The architecture in this article expands on the [virtual machine (VM) baseline architecture](baseline.yml) to address changes and expectations when you deploy it in an Azure landing zone.

In the example in this article, an organization wants a VM-based workload to use federated resources that a platform team centrally manages. These resources include networking resources for cross-premises connectivity, identity access management, and policies. This example assumes that the organization adopts Azure landing zones to enforce consistent governance and cost efficiency across multiple workloads.

As a workload owner, you can offload the management of shared resources to central teams, so you can focus on workload development efforts. This article presents the workload team's perspective. Recommendations that are for the platform team are specified.

> [!IMPORTANT]
> **What are Azure landing zones?**
> Azure landing zones present two perspectives of an organization's cloud footprint. An *application landing zone* is an Azure subscription in which a workload runs. It's connected to the organization's shared resources. Through that connection, it has access to basic infrastructure that runs the workload, such as networking, identity access management, policies, and monitoring. A *platform landing zone* is a collection of various subscriptions, each with a specific function. For example, a connectivity subscription provides centralized Domain Name System (DNS) resolution, cross-premises connectivity, and network virtual appliances (NVAs) that are available for application teams to use.
>
> We recommend that you understand the concept of [Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone) to help you prepare for the implementation of this architecture.

## Article layout

|Architecture| Design decision |Azure Well-Architected Framework approach|
|---|---|---|
|&#9642; [Architecture diagram](#architecture) <br>&#9642; [Workload resources](#workload-team-owned-resources) <br> &#9642; [Federated resources](#platform-team-owned-resources)  |&#9642; [Subscription setup](#subscription-setup)<br> &#9642; [Networking requirements](#workload-requirements-and-fulfillments) <br> &#9642; [Network design changes from the baseline](#networking)<br> &#9642; [Monitoring](#monitoring) <br> &#9642; [Patch compliance](#patch-compliance-and-os-upgrades) <br> &#9642; [Organizational governance](#azure-policy) <br> &#9642; [Change management](#manage-changes-over-time)|<br> &#9642; [Reliability](#reliability) <br> &#9642; [Security](#security) <br> &#9642; [Cost Optimization](#cost-optimization)|

> [!TIP]
> ![GitHub logo.](../_images/github.svg) This [reference implementation](https://github.com/mspnp/iaas-landing-zone-baseline) demonstrates the best practices described in this article.
>
> The repository artifacts provide a customizable foundation for your environment. The implementation sets up a hub network with shared resources like Azure Firewall for demonstration purposes. You can apply this setup to separate application landing zone subscriptions for distinct workload and platform functions.

## Architecture

:::image type="content" source="./media/baseline-landing-zone.svg" alt-text="A diagram that shows the VM baseline architecture in an application landing zone." lightbox="./media/baseline-landing-zone.svg" border="false":::
*Download a [Visio file](https://arch-center.azureedge.net/baseline-landing-zone.vsdx) of this architecture.*

### Components

All Azure landing zone architectures have a separation of ownership between the platform team and the workload team. Application architects and DevOps teams need to have a strong understanding of this responsibility split in order to understand what's under their direct influence or control and what's not.

#### Workload team-owned resources

The following resources remain mostly unchanged from the [baseline architecture](./baseline.yml#workload-resources).

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is an infrastructure as a service (IaaS) offering that provides scalable compute resources. In this architecture, VMs host the front-end and back-end tiers and are distributed across availability zones for resilience.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) is a layer-4 load balancing service for Transmission Control Protocol (TCP) and User Datagram Protocol (UDP) traffic. In this architecture, it privately load balances traffic from front-end to back-end VMs across zones.
- [Azure Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a layer-7 reverse proxy and web traffic load balancer. In this architecture, it terminates Transport Layer Security (TLS), inspects requests, and serves as the reverse proxy to route user traffic to front-end VMs. The selected SKU also hosts Azure Web Application Firewall to protect the front-end VMs from potentially malicious traffic.
- [Azure Key Vault](/azure/key-vault/general/overview) is a service for managing secrets, keys, and certificates. In this architecture, it holds the TLS certificates that Application Gateway and VMs consume.
- [Azure Monitor](/azure/azure-monitor/fundamentals/overview), [Log Analytics](/azure/well-architected/service-guides/azure-log-analytics), and [Application Insights](/azure/well-architected/service-guides/application-insights) are tools that collect, store, and visualize observability data. In this architecture they collect guest and platform metrics and logs, ingest and correlate them in a dedicated workspace, and enable application-level telemetry and visualization for troubleshooting, performance tuning, and governance.
- [Azure Policy](/azure/governance/policy/overview) is a service that enforces organizational standards and assesses compliance at scale. In this architecture, it applies workload-specific governance controls separate from platform-wide policies.

The workload team maintains and fulfills the following resources and responsibilities.

- **Spoke virtual network subnets and the network security groups (NSGs)** provide segmented IP address space and traffic filtering boundaries. In this architecture, they implement tier-based isolation and control east‑west and ingress and egress flows for workload components.

- **Private endpoints** provide private IP-based access to platform services over the Azure backbone. In this architecture, they secure connectivity to platform as a service (PaaS) solutions and the **private DNS zones** required for those endpoints.
- [Azure Managed Disks](/azure/virtual-machines/managed-disks-overview) provide durable, high-performance storage for VMs. In this architecture, they store log files on the back-end servers, and the data is retained even when VMs reboot. The front-end servers have disks attached that you can use to deploy your stateless application.

#### Platform team-owned resources

The platform team owns and maintains these centralized resources. This architecture assumes that these resources are preprovisioned and considers them dependencies.

- **Azure Firewall in the hub network** is a stateful network security service for filtering and logging traffic. In this architecture, it centrally inspects and restricts egress from the spoke via forced tunneling. This component replaces the standard load balancer in the baseline architecture, which doesn't provide restrictions on outbound traffic to the internet.

- **Azure Bastion in the hub network** is an architectural approach that provides Remote Desktop Protocol (RDP) and Secure Shell (SSH) connectivity to VMs over TLS without exposing public IP addresses. In this architecture, it supplies shared, audited operational access to workload VMs. In the baseline architecture, the workload team owns this component.
- The **spoke virtual network** is an isolated address space peered to a hub for shared services. In this architecture, it hosts the workload's compute, ingress, and related resources under workload team ownership.
- **User-defined routes (UDRs)** are custom routing rules that let you customize routing tables to direct traffic through specific next hops. In this architecture, they force all internet-bound traffic from the spoke through the hub's firewall.
- **Azure Policy-based governance constraints** and `DeployIfNotExists` (DINE) policies automatically deploy or configure required resources for compliance. In this architecture, they ensure that mandated platform-aligned configurations, such as private DNS or diagnostics, exist in the workload subscription.

> [!IMPORTANT]
> Azure landing zones provide some of the preceding resources as part of the platform landing zone subscriptions, and your workload subscription provides other resources. Many of the resources are part of the connectivity subscription, which has additional resources, such as Azure ExpressRoute, Azure VPN Gateway, and Azure DNS. These additional resources provide cross-premises access and name resolution. The management of these resources is outside the scope of this article.

## Subscription setup

In an application landing zone context, your workload team must inform the platform team of their specific requirements.

Your **workload team** must include detailed information about the networking space that your workload needs, so that the platform team can allocate necessary resources. Your team determines the requirements, and the platform team determines the IP addresses to assign within the virtual network and the management group to which the subscription is assigned.

The **platform team** assigns an appropriate management group based on the workload's business criticality and technical requirements, for example if a workload is exposed to the internet. The organization determines the configuration of these management groups, and the platform team implements them.

For example, the management groups in the application scenarios for the [baseline architecture](baseline.yml) are considered:  

- **Private applications**, such as internal line-of-business applications or commercial off-the-shelf (COTS) solutions, which are often located under the Corp management group of Azure landing zones.

- **Public applications**, as in internet-facing applications, which are often under the Corp or Online management group.

The platform team is also responsible for setting up a subscription or a group of subscriptions for the workload deployment.

The following sections provide guidance on the initial subscription setup. However, the platform team typically makes changes to the centralized services to address missed or changed requirements. Platform changes have a broader effect on all workload teams.

Therefore, the platform team must ensure that all VM workloads are prepared for any changes, and they must be aware of the life cycle of the VM-based solution and the testing cycle. For more information, see [Managing changes over time](#manage-changes-over-time).

### Workload requirements and fulfillments

The workload team and platform teams share two main responsibilities: management group assignment and networking setup. For this architecture, consider the following networking requirements that you should communicate to the platform team. Use these points as examples to understand the discussion and negotiation between the two teams when you implement a similar architecture.

- **The number of spoke virtual networks**: In this architecture, only one dedicated spoke is required. The deployed resources don't need to span across multiple networks and are colocated within a single virtual network.

- **The size of the spoke network**: Take the operational requirements and expected growth of the workload into consideration. For example, if you plan to implement blue/green or canary updates, the maximum size should account for the space that your side-by-side deployments require.

    Future changes might require more IP space, which can misalign with the current allocation. The integration of these spaces can introduce extra complexity. Be proactive and request enough network resources upfront to ensure that the allocated space can accommodate future expansion.

- **The deployment region**: It's important to specify the regions where the workload will be deployed. The platform team can use this information to ensure that the spoke-and-hub virtual networks are provisioned in the same region. Networks across different regions can lead to latency issues due to traffic crossing regional boundaries and can also incur extra bandwidth costs.

- **The workload characteristics and design choices**: Communicate your design choices, components, and characteristics to your platform team. For instance, if you expect your workload to generate a high number of concurrent connections to the internet (*chatty*), the platform team should ensure that there are sufficient ports available to prevent exhaustion. They can add IP addresses to the centralized firewall to support the traffic or set up a Network Address Translation (NAT) gateway to route the traffic through an alternate path.

    Conversely, if you expect your workload to generate minimal network traffic (*background noise*), the platform team should use resources efficiently across the organization.

    The platform team needs to clearly understand any dependencies. For example, your workload might need access to a database that another team owns, or your workload might have cross-premises traffic. Does your workload have dependencies outside of Azure? Such information is important for the platform team to know.

- **The firewall configuration**: The platform team must be aware of traffic that leaves the spoke network and is tunneled out to the hub network. The firewall in the hub can't block that traffic.

    For instance, if your workload needs to access Windows updates to stay patched, a firewall shouldn't block these updates. Similarly, if there are Monitor agents, which access specific endpoints, a firewall shouldn't block that traffic because it can disrupt monitoring data for your workload. The application might require access to third-party endpoints. Regardless, use a centralized firewall to distinguish between expected and unwarranted traffic.

- **Operator access**: If there are Microsoft Entra ID security groups that operators use to access the VMs via Azure Bastion, inform the platform team. Azure Bastion is typically a central resource. It's crucial to ensure that the security groups and the VMs support the secure protocol.

    Additionally, inform the platform team about the IP ranges that contain the VMs. This information is necessary for configuring the NSGs around Azure Bastion in the hub network.

- **The public IPs**: Inform the platform team about the ingress traffic profile, including any anticipated public IP addresses. In this architecture, only internet-sourced traffic targets the public IP on Application Gateway. The platform team should inform the workload team if these IPs are under an Azure DDoS Protection plan or if that's the responsibility of the workload team.

    In this architecture, there's another public IP for operational access via Azure Bastion. The platform team owns this public IP and it's enrolled in a service, like DDoS Protection, which the platform team also manages.

> [!IMPORTANT]
> We recommend a subscription vending workstream for the platform team that involves a series of questions designed to capture information from the workload team. These questions might vary from one organization to another, but the intent is to gather the requirements for implementing subscriptions. For more information, see [Subscription vending](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending).

## VM design choices

The VM SKU and disk selections remain the same as the [baseline architecture](baseline.yml#vm-design-choices).

An organization might impose compliance requirements on the workload team that mandates the use of specific VM images. Given such requirements, the platform team might manage a set of standardized images, often referred to as *golden images*, which are created for use across the organization.

The platform team might use a managed offering such as Azure Compute Gallery or a private repository to store approved OS images or workload artifacts. When you choose an OS image for VMs, consult your platform team about image sources, update frequency, and usage expectations. Also ensure that images can meet the necessary business requirements that the workload fulfills.

> [!IMPORTANT]
> **For the platform team**:
> If you use Compute Gallery, the workload requires network visibility to the private gallery. Collaborate with the workload team to establish secure connectivity.

## Networking

In the [baseline architecture](baseline.yml#network-layout), the workload is provisioned in a single virtual network. The workload team manages the virtual network.

In this architecture, the platform team determines the network topology. Hub-spoke topology is assumed in this architecture.

:::image type="content" source="./media/baseline-landing-zone-network-topology.svg" alt-text="Diagram that shows the network layout in a hub-spoke topology." lightbox="./media/baseline-landing-zone-network-topology.svg" border="false":::
*Download a [Visio file](https://arch-center.azureedge.net/baseline-landing-zone-network-topology.vsdx) of this architecture.*

- **Hub virtual network**: A regional hub contains centralized services that communicate with workload resources in the same region. For more information, see [Platform team-owned resources](#platform-team-owned-resources). We recommend placing the hub in the [connectivity subscription](/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity).

- **Spoke virtual network**: In this architecture, the single virtual network from the baseline architecture is the spoke network. It's peered to the hub network, which contains the centralized services. The platform team owns and manages this spoke network. This network contains the [workload resources](#workload-team-owned-resources). The workload team owns the resources in this network, including its subnets.

Make sure that you [communicate the workload requirements](#subscription-setup) to the platform team, and review them periodically.

> [!IMPORTANT]
> **For the platform team**:
>Unless specifically required by the workload, don't directly peer the spoke network to another spoke virtual network. This practice protects the segmentation goals of the workload. Your team should facilitate all transitive virtual network connections.

### Virtual network subnets

In the spoke virtual network, the workload team creates and allocates the subnets. Placing controls to restrict traffic in and out of the subnets helps to provide segmentation. This architecture uses the same subnet topology as the [baseline architecture](baseline.yml#subnetting-considerations), which has dedicated subnets for Application Gateway, front-end VMs, the load balancer, back-end VMs, and private endpoints.

When you deploy your workload in an application landing zone, you still have to implement network controls. Organizations might impose restrictions to safeguard against data exfiltration and ensure visibility for the central security operations center (SOC) and the IT network team.

With this approach, the platform team can optimize overall organizational spend by using centralized services, rather than deploying redundant security controls for each workload throughout the organization. In this architecture, Azure Firewall is an example of a central service. It's not cost-effective or practical for each workload team to manage their own firewall instance. We recommend a centralized approach to firewall management.

#### Ingress traffic

The ingress traffic flow remains the same as the [baseline architecture](baseline.yml#ingress-traffic).

The workload owner is responsible for any resources that are related to public internet ingress into your workload. For example, in this architecture, Application Gateway and its public IP are placed in the spoke network and not the hub network. Some organizations might place resources with ingress traffic in a connectivity subscription by using a centralized demilitarized (DMZ) implementation. Integration with that specific topology is out of scope for this article.

#### Egress traffic

In the baseline architecture, workload virtual machine scale sets access the public internet through Azure Load Balancer, but that traffic isn't restricted.

That design is different in this architecture. All traffic that leaves the spoke virtual network is routed through the peered hub network via an egress firewall. A route is attached to all the possible subnets in the spoke network that directs all traffic for IPs not found in the local virtual network (*0.0.0.0/0*) to the hub's Azure Firewall.

:::image type="content" source="./media/baseline-landing-zone-network-egress.svg" alt-text="Diagram that shows the network layout in a hub-spoke topology." lightbox="./media/baseline-landing-zone-network-egress.svg" border="false":::
*Download a [Visio file](https://arch-center.azureedge.net/baseline-landing-zone-network-egress.vsdx) of this architecture.*

Workload communication to the private endpoint for Key Vault access remains the same as the [baseline architecture](baseline.yml#egress-traffic). That path is omitted from the preceding diagram for brevity.

The workload team must identify, document, and communicate all necessary outbound traffic flows for the infrastructure and workload operations. The platform team allows the required traffic, and all uncommunicated egress traffic is likely denied.

Controlling egress traffic is more than just making sure that the expected traffic be allowed. It's also about making sure *only* expected traffic be allowed. Uncommunicated egress traffic is likely denied by default, but it's in the workload's best security interest to ensure that traffic is properly routed.

> [!TIP]
>
> Encourage the platform team to use IP groups in Azure Firewall. This practice ensures that your workload's egress traffic needs are accurately represented with tight scoping only to the source subnets. For instance, a rule that allows workload VMs to reach `api.example.org` doesn't necessarily imply that supporting resources within the same virtual network can access the same endpoint. This level of granular control can enhance the security posture of your network.

Communicate any unique egress traffic requirements to the platform team. For instance, if your workload establishes numerous concurrent connections to external network endpoints, inform the platform team. Then the platform team can either provision an appropriate Azure NAT Gateway implementation or add more public IPs on the regional firewall for mitigation.

Your organization might have requirements that discourage the use of architecture patterns, which use workload-owned public IPs for egress. In that case, you can use Azure Policy to deny public IPs on VM network interface cards (NICs) and any other public IPs, other than your well-known ingress points.

#### Private DNS zones

Architectures that use private endpoints need private DNS zones to work with the DNS provider. The workload team must have a clear understanding of the requirements and management of private DNS zones in the subscription that the platform team provides. Private DNS zones are typically managed at a large scale with DINE policies, which enables Azure Firewall to function as a reliable DNS proxy and support fully qualified domain name (FQDN) network rules.

In this architecture, the platform team ensures the reliable private DNS resolution for private link endpoints. Collaborate with your platform team to understand their expectations.

#### Connectivity testing

For VM-based architectures, there are several test tools that can help determine network line-of-sight, routing, and DNS issues. You can use  traditional troubleshooting tools, such as `netstat`, `nslookup`, or `tcping`. Additionally, you can examine the network adapter's Dynamic Host Configuration Protocol (DHCP) and DNS settings. If there are NICs, you have more troubleshooting capabilities that enable you to perform connectivity checks by using Azure Network Watcher.

## Operator access

Like the [baseline architecture](baseline.yml#operator), operational access through Azure Bastion is supported in this architecture.

However, the baseline architecture deploys Azure Bastion as part of the workload. For a typical organization that adopts Azure landing zones, they deploy Azure Bastion as central resources for each region. The platform team owns and maintains Azure Bastion, and all workloads in the organization share it. To demonstrate that use case in this architecture, Azure Bastion is in the hub network in the connectivity subscription.

### Operator identity

This architecture uses the same authentication extension as the [baseline architecture](baseline.yml#identity-and-access-management).

> [!NOTE]
> When operators log into a VM, they must use their corporate identities in their Microsoft Entra ID tenant and not share service principals across functions.

Always start with the principle of least-privilege and granular access to a task instead of long-standing access. Take advantage of just-in-time (JIT) support that the platform team manages.

## Patch compliance and OS upgrades

The [baseline architecture](baseline.yml#update-management) describes an autonomous approach to patching and upgrades. When the workload is integrated with landing zones, that approach might change. The platform team might dictate the patching operations so that all workloads are compliant with organizational requirements.

Make sure that the patching process includes all components that you add to the architecture. For example, if you choose to add build agent VMs to automate the deployment, scaling, and management of applications, those VMs must comply with the platform requirements.  

## Monitoring

The Azure landing zone platform provides shared observability resources as part of the management subscription. However, we recommend that you provision your own monitoring resources to facilitate ownership responsibilities of the workload. This approach is consistent with the [baseline architecture](baseline.yml#monitoring).

The workload team provisions the monitoring resources, which include:

- Application Insights as the application performance monitoring (APM) service for the workload team.

- The Log Analytics workspace as the unified sink for all logs and metrics that are collected from workload-owned Azure resources and the application code.

:::image type="content" source="./media/baseline-landing-zone-monitoring.svg" alt-text="Diagram that shows monitoring resources for the workload." lightbox="./media/baseline-landing-zone-monitoring.svg" border="false":::
*Download a [Visio file](https://arch-center.azureedge.net/baseline-landing-zone-monitoring.vsdx) of this architecture.*

Similar to the baseline, all resources are configured to send Azure Diagnostics logs to the Log Analytics workspace that the workload team provisions as part of the infrastructure as code (IaC) deployment of the resources. You might also need to send logs to a central Log Analytics workspace. In Azure landing zones, that workspace is in the management subscription.

The platform team might also have DINE policies that they can use to configure Diagnostics to send logs to their centralized management subscriptions. It's important to ensure that your implementation doesn't restrict the additional log flows.

### Correlate data from multiple sinks

The workload's logs and metrics and its infrastructure components are stored in the workload's Log Analytics workspace. However, logs and metrics that centralized services, such as Azure Firewall, Microsoft Entra ID, and Azure Bastion, generate are stored in a central Log Analytics workspace. Correlating data from multiple sinks can be a complex task.

Correlated data is often used during incident response. If there's a problem with correlating data from multiple sinks, make sure the triage runbook for this architecture addresses it and includes organizational points of contact if the problem extends beyond the workload resources. Workload administrators might require assistance from platform administrators to correlate log entries from enterprise networking, security, or other platform services.

> [!IMPORTANT]
>
> **For the platform team:** Where possible, grant Azure role-based access control (Azure RBAC) to query and read log sinks for relevant platform resources. Enable firewall logs for network and application rule evaluations and DNS proxy because the application teams can use this information during troubleshooting tasks.

## Azure Policy

The platform team likely applies policies that affect the workload deployment. They often apply DINE policies to handle automated deployments into an application landing zone subscription. DINE policies can modify workload resources or add resources to your deployment, which can result in a discrepancy between the resources that are declaratively deployed through the workload template and the resources that the processing requests actually use. A typical solution is to fix those changes with imperative approaches, which aren't ideal.

To avoid that discrepancy, preemptively incorporate and test the platform-initiated changes into your IaC templates. If the platform team uses Azure policies that conflict with the requirements of the application, you can negotiate a resolution with the platform team.

  > [!IMPORTANT]
  > Azure landing zones use various DINE policies, for example a policy that manages private endpoints at scale. This policy monitors private endpoint deployments and updates Azure DNS in the hub network, which is part of a platform-managed subscription. The workload team doesn't have permission to modify the policy in the hub, and the platform team doesn't monitor the workload teams' deployments to update DNS automatically. DINE policies are used to provide this connection.
  >
  > Other policies might affect this architecture, including policies that:
  >
  > - Require a Windows VM to join an Active Directory domain. This policy ensures that the `JoinADDomainExtension` VM extension is installed and configured. For more information, see [Enforce Windows VMs to join an Active Directory domain](https://github.com/Azure/Enterprise-Scale/blob/main/docs/reference/azpol.md#enforce-windows-vms-to-join-ad-domain).
  > - Disallow IP forwarding on network interfaces.

## Manage changes over time

Platform-provided services and operations are considered external dependencies in this architecture. The platform team continues to apply changes, onboard users, and apply cost controls. The platform team, serving the organization, might not prioritize individual workloads. Changes to those dependencies, whether they're golden image changes, firewall modifications, automated patching, or rule changes, can affect multiple workloads.

Therefore, workload and platform teams must communicate efficiently and timely to manage all external dependencies. It's important to test changes, so they don't negatively affect workloads.

### Platform changes that affect the workload

In this architecture, the platform team manages the following resources. Changes to these resources can potentially affect the workload's reliability, security, operations, and performance targets. It's important to evaluate these changes before the platform team puts them into effect to determine how they affect the workload.

- **Azure policies**: Changes to Azure policies can affect workload resources and their dependencies. For example, there might be direct policy changes or movement of the landing zone into a new management group hierarchy. These changes might go unnoticed until there's a new deployment, so it's important to thoroughly test them.

- **Firewall rules**: Modifications to firewall rules can affect the workload's virtual network or rules that apply broadly across all traffic. These modifications can result in blocked traffic and even silent process failures, like failed application of OS patches. These potential problems apply to both the egress Azure firewall and Azure Virtual Network Manager-applied NSG rules.

- **Shared resources**: Changes to the SKU or features on shared resources can affect the workload.

- **Routing in the hub network**: Changes in the transitive nature of routing in the hub can potentially affect the workload functionality if a workload depends on routing to other virtual networks.

- **Azure Bastion host**: Changes to the Azure Bastion host availability or configuration can affect workload operations. Ensure that jump box access pattern changes have effective routine, ad-hoc, and emergency access.

- **Ownership changes**: Communicate any changes in ownership and points of contact to the workload team because they can affect the management and support requests of the workload.

### Workload changes that affect the platform

The following examples are workload changes in this architecture that you should communicate to the platform team. It's important that the platform team validates the platform service's reliability, security, operations, and performance targets against the new workload team changes before they go into effect.

- **Network egress**: Monitor any significant increase in network egress to prevent the workload from becoming a noisy neighbor on network devices. This problem can potentially affect the performance or reliability targets of other workloads.

- **Public access**: Changes in the public access to workload components might require further testing. The platform team might relocate the workload to a different management group.

- **Business criticality rating**: If there are changes to the workload's service-level agreements (SLAs), you might need a new collaboration approach between the platform and workload teams.

- **Ownership changes**: Communicate changes in ownership and points of contact to the platform team.

#### Workload business requirement changes

To maintain service-level objectives (SLOs) of the workload, the platform team might need to be involved in workload architecture changes. These changes might require change management from the platform team or validation that existing governance supports the changed requirements.

For example, communicate changes to any previously disallowed egress flow so that the platform team can add that flow in the firewall, Virtual Network Manager, or other components to support the required traffic. Conversely, if a previously allowed egress flow is no longer needed, the platform team should block that flow in order to maintain the workload's security. Also communicate changes in routing to other virtual networks or cross-premises endpoints or changes to the architecture components. Each resource is subject to policies and potentially egress firewall control.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This architecture aligns with the reliability guarantees in the [baseline architecture](baseline.yml#reliability).

#### Reliability targets

The maximum possible composite SLO is [lower than the baseline composite SLO](baseline.yml#reliability-targets) due to components like egress network control. These components, common in landing zone environments, aren't unique to this architecture. The SLO is similarly reduced if the workload team directly controls these Azure services.

Despite a lower maximum possible SLO, the key reliability aspect is the division of workload components across functional teams. With this method, the workload team benefits from a specialized team that focuses on operating critical infrastructure that this workload and other workloads use.

For more information, see [Recommendations for defining reliability targets](/azure/well-architected/reliability/metrics).

##### Critical dependencies

View all functionality that the workload performs in the platform and application landing zone as dependencies. Incident response plans require that the workload team is aware of the point and method of contact information for these dependencies. Also include these dependencies in the workload's failure mode analysis (FMA).

For this architecture, consider the following dependencies:

- **Egress firewall**: The centralized egress firewall, shared by multiple workloads, undergoes changes unrelated to the workload.

- **Network port exhaustion**: Spikes in usage from all workloads sharing the network device can lead to network saturation or port exhaustion on the egress firewall.

- **DINE policies**: DINE policies for Azure DNS private DNS zones (or any other platform-provided dependency) are *best effort*, with no SLA on execution. A delay in DNS configuration can cause delays in the readiness of an application to handle traffic.

- **Management group policies**: Consistent policies among environments are key for reliability. Ensure that preproduction environments are similar to production environments to provide accurate testing and to prevent environment-specific deviations that can block a deployment or scale. For more information, see [Manage application development environments in Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-application-environments).

Many of these considerations might exist without Azure landing zones, but the workload and platform teams need to collaboratively address these problems to ensure needs are met.

For more information, see [Recommendations for performing failure mode analysis](/azure/well-architected/reliability/failure-mode-analysis#identify-dependencies).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

The security considerations for this architecture carry over from the [baseline architecture](baseline.yml#security). The recommendations in the following sections are based on the [security design review checklist in the Well-Architected Framework](/azure/well-architected/security/checklist).

#### Network controls

Properly configure network controls to ensure that your workload is secure.

##### Ingress traffic

You can isolate your workload from other workload spokes within your organization via NSGs on your subnets or the nontransitive nature or controls in the regional hub. Construct comprehensive NSGs that only permit the inbound network requirements of your application and its infrastructure. We recommend that you don't solely rely on the nontransitive nature of the hub network for security.

  The platform team likely implements Azure policies to ensure that Application Gateway has Web Application Firewall set to *deny mode*, to restrict the number of public IPs available to your subscription, and other checks. In addition to those policies, the workload team should own the responsibility of deploying workload-centric policies that reinforce the ingress security posture.

  The following table shows examples of ingress controls in this architecture.

  | Source | Purpose | Workload control | Platform control |
  | :----- | :------ | :--------------- | :--------------- |
  | Internet | User traffic flows | Funnels all requests through an NSG, Web Application Firewall, and routing rules before allowing public traffic to transition to private traffic that enters the front-end VMs | None |
  | Azure Bastion | Operator access to VMs | NSG on VM subnets that blocks all traffic to remote access ports, unless it's sourced from the platform's designated Azure Bastion subnet | None |
  | Other spokes | None | Blocked via NSG rules | Nontransitive routing or Azure Firewall rules in the case of an Azure Virtual WAN secured hub |

##### Egress traffic

Apply NSG rules that express the required outbound connectivity requirements of your solution and deny everything else. Don't rely only on the hub network controls. As a workload operator, you have the responsibility to stop undesired egress traffic as close to the source as practicable.

Be aware that while you own your subnetting within the virtual network, the platform team likely created firewall rules to specifically represent your captured requirements as part of your subscription vending process. Ensure that changes in subnets and resource placement over the lifetime of your architecture are still compatible with your original request. Or you can work with your network team to ensure continuity of least-access egress control.

The following table shows examples of egress in this architecture.

| Endpoint | Purpose | Workload (NSG) control | Platform (hub) control |
| :------- | :------ | :---------- | :---------- |
| *ntp\.ubuntu\.com* | The Network Time Protocol (NTP) for linux VMs | *UDP/123* to the internet on the front-end VM subnet (the egress firewall narrows this broad opening) | Firewall network rule allowance for the same as the workload control |
| Windows Update endpoints | Windows Update functionality from Microsoft servers | *TCP/443* and *TCP/80* to the internet on the back-end VM subnet (the egress firewall narrows this broad opening) | Firewall allowance rule with FQDN tag of `WindowsUpdate` |
| Monitor agent endpoints | Required traffic for the Monitor extension on VMs | *TCP/443* to the internet on both VM subnets (the egress firewall narrows this broad opening) | Necessary firewall application rule allowances for all specific FQDNs on *TCP/443* |
| *nginx\.org* | To install Nginx (an example application component) directly from the vendor | *TCP/443* to the internet on the front-end VM subnet (the egress firewall narrows this broad opening) | Necessary firewall application rule allowance for *nginx\.org* on *TCP/443* |
| Key Vault | To import TLS certificates in Application Gateway and VMs | - *TCP/443* to a private endpoint subnet from both VM subnets to a private endpoint subnet<br>- *TCP/443* to a private endpoint subnet from an Application Gateway subnet<br>- *TCP/443* from VMs tagged with a required application security group (ASG) designation and Application Gateway subnet | None |

##### DDoS Protection

Determine who's responsible for applying the DDoS Protection plan that covers all of your solution's public IPs. The platform team might use IP protection plans or might even use Azure Policy to enforce virtual network protection plans. This architecture should have coverage because it involves a public IP for ingress from the internet.

For more information, see [Recommendations for networking and connectivity](/azure/well-architected/security/networking).

#### Secret management

For secret management, this architecture follows the [baseline architecture](baseline.yml#secret-management).

As a workload team, continue keeping your secrets in your Key Vault instance. Deploy more instances as needed to support your application and infrastructure operations.

For more information, see [Recommendations for protecting application secrets](/azure/well-architected/security/application-secrets).

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

For the workload resources, the cost optimization strategies in the [baseline architecture](baseline.yml#cost-optimization) also apply to this architecture.

This architecture greatly benefits from Azure landing zone platform resources. Even if you use those resources via a chargeback model, the added security and cross-premises connectivity are more cost-effective than self-managing those resources.

The platform team manages the following resources in this architecture. These resources are often consumption-based (chargeback) or potentially free to the workload team.

- Azure Firewall
- Security information and event management (SIEM)
- Azure Bastion hosts
- Cross-premises connectivity, such as ExpressRoute

Take advantage of other centralized offerings from your platform team to extend those benefits to your workload without compromising its SLO, recovery time objective (RTO), or recovery point objective (RPO).

For more information, see [Recommendations for collecting and reviewing cost data](/azure/well-architected/cost-optimization/collect-review-cost-data).

## Deploy this scenario

A deployment for this reference architecture is available on GitHub.

> [!div class="nextstepaction"]
> [Implementation: VM baseline architecture in an Azure landing zone](https://github.com/mspnp/iaas-landing-zone-baseline#deploy-the-reference-implementation)

## Next step

Review the collaboration and technical details shared between a workload team and platform teams.

[Subscription vending](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending)

This reference architecture extends the [**Virtual machine baseline architecture**](./baseline.yml) to address common changes and expectations when deployed into in Azure landing zones.

In this use case, the organization expects the **VM-based workload to utilize federated resources that are centrally managed by the platform team**. These resources include networking for cross-premises connectivity, identity access management, and policies. It's assumed that the organization has adopted Azure landing zones to enforce consistent governance and cost-efficiency across multiple workloads. As a workload owner, you benefit by offloading management of shared resources to central teams and focus on workload development efforts. This article presents the workload team's perspective. Callouts to the platform team are annotated.

> [!IMPORTANT]
> **What is Azure landing zones?**
> Azure landing zones present two perspectives on an organization's cloud footprint. An application landing zone is a Azure subscription in which the workload runs. It's connected to the organization's shared resources. Through that connection, it has access to basic infrastructure needed to run the workload, such as networking, identity access management, policies, and monitoring. The platform landing zones is a collection of various subscriptions, each with a specific function. For example, the Connectivity subscription provides centralized DNS resolution, on-premises connectivity, and network virtual appliances (NVAs) that's available for use by application teams. 
>
> We highly recommend that you understand the concept of [**Azure landing zones**](/azure/cloud-adoption-framework/ready/landing-zone/). 

This architecture can be used for these scenarios:

- **Private applications**. These include internal line-of-business applications or commercial off-the-shelf (COTS) solutions, which are often located under the Corp management group of Azure landing zones.
- **Public applications**. These are internet-facing applications that can be found under either the Corp or Online management group. This architecture isn't for high-performance computing (HPC), mission-critical workloads, latency-sensitive applications, or other highly specialized use cases. Instead, it serves as a foundational guide for a workload-agnostic perspective in Azure landing zones.

## Article layout

To meet the organizational requirements, there are changes in the **baseline architecture** and responsibilities of the workload team.

|Architecture| Design decisions |Well-Architected Framework approaches|
|---|---|---|
|&#9642; [Architecture diagram](#architecture) <br>&#9642; [Workload resources](#workload-team-owned-resources) <br> &#9642; [Federated resources](#platform-team-owned-resources)  |&#9642; [Subscription setup](#subscription-setup-by-the-platform-team)<br> &#9642; [Networking requirements](#workload-requirements-and-fulfillment) <br> &#9642; [Network design changes from the baseline](#networking)<br> &#9642; [Patch compliance](#patch-compliance-and-os-upgrades) <br> &#9642; [Organizational governance](#azure-policy) <br> &#9642; [Changes management](#manage-changes-over-time)|<br> &#9642; [Reliability](#reliability) <br> &#9642; [Security](#security) <br> &#9642; [Cost Optimization](#cost-optimization)|


> [!TIP]
> ![GitHub logo](../_images/github.svg) Best practices described in this architecture are demonstrated by a [**reference implementation**](https://github.com/mspnp/xxx/). 
>
> The repository artifacts offer a customizable foundation for your environment. It sets up a hub network with shared resources like Azure Firewall for demonstration purposes. This setup can be mapped to separate application landing zone subscriptions for distinct workload and platform functions.


## Architecture

:::image type="content" source="./media/baseline-landing-zone.png" alt-text="A architectural diagram showing the IaaS baseline in an application landing zone." lightbox="./media/baseline-landing-zone.png":::

### Components


All Azure landing zone architectures have dual-ownership between the platform team and the workload team. Application architects and DevOps teams need to have a strong understanding of this responsibility split in order to understand what's under their direct control, under their influence, and what is out of their influence or control.


#### Workload team-owned resources

Your team provisions and owns these resources and remain unchanged from the [**baseline architecture**](./baseline-content.md#workload-resources). 

- **Azure virtual machines (VMs)** serves as application platform and the  compute resources are distributed across availability zones.
- **Azure Load Balancer** routes traffic from the frontend tier to the backend servers. The load balancer distributes traffic to VMs across zones.
- **Azure Application Gateway Standard_v2** acts as the reverse proxy routing  requests to the frontend servers. 
- **Azure Key Vault** stores application secrets and certificates.
- **Azure Monitor, Azure Log Analytics and Application Insights** collect and store observability data. 
- **Azure Policy** applies policies specific to the workload.

These resources and responsibilities continue to be maintained and fulfilled by the workload team. 

- **Spoke virtual network subnetting and Network Security Groups (NSGs)** placed on those networks to maintain segmentation and control traffic flow. 
- **Private endpoints** to secure connectivity to PaaS services and the **private DNS zones** required for those endpoints. 
- **Disks and storage** resources that temporarily log files. Beyond that, this architecture continues to be stateless. 
- **Build agent VMs** are autonomously owned by the workload team to ensure reliability of the deployment infrastructure.

#### Platform team-owned resources

The platform team owns and maintains these centralized resources. This architecture  assumes these resources are pre-provisioned and considers them as dependencies. 

- **Azure Firewall in the hub network** inspects and restricts egress traffic. This component is an addition to the baseline architecture, which didn't provide restrictions on outbound traffic to the internet. 
- **Azure Bastion in the hub network** provides secure operational access to workload VMs. In the baseline architecture, this was owned by the workload team. 
- **Spoke virtual network** in which the workload is deployed. 
- **User-defined routes** (UDRs) for forced tunneling to the hub network.
- **Azure Policy** based governance constraints and DeployIfNotExists (DINE)  policies as part of the workload subscription.

> [!IMPORTANT]
> Azure landing zones provides the preceding resources as part of the platform landing zone subscriptions. The networking resources are part of the Connectivity subscription, which has additional resources such as Azure ExpressRoute, VPN gateway, Azure DNS for cross-premises access and name resolution. The management of these resources are outside the scope of this architecture. 

## Subscription setup by the platform team

In a landing zone context, **workload teams must provide their specific requirements to the platform team**. 

- **Workload team**

    Include detailed information about the networking space so that the platform team can allocate necessary resources. While you provide the requirements, the platform team is responsible for deciding the specific IP addresses to assign within the virtual network and the management group to which the subscription will be assigned.


- **Platform team**

    The platform team assigns an appropriate management group based on the workload's business criticality and technical requirements, such as whether it will be exposed to the internet. The configuration of these management groups is determined by the organization and implemented by the platform team. The team also is responsible for setting up a subscription or a group of subscriptions for workload deployment.

    This section provides guidance on the initial subscription setup. However, the platform team is expected to make changes to the centralized services to address missed or changed requirements. Platform changes have a broader impact on all workload teams. 

    Therefore, the platform team must ensure all VM workloads are ready for any changes and be aware of the life cycle of the VM-based solution and the testing cycle. For more information, see [Managing changes over time](#manage-changes-over-time).


##### Workload requirements and fulfillment

The primary shared responsibility between the two teams is in the areas of management group assignment and networking setup. Here are some networking requirements for this architecture that you should communicate to the platform team. Use these points as examples to understand the discussion and negotiation between the two teams for a similar architecture.

> [!IMPORTANT] 
> Azure landing zones recommend a subscription vending workstream for the platform team that involves a series of questions designed to capture information from the workload team. These questions may vary from one organization to another, but the intent is to gather the requirements for implementing subsription(s). For more information, see [**Cloud Adoption Framework: Subscription vending**](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending).

- **Number of spoke virtual networks**. In this architecture only one dedicated spoke is required. The deployed resources don't need to span across multiple networks and are colocated within a single virtual network. 

- **Size of the spoke network (s)**. The operational requirements and expected growth of the workload must be taken into consideration. For example, if you're planning to implement Blue/Green or Canary updates, the maximum size should account for the space required for side-by-side deployments.

    Future changes may require additional IP space, which may not be contiguous with the current allocation. The integration of these spaces could introduce extra complexity. Be proactive and request enough network resources upfront to ensure that the allocated space can accommodate future expansion.

- **Deployment region**. It's important to specify the region(s) where the workload will be deployed. This information allows the platform team to ensure that the spoke and hub virtual networks are provisioned in the same region. Networks across different regions can lead to latency issues due to traffic crossing regional boundaries and can also incur additional bandwidth costs.

- **Workload characteristics and design choices**. Communicate your design choices, components, and characteristics to your platform team. For instance, if your workload is expected to generate a high volume of network traffic ("chatty"), the platform team should ensure that there are sufficient ports available to prevent exhaustion, add extra IP address to the centralized firewall to support that traffic, set up a NAT gateway to route the traffic through an alternate path, and so on. 

    Conversely, if your workload is expected to generate only minimal network traffic ("background noise"), this should also be communicated so that the platform team uses resources efficiently across the organization.

    Any dependencies should be clearly understood. For example, if the workload needs access to a database owned by another team, is on-premises traffic expected? Does the workload have dependencies outside Azure? Such information is important for the platform team to know.

- **Firewall configuration**. The platform team must know of traffic that's expected to leave the spoke network and tunneled out to the hub network. This ensures that the firewall in the hub doesn't block that traffic.

    For instance, if your workload needs to access Windows updates to stay patched, firewall shouldn't block these updates. Similarly, if the installed Azure Monitor agents, which access specific endpoints, firewall shouldn't block that traffic because this could disrupt monitoring data for your workload. The application could require access to third-party endpoints. Regardless, centralized firewall should be able to make the distinction between expected and unwarranted traffic.

- **Operator access**. If there are Microsoft Entra ID security groups that operators use to access the VMs via Bastion, inform the platform team. Bastion is typically a central resource, it's crucial to ensure that the secure protocol is supported by both the security groups and the VMs.

    Additionally, the platform team should be informed about the IP ranges that contain the VMs. This information is necessary for configuring the Network Security Groups (NSGs) around Azure Bastion in the hub network.

- **Public IPs**. The platform team should be informed about the ingress traffic profile, including any anticipated public IP addresses. In this architecture, only internet-sourced traffic is expected that targets public IP on Application Gateway. 

    There's another public IP for operational access via Bastion. This public IP would be enrolled in a service like DDoS protection, which is managed by by the platform team.


## Networking

In the [**baseline architecture**](./baseline-content.md#network-layout), the workload was provisioned in a single virtual network, the management of which was the responsibility of the workload team.

In this architecture, the network topology is decided by the platform team. Hub-spoke topology is assumed in this architecture. 

- **Hub virtual network**. This network contains a regional hub designed to provide centralized services that communicate with workload resources in the same region. For information, see [these networking resources](#platform-team-owned-resources). Azure landing zones recommend placing the hub in the [Connectivity subscription](/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity). 

- **Spoke virtual network**. The single virtual network from the baseline architecture is now transformed into the spoke network. It's peered to the hub network, which provides the centralized services. The ownership and management of this spoke network now fall under the purview of the platform team. This network contains the [workload resources](#workload-team-owned-resources). The workload team owns the resources in this network. 

Make sure you [communicate the workload requirements](#subscription-setup-by-the-platform-team) to the platform team and review them periodically.

> [!IMPORTANT] 
> **Platform team**
>
> The workload network must not be directly peered to another spoke virtual network. All transitive virtual network connections should be facilitated by your platform team.
>
> Ensure virtual networks involved in peerings have unique addresses. Overlapping addresses, such as those of on-premises and workload networks, can cause disruptions and outages.
>
> Allocate IP address spaces that are sufficiently large to accommodate runtime and deployment resources, manage failovers, and facilitate scalability.

#### Virtual network subnets

In the spoke virtual network, the workload team has the responsibility of subnet allocation. The intent is segmentation and placing controls to restrict traffic in and out of the subnets. This architecture recommends the creation of dedicated subnets for Application Gateway, Key Vault, frontend VMs, load balancer, backend VMs, and private endpoints.

Subnets for those components remain the same as the [**baseline architecture**](baseline-content.md#subnetting-considerations). 

Deploying your workload in an Azure landing zone doesn't take away the responsibility of implementing network controls. There might be other restrictions imposed by the organization to safeguard against data exfiltration, ensure visibility for central Security Operations Center (SOC) and IT network team.

This approach allows the platform team to optimize costs through centralized services, rather than deploying redundant security controls per workload throughout the organization. In this architecture, Azure Firewall is an example of a central service. It would be neither cost-effective nor practical for each workload team to manage their own firewall instance. Instead, a centralized approach to firewall management is recommended.

##### Ingress traffic

Ingress traffic flow remains the same as the [**baseline architecture**](./baseline-content.md#ingress-traffic). 

The workload owner is responsible for any resources related to public internet ingress into your workload. In this architecture, this is demonstrated by placing Application Gateway and its public IP in the spoke network, and not as part of the hub network. In some organizations, ingress might be expected in a connectivity subscription using a centralized DMZ implementation. Integration with that specific topology is out of scope for this article.

##### Egress traffic

In the baseline architecture, egress traffic to the internet wasn't restricted. 

That design has changed in this architecture. All traffic leaving the spoke virtual network is expected to be routed through the peered hub network, via an egress firewall. This is achieved with a route attached to the spoke network that directs all traffic (0.0.0.0/0) to the hub's Azure Firewall.

The workload team must identify, document, and communicate all necessary outbound traffic flows for your infrastructure and workload operations. The platform team allows the  required traffic, while all uncommunicated egress traffic will likely be denied.

> [!TIP]
>
> Encourage the platform team to use IP groups in Azure Firewall. This will ensure that your workload's specific egress needs are accurately represented with tight scoping to just the source subnets. For instance, a rule that allows workload virtual machines to reach api.example.org doesn't necessarily imply that supporting virtual machines, such as build agents within the same virtual network, should be able to access the same endpoint. This level of granular control can enhance the security posture of your network.

Communicate any unique egress requirements to the platform team. For instance, if your workload establishes numerous concurrent connections to external network endpoints, inform the platform team. This will allow them to either provision an appropriate NAT Gateway implementation or add additional public IPs on the regional firewall for mitigation.

Avoid architecture patterns that rely on workload-owned public IPs for egress. To enforce this, consider using Azure Policy to deny public IPs on virtual machine Network Interface Cards (NICs) and any other public IP other than your well-known ingress points.

##### Private DNS zones

Architectures that use private endpoints, need private DNS zones. The workload team must have a clear understanding of those requirements and management of private DNS zones in the subscription given by the platform team. Private DNS zones are typically managed at a large scale using DINE policies, enabling Azure Firewall to function as a reliable DNS proxy and support Fully Qualified Domain Name (FQDN) network rules. 


This architecture delegates the responsibility of ensuring reliable private DNS resolution for private link endpoints to the platform team. Collaborate with your platform team to understand their expectations.


##### Connectivity testing

For VM-based architecture, there are several test tools that can help determining network line of sight, routing, and DNS issues. You can use  traditional troubleshooting using tools such as `netstat`, `nslookup`, or `tcping`. Additionally, you can examine the network adapter's DHCP and DNS settings. The presence of NICs further enhances your troubleshooting capabilities, enabling you to perform connectivity checks using Azure Network Watcher.

## Operator access

Operational access through Azure Bastion is still supported in this architecture much like the [**baseline architecture**](./baseline-content.md#operations-user). 

However, the baseline architecture deploys Azure Bastion as part of the workload. In a typical Azure landing zone architecture, Azure Bastion is a central resource, owned and maintained by the platform team, which is shared by all workloads in the organization. To demonstrate that use case, in this architecture, Azure Bastion has moved to the hub network in the Connectivity subscription.

##### Operator identity

This architecture uses the same authentication extension as 
the [**baseline architecture**](./baseline-content.md#identity-and-access-management).

Just as a reminder, when logging into a virtual machine, operators must use their corporate identities in their Microsoft Entra ID tenant and not share service principals across functions. 

Always start with principle of least-privilege and granular access to the task being performed instead of long standing access. In the landing zone context, take advantage of Just-In-Time (JIT) support managed by the platform team.

##### Build agents

The build agents remain the same as the [**baseline architecture**](baseline-content.md#build-agents). This means the workload team is still responsible for these VMs. 

Make sure that the patching process for your build agents complies with platform requirements. OS access to these machines should be provided by the centralized Azure Bastion resource.


## Patch compliance and OS upgrades

The [**baseline architecture**](./baseline-content.md#infrastructure-update-management) describes an autonomous approach to patching and upgrades. When the workload is integrated with landing zones, that approach might change.

An organization might impose compliance requirements on the workload team that mandates the use of specific images. Given such requirements, the platform team might manage a set of standardized VM images, often referred to as _golden images_, which are created for use across the organization. 

The platform team might use a managed offering such as Azure Compute Gallery or a private repository to store approved OS images or workload artifacts. When choosing an OS image for VMs, consult your platform team about image sources, update frequency, and usage expectations. Also make sure the images are able to meet the necessary business requirements fulfilled by the workload.

> [!IMPORTANT] 
> **Platform team**
>
> If Azure Compute Gallery is used, the workload requires network visibility to the gallery and Azure Firewall rules to allow access.

## Monitoring considerations

The Azure landing zone platform provides shared observability resources as part of the Management subscription. However, it's recommended to provision your own monitoring resources to facilitate ownership responsibilities of the workload. This approach is consistent with the [**baseline architecture**](./baseline-content.md#monitoring).

The workload team provisions the monitoring resources, which include:

- Azure Application Insights as the Application Performance Monitoring (APM) of the workload team.
- Azure Log Analytics workspace serves as the unified sink for all logs and metrics collected from Azure services and the application.

A custom storage account can be used for greater control over access permissions and log retention.

Similar to the baseline, all resources are configured to send Azure Diagnostics to the Log Analytics workspace provisioned by the workload team as part of the Infrastructure as Code (IaC) deployment of the resources. The platform team might also have Deploy If Not Exists (DINE) policies to configure Azure Diagnostics to send logs to their centralized Management subscriptions. It's important to ensure that your IaC solution or workload-level Azure Policy implementation doesn't restrict those log flows.

##### Correlating data from multiple sinks

Logs and metrics generated by the workload and its infrastructure components are stored in the workload's Log Analytics workspace. However, logs and metrics produced by centralized services, such as Azure Firewall, Microsoft Entra ID, Bastion, are stored in a central Log Analytics workspace in the Management subscription. There might be complexity when correlating data from multiple sinks. 

Correlated data is often used during incident response. Make sure the triage runbook for this architecture addresses this issue and includes organizational points of contact if the problem extends beyond the workload resources. Workload administrators may require assistance from platform administrators in correlating log entries from enterprise networking, security, or other platform services. 

> [!IMPORTANT]
>
> **Platform team**
>
> - Where possible, grant role-based access control (RBAC) to query and read log sinks for relevant platform resources.
> - Enable logs for AzureFirewallApplicationRule, AzureFirewallNetworkRule, AzureFirewallDnsProxy because the application team needs to monitor traffic flows from the application and requests to the DNS server.


## Azure policy

The platform team will likely apply policies that impact the workload deployment. Deploy If Not Exists (DINE) policies are part of an automated deployment configured into a subscription by the platform team. DINE policies can either modify workload resources that are deployed or add things to your deployment, which can result in a discrepancy between the workload template and show predictable results.

To avoid this, it's ideal to incorporate these changes into your IaC templates in advance or communicate with your platform team to be excluded from this policy.
    
  > [!IMPORTANT] 
  > Azure Landing Zone uses various DINE policies. For example, policies that manage private endpoints at scale. This policy monitors private endpoint deployments and updates Azure DNS in the hub network, which is part of a platform-managed subscription. The workload team doesn't have permission to modify it in the hub, and the platform team doesn't monitor the workload teams' deployments to update DNS automatically. DINE policies are used to provide this connection. 
  > Here are some other policies that might impact this architecture:
  > - Enforce that Windows VM join an Active Directory Domain. This ensures the `JsonADDomainExtension` virtual machine extension is installed and configured. See [Enforce Windows Virtual Machines to join AD Domain](https://github.com/Azure/Enterprise-Scale/blob/main/docs/reference/azpol.md#enforce-windows-vms-to-join-ad-domain).
  > - Disallow IP forwarding on network interfaces.

## Manage changes over time

Platform-provided service and operations are considered external dependencies in this architecture. The platform team continues to evolve, onboard users, and apply cost controls. The platform team, serving the organization, may not prioritize individual workloads. Changes to those dependencies, whether they're golden image changes, firewall modifications, automated patching, or rule changes, can affect multiple workloads. 

Therefore, all external dependencies must be managed with  **bi-directional and timely communication between the workload and platform teams**. Testing those changes is crucial or they might impact  workloads negatively. 

##### Platform changes that impact the workload

Here are some examples from this architecture that managed by the platform team but can have impact on the workload's reliability, security, operations, and performance targets. These changes must be validated against the new platform team change before it goes into effect.

- **Azure policies**. Changes to Azure policies that impact workload resources and their dependencies. This can come from direct policy changes or movement of the subscription into a new management group hierarchy. These may go unnoticed until a new deployment, so thorough testing is needed.

- **Firewall rules**. Modifications to firewall rules affecting the workload's virtual network or rules that apply broadly across all traffic. These could result in blocked traffic and even silent process failures like failed application of OS patches. This applies to both the egress Azure Firewall and Azure Network Manager applied NSG rules.

- **Shared resources**. Changes to SKU or features on shared resources can impact the workload.

- **Routing in the hub network**. Changes in the transitive nature of routing in the hub, potentially affecting workload functionality if a workload depended on routing to other virtual networks.

- **Bastion host**. Changes in Bastion host availability or configuration can impact operations of the workload. Communicate jump box access pattern changes to have effective routine, ad-hoc, and emergency access.

- **Ownership changes**: Any changes in ownership and points of contact should be communicated to the workload team because it can impact the management and operation of the workload.
 
##### Workload changes that impact the platform
 
Here are some examples of workload changes in this architecture that should be communicated to the platform team so that reliability, security, operations, and performance targets for the platform services can be validated against the new workload team change before it goes into effect.
 
- **Network egress**. A significant increase in network egress should be monitored to prevent the workload from becoming a noisy neighbor on network devices, which could potentially impact the performance or reliability targets of other workloads.

- **Public access**. Changes in the public access to workload components may require additional testing. The platform team might relocate the workload to a different management group.

- **Business criticality rating**. If there are changes to the workload's service level agreements, new collaboration approach between the platform and workload teams might be needed.

- **Ownership changes**. Changes in ownership and points of contact  should be communicated to the platform team.
 
##### Workload business requirement changes that impact the platform

To maintain Service Level Objectives (SLOs) of the workload, the platform team needs to be aware of workload architecture changes. These changes may require change management from the platform team or validation that existing governance supports the changed requirements. 

For example, communicate changes to any previously disallowed egress flow so that the platform team can add that flow in the firewall, Azure Network Manager, or other components to support the required traffic. Conversely, if a previously allowed egress flow is no longer needed, platform team should block that flow in order to maintain the workload's security.  Changes in routing to other virtual networks or cross-premises endpoints should be communicated. If there are changes to the architecture components, those changes must also be communicated. Each resource is subject to policies and potentially egress firewall control.

## Reliability

This architecture aligns with the Reliability guarantees provided in the [**baseline architecture**](./baseline-content.md#reliability). 

##### Reliability targets

The maximum possible composite Service Level Objective (SLO) is [lower than the baseline composite SLO](./baseline-content.md#reliability-targets) due to other components like egress network control. These components, common in landing zone environments, aren't unique to this architecture. The SLO would be similarly reduced if these Azure services were directly controlled by the workload team.

Despite a lower maximum possible SLO, the key reliability aspect is the division of workload components across functional teams. This allows the workload team to benefit from a specialized team focused on operating critical infrastructure used by this and other workloads. 

> Refer to Well-Architected Framework: [RE:04 - Recommendations for defining reliability targets](/azure/well-architected/reliability/metrics).

##### Critical dependencies

All functionality used by the workload in the platform and application landing zone should be viewed as dependencies. Incident response plans require that the workload team is aware of the point and method of contact information for these dependencies. These dependencies also need to be included in the workload's failure mode analysis (FMA).

Here are some dependencies to consider for this architecture:

- **Egress firewall**. The centralized egress firewall, shared by multiple workloads, will undergo changes unrelated to the workload.

- **Network port exhaustion**. Spikes in usage from all workloads sharing the network device could lead to network saturation or port exhaustion on the egress firewall.

- **DINE policies**: DINE policies for Azure DNS Private DNS zones (or any other platform-provided dependency) are best effort, with no Service Level Agreement (SLA) on execution.

- **Management group policies**: Consistent policies between environments are key for reliability. Preproduction environments should be similar to production environments for meaningful testing and to prevent environment-specific deviations that could block deployment or scale. 

> Refer to Well-Architected Framework: [RE:03 - Recommendations for performing failure mode analysis](/azure/well-architected/reliability/failure-mode-analysis#identify-dependencies).

While many of these considerations could exist without Azure landing zones, in their context, these issues need to be collaboratively addressed by the workload and platform teams to ensure needs are met.

## Security

The security considerations carry over from the [**baseline architecture**](./baseline-content.md#security).The recommendations are based on the [Security design review checklist given in Azure Well-Architected Framework](/azure/well-architected/security/checklist). 

##### Network controls

- **Ingress traffic**. Isolation from other workload spokes within the organization is achieved by using Network Security Groups (NSGs) on your subnets, and potentially also through the nontransitive nature or controls in the regional hub. Construct comprehensive NSGs that only permit the inbound network requirements of your application and its infrastructure. Relying on the nontransitive nature of the hub network for security isn't recommended.

    The platform team will likely implement specific Azure Policies to ensure that  Application Gateway has the Web Application Firewall (WAF) enabled in deny mode, restrict the number of public IPs available to your subscription, and other checks. In addition to those policies, the workload team should own the responsibility of deploying workload-centric policies that reinforce the ingress security posture.

    Examples of ingress controls in this architecture:

    | Source | Purpose | Workload control | Platform control |
    | :----- | :------ | :--------------- | :--------------- |
    | Internet | _TODO_ | _TODO_ | _TODO_ |
    | Azure Bastion | _TODO_ | _TODO_ | _TODO_ |
    | Other spokes | None | Blocked via NSG rules. | Nontransitive routing or Azure Firewall rules in the case of Azure VWAN secured hub. |

- **Egress traffic**. Apply NSG rules that express the required outbound connectivity requirements of your solution, and deny everything else. Don't only rely on the hub network controls. As a workload owner, have the responsibility to stop undesired egress traffic as close to the source as practicable.

Be aware that while you own your subnetting within the virtual network, the platform team likely created firewall rules to specifically represent your captured requirements as part of your subscription vending process. Ensure that changes in subnets and resource placement over the lifetime of your architecture are still compatible with your original request, or work with your network team to ensure continuity of least-access egress control.

Examples of egress in this architecture:

| Endpoint | Purpose | NSG control | Hub control |
| :------- | :------ | :---------- | :---------- |
| _TODO_ | _TODO_ | _TODO_ | _TODO_ |
| _TODO_ | _TODO_ | _TODO_ | _TODO_ |
| _TODO_ | _TODO_ | _TODO_ | _TODO_ |

- **DDoS protection**. Ensure you've understood who will be responsible for applying the DDoS Protection plan that covers all of your solution's public IPs. The platform team might use IP protection plans, or might even use Azure Policy to enforce virtual network protection plans. This specific architecture should have coverage as it involves a public IP for ingress from the Internet. 

> Refer to Well-Architected Framework: [SE:06 - Recommendations for networking and connectivity](/azure/well-architected/security/networking).


##### Secret management

This architecture follows the new decisions from [**baseline architecture**](./baseline-content.md#secret-management).

This architecture doesn't introduce any specific dependencies outside of the workload on Key Vault. However, it's common for publicly exposed HTTPS endpoints to be surfaced with TLS using the organization's domain. This involves working with your IT team to understand how those TLS certs are procured, where they're stored, and how they're rotated. This architecture doesn't make any specific affordances for this process.

As a workload team, continue to keep your workload secrets a function of your landing zone. Deploy your own Azure Key Vault instance(s) as needed to support your application and infrastructure operations.

> Refer to Well-Architected Framework: [SE:09 - Recommendations for protecting application secrets](/azure/well-architected/security/application-secrets).

## Cost Optimization

The cost optimization strategies in the [**baseline architecture**](./baseline-content.md#cost-optimization) still apply to this architecture for the workload resources.

This architecture greatly benefits from Azure landing zone platform resources. Even if those resources are used through a chargeback model, the added security and cross-premises connectivity are significantly more cost-effective than self-managing these resources. 

Examples of resources in this architecture managed by the platform team, which might be consumption-based (charge-back) or potentially free to the workload team, include:

- Azure Firewall
- Security Information and Event Management (SIEM)
- Azure Bastion Hosts
- Cross-premises connectivity such as ExpressRoute

Take advantage of other centralized offerings from your platform team that can extend these benefits to your workload without compromising its Service Level Objective (SLO), Recovery Time Objective (RTO), or Recovery Point Objective (RPO).

> Refer to Well-Architected Framework: [CO:03 - Recommendations for collecting and reviewing cost data](/azure/well-architected/cost-optimization/collect-review-cost-data).

## Deploy this scenario

A deployment for this reference architecture is available on GitHub.

> [!div class="nextstepaction"]
> [Implementation: Virtual machine baseline architecture in an Azure landing zone](https://github.com/mspnp/iaas-landing-zone-baseline#deploy-the-reference-implementation)

## Next step

Review the collaboration and technical details shared between a workload team and platform teams.

[**Cloud Adoption Framework: Subscription vending**](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending)
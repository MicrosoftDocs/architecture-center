This reference architecture extends the [**Virtual machine baseline architecture**](./vm-baseline.yml) to address common architectural changes and expectations when deployed into in Azure landing zones.

In this use case, the organization expects the VM-based workload to utilize federated resources that are centrally managed by the platform team. These resources include networking for cross-premises connectivity, identity access management, and policies. It's assumed that the organization has adopted Azure landing zones to enforce consistent governance and cost-efficiency across multiple workloads. 

This architecture can be used for these scenarios:

- Private applications. These include internal line-of-business applications or commercial off-the-shelf (COTS) solutions, which are often located under the Corp management group of Azure landing zones.
- Public applications. These are internet-facing applications that can be found under either the Corp or Online management group. This architecture isn't for high-performance computing (HPC), mission-critical workloads, latency-sensitive applications, or highly specialized use cases. Instead, it serves as a foundational guide for a workload-agnostic perspective in Azure landing zones.

## Article layout

To meet the organizational requirements, there are chanes in the **baseline architecture** and responsibilities of the workload team.

|Architecture| Shared responsibility |Workload concerns|
|---|---|---|
|&#9642; [Architecture diagram](#architecture) <br>&#9642; [Workload resources](#workload-team-owned-resources) <br> &#9642; [Federated resources](#platform-team-owned-resources)  |&#9642; [Subscription setup](#subscription-set-up-by-the-platform-team)<br> &#9642; [Requirements by the workload team](#workload-team) <br> &#9642; [Fulfillment by the platform team](#platform-team)| &#9642; [Operations](#os-patching) <br> &#9642; [Reliability](#reliability) <br> &#9642; [Security](#security) <br> &#9642; [Cost Optimization](#cost-optimization)|

> [!TIP]
> ![GitHub logo](../_images/github.svg) The best practices described in this architecture are demonstrated by a [**reference implementation**](https://github.com/mspnp/vm-baseline-lz). 
> The implementation includes an application that's a small test harness that will exercise the infrastructure set up end-to-end. 


## Architecture

:::image type="content" source="./media/vm-baseline-landing-zone.png" alt-text="A architectural diagram showing the IaaS baseline in an application landing zone." lightbox="./media/vm-baseline-landing-zone.png":::

### Components

All Azure landing zone architectures have dual-ownership between the platform team and the workload team. Application architect and DevOps teams need to have a strong understanding of this responsibility split in order to understand what's under their direct control, under their influence, and what is out of their influence or control.

#### Workload team-owned resources

Your team provisions and owns these resources and remain unchanged from the [**baseline architecture**](vm-baseline.md#workload-resources). 

- **Azure virtual machines (VMs)** serves as application platform and the  compute resources are distributed across availability zones.
- **Azure Load Balancer** routes traffic from the frontend tier to the backend servers. The load balancer distributes traffic to VMs across zones.
- **Azure Application Gateway Standard_v2** acts as the reverse proxy routing  requests to the frontend servers. 
- **Azure Key Vault** stores application secrets and certificates.
- **Azure Monitor** Azure Log Analytics and Application Insights collect and store observability data. 
- **Azure Policy** as it applies to the specific workload.

These resources and responsibilities continue to be maintained and fullfiled by the workload team. 

- **Spoke virtual network subnetting and Network Security Groups (NSGs)** placed on those networks to maintain segmentation and control traffic flow. 
- **Private endpoints** to secure connectivity to PaaS services and the **private DNS zones** required for those endpoints. 
- **Disks and storage** resources that temporarily log files. Beyond that, this architecture continues to be stateless. 
- **Build agent VMs** are autonomously owned by the workload team to ensure reliability of the deployment infrastructure.

#### Platform team-owned resources

The platform team owns and maintains these centralized resources. This architecture  assumes these resources are preprovisioned and considers them as dependencies. 

- **Azure Firewall in the hub network** inspects and restricts egress traffic. This component is an addition to the baseline architecture, which didn't provide restrictions on outbound traffic to the internet. 
- **Azure Bastion in the hub network** provides secure operational access to workload VMs. In the baseline architecture, this was owned by the workload team. 
- **Spoke virtual network** in which the workload is deployed. 
- **User-defined routes** (UDRs) for forced tunneling to the hub network.
- **Azure Policy** based governance constraints and DeployIfNotExists (DINE)  policies as part of the workload subscription.

> [!IMPORTANT]
> Azure landing zones provides the preceding resources as part of the platform landing zone subscriptions. The networking resources are part of the Connectivity subscription, which has additional resources such as Azure ExpressRoute, VPN gateway, Azure DNS for cross-premises access and name resolution. They are outside the scope of this architecture. 

## Subscription set up by the platform team

In a landing zone context, **workload teams must provide their specific requirements to the platform team**. The primary shared responsibility between the two teams are in the areas of management group assignment and networking setup. 

The platform team will assign the workload to an appropriate management group based on the workload's business criticality and technical requirements, such as whether it'll be exposed to the internet. The configuration of these management groups is determined by the organization and implemented by the platform team. 

The specific requirements, provided by the workload team, are used by the platform team to set up a subscription or a group of subscriptions for deployment. The workload team should include detailed information about the networking space so that the platform team can allocate necessary resources. While the workload team provides the requirements, the platform team is responsible for deciding the specific IP addresses to assign within the virtual network and the management group to which the subscription will be assigned.

> [!IMPORTANT] 
> Azure landing zones recommend a subscription vending workstream for the platform team that involves a series of questions designed to capture key pieces of information from the workload team. These questions may vary from one organization to another, but the intent is to gather the requirements for implementing subsription(s). For more information, see [**Cloud Adoption Framework: Subscription vending**](/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending).

##### Workload team

Here are some networking requirements for this architecture. Use these points as examples for a similar architecture that must be communicated to the platform team. 

- **Number of spoke virtual networks**. In this architecture only one dedicated spoke is required. The deployed resources don't need to span across multiple networks and are colocated within a single virtual network. 

- **Size of the spoke network (s)**. The operational requirements and expected growth of the workload must be taken into consideration. For example, if you are planning to implement Blue/Green or Canary updates, the maximum size should account for the space required for side-by-side deployments.

    Future changes may require additional IP space, which may not be contiguous with the current allocation. The integration of these spaces could introduce additional complexity. Be proactive and request enough network resources upfront to ensure that the allocated space can accomodate future expansion.

- **Deployment region**. It's important to specify the region(s) where the workload will be deployed. This information allows the platform team to ensure that the spoke and hub virtual networks are provisioned in the same region. Networks across different regions can lead to latency issues due to traffic crossing regional boundaries and can also incur additional bandwidth costs.

- **Workload characteristics and design choices**. Communicate your design choices, components, and characteristics to your platform team. For instance, if your workload is expected to generate a high volume of network traffic ("chatty"), the platform team should ensure that there are sufficient ports available to prevent exhaustion, add extra IP address to the centralized firewall to support that traffic, set up a NAT gateway to route the traffic through an alternate path, and so on. 

    Conversely, if your workload is expected to generate only minimal network traffic ("background noise"), this should also be communicated so that the platform team uses resources efficiently across the organization.

    Any dependencies should be clearly communicated. For example, if the workloads needs access to a database owned by another workload team, if on-premises traffic is to be expected, or if the workload has dependencies outside Azure. Such information is important for the platform team to know.

- **Firewall configuration**. The platform team must know of traffic that's expected to leave the spoke network and tunnelled out to the hub network. This ensures that the firewall in the hub doesn't block that traffic.

    For instance, if your workload needs to access Windows updates to stay patched, the firewall shouldn't block these updates. Similarly, if the installed Azure Monitor agents, which access specific endpoints, firewall shouldn't block that traffic because this could disrupt monitoring data for your workload. The application could require access to third-part endpoints. Regardless, centralized firewall should be able to make the distinction between expected and unwarranted traffic.

- **Operator access**. If there are Microsoft Entra ID security groups that operators use to access the VMs via Bastion, inform the platform team. Bastion is typically a central resource, it's crucial to ensure that the secure protocol is supported by both the security groups and the VMs.

    Additionally, the platform team should be informed about the IP ranges that will contain the VMs. This information is necessary for configuring the Network Security Groups (NSGs) around Azure Bastion in the hub network.

- **Public IPs**. The platform team should be informed about the ingress traffic profile, including any anticipated public IP addresses. In this architecture, we expect only internet-sourced traffic targetting public IP on Application Gateway. 

    There's another public IP for operational access via Bastion. This public IP would be enrolled in a service like DDoS protection, which is managed by by the platform team.

- Deploy If Not Exists (DINE) policies. These policies are part of an automated deployment configured into a subscription by the platform team. DINE policies can either modify workload resources that are deployed or add things to your deployment, which can result in a discrepancy between the workload templates.

  To avoid this, it’s ideal to incorporate these changes into your templates in advance or communicate with your platform team to be excluded from this policy.
    
  > [!IMPORTANT] 
  > Azure Landing Zone uses various DINE policies. For example, policies that manage private endpoints at scale. This policy monitors private endpoint deployments and updates Azure DNS in the hub network, which is part of a platform-managed subscription. The workload team doesn’t have permission to modify it in the hub, and the platform team doesn’t monitor the workload teams’ deployments to update DNS automatically. DINE policies are used to provide this connection.

- **Golden images for VMs**. Platform team might manage a standardized set of VM images, known as golden images, which are created for use across the organization. Prior to release, these images undergo a certification process by the workload teams to ensure they meet the necessary standards and requirements.

##### Platform team

- Patching?
- Firewall rules?
- Golden images?

## Application considerations

_TODO TBD_

## Networking

In the baseline architecture, the workload was deployed in s single virtual network managed by the workload team. In this architecture, the network topology is decided by the platform team. Hub-spoke topology is assumed in this architecture. The single virtual network in the baseline becomes the spoke network, which owned and managed by the platform team. It's peered to the hub network, which provides the centralized services.

In the [**baseline architecture**](vm-baseline-content.md#networking), the workload was provisioned in a single virtual network, the management of which was the responsibility of the workload team. However, in this architecture, the responsibility for determining the network topology has been offloaded to the platform team.

This architecture operates on the assumption of a hub-spoke topology. 

- **Hub virtual network**. This network contains a regional hub designed to provide centralized services that communicate with workload resources in the same region. For information, see [these networking resources](#platform-team-owned-resources). Azure landing zones recommend placing the hub in the [Connectivity subscription](/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity). 
- **Spoke virtual network**. The single virtual network from the baseline architecture is now transformed into the spoke network. The ownership and management of this spoke network now fall under the purview of the platform team. This network contains the[ workload resources](#workload-team-owned-resources). However, the workload team owns the resources in this network. 

The spoke network is peered with the hub network. Azure landing zone subscription intended for the workload, has at least one preprovisioned virtual network that's peered to the hub network. The preprovisioned virtual network and peerings must be able to support the expected growth of the workload. Make sure you [communicate the workload requirements](#subscription-set-up-by-the-platform-team) to the platform team and review them periodiocally.

> [!IMPORTANT] 
> The workload network must not be directly peered to another spoke virtual network. All transitive virtual network connections should be facilitated by your platform team.

TODO: IPAM, Org IP overlap

#### Virtual network subnets

In the spoke virtual network, the workload team has the responsibility of subnet allocation. The intent is segmentation and placing controls to restrict traffic in and out of the subnets. This architecture recommends the creation of dedicated subnets for Application Gateway, Key Vault, frontend VMs, load balancer, backend VMs, and private endpoints.

Subnets for those components remain the same as the [**baseline architecture**](vm-baseline-content.md#subnetting-considerations). 

Deploying your workload in an Azure landing zone does not take away the responsibility of implementing network controls. There might be additional restrictions imposed by the organization to safeguard against data exfiltration, ensure visibility for central Security Operations Center (SOC) and IT network team.

This approach allows the platform team to optimize costs through centralized services, rather than deploying redundant security controls per workload throughout the organization. In this architecture, Azure Firewall is an example of a central service. It would be neither cost-effective nor practical for each workload team to manage their own firewall instance. Instead, a centralized approach to firewall management is recommended.

##### Ingress traffic

Ingress traffic flow remains the same as the [**baseline architecture**](vm-baseline-content.md#ingress-traffic). 

The workload owner is responsible for any resources related to public internet ingress into your workload. In this architecture, this is demonstrated by placing Application Gateway and its public IP in the spoke network, and specifically not as part of the hub network. In some organizations, ingress might be expected in a connectivity subscription using a centralized DMZ implementation. Integration with that specific topology is out of scope for this article.

##### Egress traffc

In the baseline architecture, egress traffic to the internet wasn't restricted. 

That design has changed in this arcitecture. All traffic leaving the spoke virtual network is expected to be routed through the peered hub network, typically via an egress firewall. This is usually achieved with a route attached to the spoke network that directs all traffic (0.0.0.0/0) to the hub’s Azure Firewall.

The workload team must identify, document, and communicate all necessary outbound traffic flows for your infrastructure and workload operations. The platform team will allow the  required traffic, while all uncommunicated egress traffic will likely be denied.

> [!TIP]
>
> Encourage the platform team to use IP groups in Azure Firewall. This will ensure that your workload’s specific egress needs are accurately represented with tight scoping to just the source subnets. For instance, a rule that allows workload virtual machines to reach api.example.org doesn't necessarily imply that supporting virtual machines, such as build agents within the same virtual network, should be able to access the same endpoint. This level of granular control can enhance the security posture of your network.

Communicate any unique egress requirements to the platform team. For instance, if your workload establishes numerous concurrent connections to external network endpoints, inform the platform team. This will allow them to either provision an appropriate NAT Gateway implementation or add additional public IPs on the regional firewall for mitigation.

Avoid architecture patterns that relies on workload-owned public IPs for egress. To enforce this, consider using Azure Policy to deny public IPs on virtual machine Network Interface Cards (NICs) and any other public IP other than your well-known ingress points.

##### Private DNS zones

Architectures that use private endpoints, need private DNS zones. The workload team must have a clear understanding of those requirements and management of private DNS zones in the subscription given by the platform team. Private DNS zones are typically managed at a large scale using DINE policies, enabling Azure Firewall to function as a reliable DNS proxy and support Fully Qualified Domain Name (FQDN) network rules. 

//TODO (choose one) This architecture will either delegate the responsibility of ensuring reliable private DNS resolution for private link endpoints to the platform team or assume these responsibilities itself. It is recommended to collaborate with your platform team to understand their expectations.

##### Connectivity testing

For VM-based architecture, there are several test tools that can help determining network line of sight, routing, and DNS issues.You can use  traditional troubleshooting using tools such as `netstat`, `nslookup`, or `tcping`. Additionally, you can examine the network adapter’s DHCP and DNS settings. The presence of NICs further enhances your troubleshooting capabilities, enabling you to perform connectivity checks using Azure Network Watcher.

## Patch compliance reporting

TBD

- Automation Accounts


## Operations access

Your architecture is made up of virtual machines, which sometimes need to be accessed directly. This can happen in a break-fix situation, as part of troubleshooting, or can even happen as part of a deployment process from your build agents. This architecture does not support public IPs for control plane ingress into your solution, only for workload application traffic. Virtual machine solutions often then sit on the network such that Azure Bastion act as a serverless gateway for operations to access via SSH or RDP.

The baseline architecture deployed Azure Bastion as part of the workload, as that architecture did not imply any larger context for which it resided. In a typical Azure landing zone architecture, Azure Bastion is often one of the centrally provided resources that are then made available for workload teams to use. In this architecture, Azure Bastion has moved to be managed by the Platform team (shown in the Connectivity subscription).

### User access

When logging into a virtual machine, you must do so under a user account. Your organization might have guidelines or requirements to follow. Typically, it would be expected that access is controlled via Azure AD authentication, and is security group backed. This architecture deploys the Azure AD authentication extension to all virtual machines to support this mechanism.

As with any identity-based access, it's recommended that humans use corporate identities in their corporate Azure Active Directory tenant, and any service principal based access does not share principals across functions. In both cases, least-priviledged and granular access to the task being performed is preferred. For human access, look into your platform's identity team's JIT support.

## Build agents

As a workload team, you are still responsible for deploying the workload. And due to no public IP access to the control plane of this architecture, that often means having deployment agents in the architecture. This was showcased in the baseline architecture, can carries forward into the landing zone variant as well.

Ensure your patching process for your deployment agent virtual machines comply with platform requirements. OS access to these machines should be provided by your Azure Bastion access.

## OS images

Being in a landing zone doesn't imply any particular sources for virtual machine images, however it is possible that your organization does have a managed offering or compliance requirements around images.

Your organization might use Azure Compute Gallery to hold "blessed" OS images or encourage application teams like yourself to publish their workload artifacts there, and use it as part of your software deployment mechanism. As you decide on the OS for the virtual machines in your architecture, be sure to consult your platform team on where images should be sourced from, how often they are updated, and any expectations around consuming them.

If Azure Compute Gallery is desired, you'll need network line of sight to the gallery, including any Azure Firewall rules to support it.

TODO

## Monitoring considerations

The Azure landing zone platform provides shared observability resources as part of the Management subscriptions. However, provisioning your own monitoring resources is recommended to facilitate ownership responsibilities of the workload.

The workload team provisions these resources:

- Azure Application Insights to showcase Application Performance Monitoring (APM) being a function of the workload team.
- Azure Log Analytics workspace as the unified sink for all logs and metrics collected from Azure services and the application.
- A self-managed Azure Storage account to capture boot diagnostics from virtual machines in this architecture.

Just as in the baseline, all resources are configured to send Azure Diagnostics to the Log Analytics workspace provisioned by the workload team and is part of the IaC deployment of the resources. Be aware that the platform team might also have DINE policies to configure Azure Diagnostics to send logs to their centralized Management subscriptions to support NOC, SOC, other operations. Ensure that your IaC solution or workload-level Azure Policy implementation does not impede those log flows.

### Correlating data from multiple sinks

Logs and metrics generated by the workload and its infrastructure components are saved in the workload's Log Analytics workspace. But, logs and metrics generated by centralized services, such as Active Directory and Firewall, are saved to a central Log Analytics workspace managed by platform teams. Likewise, platform teams might occasionally benefit from workload-level logs to trace impact/scope of an incident. Correlating data from different sinks can lead to complexities.

Your triage runbook for this architecture should account for those gaps and have organizational points of contact established if the problem has been determined to extend beyond your resources. Workload administrators may need help from platform administrators to correlate log entries from enterprise networking, security, or other platform services. Likewise, when a security incident occurs, the workload-level administrators might be asked to review their systems' logs for signs of malicious activity or provide copies of their logs to incident handlers for further analysis. When troubleshooting application issues. To help with this type of collaboration, familiarize yourself well in advance with the procedures set up by your organization.

> [!IMPORTANT]
>
> **Platform team**
>
> - Where possible, grant role-based access control (RBAC) to query and read log sinks for relevant platform resources.
> - Enable logs for AzureFirewallApplicationRule, AzureFirewallNetworkRule, AzureFirewallDnsProxy because the application team needs to monitor traffic flows from the application and requests to the DNS server.

## Azure Policy

TODO

- Review common azure policies (both platform and workload)
- In-guest Azure Policy agent

Your platform team will likely apply policies that will influence your deployment. Getting to understand what policies are applied to your environment and making sure you're accounting for them in your architecture ahead of time will yield the most predictable results. Ideally, where practical, you should apply some of these configurations directly in your IaC resources to avoid unnecessary resource changes via DINE policies.

Here are some examples of policy that might be applied.

- Enforce that Windows VM join an Active Directory Domain. This might be accomplished through a DINE policy that ensures the  `JsonADDomainExtension` virtual machine extension is installed and configured. See [Enforce Windows Virtual Machines to join AD Domain](https://github.com/Azure/Enterprise-Scale/blob/main/docs/reference/azpol.md#enforce-windows-vms-to-join-ad-domain).
- Disallow IP forwarding on network interfaces
- Private Link DNS management

TODO

## Security

The security considerations carry over from the [**baseline architecture**](vm-baseline-content.md#security).The recommendations are based on the [Security design review checklist given in Azure Well-Architected Framework](/azure/well-architected/security/checklist). The sections are annotated with recommendations from that checklist.

##### Network controls

- **Ingress traffic**. Isolation from other workload spokes within the organization is achieved through the use of Network Security Groups (NSGs) on your subnets, and potentially also through the non-transitive nature or controls in the regional hub. Construct comprehensive NSGs that only permit the inbound network requirements of your application and its infrastructure. Relying on the non-transitive nature of the hub network for security is not recommended.

    The platform team will likely implement specific Azure Policies to ensure that  Application Gateway has the Web Application Firewall (WAF) enabled in deny mode, restrict the number of public IPs available to your subscription, and other checks. In addition to those policies, the workload team should own the responsibility of deploying workload-centric policies that reinforce the ingress security posture.

    Examples of ingress controls in this architecture:

    | Source | Purpose | Workload control | Platform control |
    | :----- | :------ | :--------------- | :--------------- |
    | Internet | _TODO_ | _TODO_ | _TODO_ |
    | Azure Bastion | _TODO_ | _TODO_ | _TODO_ |
    | Other spokes | None | Blocked via NSG rules. | Non-transitive routing or Azure Firewall rules in the case of Azure VWAN secured hub. |

- **Egress traffic**. Apply NSG rules that express the required outbound connectivity requirements of your solution, and deny everything else. Do not depend on hub security controls alone. As a workload owner, have the responsibility to stop undesired egress traffic as close to the source as practicable.

Be aware that while you own your subnetting within the virtual network, the platform team likely created firewall rules to specifically represent your captured requirements as part of your subscription vending process. Ensure that changes in subnets and resource placement over the lifetime of your architecture are still compatible with your original request, or work with your network team to ensure continuity of least-access egress control.

Examples of egress in this architecture:

| Endpoint | Purpose | NSG control | Hub control |
| :------- | :------ | :---------- | :---------- |
| _TODO_ | _TODO_ | _TODO_ | _TODO_ |
| _TODO_ | _TODO_ | _TODO_ | _TODO_ |
| _TODO_ | _TODO_ | _TODO_ | _TODO_ |

##### Identity and access management

TBD

- RBAC
- Automation Accounts here too?
- User accounts (corporate, etc)


##### DDoS protection

Ensure you've understood who will be responsible for applying the DDoS Protection plan that covers all of your solution's public IPs. Your Platform team might use IP protection plans, or might even use Azure Policy to enforce Vnet protection plans. This specific architecture should have coverage as it involves a public IP for ingress from the Internet. VNet protection plan is deployed.

##### Secret management

This architecture does not introduce any specific dependencies outside of the workload on Key Vault. However, it's common for publicly exposed HTTPS endpoints to be surfaced with TLS using the organization's domain. This involves working with your IT team to understand how those TLS certs are procured, where they are stored, and how they are rotated. This architecture doesn't make any specific affordences for this process.

As a workload team, continue to keep your workload secrets a function of your landing zone. Deploy your own Azure Key Vault instance(s) as needed to support your application and infrastructure operations.

## Cost optimization strategies

This architecture benefits significantly from the Azure landing zone platform resources being brought into this architecture. Even if usage of those resources are done through a chargeback model to your team, the added security value and added cross-premisses connectivity is significantly cheeper, from the workload perspective, than purchasing, deploying, and managing those resources yourself. Look for additional centralized offerings from your platform team that extend the same to your workload, without compromising on your workload's SLO, RTO, or RPO.

Examples of Platform team resource in this architecture that might be consumption based (charge-back) or even potentially free to the workload team resources:

- Azure Firewall
- SIEM
- Azure Bastion Hosts
- Cross-premisses connectivity such as ExpressRoute

## Deploy this scenario

A deployment for this reference architecture is available at [XXX](https://github.com/mspnp/xxx) on GitHub.

The artifacts in this repository provide a foundation that you can customize for your environment. The implementation provisions a hub network with shared resources such as Azure Firewall only for illustrative purposes. This grouping can be mapped to separate landing zone subscriptions to keep workload and platform functions separate.

The deployment uses Bicep templates. To deploy the architecture, follow the [step-by-step instructions](https://github.com/mspnp/xxx/go).

## Related resources

TODO

For more scenarios, see these articles.

TODO

## Next steps

TODO

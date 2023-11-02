This reference architecture extends the IaaS [**baseline architecture**](./vm-baseline.yml) to address common architectural changes and expectations when being deployed into in Azure landing zones.

In this scenario, your organization expects the vm-based workload to use federated resources managed by central teams (platform), such as networking for cross-premises connectivity, identity access management, and policies. This guidance assumes that the organization has adopted Azure landing zones to apply consistent governance and save costs across multiple workloads.

## Architecture

:::image type="content" source="./media/vm-baseline-landing-zone.png" alt-text="A architectural diagram showing the IaaS baseline in an application landing zone." lightbox="./media/vm-baseline-landing-zone.png":::

Typical uses for this architecture include:

- Private applications: Internal line-of-business application or commercial off the shelf (COTS) solutions. These are often found under the "Corp" management group in traditional Azure landing zones.
- Public applications: Internet facing applications. These can be found under either the "Corp" or "Online" management group in traditional Azure landing zones.

This article will not address scenarios such as high performance compute (HPC), mission-critical workloads, latency-sensitive applications, low RPO/RTO targets, or more accurately any _specific_ workload needs; but instead serves as a foundation for a workload-agnostic perspective in Azure landing zones.

### Components

All Azure landing zone architectures have dual-ownership between the platform team and the workload team. Application architect and DevOps teams need to have a strong understanding of this responsibility split in order to understand what's under their direct control, under their influence, and what is out of their influence or control.

#### Application team-owned resources

Your team provisions and owns these resources.

- Application platform Virtual Machines
- Load balancer
- Azure Application Gateway
- Azure Key Vault
- Azure Monitor - Log Analytics & Application Insights
- Azure Policy as it applies to the specific workload
- Spoke subnetting
- Build/deployment agents (VMs)
- Workload-specific private DNS zones
- Network security groups
- Private endpoints
- Disks/Storage

#### Platform team-owned resources

This architecture assumes these resources are preprovisioned. The central teams of the organization own and maintain the resources. Your application depends on these services to reduce operational overhead and optimize cost.

- **Azure Firewall** inspects and restricts egress traffic.
- **Azure Bastion** provides secure access to the management jump box.
- **Azure ExpressRoute** provides private connectivity from cross-premises to Azure infrastructure.
- **Azure DNS** provides cross-premises name resolution.
- VPN gateway connects the application with remote teams in your cross-premises network.
- Private Link Private DNS zone entries
- Spoke Virtual Network
- UDR for forced tunneling
- Azure Policy based governance constraints and DINE policies

## Subscription vending

The subscription this IaaS workload architecture will be deployed into will come from your organization's subscription vending process. Ensure key workload requirements are communicated as part of the subscription request. In addition to any other data required specific to your subscription vending process, here are examples, specific to this architecture, that you'd want your platform team to be made aware of up front:

- Number of spoke virtual networks. _In this architecture, this would just be one._
- Required size of spoke virtual networks to support full workload operations and expected growth. _In this architecture, this would be `/??` on the single virtual network._
- What region(s) your workload will be deployed to. _In this architecture, a single region; for example eastus2._
- Any special NAT gateway/SNAT considerations on egress. _There are none for this architecture._
- Any expected cross-premisis access. _There are none for this architecture._
- Any expected cross-virtual network access. _There are none for this architecture._
- Azure Firewall egress rules for infrastructure and OS needs
  - OS-specific time (NTP) endpoints. _In this architecture... _TODO_
  - OS-specific patching endpoints _In this architecture... _TODO_
  - Azure Monitor Agent endpoints _In this architecture... _TODO_
  - Azure Policy reporting endpoints _In this architecture... _TODO_
- Azure Firewall egress rules for all workload specific traffic, including build agents. _In this architecture... _TODO_
- Existing Azure Active Directory security groups expected to be able to log into virtual machines as users (via SSH/RDP). _In this architecture... TODO_
- Expressed ingress traffic profile, including any expected public IP addresses. _In this architecture, we only expect Internet-sourced traffic, and will be handled by our Application Gateway + WAF in the spoke. Application Gateway will have one public IP._
- Which IP ranges will contain virtual machines so they can be added to the NSGs around Azure Bastion in the hub.
- _TODO, more?_
- Plus any other data required specific to your subscription vending process.

Items you should be made aware of from the platform team after the vending process is complete:

- Possible egress IP addresses on the hub's firewall, to provide to dependent services (1st party or 3rd party) for ACL purposes.
- Update/patch management expectations
- Any DINE policies that are expected to impact your resources' configuration
- In region Azure Bastion host access.
- Platform created managed identities and their intended utility
- Coverage under DDoS Protection plan for public IPs in this architecture.
- The IP ranges of the regional and failover Azure Bastion hosts to include in your NSGs around your virtual machines.
- Any VM Application Gallery endpoints and auth information for approved virtual machine images.

## Application considerations

_TODO TBD_

## Networking considerations

In this design, the workload is dependent on key network resources owned by the platform team for accessing or being accessed by cross-premises resources, controlling egress traffic, and so on.

### Network topology

The platform team decides the network topology. Hub-spoke topology is assumed in this architecture.

- **Hub virtual network**

  The [Connectivity subscription](/azure-best-practices/traditional-azure-networking-topology) contains a regional hub shared by all or many of the organization's resources in the same single region. It contains [these networking resources](#platform-team-owned-resources) that are owned and maintained by the platform team. These resources are in scope for this architecture:

  - **Azure Firewall** used for controlling outbound traffic to the internet.
  - **Azure Bastion** used to securing access to the virtual machine instances.

- **Spoke virtual network**

  The application landing zone has at least one preprovisioned virtual network that's peered to the hub network. You own the resources in this network. The preprovisioned virtual network and peerings must be able to support the expected growth of the workload. Estimate the virtual network size and evaluate the requirements with the platform team regularly.

TODO: IPAM, Org IP overlap

#### Virtual network subnets

You're responsible for allocating subnets in the spoke virtual network. This architecture requires suggests dedicated subnets for:

- Application Gateway
- Front End VMs
- Load Balancers between tiers
- Back End VMs
- Deployment agents
- Private Endpoints

#### Virtual network peering

Your workload should not be architected to expect any direct peering to another spoke virtual network. All transitive virtual network connections should be facilitated by your platform team.

#### Network controls

Landing your workload in an Azure landing zone does not change the responsibility of applying appropriate network controls to your solution. Azure landing often will enforce specific additional restrictions to ensure the organization is protecting itself against data exfiltration, can support SOC & NOC visibility, and shadow IT. Doing so results in splitting responsibility so that the platform team can optimize cost by having centralized offerings instead of duplicative security controls deployed throughout the org. In this architecture Azure Firewall is an example. It's impractical to govern and not cost optimized for every workload team to manage their own firewall instance.

##### Egress controls

For all traffic that leaves your virtual network, your IaaS workload will be expected to pass that traffic through its regional hub and usually more specifically through an egress firewall in that hub. This is often implemented with a route table that is attached to your spoke virtual network as part of the subscription vending process, directing `0.0.0.0/0` traffic to your regional hub's Azure Firewall.

This means that you need to discover and document all outbound traffic flows necessary for both infrastructure operations and workload operations as part of your solution. You'll communicate the flows that leave your spoke, in specificity, with the platform team. The platform team is expected to allow your required traffic and you should expected to all other egress traffic that wasn't specifically communicated to be denied.

> [!TIP]
>
> Encourage the platform team to use IP groups to ensure that your workload's specific egress needs are represented in Azure Firewall with tight scoping to just the source subnets. For example the rule that support workload virtual machines being able to reach api.example.org, does not mean that supporting virtual machines, like build agents, even in the same virtual network, should necessarily be able to reach the same endpoint.

Apply NSG rules that express the required outbound connectivity requirements of your solution, and deny everything else. Do not depend on hub security controls alone. As a workload owner, have the responsibility to stop undesired egress traffic as close to the source as practicable.

Be aware that while you own your subnetting within the virtual network, the platform team likely created firewall rules to specifically represent your captured requirements as part of your subscription vending process. Ensure that changes in subnets and resource placement over the lifetime of your architecture are still compatible with your original request, or work with your network team to ensure continuity of least-access egress control.

Examples of egress in this architecture:

| Endpoint | Purpose | NSG control | Hub control |
| :------- | :------ | :---------- | :---------- |
| _TODO_ | _TODO_ | _TODO_ | _TODO_ |
| _TODO_ | _TODO_ | _TODO_ | _TODO_ |
| _TODO_ | _TODO_ | _TODO_ | _TODO_ |

**Communicate any special egress requirements.** For example if your workload establishes many concurrent connections to external network endpoints, ensure your platform team is aware of this so they can either provision the appropriate NAT Gateway implementation or add additional public IPs on the regional firewall to mitigate.

As an architect building for a landing zone implementation, you should not expect to design an IaaS solution that depends on workload-owned Public IP addresses for egress. Consider helping enforce this with Azure Policy by denying public IPs on virtual machine NICs and any other public IP other than your well-known ingress points.

##### Ingress controls

Isolation from other workloads' spokes in the organization is achieved through NSGs on your subnets, and potentially also through the non-transitive nature or controls in the regional hub. Always build comprehensive NSGs that only allow the inbound network requirements of your application and its infrastructure; do not depend on any non-transtive nature of the hub you are peered to for security.

As a workload owner, typically you are responsible for any resources related to public Internet ingress into your workload. In this architecture, this is showcased by the inclusion of Application Gateway and its public IP as being part of the workload spoke, and specifically not as part of the hub. In some organizations, ingress is expected to be handled in a connectivity subscription using a centralized DMZ implementation. Integration with that specific topology is out of scope for this article.

Your platform team will likely have specific Azure Policies in place to ensure your Application Gateway has WAF enabled in deny mode, limit the number of public IPs available to your subscription, etc. As a workload owner, also deploy workload-centric policies that enforce your ingress security posture.

Examples of ingress in this architecture:

| Source | Purpose | Workload control | Platform control |
| :----- | :------ | :--------------- | :--------------- |
| Internet | _TODO_ | _TODO_ | _TODO_ |
| Azure Bastion | _TODO_ | _TODO_ | _TODO_ |
| Other spokes | None | Blocked via NSG rules. | Non-transitive routing or Azure Firewall rules in the case of Azure VWAN secured hub. |

##### Network security group example

Here is an example of a network security group that supports access from the hub for Azure Bastion, etc. TODO

NSG TODO

#### Private DNS delegation

Architectures that depend on private endpoints need to understand their landing zone's DNS expectations and how private DNS zones are managed. Typically Private DNS zones are managed at scale with DINE policies so that Azure Firewall can reliably act as a DNS proxy to support FQDN network rules. This architecture either will shift responsibility to the Platform team to ensure reliable private DNS resolution for private link endpoints or take on those responsibilities itself. Work with your platform team to understand expectations.

TODO MORE

#### Connectivity testing

In sufficiently complex networking architectures, it's sometimes challenging to figure out network line of sight, routing, DNS issues. In a virtual machine-based architecture such as this, you have some powerful tools available to you to help troubleshoot, even more so than in a PaaS offering in many cases.

You ultimately have OS-level access to perform local traditional troubleshooting using tools such as `netstat`, `nslookup`, or `tcping`. You can also look at the network adaptor's DHCP and DNS settings. But even more so, the fact that you have NICs available give you the ability to run connectivity checks using Azure Network Watcher.

## Patch compliance reporting

TBD

- Automation Accounts

## Identity and access management

TBD

- RBAC
- Automation Accounts here too?
- User accounts (corporate, etc)

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

## Security considerations

### DDoS protection

Ensure you've understood who will be responsible for applying the DDoS Protection plan that covers all of your solution's public IPs. Your Platform team might use IP protection plans, or might even use Azure Policy to enforce Vnet protection plans. This specific architecture should have coverage as it involves a public IP for ingress from the Internet. VNet protection plan is deployed.

### Secret management

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

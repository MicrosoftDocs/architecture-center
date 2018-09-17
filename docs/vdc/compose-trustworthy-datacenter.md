---
title: "Azure Virtual Datacenter: Compose a trustworthy datacenter" 
description: How to compose a trustworthy datacenter using the Azure Virtual Datacenter framework.
author: telmosampaio
---

# Azure Virtual Datacenter: How to compose a trustworthy datacenter

Virtual datacenters introduce new challenges to the service management landscape. Together with Azure Virtual Datacenter principles, good IT management processes help enterprises realize the benefits of public cloud computing such as self-service, scalability, and elasticity.

This section describes a reference implementation for Contoso, a fictional financial services enterprise. It is based on real-life engagements with global organizations that have successfully made the transition to the cloud with the requisite regulatory approval.

## Compose in layers driven by policy

Policy is built in layers using the components discussed in Part 2—software-defined networking, encryption, identity management, and compliance.

### Proposed Contoso architecture

The core of Contoso's virtual datacenter is a central IT infrastructure through which all network traffic flows, policies are set, and core monitoring occurs. This infrastructure is segmented in its own environment, providing central security and networking services, including a hub virtual network that connects to other parts of the datacenter. It also manages any external connections used by resources hosted outside the virtual datacenter.

The design calls for isolated workspaces that support Contoso's various workload deployments such as Microsoft SharePoint or SAP services. Each workspace has its own management resources and spoke virtual networking infrastructure. Teams can add other policies to control access and resource usage within their workspace while adhering to central policies.

The central IT infrastructure environment and each workspace are created as separate Azure subscriptions. This policy decision is designed to increase workload flexibility and avoid [subscription-related limits](/azure/azure-subscription-service-limits). Each central IT and workspace subscription is associated with the main organizational Azure AD tenant, but teams can also set up additional workspace-specific access controls and policies. For example, workspace-level RBAC enables teams to deploy resources for specific workloads or projects. If some teams want to run more than one workload in their workspace, they can do so without needing another subscription. Enforcement of global organizational policies is maintained on all subscriptions.

The Contoso virtual datacenter's central IT infrastructure includes the following:

- Subscription level security policy and monitoring settings.
- Subscription level, networking-specific policy and monitoring settings.
- Any connections to on-premises networks or the Internet.
- The central hub virtual network, through which all traffic between cloud workloads and the on-premises network must pass.
- The central firewall that, in line with the trusted extension model, inspects and redirects traffic passing through the virtual datacenter to an on-premises network.
- Operational tools and shared management services used by the virtual datacenter.

Workspaces include the following:

- Resource Manager policy settings that prevent direct access to external networks and route traffic through the central IT infrastructure.
- The workspace spoke virtual network.
- Workload-specific operational tools, such as log and key management.
- Workload resources.

### Initial environment setup

Before any workspace subscriptions are created, Contoso configures their Azure AD tenant. This tenant was created when Contoso's Azure Enterprise Agreement was established and will be used for authentication and access control across the entire virtual datacenter. They integrate identity management between their on-premises Active Directory and Azure AD, using Azure AD Connect to synchronize credentials and accounts between the two environments.

Central IT and workspace subscriptions are created separately by Contoso's Azure Account Administrator, who ensures all subscriptions created for the virtual datacenter are associated with the organization's Azure AD tenant.

After a subscription is created, the standard SecOps, NetOps, SysOps, and DevOps roles for that subscription are added to Azure AD and given appropriate permissions.

### Central IT infrastructure and workspace layout

Contoso organizes the central IT infrastructure and workspace subscriptions into functional resource groups. They use Resource Manager policies to establish rules about what and how resources can be deployed through Resource Manager. These policies can also be applied at the resource group level. For instance, they can apply policies to a resource group created for developers that allows the creation of virtual machines and prevents the creation of networking resources or storage accounts. Resource groups are also used for access control. Contoso assigns specific roles to certain resource groups, while denying them access to the wider subscription.

Contoso will create the following resource groups in the central IT subscription:

| Resource group | Description |
| --- | --- |
| Networking | Contains the virtual network and related policy mechanisms such as the custom [user-defined routes](/azure/virtual-network/virtual-networks-udr-overview) (UDRs) and [network security groups](/azure/virtual-network/virtual-networks-nsg) (NSGs) used by the central IT infrastructure. |
| Operations | Hosts management services for central IT such as Microsoft Operations Management Suite (OMS) workspaces and network monitoring services. |
| Key vault | Provides access to the central IT Key Vault. |
| Shared services | Contains virtual machines providing DNS and domain services to the virtual datacenter. |
| Central firewall | Contains the central firewall providing layer 7 and potentially layer 4 outbound filters. |
| Management | Contains the virtual machines providing management jumpbox capabilities. |

The breakdown of resource groups within workspaces depends on the needs of individual workloads, but Contoso will provide each workspace with the following groups on creation:

| Resource group | Description |
| --- | --- |
| Networking | Contains the virtual network, related NSGs, and custom routing policies used by the workspace. |
| Operations | Hosts workspace-specific management services such as OMS workspaces and network monitoring services. |
| Key vault | Provides access to workspace-specific Key Vault. |

### Resource Manager policies

The base Resource Manager policies defined for a subscription and for resource groups are inherited by all resources within them. The Contoso virtual datacenter implements the following policies on both the central IT infrastructure and all workspaces:

| Policies | Description |
| --- | --- |
| Deny public IP | Prevents the creation of any new public IP endpoints. For workspaces, this policy applies at the subscription level. The central IT infrastructure applies this policy on all resource groups, allowing the subscription owner to add a public IP for a VPN connection if necessary. |
| Enforce storage encryption | Forces any storage accounts created to use encryption. This policy is applied at the subscription level for central IT and all workspaces. |
| Restrict allowed regions | Restricts the creation of any resources within the subscription to specific Azure regions. Contoso restricts the deployment of resources to regions within the United States. This policy is applied at the subscription level for central IT and all workspaces. |

### Key Vault setup

With the _enforce storage encryption_ policy in place on all subscriptions, Contoso needs to securely host and store encryption keys before any storage or virtual machines can be deployed.

After creating resource groups, Contoso provisions Key Vault for each environment—central IT and all workspace subscriptions. When the provisioning is complete, a cryptographic key is created and stored in Key Vault, which is then used to perform storage encryption tasks. An encrypted storage account is created in the Key Vault resource group for storing audit log information related to the vault.

Edit access to secrets and keys within the vault is restricted to the CorpSecOps or workload-specific SecOps role. Other roles can use secrets and keys to encrypt and decrypt storage and access encrypted virtual machines, but they cannot modify or otherwise access any keys.

### Hub virtual network setup

Contoso implements the central IT infrastructure hub and multiple workspace spokes of their virtual datacenter as separate virtual networks, residing in their respective subscriptions. They base the design of their a virtual network on the hub-spoke topology proposed in the Azure [network virtual datacenter paper](/azure/networking/networking-virtual-datacenter). Contoso's CorpNetOps group configures [virtual network peering](/azure/virtual-network/virtual-network-peering-overview) to provide basic connectivity between the central IT infrastructure hub and the workspace spoke virtual networks. If a workload goes out of compliance, central IT can immediately sever the peering connection, effectively cutting off all resources in the affected workspace from the wider virtual datacenter.

Contoso's infrastructure policy requires a consistent IP address schema across all virtual networks within the virtual datacenter. This schema makes sure addresses do not overlap with on-premises networks, allowing the virtual datacenter to coexist with those networks when the two are connected over VPN or ExpressRoute. In addition, within the virtual datacenter, IP address ranges for any of the central IT and workspace virtual networks must not overlap for peering links between spokes and hub to work.

#### Central firewall

Data exfiltration is a major concern to Contoso, so they want to implement a layer-7 whitelisting mechanism to control data leaving the virtual datacenter. They set up a firewall using one or more [network virtual appliances](https://azure.microsoft.com/en-us/solutions/network-appliances/) (NVAs) in the central IT infrastructure, and all traffic from a workspace to the outside world must pass through it. These virtual devices are designed to handle the networking and security functionality traditionally handled by physical firewall devices.

Through the central firewall, the central IT infrastructure controls the traffic allowed to pass in and out of the virtual datacenter and determines how that traffic is directed. The central firewall manages network flow within the virtual datacenter and between resources hosted in the virtual datacenter and those in external environments, including the on-premises datacenter.

UDRs on the workspace subnets route outbound traffic to the central firewall.

![]()
Figure 6. How the central firewall uses load balancers and traffic routing.

Contoso is expecting a large amount of traffic between their on-premises network and workloads hosted on the virtual datacenter. To handle the load and provide redundancy, the central firewall will consist of multiple NVAs. Two load balancers, using the [High Availability Ports](/azure/load-balancer/load-balancer-ha-ports-overview) feature, will distribute traffic: A front-end load balancer handles traffic going to the workspaces from the network on-premises, and a back-end load balancer handles traffic going from workloads to the network on-premises.

See also

[Secure networks with virtual appliances](/azure/virtual-network/virtual-network-scenario-udr-gw-nva)

[User-defined routes and IP forwarding](/azure/virtual-network/virtual-networks-udr-overview)

#### Gateways and perimeter networks

Contoso needs to set up a perimeter network to provide network connectivity with their on-premises datacenter networks. Perimeter networks in a virtual datacenter are usually handled as subnets of the central IT infrastructure's hub virtual network. When both this hub network and the remote network are fully trusted, the perimeter network can be implemented simply using a gateway to ensure traffic is routed properly to and from the central firewall.

In Contoso's implementation of the trusted extension model, a DMZ is not required, because all traffic flows only between the on-premises network and the virtual datacenter. This traffic passes through either an isolated ExpressRoute connection or a secure site-to-site VPN, and subscription policy prevents any public access to the virtual datacenter itself.

![]()
Figure 7. The gateway subnet routes traffic to the appropriate part of the central IT infrastructure.

This gateway is configured in a subnet of the central IT infrastructure's hub virtual network. The subnet implements UDRs to send incoming traffic to one of three destinations. Requests for workspace resources are processed through the central firewall. Administrator requests for remote access to configure network resources are sent to the management jumpboxes. Requests for tasks such as name resolution are routed to the shared services subnet.

In any case where the perimeter borders an untrusted source such as a public Internet connection, the Azure Virtual Datacenter model requires a full DMZ. To use this option, Contoso's perimeter network would include UDRs to send traffic to NVAs hosted on a DMZ subnet. This traffic gets processed, and only approved requests make it through either to the outside world or into the secured central IT hub virtual network, where it can be forwarded to the appropriate workspace spoke network.

See also

[Azure Reference Architectures: Connect an On-premises Network to Azure](/azure/architecture/reference-architectures/hybrid-networking/)

[Azure Reference Architectures: DMZ between Azure and the Internet](/azure/architecture/reference-architectures/dmz/secure-vnet-dmz)

#### Administration and management

By default, Contoso's on-premises network lacks direct access to the virtual datacenter's virtual networks or connected resources. CorpSecOps needs to configure the central firewall and oversee other management tasks in the central IT infrastructure that are not available through the Azure portal or management APIs. To support this capability, Contoso will create a set of secured jumpbox virtual machines connected to the central IT hub network. They will configure UDR rules to allow administrators to connect to these virtual machines from the on-premises network, and directly access virtual machines and NVAs hosted in the virtual datacenter.

Jumpboxes are created inside a management subnet, and NSG rules applied to this subnet restrict access to specific IPs on the on-premises network. Contoso will be deploying two jumpboxes to the central IT infrastructure as an availability set. To gain access to these virtual machines, administrators must be authorized through the [just in time access control](/azure/security-center/security-center-just-in-time) mechanism.

![]()
Figure 8. Administrators on-premises use hardened jumpboxes (bastion hosts) to remotely configure the central firewall and manage virtual machines and NVAs over the virtual network. NSGs restrict access to specific ports and IP addresses.

See also

[Implementing Secure Administrative Hosts](/windows-server/identity/ad-ds/plan/security-best-practices/implementing-secure-administrative-hosts)

[Filter network traffic with network security groups](/azure/virtual-network/virtual-networks-nsg)

#### Shared services

The shared services subnet provides a central place to deploy core functionality used by workspaces. For example, workloads in the virtual datacenter need to resolve names for on-premises resources, and the on-premises network needs to resolve names for virtual datacenter resources, so Contoso deploys DNS as the first shared service. Contoso also wants to integrate their DNS infrastructure, so they can use consistent name resolution across virtual and on-premises environments.

Contoso will provide DNS services by creating a primary and secondary domain controller running Azure Active Directory Domain Services in the central IT infrastructure environment, configured to handle DNS resolution for the virtual datacenter. These servers are configured to forward DNS requests from the virtual datacenter to the on-premises environment, and the on-premises DNS servers are likewise configured to forward DNS requests for names of workspace resources to the shared services DNS servers.

See also

[Name Resolution for VMs and Role Instances](/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances)

## Centralize access control and connect workspaces

Contoso's virtual datacenter design specifies a centralized set of IT security and management capabilities. They want business units to be able to deploy individual workloads with the agility and flexibility common to Azure solutions, while adhering to central IT policies. The basic infrastructure is supported by a hub-and-spoke network architecture connecting the central IT infrastructure with workloads.

They plan to set up a fast, private connection between the virtual datacenter and their network on-premises. They don't want to allow direct access to the Internet or external networks other than their own. All Internet-bound traffic must pass through the on-premises network—where it is subject to any security restrictions and policy managed there.

Figure 5 shows their initial proposal. For the final Contoso architecture, see Figure 11 at the end of this section.

![]()
Figure 5. Proposed high-level architecture for Contoso virtual datacenter.

### On-premises connectivity

To avoid sending traffic over the public Internet, Contoso wants to use a dedicated, private connection between their on-premises network and the virtual datacenter. The Azure Virtual Datacenter model supports two methods of connecting a virtual datacenter center to on-premises networks:

- [ExpressRoute](https://azure.microsoft.com/en-us/services/expressroute/) uses a dedicated, private connection facilitated by a connectivity provider.
- [Azure VPN gateways](/azure/vpn-gateway/vpn-gateway-about-vpngateways) create a site-to-site connection that passes encrypted traffic over the public Internet.

Contoso plans to set up an ExpressRoute connection, which offers more reliability, faster speeds, and lower latencies than typical connections over the Internet. ExpressRoute creates a direct link between the on-premises network and Azure. However, ExpressRoute connections take time to acquire and deploy. While they wait for ExpressRoute, Contoso can immediately set up a site-to-site VPN gateway, a common tactic used by many organizations to quickly get started using Azure resources.

After the ExpressRoute connection is in place, they can convert the VPN gateway to a failover connection in case the ExpressRoute goes down. They could also use it as a secondary connection for workloads that don't require the increased speed and lower latency of ExpressRoute.

### Separation of responsibility in the datacenter

Contoso wants the separation of responsibilities found in their on-premises operations to be reflected in their virtual datacenter. To organize jobs and responsibilities within the IT infrastructure, Contoso manages roles and assigns users to those roles using their on-premises directory service. Azure AD surfaces these roles in Azure, where they can be applied to access rules for the virtual datacenter's resources.

RBAC gives Contoso a way to assign different teams to various management tasks within the virtual datacenter. They give Central IT control over core access and security features, but also use a distributed approach to access that gives software developers and other teams large amounts of control over specific workloads.

Any significant change to resources or infrastructure involves multiple roles—that is, more than one person must review and approve a change. This separation of responsibilities limits the ability of a single person to access sensitive data or introduce vulnerabilities without the knowledge of other team members.

For example, the Network Operations person responsible for the central network infrastructure must approve certain infrastructure requests from the Network Operations person who oversees a specific application's virtual network. Contoso decided that these two similar roles should be split between the central team overseeing the common components of the infrastructure (Corporate NetOps) and the many people who oversee the individual application deployments (Application NetOps). Likewise, they take the same approach to Security Operations and other roles. Contoso can centrally manage policy for the organization as well as unleash application teams to innovate within those policies.

### Management roles

Contoso's current IT service management organization revolves around the activities that occur throughout the entire IT lifecycle: managing compliance, configurations, and audits. To handle these activities for the new virtual datacenter, Contoso organizes IT users from both the central and application teams into the following roles:

| Group | Common role name | Responsibilities |
| --- | --- | --- |
| Security Operations | SecOps | Provide general security oversight.Establish and enforce security policy such as encryption at rest.Manage encryption keys.Manage firewall rules. |
| Network Operations | NetOps | Manage network configuration and operations within virtual networks of the virtual datacenter such as routes and peerings. |
| Systems Operations | SysOps | Specify compute and storage infrastructure options and maintain resources that have been deployed. |
| Development, Test and Operations | DevOps | Build workload features and applications.Operate features and applications to meet service-level agreements (SLAs) and other quality standards.DevOps roles are generally not used in the central IT infrastructure. |

Following Azure Virtual Datacenter principles, access and security for resources within each workspace should be handled through workspace-specific groups independent of the central IT groups. Workload teams can then maintain their own resources, deploy solutions, and create access policies, while the central IT teams retain overall control of the virtual datacenter and communication into and out of it.

Each group should have a unique and easily identifiable name that indicates the section of the datacenter they are responsible for. Contoso creates a nomenclature to differentiate the roles associated with managing the central virtual datacenter services from the roles associated with managing the workspaces and workloads.

| Common IT infrastructure groups | Workspace-specific groups |
| --- | --- |
| CorpSecOpsCorpNetOpsCorpSysOpsCorpDevOps | _App_SecOps_App_NetOps_App_SysOps_App_DevOpsWhere &quot;_App_&quot; is a descriptive prefix for a workload's primary function, for instance, &quot;_LOBService1_NetOps&quot; for a workspace hosting a specific line-of-business application. |

### Identity management with Azure AD

Contoso wants to provide a common identity for managing resources on their virtual datacenter. To do this, they plan to integrate their on-premises directory services with Azure AD. [Azure AD Connect](/azure/active-directory/connect/active-directory-aadconnect) is used to provide synchronization of users and roles between Contoso's on-premises Active Directory service and the Azure AD tenant associated with the virtual datacenter.

Individual workloads and applications hosted in virtual datacenter workspaces may or may not make use of the shared identity services, but all management of Azure resources will use Azure AD for access control.

See also

[Microsoft hybrid identity solutions](/azure/active-directory/choose-hybrid-identity-solution)

[Azure AD Connect and federation](/azure/active-directory/connect/active-directory-aadconnectfed-whatis)


## Deploy workloads within workspaces

In their virtual datacenter implementation, Contoso considers DevOps at every layer, so teams stay productive and processes can be automated. Development teams need continuous integration and deployment pipelines, and all teams need to be able to monitor their workloads and resources.

Contoso's virtual datacenter policy manages workspaces as separate subscriptions, giving workload teams considerable control over their deployment environments. Developers get the agility Azure provides while remaining in compliance with the broader Contoso security and isolation policies enforced through the central IT infrastructure.

## Workspace management roles

Earlier, Contoso defined workspace-specific SecOps, NetOps, SysOps and DevOps roles. These workspace management roles have control over the workspace subscription and any resources they deploy into it—within the confines of the central IT policy restrictions. When the workspace subscription is created, Resource Manager policies are set up to restrict external access and route all outbound traffic through the central IT infrastructure.

The workspace SecOps and NetOps roles have the responsibility to lock down the workspace virtual networks based on Contoso policy for each specific workload. DevOps teams can have considerable flexibility in deploying any operating resources they need to support a workload. If DevOps activities require Internet or ExpressRoute access, the traffic goes through the central IT hub virtual network controlled by the central IT CorpSecOps team. Central firewall rules must be implemented for this traffic to make it through to the on-premises network, and the CorpSecOps team will be responsible for reviewing and implementing any requested updates to the firewall.

### Choosing the right service model for a workload

When planning workload deployments, Contoso DevOps teams can decide for themselves how much trust to hand over to the platform. Azure services offer a tradeoff between control and platform trust. Generalized cloud workloads fall into three broad categories, which represent a spectrum of control and trust on one end (IaaS) vs. the ease of management coupled with platform trust on the other (SaaS), with platform as a service (PaaS) in the middle.

![]()
Figure 9. The Azure platform offers a range of options to suit the level of control DevOps needs for workloads deployed to the virtual datacenter.

### Virtual network integration with PaaS

Some Contoso business units would like to use Azure PaaS offerings, such as Azure Batch, Azure SQL Database, and Azure Storage. Although these services provide security and encryption capabilities, by default most of them use a public endpoint for access. Contoso's security and network teams prefer to avoid any services that rely on public endpoints for access. Instead, they want services to be accessible only from inside workspace virtual networks.

They can integrate [Azure services in a virtual network](/azure/virtual-network/virtual-network-for-azure-services), which enables private, secured access for services such as HDInsight, Azure Batch, and Azure Storage. Two patterns are supported. In the first pattern, the service deploys dedicated instances into the virtual network, where they can only be used by resources with access to that network. Azure Batch and HDInsight follow this pattern.

The second pattern, [virtual network service endpoints](https://azure.microsoft.com/en-us/blog/announcing-virtual-network-integration-for-azure-storage-and-azure-sql/), is an Azure feature that extends a virtual network's private address space and identity to Azure services over a direct connection. This option helps secure service resources by allowing access only from the virtual network, providing private connectivity to these resources and preventing access from external networks. Service endpoints use the Microsoft backbone network and allow PaaS resources to be restricted to a single virtual network, or inside a single subnet capable of using NSGs to further secure network access.

Azure Storage and SQL Database follow this pattern. Additional Azure services are planning to support this feature in the future.

See also

[Virtual network integration for Azure services](/azure/virtual-network/virtual-network-for-azure-services)

[Announcing Virtual Network integration for Azure Storage and Azure SQL](https://azure.microsoft.com/en-us/blog/announcing-virtual-network-integration-for-azure-storage-and-azure-sql/)

[Virtual Network Service Endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview)

### Auditing and logging

Governance and control of workloads begins with collecting log data, but Contoso also needs to trigger actions based on specific, reported events. Within the virtual datacenter, Azure resources have logging policies enabled by default.

Different types of logging and monitoring services can be used to track the behavior of virtual datacenter resources. The Contoso SysOps team uses the two main types of logs offered by Azure:

- Audit logs (also called operational logs) provide insight into the operations performed on resources in an Azure subscription. Every Azure resource within a virtual datacenter produces audit logs.
- Azure diagnostic logs are generated by a resource and provide rich, frequent data about the operation of that resource. The content of these logs varies by resource type.

![]()
Figure 10. Virtual datacenter activities are continuously logged and monitored. Logging data is imported into OMS and is also available for use in on-premises log analytics.

Contoso wants to extend the standard monitoring framework already used for their on-premises systems and integrate the logs generated by virtual datacenter resources. If they want to keep logging activities in the cloud, they can use OMS. Its log analyzer helps to collect, correlate, search, and act on log and performance data generated by operating systems, applications, and infrastructure cloud components.

See also

[Azure Logging and Auditing](/azure/security/azure-log-audit)

### Use Azure security and monitoring tools

Continuous monitoring, auditing, and reporting are critical to proper governance. Azure provides Contoso an extensive set of management capabilities to help authorized individuals oversee the security configuration baselines and policy drift, network traffic, intrusion detection, and many other IT service management tasks. Most of these tasks can be handled by OMS, Azure Security Center, Azure Network Watcher, and Azure AD reporting.

| Tool | Description |
| --- | --- |
| [OMS](https://www.microsoft.com/en-us/cloud-platform/operations-management-suite) |
- Gives teams visibility and control across hybrid cloud implementations with simplified operations management and security.
- Offers real-time operational insights through integrated search and custom dashboards that analyze all the records across all workloads in a virtual datacenter.
 |
| [Azure Monitor](/azure/monitoring-and-diagnostics/monitoring-overview-azure-monitor) |
- Monitors across Azure resources.
- Supports performance metrics and diagnostic logging.
- Provides integration with SQL Database, NSGs, and Azure Blog Storage.
- Supports custom alert rules that can notify teams of performance issues and trigger automated actions.
 |
| [Azure AD](/azure/active-directory/active-directory-reporting-azure-portal) |
- Helps secure virtual datacenter resources by providing diagnostic reports.
- Provides reports on sign-on anomalies, the use of integrated applications, errors, and even specific users. Offers activity logs of all audited events, group activities, password resets, and registration activities.
 |
| [Azure Security Center](https://azure.microsoft.com/en-us/services/security-center/) |
- Detects security threats or breaches within a virtual datacenter and helps to detect, prevent, and respond to threats to hosted resources.
- Provides security monitoring and centralized policy management across Azure subscriptions used in a virtual datacenter.
- Supports definition of security policies for resources within a specified subscription or resource group, alerts the appropriate security teams of any policy violations, and offers recommendations for remediation.
- Collects, analyzes, and fuses log data from compute services, network resources, and partner solutions such as firewalls.
- Supports Microsoft Digital Crimes Unit, the Microsoft Security Response Center (MSRC), and other resources designed to stop attacks and prevent future attacks.
 |
| [Azure Network Watcher](https://azure.microsoft.com/en-us/services/network-watcher/) |
- Provides network monitoring capabilities so you can visualize network topologies and identify unhealthy connections and resources.
- Includes diagnostics for connectivity, latency, DNS check, trace route, IP flow verification, security group views, next hop, and packet capture.
- Reveals performance and health through flow analysis, security analysis, bandwidth usage, protocol analyzer, and network subscription limits.
- Shows configurations and views of all network logs and alerts.
 |

See also

[Azure Operational Security best practices](/azure/security/azure-operational-security-best-practices)

[Best practices for creating management solutions in Operations Management Suite (OMS)](/azure/operations-management-suite/operations-management-suite-solutions-best-practices)

[Azure Architecture Center - Best Practices: Monitoring and diagnostics](/azure/architecture/best-practices/monitoring)

## Final Contoso architecture

The finished Contoso architecture lays out a complete trusted datacenter extension to their existing on-premises IT infrastructure. The following table summarizes the decisions they made, shown in Figure 11.

| Area | Decisions |
| --- | --- |
| Identity management |
- Roles in place
- RBAC rules configured for central IT infrastructure
- RBAC rules configured for workspaces
- Azure AD Connect set up to synchronize users and roles with on-premises Active Directory
 |
| Subscription |
- Separate subscriptions for central IT infrastructure and each workspace
- Subscription-level access control and policy
 |
| Network |
- No public Internet access allowed from within the virtual datacenter
- DNS services configured and integrated with the on-premises network
- ExpressRoute connection between the virtual datacenter and on-premises network
- Central IT hub network
- Central firewall to inspect traffic between the on-premises network and workspace networks
- Connectivity between central IT and workspace virtual networks via virtual network peering
- Workspace subscription policies, NSGs, and UDRs
 |
| Management |
- Management jumpboxes accessible only from on-premises network when authorized through the just in time access authorization mechanism
 |

When complete, the Contoso virtual datacenter is ready to deploy workloads accessible only through the central IT infrastructure, and subject to the access controls, policy, and networking configuration enforced by Contoso's central IT management team.

![]()
Figure 11. Final Contoso architecture with major components and traffic flows (on-premises to workload, workload to on-premises, on-premises to management, and DNS).
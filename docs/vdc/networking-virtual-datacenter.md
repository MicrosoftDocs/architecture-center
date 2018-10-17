---
title: "Azure virtual datacenter: A network perspective"
description: Learn how to build your virtual datacenter in Azure
author: tracsman
manager: rossort
tags: azure-resource-manager

ms.service: virtual-network
ms.date: 09/24/2018
ms.author: jonor
---

# Azure virtual datacenter: A network perspective

## Overview
Migrating on-premises applications to Azure, even without any significant changes, provides organizations the benefit of a secured and cost-efficient infrastructure. This approach is known as **lift and shift**. To make the most of the agility possible with cloud computing, enterprises should evolve their architectures to take advantage of Azure capabilities. Microsoft Azure delivers hyperscale services and infrastructure, enterprise-grade capabilities and reliability, and many choices for hybrid connectivity. 

Customers can choose to access these cloud services either via the internet or with Azure ExpressRoute, which provides private network connectivity. With the Microsoft Azure platform, customers can seamlessly extend their infrastructure into the cloud and build multi-tier architectures. Microsoft partners also provide enhanced capabilities by offering security services and virtual appliances that are optimized to run in Azure.

This article provides an overview of patterns and designs that solve the architectural scale, performance, and security concerns many customers face when they think about moving en masse to the cloud. An overview of how to fit different organizational IT roles into the management and governance of the system is also discussed. Emphasis is on security requirements and cost optimization.

## What is a virtual datacenter?
Cloud solutions were first designed to host single, relatively isolated applications in the public spectrum. This approach worked well for a few years. Then the benefits of cloud solutions became apparent, and multiple large-scale workloads were hosted on the cloud. Addressing security, reliability, performance, and cost concerns of deployments in one or more regions became vital throughout the life cycle of the cloud service.

The following cloud deployment diagram shows an example of a security gap in the **red box**. The **yellow box** shows room for optimization network virtual appliances across workloads.

[![0]][0]

The virtual datacenter (VDC) was born from the necessity to scale to support enterprise workloads. It also deals with the problems introduced when supporting large-scale applications in the public cloud.

A VDC isn't just the application workloads in the cloud. It's also the network, security, management, and infrastructure. Examples are DNS and directory services. It usually provides a private connection back to an on-premises network or datacenter. As more and more workloads move to Azure, it's important to think about the supporting infrastructure and objects that these workloads are placed in. Think carefully about how resources are structured to avoid the proliferation of hundreds of **workload islands** that must be managed separately with independent data flow, security models, and compliance challenges.

A virtual datacenter is a collection of separate but related entities with common supporting functions, features, and infrastructure. By viewing your workloads as an integrated VDC, you can reduce costs from economies of scale and optimized security through component and data flow centralization. You also get easier operations, management, and compliance audits.

> [!NOTE]  
> It's important to understand that the VDC is **not** a discrete Azure product. It's the combination of various features and capabilities to  meet your exact requirements. A VDC is a way of thinking about your workloads and Azure usage to maximize your resources and abilities in the cloud. The virtual datacenter is therefore a modular approach on how to build up IT services in Azure, respecting organizational roles and responsibilities.

The VDC can help enterprises get workloads and applications into Azure for the following scenarios:

-   Host multiple related workloads.
-   Migrate workloads from an on-premises environment to Azure.
-   Implement shared or centralized security and access requirements across workloads.
-   Mix Azure DevOps and centralized IT appropriately for a large enterprise.

The key to unlock the advantages of a VDC is a centralized topology, hub and spokes, with a mix of Azure features: 

- [Azure Virtual Network][VNet]. 
- [Network security groups (NSGs)][NSG].
- [Virtual network peering][VNetPeering]. 
- [User-defined routes (UDRs)][UDR].
- Azure identity services with [role-based access control (RBAC)][RBAC]. 
- Optionally, [Azure Firewall][AzFW], [Azure DNS][DNS], [Azure Front Door][AFD], and [Azure Virtual WAN][vWAN].

## Who needs a virtual datacenter?
Any Azure customer that needs to move more than a few workloads into Azure can benefit from using common resources. Depending on the size, even single applications can benefit from using the patterns and components used to build a VDC.

If your organization has a centralized IT, network, security, or compliance team or department, a VDC can help enforce policy points and segregation of duty. It also ensures uniformity of the underlying common components while giving application teams as much freedom and control as is appropriate for your requirements.

Organizations that look to Azure DevOps can utilize the VDC concepts to provide authorized pockets of Azure resources and to ensure they have total control within that group. Groups are either subscriptions or resource groups in a common subscription. But the network and security boundaries stay compliant as defined by a centralized policy in a hub virtual network and resource group.

## Considerations when you implement a virtual datacenter
When you design a VDC, there are several pivotal issues to consider:

-   Identity and directory services.
-   Security infrastructure.
-   Connectivity to the cloud.
-   Connectivity within the cloud.

### Identity and directory services
Identity and directory services are a key aspect of all datacenters, both on-premises and in the cloud. Identity is related to all aspects of access and authorization to services within the VDC. To make sure that only authorized users and processes access your Azure account and resources, Azure uses several types of credentials for authentication. These include passwords to access the Azure account, cryptographic keys, digital signatures, and certificates. 

[Azure Multi-Factor Authentication][MFA] is an additional layer of security for accessing Azure services. It provides strong authentication with a range of easy verification options. Customers can choose the method they prefer. Options include a phone call, text message, or mobile app notification. 

Any large enterprise needs to define an identity management process that describes the management of individual identities and their authentication, authorization, roles, and privileges within or across the VDC. The goals of this process are to increase security and productivity while lowering cost, downtime, and repetitive manual tasks.

Enterprises and organizations can require a demanding mix of services for different lines of business (LOBs). And employees often have different roles when involved with different projects. A VDC requires good cooperation between different teams, each with specific role definitions, to get systems running with good governance. The matrix of responsibilities, access, and rights can be complex. Identity management in VDC is implemented through [Azure Active Directory (Azure AD)][AAD] and role-based access control (RBAC).

A directory service is a shared information infrastructure that locates, manages, administers, and organizes everyday items and network resources. These resources can include volumes, folders, files, printers, users, groups, devices, and other objects. Each resource on the network is considered an object by the directory server. Information about a resource is stored as a collection of attributes associated with that resource or object.

All Microsoft online business services rely on Azure Active Directory (Azure AD) for sign-in and other identity needs. Azure Active Directory is a comprehensive, highly available identity and access management cloud solution that combines core directory services, advanced identity governance, and application access management. Azure AD can integrate with on-premises Active Directory to enable single sign-on for all cloud-based and locally hosted on-premises applications. The user attributes of on-premises Active Directory can be automatically synchronized to Azure AD.

A single global administrator isn't required to assign all permissions in a VDC. Instead, each specific department or group of users or services in the directory service can have the permissions that are required to manage their own resources within a VDC. Structuring permissions requires balancing. Too many permissions impede performance efficiency. Too few or loose permissions increase security risks. Azure role-based access control (RBAC) helps address this problem by offering fine-grained access management for VDC resources.

#### Security infrastructure
In the context of a VDC, security infrastructure mainly relates to traffic segregation in the VDC's specific virtual network segment and how to control ingress and egress flows throughout the VDC. Azure is based on multi-tenant architecture that prevents unauthorized and unintentional traffic between deployments. It uses virtual network isolation, access control lists (ACLs), load balancers, IP filters, and traffic flow policies. Network address translation (NAT) separates internal network traffic from external traffic.

The Azure fabric allocates infrastructure resources to tenant workloads and manages communications to and from virtual machines (VMs). The Azure hypervisor enforces memory and process separation between VMs and securely routes network traffic to guest OS tenants.

#### Connectivity to the cloud
The VDC needs connectivity with external networks to offer services to customers, partners, and internal users. It usually needs connectivity not only to the internet but also to on-premises networks and datacenters.

Customers can build their security policies to control what and how specific VDC-hosted services are accessible to or from the internet with [Azure Firewall][AzFW] or network virtual appliances, custom routing policies, and network filtering. See information on [user-defined routes][UDR] and [network security groups][NSG]. We recommend that all internet-facing resources be additionally protected by [Azure DDoS Protection Standard][DDOS].

Enterprises often need to connect VDCs to on-premises datacenters or other resources. So the connectivity between Azure and on-premises networks is a crucial aspect when designing an effective architecture. Enterprises have two different ways to create interconnections between VDCs and on-premises in Azure: transit over the internet or private direct connections.

An [Azure site-to-site VPN][VPN] is an interconnection service over the internet between on-premises networks and the VDC. It's established through secure encrypted connections, IPsec/IKE tunnels. An Azure site-to-site connection is flexible and quick to create. This VPN doesn't require any further procurement as all connections connect over the internet.

For large numbers of VPN connections, [Azure Virtual WAN][vWAN] is a networking service that provides optimized and automated branch-to-branch connectivity through Azure. With Virtual WAN, you can connect and configure branch devices to communicate with Azure. This connection can be done either manually or by using preferred provider devices through a Virtual WAN partner. Preferred provider devices give you ease of use, simplification of connectivity, and configuration management. The Azure WAN built-in dashboard provides instant troubleshooting insights that can save you time. And the dashboard gives you an easy way to view large-scale site-to-site connectivity.

With [ExpressRoute][ExR], an Azure connectivity service, you can create private connections between the VDC and on-premises networks. ExpressRoute connections don't go over the public internet. They offer higher security, reliability, and higher speeds, up to 10 Gbps, along with consistent latency. ExpressRoute is useful for VDCs as ExpressRoute customers get the benefits of compliance rules associated with private connections. [ExpressRoute Direct][ExRD] connects you directly to Microsoft routers at 100 Gbps for customers with larger bandwidth needs.

Deploying ExpressRoute connections usually involves engaging with an ExpressRoute service provider. For customers that need to start quickly, it's common to initially use a site-to-site VPN to establish connectivity between the VDC and on-premises resources. Then migrate to ExpressRoute connection when your physical interconnection with your service provider is finished.

#### Connectivity within the cloud
[Virtual networks][VNet] and [virtual network peering][VNetPeering] are the basic networking connectivity services inside a VDC. A virtual network guarantees a natural boundary of isolation for VDC resources. And virtual network peering allows intercommunication between different virtual networks in the same Azure region or even across regions. Traffic control inside a virtual network and between virtual networks needs to match a set of security rules specified through access control lists. See information on [network security groups][NSG], [network virtual appliances (NVAs)][NVA], and [custom routing tables for user-defined routes][UDR].

## Virtual datacenter overview

### Topology
**Hub and spokes** is a model for extending a virtual datacenter within a single Azure region.

[![1]][1]

The hub is the central zone that controls and inspects ingress or egress traffic between different zones: internet, on-premises, and the spokes. The hub and spoke topology gives the IT department an effective way to enforce security policies in a central location. It also reduces the potential for misconfiguration and exposure.

The hub contains the common service components consumed by the spokes. The following examples are common central services:

-   The Windows Active Directory infrastructure, required for user authentication of third parties that access from untrusted networks before they get access to the workloads in the spoke. It includes the related Active Directory Federation Services (AD FS).
-   A DNS service to resolve naming for the workload in the spokes, to access resources on-premises and on the internet if [Azure DNS][DNS] isn't used.
-   A public key infrastructure (PKI), to implement single sign-on on workloads.
-   Flow control (TCP, UDP) between the spokes and internet.
-   Flow control between the spokes and on-premises.
-   If needed, flow control between one spoke and another.

The VDC reduces overall cost by using the shared hub infrastructure between multiple spokes.

The role of each spoke can be to host different types of workloads. The spokes also provide a modular approach for repeatable deployments of the same workloads. Examples are dev and test, user acceptance testing, preproduction, and production. The spokes can also segregate and enable different groups within your organization. An example is Azure DevOps groups. Inside a spoke, it's possible to deploy a basic workload or complex multi-tier workloads with traffic control between the tiers.

#### Subscription limits and multiple hubs
In Azure, every component, whatever the type, is deployed in an Azure subscription. The isolation of Azure components in different Azure subscriptions can satisfy the requirements of different lines of business. An example is setting up differentiated levels of access and authorization.

A single VDC can scale up to a large number of spokes. But as with every IT system, there are platforms limits. The hub deployment is bound to a specific Azure subscription, which has restrictions and limits. An example is a maximum number of virtual network peerings. For details, see [Azure subscription and service limits, quotas, and constraints][Limits]. In cases where limits might be an issue, the architecture can scale up further. Extend the model from a single hub-spokes to a cluster of hub and spokes. Interconnect multiple hubs in one or more Azure regions by using virtual network peering, ExpressRoute, Virtual WAN, or a site-to-site VPN.

[![2]][2]

The introduction of multiple hubs increases the cost and management effort of the system. It would only be justified by scalability like system limits or redundancy and regional replication like end-user performance or disaster recovery. In scenarios requiring multiple hubs, all the hubs should strive to offer the same set of services for operational ease.

#### Interconnection between spokes
Inside a single spoke, it's possible to implement complex multi-tier workloads. You can implement multi-tier configurations by using one subnet for every tier in the same virtual network. Filter the flows by using NSGs.

An architect might want to deploy a multi-tier workload across multiple virtual networks. With virtual network peering, spokes can connect to other spokes in the same hub or different hubs. A typical example of this scenario is the case where application processing servers are in one spoke, or virtual network. The database deploys in a different spoke, or virtual network. In this case, it's easy to interconnect the spokes with virtual network peering and thereby avoid transiting through the hub. A careful architecture and security review should be performed to ensure that bypassing the hub doesn’t bypass important security or auditing points that might exist only in the hub.

[![3]][3]

Spokes can also be interconnected to a spoke that acts as a hub. This approach creates a two-level hierarchy: the spokes in the higher level, level 0, become the hub of lower spokes, level 1, of the hierarchy. The spokes of a VDC need to forward the traffic to the central hub to reach out either to the on-premises network or internet. An architecture with two levels of hub introduces complex routing that removes the benefits of a simple hub-spoke relationship.

Although Azure allows complex topologies, one of the core principles of the VDC concept is repeatability and simplicity. To minimize management effort, the simple hub-spoke design is the VDC reference architecture that we recommend.

### Components
A virtual datacenter is made up of four basic component types: **Infrastructure**, **Perimeter Networks**, **Workloads**, and **Monitoring**.

Each component type consists of various Azure features and resources. Your VDC is made up of instances of multiple component types and multiple variations of the same component type. For instance, you might have many different, logically separated workload instances that represent different applications. You use these different component types and instances to ultimately build the VDC.

[![4]][4]

The preceding high-level architecture of a VDC shows different component types used in different zones of the hub-spokes topology. The diagram shows infrastructure components in various parts of the architecture.

As a good practice for an on-premises datacenter or VDC, access rights and privileges should be group based. Deal with groups instead of individual users to maintain access policies consistently across teams and minimize configuration errors. Assign and remove users to and from appropriate groups to keep the privileges of a specific user up to date.

Each role group should have a unique prefix on their names. This prefix makes it easy to identify which group is associated with which workload. For example, a workload hosting an authentication service might have groups named **AuthServiceNetOps**, **AuthServiceSecOps**, **AuthServiceDevOps**, and **AuthServiceInfraOps**. Centralized roles, or roles not related to a specific service, might be prefaced with **Corp**. An example is **CorpNetOps**.

Many organizations use a variation of the following groups to provide a major breakdown of roles:

-   The central IT group, **Corp,** has the ownership rights to control infrastructure components. Examples are networking and security. The group needs to have the role of contributor on the subscription, control of the hub, and network contributor rights in the spokes. Large organizations frequently split up these management responsibilities between multiple teams. Examples are a network operations **CorpNetOps** group with exclusive focus on networking and a security operations **CorpSecOps** group responsible for the firewall and security policy. In this specific case, two different groups need to be created for assignment of these custom roles.
-   The dev-test group, **AppDevOps,** has the responsibility to deploy app or service workloads. This group takes the role of virtual machine contributor for IaaS deployments or one or more PaaS contributor’s roles. See [Built-in roles for Azure resources][Roles]. Optionally, the dev-test team might need visibility on security policies, NSGs, and routing policies, UDRs, inside the hub or a specific spoke. In addition to the role of contributor for workloads, this group would also need the role of network reader.
-   The operation and maintenance group, **CorpInfraOps** or **AppInfraOps,** has the responsibility of managing workloads in production. This group needs to be a subscription contributor on workloads in any production subscriptions. Some organizations might also evaluate if they need an additional escalation support team group with the role of subscription contributor in production and the central hub subscription. The additional group fixes potential configuration issues in the production environment.

A VDC is structured so that groups created for the central IT groups that manage the hub have corresponding groups at the workload level. In addition to managing hub resources, only the central IT groups would control external access and top-level permissions on the subscription. However, workload groups would control resources and permissions of their virtual network independently on the central IT.

Partition the VDC to securely host multiple projects across different lines of business. All projects require different isolated environments, such as dev, UAT, and production. Separate Azure subscriptions for each of these environments provide natural isolation.

[![5]][5]

The preceding diagram shows the relationship between an organization's projects, users, and groups and the environments where the Azure components are deployed.

Typically in IT, an environment or tier is a system in which multiple applications are deployed and run. Large enterprises use a development environment to make and test changes and a production environment that end users use. Those environments are separated, often with several staging environments in between them to allow phased deployment (rollout), testing, and rollback if there are problems. Deployment architectures vary significantly but usually still follow the basic process that starts at development, **DEV**, and ends at production, **PROD**.

A common architecture for these types of multi-tier environments consists of Azure DevOps for development and testing, UAT for staging, and production environments. Organizations can leverage single or multiple Azure AD tenants to define access and rights to these environments. The previous diagram shows a case where two different Azure AD tenants are used: one for Azure DevOps and UAT, and the other exclusively for production.

The presence of different Azure AD tenants enforces the separation between environments. The same group of users, such as the central IT, needs to authenticate by using a different URI to access a different Azure AD tenant to modify the roles or permissions of either the Azure DevOps or production environments of a project. The presence of different user authentications to access different environments reduces possible outages and other issues caused by human errors.

#### Component type: Infrastructure
This component type is where most of the supporting infrastructure resides. It's also where your centralized IT, security, and compliance teams spend most of their time.

[![6]][6]

Infrastructure components provide an interconnection between the different components of a VDC. They're present in both the hub and the spokes. The responsibility for managing and maintaining the infrastructure components is typically assigned to the central IT or security team.

One of the primary tasks of the IT infrastructure team is to guarantee the consistency of IP address schemas across the enterprise. The private IP address space assigned to the VDC needs to be consistent. It can't overlap with private IP addresses assigned on your on-premises networks.

NAT on the on-premises edge routers or in Azure environments can avoid IP address conflicts. But it adds complications to your infrastructure components. Simplicity of management is one of the key goals of a VDC. So using NAT to handle IP concerns isn't a solution that we recommend.

Infrastructure components have the following functionality:

-   [**Identity and directory services**][AAD]. Access to every resource type in Azure is controlled by an identity stored in a directory service. The directory service stores the users list and the access rights to resources in a specific Azure subscription. These services can exist in the cloud only. Or they can be synchronized with an on-premises identity stored in Azure Active Directory.
-   [**Virtual network**][VPN]. Virtual networks are one of main components of a VDC. By using virtual networks, you can create a traffic isolation boundary on the Azure platform. A virtual network is composed of single or multiple virtual network segments. Each has a specific IP network prefix, a subnet. The virtual network defines an internal perimeter area where IaaS virtual machines and PaaS services can establish private communications. VMs and PaaS services in one virtual network can't communicate directly to VMs and PaaS services in a different virtual network. This isolation occurs even if the same customer creates both virtual networks under the same subscription. Isolation is a critical property that ensures customer VMs and communication stay private within a virtual network.
-   [**UDR**][UDR]. Traffic in a virtual network is routed by default based on the system routing table. A user-defined route is a custom routing table that network administrators can associate to one or more subnets. This association overwrites the behavior of the system routing table and defines a communication path within a virtual network. The presence of UDRs guarantees that egress traffic from the spoke transits through specific custom VMs or network virtual appliances and load balancers present in the hub and in the spokes.
-   [**NSG**][NSG]. A network security group is a list of security rules that acts as traffic filtering on IP sources, IP destinations, protocols, IP source ports, and IP destination ports. The NSG can apply to a subnet, a virtual NIC card associated with an Azure VM, or both. NSGs are essential to implement a correct flow control in the hub and in the spokes. The level of security afforded by the NSG is a function of which ports you open and for what purpose. Customers should apply additional per VM filters with host-based firewalls such as IPtables or the Windows Firewall.
-   [**DNS**][DNS]. The name resolution of resources in the virtual networks of a VDC is provided through the DNS. Azure provides DNS services for both [public][DNS] and [private][PrivateDNS] name resolution. Private zones provide name resolution both within a virtual network and across virtual networks. You can have private zones that span across virtual networks in the same region and also across regions and subscriptions. For public resolution, Azure DNS provides a hosting service for DNS domains. It provides name resolution by using Microsoft Azure infrastructure. By hosting your domains in Azure, you can manage your DNS records by using the same credentials, APIs, tools, and billing as your other Azure services.
-   [**Subscription**][SubMgmt] and [**resource group management**][RGMgmt]. A subscription defines a natural boundary to create multiple groups of resources in Azure. Resources in a subscription are assembled together in logical containers named **resource groups**. The resource group represents a logical group to organize the resources of a VDC.
-   [**RBAC**][RBAC]. Through RBAC, it's possible to map organizational roles along with rights to access specific Azure resources, which allows you to restrict users to only a certain subset of actions. With RBAC, you can grant access by assigning the appropriate role to users, groups, and applications within the relevant scope. The scope of a role assignment can be an Azure subscription, a resource group, or a single resource. RBAC allows inheritance of permissions. A role assigned at a parent scope also grants access to the children within it. With RBAC, you can segregate duties and grant only the amount of access to users that they need to do their jobs. For example, use RBAC so one employee can manage virtual machines in a subscription. Another can manage SQL databases within the same subscription.
-   [**Virtual network peering**][VNetPeering]. The fundamental feature used to create the infrastructure of a VDC is virtual network peering. It's a mechanism that connects two virtual networks in the same region through the Azure datacenter network or by using the Azure worldwide backbone across regions.

#### Component type: Perimeter networks
With [perimeter network][DMZ] components, or a DMZ network, you can provide network connectivity with your on-premises or physical datacenter networks, along with any connectivity to and from the internet. It's also where your network and security teams likely spend most of their time.

Incoming packets should flow through the security appliances in the hub before reaching the back-end servers in the spokes. Examples are the firewall, IDS, and IPS. Before they leave the network, internet-bound packets from the workloads should also flow through the security appliances in the perimeter network. The purposes of this flow are policy enforcement, inspection, and auditing.

Perimeter network components provide the following features:

-   [Virtual networks][VNet], [UDRs][UDR], and [NSGs][NSG]
-   [Network virtual appliances][NVA]
-   [Azure Load Balancer][ALB]
-   [Azure Application Gateway][AppGW] and [web application firewall (WAF)][WAF]
-   [Public IPs][PIP]
-   [Azure Front Door][AFD]
-   [Azure Firewall][AzFW]

Usually, the central IT and security teams have responsibility for requirement definition and operation of the perimeter networks.

[![7]][7]

The preceding diagram shows the enforcement of two perimeters with access to the internet and an on-premises network. Both are resident in the DMZ and vWAN hubs. In the DMZ hub, the perimeter network to the internet can scale up to support large numbers of lines of business by using multiple farms of web application firewall (WAF) or Azure Firewall instances. In the vWAN hub, highly scalable branch-to-branch and branch-to-Azure connectivity is accomplished via a VPN or ExpressRoute as needed.

[**Virtual networks**][VNet]. The hub is typically built on a virtual network with multiple subnets to host the different types of services that filter and inspect traffic to or from the internet via NVAs, WAF, and Azure Application Gateway instances.

[**UDRs**][UDR]. With UDRs, customers can deploy firewalls, IDSs or IPSs, and other virtual appliances. They can route network traffic through these security appliances for security boundary policy enforcement, auditing, and inspection. You can create UDRs in both the hub and the spokes. They guarantee that traffic transits through the specific custom VMs, network virtual appliances, and load balancers used by the VDC. To make sure that traffic generated from VMs resident in the spoke transits to the correct virtual appliances, set a UDR in the subnets of the spoke. Set the front-end IP address of the internal load balancer as the next hop. The internal load balancer distributes the internal traffic to the virtual appliances, or load balancer back-end pool.

[**Azure Firewall**][AzFW] is a managed, cloud-based network security service that protects your Azure Virtual Network resources. It's a fully stateful firewall as a service with built-in high availability and unrestricted cloud scalability. You can centrally create, enforce, and log application and network connectivity policies across subscriptions and virtual networks. Azure Firewall uses a static public IP address for your virtual network resources. It allows outside firewalls to identify traffic that originates from your virtual network. The service is fully integrated with Azure Monitor for logging and analytics.

[**Network virtual appliances**][NVA]. In the hub, the perimeter network with access to the internet is normally managed through an Azure Firewall instance or a farm of firewalls or web application firewall (WAF).

Different LOBs commonly use many web applications, and these applications tend to suffer from various vulnerabilities and potential exploits. Web application firewall is a special type of product that detects attacks against web applications, HTTP or HTTPS, in more depth than a generic firewall. Compared with tradition firewall technology, WAF has a set of specific features to protect internal web servers from threats.

An Azure Firewall instance or NVA firewall farms use a common administration plane. A set of security rules protects the workloads that are hosted in the spokes and controls access to on-premises networks. Azure Firewall has scalability built in, whereas NVA firewalls can be manually scaled behind a load balancer. Generally, a firewall farm has less specialized software compared to WAF. But it has a broader application scope to filter and inspect any type of traffic in egress and ingress. If an NVA approach is used, they can be found and deployed from the Azure Marketplace.

We recommend that you use one set of Azure Firewall instances, or NVAs, for traffic originating on the internet. Use another for traffic originating on-premises. Using only one set of firewalls for both is a security risk as it provides no security perimeter between the two sets of network traffic. Using separate firewall layers reduces the complexity of checking security rules and makes it clear which rules correspond to which incoming network request.

Most large enterprises manage multiple domains. [Azure DNS][DNS] can be used to host the DNS records for a particular domain. For example, the virtual IP (VIP) address of the Azure external load balancer, or WAF, can be registered in the **A** record of an Azure DNS record. [**Private DNSs**][PrivateDNS] are also available for managing the private address spaces inside virtual networks.

[**Azure Load Balancer**][ALB] offers a high-availability Layer 4, TCP or UDP, service. It can distribute incoming traffic among service instances defined in a load-balanced set. Traffic sent to the load balancer from front-end endpoints, public or private IP, can be redistributed with or without address translation to a set of back-end IP address pools. Examples are network virtual appliances or VMs.

Azure Load Balancer can probe the health of the various server instances as well. When a probe fails to respond, the load balancer stops sending traffic to the unhealthy instance. In a VDC, an external load balancer in the hub balances the traffic to NVAs, for example. In the spokes, it does tasks like balancing traffic between different VMs of a multi-tier application.

[**Azure Front Door**][AFD] is Microsoft's highly available and scalable web application acceleration platform, global HTTP load balancer, application protection, and content delivery network. Front Door runs in more than 100 locations at the edge of Microsoft's global network. By using Front Door, you can build, operate, and scale out your dynamic web applications and static content. Front Door provides your application the following benefits: 
* World-class end-user performance.
* Unified regional or stamp maintenance automation.
* BCDR automation.
* Unified client or user information. 
* Caching. 
* Service insights. 
The platform offers performance, reliability and support SLAs, compliance certifications, and auditable security practices that are developed, operated, and supported natively by Azure.

[**Application Gateway**][AppGW] is a dedicated virtual appliance that provides application delivery controller (ADC) as a service, offering various layer 7 load-balancing capabilities for your application. You can optimize web farm productivity by offloading CPU-intensive SSL termination to the Application Gateway instance. It also provides other layer 7 routing capabilities that include the following examples: 
* Round robin distribution of incoming traffic. 
* Cookie-based session affinity. 
* URL path-based routing. 
* The ability to host multiple websites behind a single Application Gateway instance. 
Web application firewall (WAF) is also provided as part of the Application Gateway WAF SKU. This SKU provides protection to web applications from common web vulnerabilities and exploits. Application Gateway can be configured as an internet-facing gateway, an internal-only gateway, or a combination of both. 

[**Public IPs**][PIP]. With some Azure features, you can associate service endpoints to a public IP address, so that your resource can be accessed from the internet. This endpoint uses network address translation (NAT) to route traffic to the internal address and port on the Azure virtual network. This path is the primary way for external traffic to pass into the virtual network. You can configure public IP addresses to determine which traffic is passed in and how and where it's translated onto the virtual network.

[**Azure DDoS Protection Standard**][DDOS] provides additional mitigation capabilities over the [Basic service][DDOS] tier that are tuned specifically to Azure Virtual Network resources. DDoS Protection Standard is simple to enable and requires no application changes. Protection policies are tuned through dedicated traffic monitoring and machine learning algorithms. Policies are applied to public IP addresses associated to resources deployed in virtual networks. Examples are Azure Load Balancer, Azure Application Gateway, and Azure Service Fabric instances. Real-time telemetry is available through Azure Monitor views during an attack and for history. Application layer protection can be added through the Azure Application Gateway web application firewall. Protection is provided for IPv4 Azure public IP addresses.

#### Component type: Monitoring
Monitoring components provide visibility and alerting from all the other components types. All teams should have access to monitoring for the components and services they have access to. If you have a centralized help desk or operation teams, they would need to have integrated access to the data provided by these components.

Azure offers different types of logging and monitoring services to track the behavior of Azure-hosted resources. Governance and control of workloads in Azure is based not just on collecting log data but also on the ability to trigger actions based on specific reported events.

[**Azure Monitor**][Monitor]. Azure includes multiple services that individually perform a specific role or task in the monitoring space. Together, these services deliver a comprehensive solution for collecting, analyzing, and acting on telemetry from your application and the Azure resources that support them. They can also work to monitor critical on-premises resources in order to provide a hybrid monitoring environment. Understanding the tools and data that are available is the first step in developing a complete monitoring strategy for your application.

There are two major types of logs in Azure:

-   The [Azure Activity Log][ActLog], previously called **Operational Logs**, provides insight into the operations that were performed on resources in the Azure subscription. These logs report the control-plane events for your subscriptions. Every Azure resource produces audit logs.

-   [Azure Monitor diagnostic logs][DiagLog] are logs generated by a resource that provides rich, frequent data about the operation of that resource. The content of these logs varies by resource type.

[![9]][9]

In a VDC, it's important to track the NSG logs, particularly this information:

-   [Event logs][NSGLog] provide information on what NSG rules are applied to VMs and instance roles based on MAC address.
-   [Counter logs][NSGLog] track how many times each NSG rule was run to deny or allow traffic.

All logs can be stored in Azure storage accounts for audit, static analysis, or backup purposes. When you store the logs in an Azure storage account, customers can use different types of frameworks to retrieve, prep, analyze, and visualize this data to report the status and health of cloud resources. 

Large enterprises should already have acquired a standard framework for monitoring on-premises systems. They can extend that framework to integrate logs generated by cloud deployments. By using [Azure Log Analytics][../log-analytics/log-analytics-overview.md], organizations can keep all the logging in the cloud. Log Analytics is implemented as a cloud-based service. So you have it up and running quickly with minimal investment in infrastructure services. Log Analytics also integrate with System Center components such as System Center Operations Manager to extend your existing management investments into the cloud. 

Log Analytics is a service in Azure that helps collect, correlate, search, and act on log and performance data generated by operating systems, applications, and infrastructure cloud components. It gives customers real-time operational insights by using integrated search and custom dashboards to analyze all the records across all your workloads in a VDC.

[Azure Network Watcher][NetWatch] provides tools to monitor, diagnose, and view metrics and enable or disable logs for resources in an Azure virtual network. It's a multifaceted service that allows the following functionalities and more:
-    Monitor communication between a virtual machine and an endpoint.
-    View resources in a virtual network and their relationships.
-    Diagnose network traffic filtering problems to or from a VM.
-    Diagnose network routing problems from a VM.
-    Diagnose outbound connections from a VM.
-    Capture packets to and from a VM.
-    Diagnose problems with an Azure virtual network gateway and connections.
-    Determine relative latencies between Azure regions and internet service providers.
-    View security rules for a network interface.
-    View network metrics.
-    Analyze traffic to or from a network security group.
-    View diagnostic logs for network resources.

The [Network Performance Monitor][NPM] solution inside Operations Management Suite can provide detailed network information end to end. This information includes a single view of your Azure networks and on-premises networks. The solution has specific monitors for ExpressRoute and public services.

#### Component type: Workloads
Workload components are where your actual applications and services reside. It's also where your application development teams spend most of their time.

The workload possibilities are endless. The following are just a few of the possible workload types:

**Internal LOB applications**. Line-of-business applications are computer applications critical to the ongoing operation of an enterprise. LOB applications have some common characteristics:

-   **Interactive**. LOB applications are interactive by nature. Data is entered, and results or reports are returned.
-   **Data driven**. LOB applications are data intensive with frequent access to databases or other storage.
-   **Integrated**. LOB applications offer integration with other systems within or outside the organization.

**Customer-facing websites (internet or internal facing)**. Most applications that interact with the internet are websites. Azure offers the ability to run a website on an IaaS VM or from a [Web Apps feature of Microsoft Azure App Service][WebApps] site (PaaS). Web Apps supports integration with virtual networks that allow the deployment of Web Apps in the spoke of a VDC. When looking at internal-facing websites, with virtual network integration, you don't need to expose an internet endpoint for your applications. But you can use the resources via private non-internet routable addresses from your private virtual network instead.

**Big data and analytics**. When data needs to scale up to a large volume, databases might not scale up properly. Apache Hadoop technology offers a system to run distributed queries in parallel on a large number of nodes. Customers can run data workloads in IaaS VMs or PaaS, [Azure HDInsight][HDI]. HDInsight supports deploying into a location-based virtual network. It can be deployed to a cluster in a spoke of the VDC.

**Events and messaging**. [Azure Event Hubs][EventHubs] is a hyperscale telemetry-ingestion service that collects, transforms, and stores millions of events. As a distributed streaming platform, it offers low latency and configurable time retention. So you can ingest massive amounts of telemetry into Azure and read that data from multiple applications. With Event Hubs, a single stream can support both real-time and batch-based pipelines.

You can implement a highly reliable cloud messaging service between applications and services through [Azure Service Bus][ServiceBus]. It offers asynchronous brokered messaging between client and server, along with structured first-in-first-out (FIFO) messaging and publishes and subscribe capabilities.

[![10]][10]

### Multiple VDCs
So far, this article has focused on a single VDC, describing the basic components and architecture that contribute to a resilient VDC. Azure features like Load Balancer, NVAs, availability sets, scale sets, and other mechanisms contribute to a system that allows you to build solid SLA levels into your production services.

However, a single VDC is hosted within a single region. It's vulnerable to a major outage that might affect that entire region. Customers that want to achieve high SLAs need to protect the services through deployments of the same project in two or more VDCs, placed in different regions.

In addition to SLA concerns, there are several common scenarios where deploying multiple VDCs makes sense:

-   Regional or global presence.
-   Disaster recovery.
-   A mechanism to divert traffic between datacenters.

#### Regional and global presence
Azure datacenters are present in many regions worldwide. When they select multiple Azure datacenters, customers need to consider two related factors: geographical distances and latency. To offer the best user experience, customers need to evaluate the geographical distance between the VDCs and the distance between the VDC and the end users.

The Azure region where VDCs are hosted also needs to conform with regulatory requirements established by any legal jurisdiction under which your organization operates.

#### Disaster recovery
The implementation of a disaster recovery plan is related to the type of workload concerned and the ability to synchronize the workload state between different VDCs. Ideally, most customers want to synchronize application data between deployments that run in two different VDCs to implement a fast fail-over mechanism. Most applications are sensitive to latency, and that can cause potential timeout and delay in data synchronization.

Synchronization or heartbeat monitoring of applications in different VDCs requires communication between them. Two VDCs in different regions can be connected as follows:

-   Virtual network peering can connect hubs across regions.
-   ExpressRoute private peering when the VDC hubs are connected to the same ExpressRoute circuit.
-   Multiple ExpressRoute circuits connected via your corporate backbone and your VDC mesh connected to the ExpressRoute circuits.
-   Site-to-site VPN connections between your VDC hubs in each Azure region.

Usually, virtual network peering or ExpressRoute connections are the preferred mechanism because of higher bandwidth and consistent latency when transiting through the Microsoft backbone.

There's no magic recipe to validate an application distributed between two or more different VDCs located in different regions. Customers should run network qualification tests to verify the latency and bandwidth of the connections. Then target whether synchronous or asynchronous data replication is appropriate and what the optimal recovery time objective (RTO) can be for your workloads.

#### Mechanism to divert traffic between datacenters
One effective technique to divert the traffic incoming in one datacenter to another is based on the Domain Name System (DNS). [Azure Traffic Manager][TM] uses the DNS mechanism to direct end-user traffic to the most appropriate public endpoint in a specific VDC. Through probes, Traffic Manager periodically checks the service health of public endpoints in different VDCs. If those endpoints fail, it routes automatically to the secondary VDC.

Traffic Manager works on Azure public endpoints. For example, it can control or divert traffic to Azure VMs and Web Apps in the appropriate VDC. Traffic Manager is resilient even in the face of an entire Azure region failing. It can control the distribution of user traffic for service endpoints in different VDCs based on several criteria. Examples are service failure in a specific VDC or selecting the VDC with the lowest network latency for the client.

### Conclusion
The virtual datacenter is an approach to datacenter migration into the cloud that uses a combination of features and capabilities to create a scalable architecture in Azure. It maximizes cloud resource use, reduces costs, and simplifies system governance. The VDC concept is based on a hub-spokes topology that provides common shared services in the hub. It allows specific applications or workloads in the spokes. A VDC matches the structure of company roles, where different departments work together. Examples are the central IT, Azure DevOps, and operations and maintenance. Each department has a specific list of roles and duties. A VDC satisfies the requirements for a **lift and shift** migration. But it also provides many advantages to native cloud deployments.

## References
Learn more about the following features discussed in this article:

| | | |
|-|-|-|
|Network features|Load balancing|Connectivity|
|[Azure Virtual Network][VNet]</br>[Network security groups][NSG]</br>[NSG logs][NSGLog]</br>[User-defined routes][UDR]</br>[Network virtual appliances][NVA]</br>[Public IP addresses][PIP]</br>[Azure DDoS Protection][DDOS]</br>[Azure Firewall][AzFW]</br>[Azure DNS][DNS]|[Azure Front Door][AFD]</br>[Azure Load Balancer (L3)][ALB]</br>[Application Gateway (L7)][AppGW]</br>[Web application firewall][WAF]</br>[Azure Traffic Manager][TM]</br></br></br></br></br> |[Virtual network peering][VNetPeering]</br>[Virtual private network][VPN]</br>[Virtual WAN][vWAN]</br>[ExpressRoute][ExR]</br>[ExpressRoute Direct][ExRD]</br></br></br></br></br>
|Identity</br>|Monitoring</br>|Best practices</br>|
|[Azure Active Directory][AAD]</br>[Multi-Factor Authentication][MFA]</br>[Role-based access control][RBAC]</br>[Default Azure AD roles][Roles]</br></br></br> |[Network Watcher][NetWatch]</br>[Azure Monitor][Monitor]</br>[Activity Log][ActLog]</br>[Monitor diagnostic logs][DiagLog]</br>[Microsoft Operations Management Suite][OMS]</br>[Network Performance Monitor][NPM]|[Perimeter network best practices][DMZ]</br>[Subscription management][SubMgmt]</br>[Resource group management][RGMgmt]</br>[Azure subscription limits][Limits] </br></br></br>|
|Other Azure services|
|[Web Apps][WebApps]</br>[HDInsight (Hadoop)][HDI]</br>[Event Hubs][EventHubs]</br>[Service Bus][ServiceBus]|

## Next steps
 - Explore [virtual network peering][VNetPeering], the underpinning technology for VDC hub and spoke designs.
 - Implement [Azure AD][AAD] to get started with [RBAC][RBAC] exploration.
 - Develop a subscription and resource management model and an RBAC model to meet the structure, requirements, and policies of your organization. The most important activity is planning. As much as practical, plan for reorganizations, mergers, new product lines, and other possibilities.

<!--Image References-->
[0]: ./images/networking-redundant-equipment.png "Examples of component overlap" 
[1]: ./images/networking-vdc-high-level.png "High-level example of hub and spoke VDC"
[2]: ./images/networking-hub-spokes-cluster.png "Cluster of hubs and spokes"
[3]: ./images/networking-spoke-to-spoke.png "Spoke-to-spoke"
[4]: ./images/networking-vdc-block-level-diagram.png "Block level diagram of the VDC"
[5]: ./images/networking-users-groups-subsciptions.png "Users, groups, subscriptions, and projects"
[6]: ./images/networking-infrastructure-high-level.png "High-level infrastructure diagram"
[7]: ./images/networking-highlevel-perimeter-networks.png "High-level infrastructure diagram"
[8]: ./images/networking-vnet-peering-perimeter-neworks.png "VNet Peering and perimeter networks"
[9]: ./images/networking-high-level-diagram-monitoring.png "High-Level diagram for Monitoring"
[10]: ./images/networking-high-level-workloads.png "High-level diagram for Workload"

<!--Link References-->
[Limits]: /azure/azure-subscription-service-limits
[Roles]: /azure/role-based-access-control/built-in-roles
[VNet]: /azure/virtual-network/virtual-networks-overview
[NSG]: /azure/virtual-network/virtual-networks-nsg
[DNS]: /azure/dns/dns-overview
[PrivateDNS]: /azure/dns/private-dns-overview
[VNetPeering]: /azure/virtual-network/virtual-network-peering-overview 
[UDR]: /azure/virtual-network/virtual-networks-udr-overview 
[RBAC]: /azure/role-based-access-control/overview
[MFA]: /azure/multi-factor-authentication/multi-factor-authentication
[AAD]: /azure/active-directory/active-directory-whatis
[VPN]: /azure/vpn-gateway/vpn-gateway-about-vpngateways 
[ExR]: /azure/expressroute/expressroute-introduction
[ExRD]: https://docs.microsoft.com/en-us/azure/expressroute/expressroute-erdirect-about
[vWAN]: /azure/virtual-wan/virtual-wan-about
[NVA]: /azure/architecture/reference-architectures/dmz/nva-ha
[AzFW]: /azure/firewall/overview
[SubMgmt]: /azure/architecture/cloud-adoption/appendix/azure-scaffold 
[RGMgmt]: /azure/azure-resource-manager/resource-group-overview
[DMZ]: /azure/best-practices-network-security
[ALB]: /azure/load-balancer/load-balancer-overview
[DDOS]: /azure/virtual-network/ddos-protection-overview
[PIP]: /azure/virtual-network/resource-groups-networking#public-ip-address
[AFD]: https://docs.microsoft.com/en-us/azure/frontdoor/front-door-overview
[AppGW]: /azure/application-gateway/application-gateway-introduction
[WAF]: /azure/application-gateway/application-gateway-web-application-firewall-overview
[Monitor]: /azure/monitoring-and-diagnostics/
[ActLog]: /azure/monitoring-and-diagnostics/monitoring-overview-activity-logs 
[DiagLog]: /azure/monitoring-and-diagnostics/monitoring-overview-of-diagnostic-logs
[NSGLog]: /azure/virtual-network/virtual-network-nsg-manage-log
[OMS]: /azure/operations-management-suite/operations-management-suite-overview
[NPM]: /azure/log-analytics/log-analytics-network-performance-monitor
[NetWatch]: /azure/network-watcher/network-watcher-monitoring-overview
[WebApps]: /azure/app-service/
[HDI]: /azure/hdinsight/hdinsight-hadoop-introduction
[EventHubs]: /azure/event-hubs/event-hubs-what-is-event-hubs 
[ServiceBus]: /azure/service-bus-messaging/service-bus-messaging-overview
[TM]: /azure/traffic-manager/traffic-manager-overview


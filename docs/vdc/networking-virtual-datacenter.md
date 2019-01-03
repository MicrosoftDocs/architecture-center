---
title: "Azure virtual datacenter: A network perspective"
description: Learn how to build your virtual datacenter in Azure
author: tracsman
manager: rossort
tags: azure-resource-manager

ms.service: virtual-network
ms.date: 11/28/2018
ms.author: jonor
---

# Azure virtual datacenter: A network perspective

## Overview

Migrating on-premises applications to Azure provides organizations the benefits of a secured and cost-efficient infrastructure, even if the applications are migrated with minimal changes. However, to make the most of the agility possible with cloud computing, enterprises must evolve their architectures to take advantage of Azure capabilities. 

Microsoft Azure delivers hyper-scale services and infrastructure with enterprise-grade capabilities and reliability. These services and infrastructure offer many choices in hybrid connectivity so customers can choose to access them over the public internet or over a private Azure ExpressRoute connection. Microsoft partners also provide enhanced capabilities by offering security services and virtual appliances that are optimized to run in Azure.

Customers can choose to access these cloud services either via the internet or with Azure ExpressRoute, which provides private network connectivity. With the Microsoft Azure platform, customers can seamlessly extend their infrastructure into the cloud and build multi-tier architectures. Microsoft partners also provide enhanced capabilities by offering security services and virtual appliances that are optimized to run in Azure.

## What is the Virtual datacenter?

At its inception, the cloud was essentially a platform for hosting public-facing applications. Enterprises began to understand the value of the cloud and began to move internal line-of-business applications to the cloud. These types of applications brought additional security, reliability, performance, and cost considerations that required additional flexibility in the way cloud services were delivered. This paved the way for new infrastructure and networking services designed to provide this flexibility but also new features for scale, disaster recovery, and other considerations.

## What is a virtual datacenter?
Cloud solutions were first designed to host single, relatively isolated applications in the public spectrum. This approach worked well for a few years. Then the benefits of cloud solutions became apparent, and multiple large-scale workloads were hosted on the cloud. Addressing security, reliability, performance, and cost concerns of deployments in one or more regions became vital throughout the life cycle of the cloud service.

The following cloud deployment diagram shows an example of a security gap in the **red box**. The **yellow box** shows room for optimization network virtual appliances across workloads.

[![0]][0]

The Virtual datacenter (VDC) is a concept born of the necessity for scaling to support enterprise workloads while balancing the need to deal with the problems introduced when supporting large-scale applications in the public cloud.

A VDC implementation does not just represent the application workloads in the cloud, but also the network, security, management, and infrastructure  (for example, DNS and Directory Services). As more and more of an enterprise's workloads move to Azure, it's important they think about the supporting infrastructure and objects these workloads are placed in. Thinking carefully about how resources are structured can avoid the proliferation of hundreds of "workload islands" that must be managed separately with independent data flow, security models, and compliance challenges.

The VDC concept is a set of recommendations and best practices for implementing a collection of separate but related entities with common supporting functions, features, and infrastructure. By viewing your workloads through the lens of the VDC, you can realize reduced cost due to economies of scale, optimized security through component and data flow centralization, along with easier operations, management, and compliance audits.

> [!NOTE]
> It's important to understand that the VDC is **NOT** a discrete Azure product, but the combination of various features and capabilities to meet your exact requirements. The VDC is a way of thinking about your workloads and Azure usage to maximize your resources and abilities in the cloud. It's a modular approach to building up IT services in Azure while respecting the enterprise's organizational roles and responsibilities.

A VDC implementation can help enterprises get workloads and applications into Azure for the following scenarios:

-   Host multiple related workloads.
-   Migrate workloads from an on-premises environment to Azure.
-   Implement shared or centralized security and access requirements across workloads.
-   Mix Azure DevOps and centralized IT appropriately for a large enterprise.

The key to unlock the advantages of VDC is a centralized hub and spoke network topology with a mix of Azure services and features:

* [Azure Virtual Network][VNet],
* [Network security groups][NSG],
* [Virtual network peering][VNetPeering],
* [User-Defined Routes (UDR)][UDR], and
* Azure Identity with [Role-Based Access Control (RBAC)][RBAC] and optionally [Azure Firewall][AzFW], [Azure DNS][DNS], [Azure Front Door][AFD], and [Azure Virtual WAN][vWAN].

## Who should implement a Virtual datacenter?

Any Azure customer that has decided to adopt the cloud can benefit from the efficiency of configuring a set of resources for common use by all applications. Depending on the magnitude, even single applications can benefit from using the patterns and components used to build a VDC implementation.

If your organization has a centralized IT, Network, Security, and/or Compliance team/department, implementing a VDC can help enforce policy points, segregation of duty, and ensure uniformity of the underlying common components while giving application teams as much freedom and control as is appropriate for your requirements.

Organizations that are looking to DevOps can also utilize the VDC concepts to provide authorized pockets of Azure resources and ensure they have total control within that group (either subscription or resource group in a common subscription), but the network and security boundaries stay compliant as defined by a centralized policy in a hub VNet and Resource Group.

## Considerations for Implementing a Virtual datacenter

When designing a VDC implementation, there are several pivotal issues to consider:

### Identity and Directory Service

Identity and Directory services are a key aspect of all datacenters, both on-premises and in the cloud. Identity is related to all aspects of access and authorization to services within a VDC implementation. To help ensure that only authorized users and processes access your Azure Account and resources, Azure uses several types of credentials for authentication. These include passwords (to access the Azure account), cryptographic keys, digital signatures, and certificates. [Azure Multi-Factor Authentication (MFA)][MFA] is an additional layer of security for accessing Azure services. Azure MFA provides strong authentication with a range of easy verification options — phone call, text message, or mobile app notification — and allow customers to choose the method they prefer.

Any large enterprise needs to define an identity management process that describes the management of individual identities, their authentication, authorization, roles, and privileges within or across their VDC implementation. The goals of this process should be to increase security and productivity while decreasing cost, downtime, and repetitive manual tasks.

Enterprise/organizations can require a demanding mix of services for different Line-of-Businesses (LOBs), and employees often have different roles when involved with different projects. The VDC requires good cooperation between different teams, each with specific role definitions, to get systems running with good governance. The matrix of responsibilities, access, and rights can be complex. Identity management in the VDC is implemented through [*Azure Active Directory* (Azure AD)][AAD] and Role-Based Access Control (RBAC).

A directory service is a shared information infrastructure that locates, manages, administers, and organizes everyday items and network resources. These resources can include volumes, folders, files, printers, users, groups, devices, and other objects. Each resource on the network is considered an object by the directory server. Information about a resource is stored as a collection of attributes associated with that resource or object.

All Microsoft online business services rely on Azure Active Directory (Azure AD) for sign-in and other identity needs. Azure Active Directory is a comprehensive, highly available identity and access management cloud solution that combines core directory services, advanced identity governance, and application access management. Azure AD can integrate with on-premises Active Directory to enable single sign-on for all cloud-based and locally hosted on-premises applications. The user attributes of on-premises Active Directory can be automatically synchronized to Azure AD.

A single global administrator is not required to assign all permissions in a VDC implementation. Instead, each specific department, group of users, or services in the Directory Service can have the permissions required to manage their own resources within a VDC implementation. Structuring permissions requires balancing. Too many permissions can impede performance efficiency, and too few or loose permissions can increase security risks. Azure Role-Based Access Control (RBAC) helps to address this problem, by offering fine-grained access management for resources in a VDC implementation.

#### Security infrastructure

Security infrastructure refers to the segregation of traffic in a VDC implementation's specific virtual network segment. This infrastructure specifies how ingress and egress is controlled in a VDC implementation. Azure is based on a multi-tenant architecture that prevents unauthorized and unintentional traffic between deployments by using Virtual Network (VNet) isolation, access control lists (ACLs), load balancers, IP filters, and traffic flow policies. Network address translation (NAT) separates internal network traffic from external traffic.

The Azure fabric allocates infrastructure resources to tenant workloads and manages communications to and from virtual machines (VMs). The Azure hypervisor enforces memory and process separation between VMs and securely routes network traffic to guest OS tenants.

#### Connectivity to the cloud

A VDC implementation requires connectivity to external networks to offer services to customers, partners and/or internal users. This need for connectivity refers not only to the Internet, but also to on-premises networks and datacenters.

Customers control which services have access to and are accessible from the public internet by using [Azure Firewall][AzFW] or other types of virtual network appliances (NVAs), custom routing policies by using [user-defined routes][UDR], and network filtering by using [network security groups][NSG]. We recommend that all internet-facing resources also be protected by the [Azure DDoS Protection Standard][DDOS].

Enterprises may need to connect their VDC implementation to on-premises datacenters or other resources. This connectivity between Azure and on-premises networks is a crucial aspect when designing an effective architecture. Enterprises have two different ways to create this interconnection: transit over the Internet and/or by private direct connections.

An [**Azure Site-to-Site VPN**][VPN] is an interconnection service over the Internet between on-premises networks and a VDC implementation, established through secure encrypted connections (IPsec/IKE tunnels). Azure Site-to-Site connection is flexible, quick to create, and does not require any further procurement, as all connections connect over the internet.

For large numbers of VPN connections, [**Azure Virtual WAN**][vWAN] is a networking service that provides optimized and automated branch-to-branch connectivity through Azure. Virtual WAN lets you connect and configure branch devices to communicate with Azure. Connecting and configuring can be done either manually, or by using preferred provider devices through a Virtual WAN partner. Using preferred provider devices allows ease of use, simplification of connectivity, and configuration management. The Azure WAN built-in dashboard provides instant troubleshooting insights that can help save you time, and gives you an easy way to view large-scale Site-to-Site connectivity.

[**ExpressRoute**][ExR] is an Azure connectivity service that enables private connections between a VDC implementation and any on-premises networks. ExpressRoute connections do not go over the public Internet, and offer higher security, reliability, and higher speeds (up to 10 Gbps) along with consistent latency. ExpressRoute is useful for VDC implementations, as ExpressRoute customers can get the benefits of compliance rules associated with private connections. With ExpressRoute Direct,][ExRD] you can connect directly to Microsoft routers at 100 Gbps for customer with larger bandwidth needs.

Deploying ExpressRoute connections usually involves engaging with an ExpressRoute service provider. For customers that need to start quickly, it is common to initially use Site-to-Site VPN to establish connectivity between a VDC implementation and on-premises resources, and then migrate to ExpressRoute connection when your physical interconnection with your service provider is complete.

#### *Connectivity within the cloud*

[VNets][VNet] and [VNet Peering][VNetPeering] are the basic networking connectivity services inside a VDC implementation. A VNet guarantees a natural boundary of isolation for VDC resources, and VNet peering allows intercommunication between different VNets within the same Azure region or even across regions. Traffic control inside a VNet and between VNets need to match a set of security rules specified through Access Control Lists ([Network Security Group][NSG]), [Network Virtual Appliances][NVA], and custom routing tables ([UDR][UDR]).

## Virtual datacenter overview

### Topology

_Hub and spoke_ is a model for designing the network topology for a virtual datacenter implementation. 

[![1]][1]

A hub is the central network zone that controls and inspects ingress or egress traffic between different zones: internet, on-premises, and the spokes. The hub and spoke topology gives the IT department an effective way to enforce security policies in a central location. It also reduces the potential for misconfiguration and exposure.

The hub contains the common service components consumed by the spokes. The following examples are common central services:

-   The Windows Active Directory infrastructure, required for user authentication of third parties that access from untrusted networks before they get access to the workloads in the spoke. It includes the related Active Directory Federation Services (AD FS).
-   A DNS service to resolve naming for the workload in the spokes, to access resources on-premises and on the internet if [Azure DNS][DNS] isn't used.
-   A public key infrastructure (PKI), to implement single sign-on on workloads.
-   Flow control of TCP and UDP traffic between the spoke network zones and the internet.
-   Flow control between the spokes and on-premises.
-   If needed, flow control between one spoke and another.

The VDC reduces overall cost by using the shared hub infrastructure between multiple spokes.

The role of each spoke can be to host different types of workloads. The spokes also provide a modular approach for repeatable deployments of the same workloads. Examples are dev and test, user acceptance testing, preproduction, and production. The spokes can also segregate and enable different groups within your organization. An example is Azure DevOps groups. Inside a spoke, it's possible to deploy a basic workload or complex multi-tier workloads with traffic control between the tiers.

#### Subscription limits and multiple hubs

In Azure, every component, whatever the type, is deployed in an Azure Subscription. The isolation of Azure components in different Azure subscriptions can satisfy the requirements of different LOBs, such as setting up differentiated levels of access and authorization.

A single VDC implementation can scale up to large number of spokes, although, as with every IT system, there are platforms limits. The hub deployment is bound to a specific Azure subscription, which has restrictions and limits (for example, a max number of VNet peerings - see [Azure subscription and service limits, quotas, and constraints][Limits] for details). In cases where limits may be an issue, the architecture can scale up further by extending the model from a single hub-spokes to a cluster of hub and spokes. Multiple hubs in one or more Azure regions can be interconnected using VNet Peering, ExpressRoute, Virtual WAN, or site-to-site VPN.

[![2]][2]

The introduction of multiple hubs increases the cost and management effort of the system. It would only be justified by scalability like system limits or redundancy and regional replication like end-user performance or disaster recovery. In scenarios requiring multiple hubs, all the hubs should strive to offer the same set of services for operational ease.

#### Interconnection between spokes

Inside a single spoke, it is possible to implement complex multi-tiers workloads. Multi-tier configurations can be implemented using subnets (one for every tier) in the same VNet and filtering the flows using NSGs.

An architect might want to deploy a multi-tier workload across multiple virtual networks. With virtual network peering, spokes can connect to other spokes in the same hub or different hubs. A typical example of this scenario is the case where application processing servers are in one spoke, or virtual network. The database deploys in a different spoke, or virtual network. In this case, it's easy to interconnect the spokes with virtual network peering and thereby avoid transiting through the hub. A careful architecture and security review should be performed to ensure that bypassing the hub doesn’t bypass important security or auditing points that might exist only in the hub.

[![3]][3]

Spokes can also be interconnected to a spoke that acts as a hub. This approach creates a two-level hierarchy: the spoke in the higher level (level 0) become the hub of lower spokes (level 1) of the hierarchy. The spokes of a VDC implementation are required to forward the traffic to the central hub so that the traffic can transit to its destination in either the on-premises network or public internet. An architecture with two levels of hub introduces complex routing that removes the benefits of a simple hub-spoke relationship.

Although Azure allows complex topologies, one of the core principles of the VDC concept is repeatability and simplicity. To minimize management effort, the simple hub-spoke design is the VDC reference architecture that we recommend.

### Components

The virtual datacenter is made up of four basic component types: **Infrastructure**, **Perimeter Networks**, **Workloads**, and **Monitoring**.

Each component type consists of various Azure features and resources. Your VDC implementation is made up of instances of multiple components types and multiple variations of the same component type. For instance, you may have many different, logically separated, workload instances that represent different applications. You use these different component types and instances to ultimately build the VDC.

[![4]][4]

The preceding high-level conceptual architecture of the VDC shows different component types used in different zones of the hub-spokes topology. The diagram shows infrastructure components in various parts of the architecture.

As good practice in general, access rights and privileges should be group-based. Dealing with groups rather than individual users eases maintenance of access policies by providing a consistent way to manage it across teams.  and aids in minimizing configuration errors. Assigning and removing users to and from appropriate groups helps keeping the privileges of a specific user up-to-date.

Each role group should have a unique prefix on their names. This prefix makes it easy to identify which group is associated with which workload. For example, a workload hosting an authentication service might have groups named **AuthServiceNetOps**, **AuthServiceSecOps**, **AuthServiceDevOps**, and **AuthServiceInfraOps**. Centralized roles, or roles not related to a specific service, might be prefaced with **Corp**. An example is **CorpNetOps**.

Many organizations use a variation of the following groups to provide a major breakdown of roles:

-   The central IT group, **Corp,** has the ownership rights to control infrastructure components. Examples are networking and security. The group needs to have the role of contributor on the subscription, control of the hub, and network contributor rights in the spokes. Large organizations frequently split up these management responsibilities between multiple teams. Examples are a network operations **CorpNetOps** group with exclusive focus on networking and a security operations **CorpSecOps** group responsible for the firewall and security policy. In this specific case, two different groups need to be created for assignment of these custom roles.
-   The dev-test group, **AppDevOps,** has the responsibility to deploy app or service workloads. This group takes the role of virtual machine contributor for IaaS deployments or one or more PaaS contributor’s roles. See [Built-in roles for Azure resources][Roles]. Optionally, the dev-test team might need visibility on security policies, NSGs, and routing policies, UDRs, inside the hub or a specific spoke. In addition to the role of contributor for workloads, this group would also need the role of network reader.
-   The operation and maintenance group, **CorpInfraOps** or **AppInfraOps,** has the responsibility of managing workloads in production. This group needs to be a subscription contributor on workloads in any production subscriptions. Some organizations might also evaluate if they need an additional escalation support team group with the role of subscription contributor in production and the central hub subscription. The additional group fixes potential configuration issues in the production environment.

The VDC is designed so groups created for the central IT groups managing the hub have corresponding groups at the workload level. In addition to managing hub resources only, the central IT group is able to control external access and top-level permissions on the subscription. Workload groups are also able to control resources and permissions of their VNet independently on Central IT.

The VDC is partitioned to securely host multiple projects across different Lines-of-Business (LOBs). All projects require different isolated environments (Dev, UAT, production). Separate Azure subscriptions for each of these environments provide natural isolation.

[![5]][5]

The preceding diagram shows the relationship between an organization's projects, users, and groups and the environments where the Azure components are deployed.

Typically in IT, an environment (or tier) is a system in which multiple applications are deployed and executed. Large enterprises use a development environment (where changes originally made and tested) and a production environment (what end-users use). Those environments are separated, often with several staging environments in between them to allow phased deployment (rollout), testing, and rollback if problems arise. Deployment architectures vary significantly, but usually the basic process of starting at development (DEV) and ending at production (PROD) is still followed.

A common architecture for these types of multi-tier environments consists of Azure DevOps for development and testing, UAT for staging, and production environments. Organizations can leverage single or multiple Azure AD tenants to define access and rights to these environments. The previous diagram shows a case where two different Azure AD tenants are used: one for Azure DevOps and UAT, and the other exclusively for production.

The presence of different Azure AD tenants enforces the separation between environments. The same group of users, such as the central IT, needs to authenticate by using a different URI to access a different Azure AD tenant to modify the roles or permissions of either the Azure DevOps or production environments of a project. The presence of different user authentications to access different environments reduces possible outages and other issues caused by human errors.

#### Component type: Infrastructure

This component type is where most of the supporting infrastructure resides. It's also where your centralized IT, Security, and/or Compliance teams spend most of their time.

[![6]][6]

Infrastructure components provide an interconnection for the different components of a VDC implementation, and are present in both the hub and the spokes. The responsibility for managing and maintaining the infrastructure components is typically assigned to the central IT and/or security team.

One of the primary tasks of the IT infrastructure team is to guarantee the consistency of IP address schemas across the enterprise. The private IP address space assigned to a VDC implementation must be consistent and NOT overlapping with private IP addresses assigned on your on-premises networks.

While NAT on the on-premises edge routers or in Azure environments can avoid IP address conflicts, it adds complications to your infrastructure components. Simplicity of management is one of the key goals of the VDC, so using NAT to handle IP concerns is not a recommended solution.

Infrastructure components have the following functionality:

-   [**Identity and directory services**][AAD]. Access to every resource type in Azure is controlled by an identity stored in a directory service. The directory service stores not only the list of users, but also the access rights to resources in a specific Azure subscription. These services can exist cloud-only, or they can be synchronized with on-premises identity stored in Active Directory.
-   [**Virtual Network**][VPN]. Virtual Networks are one of main components of the VDC, and enable you to create a traffic isolation boundary on the Azure platform. A Virtual Network is composed of a single or multiple virtual network segments, each with a specific IP network prefix (a subnet). The Virtual Network defines an internal perimeter area where IaaS virtual machines and PaaS services can establish private communications. VMs (and PaaS services) in one virtual network cannot communicate directly to VMs (and PaaS services) in a different virtual network, even if both virtual networks are created by the same customer, under the same subscription. Isolation is a critical property that ensures customer VMs and communication remains private within a virtual network.
-   [**UDR**][UDR]. Traffic in a Virtual Network is routed by default based on the system routing table. A User Defined Route is a custom routing table that network administrators can associate to one or more subnets to overwrite the behavior of the system routing table and define a communication path within a virtual network. The presence of UDRs guarantees that egress traffic from the spoke transit through specific custom VMs and/or Network Virtual Appliances and load balancers present in the hub and in the spokes.
-   [**NSG**][NSG]. A Network Security Group is a list of security rules that act as traffic filtering on IP Sources, IP Destination, Protocols, IP Source Ports, and IP Destination ports. The NSG can be applied to a subnet, a Virtual NIC card associated with an Azure VM, or both. The NSGs are essential to implement a correct flow control in the hub and in the spokes. The level of security afforded by the NSG is a function of which ports you open, and for what purpose. Customers should apply additional per-VM filters with host-based firewalls such as IPtables or the Windows Firewall.
-   [**DNS**][DNS]. The name resolution of resources in the VNets of a VDC implementation is provided through DNS. Azure provides DNS services for both [Public][DNS] and [Private][PrivateDNS] name resolution. Private zones provide name resolution both within a virtual network and across virtual networks. You can have private zones not only span across virtual networks in the same region, but also across regions and subscriptions. For public resolution, Azure DNS provides a hosting service for DNS domains, providing name resolution using Microsoft Azure infrastructure. By hosting your domains in Azure, you can manage your DNS records using the same credentials, APIs, tools, and billing as your other Azure services.
-   [**Subscription**][SubMgmt] and [**Resource Group Management**][RGMgmt]. A subscription defines a natural boundary to create multiple groups of resources in Azure. Resources in a subscription are assembled together in logical containers named Resource Groups. The Resource Group represents a logical group to organize the resources of a VDC implementation.
-   [**RBAC**][RBAC]. Through RBAC, it is possible to map organizational role along with rights to access specific Azure resources, allowing you to restrict users to only a certain subset of actions. With RBAC, you can grant access by assigning the appropriate role to users, groups, and applications within the relevant scope. The scope of a role assignment can be an Azure subscription, a resource group, or a single resource. RBAC allows inheritance of permissions. A role assigned at a parent scope also grants access to the children contained within it. Using RBAC, you can segregate duties and grant only the amount of access to users that they need to perform their jobs. For example, use RBAC to let one employee manage virtual machines in a subscription, while another can manage SQL DBs within the same subscription.
-   [**VNet Peering**][VNetPeering]. The fundamental feature used to create the infrastructure of the VDC is VNet Peering, a mechanism that connects two virtual networks (VNets) in the same region through the Azure datacenter network, or using the Azure world-wide backbone across regions.

#### Component Type: Perimeter Networks

[Perimeter network][DMZ] components enable network connectivity between your on-premises or physical datacenter networks, along with any connectivity to and from the Internet. It's also where your network and security teams likely spend most of their time.

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

The preceding diagram shows the enforcement of two perimeters with access to the internet and an on-premises network, both resident in the DMZ and vWAN hubs. In the DMZ hub, the perimeter network to internet can scale up to support large numbers of LOBs, using multiple farms of Web Application Firewalls (WAFs) and/or Azure Firewalls. In the vWAN hub, highly scalable branch to branch and branch to Azure connectivity is accomplished via VPN or ExpressRoute as needed.

[**Virtual networks**][VNet]. The hub is typically built on a virtual network with multiple subnets to host the different types of services that filter and inspect traffic to or from the internet via NVAs, WAF, and Azure Application Gateway instances.

[**UDR**][UDR]
Using UDRs, customers can deploy firewalls, IDS/IPS, and other virtual appliances, and route network traffic through these security appliances for security boundary policy enforcement, auditing, and inspection. UDRs can be created in both the hub and the spokes to guarantee that traffic transits through the specific custom VMs, Network Virtual Appliances, and load balancers used by a VDC implementation. To guarantee that traffic generated from VMs resident in the spoke transit to the correct virtual appliances, a UDR needs to be set in the subnets of the spoke by setting the front-end IP address of the internal load balancer as the next-hop. The internal load balancer distributes the internal traffic to the virtual appliances (load balancer back-end pool).

[**Azure Firewall**][AzFW] is a managed, cloud-based network security service that protects your Azure Virtual Network resources. It's a fully stateful firewall as a service with built-in high availability and unrestricted cloud scalability. You can centrally create, enforce, and log application and network connectivity policies across subscriptions and virtual networks. Azure Firewall uses a static public IP address for your virtual network resources. It allows outside firewalls to identify traffic that originates from your virtual network. The service is fully integrated with Azure Monitor for logging and analytics.

[**Network virtual appliances**][NVA]. In the hub, the perimeter network with access to the internet is normally managed through an Azure Firewall instance or a farm of firewalls or web application firewall (WAF).

Different LOBs commonly use many web applications. These applications tend to suffer from various vulnerabilities and potential exploits. Web application firewalls are a special type of product used to detect attacks against web applications, HTTP/HTTPS, in more depth than a generic firewall. Compared with tradition firewall technology, WAFs have a set of specific features to protect internal web servers from threats.

An Azure Firewall or NVA firewall both use a common administration plane, with a set of security rules to protect the workloads hosted in the spokes, and control access to on-premises networks. The Azure Firewall has scalability built in, whereas NVA firewalls can be manually scaled behind a load balancer. Generally, a firewall farm has less specialized software compared with a WAF, but has a broader application scope to filter and inspect any type of traffic in egress and ingress. If an NVA approach is used, they can be found and deployed from the Azure marketplace.

Use one set of Azure Firewalls (or NVAs) for traffic originating on the Internet, and another for traffic originating on-premises. Using only one set of firewalls for both is a security risk, as it provides no security perimeter between the two sets of network traffic. Using separate firewall layers reduces the complexity of checking security rules, and makes it clear which rules correspond to which incoming network request.

We recommend that you use one set of Azure Firewall instances, or NVAs, for traffic originating on the internet. Use another for traffic originating on-premises. Using only one set of firewalls for both is a security risk as it provides no security perimeter between the two sets of network traffic. Using separate firewall layers reduces the complexity of checking security rules and makes it clear which rules correspond to which incoming network request.

[**Azure Load Balancer**][ALB] offers a high availability Layer 4 (TCP, UDP) service, which can distribute incoming traffic among service instances defined in a load-balanced set. Traffic sent to the load balancer from front-end endpoints (public IP endpoints or private IP endpoints) can be redistributed with or without address translation to a set of back-end IP address pool (examples being; Network Virtual Appliances or VMs).

Azure Load Balancer can probe the health of the various server instances as well, and when a probe fails to respond the load balancer stops sending traffic to the unhealthy instance. In the VDC, an external load balancer is deployed to the hub and the spokes. In the hub, the load balancer is used to efficiently route traffic to services in the spokes, and in the spokes, load balancers are used to manage application traffic.

[**Azure Front Door**][AFD] (AFD) is Microsoft's highly available and scalable Web Application Acceleration Platform, Global HTTP Load Balancer, Application Protection, and Content Delivery Network. Running in more than 100 locations at the Edge of Microsoft's Global Network, AFD enables you to build, operate, and scale out your dynamic web application and static content. AFD provides your application with world-class end-user performance, unified regional/stamp maintenance automation, BCDR automation, unified client/user information, caching, and service insights. The platform offers performance, reliability and support SLAs, compliance certifications and auditable security practices developed, operated, and supported natively by Azure.

[**Application Gateway**][AppGW]
Microsoft Azure Application Gateway is a dedicated virtual appliance providing application delivery controller (ADC) as a service, offering various layer 7 load-balancing capabilities for your application. It allows you to optimize web farm productivity by offloading CPU intensive SSL termination to the application gateway. It also provides other layer 7 routing capabilities including round robin distribution of incoming traffic, cookie-based session affinity, URL path-based routing, and the ability to host multiple websites behind a single Application Gateway. A web application firewall (WAF) is also provided as part of the application gateway WAF SKU. This SKU provides protection to web applications from common web vulnerabilities and exploits. Application Gateway can be configured as internet facing gateway, internal only gateway, or a combination of both. 

[**Application Gateway**][AppGW] is a dedicated virtual appliance that provides application delivery controller (ADC) as a service, offering various layer 7 load-balancing capabilities for your application. You can optimize web farm productivity by offloading CPU-intensive SSL termination to the Application Gateway instance. It also provides other layer 7 routing capabilities that include the following examples: 
* Round robin distribution of incoming traffic. 
* Cookie-based session affinity. 
* URL path-based routing. 
* The ability to host multiple websites behind a single Application Gateway instance. 
Web application firewall (WAF) is also provided as part of the Application Gateway WAF SKU. This SKU provides protection to web applications from common web vulnerabilities and exploits. Application Gateway can be configured as an internet-facing gateway, an internal-only gateway, or a combination of both. 

[**Public IPs**][PIP]. With some Azure features, you can associate service endpoints to a public IP address, so that your resource can be accessed from the internet. This endpoint uses network address translation (NAT) to route traffic to the internal address and port on the Azure virtual network. This path is the primary way for external traffic to pass into the virtual network. You can configure public IP addresses to determine which traffic is passed in and how and where it's translated onto the virtual network.

[**Azure DDoS Protection Standard**][DDOS] provides additional mitigation capabilities over the [Basic service][DDOS] tier that are tuned specifically to Azure Virtual Network resources. DDoS Protection Standard is simple to enable and requires no application changes. Protection policies are tuned through dedicated traffic monitoring and machine learning algorithms. Policies are applied to public IP addresses associated to resources deployed in virtual networks. Examples are Azure Load Balancer, Azure Application Gateway, and Azure Service Fabric instances. Real-time telemetry is available through Azure Monitor views during an attack and for history. Application layer protection can be added through the Azure Application Gateway web application firewall. Protection is provided for IPv4 Azure public IP addresses.

#### Component type: Monitoring

Monitoring components provide visibility and alerting from all the other components types. All teams should have access to monitoring for the components and services they have access to. If you have a centralized help desk or operations teams, they require integrated access to the data provided by these components.

Azure offers different types of logging and monitoring services to track the behavior of Azure-hosted resources. Governance and control of workloads in Azure is based not just on collecting log data but also on the ability to trigger actions based on specific reported events.

[**Azure Monitor**][Monitor]. Azure includes multiple services that individually perform a specific role or task in the monitoring space. Together, these services deliver a comprehensive solution for collecting, analyzing, and acting on telemetry from your application and the Azure resources that support them. They can also work to monitor critical on-premises resources in order to provide a hybrid monitoring environment. Understanding the tools and data that are available is the first step in developing a complete monitoring strategy for your application.

There are two major types of logs in Azure:

-   The [Azure Activity Log][ActLog], previously called **Operational Logs**, provides insight into the operations that were performed on resources in the Azure subscription. These logs report the control-plane events for your subscriptions. Every Azure resource produces audit logs.

-   [Azure Monitor diagnostic logs][DiagLog] are logs generated by a resource that provides rich, frequent data about the operation of that resource. The content of these logs varies by resource type.

[![9]][9]

It is important to track the NSGs logs, particularly this information:

-   [Event logs][NSGLog] provide information on what NSG rules are applied to VMs and instance roles based on MAC address.
-   [Counter logs][NSGLog] track how many times each NSG rule was run to deny or allow traffic.

All logs can be stored in Azure storage accounts for audit, static analysis, or backup purposes. When you store the logs in an Azure storage account, customers can use different types of frameworks to retrieve, prep, analyze, and visualize this data to report the status and health of cloud resources. 

Large enterprises should already have acquired a standard framework for monitoring on-premises systems. They can extend that framework to integrate logs generated by cloud deployments. By using [Azure Log Analytics][https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-queries], organizations can keep all the logging in the cloud. Log Analytics is implemented as a cloud-based service. So you have it up and running quickly with minimal investment in infrastructure services. Log Analytics also integrate with System Center components like System Center Operations Manager to extend your existing management investments into the cloud. 

Log Analytics is a service in Azure that helps collect, correlate, search, and act on log and performance data generated by operating systems, applications, and infrastructure cloud components. It gives customers real-time operational insights using integrated search and custom dashboards to analyze all the records across all your workloads in your VDC implementation.

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

**Internal LOB Applications**: Line-of-business applications are computer applications critical to the ongoing operation of an enterprise. LOB applications have some common characteristics:

-   **Interactive** by nature. Data is entered, and results or reports are returned.
-   **Data driven**&mdash;data intensive with frequent access to databases or other storage.
-   **Integrated**&mdash;offer integration with other systems within or outside the organization.

**Customer facing web sites (Internet or Internal facing)**: Most applications that interact with the Internet are web sites. Azure offers the capability to run a web site on an IaaS VM or from an [Azure Web Apps][WebApps] site (PaaS). Azure Web Apps support integration with VNets that allow the deployment of the Web Apps in a spoke network zone. Internal facing web sites don't need to expose a public internet endpoint becuase the resources are accessible via private non-internet routable addresses from the private VNet.

**Big Data/Analytics**: When data needs to scale up to a large volume, databases may not scale up properly. Hadoop technology offers a system to run distributed queries in parallel on large number of nodes. Customers have the option to run data workloads in IaaS VMs or PaaS ([HDInsight][HDI]). HDInsight supports deploying into a location-based VNet, can be deployed to a cluster in a spoke of the VDC.

**Events and Messaging**: [Azure Event Hubs][EventHubs] is a hyper-scale telemetry ingestion service that collects, transforms, and stores millions of events. As a distributed streaming platform, it offers low latency and configurable time retention, enabling you to ingest massive amounts of telemetry into Azure and read that data from multiple applications. With Event Hubs, a single stream can support both real-time and batch-based pipelines.

You can implement a highly reliable cloud messaging service between applications and services through [Azure Service Bus][ServiceBus]. It offers asynchronous brokered messaging between client and server, structured first-in-first-out (FIFO) messaging, and publish and subscribe capabilities.

[![10]][10]

### Making the VDC highly available: multiple VDCs

So far, this article has focused on the design of a single VDC, describing the basic components and architecture that contribute to resiliency. Azure features such as Azure load balancer, NVAs, availability sets, scale sets, along with other mechanisms contribute to a system that enable you to build solid SLA levels into your production services.

However, because a single VDC is typically implemented within a single region, it may be vulnerable to any major outage that affects that entire region. Customers that require high SLAs must protect the services through deployments of the same project in two (or more) VDC implementations placed in different regions.

In addition to SLA concerns, there are several common scenarios where deploying multiple VDC implementations makes sense:

-   Regional or global presence.
-   Disaster recovery.
-   A mechanism to divert traffic between datacenters.

#### Regional/global presence

Azure datacenters are present in numerous regions worldwide. When selecting multiple Azure datacenters, customers need to consider two related factors: geographical distances and latency. To offer the best user experience, evaluate the geographical distance between each VDC implementation as well as the distance between each VDC implementation and the end users.

The region in which VDC implementations are hosted must conform with regulatory requirements established by any legal jurisdiction under which your organization operates.

#### Disaster recovery

The design of a disaster recovery plan depends on the types of workloads  and the ability to synchronize state of those workloads between different VDC implementations. Ideally, most customers desire a fast fail-over mechanism, and this may require application data synchronization between deployments running multiple VDC implementations. However, when designing disaster recovery plans, it's important to consider that most applications are sensitive to the latency that can be caused by this data synchronization.

Synchronization and heartbeat monitoring of applications in different VDC implementations requires them to communicate over the network. Two VDC implementations in different regions can be connected through:

-   VNet Peering - VNet Peering can connect hubs across regions
-   ExpressRoute private peering when the hubs in each VDC implementation are connected to the same ExpressRoute circuit
-   multiple ExpressRoute circuits connected via your corporate backbone and your multiple VDC implementations connected to the ExpressRoute circuits
-   Site-to-Site VPN connections between the hub zone of your VDC implementations in each Azure Region

Typically, VNet Peering or ExpressRoute connections are the preferred type of network connectivity due to the higher bandwidth and consistent latency levels when transiting through the Microsoft backbone.

We recommend that customers run network qualification tests to verify the latency and bandwidth of these connections, and decide whether synchronous or asynchronous data replication is appropriate based on the result. It's also important to weigh these results in view of the optimal recovery time objective (RTO).

#### Disaster recovery: diverting traffic from one region to another

[Azure Traffic Manager][TM] periodically checks the service health of public endpoints in different VDC implementations and, if those endpoints fail, it routes automatically to the secondary VDC using the Domain Name System (DNS). 

Because it uses DNS, Traffic Manager is only for use with Azure public endpoints.  The service is typically used to control or divert traffic to Azure VMs and Web Apps in the healthy instance of a VDC implementation. Traffic Manager is resilient even in the face of an entire Azure region failing and can control the distribution of user traffic for service endpoints in different VDCs based on several criteria. For example, failure of a service in a specific VDC implementation, or selecting the VDC implementation with the lowest network latency.

### Summary

The Virtual datacenter is an approach to datacenter migration to create a scalable architecture in Azure that maximizes cloud resource use, reduces costs, and simplifies system governance. The VDC is based on a hub and spoke network topology, providing common shared services in the hub and allowing specific applications/workloads in the spokes. The VDC also matches the structure of company roles, where different departments such as Central IT, DevOps, operation and maintenance, all work together while performing their specific roles. The VDC satisfies the requirements for a "Lift and Shift" migration, but also provides many advantages to native cloud deployments.

## References

The following features were discussed in this document. Follow the links to learn more.

| | | |
|-|-|-|
|Network Features|Load Balancing|Connectivity|
|[Azure Virtual Networks][VNet]</br>[Network Security Groups][NSG]</br>[NSG Logs][NSGLog]</br>[User Defined Routing][UDR]</br>[Network Virtual Appliances][NVA]</br>[Public IP Addresses][PIP]</br>[Azure DDOS][DDOS]</br>[Azure Firewall][AzFW]</br>[Azure DNS][DNS]|[Azure Front Door][AFD]</br>[Azure Load Balancer (L3) ][ALB]</br>[Application Gateway (L7) ][AppGW]</br>[Web Application Firewall][WAF]</br>[Azure Traffic Manager][TM]</br></br></br></br></br> |[VNet Peering][VNetPeering]</br>[Virtual Private Network][VPN]</br>[Virtual WAN][vWAN]</br>[ExpressRoute][ExR]</br>[ExpressRoute Direct][ExRD]</br></br></br></br></br>
|Identity</br>|Monitoring</br>|Best Practices</br>|
|[Azure Active Directory][AAD]</br>[Multi-Factor Authentication][MFA]</br>[Role Base Access Controls][RBAC]</br>[Default Azure AD Roles][Roles]</br></br></br> |[Network Watcher][NetWatch]</br>[Azure Monitor][Monitor]</br>[Activity Logs][ActLog]</br>[Diagnostic Logs][DiagLog]</br>[Microsoft Operations Management Suite][OMS]</br>[Network Performance Monitor][NPM]|[Perimeter Networks Best Practices][DMZ]</br>[Subscription Management][SubMgmt]</br>[Resource Group Management][RGMgmt]</br>[Azure Subscription Limits][Limits] </br></br></br>|
|Other Azure Services|
|[Azure Web Apps][WebApps]</br>[HDInsights (Hadoop) ][HDI]</br>[Event Hubs][EventHubs]</br>[Service Bus][ServiceBus]|

## Next Steps

 - Explore [VNet Peering][VNetPeering], the underpinning technology for VDC hub and spoke designs
 - Implement [Azure AD][AAD] to get started with [RBAC][RBAC] exploration
 - Develop a Subscription and Resource management model and RBAC model to meet the structure, requirements, and policies of your organization. The most important activity is planning. As much as practical, plan for reorganizations, mergers, new product lines, etc.
m
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
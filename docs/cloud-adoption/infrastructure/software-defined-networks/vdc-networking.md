---
title: "Fusion: Azure Virtual datacenter - Networking" 
description: Discusses how the Azure Virtual datacenter networking infrastructure enables secure, centrally managed, access between on-premises and cloud resources, while isolating VDC networks from the public internet and other Azure hosted networks.
author: rotycenh
ms.date: 11/08/2018
---

# Fusion: Software Defined Networks - Virtual datacenter network architecture

> [!NOTE]
> The Azure Virtual Datacenter model is more than networking functionality. Implementing this model requires integrating requirements from enterprise IT, security, governance, and developer teams. For simpler or smaller hybrid deployments a virtual datacenter model is likely more complicated than necessary. The networking aspects of the Azure Virtual datacenter model is discussed below, but for more information about this approach as a whole, and if it's right for your cloud migration, see the main [Azure Virtual Datacenter](../virtual-datacenter/overview.md) topic. 

Jump to: [IP Policy](#ip-policy) | [On-premises connectivity](#on-premises-connectivity) | [Hub network](#hub-network) | [Spoke networks](#spoke-networks) | [Virtual network integration with PaaS](#virtual-network-integration-with-paas)

![Example hub and spoke structure of a virtual data center, including connection to on-premises network](../../_images/infra-sdn-figure3.png)

The [Azure Virtual Data Center (VDC)](../virtual-datacenter/overview.md) is an approach designed to assist enterprises in deploying large number of workloads and services to the Azure public cloud platform while still preserving key aspects of your existing security, policy compliance, and general IT governance practices. The networking architecture for a virtual datacenter was first discussed in depth in Jon Ormond's article [Azure virtual datacenter: A network perspective](https://docs.microsoft.com/en-us/azure/architecture/vdc/networking-virtual-datacenter).

As with other hybrid cloud architectures, the VDC hub network hosts a connection to on-premises or other external networks (via ExpressRoute or VPN) and contains the UDR, NVA and other routing and security devices to manage traffic coming from workloads to external on-premises networks and vice versa.

The VDC model's networking architecture extends the [hub and spoke architecture](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) by adding centralized traffic management, Azure Policy settings, network governance, and access control capabilities. Hub and spoke networks can be hosted on separate accounts or subscriptions, allowing VDCs to bypass single-subscription resource limits. A single hub can connect to many spokes, with each hub and spoke virtual network hosted in separate subscriptions.

The VDC model supports connecting hub and spoke networks across geo-regions. However, connecting between geo-regions has the potential to introduce higher latency than would be the case if all networks were in the same geo-region, and this potential latency would need to be accounted for in your network and workload planning.

## IP Policy

To interact with your on-premises network, your central hub and workload spoke networks need to have a compatible IP address configuration. IP ranges for the hub and workspace spokes should not conflict with each other or any on-premises networks the virtual datacenter connects with. Before deploying a VDC, integrate the networks in your virtual datacenter with your existing on-premises IP Address Management (IPAM) scheme before settling on the IP ranges for the main hub and any planned spoke networks.

## On-premises connectivity

To avoid sending traffic over the public Internet, a VDC uses a dedicated, private connection between their on-premises network and the virtual datacenter. The Azure Virtual Datacenter model supports two methods of connecting a virtual datacenter center to on-premises networks:

- [ExpressRoute circuit](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-introduction) uses a dedicated, private connection facilitated by a connectivity provider.
- [Azure VPN gateways](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways) create a site-to-site connection that passes encrypted traffic over the public Internet.

ExpressRoute connections offer more reliability, faster speeds, and lower latencies than typical connections over the Internet. ExpressRoute creates a direct link between the on-premises network and Azure. However, ExpressRoute connections take time to acquire and deploy. While you wait for ExpressRoute, you can immediately set up a site-to-site VPN gateway, a common tactic used by many organizations to quickly get started using Azure resources. 

After the ExpressRoute connection is in place, you can convert the VPN gateway to a failover connection in case the ExpressRoute goes down, or as  a secondary connection for workloads that don't require the increased speed and lower latency of ExpressRoute.

## Hub network

The central hub virtual network contains the main traffic management, policy rules, and monitoring resources for the VDC. The hub hosts a connection to on-premises or other external networks and contains the central routing and firewall capabilities that manage traffic coming from workloads to external networks and vice versa. The hub also hosts any other common shared services used by workloads across the VDC.

Spoke virtual networks use [virtual network peering](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview) to connect with the hub virtual network.

### Subnets

The central hub virtual network hosts several subnets, each allowing the separate application of route tables and security settings. This subnet design can vary depending on what features the hub supports, but at the minimum will support the following three subnets:

| Subnet               | Description                                                                       |
|----------------------|-----------------------------------------------------------------------------------|
| Gateway              | Contains the Virtual Network Gateway connecting the hub with the on-premises network.   |
| Shared Services      | Contains the secure bastion host managment VMs and virtual servers hosting DNS or domain services.                       |
| Central firewall     | Hosts the central firewall.  |

The central firewall subnet may be broken into two or more subnets. For instance, you may have an ingress subnet to handle traffic handling incoming traffic using one virtual device, and an egress subnet that uses another mechanism to secure outbound traffic. 

### User Defined Routes

[User Defined Routes (UDRs)](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview) are used to route traffic to the correct location within the hub network, either pointing to the correct resources or sending the traffic to the central firewall to be further inspected and routed as appropriate. UDRs are attached to subnets, and each subnet on the hub network should have an attached UDR set defining how to handle traffic. 

Depending on your central firewall configuration, UDR rules can vary in complexity. At the most basic, each subnet UDR should have the following rules implemented: 

- Requests for workspace resources are processed through the central firewall. 
- Administrator requests for remote access to configure network resources are sent to the secure bastion host management VMs. 
- Requests for tasks such as name resolution are routed to the shared services subnet. 
- Requests for on-premises resources are passed to the gateway. 

In any case where the virtual datacenter allows either incoming or outgoing access to the Internet without first passing through the on-premises network, the Azure Virtual Datacenter model requires a [full DMZ](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/dmz/secure-vnet-dmz). In this scenario, UDRs send traffic coming into or out of the virtual datacenter to NVAs hosted on a DMZ subnet. This traffic gets processed, and only approved requests make it through either to the outside world or into the secured hub virtual network's central firewall, where it can be forwarded to the appropriate workloads spoke network.

### Gateway

The primary Virtual Network Gateway uses either the Azure VPN or ExpressRoute connection you've configured to connect with your on-premises network. It connects to the hub's Gateway subnet and traffic from spoke network is routed to it via UDR rules. 

A VDC can support multiple connections using the gateway, either hosting redundant connections or connections to additional on-premises networks, provided UDR rules are created to support the additional IP ranges of these additional network destinations.

### Network Security Groups

[Network Security Groups (NSGs)](https://docs.microsoft.com/en-us/azure/virtual-network/security-overview) filter network traffic to and from Azure resources in an Azure virtual network. In the VDC model, NSGs are assigned to each of the subnets. You can lock these rules down as tightly as you like, but the default rules for all subnets are as follows in order of priority:

| Rule Type | NSG rule                | Description                                                                                              |
|-----------|-------------------------|----------------------------------------------------------------------------------------------------------|
| Inbound   | Allow VNet Inbound      | Allows any inbound traffic originating within the virtual network.                                       |
| Inbound   | Deny All Inbound        | Prevents any inbound traffic to the subnet not explicitly allowed in previous rules.                     |
| Outbound  | Allow VNet Outbound     | Allows any outbound traffic targeting the virtual network.                                               |
| Outbound  | Allow Internet Outbound | Allows any traffic from with the virtual network to access external locations (subject to UDR rules or firewall/DMZ access restriction). |
| Outbound  | Deny All Outbound       | Prevents any outbound traffic to the subnet not explicitly allowed in previous rules.                    |

The shared services subnet uses a separate set of rules applied to limit access to the management virtual machines and DNS servers. These rules ensure that management VMs are only accessible from the on-premises network, that the virtual servers running Active Directory Domain Services (providing shared DNS or domain services) allow remote management only through the secure bastion host management VMs, and that rest of the VDC network can access those shared services.

| Rule Type | NSG rule                           | Description                                                                                              |
|-----------|------------------------------------|----------------------------------------------------------------------------------------------------------|
| Inbound   | Allow TCP Between ADDS             | Allows ADDS servers providing DNS or domain servers access to all the TCP ports required to sync and maintain trust relationships to other ADDS servers in the shared services subnet. |
| Inbound   | Allow UDP Between ADDS             | Allows ADDS servers providing DNS or domain servers access to all the UDP ports required to sync and maintain trust relationships to other ADDS servers in the shared services subnet. |
| Inbound   | Allow On-premises TCP ADDS Access  | Allows on-premises directory servers to access all the TCP ports required to sync and maintain trust relationships to other ADDS servers in the shared services subnet. |
| Inbound   | Allow On-premises UDP ADDS Access  | Allows on-premises directory servers to access all the UDP ports required to sync and maintain trust relationships to other ADDS servers in the shared services subnet. |
| Inbound   | Allow RDP Into ADDS                | Allows RDP access to ADDS servers from the secure bastion host management VMs *only*. |
| Inbound   | Allow RDP/SSH into Management VMs  | Allows RDP or SSH access to the secure bastion host management VMs from the on-premises network *only*. |
| Inbound   | Allow VNet TCP Access to ADDS      | Allows the rest of the VDC network to access only the TCP ports required to support DNS or domain services. |
| Inbound   | Allow VNet UDP Access to ADDS      | Allows the rest of the VDC network to access only the TCP ports required to support DNS or domain services. |
| Inbound   | Deny All Inbound                   | Prevents any inbound traffic to the subnet not explicitly allowed in previous rules.                     |
| Outbound  | Allow VNet Outbound     | Allows any outbound traffic targeting the virtual network.                                               |
| Outbound  | Allow Internet Outbound | Allows any traffic from with the virtual network to access external locations (subject to UDR rules or firewall/DMZ access restriction). |
| Outbound  | Deny All Outbound       | Prevents any outbound traffic to the subnet not explicitly allowed in previous rules.                    |

### Shared Services (DNS)

The shared services subnet provides a central place to deploy core functionality used by workloads. For example, workloads in a VDC need to resolve names for on-premises resources, and the on-premises network needs to resolve names for virtual datacenter resources, so DNS services are the first shared service you will deploy to the VDC. You will want to integrate VDC hosted DNS service with your existing DNS infrastructure, so that you have consistent name resolution across virtual and on-premises environments. 

The standard VDC model provides DNS services by creating a primary and secondary domain controller running Azure Active Directory Domain Services in the central hub environment, configured to handle DNS resolution for the VDC. These servers are configured to forward DNS requests from the VDC to the on-premises environment, and the on-premises DNS servers will need to also be configured to forward DNS requests for names of workspace resources to the shared services DNS servers.

After deploying DNS services, the hub and each spoke virtual network need to be configured to use the shared services VMs as their default DNS servers. 

### Management 

By default, your on-premises network will lack direct access to a VDC's virtual networks or connected resources. However, your central IT teams will need to configure the central firewall and oversee other management tasks in the hub infrastructure that are not available through the Azure portal or management APIs. To support this capability, you will need to create a set of secured bastion host virtual machines connected to the network. UDR rules will allow administrators to connect to these virtual machines from the on-premises network only, and directly access virtual machines and NVAs hosted in the VDC network.

These management VMs are created inside the shared services subnet, and NSG rules applied to this subnet restrict access to specific IPs on the on-premises network. The VDC model recommends deploying two of these VMs to the hub environment as an [availability set](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/manage-availability). It is also recommended that you use the [just in time access control](https://docs.microsoft.com/en-us/azure/security-center/security-center-just-in-time) mechanism to prevent unauthorized administrator access to the VMs.

### Central firewall

In the VDC model, the *central firewall* is not a specific virtual device, but an abstract reference to whatever devices or services are responsible for controlling what traffic is allowed to pass in and out of the VDC and determines how that traffic is directed. The central firewall manages network flow within the virtual datacenter and between resources hosted in the virtual datacenter and those in external environments, including the on-premises datacenter. Spoke networks and the gateway subnet use UDRs to route outbound traffic to the central firewall.

The VDC model offers no prescriptive guidance on what devices to use to construct your central firewall. However, there are some standard approaches that you can apply:

#### Native Azure traffic management features 

Several Azure features provide traffic management features that can be used within a VDC central firewall. For instance, [Azure Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview) is a web traffic load balancer that allows you to manage traffic targeting your workloads at both the transport layer (OSI layer 4 - TCP and UDP) using  source IP address and port and  application layer (OSI layer 7) load balancing based on request path. Application gateways can manage traffic coming from the public internet via a public IP or be used with an [Azure Internal Load Balancer](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview#a-name--internalloadbalancera-internal-load-balancer) to manage traffic within the virtual network.

[Azure Firewall](https://docs.microsoft.com/en-us/azure/firewall/overview) is another Azure feature that can be used as part of your central firewall configuration. Azure firewall can be used to control outbound requests, allowing you to provide limited access to the public internet to resources hosted in your virtual datacenter. For instance, only allowing machines inside your virtual datacenter to access Windows Update services, while preventing access to the rest of the internet. 

#### Network Virtual Appliances (NVAs)

The [Azure Marketplace contains](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/category/networking?page=1) many pre-built VM images designed to provide the same capabilities as traditional physical network security and management devices. These [Network Virtual Appliances (NVAs)](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/dmz/nva-ha) can be deployed to your central firewall subnet and then configured using through your VDC's management VMs. 

#### Custom VMs

If existing NVAs don't meet your security needs, you can deploy a custom VM and configure it to perform traffic management for the VDC. You can either deploy an existing base image from the Marketplace, or, if your organization has existing pre-configured VM images on-premises, you can [create a VM in Azure using a custom image](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/prepare-for-upload-vhd-image).
 
## Spoke networks

Workload spokes are separate virtual networks that, aside from network peering with the hub network, are isolated by default. All traffic travelling to the spoke from outside the VDC and form the spoke to the outside world are forced to travel through the hub where central security rules and access policies are applied. Much of the control over the spoke networks and connected workload resources can be delegated to the workload teams themselves, while critical security and access controls can be maintained through the central hub.





## Virtual network integration with PaaS

Although Azure PaaS offerings, such as Azure Batch, Azure SQL Database, and Azure Storage provide security and encryption capabilities, by default most of them use a public endpoint for access. The VDC model aims to avoid public endpoints for access, instead, using services  accessible only from inside hub or spoke virtual networks.

There are two patterns which enables private, secured access within your virtual network for PaaS services such as Azure App Services, Azure SQL Database, Azure Batch, and Azure Storage. In the first pattern, the service deploys dedicated instances into the virtual network, where they can only be used by resources with access to that network. [Azure Batch](https://docs.microsoft.com/en-us/azure/batch/batch-virtual-network) and [Azure App Service Environments](https://docs.microsoft.com/en-us/azure/app-service/environment/intro#virtual-network-support) support this pattern.

The second pattern, [virtual network service endpoints](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoints-overview), is an Azure feature that extends a virtual network's private address space and identity to Azure services over a direct connection. This option helps secure service resources by allowing access only from the virtual network, providing private connectivity to these resources and preventing access from external networks. Service endpoints use the Microsoft backbone network and allow PaaS resources to be restricted to a single virtual network, or inside a single subnet capable of using NSGs to further secure network access. 

See the article [Virtual Network Service Endpoints](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoints-overview) on the Azure documentation site for the latest list of PaaS services that support service endpoints. 


## Next steps

Learn more about [software defined networking](overview.md).

> [!div class="nextstepaction"]
> [Software Defined Networking](overview.md)

Learn how  [encryption](../encryption/vdc-encryption.md) is used to secure data in the Azure Virtual datacenter model.

> [!div class="nextstepaction"]
> [Azure Virtual datacenter: Encryption](../encryption/vdc-encryption.md)
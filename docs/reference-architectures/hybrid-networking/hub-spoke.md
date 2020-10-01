---
title: Hub-spoke network topology in Azure
titleSuffix: Azure Reference Architectures
description: Learn how to implement a hub-spoke topology in Azure, where the hub is a virtual network and the spokes are virtual networks that peer with the hub.
author: doodlemania2
ms.date: 09/30/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.category:
  - networking
  - management-and-governance
  - hybrid
ms.subservice: reference-architecture
ms.custom: seodec18, networking, fcp
---

# Hub-spoke network topology in Azure

This reference architecture shows how to implement a hub-spoke topology in Azure. The *hub* is a virtual network in Azure that acts as a central point of connectivity to your on-premises network. The *spokes* are virtual networks that peer with the hub, and can be used to isolate workloads. Traffic flows between the on-premises datacenter and the hub through an ExpressRoute or VPN gateway connection. [**Deploy this solution**](#deploy-the-solution).

![[0]][0]

*Download a [Visio file][visio-download] of this architecture*

The benefits of this topology include:

- **Cost savings** by centralizing services that can be shared by multiple workloads, such as network virtual appliances (NVAs) and DNS servers, in a single location.
- **Overcome subscriptions limits** by peering virtual networks from different subscriptions to the central hub.
- **Separation of concerns** between central IT (SecOps, InfraOps) and workloads (DevOps).

Typical uses for this architecture include:

- Workloads deployed in different environments, such as development, testing, and production, that require shared services such as DNS, IDS, NTP, or AD DS. Shared services are placed in the hub virtual network, while each environment is deployed to a spoke to maintain isolation.
- Workloads that do not require connectivity to each other, but require access to shared services.
- Enterprises that require central control over security aspects, such as a firewall in the hub as a DMZ, and segregated management for the workloads in each spoke.

## Architecture

The architecture consists of the following components.

- **On-premises network**. A private local-area network running within an organization.

- **VPN device**. A device or service that provides external connectivity to the on-premises network. The VPN device may be a hardware device, or a software solution such as the Routing and Remote Access Service (RRAS) in Windows Server 2012. For a list of supported VPN appliances and information on configuring selected VPN appliances for connecting to Azure, see [About VPN devices for Site-to-Site VPN Gateway connections][vpn-appliance].

- **VPN virtual network gateway or ExpressRoute gateway**. The virtual network gateway enables the virtual network to connect to the VPN device, or ExpressRoute circuit, used for connectivity with your on-premises network. For more information, see [Connect an on-premises network to a Microsoft Azure virtual network][connect-to-an-Azure-vnet].

- **Hub virtual network**. The virtual network used as the hub in the hub-spoke topology. The hub is the central point of connectivity to your on-premises network, and a place to host services that can be consumed by the different workloads hosted in the spoke virtual networks.

- **Gateway subnet**. The virtual network gateways are held in the same subnet.

- **Spoke virtual networks**. One or more virtual networks that are used as spokes in the hub-spoke topology. Spokes can be used to isolate workloads in their own virtual networks, managed separately from other spokes. Each workload might include multiple tiers, with multiple subnets connected through Azure load balancers. For more information about the application infrastructure, see [Running Windows VM workloads][windows-vm-ra] and [Running Linux VM workloads][linux-vm-ra].

- **Virtual network peering**. Two virtual networks can be connected using a [peering connection][vnet-peering]. Peering connections are non-transitive, low latency connections between virtual networks. Once peered, the virtual networks exchange traffic by using the Azure backbone, without the need for a router. In a hub-spoke network topology, you use virtual network peering to connect the hub to each spoke. You can peer virtual networks in the same region, or different regions. For more information, see [Requirements and constraints][vnet-peering-requirements].

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Resource groups

The hub and each spoke can be implemented in different resource groups and even different subscriptions. When you peer virtual networks in different subscriptions, both subscriptions can be associated with the same or different Azure Active Directory tenant. This allows for decentralized management of each workload while sharing services maintained in the hub.

### Virtual network and GatewaySubnet

Create a subnet named *GatewaySubnet*, with an address range of /27. This subnet is required by the virtual network gateway. Allocating 32 addresses to this subnet will help to prevent reaching gateway size limitations in the future.

For more information about setting up the gateway, see the following reference architectures, depending on your connection type:

- [Hybrid network using ExpressRoute][guidance-expressroute]
- [Hybrid network using a VPN gateway][guidance-vpn]

For higher availability, you can use ExpressRoute plus a VPN for failover. See [Connect an on-premises network to Azure using ExpressRoute with VPN failover][hybrid-ha].

A hub-spoke topology can also be used without a gateway, if you don't need connectivity with your on-premises network.

### Virtual network peering

Virtual network peering is a non-transitive relationship between two virtual networks. If you require spokes to connect to each other, consider adding a separate peering connection between those spokes.

However, suppose you have several spokes that need to connect with each other. In that case, you will run out of possible peering connections very quickly due to the limitation on the number of virtual network peerings per virtual network. (For more information, see [Networking limits][vnet-peering-limit].) In this scenario, consider using user-defined routes (UDRs) to force traffic destined to a spoke to be sent to Azure Firewall or an NVA acting as a router at the hub. This will allow the spokes to connect to each other.

You can also configure spokes to use the hub gateway to communicate with remote networks. To allow gateway traffic to flow from spoke to hub and connect to remote networks, you must:

- Configure the peering connection in the hub to **allow gateway transit**.
- Configure the peering connection in each spoke to **use remote gateways**.
- Configure all peering connections to **allow forwarded traffic**.

For additional information on creating virtual network peering, see [Create VNet peerings](/azure/virtual-network/virtual-network-manage-peering#create-a-peering).

## Considerations

### Spoke connectivity

If you require connectivity between spokes, consider deploying Azure Firewall or an NVA for routing in the hub and using UDRs in the spoke to forward traffic to the hub. The deployment steps below include an optional step that sets up this configuration. 

![[2]][2]

In this scenario, you must configure the peering connections to **allow forwarded traffic**.

You can also use a VPN gateway to route traffic between spokes, although this will have impacts in terms of latency and throughput. Also, Azure Firewall or a network firewall appliance provides an additional layer of security.

Also consider what services are shared in the hub to ensure the hub scales for a larger number of spokes. For instance, if your hub provides firewall services, consider the bandwidth limits of your firewall solution when adding multiple spokes. You might want to move some of these shared services to a second level of hubs.

## DevOps considerations

In this architecture, the entire networking infrastructure is created by using an Azure Resource Manager template, so it follows the IaC process for deploying the resources. To automate infrastructure deployment, you can use Azure DevOps, GitHub Actions or other CI/CD solutions. The deployment process is also idempotent - that is, repeatable to produce the same results. 

Templates are also good for dependency tracking since they allow you to define dependencies for resources that are deployed in the same template. For a given resource, there can be other resources that must exist before the resource is deployed.

### Network monitoring

Use Azure Network Watcher to monitor and troubleshoot the network components, tools like Traffic Analytics will show you the systems in your virtual networks that generate the most traffic so that you can visually identify bottlenecks before they degenerate into problems. Network Performance Manager is the right tool to monitor information about Microsoft ExpressRoute circuits. VPN diagnostics is another tool that can help troubleshoot site-to-site VPN connections connecting your applications to users on-premises.

For more information, see [Azure Network Watcher][azure-network-watcher] in the Azure Well-Architected Framework.

## Cost considerations

Centralizing services that can be shared by multiple workloads in a single location can be cost-efficient.

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs. Other considerations are described in the Cost section in [Microsoft Azure Well-Architected Framework][aaf-cost].

### Azure Firewall

In this architecture, Azure Firewall is deployed in the hub, which provides an additional security layer. Azure Firewall is cost-effective, especially if it's used as a shared solution consumed by multiple workloads. Here are the Azure Firewall pricing models:
- Fixed-rate per deployment hour.
- Data processed per GB to support auto-scaling. 

Compared to network virtual appliances (NVAs), with Azure Firewall you can save up to 30-50%. For more information, see [Azure Firewall vs NVA][Firewall-NVA].

### Virtual network peering

You can use virtual network peering to route traffic between virtual networks by using private IP addresses. Here are some points:

- Ingress and egress traffic is charged at both ends of the peered networks. 
- Different zones have different transfer rates.

For instance, data transfer from a virtual network in zone 1 to another virtual network in zone 2, will incur outbound transfer rate for zone 1 and inbound rate for zone 2. For more information, see [Virtual network pricing][VN-pricing].

## Deploy the solution

A sample hub and spoke deployment can be found [here](https://github.com/Azure/azure-quickstart-templates/tree/master/101-hub-and-spoke-sandbox). This deployment creates the following resources:

- Hub VNet with three subnets (DMZ, Management, and Shared).
- Two spoke VNets (development and production).
- A Windows virtual machine connected to the hub management subnet.
- VNet peerings between the hub and spoke VNets.

The following commands can be used to deploy the sample.

Create a resource group for the deployment.

```azurecli
az group create --name hub-spoke-sample --location eastus
```

Update the deployment values to suit your needs and deploy the template.

```azurecli
# Virtual machine admin user name and password
ADMIN_USER=adminuser
ADMIN_PASSWORD=Password2020!

# DNS prefix for the virtual machine
VM_DNS_PREFIX=hubSpokeSample

az deployment group create \
    --resource-group hub-spoke-sample \
    --template-uri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-hub-and-spoke-sandbox/azuredeploy.json \
    --parameters winVmUser=$ADMIN_USER winVmPassword=$ADMIN_PASSWORD winVmDnsPrefix=$VM_DNS_PREFIX
```

## Next steps

For a version of this architecture that deploys shared identity and security services, see [Hub-spoke network topology with shared services in Azure](./shared-services.md).

<!-- links -->

[aaf-cost]: ../../framework/cost/overview.md
[AAF-devops]: ../../framework/devops/overview.md
[azure-cli-2]: /azure/install-azure-cli
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[azbb]: https://github.com/mspnp/template-building-blocks/wiki/Install-Azure-Building-Blocks
[azure-network-watcher]: /azure/network-watcher/network-watcher-monitoring-overview
[azure-vpn-gateway]: /azure/vpn-gateway/vpn-gateway-about-vpngateways
[connect-to-an-Azure-vnet]: /microsoft-365/enterprise/connect-an-on-premises-network-to-a-microsoft-azure-virtual-network?view=o365-worldwide
[network-watcher]: /azure/network-watcher/network-watcher-monitoring-overview
[Firewall-NVA]: https://azure.microsoft.com/blog/azure-firewall-and-network-virtual-appliances
[guidance-expressroute]: ./expressroute.md
[guidance-vpn]: ./vpn.md
[linux-vm-ra]: ../n-tier/n-tier-cassandra.md
[hybrid-ha]: ./expressroute-vpn-failover.md
[naming conventions]: /azure/guidance/guidance-naming-conventions
[VN-pricing]: https://azure.microsoft.com/pricing/details/virtual-network
[vnet-peering]: /azure/virtual-network/virtual-network-peering-overview
[vnet-peering-limit]: /azure/azure-subscription-service-limits#networking-limits
[vnet-peering-requirements]: /azure/virtual-network/virtual-network-manage-peering#requirements-and-constraints
[vpn-appliance]: /azure/vpn-gateway/vpn-gateway-about-vpn-devices
[windows-vm-ra]: ../n-tier/n-tier-sql-server.md
[visio-download]: https://archcenter.blob.core.windows.net/cdn/hybrid-network-hub-spoke.vsdx
[ref-arch-repo]: https://github.com/mspnp/reference-architectures

[0]: ./images/hub-spoke.png "Hub-spoke topology in Azure"
[1]: ./images/hub-spoke-resources.png "Deployed Azure resources"
[2]: ./images/spoke-spoke-routing.png "Routing between spokes using Azure Firewall"
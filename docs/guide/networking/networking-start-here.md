# Networking architecture design

intro 

diagram?

Azure provides a wide range of networking tools and capabilities. These are just some of the key networking services available in Azure:

- [Azure Application Gateway](https://azure.microsoft.com/services/application-gateway). Build secure, scalable, highly available web front ends.
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute). Experience a fast, reliable, and private connection to Azure.
- [Azure Firewall](https://azure.microsoft.com/services/azure-firewall). Use a cloud-native, next-generation firewall to provide protection for your Azure Virtual Network resources.
- [Azure Load Balancer](https://azure.microsoft.com/products/azure-load-balancing). Deliver high availability and network performance to your apps.
- [Azure Private Link](https://azure.microsoft.com/services/private-link). Enable private access to services that are hosted on the Azure platform while keeping your data on the Microsoft network.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network). Provision private networks, and optionally connect to on-premises datacenters.
- [Azure Virtual WAN](https://azure.microsoft.com/services/virtual-wan). Optimize and automate branch-to-branch connectivity through Azure.
- [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway). Establish secure, cross-premises connectivity.

For more about information more Azure networking services, see [Azure networking](https://azure.microsoft.com/product-categories/networking).

## Introduction to networking on Azure
If you're new to networking on Azure, the best way to learn more is with [Microsoft Learn](https://docs.microsoft.com/learn/?WT.mc_id=learnaka), a free online training platform. Microsoft Learn provides interactive training for Microsoft products and more.

Here's a good introduction: 
- [Explore Azure networking services](/learn/modules/azure-networking-fundamentals)

And here's a comprehensive learning path: 
- [Configure and manage virtual networks for Azure administrators](/learn/paths/azure-administrator-manage-virtual-networks)

## Path to production
Consider these technologies and solutions as you plan and implement your deployment: 
- [Azure Firewall architecture overview](/azure/architecture/example-scenario/firewalls) 
- [Azure Private Link in a hub-and-spoke network](/azure/architecture/guide/networking/private-link-hub-spoke-network)
- [Build solutions with availability zones](/azure/architecture/high-availability/building-solutions-for-high-availability) 
- [Add IP address spaces to peered virtual networks](/azure/architecture/networking/prefixes/add-ip-space-peered-vnet)
- [Choose between virtual network peering and VPN gateways](/azure/architecture/reference-architectures/hybrid-networking/vnet-peering)
- [Use Azure ExpressRoute with Microsoft Power Platform](/power-platform/guidance/expressroute/overview?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)


## Best practices
The [Azure Well-Architected Framework](/azure/architecture/framework) is a set of guiding tenets, based on five pillars, that you can use to improve the quality of your architectures. These reviews provide guidance for each of the pillars: 
- [Azure Well-Architected Framework review of Azure Application Gateway](/azure/architecture/networking/guide/waf-application-gateway) 
- [Azure Well-Architected Framework review of Azure Firewall](/azure/architecture/networking/guide/well-architected-framework-azure-firewall) 
- [Azure Well-Architected Framework review of an Azure NAT gateway](/azure/architecture/networking/guide/well-architected-network-address-translation-gateway) 

The [Cloud Adoption Framework](/azure/cloud-adoption-framework) is a collection of documentation, implementation guidance, best practices, and tools that are designed to accelerate your cloud adoption. You might find these helpful as you plan and implement your networking solution: 
- [Connectivity to other cloud providers - Cloud Adoption Framework](/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-other-providers?view=o365-worldwide&toc=https:%2f%2fdocs.microsoft.com%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fazure%2farchitecture%2fbread%2ftoc.json) 
- [Connectivity to Oracle Cloud Infrastructure - Cloud Adoption Framework](/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-other-providers-oci?view=o365-worldwide&toc=https:%2f%2fdocs.microsoft.com%2fazure%2farchitecture%2ftoc.json&bc=https:%2f%2fdocs.microsoft.com%2fazure%2farchitecture%2fbread%2ftoc.json) 

## Networking architectures
### HA

### hybrid

### hu and spoke

### vwan

### multiregion 

### Stay current with networking

## Additional resources 

### Example solutions 
These are some additional sample implementations of networking on Azure:

[See more networking examples on the Azure Architecture Center]
 
### AWS or GCP professionals
These articles provide service mapping and comparison between Azure and other cloud services. They can help you ramp up quickly on Azure.
- [Compare AWS and Azure networking options](/azure/architecture/aws-professional/networking) 
- [Google Cloud to Azure services comparison - Networking](/azure/architecture/gcp-professional/services#networking)


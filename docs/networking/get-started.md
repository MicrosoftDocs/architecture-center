---
title: Get Started with Networking Architecture Design
description: Learn about sample architectures, solutions, and guides that can help you explore the various networking services in Azure.
author: anaharris-ms
ms.author: pnp
ms.date: 06/10/2026
ms.topic: concept-article
ms.subservice: category-get-started
ms.update-cycle: 1095-days
---

# Get started with networking architecture design

Designing and implementing Azure networking capabilities is a critical part of your cloud solution. You need to make networking design decisions to properly support your workloads and services.

## Azure services for networking

Azure provides a range of services for networking:

### Networking foundation

- [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview): Provision private networks, and optionally connect to on-premises datacenters.
- [Azure DNS](/azure/dns/dns-overview). Host your DNS domains and manage name resolution.
- [Azure NAT Gateway](/azure/nat-gateway/nat-overview): Provide outbound internet connectivity for virtual networks.
- [Azure Bastion](/azure/bastion/bastion-overview): Connect securely to your virtual machines without exposing public IP addresses.
- [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview): Distribute traffic optimally to services across global Azure regions.
- [Azure Route Server](/azure/route-server/overview): Simplify dynamic routing between your network virtual appliance and your virtual network.
- [Azure Private Link](/azure/private-link/private-link-overview): Enable private access to services that are hosted on the Azure platform while keeping your data on the Microsoft network.

### Load balancing and content delivery

- [Azure Load Balancer](/azure/load-balancer/load-balancer-overview): Deliver high availability and network performance to your apps.
- [Azure Application Gateway](/azure/application-gateway/overview): Build highly secure, scalable, highly available web front ends.
- [Azure Front Door](/azure/frontdoor/front-door-overview): Deliver, protect, and monitor your global web applications.

### Hybrid connectivity

- [Azure ExpressRoute](/azure/expressroute/expressroute-introduction): Create a fast, reliable, and private connection to Azure.
- [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways): Establish highly secure cross-premises connectivity.
- [Azure Virtual WAN](/azure/virtual-wan/virtual-wan-about): Optimize and automate branch-to-branch connectivity.
- [Azure Peering Service](/azure/peering-service/about): Enhance connectivity from the public internet to Microsoft cloud services.

### Network security

- [Azure Firewall](/azure/firewall/overview): Provide protection for your Azure Virtual Network resources.
- [Azure Firewall Manager](/azure/firewall-manager/overview): Centrally manage security policies and routes across multiple firewalls.
- [Azure Web Application Firewall](/azure/web-application-firewall/overview): Protect your web applications from common web exploits and vulnerabilities.
- [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview): Protect your Azure resources from distributed denial-of-service attacks.
- [Container Network Security](/azure/aks/advanced-container-networking-services-overview#container-network-security): Enforce security policies for containerized workloads in Azure Kubernetes Service (AKS) clusters.

### Network management and monitoring

- [Azure Network Watcher](/azure/network-watcher/network-watcher-overview): Monitor, diagnose, and gain insights into your network performance and health.
- [Azure Monitor](/azure/azure-monitor/fundamentals/overview): Collect, analyze, and act on telemetry from your network and other Azure resources.
- [Azure Virtual Network Manager](/azure/virtual-network-manager/overview): Centrally manage virtual networks at scale across subscriptions and regions.
- [Container Network Observability](/azure/aks/advanced-container-networking-services-overview#container-network-observability): Gain deep insights into network traffic and performance across containerized environments in Azure Kubernetes Service (AKS) clusters.

For more information about Azure networking services, see [Azure networking services overview](/azure/networking/networking-overview).

For guidance on selecting the right networking technologies for your solution, see the following articles:

- [Load balancing options](/azure/architecture/guide/technology-choices/load-balancing-overview)
- [Virtual network connectivity options and spoke-to-spoke communication](/azure/architecture/reference-architectures/hybrid-networking/virtual-network-peering)

## Architecture

:::image type="complex" border="false" source="../_images/hub-spoke-network-topology-architecture.svg" alt-text="Diagram that shows a hub-spoke virtual network topology architecture." lightbox="../_images/hub-spoke-network-topology-architecture.svg":::
   Diagram that shows a hub-spoke network layout in Azure. A large outer frame labeled Azure Virtual Network Manager contains a central hub virtual network and four spoke virtual networks around it. On the left, outside the hub, a cross-premises network contains two virtual machines and a gateway icon. In the middle, the hub virtual network contains three services: Azure Bastion at the top, Azure Firewall in the center, and Azure VPN Gateway or Azure ExpressRoute at the bottom. Azure Monitor appears to the right of the hub, connected to the hub services by dashed lines labeled Diagnostics. Two production spoke virtual networks appear on the right, one above the other. Each production spoke contains a resource subnet that contains three virtual machines. Dashed lines labeled Forced tunnel run from both production spokes toward the hub firewall area. At the bottom, there are two nonproduction spoke virtual networks, each with a resource subnet that contains three virtual machines. Dotted lines between the lower spokes indicate that they can be peered or directly connected. Other dotted lines show spoke virtual networks connecting to or peering through the hub. Across the top, a dotted bidirectional line labeled virtual network peering connects the hub to the upper production spoke.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/hub-spoke-network-topology-architecture.vsdx) of this architecture.*

The previous diagram demonstrates a typical basic or baseline networking implementation.

## Explore networking guides and architectures  

The articles in this section include guides and fully developed architectures that you can deploy in Azure and expand to production-grade solutions. These articles can help you decide how to use networking technologies in Azure.

[!INCLUDE [networking-get-started](../includes/networking-get-started-include.md)]

## Organizational readiness

Organizations at the beginning of the cloud adoption process can use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) to access proven guidance that accelerates cloud adoption. The following articles can help you plan and implement your networking solution:

- [Network topology and connectivity](/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity): Review the network topology and connectivity design area for Azure landing zones.
- [Connectivity to other cloud providers](/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-other-providers): Establish enterprise-grade connections between Azure and other cloud providers.
- [Connectivity to Oracle Cloud Infrastructure](/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-other-providers-oci): Set up secure, high-performance connectivity between Azure and Oracle Cloud Infrastructure.

To help ensure the quality of your networking solution on Azure, follow guidance in the [Azure Well-Architected Framework](/azure/well-architected/). The Well-Architected Framework provides prescriptive guidance for organizations that seek architectural excellence and describes how to design, provision, and monitor cost-optimized Azure solutions. For networking-specific guidance, see the following Well-Architected Framework service guides:

- [Architecture best practices for Azure Application Gateway v2](/azure/well-architected/service-guides/azure-application-gateway)
- [Architecture best practices for Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute)
- [Architecture best practices for Azure Firewall](/azure/well-architected/service-guides/azure-firewall)
- [Architecture best practices for Azure Front Door](/azure/well-architected/service-guides/azure-front-door)
- [Architecture best practices for Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer)
- [Architecture best practices for Azure Traffic Manager](/azure/well-architected/service-guides/azure-traffic-manager)
- [Architecture best practices for Azure Virtual Network](/azure/well-architected/service-guides/virtual-network)
- [Architecture best practices for Azure Virtual WAN](/azure/well-architected/service-guides/azure-virtual-wan)

## Best practices

Apply these best practices to improve the security, reliability, performance, and operational quality of your networking workloads on Azure.

- [Architecture best practices for Azure Application Gateway v2](/azure/well-architected/service-guides/azure-application-gateway): Review Well-Architected Framework guidance for designing secure, reliable, and performant Application Gateway deployments.

- [Architecture best practices for Azure Firewall](/azure/well-architected/service-guides/azure-firewall): Review Well-Architected Framework guidance for Azure Firewall deployments, including security, cost optimization, and operational best practices.

- [Architecture best practices for Azure Virtual Network](/azure/well-architected/service-guides/virtual-network): Review Well-Architected Framework guidance for virtual network design, including segmentation, IP address planning, and network security.

- [Architecture best practices for Azure Virtual WAN](/azure/well-architected/service-guides/azure-virtual-wan): Review Well-Architected Framework guidance for Azure Virtual WAN deployments, including security, reliability, and performance recommendations.

- [Azure best practices for network security](/azure/security/fundamentals/network-best-practices): Apply network security best practices, including Zero Trust principles, network segmentation guidance, and load balancing strategies.

- [Azure Private Link in a hub-and-spoke network](/azure/architecture/networking/guide/private-link-hub-spoke-network): Plan the deployment of private endpoints in hub-and-spoke or Azure Virtual WAN network topologies.

- [Recommendations for using availability zones and regions](/azure/well-architected/design-guides/regions-availability-zones): Select the right deployment approach across availability zones and regions to meet your reliability requirements.

- [Virtual network connectivity options and spoke-to-spoke communication](/azure/architecture/reference-architectures/hybrid-networking/virtual-network-peering): Compare virtual network peering, VPN gateways, and other connectivity options for spoke-to-spoke communication.

- [Use Azure ExpressRoute with Power Platform](/power-platform/architecture/key-concepts/expressroute/overview?toc=%2Fazure%2Farchitecture%2Ftoc.json&bc=%2Fazure%2Farchitecture%2F_bread%2Ftoc.json): Configure Azure ExpressRoute connectivity for Microsoft Power Platform workloads.

## Stay current with networking

Azure networking services evolve to address modern data challenges. Stay informed about the latest [updates and features](https://azure.microsoft.com/updates/).

To stay current with key networking services, see the following articles:

- [What's new in Azure VPN Gateway?](/azure/vpn-gateway/whats-new)
- [What's new in Azure Virtual WAN?](/azure/virtual-wan/whats-new)
- [What's new in Azure Load Balancer?](/azure/load-balancer/whats-new)

## Other resources

The following resources can help you discover more about networking.

### Cloud platform resources

- [Traditional Azure networking topology](/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology): Review design considerations and recommendations for traditional hub-and-spoke network topologies in Azure, including virtual network peering, Azure ExpressRoute, and VPN gateway configurations.

- [What is an Azure landing zone?](/azure/cloud-adoption-framework/ready/landing-zone/): Learn about the standardized approach for setting up and managing your Azure environment at scale, including hub-and-spoke and Azure Virtual WAN networking topologies.

- [Baseline highly available zone-redundant web application](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant): Deploy a secure, zone-redundant web application on Azure with Azure Application Gateway, Azure Private Link, and virtual network integration.

- [Network topology and connectivity for Azure VMware Solution](/azure/cloud-adoption-framework/scenarios/azure-vmware/eslz-network-topology-connectivity): Design network topology and connectivity for Azure VMware Solution deployments, including Azure ExpressRoute, Global Reach, and hub-and-spoke or Azure Virtual WAN integration.

- [Azure Private Link and DNS integration at scale](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale): Configure Azure Private Link and private DNS zones at scale in enterprise environments, including policy-driven DNS record management and centralized DNS architecture.

## Amazon Web Services (AWS) or Google Cloud professionals

To help you get started quickly, the following articles compare Azure networking options to other cloud services and provide migration guidance.

### Service comparison

- [Compare AWS and Azure networking options](/azure/architecture/aws-professional/networking): Compare the core networking services of AWS and Azure, including virtual networks, VPN, load balancing, DNS, Private Link, and peering.
- [Google Cloud to Azure services comparison - Networking](/azure/architecture/gcp-professional/services#networking): Compare Google Cloud networking services to Azure equivalents, including VPC, DNS, load balancing, VPN, ExpressRoute, and firewall services.

### Migration guidance

If you're migrating from another cloud platform, see the following article:

- [Migrate networking from AWS to Azure](/azure/migration/migrate-networking-from-aws): Review networking migration guides for moving AWS networking services to Azure, including VPN gateway connectivity, Application Load Balancer migration, Network Load Balancer migration, and API Gateway migration.

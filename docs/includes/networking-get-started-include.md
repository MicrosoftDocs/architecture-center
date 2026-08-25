### Networking guides

The following articles help you evaluate and select the best networking technologies for your workload requirements.

#### Networking foundation

- [Virtual network connectivity options and spoke-to-spoke communication](/azure/architecture/reference-architectures/hybrid-networking/virtual-network-peering): Compare virtual network peering, VPN gateways, and other connectivity options for spoke-to-spoke communication.
- [Azure Private Link in a hub-and-spoke network](/azure/architecture/networking/guide/private-link-hub-spoke-network): Use Private Link in a hub-and-spoke network topology.
- Azure Private Link and DNS with Azure Virtual WAN:
  - [Guide overview](/azure/architecture/networking/guide/private-link-virtual-wan-dns-guide): Plan Azure Private Link and DNS integration with Azure Virtual WAN.
  - [Virtual hub extension pattern](/azure/architecture/networking/guide/private-link-virtual-wan-dns-virtual-hub-extension-pattern): Implement the virtual hub extension pattern for Azure Private Link and DNS.
  - [Single region accessing a single resource](/azure/architecture/networking/guide/private-link-virtual-wan-dns-single-region-workload): Configure Azure Private Link and DNS for a single-region workload that accesses a single resource.
- Adopt IPv6:
  - [Prevent IPv4 exhaustion](/azure/architecture/networking/guide/internet-protocol-version-4-exhaustion): Plan for IPv4 address exhaustion, and adopt IPv6 in Azure.
  - [IPv6 hub-spoke network topology](/azure/architecture/networking/guide/ipv6-architecture): Implement a hub-spoke network topology with IPv6 support.
  - [Conceptual planning for IPv6 networking](/azure/architecture/networking/guide/ipv6-ip-planning): Plan your IPv6 IP addressing strategy for Azure networking.
- [Design a hybrid DNS solution by using Azure](/azure/architecture/hybrid/hybrid-dns-infra): Design a hybrid DNS solution that uses Azure DNS Private Resolver to resolve names for workloads hosted on-premises and on Azure.

#### Load balancing and content delivery

- [Load balancing options](/azure/architecture/guide/technology-choices/load-balancing-overview): Choose the right Azure load balancing service for your workload.

#### Hybrid connectivity

- [SD-WAN integration in hub-and-spoke network topologies](/azure/architecture/networking/guide/sdwan-integration-in-hub-and-spoke-network-topologies): Integrate SD-WAN solutions with Azure hub-and-spoke network topologies.
- [Troubleshoot a hybrid VPN connection](/azure/architecture/reference-architectures/hybrid-networking/troubleshoot-vpn): Troubleshoot connectivity problems in site-to-site VPN connections between an on-premises network and Azure.

#### Network security

- [Use a split-brain DNS configuration to host a web app](/azure/architecture/example-scenario/networking/split-brain-dns): Configure split-brain DNS to host a web application with private and public resolution.
- [Deploy highly available NVAs](/azure/architecture/networking/guide/network-virtual-appliance-high-availability): Deploy network virtual appliances (NVAs) in a highly available configuration.
- [Cross-tenant secure access to apps](/azure/architecture/networking/guide/cross-tenant-secure-access-private-endpoints): Use private endpoints to enable cross-tenant secure access to applications.

### Networking architectures

The following production-ready architectures demonstrate end-to-end networking solutions that you can deploy and customize.

#### Networking foundation

- [Hub-spoke network topology in Azure](/azure/architecture/networking/architecture/hub-spoke): Implement a hub-and-spoke network pattern that has customer-managed hub infrastructure components.
- [Azure DNS Private Resolver](/azure/architecture/networking/architecture/azure-dns-private-resolver): Implement hybrid DNS resolution by using Azure DNS Private Resolver.

#### Hybrid connectivity

- [Hub-spoke network topology that uses Azure Virtual WAN](/azure/architecture/networking/architecture/hub-spoke-virtual-wan-architecture): Implement a hub-and-spoke network topology by using Azure Virtual WAN for Microsoft-managed hub infrastructure.
- [Massive-scale Azure Virtual WAN architecture design](/azure/architecture/networking/architecture/massive-scale-azure-architecture): Design a massive-scale Azure Virtual WAN network architecture across multiple Azure regions.
- [Azure Virtual WAN optimized for department-specific requirements](/azure/architecture/networking/architecture/performance-security-optimized-vwan): Optimize an Azure Virtual WAN architecture for department-specific performance and security requirements.
- [Connect an on-premises network to Azure](/azure/architecture/reference-architectures/hybrid-networking/): Compare options for connecting an on-premises network to Azure, including Azure VPN Gateway and Azure ExpressRoute.
- [Connect an on-premises network to Azure by using Azure ExpressRoute with VPN failover](/azure/architecture/reference-architectures/hybrid-networking/expressroute-vpn-failover): Use Azure ExpressRoute as the primary connection to Azure and Azure VPN Gateway as a backup connection.

#### Network security

- [Implement TIC 3.0 compliance](/azure/architecture/networking/architecture/trusted-internet-connections): Implement Trusted Internet Connections (TIC) 3.0 compliance for internet-facing applications.
- [Implement a secure hybrid network](/azure/architecture/reference-architectures/dmz/secure-vnet-dmz): Extend an on-premises network to Azure by using a perimeter network and Azure Firewall.


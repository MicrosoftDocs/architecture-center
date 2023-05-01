This article presents a solution for using Azure DNS Private Resolver to simplify hybrid recursive domain name system (DNS) resolution. You can use Azure DNS Private Resolver for on-premises workloads and Azure workloads. Azure DNS Private Resolver simplifies private DNS resolution from on-premises to Azure Private DNS and vice versa.

## Architecture

The following sections present alternatives for hybrid recursive DNS resolution. The first section discusses a solution that uses a DNS forwarder virtual machine (VM). Subsequent sections explain how to use Azure DNS Private Resolver.

### Use a DNS forwarder VM

Before Azure DNS Private Resolver was available, a DNS forwarder VM was deployed so that an on-premises server could resolve Azure Private DNS. The following diagram illustrates the details of this name resolution. A conditional forwarder on the on-premises DNS server forwards requests to Azure, and a private DNS zone is linked to a virtual network. Requests to the Azure service then resolve to the appropriate private IP address.
  
In this solution, you can't use the Azure public DNS service to resolve on-premises domain names.

:::image type="content" source="./media/dns-forwarder-architecture.png" alt-text="Architecture diagram that shows a solution without Azure DNS Private Resolver. Traffic from an on-premises server to an Azure database is visible." border="false" lightbox="./media/dns-forwarder-architecture.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/US-1968331-azure-dns-private-resolver.pptx) of this architecture.*

#### Workflow

1. A client VM sends a name resolution request for azsql1.database.windows.net to an on-premises internal DNS server.

1. A conditional forwarder is configured on the internal DNS server. That forwarder forwards the DNS query for database.windows.net to 10.5.0.254, which is the address of a DNS forwarder VM.

1. The DNS forwarder VM sends the request to 168.63.129.16, the IP address of the Azure internal DNS server.

1. The Azure DNS server sends a name resolution request for azsql1.database.windows.net to the Azure recursive resolvers. The resolvers respond with the canonical name (CNAME) azsql1.privatelink.database.windows.net.

1. The Azure DNS server sends a name resolution request for azsql1.privatelink.database.windows.net to the private DNS zone privatelink.database.windows.net. The private DNS zone responds with the private IP address 10.5.0.5.

1. The response that associates the CNAME azsql1.privatelink.database.windows.net with the A record 10.5.0.5 arrives at the DNS forwarder.

1. The response arrives at the on-premises internal DNS server.

1. The response arrives at the client VM.

1. The client VM establishes a private connection to the private endpoint that uses the AP address 10.5.0.5. The private endpoint provides the client VM with a secure connection to an Azure database.

For more information, see [Azure private endpoint DNS configuration](/azure/private-link/private-endpoint-dns).

### Use Azure DNS Private Resolver

When you use Azure DNS Private Resolver, you don't need a DNS forwarder VM, and Azure DNS is able to resolve on-premises domain names.

The following solution uses Azure DNS Private Resolver in a [hub-spoke network topology](../../reference-architectures/hybrid-networking/hub-spoke.yml?tabs=cli). As a best practice, the Azure landing zone design pattern recommends using this type of topology. A hybrid network connection is established by using [Azure ExpressRoute](/azure/expressroute/expressroute-introduction) and [Azure Firewall](/azure/firewall). This setup provides a [secure hybrid network](../../reference-architectures/dmz/secure-vnet-dmz.yml?tabs=portal). Azure DNS Private Resolver is deployed in the hub network.

:::image type="content" source="./media/azure-dns-private-resolver-architecture.png" alt-text="Architecture diagram that shows an on-premises network connected to an Azure hub-and-spoke network. Azure DNS Private Resolver is in the hub network." border="false" lightbox="./media/azure-dns-private-resolver-architecture.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/US-1968331-azure-dns-private-resolver.pptx) of this architecture.*

#### Workflow

The solution that uses Azure DNS Private Resolver contains the following components:

- An on-premises network. This network of customer datacenters is connected to Azure via ExpressRoute or a site-to-site Azure VPN Gateway connection. Network components include two local DNS servers. One uses the IP addresses 192.168.0.1. The other uses 192.168.0.2. Both servers work as resolvers or forwarders for all computers inside the on-premises network.

  An administrator creates all local DNS and Azure endpoints on these servers. Conditional forwarders are configured on these servers for the Azure Blob Storage and API private endpoint DNS zones. Those forwarders forward requests to the Azure DNS Private Resolver inbound connection. The inbound endpoint uses the IP address 10.0.0.8 and is hosted within the hub virtual network.

  The following table lists the records on the local servers.

  | Domain name | IP address | Record type |
  | --- | --- | ---|
  | App1.onprem.company.com | 192.168.0.8 | Address mapping |
  | App2.onprem.company.com | 192.168.0.9 | Address mapping |
  | blob.core.windows.net | 10.0.0.8 | DNS forwarder |
  | azure-api.net | 10.0.0.8 | DNS forwarder |

- A hub network.

  - VPN Gateway or an ExpressRoute connection is used for the hybrid connection to Azure.
  - Azure Firewall provides a managed firewall as a service. The firewall instance resides in its own subnet.
  - The following table lists the parameters that are configured for Azure DNS Private Resolver. For App1 and App2 DNS names, the DNS forwarding rule set is configured.
  
  | Parameter | IP address |
  | ----- | ----- |
  | Virtual network | 10.0.0.0/24 |
  | Inbound endpoint subnet | 10.0.0.0/28 |
  | Inbound endpoint IP address | 10.0.0.8 |
  | Outbound endpoint subnet | 10.0.0.16/28 |
  | Outbound endpoint IP address | 10.0.0.19 |

  - The hub virtual network is linked to the private DNS zones for Blob Storage and the API service.

- Spoke networks.

  - VMs are hosted in all spoke networks for testing and validating DNS resolution.
  - All Azure spoke virtual networks use the default Azure DNS server at the IP address 168.63.129.16. All spoke networks are optionaly peered with the hub virtual network.
  - The spoke virtual networks are linked to private DNS zones, which makes it possible to resolve the names of private endpoint link services like privatelink.blob.core.windows.net.

#### Traffic flow for an on-premises DNS query

The following diagram shows the traffic flow that results when an on-premises server issues a DNS request.

:::image type="content" source="./media/azure-dns-private-resolver-on-premises-query-traffic.png" alt-text="Architecture diagram that shows Azure DNS Private Resolver name resolution traffic when an on-premises server queries an Azure private DNS record." border="false" lightbox="./media/azure-dns-private-resolver-on-premises-query-traffic.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/US-1968331-azure-dns-private-resolver.pptx) of this architecture.*

1. An on-premises server queries an Azure private DNS record such as blob.core.windows.net. The request is sent to the local DNS server at IP address 192.168.0.1 or 192.168.0.2. All on-premises computers point to the local DNS server.

1. A conditional forwarder on the local DNS server for blob.core.windows.net forwards the request to the DNS resolver at IP address 10.0.0.8.

1. The DNS resolver queries Azure DNS and receives information about an Azure Private DNS virtual network link.

1. Azure Private DNS resolves DNS queries that are sent through the Azure public DNS service to the DNS resolver inbound endpoint.

#### Traffic flow for a spoke DNS query (Usecase 1)

The following diagram shows the traffic flow that results when VM 1 issues a DNS request. In this case, the Spoke 1 spoke network attempts to resolve the request.

:::image type="content" source="./media/azure-dns-private-resolver-spoke-query-traffic.png" alt-text="Architecture diagram that shows name resolution traffic with Azure DNS Private Resolver when a spoke VM issues a DNS request." border="false" lightbox="./media/azure-dns-private-resolver-spoke-query-traffic.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/US-1968331-azure-dns-private-resolver.pptx) of this architecture.*

1. VM 1 queries a DNS record. The spoke virtual networks are configured to use the name resolution that Azure provides. As a result, Azure DNS is used to resolve the DNS query.

1. If the query attempts to resolve a private name, Azure Private DNS is contacted.

1. If the query doesn't match a private DNS zone that's linked to the virtual network, Azure DNS connects to Azure DNS Private Resolver. A virtual network link exists for the Spoke 1 virtual network. Azure DNS Private Resolver checks for a DNS forwarding rule set that's associated with the Spoke 1 virtual network.

1. If a match is found in the DNS forwarding rule set, the DNS query is forwarded via the outbound endpoint to the IP address that's specified in the rule set.

1. If Azure Private DNS (**2**) and Azure DNS Private Resolver (**3**) can't find a matching record, Azure DNS is used to resolve the query.

Each DNS forwarding rule specifies one or more target DNS servers to use for conditional forwarding. Specified information includes the domain name, target IP address, and port.

#### Traffic flow for a spoke DNS query (Usecase 2)

The following diagram shows the traffic flow that results when VM 1 issues a DNS request via DNS Private Resolver Inbound endpoint. In this case, the Spoke 1 spoke network attempts to resolve the request.

:::image type="content" source="./media/azure-dns-private-resolver-spoke-query-traffic.png" alt-text="Architecture diagram that shows name resolution traffic with Azure DNS Private Resolver when a spoke VM issues a DNS request." border="false" lightbox="./media/azure-dns-private-resolver-spoke-query-traffic.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/US-1968331-azure-dns-private-resolver.pptx) of this architecture.*

1. VM 1 queries a DNS record. The spoke virtual networks are configured to use 10.0.0.8 as the name resolution  DNS server. As a result, DNS Private Resolver is used to resolve the DNS query.

1. If the query attempts to resolve a private name, Azure Private DNS is contacted.

1. If the query doesn't match a private DNS zone that's linked to the virtual network, Azure DNS connects to Azure DNS Private Resolver. A virtual network link exists for the Spoke 1 virtual network. Azure DNS Private Resolver checks for a DNS forwarding rule set that's associated with the Spoke 1 virtual network.

1. If a match is found in the DNS forwarding rule set, the DNS query is forwarded via the outbound endpoint to the IP address that's specified in the rule set.

1. If Azure Private DNS (**2**) and Azure DNS Private Resolver (**3**) can't find a matching record, Azure DNS (**5**) is used to resolve the query.

Each DNS forwarding rule specifies one or more target DNS servers to use for conditional forwarding. Specified information includes the domain name, target IP address, and port.

#### Traffic flow for a spoke DNS query (Usecase 3)

The following diagram shows the traffic flow that results when VM 1 issues a DNS request via on-premise DNS server. In this case, the Spoke 1 spoke network attempts to resolve the request.

:::image type="content" source="./media/azure-dns-private-resolver-spoke-query-traffic.png" alt-text="Architecture diagram that shows name resolution traffic with Azure DNS Private Resolver when a spoke VM issues a DNS request." border="false" lightbox="./media/azure-dns-private-resolver-spoke-query-traffic.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/US-1968331-azure-dns-private-resolver.pptx) of this architecture.*

1. VM 1 queries a DNS record. The spoke virtual networks are configured to use 192.168.0.1/2 as the name resolution  DNS server. As a result, on-premise DNS server is used to resolve the DNS query.

1. The request is sent to the local DNS server at IP address 192.168.0.1 or 192.168.0.2.

1. A conditional forwarder on the local DNS server for blob.core.windows.net forwards the request to the DNS resolver at IP address 10.0.0.8.

1. The DNS resolver queries Azure DNS and receives information about an Azure Private DNS virtual network link.

1. Azure Private DNS resolves DNS queries that are sent through the Azure public DNS service to the DNS resolver inbound endpoint.


#### Components

- [VPN Gateway](https://azure.microsoft.com/services/vpn-gateway) is a virtual network gateway that you can use to send encrypted traffic:

  - Between an Azure virtual network and an on-premises location over the public internet.
  - Between Azure virtual networks over the Azure backbone network.

- [ExpressRoute](https://azure.microsoft.com/services/expressroute) extends on-premises networks into the Microsoft cloud. By using a connectivity provider, ExpressRoute establishes private connections to cloud components like Azure services and Microsoft 365.

- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block for private networks in Azure. Through Virtual Network, Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks.

- [Azure Firewall](https://azure.microsoft.com/services/azure-firewall) enforces application and network connectivity policies. This network security service centrally manages the policies across multiple virtual networks and subscriptions.

- [Azure DNS Private Resolver](/azure/dns/dns-private-resolver-overview) is a service that bridges an on-premises DNS with Azure DNS. You can use this service to query Azure DNS private zones from an on-premises environment and vice versa without deploying VM-based DNS servers.

- [Azure DNS](https://azure.microsoft.com/services/dns) is a hosting service for DNS domains. Azure DNS uses Azure infrastructure to provide name resolution.

- [Azure Private DNS](/azure/dns/private-dns-overview) manages and resolves domain names in a virtual network and in connected virtual networks. When you use this service, you don't need to configure a custom DNS solution. When you use private DNS zones, you can use custom domain names instead of the names that Azure provides during deployment.

- [DNS forwarders](/windows-server/identity/ad-ds/plan/reviewing-dns-concepts#resolving-names-by-using-forwarding) are DNS servers that forward queries to servers that are outside the network. The DNS forwarder only forwards queries for names that it can't resolve.

## Scenario details

Azure offers various DNS solutions:

- Azure DNS is a hosting service for DNS domains. By default, Azure virtual networks use Azure DNS for DNS resolution. Microsoft manages and maintains Azure DNS.
- Azure Traffic Manager acts as a DNS-based load balancing service. It provides a way to distribute traffic across Azure regions to public-facing applications.
- Azure Private DNS provides a DNS service for virtual networks. You can use Azure private DNS zones to resolve your own domain names and VM names without having to configure a custom solution and without modifying your own configuration. During deployment, you can use custom domain names instead of names that Azure provides if you use private DNS zones.
- Azure DNS Private Resolver Preview is a cloud-native, highly available, DevOps-friendly service. It provides a straightforward, zero-maintenance, reliable, and secure DNS service. You can use this service to resolve DNS names that are hosted in Azure DNS private zones from on-premises networks. You can also use the service for DNS queries for your own domain names.

Before Azure DNS Private Resolver was available, you had to use custom DNS servers for DNS resolution from on-premises systems to Azure and vice versa. Custom DNS solutions have many disadvantages:

- Managing multiple custom DNS servers for multiple virtual networks involves high infrastructure and licensing costs.
- You have to handle all aspects of installing, configuring, and maintaining DNS servers.
- Overhead tasks, such as monitoring and patching these servers, are complex and prone to failure.
- There's no DevOps support for managing DNS records and forwarding rules.
- It's expensive to implement scalable DNS server solutions.

Azure DNS Private Resolver overcomes these obstacles by providing the following features and key advantages:

- A fully managed Microsoft service with built-in high availability and zone redundancy.
- A scalable solution that works well with DevOps.
- Cost savings when compared with traditional infrastructure as a service (IaaS)–based custom solutions.
- Conditional forwarding for Azure DNS to on-premises servers. The outbound endpoint provides this capability, which hasn't been available in the past. Workloads in Azure no longer require direct connections to on-premises DNS servers. Instead, the Azure workloads connect to the outbound IP address of Azure DNS Private Resolver.

### Potential use cases

This solution simplifies private DNS resolution in hybrid networks. It applies to many scenarios:

- Transition strategies during long-term migration to fully cloud-native solutions
- Disaster recovery and fault tolerance solutions that replicate data and services between on-premises and cloud environments
- Solutions that host components in Azure to reduce latency between on-premises datacenters and remote locations

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

#### Regional availability

For a list of regions in which Azure DNS Private Resolver is available, see [Regional availability](/azure/dns/dns-private-resolver-overview#regional-availability).

A DNS resolver can only refer to a virtual network that's in the same region as the DNS resolver.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Azure DNS supports the extended ASCII encoding set for text (TXT) record sets. For more information, see [Azure DNS FAQ](/azure/dns/dns-faq#does-azure-dns-support-the-extended-ascii-encoding--8-bit--set-for-txt-record-sets-).

Azure DNS doesn't currently support DNS security extensions (DNSSEC). But users have requested this feature.

### Cost optimization

Cost optimization looks at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- As a solution, Azure DNS Private Resolver is largely cost-effective. One of the primary benefits of Azure DNS Private Resolver is that it's fully managed, which eliminates the need for dedicated servers.
- To calculate the cost of Azure DNS Private Resolver, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). For Azure DNS Private Resolver pricing models, see [Azure DNS pricing](https://azure.microsoft.com/pricing/details/dns).
- Pricing also includes availability and scalability features.
- ExpressRoute supports two billing models:

  - Metered data, which charges you per gigabyte for outbound data transfers
  - Unlimited data, which charges you a fixed monthly port fee that covers all inbound and outbound data transfers

  For more information, see [Azure ExpressRoute pricing](https://azure.microsoft.com/pricing/details/expressroute).

- If you use VPN Gateway instead of ExpressRoute, the cost varies by the SKU and is charged per hour. For more information, see [VPN Gateway pricing](https://azure.microsoft.com/pricing/details/vpn-gateway).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Azure DNS Private Resolver is a fully managed Microsoft service that can handle millions of requests. Use a subnet address space between /28 and /24. For most users, /26 works best. For more information, see [Subnet restrictions](/azure/dns/dns-private-resolver-overview#subnet-restrictions).

### Networking

The following resources provide more information about creating a private DNS resolver:

- [Create an Azure DNS Private Resolver using the Azure portal](/azure/dns/dns-private-resolver-get-started-portal)
- [Create an Azure DNS Private Resolver using Azure PowerShell](/azure/dns/dns-private-resolver-get-started-powershell)

#### Reverse DNS support

For detailed information about Azure support for reverse DNS and how reverse DNS works, see [Overview of reverse DNS and support in Azure](/azure/dns/dns-reverse-dns-overview).

Traditionally, DNS records map a DNS name to an IP address. For example, `www.contoso.com` resolves to 42.3.10.170. With reverse DNS, the mapping goes in the opposite direction. An IP address is mapped back to a name. For example, the IP address 42.3.10.170 resolves to `www.contoso.com`.

#### Restrictions

Azure DNS Private Resolver has the following limitations:

- Azure DNS Private Resolver can only resolve virtual networks that are within the same geographical region as the resolver.
- A virtual network can't contain more than one DNS resolver.
- You need to assign a dedicated subnet to each inbound and outbound endpoint.

For more information, see [Virtual network restrictions](/azure/dns/dns-private-resolver-overview#virtual-network-restrictions).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Moorthy Annadurai](https://www.linkedin.com/in/moorthy-annadurai) | Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is a virtual network link?](/azure/dns/private-dns-virtual-network-links)
- [What is Azure DNS?](/azure/dns/dns-overview)
- [What is Azure Private DNS?](/azure/dns/private-dns-overview)
- [What is Azure DNS Private Resolver?](/azure/dns/dns-private-resolver-overview)
- [Azure DNS FAQ](/azure/dns/dns-faq)
- [Overview of reverse DNS and support in Azure](/azure/dns/dns-reverse-dns-overview)

## Related resources

- [Azure files accessed on-premises and secured by AD DS](../hybrid/azure-files-on-premises-authentication.yml)
- [Design a hybrid Domain Name System solution with Azure](../../hybrid/hybrid-dns-infra.yml)
- [Azure enterprise cloud file share](../../hybrid/azure-files-private.yml)

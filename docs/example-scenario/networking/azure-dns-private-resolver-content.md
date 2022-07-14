This article presents a solution for using Azure DNS Private Resolver to simplify hybrid recursive DNS resolution. You can use Azure Private DNS Resolver for on-premises workloads and Azure workloads. Azure Private DNS Resolver simplifies private DNS resolution from on-premises to Azure Private DNS and vice-versa.

## Architecture

Add filler sentence.

### Use DNS forwarder VM

Before Azure DNS Private Resolver was available, a DNS forwarder VM was deployed so that an on-premises server could resolve the Azure private DNS service. The following diagram illustrates the details of this name resolution. A conditional forwarder on the on-premises DNS server forwards requests to Azure, and a private DNS zone is linked to a virtual network. Requests to the Azure service then resolve to the appropriate private IP address.
  
You can't use the Azure public DNS service to resolve on-premises domain names.

:::image type="content" source="./media/manage-routing-azure-route-server-architecture.png" alt-text="Architecture diagram that shows how data flows between local networks, a hub virtual network, a spoke virtual network, and various gateways." border="false" lightbox="./media/manage-routing-azure-route-server-architecture.svg":::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

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

For more information, see [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns).

### Use a Azure DNS Private Resolver

The following architecture uses a [hub-spoke network topology](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?tabs=cli). As a best practice, the Azure Landing Zone design pattern recommends using this type of topology. A hybrid network connection is also established by using [Azure ExpressRoute](https://azure.microsoft.com/en-us/services/expressroute/) and [Azure Firewall](https://docs.microsoft.com/en-us/azure/firewall/). This setup provides a [secure hybrid network](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/dmz/secure-vnet-dmz?tabs=portal). Azure DNS Private Resolver is deployed in the hub network.

:::image type="content" source="./media/manage-routing-azure-route-server-architecture.png" alt-text="Architecture diagram that shows how data flows between local networks, a hub virtual network, a spoke virtual network, and various gateways." border="false" lightbox="./media/manage-routing-azure-route-server-architecture.svg":::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

#### Workflow

The solution that uses Azure DNS Private Resolver contains the following components:

- An on-premises network. This network of customer datacenters is connected to Azure via ExpressRoute or a site-to-site VPN. Network components include two local DNS servers that use the IP addresses 192.168.0.1 and 192.168.0.2, respectively. Both servers work as resolvers or forwarders for all the computers inside the on-premises network.

  An administrator creates all local DNS and Azure endpoints on these servers. Conditional forwarders are configured on these servers for the blob and API private endpoint DNS zones. Those forwarders forward requests to the Azure DNS Private Resolver inbound connection. It uses the IP address 10.0.0.8 and is hosted within the hub virtual network.

  - App1.onprem.company.com - 192.168.0.8
  - App2.onprem.company.com - 192.168.0.9
  - privatelink.blob.core.windows.net - 10.0.0.8 (DNS forwarder record)
  - privatelink.azure-api.net - 10.0.0.8 (DNS forwarder record)

- A hub network.

  - A VPN gateway or an ExpressRoute connection is used for the hybrid connection to Azure.
  - Azure Firewall provides a managed firewall as a service. The firewall instance resides in its own subnet.
  - The following table lists the parameters that are configured for Azure DNS Private Resolver. For App1 and App2 DNS names, the DNS forwarding rule set is configured.
  
  | Parameter | IP address |
  | ----- | ----- |
  | Virtual network | 10.0.0.0/24 |
  | Inbound endpoint subnet | 10.0.0.0/28 |
  | Inbound endpoint IP address | 10.0.0.8 |
  | Outbound endpoint subnet | 10.0.0.16/28 |
  | Outbound endpoint IP address | 10.0.0.19 |

  - The hub virtual network is linked to the private DNS zones for the Azure blob and API services.

- Spoke networks.

  - VMs are hosted in all spoke networks for testing and validating DNS resolution.
  - All Azure spoke virtual networks use the default Azure DNS server at the IP address 192.63.129.16. All spoke networks are peered with the hub virtual network.
  - The spoke virtual networks are linked to private DNS zones, which makes it possible to resolve the names of private endpoint link services like privatelink.blob.core.windows.net.

### Traffic flow for an on-premises DNS query

The following diagram shows the traffic flow that results when an on-premises server issues a DNS request.

:::image type="content" source="./media/manage-routing-azure-route-server-architecture.png" alt-text="Architecture diagram that shows how data flows between local networks, a hub virtual network, a spoke virtual network, and various gateways." border="false" lightbox="./media/manage-routing-azure-route-server-architecture.svg":::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

1. An on-premises server queries an Azure private DNS record such as privatelink.blob.core.windows.net. The request is sent to the local DNS server at IP address 192.168.0.1 or 192.168.0.2. All on-premises computers point to the local DNS server.

1. A conditional forwarder on the local DNS server for privatelink.blob.core.windows.net forwards the request to the DNS resolver at IP address 10.0.0.8.

1. The DNS resolver queries the Azure public DNS service and receives information about an Azure private DNS virtual network link.

1. The Azure private DNS service resolves DNS queries that are sent through the Azure public DNS service to the DNS resolver inbound endpoint.

### Traffic flow for a spoke DNS query

The following diagram shows the traffic flow that results when VM 1 issues a DNS request. In this case, the Spoke 1 spoke network attempts to resolve the request.

:::image type="content" source="./media/manage-routing-azure-route-server-architecture.png" alt-text="Architecture diagram that shows how data flows between local networks, a hub virtual network, a spoke virtual network, and various gateways." border="false" lightbox="./media/manage-routing-azure-route-server-architecture.svg":::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

1. VM 1 queries a DNS record. The spoke virtual networks are configured to use the name resolution that Azure provides. As a result, the Azure public DNS service is used to resolve the DNS query.

1. If the query attempts to resolve a private name, the Azure private DNS service is contacted.

1. If the query doesn't match a private DNS zone that's linked to the virtual network, the public Azure DNS service connects to Azure DNS Private Resolver. A virtual network link exists for the Spoke 1 virtual network. Azure DNS Private Resolver checks for a DNS forwarding ruleset that's associated with the Spoke 1 virtual network.

1. If a match is found in the DNS forwarding ruleset, the DNS query is forwarded via the outbound endpoint to the IP address that's specified in the ruleset.

1. If the Azure private DNS service (**2**) and Azure DNS Private Resolver (**3**) couldn't find a matching record, the Azure public DNS service is used to resolve the query.

Each DNS forwarding rule specifies one or more target DNS servers to use for conditional forwarding. Specified information includes the domain name, target IP address, and port.

### Components

- [VPN Gateway](https://azure.microsoft.com/en-us/services/vpn-gateway/) is a virtual network gateway that you can use to send encrypted traffic:

  - Between an Azure virtual network and an on-premises location over the public internet.
  - Between Azure virtual networks over the Azure backbone network.

- [Azure ExpressRoute](https://azure.microsoft.com/en-us/services/expressroute/) extends on-premises networks into the Microsoft cloud. By using a connectivity provider, ExpressRoute establishes private connections to cloud components like Azure services and Microsoft 365.

- [Azure Virtual Network](https://azure.microsoft.com/en-us/services/virtual-network/) is the fundamental building block for private networks in Azure. Through Virtual Network, Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks.

- [Azure Firewall](https://azure.microsoft.com/en-us/services/azure-firewall/) enforces application and network connectivity policies. This network security service centrally manages the policies across multiple virtual networks and subscriptions.

- [Azure DNS Private Resolver](https://docs.microsoft.com/en-us/azure/dns/dns-private-resolver-overview) is a service that bridges an on-premises domain name system (DNS) with Azure DNS. You can use this service to query Azure DNS private zones from an on-premises environment and vice versa without deploying VM-based DNS servers.

- [Azure DNS](https://azure.microsoft.com/en-us/services/dns/) is a hosting service for DNS domains. Azure DNS uses Azure infrastructure to provide name resolution.

- The [Azure private DNS service](https://docs.microsoft.com/en-us/azure/dns/private-dns-overview) manages and resolves domain names in a virtual network and connected virtual networks. When you use this service, you don't need to configure a custom DNS solution. By using private DNS zones, you can use custom domain names instead of the names that Azure provides during deployment.

- [DNS forwarders](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/plan/reviewing-dns-concepts#resolving-names-by-using-forwarding) are DNS servers that forward queries to servers that are outside the network. The DNS forwarder only forwards queries for names that it can't resolve.

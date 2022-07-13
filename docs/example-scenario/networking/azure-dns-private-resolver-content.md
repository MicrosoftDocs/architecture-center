This article presents a solution for using Azure DNS Private Resolver to simplify hybrid recursive DNS resolution. You can use Azure Private DNS Resolver for on-premises workloads and Azure workloads. Azure Private DNS Resolver simplifies private DNS resolution from on-premises to Azure Private DNS and vice-versa.

## Architecture

Before Azure DNS Private Resolver was available, you deployed a DNS forwarder VM so that an on-premises server could resolve Azure Private DNS (maybe the Azure DNS IP address). The following diagram illustrates the details of this name resolution. DNS is resolved by an on-premises network conditionally forwarded to Azure. This is done by a private DNS zone linked to a virtual network.
  
Additionally, there is no way for Azure Public DNS to resolve against on-premises domain names. 



1. A client VM sends a name resolution request for azsql1.database.windows.net to an on-premises internal DNS server.

1. A conditional forwarder is configured on the internal DNS server. That forwarder forwards the DNS query for database.windows.net to 10.5.0.254, which is the address of a DNS forwarder VM.

1. The DNS forwarder VM sends the request to 168.63.129.16, the IP address of the Azure internal DNS server.

1. The Azure DNS server sends a name resolution request for azsql1.database.windows.net to the Azure recursive resolvers. The resolvers respond with the canonical name (CNAME) azsql1.privatelink.database.windows.net.

1. The Azure DNS server sends a name resolution request for azsql1.privatelink.database.windows.net to the private DNS zone privatelink.database.windows.net. The private DNS zone responds with the private IP address 10.5.0.5.

1. The response that associates the CNAME azsql1.privatelink.database.windows.net with the A record 10.5.0.5 arrives at the DNS forwarder.

1. The response arrives at the on-premises internal DNS server.

1. The response arrives at the client VM.

1. The client VM establishes a private connection to the private endpoint that uses the AP address 10.5.0.5. The private endpoint provides the client VM with a secure connection to an Azure database.

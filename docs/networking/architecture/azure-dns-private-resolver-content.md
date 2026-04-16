This article describes a solution for using Azure DNS Private Resolver to simplify hybrid recursive Domain Name System (DNS) resolution. You can use DNS Private Resolver for on-premises workloads and Azure workloads. DNS Private Resolver simplifies private DNS resolution from on-premises to Azure private DNS and from Azure private DNS to on-premises.

## Architecture

The following sections describe alternatives for hybrid recursive DNS resolution. The first section describes a solution that uses a DNS forwarder virtual machine (VM). Subsequent sections describe how to use DNS Private Resolver.

### Use a DNS forwarder VM

Before DNS Private Resolver was available, a DNS forwarder VM was deployed so that an on-premises server could resolve requests to Azure private DNS. The following diagram shows the details of this name resolution. A conditional forwarder on the on-premises DNS server forwards requests to Azure, and a private DNS zone links to a virtual network. Requests to the Azure service resolve to the appropriate private IP address.
  
In this solution, you can't use Azure public DNS to resolve on-premises domain names.

:::image type="complex" border="false" source="./_images/dns-forwarder-architecture.svg" alt-text="Architecture diagram that shows a solution without DNS Private Resolver. Traffic from an on-premises server to an Azure database is shown." lightbox="./_images/dns-forwarder-architecture.svg":::
   In the image, a map key shows DNS traffic and private connections. An on-premises virtual network section contains the internal DNS and the client VM. DNS traffic arrows point back and forth between them. An arrow points from internal DNS to an IP address section via a DNS traffic arrow labeled conditional forwarder. Next to this section is a DNS section that contains vmdns, the forward and reverse lookup zones, trust points, and conditional forwarders. DNS traffic arrows connect the on-premises network section and the VNet-hub-001 section. The snet-consumer subnet in this section includes the DNS forwarder and Azure Private Link endpoint. A private connection arrow points to the Private Link endpoint from the client VM and from Private Link endpoint to the SQL database. The adjoining section shows Azure-provided DNS. DNS arrows point from this section to the private DNS zone and to Azure recursive resolvers. A virtual network link connects the VNet-hub-001 section to the private DNS zone.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/azure-dns-private-resolver.pptx) of this architecture.*

#### Workflow

The following workflow corresponds to the previous diagram:

1. A client VM sends a name resolution request for `azsql1.database.windows.net` to an on-premises internal DNS server.

1. A conditional forwarder is set up on the internal DNS server. It forwards the DNS query for `database.windows.net` to `10.5.0.254`, which is the IP address of a DNS forwarder VM.

1. The DNS forwarder VM sends the request to `168.63.129.16`, which is the IP address of the Azure internal DNS server.

1. The Azure DNS server sends a name resolution request for `azsql1.database.windows.net` to the Azure recursive resolvers. The resolvers return the canonical name (CNAME) `azsql1.privatelink.database.windows.net`.

1. The Azure DNS server sends a name resolution request for `azsql1.privatelink.database.windows.net` to the private DNS zone `privatelink.database.windows.net`. The private DNS zone returns the private IP address `10.5.0.5`.

1. The response that associates the CNAME `azsql1.privatelink.database.windows.net` with the record `10.5.0.5` arrives at the DNS forwarder.

1. The response arrives at the on-premises internal DNS server.

1. The response arrives at the client VM.

1. The client VM establishes a private connection to the private endpoint that uses the IP address `10.5.0.5`. The private endpoint provides the client VM with a more secure connection to an Azure database.

For more information, see [Azure private endpoint DNS configuration](/azure/private-link/private-endpoint-dns).

### Use DNS Private Resolver

When you use DNS Private Resolver, you don't need a DNS forwarder VM, and Azure DNS can resolve on-premises domain names directly.

The following solution uses DNS Private Resolver in a [hub-spoke network topology](../../reference-architectures/hybrid-networking/hub-spoke.yml). As a best practice, the Azure landing zone design pattern recommends that you use this type of topology. The solution establishes a hybrid network connection by using [Azure ExpressRoute](/azure/expressroute/expressroute-introduction) and [Azure Firewall](/azure/firewall/overview). This setup provides a [secure hybrid network](../../reference-architectures/dmz/secure-vnet-dmz.yml). DNS Private Resolver resides in the hub network.

:::image type="complex" border="false" source="./_images/azure-dns-private-resolver-architecture.svg" alt-text="Architecture diagram that shows an on-premises network connected to an Azure hub-and-spoke network. DNS Private Resolver is in the hub network." lightbox="./_images/azure-dns-private-resolver-architecture.svg":::
   The image has three primary sections. The largest section is an Azure hub-and-spoke network. This section includes Azure DNS, Azure private DNS, and DNS Private Resolver. It also includes a site-to-site or ExpressRoute gateway, an inbound endpoint, and an outbound endpoint. The outbound endpoint connects via a dotted line to the DNS forwarding rule set. This rule set connects via a dotted line to spoke 1 in the Azure section. ExpressRoute connects the site-to-site or ExpressRoute gateway to the on-premises section. This section contains the on-premises server, Windows desktops, App 1, App 2, App 3, and local DNS servers with their IP addresses.
:::image-end:::

#### DNS Private Resolver solution components

The solution that uses DNS Private Resolver contains the following components:

- An on-premises network. This network of customer datacenters connects to Azure via ExpressRoute or a site-to-site Azure VPN Gateway connection. Network components include two local DNS servers. One server uses the IP address `192.168.0.1`. The other server uses `192.168.0.2`. Both servers function as resolvers or forwarders for all computers inside the on-premises network.

  An admin creates all local DNS records and Azure endpoint forwarders on these servers. The admin sets up conditional forwarders on these servers for Azure Blob Storage and Azure API Management. Those forwarders send requests to the DNS Private Resolver inbound connection. The inbound endpoint uses the IP address `10.0.0.8` and is hosted within the hub virtual network.

  The following table lists the records on the local servers.

  | Domain name | IP address | Record type |
  | --- | --- | --- |
  | `App1.onpremises.company.com` | 192.168.0.8 | Address mapping |
  | `App2.onpremises.company.com` | 192.168.0.9 | Address mapping |
  | `blob.core.windows.net` | 10.0.0.8 | DNS forwarder |
  | `azure-api.net` | 10.0.0.8 | DNS forwarder 

- A hub network.

  - VPN Gateway or ExpressRoute provides the hybrid connection to Azure.

  - Azure Firewall provides a managed firewall. The firewall instance resides in its own subnet.

  - The following table lists the parameters set up for DNS Private Resolver. The DNS forwarding rule set is configured for App 1 and App 2 DNS names.
  
    | Parameter | IP address |
    | ----- | ----- |
    | Virtual network | 10.0.0.0/24 |
    | Inbound endpoint subnet | 10.0.0.0/28 |
    | Inbound endpoint IP address | 10.0.0.8 |
    | Outbound endpoint subnet | 10.0.0.16/28 |
    | Outbound endpoint IP address | 10.0.0.19 |

  - The hub virtual network links to the private DNS zones for Blob Storage and API Management.

- Spoke networks.

  - VMs are hosted in all spoke networks for testing and validating DNS resolution.

  - All Azure spoke virtual networks use the default Azure DNS server at the IP address `168.63.129.16`. All spoke virtual networks peer with the hub virtual network. The network routes all traffic through the hub, including traffic to and from DNS Private Resolver.

  - The spoke virtual networks link to private DNS zones. This configuration lets them resolve the names of private endpoint link services like `privatelink.blob.core.windows.net`.

#### Traffic flow for an on-premises DNS query

The following diagram shows the traffic flow that results when an on-premises server issues a DNS request.

:::image type="complex" border="false" source="./_images/azure-dns-private-resolver-on-premises-query-traffic-usecase-1.svg" alt-text="Architecture diagram that shows DNS Private Resolver name resolution traffic when an on-premises server queries an Azure private DNS service record." lightbox="./_images/azure-dns-private-resolver-on-premises-query-traffic-usecase-1.svg":::
   The image has two main sections that ExpressRoute connects. The on-premises section contains the on-premises server, Windows desktops, App 1, App 2, App 3, the DNS query, and servers. The Azure section includes a site-to-site or ExpressRoute gateway, the inbound and outbound endpoints, Azure DNS, Azure private DNS, DNS Private Resolver, and two Azure provisioned DNS sections that each contain a spoke and a VM.
:::image-end:::

1. An on-premises server queries an Azure private DNS service record, like `blob.core.windows.net`. The on-premises server sends the request to the local DNS server at the IP address `192.168.0.1` or `192.168.0.2`. All on-premises computers point to the local DNS server.

1. A conditional forwarder on the local DNS server for `blob.core.windows.net` forwards the request to the DNS resolver at the IP address `10.0.0.8`.

1. The DNS resolver queries Azure DNS and receives information about an Azure private DNS virtual network link.

1. Azure private DNS resolves DNS queries that Azure public DNS sends to the DNS resolver inbound endpoint.

#### Traffic flow for a VM DNS query (decentralized)

The following diagram shows the traffic flow that results when VM 1 issues a DNS request. In this scenario, the spoke 1 virtual network attempts to resolve the request.

:::image type="complex" border="false" source="./_images/azure-dns-private-resolver-spoke-query-traffic-decentralized.svg" alt-text="Architecture diagram that shows name resolution traffic with DNS Private Resolver when a spoke VM issues a DNS request." lightbox="./_images/azure-dns-private-resolver-spoke-query-traffic-decentralized.svg":::
   The image includes two main sections. The on-premises section contains the on-premises server, Windows desktops, App 1, App 2, App 3, and servers and their IP addresses. ExpressRoute connects the on-premises section to the site-to-site or ExpressRoute gateway in the Azure section. The Azure section contains the inbound and outbound endpoints inside the gateway section, Azure DNS, Azure private DNS, DNS Private Resolver, and two Azure-provisioned DNS sections that each contain a spoke and a VM. Spoke 1 connects via DNS forwarding virtual network link to the DNS forwarding rule set. A dotted line connects this section to the outbound endpoint.
:::image-end:::

1. VM 1 queries a DNS record. The spoke virtual networks are set up to use the name resolution that Azure provides. As a result, Azure DNS resolves the DNS query.

1. If the query attempts to resolve a private name, Azure DNS contacts Azure private DNS.

1. If the query doesn't match a private DNS zone linked to the virtual network, Azure DNS connects to DNS Private Resolver. The spoke 1 virtual network has a virtual network link. DNS Private Resolver checks for a DNS forwarding rule set associated with the spoke 1 virtual network.

1. If DNS Private Resolver finds a match in the DNS forwarding rule set, it forwards the DNS query via the outbound endpoint to the IP address specified in the rule set.

1. If Azure private DNS (**2**) and DNS Private Resolver (**3**) can't find a matching record, Azure DNS (**5**) resolves the query.

   In this scenario, VM 2 has no DNS forwarding virtual network link associated with the DNS forwarding rule set. As a result, VM 2 can't resolve on‑premises DNS queries, like `App1.onpremises.company.com`.

Each DNS forwarding rule specifies one or more target DNS servers to use for conditional forwarding. The specified information includes the domain name, target IP address, and port.

#### Traffic flow for a VM DNS query via DNS Private Resolver (centralized)

The following diagram shows the traffic flow that results when VM 1 or VM 2 issues a DNS request via a DNS Private Resolver inbound endpoint. In this scenario, spoke VMs attempt to resolve the DNS request.

:::image type="complex" border="false" source="./_images/azure-dns-private-resolver-spoke-query-traffic-centralized.svg" alt-text="Architecture diagram that shows traffic with DNS Private Resolver when a spoke VM issues a DNS request." lightbox="./_images/azure-dns-private-resolver-spoke-query-traffic-centralized.svg":::
   The image includes two main sections. The on-premises section contains the on-premises server, Windows desktops, App 1, App 2, App 3, and servers and their IP addresses. ExpressRoute connects the on-premises section to the site-to-site or ExpressRoute gateway in the Azure section. The Azure section contains the inbound and outbound endpoints, Azure DNS, Azure private DNS, DNS Private Resolver, and two DNS server sections that each contain a spoke and a VM. An arrow indicates the flow between the DNS server sections, the inbound endpoint, Azure DNS, and Azure private DNS. The DNS server sections also connect via the DNS forwarding virtual network link to the DNS forwarding rule set. A dotted line connects this section to the outbound endpoint.
:::image-end:::

1. VM 1 or VM 2 queries a DNS record. The spoke virtual networks are set up to use `10.0.0.8` as the name resolution DNS server. As a result, DNS Private Resolver resolves the DNS query.

1. If the query attempts to resolve a private name, DNS Private Resolver contacts Azure private DNS.

1. If the query doesn't match a private DNS zone linked to the resolver virtual network, DNS Private Resolver checks for a DNS forwarding rule set associated with the resolver virtual network.

1. If DNS Private Resolver finds a match in the DNS forwarding rule set, it forwards the DNS query via the outbound endpoint to the IP address specified in the rule set.

1. If Azure private DNS (**2**) and DNS Private Resolver (**3**) can't find a matching record, Azure DNS (**5**) resolves the query.

Each DNS forwarding rule specifies one or more target DNS servers to use for conditional forwarding. The specified information includes the domain name, target IP address, and port.

#### Traffic flow for a VM DNS query via an on-premises DNS server

The following diagram shows the traffic flow that results when VM 1 or VM 2 issues a DNS request via an on-premises DNS server. In this scenario, spoke VMs attempt to resolve the DNS request.

:::image type="complex" border="false" source="./_images/azure-dns-private-resolver-spoke-query-traffic-on-premises.svg" alt-text="Architecture diagram that shows name resolution traffic with DNS Private Resolver when a spoke VM issues a DNS request." lightbox="./_images/azure-dns-private-resolver-spoke-query-traffic-on-premises.svg":::
   The image includes two main sections. The on-premises section contains the on-premises server, Windows desktops, App 1, App 2, App 3, and servers and their IP addresses. ExpressRoute connects the on-premises section to the site-to-site or ExpressRoute gateway section located in the Azure section. The Azure section contains the inbound and outbound endpoints, Azure DNS, Azure private DNS, DNS Private Resolver, and two DNS server sections that each contain a spoke and a VM. The DNS server sections also connect via the DNS forwarding virtual network link to the DNS forwarding rule set. An arrow shows the flow of operations.
:::image-end:::

1. VM 1 or VM 2 queries a DNS record. The spoke virtual networks use `192.168.0.1/2` as the name resolution DNS server. As a result, an on-premises DNS server resolves the DNS query. The VM sends the request to the local DNS server at IP address `192.168.0.1` or `192.168.0.2`.

1. A conditional forwarder on the local DNS server for `blob.core.windows.net` forwards the request to the DNS resolver at the IP address `10.0.0.8`.

1. The DNS resolver queries Azure DNS and receives information about an Azure private DNS service virtual network link.

1. Azure private DNS resolves DNS queries that Azure public DNS sends to the DNS Private Resolver inbound endpoint.

#### Traffic flow for a VM DNS query via DNS Private Resolver (nested DNS resolver)

The following diagram shows the traffic flow that results when VM 1 or VM 2 issues a DNS request via a hub DNS Private Resolver inbound endpoint. In this scenario, spoke VMs attempt to resolve the request to the nested DNS resolver.

:::image type="complex" border="false" source="./_images/azure-dns-private-resolver-spoke-query-traffic-nested.svg" alt-text="Architecture diagram that shows traffic with DNS Private Resolver when a spoke VM issues a DNS request." lightbox="./_images/azure-dns-private-resolver-spoke-query-traffic-nested.svg":::
   The image includes two main sections. The on-premises section contains the on-premises server, Windows desktops, App 1, App 2, App 3, and servers and their IP addresses. ExpressRoute connects the on-premises section to the site-to-site or ExpressRoute gateway in the Azure section. The Azure section contains the inbound and outbound endpoints, Azure DNS, Azure private DNS, DNS Private Resolver 1, DNS Private Resolver 2, and two DNS server sections that each contain a spoke and a VM. An arrow indicates the flow between the DNS server sections, the inbound endpoint, Azure DNS, and Azure private DNS. The DNS server sections also connect via the DNS forwarding virtual network link to the DNS forwarding rule set. A dotted line connects this section to the outbound endpoint.
:::image-end:::

1. VM 1 or VM 2 queries a DNS record. The spoke virtual networks are set up to use `10.0.0.8` as the name resolution DNS server. As a result, the hub DNS Private Resolver resolves the DNS query.

1. If the query attempts to resolve a private name, the hub resolver contacts the linked Azure private DNS service.

1. If the query doesn't match a private DNS zone linked to the hub resolver virtual network, DNS Private Resolver checks for a DNS forwarding rule set associated with the resolver virtual network.

1. If DNS Private Resolver finds a match in the DNS forwarding rule set, it forwards the DNS query via the outbound endpoint to the IP address specified in the rule set.

   In this scenario, because the hub resolver has no virtual network link to `privatelink.vaultcore.azure.net`, the DNS forwarding rule set forwards queries for `xyz.privatelink.vaultcore.azure.net` (**4.a**) to the nested DNS resolver as intended.

1. If Azure private DNS (**2**) and DNS Private Resolver (**3**) can't find a matching record, Azure DNS (**5**) resolves the query.

Each DNS forwarding rule specifies one or more target DNS servers to use for conditional forwarding. The specified information includes the domain name, target IP address, and port.

   In the following scenario, if a private DNS zone exists in both DNS Private Resolver instances (like `privatelink.blob.core.windows.net`), the hub resolver already links to that zone through its virtual network. Because this link is in place, the DNS forwarding rule set that should send queries for `privatelink.blob.core.windows.net` (**4.a**) to the nested DNS resolver doesn't take effect. This behavior is by design.

:::image type="complex" border="false" source="./_images/azure-dns-private-resolver-spoke-vm-query-nested-resolver-forwarding-bypass.svg" alt-text="Architecture diagram that shows traffic with DNS Private Resolver when a spoke VM issues a DNS request." lightbox="./_images/azure-dns-private-resolver-spoke-vm-query-nested-resolver-forwarding-bypass.svg":::
   The image includes two main sections. The on-premises section contains the on-premises server, Windows desktops, App 1, App 2, App 3, and servers and their IP addresses. ExpressRoute connects the on-premises section to the site-to-site or ExpressRoute gateway in the Azure section. The Azure section contains the inbound and outbound endpoints, Azure DNS, Azure private DNS, DNS Private Resolver 1, DNS Private Resolver 2 and DNS server sections that contain a spoke and a VM. An arrow indicates the flow between the DNS server sections, the inbound endpoint, Azure DNS, and Azure private DNS. The DNS server sections also connect via the DNS forwarding virtual network link to the DNS forwarding rule set. A dotted line connects this section to the outbound endpoint.
:::image-end:::

### Components

- [VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) is a virtual network gateway that sends encrypted traffic between an Azure virtual network and an on-premises location over the public internet. In this architecture, VPN Gateway is an alternative to ExpressRoute. It provides hybrid connectivity between Azure and on-premises environments for DNS conditional forwarder traffic.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a networking service that extends on-premises networks into the Microsoft cloud. It establishes private connections to cloud components like Azure services and Microsoft 365 through a connectivity provider. In this architecture, ExpressRoute supports hybrid connectivity between Azure and on-premises environments, specifically for DNS conditional forwarder traffic.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service and the foundational building block for private networks in Azure. Azure resources like VMs use virtual networks to securely communicate with each other, the internet, and on-premises networks. In this architecture, the virtual networks host DNS Private Resolver and Azure Virtual Machines. They facilitate communication and integration between various Azure services and on-premises resources.

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a managed, cloud-based network security service that enforces application and network connectivity policies. It centrally manages policies across multiple virtual networks and subscriptions. In this architecture, you can implement Azure Firewall to enhance security for network traffic. It provides advanced threat protection, network traffic filtering, and logging capabilities to allow only authorized traffic while blocking potential threats.

- [DNS Private Resolver](/azure/dns/dns-private-resolver-overview) is a service that bridges an on-premises DNS with Azure DNS. In this architecture, it facilitates DNS queries between Azure DNS private zones and an on-premises environment. This approach eliminates the need for VM-based DNS servers in Azure. This setup ensures efficient DNS resolution across hybrid environments, so Azure and on-premises resources can communicate DNS resolutions effectively.

- [Azure DNS](/azure/dns/dns-overview) is a hosting service for DNS domains that uses Azure infrastructure for name resolution. In this architecture, it manages DNS resolution traffic.

- [Azure private DNS](/azure/dns/private-dns-overview) is a managed DNS service that resolves domain names within a virtual network and connected virtual networks. It eliminates the need for custom DNS configuration. With private DNS zones, you can assign custom domain names instead of using the default names that Azure provides during deployment. In this architecture, Azure private DNS hosts the private endpoint DNS zones and returns private IP address records for Azure services.

- An [on-premises DNS conditional forwarder](/windows-server/identity/ad-ds/plan/reviewing-dns-concepts#resolving-names-by-using-forwarding) is a DNS server that forwards DNS queries that it can't resolve locally to another DNS server, like a DNS forwarder VM in Azure or the inbound endpoint of DNS Private Resolver. On‑premises workloads use this approach to accurately resolve Azure private endpoint fully qualified domain names (FQDNs) to their corresponding private IP addresses. It also ensures secure hybrid connectivity without relying on public DNS resolution. In this architecture, conditional forwarders on on-premises DNS servers route Azure-specific DNS queries to the DNS Private Resolver inbound endpoint in the hub network.

## Scenario details

Azure provides various DNS solutions, including Azure Traffic Manager. Traffic Manager functions as a DNS-based load balancing service. It provides a way to distribute traffic across Azure regions to public-facing applications.

Before DNS Private Resolver was available, custom DNS servers resolved names from on-premises systems to Azure and from Azure to on-premises systems. Custom DNS solutions have many disadvantages:

- Multiple custom DNS servers across multiple virtual networks create high infrastructure and licensing costs.

- Installation, configuration, and maintenance of DNS servers are the operator's responsibility.

- Overhead tasks like monitoring and patching the servers introduce complexity and frequent failure points.

- Lack of DevOps support limits automation for DNS records and forwarding rules.

- Scalable DNS server solutions are costly to implement.

DNS Private Resolver addresses these obstacles by providing the following features and key advantages:

- A fully managed Microsoft service that has built-in high availability and zone redundancy.

- A scalable solution optimized for integration with DevOps.

- Cost savings when compared with traditional infrastructure as a service (IaaS)-based custom solutions.

- Conditional forwarding for Azure DNS to on-premises servers. The outbound endpoint provides this capability, which wasn't previously available. Workloads in Azure no longer require direct connections to on-premises DNS servers. Azure workloads instead connect to the outbound IP address of DNS Private Resolver.

### Potential use cases

This solution simplifies private DNS resolution in hybrid networks. It applies to the following scenarios:

- Transition strategies during long-term migration to fully cloud-native solutions

- Disaster recovery and fault tolerance solutions that replicate data and services between on-premises and cloud environments

- Solutions that host components in Azure to reduce latency between on-premises datacenters and remote locations

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

DNS Private Resolver is a cloud-native service that provides high availability and integrates with DevOps practices, so it supports collaborative and automated workflows. It provides a reliable and secure DNS solution and requires no ongoing user maintenance.

Don't deploy DNS Private Resolver into a virtual network that includes an ExpressRoute virtual network gateway and uses wildcard rules to direct all name resolution to a specific DNS server. This type of configuration can cause management connectivity problems. For more information, see [DNS Private Resolver with wildcard rules on an ExpressRoute gateway](/azure/expressroute/expressroute-about-virtual-network-gateways#gateway-subnet).

#### Regional availability

For a list of regions where DNS Private Resolver is available, see [Regional availability](/azure/dns/dns-private-resolver-overview#regional-availability).

A DNS resolver can only refer to a virtual network that's located in the same region as the DNS resolver.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Azure DNS supports [DNS security extensions](/azure/dns/dnssec).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- DNS Private Resolver is a cost-effective solution because it's fully managed and highly available. Its managed design eliminates the need to deploy and maintain dedicated DNS servers.

- To calculate the cost of DNS Private Resolver, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). For DNS Private Resolver pricing models, see [Azure DNS pricing](https://azure.microsoft.com/pricing/details/dns).

- Pricing also includes availability and scalability features.

- ExpressRoute supports two billing models:

  - Metered data, which charges you per gigabyte (GB) for outbound data transfers

  - Unlimited data, which charges you a fixed monthly port fee that covers all inbound and outbound data transfers

  For more information, see [ExpressRoute pricing](https://azure.microsoft.com/pricing/details/expressroute).

- If you use VPN Gateway instead of ExpressRoute, pricing is based on the VPN Gateway SKU and is billed hourly. For more information, see [VPN Gateway pricing](https://azure.microsoft.com/pricing/details/vpn-gateway).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

DNS Private Resolver is a fully managed, highly available service that exposes queries‑per‑second (QPS) metrics for monitoring. The Azure platform automatically manages its capacity and performance. Deploy each inbound or outbound endpoint in a dedicated subnet with a `/28` or larger Classless Inter-Domain Routing (CIDR) block to provide sufficient IP addresses for scaling. For more information, see [Subnet restrictions](/azure/dns/dns-private-resolver-overview#subnet-restrictions).

### Networking

The following resources provide information about how to create a DNS private resolver:

- [Create a DNS private resolver by using the Azure portal](/azure/dns/dns-private-resolver-get-started-portal)
- [Create a DNS private resolver by using Azure PowerShell](/azure/dns/dns-private-resolver-get-started-powershell)

#### Reverse DNS support

Reverse DNS is the process of resolving an IP address to its associated hostname. DNS Private Resolver supports reverse DNS resolution when you set up appropriate reverse lookup zones within Azure private DNS zones. Traditionally, DNS records map a DNS name to an IP address. For example, `www.contoso.com` resolves to `42.3.10.170`. Reverse DNS handles inverse lookup and maps an IP address back to a DNS name. For example, the IP address `42.3.10.170` resolves to `www.contoso.com`.

For more information, see [Overview of reverse DNS and support in Azure](/azure/dns/dns-reverse-dns-overview).

#### Restrictions

DNS Private Resolver has the following limitations:

- You can link DNS Private Resolver rule sets only to virtual networks that are within the same geographical region as the resolver.

- A virtual network can't contain more than one DNS private resolver.

- You need to assign a dedicated subnet to each inbound and outbound endpoint.

For more information, see [Virtual network restrictions](/azure/dns/dns-private-resolver-overview#virtual-network-restrictions).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Moorthy Annadurai](https://www.linkedin.com/in/moorthy-annadurai/) | Senior Technical Specialist

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Virtual network link](/azure/dns/private-dns-virtual-network-links)
- [Azure DNS](/azure/dns/dns-overview)
- [Azure private DNS](/azure/dns/private-dns-overview)
- [DNS Private Resolver](/azure/dns/dns-private-resolver-overview)
- [Azure DNS FAQ](/azure/dns/dns-faq)
- [Overview of reverse DNS and support in Azure](/azure/dns/dns-reverse-dns-overview)

## Related resources

- [Azure Files accessed on-premises and secured by Active Directory Domain Services](../../example-scenario/hybrid/azure-files-on-premises-authentication.yml)
- [Design a hybrid DNS solution by using Azure](../../hybrid/hybrid-dns-infra.yml)
- [Azure enterprise cloud file share](../../hybrid/azure-files-private.yml)

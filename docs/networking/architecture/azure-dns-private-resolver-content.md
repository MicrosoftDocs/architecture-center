This article presents a solution for using Azure DNS Private Resolver to simplify hybrid recursive domain name system (DNS) resolution. You can use DNS Private Resolver for on-premises workloads and Azure workloads. DNS Private Resolver simplifies private DNS resolution from on-premises to the Azure private DNS service and from the Azure private DNS service to on-premises.

## Architecture

The following sections present alternatives for hybrid recursive DNS resolution. The first section describes a solution that uses a DNS forwarder virtual machine (VM). Subsequent sections explain how to use DNS Private Resolver.

### Use a DNS forwarder VM

Before DNS Private Resolver was available, a DNS forwarder VM was deployed so that an on-premises server could resolve requests to the Azure private DNS service. The following diagram illustrates the details of this name resolution. A conditional forwarder on the on-premises DNS server forwards requests to Azure, and a private DNS zone is linked to a virtual network. Requests to the Azure service then resolve to the appropriate private IP address.
  
In this solution, you can't use the Azure public DNS service to resolve on-premises domain names.

:::image type="complex" border="false" source="./_images/dns-forwarder-architecture.svg" alt-text="Architecture diagram that shows a solution without DNS Private Resolver. Traffic from an on-premises server to an Azure database is visible." lightbox="./_images/dns-forwarder-architecture.svg":::
   In the image, a map key shows DNS traffic as a black arrow and private connections as a blue arrow. An on-premises virtual network section contains the Internal DNS and the client VM. DNS traffic arrows point back and forth between them. An arrow points from Internal DNS to an IP address section via a DNS traffic arrow labeled Conditional forwarder. Next to this section is a DNS section that contains vmdns, the forward and reverse lookup zones, trust points, and conditional forwarders. DNS traffic arrows connect the on-premises network section and the VNet-hub-001 section. The snet-consumer subnet in this section includes the DNS forwarder and Private Link endpoint. A private connection arrow points to Private Link endpoint from the client VM and from Private Link endpoint to the SQL database. The adjoining section shows Azure-provided DNS. DNS arrows point from this section to the Private DNS zone and to Azure recursive resolvers. A virtual network link connects the VNet-hub-001 section to the Private DNS zone.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/azure-dns-private-resolver.pptx) of this architecture.*

#### Workflow

The following workflow corresponds to the previous diagram:

1. A client VM sends a name resolution request for `azsql1.database.windows.net` to an on-premises internal DNS server.

1. A conditional forwarder is configured on the internal DNS server. It forwards the DNS query for `database.windows.net` to `10.5.0.254`, which is the IP address of a DNS forwarder VM.

1. The DNS forwarder VM sends the request to `168.63.129.16`, which is the IP address of the Azure internal DNS server.

1. The Azure DNS server sends a name resolution request for `azsql1.database.windows.net` to the Azure recursive resolvers. The resolvers respond with the canonical name (CNAME) `azsql1.privatelink.database.windows.net`.

1. The Azure DNS server sends a name resolution request for `azsql1.privatelink.database.windows.net` to the private DNS zone `privatelink.database.windows.net`. The private DNS zone responds with the private IP address `10.5.0.5`.

1. The response that associates the CNAME `azsql1.privatelink.database.windows.net` with the record `10.5.0.5` arrives at the DNS forwarder.

1. The response arrives at the on-premises internal DNS server.

1. The response arrives at the client VM.

1. The client VM establishes a private connection to the private endpoint that uses the IP address `10.5.0.5`. The private endpoint provides the client VM with a more secure connection to an Azure database.

For more information, see [Azure private endpoint DNS configuration](/azure/private-link/private-endpoint-dns).

### Use DNS Private Resolver

When you use DNS Private Resolver, you don't need a DNS forwarder VM, and Azure DNS is able to resolve on-premises domain names.

The following solution uses DNS Private Resolver in a [hub-spoke network topology](../../reference-architectures/hybrid-networking/hub-spoke.yml). As a best practice, the Azure landing zone design pattern recommends that you use this type of topology. A hybrid network connection is established by using [Azure ExpressRoute](/azure/expressroute/expressroute-introduction) and [Azure Firewall](/azure/firewall/overview). This setup provides a [secure hybrid network](../../reference-architectures/dmz/secure-vnet-dmz.yml). DNS Private Resolver is in the hub network.

:::image type="complex" border="false" source="./_images/azure-dns-private-resolver-architecture.svg" alt-text="Architecture diagram that shows an on-premises network connected to an Azure hub-and-spoke network. DNS Private Resolver is in the hub network." lightbox="./_images/azure-dns-private-resolver-architecture.svg":::
   The image has three primary sections. The largest section is an Azure hub-and-spoke network. This section includes Azure DNS, Azure Private DNS, and Azure DNS Private Resolver. It also includes a site-to-site or Azure ExpressRoute gateway, an inbound endpoint, and an outbound endpoint. The outbound endpoint connects via a dotted line to the DNS forwarding rule set. This rule set connects via dotted lines to Spoke 1 and Spoke 2 in the Azure section. Azure ExpressRoute connects the site-to-site or Azure ExpressRoute gateway to the On-premises section. This section contains the on-premises server, Windows desktops, App 1, App 2, App 3, and local DNS servers with their IP addresses.
:::image-end:::

#### DNS Private Resolver solution components

The solution that uses DNS Private Resolver contains the following components:

- An on-premises network. This network of customer datacenters is connected to Azure via ExpressRoute or a site-to-site Azure VPN Gateway connection. Network components include two local DNS servers. One server uses the IP address `192.168.0.1`. The other server uses `192.168.0.2`. Both servers work as resolvers or forwarders for all computers inside the on-premises network.

  An administrator creates all local DNS records and Azure endpoint forwarders on these servers. Conditional forwarders are configured on these servers for the Azure Blob Storage and Azure API Management services. Those forwarders send requests to the DNS Private Resolver inbound connection. The inbound endpoint uses the IP address `10.0.0.8` and is hosted within the hub virtual network.

  The following table lists the records on the local servers.

  | Domain name | IP address | Record type |
  | --- | --- | ---|
  | `App1.onprem.company.com` | 192.168.0.8 | Address mapping |
  | `App2.onprem.company.com` | 192.168.0.9 | Address mapping |
  | `blob.core.windows.net` | 10.0.0.8 | DNS forwarder |
  | `azure-api.net` | 10.0.0.8 | DNS forwarder |

- A hub network.

  - VPN Gateway or an ExpressRoute connection is used for the hybrid connection to Azure.

  - Azure Firewall provides a managed firewall. The firewall instance resides in its own subnet.

  - The following table lists the parameters that are configured for DNS Private Resolver. For App 1 and App 2 DNS names, the DNS forwarding rule set is configured.
  
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

  - All Azure spoke virtual networks use the default Azure DNS server at the IP address `168.63.129.16`. And all spoke virtual networks are peered with the hub virtual networks. All traffic, including traffic to and from DNS Private Resolver, is routed through the hub.

  - The spoke virtual networks are linked to private DNS zones. This configuration makes it possible to resolve the names of private endpoint link services like `privatelink.blob.core.windows.net`.

#### Traffic flow for an on-premises DNS query

The following diagram shows the traffic flow that results when an on-premises server issues a DNS request.

:::image type="complex" border="false" source="./_images/azure-dns-private-resolver-on-premises-query-traffic.svg" alt-text="Architecture diagram that shows DNS Private Resolver name resolution traffic when an on-premises server queries an Azure private DNS service record." lightbox="./_images/azure-dns-private-resolver-on-premises-query-traffic.svg":::
   The image has two main sections that are connected by Azure ExpressRoute. The On-premises section contains the on-premises server, Windows desktops, App 1, App 2, App 3, the DNS query, and servers. The Azure section includes a site-to-site or Azure ExpressRoute gateway, the inbound and outbound endpoints, Azure DNS, Azure private DNS, Azure DNS Private Resolver, and two Azure provisioned DNS sections that each contain a spoke and a VM.
:::image-end:::

1. An on-premises server queries an Azure private DNS service record, such as `blob.core.windows.net`. The request is sent to the local DNS server at IP address `192.168.0.1` or `192.168.0.2`. All on-premises computers point to the local DNS server.

1. A conditional forwarder on the local DNS server for `blob.core.windows.net` forwards the request to the DNS resolver at IP address `10.0.0.8`.

1. The DNS resolver queries Azure DNS and receives information about an Azure private DNS service virtual network link.

1. The Azure private DNS service resolves DNS queries that are sent through the Azure public DNS service to the DNS resolver inbound endpoint.

#### Traffic flow for a VM DNS query

The following diagram shows the traffic flow that results when VM 1 issues a DNS request. In this scenario, the Spoke 1 spoke virtual network attempts to resolve the request.

:::image type="complex" border="false" source="./_images/azure-dns-private-resolver-spoke-query-traffic.svg" alt-text="Architecture diagram that shows name resolution traffic with DNS Private Resolver when a spoke VM issues a DNS request." lightbox="./_images/azure-dns-private-resolver-spoke-query-traffic.svg":::
   The image includes two main sections. The On-premises section contains the on-premises server, Windows desktops, App 1, App 2, App 3, and servers and their IP addresses. Azure ExpressRoute connects the On-premises section to the site-to site or Azure ExpressRoute gateway in the Azure section. The Azure section contains the inbound and outbound endpoints inside the gateway section, Azure DNS, Azure private DNS, Azure DNS Private Resolver, Azure provisioned DNS sections that contain a spoke and a VM. These sections connect via DNS forwarding virtual network link to the DNS forwarding rule set. A dotted line connects this section to the outbound endpoint.
:::image-end:::

1. VM 1 queries a DNS record. The spoke virtual networks are configured to use the name resolution that Azure provides. As a result, Azure DNS is used to resolve the DNS query.

1. If the query attempts to resolve a private name, the Azure private DNS service is contacted.

1. If the query doesn't match a private DNS zone linked to the virtual network, Azure DNS connects to DNS Private Resolver. The Spoke 1 virtual network has a virtual network link. DNS Private Resolver checks for a DNS forwarding rule set associated with the Spoke 1 virtual network.

1. If a match is found in the DNS forwarding rule set, the DNS query is forwarded via the outbound endpoint to the IP address specified in the rule set.

1. If the Azure private DNS service (**2**) and DNS Private Resolver (**3**) can't find a matching record, Azure DNS (**5**) is used to resolve the query.

Each DNS forwarding rule specifies one or more target DNS servers to use for conditional forwarding. The specified information includes the domain name, target IP address, and port.

#### Traffic flow for a VM DNS query via DNS Private Resolver

The following diagram shows the traffic flow that results when VM 1 issues a DNS request via a DNS Private Resolver inbound endpoint. In this scenario, the Spoke 1 spoke virtual network attempts to resolve the request.

:::image type="complex" border="false" source="./_images/azure-dns-private-resolver-spoke-query-traffic-uc2.svg" alt-text="Architecture diagram that shows traffic with DNS Private Resolver when a spoke VM issues a DNS request." lightbox="./_images/azure-dns-private-resolver-spoke-query-traffic-uc2.svg":::
   The image includes two main sections. The On-premises section contains the on-premises server, Windows desktops, App 1, App 2, App 3, and servers and their IP addresses. Azure ExpressRoute connects the On-premises section to the site-to site or Azure ExpressRoute gateway in the Azure section. The Azure section contains the inbound and outbound endpoints, Azure DNS, Azure Private DNS, Azure DNS Private Resolver, and DNS server sections that contain a spoke and a VM. A green arrow indicates the flow between the DNS server sections, the inbound endpoint, Azure DNS, and Azure private DNS. The DNS server sections also connect via the DNS forwarding virtual network link to the DNS forwarding rule set. A dotted line connects this section to the outbound endpoint.
:::image-end:::

1. VM 1 queries a DNS record. The spoke virtual networks are configured to use `10.0.0.8` as the name resolution DNS server. As a result, DNS Private Resolver is used to resolve the DNS query.

1. If the query attempts to resolve a private name, the Azure private DNS service is contacted.

1. If the query doesn't match a private DNS zone linked to the virtual network, Azure DNS connects to DNS Private Resolver. The Spoke 1 virtual network has a virtual network link. DNS Private Resolver checks for a DNS forwarding rule set associated with the Spoke 1 virtual network.

1. If a match is found in the DNS forwarding rule set, the DNS query is forwarded via the outbound endpoint to the IP address specified in the rule set.

1. If the Azure private DNS service (**2**) and DNS Private Resolver (**3**) can't find a matching record, Azure DNS (**5**) is used to resolve the query.

Each DNS forwarding rule specifies one or more target DNS servers to use for conditional forwarding. The specified information includes the domain name, target IP address, and port.

#### Traffic flow for a VM DNS query via an on-premises DNS server

The following diagram shows the traffic flow that results when VM 1 issues a DNS request via an on-premises DNS server. In this scenario, the Spoke 1 spoke virtual network attempts to resolve the request.

:::image type="complex" border="false" source="./_images/azure-dns-private-resolver-spoke-query-traffic-uc3.svg" alt-text="Architecture diagram that shows name resolution traffic with DNS Private Resolver when a spoke VM issues a DNS request." lightbox="./_images/azure-dns-private-resolver-spoke-query-traffic-uc3.svg":::
   The image includes two main sections. The On-premises section contains the on-premises server, Windows desktops, App 1, App 2, App 3, and servers and their IP addresses. Azure ExpressRoute connects the On-premises section to the site-to site or Azure ExpressRoute gateway section located in the Azure section. The Azure section contains the inbound and outbound endpoints, Azure DNS, Azure Private DNS, Azure DNS Private Resolver, and DNS server sections that contain a spoke and a VM. The DNS server sections also connect via the DNS forwarding virtual network link to the DNS forwarding rule set. A purple arrow shows the flow of operations.
:::image-end:::

1. VM 1 queries a DNS record. The spoke virtual networks are configured to use `192.168.0.1/2` as the name resolution DNS server. As a result, an on-premises DNS server is used to resolve the DNS query. The request is sent to the local DNS server at IP address `192.168.0.1` or `192.168.0.2`.

1. A conditional forwarder on the local DNS server for `blob.core.windows.net` forwards the request to the DNS resolver at IP address `10.0.0.8`.

1. The DNS resolver queries Azure DNS and receives information about an Azure private DNS service virtual network link.

1. The Azure private DNS service resolves DNS queries that are sent through the Azure public DNS service to the DNS Private Resolver inbound endpoint.

#### Components

- [VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) is a virtual network gateway that lets you send encrypted traffic between an Azure virtual network and an on-premises location over the public internet. In this architecture, a VPN gateway is an optional component for ExpressRoute that enables hybrid connectivity between Azure and on-premises environments for DNS conditional forwarder traffic.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a networking service that extends on-premises networks into the Microsoft cloud. It establishes private connections to cloud components like Azure services and Microsoft 365 through a connectivity provider. In this architecture, ExpressRoute is used for hybrid connectivity between Azure and on-premises environments, specifically for DNS conditional forwarder traffic.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service and the foundational building block for private networks in Azure. It lets Azure resources like VMs securely communicate with each other, the internet, and on-premises networks. In the previous design, the primary purpose of the virtual networks is to host the DNS Private Resolver and Azure Virtual Machines. These virtual networks facilitate seamless communication and integration between various Azure services and on-premises resources.

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a managed, cloud-based network security service that enforces application and network connectivity policies. It centrally manages policies across multiple virtual networks and subscriptions. In the previous use case, you can implement Azure Firewall to enhance security for network traffic. It provides advanced threat protection, network traffic filtering, and logging capabilities to allow only authorized traffic while blocking potential threats.

- [DNS Private Resolver](/azure/dns/dns-private-resolver-overview) is a service that bridges an on-premises DNS with Azure DNS. In this architecture, its primary function is to facilitate DNS queries between Azure DNS private zones and an on-premises environment. This facilitation eliminates the need for VM-based DNS servers. This setup ensures seamless and efficient DNS resolution across hybrid environments, which allows Azure and on-premises resources to communicate DNS resolutions effectively.

- [Azure DNS](/azure/dns/dns-overview) is a hosting service for DNS domains that takes advantage of Azure’s infrastructure for name resolution. It plays a crucial role in this design by managing DNS resolution traffic.

- The [Azure private DNS service](/azure/dns/private-dns-overview) is a managed DNS service that resolves domain names within a virtual network and connected virtual networks. It eliminates the need for custom DNS configuration. With private DNS zones, you can assign custom domain names instead of using the default names that Azure provides during deployment.

- [DNS forwarders](/windows-server/identity/ad-ds/plan/reviewing-dns-concepts#resolving-names-by-using-forwarding) are DNS servers that send queries to external servers when they can't resolve domain names on their own. This approach has long been a standard method for DNS resolution. In this article and its use cases, the DNS Private Resolver replaces VM-based DNS forwarders, which provides a more efficient and streamlined approach to DNS resolution.

## Scenario details

Azure provides various DNS solutions, including Azure Traffic Manager. Traffic Manager acts as a DNS-based load balancing service. It provides a way to distribute traffic across Azure regions to public-facing applications.

Before DNS Private Resolver was available, you had to use custom DNS servers for DNS resolution from on-premises systems to Azure and from Azure to on-premises systems. Custom DNS solutions have many disadvantages:

- Managing multiple custom DNS servers for multiple virtual networks involves high infrastructure and licensing costs.

- You have to handle all aspects of installing, configuring, and maintaining DNS servers.

- Overhead tasks, such as monitoring and patching these servers, are complex and prone to failure.

- There's no DevOps support for managing DNS records and forwarding rules.

- It's expensive to implement scalable DNS server solutions.

DNS Private Resolver addresses these obstacles by providing the following features and key advantages:

- A fully managed Microsoft service that has built-in high availability and zone redundancy.

- A scalable solution optimized for seamless integration with DevOps.

- Cost savings when compared with traditional infrastructure as a service-based custom solutions.

- Conditional forwarding for Azure DNS to on-premises servers. The outbound endpoint provides this capability, which wasn't previously available. Workloads in Azure no longer require direct connections to on-premises DNS servers. Instead, the Azure workloads connect to the outbound IP address of DNS Private Resolver.

### Potential use cases

This solution simplifies private DNS resolution in hybrid networks. It applies to the following scenarios:

- Transition strategies during long-term migration to fully cloud-native solutions

- Disaster recovery and fault tolerance solutions that replicate data and services between on-premises and cloud environments

- Solutions that host components in Azure to reduce latency between on-premises datacenters and remote locations

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

DNS Private Resolver is a cloud-native service designed for high availability and built to integrate seamlessly with DevOps practices, which makes it well-suited for collaborative and automated workflows. It delivers a reliable and enhanced security DNS solution while maintaining simplicity and zero-maintenance for users.

Don't deploy DNS Private Resolver into a virtual network that includes an ExpressRoute virtual network gateway and uses wildcard rules to direct all name resolution to a specific DNS server. This type of configuration can cause management connectivity problems. For more information, see [DNS Private Resolver with wildcard rules on an ExpressRoute gateway](/azure/expressroute/expressroute-about-virtual-network-gateways#gwsub).

#### Regional availability

For a list of regions in which DNS Private Resolver is available, see [Regional availability](/azure/dns/dns-private-resolver-overview#regional-availability).

A DNS resolver can only refer to a virtual network that's located in the same region as the DNS resolver.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Azure DNS has [DNS security extensions in preview](/azure/dns/dnssec).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- As a solution, DNS Private Resolver is largely cost-effective. One of the primary benefits of DNS Private Resolver is that it's fully managed. This feature eliminates the need for dedicated servers.

- To calculate the cost of DNS Private Resolver, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). For DNS Private Resolver pricing models, see [Azure DNS pricing](https://azure.microsoft.com/pricing/details/dns).

- Pricing also includes availability and scalability features.

- ExpressRoute supports two billing models:

  - Metered data, which charges you per gigabyte for outbound data transfers.

  - Unlimited data, which charges you a fixed monthly port fee that covers all inbound and outbound data transfers.

  For more information, see [ExpressRoute pricing](https://azure.microsoft.com/pricing/details/expressroute).

- If you use VPN Gateway instead of ExpressRoute, the cost varies by the product and is charged per hour. For more information, see [VPN Gateway pricing](https://azure.microsoft.com/pricing/details/vpn-gateway).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

DNS Private Resolver is a fully managed Microsoft service that can handle millions of requests. Use a subnet address space between /28 and /24. For most users, /26 is most suitable. For more information, see [Subnet restrictions](/azure/dns/dns-private-resolver-overview#subnet-restrictions).

### Networking

The following resources provide information about how to create a DNS private resolver:

- [Create a DNS private resolver by using the Azure portal](/azure/dns/dns-private-resolver-get-started-portal)

- [Create a DNS private resolver by using Azure PowerShell](/azure/dns/dns-private-resolver-get-started-powershell)

#### Reverse DNS support

Traditionally, DNS records map a DNS name to an IP address. For example, `www.contoso.com` resolves to `42.3.10.170`. Reverse DNS performs the opposite function. It maps an IP address back to a DNS name. For example, the IP address `42.3.10.170` resolves to `www.contoso.com`.

For more information about Azure support for reverse DNS and how reverse DNS works, see [Overview of reverse DNS and support in Azure](/azure/dns/dns-reverse-dns-overview).

#### Restrictions

DNS Private Resolver has the following limitations:

- DNS Private Resolver rule sets can only be linked to virtual networks that are within the same geographical region as the resolver.

- A virtual network can't contain more than one DNS private resolver.

- You need to assign a dedicated subnet to each inbound and outbound endpoint.

For more information, see [Virtual network restrictions](/azure/dns/dns-private-resolver-overview#virtual-network-restrictions).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Moorthy Annadurai](https://www.linkedin.com/in/moorthy-annadurai/) | Senior Technical Specialist

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is a virtual network link?](/azure/dns/private-dns-virtual-network-links)
- [What is Azure DNS?](/azure/dns/dns-overview)
- [What is the Azure private DNS service?](/azure/dns/private-dns-overview)
- [What is DNS Private Resolver?](/azure/dns/dns-private-resolver-overview)
- [Azure DNS FAQ](/azure/dns/dns-faq)
- [Overview of reverse DNS and support in Azure](/azure/dns/dns-reverse-dns-overview)

## Related resources

- [Azure files accessed on-premises and secured by Active Directory Domain Services](../../example-scenario/hybrid/azure-files-on-premises-authentication.yml)
- [Design a hybrid DNS solution with Azure](../../hybrid/hybrid-dns-infra.yml)
- [Azure enterprise cloud file share](../../hybrid/azure-files-private.yml)

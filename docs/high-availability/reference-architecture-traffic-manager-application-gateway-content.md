
This reference architecture serves web workloads with resilient multitier applications, and deploys across multiple Azure regions to achieve high availability and robust disaster recovery.

Microsoft Azure Traffic Manager balances the traffic across regions, and there is a regional load balancer based on Azure Application Gateway. This combination gets you the benefits of Traffic Manager's flexible routing, and Application Gateway's many capabilities, including:

- Web Application Firewall (WAF).
- Transport Layer Security (TLS) termination.
- Path-based routing.
- Cookie-based session affinity.

In this scenario, the application consists of three layers:

- **Web tier:** This is the top layer, and has the user interface. It parses user interactions and passes the actions to the business tier for processing.
- **Business tier:** Processes the user interactions and determines the next steps. It connects the web and data tiers.
- **Data tier:** Stores the application data, typically in a database, object storage, or files.

:::image type="content" source="images/high-availability-multi-region.png" alt-text="Multi-region load balancing with Application Gateway and Traffic Manager." lightbox="images/high-availability-multi-region.png":::

> [!NOTE]
> Azure provides a suite of fully managed load-balancing solutions. If you're looking for Transport Layer Security (TLS) protocol termination ("SSL offload") or per-HTTP/HTTPS request, application-layer processing, review [What is Azure Application Gateway?](/azure/application-gateway/overview). If you're looking for regional load balancing, review [Azure Load Balancer](/azure/load-balancer/load-balancer-overview). Your end-to-end scenarios might benefit from combining these solutions as needed.
>
> For a comparison of Azure load-balancing options, see [Overview of load-balancing options in Azure](../guide/technology-choices/load-balancing-overview-content.md).

## Architecture

Traffic Manager operates at the DNS layer to direct application traffic according to your choice of routing method. For example, you might direct that requests be sent to the closest endpoints, to improve responsiveness. Application Gateway load balances HTTP(S) and WebSocket requests as it routes them to backend pool servers. The backend can be public or private endpoints, virtual machines, Azure Virtual Machine Scale Sets, app services, or AKS clusters. You can route traffic based on attributes of an HTTP request, such as host name and URI path.

## Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines/) VMs are on-demand, scalable computing resources that give you the flexibility of virtualization but eliminate the maintenance demands of physical hardware. The operating system choices include Windows and Linux. The VMs are an on-demand and scalable resource.
- [Azure Virtual Machine Scale Sets](https://azure.microsoft.com/services/virtual-machine-scale-sets/) is automated and load-balanced VM scaling that simplifies management of your applications and increases availability.
- [Traffic Manager](https://azure.microsoft.com/services/traffic-manager/) is a DNS-based traffic load balancer that distributes traffic optimally to services across global Azure regions while providing high availability and responsiveness. For more information, see the section [Traffic Manager configuration](../reference-architectures/n-tier/multi-region-sql-server.yml#traffic-manager-configuration).
- [Application Gateway](https://azure.microsoft.com/services/application-gateway/) is a layer 7 load balancer. In this architecture, a zone-redundant Application Gateway routes HTTP requests to the web front end. Application Gateway also provides a Web Application Firewall (WAF) that protects the application from common exploits and vulnerabilities. The v2 SKU of Application Gateway supports cross-zone redundancy. A single Application Gateway deployment can run multiple instances of the gateway.
- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer/) is a layer 4 load balancer. There are two SKUs: Standard and Basic. In this architecture, a zone-redundant Standard Load Balancer directs network traffic from the web tier to the business tier. Because a zone-redundant Load Balancer is not pinned to a specific zone, the application will continue to distribute the network traffic in the case of a zone failure.
- [Azure DDoS Protection](https://azure.microsoft.com/services/ddos-protection/) has enhanced features to protect  against distributed denial of service (DDoS) attacks, features that go beyond the basic protection that Azure provides.
- [Azure DNS](https://azure.microsoft.com/services/dns/) is a hosting service for DNS domains. It provides name resolution using Microsoft Azure infrastructure. By hosting your domains in Azure, you can manage your DNS records using the same credentials, APIs, tools, and billing as your other Azure services. Azure DNS also supports [private DNS zones](/azure/dns/private-dns-overview). Azure DNS Private Zones provide name resolution within a virtual network, as well as between virtual networks. The records contained in a private DNS zone are not resolvable from the Internet. DNS resolution against a private DNS zone works only from virtual networks that are linked to it.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/) is a secure private network in the cloud. It connects VMs to one another, to the internet, and to on-premises networks.
- [Azure Bastion](https://azure.microsoft.com/services/azure-bastion/) provides secure and seamless Remote Desktop Protocol (RDP) and Secure Shell (SSH) access to the VMs within the virtual network. This provides access while limiting the exposed public IP addresses of the VMs in the virtual network. Azure Bastion provides a cost-effective alternative to a provisioned VM to provide access to all VMs within the same virtual network.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

- Use at least two Azure regions for higher availability. You can deploy your application across multiple Azure regions in active/passive or active/active configurations. For details, see [Multiple regions](#multiple-regions).
- For production workloads, run at least two gateway instances. Note that in this architecture, the public endpoints of the Application Gateways are configured as the Traffic Manager backends.
- Use Network Security Groups (NSG) rules to restrict traffic between tiers. For details, see [Network Security Groups](#network-security-groups).

## Availability considerations

### Azure Availability Zones

[Azure Availability Zones](https://azure.microsoft.com/global-infrastructure/availability-zones/) provide high availability within a region. A regional network connects at least three physically distinct strategically placed datacenters in each region.

### Multiple regions

Deploying in multiple regions can provide higher availability than deploying to a single region. If a regional outage affects the primary region, you can use Traffic Manager to fail over to the secondary region. Multiple regions can also help if an individual subsystem of the application fails.

Note that this architecture is applicable for active/passive as well as for active/active configurations across Azure regions.

For technical information, see [Regions and Availability Zones in Azure](/azure/availability-zones/az-overview).

### Paired regions

Each Azure region is paired with another region in the same geography (for example, the United States, Europe, or Asia). This approach allows for the replication of resources, such as VM storage, across regions. The idea is to keep one region available even if the other becomes unavailable due to natural disaster, civil unrest, power loss, network outage, and so on.

There are other advantages of regional pairing, including:

- In the event of a wider Azure outage, one region is prioritized out of every pair to help reduce the time to restore for applications.
- Planned Azure updates are rolled out to paired regions one at a time to minimize downtime and risk of application outage.
- Data continues to reside within the same geography as its pair (except for Brazil South) for tax and law enforcement jurisdiction purposes.

Make sure that both regions support all of the Azure services that your application needs (see [Services by region](https://azure.microsoft.com/global-infrastructure/geographies/#services)). For more information about regional pairs, see [Business continuity and disaster recovery (BCDR): Azure Paired Regions](/azure/best-practices-availability-paired-regions).

### Traffic Manager configuration

Traffic Manager delivers high availability for your critical applications by monitoring endpoints and providing automatic failover when an endpoint goes down.

Consider the following points when configuring Traffic Manager:

- **Routing:** Traffic Manager supports six traffic-routing methods to determine how to route traffic to the various service endpoints. In this architecture we use performance routing, which routes traffic to the endpoint that has the lowest latency for the user. Traffic Manager adjusts automatically as endpoint latencies change. Also, if you need more granular control—for example, to choose a preferred failover within a region—you can use Traffic Manager in a nested configuration.

  For configuration information, see [Configure the performance traffic routing method](/azure/traffic-manager/traffic-manager-configure-performance-routing-method).

  For information about the various routing methods, see [Traffic Manager routing methods](/azure/traffic-manager/traffic-manager-routing-methods).

- **Health probe:** Traffic Manager uses an HTTP (or HTTPS) probe to monitor the availability of each region. The probe checks for an HTTP 200 response for a specified URL path. As a best practice, create an endpoint that reports the overall health of the application, and use this endpoint for the health probe. Otherwise, the probe might report a healthy endpoint when critical parts of the application are failing. For more information, see [Health Endpoint Monitoring pattern](../patterns/health-endpoint-monitoring.md).

  When Traffic Manager fails over there is a period of time when clients cannot reach the application. The duration is affected by the following factors:

  - The health probe must detect that the primary region has become unreachable.
  - DNS servers must update the cached DNS records for the IP address, which depends on the DNS time-to-live (TTL). The default TTL is 300 seconds (5 minutes), but you can configure this value when you create the Traffic Manager profile.

  For more details, see [About Traffic Manager Monitoring](/azure/traffic-manager/traffic-manager-monitoring).

- **Traffic View:** Enable Traffic View to understand which regions have a large amount of traffic but suffer from higher latencies. Then you use this information to plan your footprint expansion to new Azure regions. That way your users will have a lower latency experience. See [Traffic Manager Traffic View](/azure/traffic-manager/traffic-manager-traffic-view-overview) for details.

### Application Gateway

- Application Gateway v1 SKU supports high-availability scenarios when you've deployed two or more instances. Azure distributes these instances across update and fault domains to ensure that instances don't all fail at the same time. The v1 SKU supports scalability by adding multiple instances of the same gateway to share the load.
- Application Gateway v2 SKU automatically ensures that new instances are spread across fault domains and update domains. If you choose zone redundancy, the newest instances are also spread across availability zones to offer zone failure resiliency.

### Health probes

Application Gateway and Load Balancer both use health probes to monitor the availability of VM instances.

- Application Gateway always uses an HTTP probe.
- Load Balancer can test either HTTP or TCP. Generally, if a VM runs an HTTP server, use an HTTP probe. Otherwise, use TCP.

If a probe can't reach an instance within a timeout period, the Application Gateway or Load Balancer stops sending traffic to that VM. The probe continues to check and will return the VM to the back-end pool if the VM becomes available again. HTTP probes send an HTTP GET request to a specified path and listen for an HTTP 200 response. This path can be the root path ("/"), or a health-monitoring endpoint that implements custom logic to check the health of the application. The endpoint must allow anonymous HTTP requests.

For more information about health probes, see:

- [Load Balancer health probes](/azure/load-balancer/load-balancer-custom-probe-overview)
- [Application Gateway health monitoring overview](/azure/application-gateway/application-gateway-probe-overview)

For considerations about designing a health probe endpoint, see [Health Endpoint Monitoring pattern](../patterns/health-endpoint-monitoring.md).

## Manageability considerations

- **Resource groups:** Use [Resource groups](/azure/azure-resource-manager/management/overview) to manage Azure resources by lifetime, owner, and other characteristics.
- **Virtual network peering:** Use [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview) to seamlessly connect two or more virtual networks in Azure. The virtual networks appear as one for connectivity purposes. The traffic between virtual machines in peered virtual networks uses the Microsoft backbone infrastructure. Make sure that the address space of the virtual networks don't overlap. In this scenario, the virtual networks are peered via Global virtual network peering to allow data replication from the primary region to the secondary region.
- **Virtual network and subnets:** Azure VM and specific Azure resources (such as Application Gateway and Load Balancer) are deployed into a virtual network that can be segmented into subnets. Create a separate subnet for each tier.

## Security considerations

- Use [DDoS Protection Standard](/azure/ddos-protection/ddos-protection-overview) for greater DDoS protection than the basic protection that Azure provides. For more information, see [Security considerations](../reference-architectures/n-tier/n-tier-sql-server.yml#security-considerations).
- Use [Network Security Groups (NSGs)](/azure/virtual-network/network-security-groups-overview) to restrict network traffic within the virtual network. For example, in the three-tier architecture shown here, the database tier accepts traffic only from the business tier and the Bastion subnet, not from the web front end.

### Network Security Groups

 Only the business tier can communicate directly with the database tier. To enforce this rule, the database tier should block all incoming traffic except for the business-tier subnet.

1. Deny all inbound traffic from the virtual network. (Use the VIRTUAL_NETWORK tag in the rule.)
1. Allow inbound traffic from the business-tier subnet.
1. Allow inbound traffic from the database-tier subnet itself. This rule allows communication between the database VMs, which is needed for database replication and failover.

Create rules 2 – 3 with higher priority than the first rule, so they override it.

You can use [service tags](/azure/virtual-network/service-tags-overview) to define network access controls on Network Security Groups or Azure Firewall. See [Application Gateway infrastructure configuration](/azure/application-gateway/configuration-infrastructure#network-security-groups) for details on Application Gateway NSG requirements.

## Pricing

Use the Azure [Pricing Calculator](https://azure.microsoft.com/pricing/calculator/) to estimate costs. Here are some other considerations.

### Virtual Machine Scale Sets

Virtual Machine Scale Sets are available on all Windows VM sizes. You're only charged for the Azure VMs you deploy, and any additional underlying infrastructure resources consumed, such as storage and networking. There are no incremental charges for the Virtual Machine Scale Sets service.

For single VM pricing options, see [Windows Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/).

### Standard Load Balancer

Pricing of the Standard Load Balancer is hourly based on the number of configured outbound load-balancing rules. Inbound NAT rules are free. There is no hourly charge for the Standard SKU Load Balancer when no rules are configured. There is also a charge for the amount of data that the Load Balancer processes.

For more information, see [Load Balancing pricing](https://azure.microsoft.com/pricing/details/load-balancer/).

### Application Gateway v2 SKU

The Application Gateway should be provisioned with the v2 SKU and can span multiple Availability Zones. With the v2 SKU, the pricing model is driven by consumption and has two components: hourly fixed price and a consumption-based cost.

For more information, see [Application Gateway pricing](https://azure.microsoft.com/pricing/details/application-gateway/).

### Traffic Manager

Traffic Manager billing is based on the number of DNS queries received, with a discount for services receiving more than 1 billion monthly queries. You're also charged for each monitored endpoint. For pricing information, see [Traffic Manager pricing](https://azure.microsoft.com/pricing/details/traffic-manager/).

### Virtual network peering

A high-availability deployment that leverages multiple Azure Regions makes use of virtual network peering. The charges for virtual network peering within the same region aren't the same as charges for global virtual network peering.

For more information, see [Virtual Network Pricing](https://azure.microsoft.com/pricing/details/virtual-network/).

## Next steps

For additional reference architectures using the same technologies, see:

- [Multi-region N-tier application](../reference-architectures/n-tier/multi-region-sql-server.yml)
- [IaaS: Web application with relational database](./ref-arch-iaas-web-and-db.yml)

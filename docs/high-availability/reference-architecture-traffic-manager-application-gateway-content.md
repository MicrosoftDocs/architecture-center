
This architecture gives guidance for building highly resilient, multi-tier applications. It uses cross-region data replication and three forms of load balancing to distribute traffic across two regions and three availability zones. The benefit is high availability and responsive disaster recovery.

## Architecture

:::image type="content" source="images/high-availability-multi-region-v-4.png" alt-text="Diagram showing multi-region load balancing with Application Gateway and Traffic Manager." lightbox="images/high-availability-multi-region-v-4.png":::

*Download a [Visio file](https://arch-center.azureedge.net/high-availability-multi-region-v-4.vsdx) of this architecture.*

### Workflow

- Azure Traffic Manager uses DNS-based routing to load balance incoming traffic across the two regions. Traffic Manager resolves DNS queries for the application to the public IP addresses of the Application Gateway endpoints. The public endpoints of the Application Gateways are the backend endpoints of Traffic Manager. Traffic Manager resolves DNS queries based on your routing method choice. For example, you might direct requests to the user's closest endpoints to improve responsiveness. Traffic Manager load balances through the distribution of endpoint IP addresses. The web browser connects directly to the endpoint. [It doesn't connect through Traffic Manager](/azure/traffic-manager/traffic-manager-routing-methods#priority-traffic-routing-method).

- The Application Gateways (AppGWs) receive HTTP(S) traffic from the client browser and load balance requests across the backend pool of virtual machines (VMs) in the web tier. We deployed the AppGWs to all three zones, so they're zone redundant. The AppGWs distribute traffic across the three zones in the web tier. The Web Application Firewalls (WAFs) inspect traffic and protect the application from web exploits and vulnerabilities.

- The web tier is the first layer of the three-tier application. It hosts VMs in three availability zones. The Application Gateways distribute traffic to each of the three availability zones. The web tier contains the user interface. It also parses user interactions and passes traffic destined to the data tier to internal load balancer.

- The internal load balancers distribute traffic to the business-tier VMs across the three availability zones. They use a single, private IP address for easy configuration. The private IP addresses of the load balancers are zone redundant. The IP addresses persist in all three zones and can survive any single zone failure.

- The business tier processes the user interactions and determines the next steps. It connects the web and data tiers. The VMs in the business tier route traffic to the availability group listener of the databases.

- The data tier stores the application data, typically in a database, object storage, or files. The architecture has SQL server on VMs distributed across three availability zones. They are in an availability group and use a distributed network name (DNN) to route traffic to the [availability group listener](/azure/azure-sql/virtual-machines/windows/availability-group-overview) for load balancing.

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines/) VMs are on-demand, scalable computing resources that give you the flexibility of virtualization but eliminate the maintenance demands of physical hardware. The operating system choices include Windows and Linux.
- [Azure Virtual Machine Scale Sets](https://azure.microsoft.com/services/virtual-machine-scale-sets/) is automated and load-balanced VM scaling that simplifies management of your applications and increases availability.
- [Traffic Manager](https://azure.microsoft.com/services/traffic-manager/) is a DNS-based traffic load balancer that distributes traffic to services across global Azure regions while providing high availability and responsiveness. For more information, see the section [Traffic Manager configuration](../reference-architectures/n-tier/multi-region-sql-server.yml#traffic-manager-configuration).
- [Application Gateway](https://azure.microsoft.com/services/application-gateway/) is a layer-7 load balancer. The v2 SKU of Application Gateway supports cross-zone redundancy. A single Application Gateway deployment can run multiple instances of the gateway.
- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer/) is a layer-4 load balancer. A zone-redundant Load Balancer will still distribute traffic with a zone failure.
- [Azure DDoS Protection](https://azure.microsoft.com/services/ddos-protection/) has enhanced features to protect against distributed denial of service (DDoS) attacks.
- [Azure DNS](https://azure.microsoft.com/services/dns/) is a hosting service for DNS domains. It provides name resolution using Microsoft Azure infrastructure. By hosting your domains in Azure, you can manage your DNS records using the same credentials, APIs, tools, and billing as your other Azure services.
- [Private DNS zones](/azure/dns/private-dns-overview) are a feature of Azure DNS. Azure DNS Private Zones provide name resolution within a virtual network, and between virtual networks. The records contained in a private DNS zone aren't resolvable from the Internet. DNS resolution against a private DNS zone works only from virtual networks linked to it.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/) is a secure private network in the cloud. It connects VMs to one another, to the internet, and to on-premises networks.
- [SQL Server on VMs](https://azure.microsoft.com/services/virtual-machines/sql-server/#overview) lets you use full versions of SQL Server in the cloud without having to manage any on-premises hardware.

### Alternatives

- Azure provides a suite of fully managed load-balancing solutions. If you're looking for Transport Layer Security (TLS) protocol termination ("SSL offload") or application-layer processing, see the [Application Gateway overview](/azure/application-gateway/overview).

- You can use Azure load balancer for regional load balancing. For more information, see [Azure Load Balancer overview](/azure/load-balancer/load-balancer-overview).

- Your end-to-end scenarios might benefit from combining Azure Application Gateway and Azure Load Balancer solutions in different configurations as needed.

- The backend can be public or private endpoints, virtual machines, Azure Virtual Machine Scale Sets, app services, or AKS clusters. You can route traffic based on attributes of an HTTP request, such as host name and URI path.

## Solution Details

- We configured Traffic Manager to use performance routing. It routes traffic to the endpoint that has the lowest latency for the user. Traffic Manager automatically adjusts as endpoint latencies change.

- The architecture uses three zones to support the Application Gateway, load balancer, and each application tier for high availability.
- The combination of Traffic Manager and Application Gateway gives you the following capabilities:

  - Web Application Firewall (WAF).
  - Transport Layer Security (TLS) termination.
  - Path-based routing.
  - Cookie-based session affinity.

- The virtual networks are peered via Global virtual network peering to allow data replication from the primary region to the secondary region.

## Recommendations

These considerations implement the pillars of the Azure Well-Architected Framework (WAF). WAF is a set of guiding tenets available to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

The following recommendations apply to most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

## Reliability

### Availability

- Use at least two Azure regions for higher availability. You can deploy your application across multiple Azure regions in active/passive or active/active configurations. Multiple regions also helps to avoid application downtime if a subsystem of the application fails.

- Use Traffic Manager to fail over to the secondary region if the primary region fails.

- Use Region Pairs for the most resiliency. Here are the benefits of Region Pairs:

  - Prioritizes one region out of every pair to help reduce the time to restore for applications.
  - Roles out planned Azure updates to paired regions one at a time to minimize downtime and risk of application outage.
  - Data continues to reside within the same geography as its pair (except for Brazil South) for tax and legal purposes.
  - Make sure that both Region Pairs support all the Azure services that your application needs (see [Services by region](https://azure.microsoft.com/global-infrastructure/geographies/#services)).

- Use multiple availability zones to support your Application Gateway, load balancer, and application tiers when available.

- Configure the Application Gateway with a minimum of two instances to avoid downtime.

- For more information, see:
  - [Regions and Availability Zones in Azure](/azure/availability-zones/az-overview).
  - [Business continuity and disaster recovery (BCDR): Azure Paired Regions](/azure/best-practices-availability-paired-regions).

### Traffic Manager configuration

#### Routing

- Use the traffic-routing method that best meets the needs of your customers. Traffic Manager supports six traffic-routing methods to determine how to route traffic to the various service endpoints.

- Use Traffic Manager in a nested configuration if you need more granular control to choose a preferred failover within a region.

- For more information, see:
  - [Configure the performance traffic routing method](/azure/traffic-manager/traffic-manager-configure-performance-routing-method)
  - [Traffic Manager routing methods](/azure/traffic-manager/traffic-manager-routing-methods)

#### Traffic View

- Enable Traffic View in Traffic Manager to understand which regions have a large amount of traffic but suffer from higher latencies.

- Use the Traffic View information to plan your footprint expansion to new Azure regions. That way your users will have a lower latency experience. See [Traffic Manager Traffic View](/azure/traffic-manager/traffic-manager-traffic-view-overview) for details.

### Application Gateway

Use Application Gateway v2 SKU for automated resiliency.

- Application Gateway v2 SKU automatically ensures that new instances spawn across fault domains and update domains. If you choose zone redundancy, the newest instances also spawn across availability zones to give fault tolerance.

- Application Gateway v1 SKU supports high-availability scenarios when you've deployed two or more instances. Azure distributes these instances across update and fault domains to ensure that instances don't all fail at the same time. The v1 SKU supports scalability by adding multiple instances of the same gateway to share the load.

### Health probes

#### Traffic Manager

- Create an endpoint that reports the overall health of the application. Traffic Manager uses an HTTP (or HTTPS) probe to monitor the availability of each region. The probe checks for an HTTP 200 response for a specified URL path.

- Use the endpoint you created for the health probe. Otherwise, the probe might report a healthy endpoint when critical parts of the application are failing.

For more information, see [Health Endpoint Monitoring pattern](../patterns/health-endpoint-monitoring.yml).

When Traffic Manager initiates a failover, some time passes when clients can't reach the application. The following factors affect the duration of the unavailability:

- The health probe must detect that the primary region has become unreachable.
- DNS servers must update the cached DNS records for the IP address, which depends on the DNS time-to-live (TTL). The default TTL is 300 seconds (5 minutes), but you can configure this value when you create the Traffic Manager profile.

For more information, see [About Traffic Manager Monitoring](/azure/traffic-manager/traffic-manager-monitoring).

#### Application Gateway and Load Balancer

Familiarize yourself with the health probe policies of the Application Gateway and Load Balancer to ensure you understand the health of your VMs. Here's a brief overview:

- Application Gateway always uses an HTTP probe.

- Load Balancer can evaluate either HTTP or TCP.

  - Use an HTTP probe if a VM runs an HTTP server.
  - Use TCP for everything else.

- HTTP probes send an HTTP GET request to a specified path and listen for an HTTP 200 response. This path can be the root path ("/"), or a health-monitoring endpoint that implements custom logic to check the health of the application.
- The endpoint must allow anonymous HTTP requests. If a probe can't reach an instance within the timeout period, the Application Gateway or Load Balancer stops sending traffic to that VM. The probe continues to check and will return the VM to the back-end pool if the VM becomes available again.

For more information, see:

- [Load Balancer health probes](/azure/load-balancer/load-balancer-custom-probe-overview)
- [Application Gateway health monitoring overview](/azure/application-gateway/application-gateway-probe-overview)
- [Health Endpoint Monitoring pattern](../patterns/health-endpoint-monitoring.yml).

## Operational excellence

- **Resource groups:** Use [Resource groups](/azure/azure-resource-manager/management/overview) to manage Azure resources by lifetime, owner, and other characteristics.

- **Virtual network peering:** Use [virtual network peering](/azure/virtual-network/virtual-network-peering-overview) to seamlessly connect two or more virtual networks in Azure. The virtual networks appear as one for connectivity purposes. The traffic between virtual machines in peered virtual networks uses the Microsoft backbone infrastructure. Make sure that the address space of the virtual networks doesn't overlap.

- **Virtual network and subnets:** Create a separate subnet for each tier of your subnet. You should deploy VMs and resources, such as Application Gateway and Load Balancer, into a virtual network with subnets.

## Security

- Use [DDoS Protection Standard](/azure/ddos-protection/ddos-protection-overview) for greater DDoS protection than the basic protection that Azure provides. For more information, see [security considerations](../reference-architectures/n-tier/n-tier-sql-server.yml#security).

- Use [Network Security Groups (NSGs)](/azure/virtual-network/network-security-groups-overview) to restrict network traffic within the virtual network. For example, in the three-tier architecture shown here, the data tier accepts traffic only from the business tier, not from the web front end.

 Only the business tier can communicate directly with the database tier. To enforce this rule, the database tier should block all incoming traffic except for the business-tier subnet.

1. Deny all inbound traffic from the virtual network, using the VIRTUAL_NETWORK tag in the rule).
1. Allow inbound traffic from the business-tier subnet.
1. Allow inbound traffic from the database-tier subnet itself. This rule allows communication between the database VMs. Database replication and failover need this rule.

Create rules 2 – 3 with higher priority than the first rule, so they override it.

You can use [service tags](/azure/virtual-network/service-tags-overview) to define network access controls on Network Security Groups or Azure Firewall. See [Application Gateway infrastructure configuration](/azure/application-gateway/configuration-infrastructure#network-security-groups) for details on Application Gateway NSG requirements.

## Cost optimization

Use a VPN Gateway for environments with substantial amounts of data replicated between regions. Virtual network peering charges for inbound and outbound data. VPN Gateways have an hourly charge but only charge on outbound data.

Use the Azure [Pricing Calculator](https://azure.microsoft.com/pricing/calculator/) to estimate costs.

For more information, see:

- [Load Balancing pricing](https://azure.microsoft.com/pricing/details/load-balancer/)
- [Virtual Network Pricing](https://azure.microsoft.com/pricing/details/virtual-network/)
- [Application Gateway pricing](https://azure.microsoft.com/pricing/details/application-gateway/)
- [Traffic Manager pricing](https://azure.microsoft.com/pricing/details/traffic-manager/)

## Performance efficiency

Use Virtual Machine Scale Sets (VMSSs) for automated scalability. VMSSs are available on all Windows VM sizes. You're only charged for the Azure VMs deployed and the underlying infrastructure resources consumed, such as storage and networking. There are no incremental charges for the Virtual Machine Scale Sets service.

The benefits of VMSSs are:

- Easy to create and manage multiple VMs.
- Provides high availability and application resiliency
- Allows your application to automatically scale as resource demand changes
- Works at large-scale

For more information, see [virtual machine scale sets](/azure/virtual-machine-scale-sets/overview)

## Next steps

For more reference architectures using the same technologies, see:

- [Multi-region N-tier application](../reference-architectures/n-tier/multi-region-sql-server.yml)
- [IaaS: Web application with relational database](./ref-arch-iaas-web-and-db.yml)


This architecture is for global, internet-facing applications that use HTTP(S) and TCP protocols. It features DNS-based global load balancing, two forms of regional load balancing, and global virtual network peering to create a high availability architecture that can withstand a regional outage.

## Architecture

:::image type="content" source="images/high-availability-multi-region-v-9.png" alt-text="Diagram showing multi-region load balancing with Application Gateway and Traffic Manager." lightbox="images/high-availability-multi-region-v-9.png":::

*Download a [Visio file](https://arch-center.azureedge.net/high-availability-multi-region-v-9.vsdx) of this architecture.*

### Workflow

1. Azure Traffic Manager uses DNS-based routing to load balance incoming traffic across the two regions. Traffic Manager resolves DNS queries for the application to the public IP addresses of the Application Gateway (AppGW) endpoints. The public endpoints of the AppGWs serve as the backend endpoints of Traffic Manager. Traffic Manager resolves DNS queries based on a choice of six routing methods. The browser connects directly to the endpoint. [Traffic Manager doesn't see the HTTP(S) traffic](/azure/traffic-manager/traffic-manager-routing-methods#priority-traffic-routing-method).

1. The Application Gateways (AppGWs) receive HTTP(S) traffic from the browser and load balance requests across the backend pool of virtual machines (VMs) in the web tier. Deploying the AppGWs to all three zones provides zone redundancy for the AppGWs. The AppGWs also distribute traffic across the three zones in the web tier. AppGWs include a Web Application Firewall (WAF) that inspects traffic and protects the application from web exploits and vulnerabilities.

1. The web tier is the first layer of the three-tier application. It hosts VMs in three availability zones. The Application Gateways distribute traffic to each of the three availability zones. The web tier contains the user interface. It also parses user interactions and passes traffic destined to the data tier to internal load balancer.

1. The internal load balancers distribute traffic to the business-tier VMs across the three availability zones. They use a single, private IP address for easy configuration. The private IP addresses of the load balancers are zone redundant. The IP addresses persist in all three zones and can survive any single zone failure.

1. The business tier processes the user interactions and determines the next steps. It connects the web and data tiers. The VMs in the business tier route traffic to the availability group listener of the databases.

1. The data tier stores the application data, typically in a database, object storage, or file share. The architecture has SQL server on VMs distributed across three availability zones. They are in an availability group and use a distributed network name (DNN) to route traffic to the [availability group listener](/azure/azure-sql/virtual-machines/windows/availability-group-overview) for load balancing.

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

For web applications that only use HTTP(S), Azure Front Door is a better global load balancing solution than Traffic Manager. Front Door is a layer-7 load balancer that also provides caching, traffic acceleration, SSL/TLS termination, certificate management, health probes, and other capabilities.

## Solution Details

*Traffic Manager -* We configured Traffic Manager to use performance routing. It routes traffic to the endpoint that has the lowest latency for the user. Traffic Manager automatically adjusts its load balancing algorithm as endpoint latency changes. Traffic manager provides automatic failover if there's a regional outage. It uses priority routing and regular health checks to determine where to route traffic.

*Availability Zones -* The architecture uses three availability zones. The zones create a high-availability architecture for the Application Gateways, internal load balancers, and VMs in each tier.

*Traffic Manager & Application Gateway -* Traffic Manager provides DNS-based load balancing, while the Application Gateway gives you many of the same capabilities as Azure Front Door but at the regional level such as:

- Web Application Firewall (WAF)
- Transport Layer Security (TLS) termination
- Path-based routing
- Cookie-based session affinity

*Virtual network (vnet) peering -* We call vnet peering between regions "global vnet peering." Global vnet peering provides low-latency, high-bandwidth data replication between regions. You can transfer data across Azure subscriptions, Azure Active Directory tenants, and deployment models with global vnet peering.

## Recommendations

The following recommendations adhere to the pillars of the Azure Well-Architected Framework (WAF). The WAF pillars are guiding tenets that help ensure the quality of cloud workloads. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

## Reliability

*Regions -* Use at least two Azure regions for high availability. You can deploy your application across multiple Azure regions in active/passive or active/active configurations. Multiple regions also help avoid application downtime if a subsystem of the application fails.

- Traffic Manager will automatically fail over to the secondary region if the primary region fails.
- Choosing the best regions for your needs must be based on technical, regulatory considerations, and availability-zone support.

*Region pairs -* Use Region Pairs for the most resiliency. Make sure that both Region Pairs support all the Azure services that your application needs (see [services by region](https://azure.microsoft.com/global-infrastructure/geographies/#services)). Here are two benefits of Region Pairs:

- Planned Azure updates roll out to paired regions one at a time to minimize downtime and risk of application outage.
- Data continues to reside within the same geography as its pair (except for Brazil South) for tax and legal purposes.

*Availability zones -* Use multiple availability zones to support your Application Gateway, load balancer, and application tiers when available.

*Application gateway instances -* Configure the Application Gateway with a minimum of two instances to avoid downtime.

For more information, see:

- [Regions and availability zones in Azure](/azure/availability-zones/az-overview)
- [Business continuity and disaster recovery (BCDR): Azure Paired Regions](/azure/best-practices-availability-paired-regions)

### Routing

*Routing method -* Use the traffic-routing method that best meets the needs of your customers. Traffic Manager supports six traffic-routing methods to determine how to route traffic to the various service endpoints.

*Nested configuration -* Use Traffic Manager in a nested configuration if you need more granular control to choose a preferred failover within a region.

For more information, see:

- [Configure the performance traffic routing method](/azure/traffic-manager/traffic-manager-configure-performance-routing-method)
- [Traffic Manager routing methods](/azure/traffic-manager/traffic-manager-routing-methods)

### Traffic View

Use Traffic View in Traffic Manager to see traffic patterns and latency metrics. Traffic View can help you plan your footprint expansion to new Azure regions.

See [Traffic Manager Traffic View](/azure/traffic-manager/traffic-manager-traffic-view-overview) for details.

### Application Gateway

Use Application Gateway v2 SKU for out-of-the-box automated resiliency.

- Application Gateway v2 SKU automatically ensures that new instances spawn across fault domains and update domains. If you choose zone redundancy, the newest instances also spawn across availability zones to give fault tolerance.

- Application Gateway v1 SKU supports high-availability scenarios when you've deployed two or more instances. Azure distributes these instances across update and fault domains to ensure that instances don't fail at the same time. The v1 SKU supports scalability by adding multiple instances of the same gateway to share the load.

### Health probes

Here are some recommendations for health probes in Traffic Manager, Application Gateway, and Load Balancer.

#### Traffic Manager

*Endpoint health -* Create an endpoint that reports the overall health of the application. Traffic Manager uses an HTTP(S) probe to monitor the availability of each region. The probe checks for an HTTP 200 response for a specified URL path. Use the endpoint you created for the health probe. Otherwise, the probe might report a healthy endpoint when critical parts of the application are failing.

For more information, see [health endpoint monitoring pattern](../patterns/health-endpoint-monitoring.yml).

*Failover delay -* Traffic Manager has a failover delay. The following factors determine the duration of the delay:

- Probing intervals: How often the probe checks the health of the endpoint.
- Tolerated number of failures: How many failures the probe tolerates before marking the endpoint unhealthy.
- Probe timeout: how long before Traffic Manager considers the endpoint unhealthy.
- Time-to-live (TTL): DNS servers must update the cached DNS records for the IP address. The time it takes depends on the DNS TTL. The default TTL is 300 seconds (5 minutes), but you can configure this value when you create the Traffic Manager profile.

For more information, see [Traffic Manager monitoring](/azure/traffic-manager/traffic-manager-monitoring).

#### Application Gateway and Load Balancer

Familiarize yourself with the health probe policies of the Application Gateway and load balancer to ensure you understand the health of your VMs. Here's a brief overview:

- Application Gateway always uses an HTTP probe.

- Load Balancer can evaluate either HTTP or TCP. Use an HTTP probe if a VM runs an HTTP server. Use TCP for everything else.

- HTTP probes send an HTTP GET request to a specified path and listen for an HTTP 200 response. This path can be the root path ("/"), or a health-monitoring endpoint that implements custom logic to check the health of the application.
- The endpoint must allow anonymous HTTP requests. If a probe can't reach an instance within the timeout period, the Application Gateway or Load Balancer stops sending traffic to that VM. The probe continues to check and will return the VM to the back-end pool if the VM becomes available again.

For more information, see:

- [Load Balancer health probes](/azure/load-balancer/load-balancer-custom-probe-overview)
- [Application Gateway health monitoring overview](/azure/application-gateway/application-gateway-probe-overview)
- [Health endpoint monitoring pattern](../patterns/health-endpoint-monitoring.yml)

## Operational excellence

*Resource groups -* Use [resource groups](/azure/azure-resource-manager/management/overview) to manage Azure resources by lifetime, owner, and other characteristics.

*Virtual network peering -* Use [virtual network peering](/azure/virtual-network/virtual-network-peering-overview) to seamlessly connect two or more virtual networks in Azure. The virtual networks appear as one for connectivity purposes. The traffic between virtual machines in peered virtual networks uses the Microsoft backbone infrastructure. Make sure that the address space of the virtual networks doesn't overlap.

*Virtual network and subnets -* Create a separate subnet for each tier of your subnet. You should deploy VMs and resources, such as Application Gateway and Load Balancer, into a virtual network with subnets.

## Security

*Distributed Denial of Service (DDoS) -* Use [Azure DDoS Network Protection](/azure/ddos-protection/ddos-protection-overview) for greater DDoS protection than the basic protection that Azure provides. For more information, see [security considerations](../reference-architectures/n-tier/n-tier-sql-server.yml#security).

*Network security groups (NSGs):* Use [NSGs](/azure/virtual-network/network-security-groups-overview) to restrict network traffic within the virtual network. For example, in the three-tier architecture shown here, the data tier accepts traffic only from the business tier, not from the web front end. Only the business tier can communicate directly with the database tier. To enforce this rule, the database tier should block all incoming traffic except for the business-tier subnet.

1. Deny all inbound traffic from the virtual network, using the VIRTUAL_NETWORK tag in the rule).
1. Allow inbound traffic from the business-tier subnet.
1. Allow inbound traffic from the database-tier subnet itself. This rule allows communication between the database VMs. Database replication and failover need this rule.

Create rules 2 – 3 with higher priority than the first rule, so they override it.

You can use [service tags](/azure/virtual-network/service-tags-overview) to define network access controls on Network Security Groups or Azure Firewall.

For more information, see [application gateway infrastructure configuration](/azure/application-gateway/configuration-infrastructure#network-security-groups).

## Cost optimization

*Data transfer -* Use a VPN Gateway for environments with substantial amounts of data replicated between regions instead of virtual network peering. Virtual network peering charges for inbound and outbound data. VPN Gateways have an hourly charge but only charge on outbound data.

For more information, see:

- [Load Balancing pricing](https://azure.microsoft.com/pricing/details/load-balancer/)
- [Virtual network Pricing](https://azure.microsoft.com/pricing/details/virtual-network/)
- [Application gateway pricing](https://azure.microsoft.com/pricing/details/application-gateway/)
- [Traffic Manager pricing](https://azure.microsoft.com/pricing/details/traffic-manager/)
- [Pricing calculator](https://azure.microsoft.com/pricing/calculator/)

## Performance efficiency

*Virtual machine scale sets -* Use Virtual Machine Scale Sets to automate the scalability of your VMs. Virtual machine scale sets are available on all Windows VM sizes. You're only charged for the VMs deployed and the underlying infrastructure resources consumed. There are no incremental charges. The benefits of Virtual Machine Scale Sets are:

- Create and manage multiple VMs easily
- High availability and application resiliency
- Automated scaling as resource demand changes

For more information, see [Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview).

## Next steps

For more reference architectures using the same technologies, see:

- [Multi-region N-tier application](../reference-architectures/n-tier/multi-region-sql-server.yml)
- [IaaS: Web application with relational database](./ref-arch-iaas-web-and-db.yml)
- [AKS baseline for multi-region clusters](../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml)

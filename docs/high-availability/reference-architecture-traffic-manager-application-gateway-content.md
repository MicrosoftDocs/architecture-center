
This architecture is for global, internet-facing applications that use HTTP(S) and non-HTTP(S) protocols. It features DNS-based global load balancing, two forms of regional load balancing, and global virtual network peering to create a high availability architecture that can withstand a regional outage.

## Architecture

:::image type="content" source="images/high-availability-multi-region-web-v-10.png" alt-text="Diagram showing multi-region load balancing with Azure Firewall, Application Gateway and Traffic Manager for web traffic." lightbox="images/high-availability-multi-region-web-v-10.png.png":::

*Download a [Visio file](https://arch-center.azureedge.net/high-availability-multi-region-v-10.vsdx) of this architecture.*

### Workflow for HTTP(S) traffic:

1. Azure Traffic Manager uses DNS-based routing to load balance incoming traffic across the two regions. Traffic Manager resolves DNS queries for the application to the public IP addresses of the Azure Application Gateway endpoints. The public endpoints of the Application Gateways serve as the backend endpoints of Traffic Manager for HTTP(S) traffic. Traffic Manager resolves DNS queries based on a choice of six routing methods. The browser connects directly to the endpoint. [Traffic Manager doesn't see the HTTP(S) traffic](/azure/traffic-manager/traffic-manager-routing-methods#priority-traffic-routing-method).

1. The Application Gateways deployed across availability zones receive HTTP(S) traffic from the browser, and the Web Application Firewalls Premium inspect the traffic to detect web attacks. The Application Gateways will send traffic to their backend, the internal load balancer for the frontend VMs. For this specific flow, the internal load balancer in front of the web servers is not strictly required since the Application Gateway could perform this load balancing itself. However, it is included for consistency with the flow for non-HTTP(S) applications.

1. The traffic between the Application Gateway and the frontend internal load balancer will be intercepted by Azure Firewall Premium via User Defined Routes applied on the Application Gateway subnet. The Azure Firewall Premium will apply TLS inspection to the traffic for additional security. The Azure Firewall is zone-redundant as well. Upon successful inspection, the Azure Firewall will forward the traffic to the destination web tier internal load balancer.

1. The web tier is the first layer of the three-tier application. It hosts VMs in three availability zones. The web-tier load balancer will distribute traffic to each of the three VMs, each in an availability zones. The web tier contains the user interface, and it also parses user interactions and passes traffic destined to the data tier to internal load balancer.

1. The web tier VMs will communicate with the business tier via a dedicated internal load balancer.

1. The business-tier internal load balancers distribute traffic to the business-tier VMs across the three availability zones. They use a single, private IP address for easy configuration. The private IP addresses of the load balancers are zone redundant. The IP addresses persist in all three zones and can survive any single zone failure.

1. The business tier processes the user interactions and determines the next steps. It connects the web and data tiers. The VMs in the business tier route traffic to the availability group listener of the databases.

1. The data tier stores the application data, typically in a database, object storage, or file share. The architecture has SQL server on VMs distributed across three availability zones. They are in an availability group and use a distributed network name (DNN) to route traffic to the [availability group listener](/azure/azure-sql/virtual-machines/windows/availability-group-overview) for load balancing.

### Workflow for non-HTTP(S) traffic:

1. Azure Traffic Manager uses DNS-based routing to load balance incoming traffic across the two regions. Traffic Manager resolves DNS queries for the application to the public IP addresses of the Azure endpoints. The public endpoints of the Application Firewall serve as the backend endpoints of Traffic Manager for non-HTTP(S) traffic. Traffic Manager resolves DNS queries based on a choice of six routing methods. The browser connects directly to the endpoint. [Traffic Manager doesn't see the HTTP(S) traffic](/azure/traffic-manager/traffic-manager-routing-methods#priority-traffic-routing-method).

1.  The Azure Firewall Premium will inspect the inbound traffic for security. Upon successful inspection, the Azure Firewall will forward the traffic to the web-tier internal load balancer.

1. The web tier is the first layer of the three-tier application. It hosts VMs in three availability zones. The web-tier load balancer will distribute traffic to each of the three VMs, each in an availability zones. The web tier contains the user interface, and it also parses user interactions and passes traffic destined to the data tier to internal load balancer.

1. The web tier VMs will communicate with the business tier via a dedicated internal load balancer.

1. The business-tier internal load balancers distribute traffic to the business-tier VMs across the three availability zones. They use a single, private IP address for easy configuration. The private IP addresses of the load balancers are zone redundant. The IP addresses persist in all three zones and can survive any single zone failure.

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

For web applications that only use HTTP(S), Azure Front Door is a better global load balancing solution than Traffic Manager. Front Door is a layer-7 load balancer that also provides caching, traffic acceleration, SSL/TLS termination, certificate management, health probes, and other capabilities. However, Application Gateway offers better integration with Azure Firewall for a layered protection approach.

## Solution Details

*Traffic Manager -* We configured Traffic Manager to use performance routing. It routes traffic to the endpoint that has the lowest latency for the user. Traffic Manager automatically adjusts its load balancing algorithm as endpoint latency changes. Traffic manager provides automatic failover if there's a regional outage. It uses priority routing and regular health checks to determine where to route traffic.

*Availability Zones -* The architecture uses three availability zones. The zones create a high-availability architecture for the Application Gateways, internal load balancers, and VMs in each tier.

*Traffic Manager & Application Gateway -* Traffic Manager provides DNS-based load balancing, while the Application Gateway gives you many of the same capabilities as Azure Front Door but at the regional level such as:

- Web Application Firewall (WAF)
- Transport Layer Security (TLS) termination
- Path-based routing
- Cookie-based session affinity

*Azure Firewall -* Azure Firewall Premium inspects three types of flows:

- Inbound HTTP(S) flows from the Application Gateway are protected with Azure Firewall Premium TLS inspection.
- Inbound non-HTTP(S) flows from the public Internet are inspected with the rest of [Azure Firewall Premium features](https://learn.microsoft.com/azure/firewall/premium-features).
- Outbound flows from Azure Virtual Machines are inspected by Azure Firewall to prevent data exfiltration and access to forbidden sites and applications.

*Virtual network (VNet) peering -* We call vnet peering between regions "global vnet peering." Global vnet peering provides low-latency, high-bandwidth data replication between regions. You can transfer data across Azure subscriptions, Azure Active Directory tenants, and deployment models with global vnet peering.

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

*Global routing method -* Use the traffic-routing method that best meets the needs of your customers. Traffic Manager supports six traffic-routing methods to determine how to route traffic to the various service endpoints.

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

The Application Gateway needs to trust the CA certificate of Azure Firewall.

### Azure Firewall

The Premium tier of Azure Firewall is required in this design to provide TLS inspection. Azure Firewall will intercept the TLS sessions between Application Gateway and the web-tier VMs generating its own certificates. You can find more information on this design in [Zero-trust network for web applications with Azure Firewall and Application Gateway](https://learn.microsoft.com/azure/architecture/example-scenario/gateway/application-gateway-before-azure-firewall).

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

*Web Application Firewall -* The WAF functionality of Azure Application Gateway will detect and prevent attacks at the HTTP level, such as SQL Code Injection or Cross-Site Scripting.

*Next-Generation Firewall -* Azure Firewall Premium provides an additional layer of defence by inspecting content for non-web attacks, such as malicious files uploaded via HTTP(S) or any other protocol.

*End-to-end encryption -* Traffic is encrypted at all times when traversing the Azure network. Both Application Gateway and Azure Firewall encrypt traffic before sending it to the corresponding backend system.

*Distributed Denial of Service (DDoS) -* Use [Azure DDoS Network Protection](/azure/ddos-protection/ddos-protection-overview) for greater DDoS protection than the basic protection that Azure provides. For more information, see [security considerations](../reference-architectures/n-tier/n-tier-sql-server.yml#security).

*Network security groups (NSGs):* Use [NSGs](/azure/virtual-network/network-security-groups-overview) to restrict network traffic within the virtual network. For example, in the three-tier architecture shown here, the data tier accepts traffic only from the business tier, not from the web front end. Only the business tier can communicate directly with the database tier. To enforce this rule, the database tier should block all incoming traffic except for the business-tier subnet.

1. Allow inbound traffic from the business-tier subnet.
1. Allow inbound traffic from the database-tier subnet itself. This rule allows communication between the database VMs. Database replication and failover need this rule.
1. Deny all inbound traffic from the virtual network, using the `VirtualNetwork` tag in the rule) to overwrite the permit statement included in the default NSG rules.

Create rules 3 with lower priority (higher number) than the first rules.

You can use [service tags](/azure/virtual-network/service-tags-overview) to define network access controls on Network Security Groups or Azure Firewall.

For more information, see [application gateway infrastructure configuration](/azure/application-gateway/configuration-infrastructure#network-security-groups).

## Cost

For more information, see:

- [Load Balancing pricing](https://azure.microsoft.com/pricing/details/load-balancer/)
- [Virtual network Pricing](https://azure.microsoft.com/pricing/details/virtual-network/)
- [Application gateway pricing](https://azure.microsoft.com/pricing/details/application-gateway/)
- [Choose the right Azure Firewall SKU to meet your needs](https://learn.microsoft.com/azure/firewall/choose-firewall-sku)
- [Traffic Manager pricing](https://azure.microsoft.com/pricing/details/traffic-manager/)
- [Pricing calculator](https://azure.microsoft.com/pricing/calculator/)

## Performance efficiency

*Virtual machine scale sets -* Use Virtual Machine Scale Sets to automate the scalability of your VMs. Virtual machine scale sets are available on all Windows and Linux VM sizes. You're only charged for the VMs deployed and the underlying infrastructure resources consumed. There are no incremental charges. The benefits of Virtual Machine Scale Sets are:

- Create and manage multiple VMs easily
- High availability and application resiliency
- Automated scaling as resource demand changes

For more information, see [Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview).

## Next steps

For more reference architectures using the same technologies, see:

- [Multi-region N-tier application](../reference-architectures/n-tier/multi-region-sql-server.yml)
- [IaaS: Web application with relational database](./ref-arch-iaas-web-and-db.yml)
- [AKS baseline for multi-region clusters](../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml)

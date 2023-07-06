
This architecture is for global, internet-facing applications that use HTTP(S) and non-HTTP(S) protocols. It features DNS-based global load balancing, two forms of regional load balancing, and global virtual network peering to create a high availability architecture that can withstand a regional outage. Traffic inspection is provided by both Azure Web Application Firewall (WAF) and Azure Firewall.

### Architecture notes

The architecture in this document is easily extensible to a hub-and-spoke virtual network design, where the Azure Firewall would be in the hub network, and the Application Gateway either in the hub network as well or in a spoke. If the Application Gateway is deployed in the hub, you still want multiple Application Gateways, each for a given set of applications, to avoid RBAC conflicts and prevent hitting Application Gateway limits (see [Application Gateway Limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#application-gateway-limits)).

In a Virtual WAN environment Application Gateways cannot be deployed in the hub, so they would be installed in spoke virtual networks.

The proposed architecture opts for double inspection of web content through both a Web Application Firewall (based on Application Gateway) in front of Azure Firewall. Other options exist, as documented in [Firewall and Application Gateway for virtual networks](/azure/architecture/example-scenario/gateway/firewall-application-gateway), but this option is the most flexible and complete one: it exposes the client's IP address in the HTTP header `X-Forwarded-For` for the end application, it provides end-to-end encryption, and it prevents clients from bypassing the WAF to access the application.

If only web applications are exposed (no non-HTTP(S) applications), and the double inspection by WAF und Azure Firewall of this web traffic is not required, Azure Front Door would be a better global load balancing solution than Traffic Manager. Front Door is a layer-7 load balancer for HTTP(S) content that also provides caching, traffic acceleration, SSL/TLS termination, certificate management, health probes, and other capabilities. However, Application Gateway offers better integration with Azure Firewall for a layered protection approach.

### Inbound HTTP(S) traffic flows

:::image type="content" source="images/high-availability-multi-region-web-v-10.png" alt-text="Diagram showing multi-region load balancing with Azure Firewall, Application Gateway and Traffic Manager for web traffic." lightbox="images/high-availability-multi-region-web-v-10.png":::

*Download a [Visio file](https://arch-center.azureedge.net/high-availability-multi-region-v-10.vsdx) of this architecture.*

1. Azure Traffic Manager uses DNS-based routing to load balance incoming traffic across the two regions. Traffic Manager resolves DNS queries for the application to the public IP addresses of the Azure Application Gateway endpoints. The public endpoints of the Application Gateways serve as the backend endpoints of Traffic Manager for HTTP(S) traffic. Traffic Manager resolves DNS queries based on a choice of various routing methods. The browser connects directly to the endpoint; [Traffic Manager doesn't see the HTTP(S) traffic](/azure/traffic-manager/traffic-manager-routing-methods#priority-traffic-routing-method).

2. The Application Gateways deployed across availability zones receive HTTP(S) traffic from the browser, and the Web Application Firewalls Premium inspect the traffic to detect web attacks. The Application Gateways will send traffic to their backend, the internal load balancer for the frontend virtual machines. For this specific flow, the internal load balancer in front of the web servers is not strictly required since the Application Gateway could perform this load balancing itself. However, it is included for consistency with the flow for non-HTTP(S) applications.

3. The traffic between the Application Gateway and the frontend internal load balancer will be intercepted by Azure Firewall Premium via User Defined Routes applied on the Application Gateway subnet. The Azure Firewall Premium will apply TLS inspection to the traffic for additional security. The Azure Firewall is zone-redundant as well. If the Azure Firewall detects a threat in the traffic, it will drop the packets. Otherwise, upon successful inspection the Azure Firewall will forward the traffic to the destination web-tier internal load balancer. 

4. The web-tier is the first layer of the three-tier application, it contains the user interface and it also parses user interactions. The web-tier load balancer is spread over all three availability zones, and it will distribute traffic to each of the three web-tier virtual machines.

5. The web-tier virtual machines are spread across all three availability zones, and they will communicate with the business tier via a dedicated internal load balancer.

6. The business tier processes the user interactions and determines the next steps, and it sits between the web and data tiers. The business-tier internal load balancer distributes traffic to the business-tier virtual machines across the three availability zones. The business-tier load balancer is zone-redundant, like the web-tier load balancer.

7. The business-tier virtual machines are spread across availability zones, and they will route traffic to the availability group listener of the databases.

8. The data-tier stores the application data, typically in a database, object storage, or file share. This architecture has SQL server on virtual machines distributed across three availability zones. They are in an availability group and use a distributed network name (DNN) to route traffic to the [availability group listener](/azure/azure-sql/virtual-machines/windows/availability-group-overview) for load balancing.

### Inbound non-HTTP(S) traffic flows

:::image type="content" source="images/high-availability-multi-region-nonweb-v-10.png" alt-text="Diagram showing multi-region load balancing with Azure Firewall, Application Gateway and Traffic Manager for non-web traffic." lightbox="images/high-availability-multi-region-nonweb-v-10.png":::

*Download a [Visio file](https://arch-center.azureedge.net/high-availability-multi-region-v-10.vsdx) of this architecture.*

1. Azure Traffic Manager uses DNS-based routing to load balance incoming traffic across the two regions. Traffic Manager resolves DNS queries for the application to the public IP addresses of the Azure endpoints. The public endpoints of the Application Firewall serve as the backend endpoints of Traffic Manager for non-HTTP(S) traffic. Traffic Manager resolves DNS queries based on a choice of various routing methods. The browser connects directly to the endpoint; [Traffic Manager doesn't see the HTTP(S) traffic](/azure/traffic-manager/traffic-manager-routing-methods#priority-traffic-routing-method).

2.  The Azure Firewall Premium is zone-redundant, and it will inspect the inbound traffic for security. If the Azure Firewall detects a threat in the traffic, it will drop the packets. Otherwise, upon successful inspection the Azure Firewall will forward the traffic to the web-tier internal load balancer performing Destination Network Address Translation (DNAT) on the inbound packets.

3. The web-tier is the first layer of the three-tier application, it contains the user interface and it also parses user interactions. The web-tier load balancer is spread over all three availability zones, and it will distribute traffic to each of the three web-tier virtual machines.

4. The web-tier virtual machines are spread across all three availability zones, and they will communicate with the business tier via a dedicated internal load balancer.

5. The business tier processes the user interactions and determines the next steps, and it sits between the web and data tiers. The business-tier internal load balancer distributes traffic to the business-tier virtual machines across the three availability zones. The business-tier load balancer is zone-redundant, like the web-tier load balancer.

6. The business-tier virtual machines are spread across availability zones, and they will route traffic to the availability group listener of the databases.

7. The data-tier stores the application data, typically in a database, object storage, or file share. This architecture has SQL server on virtual machines distributed across three availability zones. They are in an availability group and use a distributed network name (DNN) to route traffic to the [availability group listener](/azure/azure-sql/virtual-machines/windows/availability-group-overview) for load balancing.

### Outbound traffic flows (all protocols)

Outbound traffic flows for virtual machine patch updates or other connectivity to the Internet will go from the workload virtual machines to the Azure Firewall through User-Defined Routes. The Azure Firewall will enforce connectivity rules using web categories as well as network and application rules to prevent workloads from accessing inappropriate content or data exfiltration scenarios.

### Components

- [Azure Firewall](https://learn.microsoft.com/azure/private-link/private-link-overview) is a cloud-based, Microsoft-managed next-generation firewall that provides deep packet inspection for both North/South and East/West traffic flows. It can be spread across Availability Zones and it offers automatic autoscaling to cope with application demand changes. 
- [Azure Application Gateway](https://azure.microsoft.com/services/application-gateway/) is a layer-7 load balancer with optional Web Application Firewall (WAF) functionality. The v2 SKU of Application Gateway supports availability zone redundancy and it is recommended for most scenarios. The Application Gateway includes configurable horizontal autoscaling so that it can react automatically to application demand changes.
- [Azure Traffic Manager](https://azure.microsoft.com/services/traffic-manager/) is a DNS-based global traffic load balancer that distributes traffic to services across global Azure regions while providing high availability and responsiveness. For more information, see the section [Traffic Manager configuration](../reference-architectures/n-tier/multi-region-sql-server.yml#traffic-manager-configuration).
- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer/) is a layer-4 load balancer. A zone-redundant load balancer will still distribute traffic with an availability zone failure to the remaining zones.
- [Azure DDoS Protection](https://azure.microsoft.com/services/ddos-protection/) has enhanced features to protect against distributed denial of service (DDoS) attacks.
- [Azure DNS](https://azure.microsoft.com/services/dns/) is a hosting service for DNS domains. It provides name resolution using Microsoft Azure infrastructure. By hosting your domains in Azure, you can manage your DNS records using the same credentials, APIs, tools, and billing as your other Azure services.
- [Azure Private DNS zones](/azure/dns/private-dns-overview) are a feature of Azure DNS. Azure DNS Private Zones provide name resolution within a virtual network, and between virtual networks. The records contained in a private DNS zone aren't resolvable from the Internet. DNS resolution against a private DNS zone works only from virtual networks linked to it.
- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines/) are on-demand, scalable computing resources that give you the flexibility of virtualization but eliminate the maintenance demands of physical hardware. The operating system choices include Windows and Linux. Certain components of the applications can be replaced with platform-as-a-service Azure resources (for example the database and the frontend tier), but the architecture wouldn't change significantly if using [Private Link](/azure/private-link/private-link-overview) and [App Service VNet Integration](/azure/app-service/overview-vnet-integration) to bring those PaaS services into the virtual network.
- [Azure Virtual Machine Scale Sets](https://azure.microsoft.com/services/virtual-machine-scale-sets/) is automated and load-balanced virtual machine scaling that simplifies management of your applications and increases availability.
- [SQL Server on VMs](https://azure.microsoft.com/services/virtual-machines/sql-server/#overview) lets you use full versions of SQL Server in the cloud without having to manage any on-premises hardware.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/) is a secure private network in the cloud. It connects virtual machines to one another, to the Internet, and to cross-premises networks.
- [User-Defined Routes](/azure/virtual-network/virtual-networks-udr-overview) are a mechanism to override the default routing in virtual networks. In this scenario they are used to force traffic inbound and outbound traffic flows to traverse the Azure Firewall.

## Solution Details

*Traffic Manager -* We configured Traffic Manager to use performance routing. It routes traffic to the endpoint that has the lowest latency for the user. Traffic Manager automatically adjusts its load balancing algorithm as endpoint latency changes. Traffic manager provides automatic failover if there's a regional outage. It uses priority routing and regular health checks to determine where to route traffic.

*Availability Zones -* The architecture uses three availability zones. The zones create a high-availability architecture for the Application Gateways, internal load balancers, and virtual machines in each region. If there is a zone outage, the remaining availability zones in that region would take over the load, which wouldn't trigger a regional failover.

*Application Gateway -* While Traffic Manager provides DNS-based regional load balancing, Application Gateway gives you many of the same capabilities as Azure Front Door but at the regional level such as:

- Web Application Firewall (WAF)
- Transport Layer Security (TLS) termination
- Path-based routing
- Cookie-based session affinity

*Azure Firewall -* Azure Firewall Premium offers network security for generic applications (web and non-web traffic), inspecting three types of flows in this architecture:

- Inbound HTTP(S) flows from the Application Gateway are protected with Azure Firewall Premium TLS inspection.
- Inbound non-HTTP(S) flows from the public Internet are inspected with the rest of [Azure Firewall Premium features](/azure/firewall/premium-features).
- Outbound flows from Azure Virtual Machines are inspected by Azure Firewall to prevent data exfiltration and access to forbidden sites and applications.

*Virtual network peering -* We call peering between regions "global virtual network peering." Global virtual network peering provides low-latency, high-bandwidth data replication between regions. You can transfer data across Azure subscriptions, Azure Active Directory tenants, and deployment models with this global peering. In hub-spoke environment virtual network peerings would exist between hub and spoke networks.

## Recommendations

The following recommendations adhere to the pillars of the Azure Well-Architected Framework (WAF). The WAF pillars are guiding tenets that help ensure the quality of cloud workloads. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

*Regions -* Use at least two Azure regions for high availability. You can deploy your application across multiple Azure regions in active/passive or active/active configurations. Multiple regions also help avoid application downtime if a subsystem of the application fails.

- Traffic Manager will automatically fail over to the secondary region if the primary region fails.
- Choosing the best regions for your needs must be based on technical, regulatory considerations, and availability-zone support.

*Region pairs -* Use Region Pairs for the most resiliency. Make sure that both Region Pairs support all the Azure services that your application needs (see [services by region](https://azure.microsoft.com/global-infrastructure/geographies/#services)). Here are two benefits of Region Pairs:

- Planned Azure updates roll out to paired regions one at a time to minimize downtime and risk of application outage.
- Data continues to reside within the same geography as its pair (except for Brazil South) for tax and legal purposes.

*Availability zones -* Use multiple availability zones to support your Application Gateway, Azure Firewall, Azure Load Balancer, and application tiers when available.

*Application gateway autoscaling and instances -* Configure the Application Gateway with a minimum of two instances to avoid downtime, and autoscaling to provide dynamic adaptation to changing application capacity demands.

For more information, see:

- [Regions and availability zones in Azure](/azure/availability-zones/az-overview)
- [Business continuity and disaster recovery (BCDR): Azure Paired Regions](/azure/best-practices-availability-paired-regions)

### Global routing

*Global routing method -* Use the traffic-routing method that best meets the needs of your customers. Traffic Manager supports multiple traffic-routing methods to deterministically route traffic to the various service endpoints.

*Nested configuration -* Use Traffic Manager in a nested configuration if you need more granular control to choose a preferred failover within a region.

For more information, see:

- [Configure the performance traffic routing method](/azure/traffic-manager/traffic-manager-configure-performance-routing-method)
- [Traffic Manager routing methods](/azure/traffic-manager/traffic-manager-routing-methods)

### Global traffic view

Use Traffic View in Traffic Manager to see traffic patterns and latency metrics. Traffic View can help you plan your footprint expansion to new Azure regions.

See [Traffic Manager Traffic View](/azure/traffic-manager/traffic-manager-traffic-view-overview) for details.

### Application Gateway

Use Application Gateway v2 SKU for out-of-the-box automated resiliency.

- Application Gateway v2 SKU automatically ensures that new instances spawn across fault domains and update domains. If you choose zone redundancy, the newest instances also spawn across availability zones to give fault tolerance.

- Application Gateway v1 SKU supports high-availability scenarios when you've deployed two or more instances. Azure distributes these instances across update and fault domains to ensure that instances don't fail at the same time. The v1 SKU supports scalability by adding multiple instances of the same gateway to share the load.

The Application Gateway needs to trust the CA certificate of Azure Firewall.

### Azure Firewall

The Premium tier of Azure Firewall is required in this design to provide TLS inspection. Azure Firewall will intercept the TLS sessions between Application Gateway and the web-tier virtual machines generating its own certificates, as well as inspect outbound traffic flows from the virtual networks to the public Internet. You can find more information on this design in [Zero-trust network for web applications with Azure Firewall and Application Gateway](/azure/architecture/example-scenario/gateway/application-gateway-before-azure-firewall).

### Health probe recommnendations

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

### Operational excellence

*Resource groups -* Use [resource groups](/azure/azure-resource-manager/management/overview) to manage Azure resources by lifetime, owner, and other characteristics.

*Virtual network peering -* Use [virtual network peering](/azure/virtual-network/virtual-network-peering-overview) to seamlessly connect two or more virtual networks in Azure. The virtual networks appear as one for connectivity purposes. The traffic between virtual machines in peered virtual networks uses the Microsoft backbone infrastructure. Make sure that the address space of the virtual networks doesn't overlap.

*Virtual network and subnets -* Create a separate subnet for each tier of your subnet. You should deploy VMs and resources, such as Application Gateway and Load Balancer, into a virtual network with subnets.

## Security

*Web Application Firewall -* The WAF functionality of Azure Application Gateway will detect and prevent attacks at the HTTP level, such as SQL injection (SQLi) or cross-site scripting (CSS).

*Next-Generation Firewall -* Azure Firewall Premium provides an additional layer of defence by inspecting content for non-web attacks, such as malicious files uploaded via HTTP(S) or any other protocol.

*End-to-end encryption -* Traffic is encrypted at all times when traversing the Azure network. Both Application Gateway and Azure Firewall encrypt traffic before sending it to the corresponding backend system.

*Distributed Denial of Service (DDoS) -* Use [Azure DDoS Network Protection](/azure/ddos-protection/ddos-protection-overview) for greater DDoS protection than the basic protection that Azure provides. For more information, see [security considerations](../reference-architectures/n-tier/n-tier-sql-server.yml#security).

*Network security groups (NSGs):* Use [NSGs](/azure/virtual-network/network-security-groups-overview) to restrict network traffic within the virtual network. For example, in the three-tier architecture shown here, the data tier accepts traffic only from the business tier, not from the web front end. Only the business tier can communicate directly with the database tier. To enforce this rule, the database tier should block all incoming traffic except for the business-tier subnet.

1. Allow inbound traffic from the business-tier subnet.
1. Allow inbound traffic from the database-tier subnet itself. This rule allows communication between the database VMs. Database replication and failover need this rule.
1. Deny all inbound traffic from the virtual network, using the `VirtualNetwork` tag in the rule) to overwrite the permit statement included in the default NSG rules.

Create rule 3 with lower priority (higher number) than the first rules.

You can use [service tags](/azure/virtual-network/service-tags-overview) to define network access controls on Network Security Groups or Azure Firewall.

For more information, see [application gateway infrastructure configuration](/azure/application-gateway/configuration-infrastructure#network-security-groups).

### Cost optimization

For more information, see:

- [Load Balancing pricing](https://azure.microsoft.com/pricing/details/load-balancer/)
- [Virtual network Pricing](https://azure.microsoft.com/pricing/details/virtual-network/)
- [Application gateway pricing](https://azure.microsoft.com/pricing/details/application-gateway/)
- [Choose the right Azure Firewall SKU to meet your needs](/azure/firewall/choose-firewall-sku)
- [Traffic Manager pricing](https://azure.microsoft.com/pricing/details/traffic-manager/)
- [Pricing calculator](https://azure.microsoft.com/pricing/calculator/)

## Performance efficiency

*Virtual machine scale sets -* Use Virtual Machine Scale Sets to automate the scalability of your virtual machines. Virtual machine scale sets are available on all Windows and Linux virtual machine sizes. You're only charged for the virtual machines deployed and the underlying infrastructure resources consumed. There are no incremental charges. The benefits of Virtual Machine Scale Sets are:

- Create and manage multiple virtual machines easily
- High availability and application resiliency
- Automated scaling as resource demand changes

For more information, see [Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview).

## Next steps

For more reference architectures using the same technologies, see:

- [Multi-region N-tier application](../reference-architectures/n-tier/multi-region-sql-server.yml)
- [IaaS: Web application with relational database](./ref-arch-iaas-web-and-db.yml)
- [AKS baseline for multi-region clusters](../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml)

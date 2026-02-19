This architecture is for global, internet-facing applications that use HTTP(S) and non-HTTP(S) protocols. It features DNS-based global load balancing, two forms of regional load balancing, and global virtual network peering to create a high availability architecture that can withstand a regional outage. Traffic inspection is provided by both Azure Web Application Firewall (WAF) and Azure Firewall.

### Architecture notes

The architecture in this document is easily extensible to a hub-and-spoke virtual network design, where the Azure Firewall would be in the hub network, and the Application Gateway either in the hub network as well or in a spoke. If the Application Gateway is deployed in the hub, you still want multiple Application Gateways, each for a given set of applications, to control Azure role-based access control (Azure RBAC) scope and to prevent reaching internal Application Gateway limits. For more information, see [Application Gateway Limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#application-gateway-limits).

In a Virtual WAN environment Application Gateways cannot be deployed in the hub, so they would be installed in spoke virtual networks.

The proposed architecture opts for double inspection of web content through both a Web Application Firewall (based on Application Gateway) in front of Azure Firewall. Other options exist, as documented in [Firewall and Application Gateway for virtual networks](/azure/architecture/example-scenario/gateway/firewall-application-gateway), but this option is the most flexible and complete one: it exposes the client's IP address in the HTTP header `X-Forwarded-For` for the end application, it provides end-to-end encryption, and it prevents clients from bypassing the WAF to access the application.

If your workload only exposes HTTP(S) endpoints and does not require deep packet inspection by Azure Firewall, use [Azure Front Door](/azure/frontdoor/front-door-overview) instead of Traffic Manager. Front Door is a layer-7 global load balancer purpose-built for HTTP(S) traffic that provides caching, traffic acceleration, TLS termination, certificate management, and built-in WAF. It is the preferred global routing solution for HTTP(S)-only workloads. This architecture uses Traffic Manager because it must also handle non-HTTP(S) protocol flows and route them through Azure Firewall for network-level inspection, which Front Door does not support.

### Inbound HTTP(S) traffic flows

:::image type="content" source="images/high-availability-multi-region-web-v-10.png" alt-text="Diagram showing multi-region load balancing with Azure Firewall, Application Gateway and Traffic Manager for web traffic." lightbox="images/high-availability-multi-region-web-v-10.png":::

*Download a [Visio file](https://arch-center.azureedge.net/high-availability-multi-region-v-10.vsdx) of this architecture.*

1. Azure Traffic Manager uses DNS-based routing to load balance incoming traffic across the two regions. Traffic Manager resolves DNS queries for the application to the public IP addresses of the Azure Application Gateway endpoints. The public endpoints of the Application Gateways serve as the backend endpoints of Traffic Manager for HTTP(S) traffic. Traffic Manager resolves DNS queries based on a choice of various routing methods. The browser connects directly to the endpoint; [Traffic Manager doesn't see the HTTP(S) traffic](/azure/traffic-manager/traffic-manager-routing-methods#priority-traffic-routing-method).

2. The Application Gateways deployed across availability zones receive HTTP(S) traffic from the browser, and the Web Application Firewalls Premium inspect the traffic to detect web attacks. The Application Gateways sends traffic to their backend, the internal load balancer for the frontend virtual machines (VMs). For this specific flow, the internal load balancer in front of the web servers isn't strictly required since the Application Gateway could perform this load balancing itself. But it's included for consistency with the flow for non-HTTP(S) applications.

1. The traffic between the Application Gateway and the frontend internal load balancer is intercepted by Azure Firewall Premium via User Defined Routes applied on the Application Gateway subnet. The Azure Firewall Premium applies TLS inspection to the traffic for additional security. The Azure Firewall is zone-redundant as well. If the Azure Firewall detects a threat in the traffic, it drops the packets. Otherwise, after successful inspection the Azure Firewall forwards the traffic to the destination web-tier internal load balancer. 

1. The web-tier is the first layer of the three-tier application. It contains the user interface and it also parses user interactions. The web-tier load balancer is spread over all three availability zones, and it distributes traffic to each of the three web-tier virtual machines.

1. The web-tier virtual machines are spread across all three availability zones, and they communicate with the business tier by way of a dedicated internal load balancer.

1. The business tier processes the user interactions and determines the next steps, and it sits between the web and data tiers. The business-tier internal load balancer distributes traffic to the business-tier virtual machines across the three availability zones. The business-tier load balancer is zone-redundant, like the web-tier load balancer.

1. The business-tier virtual machines are spread across availability zones, and they route traffic to the availability group listener of the databases.

1. The data-tier stores the application data, typically in a database, object storage, or file share. This architecture has SQL Server on virtual machines distributed across three availability zones. They use an Always On availability group with each SQL Server VM in a [separate subnet](/azure/azure-sql/virtual-machines/windows/availability-group-manually-configure-prerequisites-tutorial-multi-subnet). A multi-subnet deployment allows the [availability group listener](/azure/azure-sql/virtual-machines/windows/availability-group-overview) to route traffic directly to the replicas without requiring an Azure Load Balancer or distributed network name (DNN).

### Inbound non-HTTP(S) traffic flows

Some workloads accept traffic over protocols other than HTTP(S), such as SFTP for file-based data ingestion from business partners or legacy TCP-based integrations. This flow handles those scenarios.

:::image type="content" source="images/high-availability-multi-region-nonweb-v-10.png" alt-text="Diagram showing multi-region load balancing with Azure Firewall, Application Gateway and Traffic Manager for non-web traffic." lightbox="images/high-availability-multi-region-nonweb-v-10.png":::

*Download a [Visio file](https://arch-center.azureedge.net/high-availability-multi-region-v-10.vsdx) of this architecture.*

1. Azure Traffic Manager uses DNS-based routing to load balance incoming traffic across the two regions. Traffic Manager resolves DNS queries for the application to the public IP addresses of the Azure endpoints. The public endpoints of Azure Firewall serve as the backend endpoints of Traffic Manager for non-HTTP(S) traffic. Traffic Manager resolves DNS queries based on a choice of various routing methods. The client connects directly to the resolved endpoint; [Traffic Manager doesn't see the protocol traffic](/azure/traffic-manager/traffic-manager-routing-methods#priority-traffic-routing-method).

1. The Azure Firewall Premium is zone-redundant, and it inspects the inbound traffic for security. If the Azure Firewall detects a threat in the traffic, it drops the packets. Otherwise, upon successful inspection the Azure Firewall forwards the traffic to the web-tier internal load balancer performing Destination Network Address Translation (DNAT) on the inbound packets.

1. The web-tier is the first layer of the three-tier application, it contains the user interface and it also parses user interactions. The web-tier load balancer is spread over all three availability zones, and it distributes traffic to each of the three web-tier virtual machines.

1. The web-tier virtual machines are spread across all three availability zones, and they communicate with the business tier via a dedicated internal load balancer.

1. The business tier processes the user interactions and determines the next steps, and it sits between the web and data tiers. The business-tier internal load balancer distributes traffic to the business-tier virtual machines across the three availability zones. The business-tier load balancer is zone-redundant, like the web-tier load balancer.

1. The business-tier virtual machines are spread across availability zones, and they route traffic to the availability group listener of the databases.

1. The data-tier stores the application data, typically in a database, object storage, or file share. This architecture has SQL Server on virtual machines distributed across three availability zones. They use an Always On availability group with each SQL Server VM in a [separate subnet](/azure/azure-sql/virtual-machines/windows/availability-group-manually-configure-prerequisites-tutorial-multi-subnet). A multi-subnet deployment allows the [availability group listener](/azure/azure-sql/virtual-machines/windows/availability-group-overview) to route traffic directly to the replicas without requiring an Azure Load Balancer or distributed network name (DNN).

### Outbound traffic flows (all protocols)

Outbound traffic flows for virtual machine patch updates or other connectivity to the Internet go from the workload virtual machines to the Azure Firewall through user-defined routes (UDRs). The Azure Firewall enforces connectivity rules using web categories as well as network and application rules to prevent workloads from accessing inappropriate content or data exfiltration scenarios.

### Components

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a cloud-based, Microsoft-managed next-generation firewall that provides deep packet inspection for north-south and east-west traffic flows. In this architecture, Azure Firewall provides network security for both web and non-web traffic. It uses TLS inspection to inspect inbound HTTP(S) flows from Application Gateway, handles inbound non-HTTP(S) flows from the public internet, and inspects outbound flows from VMs to prevent data exfiltration.

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a layer-7 load balancer that provides web application firewall (WAF) functionality. In this architecture, Application Gateway provides regional load balancing for HTTP(S) traffic, helps detect and prevent web attacks, and provides TLS termination and path-based routing. It serves as the back-end endpoint for Traffic Manager.

- [Traffic Manager](/azure/well-architected/service-guides/traffic-manager/reliability) is a DNS-based global traffic load balancer that distributes traffic to services across global Azure regions while providing high availability and responsiveness. In this architecture, Traffic Manager provides global load balancing by resolving DNS queries to direct traffic to the appropriate regional endpoints. It automatically fails over to secondary regions during outages.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer/reliability) is a layer-4 load balancer that distributes incoming network traffic among back-end resources. In this architecture, Load Balancer provides internal load balancing between application tiers and maintains high availability across availability zones within each region.

- [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) is a service that helps protect against distributed denial of service (DDoS) attacks. In this architecture, DDoS Protection provides protection for public IP addresses and helps ensure availability during attack scenarios.

- [Azure DNS](/azure/dns/dns-overview) is a hosting service for DNS domains. It provides name resolution by using Microsoft Azure infrastructure. In this architecture, Azure DNS manages DNS records and works with Traffic Manager to provide global DNS-based load balancing and failover capabilities.

- [Azure DNS private zones](/azure/dns/private-dns-overview) are a feature of Azure DNS. Azure DNS private zones provide name resolution within a virtual network and between virtual networks. In this architecture, Azure DNS private zones enable internal name resolution for resources within the virtual network infrastructure.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is a service that provides on-demand, scalable computing resources that give you the flexibility of virtualization but eliminate the maintenance demands of physical hardware. In this architecture, Virtual Machines host the application tiers and distributes them across availability zones in multiple regions for high availability.

   You can replace specific components, like the database and the front-end tier, of the applications with platform as a service (PaaS) Azure resources. However, the architecture won't change significantly if you use [Azure Private Link](/azure/private-link/private-link-overview) and [Azure App Service virtual network integration](/azure/app-service/overview-vnet-integration) to bring those PaaS services into the virtual network.

- [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview) with [Flexible orchestration](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-orchestration-modes#scale-sets-with-flexible-orchestration) is a service that lets you create and manage a group of load-balanced VMs that can automatically scale based on demand. In this architecture, Virtual Machine Scale Sets hosts the web, business, and data tier VMs across availability zones in each region.

- [SQL Server on VMs](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview) is a service that provides full versions of SQL Server in the cloud without having to manage any on-premises hardware. In this architecture, SQL Server on VMs forms the data tier with Always On availability groups distributed across availability zones in a [multi-subnet configuration](/azure/azure-sql/virtual-machines/windows/availability-group-manually-configure-prerequisites-tutorial-multi-subnet).

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a secure private network in the cloud. It connects VMs to one another, to the internet, and to cross-premises networks. In this architecture, Virtual Network provides network isolation and connectivity for all components. Global virtual network peering enables low-latency communication between regions.

- [UDRs](/azure/virtual-network/virtual-networks-udr-overview) are a mechanism to override the default routing in virtual networks. In this architecture, they force inbound and outbound traffic flows to traverse Azure Firewall for security inspection and policy enforcement.

## Solution details

*Traffic Manager -* We configured Traffic Manager to use performance routing. It routes traffic to the endpoint that has the lowest latency for the user. Traffic Manager automatically adjusts its load balancing algorithm as endpoint latency changes. Traffic manager provides automatic failover if there's a regional outage. It uses priority routing and regular health checks to determine where to route traffic.

*Availability Zones -* The architecture uses three availability zones. The zones create a high-availability architecture for the Application Gateways, internal load balancers, and virtual machines in each region. If there's a zone outage, the remaining availability zones in that region would take over the load, which wouldn't trigger a regional failover.

*Application Gateway -* While Traffic Manager provides DNS-based global load balancing, Application Gateway gives you many of the same capabilities as Azure Front Door but at the regional level such as:

- Web Application Firewall (WAF)
- Transport Layer Security (TLS) termination
- Path-based routing
- Cookie-based session affinity

*Azure Firewall -* Azure Firewall Premium offers network security for generic applications (web and non-web traffic), inspecting three types of flows in this architecture:

- Inbound HTTP(S) flows from the Application Gateway are protected with Azure Firewall Premium TLS inspection.
- Inbound non-HTTP(S) flows from the public Internet are inspected with the rest of [Azure Firewall Premium features](/azure/firewall/premium-features).
- Outbound flows from Azure Virtual Machines are inspected by Azure Firewall to prevent data exfiltration and access to forbidden sites and applications.

*Virtual Machine Scale Sets -* This architecture uses Flexible orchestration for all three application tiers. The data tier's multi-subnet SQL Server availability group requires placing individual VMs into specific subnets and fault domains, which only Flexible orchestration supports. The web and business tiers use Flexible orchestration as well to maintain a single operational model across the workload rather than mixing orchestration modes across tiers.

*Virtual network peering -* We call peering between regions "global virtual network peering." Global virtual network peering provides low-latency, high-bandwidth data replication between regions. You can transfer data across Azure subscriptions, Microsoft Entra tenants, and deployment models with this global peering. In hub-spoke environment virtual network peerings would exist between hub and spoke networks.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

*Regions -* Use at least two Azure regions for high availability. You can deploy your application across multiple Azure regions in active/passive or active/active configurations. Multiple regions also help avoid application downtime if a subsystem of the application fails.

Traffic Manager automatically fails over to the secondary region if the primary region fails.

Choose the best regions for your needs based on all of these factors:

- Your technical requirements, including geographic distance and cross-region latency
- Data residency needs
- Regulatory considerations
- Availability zone support
- Service availability in each region
- Cost

Many Azure regions are paired. If your region has a pair, there can be some benefits to using the paired region as your secondary region. However, you should verify the region pair meets all your requirements first.

For more information about how to select Azure regions, see [Select Azure regions in the Cloud Adoption Framework](/azure/cloud-adoption-framework/ready/azure-setup-guide/regions).

*Availability zones -* Use multiple availability zones to support your Application Gateway, Azure Firewall, Azure Load Balancer, and application tiers when available.

*Virtual Machine Scale Sets -* Flexible orchestration distributes VM instances across fault domains within each availability zone, which reduces the blast radius of a single host failure. It also lets you assign individual VMs to specific availability zones and fault domains, which provides the placement control that the multi-subnet SQL Server availability group configuration in this architecture requires.

For more information, see:

- [Regions and availability zones in Azure](/azure/reliability/availability-zones-overview)
- [Azure region pairs and nonpaired regions](/azure/reliability/regions-paired)

#### Global routing

*Global routing method -* Use the traffic-routing method that best meets the needs of your customers. Traffic Manager supports multiple traffic-routing methods to deterministically route traffic to the various service endpoints.

*Nested configuration -* Use Traffic Manager in a nested configuration if you need more granular control to choose a preferred failover within a region.

For more information, see:

- [Configure the performance traffic routing method](/azure/traffic-manager/traffic-manager-configure-performance-routing-method)
- [Traffic Manager routing methods](/azure/traffic-manager/traffic-manager-routing-methods)

#### Global traffic view

Use Traffic View in Traffic Manager to see traffic patterns and latency metrics. Traffic View can help you plan your footprint expansion to new Azure regions.

For more information, see [Traffic Manager Traffic View](/azure/traffic-manager/traffic-manager-traffic-view-overview).

#### Application Gateway

To maintain reliable traffic flow through Application Gateway:

- The platform automatically distributes instances across fault domains and update domains. In regions that support availability zones, Application Gateway is zone-redundant by default, which means instances are also spread across availability zones for zonal fault tolerance.
- Enable autoscaling and set the minimum instance count to at least two. This reserved capacity ensures that Application Gateway can serve traffic without the three-to-five-minute delay that provisioning new instances requires. For more information, see [Application Gateway autoscaling](/azure/application-gateway/application-gateway-autoscaling-zone-redundant).

#### Azure Firewall

The Premium tier of Azure Firewall is required in this design to provide TLS inspection. Azure Firewall intercepts the TLS sessions between Application Gateway and the web-tier virtual machines generating its own certificates, as well as inspect outbound traffic flows from the virtual networks to the public Internet. You can find more information on this design in [Zero-trust network for web applications with Azure Firewall and Application Gateway](/azure/architecture/example-scenario/gateway/application-gateway-before-azure-firewall).

Monitor the expiration dates of the intermediate CA certificates that Azure Firewall uses for TLS inspection. An expired certificate breaks the TLS handshake and prevents traffic from reaching your backend servers, even though all infrastructure components remain healthy. For more information about the certificate configuration, see [TLS certificate trust chain](#security) in this article.

#### Health probe recommendations

Here are some recommendations for health probes in Traffic Manager, Application Gateway, and Load Balancer.

##### Traffic Manager

*Endpoint health -* Create an endpoint that reports the overall health of the application. Traffic Manager uses an HTTP(S) probe to monitor the availability of each region. The probe checks for an HTTP 200 response for a specified URL path. Use the endpoint you created for the health probe. Otherwise, the probe might report a healthy endpoint when critical parts of the application are failing.

For more information, see [health endpoint monitoring pattern](../patterns/health-endpoint-monitoring.yml).

*Failover delay -* Traffic Manager has a failover delay. The following factors determine the duration of the delay:

- Probing intervals: How often the probe checks the health of the endpoint.
- Tolerated number of failures: How many failures the probe tolerates before marking the endpoint unhealthy.
- Probe timeout: how long before Traffic Manager considers the endpoint unhealthy.
- Time-to-live (TTL): DNS servers must update the cached DNS records for the IP address. The time it takes depends on the DNS TTL. The default TTL is 300 seconds (5 minutes), but you can configure this value when you create the Traffic Manager profile.

For more information, see [Traffic Manager monitoring](/azure/traffic-manager/traffic-manager-monitoring).

##### Application Gateway and Load Balancer

Familiarize yourself with the health probe policies of the Application Gateway and load balancer to ensure you understand the health of your VMs. Here's a brief overview:

- Application Gateway always uses an HTTP probe.

- Load Balancer can evaluate either HTTP or TCP. Use an HTTP probe if a VM runs an HTTP server. Use TCP for everything else.

- HTTP probes send an HTTP GET request to a specified path and listen for an HTTP 200 response. This path can be the root path ("/"), or a health-monitoring endpoint that implements custom logic to check the health of the application.
- The endpoint must allow anonymous HTTP requests. If a probe can't reach an instance within the timeout period, the Application Gateway or Load Balancer stops sending traffic to that VM. The probe continues to check and returns the VM to the back-end pool if the VM becomes available again.

For more information, see:

- [Load Balancer health probes](/azure/load-balancer/load-balancer-custom-probe-overview)
- [Application Gateway health monitoring overview](/azure/application-gateway/application-gateway-probe-overview)
- [Health endpoint monitoring pattern](../patterns/health-endpoint-monitoring.yml)

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This architecture follows zero-trust principles by assuming no implicit trust between components. Traffic is inspected and authorized at multiple points: Application Gateway's WAF filters HTTP-level threats, Azure Firewall Premium performs deep packet inspection on all traffic flows, NSGs enforce least-privilege network segmentation between tiers, and TLS encryption protects data in transit between every hop. No single layer is trusted to catch all threats.

*Web Application Firewall -* The WAF functionality of Azure Application Gateway detects and prevents attacks at the HTTP level, such as SQL injection (SQLi) or cross-site scripting (XSS).

*Next-Generation Firewall -* Azure Firewall Premium provides an additional layer of defense by inspecting content for non-web attacks, such as malicious files uploaded via HTTP(S) or any other protocol.

*End-to-end encryption -* Traffic is encrypted at all times when traversing the Azure network. Both Application Gateway and Azure Firewall encrypt traffic before sending it to the corresponding backend system.

*TLS certificate trust chain -* Azure Firewall Premium acts as a forward proxy and dynamically generates certificates signed by a private CA during TLS inspection. Configure Application Gateway to trust the root CA certificate that Azure Firewall uses so that the TLS handshake between them succeeds. For production deployments, use an enterprise PKI to generate the intermediate CA certificate. For more information, see [Deploy and configure enterprise CA certificates for Azure Firewall](/azure/firewall/premium-deploy-certificates-enterprise-ca) and the [certificate chain details for this architecture](/azure/architecture/example-scenario/gateway/application-gateway-before-azure-firewall#digital-certificates).

*Distributed Denial of Service (DDoS) -* Use [Azure DDoS Network Protection](/azure/ddos-protection/ddos-protection-overview) for greater DDoS protection than the basic protection that Azure provides.

*Network security groups (NSGs) -* Use [NSGs](/azure/virtual-network/network-security-groups-overview) to restrict network traffic within the virtual network. For example, in the three-tier architecture shown here, the data tier accepts traffic only from the business tier, not from the web front end. Only the business tier can communicate directly with the database tier. To enforce this rule, the database tier should block all incoming traffic except for the business-tier subnet.

1. Allow inbound traffic from the business-tier subnet.
1. Allow inbound traffic from the database-tier subnet itself. This rule allows communication between the database VMs. Database replication and failover need this rule.
1. Deny all inbound traffic from the virtual network, using the `VirtualNetwork` tag in the rule to overwrite the permit statement included in the default NSG rules.

Create rule 3 with lower priority (higher number) than the first rules.

You can use [service tags](/azure/virtual-network/service-tags-overview) to define network access controls on Network Security Groups or Azure Firewall.

For more information, see [application gateway infrastructure configuration](/azure/application-gateway/configuration-infrastructure#network-security-groups).

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

For more information, see:

- [Load Balancing pricing](https://azure.microsoft.com/pricing/details/load-balancer/)
- [Virtual network Pricing](https://azure.microsoft.com/pricing/details/virtual-network/)
- [Application gateway pricing](https://azure.microsoft.com/pricing/details/application-gateway/)
- [Choose the right Azure Firewall SKU to meet your needs](/azure/firewall/choose-firewall-sku)
- [Traffic Manager pricing](https://azure.microsoft.com/pricing/details/traffic-manager/)
- [Pricing calculator](https://azure.microsoft.com/pricing/calculator/)

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

*Resource groups -* Use [resource groups](/azure/azure-resource-manager/management/overview) to manage Azure resources by lifetime, owner, and other characteristics.

*Virtual network peering -* Use [virtual network peering](/azure/virtual-network/virtual-network-peering-overview) to connect two or more virtual networks in Azure. The virtual networks appear as one for connectivity purposes. The traffic between virtual machines in peered virtual networks uses the Microsoft backbone infrastructure. Make sure that the address space of the virtual networks doesn't overlap.

*Application tier patching -* Virtual Machine Scale Sets with Flexible orchestration supports [automatic guest patching](/azure/virtual-machines/automatic-vm-guest-patching), which applies critical and security patches during off-peak hours without operator intervention. However, Flexible orchestration does not support automatic OS image upgrades. Use [Azure Update Manager](/azure/update-manager/overview) or your deployment pipeline to manage OS image updates across the web, business, and data tiers.

*Virtual network and subnets -* Create a separate subnet for each tier of your subnet. You should deploy VMs and resources, such as Application Gateway and Load Balancer, into a virtual network with subnets.

### Performance Efficiency

Performance Efficiency is the ability of your workload to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

*Virtual Machine Scale Sets -* Deploy a separate [Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview) instance with [Flexible orchestration](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-orchestration-modes#scale-sets-with-flexible-orchestration) for each application tier (web, business, and data). Separate scale sets let you scale each tier independently based on its own demand profile. Configure [autoscaling policies](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview) on the web and business tiers to scale out during demand increases and scale in during off-peak periods.

## Next steps

For more reference architectures using the same technologies, see:

- [AKS baseline for multi-region clusters](../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml)

This architecture is for global, internet-facing applications that use HTTP(S) and non-HTTP(S) protocols. It features DNS-based global load balancing, two forms of regional load balancing, and global virtual network peering to create a reliable architecture. Availability zones provide resiliency within each region, and multi-region deployment with automatic failover provides recoverability from a regional outage. Traffic inspection is provided by both Azure Web Application Firewall (WAF) and Azure Firewall.

### Architecture notes

The architecture in this document is easily extensible to a hub-and-spoke virtual network design, where the Azure Firewall would be in the hub network, and the Application Gateway either in the hub network as well or in a spoke. If the Application Gateway is deployed in the hub, you still want multiple Application Gateways, each for a given set of applications, to control Azure role-based access control (Azure RBAC) scope and to prevent reaching internal Application Gateway limits. For more information, see [Application Gateway Limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#application-gateway-limits).

In a Virtual WAN environment Application Gateways cannot be deployed in the hub, so they would be installed in spoke virtual networks.

The proposed architecture opts for double inspection of web content through both a Web Application Firewall (based on Application Gateway) in front of Azure Firewall. Other options exist, as documented in [Firewall and Application Gateway for virtual networks](/azure/architecture/example-scenario/gateway/firewall-application-gateway), but this option is the most flexible and complete one: it exposes the client's IP address in the HTTP header `X-Forwarded-For` for the end application, it provides end-to-end encryption, and it prevents clients from bypassing the WAF to access the application.

### Inbound HTTP(S) traffic flows

HTTP(S) traffic passes through both Application Gateway's WAF and Azure Firewall Premium's TLS inspection before reaching the application tiers.

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

Some workloads accept traffic over protocols other than HTTP(S), such as SFTP for file-based data ingestion from business partners or legacy TCP-based integrations. Non-HTTP(S) traffic routes directly to Azure Firewall for DNAT and inspection, bypassing Application Gateway.

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

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is a service that provides on-demand, scalable computing resources that give you the flexibility of virtualization but eliminate the maintenance demands of physical hardware. In this architecture, Virtual Machines host the application tiers, distributed across availability zones for resiliency and across multiple regions for recoverability.

- [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview) with [Flexible orchestration](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-orchestration-modes#scale-sets-with-flexible-orchestration) is a service that lets you create and manage a group of load-balanced VMs that can automatically scale based on demand. In this architecture, Virtual Machine Scale Sets hosts the web, business, and data tier VMs across availability zones in each region.

- [SQL Server on VMs](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview) is a service that provides full versions of SQL Server in the cloud without having to manage any on-premises hardware. In this architecture, SQL Server on VMs forms the data tier with Always On availability groups distributed across availability zones in a [multi-subnet configuration](/azure/azure-sql/virtual-machines/windows/availability-group-manually-configure-prerequisites-tutorial-multi-subnet).

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a secure private network in the cloud. It connects VMs to one another, to the internet, and to cross-premises networks. In this architecture, Virtual Network provides network isolation and connectivity for all components. Global virtual network peering enables low-latency communication between regions.

- [UDRs](/azure/virtual-network/virtual-networks-udr-overview) are a mechanism to override the default routing in virtual networks. In this architecture, they force inbound and outbound traffic flows to traverse Azure Firewall for security inspection and policy enforcement.

## Solution details

*Traffic Manager -* We configured Traffic Manager to use performance routing. It routes traffic to the endpoint that has the lowest latency for the user. Traffic Manager automatically adjusts its load balancing algorithm as endpoint latency changes. Traffic manager provides automatic failover if there's a regional outage. It uses priority routing and regular health checks to determine where to route traffic.

*Availability Zones -* The architecture uses three availability zones. The zones provide resiliency for the Application Gateways, internal load balancers, and virtual machines within each region. If there's a zone outage, the remaining availability zones in that region take over the load without triggering a regional failover.

*Application Gateway -* While Traffic Manager provides DNS-based global load balancing, Application Gateway gives you many of the same capabilities as Azure Front Door but at the regional level such as:

- Web Application Firewall (WAF)
- Transport Layer Security (TLS) termination
- Path-based routing
- Cookie-based session affinity

*Azure Firewall -* Azure Firewall Premium offers network security for generic applications (web and non-web traffic), inspecting three types of flows in this architecture:

- Inbound HTTP(S) flows from the Application Gateway are protected with Azure Firewall Premium TLS inspection.
- Inbound non-HTTP(S) flows from the public Internet are inspected with the rest of [Azure Firewall Premium features](/azure/firewall/premium-features). Application Gateway also supports [Layer 4 (TCP/TLS) proxying](/azure/application-gateway/tcp-tls-proxy-overview), which could consolidate both HTTP and non-HTTP ingress onto a single entry point. However, this capability is in preview and WAF does not apply to Layer 4 traffic, so this architecture uses a separate path for non-HTTP(S) flows.
- Outbound flows from Azure Virtual Machines are inspected by Azure Firewall to prevent data exfiltration and access to forbidden sites and applications.

*Virtual Machine Scale Sets -* This architecture uses Flexible orchestration for all three application tiers. The data tier's multi-subnet SQL Server availability group requires placing individual VMs into specific subnets and fault domains, which only Flexible orchestration supports. The web and business tiers use Flexible orchestration as well to maintain a single operational model across the workload rather than mixing orchestration modes across tiers.

*Virtual network peering -* We call peering between regions "global virtual network peering." Global virtual network peering provides low-latency, high-bandwidth data replication between regions. You can transfer data across Azure subscriptions, Microsoft Entra tenants, and deployment models with this global peering. In hub-spoke environment virtual network peerings would exist between hub and spoke networks.

## Alternatives

This architecture makes specific technology choices to support mixed-protocol, multi-region workloads. Your workload's requirements might lead to different choices. Consider the following alternatives.

### Global load balancer

**Current approach:** Traffic Manager provides DNS-based global load balancing that supports both HTTP(S) and non-HTTP(S) protocols. This architecture uses Traffic Manager because it must route non-HTTP(S) flows, such as SFTP and legacy TCP integrations, through Azure Firewall for network-level inspection.

**Alternative approach:** Use [Azure Front Door](/azure/frontdoor/front-door-overview) instead of Traffic Manager. Front Door is a layer-7 global load balancer purpose-built for HTTP(S) traffic that provides caching, traffic acceleration, TLS termination, certificate management, and built-in WAF. It is the preferred global routing solution for HTTP(S)-only workloads.

Consider Front Door if your workload meets the following conditions:

- All inbound traffic uses HTTP(S) protocols.
- You don't require Azure Firewall for deep packet inspection of inbound traffic.
- You want integrated WAF and CDN capabilities at the global edge.

### Compute platform

**Current approach:** The web, business, and data tiers run on Virtual Machine Scale Sets with SQL Server on Azure Virtual Machines. This IaaS approach provides full control over the operating system, middleware, and database engine configuration.

**Alternative approach:** Replace specific tiers with platform as a service (PaaS) resources such as [Azure App Service](/azure/app-service/overview) for the web tier or [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview) for the data tier. The overall network architecture does not change significantly if you use [Azure Private Link](/azure/private-link/private-link-overview) and [App Service virtual network integration](/azure/app-service/overview-vnet-integration) to bring those PaaS services into the virtual network.

Consider PaaS alternatives if your workload meets the following conditions:

- You don't require direct OS-level or middleware configuration control.
- You want to reduce operational overhead for patching, scaling, and availability management.
- Your database workload is compatible with Azure SQL Database feature set and limits.

### Load-balancing service combination

**Current approach:** This architecture uses Traffic Manager (global, DNS-based), Application Gateway (regional, layer 7), and Azure Load Balancer (regional, layer 4) to address global routing, WAF inspection, and internal tier-to-tier distribution respectively.

**Alternative approach:** Your workload's protocol, latency, and security requirements might lead to a different combination of load-balancing services. For example, workloads that don't need WAF can use Azure Load Balancer alone for regional distribution, and workloads that need path-based routing without a firewall can use Application Gateway without Azure Firewall in front of it.

To evaluate which services fit your scenario, see [Load-balancing options in Azure](/azure/architecture/guide/technology-choices/load-balancing-overview).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

*Regions -* Deploy to at least two Azure regions for recoverability. An active/passive or active/active multi-region configuration enables your workload to recover from a regional outage. Traffic Manager monitors endpoint health and redirects DNS responses away from unhealthy regions, but you are responsible for ensuring the secondary region is ready to serve traffic, including data replication and application readiness.

For your secondary region, prefer a [paired region](/azure/reliability/cross-region-replication-azure) when one is available for benefits like prioritized recovery sequencing and staggered platform updates. If your region doesn't have a pair, you can still build a multi-region solution, but some services like [geo-redundant storage](/azure/storage/common/storage-redundancy#geo-redundant-storage) require alternative replication approaches. Also factor in geographic distance, data residency, service availability, and cost. For more information, see [Select Azure regions](/azure/cloud-adoption-framework/ready/azure-setup-guide/regions).

*Availability zones -* This architecture deploys Application Gateway, Azure Firewall, Azure Load Balancer, and Virtual Machine Scale Sets across multiple [availability zones](/azure/reliability/availability-zones-overview) within each region to provide resiliency against datacenter-level failures.

*Virtual Machine Scale Sets -* Flexible orchestration distributes VM instances across fault domains within each availability zone, which reduces the blast radius of a single host failure. It also provides the per-VM placement control that the [multi-subnet SQL Server availability group](/azure/azure-sql/virtual-machines/windows/hadr-cluster-best-practices) configuration requires.

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
- Enable [connection draining](/azure/application-gateway/features#connection-draining) so that in-flight requests complete before backend instances are removed. Without it, scale-in events and configuration updates cause transient request failures.

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

*Multi-region baseline cost -* This architecture deploys a full infrastructure stamp in each region: Virtual Machine Scale Sets across three tiers, Application Gateway, Azure Firewall Premium, and load balancers. The secondary region incurs cost whether or not it is actively serving traffic. In an active/passive configuration, reduce cost by scaling the secondary region's VMSS instances to the minimum required for a timely failover, rather than running at full production capacity.

*Virtual machines -* VMs are the largest cost driver because every tier in both regions runs compute continuously. Use [Azure Reserved VM Instances](/azure/virtual-machines/prepay-reserved-vm-instances) or [Azure savings plans for compute](/azure/cost-management-billing/savings-plan/savings-plan-compute-overview). Reserved instances work well for the minimum always-on capacity, while savings plans offer flexibility if VM sizes change over time.

*Azure Firewall Premium -* Firewall Premium has a fixed per-deployment-unit hourly charge plus variable per-gigabyte processing fees, and it runs in both regions. If your workload does not require IDPS or TLS inspection, evaluate whether [Azure Firewall Standard](/azure/firewall/choose-firewall-sku) meets your security requirements at a lower price point.

*DDoS Network Protection and WAF discount -* [DDoS Network Protection](/azure/ddos-protection/ddos-protection-overview) has a fixed monthly cost that covers up to 100 public IP addresses across subscriptions in a tenant. When DDoS Network Protection is enabled, Application Gateway WAF instances are [billed at the lower Standard rate](/azure/application-gateway/understanding-pricing) instead of the WAF rate. For architectures with multiple Application Gateway instances like this one, the WAF discount can offset a meaningful portion of the DDoS plan cost.

*Application Gateway scaling -* Application Gateway charges a fixed hourly rate plus variable [capacity unit](/azure/application-gateway/understanding-pricing#capacity-unit) costs. Setting the autoscale minimum instance count higher than necessary reserves capacity units you pay for regardless of traffic. Balance the minimum instance count against acceptable cold-start latency to avoid paying for unused capacity.

For service-specific pricing details, see:

- [Virtual Machines pricing](https://azure.microsoft.com/pricing/details/virtual-machines/)
- [Application Gateway pricing](https://azure.microsoft.com/pricing/details/application-gateway/)
- [Azure Firewall pricing](https://azure.microsoft.com/pricing/details/azure-firewall/)
- [Azure DDoS Protection pricing](https://azure.microsoft.com/pricing/details/ddos-protection/)
- [Traffic Manager pricing](https://azure.microsoft.com/pricing/details/traffic-manager/)

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

*Infrastructure as code -* This architecture has a large resource surface area: Traffic Manager, two regional stamps each with Application Gateway, Azure Firewall, load balancers, Virtual Machine Scale Sets, NSGs, VNets, and subnets. Define all resources in [Bicep](/azure/azure-resource-manager/bicep/overview) or [Terraform](/azure/developer/terraform/overview) to ensure both regional stamps stay consistent and to enable repeatable deployments.

*Deployment coordination -* With two active regional stamps, deploy updates to the secondary region first and validate before promoting to the primary. Use [safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments) with progressive exposure to limit blast radius. Traffic Manager's DNS weighting can support canary traffic shifting between regions during rollouts.

*Monitoring -* Deploy a [Log Analytics workspace](/azure/azure-monitor/logs/workspace-design) in each region so that monitoring remains functional even during a regional outage. Use [cross-workspace queries](/azure/azure-monitor/logs/cross-workspace-query) and [Azure Monitor workbooks](/azure/azure-monitor/visualize/workbooks-overview) to correlate signals across both regions into a unified operational view. Build a [health model](/azure/well-architected/operational-excellence/observability) that combines Traffic Manager endpoint probes, Application Gateway backend health, Firewall logs, and VM-level metrics into a composite health status.

*Configuration drift -* Operating two identical regional stamps creates ongoing risk of configuration drift. Use [Azure Policy](/azure/governance/policy/overview) to enforce guardrails, such as requiring NSG rules, Firewall policy versions, or Application Gateway WAF rule sets to be consistent across regions.

*Resource groups -* Use [resource groups](/azure/azure-resource-manager/management/overview) to manage Azure resources by lifetime, owner, and other characteristics.

*Virtual network peering -* Use [virtual network peering](/azure/virtual-network/virtual-network-peering-overview) to connect two or more virtual networks in Azure. The virtual networks appear as one for connectivity purposes. The traffic between virtual machines in peered virtual networks uses the Microsoft backbone infrastructure. Make sure that the address space of the virtual networks doesn't overlap.

*Operational overhead -* This IaaS architecture requires you to manage middleware configuration, certificate rotation, firewall rule tuning, and SQL Server availability group health across both regions. Flexible orchestration supports [automatic guest patching](/azure/virtual-machines/automatic-vm-guest-patching) for critical and security patches, but does not support automatic OS image upgrades. Use [Azure Update Manager](/azure/update-manager/overview) or your deployment pipeline for those. This ongoing operational burden is the primary tradeoff for the control and flexibility that IaaS provides. If your team lacks the need for this level of management, evaluate the PaaS alternatives described in the [Alternatives](#compute-platform) section.

### Performance Efficiency

Performance Efficiency is the ability of your workload to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

*Virtual Machine Scale Sets -* Deploy a separate [Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview) instance with [Flexible orchestration](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-orchestration-modes#scale-sets-with-flexible-orchestration) for each application tier (web, business, and data). Separate scale sets let you scale each tier independently based on its own demand profile. Configure [autoscaling policies](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview) on the web and business tiers to scale out during demand increases and scale in during off-peak periods.

*Double inspection latency -* The HTTP(S) flow in this architecture passes traffic through both Application Gateway's WAF and Azure Firewall Premium's TLS inspection. This layered defense adds latency to each request. Test your application's performance under realistic load to confirm that the additional inspection time meets your response-time requirements.

*Azure Firewall throughput -* Enabling IDPS in Alert and Deny mode significantly reduces Azure Firewall's maximum throughput compared to other modes. If your workload requires both IDPS deny-mode and high throughput, plan your capacity accordingly and monitor firewall throughput metrics. For more information, see [Azure Firewall performance](/azure/firewall/firewall-performance).

*Application Gateway capacity -* WAF rule processing and TLS operations consume compute units and reduce per-instance throughput. Monitor the [capacity unit and compute unit metrics](/azure/application-gateway/understanding-pricing#capacity-unit) to verify that autoscaling keeps pace with demand.

*Read-only routing -* The Always On availability group secondaries in this architecture can serve read-only queries, such as reporting or analytics workloads. Configure [read-only routing](/sql/database-engine/availability-groups/windows/configure-read-only-routing-for-an-availability-group-sql-server) to offload read traffic from the primary replica and turn the HA investment into a performance benefit.

## Next steps

For more reference architectures using the same technologies, see:

- [AKS baseline for multi-region clusters](../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml)

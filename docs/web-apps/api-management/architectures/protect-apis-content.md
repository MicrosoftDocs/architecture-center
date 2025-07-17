Organizations increasingly adopt API-first design approaches while facing growing threats to web applications. You need a comprehensive security strategy to protect APIs, especially when exposing AI-powered APIs and implementing zero trust architecture principles. The [Gateway Routing pattern](../../../patterns/gateway-routing.yml) provides one approach to API security by protecting network traffic. The gateway restricts traffic source locations and traffic quality while supporting flexible routing rules. This article describes how to use Azure Application Gateway and Azure API Management to protect API access.

## Architecture

This article doesn't address the application's underlying platforms, such as App Service Environment, Azure SQL Managed Instance, and Azure Kubernetes Service. Those parts of the diagram showcase what you can implement as a broader solution. This article specifically discusses the shaded areas, API Management and Application Gateway.

:::image type="complex" source="../_images/protect-apis.png" alt-text="Diagram showing how Application Gateway and API Management protect APIs." lightbox="../_images/protect-apis.png":::
The diagram shows the Microsoft Azure architecture for protecting APIs using Application Gateway and API Management. On the left, external clients connect through the Internet to Application Gateway in the ag-subnet, which includes a Web Application Firewall. Application Gateway routes traffic to API Management in the apim-subnet above it. API Management connects to two backend services to the right: App Service Environment in ase-subnet and Kubernetes Service in aks-subnet. Internal clients at the bottom left connect directly through the virtual network. The architecture shows URL patterns for external and internal API access, with a dead end sinkpool for unauthorized requests. DDoS Protection shields the entire Azure environment, indicated by a security badge in the bottom right corner.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/protect-apis.vsdx) of this architecture.*

### Workflow

1. The Application Gateway receives HTTPS requests that the subnet's Network Security Group (NSG) allows.

1. The Web Application Firewall (WAF) on Application Gateway checks the request against WAF rules, including [Geomatch custom rules](/azure/web-application-firewall/geomatch-custom-rules-examples). If the request is valid, the request proceeds.

1. Application Gateway sets up a URL proxy mechanism that sends the request to the proper [backend pool](/azure/application-gateway/application-gateway-components#backend-pools). For example, depending on the URL format of the API call:

   - URLs formatted like `api.<some-domain>/external/*` can reach the backend to interact with the requested APIs.
   - Calls formatted as `api.<some-domain>/*` go to a dead end (sinkpool), which is a backend pool with no target.
   - A routing rule at the Application Gateway level redirects users under `portal.<some-domain>/*` to the developer portal. Developers can manage APIs and their configurations from both internal and external environments. Alternatively, you can block the developer portal completely.

1. Application Gateway accepts and proxies internal calls from resources in the same Azure virtual network under `api.<some-domain>/internal/*`.

1. At the API Management level, APIs accept calls under the following patterns:

   - `api.<some-domain>/external/*`
   - `api.<some-domain>/internal/*`

   In this scenario, API Management uses two types of IP addresses, public and private. Public IP addresses are for management operations on port 3443 for the management plane and for runtime API traffic in external virtual network configuration. When API Management sends a request to a public internet-facing back end, it shows a public IP address as the origin of the request. For more information, see [IP addresses of API Management service in VNet](/azure/api-management/api-management-howto-ip-addresses#ip-addresses-of-api-management-in-a-virtual-network).

### Components

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) enables many types of Azure resources to communicate privately with each other, the internet, and on-premises networks. In this architecture, the Application Gateway tunnels public internet traffic into this private network.

- [Azure Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a web traffic load balancer that manages traffic to web applications. This type of routing is known as application layer (OSI layer 7) load balancing. In this architecture, the gateway provides routing and hosts a Web Application Firewall (WAF) to protect against common web-based attack vectors.

- [Azure API Management](/azure/well-architected/service-guides/api-management/reliability) is a hybrid, multicloud management platform for APIs across all environments. API Management creates consistent, modern API gateways for existing backend services. In this architecture, API Management operates in a fully private mode to offload cross-cutting concerns from the API code and hosts.

## Recommendations

This solution focuses on implementing the whole solution and testing API access from inside and outside the API Management virtual network. For more information about the API Management virtual network integration process, see [Deploy API Management in an internal virtual network with Application Gateway](/azure/api-management/api-management-howto-integrate-internal-vnet-appgateway).

To communicate with private resources in the back end, Application Gateway and API Management must be in the same virtual network as the resources or in a peered virtual network.

- The private, internal deployment model allows API Management to connect to an existing virtual network, making it reachable from inside that network context. To enable this feature, deploy either the **Developer** or **Premium** API Management tiers for classic virtual network injection. For newer virtual network options, use **Standard v2** or **Premium v2** tiers with virtual network integration or injection capabilities.

- If your clients exist in a different subscription or are managed with a different Entra ID directory, use [Application Gateway Private Link](/azure/application-gateway/private-link) to provide private connectivity to the Application Gateway from client virtual networks across subscriptions and regions.

- Manage Application Gateway certificates in [Azure Key Vault](/azure/key-vault/general/basic-concepts).

- To personalize interactions with the services, you can use [CNAME entries](/azure/dns/dns-web-sites-custom-domain).

## Alternatives

You can use other services to deliver a similar level of firewall and Web Application Firewall (WAF) protection:

- [Azure Front Door](/azure/frontdoor/front-door-overview) with built-in DDoS protection and global load balancing
- [Azure Firewall](/azure/firewall/overview) for network-level protection and centralized security policy management
- Partner solutions such as [Barracuda Web Application Firewall](https://azuremarketplace.microsoft.com/marketplace/apps/barracudanetworks.waf) or other web application firewall solutions available in [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/category/security?page=1&subcategories=threat-protection)

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Azure Application Gateway is always deployed in a highly available fashion, regardless of the instance count. To avoid the impact of a zone malfunction, you can configure the Application Gateway to span multiple Availability Zones. For more information, see [Autoscaling and High Availability](/azure/application-gateway/application-gateway-autoscaling-zone-redundant#autoscaling-and-high-availability).

Enable zone redundancy for your API Management service components to provide resiliency and high availability. Zone redundancy replicates the API Management gateway and control plane across datacenters in physically separated zones, making them resilient to zone failure. The API Management **Premium** tier is required to support [Availability zones](/azure/api-management/high-availability#availability-zones).

API Management also supports multi-region deployments, which can improve availability if one region goes offline. For more information, see [Multi-region deployment](/azure/api-management/high-availability#multi-region-deployment). In this topology, it's important to also have one Application Gateway per region, since Application Gateway is a regional service.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

For more information about Application Gateway security, see [Azure security baseline for Application Gateway](/security/benchmark/azure/baselines/application-gateway-security-baseline).

For more information about API Management security, see [Azure security baseline for API Management](/security/benchmark/azure/baselines/api-management-security-baseline).

Always implement these security measures:

- Use [Azure Web Application Firewall (WAF)](/azure/web-application-firewall/overview) policies with the latest OWASP Core Rule Set (CRS) 3.2 or newer to protect against common web vulnerabilities, including OWASP Top 10 threats.

- Configure [WAF geomatch custom rules](/azure/web-application-firewall/geomatch-custom-rules-examples) to block or allow traffic based on geographic location. This approach provides some protection against distributed denial-of-service (DDoS) attacks.

- Enable [Application (Layer 7) DDoS protection](/azure/web-application-firewall/shared/application-ddos-protection#azure-waf-with-azure-application-gateway) using Azure WAF with Application Gateway to protect against volumetric and protocol-based attacks. [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview), combined with application-design practices, provides enhanced DDoS mitigation features to provide more defense against DDoS attacks.

- Use [private endpoints](/azure/api-management/private-endpoint) for API Management to provide secure inbound connectivity.

- Enable [Microsoft Defender for APIs](/defender-for-cloud/defender-for-apis-introduction) to monitor API security posture and detect threats.

- Configure [WAF bot protection rules](/azure/web-application-firewall/ag/bot-protection) to identify and block malicious bots.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The cost of this architecture depends on configuration aspects such as:

- Service tiers. Consider Standard v2 and Premium v2 tiers for API Management, which offer improved cost-efficiency and performance.
- Scalability, meaning the number of instances dynamically allocated by services to support a given demand
- Whether this architecture runs continuously or just a few hours a month
- Data transfer costs between regions if using multi-region deployments
- WAF processing costs based on the number of requests and rules evaluated

Consider these cost optimization strategies:

- Use the [API Management consumption tier](/azure/api-management/api-management-features) for low usage, variable workloads where you pay only for actual usage.
- Implement [Application Gateway autoscaling](/azure/application-gateway/application-gateway-autoscaling-zone-redundant) to optimize instance counts based on demand.

After you assess these aspects, use the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/) to estimate pricing.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Implement comprehensive monitoring and observability:

- Configure [API Management logging](/azure/api-management/api-management-howto-use-azure-monitor) to Azure Monitor Logs for detailed API analytics
- Set up [Application Gateway diagnostics](/azure/application-gateway/application-gateway-diagnostics) to monitor WAF events and performance metrics
- Implement [API Management alerts](/azure/api-management/api-management-howto-use-azure-monitor#set-up-an-alert-rule) for API performance and availability thresholds

### Performance Efficiency

Performance Efficiency is the ability of your workload to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Application Gateway is the entry point for this architecture, and the WAF feature requires processing power for each request analysis. To allow Application Gateway to expand its computational capacity on demand, enable autoscaling. For more information, see [Autoscaling and zone redundancy in Application Gateway](/azure/application-gateway/application-gateway-autoscaling-zone-redundant). Follow the product documentation recommendations for [Application Gateway infrastructure configuration](/azure/application-gateway/configuration-infrastructure), including proper subnet sizing. This approach ensures the subnet is large enough to support full scale-out.

For API Management, consider these performance optimizations:

- Enable [API Management autoscaling](/azure/api-management/api-management-howto-autoscale) to automatically respond to increasing request volumes.
- Use [API Management caching policies](/azure/api-management/api-management-howto-cache) to reduce backend load and improve response times.
- Implement [API Management rate limiting](/azure/api-management/api-management-access-restriction-policies) to protect backend services from excessive load.
- Use [Standard v2 or Premium v2 tiers](/azure/api-management/v2-service-tiers-overview) for improved performance and networking capabilities.

## Next steps

Design your APIs following good [Web API design](../../../best-practices/api-design.md) guidelines and implement them using good [Web API implementation](../../../best-practices/api-implementation.md) practices.

## Related resources

- [Gateway Routing pattern](../../../patterns/gateway-routing.yml) - Route requests to multiple services using a single endpoint
- [Gateway Aggregation pattern](../../../patterns/gateway-aggregation.yml) - Aggregate multiple requests into a single request
- [Gateway Offloading pattern](../../../patterns/gateway-offloading.yml) - Offload shared functionality to an API gateway
- [URL path-based routing overview](/azure/application-gateway/url-route-overview)
- [Tutorial: Create an application gateway with URL path-based redirection using the Azure CLI](/azure/application-gateway/tutorial-url-redirect-cli)

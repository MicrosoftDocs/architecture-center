With more workloads adhering to the [API-first approach](https://swagger.io/resources/articles/adopting-an-api-first-approach/) for their design, and the growing number and severity of threats to web applications over the internet, it's critical to have a comprehensive security strategy to protect APIs. This is especially important as organizations increasingly expose AI-powered APIs and adopt zero trust architecture principles. One step toward API security is protecting the network traffic by using the [Gateway Routing pattern](../../../patterns/gateway-routing.yml). You use the gateway to restrict traffic source locations and traffic quality in addition to supporting flexible routing rules. This article describes how to use Azure Application Gateway and Azure API Management to protect API access.

## Architecture

This article doesn't address the application's underlying platforms, like App Service Environment, Azure SQL Managed Instance, and Azure Kubernetes Services. Those parts of the diagram only showcase what you can do as a broader solution. This article specifically discusses the shaded areas, API Management and Application Gateway.

![Diagram showing how Application Gateway and API Management protect APIs.](../_images/protect-apis.png)

*Download a [Visio file](https://arch-center.azureedge.net/protect-apis.vsdx) of this architecture.*

### Workflow

- The Application Gateway receives HTTP requests that have been allowed by its subnet's Network Security Group (NSG).

- The Web Application Firewall (WAF) on Application Gateway then checks the request against WAF rules, including [Geomatch custom rules](/azure/web-application-firewall/geomatch-custom-rules-examples). If the request is valid, the request proceeds.

- Application Gateway sets up a URL proxy mechanism that sends the request to the proper [backend pool](/azure/application-gateway/application-gateway-components#backend-pools). For example, depending on the URL format of the API call:

  - URLs formatted like `api.<some-domain>/external/*` can reach the back end to interact with the requested APIs.

  - Calls formatted as `api.<some-domain>/*` go to a dead end (sinkpool), which is a back-end pool with no target.

- Also, Application Gateway accepts and proxies internal calls, which come from resources in the same Azure virtual network, under `api.<some-domain>/internal/*`.

- Finally, at the API Management level, APIs are set up to accept calls under the following patterns:

  - `api.<some-domain>/external/*`
  - `api.<some-domain>/internal/*`

  In this scenario, API Management uses two types of IP addresses, public and private. Public IP addresses are for management operations on port 3443 for the management plane, and for runtime API traffic in external virtual network configuration. When API Management sends a request to a public internet-facing back end, it shows a public IP address as the origin of the request. For more information, see [IP addresses of API Management service in VNet](/azure/api-management/api-management-howto-ip-addresses#ip-addresses-of-api-management-in-a-virtual-network).

- A routing rule at the Application Gateway level properly redirects users under `portal.<some-domain>/*` to the developer portal, so that developers can manage APIs and their configurations from both internal and external environments. Alternatively, the developer portal can be fully blocked.

### Components

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) enables many types of Azure resources to privately communicate with each other, the internet, and on-premises networks. In this architecture, the Application Gateway is responsible for tunneling public Internet traffic into this private network.

- [Azure Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a web traffic load balancer that manages traffic to web applications. This type of routing is known as application layer (OSI layer 7) load balancing. In this architecture, not only is the gateway used for routing, the gateway also hosts a Web Application Firewall (WAF) to protect against common web-based attack vectors.

- [Azure API Management](/azure/well-architected/service-guides/api-management/reliability) is a hybrid, multicloud management platform for APIs across all environments. API Management creates consistent, modern API gateways for existing backend services. In this architecture, API Management is used in a fully private mode to offload cross-cutting concerns from the API code and hosts.

## Recommendations

This solution focuses on implementing the whole solution, and testing API access from inside and outside the API Management virtual network. For more information about the API Management virtual network integration process, see [Deploy API Management in an internal virtual network with Application Gateway](/azure/api-management/api-management-howto-integrate-internal-vnet-appgateway).

To communicate with private resources in the back end, Application Gateway and API Management must be in the same virtual network as the resources or in a peered virtual network.

- The private, internal deployment model allows API Management to connect to an existing virtual network, making it reachable from the inside of that network context. To enable this feature, deploy either the **Developer** or **Premium** API Management tiers for classic virtual network injection. For newer virtual network options, use **Standard v2** or **Premium v2** tiers with virtual network integration or injection capabilities.

- If your clients exists in a different subscription or managed with a different Entra ID directory, use [Application Gateway Private Link](/azure/application-gateway/private-link) to provide private connectivity to the Application Gateway from client virtual networks across subscriptions and regions.

- Manage App Gateway certificates in [Azure Key Vault](/azure/key-vault/general/basic-concepts).

- To personalize interactions with the services, you can use [CNAME entries](/azure/dns/dns-web-sites-custom-domain).

## Alternatives

You can use other services to deliver a similar level of firewall and Web Application Firewall (WAF) protection:

- [Azure Front Door](/azure/frontdoor/front-door-overview) with built-in DDoS protection and global load balancing
- [Azure Firewall](/azure/firewall/overview) for network-level protection and centralized security policy management
- Partner solutions like [Barracuda Web Application Firewall](https://azuremarketplace.microsoft.com/marketplace/apps/barracudanetworks.waf) or other web application firewall solutions available in [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/category/security?page=1&subcategories=threat-protection).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Azure Application Gateway is always deployed in a highly available fashion, no matter the instance count. To avoid the impact of a zone malfunction, you can configure the Application Gateway to span multiple Availability Zones. For more information, see [Autoscaling and High Availability](/azure/application-gateway/application-gateway-autoscaling-zone-redundant#autoscaling-and-high-availability).

Enable zone redundancy for your API Management service components to provide resiliency and high availability. Zone redundancy replicates the API Management gateway and control plane across datacenters in physically separated zones, making them resilient to zone failure. The API Management **Premium** tier is required to support [Availability zones](/azure/api-management/high-availability#availability-zones).

API Management also supports multi-region deployments, which can improve availability if one region goes offline. For more information, see [Multi-region deployment](/azure/api-management/high-availability#multi-region-deployment). In this topology, it's important to also have one Application Gateway per region, since Application Gateway is a regional service.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

For more information about Application Gateway security, see [Azure security baseline for Application Gateway](/security/benchmark/azure/baselines/application-gateway-security-baseline).

For more information about API Management security, see [Azure security baseline for API Management](/security/benchmark/azure/baselines/api-management-security-baseline).

Always implement these additional security measures:

- Use [Azure Web Application Firewall (WAF)](/azure/web-application-firewall/overview) policies with the latest OWASP Core Rule Set (CRS) 3.2 or newer to protect against common web vulnerabilities including OWASP Top 10 threats.

- Configure [WAF geomatch custom rules](/azure/web-application-firewall/geomatch-custom-rules-examples) to block or allow traffic based on geographic location, which is particularly effective against distributed denial-of-service (DDoS) attacks.

- Enable [Application (Layer 7) DDoS protection](/azure/web-application-firewall/shared/application-ddos-protection#azure-waf-with-azure-application-gateway) using Azure WAF with Application Gateway to protect against volumetric and protocol-based attacks. [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview), combined with application-design best practices, provides enhanced DDoS mitigation features to provide more defense against DDoS attacks.

- Use [private endpoints](/azure/api-management/private-endpoint) for API Management to provide secure inbound connectivity.

- Enable [Microsoft Defender for APIs](/defender-for-cloud/defender-for-apis-introduction) to monitor API security posture and detect threats.

- Configure [WAF bot protection rules](/azure/web-application-firewall/ag/bot-protection) to identify and block malicious bots.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The cost of this architecture depends on configuration aspects like:

- Service tiers. Specifically, consider Standard v2 and Premium v2 tiers for API Management, which offer improved cost-efficiency and performance.
- Scalability, meaning the number of instances dynamically allocated by services to support a given demand
- Whether this architecture will run continuously or just a few hours a month
- Data transfer costs between regions if using multi-region deployments
- WAF processing costs based on the number of requests and rules evaluated

Consider these cost optimization strategies:

- Use [API Management consumption tier](/azure/api-management/api-management-features) for low usage, variable workloads where you only pay for actual usage.
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

Application Gateway is the entry point for this architecture, and the WAF feature requires additional processing power for each request analysis. To allow Application Gateway to expand its computational capacity on demand, enable autoscaling. For more information, see [Autoscaling and zone redundancy in Application Gateway](/azure/application-gateway/application-gateway-autoscaling-zone-redundant). Follow the product documentation recommendations for [Application Gateway infrastructure configuration](/azure/application-gateway/configuration-infrastructure) including proper subnet sizing. This ensures the subnet is large enough to support full scale-out.

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

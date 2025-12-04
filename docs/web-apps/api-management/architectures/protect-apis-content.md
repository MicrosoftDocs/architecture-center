Organizations increasingly adopt API-first design approaches while facing growing threats to web applications. You need a comprehensive security strategy to protect APIs, especially when exposing AI-powered APIs and implementing zero trust architecture principles. The [Gateway Routing pattern](../../../patterns/gateway-routing.yml) provides one approach to API security by protecting network traffic. The gateway restricts traffic source locations and traffic quality while supporting flexible routing rules. This article describes how to use Azure Application Gateway and Azure API Management to protect API access.

## Architecture

This article doesn't address the application's underlying platforms, such as App Service Environment, Azure SQL Managed Instance, and Azure Kubernetes Service (AKS). Those parts of the diagram showcase what you can implement as a broader solution. This article specifically discusses the shaded areas, API Management, and Application Gateway.

:::image type="complex" source="../_images/protect-apis.svg" alt-text="Diagram that shows how Application Gateway and API Management protect APIs." lightbox="../_images/protect-apis.svg" border="false":::
The diagram shows the Microsoft Azure architecture that protects APIs by using Application Gateway and API Management. External clients connect through the internet to Application Gateway in the ag-subnet, which includes a web application firewall (WAF). Application Gateway routes traffic to API Management in the apim-subnet. API Management connects to two back-end services: App Service Environment in ase-subnet and Azure Kubernetes Service (AKS) in the aks-subnet. Internal clients connect directly through the virtual network. The architecture shows URL patterns for external and internal API access, with a dead end, or sinkpool, for unauthorized requests. Azure DDoS Protection shields the entire Azure environment, indicated by a security badge on the edge of the virtual network.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/protect-apis.vsdx) of this architecture.*

### Workflow

1. Application Gateway receives HTTPS requests that the subnet's network security group (NSG) allows.

1. The web application firewall (WAF) on Application Gateway checks the request against WAF rules, including [geomatch custom rules](/azure/web-application-firewall/geomatch-custom-rules-examples). If the request is valid, the request proceeds.

1. Application Gateway sets up a URL proxy mechanism that sends the request to the proper [back-end pool](/azure/application-gateway/application-gateway-components#backend-pools). The routing behavior depends on the URL format of the API call:

   - URLs formatted as `api.<some-domain>/external/*` can reach the back end to interact with the requested APIs.

   - Calls formatted as `api.<some-domain>/*` go to a dead end, called a *sinkpool*, which is a back-end pool with no target.
   - A routing rule at the Application Gateway level redirects users under `portal.<some-domain>/*` to the developer portal. Developers can manage APIs and their configurations from both internal and external environments. Alternatively, you can block the developer portal completely.

1. Application Gateway accepts and proxies internal calls from resources in the same Azure virtual network under `api.<some-domain>/internal/*`.

1. At the API Management level, APIs accept calls under the following patterns:

   - `api.<some-domain>/external/*`
   - `api.<some-domain>/internal/*`

   In this scenario, API Management uses public and private IP addresses. Public IP addresses support management operations on port 3443 for the management plane and for runtime API traffic in external virtual network configurations. When API Management sends a request to a public internet-facing back end, it shows a public IP address as the origin of the request. For more information, see [IP addresses of API Management in a virtual network](/azure/api-management/api-management-howto-ip-addresses#ip-addresses-of-api-management-in-a-virtual-network).

### Components

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) enables many types of Azure resources to communicate privately with each other, the internet, and on-premises networks. In this architecture, Application Gateway tunnels public internet traffic into this private network.

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a web traffic load balancer that manages traffic to web applications. This type of routing is known as *application layer (OSI Layer 7) load balancing*. In this architecture, the gateway provides routing and hosts a WAF to protect against common web-based attack vectors.

- [API Management](/azure/well-architected/service-guides/api-management/reliability) is a hybrid, multicloud management platform for APIs across all environments. API Management creates consistent, modern API gateways for existing back-end services. In this architecture, API Management operates in a fully private mode to offload cross-cutting concerns from the API code and hosts.

### Alternatives

You can use other services to deliver a similar level of firewall and WAF protection:

- [Azure Front Door](/azure/frontdoor/front-door-overview) provides built-in distributed denial-of-service (DDoS) protection and global load balancing.

- [Azure Firewall](/azure/firewall/overview) provides network-level protection and centralized security policy management.
- Partner solutions, such as [Barracuda WAF](https://azuremarketplace.microsoft.com/marketplace/apps/barracudanetworks.waf), or other WAF solutions are available in [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/category/security?page=1&subcategories=threat-protection).

## Recommendations

This architecture focuses on implementing the whole solution and testing API access from inside and outside the API Management virtual network. For more information about the integration process, see [Integrate API Management in an internal virtual network by using Application Gateway](/azure/api-management/api-management-howto-integrate-internal-vnet-appgateway).

To communicate with private resources in the back end, place Application Gateway and API Management in the same virtual network as the resources or in a peered virtual network.

- The private, internal deployment model allows API Management to connect to an existing virtual network, which makes it reachable from inside that network context. To enable this feature, deploy either the **Developer** or **Premium** API Management tiers for classic virtual network injection. For newer virtual network options, use the **Standard v2** or **Premium v2** tiers with virtual network integration or injection capabilities.

- If your clients operate in a different subscription or are managed with a different Microsoft Entra ID directory, use [Azure Private Link for Application Gateway](/azure/application-gateway/private-link) to provide private connectivity to Application Gateway from client virtual networks across subscriptions and regions.

- Manage Application Gateway certificates in [Azure Key Vault](/azure/key-vault/general/basic-concepts).

- To personalize interactions with the services, you can use [canonical name (CNAME) entries](/azure/dns/dns-web-sites-custom-domain).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Application Gateway always deploys in a highly available configuration, regardless of the instance count. To reduce the impact of a zone malfunction, you can configure the application gateway to span multiple availability zones. For more information, see [Autoscaling and high availability](/azure/application-gateway/application-gateway-autoscaling-zone-redundant#autoscaling-and-high-availability).

Enable zone redundancy for your API Management service components to provide resiliency and high availability. Zone redundancy replicates the API Management gateway and control plane across datacenters in physically separated zones. This configuration makes them resilient to zone failure. You must use the API Management **Premium** tier to support [availability zones](/azure/reliability/reliability-api-management#availability-zone-support).

API Management also supports multiregion deployments, which can improve availability if one region goes offline. For more information, see [Multiregion support](/azure/reliability/reliability-api-management#multi-region-support). In this topology, deploy one application gateway for each region because Application Gateway is a regional service.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

For more information about Application Gateway security, see [Azure security baseline for Application Gateway](/security/benchmark/azure/baselines/application-gateway-security-baseline).

For more information about API Management security, see [Azure security baseline for API Management](/security/benchmark/azure/baselines/api-management-security-baseline).

Always implement the following security measures:

- Use [Azure Web Application Firewall](/azure/web-application-firewall/overview) policies with the latest Open Web Application Security Project (OWASP) Core Rule Set (CRS) 3.2 or newer to protect against common web vulnerabilities, including the OWASP Top 10 threats.

- Configure [WAF geomatch custom rules](/azure/web-application-firewall/geomatch-custom-rules-examples) to block or allow traffic based on geographic location. This approach provides some protection against DDoS attacks.

- Enable [application (Layer 7) DDoS protection](/azure/web-application-firewall/shared/application-ddos-protection#azure-waf-with-azure-application-gateway) by using Azure Web Application Firewall with Application Gateway to protect against volumetric and protocol-based attacks. Combine [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) with application-design practices to enhance DDoS mitigation features.

- Use [private endpoints](/azure/api-management/private-endpoint) for API Management to provide secure inbound connectivity.

- Enable [Microsoft Defender for APIs](/azure/defender-for-cloud/defender-for-apis-introduction) to monitor API security posture and detect threats.

- Configure [WAF bot protection rules](/azure/web-application-firewall/ag/bot-protection) to identify and block malicious bots.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The cost of this architecture depends on several configuration aspects:

- **Service tiers:** Consider Standard v2 and Premium v2 tiers for API Management to improve cost efficiency and performance.

- **Scalability:** Services dynamically allocate the number of instances to support a given demand.
- **Runtime duration:** Costs vary depending on whether the architecture runs continuously or only a few hours every month.
- **Data transfer:** Multiregion deployments incur transfer costs between regions.
- **WAF processing:** Costs depend on the number of requests and rules evaluated.

Consider the following cost optimization strategies:

- Use the [API Management consumption tier](/azure/api-management/api-management-features) for low usage, variable workloads where you pay only for actual usage.

- Implement [Application Gateway autoscaling](/azure/application-gateway/application-gateway-autoscaling-zone-redundant) to optimize instance counts based on demand.

After you assess these aspects, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate pricing.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Implement comprehensive monitoring and observability:

- Configure [API Management diagnostics](/azure/api-management/api-management-howto-use-azure-monitor) to send logs to Azure Monitor so that you can use Log Analytics for detailed API analytics.

- Set up [Application Gateway diagnostics](/azure/application-gateway/application-gateway-diagnostics) to monitor WAF events and performance metrics.
- Implement [API Management alerts](/azure/api-management/api-management-howto-use-azure-monitor#set-up-an-alert-rule) for API performance and availability thresholds.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Application Gateway serves as the entry point for this architecture, and the Azure Web Application Firewall feature requires processing power for each request analysis. To allow Application Gateway to expand its computational capacity on demand, enable autoscaling. For more information, see [Autoscaling and zone redundancy in Application Gateway](/azure/application-gateway/application-gateway-autoscaling-zone-redundant). Follow the product documentation recommendations for [Application Gateway infrastructure configuration](/azure/application-gateway/configuration-infrastructure), including proper subnet sizing. This approach ensures the subnet is large enough to support full scale-out.

Consider the following performance optimizations for API Management:

- Enable [API Management autoscaling](/azure/api-management/api-management-howto-autoscale) to automatically respond to increasing request volumes.

- Use [API Management caching policies](/azure/api-management/api-management-howto-cache) to reduce back-end load and improve response times.
- Implement [API Management rate limiting](/azure/api-management/api-management-policies) to protect back-end services from excessive load.
- Use [Standard v2 or Premium v2 tiers](/azure/api-management/v2-service-tiers-overview) to improve performance and networking capabilities.

## Next steps

To design APIs, follow good [web API design](../../../best-practices/api-design.md) guidelines. To implement APIs, use good [web API implementation](../../../best-practices/api-implementation.md) practices.

## Related resources

- [Gateway Routing pattern](../../../patterns/gateway-routing.yml): Route requests to multiple services by using a single endpoint.
- [Gateway Aggregation pattern](../../../patterns/gateway-aggregation.yml): Aggregate multiple requests into a single request.
- [Gateway Offloading pattern](../../../patterns/gateway-offloading.yml): Offload shared functionality to an API gateway.
- [URL path-based routing overview](/azure/application-gateway/url-route-overview)
- [Tutorial: Create an application gateway with URL path-based redirection by using the Azure CLI](/azure/application-gateway/tutorial-url-redirect-cli)

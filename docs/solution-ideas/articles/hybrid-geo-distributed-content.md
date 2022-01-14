[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Learn how to provide app endpoints across multiple regions and route user traffic based on location and compliance needs.

Organizations with wide-reaching geographies strive to securely and accurately distribute and enable access to data while ensuring required levels of security, compliance and performance per user, location, and device across borders.

## Potential use cases

The company needs to route geo-distributed apps, lets traffic be directed to specific endpoints based on various metrics. Creating a Traffic Manager routes traffic to endpoints based on regional requirements, corporate and international regulation, and data needs.

When to use this architecture:

* My organization has international branches requiring custom regional security and distribution policies.
* Each of my organization's offices pulls employee, business, and facility data, requiring reporting activity per local regulations and time zone.
* High-scale requirements can be met by horizontally scaling out apps, with multiple app deployments being made within a single region and across regions to handle extreme load requirements.
* The apps must be highly available and responsive to client requests even in single-region outages.

## Architecture

![Architecture diagram](../media/hybrid-geo-distributed.png)  
_Download an [Visio file](https://arch-center.azureedge.net/hybrid-geo-distributed.vsdx) of this architecture._

### Data flow

1. The client sends a request to our application.
1. Traffic Manager sends the traffic to some of the available backend.
1. The backend responds the requirement

### Components

* [Traffic Manager](https://azure.microsoft.com/services/traffic-manager/): Azure Traffic Manager is a DNS-based traffic load balancer. Traffic Manager uses DNS to direct the client requests to the appropriate service endpoint based on a traffic-routing method of your choice.
* Cloud Endpoint, [Public IP](https://docs.microsoft.com/azure/virtual-network/ip-services/public-ip-addresses) addresses are used to route the incoming traffic through traffic manager to the public cloud app resources endpoint.
* Local Endpoint, [Public IP](https://docs.microsoft.com/azure/virtual-network/ip-services/public-ip-addresses) addresses are used to route the incoming traffic through traffic manager to the private cloud app resources endpoint.

### Alternatives

For web applications, you can use [Azure Front Door](https://azure.microsoft.com/services/frontdoor/). It works at Layer 7 (HTTP/HTTPS layer) using anycast protocol with split TCP and Microsoft's global network to improve global connectivity. Based on your routing method you can ensure that Front Door will route your client requests to the fastest and most available application backend.

## Considerations

### Reliability

It's important to think about how to deal with networking or power failures. Leverage the [Resiliency and Dependencies](https://docs.microsoft.com/azure/architecture/framework/resiliency/design-resiliency), [Best Practices](https://docs.microsoft.com/azure/architecture/framework/resiliency/design-best-practices), and other [reliability guidance](https://docs.microsoft.com/azure/architecture/framework/resiliency/) from the Microsoft Azure Well Architected Framework (WAF) to improve the solution resiliency.

### Security

The solution could have several components, but at least you need to pay attention to networking security. Leverage the [WAF Network security](https://docs.microsoft.com/azure/architecture/framework/security/design-network) guidance to secure your infrastructure.

### Operational excellence

[Azure Arc](https://azure.microsoft.com/services/azure-arc/) simplifies governance and management by delivering a consistent multi-cloud and on-premises management platform. Manage your entire environment, with a single pane of glass, by projecting your existing non-Azure, on-premises, or other-cloud resources into Azure Resource Manager

### Performance efficiency

The key component of cross-cloud scaling is the ability to deliver on-demand scaling. Scaling must happen between public and local cloud infrastructure and provide a consistent, reliable service per the demand.

## Next steps

To learn more about topics introduced in this article:

* See the [Azure Traffic Manager documentation](https://docs.microsoft.com/azure/traffic-manager/traffic-manager-overview) to learn more about how this DNS-based traffic load balancer works.
* See [Hybrid app design considerations](https://docs.microsoft.com/hybrid/app-solutions/overview-app-design-considerations) to learn more about best practices and to get answers for any additional questions.
* See the [Azure Stack family of products and solutions](https://docs.microsoft.com/azure-stack) to learn more about the entire portfolio of products and solutions.

When you're ready to test the solution example, continue with the [Geo-distributed app solution deployment guide](/azure/architecture/hybrid/deployments/solution-deployment-guide-geo-distributed). The deployment guide provides step-by-step instructions for deploying and testing its components. You learn how to direct traffic to specific endpoints, based on various metrics using the geo-distributed app pattern. Creating a Traffic Manager profile with geographic-based routing and endpoint configuration ensures information is routed to endpoints based on regional requirements, corporate and international regulation, and your data needs.

## Related resources

* [Highly available multi-region web application](../../reference-architectures/app-service-web-app/multi-region.yml)
* [Architecting Azure applications for resiliency and availability](/azure/architecture/reliability/architect.md)

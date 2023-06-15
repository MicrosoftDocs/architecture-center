This solution uses Azure Traffic Manager to route traffic to endpoints to satisfy regional requirements, corporate and international regulations, and data needs.

## Architecture

![Diagram that shows an architecture for geographic traffic routing.](../hybrid/media/hybrid-geo-distributed.svg)

*Download a [Visio file](https://arch-center.azureedge.net/hybrid-geo-distributed.vsdx) of this architecture.*

### Dataflow

1. The client sends a request to the cloud application.
1. Traffic Manager uses DNS to direct the client requests to the appropriate service endpoint, based on a [traffic-routing method](/azure/traffic-manager/traffic-manager-routing-methods). Traffic Manager also provides health monitoring for every endpoint.
1. The instance of the cloud application that Traffic Manager selects processes the request.

### Components

* [Azure Stack Hub](https://azure.microsoft.com/products/azure-stack/hub). Azure Stack Hub is an extension of Azure. It brings the agility of cloud computing to your on-premises environment. In this architecture, it hosts the on-premises version of the app.
* [Traffic Manager](https://azure.microsoft.com/products/traffic-manager). Traffic Manager is a DNS-based traffic load balancer. It's used here to direct client requests to the appropriate endpoint.
* **Domain Name System (DNS)**. DNS translates (or resolves) a website or service name to its IP address.
* **Cloud endpoint**. Public IP addresses route incoming traffic through Traffic Manager to the endpoints for the public cloud app resources.
* **Local endpoint**. Public IP addresses route incoming traffic through Traffic Manager to the endpoints for the local cloud app resources.
* [Azure DDoS Protection Standard](/azure/ddos-protection/ddos-protection-overview), combined with application-design best practices, provides enhanced DDoS mitigation features to provide more defense against DDoS attacks. You should enable [Azure DDOS Protection Standard](/azure/ddos-protection/ddos-protection-overview) on any perimeter virtual network.

### Alternatives

For web applications, you can use [Azure Front Door](https://azure.microsoft.com/products/frontdoor) instead of Traffic Manager. Azure Front Door works on Layer 7 (the HTTP/HTTPS layer). It can keep traffic on the best path to your app, improve service scale, reduce latency, and increase throughput for your global users with edge load balancing, SSL offload, and application acceleration.

## Scenario details

This solution illustrates geographic traffic routing, a process for implementing geo-distributed apps. The solution directs traffic to specific endpoints based on various metrics. It uses Azure Traffic Manager to route traffic to endpoints to satisfy regional requirements, corporate and international regulations, and data needs.

### Potential use cases

Organizations that have wide-reaching geographies strive to distribute data and make it accessible. At the same time, they must meet the required levels of security, compliance, and performance per user, location, and device across borders.

Use this solution when:

* Your organization has international branches that require custom regional security and distribution policies.
* Each of your organization's offices pulls employee, business, and facility data, which necessitates reporting activity per local regulations and time zone.
* You can meet high-scale requirements by horizontally scaling out apps, with multiple app deployments made within a single region and across regions to handle extreme load requirements.
* Your apps must be highly available and responsive to client requests even during single-region outages.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures that your application can meet the commitments that you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Use appropriate on-premises hardware configuration and software deployment practices to ensure that locally deployed apps are configured for high availability. To improve resiliency, follow the guidance in [Resiliency and dependencies](/azure/architecture/framework/resiliency/design-resiliency) and [Best practices](/azure/architecture/framework/resiliency/design-best-practices).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

For comprehensive guidance about security principles, see [Security documentation](/azure/architecture/framework/security) in the Azure Well-Architected Framework.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

For guidance about monitoring in hybrid scenarios, see [Run containers in a hybrid environment](../../hybrid/hybrid-containers.yml).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

The key benefit of cross-cloud scaling is the ability to deliver on-demand scaling. Scaling must happen between public and local cloud infrastructure and provide a consistent, reliable service that's based on demand. To learn more about implementing scalability in Azure, see [Performance efficiency](/azure/architecture/framework/scalability).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Bryan Lamos](https://www.linkedin.com/in/bryanlamos) | Senior Content Developer

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

## Next steps

* See the [Azure Traffic Manager documentation](/azure/traffic-manager/traffic-manager-overview) to learn more about how this DNS-based traffic load balancer works.
* See [Hybrid app design considerations](/hybrid/app-solutions/overview-app-design-considerations) to learn more about best practices.
* Learn about the [Azure Stack portfolio of products and solutions](/azure-stack).
* When you're ready to deploy this solution, use the [Geo-distributed app solution deployment guide](/azure/architecture/hybrid/deployments/solution-deployment-guide-geo-distributed). It provides step-by-step instructions for deploying and testing the solution's components.

## Related resources

* [Highly available multi-region web application](../../web-apps/architectures/multi-region.yml)
* [Architect Azure applications for resiliency and availability](/azure/architecture/reliability/architect)
* [Hybrid architecture design](../../hybrid/hybrid-start-here.md)
* [Extend an on-premises network using VPN](/azure/expressroute/expressroute-howto-coexist-resource-manager)
* [Hybrid availability and performance monitoring](../../hybrid/hybrid-containers.yml)

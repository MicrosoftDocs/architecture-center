[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution shows how to use Azure Traffic Manager to extend an app that's located in a local cloud by connecting it to public cloud resources. A change in routing is triggered by an increase or decrease in demand, and resources are added or removed in the cloud. These resources provide redundancy, rapid availability, and geo-compliant routing.

## Potential use cases

When an app can't increase capacity to meet unexpected increases in demand, it can service only a fixed number of users. This lack of scalability can result in users not reaching the app during peak usage times.

Global enterprises require secure, reliable, and available cloud-based apps. It's critical to meet increases in demand and use the right infrastructure to support that demand. It can be difficult to balance costs and maintenance with business-data security, storage, and real-time availability.

However, sometimes it's not economically feasible for a business to maintain the capacity required to handle spikes in demand in their on-premises environment. By using this solution, you can use the elasticity of the public cloud with your on-premises solution.  

Use this solution when:

- You need to increase your app's capacity for unexpected demand or periodic increases in demand.
- You want to pay for certain resources only during peaks.

We don't recommend this solution when:

- Your business is subject to local regulations that require the originating connection to come from an onsite call.
- Your network experiences regular bottlenecks that would restrict the performance of scaling.
- Your environment is disconnected from the internet and can't reach the public cloud.

## Architecture

![Diagram that shows an architecture for hybrid cross-cloud scaling.](../media/hybrid-cross-cloud-scaling.png)  
_Download an [SVG file](https://arch-center.azureedge.net/cross-cloud-scaling.svg) of this architecture._

### Dataflow

1. The client sends a request to the cloud application.
1. Azure Traffic Manager uses DNS to direct the client request to the appropriate service endpoint, based on a [traffic-routing method](/azure/traffic-manager/traffic-manager-routing-methods). Traffic Manager also provides health monitoring for every endpoint.
1. The instance of the cloud application chosen by Traffic Manager processes the request.

### Components

- [Traffic Manager](https://azure.microsoft.com/services/traffic-manager) is a DNS-based traffic load balancer. It's used here to direct client requests to the appropriate endpoint.
- [Azure Virtual Machine Scale Sets](https://azure.microsoft.com/services/virtual-machine-scale-sets) enables you to scale virtual machines. In this architecture, you can use it to enable app resources to scale in and out. 
- [Azure Container Instances](https://azure.microsoft.com/services/container-instances) enables you to run containers in Azure. In this architecture, it can be used as an alternative to Virtual Machine Scale Sets to provide scaling. 
- **Domain Name System (DNS)** translates (or resolves) a website or service name to its IP address.
- **The hosted build server** is an environment for hosting your build pipeline.
- **Public IP addresses** are used to route the incoming traffic through Traffic Manager to the endpoint for the public cloud app resources.

### Alternatives

For web applications, you can use [Azure Front Door](https://azure.microsoft.com/services/frontdoor) instead of Traffic Manager. Azure Front Door works on Layer 7 (the HTTP/HTTPS layer).
It can keep traffic on the best path to your app, improve service scale, reduce latency, and increase throughput for your global users with edge load balancing, SSL offload, and application acceleration.

## Considerations

### Reliability

Use appropriate on-premises hardware configuration and software deployment practices to ensure that locally deployed apps are configured for high availability. Follow the guidance in [Resiliency and dependencies](/azure/architecture/framework/resiliency/design-resiliency) and [Best practices](/azure/architecture/framework/resiliency/design-best-practices) to improve resiliency.

### Security

For comprehensive guidance about security principles, see [Security documentation](/azure/architecture/framework/security) in the Azure Well-Architected Framework.

### Operational excellence

The operational excellence pillar of the Azure Well-Architected Framework covers the operations processes that keep an application running in production. See [Operational excellence documentation](/azure/architecture/framework/devops) for guidance. See [Hybrid availability and performance monitoring](../../hybrid/hybrid-containers.yml) for guidance about monitoring in hybrid scenarios.

### Performance efficiency

The key benefit of cross-cloud scaling is the ability to deliver on-demand scaling. Scaling must happen between public and local cloud infrastructure and provide a consistent, reliable service based on demand. See [Performance efficiency](/azure/architecture/framework/scalability) to learn more about implementing scalability in Azure.

## Next steps

- See the [Azure Traffic Manager documentation](/azure/traffic-manager/traffic-manager-overview) to learn more about how this DNS-based traffic load balancer works.
- See [Hybrid application design considerations](/hybrid/app-solutions/overview-app-design-considerations) to learn more about best practices.
- Learn about the [Azure Stack portfolio of products and solutions](/azure-stack).
- When you're ready to deploy this solution, use the [Cross-cloud scaling solution deployment guide](/../../hybrid/deployments/solution-deployment-guide-cross-cloud-scaling.md). It provides step-by-step instructions for deploying and testing the solution's components. 

## Related resources

- [Hybrid architecture design](../../hybrid/hybrid-start-here.md)
- [Run containers in a hybrid environment](../../hybrid/hybrid-containers.yml)
- [Extend an on-premises network using VPN](../../reference-architectures/hybrid-networking/vpn.yml)
- [Hybrid availability and performance monitoring](../../hybrid/hybrid-containers.yml)

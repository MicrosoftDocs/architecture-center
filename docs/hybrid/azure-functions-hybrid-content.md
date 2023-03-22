This reference architecture illustrates multiple local branches of an organization that's spread out geographically. Each location is using a Microsoft Azure Function App that's configured with the Premium plan in a nearby cloud region. The developers in this architecture are monitoring all the Azure Function Apps by using Azure Monitor as a single pane of glass.

## Architecture

![The diagram illustrates multiple local virtual machines (VMs) that are connected to Azure Functions in different regions. Developers are monitoring their function apps by using Azure Monitor.][architectural-diagram]

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

### Components

The architecture consists of the following components:

- **[Azure Functions](https://azure.microsoft.com/services/functions)**. Azure Functions is a serverless platform as a service (PaaS) in Azure that runs small, single-task code without requiring new infrastructure to be spun up. The [Azure Functions Premium plan][azure-functions-premium] adds the ability to communicate with Azure Functions privately over a virtual network.
- **[Azure Virtual Network](https://azure.microsoft.com/services/virtual-network)**. Azure virtual networks are private networks built on the Azure cloud platform so that Azure resources can communicate with each other in a secure fashion. Azure virtual networks [service endpoints][azure-virtual-network-service-endpoints] ensure that Azure resources can only communicate over the secure virtual network backbone.
- **On-premises network**. In this architecture, the organization has created a secure private network that connects the various branches. This private network is connected to their Azure virtual networks by using a [site-to-site][azure-virtual-network-s2s] connection.
- **Developer workstations**. In this architecture, individual developers might work on code for Azure Functions entirely on the secure private network or from any remote location. In either scenario, developers have access to Azure Monitor to query or observe metrics and logs for the function apps.

## Scenario details

Typical uses for this architecture include:

- Organizations with many physical locations that are connected to a virtual network in Azure to communicate with Azure Functions.
- High-growth workloads that are using Azure Functions locally and maintaining the option to use Azure for any unexpected bursts in work.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Designing for a serverless architecture

Traditional enterprise applications trend toward a monolithic application architecture in which one code "solution" runs the entire organization's business logic. With Azure Functions, the [best practice][azure-functions-best-practices] is to design for a [serverless architecture][azure-architecture-center-serverless] in which individual functions perform single tasks. These single tasks are designed to run quickly and integrate into larger workflows.

Serverless architecture on Azure Functions has many benefits, including:

- Applications can [automatically scale][azure-functions-scale] by individual business functions instead of scaling the entire solution. This can help keep costs down by scaling only what's needed for each task to serve existing workloads.
- Azure Functions provides [declarative bindings][azure-functions-bindings] for [many Azure services][azure-functions-bindings-list], reducing the amount of code your team needs to write, test, and maintain.
- Individual functions can be reused, reducing the amount of repeated code that's necessary for large enterprise solutions.

### Running Azure Functions on-premises

You may choose to have Azure Functions run on-premises rather than in Azure; for example:

- Your team might want to run Azure Functions within an existing on-premises Kubernetes installation.
- In development, your team may find it easier to develop locally using the command line interface instead of the in-portal editor.
- Your functions will run locally with the toolset installed on on-premises VMs.

You can run Azure Functions on-premises in three ways:

- **[Azure Functions Core Tools][azure-functions-core-tools]**. Azure Functions Core Tools is a developer suite that typically [installs from node package manager (npm)][azure-functions-core-tools-install]. It allows developers to develop, debug, and test function apps at the command prompt on a local computer.
- **[Azure Functions Docker container image][azure-functions-docker]**. You can use this [container image][azure-functions-docker-hub] as a base image for containers that run Azure Functions on a Docker host or in Kubernetes.
- **[Kubernetes][kubernetes]**. Azure Functions supports [seamless event-driven scale within a Kubernetes cluster][azure-functions-kubernetes] using [Kubernetes-based Event Driven Autoscaling (KEDA)][kubernetes-keda]. To review best practices for managing [Azure Kubernetes Service][azure-kubernetes-service] clusters and [Azure Arc-enabled Kubernetes][azure-arc-kubernetes] clusters, review the [Run containers in a hybrid environment][reference-architecture-hybrid-containers] reference architecture.

### Network connectivity

Creating function apps by using the Premium plan opens up the possibility of highly secure [cross-network connectivity][azure-virtual-network-cross] between Azure virtual networks, Azure and on-premises networks, and the networks for each on-premises branch.

You should use either a [site-to-site][azure-virtual-network-s2s] or an [Azure ExpressRoute][azure-expressroute] connection between Azure Virtual Network and on-premises networks. This allows the on-premises branches to communicate with the function apps in Azure by using their [service endpoints][azure-virtual-network-service-endpoints].

Additionally, each virtual network in Azure should also use [virtual network peering][azure-virtual-network-peering] to enable communication between individual function apps across regions.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Scalability

- Azure Functions code should be designed so that it can scale out endlessly. Consider race conditions, leased files, and other workloads that might cause one function run to block another. Also consider writing all Azure Functions code to be [stateless and defensive][azure-functions-best-practices] in its design.
- For function apps that use [Azure Storage][azure-storage] accounts in triggers or bindings, don't reuse the same account that's used to store metadata about the function apps and their runs.

### Availability

- Typically, Azure Functions on the consumption plan can scale down to zero instances. When a new event triggers a function app, a new instance must be created with your code running on it. The latency that's associated with this process is referred to as a *cold start*. The Azure Functions Premium plan offers the option to configure [pre-warmed instances][azure-functions-premium-warmed] that are ready for any new requests. You can configure the number of pre-warmed instances up to the minimum number of instances in your scale-out configuration.
- Consider having multiple Premium plans in multiple regions and using [Azure Traffic Manager][azure-traffic-manager] to route requests appropriately.

### Manageability

- Azure Functions must be in an empty subnet that's a different subnet than your other Azure resources. This might require more planning when designing subnets for your virtual network.
- Consider creating proxies for every on-premises resource that Azure Functions might need to access. This can protect your application integrity against any unanticipated on-premises networking changes.
- Use Azure Monitor to [observe analytics and logs][azure-functions-monitor] for Azure Functions across your entire solution.

### DevOps

- Ideally, deployment operations should come from a single team (*Dev* or *DevOps*), not from each individual branch. Consider using a modern workflow system like Azure Pipelines or GitHub Actions to deploy function apps in a repeatable manner across all Azure regions and potentially on-premises.
- Use your workflow system to automate the redeployment of code to Azure Functions as the code is updated and tagged for release.
- Use [deployment slots][azure-functions-deployment-slots] to test Azure Functions prior to their final push to production.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs.
- The Azure Functions Premium plan is required for Azure Virtual Network connectivity, private site access, service endpoints, and pre-warmed instances.
- The Azure Functions Premium plan bills on instances instead of consumption. The minimum of a single instance ensures there will be at least some monthly bill even without runs. You can set a maximum instance count to control costs for workloads that may burst in size.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:
- [Raunak Jhawar](https://www.linkedin.com/in/raunakjhawar) | Senior Cloud Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Functions documentation][azure-functions]
- [Azure App Service Hybrid Connections](/azure/app-service/app-service-hybrid-connections)
- [Managing hybrid environments with PowerShell](/azure/azure-functions/functions-hybrid-powershell)
- [Azure Functions to connect to resources in an Azure virtual network](/azure/azure-functions/functions-create-vnet)
- [Azure Virtual Network documentation][azure-virtual-network]

## Related resources

See the following architectural guidance for Azure Functions:

- [Serverless event processing](/azure/architecture/reference-architectures/serverless/event-processing)
- [Azure Functions in a hybrid environment](/azure/architecture/hybrid/azure-functions-hybrid)
- [Cross-cloud scaling with Azure Functions](/azure/architecture/solution-ideas/articles/cross-cloud-scaling)
- [Code walkthrough: Serverless application with Functions](/azure/architecture/serverless/code)

See the following architectural guidance for Azure Virtual Networks:

- [Choose between virtual network peering and VPN gateways](/azure/architecture/reference-architectures/hybrid-networking/vnet-peering)
- [Virtual network integrated serverless microservices](/azure/architecture/example-scenario/integrated-multiservices/virtual-network-integration)
- [Spoke-to-spoke networking](/azure/architecture/networking/spoke-to-spoke-networking)
- [Hub-spoke network topology in Azure](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)
- [Firewall and Application Gateway for virtual networks](/azure/architecture/example-scenario/gateway/firewall-application-gateway)
- [Deploy AD DS in an Azure virtual network](/azure/architecture/reference-architectures/identity/adds-extend-domain)

[architectural-diagram]: ./images/azure-functions-hybrid.svg
[architectural-diagram-visio-source]: https://arch-center.azureedge.net/azure-functions-hybrid.vsdx
[azure-arc-kubernetes]: /azure/azure-arc/kubernetes/
[azure-architecture-center-serverless]: ../serverless-quest/serverless-overview.md
[azure-expressroute]: /azure/expressroute/
[azure-functions]: /azure/azure-functions/
[azure-functions-best-practices]: /azure/azure-functions/functions-best-practices
[azure-functions-bindings]: /azure/azure-functions/functions-bindings-example
[azure-functions-bindings-list]: /azure/azure-functions/functions-triggers-bindings#supported-bindings
[azure-functions-core-tools]: https://github.com/azure/azure-functions-core-tools
[azure-functions-core-tools-install]: /azure/azure-functions/functions-run-local#install-the-azure-functions-core-tools
[azure-functions-deployment-slots]: /azure/azure-functions/functions-deployment-slots
[azure-functions-docker]: /azure/azure-functions/functions-create-function-linux-custom-image
[azure-functions-docker-hub]: https://hub.docker.com/_/microsoft-azure-functions-base
[azure-functions-kubernetes]: /azure/azure-functions/functions-kubernetes-keda
[azure-functions-monitor]: /azure/azure-functions/functions-monitoring
[azure-functions-premium]: /azure/azure-functions/functions-premium-plan
[azure-functions-premium-warmed]: /azure/azure-functions/functions-premium-plan#pre-warmed-instances
[azure-functions-scale]: /azure/azure-functions/functions-scale
[azure-kubernetes-service]: /azure/aks/
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator/
[azure-storage]: /azure/storage
[azure-traffic-manager]: /azure/traffic-manager
[azure-virtual-network]: /azure/virtual-network/
[azure-virtual-network-cross]: /azure/expressroute/cross-network-connectivity
[azure-virtual-network-peering]: /azure/virtual-network/virtual-network-peering-overview
[azure-virtual-network-service-endpoints]: /azure/virtual-network/virtual-network-service-endpoints-overview
[azure-virtual-network-s2s]: /azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal
[kubernetes]: https://kubernetes.io/
[kubernetes-keda]: https://keda.sh/
[reference-architecture-hybrid-containers]: hybrid-containers.yml

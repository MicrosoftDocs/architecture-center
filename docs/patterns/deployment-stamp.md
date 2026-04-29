---
title: Deployment Stamps Pattern
description: Learn about the Deployment Stamps pattern, which deploys many independent copies (known as stamps, service units, or scale units) of application components.
ms.author: pnp
author: claytonsiemens77
ms.date: 04/28/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Deployment Stamps pattern

<!-- cSpell:ignore myapi backplane Salvatori -->
The Deployment Stamps pattern provisions, manages, and monitors a group of resources to host and operate multiple workloads or tenants. Each individual copy is called a *stamp*, or sometimes a *service unit*, *scale unit*, or *cell*. In a multitenant environment, each stamp serves a predefined number of tenants. You can deploy multiple stamps to scale the solution almost linearly and serve an increasing number of tenants. This approach can improve the scalability of your solution, enable you to deploy instances across multiple regions, and separate your customer data.

> [!NOTE]
> For more information, see [Architect multitenant solutions on Azure](../guide/multitenant/overview.md).

## Context and problem

When you host an application in the cloud, consider the performance and reliability of your application. If you host a single instance of your solution, the following limitations might apply:

- **Scale limits:** A single instance of your application might reach natural scaling limits. For example, the services that you use might limit the number of inbound connections, host names, Transmission Control Protocol (TCP) sockets, or other resources.

- **Nonlinear scaling or cost:** Some of your solution's components might not scale linearly with the number of requests or the amount of data. Instead, performance can drop or cost can spike after you meet a threshold. For example, you might find that adding more capacity to a database, or scaling up, becomes prohibitively expensive and that scaling out is more cost effective.

- **Separation of customers:** You might need to isolate one customer's data from another customer's data. You might also have customers that consume more system resources than others. You can group them on different sets of infrastructure.

- **Single-tenant and multitenant instances:** Some large customers might need their own independent instances of your solution. Smaller customers can share a multitenant deployment.

- **Complex deployment requirements:** You might need to deploy updates to your service in a controlled manner and deploy to different subsets of your customer base at different times.

- **Update frequency:** Some customers tolerate frequent updates, while risk-averse customers want infrequent updates to the system that serves their requests. You can deploy these customers to isolated environments.

- **Geographical or geopolitical restrictions:** To achieve low latency or comply with data sovereignty requirements, you might deploy some customers to specific regions.

These limitations often apply to software development companies that build software as a service (SaaS), which they typically design as multitenant. The same limitations can also apply to other scenarios.

## Solution

To avoid these problems, consider grouping resources into *scale units* and provisioning multiple copies of your *stamps*. Each scale unit hosts and serves a subset of your tenants. Stamps run independently of each other, and you can deploy and update them independently. A single geographic region might contain one stamp or multiple stamps that scale out horizontally within the region. Each stamp serves a subset of your customers.

:::image type="complex" source="./_images/deployment-stamp/deployment-stamp.png" border="false" lightbox="./_images/deployment-stamp/deployment-stamp.png" alt-text="Diagram that shows an example set of deployment stamps.":::
The diagram shows five stacked rows. Each row represents one deployment stamp. Every row has a label on the upper left that names the stamp and its Azure region, a label on the upper right that lists the tenants that the stamp serves, and two components below the labels, Azure App Service on the left and a SQL database on the right. From top to bottom, the stamps are Stamp 1 in West US 2, which serves tenants A, B, and C; Stamp 2 in West US 2, which serves tenant D; Stamp 3 in East US, which serves tenants E, F, and G; Stamp 4 in West Europe, which serves tenants H, I, and J; and Stamp 5 in Australia East, which serves tenants K, L, and M. The five stamps share the same internal composition but differ in region and in the set of tenants assigned to them, and the West US 2 region contains two separate stamps while each of the other regions contains one stamp.
:::image-end:::

Deployment stamps can apply whether your solution uses infrastructure as a service (IaaS) or platform as a service (PaaS) components, or a combination of both. IaaS workloads typically require more intervention to scale, so this pattern can help IaaS-heavy workloads scale out.

You can use stamps to implement [deployment rings](/azure/architecture/guide/multitenant/considerations/updates#deployment-rings). If different customers want service updates at different frequencies, group them onto different stamps and deploy updates to each stamp at a different cadence.

Stamps run independently, so they implicitly *shard* your data. A single stamp can also use further sharding internally to scale and remain elastic.

Deploying identical copies of the same components is complex, so good DevOps practices are critical. Describe your infrastructure as code so that the deployment of each stamp is predictable and repeatable.

Deployment stamps relate to but differ from [geodes](geodes.yml). In a deployment stamp architecture, each independent instance of your system serves a subset of your customers and users. In a geode architecture, every instance can serve requests from any user, but this approach is typically more complex to design and build. You can also combine the two patterns within one solution. The [traffic routing approach](#traffic-routing) described later in this article is an example of such a hybrid scenario.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- **Deployment process:** When you deploy multiple stamps, automate and fully repeat your deployment processes. Consider using [Bicep](/azure/azure-resource-manager/bicep/overview), [JSON Azure Resource Manager templates (ARM templates)](/azure/azure-resource-manager/templates/overview), or [Terraform](/azure/developer/terraform/overview) modules to declaratively define your stamps and keep the definitions consistent.

- **Cross-stamp operations:** When you deploy your solution independently across multiple stamps, it can be hard to determine how many customers you have across all your stamps. You might need to query each stamp and aggregate the results. Alternatively, you can have all stamps publish data into a centralized data warehouse for consolidated reporting.

- **Scale-out policies:** Stamps have a finite capacity, which you can define by using a proxy metric, such as the number of tenants that you can deploy to the stamp. Monitor the available and used capacity for each stamp, and proactively deploy more stamps to direct new tenants to them.

- **Minimum number of stamps:** When you use the Deployment Stamps pattern, deploy at least two stamps of your solution. If you deploy only a single stamp, you can easily hard-code assumptions into your code or configuration that don't apply when you scale out.

- **Cost:** The Deployment Stamps pattern deploys multiple copies of your infrastructure components, which substantially increases the cost of operating your solution.

- **Moving between stamps:** Each stamp runs independently, so moving tenants between stamps can be difficult. Your application needs custom logic to transmit a customer's information to a different stamp and then remove the tenant's information from the original stamp. This process might require a backplane to communicate between stamps, which further increases the complexity of your solution.

- **Traffic routing:** As described previously in this article, routing traffic to the correct stamp for a given request can require an extra component that resolves tenants to stamps. This component might also need to be highly available.

- **Observability across stamps:** As the number of stamps increases, it becomes harder to understand overall health and detect incidents quickly. Use [Azure Monitor](/azure/azure-monitor/fundamentals/overview) to collect and correlate metrics, logs, traces, and alerts across all stamps. Use this data to identify unhealthy stamps and diagnose problems.

- **Regional failure impact:** Stamps run independently, but they aren't inherently redundant across regions. If a region that hosts one or more stamps becomes unavailable, the tenants on those stamps lose access until the region recovers or you migrate the tenants to stamps in another region. To plan for this scenario, document your recovery procedures, set tenant expectations, and consider whether critical tenants need geo-redundant stamp placement.

- **Shared components:** You might have components that you can share across stamps. For example, if you have a shared single-page app for all tenants, deploy it to one region and use [Azure Front Door](/azure/frontdoor/) edge caching to replicate it globally.

- **Governance and configuration drift:** As the number of stamps increases, it becomes harder to keep security policies, role-based access control (RBAC) assignments, network controls, observability settings, and service configurations consistent. Use [Azure Policy to treat governance as code](/azure/governance/policy/concepts/policy-as-code) and continuously validate each stamp for drift to prevent inconsistent behavior and compliance gaps.

## When to use this pattern

Use this pattern when:

- Your solution has natural limits on scalability. For example, if some components can't or shouldn't scale beyond a certain number of customers or requests, use stamps to scale out.

- You need to separate certain tenants from others. If security concerns prevent you from deploying some customers into a multitenant stamp, deploy them onto their own isolated stamp.

- You need to host some tenants on different versions of your solution at the same time.

- You build multiregion applications that need to direct each tenant's data and traffic to a specific region.

- You want to achieve resiliency during outages. Stamps run independently, so if an outage affects a single stamp, tenants on other stamps remain unaffected. This isolation contains the *blast radius* of an incident or outage.

This pattern might not be suitable when:

- Your solution is simple and doesn't need to scale to a high degree.

- You can scale your system out or up within a single instance, such as by increasing the size of the application layer or by increasing the reserved capacity for databases and the storage tier.

- You need to replicate data across all deployed instances. Consider the [Geode pattern](geodes.yml) for this scenario.

- You only need to scale some components and not others. For example, consider whether you can scale your solution by [sharding the data store](sharding.md) instead of deploying a new copy of all the solution components.

- Your solution consists solely of static content, such as a front-end JavaScript application. Store this content in a [storage account](/azure/storage/blobs/storage-blob-static-website) and use [Azure Content Delivery Network](/azure/architecture/best-practices/cdn).

## Workload design

Evaluate how to use the Deployment Stamps pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | Stamps operate independently, so a failure in one stamp is isolated and doesn't affect tenants on other stamps. Deploying multiple stamps across regions also provides a foundation for redundancy and recovery planning, which reduces the blast radius of regional outages.<br/><br/> - [RE:05 Redundancy](/azure/well-architected/reliability/redundancy)<br/> - [RE:07 Self-preservation](/azure/well-architected/reliability/self-preservation) |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | This pattern supports immutable infrastructure goals, advanced deployment models, and can facilitate safe deployment practices.<br/><br/> - [OE:05 Infrastructure as code](/azure/well-architected/operational-excellence/infrastructure-as-code-design)<br/> - [OE:11 Safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | This pattern often aligns to the defined scale units in your workload. When you need more capacity than a single scale unit provides, you deploy another stamp to scale out.<br/><br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

The following example architecture uses Azure Front Door, Azure API Management, and Azure Cosmos DB to route traffic globally to a series of region-specific stamps.

:::image type="complex" source="./_images/deployment-stamp/deployment-stamp-traffic-routing.png" border="false" lightbox="./_images/deployment-stamp/deployment-stamp-traffic-routing.png" alt-text="Diagram that shows an example traffic routing architecture.":::
On the far left, Azure Front Door (global) represents the entry point. To its right, the middle of the diagram contains three regional traffic routing tiers stacked vertically, one each for West US 2, East US, and Australia East. In every tier, an API Management instance sits on the left and an Azure Cosmos DB instance sits on the right, and a double-headed arrow labeled query for tenant's stamp connects them. Vertical double-headed arrows labeled geo-replication link the three Azure Cosmos DB instances. Azure Front Door connects with double-headed arrows to all three API Management instances. On the far right, five stamps are stacked vertically. Each stamp shows its name and region, the tenants it serves, and an App Service instance paired with a SQL database. The stamps are Stamp 1 (West US 2) for tenants A, B, and C; Stamp 2 (West US 2) for tenant D; Stamp 3 (East US) for tenants E, F, and G; Stamp 4 (West Europe) for tenants H, I, and J; and Stamp 5 (Australia East) for tenants K, L, and M. Curved arrows lead from the API Management instances to the appropriate stamps on the right.
:::image-end:::

Suppose a user resides in New York. Stamp 3, in the East US region, stores their data.

If the user travels to California and accesses the system, the system routes their connection through the West US 2 region because that region is closest to them when they make the request. However, stamp 3 must ultimately serve the request because it stores their data. The traffic routing system routes the request to the correct stamp.

### Deployment

Consider describing your infrastructure as code, such as by using [Bicep](/azure/azure-resource-manager/bicep/overview), [JSON ARM templates](/azure/azure-resource-manager/templates/overview), [Terraform](/azure/developer/terraform/overview), and scripts. This approach ensures that the deployment of each stamp is predictable and repeatable. It also reduces the likelihood of human errors such as accidental mismatches in configuration between stamps.

You can deploy updates automatically to all stamps in parallel. Technologies like [Bicep](/azure/azure-resource-manager/bicep/overview) or ARM templates can coordinate the deployment of your infrastructure and applications. Alternatively, you might decide to gradually roll out updates to some stamps first, and then progressively to other stamps. Consider using a release management tool like [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines) or [GitHub Actions](https://docs.github.com/actions) to orchestrate deployments to each stamp.

Carefully consider the topology of the Azure subscriptions and resource groups for your deployments:

- Typically, a subscription contains all resources for a single solution, so consider using a single subscription for all stamps. However, [some Azure services impose subscription-wide quotas](/azure/azure-resource-manager/management/azure-subscription-service-limits). If you use this pattern to allow for a high degree of scale-out, you might need to deploy stamps across different subscriptions.

- Resource groups generally contain components that share the same life cycle. If you plan to deploy updates to all stamps at the same time, you can use a single resource group that contains all components for all stamps. Use resource naming conventions and tags to identify the components that belong to each stamp. Alternatively, if you plan to deploy updates to each stamp independently, you can deploy each stamp into its own resource group.

### Capacity planning

Use load and performance testing to determine the approximate load that a given stamp can accommodate. Load metrics might be based on the number of customers or tenants that a single stamp can accommodate, or on metrics that the services in the stamp emit. Instrument each stamp so that you can measure when it approaches its capacity, and make sure that you can deploy new stamps quickly to respond to demand.

### Traffic routing

The Deployment Stamps pattern works well when you address each stamp independently. For example, if Contoso deploys the same API application across multiple stamps, Contoso might use Domain Name System (DNS) to route traffic to the relevant stamp:

- `unit1.aus.myapi.contoso.com` routes traffic to stamp `unit1` within an Australian region.
- `unit2.aus.myapi.contoso.com` routes traffic to stamp `unit2` within an Australian region.
- `unit1.eu.myapi.contoso.com` routes traffic to stamp `unit1` within a European region.

In Azure, you can host these records in [Azure DNS](/azure/dns/dns-overview) and use a consistent subdomain convention for each region and stamp. This approach maintains predictable routing and operations.

Clients are responsible for connecting to the correct stamp.

If your solution requires a single ingress point for all traffic, you can use a traffic routing service to resolve the stamp for a given request, customer, or tenant. The traffic routing service either directs the client to the relevant URL for the stamp (for example, by returning an HTTP 302 response status code), or it acts as a reverse proxy and forwards the traffic to the relevant stamp without the client being aware.

A centralized traffic routing service can be a complex component to design, especially when a solution runs across multiple regions. Consider deploying the traffic routing service into multiple regions, potentially including every region that hosts stamps, and sync the data store that maps tenants to stamps. The traffic routing component might itself be an instance of the [Geode pattern](geodes.yml).

For example, you can deploy [API Management](/azure/api-management/api-management-key-concepts) to act as the traffic routing service. API Management determines the appropriate stamp for a request by looking up data in an [Azure Cosmos DB](/azure/cosmos-db/overview) collection that stores the mapping between tenants and stamps. API Management then [dynamically sets the back-end URL](/azure/api-management/set-backend-service-policy) to the relevant stamp's API service.

To geo-distribute requests and provide geo-redundancy for the traffic routing service, [deploy API Management across multiple regions](/azure/api-management/api-management-howto-deploy-multi-region) and use [Azure Front Door](/azure/frontdoor/front-door-overview) to direct traffic to the closest API Management gateway. In this topology, Azure Front Door uses [origin groups](/azure/frontdoor/origin), [health probes](/azure/frontdoor/health-probes), and an appropriate [routing method](/azure/frontdoor/routing-methods) to route requests away from unhealthy API Management regional gateways. API Management then routes to the appropriate stamp by using the tenant-to-stamp mapping and its back-end configuration (or back-end pools), including failover rules between stamp endpoints as needed. If your application isn't exposed over HTTP or HTTPS, you can use a [cross-region Azure load balancer](/azure/load-balancer/cross-region-overview) to distribute incoming calls to regional Azure load balancers. Use the [global distribution feature of Azure Cosmos DB](/azure/cosmos-db/distribute-data-globally) to keep the mapping information updated across each region.

If your solution includes a traffic routing service, consider whether it acts as a [gateway](gateway-routing.yml) and can perform [gateway offloading](gateway-offloading.yml) for the other services, such as token validation, throttling, and authorization.

## Next steps

- [Azure Front Door](/azure/frontdoor/)
- [Integrate Bicep with Azure Pipelines](/azure/azure-resource-manager/bicep/add-template-to-azure-pipelines)
- [Integrate JSON ARM templates with Azure Pipelines](/azure/azure-resource-manager/templates/add-template-to-azure-pipelines)

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Federico Arambarri](https://www.linkedin.com/in/farambarri/) | Senior Software Developer, Clarius Consulting
- [Daniel Larsen](https://www.linkedin.com/in/daniellarsennz) | Principal Customer Engineer, FastTrack for Azure
- [Angel Lopez](https://www.linkedin.com/in/iangellopez) | Senior Software Engineer, Azure Patterns and Practices
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, FastTrack for Azure
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- You can use sharding as another simpler approach to scale out your data tier. Stamps implicitly shard their data, but sharding doesn't require a deployment stamp. For more information, see [Sharding pattern](sharding.md).
- If your solution deploys a traffic routing service, you can combine the [Gateway Routing](gateway-routing.yml) and [Gateway Offloading](gateway-offloading.yml) patterns to make the best use of this component.

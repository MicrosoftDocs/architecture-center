---
  title: Tenancy Models for a Multitenant Solution
  description: Learn about various tenancy models for a multitenant solution and how to choose the best multitenant architecture for your scenario.
  author: johndowns
  ms.author: pnp
  ms.date: 06/11/2025
  ms.topic: concept-article
  ms.subservice: architecture-guide
  ms.custom:
    - arb-saas
# thumbnailUrl: /azure/architecture/browse/thumbs/map-logical-physical.png
---

# Tenancy models for a multitenant solution

There are many ways to consider how to work with tenants in your solution. Your approach depends on whether and how you share resources among your tenants. Intuitively, you might want to avoid sharing any resources, but that approach quickly becomes expensive as your business scales and you onboard more tenants.

When you consider the various models of multitenancy, it's helpful to first consider how you define tenants for your organization, what your business drivers are, and how you plan to scale your solution. This article provides guidance to help technical decision makers evaluate tenancy models and their trade-offs.

## Define a tenant

You need to first define a *tenant* for your organization. Consider who your customer is or who receives your services. There are two common models:

- **Business to business (B2B):** If your customers are other organizations, you likely map your tenants to those customers. However, consider whether your customers have divisions, like teams or departments, and whether they have a presence in multiple countries or regions. You might need to map a single customer to multiple tenants if there are different requirements for these subgroups. Similarly, a customer might want to maintain two instances of your service so that they can keep their development and production environments separated from each other. A single tenant typically has multiple users. For example, all of the customer's employees are users within a single tenant.

- **Business to consumer (B2C):** If your customers are consumers, it's often more complicated to relate customers, tenants, and users. In some scenarios, each consumer might be a separate tenant. However, consider whether your solution might be used by families, groups of friends, clubs, associations, or other groups that might need to access and manage their data together. For example, a music streaming service might support both individual users and families, and it might treat each of these account types differently when it separates them into tenants.

Your definition of *tenant* affects some of the things that you need to consider or emphasize when you architect your solution. For example, consider the following types of tenants:

- If your tenants are individual people or families, you might need to consider how you handle personal data and about the data sovereignty laws in each jurisdiction that you serve.

- If your tenants are businesses, you might need to be mindful of your customers' requirements for regulatory compliance and the isolation of their data. Ensure that you meet a specified service-level objective (SLO), like uptime or service availability.

## Decide which model to use

Selecting a tenancy model isn't only a technical decision. It's also a commercial decision. You need to consider the following questions:

- **Business objectives:** Consider whether reducing the cost for each tenant or maximizing the tenant experience aligns more closely with strategic goals.

- **Compliance:** Consider whether your customers will accept all forms of multitenancy. How does each multitenancy model affect your compliance requirements or your customers' compliance requirements?

- **Scale:** Consider whether a single-tenant solution can scale to your future growth aspirations.

- **Automation:** Consider the size of your operations team and how much of your infrastructure management you can automate.

- **Service-level agreements (SLAs):** Consider whether your customers expect you to meet SLAs, or whether you have SLOs that you target.

If you expect your business to scale to a large number of customers, it's important to deploy shared infrastructure. Otherwise, you have to maintain a large and growing fleet of resource instances. Deploying individual Azure resources for each customer is likely unsustainable, unless you provision and use a dedicated subscription for each tenant. When you share the same Azure subscription across multiple tenants, [Azure resource quotas and limits](/azure/azure-resource-manager/management/azure-subscription-service-limits) might apply, and the operational costs to deploy and reconfigure these resources increase with each new customer.

Conversely, if you expect that your business will have only a few customers, you might want to consider using single-tenant resources that are dedicated to each customer. Also, if your customers' isolation requirements are high, a single-tenant infrastructure approach might be appropriate even though it's more costly.

## Tenants and deployments

Next, you need to determine whether you should distinguish between logical tenants and deployments.

For example, consider a music streaming service. Initially, you might build a solution that can easily handle thousands or even tens of thousands of users. However, as your organization continues to grow, you might find that you need to duplicate your solution or some of its components to scale to new customer demand. To accomplish this task, you need to determine how to assign specific customers to specific instances of your solution. You might assign customers randomly, geographically, or by filling up a single instance and then starting another instance, also known as [*bin packing*](../approaches/resource-organization.md#bin-packing). However, you probably need to maintain a record of your customers and the infrastructure where their data and applications reside so that you can route their traffic to the correct location. In this example, you might represent each customer as a separate tenant and map users to the deployment that contains their data. This approach creates a one-to-many relationship between tenants and deployments, and you can move tenants between deployments at your discretion.

In contrast, consider a company that creates cloud software for legal firms. Your customers might insist on having their own dedicated infrastructure to maintain compliance with regulatory requirements. Therefore, you need to be prepared to deploy and manage many different instances of your solution from the start. In this example, a deployment always contains a single tenant, and a tenant is mapped to its own dedicated deployment.

A key difference between tenants and deployments is how isolation is enforced. When multiple tenants share a single deployment (a set of infrastructure), you typically rely on your application code and a tenant identifier that's in a database to keep each tenant's data separate. When tenants have their own dedicated deployments, they have their own infrastructure, so it might be less important for your code to account for a multitenant environment.

Deployments are sometimes referred to as *supertenants* or *stamps*.

When you receive a request for a specific tenant, you need to map it to the deployment that holds that tenant's data, as shown in the following diagram:

:::image type="complex" border="false" source="media/tenancy-models/map-logical-physical.png" alt-text="Diagram that shows the mapping between tenants and deployments. A tenant mapping layer refers to a table that stores the relationship between tenants and deployments." lightbox="media/tenancy-models/map-logical-physical.png":::
   The diagram is divided into three main sections, tenants, your solution, and tenant ID and deployment ID. Arrows point from Tenants A, B, C, and D to a box labeled tenant mapping inside the solution section. That section also includes a web server and database for deployment 1 and deployment 2. Another arrow points from the tenant mapping box to the section that contains the tenant and deployment IDs. Tenants A and B have a deployment ID of 1, and tenants C and D have deployment IDs of 2.
:::image-end:::

For more information, see [Map requests to tenants](map-requests.yml).

## Tenant isolation

One of the biggest considerations in multitenant architecture design is the level of isolation that each tenant needs. Isolation can refer to the following configurations:

- Having a single shared infrastructure that includes separate instances of your application and separate databases for each tenant.

- Sharing some common resources, but keeping other resources separate for each tenant.

- Keeping data on a separate physical infrastructure. In the cloud, this configuration might require separate Azure resources for each tenant. In extreme scenarios, it can even require you to deploy a separate physical infrastructure by using [dedicated hosts](/azure/virtual-machines/dedicated-hosts).

Instead of viewing isolation as a discrete property, consider it a spectrum. You can deploy components of your architecture that are more isolated or less isolated than other components in the same architecture, depending on your requirements. The following diagram demonstrates a continuum of isolation:

:::image type="complex" border="false" source="media/tenancy-models/isolated-shared.png" alt-text="Diagram that shows a continuum of isolation. It ranges from fully isolated, which means that nothing is shared, to fully shared, which means that everything is shared." lightbox="media/tenancy-models/isolated-shared.png":::
   The diagram shows an arrow from fully isolated (shared nothing) to fully shared (shared everything). On the fully isolated side, blue boxes contain separate compute, separate databases, separate networking, and separate domain names. In the middle of the arrow, green boxes contain shared compute, shared networking, and shared domain names. A blue box contains separate databases. On the fully shared side, green boxes contain shared compute, shared database, shared networking, and shared domain names.
:::image-end:::

The level of isolation affects many aspects of your architecture:

- **Security:** If you share infrastructure among multiple tenants, take care not to access data from one tenant when you return responses to another. You need a strong foundation for your identity strategy, and you need to consider both tenant and user identity in your authorization process.

- **Cost:** Multiple tenants can use shared infrastructure, so it's less expensive.

- **Performance:** If you share infrastructure, your system's performance might degrade as more customers use it because the resources might be consumed faster. Tenants that have unusual usage patterns can worsen performance problems.

- **Reliability:** If you use a single set of shared infrastructure, a problem with one component can result in an outage for all of your tenants.

- **Responsiveness to individual tenant needs:** When you deploy infrastructure that's dedicated to one tenant, you might be able to adapt the configuration for the resources to that specific tenant's requirements. You might even consider this capability in your pricing model to allow customers to pay more for isolated deployments.

Your solution architecture can influence your available options for isolation. For example, consider a three-tier solution architecture:

- Your user interface tier might be a shared multitenant web app. All your tenants access a single host name.

- Your middle tier can be a shared application layer that has shared message queues.

- Your data tier can be isolated databases, tables, or blob containers.

You can use different levels of isolation for each tier. You should base your decision about what to share and what to isolate on several factors, including cost, complexity, your customers' requirements, and the number of resources you can deploy before you reach Azure quotas and limits.

## Common tenancy models

After you establish your requirements, evaluate them against some common tenancy models and corresponding deployment patterns.

### Automated single-tenant deployments

In an automated single-tenant deployment model, you deploy a dedicated set of infrastructure for each tenant, as shown in the following example:

:::image type="complex" border="false" source="media/tenancy-models/automated-single-tenant-deployments.png" alt-text="Diagram that shows three tenants, each with separate deployments." lightbox="media/tenancy-models/automated-single-tenant-deployments.png":::
   The diagram is divided into three sections, one for Tenant A, one for Tenant B, and one for Tenant C. An arrow points from Tenant A to a box labeled Deployment A. That box contains a web server for tenant A. Another arrow points from Tenant B to a box labeled Deployment B. That box contains a web server for tenant B. Another arrow points from Tenant C to a box labeled Deployment C. That box contains a web server for tenant C.
:::image-end:::

Your application is responsible for initiating and coordinating the deployment of each tenant's resources. Typically, solutions that use this model use infrastructure as code or the Azure Resource Manager APIs extensively. You might use this approach when you need to provision entirely separate infrastructures for each of your customers. Consider using the [Deployment Stamps pattern](../../../patterns/deployment-stamp.yml) when you plan your deployment.

**Benefits:** A key benefit of this approach is that data for each tenant is isolated, which reduces the risk of accidental leakage. This safeguard can be important to customers that have high regulatory compliance overhead. Also, tenants are unlikely to affect each other's system performance, also known as the *noisy neighbor* problem. Updates and changes can be rolled out progressively across tenants, which reduces the likelihood of a system-wide outage.

**Risks:** If you use this approach, cost efficiency is low because you don't share infrastructure among your tenants. If a single tenant requires a specific infrastructure cost, 100 tenants probably require 100 times that cost. Also, ongoing maintenance, like applying new configuration or software updates, can be time consuming. Consider automating your operational processes, and consider applying changes progressively through your environments. You should also consider other cross-deployment operations, like reporting and analytics across your whole fleet. Plan for how you can query and manipulate data across multiple deployments.

### Fully multitenant deployments

At the opposite extreme, you can consider a fully multitenant deployment in which all components are shared. You have only one set of infrastructure to deploy and maintain, and all tenants use it, as shown in the following diagram:

:::image type="complex" border="false" source="media/tenancy-models/fully-multitenant-deployments.png" alt-text="Diagram that shows three tenants that all use a single shared deployment." lightbox="media/tenancy-models/fully-multitenant-deployments.png":::
   In this diagram, arrows point from boxes labeled Tenant A, Tenant B, and Tenant C to a box that's labeled as shared resources. That box contains a web server for tenants A, B, and C.
:::image-end:::

**Benefits:** This model is appealing because operating a solution that has shared components is less expensive than using individual resources for each tenant. Even if you need to deploy higher tiers or SKUs of resources to account for the increased load, the overall deployment cost is often still lower than the cost of a set of single-tenant resources. Also, if a user or tenant needs to move their data to another tenant, you might be able to update tenant identifiers and keys, and you might not have to migrate data between two separate deployments.

**Risks:**

- Be sure to separate data for each tenant, and don't leak data among tenants. You might need to manage sharding data. You might also need to consider the effects that individual tenants can have on the overall system. For example, if a large tenant tries to perform a heavy query or operation, it might affect other tenants.

- Determine how to [track and associate your Azure costs to tenants](measure-consumption.md), if this information is important to you.

- You can simplify maintenance by using a single deployment because you only have to update one set of resources. However, it's also often riskier because changes might affect your entire customer base.

- You might also need to consider scale. You're more likely to reach [Azure resource scale limits](/azure/azure-resource-manager/management/azure-subscription-service-limits) when you have a shared set of infrastructure. For example, if you use a storage account as part of your solution, as your scale increases, the number of requests to that storage account might reach the limit of what the storage account can handle. To avoid reaching a resource quota limit, you can deploy a pool of multiple instances of your resources, such as multiple AKS clusters or storage accounts. You can even consider distributing your tenants across resources that you deploy into multiple Azure subscriptions.

- There's probably a limit to how far you can scale a single deployment, and the costs of scaling might increase nonlinearly. For example, if you have a single shared database that you run at high scale, you might exhaust its throughput and need to pay increasingly more for increased throughput to keep up with your demand.

### Vertically partitioned deployments

You don't have to choose one of the extremes of these scales. Instead, you can vertically partition your tenants by taking the following approach:

- Use a combination of single-tenant and multitenant deployments. For example, you might have most of your customers' data and application tiers on multitenant infrastructures, but you deploy single-tenant infrastructures for customers who require higher performance or data isolation.

- Deploy multiple instances of your solution geographically, and map each tenant to a specific deployment. This approach is effective when you have tenants in different geographies.

Here's an example that illustrates a shared deployment for some tenants and a single-tenant deployment for another:

:::image type="complex" border="false" source="media/tenancy-models/vertically-partitioned-deployments.png" alt-text="Diagram that shows three tenants. Tenants A and B share a deployment. Tenant C has a dedicated deployment." lightbox="media/tenancy-models/vertically-partitioned-deployments.png":::
   In this diagram, arrows point from Tenant A and Tenant B to a box that's labeled Deployment 1. That box contains a web server for tenants A and B. Another arrow points from Tenant C to a box labeled Deployment 2. That box contains a web server for Tenant C.
:::image-end:::

**Benefits:** Because you still share some of your infrastructure, you can gain some of the cost benefits of using shared multitenant deployments. You can deploy less expensive shared resources for specific customers, like customers who are evaluating your service by using a trial. You can even charge customers a higher rate to use a single-tenant deployment, which helps you recover some of your costs.

**Risks:** Your codebase needs to be designed to support both multitenant and single-tenant deployments. If you plan to allow migration between deployments, you need to consider how to migrate customers from a multitenant deployment to their own single-tenant deployment. You also need to know which of your tenants are on each deployment so that you can communicate information about system problems or upgrades to the relevant customers.

### Horizontally partitioned deployments

You can also horizontally partition your deployments. In a horizontal deployment, you have some shared components but maintain other components with single-tenant deployments. For example, you can build a single application tier and then deploy individual databases for each tenant, as shown in this diagram:

:::image type="complex" border="false" source="media/tenancy-models/horizontally-partitioned-deployments.png" alt-text="Diagram that shows three tenants that each use a dedicated database and a single shared web server." lightbox="media/tenancy-models/horizontally-partitioned-deployments.png":::
   In this diagram, arrows point from boxes labeled Tenant A, Tenant B, and Tenant C to a box that contains a web server that tenants A, B, and C share.
:::image-end:::

**Benefits:** Horizontally partitioned deployments can help you mitigate a noisy neighbor problem. If you identify that specific components cause most of the load on your system, then you can deploy separate components for each tenant. For example, your databases might absorb most of your system's load because the query load is high. If a single tenant sends a large number of requests to your solution, the performance of a database might be negatively affected, but other tenants' databases and shared components, like the application tier, remain unaffected.

**Risks:** With a horizontally partitioned deployment, you still need to consider the automated deployment and management of your components, especially the components that a single tenant uses.

## Test your isolation model

Whichever isolation model you choose, be sure to test your solution to verify that one tenant's data isn't accidentally leaked to another and that any [noisy neighbor](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) outcomes are acceptable. Consider using [Azure Chaos Studio](/azure/chaos-studio/chaos-studio-overview) to deliberately introduce faults that simulate real-world outages and verify the resiliency of your solution even when components are malfunctioning.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer, Azure Patterns & Practices
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal Customer Engineer, FastTrack for Azure
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

Consider the [life cycle of your tenants](tenant-life-cycle.md).

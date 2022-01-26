---
title: Tenancy models to consider for a multitenant solution
titleSuffix: Azure Architecture Center
description: This article describes the considerations you need to give to different models of multitenancy.
author: johndowns
ms.author: jodowns
ms.date: 11/24/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
categories:
  - management-and-governance
  - security
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Tenancy models to consider for a multitenant solution

There are many different ways that you can design a solution to be multitenanted. Mostly this decision hinges on whether and how you share resources between your tenants. Intuitively, you might want to avoid sharing *any* resources, but this quickly becomes expensive, as your business scales and as you onboard more and more tenants.

It's helpful to think about the different models of multitenancy, by first understanding how you define tenants for your specific organization, what business drivers you have, and how you plan to scale your solution. On this page, we provide guidance for technical decision-makers about the tenancy models you can consider and their tradeoffs.

## Define a tenant

First, you need to define a *tenant* for your organization. Consider who your customer is. In other words, who are you providing your services to? There are two common models:

- **Business-to-business (B2B)**. If your customers are other organizations, you are likely to consider your tenants to be those customers. However, consider whether your customers might have divisions (teams or departments), or if they have a presence in multiple countries. You may need to consider having a single customer map to multiple tenants, if there are different requirements for these subgroups. Similarly, a customer might want to maintain two instances of your service, so they can keep their development and production environments separated from each other. Generally, a single tenant will have multiple users. For example, all of your customer's employees will be users within the same tenant.
- **Business-to-consumer (B2C)**. If your customers are consumers, it's often more complicated to relate customers, tenants, and users. In some scenarios, each consumer could be their own tenant. However, consider whether your solution might be used by families, groups of friends, clubs, associations, or other groupings that might need to access and manage their data together. For example, a music-streaming service might support both individual users and families, and it might treat each of these account types differently, when it comes to separating them into tenants.

Your definition of _tenant_ will impact some of the things that you need to consider or emphasize, when you architect your solution. For example, consider these different types of tenants:

- If your tenants are individual people or families, you may need to be particularly concerned about how you handle personal data, and the data sovereignty laws within each jurisdiction you serve.
- If your tenants are businesses, you may need to be mindful of your customers' requirements for regulatory compliance, the isolation of their data, and ensuring you meet a specified service-level objective (SLO), such as uptime or service availability.

## How do you decide which model to use?

Selecting a tenancy model isn't just a technical decision; it's also a commercial decision that you need to make. You need to consider questions like the following:

- What are your business objectives?
- Will your customers accept all forms of multitenancy? How would each multitenancy model impact your compliance requirements, or your customer's compliance requirements?
- Will a single-tenant solution scale to your future growth aspirations?
- How large is your operations team, and how much of your infrastructure management are you able to automate?
- Do your customers expect you to meet service-level agreements (SLAs), or do you have SLOs that you are aiming for?

If you expect that your business is going to scale to a large number of customers, it will be very important to deploy shared infrastructure. Otherwise, you'll have to maintain a large and ever-growing fleet of instances. Deploying individual Azure resources, for each customer, is likely to be unsustainable, unless you provision and use a dedicated subscription, per tenant. When sharing the same Azure subscription across multiple tenants, [Azure resource quotas and limits](/azure/azure-resource-manager/management/azure-subscription-service-limits) might start to apply, and the operational costs to deploy and reconfigure these resources become higher, with each new customer.

Conversely, if you expect that your business is only going to have a few customers, it might be worth considering to have single-tenant resources that are dedicated to each customer. Similarly, if your customers' isolation requirements are high, a single-tenant infrastructure might be appropriate.

## Logical and physical tenants

Next, you need to determine what a tenant means for your particular solution, and whether you should distinguish between _logical_ and _physical_ tenants.

For example, consider a music streaming service. Initially, you might build a solution that can easily cope with thousands (or even tens of thousands) of users. As you continue to grow, though, you might find that you need to duplicate your solution or some of its components, in order to scale to your new customer demand. This means that you'll need to work out how to assign specific customers to specific instances of your solution. You might do this randomly, or geographically, or by filling up a single instance and then spilling over to another. However, you will probably need to maintain a record of which customers you have and which infrastructure their data and applications are available on, so that you can route their traffic to the correct infrastructure. In this example, you might represent each user as a separate logical tenant, and then map the users to physical tenants that represent the different instances you've deployed. You have a one-to-many mapping between logical and physical tenants, and you can move logical tenants between physical tenants at your own discretion.

In contrast, consider a company that builds cloud software for legal firms. Your customers might insist on their own dedicated infrastructure to maintain their compliance standards. Therefore, you need to be prepared to deploy and manage many different instances of your solution, right from the start. In this example, a logical and physical tenant is the same thing.

A key difference between logical and physical tenants is how isolation is enforced. When multiple logical tenants share a single set of infrastructure, you typically rely on your application code and a tenant identifier in a database, to keep each tenant's data separate. When you have physical tenants, they have their own infrastructure, and so it may be less important for your code to be aware that it's operating in a multitenant environment.

Sometimes, you'll see physical tenants referred to as _deployments_, _supertenants_, or _stamps_. In the rest of this document, we use the terms _deployments_ and _physical deployments_, to avoid confusion between logical and physical tenants.

When you receive a request for a specific logical tenant, you need to map it to the physical deployment that holds that tenant's data, as illustrated below:

![Diagram showing the mapping between logical and physical tenants. A tenant mapping layer refers to a table that stores the relationship between logical tenants and physical deployments.](media/tenancy-models/map-logical-physical.png)

## Tenant isolation

One of the biggest considerations when designing a multitenant architecture is the level of isolation that each tenant needs. Isolation can mean different things:

- Having a single set of shared infrastructure, with separate instances of your application and separate databases for each tenant.
- Sharing some common resources, while keeping other resources separate for each tenant.
- Keeping data on a separate physical infrastructure. In the cloud, this might require separate Azure resources for each tenant, or it could even mean literally deploying a separate physical infrastructure, by using [dedicated hosts](/azure/virtual-machines/dedicated-hosts).

Rather than thinking of isolation as being a discrete property, you should think about isolation as being a continuum. You can deploy components of your architecture that are more or less isolated than other components in the same architecture, depending on your requirements. The following diagram demonstrates a continuum of isolation:

![Diagram showing a continuum of isolation, ranging from fully isolated (shared nothing) to fully shared (shared everything).](media/tenancy-models/isolated-shared.png)

The level of isolation impacts many aspects of your architecture, including the following:

- **Security.** If you share infrastructure between multiple tenants, you need to be especially careful not to access data from one tenant when returning responses to another. You need a strong foundation for your identity strategy, and you need to consider both tenant and user identity within your authorization process.
- **Cost.** Shared infrastructure can be used by multiple tenants, so it's cheaper.
- **Performance.** If you're sharing infrastructure, your system's performance may suffer as more customers use it, since the resources may be consumed faster.
- **Reliability.** If you're using a single set of shared infrastructure, a problem with one tenant's components can result in an outage for everyone.
- **Responsiveness to individual tenants' needs.** When you deploy infrastructure that is dedicated to one tenant, you may be able to tune the configuration for the resources for that specific tenant's requirements. You might even consider this in your pricing model, where you enable customers to pay more for isolated deployments.

Your solution architecture can influence the options that you've got available to you for isolation. For example, let's think about an example three-tier solution architecture:

- Your user interface tier might be a shared multitenant web app, and all of your tenants access a single hostname.
- Your middle tier could be a shared application layer, with shared message queues.
- Your data tier could be isolated databases, tables, or blob containers.

You can consider mixing and matching different levels of isolation at each tier. Your decision about what is shared and what is isolated will be based on many considerations, including cost, complexity, your customers' requirements, and the number of resources that you can deploy before reaching Azure quotas and limits.

## Common tenancy models

Once you've established your requirements, evaluate them against some common tenancy models and patterns.

### Automated single-tenant deployments

In an automated single-tenant deployment model, you deploy a dedicated set of infrastructure for each tenant, as illustrated in this example:

![Diagram showing three tenants, each with separate deployments.](media/tenancy-models/automated-single-tenant-deployments.png)

Your application is responsible for initiating and coordinating the deployment of each tenant's resources. Typically, solutions built using this model make extensive use of infrastructure as code (IaC) or the Azure Resource Manager APIs. You might use this approach when you need to provision entirely separate infrastructures for each of your customers. Consider the [Deployment Stamps pattern](../../../patterns/deployment-stamp.md) when planning your deployment.

**Benefits:** A key benefit of this approach is that data for each tenant is isolated, which reduces the risk of accidental leakage. This can be important to some customers with high regulatory compliance overhead. Additionally, tenants are unlikely to affect each other's system performance, which is sometimes called the _noisy neighbor_ problem. Updates and changes can be rolled out progressively across tenants, which reduces the likelihood of a system-wide outage.

**Risks:** Your cost efficiency is low, because you aren't sharing infrastructure between your tenants. If a single tenant requires spending a certain amount on infrastructure, then it's likely that 100 tenants will require 100 times that cost, in expenditure. Additionally, ongoing maintenance (like applying new configuration or software updates) is likely to be time-consuming. Consider automating your operational processes, and consider applying changes progressively through your environments. You should also consider other cross-deployment operations, like reporting and analytics across your whole estate. Likewise, ensure you plan for how you can query and manipulate data across multiple deployments.

### Fully multitenant deployments

At the opposite extreme, you can consider a fully multitenant deployment, where all components are shared. You only have one set of infrastructure to deploy and maintain, and all tenants use it, as illustrated in the following diagram:

![Diagram showing three tenants, all using a single shared deployment.](media/tenancy-models/fully-multitenant-deployments.png)

**Benefits:** This model is attractive because of the lower cost to operate a solution with shared components. Even if you need to deploy higher tiers or SKUs of resources, it's still often the case that the overall deployment cost is lower than a set of single-tenant resources. Additionally, if a user or tenant needs to move their data into another logical tenant, you don't have to migrate data between two separate deployments.

**Risks:**

- Take care to ensure you separate data for each tenant, and do not leak data between tenants. You may need to manage sharding your data yourself. Additionally, you may need to be concerned about the effects that individual tenants can have on the overall system. For example, if a single large tenant tries to perform a heavy query or operation, will it affect other tenants?

- Determine how you [track and associate your Azure costs to tenants](measure-consumption.md), if this is important to you. Maintenance can be simpler with a single deployment, since you only have to update one set of resources. However, it's also often riskier, since any changes may affect your entire customer base.

- Scale can be a factor to consider as well. You are more likely to reach [Azure resource scale limits](/azure/azure-resource-manager/management/azure-subscription-service-limits) when you have a shared set of infrastructure. For example, if you use a storage account as part of your solution, then as your scale increases, the number of requests to that storage account could reach the limit of what the storage account can handle. To avoid hitting a resource quota limit, you might consider deploying multiple instances of your resources (for example, multiple AKS clusters or storage accounts), or you might even consider distributing your tenants across resources that you've deployed into multiple Azure subscriptions.

- There is likely to be a limit to how far you can scale a single deployment, and the costs of doing so may increase non-linearly. For example, if you have a single, shared database, when you run at very high scale you may exhaust its throughput and have to pay increasingly more for increased throughput, to keep up with your demand.

### Vertically partitioned deployments

You don't have to sit at the extremes of these scales. Instead, you could consider vertically partitioning your tenants, with the following steps:

- Use a combination of single-tenant and multitenant deployments. For example, you might have most of your customers' data and application tiers on multitenant infrastructures, but you might deploy single-tenant infrastructures for customers who require higher performance or data isolation.
- Deploy multiple instances of your solution geographically, and have each tenant pinned to a specific deployment. This is particularly effective when you have tenants in different geographies.

Here's an example that illustrates a shared deployment for some tenants, and a single-tenant deployment for another:

![Diagram showing three tenants. Tenants A and B share a deployment. Tenant C has a dedicated deployment.](media/tenancy-models/vertically-partitioned-deployments.png)

**Benefits:** Since you are still sharing infrastructure, you can still gain some of the cost benefits of having shared multitenant deployments. You can deploy cheaper, shared resources for certain customers, like those who are trying your service with a trial. You can even bill customers a higher rate to be on a single-tenant deployment, thereby recouping some of your costs.

**Risks:** Your codebase will likely need to be designed to support both multitenant and single-tenant deployments. If you plan to allow migration between infrastructures, you need to consider how you migrate customers from a multitenant deployment to their own single-tenant deployment. You also need to have a clear understanding of which of your logical tenants are on which sets of physical infrastructure, so that you can communicate information about system issues or upgrades to the relevant customers.

### Horizontally partitioned deployments

You can also consider horizontally partitioning your deployments. This means you have some shared components, while maintaining other components with single-tenant deployments. For example, you could build a single application tier, and then deploy individual databases for each tenant, as shown in this illustration:

![Diagram showing three tenants, each using a dedicated database and a single, shared web server.](media/tenancy-models/horizontally-partitioned-deployments.png)

**Benefits:** Horizontally partitioned deployments can help you mitigate a noisy-neighbor problem, if you've identified that most of the load on your system is due to specific components that you can deploy separately for each tenant. For example, your databases might absorb most of your system's load, because the query load is high. If a single tenant sends a large number of requests to your solution, the performance of a database might be negatively affected, but other tenants' databases (and shared components, like the application tier) remain unaffected.

**Risks:** With a horizontally partitioned deployment, you still need to consider the automated deployment and management of your components, especially the components used by a single tenant.

## Test your isolation model

Whichever isolation model you select, ensure you test your solution to verify that one tenant's data isn't accidentally leaked to another and that any [noisy neighbor](../../../antipatterns/noisy-neighbor/index.md) effects are acceptable. Consider using [Azure Chaos Studio](/azure/chaos-studio/chaos-studio-overview) to deliberately introduce faults that simulate real-world outages and verify the resiliency of your solution even when components are malfunctioning.

## Next steps

Consider the [lifecycle of your tenants](tenant-lifecycle.md).

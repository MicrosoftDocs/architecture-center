---
title: Organize Azure Resources in Multitenant Solutions
description: Learn how to organize your Azure resources in a multitenant solution based on tenant isolation and scaling out across multiple resources.
author: johndowns
ms.author: pnp
ms.date: 06/16/2025
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
   - arb-saas
---

# Organize Azure resources in multitenant solutions

Azure provides many options for organizing your resources. In a multitenant solution, you need to consider specific trade-offs when you plan your resource organization strategy. This article focuses on two core elements of Azure resource organization: tenant isolation and scaling out across multiple resources. It describes some common deployment approaches that can support different tenant isolation models. This article also describes how to work with Azure resource limits and quotas and how to scale your solution beyond these limits.

## Key considerations and requirements

The following sections describe tenant isolation and scale considerations that you should make when you organize your Azure resources.

### Tenant isolation requirements

When you deploy a multitenant solution in Azure, you need to decide whether you dedicate resources to each tenant or share resources between multiple tenants. The multitenancy approaches and [service-specific guidance](../service/overview.md) sections of this article series describe the options and trade-offs for many categories of resources. In general, there are a range of options for tenant isolation. For more information about how to decide on your isolation model, see [Tenancy models for a multitenant solution](../considerations/tenancy-models.md).

### Scale

Most Azure resources, resource groups, and subscriptions impose limits that can affect your ability to scale. You might need to consider scaling out or bin packing to meet your planned number of tenants or your planned system load.

If you know with certainty that you won't grow to large numbers of tenants or to a high load, don't overengineer your scale-out plan. But if you plan for your solution to grow, carefully consider your scale-out plan. Follow the guidance in this article to help ensure that you architect for scale.

If you have an automated deployment process and need to scale across resources, determine how you plan to deploy and assign tenants across multiple resource instances. For example, consider how to detect when you approach the number of tenants that can be assigned to a specific resource. You might plan to deploy new resources just in time for when you need them. Or you might deploy a pool of resources ahead of time so that they're ready for you to use when you need them.

> [!TIP]
> In the early stages of design and development, you might not choose to implement automated scale-out processes. You should still consider and clearly document the processes required to scale as you grow. By documenting the processes, you make it easier to automate them if the need arises in the future.

It's also important to avoid making any assumptions throughout your code and configuration that can limit your ability to scale. For example, you might need to scale out to multiple storage accounts in the future. When you build your application tier, ensure it can dynamically switch the storage account it connects to based on the active tenant.

## Approaches and patterns to consider

Consider the following approaches to tenant isolation, bin packing, resource tags, and deployments stacks when you plan your Azure resource organization.

### Tenant isolation

Azure resources are deployed and managed through a hierarchy. Most resources are deployed into [resource groups](/azure/azure-resource-manager/management/manage-resource-groups-portal), which are contained in subscriptions. [Management groups](/azure/governance/management-groups/overview) logically group subscriptions together. All of these hierarchical layers are associated with a [Microsoft Entra tenant](/entra/fundamentals/how-subscriptions-associated-directory).

When you determine how to deploy resources for each tenant, you might isolate at different levels in the hierarchy. Each option is valid for specific types of multitenant solutions, and each option comes with benefits and trade-offs. It's also common to combine approaches by using different isolation models for different components of a solution.

#### Isolation within a shared resource

You might choose to share an Azure resource among multiple tenants and run all of their workloads on a single instance. For specific considerations or options that might be important, see the [service-specific guidance](../service/overview.md) for the Azure services that you use.

When you run single instances of a resource, you need to consider any service limits, subscription limits, or quotas that you might reach as you scale. For example, there's a maximum number of nodes that an Azure Kubernetes Service (AKS) cluster supports, and there's an upper limit on the number of transactions per second that a storage account supports. Plan how to [scale to multiple shared resources](#bin-packing) as you approach these limits.

You also need to ensure that your application code is fully aware of multitenancy and that it restricts access to the data for a specific tenant.

As an example of the shared resource approach, suppose Contoso is building a multitenant software as a service (SaaS) application that includes a web application, a database, and a storage account. They might decide to deploy shared resources to service all of their customers. In the following diagram, all customers share a single set of resources.

:::image type="complex" border="false" source="media/resource-organization/isolation-within-resource.png" alt-text="Diagram that shows a single set of resources that all the customers share." lightbox="media/resource-organization/isolation-within-resource.png":::
   In the diagram, a box that represents the Microsoft Entra tenant for Contoso contains another box that represents Contoso's Azure subscription. That box contains another box that represents a shared resource group. It contains the application, the database, and storage.
:::image-end:::

#### Separate resources in a resource group

You can also deploy dedicated resources for each tenant. You might deploy an entire copy of your solution for a single tenant. Or you might share some components between tenants and dedicate other components to a specific tenant. This approach is known as [horizontal partitioning](../considerations/tenancy-models.md#horizontally-partitioned-deployments).

We recommend that you use resource groups to manage resources that have the same life cycle. In some multitenant systems, it makes sense to deploy resources for multiple tenants into a single resource group or a set of resource groups.

It's important to consider how you deploy and manage these resources, including [whether your deployment pipeline or your application initiate the deployment of tenant-specific resources](deployment-configuration.md#resource-management-responsibility). You also need to determine how to [clearly identify that specific resources relate to specific tenants](cost-management-allocation.md). Consider using a clear [naming convention strategy](/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging), [resource tags](cost-management-allocation.md#allocate-costs-by-using-resource-tags), or a tenant catalog database.

It's a good practice to use separate resource groups for the resources that you share between multiple tenants and the resources that you deploy for individual tenants. However, for some resources, [Azure limits the number of resources of a single type that can be deployed into a resource group](/azure/azure-resource-manager/management/resources-without-resource-group-limit). This limit means that you might need to [scale across multiple resource groups](#resource-group-and-subscription-limits) as you grow.

Suppose Contoso has three customers, or tenants: Adventure Works, Fabrikam, and Tailwind. They might choose to share the web application and storage account between the three tenants, and then deploy individual databases for each tenant. The following diagram shows a resource group that contains shared resources and a resource group that contains each tenant's database.


:::image type="complex" border="false" source="media/resource-organization/isolation-resource.png" alt-text="Diagram that shows one resource group that contains shared resources and another resource group that contains a database for each customer." lightbox="media/resource-organization/isolation-resource.png":::
   In the diagram, a box that represents the Microsoft Entra tenant for Contoso contains another box that represents Contoso's Azure subscription. That box contains another box that contains two resource groups. One resource group contains the application and storage and is marked as shared. The other resource group contains a tenant database for each customer: Adventure Works, Fabrikam, and Tailwind.
:::image-end:::

#### Separate resource groups in a subscription

When you deploy a set of resources for each tenant, consider using dedicated, tenant-specific resource groups. For example, when you follow the [Deployment Stamps pattern](overview.md#deployment-stamps-pattern), you should deploy each stamp into its own resource group. You can consider deploying multiple tenant-specific resource groups into a shared Azure subscription. This approach enables you to easily configure policies and access control rules.

You might choose to create a set of resource groups for each tenant and shared resource groups for any shared resources.

When you deploy tenant-specific resource groups into shared subscriptions, be aware of the maximum number of resource groups in each subscription and other subscription-level limits that apply to the resources you deploy. As you approach these limits, you might need to [scale across multiple subscriptions](#resource-group-and-subscription-limits).

In the example, Contoso might choose to deploy a stamp for each of their customers and place the stamps in dedicated resource groups within a single subscription. In the following diagram, a subscription, which contains three resource groups, is created for each customer.

:::image type="complex" border="false" source="media/resource-organization/isolation-resource-group.png" alt-text="Diagram that shows a subscription that contains three resource groups. Each resource group is a complete set of resources for a specific customer." lightbox="media/resource-organization/isolation-resource-group.png":::
   In the diagram, a box that represents the Microsoft Entra tenant for Contoso contains another box that represents Contoso's Azure subscription. That box contains another box that contains three resource groups. Each resource group contains the application, database, and storage for each customer: Adventure Works, Fabrikam, and Tailwind.
:::image-end:::

#### Separate subscriptions

You can deploy tenant-specific subscriptions to completely isolate tenant-specific resources. You can also ensure that each tenant has full use of any applicable quotas by using a separate subscription for each tenant because most quotas and limits apply within a subscription. For some Azure billing account types, [you can programmatically create subscriptions](/azure/cost-management-billing/manage/programmatically-create-subscription). You can also use [Azure reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) and [Azure savings plan for compute](https://azure.microsoft.com/pricing/offers/savings-plan-compute/) across subscriptions.

Make sure you know how many subscriptions you can create. The maximum number of subscriptions might differ depending on your commercial relationship with Microsoft or a Microsoft partner, such as if you have an [enterprise agreement](/azure/cost-management-billing/manage/programmatically-create-subscription-enterprise-agreement?tabs=rest#limitations-of-azure-enterprise-subscription-creation-api).

It can be more difficult to request quota increases when you work across a large number of subscriptions. The [Quota API](/rest/api/reserved-vm-instances/quotaapi) provides a programmatic interface for some resource types. However, for many resource types, quota increases must be requested by [initiating a support case](/azure/azure-resource-manager/management/azure-subscription-service-limits#how-to-manage-limits). It can also be challenging to work with Azure support agreements and support cases when you work with many subscriptions.

Consider grouping your tenant-specific subscriptions into a [management group](/azure/governance/management-groups/overview) hierarchy to enable easy management of access control rules and policies.

For example, suppose Contoso decides to create separate Azure subscriptions for each of their customers, as shown in the following diagram. Each subscription contains a resource group that includes the complete set of resources for that customer.

:::image type="complex" border="false" source="media/resource-organization/isolation-subscription.png" alt-text="Diagram that shows three customer-specific subscriptions. Each subscription contains a resource group that includes the complete set of resources for that customer." lightbox="media/resource-organization/isolation-subscription.png":::
   In the diagram, a box that represents the Microsoft Entra tenant for Contoso contains another box that represents the management group. The management group contains three separate boxes that represent an Azure subscription for each customer: Adventure Works, Fabrikam, and Tailwind. Each Azure subscription contains another box that represents the resource group for each customer. Each resource group contains the application, database, and storage for each customer.
:::image-end:::

Each subscription contains a resource group that includes the complete set of resources for that customer.

In this example, Contoso uses a management group to simplify the management of their subscriptions. By including *Production* in the management group's name, they can clearly distinguish any production tenants from nonproduction or test tenants. Different Azure access control rules and policies apply to nonproduction tenants.

All of Contoso's subscriptions are associated with a single Microsoft Entra tenant. By using a single Microsoft Entra tenant, Contoso can use its team's identities, including users and service principals, throughout its entire Azure estate.

<a name='separate-subscriptions-in-separate-azure-ad-tenants'></a>

#### Separate subscriptions in separate Microsoft Entra tenants

You can also manually create individual Microsoft Entra tenants for each of your tenants or deploy your resources into subscriptions within your customers' Microsoft Entra tenants. However, working with multiple Microsoft Entra tenants makes it more difficult to authenticate, manage role assignments, apply global policies, and perform many other management operations.

> [!WARNING]
> **We advise against creating multiple Microsoft Entra tenants for most multitenant solutions.** Working across Microsoft Entra tenants introduces extra complexity and reduces your ability to scale and manage your resources. Typically, this approach is only used by managed service providers (MSPs) who operate Azure environments on behalf of their customers.
>
> Before you make an effort to deploy multiple Microsoft Entra tenants, consider whether you can achieve your requirements by using management groups or subscriptions within a single tenant instead.

In situations where you need to manage Azure resources in subscriptions that are tied to multiple Microsoft Entra tenants, consider using [Azure Lighthouse](/azure/lighthouse/overview) to help manage your resources across your Microsoft Entra tenants.

For example, Contoso can create separate Microsoft Entra tenants and separate Azure subscriptions for each of their customers, as shown in the following diagram.

:::image type="complex" border="false" source="media/resource-organization/isolation-tenant.png" alt-text="Diagram that shows a Microsoft Entra tenant for each of Contoso's tenants. Each tenant contains a subscription and the resources that each customer needs. Azure Lighthouse is connected to each Microsoft Entra tenant." lightbox="media/resource-organization/isolation-tenant.png":::
   In the diagram, three separate boxes represent the Microsoft Entra tenant for each of Contoso's customers: Adventure Works, Fabrikam, and Tailwind. Each tenant contains another box that represents the Azure subscription for each customer. Each Azure subscription contains another box that represents the resource group for each customer. Each resource group contains the application, database, and storage for each customer. On the right side of the diagram, a blue line represents Azure Lighthouse. An arrow points from this blue line to each of the Microsoft Entra tenants.
:::image-end:::

A Microsoft Entra tenant is configured for each of Contoso's tenants. Each tenant contains a subscription and the resources that each customer needs. Azure Lighthouse is connected to each Microsoft Entra tenant.

### Bin packing

Regardless of your resource isolation model, it's important to consider when and how you plan to scale out your solution across multiple resources. You might need to scale your resources as the load on your system increases or as the number of tenants grows. Consider bin packing to deploy an optimal number of resources for your requirements.

> [!TIP]
> In many solutions, it's easier to scale your entire set of resources together instead of scaling resources individually. Consider following the [Deployment Stamps pattern](overview.md#deployment-stamps-pattern).

#### Resource limits

Azure resources have [limits and quotas](/azure/azure-resource-manager/management/azure-subscription-service-limits) that you must consider in your solution planning. For example, resources might support a maximum number of concurrent requests or tenant-specific configuration settings.

The way you configure and use each resource also affects the scalability of that resource. For example, suppose that your application can successfully respond to a defined number of transactions per second when a specific amount of compute resources are available. Beyond this point, you might need to scale out. Performance testing helps you identify the point at which your resources no longer meet your requirements.

> [!NOTE]
> The principle of scaling to multiple resources applies even when you work with services that support multiple instances.
> 
> For example, Azure App Service supports scaling out the number of instances of your plan, but there are limits for how far you can scale a single plan. In a high-scale multitenant app, you might exceed these limits and need to deploy more App Service plans to match your growth.

When you share some of your resources between tenants, you should first determine the number of tenants that the resource supports when it's configured according to your requirements. Then, deploy as many resources as you need to serve your total number of tenants.

For example, suppose you deploy Azure Application Gateway as part of a multitenant SaaS solution. You review your application design, test the application gateway's performance under load, and review its configuration. Then, you determine that a single application gateway resource can be shared among 100 customers. According to your organization's growth plan, you expect to onboard 150 customers in your first year, so you need to plan to deploy multiple application gateways to service your expected load.

:::image type="complex" border="false" source="media/resource-organization/bin-pack-resource.png" alt-text="Diagram that shows an application gateway that's dedicated to customers 1 through 100 and another that's dedicated to customers 101 through 200." lightbox="media/resource-organization/bin-pack-resource.png":::
   In the diagram, a box that represents a subscription contains another box that represents a resource group. The resource group contains two application gateways. One gateway is dedicated to customers 1 through 100, and the other is dedicated to customers 101 through 200.
:::image-end:::

The diagram shows two application gateways. The first gateway is dedicated to customers 1 through 100, and the second is dedicated to customers 101 through 200.

#### Resource group and subscription limits

Whether you work with shared or dedicated resources, it's important to account for limits. Azure limits the number of resources that can be [deployed into a resource group](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-resource-group-limits) and [into an Azure subscription](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-subscription-limits). As you approach these limits, you need to plan to scale across multiple resource groups or subscriptions.

For example, suppose you deploy a dedicated application gateway for each of your customers into a shared resource group. For some resources, [Azure supports deploying up to 800 resources of the same type](/azure/azure-resource-manager/management/resources-without-resource-group-limit) into a single resource group. So, when you reach this limit, you need to deploy any new application gateways into another resource group. In the following diagram, there are two resource groups. Each resource group contains 800 application gateways.

:::image type="complex" border="false" source="media/resource-organization/bin-pack-resource-group.png" alt-text="Diagram that shows two resource groups. Each resource group contains 800 application gateways." lightbox="media/resource-organization/bin-pack-resource-group.png":::
   In the diagram, a box that represents a subscription contains three boxes that represent resource group 1, resource group 2, and resource group N. The resource group 1 box contains application gateways for tenants 1 through 800. The resource group 2 box contains application gateways for tenants 801 through 1600. The resource group N box contains application gateways for N tenants.
:::image-end:::

#### Bin pack tenants across resource groups and subscriptions

You can also apply the bin packing concept across resources, resource groups, and subscriptions. For example, when you have a few tenants, you might be able to deploy a single resource and share it among all of your tenants. The following diagram shows bin packing into a single resource.

:::image type="complex" border="false" source="media/resource-organization/bin-pack-resources-1.png" alt-text="Diagram that shows bin packing into a single resource." lightbox="media/resource-organization/bin-pack-resources-1.png":::
   In the diagram, a box that represents subscription A contains another box that represents resource group A1. Resource group A1 contains resource A1-1.
:::image-end:::

As you grow, you might approach the capacity limit for a single resource and scale out to multiple resources (*R*). The following diagram shows bin packing across multiple resources.

:::image type="complex" border="false" source="media/resource-organization/bin-pack-resources-2.png" alt-text="Diagram that shows bin packing across multiple resources." lightbox="media/resource-organization/bin-pack-resources-2.png":::
   In the diagram, a box that represents subscription A contains another box that represents resource group A1. Resource group A1 contains resources A1-1 to A1-R.
:::image-end:::

If you reach the limit of the number of resources in a single resource group, you can then deploy multiple resources (*R*) into multiple resource groups (*G*). The following diagram shows bin packing across multiple resources, in multiple resource groups.

:::image type="complex" border="false" source="media/resource-organization/bin-pack-resources-3.png" alt-text="Diagram that shows bin packing across multiple resources, in multiple resource groups." lightbox="media/resource-organization/bin-pack-resources-3.png":::
   In the diagram, a box that represents subscription A contains two boxes. One box represents resource group A1, and the other represents resource group AG. Resource group A1 contains resources A1-1 to A1-R. Resource group AG contains resources AG-1 to AG-R.
:::image-end:::

As you grow even larger, you can deploy resources across multiple subscriptions (*S*), each containing multiple resource groups (*G*) that have multiple resources (*R*). The following diagram shows bin packing across multiple resources, in multiple resource groups and subscriptions.

:::image type="complex" border="false" source="media/resource-organization/bin-pack-resources-4.png" alt-text="Diagram that shows bin packing across multiple resources, in multiple resource groups and subscriptions." lightbox="media/resource-organization/bin-pack-resources-4.png":::
   In the diagram, a box that represents subscription A contains two boxes. One box represents resource group A1, and the other represents resource group AG. Resource group A1 contains resources A1-1 to A1-R. Resource group AG contains resources AG-1 to AG-R. Another box that represents subscription S contains two boxes. One box represents resource group S1, and the other represents resource group SG. Resource group S1 contains resources S1-1 to S1-R. Resource group SG contains resources SG-1 to SG-R.
:::image-end:::

By planning your scale-out strategy, you can scale to large numbers of tenants and sustain a high level of load.

### Tags

Resource tags enable you to add custom metadata to your Azure resources. You can use this metadata to manage resources and track costs. For more information, see [Allocate costs by using resource tags](cost-management-allocation.md#allocate-costs-by-using-resource-tags).

### Deployment stacks

Deployment stacks enable you to group resources together based on a common lifetime, even if they span multiple resource groups or subscriptions. Deployment stacks are useful when you deploy tenant-specific resources, especially if you have a deployment approach that requires you to deploy different types of resources into different places because of scale or compliance concerns. Deployment stacks also enable you to easily remove all of the resources related to a single tenant in one operation if you offboard that tenant. For more information, see [Create and deploy Azure deployment stacks](/azure/azure-resource-manager/bicep/deployment-stacks).

## Antipatterns to avoid

- **Not planning for scale.** Ensure that you understand the limits of the resources that you deploy. Know which limits might become important as your load or number of tenants increases. Plan how to deploy more resources as you scale, and test that plan.

- **Not planning to bin pack.** Even if you don't need to grow immediately, plan to scale your Azure resources across multiple resources, resource groups, and subscriptions over time. Avoid making assumptions in your application code, like having a single resource when you might need to scale to multiple resources in the future.

- **Scaling many individual resources.** If you have a complex resource topology, it can become difficult to scale each component individually. It's often simpler to scale your solution as a unit by following the [Deployment Stamps pattern](overview.md#deployment-stamps-pattern).

- **Deploying isolated resources for each tenant when it's not required.** In many solutions, it's more cost effective and efficient to deploy shared resources for multiple tenants.

- **Failing to track tenant-specific resources.** If you deploy tenant-specific resources, ensure that you understand which resources are allocated to which tenants. This information is important for compliance purposes, for tracking costs, and for deprovisioning resources if you offboard a tenant. Consider using resource tags to keep track of tenant information on resources, and consider using deployment stacks to group tenant-specific resources together into a logical unit regardless of the resource group or subscription they're in.

- **Using separate Microsoft Entra tenants.** In general, it's inadvisable to provision multiple Microsoft Entra tenants. Managing resources across Microsoft Entra tenants is complex. It's simpler to scale across subscriptions linked to a single Microsoft Entra tenant.

- **Overarchitecting when you don't need to scale.** In some solutions, you know with certainty that you won't grow beyond a certain level of scale. In these scenarios, there's no need to build complex scaling logic. However, if your organization plans to grow, then you need to be prepared to scale quickly.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Jason Beck](https://www.linkedin.com/in/jason-beck-75902061) | Senior Customer Engineer, FastTrack for Azure
- [Bohdan Cherchyk](https://www.linkedin.com/in/cherchyk) | Senior Customer Engineer, FastTrack for Azure
- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd) | Senior Customer Engineer, FastTrack for Azure
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
- [Joshua Waddell](https://www.linkedin.com/in/joshua-waddell) | Senior Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resource

- [Cost management and allocation approaches](cost-management-allocation.md)

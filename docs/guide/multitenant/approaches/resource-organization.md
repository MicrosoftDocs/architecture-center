---
title: Azure resource organization in multitenant solutions
titleSuffix: Azure Architecture Center
description: This article describes how to organize your Azure resources in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 12/10/2021
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

# Azure resource organization in multitenant solutions

Azure provides a number of options for organizing your resources. In a multitenant solution, there are specific tradeoffs to consider when you plan your resource organization strategy. On this page, we review two core elements of your resource organization approach: tenant isolation and scale-out across multiple resources.

## Tenant isolation

When you deploy a multitenant solution in Azure, you need to determine whether you dedicate resources to each tenant or if you share resources between multiple tenants. Throughout the multitenancy approaches and service-specific guidance sections of this series, we describe the options and their trade-offs for many categories of resources. In general, though, there are a range of options for *tenant isolation*.

Azure resources are deployed and managed through a hierarchy: most *resources* are deployed into [*resource groups*](/azure/azure-resource-manager/management/manage-resource-groups-portal), which are contained in *subscriptions*. [*Management groups*](/azure/governance/management-groups/overview) logically group subscriptions together. All of these hierarchical layers exist within an [*Azure Active Directory tenant*](/azure/active-directory/fundamentals/active-directory-how-subscriptions-associated-directory).

When you determine how to deploy resources for each tenant, you might choose to isolate at any of these levels in the hierarchy. Each option is valid for certain types of multitenant solutions, and comes with benefits and costs. It's also common to combine approaches, using different isolation models for different components of a solution.

### Isolation within a shared resource

You might choose to share an Azure resource among multiple tenants, and run all of their workloads on a single instance. Ensure you review the [service-specific guidance](../service/overview.md) for the resources you use to understand any specific considerations or options that might be important.

When you run single instances of a component, you need to consider any service limits that might become a problem as you scale. For example, there is a maximimum number of nodes in an Azure Kubernetes Service (AKS) cluster, and an upper limit on the number of transactions per second supported by a storage account. Consider how you'll [scale to multiple shared resources](#plan-to-scale-out) as you approach these limits.

You also need to ensure your application code is fully aware of multitenancy, and that it restricts access to the data for a specific tenant.

As an illustration of the shared resource approach, suppose Contoso is building a multitenant SaaS application that includes a web application, a database, and a storage account. They might decide to deploy shared resources, and use these resources to service all of their customers:

![Diagram showing a single set of resources that are shared by all customers.](media/overview/isolation-within-resource.png)

### Separate resources in a resource group

You can also deploy dedicated resources for each tenant. You might deploy an entire copy of your solution for a single tenant, as in the [Deployment Stamps pattern](overview.md#deployment-stamps-pattern), or you might deploy some components that are shared between tenants and other components that are dedicated to a specific tenants.

It's important that you consider how you deploy and manage these resources, including [whether the deployment of tenant-specific resources is initiated by your deployment pipeline or an application component](deployment-configuration.yml#resource-management-responsibility). You also need to determine how you'll [clearly identify that specific resources relate to specific tenants](cost-management-allocation.md), which might include naming conventions, tags, and a tenant catalog database.

It's often a good practice to use separate resource groups for the resources you share between multiple tenants and those that you deploy for individual tenants. However, for some resources, [Azure limits the number of resources of a single type that can be deployed into a resource group](/azure/azure-resource-manager/management/resources-without-resource-group-limit), so you also need to consider [scaling across multiple resource groups](#resource-group-and-subscription-limits) as you grow.

Suppose Contoso has three customers: Adventure Works, Fabrikam, and Tailwind. They might choose to share the web application and storage account between the three customers, and deploy individual databases for each tenant:

![Diagram showing a resource group containing shared resources, and another resource group containing a database for each customer.](media/overview/isolation-resource.png)

### Separate resource groups in a subscription

When you deploy a set of resources for each tenant, consider using dedicated tenant-specific resource groups. For example, when you follow the [Deployment Stamps pattern](overview.md#deployment-stamps-pattern), each stamp should be deployed into its own resource group. You can consider deploying multiple tenant-specific resource groups into a shared Azure subscription. This enables you to easily configure policies and access control rules.

You might choose to create a set of resource groups for each tenant, and also shared resource groups for any shared resources.

When you deploy tenant-specific resource groups into shared subscriptions, be aware of the maximum number of resource groups in each subscription, and other subscription-level limits that apply to the resources you deploy. As you approach these limits, you might need to [scale across multiple subscriptions](#resource-group-and-subscription-limits).

In our example, Contoso might choose to deploy a stamp for each of their customers and place the stamps in dedicated resource groups within a single subscription:

![Diagram showing a subscription containing three resource groups, each of which is a complete set of resources for a specific customer.](media/overview/isolation-resource-group.png)

### Separate subscriptions

By deploying tenant-specific subscriptions, you can completely isolate tenant-specific resources. Additionally, because most quotas and limits apply within a subscription, using a separate subscription per tenant ensures that each tenant has full use of any applicable quotas. For some Azure billing account types, [you can programmatically create subscriptions](/azure/cost-management-billing/manage/programmatically-create-subscription). You can also make use of [Azure reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) across subscriptions.

However, it can be more difficult to request quota increases when you work across a large number of subscriptions. The [Quota API](/rest/api/reserved-vm-instances/quotaapi) provides a programmatic interface for certain resource types, but for many resource types, quota increases must be requested by [initiating a support case](/azure/azure-resource-manager/management/azure-subscription-service-limits#managing-limits). It can also be challenging to work with support contracts and support cases when you work with many subscriptions.

Consider grouping your tenant-specific subscriptions into a [management group](/azure/governance/management-groups/overview) hierarchy, to enable easy management of access control rules and policies.

For example, suppose Contoso decided to create separate Azure subscriptions for each of their three customers:

![Diagram showing three customer-specific subscriptions, each containing a resource group with the complete set of resources for that customer.](media/overview/isolation-subscription.png)

They use a management group to simplify the management of their subscriptions. They include *Production* in the name of the management group to clearly distinguish any production tenants from non-production or test tenants, which might have different access control rules and policies applies.

All of their subscriptions are tied to a single Azure Active Directory tenant. This means that the Contoso team's identities, including users and service principals, can be used throughout their entire Azure estate.

### Separate subscriptions in separate Azure AD tenants

It's also possible to manually create individual Azure Active Directory (Azure AD) tenants for each of your tenants, or to deploy your resources into subscriptions within your customers' Azure AD tenants. However, this introduces complexity and makes it more difficult to authenticate, to manage role assignments, to apply global policies, and perform many other management operations.

> [!WARNING]
> **We advise against creating multiple Azure Active Directory tenants for most multitenant solutions.** It introduces extra complexity and reduces your ability to scale and manage your resources. Typically, this approach is only used by managed service providers (MSPs), who operate Azure environments on behalf of their customers.

In situations where you need to manage Azure resources in subscriptions tied to multiple Azure AD tenants, consider using [Azure Lighthouse](/azure/lighthouse/overview) to help to manage across your Azure AD tenants.

For example, Contoso could create separate Azure AD tenants and separate subscriptions for each of their tenants:

![Diagram showing an Azure A D tenant for each of Contoso's tenants, containing a subscription and the resources required. Azure Lighthouse is connected to each Azure A D tenant.](media/overview/isolation-tenant.png)

## Plan to scale out

Regardless of your resource isolation model, it's important to consider when and how your solution will scale out across multiple resources. This might need to happen as the load on your system increases, or as the number of tenants grows.

> [!NOTE]
> If you know with certainty that you won't grow to large numbers of tenants or large levels of load, you don't need to overengineer your scale-out plan, and likely don't need to follow the guidance in this section. But if you plan for your solution to grow, we advise you to consider your scale-out plan carefully.

> [!TIP]
> In many solutions, it's easier to scale your entire set of resources together instead of scaling resources individually. Consider following the [Deployment Stamps pattern](overview.md#deployment-stamps-pattern).

### Resource limits

Azure resources have [limits and quotas](/azure/azure-resource-manager/management/azure-subscription-service-limits) that must be considered in your solution planning. For example, resources might support a maximum number of concurrent requests or tenant-specific configuration settings.

Additionally, the way you configure and use each resource affects the scalability supported by that resource. For example, for a given set of compute resources, your application will be able to successfully respond to a defined number of transactions per second. Beyond this point, you might need to scale out. Performance testing helps you to identify the point at which your resources no longer meet your requirements.

> [!NOTE]
> The principle of scaling to multiple resources applies even when you work with services that support multiple instances.
> 
> For example, Azure App Service supports scaling out the number of instances of your plan, but there are limits for how far you can scale a single plan. In a high-scale multitenant app, you might exceed these limits and need deploy additional App Service resources to match your growth.

When you share some of your resources between tenants, consider *bin packing*. Determine the number of tenants that are supported by the resource when it's configured according to your requirements. Then, deploy as many resources as you need to serve your total number of tenants.

For example, suppose you deploy an Azure Application Gateway as part of a multitenant SaaS solution. After reviewing your application design, testing the application gateway's performance under load, and reviewing its configuration, you might determine that a single application gateway can be shared among 100 customers. According to your organization's growth plan, you expect to onboard 150 tenants in your first year. This means that you need to plan to deploy multiple application gateways to service your expected load:

![Diagram showing two application gateways, with the first dedicated to customers 1 through 100, and the second dedicated to customers 101 through 200.](media/overview/bin-pack-resource.png)

### Resource group and subscription limits

Whether you work with shared or dedicated resources, it's important to account for the limits to the number of resources that can be [deployed into a resource group](/azure/azure-resource-manager/management/azure-subscription-service-limits#resource-group-limits) and [into an Azure subscription](/azure/azure-resource-manager/management/azure-subscription-service-limits#subscription-limits). As you approach these limits, you need to plan to scale across multiple resource groups or subscriptions.

For example, suppose you deploy a dedicated application gateway for each of your tenants. You deploy them into a shared resource group. Azure supports deploying 800 resources of the same type into a single resource group, so when you reach this number, you need to deploy any new application gateways into another resource group:

![Diagram showing two resource groups, each containing 800 application gateways.](media/overview/bin-pack-resource-group.png)

### Bin pack tenants across resource groups and subscriptions

You can also apply the bin packing concept across resources, resource groups, and subscriptions. For example, when you have a small number of tenants you might be able to use a single resource for all of your tenants:

![Diagram showing bin packing into a single resource.](media/overview/bin-pack-resources-1.png)

As you grow, you might approach the capacity limit for a single resource, and scale to multiple resources:

![Diagram showing bin packing across multiple resources.](media/overview/bin-pack-resources-2.png)

Over time, you might reach the limit of the number of resources in a single resource group, and deploy resources into multiple resource groups:

![Diagram showing bin packing across multiple resources in multiple resource groups.](media/overview/bin-pack-resources-3.png)

And as you grow even larger you can deploy across multiple subscriptions:

![Diagram showing bin packing across multiple resources in multiple resource groups and subscriptions.](media/overview/bin-pack-resources-4.png)

By planning your scale-out strategy, you can scale to extremely large numbers of tenants with high load.

### Consider how to scale

If you expect to only have a small number of tenants with a small load, it might be possible to avoid scaling across multiple resources. But, if you expect to grow the number of tenants or the amount of overall usage, it's important to consider how you will work with resources as you scale.

If you have an automated deployment process, consider how you'll deploy and assign tenants across multiple resource instances. For example, how will you detect that you're approaching the number of tenants that can be assigned to a specific resource? Will you plan to deploy additional resources as you need them (*just in time*), or will you deploy a pool of resources *ahead of time* so they're ready for you to use when you need them?

It's also important to avoid making assumptions in your code and configuration that can limit your ability to scale. For example, if you plan to scale out to multiple storage accounts, ensure your application tier doesn't assume that it only connects to a single storage account for all tenants.

> [!TIP]
> In the early stages of design and development, you might not choose to implement an automated scale-out process. You should still consider and clearly document the processes required to scale as you grow.

## Next steps

Review [Cost management and allocation](cost-management-allocation.md) approaches.

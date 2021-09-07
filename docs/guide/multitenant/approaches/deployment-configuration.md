---
title: Architectural approaches for deployment and configuration
titleSuffix: Azure Architecture Center
description: This article describes approaches to consider when deploying and configuring a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 09/06/2021
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

# Architectural approaches for deployment and configuration

Regardless of your architecture and the components you use to implement it, you need to deploy and configure your solution. In a multitenant environment, it's important to consider how you deploy your Azure resources, especially when you deploy additional resources for each tenant or reconfigure resources based on the number of tenants in your system. On this page, we provide guidance about deploying multitenant solutions, and some approaches you can consider when planning your deployment strategy.

## Key considerations and requirements

It's important to have a clear idea of your requirements before planning your deployment strategy. Specific considerations include:

- **Expected scale:** Do you expect to support a small number of tenants (such as five or less), or will you grow to a large number of tenants?
- **Self service or supported onboarding:** When a tenant is ready to be onboarded, will they initiate the process themselves? Or, will you provide a manual process that they should trigger?
- **Provisioning time:** When a tenant is ready to be onboarded, how quickly does the onboarding process need to be completed? If you don't have a clear answer, consider whether this should be measured in seconds, minutes, hours, or days.

### Automation

Automated deployments are always advisable, but when working with multitenant solutions, automation becomes even more important, for several reasons:

- **Scale:** An automated deployment approach scales as the number of tenants grows. Manual deployment processes become increasingly complex and time-consuming as your tenant population increases.
- **Repeatable:** In a multitenant environment, use a consistent process for deployments across all tenants. Manual processes introduce the chance of error, or of steps being performed for some tenants and not others, leaving your environment in an inconsistent state.
- **Impact of outages:** Manual deployments are significantly more risky and prone to outages than automated deployments. In a multitenant environment, the impact of a system-wide outage due to a deployment error can be high, since every tenant could be affected.

When deploying to a multitenant environment, it's important to use infrastructure as code (IaC) technologies such as Bicep, JSON ARM templates, or Terraform. You should also use deployment pipelines to publish your code and configuration.

### Resource management responsibility

In many multitenant solutions, you deploy dedicated Azure resources for each tenant, such as a database for each tenant. In other solutions, you deploy shared resources but reconfigure them when new tenants are onboarded, or you decide on a set number of tenants to house on a specific resource and then *spill over* to a new resource. In these situations, the number of tenants you have dictates the resources you deploy to Azure.

You can consider two approaches when deploying resources in a multitenant solution:

- Use an automated deployment pipeline to deploy every resource. As new tenants are added, reconfigure your pipeline to provision the resources for each tenant.
- Use an automated deployment pipeline to deploy shared resources that don't depend on the number of tenants. For resources that are deployed for each tenant, create them programmatically within your application.

When considering the two approaches, it's useful to distinguish between treating your tenant list as *configuration* or as *data*.

When you treat your tenant list as configuration, you deploy resources by using a deployment pipeline and reconfigure the pipeline as you add tenants. This approach tends to work well for small numbers of tenants, and for architectures where all resources are shared. However, when you have large numbers of tenants, it can become cumbersome to reconfigure the pipeline as you add tenants, and time it takes to run the deployment pipeline often increases significantly too. This approach also doesn't easily support self-service tenant creation, and it typically takes more time to onboard a tenant since you need to trigger your pipeline to run.

When you treat your tenant list as data, you deploy your shared components by using a pipeline. However, for resources and configuration settings that need to be deployed for each tenant, you programmatically deploy or configure your resources, such as by using the [Azure SDKs](https://azure.microsoft.com/downloads). By doing this, you can provision resources for new tenants without redeploying your entire solution. However, this approach is often much more time-consuming to build, and the effort you spend needs to be justified by the number of tenants or the provisioning timeframes you need to meet.

> [!NOTE]
> Azure deployment and configuration operations often take time to complete. Ensure you use an appropriate technology to initiate and monitor these long-running operations.
>
> For example, you might create an API that adds tenants. When a tenant is added using the API, you could initiate a long-running process that follows the [Asynchronous Request-Reply pattern](../../../patterns/async-request-reply.md). Use technologies that are designed to support long-running operations, like [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps/) and [Durable Functions](/azure/azure-functions/durable/durable-functions-overview).

TODO: Would it be worth discussing an example here? This might be a simple multitenant solution that uses a shared App Service and a dedicated SQL DB per tenant. We'd then compare the two deployment approaches described above, maybe with a diagram showing each approach.

## Patterns to consider

Several design patterns from the Azure Architecture Center and the wider community are of relevance to deployment and configuration of multitenant solutions.

### Deployment Stamps pattern

The [Deployment Stamps pattern](../../../patterns/deployment-stamp.md) involves deploying dedicated infrastructure for a tenant or group of tenants. A single stamp might contain multiple tenants or might be dedicated to a single tenant. You can choose to deploy a single stamp, or you can coordinate a deployment across multiple stamps. If you deploy dedicated stamps for each tenant, you can also consider deploying entire stamps programmatically.

> [!NOTE]
> When you programmatically deploy tenant resources onto shared stamps, consider how you handle *spillover*. For example, suppose each stamp includes an Azure SQL logical server, and your solution provisions a dedicated database in that server for each tenant. A [single logical server has limits](/azure/azure-sql/database/resource-limits-logical-server#logical-server-limits), including a maximum number of databases that a logical server supports. As you approach these limits, you might need to provision new servers or even a new deployment stamp so that you can continue to onboard tenants. Consider whether you automate this process or manually monitor the growth.

### Deployment rings

[Deployment rings](/azure/devops/migrate/phase-rollout-with-rings) enable you to roll out updates to different groups of infrastructure at different times. This approach is commonly used with the [Deployment Stamps pattern](../../../patterns/deployment-stamp.md), and groups of stamps are deployed into distinct rings based on tenant preferences, workload types, and other considerations.

### Feature flags

[Feature flags](/azure/devops/migrate/phase-features-with-feature-flags) enable you to expose different sets of features or versions of your solution to different tenants, while maintaining a single codebase. Consider using [Azure App Configuration](/azure/azure-app-configuration/overview) to manage your feature flags.

## Antipatterns to avoid

When you deploy and configure multitenant solutions, it's important to avoid situations that inhibit your ability to scale. These include:

- **Manual deployment and testing.** As described above, manual deployment processes add risk and slow your ability to deploy. Consider using automated deployments using pipelines, programmatic creation of resources from your solution's code, or a combination of both.
- **Per-tenant customization.** Avoid creating features or configuration that only applies to a single tenant. This approach adds complexity to your deployments and testing processes. Aim to have use the same resource types and codebase for each tenant, and use strategies like [feature flags](#feature-flags) or [different pricing tiers](../considerations/pricing-models.md) to selectively enable features for tenants that require them.

## Next steps

- Review the [considerations for updating a multitenant solution](../considerations/updates.md).
- Consider [architectural approaches for storage and data](storage-data.md).

---
title: Architectural Approaches for the Deployment and Configuration of Multitenant Solutions
description: Learn how to deploy and configure multitenant solutions in Azure by using automation, scalable architecture, and best practices for onboarding tenants.
author: johndowns
ms.author: pnp
ms.date: 07/16/2025
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
 - arb-saas
categories:
 - management-and-governance
 - devops
---

# Architectural approaches for the deployment and configuration of multitenant solutions

Regardless of your architecture and the components that you use to implement it, you need to deploy and configure your solution's components. In a multitenant environment, consider how to deploy your Azure resources, especially when you deploy dedicated resources for each tenant or reconfigure resources dynamically based on the number of tenants in your system. This article provides solution architects with guidance about deploying multitenant solutions. It demonstrates approaches to consider when you plan your deployment strategy.

## Key considerations and requirements

Clearly define your requirements before you plan your deployment strategy. Consider the following factors:

- **Expected scale:** Determine whether you expect to support only a few tenants, such as five or fewer, or grow to a large number of tenants. As the number of tenants grows, automation becomes increasingly important.

- **Automated or supported onboarding:** Specify whether tenants should complete onboarding through an automated procedure or initiate a request that requires manual onboarding. Define any manual approval steps from your team, such as to prevent the misuse of your service.

- **Provisioning time:** Establish how quickly the onboarding process must be completed. If you don't have a clear answer, define whether this step should be measured in seconds, minutes, hours, or days.

- **[Microsoft Marketplace](https://marketplace.microsoft.com):** Confirm whether you plan to use the Microsoft Marketplace to initiate deployment of your Azure solution. If you do, meet the necessary [requirements to add new tenants](/partner-center/marketplace-offers/plan-azure-application-offer).

Also consider onboarding and provisioning steps, automation, and resource management responsibility.

### Onboarding and provisioning steps

Define and document every task required to onboard a tenant, even if the process is manual. The onboarding workflow typically includes the following steps:

1. Accept commercial agreements.
1. Complete manual approval steps, for example to prevent fraud or misuse of your service.
1. Provision resources in Azure.
1. [Create or configure domain names](../considerations/domain-names.md).
1. Perform post-deployment configuration tasks, such as creating the first user account for the tenant and securely transmitting its credentials to the tenant.
1. Apply manual configuration changes, such as Domain Name System (DNS) record changes.

Clearly document the workflow required to onboard a new tenant.

Consider the specific Azure resources that you need to provision for a tenant. Even if you don't provision dedicated resources for each tenant, consider whether you sometimes need to deploy resources when a new tenant is onboarded. This scenario might occur when a tenant requires data storage in a specific region. It can also occur when you use a [bin packing approach](./resource-organization.md#bin-packing). In bin packing, as you approach the limits of a stamp or component in your solution, you create another instance for the next batch of tenants.

Consider whether the onboarding process could disrupt other tenants, especially tenants that share the same infrastructure. For example, if you need to modify shared databases, determine whether this process could cause a performance impact that other tenants might notice. Consider whether you can avoid these effects or mitigate them by performing the onboarding process outside of normal operating hours.

### Automation

You should use automated deployments for cloud-hosted solutions. In multitenant solutions, automation becomes even more important for the following reasons:

- **Scale:** As your tenant population increases, manual deployment processes become increasingly complex and time-consuming. An automated deployment approach is easier to scale as the number of tenants grows.

- **Repeatable:** In a multitenant environment, use a consistent process for deployments across all tenants. Manual processes introduce the chance of error or inconsistent steps across tenants. Your environment can then be left in an inconsistent state, which makes it harder for your team to manage the solution.

- **Impact of outages:** Manual deployments are more risky and prone to outages than automated deployments. In a multitenant environment, a deployment error can cause a system-wide outage that affects every tenant, which increases the overall impact.

When you deploy to a multitenant environment, follow these practices:

- Use deployment pipelines to deploy common resources.

- Use infrastructure as code (IaC) technologies, such as [Bicep](/azure/azure-resource-manager/bicep/overview), JSON Azure Resource Manager templates (ARM templates), or Terraform.
- Use code to invoke Azure SDKs if appropriate.

If you plan to offer your Azure solution through the [Microsoft Marketplace](https://marketplace.microsoft.com), you should provide a [fully automated onboarding process for new tenants](/azure/marketplace/partner-center-portal/pc-saas-fulfillment-operations-api).

### Maximum resource capacity

When you programmatically deploy tenant resources onto shared resources, consider the capacity limit for each resource. When you approach that limit, you might need to create another instance of the resource to support further scale. Consider the limits of each resource that you deploy and the conditions that trigger you to deploy another instance.

For example, suppose your solution includes an Azure SQL logical server and provisions a dedicated database on that server for each tenant. A [single logical server has limits](/azure/azure-sql/database/resource-limits-logical-server#logical-server-limits), which include a maximum number of databases that it supports. As you approach these limits, you might need to provision new servers so that you can continue to onboard tenants. Consider whether to automate this process or manually monitor the growth.

### Resource management responsibility

In some multitenant solutions, deploy resources by using one of several models. Deploy dedicated Azure resources for each tenant, such as a database for each tenant. Or you can define a set number of tenants to house on a single instance of a resource, so the number of tenants that you have dictates the set of resources that you deploy to Azure. In other solutions, deploy a single set of shared resources and reconfigure them when you onboard new tenants.

Each of these models requires you to deploy and manage resources in different ways, and you must consider how to deploy and manage the life cycle of the resources that you provision. Consider two common approaches:

- Treat tenants as *configuration* of deployed resources, and use your deployment pipelines to deploy and configure those resources.

- Treat tenants as *data*, and have a [control plane](../considerations/control-planes.md) provision and configure infrastructure for your tenants.

The following sections further describe these approaches.

### Testing

Thoroughly test your solution during and after every deployment. You can use automated testing to verify the functional and nonfunctional behavior of your solution. Ensure you test your tenant isolation model. Consider using tools like [Azure Chaos Studio](/azure/chaos-studio/chaos-studio-overview) to deliberately introduce faults that simulate real-world outages and verify that your solution functions even when a component becomes unavailable or malfunctions.

## Approaches and patterns to consider

Several design patterns from the Azure Architecture Center and the broader community support the deployment and configuration of multitenant solutions.

### Deployment Stamps pattern

Use the [Deployment Stamps pattern](../../../patterns/deployment-stamp.yml) to deploy dedicated infrastructure for a tenant or group of tenants. A single stamp might contain multiple tenants, or it might be dedicated to a single tenant. You can deploy a single stamp or coordinate a deployment across multiple stamps. If you deploy dedicated stamps for each tenant, consider deploying entire stamps programmatically.

### Deployment rings

Use [deployment rings](/azure/devops/migrate/phase-rollout-with-rings) to roll out updates to different groups of infrastructure at different times. This approach often complements the [Deployment Stamps pattern](../../../patterns/deployment-stamp.yml). Assign groups of stamps to distinct rings based on tenant preferences, workload types, and other considerations. For more information, see [Deployment rings](../considerations/updates.md#deployment-rings).

### Feature flags

Use [feature flags](/devops/operate/progressive-experimentation-feature-flags) to progressively expose new features or versions of your solution to different tenants or users without redeploying code. Consider using [Azure App Configuration](/azure/azure-app-configuration/overview) to manage your feature flags. For more information, see [Feature flags](../considerations/updates.md#feature-flags).

Sometimes you must selectively enable specific features for specific customers. For example, you might have different [pricing tiers](../considerations/pricing-models.md) that allow access to certain capabilities. Feature flags aren't usually the right choice for these scenarios. Instead, consider building a process to track and enforce the *license entitlements* that each customer has.

## Antipatterns to avoid

When you deploy and configure multitenant solutions, avoid situations that inhibit your ability to scale. The following examples highlight common antipatterns:

- **Manual deployment and testing:** Manual deployment processes add risk and slow your ability to deploy. Consider using pipelines for automated deployments, programmatically creating resources from your solution's code, or a combination of both.

- **Specialized customizations for tenants:** Avoid deploying features or a configuration that only applies to a single tenant. This approach adds complexity to your deployments and testing processes. Instead, use the same resource types and codebase for each tenant. Use strategies like [feature flags](#feature-flags) for temporary changes or for features that are rolled out progressively. Or use [different pricing tiers](../considerations/pricing-models.md) with license entitlements to selectively enable features for tenants that require them. Use a consistent and automated deployment process, even for tenants that have isolated or dedicated resources.

## Tenant lists as configuration or data

Consider the following approaches when you deploy resources in a multitenant solution:

- **Use an automated deployment pipeline to deploy every resource.** As new tenants are added, reconfigure your pipeline to provision the resources for each tenant.

- **Use an automated deployment pipeline to deploy shared resources that don't depend on the number of tenants.** Create tenant-specific resources within your application.

When you consider the two approaches, distinguish between treating your tenant list as a *configuration* or as *data*. This distinction also influences how you build a [control plane](../considerations/control-planes.md) for your system.

### Tenant list as configuration

When you treat your tenant list as configuration, you deploy all your resources from a centralized deployment pipeline. When new tenants are onboarded, you reconfigure the pipeline or its parameters. Typically, the reconfiguration happens through manual changes, as shown in the following diagram.

:::image type="complex" source="media/deployment-configuration/tenants-configuration.png" alt-text="Diagram that shows the process of onboarding a tenant when the tenant list is maintained as a pipeline configuration." border="false" lightbox="media/deployment-configuration/tenants-configuration.png":::
The diagram consists of three primary components arranged sequentially to represent the flow of operations. The process begins with a tenant list. This component feeds into the pipeline, where the lookup operation occurs to retrieve relevant tenant data. The pipeline deploys tasks by using IaC and targets the Azure environment.
:::image-end:::

The onboarding process for a new tenant typically includes the following steps:

1. Update the tenant list manually by configuring the pipeline or modifying a parameters file included in the pipeline's configuration.

1. Trigger the pipeline to run.
1. The pipeline redeploys your complete set of Azure resources, including any new tenant-specific resources.

This approach works well for small numbers of tenants and architectures where all resources are shared. A single process deploys and configures all your Azure resources, which simplifies the overall approach.

However, as the number of tenants increases, often around 10 or more, it becomes cumbersome to reconfigure the pipeline as you add tenants. The time it takes to run the deployment pipeline often increases too. This approach also doesn't easily support self-service tenant creation, and the lead time before a tenant is onboarded can be longer because you need to trigger your pipeline to run.

### Tenant list as data

When you treat your tenant list as data, you still deploy your shared components by using a pipeline. However, for resources and configuration settings that need to be deployed for each tenant, you imperatively deploy or configure your resources. For example, your control plane can use [Azure SDKs](https://azure.microsoft.com/downloads) to create a specific resource or initiate the deployment of a parameterized template.

:::image type="complex" source="media/deployment-configuration/tenants-data.png" alt-text="Diagram that shows the process of onboarding a tenant, when the tenant list is maintained as data." border="false" lightbox="media/deployment-configuration/tenants-data.png":::
The diagram shows a four-step process for tenant creation. It begins with the API component on the left, which initiates the flow by sending data to the creation workflow in the center, as indicated by arrow 1. The creation workflow is labeled step 2. From there, two paths emerge: arrow 3 directs the flow to Azure on the right, and arrow 4 leads upward to tenants.
:::image-end:::

The onboarding process typically includes the following asynchronous steps:

1. Request to onboard a tenant, such as initiating an API request to your system's control plane.

1. A workflow component receives the creation request and orchestrates the remaining steps.
1. The workflow initiates the deployment of tenant-specific resources to Azure. You can use an imperative programming model, such as Azure SDKs, or imperatively trigger the deployment of a Bicep file or Terraform template.
1. When the deployment completes, the workflow saves the new tenant's details to the central tenant catalog. The data stored for each tenant might include the tenant ID and the resource IDs for all the tenant-specific resources that the workflow created.

This approach enables resource provisioning for new tenants without redeploying your entire solution. Provisioning time is typically shorter because only tenant-specific resources are deployed.

However, this approach is often much more time-consuming to build. Your effort needs to be justified by the number of tenants or the provisioning timeframes that you need to meet.

For more information, see [Considerations for multitenant control planes](../considerations/control-planes.md).

> [!NOTE]
> Azure deployment and configuration operations often take time to complete. Ensure that you use an appropriate process to initiate and monitor these long-running operations. For example, you might consider following the [Asynchronous Request-Reply pattern](../../../patterns/async-request-reply.yml). Use technologies designed to support long-running operations, like [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps/) and [durable functions](/azure/azure-functions/durable/durable-functions-overview).

### Example

Contoso runs a multitenant solution for their customers. They have six tenants, and they expect to grow to 300 tenants within the next 18 months. Contoso follows the [multitenant app with dedicated databases for each tenant](storage-data.md#multitenant-app-with-dedicated-databases-for-each-tenant) approach. They deploy a single set of Azure App Service resources and an Azure SQL logical server that all tenants share. They also deploy a dedicated Azure SQL database for each tenant, as shown in the following diagram. Contoso uses Bicep to deploy their Azure resources.

:::image type="complex" source="media/deployment-configuration/example-architecture.png" alt-text="Architecture diagram that shows shared resources and dedicated resources for each tenant." border="false" lightbox="media/deployment-configuration/example-architecture.png":::
The diagram shows a shared resource architecture in an Azure environment. At the top, three shared components are shown: Azure SQL Server, App Service plan, and App Service app. Beneath them, individual tenants labeled tenant 1, tenant 2, and tenant N are depicted. Each tenant connects to their own dedicated Azure SQL database.
:::image-end:::

#### Option 1: Use deployment pipelines for everything

Contoso might deploy all their resources by using a deployment pipeline. Their pipeline deploys a Bicep file that includes all their Azure resources, including the Azure SQL databases for each tenant. A parameter file defines the list of tenants. The Bicep file uses a [resource loop](/azure/azure-resource-manager/bicep/loop-resources) to deploy a database for each of the listed tenants, as shown in the following diagram.

:::image type="complex" source="media/deployment-configuration/example-configuration.png" alt-text="Diagram that shows a pipeline deploying both shared and tenant-specific resources." border="false" lightbox="media/deployment-configuration/example-configuration.png":::
The diagram shows a deployment process to Azure that uses a pipeline that connects to two input files: a Bicep file and a parameter file. The Bicep file includes an App Service plan, an App Service app, Azure SQL Server, and multiple Azure SQL databases. The parameter file lists tenant 1, tenant 2, and continues through tenant N. The pipeline targets an Azure environment.
:::image-end:::

If Contoso follows this model, they must do the following steps:

1. Update their parameter file as part of onboarding a new tenant.

1. Rerun their pipeline.
1. Manually track resource limits, such as if they grow at an unexpectedly high rate and approach the maximum number of databases supported on a single Azure SQL logical server.

#### Option 2: Use a combination of deployment pipelines and imperative resource creation

Alternatively, Contoso might separate the responsibility for the Azure deployments.

Contoso uses a Bicep file that defines shared resources to deployed. The shared resources support all tenants and include a tenant catalog database, also known as a *tenant list database*, as shown in the following diagram.

:::image type="complex" source="media/deployment-configuration/example-data-pipeline.png" alt-text="Diagram that shows the workflow to deploy the shared resources by using a pipeline." border="false" lightbox="media/deployment-configuration/example-data-pipeline.png":::
The diagram shows the deployment of shared resources in Azure that uses a pipeline and a Bicep file. The flow starts at the pipeline, which targets an Azure environment. The Azure shared resources section includes four components: App Service plan, App Service app, Azure SQL Server, and tenant list. These resources are defined in the Bicep file, which includes specifications for the App Service plan, App Service app, Azure SQL Server, and a tenant list database.
:::image-end:::

The Contoso team builds a control plane that includes a tenant onboarding API. When their sales team completes the sale to a new customer, Microsoft Dynamics triggers the API to begin the onboarding process. Contoso also provides a self-service web interface that customers use to trigger the same API.

The API asynchronously starts a workflow that onboards their new tenants. The workflow initiates the deployment of a new Azure SQL database, which might use one of the following approaches:

- Use the Azure SDK to initiate the deployment of a second Bicep file that defines the Azure SQL database.

- Use the Azure SDK to imperatively create an Azure SQL database by using the [management library](/dotnet/api/overview/azure/sql#management-library).

After the database is deployed, the workflow adds the tenant to the tenant list database, as shown in the following diagram. The application tier initiates ongoing database schema updates.

:::image type="complex" source="media/deployment-configuration/example-data-workflow.png" alt-text="Diagram that shows the workflow to deploy a database for a new tenant." border="false" lightbox="media/deployment-configuration/example-data-workflow.png":::
The diagram shows a deployment process in Azure involving tenant-specific and shared resources. It begins with an API that points to a workflow. Within the workflow, two actions are defined: deploy database and update tenant list. The deploy database action points to Azure tenant-specific resources, including SQL databases for tenant 1, tenant 2, and tenant N. The update tenant list action points to the SQL tenant list within Azure shared resources.
:::image-end:::

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Bohdan Cherchyk](https://www.linkedin.com/in/cherchyk) | Senior Customer Engineer, FastTrack for Azure
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Considerations for updating a multitenant solution](../considerations/updates.md).
- [Architectural approaches for storage and data](storage-data.md).
- [Use Azure Resource Manager in a multitenant solution](../service/resource-manager.md).

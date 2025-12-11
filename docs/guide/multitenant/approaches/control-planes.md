---
title: Architectural Approaches for Control Planes in Multitenant Solutions
description: Learn about approaches for designing and creating control planes for your multitenant solutions, including manual, low-code, and custom approaches.
author: johndowns 
ms.author: pnp 
ms.date: 06/12/2025
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
--- 

# Architectural approaches for control planes in multitenant solutions

Control planes are an important part of software as a service (SaaS) and multitenant solutions. They help manage a solution at scale. Typically, a control plane consists of two main components: 

- The tenant catalog, which stores important information about tenants, including the following information:

  - Tenant configuration
  - SKUs deployed for tenant resources
  - Which [deployment stamps](../../../patterns/deployment-stamp.yml) the tenants are allocated to
- Processes that manage changes to the environment. [Tenant life cycle events](../considerations/tenant-life-cycle.md) trigger these processes. Examples include tenant onboarding, tenant offboarding, and required regular maintenance.

A control plane functions as an application. You must design your control plane with the same rigor and care that you apply to other parts of your solution. For more information about what a control plane is, why it matters, and design considerations, see [Considerations for multitenant control planes](../considerations/control-planes.md).

This article describes approaches that you can use to design and create a control plane. Each approach is valid, but a different architecture outside this guidance might better suit your specific scenario.

## Approaches and patterns to consider

The following table summarizes the differences between manual, low-code, and custom approaches for a control plane.

| Consideration  | Manual | Low-code | Custom | 
|---|---|---|---|
| Operational overhead | High | Low-medium | Low |
| Frequency of life cycle events that the approach supports | Rare | Occasional-often | Often |
| Time and complexity to implement | Low | Medium | High |
| Control plane maintenance responsibilities | Low | Medium | High |
| Testability | Low | Medium | High |
| Risk of inconsistencies | High | Medium-low | Low |

### Manual processes

You don't always need to build a fully automated control plane, especially when you're starting out with only a few tenants.

You can keep your tenant catalog in a central location, such as an Excel workbook or a JSON file that's stored in a location that your team can access. Regardless of the format, you should store the information in a structured way so that you can easily work with the data programmatically.

> [!NOTE]
> A manual control plane works well as a starting point for managing your multitenant application, but it's only suitable for fewer than 10 tenants. The administrative overhead and risk of inconsistencies increase with each manually onboarded tenant. Use this approach only if you have a few tenants and don't require automated or self-service onboarding.

Consider the following factors for processes like tenant onboarding and maintenance activities:

- **Create scripts or automated pipelines when possible, even if you run them manually.** Scripts or pipelines help the steps run consistently for each tenant.

- **For tasks that you can't script initially, document the process in clear, detailed steps.** Explain the *how* and the *why*. This information helps others automate the task in the future.

The following diagram shows a manual process approach for an initial control plane.

:::image type="complex" source="media/control-plane/control-plane-approaches-manual.svg" alt-text="Diagram that shows one way to use scripts and other manual processes for a control plane." lightbox="media/control-plane/control-plane-approaches-manual.svg" border="false":::
The diagram has two main sections, a control plane and a data plane. The control plane contains a web application, a salesperson, an Excel file, an engineer, and a script. The data plane contains two existing tenants and one new tenant. Each tenant has an application and a SQL database. The flow starts with an external customer who signs up by speaking to a salesperson. The salesperson inserts the tenant information into an Excel file. An engineer reads the tenant information and runs a deployment script. The script reads the information and deploys and configures the environment in Azure Resource Manager. Resource Manager points to the new tenant in the data plane.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/control-plane-approaches-manual.vsdx) of this architecture.*

#### Advantages of a manual approach

- **Lightweight:** Documentation, scripts, and pipelines are easy to develop and modify. This flexibility makes them ideal when you're figuring out your processes because you can rapidly iterate and evolve them.

- **Low cost:** Maintaining and running a manual approach is inexpensive.
- **Process validation:** A manual approach serves as a proof of concept. It allows you to test and confirm your maintenance strategy before you commit time and resources to building full automation.

#### Disadvantages of a manual approach

- **Lack of control:** This approach relies on everybody involved doing the correct thing. Somebody might deviate from the prescribed processes, either accidentally or intentionally. Every variation in process increases the risk of inconsistency in your environment, which makes ongoing management difficult.

- **Access-control challenges:** This approach often requires broadly scoped, highly permissive access to operators of your solution. This access makes it difficult to enforce [access segmentation](/azure/well-architected/security/segmentation) best practices.
- **Scalability:** The work required to run manual processes scales with the number of tenants that you need to manage. 
- **Testability:** Manual processes are difficult to validate and test.

#### When to transition from a manual approach

- When your team can't keep up with the workload required to maintain the application. This scenario often occurs when the number of tenants exceeds a manageable threshold, typically between 5 and 10 tenants.

- When you anticipate tenant growth beyond a critical number of tenants, and you need to prepare for the demands of administering a larger number of tenants.
- When you need to mitigate the risk of inconsistencies. For example, you might observe mistakes occurring because somebody isn't following the processes correctly or because of unclear processes. The risk of inconsistency increases as more tenants are onboarded manually and as your team grows.

### Low-code control plane

A low-code or no-code control plane uses a platform designed to automate business processes and track information. Many platforms, including Microsoft Power Platform, enable you to do these tasks without writing custom code.

If you use Microsoft Power Platform, you can store your tenant catalog in Dynamics 365, Dataverse, or Microsoft 365. You can also keep the same tenant catalog that you use for your manual processes if you don't want to fully commit to automating everything at first.

For tenant onboarding and maintenance, you can use Power Automate to run workflows that perform tenant management, configure tenants, and trigger pipelines or API calls. Power Automate can monitor for changes to your tenant catalog if it has access to the data. If you use a manual tenant catalog, you can trigger Power Automate workflows manually. Include manual approval steps in your workflows when you need a team member to verify or complete tasks that you can't fully automate.

This approach also supports self-service sign-up for your customers. Your web application can create tenant catalog entries automatically without human involvement.

The following diagram shows how to use Microsoft Power Platform to create a control plane that has self-service sign-up.

:::image type="complex" source="media/control-plane/control-plane-approaches-low-code.svg" alt-text="Diagram that shows how to use Power Automate and Dataverse as a low-code control plane." lightbox="media/control-plane/control-plane-approaches-low-code.svg" border="false":::
The diagram has two main sections, a control plane and a data plane. The control plane contains a web application, a Dataverse table, and a Power Automate workflow. The data plane contains two existing tenants and one new tenant. Each tenant has an application and a SQL database. The flow starts with an external customer who signs up by using a web app. The web app inserts the tenant information into a Dataverse table. These changes trigger the Power Automate workflow, which deploys and configures the environment in Azure Resource Manager. Resource Manager points to the new tenant in the data plane.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/control-plane-approaches-low-code.vsdx) of this architecture.*

#### Advantages of a low-code approach

- **Lightweight:** You can quickly and affordably create low-code workflows and connect them to surrounding systems.

- **Uses platform tooling:** You can use native platform features to store data, create administrative portals for your team, and monitor workflows. This approach reduces the need to develop and maintain custom components.
- **Customizable:** You can extend workflows with custom code when needed. For example, Power Automate can trigger a deployment workflow in GitHub Actions or invoke Azure Functions to run your code. This flexibility helps facilitate a gradual automation implementation.
- **Low overhead:** Low-code services are typically fully managed, so you don't need to manage infrastructure.

#### Disadvantages of a low-code approach

- **Required expertise:** Low-code platforms often require proprietary knowledge to build and manage processes effectively. Many organizations already use these tools, so your team might have the required expertise, or you might need to provide training.

- **Management:** It can be challenging to handle the management of large amounts of low-code configuration.
- **Testability:** In a managed platform, creating a typical DevOps process for testing and promoting changes is more difficult. You typically make changes through configuration, not code.
- **Design:** Low-code platforms often manage nonfunctional requirements, but you still need to verify that they meet your standards. Carefully evaluate how to meet these requirements, such as security and reliability. 

#### When to consider moving away from a low-code approach

Eventually, your requirements might become so complex that you can't sensibly incorporate them in a low-code solution. When you need to work around tooling limitations to meet your needs, you should move away from a managed solution and toward a custom control plane.

### Custom control plane

You can choose to create a fully customized control plane. This option provides the most flexibility and power, but it also requires the most work.

The tenant catalog is usually stored in a database. You don't directly work with the catalog. Instead, you manage it through an administrative interface, such as a custom application or a system like your organization's customer relationship management (CRM) application.

You typically create a set of control plane components to support your tenant administrative functions. These components can include an administrative portal or other user interface, an API, and background processing components. If you need to deploy code or infrastructure when tenant life cycle events occur, you can also add deployment pipelines to your control plane.

Ensure that long-running processing uses appropriate tooling. For example, you might use [Durable Functions](/azure/azure-functions/durable/durable-functions-overview) or [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) for components that orchestrate tenant onboarding, manage deployments, or require communication with external systems.

Like the low-code approach, this approach enables you to provide self-service sign-up to your customers. Your web application can directly add records to your tenant catalog without human intervention.

The following diagram shows how to create a basic custom control plane that provides self-service sign-up.

:::image type="complex" source="media/control-plane/control-plane-approaches-custom.svg" alt-text="Diagram that illustrates a control plane created with Durable Functions, a SQL database, and a service bus." lightbox="media/control-plane/control-plane-approaches-custom.svg" border="false":::
This diagram has two main sections, a control plane and a data plane. The control plane contains a web application, Azure Service Bus, Durable Functions, and SQL Database. The data plane contains two existing tenants and one new tenant. Each tenant has an application and a SQL database. The flow starts with an external customer who signs up by using a web app. The web app stores the tenant information in Azure SQL Database and sends a notification to Service Bus. This notification triggers Durable Functions, which deploys and configures the environment in Azure Resource Manager. Resource Manager points to the new tenant in the data plane. Durable Functions stores the new tenant environment metadata in SQL Database.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/control-plane-approaches-custom.vsdx) of this architecture.*

#### Advantages of a custom approach

- **Full flexibility and customizability:** You have complete control over the functionality of your control plane and can modify it if your requirements change.

- **Testability:** You can use a standard software development life cycle for your control plane application and implement typical approaches for testing and deployments, just like you do for your main applications.

#### Disadvantages of a custom approach

- **Maintenance responsibilities:** This approach requires more maintenance overhead because you need to create everything yourself. A control plane is as important as any other part of your application. You need to take care developing, testing, and operating your control plane to ensure its reliability and security.

### Hybrid approaches

You can also consider a hybrid approach that combines manual and automated systems. Or you might use a managed platform like Microsoft Power Platform and augment it with custom applications. Consider implementing a hybrid approach if you need the flexibility of a custom control plane but don't want to build and maintain a fully custom system. However, keep in mind that automated customizations to your manual processes or managed platform might become as complex as a fully customized system. If your hybrid approach becomes difficult to maintain, consider moving to a fully customized system.

### Gradual implementation

Even if you eventually want to automate your control plane, you don't necessarily need to start with that approach. During the initial stages, a common approach of application development is to start with a manual control plane. As your application progresses and onboards more tenants, identify bottleneck areas and automate them as necessary. This shift moves you toward a hybrid approach. As you automate more tasks, you might transition to a fully automated control plane.

## Antipatterns to avoid

- **Relying on manual processes for too long:** Manual processes work well when you start out or have a low number of tenants and require lightweight management. But you need to plan how to scale to an automated solution as you grow. If you need to hire more team members to keep up with the demand of your manual processes, consider automating parts of your control plane.

- **Using inappropriate tools for long-running workflows:** Don't use tools that have runtime limits, such as standard Azure functions or synchronous API calls, for long-running operations like Azure Resource Manager deployments or multistep orchestration. Instead, use tools that support long-running workflows or sequences of operations, like [Logic Apps](/azure/logic-apps/logic-apps-overview) and [Durable Functions](/azure/azure-functions/durable/durable-functions-overview). For more information, see [Azure Functions performance and reliability](/azure/azure-functions/performance-reliability) and [Asynchronous Request-Reply pattern](/azure/architecture/patterns/async-request-reply).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Landon Pierce](https://www.linkedin.com/in/landon-pierce/) | Customer Engineer

Other contributors:

- [Bohdan Cherchyk](https://www.linkedin.com/in/cherchyk/) | Senior Customer Engineer
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Microsoft Power Platform](https://powerplatform.microsoft.com/)
- [Power Automate](/power-automate/flow-types)

## Related resources

- [Architectural considerations for control planes in a multitenant solution](../considerations/control-planes.md)
- [Architectural approaches for a multitenant solution](../approaches/overview.md)

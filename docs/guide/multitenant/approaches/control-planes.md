---
title: Architectural approaches for control planes in multitenant solutions
description: Learn about approaches to designing and creating control planes for your multitenant solutions, including manual, low-code, and custom approaches.
author: johndowns 
ms.author: pnp 
ms.date: 06/12/2025
ms.update-cycle: 1095-days
ms.topic: conceptual
ms.subservice: architecture-guide
ms.custom: arb-saas
--- 

# Architectural approaches for control planes in multitenant solutions

Control planes are an important part of software as a service (SaaS) and multitenant solutions, especially to help manage a solution at scale. Typically, there are two main components that make up a control plane: 

- The tenant catalog, which stores important information about your tenants, such as: 
  - Tenant configuration.
  - SKUs deployed for tenant resources.
  - Which [deployment stamps](../../../patterns/deployment-stamp.yml) the tenants are allocated to.
- Processes for managing changes to the environment, which are triggered by [tenant lifecycle events](../considerations/tenant-lifecycle.md). For example, tenant onboarding, tenant offboarding, and any required regular maintenance.

A control plane is itself an application. You need to think about your control plane carefully and design it with the same rigor and care you use with any other part of your solution. For more information on what a control plane is, why you should use it, and considerations for designing one, see [Considerations for multitenant control planes](../considerations/control-planes.yml).

This article describes some approaches you can consider for designing and creating a control plane. The list of approaches described here isn't comprehensive. Although the approaches are all valid, there are other valid architectures.

## Approaches and patterns to consider

The following table summarizes the differences between some of the approaches you can consider for a control plane. Manual, low-code, and custom approaches are compared. 

| Consideration  | Manual | Low-code | Custom | 
|---|---|---|---|
| Operational overhead | High | Low-medium | Low |
| Frequency of lifecycle events the approach is suitable for | Rare | Occasional-often | Often |
| Time and complexity to implement | Low | Medium | High |
| Control plane maintenance responsibilities | Low | Medium | High |
| Testability | Low | Medium | High |
| Risk of inconsistencies | High | Medium-low | Low |

### Manual processes

It's not always essential to build a fully automated control plane, especially when you're starting out and have only a small number of tenants.

You might keep your tenant catalog somewhere centrally located, like in an Excel workbook or a JSON file that's stored in a place that your team can access. Regardless of the format, it's a good idea to store the information in a structured way so that you can easily work with the data programmatically.

> [!NOTE]
> A manual control plane is a great way to get started with managing your multitenant application, but it's only suitable for a small number of tenants (less than 5-10). The administrative overhead and the risk of inconsistencies increase with each tenant you onboard manually. You should only use this approach if you have only a few tenants and you don't need automated or self-service onboarding.

For processes like tenant onboarding and maintenance activities:

> [!div class="checklist"]
>
> - **Create scripts or automated pipelines wherever possible, even if you run them manually.** By using scripts or pipelines, you ensure that the steps run consistently for each tenant.
> - **For tasks that you can't script initially, document the process thoroughly and in explicit detail.** Document the *how* as well as the *why*. If somebody ends up automating the task in the future, they should have a good understanding of both.

The following diagram illustrates one way to use manual processes for an initial control plane: 

:::image type="content" source="media/control-plane/control-plane-approaches-manual.svg" alt-text="Diagram that shows one way to use scripts and other manual processes for a control plane." lightbox="media/control-plane/control-plane-approaches-manual.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/control-plane-approaches-manual.vsdx) of this architecture.*

#### Advantages of a manual approach

- **Lightweight**: Documentation, scripts, and pipelines are easy to develop and modify. This makes them appropriate when you're figuring out your processes because you can rapidly iterate and evolve them.
- **Low cost**: Maintaining and running a manual approach is inexpensive.
- **Validates your process**: Even if you eventually intend to use a more automated approach, starting with a manual approach as a proof of concept is a good way to validate your maintenance strategy before you invest time in developing more robust automation.

#### Disadvantages of a manual approach

- **Lack of control**: This approach relies on everybody involved doing the correct thing. Somebody might deviate from the prescribed processes, either accidentally or intentionally. Every variation in process increases the risk of inconsistency in your environment, which makes ongoing management much harder.
- **Access-control challenges**: When you use this approach, you typically need to grant broadly scoped, highly permissive access to anybody who operates your solution, which makes it hard to follow the best practices for [access segmentation](/azure/well-architected/security/segmentation).
- **Scalability**: The work required to run manual processes scales with the number of tenants that you need to manage. 
- **Testability**: Manual processes are difficult to validate and test.

#### When to consider moving away from a manual approach

- When your team can't keep up with the amount of work they need to do to maintain the application. For example, when your number of tenants scales beyond a critical point, which for most teams is between 5 and 10 tenants.
- When you anticipate tenant growth beyond a critical number of tenants and you need to prepare for the work involved in administering that number of tenants.
- When you need to mitigate the risk of inconsistencies. For example, you might observe some mistakes occurring because somebody isn't following the processes correctly, or because there's too much ambiguity in the processes. The risk of inconsistency typically grows as more tenants are onboarded manually, and as your team grows.

### Low-code control plane

A low-code or no-code control plane is built on a platform that's designed to automate business processes and track information. There are many platforms that enable you to do these tasks without writing custom code.

Microsoft Power Platform is an example of one of these platforms. If you use Power Platform, you might keep your tenant catalog in Dynamics 365, Dataverse, or Microsoft 365. You can also consider keeping the same tenant catalog that you use for your manual processes, if you don't want to fully commit to automating everything at first.

For tenant onboarding and maintenance, you can use Power Automate to run workflows that perform tenant management, configure tenants, trigger pipelines or API calls, and so on. You can use Power Automate to watch for changes to your tenant catalog, if the data is somewhere accessible to Power Automate. If you use a manual tenant catalog, Power Automate workflows can also be triggered manually. You might decide to include manual approval steps in your workflows if you need somebody from your team to verify something or perform additional steps that can't be fully automated.

This approach also enables you to provide self-service sign-up to your customers by allowing your web application to directly add records to your tenant catalog without human intervention.

The following diagram illustrates how you might create a control plane with self-service sign-up by using the Microsoft Power Platform:

:::image type="content" source="media/control-plane/control-plane-approaches-low-code.svg" alt-text="Diagram that shows one way to use Power Automate and Dataverse as a low-code control plane." lightbox="media/control-plane/control-plane-approaches-low-code.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/control-plane-approaches-low-code.vsdx) of this architecture.*

#### Advantages of a low-code approach

- **Lightweight**: It's often quick and inexpensive to create a set of low-code workflows and connect them to the surrounding systems.
- **Uses platform tooling**: You can use native platform features to store data, create administrative portals for your team to use, and monitor the workflows as they run. By using native platform features, you avoid building a lot of components yourself.
- **Customizable**: If you need more customization, you can typically augment your workflows with custom code and processes. For example, you might use Power Automate to trigger a deployment workflow in GitHub Actions, or you might invoke Azure Functions to run your own code. This also helps to facilitate a gradual implementation.
- **Low overhead**: Low-code services are typically fully managed, so you don't need to manage infrastructure.

#### Disadvantages of a low-code approach

- **Required expertise**: To use low-code platforms to create processes, and to effectively use these platforms, you typically need proprietary knowledge. Many organizations already use these tools, so your team might already have the required expertise, but it might not. You should consider whether you need to train your team in order to effectively use these platforms.
- **Management**: It can be challenging to handle the management of large amounts of low-code configuration.
- **Testability**: Consider how to test and promote changes to your control plane. In a managed platform, creating a typical DevOps process for testing and promoting changes is more difficult, because changes are normally made through configuration, not through code.
- **Design**: Think carefully about how to meet non-functional requirements like security and reliability. These requirements are often managed for you on a low-code platform.

#### When to consider moving away from a low-code approach

- Eventually, your requirements might become so complex that you can't sensibly incorporate them in a low-code solution. When you need to work around tooling limitations to meet your needs, it probably makes sense to move away from a managed solution and toward a custom control plane.

### Custom control plane

You can also consider creating your own completely customized control plane. This option provides the most flexibility and power, but it also requires the most work. The tenant catalog is usually stored in a database. You don't work directly with the catalog in this case, but instead manage it through an administrative interface, which might be a custom application or a system like your organization's customer relationship management (CRM) application.

You typically create a set of control plane components that's designed around all your tenant administrative functions. These components might include an administrative portal or other user interface, an API, and background processing components. If you need to do things like deploy code or infrastructure when tenant lifecycle events occur, deployment pipelines might also make up your control plane.

Ensure that any long-running processing uses appropriate tooling. For example, you might use [Durable Functions](/azure/azure-functions/durable/durable-functions-overview) or [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) for components that orchestrate tenant onboarding or deployments, or for components that need to communicate with external systems.

Like the low-code approach, this approach enables you to provide self-service sign-up to your customers by allowing your web application to directly add records to your tenant catalog without human intervention.

The following diagram shows one way to create a basic custom control plane that provides self-service sign-up:

:::image type="content" source="media/control-plane/control-plane-approaches-custom.svg" alt-text="Diagram that illustrates a control plane created with Durable Functions, a SQL database, and a service bus." lightbox="media/control-plane/control-plane-approaches-custom.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/control-plane-approaches-custom.vsdx) of this architecture.*

#### Advantages of a custom approach

- **Full flexibility and customizability**: You have complete control over what your control plane does and can change it if your requirements change.
- **Testability**: You can use a standard software development lifecycle (SDLC) for your control plane application and implement normal approaches for testing and deployments, just like you would for your main applications.

#### Disadvantages of a custom approach

- **Maintenance responsibilities**: This approach requires more maintenance overhead because you need to create everything yourself. A control plane is as important as any other part of your application. You need to take great care in developing, testing, and operating your control plane to ensure it's reliable and secure.

### Hybrid approaches

You can also consider using a hybrid approach. You might use a combination of manual and automated systems, or you might use a managed platform like Microsoft Power Platform and augment it with custom applications. Consider implementing a hybrid approach if you need the customizability of a custom control plane but don't necessarily want to build and maintain a fully custom system. Keep in mind that, at some point, your automated customizations to your manual processes or your managed platform might become as complex as a fully customized system. The tipping point is different for every organization, but if your hybrid approach is cumbersome to maintain, you should consider moving to a fully custom system.

### Gradual implementation

Even if you know that you want to eventually automate your control plane, you don't necessarily need to start with that approach. A common approach during the initial stages of creating your application is to start with a manual control plane. As your application progresses and onboards more tenants, you should begin to identify bottleneck areas and automate them as necessary, moving to a hybrid approach. As you automate more, you might eventually have a fully automated control plane.

## Antipatterns to avoid

- **Relying on manual processes for too long.** Although it's reasonable to use manual processes when you start out or when you have a low number of tenants and require fairly lightweight management, you need to plan how to scale to an automated solution as you grow. If you need to hire additional team members to keep up with the demand of your manual processes, that's a good sign that you should start automating parts of your control plane.
- **Using inappropriate tools for long-running workflows.** For example, avoid using standard Azure functions, synchronous API calls, or other tools that have an execution time limit to perform long-running operations like Azure Resource Manager deployments or multi-step orchestrations. Instead, use tools like [Azure Logic Apps](/azure/logic-apps/logic-apps-overview), [Durable Functions](/azure/azure-functions/durable/durable-functions-overview), and other tools that can perform long-running workflows or sequences of operations. For more information, see [Azure Functions performance and reliability](/azure/azure-functions/performance-reliability) and [Asynchronous Request-Reply pattern](/azure/architecture/patterns/async-request-reply).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer
- [Landon Pierce](https://www.linkedin.com/in/landon-pierce/) | Customer Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer 
- [Bohdan Cherchyk](https://www.linkedin.com/in/cherchyk/) | Senior Customer Engineer
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer 

## Next steps

- [Microsoft Power Platform](https://powerplatform.microsoft.com/)
- [Power Automate](https://powerplatform.microsoft.com/power-automate/)

## Related resources

- [Architectural considerations for control planes in a multitenant solution](../considerations/control-planes.yml)
- [Architectural approaches for a multitenant solution](../approaches/overview.yml)
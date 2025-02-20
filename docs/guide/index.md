---
title: Azure Application Architecture Fundamentals
description: Learn about a structured approach to designing scalable, resilient, and highly available applications on Azure.
author: RobBagby
ms.author: pnp
ms.date: 02/25/2025
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
ms.custom:
  - guide
products:
  - azure
categories:
  - management-and-governance
---

# Azure application architecture fundamentals

An application that's designed for cloud-hosted workloads addresses the solution's business requirements and incorporates cloud native components and functionality. A well designed cloud application addresses reliability, security, cost, operations, and performance considerations. These considerations align with the business requirements, the specific characteristics of the cloud hosting platform, and the functionality that the platform provides.

Application design for cloud workloads doesn't require any specific application style, such as microservices. However, cloud hosting makes many application design patterns more approachable than hosting solutions that don't natively offer a diverse selection of application and data platform options, scaling capabilities, security controls, and messaging options. To that end, cloud workloads benefit from applications that are decomposed into smaller, decentralized services by design. These services communicate through APIs or by using asynchronous messaging or eventing. Applications scale horizontally by adding new instances when demand increases.

Applications that use the cloud's application hosting platforms, messaging capabilities, and decomposed services are subject to common concerns for distributed systems. In these systems, the application state is distributed, and operations are performed in parallel and asynchronously. Applications must be resilient when failures occur. Malicious actors continuously target applications. Deployments must be automated and predictable. Monitoring and telemetry are critical for gaining insight into the system.

The following columns list some common characteristics of on-premises design and cloud design.

:::row:::
    :::column:::
        **Typical on-premises design**
        <br>
        - Monolithic and colocated functionality and data
        - Designed for predictable scale or is overprovisioned
        - Relational database
        - Synchronized processing
        - Designed to avoid failures and measures the mean time between failures (MTBF)
        - Resources are provisioned through IT functions
        - Snowflake and pet servers
    :::column-end:::
    :::column:::
        **Typical cloud design**
        <br>
        - Decomposed and distributed functionality and data
        - Designed for elastic scale
        - Polyglot persistence by using a mix of storage technologies
        - Asynchronous processing
        - Designed to withstand malfunctions and measures MTBF
        - Prepared for failure and measures the mean time to repair.
        - Resources are provisioned as needed through infrastructure as code
        - Immutable and replaceable infrastructure
    :::column-end:::
:::row-end:::

## Design applications for Azure

Cloud architects must design applications because they have expertise in cloud hosting and can make strategic tradeoff decisions. Azure provides resources to help architects achieve good design and guide development teams in their implementation. To achieve workload and application design, architects need to:

- [Align to organizational cloud adoption standards](#align-to-organizational-cloud-adoption-standards).
- [Ensure that the design follows the Azure Well-Architected Framework](#follow-the-well-architected-framework).
- Understand typical [architecture styles](#understand-typical-architecture-styles), [workloads](#workloads-in-the-azure-well-architected-framework), and [best practices](#best-practices).
- [Use design patterns to solve common problems and introduce strategic tradeoffs](#use-design-patterns-to-solve-common-problems-and-introduce-strategic-tradeoffs).
- [Make informed technology choices](#make-informed-technology-choices).
- [Evaluate reference architectures](#evaluate-reference-architectures).
- [Review service-specific guides](#review-service-specific-guides).

You can use Azure to host and rehost applications that weren't specifically designed for the cloud. You can adjust workload applications to use cloud functionality, but rehosting an application that is designed for fixed resources and scale isn't considered a cloud-native deployment.

## Align to organizational cloud adoption standards

Your application is part of a workload that likely needs to meet organizational standards and governance. Organizations of any size and cloud maturity can use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) to formalize their Azure-wide adoption strategy, readiness, innovation, management and governance, and security. Part of that approach is to standardize a consistent approach across workloads, such as using [Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/). Azure landing zones provide a blend of organizational-wide governance while giving workload teams and architects democratized access to resources to fulfill localized business objectives. As an architect who designs applications, it's crucial that you understand the macro environment and expectations for workload operations, such as application landing zones.

Your organization's Azure adoption strategy shouldn't affect your architectural style choice, but it might put constraints on technology choices or security boundaries.

## Follow the Well-Architected Framework

You can evaluate any workload's design and implementation through various lenses. Use the Well-Architected Framework to evaluate and align your decisions with design principles across these five key architectural pillars:

- [Reliability](/azure/well-architected/reliability/principles)
- [Security](/azure/well-architected/security/principles)
- [Cost Optimization](/azure/well-architected/cost-optimization/principles)
- [Operational Excellence](/azure/well-architected/operational-excellence/principles)
- [Performance Efficiency](/azure/well-architected/performance-efficiency/principles)

By following these principles and evaluating the tradeoffs between these architectural pillars, you can produce a design that meets business requirements and is sufficiently durable, maintainable, secure, and cost optimized to run in Azure. These decisions should inform your architectural style choice and help narrow your technology choices or security boundaries as they relate to your specific workload's needs.

Your team or organization might have other design principles, such as [sustainability](/azure/well-architected/sustainability/sustainability-get-started) and ethics, that you can use to evaluate your workload.

## Understand typical architecture styles

Once you have an understanding of the organizational environment your application will exist in and you have the general foundation of good architecture design from the Azure Well-Architected Framework, then typically the first decision point is what *kind* of architecture are you building? It might be a microservices architecture, a more traditional N-tier application, or a big data solution. These are distinct architectural styles fit for difference outcomes. While evaluating architectural styles, you're also selecting data store models to address state management. There are benefits and challenges to these decisions.

Evaluate the various [Architecture styles](./architecture-styles/index.md) and the [Data store models](./technology-choices/data-store-overview.md).

### Workloads in the Azure Well-Architected Framework

The Well-Architected Framework has a section devoted to distinct workload classifications or types, called [Azure Well-Architected Framework workloads](/azure/well-architected/workloads). You can find articles covering [mission-critical](/azure/well-architected/mission-critical/mission-critical-overview), [artificial intelligence and machine learning](/azure/well-architected/ai/get-started), or [software as a service (SaaS)](/azure/well-architected/saas/get-started) workloads in this section. These workload-specific articles take the five core pillars of the Well-Architected Framework and apply them to the specific domain. If your application is part of a workload that aligns with one of these documented patterns, review the respective guidance to help you approach your design by following a set of workload-specific design principles and recommendations across common design areas such as application platform, data platform, networking, and more. Some workload types might benefit from selecting a specific architectural style or data store model.

### Best practices

Review the [Best practices in cloud applications](../best-practices/index-best-practices.md) articles to learn about various design considerations including API design, autoscaling, data partitioning, caching, and so forth. Review these and apply the best practices that are appropriate for your application.

## Use design patterns to solve common problems and introduce strategic tradeoffs

Your application has unique business requirements, goals, and success measures. An architect will decompose those functional and nonfunctional requirements into discrete activities that work together to achieve a solution that you and your users are happy with. Those activities are often common enough that they have established patterns used across the software industry. These software design patterns are named and repeatable approaches applied to processing or data storage that are proven to solve specific problems with known tradeoffs.

Azure's [catalog of Cloud design patterns](../patterns/index.md) addresses specific challenges in distributed systems.

## Make well-informed technology choices

After determining the type of architecture you're building and the design patterns you expect to be used, you can start to choose the main technology pieces for the architecture. The following technology choices are critical:

- *Compute* refers to the hosting model for the computing resources (application platform) that your applications run on. For more information, see [Choose a compute service](./technology-choices/compute-decision-tree.yml).

  - Azure also offers specialized guidance for some specific application platforms like [Choose an Azure container service](./choose-azure-container-service.md) and [Azure hybrid options](./technology-choices/hybrid-considerations.yml).

- *Data stores* include databases but also storage for files, caches, logs, and anything else that an application might persist to storage. For more information, see [Choose a data store in Azure](../data-guide/technology-choices/data-store-classification.md) and [Review your storage options](./technology-choices/storage-options.md).

- *Messaging* technologies enable asynchronous messages between components of the system. For more information, see [Choose a messaging service](./technology-choices/messaging.yml).

- *Artificial intelligence (AI)* technologies solve problems that would be computationally complex to implement in traditional application code. To help guide those choices see, [Choose an Azure AI services technology](../data-guide/technology-choices/ai-services.md).

You'll probably make other technology choices along the way, but these four elements (compute, data, messaging, and AI) are central to most cloud applications and determines many aspects of your design.

## Evaluate reference architectures

The Azure Architecture Center is home to solution ideas, example workloads, and reference architectures. These articles typically include the list of common components and considerations aligned to the Azure Well-Architected Framework. Some of these articles include a deployable solution hosted on GitHub. While it's unlikely any of these scenarios are exactly what you're building, they might be a good starting point for you to adapt the guidance to your specific needs.

Browse the [catalog of architectures](/azure/architecture/browse/) here in the Azure Architecture Center.

## Review service-specific guides

Once core technology is selected and reference architectures consulted, it's important to access documentation and guidance that is specific to the services in your architecture. Use the following resources for service-specific guidance.

- **Azure Well-Architected Framework service guides**: The Well-Architected Framework has articles covering many of the services offered in Azure, where the the five pillars of architecture are applied specifically to that service.

  [Find and read the service guide](/azure/well-architected/service-guides/) for all resources that are being considered as part of your application design.

- **Azure reliability guides**: The Azure reliability hub has in-depth articles that specifically address reliability characteristics of many Azure services. These articles document some of the most critical reliability topics such as availability zone support and expected behavior during different types of outages.

  [Find and read the reliability guide](/azure/reliability/overview-reliability-guidance) for all resources that are being considered as part of your application design.

## Coming from another cloud?

If you are familiar with designing applications in another cloud provider, many of the same fundamentals translate. For example, architecture styles and cloud design patterns are conceptually cloud agnostic. Browse through the relevant service mapping and architecture guide articles.

- [Azure for AWS professionals](../aws-professional/index.md)
- [Azure for Google Cloud professionals](../gcp-professional/index.md)

## Next step

> [!div class="nextstepaction"]
> [Architecture styles](./architecture-styles/index.md)

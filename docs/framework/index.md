---
title: Microsoft Azure Well-Architected Framework
titleSuffix: Azure Architecture Center
description: Learn about the five pillars of the Azure Well-Architected Framework and how they can produce a high quality, stable, and efficient cloud architecture.
author: david-stanford 
ms.author: v-stacywray
ms.date: 09/02/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products: azure
categories: management-and-governance
ms.custom:
  - seojan19
  - guide
  - seo-aac-fy21q3
keywords:
  - "Well-architected framework"
  - "Azure Well Architected Framework"
  - "Azure architecture"
  - "architecture framework"
---

# Microsoft Azure Well-Architected Framework

The Azure Well-Architected Framework is a set of guiding tenets that can be used to improve the quality of a workload. The framework consists of five pillars of architectural excellence:

- [Reliability](#reliability)
- [Security](#security)
- [Cost Optimization](#cost-optimization)
- [Operational Excellence](#operational-excellence)
- [Performance Efficiency](#performance-efficiency)

Incorporating these pillars helps produce a high quality, stable, and efficient cloud architecture:

| Pillar | Description |
|--------|-------------|
| [Reliability][resiliency-pillar] | The ability of a system to recover from failures and continue to function. |
| [Security][security-pillar] | Protecting applications and data from threats. |
| [Cost Optimization][cost-pillar] | Managing costs to maximize the value delivered. |
| [Operational Excellence][devops-pillar] | Operations processes that keep a system running in production. |
| [Performance Efficiency][scalability-pillar] | The ability of a system to adapt to changes in load. |

Reference the following video about how to architect successful workloads on Azure with the Well-Architected Framework:


<iframe src="https://channel9.msdn.com/Shows/Azure-Enablement/Architect-successful-workloads-on-Azure--Introduction-Ep-1-Well-Architected-series/player" width="760" height="340" allowFullScreen frameBorder="0" title="Architect successful workloads on Azure - Microsoft Channel 9 Video"></iframe>

## Overview

The following diagram gives a high-level overview of the Azure Well-Architected Framework:

:::image type="content" source="./_images/WAF-diagram.png" alt-text="Well-Architected Framework diagram":::

In the center, is the Well-Architected Framework, which includes the five pillars of architectural excellence. Surrounding the Well-Architected Framework are six supporting elements:

- [Azure Well-Architected Review](/assessments/?mode=pre-assessment&session=local)
- [Azure Advisor](/azure/advisor/)
- [Documentation](/azure/architecture/framework/)
- [Partners](https://azure.microsoft.com/partners/), [Support](https://azure.microsoft.com/support/options/#support-plans), and Services Offers
- [Reference Architectures](/azure/architecture/guide/)
- [Design Principles](/azure/architecture/guide/design-principles/)

### Assessing your workload

To assess your workload using the tenets found in the Microsoft Azure Well-Architected Framework, see the [Microsoft Azure Well-Architected Review](/assessments/?id=azure-architecture-review&mode=pre-assessment).

:::image type="content" source="./_images/WAR-graphic.png" alt-text="Microsoft Azure Well-Architected Review":::

We also recommend you use Azure Advisor and Advisor Score to identify and prioritize opportunities to improve the posture of your workloads. Both services are free to all Azure users and align to the five pillars of the Well-Architected Framework:

- __[Azure Advisor](/azure/advisor/)__ is a personalized cloud consultant that helps you follow best practices to optimize your Azure deployments. It analyzes your resource configuration and usage telemetry. It recommends solutions that can help you improve the reliability, security, cost effectiveness, performance, and operational excellence of your Azure resources. Learn more about [Azure Advisor](/azure/advisor/).

- __[Advisor Score](/azure/advisor/azure-advisor-score)__ is a core feature of Azure Advisor that aggregates Advisor recommendations into a simple, actionable score. This score enables you to tell at a glance if you're taking the necessary steps to build reliable, secure, and cost-efficient solutions, and to prioritize the actions that will yield the biggest improvement to the posture of your workloads. The Advisor score consists of an overall score, which can be further broken down into five category scores corresponding to each of the Well-Architected pillars. Learn more about [Advisor Score](/azure/advisor/azure-advisor-score).

## Reliability

A reliable workload is one that is both resilient and available. [Resiliency](./resiliency/index.yml) is the ability of the system to recover from failures and continue to function. The goal of resiliency is to return the application to a fully functioning state after a failure occurs. Availability is whether your users can access your workload when they need to.

For more information, reference the following video that will show you how to start improving the reliability of your Azure workloads:

<iframe src="https://channel9.msdn.com/Shows/Azure-Enablement/Start-improving-the-reliability-of-your-Azure-workloads--Reliability-Ep-1--Well-Architected-series/player" width="760" height="340" allowFullScreen frameBorder="0" title="Start improving the reliability of your Azure workloads - Microsoft Channel 9 Video"></iframe>

### Reliability guidance

- [Designing reliable Azure applications][resiliency]
- [Design patterns for resiliency](./resiliency/reliability-patterns.md)
- Best practices:
  - [Transient fault handling][transient-fault-handling]
  - [Retry guidance for specific services][retry-service-specific]

For an overview of reliability principles, reference [Principles of the reliability pillar](./resiliency/principles.md).

## Security

Think about [security](./security/index.yml) throughout the entire lifecycle of an application, from design and implementation to deployment and operations. The Azure platform provides protections against various threats, such as network intrusion and DDoS attacks. But you still need to build security into your application and into your DevOps processes.

Ask the right questions about secure application development on Azure by referencing the following video:

<iframe src="https://channel9.msdn.com/Shows/Azure-Enablement/Ask-the-right-questions-about-secure-application-development-on-Azure/player" width="760" height="340" allowFullScreen frameBorder="0" title="Ask the right questions about secure application development on Azure - Microsoft Channel 9 Video"></iframe>

### Security guidance

Consider the following broad security areas:

- [Identity management](./security/overview.md#identity-management)
- [Protecting your infrastructure](./security/overview.md#protecting-your-infrastructure)
- [Application security](./security/overview.md#application-security)
- [Data sovereignty and encryption](./security/overview.md#data-sovereignty-and-encryption)
- [Security resources](./security/overview.md#security-resources)

For more information, reference [Overview of the security pillar](./security/overview.md).

## Cost optimization

When you're designing a cloud solution, focus on generating incremental value early. Apply the principles of **[Build-Measure-Learn](/azure/cloud-adoption-framework/innovate/considerations/)**, to accelerate your time to market while avoiding capital-intensive solutions.

For more information, reference [Cost optimization](./cost/index.yml) and the following video on how to start optimizing your Azure costs:


<iframe src="https://channel9.msdn.com/Shows/Azure-Enablement/Start-optimizing-your-Azure-costs--Cost-Optimization-Ep-1--Well-Architected-series/player" width="760" height="340" allowFullScreen frameBorder="0" title="Start optimizing your Azure costs - Microsoft Channel 9 Video"></iframe>

### Cost guidance

- Review [cost principles](./cost/overview.md)
- [Develop a cost model](./cost/design-model.md)
- Create [budgets and alerts](./cost/monitor-alert.md)
- Review the [cost optimization checklist](./cost/optimize-checklist.md)

For a high-level overview, reference [Overview of the cost optimization pillar](./cost/overview.md).

## Operational excellence

[Operational excellence](./devops/index.yml) covers the operations and processes that keep an application running in production. Deployments must be reliable and predictable. Automate deployments to reduce the chance of human error. Fast and routine deployment processes won't slow down the release of new features or bug fixes. Equally important, you must quickly roll back or roll forward if an update has problems.

Monitoring and diagnostics are crucial. Cloud applications run in a remote data-center where you don't have full control of the infrastructure or, in some cases, the operating system. In a large application, it's not practical to log into VMs to troubleshoot an issue or sift through log files. With PaaS services, there may not even be a dedicated VM to log into. Monitoring and diagnostics give insight into the system, so that you know when and where failures occur. All systems must be observable. Use a common and consistent logging schema that lets you correlate events across systems.

The monitoring and diagnostics process has several distinct phases:

- *Instrumentation*: Generating the raw data from:
  - application logs
  - web server logs
  - diagnostics built into the Azure platform, and other sources
- *Collection and storage*: Consolidating the data into one place.
- *Analysis and diagnosis*: To troubleshoot issues and see the overall health.
- *Visualization and alerts*: Using telemetry data to spot trends or alert the operations team.

Enforcing resource-level rules via [Azure Policy](/azure/governance/policy/overview) helps ensure adoption of operational excellence best practices for all the assets, which support your workload. For example, Azure Policy can help ensure all of the VMs supporting your workload adhere to a pre-approved list of VM SKUs. Azure Advisor provides [a set of Azure Policy recommendations](/azure/advisor/advisor-operational-excellence-recommendations#use-azure-policy-recommendations) to help you quickly identify opportunities to implement Azure Policy best practices for your workload.

Use the [DevOps checklist][devops-checklist] to review your design from a management and DevOps standpoint.

For more information, reference the following video about bringing security into your DevOps practice on Azure:


<iframe src="https://channel9.msdn.com/Shows/Azure-Enablement/DevSecOps-bringing-security-into-your-DevOps-practice-on-Azure/player" width="960" height="540" allowFullScreen frameBorder="0" title="DevSecOps: bringing security into your DevOps practice on Azure - Microsoft Channel 9 Video"></iframe>

### Operational excellence guidance

- [Design patterns for operational excellence](./devops/devops-patterns.md)
- Best practices: [Monitoring and diagnostics][monitoring]

## Performance efficiency

[Performance efficiency](./scalability/index.yml) is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. The main ways to achieve performance efficiency include using scaling appropriately and implementing PaaS offerings that have scaling built in.

There are two main ways that an application can scale. Vertical scaling (scaling *up*) means increasing the capacity of a resource, for example by using a larger VM size. Horizontal scaling (scaling *out*) is adding new instances of a resource, such as VMs or database replicas.

Horizontal scaling has significant advantages over vertical scaling:

- *True cloud scale*: Applications can be designed to run on hundreds or even thousands of nodes, reaching scales that aren't possible on a single node.
- *Horizontal scale is elastic*: You can add more instances if load increases, or remove them during quieter periods.
- Scaling out can be triggered automatically, either on a schedule or in response to changes in load.
- Scaling out may be cheaper than scaling up. Running several small VMs can cost less than a single large VM.
- Horizontal scaling can also improve resiliency, by adding redundancy. If an instance goes down, the application keeps running.

An advantage of vertical scaling is that you can do it without making any changes to the application. But at some point, you'll hit a limit, where you can't scale up anymore. At that point, any further scaling must be horizontal.

Horizontal scale must be designed into the system. For example, you can scale out VMs by placing them behind a load balancer. But each VM in the pool must handle any client request, so the application must be stateless or store state externally (say, in a distributed cache). Managed PaaS services often have horizontal scaling and autoscaling built in. The ease of scaling these services is a major advantage of using PaaS services.

Just adding more instances doesn't mean an application will scale, however. It might push the bottleneck somewhere else. For example, if you scale a web front end to handle more client requests, that might trigger lock contentions in the database. Then, you would need to consider other measures, such as optimistic concurrency or data partitioning, to enable more throughput to the database.

Always conduct performance and load testing to find these potential bottlenecks. The stateful parts of a system, such as databases, are the most common cause of bottlenecks, and require careful design to scale horizontally. Resolving one bottleneck may reveal other bottlenecks elsewhere.

Use the [Performance efficiency checklist](scalability/performance-efficiency.md) to review your design from a scalability standpoint.

For more information, tune in to [Performance Efficiency: Fast & Furious: Optimizing for Quick & Reliable VM Deployments](https://channel9.msdn.com/events/All-Around-Azure/Well-Architected-The-Backstage-Tour/Performance-Efficiency?term=Performance&pubDate=3years&lang-en=true)

:::image type="content" source="./_images/performance-channel-9.png" alt-text="Performance Efficiency":::

### Performance efficiency guidance

- [Design patterns for performance efficiency](./scalability/performance-efficiency-patterns.md)
- Best practices:
  - [Autoscaling][autoscale]
  - [Background jobs][background-jobs]
  - [Caching][caching]
  - [CDN][cdn]
  - [Data partitioning][data-partitioning]

## Next steps

Learn more about:

- [Azure Well-Architected Review](/assessments/?id=azure-architecture-review&mode=pre-assessment)
- [Well-Architected Series](https://channel9.msdn.com/Tags/well-architected-series)
- [Introduction to the Microsoft Azure Well-Architected Framework](/learn/modules/azure-well-architected-introduction/)
- [Azure Security Center](/azure/security-center/)
- [Cloud Adoption Framework](/azure/cloud-adoption-framework/)

<!-- links -->

[identity-ref-arch]: ../reference-architectures/identity/index.yml
[resiliency]: ../framework/resiliency/principles.md
[ad-subscriptions]: /azure/active-directory/active-directory-how-subscriptions-associated-directory
[data-warehouse-encryption]: /azure/data-lake-store/data-lake-store-security-overview#data-protection
[cosmos-db-encryption]: /azure/cosmos-db/database-security
[rbac]: /azure/role-based-access-control/overview
[paired-region]: /azure/best-practices-availability-paired-regions
[resource-manager-auditing]: /azure/azure-resource-manager/resource-group-audit
[security-center]: https://azure.microsoft.com/services/security-center
[security-documentation]: /azure/security
[sql-db-encryption]: /azure/sql-database/sql-database-always-encrypted-azure-key-vault
[storage-encryption]: /azure/storage/storage-service-encryption
[trust-center]: https://azure.microsoft.com/support/trust-center

<!-- patterns -->
[operational-excellence-patterns]: ./devops/devops-patterns.md
[resiliency-patterns]:/azure/architecture//framework/resiliency/reliability-patterns.md
[performance-efficiency-patterns]: ./scalability/performance-efficiency-patterns.md

<!-- practices -->
[autoscale]: ../best-practices/auto-scaling.md
[background-jobs]: ../best-practices/background-jobs.md
[caching]: ../best-practices/caching.md
[cdn]: ../best-practices/cdn.md
[data-partitioning]: ../best-practices/data-partitioning.md
[monitoring]: ../best-practices/monitoring.md
[cost]: /azure/cost-management/cost-mgt-best-practices
[retry-service-specific]: ../best-practices/retry-service-specific.md
[transient-fault-handling]: ../best-practices/transient-faults.md

<!-- checklist -->
[devops-checklist]: ../checklist/dev-ops.md
[scalability-checklist]: ../checklist/performance-efficiency.md

<!-- pillars -->
[cost-pillar]: ./cost/index.yml
[security-pillar]: ./security/index.yml
[resiliency-pillar]: ./resiliency/index.yml
[scalability-pillar]: ./scalability/index.yml
[devops-pillar]: ./devops/index.yml

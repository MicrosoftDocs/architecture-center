---
title: Resiliency and dependencies
description: Examine failure mode analysis (FMA) to build resiliency. Understand the impact of dependencies on failure.
author: v-aangie
ms.date: 02/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# Resiliency and dependencies

Building failure recovery into the system should be part of the architecture and design phases from the beginning to avoid the risk of failure. Dependencies are required for the application to fully operate.

## Key points

- Identify possible failure points in the system with failure mode analysis.
- Eliminate all single point of failure.
- Maintain a complete list of application dependencies.
- Ensure that applications can operate in the absence of their dependencies.
- Understand the SLA of individual components within the system to define reliability targets.

## Build resiliency with failure mode analysis

Failure mode analysis (FMA) is a process for building resiliency into a system, by identifying possible failure points in the system. The FMA should be part of the architecture and design phases, so that you can build failure recovery into the system from the beginning.

Identify all fault-points and fault-modes. Fault-points describe the elements within an application architecture which are capable of failing, while fault-modes capture the various ways by which a fault-point may fail. To ensure an application is resilient to end-to-end failures, it is essential that all fault-points and fault-modes are understood and operationalized. To learn more, see [Failure mode analysis for Azure applications](../../resiliency/failure-mode-analysis.md).

Eliminate all single point of failure. A single point of failure describes a specific fault-point which if it where to fail, would bring down the entire application. Single points of failure introduce significant risk since any failure of this component will cause an application outage. To learn more, see [Make all things redundant](../../guide/design-principles/redundancy.md).

> [!NOTE]
> Eliminate all *singletons*. A singleton describes a logical component within an application for which there can only be a single instance. It can apply to stateful architectural components or application code constructs. Ultimately, singletons introduce a significant risk by creating single points of failure within the application design.

## Understand the impact of dependencies

*Internal* dependencies describe components within the application scope which are required for the application to fully operate. *External* dependencies capture required components outside the scope of the application, such as another application or third-party service. Dependencies may be categorized as either strong or weak based on whether or not the application is able to continue operating in a degraded fashion in their absence. To learn more, see [Twelve-Factor App: Dependencies](https://12factor.net/dependencies).

You should maintain a complete list of application dependencies. Examples of typical dependencies include platform dependencies outside the remit of the application, such as Azure Active Directory, Express Route, or a central NVA (Network Virtual Appliance), as well as application dependencies such as APIs. For cost purposes, it's important to understand the price for these services and how they are being charged. For more details see [Cost models](../cost/design-model.md).

You can map application dependencies either as a simple list or a document. Usually this is part of a design document or reference architecture.

**Understand the impact of an outage with each dependency.** Strong dependencies play a critical role in application function and availability. Their absence will have a significant impact, while the absence of weak dependencies may only impact specific features and not affect overall availability. This reflects the cost that is needed to maintain the High Availability relationship between the service and its dependencies. Classifying dependencies as either strong or weak will help you identify which components are essential to the application.

**Maintain SLAs and support agreements for critical dependencies.** A Service Level Agreement (SLA) represents a commitment around performance and availability of the application. Understanding the SLA of individual components within the system is essential in order to define reliability targets. Knowing the SLA of dependencies will also provide a justification for additional spend when making the dependencies highly available and with proper support contracts. The operational commitments of all external and internal dependencies should be understood to inform the broader application operations and health model.

The usage of platform level dependencies such as Azure Active Directory must also be understood to ensure that their availability and recovery targets align with that of the application

**Ensure that applications can operate in the absence of their dependencies.** If the application has strong dependencies which it cannot operate in the absence of, then the availability and recovery targets of these dependencies should align with that of the application itself. Make an effort to minimize dependencies to achieve control over application reliability. To learn more, see [Minimize dependencies](../../guide/design-principles/minimize-coordination.md).

**Ensure that the lifecycle of the application decoupled from its dependencies.** If the application lifecycle is closely coupled with that of its dependencies, it can limit the operational agility of the application. This is true particularly where new releases are concerned.

## Next step

> [!div class="nextstepaction"]
> [Best practices](./design-best-practices.md)

## Related links

- For information on failure mode analysis, see [Failure mode analysis for Azure applications](../../resiliency/failure-mode-analysis.md).
- For information on single point of failure, see [Make all things redundant](../../guide/design-principles/redundancy.md).
- For information on fault-points and fault-modes, see [Failure Mode Analysis for Azure applications](../../resiliency/failure-mode-analysis.md).
- For information on minimizing dependencies, see [Minimize coordination](../../guide/design-principles/minimize-coordination.md).

Go back to the main article: [Design](design-checklist.md)

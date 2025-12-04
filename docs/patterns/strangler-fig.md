---
title: Strangler Fig Pattern
description: Learn how to incrementally migrate a legacy system by gradually replacing specific pieces of functionality with new applications and services.
author: OvaisMehboob
ms.author: ovmehboo
ms.date: 02/13/2025
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Strangler Fig pattern

This pattern incrementally migrates a legacy system by gradually replacing specific pieces of functionality with new applications and services. As you replace features from the legacy system, the new system eventually comprises all of the old system's features. This approach suppresses the old system so that you can decommission it.

## Context and problem

As systems age, the development tools, hosting technology, and system architectures that they're built on can become obsolete. As new features and functionality are added, these applications become more complex, which can make them harder to maintain or extend.

Replacing an entire complex system is a huge undertaking. Instead, many teams prefer to migrate to a new system gradually and keep the old system to handle unmigrated features. However, running two separate versions of an application forces clients to track which version has individual features. Every time teams migrate a feature or service, they must direct clients to the new location. To overcome these challenges, you can adopt an approach that supports incremental migration and minimizes disruptions to clients.

## Solution

Use an incremental process to replace specific pieces of functionality with new applications and services. Customers can continue using the same interface, unaware that this migration is taking place.

:::image type="content" border="false" source="./_images/strangler.png" alt-text="Diagram of the Strangler Fig pattern." lightbox="./_images/strangler.png":::

The Strangler Fig pattern provides a controlled and phased approach to modernization. It allows the existing application to continue functioning during the modernization effort. A façade (proxy) intercepts requests that go to the back-end legacy system. The façade routes these requests either to the legacy application or to the new services. 

This pattern reduces risks in migration by enabling your teams to move forward at a pace that suits the complexity of the project. As you migrate functionality to the new system, the legacy system becomes obsolete, and you decommission the legacy system.

1. The Strangler Fig pattern begins by introducing a façade (proxy) between the client app, the legacy system, and the new system. The façade acts as an intermediary. It allows the client app to interact with the legacy system and the new system. Initially, the façade routes most requests to the legacy system.

1. As the migration progresses, the façade incrementally shifts requests from the legacy system to the new system. With each iteration, you implement more pieces of functionality in the new system. 

   This incremental approach gradually reduces the legacy system's responsibilities and expands the scope of the new system. The process is iterative. It allows the team to address complexities and dependencies in manageable stages. These stages help the system remain stable and functional.

1. After you migrate all of the functionality and there are no dependencies on the legacy system, you can decommission the legacy system. The façade routes all requests exclusively to the new system.

1. You remove the façade and reconfigure the client app to communicate directly with the new system. This step marks the completion of the migration.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- Consider how to handle services and data stores that both the new system and the legacy system might use. Make sure that both systems can access these resources at the same time.

- Structure new applications and services so that you can easily intercept and replace them in future strangler fig migrations. For example, strive to have clear demarcations between parts of your solution so that you can migrate each part individually.

- After the migration is complete, you typically remove the strangler fig façade. Alternatively, you can maintain the façade as an adaptor for legacy clients to use while you update the core system for newer clients.

- Make sure that the façade keeps up with the migration.

- Make sure that the façade doesn't become a single point of failure or a performance bottleneck.

## When to use this pattern

Use this pattern when:

- You gradually migrate a back-end application to a new architecture, especially when replacing large systems, key components, or complex features introduces risk.

- The original system can continue to exist for an extended period of time during the migration effort.

This pattern might not be suitable when:

- Requests to the back-end system can't be intercepted.

- You migrate a small system and replacing the whole system is simple.

- You need to fully decommission the original solution quickly.

## Workload design

Evaluate how to use the Strangler Fig pattern in a workload's design to address the goals and principles of the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
|:---|:---|
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and to ensure that it **recovers** to a fully functioning state after a failure occurs. | This pattern's incremental approach can help mitigate risks during a component transition compared to making large systemic changes all at once.<br/><br/> - [RE:08 Testing](/azure/well-architected/reliability/testing-strategy) |
| [Cost Optimization](/azure/well-architected/cost-optimization/checklist) focuses on **sustaining and improving** your workload's **return on investment (ROI)**. | The goal of this approach is to maximize the use of existing investments in the currently running system while modernizing incrementally. It enables you to perform high-ROI replacements before low-ROI replacements.<br/><br/> - [CO:07 Component costs](/azure/well-architected/cost-optimization/optimize-component-costs)<br/> - [CO:08 Environment costs](/azure/well-architected/cost-optimization/optimize-environment-costs) |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | This pattern provides a continuous improvement approach. Incremental replacements that make small changes over time are preferable to large systemic changes that are riskier to implement.<br/><br/> - [OE:06 Supply chain for workload development](/azure/well-architected/operational-excellence/workload-supply-chain)<br/> - [OE:11 Safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments) |

Consider any trade-offs against the goals of the other pillars that this pattern might introduce.

## Example

Legacy systems typically depend on a centralized database. Over time, a centralized database can become difficult to manage and evolve because of its many dependencies. To address these challenges, various database patterns can facilitate the transition away from such legacy systems. The Strangler Fig pattern is one of these patterns. Apply the Strangler Fig pattern as a phased approach to gradually transition from a legacy system to a new system and minimize disruption.

:::image type="content" border="false" source="./_images/strangler-fig-database.png" alt-text="Diagram of the Strangler Fig pattern applied to a database." lightbox="./_images/strangler-fig-database.png":::

1. You introduce a new system, and the new system starts handling some requests from the client app. However, the new system still depends on the legacy database for all read and write operations. The legacy system remains operational, which facilitates a smooth transition without immediate structural changes.

1. In the next phase, you introduce a new database. You migrate data load history to the new database by using an extract, transform, and load (ETL) process. The ETL process synchronizes the new database with the legacy database. During this phase, the new system performs shadow writes. The new system updates both databases in parallel. The new system continues to read from the legacy database to validate consistency.

1. Finally, the new database becomes the system of record. The new database takes over all read and write operations. You can start deprecating the legacy database and legacy system. After you validate the new database, you can retire the legacy database. This retirement completes the migration process with minimal disruption.

## Next step

Read Martin Fowler's blog post about [Strangler Fig pattern application](https://martinfowler.com/bliki/StranglerFigApplication.html).

## Related resource

[Messaging Bridge pattern](./messaging-bridge.yml)

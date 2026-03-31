---
title: Compute Resource Consolidation Pattern
description: Use the Compute Resource Consolidation design pattern to consolidate multiple tasks or operations into one computational unit.
author: claytonsiemens77
ms.author: pnp
ms.date: 04/08/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# Compute resource consolidation pattern

Consolidate multiple tasks or operations into one computational unit. This pattern can increase compute resource utilization and reduce the costs and management overhead associated with compute processing in cloud-hosted applications.

## Context and problem

A cloud application often implements different types of operations. You can organize these operations into separate computational units that are hosted and deployed individually. For example, you can keep different Azure App Service web apps or virtual machines separate from each other. This strategy can help to simplify the design of the solution, but if you deploy a large number of computational units as part of the same application, this deployment can increase runtime hosting costs and make system management more complex.

The following figure shows the simplified structure of a cloud-hosted solution that's implemented by using more than one computational unit. Each computational unit runs in its own virtual environment. Each function is implemented as a separate task that runs in its own computational unit.

:::image type="complex" source="./_images/compute-resource-consolidation-diagram.png" alt-text="Diagram that shows tasks that are using a set of dedicated computational units in a cloud environment." lightbox="./_images/compute-resource-consolidation-diagram.png" border="false":::
  Diagram that shows a large blue cloud-shaped environment that contains five separate computational units distributed across the image. Each computational unit is located above its own task. The tasks are labeled task A to task E. There are no connecting lines or shared containers between tasks. The diagram shows a one-to-one relationship between each computational unit and each task within the same cloud-hosted solution.
:::image-end:::

Each computational unit consumes chargeable resources even when it's idle or lightly used. This approach isn't always the most cost-effective solution.

## Solution

To help reduce costs, increase utilization, improve communication speed, and reduce management, it's possible to consolidate multiple tasks or operations into a single computational unit.

Tasks can be grouped according to criteria based on the features provided by the environment and the costs associated with these features. It's common to look for tasks that have similar scalability, lifetime, and processing requirements. To scale the tasks as a unit, you can group them together. Many cloud environments offer elasticity so that additional instances of a computational unit can be started and stopped depending on the workload. For example, Azure provides autoscaling that you can apply to App Service and Azure Virtual Machine Scale Sets.

You can also use scalability to determine which operations you shouldn't group together. Consider the following two tasks:

- Task 1 polls a queue of infrequent, time-insensitive messages.
- Task 2 handles high-volume bursts of network traffic.

Task 2 requires elasticity to start and stop a large number of compute instances. If you apply the same scaling behavior to Task 1, more resource is deployed to listen to its infrequent, nonurgent messages, which is a waste of resources.

In many cloud environments, it's possible to specify the resources available to a computational unit, such as the number of CPU cores, memory, and disk space. If you specify more resources, the solution usually becomes more expensive. To save money, it's important to maximize the work an expensive computational unit performs and not let it become inactive.

If there are tasks that require a great deal of CPU power in short bursts, you might consolidate these tasks into a single computational unit that provides the necessary power. However, it's important to balance this need to keep expensive resources busy against the contention that could occur if they're stressed. For example, long-running, compute-intensive tasks shouldn't share the same computational unit.

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- **Scalability and elasticity:** Many cloud solutions implement computational unit scalability and elasticity by starting and stopping instances of units. Try not to group tasks that have conflicting scalability requirements in the same computational unit.

- **Lifetime:** The cloud infrastructure periodically recycles the virtual environment that hosts a computational unit. If there are many long-running tasks inside a computational unit, you might need to prevent the virtual environment from being recycled until these tasks are completed. Alternatively, use a checkpointing approach that enables the tasks to stop cleanly and continue from where they were interrupted when the computational unit is restarted.

- **Release cadence:** If the implementation or configuration of a task changes frequently, you might need to stop the computational unit that hosts the updated code, then reconfigure and redeploy the unit, and then restart it. All other tasks within the same computational unit must be stopped, redeployed, and restarted.

- **Security:** Tasks in the same computational unit might share the same security context and might be able to access the same resources. However, there must be a high degree of trust between the tasks, and you must be confident that one task isn't going to corrupt or adversely affect another. Additionally, if you increase the number of tasks that are running in a computational unit, this increases the attack surface of the unit. Each task is only as secure as the task with the most vulnerabilities.

- **Fault tolerance:** If one task in a computational unit fails or behaves abnormally, it can affect the other tasks in the same unit. For example, if one task fails to start correctly it can cause the entire startup logic for the computational unit to fail, and it can prevent other tasks in the same unit from running.

- **Contention:** Avoid contention between tasks that compete for resources in the same computational unit. Tasks that share the same computational unit should exhibit different resource utilization characteristics. For example, two compute-intensive tasks shouldn't reside in the same computational unit and neither should two tasks that consume large amounts of memory. However, you can mix a compute-intensive task with a task that requires a large amount of memory.

> [!NOTE]
> Consider consolidating compute resources only for systems that are already in production, so that operators and developers can monitor the system and create a *heat map* that identifies how each task uses resources. This map can be used to determine which tasks are good candidates for sharing compute resources.

- **Complexity:** When you combine multiple tasks into a single computational unit, this adds complexity to the code in the unit, which might make it more difficult to test, debug, and maintain.

- **Stable logical architecture:** Design and implement the code in each task so that it shouldn't need to change, even if the physical environment the task runs in does change.

- **Other strategies:** Consolidation is only one way to help reduce the costs associated with running multiple tasks concurrently. It requires careful planning and monitoring to ensure that it remains an effective approach. Other strategies might be more appropriate, depending on the nature of the work and where the users of the tasks are located.

## When to use this pattern

Use this pattern when:

- Tasks aren't cost effective if they run in their own computational units.
- A task is often idle.
- It would be expensive to run a task in a dedicated unit.

This pattern might not be suitable when:

- Tasks perform critical fault-tolerant operations.
- Tasks process highly sensitive or private data and require their own security context.
- Tasks need to run in their own isolated environment in a separate computational unit.

## Workload design

Evaluate how to use the compute resource consolidation pattern in a workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Cost Optimization](/azure/well-architected/cost-optimization/checklist) focuses on **sustaining and improving** your workload's **return on investment.** | This pattern maximizes the utilization of compute resources by avoiding unused provisioned capacity via aggregation of components or even whole workloads on a pooled infrastructure.<br/><br/> - [CO:14 Consolidation](/azure/well-architected/cost-optimization/consolidation) |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | Consolidation can lead to a more homogeneous compute platform, which can simplify management and observability, reduce disparate approaches to operational tasks, and reduce the amount of tooling required.<br/><br/> - [OE:07 Monitoring system](/azure/well-architected/operational-excellence/observability)<br/> - [OE:10 Automation design](/azure/well-architected/operational-excellence/enable-automation) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | Consolidation reduces overprovisioning and maximizes compute resource utilization by using spare node capacity. Large (vertically scaled) compute instances are often used in the resource pool for these infrastructures.<br/><br/> - [PE:02 Capacity planning](/azure/well-architected/performance-efficiency/capacity-planning)<br/> - [PE:03 Selecting services](/azure/well-architected/performance-efficiency/select-services) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

This pattern can be deployed in different ways, depending on the compute service you use. For example:

- **App Service** and **Azure Functions:** Deploy shared App Service plans, which represent the hosting server infrastructure. One or more apps can be configured to run on the same compute resources or in the same App Service plan.

- **Azure Container Apps:** Deploy Container Apps to the same shared environments, especially if you need to manage related services or you need to deploy different applications to the same virtual network.

- **Azure Kubernetes Service (AKS):** AKS is a container-based hosting infrastructure in which multiple applications or application components can be configured to run colocated on the same compute resources (nodes), grouped by computational requirements, such as CPU or memory needs (node pools).

- **Virtual machines:** Deploy a single set of virtual machines for all tenants to use so that management costs are shared across the tenants. Virtual Machine Scale Sets supports shared resource management, load-balancing, and horizontal scaling of virtual machines.

- **Consumption-based compute (serverless):** Use fully managed, pay‑per‑execution compute models with scale‑to‑zero, such as Functions (Consumption plan) and Azure Container Apps, to run multiple independent workloads on a shared global pool of compute resources. These platforms automatically allocate and release compute so that multiple applications can benefit from elastic scaling and cost efficiency without a dedicated infrastructure.

## Next steps

- [Microsoft Azure Well-Architected Framework - Cost optimization](/azure/well-architected/cost-optimization/)

## Related resources

- [Sharding](./sharding.yml)
- [Choose an Azure compute service](../guide/technology-choices/compute-decision-tree.md)
- [Architectural approaches for compute in multitenant solutions](../guide/multitenant/approaches/compute.md#compute-resource-consolidation-pattern)
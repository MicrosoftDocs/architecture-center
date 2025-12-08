Consolidate multiple tasks or operations into a single computational unit. This can increase compute resource utilization, and reduce the costs and management overhead associated with performing compute processing in cloud-hosted applications.

## Context and problem

A cloud application often implements different types of operations. In some solutions it makes sense to follow the design principle of separation of concerns initially, and divide these operations into separate computational units that are hosted and deployed individually (for example, as separate App Service web apps or separate Virtual Machines). However, although this strategy can help simplify the logical design of the solution, deploying a large number of computational units as part of the same application can increase runtime hosting costs and make management of the system more complex.

As an example, the figure shows the simplified structure of a cloud-hosted solution that is implemented using more than one computational unit. Each computational unit runs in its own virtual environment. Each function has been implemented as a separate task (labeled Task A through Task E) running in its own computational unit.

![Running tasks in a cloud environment using a set of dedicated computational units](./_images/compute-resource-consolidation-diagram.png)

Each computational unit consumes chargeable resources, even when it's idle or lightly used. Therefore, this isn't always the most cost-effective solution.

In Azure, this concern applies to App Services, Container Apps, and Virtual Machines. These items run in their own environment. Running a collection of separate websites, microservices, or virtual machines that are designed to perform a set of well-defined operations, but that need to communicate and cooperate as part of a single solution, can be an inefficient use of resources.

## Solution

To help reduce costs, increase utilization, improve communication speed, and reduce management it's possible to consolidate multiple tasks or operations into a single computational unit.

Tasks can be grouped according to criteria based on the features provided by the environment and the costs associated with these features. A common approach is to look for tasks that have a similar profile concerning their scalability, lifetime, and processing requirements. Grouping these together allows them to scale as a unit. The elasticity provided by many cloud environments enables additional instances of a computational unit to be started and stopped according to the workload. For example, Azure provides autoscaling that you can apply to App Services and Virtual Machine Scale Sets. For more information, see [Autoscaling Guidance](/previous-versions/msp-n-p/dn589774(v=pandp.10)).

As a counter example to show how scalability can be used to determine which operations shouldn't be grouped together, consider the following two tasks:

- Task 1 polls for infrequent, time-insensitive messages sent to a queue.
- Task 2 handles high-volume bursts of network traffic.

The second task requires elasticity that can involve starting and stopping a large number of instances of the computational unit. Applying the same scaling to the first task results in more tasks listening for infrequent messages on the same queue, and is a waste of resources.

In many cloud environments it's possible to specify the resources available to a computational unit in terms of the number of CPU cores, memory, disk space, and so on. Generally, the more resources specified, the greater the cost. To save money, it's important to maximize the work an expensive computational unit performs, and not let it become inactive for an extended period.

If there are tasks that require a great deal of CPU power in short bursts, consider consolidating these into a single computational unit that provides the necessary power. However, it's important to balance this need to keep expensive resources busy against the contention that could occur if they are over stressed. Long-running, compute-intensive tasks shouldn't share the same computational unit, for example.

## Issues and considerations

Consider the following points when implementing this pattern:

**Scalability and elasticity**. Many cloud solutions implement scalability and elasticity at the level of the computational unit by starting and stopping instances of units. Avoid grouping tasks that have conflicting scalability requirements in the same computational unit.

**Lifetime**. The cloud infrastructure periodically recycles the virtual environment that hosts a computational unit. When there are many long-running tasks inside a computational unit, it might be necessary to configure the unit to prevent it from being recycled until these tasks have finished. Alternatively, design the tasks by using a check-pointing approach that enables them to stop cleanly, and continue at the point they were interrupted when the computational unit is restarted.

**Release cadence**. If the implementation or configuration of a task changes frequently, it might be necessary to stop the computational unit hosting the updated code, reconfigure and redeploy the unit, and then restart it. This process will also require that all other tasks within the same computational unit are stopped, redeployed, and restarted.

**Security**. Tasks in the same computational unit might share the same security context and be able to access the same resources. There must be a high degree of trust between the tasks, and confidence that one task isn't going to corrupt or adversely affect another. Additionally, increasing the number of tasks running in a computational unit increases the attack surface of the unit. Each task is only as secure as the one with the most vulnerabilities.

**Fault tolerance**. If one task in a computational unit fails or behaves abnormally, it can affect the other tasks running within the same unit. For example, if one task fails to start correctly it can cause the entire startup logic for the computational unit to fail, and prevent other tasks in the same unit from running.

**Contention**. Avoid introducing contention between tasks that compete for resources in the same computational unit. Ideally, tasks that share the same computational unit should exhibit different resource utilization characteristics. For example, two compute-intensive tasks should probably not reside in the same computational unit, and neither should two tasks that consume large amounts of memory. However, mixing a compute-intensive task with a task that requires a large amount of memory is a workable combination.

> [!NOTE]
> Consider consolidating compute resources only for a system that's been in production for a period of time so that operators and developers can monitor the system and create a *heat map* that identifies how each task uses differing resources. This map can be used to determine which tasks are good candidates for sharing compute resources.

**Complexity**. Combining multiple tasks into a single computational unit adds complexity to the code in the unit, possibly making it more difficult to test, debug, and maintain.

**Stable logical architecture**. Design and implement the code in each task so that it shouldn't need to change, even if the physical environment the task runs in does change.

**Other strategies**. Consolidating compute resources is only one way to help reduce costs associated with running multiple tasks concurrently. It requires careful planning and monitoring to ensure that it remains an effective approach. Other strategies might be more appropriate, depending on the nature of the work and where the users these tasks are running are located. For example, functional decomposition of the workload (as described by the [Compute Partitioning Guidance](/previous-versions/msp-n-p/dn589773(v=pandp.10))) might be a better option.

## When to use this pattern

Use this pattern for tasks that are not cost effective if they run in their own computational units. If a task spends much of its time idle, running this task in a dedicated unit can be expensive.

This pattern might not be suitable for tasks that perform critical fault-tolerant operations, or tasks that process highly sensitive or private data and require their own security context. These tasks should run in their own isolated environment, in a separate computational unit.

## Workload design

An architect should evaluate how the Compute Resource Consolidation pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Cost Optimization](/azure/well-architected/cost-optimization/checklist) is focused on **sustaining and improving** your workload's **return on investment**. | This pattern maximizes the utilization of computing resources by avoiding unused provisioned capacity via aggregation of components or even whole workloads on a pooled infrastructure.<br/><br/> - [CO:14 Consolidation](/azure/well-architected/cost-optimization/consolidation) |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | Consolidation can lead to a more homogeneous compute platform, which can simplify management and observability, reduce disparate approaches to operational tasks, and reduce the amount of tooling that's required.<br/><br/> - [OE:07 Monitoring system](/azure/well-architected/operational-excellence/observability)<br/> - [OE:10 Automation design](/azure/well-architected/operational-excellence/enable-automation) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, code. | Consolidation maximizes the utilization of computing resources by using spare node capacity and reducing the need for overprovisioning. Large (vertically scaled) compute instances are often used in the resource pool for these infrastructures.<br/><br/> - [PE:02 Capacity planning](/azure/well-architected/performance-efficiency/capacity-planning)<br/> - [PE:03 Selecting services](/azure/well-architected/performance-efficiency/capacity-planning) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Application platform choices

This pattern can be achieved in different ways, depending on the compute service you use. See the following example services:

- **Azure App Service** and **Azure Functions**: Deploy shared App Service plans, which represent the hosting server infrastructure. One or more apps can be configured to run on the same computing resources (or in the same App Service plan).
- **Azure Container Apps**: Deploy container apps to the same shared environments; especially in situations when you need to manage related services or you need to deploy different applications to the same virtual network.
- **Azure Kubernetes Service (AKS)**: AKS is a container-based hosting infrastructure in which multiple applications or application components can be configured to run co-located on the same computing resources (nodes), grouped by computational requirements such as CPU or memory needs (node pools).
- **Virtual machines**: Deploy a single set of virtual machines for all tenants to use, that way the management costs are shared across the tenants. Virtual Machine Scale Sets is a feature that supports shared resource management, load-balancing, and horizontal scaling of Virtual Machines.

## Related resources

The following patterns and guidance might also be relevant when implementing this pattern:

- [Autoscaling Guidance](/previous-versions/msp-n-p/dn589774(v=pandp.10)). Autoscaling can be used to start and stop instances of service hosting computational resources, depending on the anticipated demand for processing.

- [Compute Partitioning Guidance](/previous-versions/msp-n-p/dn589773(v=pandp.10)). Describes how to allocate the services and components in a cloud service in a way that helps to minimize running costs while maintaining the scalability, performance, availability, and security of the service.

- [Architectural approaches for compute in multitenant solutions](/azure/architecture/guide/multitenant/approaches/compute#compute-resource-consolidation-pattern). Provides guidance about the considerations and requirements that are essential for solution architects, when they're planning the compute services of a multitenant solution.

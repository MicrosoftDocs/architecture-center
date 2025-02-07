Incrementally migrate a legacy system by gradually replacing specific pieces of functionality with new applications and services. As features from the legacy system are replaced, the new system eventually replaces all of the old system's features, strangling the old system and allowing you to decommission it.

## Context and problem

As systems age, the development tools, hosting technology, and even system architectures they were built on can become obsolete. As new features and functionality are added, the complexity of these applications can increase, making them harder to maintain or extend.

Replacing an entire complex system is a huge undertaking. Instead, many teams prefer to migrate to a new system gradually while keeping the old system to handle unmigrated features. However, running two separate versions of an application forces clients to track the locations of individual features. Every time teams migrate a feature or service, they must direct clients to the new location. To overcome these challenges, adopt an approach that supports incremental migration while minimizing disruptions to clients. 


## Solution

The Strangler Fig pattern enables a gradual transition from a legacy system to a new system. It provides a controlled and phased approach to modernization, and it allows the existing application to continue functioning throughout the modernization effort. The pattern reduces risks in migration by enabling teams to move forward at a pace that suits the complexity of the project. As you migrate functionality to the new system, the legacy system becomes obsolete, and you decommission the legacy system. 

 ![Diagram of the Strangler Fig pattern](./_images/strangler-fig.png)

1. The Strangler Fig pattern begins by introducing a Strangler Facade (proxy) between the client app, the legacy system, and the new system. The Strangler Facade (proxy) acts as an intermediary. It allows the client app to interact with the legacy system and the new system. Initially, the Strangler Facade (proxy) routes most requests to the legacy system.

2. As the migration progresses, the Strangler Facade incrementally shifts requests from the legacy system to the new system. With each iteration, you implement additional pieces of functionality in the new system. This incremental approach enables a gradual reduction in the legacy system responsibilities while expanding the scope of the new system. The process is iterative. It allows the team to address complexities and dependencies in manageable stages. These stages help the system remain stable and functional.

3. Once you migrate all the functionality and there are no dependencies on the legacy system, you can decommission the legacy system. The Strangler Facade (proxy) routes all requests exclusively to the new system.

4. You remove the Strangler Facade (proxy) and reconfigure the client app to communicate directly with the new system. This marks the completion of the migration.


## Strangler Fig pattern applied to datastore migrations

Legacy systems often depend on a centralized database. Over time, a centralized database can become difficult to manage and evolve because of its many dependencies. To address these challenges, there are various database patterns to facilitate the transition away from such legacy systems. The Strangler Fig pattern is one of these patterns. The Strangler Fig pattern for database migration follows a phased approach to gradually transition from a legacy system to a new system while minimizing disruption.

 ![Diagram of the Strangler Fig pattern](./_images/strangler-fig-db.png)

1. You introduce a new system, and the new system starts handling some requests from the client app. However, the new system still relies on the legacy database for all read and write operations. The legacy system remains operational, which facilitates a smooth transition without immediate structural changes.

In the next phase, a new database is introduced, and historical data is migrated using an ETL (Extract, Transform, Load) process to synchronize it with the legacy database (Step 2). During this phase, the new system performs shadow writes, updating both databases in parallel while continuing to read from the legacy database to validate consistency.

Finally, the new system database becomes the SOR (System of Record), taking over all read and write operations (Step 3), while the legacy database and system are deprecated. Once validated, the legacy system database is fully retired, completing the migration process with minimal disruption.

## Issues and considerations

* Consider how to handle services and data stores that are potentially used by both new and legacy systems. Make sure both can access these resources side-by-side.
* Structure new applications and services in a way that they can easily be intercepted and replaced in future strangler fig migrations. For example, strive to have clear demarcations between parts of your solution so that you can migrate each part individually.
* At some point, when the migration is complete, the strangler fig façade will probably go away. Alternatively, you can maintain the façade as an adaptor for legacy clients to use while you update the core system for newer clients.
* Make sure the façade keeps up with the migration.
* Make sure the façade doesn't become a single point of failure or a performance bottleneck.

## When to use this pattern

Use this pattern when gradually migrating a back-end application to a new architecture.

This pattern may not be suitable:

* When requests to the back-end system cannot be intercepted.
* For smaller systems where the complexity of wholesale replacement is low.

## Workload design

An architect should evaluate how the Strangler Fig pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
|:---|:---|
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and to ensure that it **recovers** to a fully functioning state after a failure occurs. | This pattern's incremental approach can help mitigate risks during a component transition vs large systemic changes.<br/><br/> - [RE:08 Testing](/azure/well-architected/reliability/testing-strategy) |
| [Cost Optimization](/azure/well-architected/cost-optimization/checklist) is focused on **sustaining and improving** your workload's **return on investment**. | The goal of this approach is to maximize the use of existing investments in the currently running system while modernizing incrementally, as such it enables you to perform high-ROI replacements before low-ROI replacements.<br/><br/> - [CO:07 Component costs](/azure/well-architected/cost-optimization/optimize-component-costs)<br/> - [CO:08 Environment costs](/azure/well-architected/cost-optimization/optimize-environment-costs) |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | This pattern provides a continuous improvement approach, in which incremental replacement with small changes over time is preferred rather than large systemic changes that are riskier to implement.<br/><br/> - [OE:06 Workload development](/azure/well-architected/operational-excellence/workload-supply-chain)<br/> - [OE:11 Safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Next steps

* Martin Fowler's blog post on [StranglerFigApplication](https://martinfowler.com/bliki/StranglerFigApplication.html)

## Related resources

* [Messaging Bridge pattern](./messaging-bridge.yml)


Command Query Responsibility Segregation (CQRS) is a design pattern that segregates read and write operations for a data store into separate data models. This allows each model to be optimized independently and can improve performance, scalability, and security of an application.

## Context and problem

In traditional architectures, a single data model is often used for both read and write operations.  This approach is straightforward and works well for basic CRUD operations (*see figure 1*).

![Diagram that shows a traditional CRUD architecture.](./_images/command-and-query-responsibility-segregation-cqrs-tradition-crud.png)<br>
*Figure 1. A traditional CRUD architecture.*

However, as applications grow, optimizing read and write operations on a single data model becomes increasingly challenging. Read and write operations often have different performance and scaling needs. A traditional CRUD architecture doesn't account for this asymmetry. It leads to several challenges:

- **Data mismatch:** The read and write representations of data often differ. Some fields required during updates might be unnecessary during reads.

- **Lock contention:** Parallel operations on the same data set can cause lock contention.

- **Performance issues:** The traditional approach can have a negative effect on performance due to load on the data store and data access layer, and the complexity of queries required to retrieve information.

- **Security concerns:** Managing security becomes difficult when entities are subject to read and write operations. This overlap can expose data in unintended contexts.

Combining these responsibilities can result in an overly complicated model that tries to do too much.

## Solution

Use the CQRS pattern to separate write operations (**commands**) from read operations (**queries**). Commands are responsible for updating data.

**Understand commands.** Commands should represent specific business tasks rather than low-level data updates. For example, in a hotel-booking app, use "Book hotel room" instead of "Set ReservationStatus to Reserved." This approach better reflects the intent behind user actions and aligns commands with business processes. To ensure commands are successful, you might need to refine the user interaction flow, server-side logic, and consider asynchronous processing.

| Area of refinement  | Recommendation |
|---------|----------------|
| Client-side validation  | Validate certain conditions before sending the command to prevent obvious failures. For example, if no rooms are available, disable the "Book" button and provide a clear, user-friendly message in the UI explaining why booking isn’t possible. This setup reduces unnecessary server requests and provides immediate feedback to users, enhancing their experience. |
| Server-side logic | Enhance the business logic to handle edge cases and failures gracefully. For example, to address race conditions (multiple users attempting to book the last available room), consider adding users to a waiting list or suggesting alternative options. |
| Asynchronous processing | You can also [process commands asynchronously](/dotnet/architecture/microservices/architect-microservice-container-applications/asynchronous-message-based-communication) by placing them on a queue, rather than handling them synchronously. |

**Understand queries.** Queries never alter data. Instead, they return Data Transfer Objects (DTOs) that present the required data in a convenient format, without any domain logic. This clear separation of concerns simplifies the design and implementation of the system.

### Understand read and write model separation

Separating the read model from the write model simplifies system design and implementation by addressing distinct concerns for data writes and reads. This separation improves clarity, scalability, and performance but introduces some trade-offs. For example, scaffolding tools like O/RM frameworks can't automatically generate CQRS code from a database schema, requiring custom logic for bridging the gap.

The following sections explore two primary approaches to implementing read and write model separation in CQRS. Each approach comes with unique benefits and challenges, such as synchronization and consistency management.

#### Separation of models in a single data store

This approach represents the foundational level of CQRS, where both the read and write models share a single underlying database but maintain distinct logic for their operations. By defining separate concerns, this strategy enhances simplicity while delivering benefits in scalability and performance for typical use cases. A basic CQRS architecture allows you to delineate the write model from the read model while relying on a shared data store (*see figure 2*).

![Diagram that shows a basic CQRS architecture.](./_images/command-and-query-responsibility-segregation-cqrs-basic.png)<br>
*Figure 2. A basic CQRS architecture with a single data store.*

This approach improves clarity, performance, and scalability by defining distinct models for handling write and read concerns:

- **Write model:** Designed to handle commands that update or persist data. It includes validation, domain logic, and ensures data consistency by optimizing for transactional integrity and business processes.

- **Read model:** Designed to serve queries for retrieving data. It focuses on generating DTOs (data transfer objects) or projections optimized for the presentation layer. It enhances query performance and responsiveness by avoiding domain logic.

#### Physical separation of models in separate data stores

A more advanced CQRS implementation uses distinct data stores for the read and write models. Separation of the read and write data stores allows you to scale each to match the load. It also enables you to use a different storage technology for each data store. You can use a document database for the read data store and a relational database for the write data store (*see figure 3*).

![Diagram that shows a CQRS architecture with separate read and write data stores.](./_images/command-and-query-responsibility-segregation-cqrs-separate-stores.png)<br>
*Figure 3. A CQRS architecture with separate read and write data stores.*

**Synchronizing separate data stores:** When using separate stores, you must ensure both remain in sync. A common pattern is to have the write model publish events whenever it updates the database, which the read model uses to refresh its data. For more information on using events, see [Event-driven architecture style](../guide/architecture-styles/event-driven.yml). However, you usually can't enlist message brokers and databases into a single distributed transaction. So, there can be challenges in guaranteeing consistency when updating the database and publishing events. For more information, see [idempotent message processing](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-data-platform#idempotent-message-processing).

**Read data store:** The read data store can use its own data schema that is optimized for queries. For example, it can store a [materialized view](./materialized-view.yml) of the data to avoid complex joins or O/RM mappings. The read store can be a read-only replica of the write store or have a different structure. Deploying multiple read-only replicas can improve performance by reducing latency and increasing availability, especially in distributed scenarios.

### Benefits of CQRS

- **Independent scaling**. CQRS enables the read and write models to scale independently, which can help minimize lock contention and improve system performance under load.

- **Optimized data schemas**. Read operations can use a schema optimized for queries. Write operations use a schema optimized for updates.

- **Security**. By separating reads and writes, you can ensure that only the appropriate domain entities or operations have permission to perform write actions on the data.

- **Separation of concerns**. Splitting the read and write responsibilities results in cleaner, more maintainable models. The write side typically handles complex business logic, while the read side can remain simple and focused on query efficiency.

- **Simpler queries**. When you store a materialized view in the read database, the application can avoid complex joins when querying.

## Implementation issues and considerations

Some challenges of implementing this pattern include:

- **Increased complexity**. While the core concept of CQRS is straightforward, it can introduce significant complexity into the application design, particularly when combined with the Event Sourcing pattern.

- **Messaging challenges**. Although messaging isn't a requirement for CQRS, you often use it to process commands and publish update events. When messaging is involved, the system must account for potential issues such as message failures, duplicates, and retries. See the guidance on [Priority Queues](priority-queue.yml) for strategies to handle commands with varying priorities.

- **Eventual consistency**. When the read and write databases are separated, the read data might not reflect the most recent changes immediately, leading to stale data. Ensuring the read model store stays up-to-date with changes in the write model store can be challenging. Additionally, detecting and handling scenarios where a user acts on stale data requires careful consideration.

## When to use CQRS pattern

The CQRS pattern is useful in scenarios that require a clear separation between data modifications (commands) and data queries (reads). Consider using CQRS in the following situations:

- **Collaborative domains:** In environments where multiple users access and modify the same data simultaneously, CQRS helps reduce merge conflicts. Commands can include enough granularity to prevent conflicts, and the system can resolve any that do arise within the command logic.

- **Task-based user interfaces:** Applications that guide users through complex processes as a series of steps or with complex domain models benefit from CQRS.

  - The write model has a full command-processing stack with business logic, input validation, and business validation. The write model might treat a set of associated objects as a single unit for data changes, know as an *aggregate* in domain-driven design terminology. The write model might also ensure that these objects are always in a consistent state.
  
  - The read model has no business logic or validation stack. It returns a DTO for use in a view model. The read model is eventually consistent with the write model.

- **Performance tuning:** Systems where the performance of data reads must be fine-tuned separately from performance of data writes, especially when the number of reads is greater than the number of writes, benefit from CQRS. The read model scales horizontally to handle large query volumes, while the write model runs on fewer instances to minimize merge conflicts and maintain consistency.

- **Separation of development concerns:** CQRS allows teams to work independently. One team focuses on implementing the complex business logic in the write model, while another develops the read model and user interface components.

- **Evolving systems:** CQRS supports systems that evolve over time. It accommodates new model versions, frequent changes to business rules, or other modifications without affecting existing functionality.

- **System integration:** Systems that integrate with other subsystems, especially those using Event Sourcing, remain available even if a subsystem temporarily fails. CQRS isolates failures, preventing a single component from affecting the entire system.

## When not to use CQRS

Avoid CQRS in the following situations:

- The domain or the business rules are simple.

- A simple CRUD-style user interface and data access operations are sufficient.

## Workload design

An architect should evaluate how to use the CQRS pattern in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, code. | The separation of read and write operations in high read-to-write workloads enables targeted performance and scaling optimizations for each operation's specific purpose.<br/><br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition)<br/> - [PE:08 Data performance](/azure/well-architected/performance-efficiency/optimize-data-performance) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Combining event sourcing and CQRS

Some implementations of CQRS incorporate the [Event Sourcing pattern](./event-sourcing.yml), which stores the system's state as a chronological series of events. Each event captures the changes made to the data at a given time. To determine the current state, the system replays these events in order. In this combination:

- The event store is the *write model* and the single source of truth.

- The *read model* generates materialized views from these events, typically in a highly denormalized form. These views optimize data retrieval by tailoring structures to query and display requirements.

### Benefits of combining event sourcing and CQRS

The same events that update the write model can serve as inputs to the read model. The read model can then build a real-time snapshot of the current state. These snapshots optimize queries by providing efficient, precomputed views of the data.

Instead of directly storing the current state, the system uses a stream of events as the write store. This approach reduces update conflicts on aggregates and enhances performance and scalability. The system can process these events asynchronously to build or update materialized views for the read store.

Because the event store acts as the single source of truth, you can easily regenerate materialized views or adapt to changes in the read model by replaying historical events. In essence, materialized views function as a durable, read-only cache optimized for fast and efficient queries.

### Considerations when combining event sourcing and CQRS

Before you combine the CQRS pattern with the Event Sourcing pattern, evaluate the following considerations:

- **Eventual consistency:** Since the write and read stores are separate, updates to the read store might lag behind event generation, resulting in eventual consistency.

- **Increased complexity:** Combining CQRS with Event Sourcing requires a different design approach, which can make successful implementation more challenging. You must write code to generate, process, and handle events, and assemble or update views for the read model. However, Event Sourcing simplifies domain modeling and allows you to rebuild or create new views easily by preserving the history and intent of all data changes.

- **Performance of view generation:** Generating materialized views for the read model can consume significant time and resources. The same applies to projecting data by replaying and processing events for specific entities or collections. This effect increases when calculations involve analyzing or summing values over long periods, as all related events must be examined. Implement snapshots of the data at regular intervals. For example, store periodic snapshots of aggregated totals (the number of times a specific action occurs) or the current state of an entity. Snapshots reduce the need to process the full event history repeatedly, improving performance.

## Example of CQRS pattern

The following code shows some extracts from an example of a CQRS implementation that uses different definitions for the read and the write models. The model interfaces don't dictate any features of the underlying data stores, and they can evolve and be fine-tuned independently because these interfaces are separated.

The following code shows the read model definition.

```csharp
// Query interface
namespace ReadModel
{
  public interface ProductsDao
  {
    ProductDisplay FindById(int productId);
    ICollection<ProductDisplay> FindByName(string name);
    ICollection<ProductInventory> FindOutOfStockProducts();
    ICollection<ProductDisplay> FindRelatedProducts(int productId);
  }

  public class ProductDisplay
  {
    public int Id { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    public decimal UnitPrice { get; set; }
    public bool IsOutOfStock { get; set; }
    public double UserRating { get; set; }
  }

  public class ProductInventory
  {
    public int Id { get; set; }
    public string Name { get; set; }
    public int CurrentStock { get; set; }
  }
}
```

The system allows users to rate products. The application code does this using the `RateProduct` command shown in the following code.

```csharp
public interface ICommand
{
  Guid Id { get; }
}

public class RateProduct : ICommand
{
  public RateProduct()
  {
    this.Id = Guid.NewGuid();
  }
  public Guid Id { get; set; }
  public int ProductId { get; set; }
  public int Rating { get; set; }
  public int UserId {get; set; }
}
```

The system uses the `ProductsCommandHandler` class to handle commands sent by the application. Clients typically send commands to the domain through a messaging system such as a queue. The command handler accepts these commands and invokes methods of the domain interface. The granularity of each command is designed to reduce the chance of conflicting requests. The following code shows an outline of the `ProductsCommandHandler` class.

```csharp
public class ProductsCommandHandler :
    ICommandHandler<AddNewProduct>,
    ICommandHandler<RateProduct>,
    ICommandHandler<AddToInventory>,
    ICommandHandler<ConfirmItemShipped>,
    ICommandHandler<UpdateStockFromInventoryRecount>
{
  private readonly IRepository<Product> repository;

  public ProductsCommandHandler (IRepository<Product> repository)
  {
    this.repository = repository;
  }

  void Handle (AddNewProduct command)
  {
    ...
  }

  void Handle (RateProduct command)
  {
    var product = repository.Find(command.ProductId);
    if (product != null)
    {
      product.RateProduct(command.UserId, command.Rating);
      repository.Save(product);
    }
  }

  void Handle (AddToInventory command)
  {
    ...
  }

  void Handle (ConfirmItemsShipped command)
  {
    ...
  }

  void Handle (UpdateStockFromInventoryRecount command)
  {
    ...
  }
}
```

## Next steps

The following patterns and guidance are useful when implementing this pattern:

- [Horizontal, vertical, and functional data partitioning](../best-practices/data-partitioning.yml). Describes best practices for dividing data into partitions that can be managed and accessed separately to improve scalability, reduce contention, and optimize performance.

## Related resources

- [Event Sourcing pattern](./event-sourcing.yml). Describes how to use Event Sourcing with the CQRS pattern. It shows you how to simplify tasks in complex domains while improving performance, scalability, and responsiveness. It also explains how to provide consistency for transactional data while maintaining full audit trails and history that can enable compensating actions.

- [Materialized View pattern](./materialized-view.yml). The read model of a CQRS implementation can contain materialized views of the write model data, or the read model can be used to generate materialized views.

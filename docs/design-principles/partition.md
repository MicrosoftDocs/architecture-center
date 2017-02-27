# Partition around limits

As an application scales, eventually it may hit limits in scalability, query performance, or size. Limits to consider include database size, query throughput, and network throughput.

Partioning is a way to segment a subsystem (especially a data store)

Data can be partitioned horizontally, vertically, or functionally:

- **Horizontal partitioning**, also called sharding. Each partition holds data for a subset of the total data set. The partitions share the same data schema. For example, customers whose names start with A&ndash;M go into one partition, N&ndash;Z into another partition.

- **Vertical partitioning**. Each partition holds a subset of the fields for the items in the data store. For example, frequently accessed fields might go in one  partition, and less frequently accessed fields in another.

- **Functional partitioning**. Data is partitioned according to how it is used by each bounded context in the system. For example, you might store invoice data in one partition and product inventory data in another. The schemas are independent.

There are pros and cons to each. For more detailed guidance, see [Data partitioning][data-partitioning-guidance].

Databases are one obvious candidate for partitioning, but you can also partition queues, event streams, message buses, or any other subsystem where there is a natural way to divide up the work.


## Recommendations

**Can you scale up?** Before you take the step of partitioning, consider whether you have room to scale up. Can you use a larger instance size or a higher service tier? Azure service limits are documented in [Azure subscription and service limits, quotas, and constraints][azure-limits].

**Partition different parts of the application.** Database, storage, cache, and queues are all potential spots for partitioning.

**Design the shard key to avoid hot spots.** If you partition a database, but one shard still gets the majority of the requests, then you haven't solved your  problem. Ideally, load gets distributed evenly across all the partitions. For example, hash by customer ID and not the first letter of the customer name, because some letters are more frequent.

**Partition around Azure subscription and resource group limits.** Individual components and services have limits, but there are also limits for subscriptions and resource groups. For large applications, you might need to partition around those limits.  


<!-- links -->

[azure-limits]: /azure/azure-subscription-service-limits
[data-partitioning-guidance]: ../best-practices/data-partitioning.md

 
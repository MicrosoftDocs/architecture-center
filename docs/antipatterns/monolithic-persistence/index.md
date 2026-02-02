---
title: Monolithic Persistence Antipattern
description: Learn about the Monolithic Persistence antipattern, which can weaken performance by putting all of an application's data into a single data store.
ms.author: pnp
author: claytonsiemens77
ms.date: 06/05/2017
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

<!-- cSpell:ignore DTUs -->

# Monolithic Persistence antipattern

Putting all of an application's data into a single data store can weaken performance, either because it leads to resource contention or because the data store isn't a good fit for some of the data.

## Context and problem

Historically, applications used a single data store, regardless of the different types of data that the application might need to store. Organizations used this method to simplify the application design or to match the existing skill set of the development team.

Modern cloud-based systems often have extra functional and nonfunctional requirements. These systems need to store many heterogeneous types of data, such as documents, images, cached data, queued messages, application logs, and telemetry. Following the traditional approach and putting all this information into the same data store can weaken performance for two main reasons:

- Storing and retrieving large amounts of unrelated data in the same data store can cause contention, which leads to slow response times and connection failures.
- Regardless of which data store is chosen, it might not be the best fit for all types of data. Or it might not be optimized for the operations that the application performs.

The following example shows an ASP.NET Web API controller that adds a new record to a database and also records the result to a log. The log is stored in the same database as the business data.

```csharp
public class MonoController : ApiController
{
    private static readonly string ProductionDb = ...;

    public async Task<IHttpActionResult> PostAsync([FromBody]string value)
    {
        await DataAccess.InsertPurchaseOrderHeaderAsync(ProductionDb);
        await DataAccess.LogAsync(ProductionDb, LogTableName);
        return Ok();
    }
}
```

The rate at which log records are generated can affect the performance of the business operations. And if another component, such as an application process monitor, regularly reads and processes the log data, that can also affect the business operations.

## Solution

Separate data according to its use. For each data set, select a data store that best matches how you use that data set. In the previous example, the application should log to a separate store from the database that holds business data:

```csharp
public class PolyController : ApiController
{
    private static readonly string ProductionDb = ...;
    private static readonly string LogDb = ...;

    public async Task<IHttpActionResult> PostAsync([FromBody]string value)
    {
        await DataAccess.InsertPurchaseOrderHeaderAsync(ProductionDb);
        // Log to a different data store.
        await DataAccess.LogAsync(LogDb, LogTableName);
        return Ok();
    }
}
```

## Problems and considerations

- Separate data based on how you use and access it. For example, don't store log information and business data in the same data store. These types of data have different requirements and patterns of access. Log records are inherently sequential, while business data is more likely to require random access, and is often relational.

- Consider the data access pattern for each type of data. For example, store formatted reports and documents in a document database such as [Azure Cosmos DB][cosmos-db]. Use [Azure Managed Redis][azure-managed-redis] to cache temporary data.

- Scale up the database if you follow this guidance but still reach the limits of the database. Also consider scaling horizontally and partitioning the load across database servers. However, partitioning might require redesigning the application. For more information, see [Data partitioning][DataPartitioningGuidance].

## Detect the problem

The system can slow down dramatically and eventually fail when the system runs out of resources such as database connections.

You can do the following steps to help identify the cause:

1. Instrument the system to record the key performance statistics. Capture timing information for each operation. And capture the points where the application reads and writes data.

2. Monitor the system for a few days in a production environment to get a real-world view of how the system is used. If you can't do this process, run scripted load tests with a realistic volume of virtual users that perform a typical series of operations.
3. Use the telemetry data to identify periods of poor performance.
4. Identify which data stores were accessed during those periods.
5. Identify data storage resources that might experience contention.

## Example diagnosis

The following sections apply these steps to the sample application described earlier.

### Instrument and monitor the system

The following graph shows the results of load testing the sample application described earlier. The test uses a step load of up to 1,000 concurrent users.

![Graph that shows load test performance results for the SQL-based controller.][MonolithicScenarioLoadTest]

As the load increases to 700 users, so does the throughput. But at that point, throughput stabilizes, and the system appears to run at its maximum capacity. The average response gradually increases with user load, showing that the system can't keep up with demand.

### Identify periods of poor performance

If you monitor the production system, you might notice patterns. For example, response times might drop off significantly at the same time each day. A regular workload or scheduled batch job can cause this fluctuation. Or the system might have more users at certain times. You should focus on the telemetry data for these events.

Look for correlations between increased response times and increased database activity or input/output (I/O) to shared resources. If there are correlations, it means that the database might be a bottleneck.

### Identify which data stores are accessed during those periods

The next graph shows the utilization of database throughput units (DTUs) during the load test. A DTU is a measure of available capacity. It's a combination of CPU utilization, memory allocation, and I/O rate. Utilization of DTUs quickly reaches 100%. In the previous graph, throughput peaked at this point. Database utilization remains high until the test completes. There's a slight drop toward the end, which can result from throttling, competition for database connections, or other factors.

![Graph that shows the database monitor in the Azure classic portal showing resource utilization of the database.][MonolithicDatabaseUtilization]

### Examine the telemetry for the data stores

Instrument the data stores to capture the low-level details of the activity. In the sample application, the data access statistics show a high volume of insert operations performed against both the `PurchaseOrderHeader` table and the `MonoLog` table.

![Graph that shows the data access statistics for the sample application.][MonolithicDataAccessStats]

### Identify resource contention

At this point, you can review the source code, focusing on the points where the application accesses contended resources. Look for situations such as:

- Data that's logically separate being written to the same store. Data such as logs, reports, and queued messages shouldn't be held in the same database as business information.
- A mismatch between the choice of data store and the type of data, such as large blobs or XML documents in a relational database.
- Data that has different usage patterns that share the same store. An example includes high-write and low-read data being stored with low-write and high-read data.

### Implement the solution and verify the result

This example updates the application to write logs to a separate data store. The following graph shows the load test results.

![Graph that shows the load test performance results using the Polyglot controller.][PolyglotScenarioLoadTest]

The pattern of throughput is similar to the earlier graph, but the point at which performance peaks is approximately 500 requests per second higher. The average response time is marginally lower. However, these statistics don't tell the full story. Telemetry for the business database shows that DTU utilization peaks at around 75%, rather than 100%.

![Graph that shows the database monitor in the Azure classic portal showing resource utilization of the database in the polyglot scenario.][PolyglotDatabaseUtilization]

Similarly, the maximum DTU utilization of the log database only reaches about 70%. The databases are no longer the limiting factor in the performance of the system.

![Graph that shows the database monitor in the Azure classic portal showing resource utilization of the log database in the polyglot scenario.][LogDatabaseUtilization]

## Related resources

- [Choose the right data store][data-store-overview]
- [Criteria for choosing a data store][data-store-comparison]
- [Data access for highly scalable solutions by using SQL, NoSQL, and polyglot persistence][Data-Access-Guide]
- [Data partitioning][DataPartitioningGuidance]

[cosmos-db]: https://azure.microsoft.com/services/cosmos-db
[azure-managed-redis]: /azure/redis/overview
[Data-Access-Guide]: /previous-versions/msp-n-p/dn271399(v=pandp.10)
[DataPartitioningGuidance]: ../../best-practices/data-partitioning.yml
[data-store-overview]: ../../guide/technology-choices/data-store-overview.md
[data-store-comparison]: ../../guide/technology-choices/data-store-considerations.md

[MonolithicScenarioLoadTest]: ./_images/MonolithicScenarioLoadTest.jpg
[MonolithicDatabaseUtilization]: ./_images/MonolithicDatabaseUtilization.jpg
[MonolithicDataAccessStats]: ./_images/MonolithicDataAccessStats.jpg
[PolyglotScenarioLoadTest]: ./_images/PolyglotScenarioLoadTest.jpg
[PolyglotDatabaseUtilization]: ./_images/PolyglotDatabaseUtilization.jpg
[LogDatabaseUtilization]: ./_images/LogDatabaseUtilization.jpg

---
title: Monolithic Persistence antipattern
description: 

author: dragon119
manager: christb

pnp.series.title: Optimize Performance
---
# Monolithic Persistence antipattern
[!INCLUDE [header](../../_includes/header.md)]

All business applications use data, and they need to store this data somewhere. Many
existing business applications make use of a single repository to store and retrieve
data, regardless of how that data is used. This strategy is typically aimed at
keeping the data storage requirements simple by using well understood technology, and
might appear to make sense initially. Modern cloud-based systems often have
additional functional and nonfunctional requirements, and besides the raw business
information an application might also need to store: <<RBC: We don't use commas in lists. They either get nothing or periods at the end. If one is a complete sentence they all get periods.>>

- Formatted reporting data.

- Documents.

- Images and blobs.

- Cached information and other temporary data used to improve system performance.

- Queued messages.

- Application log and audit data.

Following the traditional approach and recording all of this
information in the same repository might not be appropriate for
the following reasons:

- Storing and retrieving large quantities of unrelated data held in the same
repository can cause severe contention, leading to slow response times and data store
connection failures.

- The data store might not match the requirements of the structure of every piece of
data. For example, invoices might be best held in a document database and customer
details might be better stored in a relational database.  

- The data store might not be optimized for the operations that the application
performs on this data. For example, queuing messages requires fast first-in first-out
capability whereas business data typically requires a data store that is better tuned
to supporting random access capabilities.

----------

**Note:** For historical reasons the single repository selected is often a SQL
database as this is the form of data storage that is best understood by many
designers. However, the principles of this antipattern apply regardless of the type
of repository.

----------

The following code snippet shows a Web API controller that simulates the actions
performed as part of a web application. The `Monolithic` controller provides an HTTP
POST operation that adds a new record to a database and also records the result to a
log. The log is held in the same database as the business data. The details of the
database operations are implemented by a set of static methods the `DataAccess`
class.

**C# Web API**
```C#
public class MonoController : ApiController
{
    private static readonly string ProductionDb = ...;
    public const string LogTableName = "MonoLog";

    public async Task<IHttpActionResult> PostAsync([FromBody]string value)
    {
        await DataAccess.InsertPurchaseOrderHeaderAsync(ProductionDb);

        await DataAccess.LogAsync(ProductionDb, LogTableName);

        return Ok();
    }
}
```

----------

**Note:** This code forms part of the [MonolithicPersistence sample application][fullDemonstrationOfProblem] available with this antipattern.

----------

The application uses the same database for two distinctly different purposes, to
store business data and to record telemetry information. The rate at which log
records are generated is likely to impact the performance of the business operations.
Additionally, if a third party utility (such as application process monitor)
regularly reads and processes the log data, then the activities of this utility can
also affect the performance of business operations.

## How to detect the problem

Using a single data store for telemetry and business data can result in the data
store becoming a point of contention. A large number of very different requests could
be competing for the same data storage resources. In the sample application, as more
and more users access the web application, the system will likely slow down markedly
and eventually fail as the system runs out of SQL Server connections and throttles
applications attempting to read or write to the database.

You can perform the following steps to help identify the causes of any problems
resulting from data store contention:

1. Instrument the system and performing process monitoring under everyday conditions.

2. Use the telemetry data to identify periods of poor performance.

3. Identify the use of the data stores that are accessed during periods of poor
performance.

4. Examine the telemetry data for these stores at these times.

5. Identify contended <<RBC: This isn't very common usage, but I can't think of another word here. I might rephrase as "Identify data storage resources experiencing contention..." Although I don't love that either. Thoughts?>> data storage resources and review the source code to examine
how they are used.


The following sections apply these steps to the sample application described earlier.

----------

**Note:** If you already have an insight into where problems might lie, you may be
able to skip some of these steps. However, you should avoid making unfounded or
biased assumptions. Performing a thorough analysis can sometimes lead to the
identification of unexpected causes of performance problems. The following sections
are formulated to help you to examine applications and services systematically.

----------

### Instrumenting and monitoring the system

This step is a matter of configuring the system to record the key statistics required
to capture the performance signature of the application. You should capture timing
information for each operation as well as the points at which the application reads
and writes data. If possible, monitor the system running for a few days in a
production environment and capture the telemetry of obtain a real world view of how
the system is used. If this is not possible, then perform scripted load testing using
a realistic volume of virtual users performing a typical series of operations.

As an example, the following graph shows the load test results for a scenario in
which a step load of up to 1000 concurrent users issue HTTP POST requests to the
`Monolithic` controller.

![Load test performance results for the SQL-based controller][MonolithicScenarioLoadTest]

As the load increases to 700 users so does the throughput. At the 700 user point
throughput levels off and the system appears to be running at its maximum capacity.
The average response gradually increases with user load as the system is unable to
keep up with demand.

### Identifying periods of poor performance

If you are monitoring the production system, you might notice patterns in the way the system performs. For example, response times might drop off significantly
at the same time each day. This could be caused by a regular workload or background
job that is scheduled to run at this time, or it could be due to the behavioral
factors of the users (are users more likely to access the system at specific times?)
You should focus on the telemetry data for these events.

You should look for matches in increased response times and throughput against any
likely causes, such as increased database activity or I/O to shared resources. If any
such correlations exist, then the database or shared resource could be acting as a
bottleneck.

----------

**Note:** The cause of performance deterioration could be an external event. In the
example application, an operator purging the SQL log could generate a significant
load on the database server and cause a slow down in business operations even if the
user load is relatively low at the time.

----------

### Identifying data stores accessed during periods of poor performance

Monitoring the the data stores used by system should provide an indication of how
they are being accessed during periods of poor performance. In sample application, the data indicated that poor performance coincided with a
significant volume of requests to the SQL database holding the business and log data.
As an example, the SQL Database Monitoring pane in the Azure Portal for the database
used by the sample application showed that during load testing the database
throughput unit (DTU) utilization quickly reached 100%. This is roughly the
point the throughput shown in the previous graph plateaued. The database
utilization remained very high until the test finished. There is a slight drop,
possibly due to throttling, latency due to the competition for database connections,
or other environmental factors.

![The database monitor in the Azure Management Portal showing resource utilization of the database][MonolithicDatabaseUtilization]

A DTU is a measure of the available capacity of the system and is a combination of
the CPU utilization, memory allocation, and the rate of read and write operations
being performed. Each SQL database server allocates a quota of resources to
applications measured in DTUs. The volume of DTUs available to an application depends
on the service tier and performance level of the database server. Creating an Azure
SQL database using the Basic service tier provides 5 DTUs, while a database using the
Premium Service Tier and P3 Performance Level has 800 DTUs available. When an
application reaches the limit defined by the available DTUs, database performance is
throttled. At this point, throughput levels off but response time is likely to
increase as database requests are queued. This is what happened during the load test.

----------

**Note:** See [Azure SQL Database Service Tiers and Performance Levels][ServiceTiersPerformanceLevels] for more information about SQL Database and
DTUs.

----------

### Examining the telemetry for the data stores

The data stores should also be instrumented to capture the low level
details of the activity. In the sample application, during the load test
the data access statistics showed a high volume of insert operations performed
against the `PurchaseOrderHeader` table and the `MonoLog` table in the
AdventureWorks2012 database.

![The data access statistics for the sample application][MonolithicDataAccessStats]

----------

**Note:** There are several entries for statements that insert data into the
`MonoLog` table because the database server has generated different query plans at
different times during the load test based on the size of the table and other
environmental factors.

----------

### Identifying contended <<RBC: If this word is replaced above it should be replaced here as well.>> resources and understanding how they are used

At this point you can conduct a review of the source code focusing on the points at
which the contended resources are accessed by the application. While reviewing the
code, look for situations such as:

- Data that is logically separate being written to the same store. Information such
as logs, reports, and queued messages should not be held in the same database as
business information.

- Information being held in a data store that is not apropriate for the operations
being performed, such as large binary objects (video or audio) or XML documents in a
relational database.

- Data that has significantly different usage patterns that share the same store,
such as data that is written frequently but read relatively infrequently and vice
versa.

## How to correct the problem

Separate data according to its use, and select a data storage mechanism most  
appropriate to the pattern of use for each data set. As an example, the code below is
very similar to the `Monolithic` controller except that the log records are written
to a different database running on a separate server. This approach helps to reduce
pressure on the database holding the business information.

**C# Web API**
```C#
public class PolyController : ApiController
{
    private static readonly string ProductionDb = ...;
    private static readonly string LogDb = ...;
    public const string LogTableName = "PolyLog";

    public async Task<IHttpActionResult> PostAsync([FromBody]string value)
    {
        await DataAccess.InsertPurchaseOrderHeaderAsync(ProductionDb);

        await DataAccess.LogAsync(LogDb, LogTableName);

        return Ok();
    }
}

```

----------

**Note:** This snippet is taken from the [sample code][fullDemonstrationOfSolution]
available with this antipattern.

----------

You should consider the following points when determining the most appropriate plan
for storing business and operational data:

- Separate data by the way it is used and how it is accessed. For example,
don't store log information and business data in the same data store. These types of
data have significantly different requirements patterns of access (log records are
inherently sequential while business data is more likely to be random access).

- Use a storage technology that is most appropriate to the data access pattern for
each type of data item. For example, store formatted reports and documents in a
document database such as [DocumentDB][DocumentDB], use a specialized solution such
as [Azure Redis Cache][Azure-cache] for caching temporary data, or use
[Azure Table Storage][Azure-Table-Storage] for holding information written and
accessed sequentially such as log files.

## Consequences of the solution

Spreading the load across data stores reduces contention and helps to improve the overall
performance of the system under load. You could also take the opportunity to
assess the data storage technologies used and rework selected parts of the system to
use a more appropriate storage mechanism, although making changes such as this may
involve thorough retesting of the system functionality.

For comparison purposes, the following graph shows the results of performing the same
load tests as before but logging records to the separate database.

![Load test performance results using the Polyglot controller][PolyglotScenarioLoadTest]

The pattern of the throughput is similar to that of the earlier graph, but the volume
of requests supported when the performance levels out is approximately 500 requests
per second higher. The response time is also marginally lower. However, these
statistics do not tell the full story. Examining the utilization of the business
database by using the Azure Management Portal reveals that DTU utilization now peaks
at 75.46%. <<RBC: That's a VERY specific number. Should we say anything about whether they can expect similar results?>>

![The database monitor in the Azure Management Portal showing resource utilization of the database in the polyglot scenarion][PolyglotDatabaseUtilization]

Similarly, the maximum DTU utilization of the log database only reaches 70.52%.

![The database monitor in the Azure Management Portal showing resource utilization of the log database in the polyglot scenarion][LogDatabaseUtilization]

The databases are now no longer the limiting factor in the performance of the system,
and the throughput might now be restricted by other factors such as web server
capacity.

----------

**Note:** If you are still hitting the DTU limits for an Azure SQL database server
then you may need to scale up to a higher Service Tier or Performance Level.
Currently the Premium/P3 level is the highest level available, supporting up to 800
DTUs. If you anticipate exceeding this throughput, then you should consider scaling
horizontally and partitioning the load across database servers, although as described
earlier this is a nontrivial task that may require redesigning the application.

----------

## Related resources

- [Azure Table Storage and Windows Azure SQL Database - Compared and Contrasted][TableStorageVersusDatabase]

- [Data Access for Highly-Scalable Solutions: Using SQL, NoSQL, and Polyglot Persistence][Data-Access-Guide]

- [Azure Cache documentation][Azure-cache]

- [Data Partitioning Guidance][DataPartitioningGuidance]


[fullDemonstrationOfProblem]: https://github.com/mspnp/performance-optimization/tree/master/MonolithicPersistence
[fullDemonstrationOfSolution]: https://github.com/mspnp/performance-optimization/tree/master/MonolithicPersistence
[AdventureWorks2012]: http://msftdbprodsamples.codeplex.com/releases/view/37304
[DocumentDB]: http://azure.microsoft.com/services/documentdb/
[Azure-cache]: http://azure.microsoft.com/documentation/services/cache/
[Data-Access-Guide]: https://msdn.microsoft.com/library/dn271399.aspx
[Azure-Table-Storage]: http://azure.microsoft.com/documentation/articles/storage-dotnet-how-to-use-tables/
[DataPartitioningGuidance]: https://msdn.microsoft.com/library/dn589795.aspx
[TableStorageVersusDatabase]: https://msdn.microsoft.com/library/azure/jj553018.aspx
[ServiceTiersPerformanceLevels]: https://msdn.microsoft.com/library/azure/dn741336.aspx
[MonolithicScenarioLoadTest]: _images/MonolithicScenarioLoadTest.jpg
[MonolithicDatabaseUtilization]: _images/MonolithicDatabaseUtilization.jpg
[MonolithicDataAccessStats]: _images/MonolithicDataAccessStats.jpg
[PolyglotScenarioLoadTest]: _images/PolyglotScenarioLoadTest.jpg
[PolyglotDatabaseUtilization]: _images/PolyglotDatabaseUtilization.jpg
[LogDatabaseUtilization]: _images/LogDatabaseUtilization.jpg

---
title: Extraneous Fetching anitpattern
description: 

author: dragon119
manager: christb

pnp.series.title: Optimize Performance
---
# Extraneous Fetching antipattern
[!INCLUDE [header](../../_includes/header.md)]

Applications fetch data for query purposes, or to perform some application-specific
processing. Retrieving data, whether from a remote web service, a database, or a file,
incurs I/O. Retrieving more data than is necessary to satisfy a business operation can
result in unnecessary I/O overhead and can reduce responsiveness. In a cloud
environment supporting multiple concurrent instances of an application, this overhead
can accumulate to have a significant impact on the performance and scalability of the
system.

This antipattern typically occurs because:

- The application attempts to minimize the number of I/O requests by retrieving all of
the data that it *might* need. This is often a result of overcompensating for the
[Chatty I/O][chatty-io] antipattern. For example, the [sample
code][fullDemonstrationOfProblem] provided with this antipattern contains part of a
web application enables a customer to browse products that an organization sells. This
information is held in the `Products` table in the AdventureWorks2012 database shown
in the image below. A simple form of the application fetches the complete details for
every product. This is wasteful on at least three counts:

	- The customer might not be interested in every detail. They would typically need
	to see the product name, description, price, dimensions, and possibly a thumbnail
	image. Other related information such as product ratings, reviews, and detailed
	images might be useful but could be expensive and wasteful to retrieve unless the
	customer specifically requests it.

	- Not all of the product details might be relevant to the customer. There could be
	some properties that are only meaningful to the organization or that should remain
	hidden from customers.

	- The customer is unlikely to want to view every product that the organization
	sells.

![Entity Framework data model based on the Product table in the AdventureWorks2012 database][full-product-table]

- The application was developed following poor programming or design practices. For
example, the following code (taken from the sample application) retrieves product
information by using the Entity Framework to fetch the complete details for every
product. The code then filters this information to return only the information that
the user has requested. The remaining data is discarded. This is clearly wasteful, but
commonplace.

**C# Web API**

```C#
[HttpGet]
[Route("api/allfields")]
public async Task<IHttpActionResult> GetAllFieldsAsync()
{
    using (var context = new AdventureWorksContext())
    {
        // execute the query
        var products = await context.Products.ToListAsync();

        // project fields from the query results
        var result = products.Select(p => new ProductInfo { Id = p.ProductId, Name = p.Name });

        return Ok(result);
    }
}
```

- Similarly, the application might retrieve data to perform aggregations or other
forms of operations. The following sample code (also taken from the sample
application) calculated the total sales for the company. The application retrieves
every record for all orders sold, and then calculates the total sales value from these records.

![Entity Framework data model showing the SalesOrderHeader table][product-sales-table]

**C# Web API**

```C#
[HttpGet]
[Route("api/aggregateonclient")]
public async Task<IHttpActionResult> AggregateOnClientAsync()
{
    using (var context = new AdventureWorksContext())
    {
        // fetch all order totals from the database
        var orderAmounts = await context.SalesOrderHeaders.Select(soh => soh.TotalDue).ToListAsync();

        // sum the order totals here in the controller
        var total = orderAmounts.Sum();

        return Ok(total);
    }
}
```

- The application retrieves data from a data source using the `IEnumerable`
interface. This interface supports filtering and enumeration of data, but the
filtering is performed on the client side after it has been retrieved from the data
source. Technologies such as LINQ to Entities (used by the Entity Framework) default
to retrieving data through the `IQueryable` interface, which passes the responsibility
for filtering to the data source. However, in some situations an application might
reference an operation that is only available to the client and not available in the
data source, requiring that the data be returned through the `IEnumerable` interface
(by applying the `AsEnumerable` method to an entity collection). The following example
shows a LINQ to Entities query that retrieves all products where the `SellStartDate`
column occurs somewhere in the previous week. LINQ to Entities cannot map the `AddDays`
function to an operation in the database, so the query returns every row from the
product table to the application where it is filtered. If there are only a small
number of rows that match this criterion, this is a waste of bandwidth.

**C# Entity Framework**

``` C#
var context = new AdventureWorks2012Entities();
var query = from p in context.Products.AsEnumerable()
            where p.SellStartDate < DateTime.Now.AddDays(-7) // AddDays cannot be mapped by LINQ to Entities
            select ...;

List<Product> products = query.ToList();
```

## How to detect the problem

Symptoms of extraneous fetching in an application include high latency and low
throughput. If the data is retrieved from a data store, then increased contention is
also probable. End users are likely to report extended response times and possible
failures caused by services timing out due to increased network traffic and resource
conflicts in the data store. These failures could return <<RBC: Does this work from a technical perspective? "Manifest themselves as" seemed awkward, and I was concerned that it could be confusing to ESL readers.>> HTTP 500
(Internal Server) errors or HTTP 503 (Service Unavailable) errors. In these cases, you
should examine the event logs for the web server, which are likely to contain more
detailed information about the causes and circumstances of the errors.

----------

**Note:** The symptoms of this antipattern and some of the telemetry obtained might
be very similar to those of the [Monolithic Persistence
antipattern][MonolithicPersistence]. The causes however are somewhat different, as
are the possible solutions.

----------

You can perform the following steps to help identify the causes of any problems:

1. Identify slow workloads or transactions by performing load-testing, process
monitoring, or other methods of capturing instrumentation data.

2. Observe any behavioral patterns exhibited by the system. For example, does the
performance get worse at 5pm each day, and what happens when the workload exceeds a
specific limit in terms of transactions per second or volume of users?

3. Correlate the instances of slow workloads with behavioral patterns.

4. Identify the source of the data and the data stores being used.

5. For each data source, run lower level telemetry to observe the behavior of
operations end-to-end using process monitoring, instrumentation, or application
profiling.

6. Identify any slow-running queries that reference these data sources.

7. Perform a resource-specific analysis of the slow-running queries and ascertain how
the data is used and consumed.

The following sections apply these steps to the sample application described earlier.

----------

**Note:** If you already have an insight into where problems might lie, you may be
able to skip some of these steps. However, you should avoid making unfounded or biased
assumptions. Performing a thorough analysis can sometimes lead to the identification
of unexpected causes of performance problems. The following sections are formulated to
help you to examine applications and services systematically.

----------

### Identifying slow workloads

An initial analysis will likely be based on user reports concerning functionality that
is running slowly or raising exceptions. Load testing this functionality in a
controlled test environment could indicate high latency and low throughput. As an
example, the following performance results were obtained by using a load test that
simulated up to 400 concurrent users running the `GetAllFieldsAsync` operation in the
[sample code][fullDemonstrationOfProblem].

![Load test results for the GetAllFieldsAsync method][Load-Test-Results-Client-Side1]

Throughput diminished slowly as the load increased, but the average response time
mirrored the workload (in the graph, the average response time has been magnified by
100 to make the correlation clear).

Performing a load test for the `AggregateOnClientAsync` operation shows a similar
pattern. The volume of requests per seconds is reasonably stable (although higher),
and the average response time increases more slowly with the workload.

![Load test results for the AggregateOnClientAsync method][Load-Test-Results-Client-Side2]

Profiling an application in a test environment can help to identify the following
symptoms that characterize operations that retrieve large amounts of data. The exact
symptoms will depend on the nature of the resources being accessed, but may include:

- Frequent, large I/O requests made to the same resource or data store.

- Contention in a shared resource or data store hosting the requested information.

- Client applications frequently receiving large volumes of incoming data across the network.

- Applications and services spending significant time waiting for I/O to complete.

### Observing behavioral patterns

Determining whether behavior is influenced by time is a matter of monitoring the
performance of the production system over an appropriate period and examining the
usage statistics. Any correlation between regular periods of high usage and slowing
performance can indicate areas of concern. The performance profile of functionality
that is suspected to be slow running should be closely examined to determine whether
it matches that of the load testing performed earlier.

Load testing to destruction (in a test environment) over the same functionality using
step-based user loads can help highlight the point at which the performance drops
significantly or fails completely. If the load at which the system fails or performance
drops to unacceptable levels is within the bounds of that expected at periods of peak
activity, then the way the functionality is implemented should be examined
further.

### Correlating instances of slow workloads with behavioral patterns

A slow operation is not necessarily a problem if it is not being performed when the
system is under stress, it is not time critical, and it does not unduly impact the
performance of other important operations. For example, generating the monthly
operational statistics might be a long-running operation, but it can probably be
performed as a batch process and run as a low priority job. On the other hand,
customers querying the product catalog or placing orders are critical business
operations that can have a direct bearing on the profitability of an organization. You
should focus on the telemetry generated by these critical operations to see how the
performance varies during periods of high usage.

### Identifying data sources in slow workloads

If you suspect that a service is performing poorly because of the way data is
being retrieved, you should investigate how the application is interacting with the
repositories it utilizes. Monitoring the live system, together with a review of the
source code (if possible) should help reveal the data sources being accessed during
periods of poor performance.

In the case of the sample application, all the information is held in a single
instance of Azure SQL Database.

### Observing the end-to-end behavior of operations that access each data source

In a typical Azure scenario, a client (a browser, desktop application, or mobile
device) sends a request to a web application or cloud service. The web application or
cloud service in turn submits a request to a data store. The data is then returned,
possibly after performing some processing, to the client for processing.

For each data source, you should instrument the system to capture the frequency with
which each data store is accessed, the volume of data entering and exiting the data
store, the timing of these operations (in particular, the latency of requests), and
the nature and rate of any errors observed while accessing each data store under loads
that are typical of the system. You can compare this information against the volumes
of data being returned by the web application or cloud service to the client. The
following diagram shows a typical end-to-end scenario. In this scenario, you should
track the ratio of the volume of data returned by the data store (*x* bytes) against
the size of the data returned to the client (*y* bytes). Any large disparity between
the values of *x* and *y* should be investigated to determine whether the web
application or cloud service is fetching extraneous data and performing processing
that might be better handled by the data store.

![Observing end-to-end behavior of operations][End-to-End]

Capturing this data might involve observing the live system and tracing the lifecycle
of each user request, or you can model a series of synthetic workloads and run them
against a test system if you need to observe behavior in a more controlled
environment.

The following graphs show the results of telemetry captured using New Relic <<RBC: Should we link or at least mention it's a third party tool?>>during
the load test of the `GetAllFieldsAsync` method. It is important to note the
differences between the volumes of data received from the database and the
corresponding HTTP responses.

![Telemetry for the `GetAllFieldsAsync` method][TelemetryAllFields]

In the load tests, the size of the data returned from the database by each request was
80503 bytes. The size of the data returned to the client can vary depending on the format
requested by the client. During the load tests the data was returned to the clients in
JSON format and each response contains 19855 bytes (25% of the size of the database
response). Separate testing (results not shown), for clients requesting data in XML
format shows that the response size is 35655 bytes (44% of the size of the database
response.)

----------

**Note:** It is interesting to observe the correlation between the throughput of the
web application (requests per minute) against the number of bytes received from the
database. This tailing off was also apparent in the load test. The actual cause of
this gradual reduction <<RBC: Seriously, diminuendo?>> is not apparent from the graphs. Further investigation of the system
would be required to determine whether the reduction in the volume of requests sent to
the web application has caused a corresponding reduction in the number of requests
passed to the database (hence the volume of data returned). Or whether a gentle
throttling of the database is causing a reduction in the number of concurrent requests
that the web application can support. This investigation would involve capturing the
telemetry for the database server and for the web server hosting the web application
to determine which one is most likely to be acting as the brake on the system.

----------

Examining the telemetry captured during the load test for the `AggregateOnClientAsync`
method shows more extreme results. In this case, each test performed a query that
retrieved over 280Kb of data from the database, but the JSON response contained a mere
14 bytes. This wide disparity is due to the nature of the processing being performed
by the web application. It is calculating an aggregated result (the total value of all
orders) from a large volume of data.

![Telemetry for the `AggregateOnClientAsync` method][TelemetryAggregateOnClient]

### Identifying slow queries

Tracing execution and analyzing the application source code and data access logic
might reveal that a number of different queries are performed as the application runs.
You should concentrate on those that consume the most resources and take the most time
to execute. You can add instrumentation to determine the start and completion times
for many database operations enabling you to work out the duration. However, many data
stores also provide in-depth information on the way in which queries are performed and
optimized. For example, the Query Performance pane in the Azure SQL Database
management portal enables you to select a query and drill into the detailed runtime
performance information for that query. The figure below shows the query generated by the `GetAllFieldsAsync` operation.

![The Query Details pane in the Windows Azure SQL Database management portal][QueryDetails]

The statistics summarize the resources used by this query.

----------

**Note:** The statistics shown in this image were not generated by running the
load tests, but were obtained by monitoring the system in production. However, the
statistics are still valid as they give an indication of how the query uses resources
and this is not dependent on whether the system is under test at the time.

----------

### Performing a resource-specific analysis of the slow-running queries

Examining the queries frequently performed against a data source, and the way an application uses this information, can provide insight into how key operations
might be speeded up. In some cases, it may be advisable to partition resources
horizontally if different attributes of the data (columns in a relational table, or
fields in a NoSQL store) are accessed separately by different functions,this can help
to reduce contention. Often 90% of operations are run against 10% of the data held in
the various data sources, so spreading this load may improve performance.

Depending on the nature of the data store, you may be able to exploit the features
that it implements to efficiently store and retrieve information. For example, if an
application requires an aggregation over a number of items (such as a count, sum, min
or max operation), SQL databases typically provide aggregate functions that can
perform these operations without requiring that an application fetches all of the data
and implement the calculation itself. In other types of data store, it may be possible
to maintain this information separately within the store as records are added,
updated, or removed, eliminating the requirement of an application to fetch a
potentially large amount of data and perform the calculation itself.

If you observe requests that retrieve a large number of fields, examine the underlying
source code to determine whether all of these fields are actually necessary. Sometimes
these requests are the result of ill-advised `SELECT *` operations, or misplaced
`.Include` operations in LINQ queries. Similarly, requests that retrieve a large
number of entities (rows in a SQL Server database) may indicate an application
that is not filtering data correctly. Verify that all of these entities are actually
necessary, and implement database-side filtering if possible (for example, using a
`WHERE` clause in an SQL statement.) For operations that have to support unbounded
queries, the system should implement pagination and only fetch a limited number (a
*page*) of entities at a time.

----------

**Note:** If analysis shows that none of these situations apply, then extraneous
fetching is unlikely to be the cause of poor performance and you should look
elsewhere.

----------

## How to correct the problem

Only fetch the required data, avoid transmitting large volumes of data that
may quickly become outdated or might be discarded, and only fetch the data appropriate
to the operation being performed. The following examples describe possible solutions
to many of the scenarios listed earlier:

- In the example that retrieves product information, perform the projection at the
database rather than fetching and filtering data in the application code.

**C# Web API**

```C#
[HttpGet]
[Route("api/requiredfields")]
public async Task<IHttpActionResult> GetRequiredFieldsAsync()
{
    using (var context = new AdventureWorksContext())
    {
        // project fields as part of the query itself
        var result = await context.Products
            .Select(p => new ProductInfo {Id = p.ProductId, Name = p.Name})
            .ToListAsync();

        return Ok(result);
    }
}
```

----------

**Note:** This code is available in the [sample solution][fullDemonstrationOfSolution]
provided with this antipattern.

----------

- In the example that aggregates information held in a database, perform the
aggregation in the database rather than in the client application code.

**C# Web API**

```C#
[HttpGet]
[Route("api/aggregateondatabase")]
public async Task<IHttpActionResult> AggregateOnDatabaseAsync()
{
    using (var context = new AdventureWorksContext())
    {
        // fetch the sum of all order totals, as computed on the database server
        var total = await context.SalesOrderHeaders.SumAsync(soh => soh.TotalDue);

        return Ok(total);
    }
}
```

- Wherever possible, ensure that LINQ queries are resolved by using the `IQueryable`
interface rather than `IEnumerable`. This may be a matter of rephrasing a query to use
only the features and functions that can be mapped by LINQ to features available in
the underlying data source, or adding user-defined functions to the data source that
can perform the required operations on the data before returning it. In the example
shown earlier, the code can be refactored to remove the problematic `AddDays` function
from the query, allowing filtering to be performed by the database.


**C# Entity Framework**

``` C#
var context = new AdventureWorks2012Entities();

DateTime dateSince = DateTime.Now.AddDays(-7);
var query = from p in context.Products
            where p.SellStartDate < dateSince // AddDays has been factored out. This criterion can be passed to the database by LINQ to Entities
            select ...;

List<Product> products = query.ToList();
```

## <a name="ConsequencesOfTheSolution"></a>Consequences of the solution

The system should spend less time waiting for I/O, network traffic should be
diminished, and contention for shared data resources should be decreased. This should
show an improvement in response time and throughput in an application.
Performing load testing against the `GetRequiredFieldsAsync` method in the [sample solution][fullDemonstrationOfSolution] shows the following results:

![Load test results for the GetRequiredFieldsAsync method][Load-Test-Results-Database-Side1]

This load test was performed on the same deployment and using the same simulated
workload of 400 concurrent users as before. The graph shows much lower latency, the
response time rises with load to approximately 1.3 seconds compared to 4 seconds in
the previous case. The throughput is also higher at 350 requests per second compared
to 100 earlier. These changes are apparent from the telemetry gathered while the test
was running.

![Telemetry for the `GetRequiredFieldsAsync` method][TelemetryRequiredFields]

The volume of data retrieved from the database now closely matches the size of the
HTTP response messages sent back to the client applications.

Load testing using the `AggregateOnDatabaseAsync` method generates the following results:

![Load test results for the AggregateOnDatabaseAsync method][Load-Test-Results-Database-Side2]

The average response time is now minimal. This is an order of magnitude improvement
in performance, caused primarily by the vast reduction in I/O from the database.

The image below shows the corresponding telemetry for the `AggregateOnDatabaseAsync`
method.

![Telemetry for the `AggregateOnDatabaseAsync` method][TelemetryAggregateInDatabaseAsync]

The amount of data retrieved from the database was vastly reduced, from over 280Kb per
transaction to 53 bytes. Consequently, the maximum sustained number of requests per
minute was raised from around 2,000 to over 25,000.

----------

**Note:** The solution to this antipattern does not imply that you should always
offload processing to the database. You should only perform this strategy where the
database is designed or optimized to do so. Databases are intended to manipulate the
data that they contain very efficiently, but in many cases they are not designed to
act as complete <<RBC: Normally you'd say fullfledged, but even that seems like the easiest to parse for ESL readers. Does this work?>> application engines. Using the processing power of a database
server inappropriately can cause contention and slow down database operations. For
more information, see the [Busy Database antipattern][BusyDatabase]

----------

## Related resources
- [The performance implications of IEnumerable vs. IQueryable][IEnumerableVsIQueryable].

[fullDemonstrationOfProblem]: https://github.com/mspnp/performance-optimization/tree/master/ExtraneousFetching
[fullDemonstrationOfSolution]: https://github.com/mspnp/performance-optimization/tree/master/ExtraneousFetching
[chatty-io]: ../chatty-io/index.md
[MonolithicPersistence]: ../monolithic-persistence/index.md
[BusyDatabase]: ../busy-database/index.md
[IEnumerableVsIQueryable]: https://www.sellsbrothers.com/posts/Details/12614
[full-product-table]:_images/ProductTable.jpg
[product-sales-table]:_images/SalesOrderHeaderTable.jpg
[Load-Test-Results-Client-Side1]:_images/LoadTestResultsClientSide1.jpg
[Load-Test-Results-Client-Side2]:_images/LoadTestResultsClientSide2.jpg
[Load-Test-Results-Database-Side1]:_images/LoadTestResultsDatabaseSide1.jpg
[Load-Test-Results-Database-Side2]:_images/LoadTestResultsDatabaseSide2.jpg
[QueryPerformanceZoomed]: _images/QueryPerformanceZoomed.jpg
[QueryDetails]: _images/QueryDetails.jpg
[End-to-End]: _images/End-to-End.jpg
[TelemetryAllFields]: _images/TelemetryAllFields.jpg
[TelemetryAggregateOnClient]: _images/TelemetryAggregateOnClient.jpg
[TelemetryRequiredFields]: _images/TelemetryRequiredFields.jpg
[TelemetryAggregateInDatabaseAsync]: _images/TelemetryAggregateInDatabase.jpg

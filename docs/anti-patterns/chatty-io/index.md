---
title: Chatty I/O antipattern
description: 

author: dragon119
manager: christb

pnp.series.title: Optimize Performance
---
# Chatty I/O antipattern
[!INCLUDE [header](../../_includes/header.md)]

Network calls and other I/O operations are inherently slow compared to compute tasks.
Each I/O request typically incorporates significant overhead, and the cumulative effect
of a large number of requests can have a significant impact on the performance and
responsiveness of the system.

Common examples of chatty I/O operations include: <<RBC: The other patterns tend to use this language: "This antipattern typically occurs because:" Is that not applicable here? Should we use consistent terminology?>>

- Reading and writing individual records to a database as distinct requests. The
following code snippet shows part of a controller in a service implemented using Web
API. The example is based on the AdventureWorks2012 database. In this database, products
are grouped into subcategories and are held in the `Product` and `ProductSubcategory`
tables respectively. Pricing information for each product is held in a separate table
named `ProductListPriceHistory`. The  `GetProductsInSubCategoryAsync` method shown below
retrieves the details for all products (including price information) for a specified
subcategory. The method achieves this by using the Entity Framework to perform the
following operations:

	- Fetch the details of the specified subcategory from the `ProductSubcategory` table.

	- Find all products in the subcategory by querying the `Product` table.

	- For each product, retrieve the price data from the `ProductPriceListHistory` table.

**C# Web API**

```C#
public class ChattyProductController : ApiController
{
    [HttpGet]
    [Route("chattyproduct/products/{subcategoryId}")]
    public async Task<IHttpActionResult> GetProductsInSubCategoryAsync(int subcategoryId)
    {
        using (var context = GetContext())
        {
            var productSubcategory = await context.ProductSubcategories
                   .Where(psc => psc.ProductSubcategoryId == subcategoryId)
                   .FirstOrDefaultAsync();

            if (productSubcategory == null)
            {
                // The subcategory was not found.
                return NotFound();
            }

            productSubcategory.Product = await context.Products
                .Where(p => subcategoryId == p.ProductSubcategoryId)
                .ToListAsync();

            foreach (var prod in productSubcategory.Product)
            {
                int productId = prod.ProductId;

                var productListPriceHistory = await context.ProductListPriceHistory
                   .Where(pl => pl.ProductId == productId)
                   .ToListAsync();

                prod.ProductListPriceHistory = productListPriceHistory;
            }

            return Ok(productSubcategory);
        }
    }
    ...
}
```

----------

**Note:** This code forms part of the [ChattyIO sample application][fullDemonstrationOfProblem]. 

----------

- Sending a series of requests that constitute a single logical operation to a web
service. This often occurs when a system attempts to follow an object-oriented paradigm
and handle remote objects as though they were local items held in application memory.
This approach can result in an excessive number of network round trips. For example, the
following Web API exposes the individual properties of `User` objects through a REST
interface. Each method in the REST interface takes a parameter that identifies a user.
While this approach is efficient if an application only needs to obtain one selected
piece of information, in many cases it is likely that the application will actually
require more than one property of a `User` object, resulting in multiple requests as
shown in the C# client code snippet.

**C# Web API**

```C#
public class User
{
    public int UserID { get; set; }
    public string UserName { get; set; }
    public char? Gender { get; set; }
    public DateTime? DateOfBirth { get; set; }
    ...
}
...
public class UserController : ApiController
{
    ...
    // GET: /Users/{id}/UserName
    [HttpGet]
    [Route("users/{id:int}/username")]
    public HttpResponseMessage GetUserName(int id)
    {
        ...
    }

    // GET: /Users/{id}/Gender
    [HttpGet]
    [Route("users/{id:int}/gender")]
    public HttpResponseMessage GetGender(int id)
    {
        ...
    }

    // GET: /Users/{id}/DateOfBirth
    [HttpGet]
    [Route("users/{id:int}/dateofbirth")]
    public HttpResponseMessage GetDateOfBirth(int id)
    {
        ...
    }
}
```

**C# client**
```C#
var client = new HttpClient();
client.BaseAddress = new Uri("...");
...
// Fetch the data for user 1
HttpResponseMessage response = await client.GetAsync("users/1/username");
response.EnsureSuccessStatusCode();
var userName = await response.Content.ReadAsStringAsync();

response = await client.GetAsync("users/1/gender");
response.EnsureSuccessStatusCode();
var gender = await response.Content.ReadAsStringAsync();

response = await client.GetAsync("users/1/dateofbirth");
response.EnsureSuccessStatusCode();
var dob = await response.Content.ReadAsStringAsync();
...
```
- Reading and writing to a file on disk. Performing file I/O involves opening a file and
moving to the appropriate point before reading or writing data. When the operation is
complete, the file might be closed to save operating system resources. An application that
continually reads and writes small amounts of information to a file will generate
significant I/O overhead. Note that repeated small write requests can also lead to file
fragmentation, slowing subsequent I/O operations still further. The following example
shows part of an application that creates new *Customer* objects and writes customer
information to a file. The details of each customer are stored using the
*SaveCustomerToFileAsync* method immediately after it is created. Note that the
*FileStream* object utilized for writing to the file is created and destroyed
automatically as a result of being managed by a *using* block. Each time the *FileStream*
object is created the specified file is opened, and when the *FileStream* object is
destroyed the file is closed. If this method is invoked repeatedly as new customers are
added, the I/O overhead can quickly accumulate.

**C#**

```C#
[Serializable]
public class Customer
{
    public int Id { get; set; }
    public string Name { get; set; }
    ...
}
...
// Create a new customer and save it to a file
var cust = new Customer(...);
await SaveCustomerToFileAsync(cust);
...
// Save a single customer object to a file
private async Task SaveCustomerToFileAsync(Customer cust)
{
    using (Stream fileStream = new FileStream(CustomersFileName, FileMode.Append))
    {
        BinaryFormatter formatter = new BinaryFormatter();
        byte [] data = null;
        using (MemoryStream memStream = new MemoryStream())
        {
            formatter.Serialize(memStream, cust);
            data = memStream.ToArray();
        }
        await fileStream.WriteAsync(data, 0, data.Length);
    }
}
```


## How to detect the problem

Symptoms of chatty I/O include high latency and low throughput. End users are likely to
report extended response times and possible failures caused by services timing out due to
increased contention for I/O resources.

You can perform the following steps to help identify the causes of any problems:

1. Identify operations with poor response times by performing process monitoring of the
production system.

2. Perform controlled load testing of each operation identified in step 1.

3. Monitor the system under test to gather telemetry data about the data access requests
made by each operation.

4. Gather detailed data access statistics for each request sent to a data store by each
operation.

5. If necessary, profile the application in the test environment to establish where
possible I/O bottlenecks might be occurring.

The following sections apply these steps to the sample application described earlier.

----------

**Note:** If you already have an insight into where problems might lie, you may be able
to skip some of these steps. However, you should avoid making unfounded or biased
assumptions. Performing a thorough analysis can sometimes lead to the identification of
unexpected causes of performance problems. The following sections are formulated to help
you to examine applications and services systematically.

----------

### Load testing the application

The key task in determining the possible causes of poor performance is to examine
operations that are running slowly. With this in mind, performing load testing in a
controlled environment against suspect areas of functionality can help to establish a
baseline, and monitoring how the application runs while executing the load tests can
provide useful insights into how the system might be optimized.

Running load tests against the `GetProductsInSubCategoryAsync` operation in the
`ChattyProduct` controller in sample application yields the following results.

![Key indicators load-test results for the chatty I/O sample application][key-indicators-chatty-io]

This load test was performed using a simulated step workload of up to 1000 concurrent
users. The graph shows a high degree of latency, the median response time is measured in
10s of seconds per request. If each test represents a user querying the product catalog
to find the details of products in a specified subcategory then with a loading of 1000
users, a customer might have to wait for nearly a minute to see the results under this
load.

----------

**Note:** The application was deployed as a medium size Azure website. The database was
deployed on a premium P3 instance of Azure SQL Database configured with a connection pool
supporting up to 1000 concurrent connections (to reduce the chances of connecting to the
database itself causing contention.) The results shown in the [Consequences of this
solution](#Consequences) section were generated using the same stepped load on the same
deployment.

----------

### Monitoring the application

You can use an application performance monitoring (APM) package to capture and analyze
the key metrics that identify potentially chatty I/O. The exact metrics will depend on
the nature of the source or destination of the I/O requests. In the case of the sample
application, the interesting I/O requests are those directed at the instance of Azure
SQL Database holding the AdventureWorks2012 database. In other applications, you may need
to examine the volume and I/O rates to other data sources, files, or external web
services.

The following image shows the results generated using New Relic <<RBC: Do we want to link to them, or at least indicate that it's a third-party tool?>> as the APM while
running the load test for the sample application. The `GetProductsInSubCategoryAsync`
operation causes a significant volume of database traffic, with the average amount of
time peaking at approximately 5.6 seconds per request during the maximum workload used by
the test. The system was able to support 410 requests per minute, on average throughout
the test.

![Overview of traffic hitting the AdventureWorks2012 database][databasetraffic]

### Gathering detailed data access information

Examining data access statistics and other information provided by the data store acting
as the repository can yield detailed information about the frequency with which specific
data is requested. Using the Databases tab in the New Relic APM reveals that the sample
application executes three SQL SELECT statements. These SELECT statements correspond to
the requests generated by the Entity Framework. They fetch data from the
`ProductListPriceHistory`, `Product`, and `ProductSubcategory` tables in the database.
Furthermore, the query that retrieves data from the `ProductListPriceHistory` table is by
far the most frequently executed SELECT statement.

![Queries performed by the sample application under test][queries]

Taking a closer look at the work performed by the `GetProductsInSubCategoryAsync`
operation by examining web transaction trace information reveals that this operation
performs 45 SELECT queries, each of which causes the application to open a new SQL
connection:

![Query statistics for the sample application under test][queries2]

----------

**Note:** The trace information shown is for the slowest instance of the
`GetProductsInSubCategoryAsync` operation performed by the load test. In a production
environment, you should examine the traces of as many slow-running operations as possible
to determine whether there is a pattern in the behavior of these operations that suggests
why they might be running slowly.

----------

The Trace details tab provides a complete list of the tasks performed by the operation
under scrutiny. You can clearly see the repeated requests to open a new database
connection and retrieve data from the `ProductListPriceHistory` table.

![Transaction trace details for the sample application under test][transactiontrace1]

You can click the SQL statements tab in the Transaction trace pane if you wish to examine
the SQL code for each statement in more detail. This information can provide an insight
into how an object-relational mapping system such as the Entity Framework interacts with
a database, and can help to indicate areas where data access might be optimized.

![Query details for the sample application under test][queries3]

In the sample application it is clear that the query that fetches product list price
history information is being run for each individual product in the product subcategory
specified by the user at runtime. If this information could be retrieved as part of the
request that retrieves the details of each product then the number of queries could be
substantially reduced, although the volume of data returned by each query will be
increased considerably.

----------

**Note:** When considering how you might reduce the overhead of a chatty interface, you
must consider the effects of retrieving larger volumes of data with each request. If this
data is required by the client, then fewer, larger requests will be more optimal than
making many small requests. This issue is described in more detail in the [How to correct the problem](#HowToCorrectTheProblem) section. <<RBC: One of the things I like about this doc set is the lack of internal linking. I find excessive internal linking annoying, especially in such a short doc. Isn't it obvious that the issue is discussed in the how to solve the problem section? Is this sentence needed?>>

----------

### Profiling the application

Profiling an application can help to identify the following low-level symptoms that
characterize chatty I/O operations. The exact symptoms will depend on the nature of the
resources being accessed but may include:

- A large number of small I/O requests made to the same file.

- A large number of small network requests made by an application instance to the same
service.

- A large number of small requests made by an application instance to the same data
store.

- Applications and services becoming I/O bound.

## <a name="HowToCorrectTheProblem"></a>How to correct the problem

Reduce the number of I/O requests by packaging the data that your application reads or
writes into larger, fewer requests, as illustrated by the following examples:

- In the chatty I/O <<RBC: Should this be ChattyIO (the name of the sample) or chatty I/O a generic reference to the example? I picked the latter because other refs in the doc used this and it's easier to read when you're not pointing them at the actual code file.>> example, rather than retrieving data using separate queries, fetch
the information required in a single query as shown in the `ChunkyProduct` controller
below:

**C# Web API**

```C#
public class ChunkyProductController : ApiController
{
    [HttpGet]
    [Route("chunkyproduct/products/{subCategoryId}")]
    public async Task<IHttpActionResult> GetProductCategoryDetailsAsync(int subCategoryId)
    {
        using (var context = GetContext())
        {
            var subCategory = await context.ProductSubcategories
                  .Where(psc => psc.ProductSubcategoryId == subCategoryId)
                  .Include("Product.ProductListPriceHistory")
                  .FirstOrDefaultAsync();

            if (subCategory == null)
                return NotFound();

            return Ok(subCategory);
        }
    }
    ...
}
```
----------

**Note:** This code is available in the [ChattyIO sample application][fullDemonstrationOfSolution] provided with this antipattern.

----------

- In the `UserController` example shown earlier, rather than exposing individual
properties of `User` objects through the REST interface, provide a method that retrieves
an entire `User` object within a single request.

**C# Web API**

```C#
public class User
{
    public int UserID { get; set; }
    public string UserName { get; set; }
    public char? Gender { get; set; }
    public DateTime? DateOfBirth { get; set; }
}
...
public class UserController : ApiController
{
    ...
    // GET: /Users/{id}
    [HttpGet]
    [Route("users/{id:int}")]
    public HttpResponseMessage GetUser(int id)
    {
        ...
    }
}
```
**C# client**

```C#
var client = new HttpClient();
client.BaseAddress = new Uri("...");
...
// Fetch the data for user 1
HttpResponseMessage response = await client.GetAsync("users/1");
response.EnsureSuccessStatusCode();
var user = await response.Content.ReadAsStringAsync();
...
```

- In the file I/O example, you could buffer data in memory and provide a separate
operation that writes the buffered data to the file as a single operation. This approach
reduces the overhead associated with repeatedly opening and closing the file, and helps
to reduce fragmentation of the file on disk.

**C#**
```C#
[Serializable]
public class Customer
{
    public int Id { get; set; }
    public string Name { get; set; }
    ...
}
...

// In-memory buffer for customers
List<Customer> customers = new List<Customers>();
...

// Create a new customer and add it to the buffer
var cust = new Customer(...);
customers.Add(cust);

// Add further customers to the list as they are created
...

// Save the contents of the list, writing all customers in a single operation
await SaveCustomerListToFileAsync(customers);
...

// Save a list of customer objects to a file
private async Task SaveCustomerListToFileAsync(List<Customer> customers)
{
    using (Stream fileStream = new FileStream(CustomersFileName, FileMode.Append))
    {
        BinaryFormatter formatter = new BinaryFormatter();
        foreach (var cust in customers)
        {
            byte[] data = null;
            using (MemoryStream memStream = new MemoryStream())
            {
                formatter.Serialize(memStream, cust);
                data = memStream.ToArray();
            }
            await fileStream.WriteAsync(data, 0, data.Length);
        }
    }
}
```

As well as buffering data for output, you should also consider caching data retrieved
from a service. This can help to reduce the volume of I/O being performed by avoiding
repeated requests for the same data. For more information, see the [Caching Guidance][caching-guidance].

You should consider the following points:

- When reading data, do not make your I/O requests too large. An application should only
retrieve the information that it is likely to use. It may be necessary to partition the
information for an object into two chunks, *frequently accessed data* that accounts for
90% of the requests and *less frequently accessed data* that is used only 10% of the
time. When an application requests data, it should be retrieve  the *90%* chunk. The
*10%* chunk should only be fetched if necessary. If the *10%* chunk constitutes a large
proportion of the information for an object this approach can save significant I/O overhead.

- When writing data, avoid locking resources for longer than necessary to reduce the
chances of contention during a lengthy operation. If a write operation spans multiple
data stores, files, or services then adopt an eventually consistent approach (see
[Data Consistency guidance][data-consistency-guidance] for details).

- Data buffered in memory to optimize write requests is vulnerable if the application
crashes and may be lost.  If the data rate is bursty <<RBC: Is there another word we can use here? This isn't a common term (on 24 hits on MSDN library) it seems fairly clear, but I wonder if ESL readers will understand it?>> or relatively sparse, buffering the data in an external durable queue (such as [Event Hubs](http://azure.microsoft.com/en-us/services/event-hubs/)) may be more appropriate to protect against losing a significant amount of in-memory buffered data.

## <a name="Consequences"></a>Consequences of the solution

The system should spend less time performing I/O, and contention for I/O resources should
be decreased. This should manifest itself as an improvement in response time and
throughput in an application. However, you should ensure that each request only fetches
the data that is likely to be required. Making requests that are far too big can be as
damaging for performance as making lots of small requests, avoid retrieving data
speculatively. For more information, see the [Extraneous Fetching][extraneous-fetching]
antipattern.

Performing load testing against the chatty I/O sample application using the `chunky`
API generated the following results:

![Key indicators load test results for the chunky API in the chatty I/O sample application][key-indicators-chunky-io]

This load test was performed on the same deployment and using the same simulated step
workload of up to 1000 concurrent users as before. This time the graph shows much lower
latency. The average request time at 1000 users is between 5 and 6 seconds. A user
querying the product catalog to find the details of products in a specified subcategory
will now wait for significantly less than 10 seconds to see the results compared to
nearly a minute in the earlier tests.

For comparison purposes, the following image shows the transaction overview for the
chunky API. Notice that this time the system supported and average of 3970 requests per
minute compared to 410 for the earlier test.

![Transaction overview for the chunky API][databasetraffic2]

The web trace details for the slowest instance of an operation performed using the
chunky API shows that this time there are no repeated *open connection* and *fetch list
price history* cycles. Instead, the trace shows a single SELECT statement being run.

![Transaction trace details for the chunky API][transactiontrace2]

The SQL tab shows that the application now performs the following query that fetches all
the data required for the operation as a single SELECT statement.

![Query details for the chunky API][queries4]

Although this query is considerably more complex than that used by the chatty API, this
complexity is offset by virtue of the fact that it is performed only once. Additionally,
there is no wasted effort in retrieving unnecessary data as the information returned by
the chunky API is the same as that retrieved by the chatty API.

## Related resources

- [Data Consistency guidance][data-consistency-guidance].

- [Caching Guidance][caching-guidance]

[fullDemonstrationOfProblem]: https://github.com/mspnp/performance-optimization/tree/master/ChattyIO
[fullDemonstrationOfSolution]: https://github.com/mspnp/performance-optimization/tree/master/ChattyIO
[data-consistency-guidance]: http://https://msdn.microsoft.com/library/dn589800.aspx
[extraneous-fetching]: ../extraneous-fetching/index.md
[caching-guidance]: https://msdn.microsoft.com/library/dn589802.aspx
[key-indicators-chatty-io]: _images/ChattyIO.jpg
[key-indicators-chunky-io]: _images/ChunkyIO.jpg
[databasetraffic]: _images/DatabaseTraffic.jpg
[databasetraffic2]: _images/DatabaseTraffic2.jpg
[queries]: _images/DatabaseQueries.jpg
[queries2]: _images/DatabaseQueries2.jpg
[queries3]: _images/DatabaseQueries3.jpg
[queries4]: _images/DatabaseQueries4.jpg
[transactiontrace1]: _images/TransactionTrace.jpg
[transactiontrace2]: _images/TransactionTrace2.jpg

---
title: Improper Instantiation antipattern
description: 

author: dragon119
manager: christb

pnp.series.title: Optimize Performance
---
# Improper Instantiation antipattern
[!INCLUDE [header](../../_includes/header.md)]

Many .NET Framework libraries provide abstractions about <<RBC: I suspect this is just a pet peeve of mine. I hate using the word "around" this way. I think about or surrounding are more precise, but it's one of those changes that I can live with you rejecting.>> external resources.
Internally, these classes typically manage their own connections to these external
resources, effectively acting as brokers that clients can use to request access to a
resource. Examples of such classes frequently used by Azure applications include
`System.Net.Http.HttpClient` to communicate with a web service using the HTTP
protocol, `Microsoft.ServiceBus.Messaging.QueueClient` for posting and receiving
messages to a Service Bus queue, `Microsoft.Azure.Documents.Client.DocumentClient`
for connecting to an Azure DocumentDB instance, and
`StackExchange.Redis.ConnectionMultiplexer` for accessing Azure Redis Cache.

These *broker* classes can be expensive to create. Instead, they are intended to be
instantiated once and reused throughout the life of an application. However, it is
common to misunderstand how these classes are intended to be used, and instead treat
them as resources that should be acquired only as necessary and released quickly, as
shown by the following code snippet that demonstrates the use of the `HttpClient`
class in a web API controller. The `GetProductAsync` method retrieves product 
information from a remote web service.

**C# Web API**
``` C#
public class NewHttpClientInstancePerRequestController : ApiController
{
    // This method creates a new instance of HttpClient and disposes it for every call to GetProductAsync.

    public async Task<Product> GetProductAsync(string id)
    {
        using (var httpClient = new HttpClient())
        {
            var hostName = HttpContext.Current.Request.Url.Host;
            var result = await httpClient.GetStringAsync(string.Format("http://{0}:8080/api/...", hostName));

            return new Product { Name = result };
        }
    }
}
```

----------

**Note:** This code forms part of the [ImproperInstantiation sample application][fullDemonstrationOfProblem].

----------

In a web application this technique is not scalable. Each user request creates <<RBC: Are all those words necessary, or does this work?>> a new `HttpClient` object. Under a heavy load, the web server can exhaust
the number of sockets available resulting in `SocketException` errors.

This problem is not restricted to the `HttpClient` class. Creating many instances of
other classes that wrap resources or are expensive to create might cause similar
issues, or at least slow down the performance of the application as they are
continually created and destroyed. Consider the following code
showing an alternative implementation of the `GetProductAsync` method. This time the
data is retrieved from an external service wrapped by using the
`ExpensiveToCreateService` class.

**C# Web API**
``` C#
public class NewServiceInstancePerRequestController : ApiController
{
    // This method creates a new instance of ProductRepository and disposes it for every call to GetProductAsync.
    public async Task<Product> GetProductAsync(string id)
    {
        var expensiveToCreateService = new ExpensiveToCreateService();
        return await expensiveToCreateService.GetProductByIdAsync(id);
    }
}
```

In this code, the `ExpensiveToCreateService` could be any shareable service or broker
class that takes considerable effort to construct. As with the `HttpClient` example,
continually creating and destroying instances of this class might adversely affect the
scalability of the system.

----------

**Note:** The key element of this antipattern is that an application repeatedly
creates and destroys instances of a **shareable** object. If a class is not shareable
(if it is not thread-safe), then this antipattern does not apply.

----------

## How to detect the problem

Symptoms of the *Improper Instantiation* problem include a drop in throughput,
possibly with an increase in exceptions indicating exhaustion of related resources
(sockets, database connections, file handles, and so on). End users are likely to
report degraded performance and frequent request failures when the system is heavily
utilized.

You can perform the following steps to help identify this problem:

1. Identify points at which response times slow down or the system fails due to lack
of resources, by performing process monitoring of the production system.

2. Examine the telemetry data captured at these points to determine which operations
might be creating and destroying resource-consuming objects as the system slows down
or fails.

3. Perform load testing of each of the operations identified by step 2. Use a
controlled test environment rather than the production system.

4. Review the source code for the possible problematic <<RBC: Just saying possible seems too vague in this context. Does this work, or is there a better way to phrase this from a technical perspective?>> operations and examine the logic behind the
the lifecycle of the broker objects being created and destroyed.

The following sections apply these steps to the sample application described earlier.

----------

**Note:** If you already have an insight into where problems might lie, you may be
able to skip some of these steps. However, you should avoid making unfounded or biased
assumptions. Performing a thorough analysis can sometimes lead to the identification
of unexpected causes of performance problems. The following sections are formulated to
help you to examine applications and services systematically.

----------

### Identifying points of slow down or failure

Instrumenting each operation in the production system to track the duration of each
request and then monitoring the live system can help to provide an overall view of how
the requests perform. You should monitor the system and track which operations are
long-running or cause exceptions.

The following image shows the Overview pane of the New Relic <<RBC: If you decide to do something based on my comments in other docs, this should match.>> monitor dashboard,
highlighting operations that have a poor response time and the increased error rate
that occurs while these operations are running. This telemetry was gathered while the
system was undergoing load testing, but similar observations are likely to occur in
the live system during periods of high usage. In this case, operations that
invoke the `GetProductAsync` method in the `NewHttpClientInstancePerRequest`
controller are worth investigating further.

![The New Relic monitor dashboard showing the sample application creating a new instance of an HttpClient object for each request][dashboard-new-HTTPClient-instance]

You should also look for operations that trigger increased memory use and garbage
collection, as well as raised levels of network, disk, or database activity as
connections are made, files are opened, or database connections established.

### Examining telemetry data and finding correlations

You should examine stack trace information for operations that have been identified as
slow-running or that generate exceptions when the system is under load. This
information can help to identify how these operations are utilizing resources, and
exception information can be used to determine whether errors are caused by the system
exhausting shared resources. The image below shows data captured using thread
profiling for the period corresponding to that shown in the previous image. Note that
the system spends a significant time opening socket connections and even more time
closing them and handling socket exceptions.

![The New Relic thread profiler showing the sample application creating a new instance of an HttpClient object for each request][thread-profiler-new-HTTPClient-instance]

### Performing load testing

You can use load testing based on workloads that emulate the typical sequence of
operations that users might perform to help identify which parts of a system suffer
from resource exhaustion under varying loads. You should perform these tests in a
controlled environment rather than the production system. The following graph shows
the throughput of requests directed at the `NewHttpClientInstancePerRequest`
controller in the sample application as the user load is increased up to 100  
concurrent users.

![Throughput of the sample application creating a new instance of an HttpClient object for each request][throughput-new-HTTPClient-instance]

The volume of requests handled per second increases at the 10-user point due to the
increased workload up to approximately 30 users. At this point, the volume of
successful requests reaches a limit and the system starts to generate exceptions. The
volume of these exceptions gradually increases with the user load. These failures are
reported by the load test as HTTP 500 (Internal Server) errors. Reviewing the
telemetry (shown earlier) for this test case reveals that these errors are caused by
the system running out of socket resources as more and more `HttpClient` objects are
created.

The second graph below shows the results of a similar test performed using the
`NewServiceInstancePerRequest` controller. This controller does not use `HttpClient`
objects, but instead utilizes a custom object (`ExpensiveToCreateService`) to fetch
data.

![Throughput of the sample application creating a new instance of the ExpensiveToCreateService for each request][throughput-new-ExpensiveToCreateService-instance]

This time, although the controller does not generate any exceptions, throughput still
reaches a plateau while the average response time increases by a factor of 20 with
user load. *Note that the scale for the response time and throughput are logarithmic,
so the rate at which the response time grows is actually more dramatic than appears at
first glance.* Examining the telemetry for this code reveals that the main causes of
this limitation are the time and resources spent creating new instances of the
`ExpensiveToCreateService` for each request.

### Reviewing the code

Once you have managed to identify which parts of an application are causing the system
to slow down or generate exceptions due to resource exhaustion, perform a review of
the code or use profiling to find out how shareable objects are being instantiated,
used, and destroyed. Where appropriate, refactor the code to cache and reuse objects,
as described in the following section.

## How to correct the problem

If the class wrapping the external resource is shareable and thread-safe, either
create a shared singleton instance or a pool of reusable instances of the class. The
following code snippet shows a simple example. The `SingleHttpClientInstance`
controller performs the same operation as the `NewHttpClientInstancePerRequest`
controller shown earlier, except that the `HttpClient` object is created once, in the
constructor, rather than each time the `GetProductAsync` operation is invoked. This
approach reuses the same `HttpClient` object sharing the connection across all
requests.

**C# Web API**
```C#
public class SingleHttpClientInstanceController : ApiController
{
    private static readonly HttpClient HttpClient;

    static SingleHttpClientInstanceController()
    {
        HttpClient = new HttpClient();
    }

    // This method uses the shared instance of HttpClient for every call to GetProductAsync.
    public async Task<Product> GetProductAsync(string id)
    {
        var hostName = HttpContext.Current.Request.Url.Host;
        var result = await HttpClient.GetStringAsync(string.Format("http://{0}:8080/api/...", hostName));

        return new Product { Name = result };
    }
}
```

----------

**Note:** This code is available in the [sample solution][fullDemonstrationOfSolution]
provided with this antipattern.

----------

Similarly, assuming that the `ExpensiveToCreateService` was also designed to be
shareable, you can refactor the `NewServiceInstancePerRequest` controller in the same
manner.

**C# Web API**
```C#
public class SingleServiceInstanceController : ApiController
{
    private static readonly ExpensiveToCreateService ExpensiveToCreateService;

    static SingleServiceInstanceController()
    {
        ExpensiveToCreateService = new ExpensiveToCreateService();
    }

    // This method uses the shared instance of ExpensiveToCreateService for every call to GetProductAsync.
    public async Task<Product> GetProductAsync(string id)
    {
        return await ExpensiveToCreateService.GetProductByIdAsync(id);
    }
}
```

You should consider the following points:

- The type of shared resource might dictate whether you should use a singleton or
create a pool. The example shown above creates a single `ProductRepository` object,
and by extension a single `HttpClient` object. This is because the `HttpClient` class
is designed to be shared rather than pooled. Other types of objects might support
pooling, enabling the system to spread the workload across multiple instances.

- Objects that you share across multiple requests **must** be thread-safe. The
`HttpClient` class is designed to be used in this manner, but other classes might not
support concurrent requests, so check the available documentation.

- In the .NET Framework, many objects that establish connections to external resources
are created by using static factory methods of other classes that manage these
connections. The objects created are intended to be saved and reused rather than being
destroyed and recreated as required. For example, the
[Best Practices for Performance Improvements Using Service Bus Brokered Messaging][best-practices-service-bus] page contains the following comment:

----------

Service Bus client objects, such as `QueueClient` or `MessageSender`, are created through a
`MessagingFactory` object, which also provides internal management of connections. You should not
close messaging factories or queue, topic, and subscription clients after you send a message, and
then re-create them when you send the next message. Closing a messaging factory deletes the
connection to the Service Bus service, and a new connection is established when recreating the
factory. Establishing a connection is an expensive operation that can be avoided by re-using the
same factory and client objects for multiple operations.

----------

- Only use this approach where it is appropriate. You should always release scarce resources once
you have finished with them, and acquire them only on an as-needed basis. A common example is a
database connection. Retaining an open connection that is not required may prevent other
concurrent users from gaining access to the database.

## Consequences of the solution

The system should be more scalable, offer a higher throughput (the system is wasting less time
acquiring and releasing resources and is therefore able to spend more time doing useful work),
and report fewer errors as the workload increases. The following graph shows the load test
results for the sample application, using the same workload as before, but invoking the
`GetProductAsync` method in the `SingleHttpClientInstance` controller.

![Throughput of the sample application reusing the same instance of an HttpClient object for each request][throughput-single-HTTPClient-instance]

No errors were reported, and the system was able to handle an increasing load of up to
 <<RBC: It can't be up to and over. I'm guessing up to is correct.>> 500 requests per second. The volume of requests capable of being handled closely mirroring
the user load. The average response time was close to half that of the previous test. The result
is a system that is much more scalable than before.

The next graph shows the results of the equivalent load test for the `SingleServiceInstance`
controller. *Note that as before, the scale for the response time and throughput for this graph
are logarithmic.*

![Throughput of the sample application reusing the same instance of an HttpClient object for each request][throughput-single-ExpensiveToCreateService-instance]

The volume of requests handled increases in line with the user load while the average response
time remains low. This is similar to the profile of the code that creates a single `HttpClient`
instance.

For comparison purposes with the earlier test, the following image shows the stack trace
telemetry for the `SingleHttpClientInstance` controller. This time the system spends most of its
time performing real work rather than opening and closing sockets.

![The New Relic thread profiler showing the sample application creating single instance of an HttpClient object for all requests][thread-profiler-single-HTTPClient-instance]


## Related resources

- [Best Practices for Performance Improvements Using Service Bus Brokered Messaging][best-practices-service-bus].

- [Performance Tips for Azure DocumentDB - Part 1][performance-tips-documentdb]

- [Redis ConnectionMultiplexer - Basic Usage][redis-multiplexer-usage]

[fullDemonstrationOfProblem]: https://github.com/mspnp/performance-optimization/tree/master/ImproperInstantiation
[fullDemonstrationOfSolution]: https://github.com/mspnp/performance-optimization/tree/master/ImproperInstantiation
[best-practices-service-bus]: https://msdn.microsoft.com/library/hh528527.aspx
[performance-tips-documentdb]: http://blogs.msdn.com/b/documentdb/archive/2015/01/15/performance-tips-for-azure-documentdb-part-1.aspx
[redis-multiplexer-usage]: https://github.com/StackExchange/StackExchange.Redis/blob/master/Docs/Basics.md
[NewRelic]: http://newrelic.com/azure
[AppDynamics]: http://www.appdynamics.co.uk/cloud/windows-azure
[throughput-new-HTTPClient-instance]: _images/HttpClientInstancePerRequest.jpg
[dashboard-new-HTTPClient-instance]: _images/HttpClientInstancePerRequestWebTransactions.jpg
[thread-profiler-new-HTTPClient-instance]: _images/HttpClientInstancePerRequestThreadProfile.jpg
[throughput-new-ExpensiveToCreateService-instance]: _images/ServiceInstancePerRequest.jpg
[throughput-single-HTTPClient-instance]: _images/SingleHttpClientInstance.jpg
[throughput-single-ExpensiveToCreateService-instance]: _images/SingleServiceInstance.jpg
[thread-profiler-single-HTTPClient-instance]: _images/SingleHttpClientInstanceThreadProfile.jpg

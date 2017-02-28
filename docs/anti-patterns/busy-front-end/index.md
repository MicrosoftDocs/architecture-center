---
title: Busy Front End antipattern
description: 

author: dragon119
manager: christb

pnp.series.title: Optimize Performance
---
# Busy Front End antipattern
[!INCLUDE [header](../../_includes/header.md)]

Resource-intensive tasks can impact the response times of user requests and cause high
latency in operations performed by an application. One often-considered technique to
improve response times is to offload a resource-intensive task onto a separate thread.
This strategy enables the application to remain responsive while the processing is
performed in the background. However, tasks still consume resources regardless of
whether they are running in the foreground or on a background thread. Performing
asynchronous work in a large number of background threads can starve other concurrent
foreground tasks of resources, decreasing response times to unacceptable levels.

----------

**Note:** The term *resource* can encompass many things, such as CPU utilization,
memory occupancy, and network or disk I/O.

----------

This problem typically occurs when an application is developed as single monolithic
piece of code, with the entire business processing combined into a single tier shared
with the user interface.

As an example, the following conceptual sample code shows part of a web application
built by using Web API. The web application contains two controllers:

1. `WorkInFrontEnd` which exposes an HTTP POST operation. This operation simulates a
long-running, CPU-intensive piece of processing. The work is performed on a separate
thread in an attempt to enable the POST operation to complete quickly and ensure that
the caller remains responsive.

2. `UserProfile` which exposes an HTTP GET operation to retrieve user profile
information. This time the processing is much less CPU intensive.

**C# Web API**
```C#
public class WorkInFrontEndController : ApiController
{
    [HttpPost]
    [Route("api/workinfrontend")]
    public void Post()
    {
        new Thread(() =>
        {
            //Simulate processing
            Thread.SpinWait(Int32.MaxValue / 100);
        }).Start();

        return Request.CreateResponse(HttpStatusCode.Accepted);
    }
}
...
public class UserProfileController : ApiController
{
    [HttpGet]
    [Route("api/userprofile/{id}")]
    public UserProfile Get(int id)
    {
        //Simulate processing
        return new UserProfile() { FirstName = "Alton", LastName = "Hudgens" };
    }
}
```

The primary concern with this web application is the resource requirements of the
`Post` method in the `WorkInFrontEnd` controller. Although the processing runs on a
background thread, alleviating the user of the need to wait for the result before
continuing with further work, it can still consume considerable CPU resources. These
resources are shared with the other operations being performed by other concurrent
users. If a moderate number of users issue this request at the same time, then the
overall performance of the system is likely to suffer, causing a slowdown in all
operations; users might experience a significant slowing of the `Get` method in the
`UserProfile` controller for example.

----------

**Note:** The `WorkInFrontEnd` and `UserProfile` controllers are included in the
[sample code][fullDemonstrationOfProblem] available with this anti-pattern.

----------

## How to detect the problem

Symptoms of a busy front end in an application include high latency during periods
when resource-intensive tasks are being performed. These tasks can starve other
requests of the processing power they require, causing them to run more slowly.
End-users are likely to report extended response times and possible failures caused by
services timing out due to lack of processing resources in the web server. These
failures could also manifest themselves as HTTP 500 (Internal Server) errors or HTTP
503 (Service Unavailable) errors. In these cases, you should examine the event logs
for the web server which are likely to contain more detailed information about the
causes and circumstances of the errors.

You can perform the following steps to help identify this problem:

1. Identify points at which response times slow down by performing process monitoring
of the production system.

2. Examine the telemetry data captured at these points to determine the mix of
operations being performed and the resources being utilized by these operations and
find any correlations between repeated occurrences of poor response times and the
volumes/combinations of each operation that are running at that point.

3. Perform load testing of each possible operation to identify the *bad actors*
(operations that are consuming resources and starving other operations).

4. Review the source code for the possible bad actors to identify the reasons for
excessive resource consumption.

The following sections apply these steps to the sample application described earlier.

----------

**Note:** If you already have an insight into where problems might lie, you may be
able to skip some of these steps. However, you should avoid making unfounded or biased
assumptions. Performing a thorough analysis can sometimes lead to the identification
of unexpected causes of performance problems. The following sections are formulated to
help you examine applications and services systematically.

----------

### Identifying points of slow-down

Instrumenting each method to track the duration and resources consumed by each
requests and then monitoring the live system can help to provide an overall view of
how the requests compete with each other. During periods of stress, slow-running
resource hungry requests will likely impact other operations, and this behavior can be
observed by monitoring the system and noting the drop-off in performance.

The following image shows the Business Transactions pane in AppDyanamics monitoring
the sample application. Initially the system is lightly loaded but then users start
requesting the `UserProfile` GET operation. The performance is reasonably quick until
other users start issuing requests to the `WorkInFrontEnd` controller, when the
response time suddenly increases dramatically (see the graphic in the *Response Time
(ms)* column in the image). The response time only improves once the volume of
requests to the `WorkInFrontEnd` controller diminishes (see the graphic in the
*Calls/min* column.)

![AppDynamics Business Transactions pane showing the effects of the response times of all requests when the WorkInFrontEnd controller is used][AppDynamics-Transactions-Front-End-Requests]

### Examining telemetry data and finding correlations

The next image shows some of the metrics gathered by using AppDynamics monitoring the
resource utilization of the web role hosting the sample application during the same
interval as the previous graph. Initially, few users are accessing the system, but as
more users connect the CPU utilization becomes very high (100%) for much of the time,
so the system is clearly under duress. Additionally, the network I/O rate peaks while
the CPU utilization rises, and then retreats when the CPU is running at capacity. This
is because the system is unable to handle more than a relatively small number of
requests once the CPU is at capacity. As users disconnect, the CPU load tails off:

![AppDynamics metrics showing the CPU and network utilization][AppDynamics-Metrics-Front-End-Requests]

From the information provided by identifying the points of slow down and the telemetry
at these points, it would appear that the `WorkInFrontEnd` controller is a prime
candidate for further examination, but further work in a controlled environment is
necessary to confirm this hypothesis.

### Performing load-testing to identify *bad actors*

Having identified the possible source of disruptive requests in the system, you should
perform tests in a controlled environment to demonstrate any correlations between
these requests and the overall performance of the system. As an example, you can
perform a series of load tests that include and then omit each request in turn to see
the effects.

The graph below shows the results of a load-test performed against an identical
deployment of the cloud service used for the previous tests. The load test used a
constant load of 500 users performing the `Get` operation in the `UserProfile`
controller alongside a step-load of users performing requests against the
`WorkInFrontEnd` controller. Initially, the step-load was 0, so the only active users
were performing the `UserProfile` requests and the system was capable of responding to
approximately 500 requests per second. After 60 seconds, a load of 100 additional
users was started, and these users sent POST requests to the `WorkInFrontEnd`
controller. Almost immediately, the workload sent to the `UserProfile` controller
dropped to about 150 requests per second. This is due to the way in which the
load-test runner functions; it waits for a response before sending the next request,
so the longer it takes to receive a response the lower the subsequent request rate.

As more users were added (in steps of 100) performing POST requests against the
`WorkInFrontEnd` controller, the response rate against the `UserProfile` controller
gradually diminished further. The volume of requests serviced by the `WorkInFrontEnd`
controller remained relatively constant. The saturation of the system becomes apparent
as the overall rate of both requests tends towards a steady but low limit.

![Initial load-test results for the WorkInFrontEnd controller][Initial-Load-Test-Results-Front-End]

### Reviewing the source code

The final stage is to examine the source code for each of the `bad actors` previously
identified. In the case of the `Post` method in the `WorkInFrontEnd` controller, the
development team was aware that this request could take a considerable amount of time
which is why the processing is performed on a different thread running asynchronously.
In this way a user issuing the request does not have to wait for processing to
complete before being able to continue with the next task:

**C#**
```C#
public void Post()
{
    new Thread(() =>
    {
        //Simulate processing
        Thread.SpinWait(Int32.MaxValue / 100);
    }).Start();

    return Request.CreateResponse(HttpStatusCode.Accepted);
}
```

However, although this approach notionally improves response time for the user, it
introduces a small overhead associated with creating and managing a new thread.
Additionally, the work performed by this method still consumes CPU, memory, and other
resources. Enabling this process to run asynchronously might actually be damaging to
performance as users can possibly trigger a large number of these operations
simultaneously, in an uncontrolled manner. In turn, this has an effect on any other
operations that the server is attempting to perform. Furthermore, there is a finite
limit to the number of threads that a server can run, determined by a number of
factors such as available computing resource capacity and the number of CPU cores.
When the system reaches its limit, applications are likely to receive an exception
when they attempt to start a new thread.

## How to correct the problem

You should move processes that might consume significant resources to a separate tier,
and control the way in which these processes run to prevent competition from causing
resource starvation. For more information, see the [Compute Partitioning
Guidance][ComputePartitioning] available on the Microsoft website.

With Azure, you can offload the image processing work to a set of worker roles. The
POST request in the `WorkInBackground` controller shown below submits the details of
the request to a queue, and instances of the worker role can pick up these requests and
perform the necessary tasks. The web role is then free to focus on user-facing tasks.
Furthermore, the queue acts as a natural load-leveller, buffering requests until a
worker role instance is available. If the queue length becomes too long, you can
configure auto-scaling to start additional worker role instances, and shut these
instances down when the workload eases:

**C# web API**
```C#
public class WorkInBackgroundController : ApiController
{
    ...
    private static readonly QueueClient QueueClient;
    private static readonly string QueueName;
    private static readonly ServiceBusQueueHandler ServiceBusQueueHandler;

    public WorkInBackgroundController()
    {
        var serviceBusConnectionString = ...;
        QueueName = ...;
        ServiceBusQueueHandler = new ServiceBusQueueHandler(serviceBusConnectionString);
        QueueClient = ServiceBusQueueHandler.GetQueueClientAsync(QueueName).Result;
    }

    ...

    [HttpPost]
    [Route("api/workinbackground")]
    public async Task<long> Post()
    {
        return await ServiceBusQueuehandler.AddWorkLoadToQueueAsync(
                QueueClient, QueueName, 0);
    }
}
```

The worker role listens for incoming messages on the queue and performs the image processing:

**C#**
```C#
public class WorkerRole : RoleEntryPoint
{
    ...
    private QueueClient _queueClient;
    ...

    public async Task RunAsync(CancellationToken cancellationToken)
    {
        // Initiates the message pump and callback is invoked for each message that is received, calling close on the client will stop the pump.
        this._queueClient.OnMessageAsync(
            async (receivedMessage) =>
            {
                try
                {
                    // Simulate processing of message
                    Thread.SpinWait(Int32.Maxvalue / 1000);

                    await receivedMessage.CompleteAsync();
                }
                catch
                {
                    receivedMessage.Abandon();
                }
            });
        ...
    }
    ...
}
```
----------

**Note:** The `WorkInBackgroundController` controller and the worker role are included in the [sample code][fullDemonstrationOfSolution] available with this anti-pattern.

----------

You should consider the following points:

- This architecture complicates the structure of the solution. In the example, you
must ensure that you handle queuing and dequeuing safely to avoid losing requests in
the event of a failure.

- The processing environment must be sufficiently scalable to handle the expected
workload and meet the required throughput targets.

- Using a worker role is simply one solution. If you are using Azure Websites, you can
use other options such as [WebJobs][WebJobs].


## Consequences of the solution

Running the [sample solution][fullDemonstrationOfSolution] in a production environment
and using AppDynamics to monitor performance generated the following results. The load
was similar to that shown earlier, but the response times of requests to the
`UserProfile` controller is now much faster and the volume of requests overall was
greatly increased over the same duration (23565 against 2759 earlier). A much bigger
volume of requests was made to the `WorkInBackground` controller compared to the
earlier tests due to the increased efficiency of these requests. However, you should
not compare the throughput and response time for these requests to those shown earlier
as the work being performed is very different (queuing a request rather than
performing a time-consuming calculation):

![AppDynamics Business Transactions pane showing the effects of the response times of all requests when the WorkInBackground controller is used][AppDynamics-Transactions-Background-Requests]

The CPU and network utilization also illustrate the improved performance. The CPU
utilization never reached 100% and the volume of network requests handled was far
greater than earlier and did not tail off until the workload dropped.

![AppDynamics metrics showing the CPU and network utilization for the WorkInBackground controller][AppDynamics-Metrics-Background-Requests]

Repeating the controlled load-test over 5 minutes for users submitting a mixture of
all requests against the `UserProfile` and `WorkInBackground` controllers gives the
following results:

![Load-test results for the BackgroundImageProcessing controller][Load-Test-Results-Background]

This graph confirms the improvement in performance of the system as a result of
offloading the intensive processing to the worker role. The overall volume of requests
serviced is greatly improved compared to the earlier tests.

Relocating resource-hungry processing to a separate set of processes should improve
responsiveness for most requests, but the resource-hungry processing itself may take
longer (this duration is not illustrated in the two graphs above, and requires
instrumenting and monitoring the worker role.) If there are insufficient worker role
instances available to perform the resource-hungry workload, jobs might be queued or
otherwise held pending for an indeterminate period. However, it might be possible to
expedite critical jobs that must be performed quickly by using a priority queuing
mechanism.

## Related resources

- [Compute Partitioning Guidance][ComputePartitioning]

- [Azure Service Bus Queues][ServiceBusQueues]

[fullDemonstrationOfProblem]: https://github.com/mspnp/performance-optimization/tree/master/BusyFrontEnd
[fullDemonstrationOfSolution]: https://github.com/mspnp/performance-optimization/tree/master/BusyFrontEnd
[WebJobs]: http://www.hanselman.com/blog/IntroducingWindowsAzureWebJobs.aspx
[ComputePartitioning]: https://msdn.microsoft.com/library/dn589773.aspx
[ServiceBusQueues]: https://msdn.microsoft.com/library/azure/hh367516.aspx
[AppDynamics-Transactions-Front-End-Requests]: ./_images/AppDynamicsPerformanceStats.jpg
[AppDynamics-Metrics-Front-End-Requests]: ./_images/AppDynamicsFrontEndMetrics.jpg
[Initial-Load-Test-Results-Front-End]: ./_images/InitialLoadTestResultsFrontEnd.jpg
[AppDynamics-Transactions-Background-Requests]: ./_images/AppDynamicsBackgroundPerformanceStats.jpg
[AppDynamics-Metrics-Background-Requests]: ./_images/AppDynamicsBackgroundMetrics.jpg
[Load-Test-Results-Background]: ./_images/LoadTestResultsBackground.jpg

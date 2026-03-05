---
title: Transient Fault Handling
description: Learn how to handle transient faults that the loss of network connectivity, temporary unavailability, or timeouts can cause.
ms.author: pnp
author: claytonsiemens77
ms.date: 02/26/2026
ms.update-cycle: 1095-days
ms.topic: best-practice
ms.subservice: best-practice
---

# Best practices for transient fault handling

All applications that communicate with remote services and resources must detect and recover from transient faults. This requirement is especially true for applications that run in the cloud. Because of the nature of the cloud environment and connectivity over the internet, your application is likely to encounter transient faults more often. Transient faults include the momentary loss of network connectivity to components and services, the temporary unavailability of a service, and timeouts that occur when a service is busy. These faults typically resolve themselves without intervention, so the action is likely to succeed if the application retries it after a suitable delay.

[Transient fault handling](/azure/well-architected/design-guides/handle-transient-faults) is a key resiliency technique within the [Reliability pillar](/azure/well-architected/reliability/) of the Azure Well-Architected Framework. If you detect and recover from transient faults at the application level, you reduce the chance of cascading failures that might trigger broader incident response or [disaster recovery (DR)](/azure/well-architected/reliability/disaster-recovery) procedures. Effective transient fault handling helps your workload tolerate routine disruptions and maintain availability without escalation to infrastructure-level recovery procedures.

## Why do transient faults occur in the cloud?

Transient faults can occur in any environment, on any platform or operating system, and in any kind of application. For solutions that run on on-premises infrastructure, redundant hardware typically maintains the performance and availability of the application and its components. Components and resources are also located close to each other. This approach makes failure less probable, but transient faults can still occur. Unexpected events like external power supply or network problems, or other disaster scenarios, can cause outages. Redundant hardware can also be expensive and is often underused.

Cloud environments can provide higher overall availability because they distribute workloads across many servers and use redundancy, automatic failover, and dynamic resource allocation. But the nature of cloud environments makes transient faults more likely for several reasons:

- Many resources in a cloud environment are shared, and access to these resources is subject to [throttling](../patterns/throttling.yml) to protect the resources. Some services refuse connections when the load reaches a specific level or maximum throughput rate. This approach lets the service process existing requests and maintain performance for all users. Throttling helps maintain the quality of service for neighbors and other tenants that use the shared resource.

- Cloud environments use large numbers of commodity hardware units. They deliver performance by dynamically distributing load across multiple computing units and infrastructure components. They deliver reliability by automatically recycling or replacing failed units. Because of this dynamic nature, transient faults and temporary connection failures might occasionally occur.

- More hardware components, including network infrastructure like routers and load balancers, often exist between the application and the resources and services that it uses. This infrastructure can occasionally introduce extra connection latency and transient connection faults.

- Network conditions between the client and server often vary, especially when communication crosses the internet. Even in on-premises locations, heavy-traffic loads can slow communication and cause intermittent connection failures.

## Challenges

Transient faults can significantly affect the perceived availability of an application, even if you test it thoroughly under expected conditions. To ensure that cloud-hosted applications operate reliably, they must address the following challenges:

- The application must be able to detect faults when they occur and determine whether the faults are transient, long-lasting, or terminal failures. Different resources typically return different responses when a fault occurs. These responses can also vary depending on the context of the operation. For example, the response for an error when the application reads from storage might differ from the response for an error when it writes to storage. 

   Many resources and services have well-documented transient-failure contracts. When this information isn't available, it becomes much harder to determine the nature of the fault and whether it's likely to be transient.

- The application must be able to retry the operation if it determines that the fault is likely to be transient. It also needs to track the number of times that it retries the operation.

- The application must use a retry strategy that fits its requirements. The strategy specifies how many times the application should retry, the delay between attempts, and the actions to take after a failed attempt. The number of attempts and the delay between each one are often difficult to determine. The strategy depends on the type of resource and on the current operating conditions of the resource and the application.

## General guidelines

The following guidelines can help you design suitable transient fault handling mechanisms for your applications.

### Check whether a built-in retry mechanism exists

Many services provide an SDK or client library that contains a transient fault handling mechanism. The retry policy that it uses is typically tailored to the nature and requirements of the target service. Alternatively, REST interfaces for services might return information that can help you determine whether a retry is needed and how long to wait before the next attempt.

Use the built-in retry mechanism when a built-in option is available, unless you have specific and well-understood requirements that make a different retry behavior more suitable for your scenario.

Azure services each handle transient faults differently. Some services provide SDK-level retry policies that include configurable back-off algorithms. Other services provide platform features like health probes and visibility timeouts that complement application-level retry logic. Check the [reliability guide](/azure/reliability/overview-reliability-guidance) for each Azure service that you use. These guides include a dedicated section that provides service-specific recommendations for retry configuration, timeout tuning, and health monitoring.

### Check whether retrying suits the operation

Retry tasks only when the faults are transient, which the nature of the error typically indicates, and when the operation might succeed when retried. For HTTP-based services, status code 429 (Too Many Requests) and 5xx server errors are typical retry candidates. Most 4xx client errors, like 400, 401, 403, and 404, indicate problems that a retry won't resolve. Don't retry tasks that attempt an operation that can't succeed, like a database update to an item that doesn't exist or a request to a service or resource that encountered a fatal error.

In general, implement retries only when you can determine their full effect and when you understand and can validate the conditions. Otherwise, let the calling code implement retries. Errors returned from resources and services outside your control might evolve over time, and you might need to revisit your transient fault detection logic.

When you create services or components, implement error codes and messages that help clients determine whether they should retry failed operations. For example, return an `isTransient` value to indicate whether the client should retry the operation, and suggest a suitable delay before the next retry attempt. If you build a web service, return custom errors that your service contracts define. Generic clients might not be able to read these errors, but they're useful when you create custom clients.

### Determine an appropriate retry count and interval

Optimize the retry count and the interval for the type of use case. If you don't retry enough times, the application can't complete the operation and fails. If you retry too many times or don't wait long enough between tries, the application might hold resources like threads, connections, and memory for long periods, which adversely affects application health. For more information, see [Retry pattern](../patterns/retry.yml).

Adapt values for the time interval and the number of retry attempts to the type of operation. For example, if the operation is part of a user interaction, the interval should be short, and you should attempt only a few retries. Use this approach to avoid making users wait for a response, which holds open connections and can reduce availability for other users. If the operation is part of a long-running or critical workflow, where canceling and restarting the process is costly or time-consuming, you can wait longer between attempts and retry more times.

Determining the correct intervals between retries is the most difficult part of designing a successful strategy. Typical strategies use the following types of retry interval:

- **Exponential back-off:** The application waits a short time before the first retry and then exponentially increases the time between each subsequent retry. For example, it might retry the operation after two seconds, four seconds, eight seconds, and up to a set number of tries or a total duration. Add jitter, which is a small random delay, to each retry interval to prevent multiple clients from syncing their retries and creating load spikes on the target service.

- **Incremental intervals:** The application waits a short time before the first retry, and then incrementally increases the time between each subsequent retry. For example, it might retry the operation after 3 seconds, 7 seconds, and 11 seconds.

- **Regular intervals:** The application waits for the same period of time between each attempt. For example, it might retry the operation every three seconds.

- **Immediate retry:** Transient faults that events like a network packet collision or a spike in a hardware component cause are typically brief. In these scenarios, retrying the operation immediately can help because it might succeed if the fault clears in the time that the application takes to assemble and send the next request. Don't attempt more than one immediate retry. If the immediate retry fails, switch to alternative strategies, like exponential back-off or fallback actions.

- **Randomization:** Any of the retry strategies listed previously can include randomization to prevent multiple instances of the client sending subsequent retry attempts at the same time. For example, one instance might retry the operation after 3 seconds, 11 seconds, or 28 seconds, while another instance might retry the operation after 4 seconds, 12 seconds, or 26 seconds. Randomization is a useful technique that you can combine with other strategies.

Use an exponential back-off strategy with jitter for background operations, and use immediate or regular interval retry strategies for interactive operations. In both cases, choose the delay and the retry count so that the maximum latency for all retry attempts meets the end-to-end latency requirement.

A combination of factors contribute to the overall maximum timeout for a retried operation. Consider the following factors:

- The time a failed connection takes to produce a response. A timeout value in the client typically sets this time.

- The delay between retry attempts.

- The maximum number of retries.

 The total of these times can result in long overall operation times, especially when you use an exponential delay strategy where the interval between retries grows rapidly after each failure. If a process must meet a specific service-level agreement (SLA), the overall operation time, including all timeouts and delays, must be within the limits defined in the SLA.

Account for the timeout of the operations when you choose retry intervals to avoid launching a subsequent attempt immediately, like if the timeout period is similar to the retry interval. Determine whether you need to keep the total possible period, which is the timeout plus the retry intervals, under a specific total time threshold. If an operation has an unusually short or long timeout, the timeout might influence how long to wait and how often to retry the operation.

Set timeouts on every outbound call before you implement retry logic. Timeouts, retries, and back-off approaches work together. A retry strategy is only as effective as the timeouts that govern each individual attempt. Timeouts that are too long cause threads and connections to accumulate during outages. Timeouts that are too short cause premature failures on operations that would otherwise succeed.

Don't implement overly aggressive retry strategies. These strategies use intervals that are too short or retries that occur too frequently. They can adversely affect the target resource or service. They might also prevent the resource or service from recovering, so the resource or service continues to block or refuse requests. This scenario creates a cycle in which the application sends more requests to the resource or service, which further reduces its ability to recover.

Use the exception type and any data it contains, or the error codes and messages that the service returns, to optimize the number of retries and the interval between them. Some exceptions or error codes, like HTTP 503 (Service Unavailable), might indicate that the service failed and won't respond to further attempts. When a response includes a `Retry-After` header, follow it and wait at least the specified duration before the next attempt. This server-provided signal reflects the service's recovery timeline and takes precedence over your client-side back-off calculation.

Use a *[dead-letter queue](/azure/service-bus-messaging/service-bus-dead-letter-queues)* approach so that the information from the incoming request isn't lost after you use all retry attempts. This technique defers failed work for later processing instead of discarding it.

### Avoid antipatterns

In most cases, avoid implementations that include duplicated layers of retry code. Avoid designs that use cascading retry mechanisms or that apply retries at every stage of an operation that involves a hierarchy of requests, unless you have specific requirements. In these exceptional cases, use policies that limit the number of retries and delay periods, and make sure that you understand the consequences.

For example, consider one component that makes a request to another, which then accesses the target service. A retry with a count of three on both calls adds up to nine retry attempts in total against the service. 
   
Many services and resources implement a built-in retry mechanism. Turn off or modify these mechanisms if you need to implement retries at a higher level. For more information about the risks of uncoordinated retries, see [Retry Storm antipattern](../antipatterns/retry-storm/index.md).

Never implement an endless retry mechanism. This approach typically prevents the resource or service from recovering from overload situations and causes throttling and refused connections to continue for a longer time. Use a finite number of retries, or implement a pattern like [Circuit Breaker](../patterns/circuit-breaker.md) to allow the service to recover.

Implement a retry budget to limit the total number of retries across all requests within a process or service in addition to limits for each individual request. For example, you might allow a process to do no more than 60 retries per minute against a specified dependency. If you exhaust the budget, fail the request immediately instead of retrying. 
  
Per-request retry limits alone can't prevent a scenario where many concurrent requests each retry a few times and collectively overwhelm a struggling downstream service. A retry budget limits the aggregate retry load and can make the difference between a localized capacity problem and a cascading failure.

Never do an immediate retry more than once.

Avoid using a regular retry interval when you access services and resources on Azure, especially when you have a high number of retry attempts. The best approach in this scenario is an exponential back-off strategy that uses a circuit-breaking capability.

Prevent multiple instances of the same client, or multiple instances of different clients, from sending retries simultaneously. If this scenario is probable, introduce randomization into the retry intervals.

### Test your retry strategy and implementation

Test your retry strategy across a broad range of conditions, especially when the application and its target resources or services operate under extreme load. To check behavior during testing, you can take the following actions:

- Include transient faults in your [chaos engineering and fault injection](/azure/well-architected/reliability/testing-strategy#use-fault-injection-and-chaos-engineering) practices by purposely introducing them into your nonproduction and production environments. For example, send unsupported requests or add code that detects test requests and responds with different types of errors.

- Create a mock version of the resource or service that returns a range of errors that the real service might return. Make sure that it covers all error types that your retry strategy detects.

- For custom services that you create and deploy, force transient errors to occur by temporarily taking the service offline or overloading the service. Don't attempt to overload any shared resources or shared services in Azure.

- Consider using a fault injection service to run controlled experiments against your Azure resources. For example, [Azure Chaos Studio](/azure/chaos-studio/chaos-studio-overview) supports service-direct faults, like adding network latency or rebooting a cache cluster, and agent-based faults, like applying memory pressure or ending a process on a virtual machine (VM). You can integrate fault injection experiments into your continuous integration and continuous delivery (CI/CD) pipelines to continuously validate resilience as part of your deployment process.

- For HTTP-based APIs, consider using a library in your automated tests to change the outcome of HTTP requests, either by adding extra roundtrip times or by changing the response, like the HTTP status code, headers, body, or other factors. This approach helps you deterministically test a subset of the failure conditions for transient faults and other types of failures.

- Run high-load-factor and concurrent tests to ensure that the retry mechanism and strategy work correctly under these conditions. These tests also help confirm that retry attempts don't affect client operations or cause cross-contamination between requests.

### Manage retry policy configurations

A *retry policy* is a combination of all the elements of your retry strategy. It defines the detection mechanism that determines the following factors:

- Whether a fault is likely to be transient
- The type of interval to use, like regular, exponential back-off, or randomization
- The actual interval values
- The number of times to retry

Implement retries in many places, including in basic applications and at each layer of more complex applications. Instead of hard-coding policy elements in multiple locations, use a central point to store all policies. For example, store values like the interval and retry count in application configuration files, read them at runtime, and programmatically build the retry policies. This approach simplifies settings management and the modification and fine-tuning of values to respond to changing requirements and scenarios. Design the system to store the values rather than rereading a configuration file for each request, and use suitable defaults if the configuration doesn't provide the values.

Store the values used to build the retry policies at runtime in the application's configuration system so that you can change them without needing to restart the application.

Take advantage of built-in or default retry strategies available in the client APIs that you use, but only when they suit your scenario. These strategies are typically generic. They might be adequate in some scenarios, but in other scenarios they don't provide the full range of options to meet your specific requirements. To determine the most suitable values, test to understand how the settings affect your application. For service-specific retry defaults and configuration options, check the [reliability guide](/azure/reliability/overview-reliability-guidance) for each Azure service in your architecture.

### Log and track transient and nontransient faults

Your retry strategy should include exception handling and other instrumentation that logs retry attempts. An occasional transient failure and retry are expected and don't indicate a problem. But regular or increasing numbers of retries usually indicate a problem that might cause a failure or reduce application performance and availability.

Log transient faults as warning entries rather than as error entries so that monitoring systems don't detect them as application errors that might trigger false alerts.

Store a value in your log entries that indicates whether throttling in the service or other types of faults, like connection failures, cause retries. This approach helps you differentiate the causes during data analysis. An increase in throttling errors usually indicates a design flaw in the application or the need to migrate to a premium service that provides dedicated hardware.

Measure and log the overall elapsed times for operations that include a retry mechanism. This metric accurately indicates the overall effect that transient faults have on user response times, process latency, and the efficiency of application use cases. Log the number of retries that occur so that you can understand the factors that contribute to the response time.

Implement a telemetry and monitoring system that raises alerts when the following metrics increase:

- The number and rate of failures
- The average number of retries
- The overall time that elapses before operations succeed

### Manage operations that continually fail

Create a plan to handle operations that continue to fail at every attempt. These situations are inevitable.

- A retry strategy defines the maximum number of times that an application should retry an operation. It doesn't prevent the application from repeating the operation to start with the same number of retries. For example, if an order-processing service fails with a fatal error that takes it out of service permanently, the retry strategy might detect a connection timeout and treat it as a transient fault. The code retries the operation the specified number of times and then stops. When another customer places an order, the application attempts the operation again, retries, and fails.

- To prevent continual retries for operations that continually fail, implement the [Circuit Breaker pattern](../patterns/circuit-breaker.md). When you use this pattern, if the number of failures within a specified time window exceeds a threshold, requests return to the caller immediately as errors, and the application doesn't attempt to access the failed resource or service.

- The application can periodically test the service, on an intermittent basis and with long intervals between requests, to detect when it becomes available. The interval depends on factors like the criticality of the operation and the nature of the service. It might range from a few minutes to several hours. When the test succeeds, the application can resume normal operations and pass requests to the newly recovered service.

- In the meantime, you might be able to fall back to another instance of the service in a different datacenter or application. You might also use a similar service that provides compatible, but simpler, functionality, or do some alternative operations based on the hope that the service is available soon. For example, you might store requests for the service in a queue or data store and retry them later. Or you might be able to redirect the user to an alternative instance of the application, degrade the performance of the application but still provide acceptable functionality, or just return a message to the user to indicate that the application isn't currently available.

### Other considerations

When you determine the values for the number of retries and the retry intervals for a policy, consider whether the operation on the service or resource is part of a long-running or multistep operation. It can be difficult or costly to compensate for all the operational steps that have already succeeded when one of them fails. In this case, a long interval and a large number of retries might be acceptable as long as the strategy doesn't block other operations by holding or locking scarce resources.

Consider whether retrying the same operation might cause data inconsistencies. If an application repeats parts of a multistep process and the operations aren't idempotent, inconsistencies can occur. For example, if an operation that increments a value repeats, it produces an incorrect result. A repeated operation that sends a message to a queue can also cause problems for a consumer that can't detect duplicate messages. To prevent these scenarios, design each step as an idempotent operation. For more information, see [Idempotency patterns](../reference-architectures/containers/aks-mission-critical/mission-critical-data-platform.md#idempotent-message-processing).

Be intentional about the scope of operations that the application retries. For example, it might be easier to implement retry logic at a level that includes several operations and retry all of them if one fails. But this approach might lead to idempotency problems or unnecessary rollback operations.

If you choose a retry scope that includes several operations, account for the total latency of all of them when you determine retry intervals, when you monitor the elapsed time of the operation, and before you raise alerts for failures.

Account for how your retry strategy affects neighbors and other tenants in a shared application and when you use shared resources and services. Aggressive retry policies can increase the number of transient faults that occur for other users and for applications that share the resources and services. Retry policies that other users implement might also affect your application. For business-critical applications, use premium services that aren't shared. This approach lets you control the load and consequent throttling of resources and services, which can justify the extra cost.

## Next step

> [!div class="nextstepaction"]
> [Workload design to handle transient faults](/azure/well-architected/design-guides/handle-transient-faults)

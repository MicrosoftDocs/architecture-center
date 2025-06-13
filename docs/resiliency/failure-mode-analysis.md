---
title: Failure mode analysis
description: Get information about doing a failure mode analysis (FMA) for cloud solutions that are based on Azure.
author: claytonsiemens77
ms.author: pnp
ms.date: 07/25/2023
ms.topic: conceptual
ms.subservice: architecture-guide
---

# Failure mode analysis for Azure applications

Failure mode analysis (FMA) is a process for building resiliency into a system, by identifying possible failure points in the system. The FMA should be part of the architecture and design phases, so that you can build failure recovery into the system from the beginning.

Here is the general process to conduct an FMA:

1. Identify all of the components in the system. Include external dependencies, such as identity providers, third-party services, and so on.
2. For each component, identify potential failures that could occur. A single component may have more than one failure mode. For example, you should consider read failures and write failures separately, because the impact and possible mitigation steps will be different.
3. Rate each failure mode according to its overall risk. Consider these factors:

   - What is the likelihood of the failure? Is it relatively common? Extremely rare? You don't need exact numbers; the purpose is to help rank the priority.
   - What is the impact on the application, in terms of availability, data loss, monetary cost, and business disruption?

4. For each failure mode, determine how the application will respond and recover. Consider tradeoffs in cost and application complexity.

As a starting point for your FMA process, this article contains a catalog of potential failure modes and their mitigation steps. The catalog is organized by technology or Azure service, plus a general category for application-level design. The catalog isn't exhaustive, but covers many of the core Azure services.

> [!NOTE]
> Failures should be distinguished from errors. A failure is an unexpected event within a system that prevents it from continuing to function normally. For example, a hardware malfunction that causes a network partition is a failure. Usually, failures require intervention or specific design for that class of failures. In contrast, errors are an expected part of normal operations, are dealt with immediately and the system will continue to operate at the same capacity following an error. For example, errors discovered during input validation can be handled through business logic.

## App Service

### App Service app shuts down.

**Detection**. Possible causes:

- Expected shutdown

  - An operator shuts down the application; for example, using the Azure portal.
  - The app was unloaded because it was idle. (Only if the `Always On` setting is disabled.)

- Unexpected shutdown

  - The app crashes.
  - An App Service VM instance becomes unavailable.

Application_End logging will catch the app domain shutdown (soft process crash) and is the only way to catch the application domain shutdowns.

**Recovery:**

- If the shutdown was expected, use the application's shutdown event to shut down gracefully. For example, in ASP.NET, use the `Application_End` method.
- If the application was unloaded while idle, it is automatically restarted on the next request. However, you'll incur the "cold start" cost.
- To prevent the application from being unloaded while idle, enable the `Always On` setting in the web app. See [Configure web apps in Azure App Service][app-service-configure].
- To prevent an operator from shutting down the app, set a resource lock with `ReadOnly` level. See [Lock resources with Azure Resource Manager][rm-locks].
- If the app crashes or an App Service VM becomes unavailable, App Service automatically restarts the app.

**Diagnostics**. Application logs and web server logs. See [Enable diagnostics logging for web apps in Azure App Service][app-service-logging].

### A particular user repeatedly makes bad requests or overloads the system.

**Detection**. Authenticate users and include user ID in application logs.

**Recovery:**

- Use [Azure API Management][api-management] to throttle requests from the user. See [Advanced request throttling with Azure API Management][api-management-throttling]
- Block the user.

**Diagnostics**. Log all authentication requests.

### A bad update was deployed.

**Detection**. Monitor the application health through the Azure portal (see [Monitor Azure web app performance][app-insights-web-apps]) or implement the [health endpoint monitoring pattern][health-endpoint-monitoring-pattern].

**Recovery:**. Use multiple [deployment slots][app-service-slots] and roll back to the last-known-good deployment. For more information, see [Basic web application][ra-web-apps-basic].

<a name='azure-active-directory'></a>

## Microsoft Entra ID

### OpenID Connect authentication fails.

**Detection**. Possible failure modes include:

1. Microsoft Entra ID isn't available, or can't be reached due to a network problem. Redirection to the authentication endpoint fails, and the OpenID Connect middleware throws an exception.
2. Microsoft Entra tenant does not exist. Redirection to the authentication endpoint returns an HTTP error code, and the OpenID Connect middleware throws an exception.
3. User can't authenticate. No detection strategy is necessary; Microsoft Entra ID handles login failures.

**Recovery:**

1. Catch unhandled exceptions from the middleware.
2. Handle `AuthenticationFailed` events.
3. Redirect the user to an error page.
4. User retries.

## Azure AI Search

### Writing data to Azure AI Search fails.

**Detection**. Catch `Microsoft.Rest.Azure.CloudException` errors.

**Recovery:**

The [Search .NET SDK][search-sdk] automatically retries after transient failures. Any exceptions thrown by the client SDK should be treated as nontransient errors.

The default retry policy uses exponential back-off. To use a different retry policy, call `SetRetryPolicy` on the `SearchIndexClient` or `SearchServiceClient` class. For more information, see [Automatic Retries][auto-rest-client-retry].

**Diagnostics**. Use [Search Traffic Analytics][search-analytics].

### Reading data from Azure AI Search fails.

**Detection**. Catch `Microsoft.Rest.Azure.CloudException` errors.

**Recovery:**

The [Search .NET SDK][search-sdk]  automatically retries after transient failures. Any exceptions thrown by the client SDK should be treated as nontransient errors.

The default retry policy uses exponential back-off. To use a different retry policy, call `SetRetryPolicy` on the `SearchIndexClient` or `SearchServiceClient` class. For more information, see [Automatic Retries][auto-rest-client-retry].

**Diagnostics**. Use [Search Traffic Analytics][search-analytics].

## Cassandra

### Reading or writing to a node fails.

**Detection**. Catch the exception. For .NET clients, this will typically be `System.Web.HttpException`. Other client may have other exception types.  For more information, see [Cassandra error handling done right](https://www.datastax.com/dev/blog/cassandra-error-handling-done-right).

**Recovery:**

- Each [Cassandra client](https://cwiki.apache.org/confluence/display/CASSANDRA2/ClientOptions) has its own retry policies and capabilities. For more information, see [Cassandra error handling done right][cassandra-error-handling].
- Use a rack-aware deployment, with data nodes distributed across the fault domains.
- Deploy to multiple regions with local quorum consistency. If a nontransient failure occurs, fail over to another region.

**Diagnostics**. Application logs

## Azure Cosmos DB

### Reading data fails.

**Detection**. Catch `System.Net.Http.HttpRequestException` or `Microsoft.Azure.Documents.DocumentClientException`.

**Recovery:**

- The SDK automatically retries failed attempts. To set the number of retries and the maximum wait time, configure `ConnectionPolicy.RetryOptions`. Exceptions that the client raises are either beyond the retry policy or are not transient errors.
- If Azure Cosmos DB throttles the client, it returns an HTTP 429 error. Check the status code in the `DocumentClientException`. If you're getting error 429 consistently, consider increasing the throughput value of the collection.
  - If you're using the MongoDB API, the service returns error code 16500 when throttling.
- Enable zone redundancy when you work with a region that supports availability zones. When you use zone redundancy, Azure Cosmos DB automatically fails over in the event of a zone outage. For more information, see [Achieve high availability with Azure Cosmos DB](/azure/cosmos-db/high-availability).
- If you're designing a multi-region solution, replicate the Azure Cosmos DB database across two or more regions. All replicas are readable. Using the client SDKs, specify the `PreferredLocations` parameter. This is an ordered list of Azure regions. All reads will be sent to the first available region in the list. If the request fails, the client will try the other regions in the list, in order. For more information, see [How to set up global distribution in Azure Cosmos DB for NoSQL][cosmos-db-multi-region].

**Diagnostics**. Log all errors on the client side.

### Writing data fails.

**Detection**. Catch `System.Net.Http.HttpRequestException` or `Microsoft.Azure.Documents.DocumentClientException`.

**Recovery:**

- The SDK automatically retries failed attempts. To set the number of retries and the maximum wait time, configure `ConnectionPolicy.RetryOptions`. Exceptions that the client raises are either beyond the retry policy or are not transient errors.
- If Azure Cosmos DB throttles the client, it returns an HTTP 429 error. Check the status code in the `DocumentClientException`. If you're getting error 429 consistently, consider increasing the throughput value of the collection.
- Enable zone redundancy when you work with a region that supports availability zones. When you use zone redundancy, Azure Cosmos DB synchronously replicates all writes across availability zones. For more information, see [Achieve high availability with Azure Cosmos DB](/azure/cosmos-db/high-availability).
- If you're designing a multi-region solution, replicate the Azure Cosmos DB database across two or more regions. If the primary region fails, another region will be promoted to write. You can also trigger a failover manually. The SDK does automatic discovery and routing, so application code continues to work after a failover. During the failover period (typically minutes), write operations will have higher latency, as the SDK finds the new write region. For more information, see [How to set up global distribution in Azure Cosmos DB for NoSQL][cosmos-db-multi-region].
- As a fallback, persist the document to a backup queue, and process the queue later.

**Diagnostics**. Log all errors on the client side.

## Queue storage

### Writing a message to Azure Queue storage fails consistently.

**Detection**. After *N* retry attempts, the write operation still fails.

**Recovery:**

- Store the data in a local cache, and forward the writes to storage later, when the service becomes available.
- Create a secondary queue, and write to that queue if the primary queue is unavailable.

**Diagnostics**. Use [storage metrics][storage-metrics].

### The application cannot process a particular message from the queue.

**Detection**. Application specific. For example, the message contains invalid data, or the business logic fails for some reason.

**Recovery:**

Move the message to a separate queue. Run a separate process to examine the messages in that queue.

Consider using Azure Service Bus Messaging queues, which provides a [dead-letter queue][sb-dead-letter-queue] functionality for this purpose.

> [!NOTE]
> If you're using Storage queues with WebJobs, the WebJobs SDK provides built-in poison message handling. See [How to use Azure queue storage with the WebJobs SDK][sb-poison-message].

**Diagnostics**. Use application logging.

## Azure Cache for Redis

### Reading from the cache fails.

**Detection**. Catch `StackExchange.Redis.RedisConnectionException`.

**Recovery:**

1. Retry on transient failures. Azure Cache for Redis supports built-in retry.
2. Treat nontransient failures as a cache miss, and fall back to the original data source.

**Diagnostics**. Use [Azure Cache for Redis diagnostics][redis-monitor].

### Writing to the cache fails.

**Detection**. Catch `StackExchange.Redis.RedisConnectionException`.

**Recovery:**

1. Retry on transient failures. Azure Cache for Redis supports built-in retry.
2. If the error is nontransient, ignore it and let other transactions write to the cache later.

**Diagnostics**. Use [Azure Cache for Redis diagnostics][redis-monitor].

## SQL Database

### Cannot connect to the database in the primary region.

**Detection**. Connection fails.

**Recovery:**

- **Enable zone redundancy.** By enabling zone redundancy, Azure SQL Database automatically replicates your writes across multiple Azure availability zones within supported regions. For more information, see [Zone-redundant availability](/azure/azure-sql/database/high-availability-sla#zone-redundant-availability).

- **Enable geo-replication.** If you're designing a multi-region solution, consider enabling SQL Database active geo-replication.
  
  Prerequisite: The database must be configured for active geo-replication. See [SQL Database Active Geo-Replication][sql-db-replication].

  - For queries, read from a secondary replica.
  - For inserts and updates, manually fail over to a secondary replica. See [Initiate a planned or unplanned failover for Azure SQL Database][sql-db-failover].

  The replica uses a different connection string, so you'll need to update the connection string in your application.

### Client runs out of connections in the connection pool.

**Detection**. Catch `System.InvalidOperationException` errors.

**Recovery:**

- Retry the operation.
- As a mitigation plan, isolate the connection pools for each use case, so that one use case can't dominate all the connections.
- Increase the maximum connection pools.

**Diagnostics**. Application logs.

### Database connection limit is reached.

**Detection**. Azure SQL Database limits the number of concurrent workers, logins, and sessions. The limits depend on the service tier. For more information, see [Azure SQL Database resource limits][sql-db-limits].

To detect these errors, catch `System.Data.SqlClient.SqlException` and check the value of `SqlException.Number` for the SQL error code. For a list of relevant error codes, see [SQL error codes for SQL Database client applications: Database connection error and other issues][sql-db-errors].

**Recovery**. These errors are considered transient, so retrying may resolve the issue. If you consistently hit these errors, consider scaling the database.

**Diagnostics**. - The [sys.event_log][sys.event_log] query returns successful database connections, connection failures, and deadlocks.

- Create an [alert rule][azure-alerts] for failed connections.
- Enable [SQL Database auditing][sql-db-audit] and check for failed logins.

## Service Bus Messaging

### Reading a message from a Service Bus queue fails.

**Detection**. Catch exceptions from the client SDK. The base class for Service Bus exceptions is [MessagingException][sb-messagingexception-class]. If the error is transient, the `IsTransient` property is true.

For more information, see [Service Bus messaging exceptions][sb-messaging-exceptions].

**Recovery:**

1. Retry on transient failures.
2. Messages that cannot be delivered to any receiver are placed in a *dead-letter queue*. Use this queue to see which messages couldn't be received. There's no automatic cleanup of the dead-letter queue. Messages remain there until you explicitly retrieve them. See [Overview of Service Bus dead-letter queues][sb-dead-letter-queue].

### Writing a message to a Service Bus queue fails.

**Detection**. Catch exceptions from the client SDK. The base class for Service Bus exceptions is [MessagingException][sb-messagingexception-class]. If the error is transient, the `IsTransient` property is true.

For more information, see [Service Bus messaging exceptions][sb-messaging-exceptions].

**Recovery:**

- The Service Bus client automatically retries after transient errors. By default, it uses exponential back-off. After the maximum retry count or maximum timeout period, the client throws an exception.
- If the queue quota is exceeded, the client throws [QuotaExceededException][QuotaExceededException]. The exception message gives more details. Drain some messages from the queue before retrying, and consider using the Circuit Breaker pattern to avoid continued retries while the quota is exceeded. Also, make sure the [BrokeredMessage.TimeToLive] property isn't set too high.
- Within a region, resiliency can be improved by using [partitioned queues or topics][sb-partition]. A non-partitioned queue or topic is assigned to one messaging store. If this messaging store is unavailable, all operations on that queue or topic will fail. A partitioned queue or topic is partitioned across multiple messaging stores.
- Use zone redundancy to automatically replicate changes between multiple availability zones. If one availability zone fails, failover happens automatically. For more information, see [Best practices for insulating applications against Service Bus outages and disasters](/azure/service-bus-messaging/service-bus-outages-disasters).
- If you're designing a multi-region solution, create two Service Bus namespaces in different regions, and replicate the messages. You can use either active replication or passive replication.

  - Active replication: The client sends every message to both queues. The receiver listens on both queues. Tag messages with a unique identifier, so the client can discard duplicate messages.
  - Passive replication: The client sends the message to one queue. If there's an error, the client falls back to the other queue. The receiver listens on both queues. This approach reduces the number of duplicate messages that are sent. However, the receiver must still handle duplicate messages.

  For more information, see [GeoReplication sample][sb-georeplication-sample] and [Best practices for insulating applications against Service Bus outages and disasters](/azure/service-bus-messaging/service-bus-outages-disasters).

### Duplicate message.

**Detection**. Examine the `MessageId` and `DeliveryCount` properties of the message.

**Recovery:**

- If possible, design your message processing operations to be idempotent. Otherwise, store message IDs of messages that are already processed, and check the ID before processing a message.
- Enable duplicate detection, by creating the queue with `RequiresDuplicateDetection` set to true. With this setting, Service Bus automatically deletes any message that is sent with the same `MessageId` as a previous message.  Note the following:

  - This setting prevents duplicate messages from being put into the queue. It doesn't prevent a receiver from processing the same message more than once.
  - Duplicate detection has a time window. If a duplicate is sent beyond this window, it won't be detected.

**Diagnostics**. Log duplicated messages.

### The application can't process a particular message from the queue.

**Detection**. Application specific. For example, the message contains invalid data, or the business logic fails for some reason.

**Recovery:**

There are two failure modes to consider.

- The receiver detects the failure. In this case, move the message to the dead-letter queue. Later, run a separate process to examine the messages in the dead-letter queue.
- The receiver fails in the middle of processing the message &mdash; for example, due to an unhandled exception. To handle this case, use `PeekLock` mode. In this mode, if the lock expires, the message becomes available to other receivers. If the message exceeds the maximum delivery count or the time-to-live, the message is automatically moved to the dead-letter queue.

For more information, see [Overview of Service Bus dead-letter queues][sb-dead-letter-queue].

**Diagnostics**. Whenever the application moves a message to the dead-letter queue, write an event to the application logs.

## Storage

### Writing data to Azure Storage fails

**Detection**. The client receives errors when writing.

**Recovery:**

1. Retry the operation, to recover from transient failures. The [retry policy][Storage.RetryPolicies] in the client SDK handles this automatically.
2. Implement the Circuit Breaker pattern to avoid overwhelming storage.
3. If N retry attempts fail, perform a graceful fallback. For example:

   - Store the data in a local cache, and forward the writes to storage later, when the service becomes available.
   - If the write action was in a transactional scope, compensate the transaction.

**Diagnostics**. Use [storage metrics][storage-metrics].

### Reading data from Azure Storage fails.

**Detection**. The client receives errors when reading.

**Recovery:**

1. Retry the operation, to recover from transient failures. The [retry policy][Storage.RetryPolicies] in the client SDK handles this automatically.
2. For RA-GRS storage, if reading from the primary endpoint fails, try reading from the secondary endpoint. The client SDK can handle this automatically. See [Azure Storage replication][storage-replication].
3. If *N* retry attempts fail, take a fallback action to degrade gracefully. For example, if a product image can't be retrieved from storage, show a generic placeholder image.

**Diagnostics**. Use [storage metrics][storage-metrics].

## Virtual machine

### Connection to a backend VM fails.

**Detection**. Network connection errors.

**Recovery:**

- Deploy at least two backend VMs in an availability set, behind a load balancer.
- If the connection error is transient, sometimes TCP will successfully retry sending the message.
- Implement a retry policy in the application.
- For persistent or nontransient errors, implement the [Circuit Breaker][circuit-breaker] pattern.
- If the calling VM exceeds its network egress limit, the outbound queue will fill up. If the outbound queue is consistently full, consider scaling out.

**Diagnostics**. Log events at service boundaries.

### VM instance becomes unavailable or unhealthy.

**Detection**. Configure a Load Balancer [health probe][lb-probe] that signals whether the VM instance is healthy. The probe should check whether critical functions are responding correctly.

**Recovery**. For each application tier, put multiple VM instances into the same availability set, and place a load balancer in front of the VMs. If the health probe fails, the Load Balancer stops sending new connections to the unhealthy instance.

**Diagnostics**. - Use Load Balancer [log analytics][lb-monitor].

- Configure your monitoring system to monitor all of the health monitoring endpoints.

### Operator accidentally shuts down a VM.

**Detection**. N/A

**Recovery**. Set a resource lock with `ReadOnly` level. See [Lock resources with Azure Resource Manager][rm-locks].

**Diagnostics**. Use [Azure Activity Logs][azure-activity-logs].

## WebJobs

### Continuous job stops running when the SCM host is idle.

**Detection**. Pass a cancellation token to the WebJob function. For more information, see [Graceful shutdown][web-jobs-shutdown].

**Recovery**. Enable the `Always On` setting in the web app. For more information, see [Run Background tasks with WebJobs][web-jobs].

## Application design

### Application can't handle a spike in incoming requests.

**Detection**. Depends on the application. Typical symptoms:

- The website starts returning HTTP 5xx error codes.
- Dependent services, such as database or storage, start to throttle requests. Look for HTTP errors such as HTTP 429 (Too Many Requests), depending on the service.
- HTTP queue length grows.

**Recovery:**

- Scale out to handle increased load.
- Mitigate failures to avoid having cascading failures disrupt the entire application. Mitigation strategies include:

  - Implement the [Throttling pattern][throttling-pattern] to avoid overwhelming backend systems.
  - Use [queue-based load leveling][queue-based-load-leveling] to buffer requests and process them at an appropriate pace.
  - Prioritize certain clients. For example, if the application has free and paid tiers, throttle customers on the free tier, but not paid customers. See [Priority queue pattern][priority-queue-pattern].

**Diagnostics**. Use [App Service diagnostic logging][app-service-logging]. Use a service such as [Azure Log Analytics][azure-log-analytics], [Application Insights][app-insights], or [New Relic][new-relic] to help understand the diagnostic logs.

:::image type="icon" source="../_images/github.png" border="false"::: A sample is available [here](https://github.com/mspnp/samples/tree/main/Reliability/FailureModeAnalysisSample). It uses [Polly](https://github.com/App-vNext/Polly) for these exceptions:

- 429 - Throttling
- 408 - Timeout
- 401 - Unauthorized
- 503 or 5xx - Service unavailable

### One of the operations in a workflow or distributed transaction fails.

**Detection**. After *N* retry attempts, it still fails.

**Recovery:**

- As a mitigation plan, implement the [Scheduler Agent Supervisor][scheduler-agent-supervisor] pattern to manage the entire workflow.
- Don't retry on timeouts. There's a low success rate for this error.
- Queue work, in order to retry later.

**Diagnostics**. Log all operations (successful and failed), including compensating actions. Use correlation IDs, so that you can track all operations within the same transaction.

### A call to a remote service fails.

**Detection**. HTTP error code.

**Recovery:**

1. Retry on transient failures.
2. If the call fails after *N* attempts, take a fallback action. (Application specific.)
3. Implement the [Circuit Breaker pattern][circuit-breaker] to avoid cascading failures.

**Diagnostics**. Log all remote call failures.

## Next steps

See [Resiliency and dependencies](/azure/well-architected/resiliency/design-resiliency) in the Azure Well-Architected Framework. Building failure recovery into the system should be part of the architecture and design phases from the beginning to avoid the risk of failure.

<!-- links -->

[api-management]: /azure/api-management
[api-management-throttling]: /azure/api-management/api-management-sample-flexible-throttling
[app-insights]: /azure/application-insights/app-insights-overview
[app-insights-web-apps]: /azure/application-insights/app-insights-azure-web-apps
[app-service-configure]: /azure/app-service-web/web-sites-configure
[app-service-logging]: /azure/app-service-web/web-sites-enable-diagnostic-log
[app-service-slots]: /azure/app-service-web/web-sites-staged-publishing
[auto-rest-client-retry]: https://github.com/Azure/autorest/tree/main/docs
[azure-activity-logs]: /azure/monitoring-and-diagnostics/monitoring-overview-activity-logs
[azure-alerts]: /azure/monitoring-and-diagnostics/insights-alerts-portal
[azure-log-analytics]: /azure/log-analytics/log-analytics-overview
[BrokeredMessage.TimeToLive]: /dotnet/api/microsoft.servicebus.messaging.brokeredmessage?view=azure-dotnet&preserve-view=true
[cassandra-error-handling]: https://www.datastax.com/dev/blog/cassandra-error-handling-done-right
[circuit-breaker]: /previous-versions/msp-n-p/dn589784(v=pandp.10)
[cosmos-db-multi-region]: /azure/cosmos-db/tutorial-global-distribution-sql-api
[health-endpoint-monitoring-pattern]: ../patterns/health-endpoint-monitoring.yml
[lb-monitor]: /azure/load-balancer/load-balancer-monitor-log
[lb-probe]: /azure/load-balancer/load-balancer-custom-probe-overview#types
[new-relic]: https://newrelic.com
[priority-queue-pattern]: /previous-versions/msp-n-p/dn589794(v=pandp.10)
[queue-based-load-leveling]: /previous-versions/msp-n-p/dn589783(v=pandp.10)
[QuotaExceededException]: /dotnet/api/microsoft.servicebus.messaging.quotaexceededexception?view=azure-dotnet&preserve-view=true
[ra-web-apps-basic]: ../web-apps/app-service/architectures/basic-web-app.yml
[redis-monitor]: /azure/azure-cache-for-redis/cache-how-to-monitor
[rm-locks]: /azure/azure-resource-manager/resource-group-lock-resources/
[sb-dead-letter-queue]: /azure/service-bus-messaging/service-bus-dead-letter-queues/
[sb-georeplication-sample]: https://github.com/Azure/azure-service-bus/tree/master/samples/DotNet/Microsoft.Azure.ServiceBus/GeoReplication
[sb-messagingexception-class]: /dotnet/api/microsoft.servicebus.messaging.messagingexception?view=azure-dotnet&preserve-view=true
[sb-messaging-exceptions]: /azure/service-bus-messaging/service-bus-messaging-exceptions
[sb-partition]: /azure/service-bus-messaging/service-bus-partitioning
[sb-poison-message]: /azure/app-service/webjobs-sdk-how-to#automatic-triggers
[search-sdk]:  /dotnet/api/overview/azure/search?view=azure-dotnet&preserve-view=true
[scheduler-agent-supervisor]: /previous-versions/msp-n-p/dn589780(v=pandp.10)
[search-analytics]: /azure/search/search-traffic-analytics
[sql-db-audit]: /azure/sql-database/sql-database-auditing-get-started
[sql-db-errors]: /azure/sql-database/sql-database-develop-error-messages/#resource-governance-errors
[sql-db-failover]: /azure/sql-database/sql-database-geo-replication-failover-portal
[sql-db-limits]: /azure/sql-database/sql-database-resource-limits
[sql-db-replication]: /azure/sql-database/sql-database-geo-replication-overview
[storage-metrics]: /azure/storage/common/monitor-storage
[storage-replication]: /azure/storage/storage-redundancy
[Storage.RetryPolicies]: /dotnet/api/microsoft.azure.storage.retrypolicies
[sys.event_log]: /sql/relational-databases/system-catalog-views/sys-event-log-azure-sql-database?view=azuresqldb-current&preserve-view=true
[throttling-pattern]: /previous-versions/msp-n-p/dn589798(v=pandp.10)
[web-jobs]: /azure/app-service-web/web-sites-create-web-jobs
[web-jobs-shutdown]: /azure/app-service/webjobs-sdk-how-to#cancellation-tokens

---
title: Azure service retry guidance
titleSuffix: Best practices for cloud applications
description: Learn about the retry mechanism features for many Azure services. Retry mechanisms differ because services have different characteristics and requirements.
author: martinekuan
ms.date: 09/16/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: best-practice
categories:
  - azure
products:
  - azure-active-directory
ms.custom:
  - best-practice
---

<!-- cSpell:ignore MSAL adonet backoff booksleeve linq timespan servicebus retryable typeof localdb mssqllocaldb autoflushing -->

# Retry guidance for Azure services

Most Azure services and client SDKs include a retry mechanism. However, these differ because each service has different characteristics and requirements, and so each retry mechanism is tuned to a specific service. This guide summarizes the retry mechanism features for most Azure services, and includes information to help you use, adapt, or extend the retry mechanism for that service.

For general guidance on handling transient faults, and retrying connections and operations against services and resources, see [Retry guidance](./transient-faults.md).

The following table summarizes the retry features for the Azure services described in this guidance.

| **Service** | **Retry capabilities** | **Policy configuration** | **Scope** | **Telemetry features** |
| --- | --- | --- | --- | --- |
| **[Azure Active Directory](#azure-active-directory)** |Native in MSAL library |Embedded into MSAL library |Internal |None |
| **[Azure Cosmos DB](#azure-cosmos-db)** |Native in service |Non-configurable |Global |TraceSource |
| **[Data Lake Store](#data-lake-store)** |Native in client |Non-configurable |Individual operations |None |
| **[Event Hubs](#event-hubs)** |Native in client |Programmatic |Client |None |
| **[IoT Hub](#iot-hub)** |Native in client SDK |Programmatic |Client |None |
| **[Azure Cache for Redis](#azure-cache-for-redis)** |Native in client |Programmatic |Client |TextWriter |
| **[Search](#azure-search)** |Native in client |Programmatic |Client |ETW or Custom |
| **[Service Bus](#service-bus)** |Native in client |Programmatic |Namespace Manager, Messaging Factory, and Client |ETW |
| **[Service Fabric](#service-fabric)** |Native in client |Programmatic |Client |None |
| **[SQL Database with ADO.NET](#sql-database-using-adonet)** |[Polly](#transient-fault-handling-with-polly) |Declarative and programmatic |Single statements or blocks of code |Custom |
| **[SQL Database with Entity Framework](#sql-database-using-entity-framework-6)** |Native in client |Programmatic |Global per AppDomain |None |
| **[SQL Database with Entity Framework Core](#sql-database-using-entity-framework-core)** |Native in client |Programmatic |Global per AppDomain |None |
| **[Storage](#azure-storage)** |Native in client |Programmatic |Client and individual operations |TraceSource |

> [!NOTE]
> For most of the Azure built-in retry mechanisms, there is currently no way apply a different retry policy for different types of error or exception. You should configure a policy that provides the optimum average performance and availability. One way to fine-tune the policy is to analyze log files to determine the type of transient faults that are occurring.

<!-- markdownlint-disable MD024 -->

## Azure Active Directory

Azure Active Directory (Azure AD) is a comprehensive identity and access management cloud solution that combines core directory services, advanced identity governance, security, and application access management. Azure AD also offers developers an identity management platform to deliver access control to their applications, based on centralized policy and rules.

> [!NOTE]
> For retry guidance on Managed Service Identity endpoints, see [How to use an Azure VM Managed Service Identity (MSI) for token acquisition](/azure/active-directory/managed-service-identity/how-to-use-vm-token#error-handling).

### Retry mechanism

There's a built-in retry mechanism for Azure Active Directory in the [Microsoft Authentication Library (MSAL)](/azure/active-directory/develop/msal-overview). To avoid unexpected lockouts, we recommend that third-party libraries and application code do **not** retry failed connections, but allow MSAL to handle retries.

### Retry usage guidance

Consider the following guidelines when using Azure Active Directory:

- When possible, use the MSAL library and the built-in support for retries.
- If you're using the REST API for Azure Active Directory, retry the operation if the result code is 429 (Too Many Requests) or an error in the 5xx range. Don't retry for any other errors.
- For 429 errors, only retry after the time indicated in the **Retry-After** header.
- For 5xx errors, use exponential back-off, with the first retry at least 5 seconds after the response.
- Don't retry on errors other than 429 and 5xx.

### Next steps

- [Microsoft Authentication Library (MSAL)](/azure/active-directory/develop/msal-overview)

## Azure Cosmos DB

Azure Cosmos DB is a fully managed multi-model database that supports schemaless JSON data. It offers configurable and reliable performance, native JavaScript transactional processing, and is built for the cloud with elastic scale.

### Retry mechanism

The Azure Cosmos DB SDKs automatically retry on certain error conditions, and user applications are encouraged to have their own retry policies. See the [guide to designing resilient applications with Azure Cosmos DB SDKs](/azure/cosmos-db/sql/conceptual-resilient-sdk-applications) for a complete list of error conditions and when to retry.

### Telemetry

Depending on the language of your application, diagnostics and telemetry are exposed as logs or promoted properties on the operation responses. For more information, see the "Capture the diagnostics" section in [Azure Cosmos DB C# SDK](/azure/cosmos-db/sql/troubleshoot-dot-net-sdk-slow-request?#capture-diagnostics) and [Azure Cosmos DB Java SDK](/azure/cosmos-db/sql/troubleshoot-java-sdk-v4-sql?tabs=async#capture-the-diagnostics).

## Data Lake Store

[Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction) makes Azure Storage the foundation for building enterprise data lakes on Azure. Data Lake Storage Gen2 allows you to easily manage massive amounts of data.

The [Azure Storage Files Data Lake client library](/dotnet/api/overview/azure/storage.files.datalake-readme)includes all the capabilities required to make it easy for developers, data scientists, and analysts to store data of any size, shape, and speed, and do all types of processing and analytics across platforms and languages

### Retry mechanism

The [DataLakeServiceClient](/dotnet/api/azure.storage.files.datalake.datalakeserviceclient) allows you to manipulate Azure Data Lake service resources and file systems. The storage account provides the top-level namespace for the Data Lake service. When you create the client you could provides the client configuration options for connecting to Azure Data Lake service ([DataLakeClientOptions](/dotnet/api/azure.storage.files.datalake.datalakeclientoptions)).
 The DataLakeClientOptions includes a Retry property (Inherited from Azure.Core.ClientOptions), that property includes all the configurations ([RetryOptions class](/dotnet/api/azure.core.retryoptions))

### Telemetry

[Monitoring](/azure/storage/blobs/data-lake-storage-best-practices#monitor-telemetry) the use and performance of Azure Storage is an important part of operationalizing your service. Examples include frequent operations, operations with high latency, or operations that cause service-side throttling.

All of the telemetry for your storage account is available through Azure Storage logs in Azure Monitor. This feature integrates your storage account with Log Analytics and Event Hubs, while also enabling you to archive logs to another storage account. To see the full list of metrics and resources logs and their associated schema, see [Azure Storage monitoring data reference](/azure/storage/blobs/monitor-blob-storage-reference).

## Event Hubs

Azure Event Hubs is a hyperscale telemetry ingestion service that collects, transforms, and stores millions of events.

### Retry mechanism

Retry behavior in the Azure Event Hubs Client Library is controlled by the `RetryPolicy` property on the `EventHubClient` class. The default policy retries with exponential backoff when Azure Event Hubs returns a transient `EventHubsException` or an `OperationCanceledException`. Default retry policy for Event Hubs is to retry up to 9 times with an exponential back-off time of up to 30 seconds.

### Example

```csharp
EventHubClient client = EventHubClient.CreateFromConnectionString("[event_hub_connection_string]");
client.RetryPolicy = RetryPolicy.Default;
```

### Next steps

[.NET Standard client library for Azure Event Hubs](https://github.com/Azure/azure-event-hubs-dotnet)

## IoT Hub

Azure IoT Hub is a service for connecting, monitoring, and managing devices to develop Internet of Things (IoT) applications.

### Retry mechanism

The Azure IoT device SDK can detect errors in the network, protocol, or application. Based on the error type, the SDK checks whether a retry needs to be performed. If the error is *recoverable*, the SDK begins to retry using the configured retry policy.

The default retry policy is *exponential back-off with random jitter*, but it can be configured.

### Policy configuration

Policy configuration differs by language. For more information, see [IoT Hub retry policy configuration](/azure/iot-hub/iot-hub-reliability-features-in-sdks#retry-policy-apis).

### Next steps

- [IoT Hub retry policy](/azure/iot-hub/iot-hub-reliability-features-in-sdks)
- [Troubleshoot IoT Hub device disconnection](/azure/iot-hub/iot-hub-troubleshoot-connectivity)

## Azure Cache for Redis

Azure Cache for Redis is a fast data access and low latency cache service based on the popular open-source Redis cache. It's secure, managed by Microsoft, and is accessible from any application in Azure.

The guidance in this section is based on using the StackExchange.Redis client to access the cache. A list of other suitable clients can be found on the [Redis website](https://redis.io/clients), and these may have different retry mechanisms.

The StackExchange.Redis client uses multiplexing through a single connection. The recommended usage is to create an instance of the client at application startup and use this instance for all operations against the cache. For this reason, the connection to the cache is made only once, and so all of the guidance in this section is related to the retry policy for this initial connection&mdash;and not for each operation that accesses the cache.

### Retry mechanism

The StackExchange.Redis client uses a connection manager class that is configured through a set of options, including:

- **ConnectRetry**. The number of times a failed connection to the cache will be retried.
- **ReconnectRetryPolicy**. The retry strategy to use.
- **ConnectTimeout**. The maximum waiting time in milliseconds.

### Policy configuration

Retry policies are configured programmatically by setting the options for the client before connecting to the cache. This can be done by creating an instance of the **ConfigurationOptions** class, populating its properties, and passing it to the **Connect** method.

The built-in classes support linear (constant) delay and exponential backoff with randomized retry intervals. You can also create a custom retry policy by implementing the **IReconnectRetryPolicy** interface.

The following example configures a retry strategy using exponential backoff.

```csharp
var deltaBackOffInMilliseconds = TimeSpan.FromSeconds(5).TotalMilliseconds;
var maxDeltaBackOffInMilliseconds = TimeSpan.FromSeconds(20).TotalMilliseconds;
var options = new ConfigurationOptions
{
    EndPoints = {"localhost"},
    ConnectRetry = 3,
    ReconnectRetryPolicy = new ExponentialRetry(deltaBackOffInMilliseconds, maxDeltaBackOffInMilliseconds),
    ConnectTimeout = 2000
};
ConnectionMultiplexer redis = ConnectionMultiplexer.Connect(options, writer);
```

Alternatively, you can specify the options as a string, and pass this to the **Connect** method. The **ReconnectRetryPolicy** property can't be set this way, only through code.

```csharp
var options = "localhost,connectRetry=3,connectTimeout=2000";
ConnectionMultiplexer redis = ConnectionMultiplexer.Connect(options, writer);
```

You can also specify options directly when you connect to the cache.

```csharp
var conn = ConnectionMultiplexer.Connect("redis0:6380,redis1:6380,connectRetry=3");
```

For more information, see [Stack Exchange Redis Configuration](https://stackexchange.github.io/StackExchange.Redis/Configuration) in the StackExchange.Redis documentation.

The following table shows the default settings for the built-in retry policy.

| **Context** | **Setting** | **Default value**<br />(v 1.2.2) | **Meaning** |
| --- | --- | --- | --- |
| ConfigurationOptions |ConnectRetry<br /><br />ConnectTimeout<br /><br />SyncTimeout<br /><br />ReconnectRetryPolicy |3<br /><br />Maximum 5000 ms plus SyncTimeout<br />1000<br /><br />LinearRetry 5000 ms |The number of times to repeat connect attempts during the initial connection operation.<br />Timeout (ms) for connect operations. Not a delay between retry attempts.<br />Time (ms) to allow for synchronous operations.<br /><br />Retry every 5000 ms.|

> [!NOTE]
> For synchronous operations, `SyncTimeout` can add to the end-to-end latency, but setting the value too low can cause excessive timeouts. See [How to troubleshoot Azure Cache for Redis][redis-cache-troubleshoot]. In general, avoid using synchronous operations, and use asynchronous operations instead. For more information, see [Pipelines and Multiplexers](https://github.com/StackExchange/StackExchange.Redis/blob/master/docs/PipelinesMultiplexers.md).

### Retry usage guidance

Consider the following guidelines when using Azure Cache for Redis:

- The StackExchange Redis client manages its own retries, but only when establishing a connection to the cache when the application first starts. You can configure the connection timeout, the number of retry attempts, and the time between retries to establish this connection, but the retry policy doesn't apply to operations against the cache.
- Instead of using a large number of retry attempts, consider falling back by accessing the original data source instead.

### Telemetry

You can collect information about connections (but not other operations) using a **TextWriter**.

```csharp
var writer = new StringWriter();
ConnectionMultiplexer redis = ConnectionMultiplexer.Connect(options, writer);
```

An example of the output this generates is shown below.

```text
localhost:6379,connectTimeout=2000,connectRetry=3
1 unique nodes specified
Requesting tie-break from localhost:6379 > __Booksleeve_TieBreak...
Allowing endpoints 00:00:02 to respond...
localhost:6379 faulted: SocketFailure on PING
localhost:6379 failed to nominate (Faulted)
> UnableToResolvePhysicalConnection on GET
No masters detected
localhost:6379: Standalone v2.0.0, master; keep-alive: 00:01:00; int: Connecting; sub: Connecting; not in use: DidNotRespond
localhost:6379: int ops=0, qu=0, qs=0, qc=1, wr=0, sync=1, socks=2; sub ops=0, qu=0, qs=0, qc=0, wr=0, socks=2
Circular op-count snapshot; int: 0 (0.00 ops/s; spans 10s); sub: 0 (0.00 ops/s; spans 10s)
Sync timeouts: 0; fire and forget: 0; last heartbeat: -1s ago
resetting failing connections to retry...
retrying; attempts left: 2...
...
```

### Examples

The following code example configures a constant (linear) delay between retries when initializing the StackExchange.Redis client. This example shows how to set the configuration using a **ConfigurationOptions** instance.

```csharp
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StackExchange.Redis;

namespace RetryCodeSamples
{
    class CacheRedisCodeSamples
    {
        public async static Task Samples()
        {
            var writer = new StringWriter();
            {
                try
                {
                    var retryTimeInMilliseconds = TimeSpan.FromSeconds(4).TotalMilliseconds; // delay between retries

                    // Using object-based configuration.
                    var options = new ConfigurationOptions
                                        {
                                            EndPoints = { "localhost" },
                                            ConnectRetry = 3,
                                            ReconnectRetryPolicy = new LinearRetry(retryTimeInMilliseconds)
                                        };
                    ConnectionMultiplexer redis = ConnectionMultiplexer.Connect(options, writer);

                    // Store a reference to the multiplexer for use in the application.
                }
                catch
                {
                    Console.WriteLine(writer.ToString());
                    throw;
                }
            }
        }
    }
}
```

The next example sets the configuration by specifying the options as a string. The connection timeout is the maximum period of time to wait for a connection to the cache, not the delay between retry attempts. The **ReconnectRetryPolicy** property can only be set by code.

```csharp
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StackExchange.Redis;

namespace RetryCodeSamples
{
    class CacheRedisCodeSamples
    {
        public async static Task Samples()
        {
            var writer = new StringWriter();
            {
                try
                {
                    // Using string-based configuration.
                    var options = "localhost,connectRetry=3,connectTimeout=2000";
                    ConnectionMultiplexer redis = ConnectionMultiplexer.Connect(options, writer);

                    // Store a reference to the multiplexer for use in the application.
                }
                catch
                {
                    Console.WriteLine(writer.ToString());
                    throw;
                }
            }
        }
    }
}
```

For more examples, see [Configuration](https://github.com/StackExchange/StackExchange.Redis/blob/master/docs/Configuration.md) on the project website.

### Next steps

- [Redis website](https://redis.io)

## Azure Search

Azure Search can be used to add powerful and sophisticated search capabilities to a website or application, quickly and easily tune search results, and construct rich and fine-tuned ranking models.

### Retry mechanism

Azure SDK for .NET includes an [Azure.Search.Documents](/dotnet/api/overview/azure/search) client library from the Azure SDK team that is functionally equivalent to the previous client library, [Microsoft.Azure.Search](/dotnet/api/microsoft.azure.search). 

Retry behavior in [Microsoft.Azure.Search](/dotnet/api/microsoft.azure.search) is controlled by the SetRetryPolicy method on the SearchServiceClient and SearchIndexClient classes. The default policy retries with exponential backoff when Azure Search returns a 5xx or 408 (Request Timeout) response.

Retry behavior in [Azure.Search.Documents](/dotnet/api/overview/azure/search) is controlled by [SearchClientOptions](/dotnet/api/azure.search.documents.searchclientoptions) (It is part of  the [SearchClient constructor](/dotnet/api/azure.search.documents.searchclient.-ctor#azure-search-documents-searchclient-ctor(system-uri-system-string-azure-azurekeycredential-azure-search-documents-searchclientoptions))) in the property Retry, which belongs to the class [Azure.Core.RetryOptions](/dotnet/api/azure.core.retryoptions)(where all configurations are available).

### Telemetry

Trace with ETW or by registering a custom trace provider. For more information, see the [AutoRest documentation][autorest].

## Service Bus

Service Bus is a cloud messaging platform that provides loosely coupled message exchange with improved scale and resiliency for components of an application, whether hosted in the cloud or on-premises.

### Retry mechanism

The namespace and some of the configuration details depend on which Service Bus client SDK package is used:

| Package | Description | Namespace |
|---------|-------------|-------|
| [Azure.Messaging.ServiceBus](https://www.nuget.org/packages/Azure.Messaging.ServiceBus/) | Azure Service Bus client library for .NET | `Azure.Messaging.ServiceBus` |
| [WindowsAzure.ServiceBus](https://www.nuget.org/packages/WindowsAzure.ServiceBus) |  This package is the older Service Bus client library. It requires .NET Framework 4.5.2. | `Microsoft.Azure.ServiceBus` |

#### Retry usage guidance

The `ServiceBusRetryOptions` property specifies the retry options for the `ServiceBusClient` object:

| Setting | Default value | Meaning |
|---------|---------------|---------|
| CustomRetryPolicy | | A custom retry policy to be used in place of the individual option values.|
| Delay | 0.8 seconds | The delay between retry attempts for a fixed approach or the delay on which to base calculations for a backoff-based approach.|
| MaxDelay | 60 seconds | The maximum permissible delay between retry attempts.|
| MaxRetries | 3 | The maximum number of retry attempts before considering the associated operation to have failed.|
| Mode | Exponential | The approach to use for calculating retry delays.|
| TryTimeout | 60 seconds | The maximum duration to wait for completion of a single attempt, whether the initial attempt or a retry.|

Set the `Mode` property to configure the [ServiceBusRetryMode](/dotnet/api/azure.messaging.servicebus.servicebusretrymode) with any of these values:

|Property|Value|Description|
|--------|-----|-----------|
|Exponential|1|Retry attempts will delay based on a backoff strategy, where each attempt will increase the duration that it waits before retrying.|
|Fixed|0|Retry attempts happen at fixed intervals; each delay is a consistent duration.|

Example:

```csharp
using Azure.Messaging.ServiceBus;

string connectionString = "<connection_string>";
string queueName = "<queue_name>";

// Because ServiceBusClient implements IAsyncDisposable, we'll create it
// with "await using" so that it is automatically disposed for us.
var options = new ServiceBusClientOptions();
options.RetryOptions = new ServiceBusRetryOptions
{
    Delay = TimeSpan.FromSeconds(10),
    MaxDelay = TimeSpan.FromSeconds(30),
    Mode = ServiceBusRetryMode.Exponential,
    MaxRetries = 3,
};
await using var client = new ServiceBusClient(connectionString, options);
```

### Telemetry

Service Bus collects the same kinds of monitoring data as other Azure resources. You can [Monitor Azure Service Bus](/azure/service-bus-messaging/monitor-service-bus) using Azure Monitor.

You also have various options for sending telemetry with the Service Bus .NET client libraries.

- [Tracking with Azure Application Insights](/azure/service-bus-messaging/service-bus-end-to-end-tracing#tracking-with-azure-application-insights)
- [Tracking with OpenTelemetry](/azure/service-bus-messaging/service-bus-end-to-end-tracing#tracking-with-opentelemetry)

### Example

The following code example shows how to use the `Azure.Messaging.ServiceBus` package to:

- Set the retry policy for a `ServiceBusClient` using a new `ServiceBusClientOptions`.
- Create a new message with a new instance of a `ServiceBusMessage`.
- Send a message to the Service Bus using the `ServiceBusSender.SendMessageAsync(message)` method.
- Receive using the `ServiceBusReceiver`, which are represented as `ServiceBusReceivedMessage` objects.

```csharp
// using Azure.Messaging.ServiceBus;

using Azure.Messaging.ServiceBus;

string connectionString = "<connection_string>";
string queueName = "queue1";

// Because ServiceBusClient implements IAsyncDisposable, we'll create it 
// with "await using" so that it is automatically disposed for us.
var options = new ServiceBusClientOptions();
options.RetryOptions = new ServiceBusRetryOptions
{
    Delay = TimeSpan.FromSeconds(10),
    MaxDelay = TimeSpan.FromSeconds(30),
    Mode = ServiceBusRetryMode.Exponential,
    MaxRetries = 3,
};
await using var client = new ServiceBusClient(connectionString, options);

// The sender is responsible for publishing messages to the queue.
ServiceBusSender sender = client.CreateSender(queueName);
ServiceBusMessage message = new ServiceBusMessage("Hello world!");

await sender.SendMessageAsync(message);

// The receiver is responsible for reading messages from the queue.
ServiceBusReceiver receiver = client.CreateReceiver(queueName);
ServiceBusReceivedMessage receivedMessage = await receiver.ReceiveMessageAsync();

string body = receivedMessage.Body.ToString();
Console.WriteLine(body);
```

### Next steps

- [Asynchronous Messaging Patterns and High Availability](/azure/service-bus-messaging/service-bus-async-messaging)

## Service Fabric

Distributing reliable services in a Service Fabric cluster guards against most of the potential transient faults discussed in this article. Some transient faults are still possible, however. For example, the naming service might be in the middle of a routing change when it gets a request, causing it to throw an exception. If the same request comes 100 milliseconds later, it will probably succeed.

Internally, Service Fabric manages this kind of transient fault. You can configure some settings by using the `OperationRetrySettings` class while setting up your services. The following code shows an example. In most cases, this shouldn't be necessary, and the default settings will be fine.

```csharp
FabricTransportRemotingSettings transportSettings = new FabricTransportRemotingSettings
{
    OperationTimeout = TimeSpan.FromSeconds(30)
};

var retrySettings = new OperationRetrySettings(TimeSpan.FromSeconds(15), TimeSpan.FromSeconds(1), 5);

var clientFactory = new FabricTransportServiceRemotingClientFactory(transportSettings);

var serviceProxyFactory = new ServiceProxyFactory((c) => clientFactory, retrySettings);

var client = serviceProxyFactory.CreateServiceProxy<ISomeService>(
    new Uri("fabric:/SomeApp/SomeStatefulReliableService"),
    new ServicePartitionKey(0));
```

### Next steps

- [Remote exception handling](/azure/service-fabric/service-fabric-reliable-services-communication-remoting#remoting-exception-handling)

## SQL Database using ADO.NET

SQL Database is a hosted SQL database available in a range of sizes and as both a standard (shared) and premium (non-shared) service.

### Retry mechanism

SQL Database has no built-in support for retries when accessed using ADO.NET. However, the return codes from requests can be used to determine why a request failed. For more information about SQL Database throttling, see [Azure SQL Database resource limits](/azure/sql-database/sql-database-resource-limits). For a list of relevant error codes, see [SQL error codes for SQL Database client applications](/azure/sql-database/sql-database-develop-error-messages).

You can use the Polly library to implement retries for SQL Database. See [Transient fault handling with Polly](#transient-fault-handling-with-polly).

### Retry usage guidance

Consider the following guidelines when accessing SQL Database using ADO.NET:

- Choose the appropriate service option (shared or premium). A shared instance may suffer longer than usual connection delays and throttling due to the usage by other tenants of the shared server. If more predictable performance and reliable low latency operations are required, consider choosing the premium option.
- Ensure that you perform retries at the appropriate level or scope to avoid non-idempotent operations causing inconsistency in the data. Ideally, all operations should be idempotent so that they can be repeated without causing inconsistency. Where this isn't the case, the retry should be performed at a level or scope that allows all related changes to be undone if one operation fails; for example, from within a transactional scope. For more information, see [Cloud Service Fundamentals Data Access Layer – Transient Fault Handling](https://social.technet.microsoft.com/wiki/contents/articles/18665.cloud-service-fundamentals-data-access-layer-transient-fault-handling.aspx#Idempotent_Guarantee).
- A fixed interval strategy isn't recommended for use with Azure SQL Database except for interactive scenarios where there are only a few retries at short intervals. Instead, consider using an exponential back-off strategy for most scenarios.
- Choose a suitable value for the connection and command timeouts when defining connections. Too short a timeout may result in premature failures of connections when the database is busy. Too long a timeout may prevent the retry logic working correctly by waiting too long before detecting a failed connection. The value of the timeout is a component of the end-to-end latency; it's effectively added to the retry delay specified in the retry policy for every retry attempt.
- Close the connection after some retries, even when using an exponential back off retry logic, and retry the operation on a new connection. Retrying the same operation multiple times on the same connection can be a factor that contributes to connection problems. For an example of this technique, see [Cloud Service Fundamentals Data Access Layer – Transient Fault Handling](https://social.technet.microsoft.com/wiki/contents/articles/18665.cloud-service-fundamentals-data-access-layer-transient-fault-handling.aspx).
- When connection pooling is in use (the default) there's a chance that the same connection will be chosen from the pool, even after closing and reopening a connection. If so, a technique to resolve it's to call the **ClearPool** method of the **SqlConnection** class to mark the connection as not reusable. However, you should do this only after several connection attempts have failed, and only when encountering the specific class of transient failures such as SQL timeouts (error code -2) related to faulty connections.
- If the data access code uses transactions initiated as **TransactionScope** instances, the retry logic should reopen the connection and initiate a new transaction scope. For this reason, the retryable code block should encompass the entire scope of the transaction.

Consider starting with the following settings for retrying operations. These settings are general purpose, and you should monitor the operations and fine-tune the values to suit your own scenario.

| **Context** | **Sample target E2E<br />max latency** | **Retry strategy** | **Settings** | **Values** | **How it works** |
| --- | --- | --- | --- | --- | --- |
| Interactive, UI,<br />or foreground |2 sec |FixedInterval |Retry count<br />Retry interval<br />First fast retry |3<br />500 ms<br />true |Attempt 1 - delay 0 sec<br />Attempt 2 - delay 500 ms<br />Attempt 3 - delay 500 ms |
| Background<br />or batch |30 sec |ExponentialBackoff |Retry count<br />Min back-off<br />Max back-off<br />Delta back-off<br />First fast retry |5<br />0 sec<br />60 sec<br />2 sec<br />false |Attempt 1 - delay 0 sec<br />Attempt 2 - delay ~2 sec<br />Attempt 3 - delay ~6 sec<br />Attempt 4 - delay ~14 sec<br />Attempt 5 - delay ~30 sec |

> [!NOTE]
> The end-to-end latency targets assume the default timeout for connections to the service. If you specify longer connection timeouts, the end-to-end latency will be extended by this additional time for every retry attempt.

### Examples

This section shows how you can use Polly to access Azure SQL Database using a set of retry policies configured in the `Policy` class.

The following code shows an extension method on the `SqlCommand` class that calls `ExecuteAsync` with exponential backoff.

```csharp
public async static Task<SqlDataReader> ExecuteReaderWithRetryAsync(this SqlCommand command)
{
    GuardConnectionIsNotNull(command);

    var policy = Policy.Handle<Exception>().WaitAndRetryAsync(
        retryCount: 3, // Retry 3 times
        sleepDurationProvider: attempt => TimeSpan.FromMilliseconds(200 * Math.Pow(2, attempt - 1)), // Exponential backoff based on an initial 200 ms delay.
        onRetry: (exception, attempt) =>
        {
            // Capture some information for logging/telemetry.
            logger.LogWarn($"ExecuteReaderWithRetryAsync: Retry {attempt} due to {exception}.");
        });

    // Retry the following call according to the policy.
    await policy.ExecuteAsync<SqlDataReader>(async token =>
    {
        // This code is executed within the Policy

        if (conn.State != System.Data.ConnectionState.Open) await conn.OpenAsync(token);
        return await command.ExecuteReaderAsync(System.Data.CommandBehavior.Default, token);

    }, cancellationToken);
}
```

This asynchronous extension method can be used as follows.

```csharp
var sqlCommand = sqlConnection.CreateCommand();
sqlCommand.CommandText = "[some query]";

using (var reader = await sqlCommand.ExecuteReaderWithRetryAsync())
{
    // Do something with the values
}
```

### Next steps

- [Cloud Service Fundamentals Data Access Layer – Transient Fault Handling](https://social.technet.microsoft.com/wiki/contents/articles/18665.cloud-service-fundamentals-data-access-layer-transient-fault-handling.aspx)

For general guidance on getting the most from SQL Database, see [Azure SQL Database performance and elasticity guide](https://social.technet.microsoft.com/wiki/contents/articles/3507.windows-azure-sql-database-performance-and-elasticity-guide.aspx).

## SQL Database using Entity Framework 6

SQL Database is a hosted SQL database available in a range of sizes and as both a standard (shared) and premium (non-shared) service. Entity Framework is an object-relational mapper that enables .NET developers to work with relational data using domain-specific objects. It eliminates the need for most of the data-access code that developers usually need to write.

### Retry mechanism

Retry support is provided when accessing SQL Database using Entity Framework 6.0 and higher through a mechanism called [Connection resiliency / retry logic](/ef/ef6/fundamentals/connection-resiliency/retry-logic). The main features of the retry mechanism are:

- The primary abstraction is the **IDbExecutionStrategy** interface. This interface:
  - Defines synchronous and asynchronous **Execute** methods.
  - Defines classes that can be used directly or can be configured on a database context as a default strategy, mapped to provider name, or mapped to a provider name and server name. When configured on a context, retries occur at the level of individual database operations, of which there might be several for a given context operation.
  - Defines when to retry a failed connection, and how.
- It includes several built-in implementations of the **IDbExecutionStrategy** interface:
  - Default: no retrying.
  - Default for SQL Database (automatic): no retrying, but inspects exceptions and wraps them with suggestion to use the SQL Database strategy.
  - Default for SQL Database: exponential (inherited from base class) plus SQL Database detection logic.
- It implements an exponential back-off strategy that includes randomization.
- The built-in retry classes are stateful and aren't thread-safe. However, they can be reused after the current operation is completed.
- If the specified retry count is exceeded, the results are wrapped in a new exception. It doesn't bubble up the current exception.

### Policy configuration

Retry support is provided when accessing SQL Database using Entity Framework 6.0 and higher. Retry policies are configured programmatically. The configuration can't be changed on a per-operation basis.

When configuring a strategy on the context as the default, you specify a function that creates a new strategy on demand. The following code shows how you can create a retry configuration class that extends the **DbConfiguration** base class.

```csharp
public class BloggingContextConfiguration : DbConfiguration
{
  public BlogConfiguration()
  {
    // Set up the execution strategy for SQL Database (exponential) with 5 retries and 4 sec delay
    this.SetExecutionStrategy(
         "System.Data.SqlClient", () => new SqlAzureExecutionStrategy(5, TimeSpan.FromSeconds(4)));
  }
}
```

You can then specify this as the default retry strategy for all operations using the **SetConfiguration** method of the **DbConfiguration** instance when the application starts. By default, EF will automatically discover and use the configuration class.

```csharp
DbConfiguration.SetConfiguration(new BloggingContextConfiguration());
```

You can specify the retry configuration class for a context by annotating the context class with a **DbConfigurationType** attribute. However, if you have only one configuration class, EF will use it without the need to annotate the context.

```csharp
[DbConfigurationType(typeof(BloggingContextConfiguration))]
public class BloggingContext : DbContext
```

If you need to use different retry strategies for specific operations, or disable retries for specific operations, you can create a configuration class that allows you to suspend or swap strategies by setting a flag in the **CallContext**. The configuration class can use this flag to switch strategies, or disable the strategy you provide and use a default strategy. For more information, see [Suspend Execution Strategy](/ef/ef6/fundamentals/connection-resiliency/retry-logic#solution-manually-call-execution-strategy) (EF6 onwards).

Another technique for using specific retry strategies for individual operations is to create an instance of the required strategy class and supply the desired settings through parameters. You then invoke its **ExecuteAsync** method.

```csharp
var executionStrategy = new SqlAzureExecutionStrategy(5, TimeSpan.FromSeconds(4));
var blogs = await executionStrategy.ExecuteAsync(
    async () =>
    {
        using (var db = new BloggingContext("Blogs"))
        {
            // Acquire some values asynchronously and return them
        }
    },
    new CancellationToken()
);
```

The simplest way to use a **DbConfiguration** class is to locate it in the same assembly as the **DbContext** class. However, this isn't appropriate when the same context is required in different scenarios, such as different interactive and background retry strategies. If the different contexts execute in separate AppDomains, you can use the built-in support for specifying configuration classes in the configuration file or set it explicitly using code. If the different contexts must execute in the same AppDomain, a custom solution will be required.

For more information, see [Code-Based Configuration](/ef/ef6/fundamentals/configuring/code-based) (EF6 onwards).

The following table shows the default settings for the built-in retry policy when using EF6.

| Setting | Default value | Meaning |
|---------|---------------|---------|
| Policy | Exponential | Exponential back-off. |
| MaxRetryCount | 5 | The maximum number of retries. |
| MaxDelay | 30 seconds | The maximum delay between retries. This value doesn't affect how the series of delays are computed. It only defines an upper bound. |
| DefaultCoefficient | 1 second | The coefficient for the exponential back-off computation. This value can't be changed. |
| DefaultRandomFactor | 1.1 | The multiplier used to add a random delay for each entry. This value can't be changed. |
| DefaultExponentialBase | 2 | The multiplier used to calculate the next delay. This value can't be changed. |

### Retry usage guidance

Consider the following guidelines when accessing SQL Database using EF6:

- Choose the appropriate service option (shared or premium). A shared instance may suffer longer than usual connection delays and throttling due to the usage by other tenants of the shared server. If predictable performance and reliable low latency operations are required, consider choosing the premium option.

- A fixed interval strategy isn't recommended for use with Azure SQL Database. Instead, use an exponential back-off strategy because the service may be overloaded, and longer delays allow more time for it to recover.

- Choose a suitable value for the connection and command timeouts when defining connections. Base the timeout on both your business logic design and through testing. You may need to modify this value over time as the volumes of data or the business processes change. Too short a timeout may result in premature failures of connections when the database is busy. Too long a timeout may prevent the retry logic working correctly by waiting too long before detecting a failed connection. The value of the timeout is a component of the end-to-end latency, although you can't easily determine how many commands will execute when saving the context. You can change the default timeout by setting the **CommandTimeout** property of the **DbContext** instance.

- Entity Framework supports retry configurations defined in configuration files. However, for maximum flexibility on Azure you should consider creating the configuration programmatically within the application. The specific parameters for the retry policies, such as the number of retries and the retry intervals, can be stored in the service configuration file and used at runtime to create the appropriate policies. This allows the settings to be changed without requiring the application to be restarted.

Consider starting with the following settings for retrying operations. You can't specify the delay between retry attempts (it's fixed and generated as an exponential sequence). You can specify only the maximum values, as shown here; unless you create a custom retry strategy. These settings are general purpose, and you should monitor the operations and fine-tune the values to suit your own scenario.

| **Context** | **Sample target E2E<br />max latency** | **Retry policy** | **Settings** | **Values** | **How it works** |
| --- | --- | --- | --- | --- | --- |
| Interactive, UI,<br />or foreground |2 seconds |Exponential |MaxRetryCount<br />MaxDelay |3<br />750 ms |Attempt 1 - delay 0 sec<br />Attempt 2 - delay 750 ms<br />Attempt 3 – delay 750 ms |
| Background<br /> or batch |30 seconds |Exponential |MaxRetryCount<br />MaxDelay |5<br />12 seconds |Attempt 1 - delay 0 sec<br />Attempt 2 - delay ~1 sec<br />Attempt 3 - delay ~3 sec<br />Attempt 4 - delay ~7 sec<br />Attempt 5 - delay 12 sec |

> [!NOTE]
> The end-to-end latency targets assume the default timeout for connections to the service. If you specify longer connection timeouts, the end-to-end latency will be extended by this additional time for every retry attempt.

### Examples

The following code example defines a simple data access solution that uses Entity Framework. It sets a specific retry strategy by defining an instance of a class named **BlogConfiguration** that extends **DbConfiguration**.

```csharp
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.SqlServer;
using System.Threading.Tasks;

namespace RetryCodeSamples
{
    public class BlogConfiguration : DbConfiguration
    {
        public BlogConfiguration()
        {
            // Set up the execution strategy for SQL Database (exponential) with 5 retries and 12 sec delay.
            // These values could be loaded from configuration rather than being hard-coded.
            this.SetExecutionStrategy(
                    "System.Data.SqlClient", () => new SqlAzureExecutionStrategy(5, TimeSpan.FromSeconds(12)));
        }
    }

    // Specify the configuration type if more than one has been defined.
    // [DbConfigurationType(typeof(BlogConfiguration))]
    public class BloggingContext : DbContext
    {
        // Definition of content goes here.
    }

    class EF6CodeSamples
    {
        public async static Task Samples()
        {
            // Execution strategy configured by DbConfiguration subclass, discovered automatically or
            // or explicitly indicated through configuration or with an attribute. Default is no retries.
            using (var db = new BloggingContext("Blogs"))
            {
                // Add, edit, delete blog items here, then:
                await db.SaveChangesAsync();
            }
        }
    }
}
```

More examples of using the Entity Framework retry mechanism can be found in [Connection resiliency / retry logic](/ef/ef6/fundamentals/connection-resiliency/retry-logic).

### Next steps

- [Azure SQL Database performance and elasticity guide](https://social.technet.microsoft.com/wiki/contents/articles/3507.windows-azure-sql-database-performance-and-elasticity-guide.aspx)

## SQL Database using Entity Framework Core

[Entity Framework Core](/ef/core) is an object-relational mapper that enables .NET Core developers to work with data using domain-specific objects. It eliminates the need for most of the data-access code that developers usually need to write. This version of Entity Framework was written from the ground up, and doesn't automatically inherit all the features from EF6.x.

### Retry mechanism

Retry support is provided when accessing SQL Database using Entity Framework Core through a mechanism called [connection resiliency](/ef/core/miscellaneous/connection-resiliency). Connection resiliency was introduced in EF Core 1.1.0.

The primary abstraction is the `IExecutionStrategy` interface. The execution strategy for SQL Server, including SQL Azure, is aware of the exception types that can be retried and has sensible defaults for maximum retries, delay between retries, and so on.

### Examples

The following code enables automatic retries when configuring the DbContext object, which represents a session with the database.

```csharp
protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
{
    optionsBuilder
        .UseSqlServer(
            @"Server=(localdb)\mssqllocaldb;Database=EFMiscellaneous.ConnectionResiliency;Trusted_Connection=True;",
            options => options.EnableRetryOnFailure());
}
```

The following code shows how to execute a transaction with automatic retries, by using an execution strategy. The transaction is defined in a delegate. If a transient failure occurs, the execution strategy will invoke the delegate again.

```csharp
using (var db = new BloggingContext())
{
    var strategy = db.Database.CreateExecutionStrategy();

    strategy.Execute(() =>
    {
        using (var transaction = db.Database.BeginTransaction())
        {
            db.Blogs.Add(new Blog { Url = "https://blogs.msdn.com/dotnet" });
            db.SaveChanges();

            db.Blogs.Add(new Blog { Url = "https://blogs.msdn.com/visualstudio" });
            db.SaveChanges();

            transaction.Commit();
        }
    });
}
```

## Azure Storage

Azure Storage services include blob storage, files, and storage queues.

### Blobs, Queues and Files

The ClientOptions Class is the base type for all client option types and exposes various common client options like Diagnostics, Retry, Transport. To provide the client configuration options for connecting to Azure Queue, Blob, and File Storage you must use the corresponding derived type. In the next example, you use the QueueClientOptions class (derived from ClientOptions) to configure a client to connect to Azure Queue Service. The Retry property is the set of options that can be specified to influence how retry attempts are made, and how a failure is eligible to be retried.

```csharp
using System;
using System.Threading;
using Azure.Core;
using Azure.Identity;
using Azure.Storage;
using Azure.Storage.Queues;
using Azure.Storage.Queues.Models;

namespace RetryCodeSamples
{
    class AzureStorageCodeSamples {

        public async static Task Samples() {

               // Provide the client configuration options for connecting to Azure Queue Storage
                QueueClientOptions queueClientOptions = new QueueClientOptions()
                {
                    Retry = {
                    Delay = TimeSpan.FromSeconds(2),     //The delay between retry attempts for a fixed approach or the delay on which to base
                                                         //calculations for a backoff-based approach
                    MaxRetries = 5,                      //The maximum number of retry attempts before giving up
                    Mode = RetryMode.Exponential,        //The approach to use for calculating retry delays
                    MaxDelay = TimeSpan.FromSeconds(10)  //The maximum permissible delay between retry attempts
                    },

                    GeoRedundantSecondaryUri = new Uri("https://...")
                    // If the GeoRedundantSecondaryUri property is set, the secondary Uri will be used for GET or HEAD requests during retries.
                    // If the status of the response from the secondary Uri is a 404, then subsequent retries for the request will not use the
                    // secondary Uri again, as this indicates that the resource may not have propagated there yet.
                    // Otherwise, subsequent retries will alternate back and forth between primary and secondary Uri.
                };

                Uri queueServiceUri = new Uri("https://storageaccount.queue.core.windows.net/");
                string accountName = "Storage account name";
                string accountKey = "storage account key";

                // Create a client object for the Queue service, including QueueClientOptions.
                QueueServiceClient serviceClient = new QueueServiceClient(queueServiceUri, new DefaultAzureCredential(), queueClientOptions);

                CancellationTokenSource source = new CancellationTokenSource();
                CancellationToken cancellationToken = source.Token;

                // Return an async collection of queues in the storage account.
                var queues = serviceClient.GetQueuesAsync(QueueTraits.None, null, cancellationToken);
```

### Table Support

> [!NOTE]
> WindowsAzure.Storage Nuget Package and Microsoft.Azure.Cosmos.Table Nuget Package have been deprecated. For Azure table support, see [Azure.Data.Tables Nuget Package](https://www.nuget.org/packages/Azure.Data.Tables/)

### Retry mechanism

The client library is based on [Azure Core library](https://azure.github.io/azure-sdk/general_azurecore.html), which is a library that provides cross-cutting services to other client libraries.

There are many reasons why failure can occur when a client application attempts to send a network request to a service. Some examples are timeout, network infrastructure failures, service rejecting the request due to throttle/busy, service instance terminating due to service scale-down, service instance going down to be replaced with another version, service crashing due to an unhandled exception, etc. By offering a built-in retry mechanism (with a default configuration the consumer can override), our SDKs and the consumer’s application become resilient to these kinds of failures. Note that some services charge real money for each try and so consumers should be able to disable retries entirely if they prefer to save money over resiliency.

### Policy configuration

Retry policies are configured programmatically. It is based on [RetryOption class](/dotnet/api/azure.core.retryoptions). There is an attribute on [TableClientOptions](/dotnet/api/azure.data.tables.tableclientoptions) inherited  from [ClientOptions](/dotnet/api/azure.core.clientoptions)

```csharp
      var tableClientOptions = new TableClientOptions();
      tableClientOptions.Retry.Mode = RetryMode.Exponential;
      tableClientOptions.Retry.MaxRetries = 5;
      var serviceClient = new TableServiceClient(connectionString, tableClientOptions);
```

The following tables show the possibilities for the built-in retry policies.

**RetryOption**

| **Setting**    | **Meaning**                                                                                                                                                                                                                                                         |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Delay          | The delay between retry attempts for a fixed approach or the delay on which to base calculations for a backoff-based approach. If the service provides a Retry-After response header, the next retry will be delayed by the duration specified by the header value. |
| MaxDelay       | The maximum permissible delay between retry attempts when the service does not provide a Retry-After response header. If the service provides a Retry-After response header, the next retry will be delayed by the duration specified by the header value.          |
| Mode           | The approach to use for calculating retry delays.                                                                                                                                                                                                                   |
| NetworkTimeout | The timeout applied to an individual network operations.                                                                                                                                                                                                            |

### [RetryMode](/dotnet/api/azure.core.retrymode)

| **Setting** | **Meaning**                                                                                                                         |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Exponential | Retry attempts will delay based on a backoff strategy, where each attempt will increase the duration that it waits before retrying. |
| MaxDelay    | Retry attempts happen at fixed intervals; each delay is a consistent duration.                                                      |

### Telemetry

The simplest way to see the logs is to enable the console logging. To create an Azure SDK log listener that outputs messages to console use AzureEventSourceListener.CreateConsoleLogger method.

```csharp
      // Setup a listener to monitor logged events.
      using AzureEventSourceListener listener = AzureEventSourceListener.CreateConsoleLogger();
```

### Examples

Executing the following code example with the storage emmulator off will allows us to see information about retry in the console.

```csharp
using Azure.Core;
using Azure.Core.Diagnostics;
using Azure.Data.Tables;
using Azure.Data.Tables.Models;

namespace RetryCodeSamples
{
    class AzureStorageCodeSamples
    {
        private const string connectionString = "UseDevelopmentStorage=true";
        private const string tableName = "RetryTestTable";

        public async static Task SamplesAsync()
        {
            // Setup a listener to monitor logged events.
            using AzureEventSourceListener listener = AzureEventSourceListener.CreateConsoleLogger();

            var tableClientOptions = new TableClientOptions();
            tableClientOptions.Retry.Mode = RetryMode.Exponential;
            tableClientOptions.Retry.MaxRetries = 5;

            var serviceClient = new TableServiceClient(connectionString, tableClientOptions);

            TableItem table = await serviceClient.CreateTableIfNotExistsAsync(tableName);
            Console.WriteLine($"The created table's name is {table.Name}.");
        }
    }
}
```

## General REST and retry guidelines

Consider the following when accessing Azure or third-party services:

- Use a systematic approach to managing retries, perhaps as reusable code, so that you can apply a consistent methodology across all clients and all solutions.

- Consider using a retry framework such as [Polly](http://thepollyproject.org) to manage retries if the target service or client has no built-in retry mechanism. This will help you implement a consistent retry behavior, and it may provide a suitable default retry strategy for the target service. However, you may need to create custom retry code for services that have nonstandard behavior that do not rely on exceptions to indicate transient failures or if you want to use a **Retry-Response** reply to manage retry behavior.

- The transient detection logic will depend on the actual client API you use to invoke the REST calls. Some clients, such as the newer **HttpClient** class, won't throw exceptions for completed requests with a non-success HTTP status code.

- The HTTP status code returned from the service can help to indicate whether the failure is transient. You may need to examine the exceptions generated by a client or the retry framework to access the status code or to determine the equivalent exception type. The following HTTP codes typically indicate that a retry is appropriate:

  - 408 Request Timeout
  - 429 Too Many Requests
  - 500 Internal Server Error
  - 502 Bad Gateway
  - 503 Service Unavailable
  - 504 Gateway Timeout

- If you base your retry logic on exceptions, the following typically indicate a transient failure where no connection could be established:

  - WebExceptionStatus.ConnectionClosed
  - WebExceptionStatus.ConnectFailure
  - WebExceptionStatus.Timeout
  - WebExceptionStatus.RequestCanceled

- In the case of a service unavailable status, the service might indicate the appropriate delay before retrying in the **Retry-After** response header or a different custom header. Services might also send additional information as custom headers, or embedded in the content of the response.

- Don't retry for status codes representing client errors (errors in the 4xx range) except for a 408 Request Timeout and 429 Too Many Requests.

- Thoroughly test your retry strategies and mechanisms under a range of conditions, such as different network states and varying system loadings.

### Retry strategies

The following are the typical types of retry strategy intervals:

- **Exponential**. A retry policy that performs a specified number of retries, using a randomized exponential back off approach to determine the interval between retries. For example:

    ```csharp
    var random = new Random();

    var delta = (int)((Math.Pow(2.0, currentRetryCount) - 1.0) *
                random.Next((int)(this.deltaBackoff.TotalMilliseconds * 0.8),
                (int)(this.deltaBackoff.TotalMilliseconds * 1.2)));
    var interval = (int)Math.Min(checked(this.minBackoff.TotalMilliseconds + delta),
                    this.maxBackoff.TotalMilliseconds);
    retryInterval = TimeSpan.FromMilliseconds(interval);
    ```

- **Incremental**. A retry strategy with a specified number of retry attempts and an incremental time interval between retries. For example:

    ```csharp
    retryInterval = TimeSpan.FromMilliseconds(this.initialInterval.TotalMilliseconds +
                    (this.increment.TotalMilliseconds * currentRetryCount));
    ```

- **LinearRetry**. A retry policy that performs a specified number of retries, using a specified fixed time interval between retries. For example:

    ```csharp
    retryInterval = this.deltaBackoff;
    ```

### Transient fault handling with Polly

[Polly](http://thepollyproject.org) is a library to programmatically handle retries and [circuit breaker](../patterns/circuit-breaker.yml) strategies. The Polly project is a member of the [.NET Foundation][dotnet-foundation]. For services where the client doesn't natively support retries, Polly is a valid alternative and avoids the need to write custom retry code, which can be hard to implement correctly. Polly also provides a way to trace errors when they occur, so that you can log retries.

### Next steps

- [connection resiliency](/ef/core/miscellaneous/connection-resiliency)
- [Data Points - EF Core 1.1](/archive/msdn-magazine/2017/january/data-points-ef-core-1-1-a-few-of-my-favorite-things)

<!-- links -->

[msal]: /azure/active-directory/develop/msal-overview
[autorest]: https://github.com/Azure/autorest/tree/master/docs
[dotnet-foundation]: https://dotnetfoundation.org
[redis-cache-troubleshoot]: /azure/redis-cache/cache-how-to-troubleshoot
[SearchIndexClient]: /dotnet/api/microsoft.azure.search.searchindexclient?view=azure-dotnet&preserve-view=true
[SearchServiceClient]: /dotnet/api/microsoft.azure.search.searchserviceclient?view=azure-dotnet&preserve-view=true

---
title: Failure mode analysis
description: Get information about doing a failure mode analysis (FMA) for cloud solutions that are based on Azure.
author: claytonsiemens77
ms.author: pnp
ms.date: 07/25/2023
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Failure mode analysis for Azure applications

Failure mode analysis (FMA) is a process for building reliability into a system by identifying possible failure points. The FMA should be part of the architecture and design phases, so that you can build both resiliency (the ability to withstand failures) and recoverability (the ability to restore functionality after failures) into the system from the beginning.

Here is the general process to conduct an FMA:

1. Identify all of the components in the system. Include external dependencies, such as identity providers and third-party services.
1. For each component, identify potential failures that could occur. A single component might have more than one failure mode. For example, you should consider read failures and write failures separately, because the impact and possible mitigation steps will be different.
1. Rate each failure mode according to its overall risk. Consider these factors:

   - What is the likelihood of the failure? Is it relatively common? Extremely rare? You don't need exact numbers; the purpose is to help rank the priority.
   - What is the impact on the application, in terms of availability, data loss, monetary cost, and business disruption?

1. For each failure mode, determine how the application will respond and recover. Consider tradeoffs in cost and application complexity.

As a starting point for your FMA process, this article contains a catalog of potential failure modes and their mitigation steps. The catalog is organized by technology or Azure service, plus a general category for application-level design. The catalog isn't exhaustive, but covers many of the core Azure services.

> [!NOTE]
> Failures should be distinguished from errors. A failure is an unexpected event within a system that prevents it from continuing to function normally. For example, a hardware malfunction that causes a network partition is a failure. Usually, failures require intervention or specific design for that class of failures. In contrast, errors are an expected part of normal operations, are dealt with immediately and the system will continue to operate at the same capacity following an error. For example, errors discovered during input validation can be handled through business logic.

<a name='azure-active-directory'></a>

## Microsoft Entra ID

### OpenID Connect authentication fails.

**Detection**. Possible failure modes include:

1. Microsoft Entra ID isn't available, or can't be reached due to a network problem. Redirection to the authentication endpoint fails, and the OpenID Connect middleware throws an exception.
1. Microsoft Entra tenant does not exist. Redirection to the authentication endpoint returns an HTTP error code, and the OpenID Connect middleware throws an exception.
1. User can't authenticate. No detection strategy is necessary; Microsoft Entra ID handles login failures.

**Recovery:**

1. Catch unhandled exceptions from the middleware.
1. Handle `AuthenticationFailed` events.
1. Redirect the user to an error page.
1. User retries.

## Cassandra

### Reading or writing to a node fails.

**Detection**. Catch the exception. For .NET clients, this will typically be `System.Web.HttpException`. Other client might have other exception types.  For more information, see [Cassandra error handling done right](https://www.datastax.com/dev/blog/cassandra-error-handling-done-right).

**Recovery:**

- Each [Cassandra client](https://cwiki.apache.org/confluence/display/CASSANDRA2/ClientOptions) has its own retry policies and capabilities. For more information, see [Cassandra error handling done right][cassandra-error-handling].
- Use a rack-aware deployment, with data nodes distributed across the fault domains.
- Deploy to multiple regions with local quorum consistency. If a nontransient failure occurs, fail over to another region.

**Diagnostics**. Application logs

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
- Enable duplicate detection, by creating the queue with `RequiresDuplicateDetection` set to true. With this setting, Service Bus automatically deletes any message that is sent with the same `MessageId` as a previous message. Note the following points:

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

## Next steps

See [Identify dependencies](/azure/well-architected/reliability/failure-mode-analysis#identify-dependencies) in the Azure Well-Architected Framework. Building failure recovery into the system should be part of the architecture and design phases from the beginning to avoid the risk of failure.

<!-- links -->

[BrokeredMessage.TimeToLive]: /dotnet/api/microsoft.servicebus.messaging.brokeredmessage
[cassandra-error-handling]: https://www.datastax.com/dev/blog/cassandra-error-handling-done-right
[QuotaExceededException]: /dotnet/api/microsoft.servicebus.messaging.quotaexceededexception
[sb-dead-letter-queue]: /azure/service-bus-messaging/service-bus-dead-letter-queues/
[sb-georeplication-sample]: https://github.com/Azure/azure-service-bus/tree/master/samples/DotNet/Microsoft.Azure.ServiceBus/GeoReplication
[sb-messagingexception-class]: /dotnet/api/microsoft.servicebus.messaging.messagingexception
[sb-messaging-exceptions]: /azure/service-bus-messaging/service-bus-messaging-exceptions
[sb-partition]: /azure/service-bus-messaging/service-bus-partitioning
[sb-poison-message]: /azure/app-service/webjobs-sdk-how-to#automatic-triggers
[storage-metrics]: /azure/storage/common/monitor-storage

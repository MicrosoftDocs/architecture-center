---
title: Resilient Design Guidance for Event Hubs and Functions
description: Learn how to develop resilient and scalable code that runs on Azure Functions and responds to Azure Event Hubs events.
author: dbarkol
ms.author: dabarkol
ms.topic: concept-article
ms.date: 04/22/2026
ms.subservice: architecture-guide
---

# Resilient Azure Event Hubs and Azure Functions design

Error handling, designing for idempotency, and managing retry behavior are a few of the critical measures that you can take to ensure that functions triggered by Azure Event Hubs are resilient and capable of handling large volumes of data. This article covers these crucial concepts and makes recommendations for serverless event-streaming solutions.

Azure provides three main messaging services that you can use with Azure Functions to support a wide range of unique, event-driven scenarios. Because of its partitioned consumer model and ability to ingest data at a high rate, Event Hubs is commonly used for event streaming and big data scenarios. For a detailed comparison of Azure messaging services, see [Choose between Event Grid, Event Hubs, and Azure Service Bus](/azure/service-bus-messaging/compare-messaging-services).

## Streaming benefits and challenges

Understanding the benefits and drawbacks of streams helps you appreciate how a service like [Event Hubs](/azure/event-hubs/event-hubs-about) operates. You also need this context when you make significant architectural decisions, troubleshoot problems, and optimize for performance. Consider the following key concepts about solutions that use both Event Hubs and Functions:

- **Streams aren't queues:** Event Hubs, Kafka, and other similar offerings that are built on the partitioned consumer model don't intrinsically support some of the principal features in a message broker like [Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview). Perhaps the biggest indicator of these differences is the fact that reads are **nondestructive**. This behavior ensures that the data read by the Functions host remains available afterwards. Messages are immutable and remain for other consumers to read, including potentially the same consumer reading it again. For this reason, solutions that implement patterns such as [Competing Consumers](../../patterns/competing-consumers.md) might be better served with a message broker such as Service Bus.

- **Missing inherent dead-letter support:** A dead-letter channel isn't a native feature in Event Hubs or Kafka. Often, the *concept* of dead-lettering is integrated into a streaming solution to account for data that can't be processed. This functionality is intentionally not an innate element in Event Hubs and is only added on the consumer side to manufacture a similar behavior or effect. If you need dead-letter support, you might want to review your choice of a streaming message service.

- **A unit of work is a partition:** In a traditional message broker, a unit of work is a single message. In a streaming solution, a partition is often considered the unit of work. If each event in an event hub is treated as a distinct message that requires order processing or financial transaction handling, you might want to explore a more suitable messaging service for optimal performance or processing.

- **No server-side filtering:** One of the reasons Event Hubs is capable of tremendous scale and throughput is the low overhead on the service itself. Features like server-side filtering, indexes, and cross-broker coordination aren't part of the architecture of Event Hubs. Functions are occasionally used to filter events by routing them to other event hubs based on the contents in the body or header. This approach is common in event streaming but comes with the caveat that the initial function reads and evaluates each event.

- **Every reader must read all data:** Because server-side filtering is unavailable, a consumer sequentially reads all the data in a partition. It reads data that might not be relevant or that could be malformed. You can use several [strategies](#strategies-for-failures-and-corrupt-data) to compensate for these challenges.

These design decisions allow Event Hubs to support a significant influx of events and provide a resilient service for consumers to read from. Each consumer application is responsible for maintaining its own client-side offsets or cursor to those events. The low overhead makes Event Hubs a cost-effective option for event streaming.

## Idempotency

One of the core tenets of Event Hubs is the concept of at-least-once delivery. This approach ensures that events are always delivered. It also means that events can be received more than once, even repeatedly, by consumers like a function. For this reason, a function triggered by an event hub needs to support the [Idempotent Consumer](https://microservices.io/patterns/communication-style/idempotent-consumer.html) pattern.

Working under the assumption of at-least-once delivery, especially within the context of an event-driven architecture, is a responsible approach for reliably processing events. Your function must be idempotent so that the outcome of processing the same event multiple times is the same as processing it once.

### Duplicate events

Several scenarios can result in duplicate events being delivered to a function:

- **Checkpointing:** If the Azure Functions host crashes or the threshold set for the [batch checkpoint frequency](/azure/azure-functions/functions-bindings-event-hubs#hostjson-settings) isn't met, a checkpoint isn't created. As a result, the offset for the consumer isn't advanced, and the next time the function is invoked, it resumes from the last checkpoint. Checkpointing occurs at the partition level for each consumer.

- **Duplicate events published:** Many techniques can reduce the chances of the same event being published to a stream, but the consumer still needs to handle duplicates idempotently.

- **Missing acknowledgments:** In some situations, an outgoing request to a service succeeds, but an acknowledgment (ACK) from the service is never received. This scenario might result in the belief that the outgoing call failed and initiate a series of retries or other outcomes from the function. In the end, duplicate events could be published, or a checkpoint might not be created.

### Deduplication techniques

Design your functions to handle [identical input](/azure/azure-functions/functions-idempotent) by default when you use the Event Hubs trigger binding. Consider the following techniques:

- **Look for duplicates:** Before processing, take the necessary steps to validate that the event should be processed. In some cases, you need to investigate to confirm that the event is still valid. It's also possible that handling the event is no longer necessary because of data freshness or logic that invalidates the event.

- **Design events for idempotency:** You can ensure that processing an event multiple times doesn't have any detrimental effects by including additional information in the event's payload. Consider the example of an event that includes an amount to withdraw from a bank account. If the withdrawal isn't handled responsibly, the balance of the account could be decremented multiple times. However, if the event includes the updated balance to the account, the balance can be used to perform an upsert operation to the bank account balance. This event-carried state transfer approach occasionally requires coordination between producers and consumers. Use it when it makes sense for participating services.

## Error handling and retries

Error handling and retries are two of the most important qualities of distributed, event-driven applications, and functions are no exception. For event-streaming solutions, proper error-handling support is crucial because thousands of events can quickly turn into an equal number of errors if they're not handled correctly.

### Error-handling guidance

Without error handling, it can be difficult to implement retries, detect runtime exceptions, and investigate problems. Every function should have at least some level of error handling. Follow these recommended guidelines:

- **Use Application Insights:** Enable and use Application Insights to log errors and monitor the health of your functions. Be aware of the configurable sampling options for scenarios that process a high volume of events.

- **Add structured error handling:** Use the appropriate error-handling constructs for each programming language to catch, log, and detect anticipated and unhandled exceptions in your function code. For example, use a try-catch block in C\#, Java, and JavaScript, and [try and except](https://docs.python.org/3/tutorial/errors.html#handling-exceptions) blocks in Python to handle exceptions.

- **Implement logging:** Catching an exception during execution provides an opportunity to log critical information that you can use to detect, reproduce, and fix issues reliably. Log the exception, not just the message, but also the body, inner exception, and other artifacts that are helpful later.

- **Don't catch and ignore exceptions:** One of the worst things you can do is catch an exception and do nothing with it. If you catch a generic exception, log it somewhere. If you don't log errors, it's difficult to investigate bugs and reported problems.

### Retries

Implementing retry logic in an event-streaming architecture can be complex. Supporting cancellation tokens, retry counts, and exponential backoff strategies are a few of the considerations that make it a challenge. Fortunately, Functions provides [retry policies](/azure/azure-functions/functions-bindings-error-pages#retry-policies) for many of these tasks that you typically code yourself. For general guidance on retry strategies, see [Recommendations for handling transient faults](/azure/well-architected/design-guides/handle-transient-faults).

Consider the following factors when you use the retry policies with the Event Hubs binding:

- **Avoid indefinite retries:** When you set the [max retry count](/azure/azure-functions/functions-host-json) setting to -1, the function retries indefinitely. In general, use indefinite retries sparingly with Functions and almost never with the Event Hubs trigger binding.

- **Choose the appropriate retry strategy:** A [fixed delay](/azure/azure-functions/functions-bindings-error-pages#retry-strategies&tabs=fixed-delay) strategy might be optimal for scenarios that receive back pressure from other Azure services. In these cases, the delay can help avoid throttling and other limitations encountered from those services. The [exponential backoff](/azure/azure-functions/functions-bindings-error-pages#retry-strategies&tabs=exponential-backoff) strategy offers more flexibility for retry delay intervals and is commonly used in integrations with non-Microsoft services, REST endpoints, and other Azure services.

- **Keep intervals and retry counts low:** When possible, maintain a retry interval that's shorter than one minute. Also, keep the maximum number of retry attempts to a reasonably low number. These settings are especially pertinent when you use the Functions Consumption plan.

- **Use the Circuit Breaker pattern:** A transient fault error is expected from time to time and is a natural use case for retries. However, if a significant number of failures or problems occur during the processing of the function, it might make sense to stop the function, address the problems, and restart later.

An important point about the retry policies feature in Functions is that it's a best-effort feature for reprocessing events. It doesn't substitute the need for error handling, logging, and other important patterns that provide resiliency to your code.

## Strategies for failures and corrupt data

Several noteworthy approaches can help you compensate for problems that occur because of failures or bad data in an eventstream. Consider the following fundamental strategies:

- **Stop sending and reading events:** To fix the underlying problem, pause the reading and writing of events. The benefit of this approach is that data isn't lost, and operations can resume after a fix is rolled out. This approach might require a circuit-breaker component in the architecture and possibly a notification to the affected services to achieve a pause. In some cases, stopping a function might be necessary until the problems are resolved.

- **Drop messages:** If messages aren't important or mission critical, consider discarding them instead of processing them. This approach doesn't work for scenarios that require strong consistency, such as recording moves in a chess match or finance-based transactions. We recommend that you implement error handling inside of a function for catching and dropping messages that can't be processed.

- **Retry events:** Many situations might warrant the reprocessing of an event. The most common scenario is a transient error that's encountered when another service or dependency is called. Network errors, service limits and availability, and strong consistency are perhaps the most frequent use cases that justify reprocessing attempts.

- **Use a dead letter stream:** The goal here is to publish the event to a different event hub so that the existing flow isn't interrupted. The event moves off the hot path and can be handled later or by a different process. This solution is used frequently for handling poisoned messages or events. Each function that's configured with a different consumer group will still encounter bad or corrupt data in its stream and must handle it responsibly.

- **Use retry and dead letter:** This method combines numerous retry attempts with ultimately publishing to a dead letter stream after a threshold is met.

- **Use a schema registry:** You can use a schema registry as a proactive tool to help improve consistency and data quality. [Azure Schema Registry](/azure/event-hubs/schema-registry-overview) supports the transition of schemas together with versioning and different compatibility modes as schemas evolve. At its core, the schema serves as a contract between producers and consumers. It can reduce the possibility of invalid or corrupt data being published to the stream.

There's no perfect solution. You need to thoroughly examine the consequences and trade-offs of each strategy. Depending on your requirements, the best approach might be to use several of these techniques together.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [David Barkol](https://www.linkedin.com/in/davidbarkol/) | AI Apps GBB

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Before you continue, consider reviewing these related articles:

- [Azure Functions reliable event processing](/azure/azure-functions/functions-reliable-event-processing)
- [Designing Azure Functions for identical input](/azure/azure-functions/functions-idempotent)
- [Azure Functions error handling and retry guidance](/azure/azure-functions/functions-bindings-error-pages)

> [!div class="nextstepaction"]
> [Security](./security.md)

---
title: Resilient design guidance for Event Hubs and Functions
description: Learn how to develop resilient and scalable code that runs on Azure Functions and responds to Event Hubs events.
author: dbarkol
ms.author: dabarkol
ms.topic: conceptual
ms.date: 10/04/2021
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
  - compute
categories:
  - compute
products:
  - azure-event-hubs
  - azure-functions
ms.custom:
  - guide
---

# Resilient Event Hubs and Functions design

Error handling, designing for idempotency and managing retry behavior are a few of the critical measures you can take to ensure Event Hubs triggered functions are resilient and capable of handling large volumes of data. This article covers these crucial concepts and makes recommendations for serverless event-streaming solutions.

Azure provides three main messaging services that can be used with Azure Functions to support a wide range of unique, event-driven scenarios. Because of its partitioned consumer model and ability to ingest data at a high rate, Azure Event Hubs is commonly used for event streaming and big data scenarios. For a detailed comparison of Azure messaging services, see [Choose between Azure messaging services - Event Grid, Event Hubs, and Service Bus](/azure/event-grid/compare-messaging-services).

## Streaming benefits and challenges

Understanding the benefits and drawbacks of streams helps you appreciate how a service like [Event Hubs](/azure/event-hubs/event-hubs-about) operates. You also need this context when making impactful architectural decisions, troubleshooting issues, and optimizing for performance. Consider the following key concepts about solutions featuring both Event Hubs and Functions:

- **Streams are not queues:** Event Hubs, Kafka, and other similar offerings that are built on the partitioned consumer model don't intrinsically support some of the principal features in a message broker like [Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview). Perhaps the biggest indicator of this is the fact that reads are **non-destructive**. This means that the data that is read by the Functions host isn't deleted afterwards. Instead, messages are immutable and remain for other consumers to read, including potentially the same customer reading it again. For this reason, solutions that implement patterns such as [competing consumers](/azure/architecture/patterns/competing-consumers) are better suited for a traditional message broker.

- **Missing inherent dead-letter support:** A dead-letter channel is not a native feature in Event Hubs or Kafka. Often, the *concept* of dead-lettering is integrated into a streaming solution to account for data that cannot be processed. This functionality is intentionally not an innate element in Event Hubs and is only added on the consumer side to manufacture a similar behavior or effect. If you need dead-letter support, you should potentially review your choice of streaming message service.

- **A unit of work is a partition:** In a traditional message broker, a unit of work is a single message. In a streaming solution, a partition is often considered the unit of work. If each event in an event hub is regarded as a discrete message that requires it to be treated like an order processing operation or financial transaction, it's most likely an indication of the wrong messaging service being used.

- **No server-side filtering:** One of the reasons Event Hubs is capable of tremendous scale and throughput is due to the low overhead on the service itself. Features like server-side filtering, indexes, and cross-broker coordination aren't part of the architecture of Event Hubs. Functions are occasionally used to filter events by routing them to other Event Hubs based on the contents in the body or header. This approach is common in event streaming but comes with the caveat that each event is read and evaluated by the initial function.

- **Every reader must read all data:** Since server-side filtering is unavailable, a consumer sequentially reads all the data in a partition. This includes data that may not be relevant or could even be malformed. There are several options and even strategies that can be used to compensate for these challenges that will be covered later in this section.

These significant design decisions allow Event Hubs to do what it does best: support a significant influx of events and provide a robust and resilient service for consumers to read from. Each consumer application is tasked with the responsibility of maintaining their own, client-side offsets or cursor to those events. The low overhead makes Event Hubs an affordable and powerful option for event streaming.

## Idempotency

One of the core tenets of Azure Event Hubs is the concept of at-least once delivery. This approach ensures that events will always be delivered. It also means that events can be received more than once, even repeatedly, by consumers such as a function. For this reason, it's important that an event hub triggered function supports the [idempotent consumer](https://microservices.io/patterns/communication-style/idempotent-consumer.html) pattern.

Working under the assumption of at-least once delivery, especially within the context of an event-driven architecture, is a responsible approach for reliably processing events. Your function must be idempotent so that the outcome of processing the same event multiple times is the same as processing it once.

### Duplicate events

There are several different scenarios that could result in duplicate events being delivered to a function:

- **Checkpointing:** If the Azure Functions host crashes, or the threshold set for the [batch checkpoint frequency](/azure/azure-functions/functions-bindings-event-hubs#hostjson-settings) is not met, a checkpoint will not be created. As a result, the offset for the consumer is not advanced and the next time the function is invoked, it will resume from the last checkpoint. It is important to note that checkpointing occurs at the partition level for each consumer.

- **Duplicate events published:** There are many techniques that could alleviate the possibility of the same event being published to a stream, however, it's still the responsibility of the consumer to idempotently handle duplicates.

- **Missing acknowledgments:** In some situations, an outgoing request to a service may be successful, however, an acknowledgment (ACK) from the service is never received. This might result in the perception that the outgoing call failed and initiate a series or retries or other outcomes from the function. In the end, duplicate events could be published, or a checkpoint is not created.

### Deduplication techniques

Designing your functions for [identical input](/azure/azure-functions/functions-idempotent) should be the default approach taken when paired with the Event Hub trigger binding. You should consider the following techniques:

- **Looking for duplicates:** Before processing, take the necessary steps to validate that the event should be processed. In some cases, this will require an investigation to confirm that it is still valid. It could also be possible that handling the event is no longer necessary due to data freshness or logic that invalidates the event.

- **Design events for idempotency:** By providing additional information within the payload of the event, it may be possible to ensure that processing it multiple times will not have any detrimental effects. Take the example of an event that includes an amount to withdrawal from a bank account. If not handled responsibly, it is possible that it could decrement the balance of an account multiple times. However, if the same event includes the updated balance to the account, it could be used to perform an upsert operation to the bank account balance. This event-carried state transfer approach occasionally requires coordination between producers and consumers and should be used when it makes sense to participating services.

## Error handling and retries

Error handling and retries are a few of the most important qualities of distributed, event-driven applications, and Functions are no exception. For event streaming solutions, the need for proper error handling support is crucial, as thousands of events can quickly turn into an equal number of errors if they are not handled correctly.

### Error handling guidance

Without error handling, it can be tricky to implement retries, detect runtime exceptions, and investigate issues. Every function should have at least some level or error handling. A few recommended guidelines are:

- **Use Application Insights:** Enable and use Application Insights to log errors and monitor the health of your functions. Be mindful of the configurable sampling options for scenarios that process a high volume of events.

- **Add structured error handling:** Apply the appropriate error handling constructs for each programming language to catch, log, and detect anticipated and unhandled exceptions in your function code. For instance, use a try/catch block in C\#, Java and JavaScript and take advantage of the [try and except](https://docs.python.org/3/tutorial/errors.html#handling-exceptions) blocks in Python to handle exceptions.

- **Logging:** Catching an exception during execution provides an opportunity to log critical information that could be used to detect, reproduce, and fix issues reliably. Log the exception, not just the message, but the body, inner exception and other useful artifacts that will be helpful later.

- **Do not catch and ignore exceptions:** One of the worst things you can do is catch an exception and do nothing with it. If you catch a generic exception, log it somewhere. If you don't log errors, it's difficult to investigate bugs and reported issues.

### Retries

Implementing retry logic in an event streaming architecture can be complex. Supporting cancellation tokens, retry counts and exponential back off strategies are just a few of the considerations that make it challenging. Fortunately, Functions provides [retry policies](/azure/azure-functions/functions-bindings-error-pages#retry-policies-preview) that can make up for many of these tasks that you would typically code yourself.

Several important factors that must be considered when using the retry policies with the Event Hub binding, include:

- **Avoid indefinite retries:** When the [max retry count](/azure/azure-functions/functions-host-json#retry) setting is set to a value of -1, the function will retry indefinitely. In general, indefinite retries should be used sparingly with Functions and almost never with the Event Hub trigger binding.

- **Choose the appropriate retry strategy:** A [fixed delay](/azure/azure-functions/functions-bindings-error-pages#fixed-delay-retry) strategy may be optimal for scenarios that receive back pressure from other Azure services. In these cases, the delay can help avoid throttling and other limitations encountered from those services. The [exponential back off](/azure/azure-functions/functions-bindings-error-pages#exponential-backoff-retry) strategy offers more flexibility for retry delay intervals and is commonly used when integrating with third-party services, REST endpoints, and other Azure services.

- **Keep intervals and retry counts low:** When possible, try to maintain a retry interval shorter than one minute. Also, keep the maximum number of retry attempts to a reasonably low number. These settings are especially pertinent when running in the Functions Consumption plan.

- **Circuit breaker pattern:** A transient fault error from time to time is expected and a natural use case for retries. However, if a significant number of failures or issues are occurring during the processing of the function, it may make sense to stop the function, address the issues and restart later.

An important takeaway for the retry policies in Functions is that it is a best effort feature for reprocessing events. It does not substitute the need for error handling, logging, and other important patterns that provide resiliency to your code.

## Strategies for failures and corrupt data

There are several noteworthy approaches that you can use to compensate for issues that arise due to failures or bad data in an event stream. Some fundamental strategies are:

- **Stop sending and reading:** Pause the reading and writing of events to fix the underlying issue. The benefit of this approach is that data won't be lost, and operations can resume after a fix is rolled out. This approach may require a circuit-breaker component in the architecture and possibly a notification to the affected services to achieve a pause. In some cases, stopping a function may be necessary until the issues are resolved.

- **Drop messages:** If messages aren't important or are considered non-mission critical, consider moving on and not processing them. This doesn't work for scenarios that require strong consistency such as recording moves in a chess match or finance-based transactions. Error handling inside of a function is recommended for catching and dropping messages that can't be processed.

- **Retry:** There are many situations that may warrant the reprocessing of an event. The most common scenario would be a transient error encountered when calling another service or dependency. Network errors, service limits and availability, and strong consistency are perhaps the most frequent use cases that justify reprocessing attempts.

- **Dead letter:** The idea here is to publish the event to a different event hub so that the existing flow is not interrupted. The perception is that it has been moved off the hot path and could be dealt with later or by a different process. This solution is used frequently for handling poisoned messages or events. It should be noted that each  function, that is configured with a different consumer group, will still encounter the bad or corrupt data in their stream and must handle it responsibly.

- **Retry and dead letter:** The combination of numerous retry attempts before ultimately publishing to a dead letter stream once a threshold is met, is another familiar method.

- **Use a schema registry:** A schema registry can be used as a proactive tool to help improve consistency and data quality. The [Azure Schema Registry](/azure/event-hubs/schema-registry-overview) can support the transition of schemas along with versioning and different compatibility modes as schemas evolve. At its core, the schema will serve as a contract between producers and consumers, which could reduce the possibility of invalid or corrupt data being published to the stream.

In the end, there isn't a perfect solution and the consequences and tradeoffs of each of the strategies needs to be thoroughly examined. Based on the requirements, using several of these techniques together may be the best approach.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [David Barkol](https://www.linkedin.com/in/davidbarkol/) | Principal Solution Specialist GBB
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Before continuing, consider reviewing these related articles:

- [Azure Functions reliable event processing](/azure/azure-functions/functions-reliable-event-processing)
- [Designing Azure Functions for identical input](/azure/azure-functions/functions-idempotent)
- [Azure Functions error handling and retry guidance](/azure/azure-functions/functions-bindings-error-pages)

> [!div class="nextstepaction"]
> [Security](./security.md)

## Related resources

- [Monitoring serverless event processing](../guide/monitoring-serverless-event-processing.md) provides guidance on monitoring serverless event-driven architectures.
- [Serverless event processing](../../reference-architectures/serverless/event-processing.yml) is a reference architecture detailing a typical architecture of this type, with code samples and discussion of important considerations.
- [De-batching and filtering in serverless event processing with Event Hubs](../../solution-ideas/articles/serverless-event-processing-filtering.yml) describes in more detail how these portions of the reference architecture work.

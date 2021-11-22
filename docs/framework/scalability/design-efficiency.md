---
title: Design Azure applications for efficiency
description: Review design options for application efficiency in Azure, such as asynchronous programming, queued and batched requests, data compression, and session affinity.
author: v-aangie
ms.date: 12/01/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - How are you designing your applications for performance efficiency?
  - article
---

# Design Azure applications for efficiency

Making choices that effect performance efficiency is critical to application design. For additional related topics, see the [Design scalable Azure applications](./design-apps.md) article in the Performance efficiency pillar.

## Reduce response time with asynchronous programming

The time for the caller to receive a response could range from milliseconds to minutes. During that time, the thread is held by the process until the response comes back, or if an exception happens. This is inefficient because it means that no other requests can be processed during the time waiting for a response. An example when multiple requests in flight is inefficient is a bank account. In this situation, only one resource can operate on the request at the same time. Another example is when connection pools can't be shared, and then all of the requests need separate connections to complete.

Asynchronous programming is an alternative approach. It enables a remote service to be executed without waiting and blocking resources on the client. This is a critical pattern for enabling cloud scalable software and is available in most modern programming languages and platforms.

There are many ways to inject asynchronous programming into an application design. For APIs and services that work across the internet, consider using the [Asynchronous Request-Reply pattern](../../patterns/async-request-reply.md). When writing code, remote calls can be asynchronously executed using built-in language constructs like `async`/`await` in .NET C#. Review a [language construct example](/dotnet/csharp/async). .NET has other built-in platform support for asynchronous programming with [task](/dotnet/standard/asynchronous-programming-patterns/task-based-asynchronous-pattern-tap) and [event](/dotnet/standard/asynchronous-programming-patterns/event-based-asynchronous-pattern-eap) based asynchronous patterns.

## Process faster by queuing and batching requests

Similar to asynchronous programming, queuing services has long been used as a scalable mechanism to hand off processing work to a service. Highly scalable queuing services are natively supported in Azure. The queue is a storage buffer located between the caller and the processing service. It takes requests, stores them in a buffer, and queues the requests to provide services around the reliable delivery and management of the queued data.

Using a queue is often the best way to hand off work to a processor service. The processor service receives work by listening on a queue and dequeuing messages. If items to be processed enter too quickly, the queuing service will keep them in the queue until the processing service has available resources and asks for a new work item (message). By leveraging the dynamic nature of [Azure Functions](/azure/azure-functions/functions-overview), the processor service can easily autoscale on demand as the queue builds up to meet the intake pressure. Developing processor logic with Azure Functions to run task logic from a queue is a common, scalable, and cost effective way to using queuing between a client and a processor.

Azure provides some native first-party queueing services with Azure Storage Queues (simple queuing service based on Azure Storage) and Azure Service Bus (message broker service supporting transactions and reduced latency). Many other third-party options are also available through [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace).

To learn more about queue-based Load Leveling, see [Queue-based Load Leveling pattern](../../patterns/queue-based-load-leveling.md). To compare and contrast queues, see [Storage queues and Service Bus queues - compared and contrasted](/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted).

## Optimize with data compression

A well-known optimization best practice for scaling is to use a compression strategy to compress and bundle web pages or API responses. The idea is to shrink the data returned from a page or API back to the browser or client app. Compressing the data returned to clients optimizes network traffic and accelerates the application. [Azure Front Door](/azure/frontdoor/front-door-caching#file-compression) can perform file compression, and .NET has built-in framework support for this technique with GZip compression. For more information, see [Response compression in ASP.NET Core](/aspnet/core/performance/response-compression?preserve-view=true&view=aspnetcore-3.1).

## Improve scalability with session affinity

If an application is stateful, meaning that data or state will be stored locally in the instance of the application, it may increase the performance of your application, if you enable session affinity. When session affinity is enabled, subsequent requests to the application will be directed to the same server that processed the first request. If session affinity is not enabled, subsequent requests would be directed to the next available server depending on the load balancing rules. Session affinity allows the instance to have some persistent or cached data/context, which can speed subsequent requests. However, if your application does not store large amounts of state or cached data in memory, session affinity might decrease your throughput because one host could get overloaded with requests, while others are dormant.

> [!TIP]
> [Migrate an Azure Cloud Services application to Azure Service Fabric](../../service-fabric/migrate-from-cloud-services.md) describes **best practices** about stateless services for an application that is migrated from old Azure Cloud Services to Azure Service Fabric.

## Run background jobs to meet integration needs

Many types of applications require background tasks that run independently of the user interface (UI). Examples include batch jobs, intensive processing tasks, and long-running processes such as workflows. Background jobs can be executed without requiring user interaction. The application can start the job and then continue to process interactive requests from users. To learn more, see [Background jobs](../../best-practices/background-jobs.md).

Background tasks must offer sufficient performance to ensure they do not block the application, or cause inconsistencies due to delayed operation when the system is under load. Typically, performance is improved by scaling the compute instances that host the background tasks. For a list of considerations, see [Scaling and performance considerations](../../best-practices/background-jobs.md#scaling-and-performance-considerations).

[Logic Apps](/azure/logic-apps/logic-apps-overview) is a serverless consumption (pay-per-use) service that enables a vast set of out-of-the-box ready-to-use connectors and a long-running workflow engine to enable cloud-native integration needs quickly. Logic Apps is flexible enough for scenarios like running tasks/jobs, advanced scheduling, and triggering. Logic Apps also has advanced hosting options to allow it to run within enterprise restricted cloud environments. Logic Apps can be combined with all other Azure services to complement one another, or it can be used independently.

Like all serverless services, Logic Apps doesn't require VM instances to be purchased, enabled, and scaled up and down. Instead, Logic Apps scale automatically on serverless PaaS provided instances, and a consumer only pays based on usage.

## Next steps

> [!div class="nextstepaction"]
> [Design for scaling](./design-scale.md)

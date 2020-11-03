---
title: Design scalable Azure applications for efficiency
description: Describes the design options for application efficiency
author: v-aangie
ms.date: 11/03/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - How are you designing your applications for performance efficiency?
  - article
---

# Design applications for efficiency

## Asynchronous programming

When an application calls a remote service leveraging a synchronous call, some of resources on the client (i.e caller thread, network socket, etc.) are blocked and unavailable for use elsewhere until the remote service invocation completes. This pattern is simple, but leads to obvious inefficiencies. Asynchronous programming is an alternative approach that enables a remote service to be executed without waiting and blocking resources on the client. This is a critical pattern for enabling cloud scalable software and is available in most modern programming languages and platforms.

There are many ways to inject asynchronous programming into an application design. In a simplest form, remote calls be asynchronously executed using built-in language constructs like "async/await" in .NET C#. Review a [language construct example](/dotnet/csharp/async). .NET has other built-in platform support for asynchronous programming with [task](/dotnet/standard/asynchronous-programming-patterns/task-based-asynchronous-pattern-tap) and [event](/dotnet/standard/asynchronous-programming-patterns/event-based-asynchronous-pattern-eap) based asynchronous patters.

Asynchronous patterns are critical for cloud scale, and Azure enables the implementation of cloud patterns for async request/reply appropriate for long running worker type processing. These patterns simulate what a programming language like C# offers natively for request/response, but optimized for moving back-end processing out of a front end. Review the [asynchronous Request-Reply pattern](../../patterns/async-request-reply.md) for additional information.

## Queuing and batching requests

A variant to asynchronous programming discussed above, queuing services have long been used as a scalable mechanism to hand-off processing work to a service. Called the Load Leveling pattern, highly scalable queuing services are natively supported in Azure. The queue is a storage buffer that sits between the caller and the processing service, takes requests, stores and queues the request, and provides services around the reliable delivery and management of the queued data.

Using a queue is often the best way to hand off work to a processor service. The processor service receives work by listening on a queue and dequeuing messages. If items to be processed enter too quickly, the queuing service will keep them in the queue until the processing service has available resources and asks for a new work item (message). By leveraging the dynamic nature of Azure Functions, the processor service can easily autoscale on demand as the queue builds up to meet the intake pressure. Developing processor logic with Azure Functions to run task logic from a queue is a common, scalable, and cost effective way to using queuing between a client and a processor.  

Azure provides a few native first-party queueing services with Azure Storage Queues (simple queuing service based on Azure Storage) and Azure Service Bus (message broker service supporting transactions and reduced latency). Many other third-party options are also available through Marketplace. Review the [queue-based load leveling pattern](../../patterns/queue-based-load-leveling.md) to learn more.

## Data compression

A well-known optimization best practice for scaling web applications is to use a compression strategy to compress and bundle web pages or api responses. The idea here is to shrink the results returned from a page or api back to the browser or client app. Compressing the results returned to clients optimizes network traffic and accelerating the web application. .NET has built in framework support for this technique with GZip compression. Review [Response compression in ASP.NET Core](/aspnet/core/performance/response-compression?view=aspnetcore-3.0) of using response compression with ASP.NET Core. The reason this can dramatically impact scale is the network optimization benefit means less socket processing for the web server reducing web server cpu utilization, shortening connections, and thus allowing the web server to handle more concurrent requests.

## Session affinity

To design a system to be horizontally scalable, avoid designing a web application that assumes requests have instance affinity. Stateless, or non-affinity applications, allow the hosting platform (App Services, Kubernetes, Service Fabric, other) to dynamically add or remove compute instances based on service metrics. This is called autoscale and works differently depending on the service. A critical requirement for a web application or API to work in an autoscalable environment is a stateless nature where the application saves its state to an external data store allowing the app platform to load-balance and route requests across any of the clustered instances. This is advantageous for service self-healing, removing problematic compute instances, and enabling the latest platform innovation that leads to higher scale. For older applications running in App Services v1 platforms, avoid using the Application Request Routing (ARR) session affinity flag to force all requests back to the initial instance.

If the solution implements a long-running task, route requests to this task with a queuing mechanisms discussed earlier.

[Migrate an Azure Cloud Services application to Azure Service Fabric](../../service-fabric/migrate-from-cloud-services.md) describes best practices about stateless services for an application that is migrated from old Azure Cloud Services to Azure Service Fabric. 


---
title: Design Azure applications for efficiency
description: Describes the design options for application efficiency
author: v-aangie
ms.date: 11/13/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - How are you designing your applications for performance efficiency?
  - article
---

# Design Azure applications for efficiency

Application design is critical to handling scale as load increases. The topics in this article will give you insight into designing applications for efficiency. For other key topics related to handling scale as load increases, see the *Design scalable Azure applications* article in the Performance efficiency pillar. <!--LINK to Design - design-apps article-->

## Reduce response time with asynchronous programming

Calling a service is a request that will take time to complete. The time for the caller to receive a response could range from milliseconds to minutes. During that time the thread is held by the process until the response comes back, or if an exception happens. This is inefficient because it means that no other requests can be processed during the time waiting for a response. Asynchronous programming is an alternative approach that enables a remote service to be executed without waiting and blocking resources on the client. This is a critical pattern for enabling cloud scalable software and is available in most modern programming languages and platforms.

There are many ways to inject asynchronous programming into an application design. In a simplest form, remote calls can be asynchronously executed using built-in language constructs like "async/await" in .NET C#. Review a [language construct example](https://docs.microsoft.com/dotnet/csharp/async). .NET has other built-in platform support for asynchronous programming with [task](https://docs.microsoft.com/dotnet/standard/asynchronous-programming-patterns/task-based-asynchronous-pattern-tap) and [event](https://docs.microsoft.com/dotnet/standard/asynchronous-programming-patterns/event-based-asynchronous-pattern-eap) based asynchronous patterns.

Azure enables the implementation of cloud patterns for async request/reply appropriate for long running worker type processing. These patterns simulate what a programming language like C# offers natively for request/response, but optimized for moving back-end processing out of a front end. See the [asynchronous Request-Reply pattern](https://docs.microsoft.com/azure/architecture/patterns/async-request-reply) for additional information.

## Process faster by queuing and batching requests

Similar to asynchronous programming, queuing services has long been used as a scalable mechanism to hand off processing work to a service. Called the [Load Leveling pattern](https://docs.microsoft.com/azure/architecture/patterns/queue-based-load-leveling), highly scalable queuing services are natively supported in Azure. The queue is a storage buffer located between the caller and the processing service. It takes requests, stores and queues the request, and provides services around the reliable delivery and management of the queued data.

Using a queue is often the best way to hand off work to a processor service. The processor service receives work by listening on a queue and dequeuing messages. If items to be processed enter too quickly, the queuing service will keep them in the queue until the processing service has available resources and asks for a new work item (message). By leveraging the dynamic nature of [Azure Functions](https://docs.microsoft.com/azure/azure-functions/functions-overview), the processor service can easily autoscale on demand as the queue builds up to meet the intake pressure. Developing processor logic with Azure Functions to run task logic from a queue is a common, scalable, and cost effective way to using queuing between a client and a processor.  

Azure provides some native first-party queueing services with Azure Storage Queues (simple queuing service based on Azure Storage) and Azure Service Bus (message broker service supporting transactions and reduced latency). Many other third-party options are also available through [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace).

To learn more about queue-based Load Leveling, see [Queue-based Load Leveling pattern](https://docs.microsoft.com/azure/architecture/patterns/queue-based-load-leveling). To compare and contrast queues, see [Storage queues and Service Bus queues - compared and contrasted](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted).

## Optimize with data compression

A well-known optimization best practice for scaling web applications is to use a compression strategy to compress and bundle web pages or API responses. The idea is to shrink the results returned from a page or API back to the browser or client app. Compressing the results returned to clients optimizes network traffic and accelerates the web application. .NET has built-in framework support for this technique with GZip compression. 

See [Response compression in ASP.NET Core](https://docs.microsoft.com/aspnet/core/performance/response-compression?view=aspnetcore-3.1) for using response compression with ASP.NET Core. The reason this can dramatically impact scale is that the network optimization benefit means less socket processing for the web server which reduces web server CPU utilization, shortens connections, and thus allows the web server to handle more concurrent requests.

## Improve scalability with session affinity

If an application is stateful, meaning that data or state will be stored locally in the instance of the application, it may increase performance by enabling session affinity. When session affinity is enabled, subsequent requests to the application will be directed to the same server that processed the first request. If session affinity is not enabled, subsequent requests would be directed to the next available server depending on the load balancing rules.

To design a system to be horizontally scalable, avoid designing a web application that assumes requests have instance affinity. Stateless, or non-affinity applications, allow the hosting platform (App Services, Kubernetes, Service Fabric, and others), to dynamically add or remove compute instances based on service metrics. This is called autoscale and works differently depending on the service. A critical requirement for a web application or API to work in an autoscalable environment is a stateless nature. This is where the application saves its state to an external data store, which allows the app platform to load-balance and route requests across any of the clustered instances.

This is advantageous for:

- Service self-healing.
- Removing problematic compute instances.
- Enabling the latest platform innovation that leads to higher scale.

For older applications running in App Services v1 platforms, avoid using the Application Request Routing (ARR) session affinity flag to force all requests back to the initial instance.

If the solution implements a long-running task, route requests to this task with a queuing mechanisms discussed previously.

> [!TIP]
> [Migrate an Azure Cloud Services application to Azure Service Fabric](https://docs.microsoft.com/azure/architecture/service-fabric/migrate-from-cloud-services) describes **best practices** about stateless services for an application that is migrated from old Azure Cloud Services to Azure Service Fabric.

## Run background jobs to meet integration needs

At the turn of the century, Enterprise Application Integration (EAI) became a major tool for hooking systems together and creating and scheduling tasks/jobs. These platforms offered a series of connectors for working with common formats and protocols like EDI/X12/EDIFACT, SFTP, HL7, SWIFT, and SOAP. They were also used for  managing long running processes that may span minutes, hours, or days through workflow orchestration. Along with workflow, these integration tools solved app-to-app and business-to-business integration needs.

These needs still exist in the cloud, but a scalable cloud native way of enabling these capabilities is paramount. That's what the Logic Apps service enables in Azure. Logic Apps is a serverless consumption (pay-per-use) service that enables a vast set of out-of-the-box ready-to-use connectors and a long-running workflow engine to quickly enable cloud-native integration needs. Logic Apps is flexible enough for scenarios like running tasks/jobs, advanced scheduling, and triggering. It includes many of the format and protocol capabilities that existed in the Microsoft enterprise EAI product called BizTalk Server. Logic Apps also has advanced hosting options to allow it to run within enterprise restricted cloud environments. Logic Apps can be combined with all other Azure services to complement one another, or it can be used independently.

Like all serverless services, [Logic Apps](https://docs.microsoft.com/azure/logic-apps/logic-apps-overview) doesn't require VM instances to be purchased, enabled, and scaled up and down. Instead, Logic Apps scale automatically on serverless PaaS provided instances, and a consumer only pays based on usage.

## Next step

>[!div class="nextstepaction"]
>[Design for scaling]()
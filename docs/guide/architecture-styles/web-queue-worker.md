---
title: Web-Queue-Worker Architecture Style
description: Learn about the Web-Queue-Worker pattern. Discover benefits, challenges, and implementation by using Azure App Service, Azure Functions, and message queues.
author: claytonsiemens77
ms.author: pnp
ms.date: 12/19/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-web
---

# Web-Queue-Worker architecture style

The core components of this architecture are a **web front end** that handles client requests and a **worker** that does resource-intensive tasks, long-running workflows, or batch jobs. The web front end communicates with the worker through a **message queue**.

:::image type="content" source="./images/web-queue-worker-logical.svg" alt-text="A logical diagram that shows the Web-Queue-Worker architecture." lightbox="./images/web-queue-worker-logical.svg" border="false":::

The following components are commonly incorporated into this architecture:

- One or more databases

- A cache to store values from the database for quick reads

- A content delivery network to serve static content

- Remote services, like email or Short Message Service (SMS), that non-Microsoft service providers typically provide

- An identity provider for authentication

The web and worker are both stateless, and session state can be stored in a distributed cache. The worker handles long-running work asynchronously. Messages on the queue can start the worker, or a schedule can run it for batch processing. The worker is optional if the application has no long-running operations.

The front end might include a web API. A single‑page application can consume the web API by making AJAX calls, or a native client application can consume it directly.

## When to use this architecture

The Web-Queue-Worker architecture is typically implemented by using managed compute services like [Azure App Service](/azure/app-service/overview), [Azure Kubernetes Service](/azure/aks/what-is-aks), or [Azure Container Apps](/azure/container-apps/)

Consider this architecture for the following use cases:

- Applications that have a relatively simple domain

- Applications that have long-running workflows or batch operations

- Scenarios where you prefer managed services over infrastructure as a service (IaaS)

## Benefits

- An architecture that's straightforward and easy to follow

- Deployment and management with minimal effort

- Clear separation of responsibilities

- Decoupling of the front end and worker through asynchronous messaging

- Independent scaling of the front end and worker

## Challenges

- Without careful design, the front end and worker can become large monolithic components that are difficult to maintain and update.

- If the front end and worker share data schemas or code modules, there might be hidden dependencies.

- The web front end can fail after persisting to the database but before sending messages to the queue, which causes consistency problems because the worker doesn't do its part of the logic. To mitigate this problem, you can use techniques like the [Transactional Outbox pattern](../../best-practices/transactional-outbox-cosmos.yml), which require routing outgoing messages to first *loop back* through a separate queue. The [NServiceBus Transactional Session](https://docs.particular.net/nservicebus/transactional-session/) library supports this technique.

## Best practices

- Expose a well-designed API to the client. For more information, see [API design best practices](../../best-practices/api-design.md).

- Automatically scale to handle changes in load. For more information, see [Autoscaling best practices](../../best-practices/auto-scaling.md).

- Cache semistatic data. For more information, see [Caching best practices](../../best-practices/caching.yml).

- Use a content delivery network to host static content. For more information, see [Content delivery network best practices](../../best-practices/cdn.yml).

- Use polyglot persistence when appropriate. For more information, see [Understand data models](../../data-guide/technology-choices/understand-data-store-models.md).

- Partition data to improve scalability, reduce contention, and optimize performance. For more information, see [Data partitioning best practices](../../best-practices/data-partitioning.yml).

## Web-Queue-Worker on App Service

This section describes a recommended Web-Queue-Worker architecture that uses App Service.

:::image type="complex" border="false" source="./images/web-queue-worker-physical.svg" alt-text="Diagram that shows the Web-Queue-Worker architecture." lightbox="./images/web-queue-worker-physical.svg":::
   Architecture diagram that shows users who access web applications through Azure CDN for static content delivery. Traffic flows to App Service web apps that handle user requests and send messages to Azure Service Bus or Azure Storage queues. Azure Functions workers process messages from the queues to handle resource-intensive tasks. The system includes Azure Cache for Redis for session state and low-latency data access, Azure Blob Storage for file and document storage, and polyglot data storage with Azure SQL Database and Azure Cosmos DB. Web apps and Functions both run on App Service plans for compute infrastructure.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/web-queue-worker.vsdx) of this architecture.*

### Workflow

- The front end is implemented as an [App Service](/azure/app-service/overview) web app, and the worker is implemented as an [Azure Functions](/azure/azure-functions/functions-overview) app. The web app and the Functions app are both associated with an App Service plan that provides the virtual machine (VM) instances.

- You can use either [Azure Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview) or [Azure Storage queues](/azure/storage/queues/storage-queues-introduction) for the message queue. The previous diagram uses a Storage queue.

- [Azure Cache for Redis](/azure/redis/overview) stores session state and other data that requires low-latency access.

- [Azure Content Delivery Network](/azure/cdn/cdn-overview) is used to cache static content like images, CSS, or HTML.

- For storage, choose technologies that best fit your application's needs. This approach, known as *polyglot persistence*, uses multiple storage technologies in the same system to meet different requirements. To illustrate this idea, the diagram shows both [Azure SQL Database](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview) and [Azure Cosmos DB](/azure/cosmos-db/introduction).

For more information, see [Baseline highly available zone-redundant web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml) and [Build message-driven business applications with NServiceBus and Service Bus](/azure/service-bus-messaging/build-message-driven-apps-nservicebus).

### Other considerations

- Not every transaction must go through the queue and worker to storage. The web front end can do simple read and write operations directly. Workers are designed for resource-intensive tasks or long-running workflows. In some cases, you might not need a worker at all.

- Use the built-in autoscale feature of your compute platform to scale out the number of instances. If the load on the application follows predictable patterns, use schedule-based autoscaling. If the load is unpredictable, use metrics-based autoscaling.

- Consider putting the web app and the Functions app into separate App Service plans so that they can scale independently.

- Use separate App Service plans for production and testing.

- Use deployment slots to manage deployments for App Service plans. This method lets you deploy an updated version to a staging slot, then swap over to the new version. It also lets you swap back to the previous version if there's a problem during the update.

## Related resource

- [Queue-Based Load Leveling pattern](../../patterns/queue-based-load-leveling.yml)

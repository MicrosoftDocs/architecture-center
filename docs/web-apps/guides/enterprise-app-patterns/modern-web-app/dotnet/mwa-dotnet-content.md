---
title: 
---

[!INCLUDE [mwa-plan-intro](../includes/mwa-plan-intro.md)]

[!INCLUDE [reference-implementation-dotnet](../includes/reference-implementation-dotnet.md)]

## Understand the goals of the Modern Web App pattern

The Modern Web App pattern drives toward specific web app goals. Review the following goals of the Modern Web App Pattern and ensure they align with your goals:

| Modern Web App pattern business goals | Modern Web App pattern web app goals |
|---------------------------------------|--------------------------------------|
| Handle increased demand               | - Decouple components<br>- Autoscale high-traffic components independently|
| Optimize web app costs                | - Scale unneeded resources to zero where appropriate |
| Service-level objective of 99.9%      | - Deploy reliably by using containerized services<br>-Choose the right Azure services<br>-Choose the right architecture|

If your goals align with the Modern Web App pattern, then it's likely the right solution for you.

## Satisfy the prerequisites of the Modern Web App pattern

The Modern Web App builds on the Reliable Web App pattern. Before you apply the Modern Web App pattern, review the [implementation techniques](../../overview.md#principles-and-implementation-techniques-of-the-reliable-web-app-pattern) of the Reliable Web App pattern and make sure you apply the implementation techniques to your web app.

## Choose the right services

The Modern Web App pattern introduces containerization, asynchronous communication, and queue-based scaling. The services you selected for the implementation of the Reliable Web App pattern might not support these implementation techniques. You need to adopt new Azure services for the portion of the application that you want to modernize. For the Modern Web App pattern, you need an application platform that supports containerization. You need a container image repository, and you need a messaging system.

### Choose an Azure container service

Azure has three principle container services: Azure Container Apps (ACA), Azure Kubernetes Service (AKS), and App Service.

- *Azure Container Apps*: Choose ACA if you need a serverless platform that automatically scales and manages containers in event-driven applications.
- *Azure Kubernetes Service*: Choose AKS if you need detailed control over Kubernetes configurations and advanced features for scaling, networking, and security.
- *Web Apps for Container*: Select App Service for the simplest PaaS experience.

For more information, see [Choose and Azure container service](/azure/architecture/guide/choose-azure-container-service).

## Choose an Azure

When using any container-based compute service, it’s necessary to have a repository to store the container images that will be hosted.


## Messaging system

 a managed messaging system with both message queue and publish-subscribe topic support. A message bus is an important piece of service-oriented architectures because it allows multiple workers to balance work by pulling from a common queue and because it decouples message senders and receivers so that work requests can be completed asynchronously.

Azure has multiple services that support message queues. Documentation to help choose between them is available [here](https://learn.microsoft.com/azure/service-bus-messaging/compare-messaging-services) and [here](https://learn.microsoft.com/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted).


- **Error handling**. automatic support for a dead-letter queue which can be used to collect messages which could not be handled. This allows easy investigation of malformed messages.

- **At-least once message delivery**. it’s important that messages be reliably delivered. 

- **Reduced management overhead**. messaging services without the need to manage any underlying infrastructure.

- **Support for publish-subscribe models**. service-oriented web apps often benefit from publish-subscribe models eventually. enable future updates which may depend on publish-subscribe patterns.


## Next steps

This article showed you how to plan an implementation of the modern web app pattern. In the next article, learn how to apply the modern web app pattern.

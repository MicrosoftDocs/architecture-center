[!INCLUDE [mwa-plan-intro](../includes/mwa-plan-intro.md)]

[!INCLUDE [reference-implementation-dotnet](../includes/reference-implementation-dotnet.md)]

## Prerequisites

### Understand the goals of the Modern Web App pattern

The Modern Web App pattern drives toward specific web app goals. Review the following goals of the Modern Web App Pattern and ensure they align with your goals:

| Business goals                        | Web app goals                        |
|---------------------------------------|--------------------------------------|
| Handle increased demand               | Decouple components<br>Autoscale high-traffic components independently|
| Optimize web app costs                | Scale unneeded resources to zero where appropriate |
| Service-level objective of 99.9%      | Use containerized services<br>Choose the right services<br>Choose the right architecture|

If your goals align with the Modern Web App pattern, then it's likely the right solution for you.

### Apply the Reliable Web App Pattern

The Modern Web App builds on the Reliable Web App pattern. Before you apply the Modern Web App pattern, review the [implementation techniques](../../overview.md#principles-and-implementation-techniques-of-the-reliable-web-app-pattern) of the Reliable Web App pattern and make sure you apply the implementation techniques to your web app.

## Choose the right services for your web app

The Modern Web App pattern introduces containerization, asynchronous communication, and queue-based scaling. The services you selected for the implementation of the Reliable Web App pattern might not support these implementation techniques. You need to adopt new Azure services for the portion of the application that you want to modernize. For the Modern Web App pattern, you need an application platform that supports containerization. You need a container image repository, and you need a messaging system.

### Choose a container service

For the parts of your application that you want to containerize, you need an application platform that supports containers. Azure has three principle container services: Azure Container Apps (ACA), Azure Kubernetes Service (AKS), and App Service.

- *Azure Container Apps*: Choose ACA if you need a serverless platform that automatically scales and manages containers in event-driven applications.
- *Azure Kubernetes Service*: Choose AKS if you need detailed control over Kubernetes configurations and advanced features for scaling, networking, and security.
- *Web Apps for Container*: Choose Web App for Containers on Azure App Service for the simplest PaaS experience.

For more information, see [Choose an Azure container service](/azure/architecture/guide/choose-azure-container-service).

### Choose a container repository

When using any container-based compute service, it’s necessary to have a repository to store the container images. You can use a public container registry like Docker Hub or a managed registry like Azure Container Registry. For more information, see [Introduction to Container registries in Azure](/azure/container-registry/container-registry-intro).

### Choose a messaging system

A messaging system is an important piece of service-oriented architectures. It allows multiple workers to balance work by pulling from a common queue. It decouples message senders and receivers to enables [asynchronous messaging](/azure/architecture/guide/technology-choices/messaging). Ideally, your messaging system should support message queues and publish-subscribe methods.

Azure has three messaging services: Azure Event Grid, Azure Event Hub, and Azure Service Bus.

- *Azure Event Grid*: Choose Azure Event Grid when you need a highly scalable service to react to status changes through a publish-subscribe model.
- *Azure Event Hubs*: Choose Azure Event Hubs for large-scale data ingestion, especially when dealing with telemetry and event streams that require real-time processing.
- *Azure Service Bus*: Choose Azure Service Bus for reliable, ordered, and possibly transactional delivery of high-value messages in enterprise applications.

For more information, see [Choose between Azure messaging services](https://learn.microsoft.com/azure/service-bus-messaging/compare-messaging-services).

## Next steps

This article showed you how to plan an implementation of the modern web app pattern. In the next article, learn how to apply the modern web app pattern.

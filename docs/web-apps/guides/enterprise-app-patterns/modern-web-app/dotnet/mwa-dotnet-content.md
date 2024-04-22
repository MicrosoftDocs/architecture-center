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

## Identify the prerequisites of the pattern

The Modern Web App builds on the Reliable Web App pattern. Before you apply the Modern Web App pattern, review the [implementation techniques](../../overview.md#principles-and-implementation-techniques-of-the-reliable-web-app-pattern) of the Reliable Web App pattern and make sure you apply the implementation techniques to your web app.

## Choose the right services

The Modern Web App pattern introduces containerization, asynchronous communication, and queue-based scaling. The services you selected for the implementation of the Reliable Web App pattern might not support these implementation techniques. When applying the strangler fig pattern to extract functionality into a new service, the existing app continues executing as before except for the extracted component. New Azure services are adopted for the portion of the application that you need to modernize. You need an application platform that supports containerization. You need a container image repository, and you need a messaging system.

### Application platform

[Azure Container Apps](/azure/container-apps/overview) is a fully managed, serverless platform for running containerized apps in Azure. Azure Container Apps enables container orchestration and KEDA-supported scalers without needing to manage infrastructure. The ability to scale automatically based on incoming requests in a message queue makes Azure Container Apps an ideal fit for applying both the strangler fig pattern and queue-based load leveling patterns. The Relecloud modern web app reference sample uses Azure Container Apps to run its ticket rendering service because it meets the following requirements:

- **High SLA**. It has a high SLA that meets the production environment SLO.

- **Reduced management overhead**. It's a fully managed solution that handles scaling, health checks, and load balancing. Other services like Azure Kubernetes Service allow additional control of the underlying Kubernetes cluster, but this is not required for the Relecloud scenario and introduces additional management complexity.

- **KEDA-based autoscaling**. Autoscaling allows the application to horizontally scale capacity based on the length of a request queue. Azure Container Apps also supports scaling to zero so that the ticket rendering service can be stopped entirely when no work needs to be done.

## Container image repository

[Azure Container Registry](https://learn.microsoft.com/azure/container-registry/container-registry-intro) is a managed registry service based on the open-source Docker Registry 2.0. It allows users to store and deliver Docker container images used to deploy services in well-known easy-to-use environments. When using Azure Container Apps (or any container-based compute service), it’s necessary to have a repository to store the container images that will be hosted. The Relecloud sample uses Azure Container Registry to store and deliver container images because it meets the following requirements:

- **High SLA**. Because access to container images is needed to scale horizontally, it’s important that the container registry have high availability. Azure Container Registry supports [geo-replication](https://learn.microsoft.com/azure/container-registry/container-registry-geo-replication#configure-geo-replication) which allows a single instance of the service to be replicated between multiple geographies enabling automatic failover in case of a regional outage.

- **Access control**. Azure Container Registry supports authentication on private (internal) endpoints using Azure managed identity. This allows authenticating in a secure password-less manner without any endpoints being exposed to the public internet.

- **Reduced management overhead**. As a managed service, Azure Container Registry is simple to create, maintain, and use. No additional infrastructure needs to be managed by the user.

## Messaging system

[Azure Service Bus](https://learn.microsoft.com/azure/service-bus-messaging/service-bus-messaging-overview) is a managed enterprise message broker with both message queue and publish-subscribe topic support. A message bus is an important piece of service-oriented architectures because it allows multiple workers to balance work by pulling from a common queue and because it decouples message senders and receivers so that work requests can be completed asynchronously. Azure has multiple services that support message queues. Documentation to help choose between them is available [here](https://learn.microsoft.com/azure/service-bus-messaging/compare-messaging-services) and [here](https://learn.microsoft.com/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted). The Relecloud modern web app sample uses an Azure Service Bus namespace with two queues – one for the web API to request ticket rendering and another for the ticket rendering service to request the API to update the database and take any other necessary actions once ticket rendering is completed. The Relecloud sample uses Azure Service Bus because it meets the following requirements:

- **Error handling**. Azure Service Bus includes automatic support for a dead-letter queue which can be used to collect messages which could not be handled. This allows easy investigation of malformed messages.

- **At-least once message delivery**. Because Relecloud uses message queues for important business processes (creating ticket images for customers), it’s important that messages be reliably delivered. Azure Service Bus guarantees at-least one message delivery by default and is recommended as an enterprise messaging solution.

- **Reduced management overhead**. As a managed service, Azure Service Bus provides messaging services without the need to manage any underlying infrastructure.

- **Support for publish-subscribe models**. Although Relecloud only uses messaging queues, currently, service-oriented web apps often benefit from publish-subscribe models eventually. Having access to Azure Service Bus topics will enable future updates which may depend on publish-subscribe patterns.


## Next steps

This article showed you how to plan an implementation of the modern web app pattern. In the next article, learn how to apply the modern web app pattern.

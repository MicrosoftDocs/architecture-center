---
title: 
---
This article shows you how to plan an implementation of the reliable web app pattern. [!INCLUDE [mwa-intro](../includes/mwa-intro.md)]

[!INCLUDE [reference-implementation-dotnet](../includes/reference-implementation-dotnet.md)] To plan an implementation of the reliable web app pattern, follow these recommendations:

##  goals

*Example:* The fictional company, Relecloud, has applied the reliable web app pattern to their web app that allows customers to purchase concert tickets. Relecloud wants to improve how their web app handles spikes in demand especially for resource-intensive parts of the application, such as rendering ticket images. They identified the following business goals:

- Maintain a service level objective of 99.9%
- Decouple solution components so that they can operate and version independently
- Allow high traffic components of their solution to automatically scale independently
- Optimize costs by scaling unneeded resources to zero when appropriate
- Deploy reliably by using containerized services

To achieve these goals, they needed a more service-oriented architecture according to the modern web app pattern.

## Choose the right services

The Azure services used when implementing the modern web app pattern must support the web app goals and the principles of the modern web app pattern. Unlike the reliable web app pattern, the modern web app pattern uses containerization to separate logical portions of the application into standalone services. It also adds a messaging solution to enable asynchronous communication and queue-based scaling.

The services used to implement the modern web app pattern supplement the reliable web app pattern. When applying the strangler fig pattern to extract functionality into a new service, the existing app continues executing as before except for the extracted component. New Azure services are adopted for the portion of the application that is being modernized. In the case of the Relecloud example, the services below are added to the solution to meet the goals and principles of the modern web app pattern.

*Example:* The existing web app for the modern web app pattern is the end state of the reliable web app pattern. In the example used in the modern web app pattern reference sample, the web app is Relecloud’s ticket purchasing application. After applying the reliable web app pattern, Relecloud’s application consists of two Azure App Services (a front-end and an API) which communicate with an Azure SQL database and an Azure Cache for Redis. The Relecloud solution stores configuration values and secrets in Azure App Configuration and Azure Key Vault.

The Relecloud app still suffers from being deployed as a monolith which performs all business functions in the API web app. Processes which periodically consume a large amount of resources (such as rendering ticket images) are performed synchronously in-process as part of handling ticket purchase requests. Making changes to any part of the API results in needing to update the entire App Service. These challenges can be addressed by applying the modern web app pattern.

## Application platform

[Azure Container Apps](/azure/container-apps/overview) is a fully managed, serverless platform for running containerized apps in Azure. Azure Container Apps enables container orchestration and KEDA-supported scalers without needing to manage infrastructure. The ability to scale automatically based on incoming requests in a message queue makes Azure Container Apps an ideal fit for applying both the strangler fig pattern and queue-based load leveling patterns. The Relecloud modern web app reference sample uses Azure Container Apps to run its ticket rendering service because it meets the following requirements:

- **High SLA**. It has a high SLA that meets the production environment SLO.

- **Reduced management overhead**. It's a fully managed solution that handles scaling, health checks, and load balancing. Other services like Azure Kubernetes Service allow additional control of the underlying Kubernetes cluster, but this is not required for the Relecloud scenario and introduces additional management complexity.

- **KEDA-based autoscaling**. Autoscaling allows the application to horizontally scale capacity based on the length of a request queue. Azure Container Apps also supports scaling to zero so that the ticket rendering service can be stopped entirely when no work needs to be done.

## Container image repository

[Azure Container Registry](https://learn.microsoft.com/azure/container-registry/container-registry-intro) is a managed registry service based on the open-source Docker Registry 2.0. It allows users to store and deliver Docker container images used to deploy services in well-known easy-to-use environments. When using Azure Container Apps (or any container-based compute service), it’s necessary to have a repository to store the container images that will be hosted. The Relecloud sample uses Azure Container Registry to store and deliver container images because it meets the following requirements:

- **High SLA**. Because access to container images is needed to scale horizontally, it’s important that the container registry have high availability. Azure Container Registry supports [geo-replication](https://learn.microsoft.com/azure/container-registry/container-registry-geo-replication#configure-geo-replication) which allows a single instance of the service to be replicated between multiple geographies enabling automatic failover in case of a regional outage.

- **Access control**. Azure Container Registry supports authentication on private (internal) endpoints using Azure managed identity. This allows authenticating in a secure password-less manner without any endpoints being exposed to the public internet.

- **Reduced management overhead**. As a managed service, Azure Container Registry is simple to create, maintain, and use. No additional infrastructure needs to be managed by the user.

## Messaging

[Azure Service Bus](https://learn.microsoft.com/azure/service-bus-messaging/service-bus-messaging-overview) is a managed enterprise message broker with both message queue and publish-subscribe topic support. A message bus is an important piece of service-oriented architectures because it allows multiple workers to balance work by pulling from a common queue and because it decouples message senders and receivers so that work requests can be completed asynchronously. Azure has multiple services that support message queues. Documentation to help choose between them is available [here](https://learn.microsoft.com/azure/service-bus-messaging/compare-messaging-services) and [here](https://learn.microsoft.com/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted). The Relecloud modern web app sample uses an Azure Service Bus namespace with two queues – one for the web API to request ticket rendering and another for the ticket rendering service to request the API to update the database and take any other necessary actions once ticket rendering is completed. The Relecloud sample uses Azure Service Bus because it meets the following requirements:

- **Error handling**. Azure Service Bus includes automatic support for a dead-letter queue which can be used to collect messages which could not be handled. This allows easy investigation of malformed messages.

- **At-least once message delivery**. Because Relecloud uses message queues for important business processes (creating ticket images for customers), it’s important that messages be reliably delivered. Azure Service Bus guarantees at-least one message delivery by default and is recommended as an enterprise messaging solution.

- **Reduced management overhead**. As a managed service, Azure Service Bus provides messaging services without the need to manage any underlying infrastructure.

- **Support for publish-subscribe models**. Although Relecloud only uses messaging queues, currently, service-oriented web apps often benefit from publish-subscribe models eventually. Having access to Azure Service Bus topics will enable future updates which may depend on publish-subscribe patterns.

# Service level objective

A service level objective (SLO) for availability defines how available you want a web app to be for users. You need to define an SLO and what available means for your web app. Relecloud has a target SLO of 99.9% for availability, about 8.7 hours of downtime per year. For Relecloud, availability means that the core ticket purchasing and retrieval functionality of the solution are available and functioning. Once a definition of ‘available’ is established, an SLO can be calculated by considering all of the dependencies of the critical path for the necessary functionality for availability. Dependencies should include Azure services and third-party solutions.

For each dependency in the critical path, you need to assign an availability goal. Service level agreements (SLAs) from Azure provide a good starting point. However, SLAs don't factor in (1) downtime that's associated with the application code running on the services (2) deployment and operation methodologies, (3) architecture choices to connect the services. The availability metric you assign to a dependency shouldn't exceed the SLA.

Relecloud used Azure SLAs for Azure services. The following diagram illustrates Relecloud's dependency list with availability goals for each dependency.

<img src="c:\GitHub\architecture-center-pr\docs\web-apps\guides\modern-web-app\dotnet/media/image2.png" style="width:6.5in;height:3.17986in" alt="A diagram of a cloud network Description automatically generated" />

Figure SLA dependency map. Azure SLAs are subject to change. The SLAs shown here are examples used to illustrate the process of estimating composite availability. For information, see [SLAs for Online Services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).

Based on the individual services’ SLAs, a composite SLA can be calculated which must equal or exceed the required SLO. In Relecloud’s case, they are deploying application resources into multiple regions, so the composite SLA is calculated using the SLA values from the figure above as shown in the table below.

| **Global Resources**     | **Count** | **Individual SLA** | **Total SLA** | **Notes**                              |
|--------------------------|-----------|--------------------|---------------|----------------------------------------|
| Front Door               | 1         | 99.99%             | 99.99%        |                                        |
| AAD                      | 1         | 99.99%             | 99.99%        |                                        |
| DNS Zones                | 1         | 100.00%            | 100.00%       |                                        |
| Key Vault                | 1         | 99.99%             | 99.99%        |                                        |
| Private endpoint         | 2         | 99.99%             | 99.98%        | Key Vault and ACR                      |
| Azure Container Registry | 1         | 99.9999%           | 99.9999%      | Two parallels regions at 99.9% each    |
| Composite global SLA     |           |                    | 99.95%        | Product of individual SLAs             |
|                          |           |                    |               |                                        |
| **Regional Resources**   | ** **     |                    |               |                                        |
| App Service              | 2         | 99.95%             | 99.90%        |                                        |
| Azure Cache for Redis    | 1         | 99.90%             | 99.90%        |                                        |
| Private Endpoints        | 7         | 99.99%             | 99.93%        |                                        |
| Blob Storage             | 1         | 99.90%             | 99.90%        |                                        |
| Azure SQL Databases      | 1         | 99.99%             | 99.99%        |                                        |
| App Configuration        | 1         | 99.90%             | 99.90%        |                                        |
| Service Bus              | 1         | 99.90%             | 99.90%        |                                        |
| Azure Container App      | 1         | 99.95%             | 99.95%        |                                        |
| Composite regional SLA   |           |                    | 99.37%        | Product of individual SLAs             |
|                          |           |                    |               |                                        |
| Multi-region SLA         | 2         |                    | 99.996%       | Two instances of regional resources    |
|                          |           |                    |               |                                        |
| **Total composite SLA**  | ** **     | ** **              | **99.946%**   | Product of global and multi-region SLA |

Note that although Azure Container Registry is listed in the global resources category (as it is part of the hub network and resource group when deploying the Relecloud application), its SLA is calculated as two parallel independent Azure Container Registry deployments, as described in [Azure Container Registry documentation](https://learn.microsoft.com/azure/container-registry/container-registry-geo-replication#considerations-for-using-a-geo-replicated-registry), since the service’s geo-replication feature is used.

As shown in the table, using a multi-region deployment gives the Relecloud sample implementing the modern web app pattern a composite SLA of 99.946% which exceeds the required SLO of 99.9%.

For more information, see [Composite SLA formula](https://learn.microsoft.com/azure/architecture/framework/resiliency/business-metrics#composite-slas) and [Multiregional SLA formula](https://learn.microsoft.com/azure/architecture/framework/resiliency/business-metrics#slas-for-multiregion-deployments).

## Next steps

This article showed you how to plan an implementation of the modern web app pattern. In the next article, learn how to apply the modern web app pattern.

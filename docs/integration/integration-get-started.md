---
title: Get Started with Integration Architecture Design
description: Learn how to integrate workflows by connecting apps, data, services, and devices. Explore resources that provide integration guidelines and recommendations.
author: claytonsiemens77
ms.author: pnp
ms.date: 06/18/2026
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: category-get-started
ai-usage: ai-assisted
---

# Get started with integration architecture design

Integration connects applications, data, services, and devices, often in complex ways, so that they run between on-premises, cloud, and edge systems.

To integrate applications, sometimes direct API calls are suitable. But sometimes technologies need to communicate asynchronously through messaging or events. All integration processes need orchestration, or a straightforward way to define and run the workflow's logic.

## Azure services for integration

Azure provides a range of services for integration:

- [Azure API Management](/azure/api-management/api-management-key-concepts): Securely publish your APIs for internal and external developers to use when they connect to back-end systems.

- [Azure Logic Apps](/azure/logic-apps/logic-apps-overview): Create workflows to connect hundreds of services in the cloud and on-premises.

- [Azure Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview): Connect on-premises and cloud-based applications and services to implement highly secure messaging workflows.

- [Azure Event Grid](/azure/event-grid/overview): Connect supported Azure and non-Microsoft services while simplifying event-based app development.

- [Azure Functions](/azure/azure-functions/functions-overview): Simplify complex orchestration problems by using an event-driven serverless compute platform.

- [Azure Data Factory](/azure/data-factory/introduction): Visually integrate data sources to accelerate data transformation and support enterprise workflows.

## Architecture

:::image type="complex" source="./media/integration-get-started-diagram.svg" alt-text="Diagram that shows a basic enterprise integration architecture on Azure." border="false" lightbox="./media/integration-get-started-diagram.svg":::
   The diagram consists of three sections. On the left side of the diagram, a Microsoft Entra icon, a globe icon, and a user icon are arranged vertically. On the right side of the diagram, Azure services, software as a service (SaaS) services, and web services like REST and SOAP make up the back-end systems. In the middle of the diagram, a box labeled resource group contains two sections. The section on the left is labeled API Management and contains an API gateway and a developer portal. The section on the right is labeled workflow and orchestration and contains Logic Apps. A solid line labeled HTTP points from the globe icon to the API gateway. Another solid line branches from the API gateway and points to Logic Apps and web services. Another solid line branches from Logic Apps and points to Azure services and SaaS services. A dotted line labeled create application points from the user icon to the globe icon. Dotted lines labeled authentication point from the globe icon and the API gateway to Microsoft Entra. Dotted lines labeled publish interfaces point from web services and the workflow and orchestration section to the developer portal. Another dotted line labeled consume API documentation points from the developer portal to the user icon.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/integration-get-started-diagram.vsdx) of this architecture.*

The previous diagram demonstrates a typical basic or baseline integration implementation. For real-world solutions that you can build in Azure, see [Integration architectures](#integration-architectures).

## Explore integration guides and architectures

The articles in this section include guides and fully developed architectures that you can deploy in Azure and expand to production-grade solutions. These articles can help you decide how to use integration technologies in Azure.

### Integration guides

The following articles help you evaluate and select the best integration technologies for your workload requirements:

- [Choose the right integration and automation services in Azure](/azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs): Compare Azure Functions, Azure Logic Apps, Power Automate, and WebJobs for building workflows and orchestrations.

- [Choose between Azure messaging services](/azure/service-bus-messaging/compare-messaging-services): Compare Azure Event Grid, Azure Event Hubs, and Azure Service Bus, and learn when to use each service.

- [Asynchronous messaging options](../guide/technology-choices/messaging.md): Learn about various types of messages and the entities that participate in a messaging infrastructure, and select an Azure messaging service.

#### Azure Event Hubs with Azure Functions

- [Integrate Azure Event Hubs with serverless functions on Azure](../serverless/event-hubs-functions/event-hubs-functions.yml): Guidance for how to effectively integrate Azure Event Hubs with Azure Functions for performance, resiliency, security, and scale.

- [Performance and scale guidance for Azure Event Hubs and Azure Functions](../serverless/event-hubs-functions/performance-scale.yml): Optimize scalability and performance when you use Azure Event Hubs and Azure Functions together.

- [Resilient Azure Event Hubs and Azure Functions design](../serverless/event-hubs-functions/resilient-design.md): Implement error handling, idempotency, and retry behavior for functions that Azure Event Hubs triggers.

- [Secure Azure Functions and Azure Event Hubs](../serverless/event-hubs-functions/security.md): Apply fine-grained access control and network security for Azure Event Hubs and Azure Functions.

- [Monitor Azure Functions and Azure Event Hubs](../serverless/event-hubs-functions/observability.yml): Use Application Insights to monitor the behavior and health of Azure Event Hubs and Azure Functions solutions.

#### Migration

- [Apache Kafka migration to Azure](../guide/hadoop/apache-kafka-migration.yml): Explore strategies for migrating Apache Kafka workloads to Azure, including Azure Event Hubs, Azure HDInsight, and Azure Kubernetes Service (AKS).

### Integration architectures

The following production-ready architectures demonstrate end-to-end integration solutions that you can deploy and customize:

- [Basic enterprise integration on Azure](../reference-architectures/enterprise-integration/basic-enterprise-integration.yml): Orchestrate synchronous calls to enterprise back-end systems by using Azure Logic Apps and Azure API Management.

- [Use a message broker and events to integrate enterprise systems](../example-scenario/integration/queues-events.yml): Orchestrate asynchronous calls to enterprise back-end systems by using queues and events.

- [Azure API Management landing zone architecture](../example-scenario/integration/app-gateway-internal-api-management-function.yml): Deploy a secure Azure API Management baseline with Azure Application Gateway and Azure Functions in a virtual network.

- [Build real-time monitoring and observable systems for media](../example-scenario/monitoring/monitoring-observable-systems-media.yml): Provide near-real-time monitoring and observability of systems and user device telemetry data by using Fabric Real-Time Intelligence.

## Organizational readiness

Organizations at the beginning of the cloud adoption process can use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) to access proven guidance that accelerates cloud adoption.

For integration-specific guidance, see [Azure integration architectures](/azure/architecture/browse/?azure_categories=integration). These articles provide reference architectures, example scenarios, and solution guides for Azure Integration Services, including networking, security, and deployment patterns.

To help ensure the quality of your integration solution on Azure, follow the guidance in the [Azure Well-Architected Framework](/azure/well-architected/). The Azure Well-Architected Framework provides prescriptive guidance for organizations that seek architectural excellence and describes how to design, provision, and monitor cost-optimized Azure solutions.

For integration-specific guidance, see the following Azure Well-Architected Framework service guides:

- [Azure API Management](/azure/well-architected/service-guides/azure-api-management): Review architectural best practices for Azure API Management across reliability, security, cost optimization, operational excellence, and performance efficiency.

- [Azure Service Bus](/azure/well-architected/service-guides/azure-service-bus): Review architectural best practices for Azure Service Bus messaging, including queue and topic design, sessions, and dead letter handling.

- [Azure Event Grid](/azure/well-architected/service-guides/azure-event-grid): Review architectural best practices for Azure Event Grid, including event delivery, security, and operational excellence.

## Best practices

Follow these best practices to improve the reliability, security, cost effectiveness, performance, and operational quality of your integration workloads on Azure:

- [Integrate Event Hubs with serverless functions on Azure](../serverless/event-hubs-functions/event-hubs-functions.yml): Guidance for how to effectively integrate Azure Event Hubs with Azure Functions for performance, resiliency, security, observability, and scale.

- [Performance and scale guidance for Azure Event Hubs and Azure Functions](../serverless/event-hubs-functions/performance-scale.yml): Optimize scalability and performance when you use Azure Event Hubs and Azure Functions together.

- [Monitor Azure Functions and Azure Event Hubs](../serverless/event-hubs-functions/observability.yml): Use Application Insights to monitor the behavior and health of Azure Event Hubs and Azure Functions solutions.

- [Multiple-region deployments for disaster recovery (DR) in Azure Logic Apps](/azure/logic-apps/multi-region-disaster-recovery): Set up deployments in multiple regions for Azure Logic Apps to protect data and maintain business continuity (BC).

- [Secure access and data in Azure Logic Apps](/azure/logic-apps/logic-apps-securing-a-logic-app): Review security guidance for access, data, run history, and environments in Azure Logic Apps.

## Stay current with integration

Azure integration services evolve to address modern data challenges. Stay informed about the latest [updates and features](https://azure.microsoft.com/updates/).

To stay current with key integration services, see the following articles:

- [What's new in Azure Event Grid](/azure/event-grid/whats-new): Learn about the latest features and updates for Azure Event Grid, including MQTT support, pull and push delivery, and namespace capabilities.

- [What's new in Azure Data Factory](/azure/data-factory/whats-new): Learn about the latest releases, known issues, bug fixes, deprecated functionality, and planned changes for Azure Data Factory.

### Other resources

The following resources can help you discover more about integration architecture design.

#### Product documentation

These documentation sets provide comprehensive guidance for Azure integration services:

- [Azure API Management documentation](/azure/api-management/api-management-key-concepts): Learn about the API gateway, management plane, developer portal, and policy configuration for managing APIs across all environments.

- [Azure Logic Apps documentation](/azure/logic-apps/logic-apps-overview): Learn how to build automated workflows that integrate apps, data, services, and systems across cloud and on-premises environments.

- [Azure Service Bus documentation](/azure/service-bus-messaging/service-bus-messaging-overview): Learn about enterprise message queuing and publish-subscribe topics for decoupling applications and services.

- [Azure Event Grid documentation](/azure/event-grid/overview): Learn about the fully managed publish-subscribe service for event-driven architectures, including MQTT broker support and HTTP push and pull delivery.

- [Azure Functions documentation](/azure/azure-functions/functions-overview): Learn about the serverless compute platform for building event-driven applications with triggers and bindings.

- [Azure Data Factory documentation](/azure/data-factory/introduction): Learn about the managed cloud extract, transform, load (ETL) service for orchestrating data movement and transformation at scale.

#### Integration environments

- [Azure Integration Environment overview (preview)](/azure/integration-environments/overview): Learn how to centrally organize and manage Azure integration resources by creating integration environments and application groups.

#### Microservice integration patterns

- [Implement the Transactional Outbox pattern by using Azure Cosmos DB](../databases/guide/transactional-out-box-cosmos.md): Implement the Transactional Outbox pattern for reliable messaging between services.

- [Identify microservice boundaries](../microservices/model/microservice-boundaries.yml): Derive microservices from a domain model when you design your application.

- [Design interservice communication for microservices](../microservices/design/interservice-communication.yml): Use service meshes to make communication between microservices efficient and robust.


#### Enterprise integration

- [Data analysis workloads for regulated industries](../example-scenario/data/data-warehouse.yml): Run data analytics workloads that account for regulatory requirements.

- [Enterprise business intelligence (BI)](../example-scenario/analytics/enterprise-bi-microsoft-fabric.yml): Move data from an on-premises SQL Server database into Microsoft Fabric and transform the data for analysis.

- [Microsoft Power Platform documentation](/power-platform/): Make non-Microsoft data available to web users.


## Amazon Web Services (AWS) or Google Cloud professionals

To help you get started quickly, the following articles compare Azure integration options to other cloud services:

- [Messaging services on Azure and AWS](../aws-professional/messaging.md): Compare messaging components such as queues, publish-subscribe, and event streaming across Azure and AWS.

- [Google Cloud to Azure services comparison - Messaging and eventing](../gcp-professional/services.md#messaging-and-eventing): Compare Google Cloud Pub/Sub with Azure Service Bus, Azure Event Grid, and Azure Event Hubs.

- [Google Cloud to Azure services comparison - Workflow](../gcp-professional/services.md#miscellaneous): Compare Google Cloud Composer with Azure Logic Apps for workflow orchestration.

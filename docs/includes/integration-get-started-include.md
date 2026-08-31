### Select an integration service

The following articles help you evaluate and select the best integration technologies for your workload requirements:

- [Choose the right integration and automation services in Azure](/azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs): Compare Azure Functions, Azure Logic Apps, Power Automate, and WebJobs for building workflows and orchestrations.

- [Choose between Azure messaging services](/azure/service-bus-messaging/compare-messaging-services): Compare Azure Event Grid, Azure Event Hubs, and Azure Service Bus, and learn when to use each service.

- [Asynchronous messaging options](../guide/technology-choices/messaging.md): Learn about various types of messages and the entities that participate in a messaging infrastructure, and select an Azure messaging service.

### Integration solution ideas

- [Integrate IBM MQs with Azure](../example-scenario/mainframe/integrate-ibm-message-queues-azure.yml): Integrate IBM MQ messaging systems with Azure by using Azure Service Bus and hybrid connectivity.

### Integration architectures

The following production-ready architectures demonstrate end-to-end integration solutions that you can deploy and customize:

- [Azure API Management landing zone architecture](../example-scenario/integration/app-gateway-internal-api-management-function.yml): Deploy a secure Azure API Management baseline with Azure Application Gateway and Azure Functions in a virtual network.

- [Basic enterprise integration on Azure](../reference-architectures/enterprise-integration/basic-enterprise-integration.yml): Orchestrate synchronous calls to enterprise back-end systems by using Azure Logic Apps and Azure API Management.

- [Use a message broker and events to integrate enterprise systems](../example-scenario/integration/queues-events.yml): Orchestrate asynchronous calls to enterprise back-end systems by using queues and events.

- [Build real-time monitoring and observable systems for media](../example-scenario/monitoring/monitoring-observable-systems-media.yml): Provide near-real-time monitoring and observability of systems and user device telemetry data by using Fabric Real-Time Intelligence.

### Integration guides

Review the following guides for cross-cutting integration and migration concerns:

- [Apache Kafka migration to Azure](../guide/hadoop/apache-kafka-migration.yml): Explore strategies for migrating Apache Kafka workloads to Azure, including Azure Event Hubs, Azure HDInsight, and Azure Kubernetes Service (AKS).

#### Event Hubs with Azure Functions

- [Overview](../serverless/event-hubs-functions/event-hubs-functions.md): Guidance for how to effectively integrate Azure Event Hubs with Azure Functions for performance, resiliency, security, and scale.

- [Performance and scale](../serverless/event-hubs-functions/performance-scale.md): Optimize scalability and performance when you use Azure Event Hubs and Azure Functions together.

- [Resilient design](../serverless/event-hubs-functions/resilient-design.md): Implement error handling, idempotency, and retry behavior for functions that Azure Event Hubs triggers.

- [Security](../serverless/event-hubs-functions/security.md): Apply fine-grained access control and network security for Azure Event Hubs and Azure Functions.

- [Observability](../serverless/event-hubs-functions/observability.md): Use Application Insights to monitor the behavior and health of Azure Event Hubs and Azure Functions solutions.

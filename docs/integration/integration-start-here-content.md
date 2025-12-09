The purpose of integration is to connect applications, data, services, and devices, often in complex ways. Through integration, organizations bring workflows together so they're consistent and scalable. Businesses connect applications, data, and processes in a fast, efficient, and automated manner.

Connections can run between on-premises, cloud, and edge systems. They can bring together enterprise, partner, third-party, and legacy technologies.

For data, integration provides solutions for gathering and processing information from multiple sources, in multiple formats.

To integrate applications, sometimes direct API calls are suitable. But sometimes technologies need to communicate asynchronously, through messaging or events. All integration processes need orchestration—a straightforward way to define and run the workflow's logic.

:::image type="content" source="./media/four-core-integration-technologies.png" alt-text="Diagram that shows four technologies that integration uses: orchestration, messaging, events, and A P Is." border="false":::

Azure provides a wide range of integration tools and capabilities, including these services:

- [Azure API Management][API Management ACOM page]. Securely publish your APIs for internal and external developers to use when connecting to back-end systems.
- [Azure Logic Apps][Azure Logic Apps ACOM page]. Create workflows to connect hundreds of services in the cloud and on-premises.
- [Azure Service Bus][Service Bus ACOM page]. Connect on-premises and cloud-based applications and services to implement highly secure messaging workflows.
- [Azure Event Grid][Event Grid ACOM page]. Connect supported Azure and third-party services while simplifying event-based app development.
- [Azure Functions][Azure Functions ACOM page]. Simplify complex orchestration problems with an event-driven serverless compute platform.
- [Azure Data Factory][Data Factory ACOM page]. Visually integrate data sources to accelerate data transformation and support enterprise workflows.

For information about more Azure integration services, see [Integration Services][Integration Services].

## Introduction to integration on Azure

If you're new to integration, the best place to start is Microsoft Learn. This free online platform offers videos, tutorials, and hands-on training for various products and services.

The following resources can help you learn the core concepts of integration:

- [Design data integration][Design data integration]
- [Integration design for Dynamics 365 solutions][Integration design for Dynamics 365 solutions]
- [Data integrations with Finance and Operations apps][Data integrations with Finance and Operations apps]
- [Examine business integration for IoT solutions][Examine business integration for IoT solutions]
- [Explore Event Grid integration][Explore Event Grid integration]
- [Architect API integration in Azure][Architect API integration in Azure]

## Path to production

After you've covered the fundamentals of integration, the next step is to design your solution.

### Design patterns

To explore patterns to incorporate into your design, consult resources in the following areas.

#### Hybrid systems

- [Cross-cloud scaling—on-premises data][Cross-cloud scaling - on-premises data]: See a hybrid app that spans Azure and Azure Stack Hub and uses a single on-premises data source, which is a compliance requirement for some organizations.

#### Microservice architectures

- [Transactional Outbox pattern with Azure Cosmos DB][Transactional Outbox pattern with Azure Cosmos DB]: Implement the Transactional Outbox pattern for reliable messaging between services.
- [Identify microservice boundaries][Identify microservice boundaries]: Derive microservices from a domain model when designing your application.
- [Design interservice communication for microservices][Designing interservice communication for microservices]: Use service meshes to make communication between microservices efficient and robust.

#### Mainframe migration

- [Integrate IBM mainframe and midrange message queues with Azure][Integrate IBM mainframe and midrange message queues with Azure]: Use a data-first technique that provides a way for IBM mainframe and midrange message queues to work with Azure services.

### Service selectors

The following resources can also help you design your application. Besides providing general information about an integration mechanism or process, each article helps you select an Azure service that best meets your need for that area.

- [Asynchronous messaging options][Asynchronous messaging options]: Understand various types of messages and the entities that participate in a messaging infrastructure.
- [Choose between virtual network peering and VPN gateways][Choose between virtual network peering and VPN gateways]: Explore two ways to connect virtual networks in Azure.
- [Extract, transform, and load (ETL)][Extract, transform, and load (ETL)]: Find out how to gather data that comes from multiple sources in multiple formats, and then transform it and store it.

### Specific implementations

To learn about scenario-specific architectures, see the solutions in the following areas.

#### E-commerce

- [Migrate a web app using Azure APIM][Migrate a web app using Azure APIM]: Modernize the legacy browser-based software stack of an e-commerce company.

#### Finance

- [Patterns and implementations for a banking cloud transformation][Patterns and implementations for a banking cloud transformation]: Apply patterns that implement a banking system cloud transformation.

## Best practices

These resources can help you spot-check your design against current recommended best practices:

- Azure Event Hubs and Functions can work together in a serverless architecture to process large volumes of data in near real time. For guidance on how to maximize the performance, resiliency, security, observability, and scale of this architecture, see these articles:

  - [Integrate Event Hubs with serverless functions on Azure][Integrate Event Hubs with serverless functions on Azure].
  - [Performance and scale for Event Hubs and Azure Functions][Performance and scale for Event Hubs and Azure Functions]
  - [Monitor Azure Functions and Event Hubs][Monitor Azure Functions and Event Hubs]

- Many integration solutions use Logic Apps to implement business processes. For best practices on building reliable architectures with this service, see [Business continuity and disaster recovery for Azure Logic Apps][Business continuity and disaster recovery for Azure Logic Apps].

- To check whether your Logic Apps implementation aligns with the Azure Security Benchmark version 2.0, see [Azure security baseline for Logic Apps][Azure security baseline for Logic Apps].

## Suite of baseline implementations

These reference architectures provide baseline implementations for various scenarios:

- [Data analysis workloads for regulated industries][Data analysis workloads for regulated industries]: Run data analytics workloads that take into account regulatory requirements.
- [Basic enterprise integration on Azure][Basic enterprise integration on Azure]: Orchestrate synchronous calls to enterprise back-end systems.
- [Enterprise integration using message broker and events](../example-scenario/integration/queues-events.yml): Orchestrate asynchronous calls to enterprise back-end systems by using queues and events.
- [Enterprise business intelligence][Enterprise business intelligence]: Move data from an on-premises SQL Server database into Azure Synapse Analytics and transform the data for analysis.
- [Web and mobile front ends][Web and mobile front ends]: Make third-party data available to web users.

## Operations guide

Deploying your workload is a significant milestone. After your integration processes are running, your focus can turn to operations. The following materials provide recommendations and reference information to help you continue to meet customer and regulatory demands:

- [About connectors in Azure Logic Apps][About connectors in Azure Logic Apps]: Learn how to take advantage of the hundreds of connectors that Logic Apps offers.
- [Azure Policy Regulatory Compliance controls for Azure Logic Apps][Azure Policy Regulatory Compliance controls for Azure Logic Apps]: Make Logic Apps compliant with regulatory standards.

## Stay current with integration

Azure integration receives improvements on an ongoing basis. To stay on top of recent developments, see [Azure updates](https://azure.microsoft.com/updates/?filters=%5B%22API+Management%22%2C%22Azure+Health+Data+Services%22%2C%22Azure+Web+PubSub%22%2C%22Event+Grid%22%2C%22Logic+Apps%22%2C%22Service+Bus%22%5D).

## Additional resources

The following resources provide practical recommendations and information for specific scenarios.

### Information for Amazon Web Services (AWS)

- [Messaging services on Azure and AWS][Messaging services on Azure and AWS]

### Information for Google Cloud professionals

- [Google Cloud to Azure services comparison—messaging and eventing][Google Cloud to Azure services comparison—Messaging and eventing]
- [Google Cloud to Azure services comparison—miscellaneous workflow][Google Cloud to Azure services comparison—Miscellaneous workflow]

[About connectors in Azure Logic Apps]: /azure/connectors/apis-list?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[API Management ACOM page]: https://azure.microsoft.com/services/api-management
[Architect API integration in Azure]: /training/paths/architect-api-integration
[Asynchronous messaging options]: ../guide/technology-choices/messaging.yml
[Azure Functions ACOM page]: https://azure.microsoft.com/services/functions
[Azure Logic Apps ACOM page]: https://azure.microsoft.com/services/logic-apps
[Azure Policy Regulatory Compliance controls for Azure Logic Apps]: /azure/logic-apps/security-controls-policy?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Azure security baseline for Logic Apps]: /security/benchmark/azure/baselines/logic-apps-security-baseline?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Basic enterprise integration on Azure]: ../reference-architectures/enterprise-integration/basic-enterprise-integration.yml
[Business continuity and disaster recovery for Azure Logic Apps]: /azure/logic-apps/business-continuity-disaster-recovery-guidance?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Choose between virtual network peering and VPN gateways]: ../reference-architectures/hybrid-networking/virtual-network-peering.yml
[Cross-cloud scaling - on-premises data]: ../example-scenario/hybrid/hybrid-cross-cloud-scale-on-premises-data.yml
[Data analysis workloads for regulated industries]: /azure/architecture/example-scenario/data/data-warehouse
[Data Factory ACOM page]: https://azure.microsoft.com/services/data-factory
[Data integrations with Finance and Operations apps]: /training/modules/data-integrations-finance-operations
[Design data integration]: /training/modules/design-data-integration
[Designing interservice communication for microservices]: ../microservices/design/interservice-communication.yml
[Enterprise business intelligence]: /azure/architecture/example-scenario/analytics/enterprise-bi-microsoft-fabric
[Event Grid ACOM page]: https://azure.microsoft.com/services/event-grid
[Examine business integration for IoT solutions]: /training/modules/examine-business-integration-for-iot-solutions
[Explore Event Grid integration]: /training/browse/?products=azure&terms=event%20grid
[Extract, transform, and load (ETL)]: ../data-guide/relational-data/etl.yml
[Google Cloud to Azure services comparison—Messaging and eventing]: ../gcp-professional/services.md#messaging-and-eventing
[Google Cloud to Azure services comparison—Miscellaneous workflow]: ../gcp-professional/services.md#miscellaneous
[Identify microservice boundaries]: ../microservices/model/microservice-boundaries.yml
[Integrate Event Hubs with serverless functions on Azure]: ../serverless/event-hubs-functions/event-hubs-functions.yml
[Integrate IBM mainframe and midrange message queues with Azure]: ../example-scenario/mainframe/integrate-ibm-message-queues-azure.yml
[Integration design for Dynamics 365 solutions]: /training/modules/integration
[Integration Services]: https://azure.microsoft.com/product-categories/integration
[Messaging services on Azure and AWS]: ../aws-professional/messaging.md
[Migrate a web app using Azure APIM]: ../example-scenario/apps/apim-api-scenario.yml
[Monitor Azure Functions and Event Hubs]: ../serverless/event-hubs-functions/observability.yml
[Patterns and implementations for a banking cloud transformation]: ../example-scenario/banking/patterns-and-implementations.yml
[Performance and scale for Event Hubs and Azure Functions]: ../serverless/event-hubs-functions/performance-scale.yml
[Service Bus ACOM page]: https://azure.microsoft.com/services/service-bus
[Transactional Outbox pattern with Azure Cosmos DB]: ../databases/guide/transactional-outbox-cosmos.yml
[Web and mobile front ends]: ../solution-ideas/articles/front-end.yml

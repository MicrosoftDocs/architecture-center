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

For information about more Azure networking services, see [Integration Services][Integration Services].

Apache®, Apache NiFi®, and NiFi® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.

## Introduction to integration on Azure

If you're new to integration, the best place to start is Microsoft Learn. This free online platform offers videos, tutorials, and hands-on training for various products and services.

The following resources can help you learn the core concepts of integration:

- [Design data integration][Design data integration]
- [Integration design for Dynamics 365 solutions][Integration design for Dynamics 365 solutions]
- [Data integrations with Finance and Operations apps][Data integrations with Finance and Operations apps]
- [Examine business integration for IoT solutions][Examine business integration for IoT solutions]
- [Integrate data with Azure Data Factory or Azure Synapse Pipeline][Integrate data with Azure Data Factory or Azure Synapse Pipeline]
- [Explore Event Grid integration][Explore Event Grid integration]
- [Architect API integration in Azure][Architect API integration in Azure]

## Path to production

After you've covered the fundamentals of integration, the next step is to design your solution.

### Design patterns

To explore patterns to incorporate into your design, consult resources in the following areas.

#### Hybrid systems

- [Tiered data for analytics][Tiered data for analytics]: Use Azure Stack Hub to collect, process, store, and distribute local and remote data.
- [Cross-cloud scaling—on-premises data][Cross-cloud scaling - on-premises data]: See a hybrid app that spans Azure and Azure Stack Hub and uses a single on-premises data source, which is a compliance requirement for some organizations.
- [Cross-cloud scaling with Traffic Manager][Cross-cloud scaling with Traffic Manager]: Use Azure Traffic Manager to extend a local app by connecting it to public cloud resources.

#### Microservice architectures

- [Transactional Outbox pattern with Azure Cosmos DB][Transactional Outbox pattern with Azure Cosmos DB]: Implement the Transactional Outbox pattern for reliable messaging between services.
- [On-premises data gateway for Azure Logic Apps][On-premises data gateway for Azure Logic Apps]: Connect Spring microservices that are written in Java to on-premises data.
- [Identify microservice boundaries][Identify microservice boundaries]: Derive microservices from a domain model when designing your application.
- [Design interservice communication for microservices][Designing interservice communication for microservices]: Use service meshes to make communication between microservices efficient and robust.

#### Serverless solutions

[Share location in real time using low-cost serverless Azure services][Sharing location in real time using low-cost serverless Azure services]: Set up a real-time messaging service to share live locations.

#### Mainframe migration

- [Integrate IBM mainframe and midrange message queues with Azure][Integrate IBM mainframe and midrange message queues with Azure]: Use a data-first technique that provides a way for IBM mainframe and midrange message queues to work with Azure services.
- [Rehost mainframe applications to Azure with Raincode compilers][Refactor mainframe applications to Azure with Raincode compilers]: Use the Raincode COBOL compiler to modernize mainframe legacy applications without changing code.
- [Mainframe access to Azure databases][Mainframe access to Azure databases]: Give IBM mainframe and midrange applications access to remote Azure databases.

### Service selectors

The following resources can also help you design your application. Besides providing general information about an integration mechanism or process, each article helps you select an Azure service that best meets your need for that area.

- [Asynchronous messaging options][Asynchronous messaging options]: Understand various types of messages and the entities that participate in a messaging infrastructure.
- [Choose between virtual network peering and VPN gateways][Choose between virtual network peering and VPN gateways]: Explore two ways to connect virtual networks in Azure.
- [Extract, transform, and load (ETL)][Extract, transform, and load (ETL)]: Find out how to gather data that comes from multiple sources in multiple formats, and then transform it and store it.

### Specific implementations

To learn about scenario-specific architectures, see the solutions in the following areas.

#### AI

- [Forecast energy and power demand with machine learning][Forecast energy and power demand with machine learning]: Forecast spikes in demand for energy products and services.
- [Remote patient monitoring solutions][Remote patient monitoring solutions]: Remotely monitor patients and analyze the large volume of data that medical devices generate.
- [Energy supply optimization][Energy supply optimization]: Accommodate external tools like Pyomo and CBC to solve large-scale numerical optimization problems.
- [AI-based footfall detection][AI-based footfall detection]: Analyze visitor traffic in retail stores by detecting footfalls.
- [Quality assurance][Quality assurance]: Implement quality assurance in an assembly line by using analytics and machine learning to predict problems.

#### E-commerce

- [Modernize .NET applications][Modernize .NET applications]: Migrate the legacy .NET applications of a retail business to Azure.
- [Custom business processes][Custom business processes]: Automate workflows and connect to legacy airline systems.
- [Migrate a web app using Azure APIM][Migrate a web app using Azure APIM]: Modernize the legacy browser-based software stack of an e-commerce company.

#### Finance

- [SWIFT Alliance Connect Virtual in Azure][SWIFT Alliance Connect Virtual in Azure]: See an article series on connecting to the SWIFT network by using the Alliance Connect Virtual component.
- [Patterns and implementations for a banking cloud transformation][Patterns and implementations for a banking cloud transformation]: Apply patterns that implement a banking system cloud transformation.

#### Internal business solutions

- [Elastic Workplace Search on Azure][Elastic Workplace Search on Azure]: Use Workplace Search to capture information from numerous heterogeneous sources and make it searchable.
- [Power Automate deployment at scale][Power Automate deployment at scale]: Use a hub-and-spoke model to deploy Power Automate parent and child flows.
- [Line-of-business extension][Line of business extension]: Retrieve data from legacy systems on an ongoing basis and make it available in Power BI.

#### Architecture, engineering, and construction (AEC)

[Azure digital twins builder][Azure digital twins builder]: Use building information modeling data from Autodesk Forge to automate the creation of an Azure Digital Twins foundational dataset.

#### Analytics

[Geospatial data processing and analytics][Geospatial data processing and analytics]: Make large volumes of geospatial data available for analytics.

#### Healthcare

[Health data consortium][Health data consortium]: Share data among members of a healthcare consortium.

#### High-performance computing

[HPC risk analysis template][HPC risk analysis template]: Use Azure CycleCloud in a risk analysis application to expand on-premises TIBCO GridServer compute to Azure.

## Best practices

These resources can help you spot-check your design against current recommended best practices:

- Azure Event Hubs and Functions can work together in a serverless architecture to process large volumes of data in near real time. For guidance on how to maximize the performance, resiliency, security, observability, and scale of this architecture, see these articles:

  - [Integrate Event Hubs with serverless functions on Azure][Integrate Event Hubs with serverless functions on Azure].
  - [Performance and scale for Event Hubs and Azure Functions][Performance and scale for Event Hubs and Azure Functions]
  - [Monitor Azure Functions and Event Hubs][Monitor Azure Functions and Event Hubs]

- Many integration solutions use Logic Apps to implement business processes. For best practices on building reliable architectures with this service, see [Business continuity and disaster recovery for Azure Logic Apps][Business continuity and disaster recovery for Azure Logic Apps].

- To check whether your Logic Apps implementation aligns with the Azure Security Benchmark version 2.0, see [Azure security baseline for Logic Apps][Azure security baseline for Logic Apps].

- For general information and guidelines on using Apache NiFi to process and distribute data on Azure, see [Apache NiFi on Azure][Apache NiFi on Azure].

## Suite of baseline implementations

These reference architectures provide baseline implementations for various scenarios:

- [Data analysis workloads for regulated industries][Data analysis workloads for regulated industries]: Run data analytics workloads that take into account regulatory requirements.
- [Access to Azure virtual networks from Azure Logic Apps using an integration service environment (ISE)][Access to Azure virtual networks from Azure Logic Apps using an integration service environment (ISE)]: Build logic apps that run in ISEs and access protected resources.
- [Publish internal APIs to external users][Publish internal APIs to external users]: Consolidate APIs and then expose them to external users.
- [Basic enterprise integration on Azure][Basic enterprise integration on Azure]: Orchestrate synchronous calls to enterprise back-end systems.
- [Enterprise integration using message broker and events](../example-scenario/integration/queues-events.yml): Orchestrate asynchronous calls to enterprise back-end systems by using queues and events.
- [Enterprise business intelligence][Enterprise business intelligence]: Move data from an on-premises SQL Server database into Azure Synapse Analytics and transform the data for analysis.
- [Web and mobile front ends][Web and mobile front ends]: Make third-party data available to web users.
- [Data integration with Logic Apps and SQL Server][Data integration with Logic Apps and SQL Server]: Automate data integration tasks that you perform in response to API calls.

## Operations guide

Deploying your workload is a significant milestone. After your integration processes are running, your focus can turn to operations. The following materials provide recommendations and reference information to help you continue to meet customer and regulatory demands:

- [Automated Jupyter Notebooks for diagnostics][Automated Jupyter Notebooks for diagnostics]: Write troubleshooting guides and diagnostic steps in Jupyter Notebooks that you can reuse, test, and automate.
- [About connectors in Azure Logic Apps][About connectors in Azure Logic Apps]: Learn how to take advantage of the hundreds of connectors that Logic Apps offers.
- [Azure Policy Regulatory Compliance controls for Azure Logic Apps][Azure Policy Regulatory Compliance controls for Azure Logic Apps]: Make Logic Apps compliant with regulatory standards.

## Stay current with integration

Azure integration receives improvements on an ongoing basis. To stay on top of recent developments, see [Azure updates][Azure updates].

## Additional resources

The following resources provide practical recommendations and information for specific scenarios.

### Information for Amazon Web Services (AWS)

- [Messaging services on Azure and AWS][Messaging services on Azure and AWS]
- [AWS to Azure services comparison—miscellaneous back-end process logic][AWS to Azure services comparison—Miscellaneous backend process logic]

### Information for Google Cloud professionals

- [Google Cloud to Azure services comparison—messaging and eventing][Google Cloud to Azure services comparison—Messaging and eventing]
- [Google Cloud to Azure services comparison—miscellaneous workflow][Google Cloud to Azure services comparison—Miscellaneous workflow]

[About connectors in Azure Logic Apps]: /azure/connectors/apis-list?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Access to Azure virtual networks from Azure Logic Apps using an integration service environment (ISE)]: /azure/logic-apps/connect-virtual-network-vnet-isolated-environment-overview?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[AI-based footfall detection]: ../solution-ideas/articles/hybrid-footfall-detection.yml
[Apache NiFi on Azure]: ../example-scenario/data/azure-nifi.yml
[API Management ACOM page]: https://azure.microsoft.com/services/api-management
[Architect API integration in Azure]: /training/paths/architect-api-integration
[Asynchronous messaging options]: ../guide/technology-choices/messaging.yml
[Automated Jupyter Notebooks for diagnostics]: ../example-scenario/data/automating-diagnostic-jupyter-notebook.yml
[AWS to Azure services comparison—Miscellaneous backend process logic]: ../aws-professional/services.md#miscellaneous
[Azure digital twins builder]: ../solution-ideas/articles/azure-digital-twins-builder.yml
[Azure Functions ACOM page]: https://azure.microsoft.com/services/functions
[Azure Logic Apps ACOM page]: https://azure.microsoft.com/services/logic-apps
[Azure Policy Regulatory Compliance controls for Azure Logic Apps]: /azure/logic-apps/security-controls-policy?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Azure security baseline for Logic Apps]: /security/benchmark/azure/baselines/logic-apps-security-baseline?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Azure updates]: https://azure.microsoft.com/updates/?category=integration
[Basic enterprise integration on Azure]: ../reference-architectures/enterprise-integration/basic-enterprise-integration.yml
[Business continuity and disaster recovery for Azure Logic Apps]: /azure/logic-apps/business-continuity-disaster-recovery-guidance?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json
[Choose between virtual network peering and VPN gateways]: ../reference-architectures/hybrid-networking/vnet-peering.yml
[Cross-cloud scaling - on-premises data]: ../example-scenario/hybrid/hybrid-cross-cloud-scale-on-premises-data.yml
[Cross-cloud scaling with Traffic Manager]: ../example-scenario/hybrid/hybrid-cross-cloud-scaling.yml
[Custom business processes]: ../solution-ideas/articles/custom-business-processes.yml
[Data analysis workloads for regulated industries]: /azure/architecture/example-scenario/data/data-warehouse
[Data Factory ACOM page]: https://azure.microsoft.com/services/data-factory
[Data integration with Logic Apps and SQL Server]: ../example-scenario/integration/logic-apps-data-integration.yml
[Data integrations with Finance and Operations apps]: /training/modules/data-integrations-finance-operations
[Design data integration]: /training/modules/design-data-integration
[Designing interservice communication for microservices]: ../microservices/design/interservice-communication.yml
[Elastic Workplace Search on Azure]: ../solution-ideas/articles/elastic-workplace-search.yml
[Energy supply optimization]: ../solution-ideas/articles/energy-supply-optimization.yml
[Enterprise business intelligence]: /azure/architecture/example-scenario/analytics/enterprise-bi-synapse
[Event Grid ACOM page]: https://azure.microsoft.com/services/event-grid
[Examine business integration for IoT solutions]: /training/modules/examine-business-integration-for-iot-solutions
[Explore Event Grid integration]: /training/modules/explore-event-grid-integration
[Extract, transform, and load (ETL)]: ../data-guide/relational-data/etl.yml
[Forecast energy and power demand with machine learning]: ../solution-ideas/articles/forecast-energy-power-demand.yml
[Geospatial data processing and analytics]: ../example-scenario/data/geospatial-data-processing-analytics-azure.yml
[Google Cloud to Azure services comparison—Messaging and eventing]: ../gcp-professional/services.md#messaging-and-eventing
[Google Cloud to Azure services comparison—Miscellaneous workflow]: ../gcp-professional/services.md#miscellaneous
[Health data consortium]: ../example-scenario/data/azure-health-data-consortium.yml
[HPC risk analysis template]: ../solution-ideas/articles/hpc-risk-analysis.yml
[Identify microservice boundaries]: ../microservices/model/microservice-boundaries.yml
[Integrate data with Azure Data Factory or Azure Synapse Pipeline]: /training/modules/data-integration-azure-data-factory
[Integrate Event Hubs with serverless functions on Azure]: ../serverless/event-hubs-functions/event-hubs-functions.yml
[Integrate IBM mainframe and midrange message queues with Azure]: ../example-scenario/mainframe/integrate-ibm-message-queues-azure.yml
[Integration design for Dynamics 365 solutions]: /training/modules/integration
[Integration Services]: https://azure.microsoft.com/product-categories/integration
[Line of business extension]: ../solution-ideas/articles/lob.yml
[Mainframe access to Azure databases]: ../solution-ideas/articles/mainframe-access-azure-databases.yml
[Messaging services on Azure and AWS]: ../aws-professional/messaging.md
[Migrate a web app using Azure APIM]: ../example-scenario/apps/apim-api-scenario.yml
[Modernize .NET applications]: ../solution-ideas/articles/net-app-modernization.yml
[Monitor Azure Functions and Event Hubs]: ../serverless/event-hubs-functions/observability.yml
[On-premises data gateway for Azure Logic Apps]: ../hybrid/gateway-logic-apps.yml
[Patterns and implementations for a banking cloud transformation]: ../example-scenario/banking/patterns-and-implementations.yml
[Performance and scale for Event Hubs and Azure Functions]: ../serverless/event-hubs-functions/performance-scale.yml
[Power Automate deployment at scale]: ../example-scenario/power-automate/power-automate.yml
[Publish internal APIs to external users]: ../example-scenario/apps/publish-internal-apis-externally.yml
[Quality assurance]: ../solution-ideas/articles/quality-assurance.yml
[Rehost mainframe applications to Azure with Raincode compilers]: ../reference-architectures/app-modernization/raincode-reference-architecture.yml
[Remote patient monitoring solutions]: /azure/architecture/example-scenario/digital-health/remote-patient-monitoring
[Service Bus ACOM page]: https://azure.microsoft.com/services/service-bus
[Sharing location in real time using low-cost serverless Azure services]: ../example-scenario/signalr/index.yml
[SWIFT Alliance Connect in Azure]: ../example-scenario/finance/swift-on-azure-srx.yml
[SWIFT Alliance Connect Virtual in Azure]: ../example-scenario/finance/swift-on-azure-vsrx.yml
[Tiered data for analytics]: ../example-scenario/hybrid/hybrid-tiered-data-analytics.yml
[Transactional Outbox pattern with Azure Cosmos DB]: ../best-practices/transactional-outbox-cosmos.yml
[Web and mobile front ends]: ../solution-ideas/articles/front-end.yml
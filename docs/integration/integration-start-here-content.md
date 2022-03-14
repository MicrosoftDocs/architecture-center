Integration is the process of connecting applications, data, services, and devices, often in complex ways. Through integration, organizations bring workflows together so they're consistent and scalable. Businesses connect applications, data, and processes in a fast, efficient, and automated manner.

Connections can run between on-premises, cloud, and edge systems. They can bring together enterprise, partner, third-party, and legacy technologies.

To integrate applications, sometimes direct API calls are suitable. But sometimes technologies need to communicate asynchronously, through messaging or events. All integration processes need orchestration—a straightforward way to define and run the workflow's logic.

For data, integration provides solutions for gathering and processing data from multiple sources, in multiple formats.

:::image type="content" source="./media/four-core-integration-technologies.png" alt-text="Diagram that shows four technologies that integration uses: orchestration, messaging, events, and A P Is." border="false":::

Azure provides a wide range of integration tools and capabilities including these services:

- [API Management][API Management ACOM page]. Securely publish your APIs for internal and external developers to use when connecting to backend systems.
- [Azure Logic Apps][Azure Logic Apps ACOM page]. Create workflows to connect hundreds of services in the cloud and on-premises.
- [Service Bus][Service Bus ACOM page]. Connect on-premises and cloud-based applications and services to implement highly secure messaging workflows.
- [Azure Event Grid][Event Grid ACOM page]. Connect supported Azure and third-party services by using a fully managed service that simplifies event-based app development.
- [Azure Functions][Azure Functions ACOM page]. Simplify complex orchestration problems with an event-driven serverless compute platform.
- [Azure Data Factory][Data Factory ACOM page]. Visually integrate data sources to accelerate data transformation and support enterprise workflows.

For information about more Azure networking services, see [Integration Services][Integration Services].

## Introduction to integration on Azure

If you're new to integration, the best place to start is with Microsoft Learn. This free online training platform offers videos, tutorials, and hands-on learning for various products and services.

The following resources can help you learn the core concepts of integration.

- [Design data integration][Design data integration]
- [Integration design for Dynamics 365 solutions][Integration design for Dynamics 365 solutions]
- [Data integrations with Finance and Operations apps][Data integrations with Finance and Operations apps]
- [Examine business integration for IoT solutions][Examine business integration for IoT solutions]
- [Integrate data with Azure Data Factory or Azure Synapse Pipeline][Integrate data with Azure Data Factory or Azure Synapse Pipeline]
- [Explore Event Grid integration][Explore Event Grid integration]
- [Architect API integration in Azure][Architect API integration in Azure]

## Path to production

After you've covered the fundamentals of integration, the next step is to develop your solution.

### Design patterns

To explore patterns to incorporate into your design, consult resources in the following areas.

#### Hybrid systems

- [Tiered data for analytics][Tiered data for analytics]: Use Azure Stack Hub for collecting, processing, storing, and distributing local and remote data.
- [Cross-cloud scaling - on-premises data][Cross-cloud scaling - on-premises data]: See a hybrid app that spans Azure and Azure Stack Hub and uses a single on-premises data source, which is a compliance requirement for some organizations.
- [Cross-cloud scaling with Traffic Manager][Cross-cloud scaling with Traffic Manager]: Use Azure Traffic Manager to extend an app that's located in a local cloud by connecting it to public cloud resources.

#### Microservices architectures

- [Transactional Outbox pattern with Azure Cosmos DB][Transactional Outbox pattern with Azure Cosmos DB]: Implement the Transactional Outbox pattern for reliable messaging between services and guaranteed delivery of events.
- [On-premises data gateway for Azure Logic Apps][On-premises data gateway for Azure Logic Apps]: Connect Spring microservices that are written in Java to on-premises data.

#### Serverless solutions

[Share location in real time using low-cost serverless Azure services][Sharing location in real time using low-cost serverless Azure services]: Set up a real-time messaging service to share live locations.

#### Mainframe migration

- [Integrate IBM mainframe and midrange message queues with Azure][Integrate IBM mainframe and midrange message queues with Azure]: Use a data-first technique that provides a way for IBM mainframe and midrange message queues to work with Azure services.
- [Refactor mainframe applications to Azure with Raincode compilers][Refactor mainframe applications to Azure with Raincode compilers]: Use the Raincode COBOL compiler to modernize mainframe legacy applications without changing code.
- [Mainframe access to Azure databases][Mainframe access to Azure databases]: Give IBM mainframe and midrange applications access to remote Azure databases.

### Specific implementations

To learn about scenario-specific architectures, see the solutions in the following areas.

#### AI

- [Forecast energy and power demand with machine learning][Forecast energy and power demand with machine learning]: Forecast spikes in demand for energy products and services.
- [Remote patient monitoring solutions][Remote patient monitoring solutions]: Remotely monitor patients and analyze the large volume of data that medical devices generate.
- [Energy supply optimization][Energy supply optimization]: Accommodate external tools like Pyomo and CBC to solve large-scale numerical optimization problems.

#### E-commerce

- [Modernize .NET applications][Modernize .NET applications]: Migrate legacy .NET applications to Azure.
- [Custom business processes][Custom business processes]: Automate workflows and connect to legacy airline systems.
- [Migrate a web app using Azure APIM][Migrate a web app using Azure APIM]: Modernize the legacy browser-based software stack of an e-commerce company.

#### Business

[Elastic Workplace Search on Azure][Elastic Workplace Search on Azure]: Use Workplace Search to capture information from numerous heterogeneous sources and makes it searchable.
[Power Automate deployment at scale][Power Automate deployment at scale]: Use a hub-and-spoke model to deploy Power Automate parent and child flows.
[Line of business extension][Line of business extension]: Retrieve data from legacy systems on a regular basis and make it available in Power BI.

#### Finance

- [SWIFT Alliance Connect in Azure][SWIFT Alliance Connect in Azure]: See an article series on connecting to the SWIFT network by using the Alliance Access and Alliance Messaging Hub interfaces.
- [SWIFT Alliance Connect Virtual in Azure][SWIFT Alliance Connect Virtual in Azure]: See an article series on connecting to the SWIFT network by using the Alliance Connect Virtual component.
- [Patterns and implementations for a banking cloud transformation][Patterns and implementations for a banking cloud transformation]: Apply patterns that implement a banking system cloud transformation.

#### Architecture, engineering, and construction (AEC)

[Azure digital twins builder][Azure digital twins builder]: Use building information modeling data from Autodesk Forge to automate the creation of an Azure Digital Twins foundational dataset.

#### Analytics

[Geospatial data processing and analytics][Geospatial data processing and analytics]: Make large volumes of geospatial data available for analytics.

#### Healthcare

[Health data consortium][Health data consortium]: Share data among members of a health care consortium.	

#### High-performance computing

[HPC risk analysis template][HPC risk analysis template]: Use Azure CycleCloud in a risk analysis application to expand on-premises TIBCO GridServer compute to Azure.

#### Manufacturing

[Quality assurance][Quality assurance]: Implement quality assurance in an assembly line by using analytics and machine learning to predict problems.

#### Retail

[AI-based footfall detection][AI-based footfall detection]: Use AI to analyze visitor traffic in retail stores by detecting footfalls.

## Best practices

- Azure Event Hubs and Azure Functions can work together in a serverless architecture to process large volumes of data in near real time. For guidance on how to maximize the performance, resiliency, security, observability, and scale of this architecture, see these articles:

  - [Integrate Event Hubs with serverless functions on Azure][Integrate Event Hubs with serverless functions on Azure].
  - [Performance and scale for Event Hubs and Azure Functions][Performance and scale for Event Hubs and Azure Functions]
  - [Monitor Azure Functions and Event Hubs][Monitor Azure Functions and Event Hubs]

- Many integration solutions use Azure Logic Apps to implement business processes. For best practices on building reliable architectures with this service, see [Business continuity and disaster recovery for Azure Logic Apps][Business continuity and disaster recovery for Azure Logic Apps]. 

- To check whether your Logic Apps implementation aligns with the Azure Security Benchmark version 2.0, see [Azure security baseline for Logic Apps][Azure security baseline for Logic Apps].

- For general information and guidelines on using Apache NiFi to process and distribute data on Azure, see [Apache NiFi on Azure][Apache NiFi on Azure].






## Suite of baseline implementations

These reference architectures provide baseline implementations for various scenarios:



## Stay current with identity

Azure AD receives improvements on an ongoing basis.

- To stay on top of recent developments, see .
- For a roadmap showing new key features and services, see .

## Additional resources

The following resources provide practical recommendations and information for specific scenarios.

### Azure AD in educational environments


### Information for Amazon Web Services (AWS) and Google Cloud professionals




[AI-based footfall detection]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/hybrid-footfall-detection
[Apache NiFi on Azure]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/data/azure-nifi
[API Management ACOM page]: https://azure.microsoft.com/en-us/services/api-management/
[Architect API integration in Azure]: https://docs.microsoft.com/en-us/learn/paths/architect-api-integration/
[Azure digital twins builder]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/azure-digital-twins-builder
[Azure Functions ACOM page]: https://azure.microsoft.com/en-us/services/functions/
[Azure Logic Apps ACOM page]: https://azure.microsoft.com/en-us/services/logic-apps/
[Azure security baseline for Logic Apps]: https://docs.microsoft.com/en-us/security/benchmark/azure/baselines/logic-apps-security-baseline?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json
[Business continuity and disaster recovery for Azure Logic Apps]: https://docs.microsoft.com/en-us/azure/logic-apps/business-continuity-disaster-recovery-guidance?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json
[Cross-cloud scaling - on-premises data]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/hybrid/hybrid-cross-cloud-scale-on-premises-data
[Cross-cloud scaling with Traffic Manager]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/hybrid/hybrid-cross-cloud-scaling
[Custom business processes]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/custom-business-processes
[Data Factory ACOM page]: https://azure.microsoft.com/en-us/services/data-factory/
[Data integrations with Finance and Operations apps]: https://docs.microsoft.com/en-us/learn/modules/data-integrations-finance-operations/
[Design data integration]: https://docs.microsoft.com/en-us/learn/modules/design-data-integration/
[Elastic Workplace Search on Azure]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/elastic-workplace-search
[Energy supply optimization]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/energy-supply-optimization
[Event Grid ACOM page]: https://azure.microsoft.com/en-us/services/event-grid/
[Examine business integration for IoT solutions]: https://docs.microsoft.com/en-us/learn/modules/examine-business-integration-for-iot-solutions/
[Explore Event Grid integration]: https://docs.microsoft.com/en-us/learn/modules/explore-event-grid-integration/
[Forecast energy and power demand with machine learning]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/forecast-energy-power-demand
[Geospatial data processing and analytics]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/data/geospatial-data-processing-analytics-azure
[Health data consortium]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/data/azure-health-data-consortium
[HPC risk analysis template]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/hpc-risk-analysis
[Integrate data with Azure Data Factory or Azure Synapse Pipeline]: https://docs.microsoft.com/en-us/learn/modules/data-integration-azure-data-factory/
[Integrate Event Hubs with serverless functions on Azure]: https://docs.microsoft.com/en-us/azure/architecture/serverless/event-hubs-functions/event-hubs-functions
[Integrate IBM mainframe and midrange message queues with Azure]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/mainframe/integrate-ibm-message-queues-azure
[Integration design for Dynamics 365 solutions]: https://docs.microsoft.com/en-us/learn/modules/integration/
[Integration Services]: https://azure.microsoft.com/en-us/product-categories/integration/
[Line of business extension]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/lob
[Mainframe access to Azure databases]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/mainframe-access-azure-databases
[Migrate a web app using Azure APIM]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/apps/apim-api-scenario
[Modernize .NET applications]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/net-app-modernization
[Monitor Azure Functions and Event Hubs]: https://docs.microsoft.com/en-us/azure/architecture/serverless/event-hubs-functions/observability
[On-premises data gateway for Azure Logic Apps]: https://docs.microsoft.com/en-us/azure/architecture/hybrid/gateway-logic-apps
[Patterns and implementations for a banking cloud transformation]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/banking/patterns-and-implementations
[Performance and scale for Event Hubs and Azure Functions]: https://docs.microsoft.com/en-us/azure/architecture/serverless/event-hubs-functions/performance-scale
[Power Automate deployment at scale]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/power-automate/power-automate
[Quality assurance]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/quality-assurance
[Refactor mainframe applications to Azure with Raincode compilers]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/app-modernization/raincode-reference-architecture
[Remote patient monitoring solutions]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/remote-patient-monitoring
[Service Bus ACOM page]: https://azure.microsoft.com/en-us/services/service-bus/
[Sharing location in real time using low-cost serverless Azure services]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/signalr/
[SWIFT Alliance Connect in Azure]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/finance/swift-on-azure-srx
[SWIFT Alliance Connect Virtual in Azure]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/finance/swift-on-azure-vsrx
[Tiered data for analytics]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/hybrid/hybrid-tiered-data-analytics
[Transactional Outbox pattern with Azure Cosmos DB]: https://docs.microsoft.com/en-us/azure/architecture/best-practices/transactional-outbox-cosmos







*Smart places* are physical environments that bring together connected devices and data sources. By using these environments, you can see and control:

- Products and systems
- Interior and exterior spaces
- Personal experiences with surroundings

Smart places can include buildings, college or corporate campuses, stadiums, and cities. They provide value by:

- Helping property owners, facility managers, and occupants operate and maintain spaces
- Making spaces more efficient, cost effective, comfortable, and productive

These environments work by digitally modeling the spaces and compiling relevant data. From that data, you can derive insights on how people, places, and devices are connected.

Add info as specified in template:

- A paragraph that describes what the solution does
- A paragraph that contains a brief description of the main Azure services that make up the solution.

At the core of the solution is Azure Digital Twins.

## Business outcomes

In this example solution, a large commercial real estate owner is
digitally transforming its office property. This improvement combines
legacy facilities-management data with new features and technologies including:

- Occupancy sensing
- Café queue optimization
- Parking
- Shuttle services

This effort requires integrating *brownfield*, or legacy, devices and modern IoT devices that monitor the physical space. The brownfield devices communicate through common building transports such as BACnet and Modbus.

The company's goals include:

- Optimizing energy usage by diagnosing faults and streamlining field service management. This optimization integrates the existing building management system with devices.

- Deriving new spatial insights and offering innovative occupant experiences by connecting modern devices.

- Developing a cohesive digital model of the environment by bringing together multiple sources of data. The model should expand data analysis opportunities.

- Creating a scalable solution that can collect and archive millions of data points.

- Building a solution that can easily add partner solutions. The solution should also incorporate partner data into the environment's digital twin.

## Potential use cases

This solution applies to many areas:

- Smart campuses
- Facilities management
- Smart offices
- Energy optimization

## Architecture

Add sentence introducing diagram:

- The boxes that contain multiple icons represent categories of
services. Those services work independently or together to provide functionality.
- Arrows between boxes represent communication between the corresponding areas.

[ ![A diagram illustrating the recommended architecture for Smart Places solutions](media/smart-places-diagram.svg) ](media/smart-places-diagram.svg#lightbox)

1. The environment uses any of these communication protocols:

   - Building Automation Controls network (BACnet)
   - Modbus
   - KNX
   - LonWorks

1. On-premises devices and systems send data and telemetry to the cloud. Data sources include:

   - Brownfield devices
   - Direct-connect sensors
   - Sensors that independent software vendors (ISVs) provide
   - Existing business systems

1. Devices, sensors, and actuators generate telemetry. Some devices interact directly with Azure IoT Hub. Other devices send data to IoT Hub through IoT Edge.

1. External, batch, or legacy systems send data to [Azure Data Factory](https://docs.microsoft.com/azure/data-factory/introduction). This static data typically originates in files and databases.

1. Business-to-business connectors translate vendor data and stream it to Azure Digital Twins.

1. Azure IoT Hub ingests device telemetry. IoT Hub also provides these services:

   - Device-level security
   - Device provisioning services
   - Device twins
   - Command and control services
   - Scale out capabilities

1. Azure Data Factory transforms semi-static data and transfers it to Azure Data Explorer.

1. Azure Functions receives the IoT Hub data and uses the [Digital Twins APIs to update Digital Twins][Ingest IoT Hub telemetry into Azure Digital Twins]. Azure Digital Twins holds the spatial graph of the buildings and environment. Azure Functions processes the data, performing fault detection and graph updates.

1. Various components maintain the DTDL model:

   - For model creation, these options are available:

     - Azure Digital Twins Explorer
     - ISV solutions
     - Custom-built tools
     - Text or code editors

   - Repositories store *ontologies*, or pre-existing model sets:

     - GitHub stores [RealEstateCore](https://github.com/Azure/opendigitaltwins-building), the Smart Cities ontology, and the [Energy Grid ontology](https://github.com/Azure/opendigitaltwins-energygrid/).
     - For custom ontologies, customized repositories and solution-specific repos in GitHub are available.

   - For loading models into Azure Digital Twins, these options exist:

     - [UploadModels][UploadModels], a tool for uploading DTDL ontologies
     - Samples in the [Digital Twins tools repository](https://github.com/Azure/opendigitaltwins-tools)

1. Digital Twins sends the data through Azure Event Grid to Azure Data Explorer. This analytics service functions as a historian by storing the solution's time series data.

1. Simulation engines and AI tools process the data. Examples include Azure Cognitive Services, AI models, and partner simulation services.

1. Azure Data Lake provides long-term storage for the data. Azure Synapse Analytics offers reporting and high-level analysis functionality.

1. For visualization tools and enterprise apps, the solution access layer components provide secure access to core system services:

   - Azure API Management offers functionality for normalizing, securing, and customizing APIs. This platform also enforces usage quotas and rate limits.
   - SignalR sends notifications to UIs when telemetry and data changes.
   - For applications that exchange data asynchronously or at volume, various components provide publishing and subscribing mechanisms:

     - IoT Hub
     - Service Bus queues
     - Event Hubs
     - Web hooks

1. Service applications collect data from the access control API layer. These applications then analyze and prepare the data for end-user applications. Microsoft tools like Power Apps, Power BI, and Azure Maps create reports and insights on data in the Azure data stores.

1. Enterprise applications use the prepared data. Examples include:

   - Dynamics 365 modules
   - ISV solutions
   - Teams apps
   - Field-optimized solutions such as mobile apps and wearables:

     - [HoloLens](https://docs.microsoft.com/dynamics365/mixed-reality/remote-assist/overview-hololens)
     - [RealWear HMT](https://docs.microsoft.com/MicrosoftTeams/flw-realwear)






### Components

The solution uses these components:

#### Core components

- [Azure IoT Hub][Azure IoT Hub] connects devices to Azure cloud resources. This managed service provides:

  - Device-level security
  - Device provisioning services
  - Device twins
  - Command and control services
  - Scale out capabilities

- [Azure IoT SDKs][Azure IoT SDKs] provide a way for devices to connect to IoT Hub. Devices that can use these kits include:

  - [Azure Sphere][Azure Sphere] devices
  - [Devices that run Azure RTOS][Overview of Azure IoT Device SDKs - Device capabilities]

- [Azure IoT Edge][Azure IoT Edge] runs cloud workloads on IoT Edge devices. Specifically, this central message hub can run [real-time analytics][What is Azure IoT Edge] through Machine Learning and Azure Stream Analytics. IoT Edge also functions as a [gateway][How an IoT Edge device can be used as a gateway] to IoT Hub for:

  - Devices with low-power requirements
  - Legacy devices
  - Constrained devices

- [Data Factory][Azure Data Factory] is an integration service that works with potentially large blocks of data from disparate data stores. You can use this platform to orchestrate and automate data transformation workflows. For instance, Data Factory can bridge the gap between semi-static stores and historian components like Azure Data Explorer.

- Business-to-business connectors translate and stream data bidirectionally between vendor components and Azure Digital Twins. A growing number of vendors are using [Digital Twins Definition Language (DTDL)][Digital Twins Definition Language (DTDL)] to create industry-standard ontologies. [RealEstateCore][RealEstateCore] provides an example. As a result, these integrations should become simpler over time.

- [Azure Digital Twins][Azure Digital Twins] stores digital representations of IoT devices and environments. This platform as a service (PaaS) models environments with [DTDL][Digital Twins Definition Language]. Azure Digital Twins offers a [REST API][Digital Twins REST API] for entering data. [SDKs support control and data plane operations in various languages][Azure Digital Twins APIs and SDKs]. You can build [ontologies][Digital Twins ontologies] by using DTDL. You can also start with an industry-supported model:

  - [RealEstateCore ontology][RealEstateCore]
  - [Smart Cities Ontology][Smart Cities Ontology]
  - [Energy Grid Ontology][Energy Grid Ontology]

- [Azure Digital Twins Explorer][Azure Digital Twins Explorer (preview)] is a developer tool that you can use to visualize and interacting with Digital Twins data, models, and graphs. This tool is currently in public preview.


- [Azure Functions][Azure Functions] is an event-driven serverless compute platform. With Functions, you can use triggers and bindings to integrate services at scale.

- [Azure Data Explorer][Azure Data Explorer] is a fast, fully managed data analytics service. You can use this service for real-time analysis on large volumes of data. Azure Data Explorer can handle diverse data streams from applications, websites, IoT devices, and other sources.

- [Azure Cognitive Services][Azure Cognitive Services] provides AI functionality. These services offer a set of pre-trained, neural network models for the cloud. The REST APIs and client library SDKs can help you build cognitive intelligence into apps. You can use Cognitive Services functionality:

  - In near real-time
  - At certain data thresholds
  - On demand
  - For complex jobs with long processing times

- [Machine Learning][Azure Machine Learning] is a cloud-based environment that helps you build, deploy, and manage predictive analytics solutions. With these models, you can forecast behavior, outcomes, and trends.

- [Azure API Management][Azure API Management] creates consistent, modern API gateways for back-end services. Besides accepting API calls and routing them to back ends, this platform also verifies keys, tokens, certificates, and other credentials. API Management also logs call metadata and enforces usage quotas and rate limits.

- [Service Bus][Service Bus] is a fully managed enterprise message broker. Service Bus supports message queues and publish-subscribe topics.

- [Event Hubs][Event Hubs] is a fully managed streaming platform for big data.

- [Azure SignalR Service][Azure SignalR Service] is an open-source software library that provides a way to [send notifications to web apps in real time][Integrate Azure Digital Twins with Azure SignalR Service].

- [Power Apps][Microsoft Power Apps on Azure] is a suite of apps, services, connectors, and a data platform. You can use Power Apps to transform manual business operations into digital, automated processes.

- [Power BI][Power BI] is a collection of software services and apps that display analytics information.




























- Azure Maps

- Azure Graph and check diagram for others

- Dynamics 365

- Teams apps

#### Support components

Or maybe call them shared services.

- [Azure Monitor](https://azure.microsoft.com/services/monitor/) can collect, analyze, visualize, and send notifications from the operational telemetry across the services.

- [Azure Defender for IoT](https://docs.microsoft.com/azure/defender-for-iot/overview) is a unified security service that works across Azure services to protect the solution.

- [Azure DevOps](https://azure.microsoft.com/services/devops/) is a set of services to manage the code, project, deployments that you need for a well-run development team. 

- [Azure Active Directory](https://azure.microsoft.com/services/active-directory/) is the core of Microsoft identity and security services, and is critical to integration with other cloud services, ISV solutions and on premises solutions.

- [Azure Key Vault](https://azure.microsoft.com/services/key-vault/) provides a safe store for keys and secrets across the full solution.

### Alternatives

-   [Azure
    CosmosDB](https://azure.microsoft.com/services/cosmos-db/) is
    another option that offers a fully managed NoSQL database service.
    It scales easily, and offers different interaction styles, including
    document database, graph database, SQL style query, Cassandra API
    and more. It also includes [a link for access from Azure
    Synapse](https://docs.microsoft.com/azure/cosmos-db/synapse-link),
    so all of these data services can be used in conjunction if
    requirements demand it.

-   [Azure Event
    Hubs](https://docs.microsoft.com/azure/iot-hub/iot-hub-compare-event-hubs)
    are also a viable ingestion service. Event Hubs differ from IoT Hub
    in that they facilitate one-way traffic, so they are great for
    ingestion but don't provide command and control communication.
    Event Hubs scale well and have strong security. Event Hubs differ
    from IoT Hub in that they do not offer device-level security, so
    are more appropriate when the solution has a high volume of
    messages from a low number of input devices.

## Considerations

The following considerations apply to this solution:

### Scalability considerations
Smart Places solutions range from relatively simple, low volume to sophisticated solutions with very high data volume (such as a solution that aggregates HVAC telemetry across a large campus.)   The core Azure services in this architecture are built to scale, but when they are integrated with one another to form a solution, the development team needs to ensure that they do not create unintentional choke points.  Avoiding these choke points is best addressed by having performance tests run at scheduled intervals to identify potential problems early in the development cycle.

### Flexibility considerations
Integration is mentioned in the article, but Smart Places solutions need to pay additional attention to building a solution that remains flexible.   Smart Places use cases are rapidly evolving, so new sensors, new data types, new Artificial Intelligence opportunities, and new visualization techniques will inevitably be required after initial deployment. The proposed architecture is loosely coupled which is a requirement for flexibility, the use of [industry standards for data ontology](https://docs.microsoft.com/azure/digital-twins/concepts-ontologies-adopt), will reduce the time to add new functionality and integrate new software, and the use of [Azure API Management](https://azure.microsoft.com/services/api-management/#overview) increases flexibility by providing a way to create multiple API styles and signatures to a single underlying API.

### Security considerations
Legacy building solutions often relied on a lack of external connectivity as the primary source of security.  In today’s world, even data that doesn’t identify people can still be used to draw conclusions about the business or the people in the building.   It is also common to use cameras to achieve use cases such as people counting, asset tracking, and security.  In these cases, be clear with specifics about where the images are processed, what gets saved and where, and ensure that the customer requirements for both privacy and use case are addressed. The bottom line on security for Smart Places solutions is that for all data, security must be top of mind throughout the data lifecycle.  Think about what is being collected, where it is being processed, where it will be stored, and what conclusions can be drawn from the collective set of data.

## Pricing
The [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) can be used to estimate costs for an IoT solution. Other considerations are described in the Cost section in [Microsoft Azure Well-Architected Framework](https://docs.microsoft.com/azure/architecture/framework/cost/overview).

The [Azure IoT Reference Architecture](https://docs.microsoft.com/azure/architecture/reference-architectures/iot/) also has a discussion about how to optimize cost for several services commonly used in IoT solutions.

## Next steps
-	Learn [how Microsoft is powering their buildings with Azure Digital Twins](https://www.microsoft.com/itshowcase/blog/powering-microsoft-smart-buildings-with-microsoft-azure-digital-twins/)
-	[Learn more about Azure Digital Twins](https://docs.microsoft.com/learn/paths/develop-azure-digital-twins/)
-	[Learn how EDGE Next leverages Azure Digital Twins in their Smart Buildings platform](https://www.youtube.com/watch?v=sll7tJG1CcI)
-	[Brookfield Properties: real estate innovation with WillowTwin built on Azure Digital Twins](https://customers.microsoft.com/story/1373881459232543118-vasakronan-smartspaces-azure-iot)
-	[Vasakronan: sustainability and carbon neutrality with Idun ProptechOS built on Azure Digital Twins](https://customers.microsoft.com/story/1373881459232543118-vasakronan-smartspaces-azure-iot)

## Related resources

- [Get started with Azure IoT solutions][Getting started with Azure IoT solutions]
- [IoT solutions conceptual overview][IoT solutions conceptual overview]
- [Vision with Azure IoT Edge][Vision with Azure IoT Edge]
- [Azure Industrial IoT analytics guidance][Azure Industrial IoT Analytics Guidance]
- [Choose an Internet of Things (IoT) solution in Azure][Choose an Internet of Things (IoT) solution in Azure]
- [End-to-end manufacturing using computer vision on the edge][End-to-end manufacturing using computer vision on the edge]
- [COVID-19 safe environments with IoT Edge monitoring and alerting][COVID-19 safe environments with IoT Edge monitoring and alerting]
- [IoT analytics with Azure Data Explorer][IoT analytics with Azure Data Explorer]
- [Cognizant Safe Buildings with IoT and Azure][Cognizant Safe Buildings with IoT and Azure]




[Azure API Management]: https://azure.microsoft.com/services/api-management
[Azure Cognitive Services]: https://azure.microsoft.com/en-us/services/cognitive-services/?azure-portal=true
[Azure Data Explorer]: https://docs.microsoft.com/azure/data-explorer/data-explorer-overview
[Azure Data Factory]: https://docs.microsoft.com/azure/data-factory/introduction
[Azure Digital Twins]: https://docs.microsoft.com/azure/digital-twins/overview
[Azure Digital Twins APIs and SDKs]: https://docs.microsoft.com/en-us/azure/digital-twins/concepts-apis-sdks
[Azure Digital Twins Explorer (preview)]: https://docs.microsoft.com/en-US/azure/digital-twins/concepts-azure-digital-twins-explorer
[Azure Functions]: https://docs.microsoft.com/azure/digital-twins/how-to-create-azure-function?tabs=cli
[Azure Industrial IoT Analytics Guidance]: https://docs.microsoft.com/en-us/azure/architecture/guide/iiot-guidance/iiot-architecture
[Azure IoT Edge]: https://azure.microsoft.com/services/iot-edge
[Azure IoT Hub]: https://azure.microsoft.com/services/iot-hub
[Azure IoT SDKs]: https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-sdks
[Azure Machine Learning]: https://azure.microsoft.com/en-us/services/machine-learning/
[Azure SignalR Service]: https://azure.microsoft.com/en-us/services/signalr-service/
[Azure Sphere]: https://azure.microsoft.com/en-us/services/azure-sphere/
[Choose an Internet of Things (IoT) solution in Azure]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/iot/iot-central-iot-hub-cheat-sheet
[Cognizant Safe Buildings with IoT and Azure]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/safe-buildings
[COVID-19 safe environments with IoT Edge monitoring and alerting]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/cctv-iot-edge-for-covid-19-safe-environment-and-mask-detection
[Digital Twins Definition Language]: https://github.com/Azure/opendigitaltwins-dtdl/blob/master/DTDL/v2/dtdlv2.md
[Digital Twins Definition Language (DTDL)]: https://docs.microsoft.com/azure/digital-twins/concepts-models
[Digital Twins ontologies]: https://docs.microsoft.com/azure/digital-twins/concepts-ontologies
[Digital Twins REST API]: https://docs.microsoft.com/rest/api/iothub/service/digitaltwin
[End-to-end manufacturing using computer vision on the edge]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/ai/end-to-end-smart-factory
[Energy Grid Ontology]: https://github.com/Azure/opendigitaltwins-energygrid/
[Event Hubs]: https://azure.microsoft.com/en-us/services/event-hubs
[Getting started with Azure IoT solutions]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/iot/iot-architecture-overview
[How an IoT Edge device can be used as a gateway]: https://docs.microsoft.com/azure/iot-edge/iot-edge-as-gateway?view=iotedge-2018-06
[Ingest IoT Hub telemetry into Azure Digital Twins]: https://docs.microsoft.com/en-us/azure/digital-twins/how-to-ingest-iot-hub-data?tabs=cli
[Integrate Azure Digital Twins with Azure SignalR Service]: https://docs.microsoft.com/en-us/azure/digital-twins/how-to-integrate-azure-signalr
[IoT analytics with Azure Data Explorer]: https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/iot-azure-data-explorer
[IoT solutions conceptual overview]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/iot/introduction-to-solutions
[Microsoft Power Apps on Azure]: https://azure.microsoft.com/en-us/products/powerapps/
[Overview of Azure IoT Device SDKs - Device capabilities]: https://docs.microsoft.com/en-us/azure/iot-develop/about-iot-sdks#device-capabilities
[Power BI]: https://powerbi.microsoft.com/en-us/
[RealEstateCore]: https://techcommunity.microsoft.com/t5/internet-of-things/realestatecore-a-smart-building-ontology-for-digital-twins-is/ba-p/1914794
[RealEstateCore ontology]: https://github.com/azure/opendigitaltwins-building
[Service Bus]: https://azure.microsoft.com/en-us/services/service-bus
[Smart Cities Ontology]: https://github.com/Azure/opendigitaltwins-smartcities
[UploadModels]: https://github.com/Azure/opendigitaltwins-tools/tree/master/ADTTools
[Vision with Azure IoT Edge]: https://docs.microsoft.com/en-us/azure/architecture/guide/iot-edge-vision
[What is Azure IoT Edge]: https://docs.microsoft.com/azure/iot-edge/about-iot-edge?view=iotedge-2018-06)




















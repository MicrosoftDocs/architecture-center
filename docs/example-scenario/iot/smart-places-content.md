This article outlines a solution for smart spaces. Azure Digital Twins forms the core of the architecture by modeling the environment. Azure IoT Hub, which is a managed IoT service, also plays a significant role, as does the analytics service Azure Data Explorer.

## Architecture

The following diagram shows the flow of data in this solution:

- The boxes that contain multiple icons represent categories of services. Within each category, services work independently or together to provide functionality.
- Arrows between boxes represent communication between the corresponding areas.

:::image type="content" source="./media/smart-places-diagram-new.png" alt-text="Diagram that illustrates the recommended architecture for a smart space solution." border="false" lightbox="./media/smart-places-diagram-new.png":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/smart-places-diagram.vsdx) of this architecture.*

### Dataflow

1. The environment can use these and other communication protocols:

   - Building Automation Controls network (BACnet)
   - Modbus
   - KNX
   - LonWorks

1. On-premises devices and systems send telemetry and other data to the cloud. Data sources include:

   - Brownfield devices
   - Direct-connect sensors
   - Sensors that independent software vendors (ISVs) provide
   - Existing business systems

1. Devices, sensors, and actuators generate telemetry. Some devices interact directly with IoT Hub. Other devices send data to IoT Hub through Azure IoT Edge.

1. External, batch, or legacy systems send data to Azure Data Factory. This static data typically originates in files and databases.

1. Business-to-business connectors translate vendor data and stream it to Azure Digital Twins.

1. IoT Hub ingests device telemetry. IoT Hub also provides these services:

   - Device-level security
   - Device provisioning services
   - Device twins
   - Command and control services
   - Scale-out capabilities

1. Data Factory transforms semi-static data and transfers it to Azure Data Explorer or to long-term storage.

1. Azure Functions receives the IoT Hub data and uses [Azure Digital Twins APIs][Ingest IoT Hub telemetry into Azure Digital Twins] to update Azure Digital Twins. Azure Digital Twins holds the spatial graph of the buildings and environment. Azure Digital Twins models the environment with [Digital Twins Definition Language (DTDL)][Digital Twins Definition Language]. [Azure Functions][Azure Functions] processes the data, performing fault detection and graph updates.

1. Various components create, store, and load DTDL models.

1. Azure Digital Twins sends the data through Azure Event Grid to Azure Data Explorer. This analytics service functions as a historian by storing the solution's time series data.

1. Simulation engines and AI tools process the data. Examples include Azure Cognitive Services, AI models, and partner simulation services.

1. Azure Data Lake provides long-term storage for the data. Azure Synapse Analytics analyzes and reports on the data.

1. For visualization tools and enterprise apps, the solution access layer provides secure access to core system services:

   - Azure API Management offers functionality for normalizing, securing, and customizing APIs. This platform also enforces usage quotas and rate limits.
   - Azure SignalR Service sends notifications to UIs when telemetry and data changes.
   - For applications that exchange data asynchronously or at volume, various components provide publishing and subscribing mechanisms:

     - IoT Hub
     - Azure Service Bus queues
     - Azure Event Hubs
     - Web hooks

1. Service applications collect data from the access control API layer. These applications then analyze and prepare the data for end-user applications. Microsoft tools like Power Apps, Power BI, and Azure Maps create reports and insights on data in the Azure data stores.

1. Enterprise applications use the prepared data. Examples include:

   - Dynamics 365 modules.
   - ISV solutions.
   - Microsoft Teams apps.
   - Field-optimized solutions such as mobile apps and wearables:

     - [HoloLens][HoloLens]
     - [RealWear HMT][RealWear HMT]

### Components

The solution uses these components:

#### Core components

- [IoT Hub][Azure IoT Hub] connects devices to Azure cloud resources. This managed service provides:

  - Device-level security.
  - Device provisioning services.
  - Device twins.
  - Command and control services.
  - Scale-out capabilities.

- [Azure IoT SDKs][Azure IoT SDKs] provide the recommended way for devices to connect to IoT Hub. Devices that can use these kits include:

  - [Azure Sphere](https://azure.microsoft.com/services/azure-sphere) devices.
  - Devices that run Azure RTOS.

- [IoT Edge][Azure IoT Edge] runs cloud workloads on IoT Edge devices. Specifically, this central message hub can run [real-time analytics][What is Azure IoT Edge] through Azure Machine Learning and Azure Stream Analytics. IoT Edge also functions as a [gateway][How an IoT Edge device can be used as a gateway] to IoT Hub for:

  - Devices with low-power requirements.
  - Legacy devices.
  - Constrained devices.

- [Data Factory][Azure Data Factory] is an integration service that works with potentially large blocks of data from disparate data stores. You can use this platform to orchestrate and automate data transformation workflows. For instance, Data Factory can bridge the gap between semi-static stores and historian components like Azure Data Explorer.

- Business-to-business connectors translate and stream data bidirectionally between vendor components and Azure Digital Twins. A growing number of vendors use [DTDL][Digital Twins Definition Language (DTDL)] to create industry-standard models. [RealEstateCore][RealEstateCore] provides an example. As a result, these integrations are expected to become simpler over time.

- [Azure Digital Twins][Azure Digital Twins] stores digital representations of IoT devices and environments. You can use this data for data propagation or real-time analysis. Internally, Azure Digital Twins:

  - Models environments with [DTDL][Digital Twins Definition Language].
  - Offers a [REST API][Digital Twins REST API] for entering data.
  - Provides [SDKs that support control and data plane operations for various languages][Azure Digital Twins APIs and SDKs].

  You can build [ontologies][Digital Twins ontologies], or pre-existing model sets, by using DTDL. You can also start with an industry-supported model:

  - [RealEstateCore ontology][RealEstateCore]
  - [Smart Cities ontology][Smart Cities Ontology]
  - [Energy Grid ontology][Energy Grid Ontology]

- [Azure Digital Twins Explorer][Azure Digital Twins Explorer (preview)] is a developer tool that you can use to visualize and interact with Azure Digital Twins data, models, and graphs. This tool is currently in public preview.

- Model management components maintain the DTDL model:

  - For model creation, these options are available:

    - Azure Digital Twins Explorer
    - ISV solutions
    - Custom-built tools
    - Text or code editors

  - Repositories store ontologies:

    - GitHub stores [RealEstateCore][RealEstateCore ontology], the [Smart Cities ontology][Smart Cities Ontology], and the [Energy Grid ontology][Energy Grid ontology].
    - For custom ontologies, customized repositories and solution-specific repos in GitHub are available.

  - For loading models into Azure Digital Twins, these options exist:

    - [UploadModels][UploadModels], a tool for uploading DTDL ontologies
    - Samples in the [Azure Digital Twins tools repository][Azure Digital Twins tools repository]

- [Azure Functions](https://azure.microsoft.com/services/functions) is an event-driven serverless compute platform. With Functions, you can use triggers and bindings to integrate services at scale.

- [Azure Data Explorer][Azure Data Explorer] is a fast, fully managed data analytics service. You can use this service for real-time analysis on large volumes of data. Azure Data Explorer can handle diverse data streams from applications, websites, IoT devices, and other sources.

- [Azure Cognitive Services][Azure Cognitive Services] provides AI functionality. These services offer a set of pre-trained, neural network models for the cloud. The REST APIs and client library SDKs can help you build cognitive intelligence into apps. You can use Cognitive Services functionality:

  - In near real time.
  - At certain data thresholds.
  - On demand.
  - For complex jobs with long processing times.

- [Azure Machine Learning][Azure Machine Learning] is a cloud-based environment that helps you build, deploy, and manage predictive analytics solutions. With these models, you can forecast behavior, outcomes, and trends.

- [Azure Data Lake][Data Lake] stores a large amount of data in its native, raw format. The data typically comes from multiple, heterogeneous sources and may be structured, semi-structured, or unstructured.

- [Azure Synapse Analytics][Azure Synapse Analytics] is an analytics service for data warehouses and big data systems. This service integrates with Power BI, Machine Learning, and other Azure services.

- [Azure API Management][Azure API Management] creates consistent, modern API gateways for back-end services. Besides accepting API calls and routing them to back ends, this platform also verifies keys, tokens, certificates, and other credentials. API Management also logs call metadata and enforces usage quotas and rate limits.

- [Azure Service Bus][Service Bus] is a fully managed enterprise message broker. Service Bus supports message queues and publish-subscribe topics.

- [Azure Event Hubs][Event Hubs] is a fully managed streaming platform for big data.

- [Azure SignalR Service][Azure SignalR Service] is an open-source software library that provides a way to [send notifications to web apps in real time][Integrate Azure Digital Twins with Azure SignalR Service].

#### Service applications

- [Azure Logic Apps][Azure Logic Apps] automates workflows by connecting apps and data across clouds.

- [Azure Maps][Azure Maps] offers geospatial APIs for adding maps, spatial analytics, and mobility solutions to apps.

- [Microsoft Graph][Microsoft Graph] provides tools for accessing data in Microsoft 365, Windows 10, and Enterprise Mobility + Security.

- [Power Platform][Power Platform] is a collection of products and services that provide low-code tools for creating efficient and flexible solutions:

  - [Power Apps][Microsoft Power Apps on Azure] is a suite of apps, services, connectors, and a data platform. You can use Power Apps to transform manual business operations into digital, automated processes.
  - [Power BI][Power BI] is a collection of software services and apps that display analytics information.
  - [Power Automate][Power Automate] streamlines repetitive tasks and paperless processes.
  - [Power Virtual Agents][Power Virtual Agents] provides no-code chatbots to meet customer and employee needs at scale.

#### Enterprise applications

- [Dynamics 365][Dynamics 365] is a portfolio of applications for managing business operations.

- [Microsoft Teams][Microsoft Teams] provides services for meeting, messaging, calling, and collaborating.

- [Azure App Service][App Service overview] and its Web Apps feature provide a framework for building, deploying, and scaling web apps.

#### Shared support components

These services provide support for components in all areas of the solution:

- [Azure Monitor][Azure Monitor] collects and analyzes app telemetry, such as performance metrics and activity logs. This service notifies apps and personnel about irregular conditions.

- [Microsoft Defender for IoT](https://azure.microsoft.com/services/iot-defender) is a unified security service that protects IoT systems by identifying vulnerabilities and threats.

- [Azure DevOps Services][Azure DevOps] provides services, tools, and environments for managing coding projects and deployments.

- [Azure Active Directory (Azure AD)][Azure Active Directory] is a cloud-based identity service that controls access to Azure and other cloud apps, including ISV solutions and on-premises solutions.

- [Azure Key Vault][Azure Key Vault] securely stores and controls access to a system's secrets, such as API keys, passwords, certificates, and cryptographic keys.

### Alternatives

- [Azure Cosmos DB][Azure Cosmos DB] is another option for data storage. This fully managed NoSQL database service scales easily. Azure Cosmos DB offers various ways to access data, including:

  - Document databases.
  - Graph databases.
  - SQL-style queries.
  - An Azure Cosmos DB for Apache Cassandra.

  [Azure Synapse Link for Azure Cosmos DB][What is Azure Synapse Link for Azure Cosmos DB?] provides a way to run analytics on Azure Cosmos DB data by using Azure Synapse Analytics. As a result, you can combine various data services in solutions that use Azure Cosmos DB.

- Event Hubs can also provide an ingestion service that's scalable and secure. Unlike IoT Hub, which supports bidirectional communication with devices, Event Hubs supports one-way traffic. As a result, you can't use Event Hubs to send commands and policies back to devices. Event Hubs also doesn't offer device-level security. But Event Hubs is appropriate for environments with a high volume of messages from a low number of input devices.

## Solution details

*Smart places* are physical environments that bring together connected devices and data sources. By using these environments, you can see and control:

- Products and systems.
- Interior and exterior spaces.
- Personal experiences with surroundings.

Smart places can include buildings, college campuses, corporate campuses, stadiums, and cities. These environments provide value by helping property owners, facility managers, and occupants operate and maintain sites. Smart places also make spaces more efficient, cost effective, comfortable, and productive.

Smart spaces digitally model spaces and compile relevant data. From that data, you can derive insights on how people, places, and devices are connected.

### Potential use cases

This solution applies to many areas:

- Smart campuses (education industry)
- Facilities management (real estate)
- Smart stadiums (sports industry)
- Smart offices
- Energy optimization

### Business outcomes

In this example solution, a large commercial real estate owner is digitally transforming an office property. This improvement combines legacy facilities-management data with new features and technologies including:

- Occupancy sensing.
- Cafe queue optimization.
- Parking.
- Shuttle services.

This effort requires integrating brownfield devices and modern Internet of Things (IoT) devices that monitor the physical space. The brownfield devices communicate through common building transports such as BACnet and Modbus.

The company's goals include:

- Optimizing energy usage by diagnosing faults and streamlining field service management. This optimization integrates the existing building management system with devices.

- Deriving new spatial insights and offering innovative occupant experiences by connecting modern devices.

- Developing a cohesive digital model of the environment by bringing together multiple sources of data. The model should expand data analysis opportunities.

- Creating a scalable solution that can collect and archive millions of data points.

- Building a solution that can easily add partner solutions. The solution should also incorporate partner data into the environment's digital twin.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

The following considerations apply to this solution.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

#### Scalability

Solutions for smart places solutions can be relatively simple, low-volume implementations. They can also be sophisticated implementations that handle a high volume of data. A solution that aggregates heating, ventilation, and air conditioning (HVAC) telemetry across a large campus is an example of a high-volume implementation.

The core Azure services in this solution are scalable by design and well suited for complex solutions. But when you combine these services, ensure that they don't create choke points. Early in the development cycle, run performance tests at scheduled intervals to identify potential problems.

#### Flexibility

Design your smart space to be well integrated but also flexible. Smart places use cases are rapidly evolving. At some point after you deploy your solution, you'll need to add new sensors, data types, AI functionality, and visualization techniques. To increase flexibility:

- Choose a loosely coupled solution like the proposed architecture.
- Use [industry standards for data ontology][Adopting an industry ontology]. This approach helps reduce the time needed to add new functionality and integrate new software.
- Use [API Management][API Management - overview]. This platform provides a way to create multiple API styles and signatures for a single underlying API.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Legacy building solutions often rely on a lack of external connectivity as their primary source of security. But even data that doesn't identify people can provide information about a business or the people in a building. For instance, organizations use cameras to count people, track assets, and provide security data.

Be careful where you process and save images. Ensure that you address all customer requirements, including privacy issues. Make security a priority throughout the data life cycle of your smart space solution. Specifically, be aware of what data you collect, where you process and store it, and what conclusions you draw from it.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Use the [Azure pricing calculator][Azure pricing calculator] to estimate the cost of an IoT solution.

- For other cost considerations, see [Principles of cost optimization][Principles of cost optimization] in the Microsoft Azure Well-Architected Framework documentation.
- For a discussion about optimizing the cost of services that IoT solutions commonly use, see [Azure IoT Reference Architecture][Azure IoT reference architecture].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:
- [Mark Kottke](https://www.linkedin.com/in/markkottke) | Senior Architect

Other contributor:
- [Matthew Cosner](https://www.linkedin.com/in/matthew-cosner-447843225) | Principal Software Engineering Manager

## Next steps

- [Powering Microsoft smart buildings with Microsoft Azure Digital Twins][Powering Microsoft smart buildings with Microsoft Azure Digital Twins]
- [Develop with Azure Digital Twins][Develop with Azure Digital Twins]
- [Brookfield sets a new standard for innovation in real estate with WillowTwin and Azure Digital Twins][Brookfield sets a new standard for innovation in real estate with WillowTwin and Azure Digital Twins]
- [Global sustainability leader targets new heights of carbon neutrality with Azure Digital Twins][Global sustainability leader targets new heights of carbon neutrality with Azure Digital Twins]

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

[Adopting an industry ontology]: /azure/digital-twins/concepts-ontologies-adopt
[API Management - overview]: https://azure.microsoft.com/services/api-management/#overview
[App Service overview]: https://azure.microsoft.com/services/app-service
[Azure Active Directory]: https://azure.microsoft.com/services/active-directory
[Azure API Management]: https://azure.microsoft.com/services/api-management
[Azure Cognitive Services]: https://azure.microsoft.com/services/cognitive-services/?azure-portal=true
[Azure Cosmos DB]: https://azure.microsoft.com/services/cosmos-db
[Azure Data Explorer]: https://azure.microsoft.com/services/data-explorer
[Azure Data Factory]: https://azure.microsoft.com/services/data-factory
[Azure DevOps]: https://azure.microsoft.com/services/devops
[Azure Digital Twins]: https://azure.microsoft.com/services/digital-twins
[Azure Digital Twins APIs and SDKs]: /azure/digital-twins/concepts-apis-sdks
[Azure Digital Twins Explorer (preview)]: /azure/digital-twins/concepts-azure-digital-twins-explorer
[Azure Digital Twins tools repository]: https://github.com/Azure/opendigitaltwins-tools
[Azure Functions]: /azure/digital-twins/how-to-create-azure-function?tabs=cli
[Azure Industrial IoT Analytics Guidance]: ../../guide/iiot-guidance/iiot-architecture.yml
[Azure IoT Edge]: https://azure.microsoft.com/services/iot-edge
[Azure IoT Hub]: https://azure.microsoft.com/services/iot-hub
[Azure IoT reference architecture]: ../../reference-architectures/iot.yml
[Azure IoT SDKs]: /azure/iot-hub/iot-hub-devguide-sdks
[Azure Key Vault]: https://azure.microsoft.com/services/key-vault
[Azure Logic Apps]: https://azure.microsoft.com/services/logic-apps
[Azure Machine Learning]: https://azure.microsoft.com/services/machine-learning
[Azure Maps]: https://azure.microsoft.com/services/azure-maps
[Azure Monitor]: https://azure.microsoft.com/services/monitor
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator
[Azure SignalR Service]: https://azure.microsoft.com/services/signalr-service
[Azure Sphere]: https://azure.microsoft.com/services/azure-sphere/
[Azure Synapse Analytics]: https://azure.microsoft.com/services/synapse-analytics
[Brookfield sets a new standard for innovation in real estate with WillowTwin and Azure Digital Twins]: https://customers.microsoft.com/story/855907-brookfield-properties-professional-services-azure
[Choose an Internet of Things (IoT) solution in Azure]: ./iot-central-iot-hub-cheat-sheet.yml
[Cognizant Safe Buildings with IoT and Azure]: ../../solution-ideas/articles/safe-buildings.yml
[COVID-19 safe environments with IoT Edge monitoring and alerting]: ../../solution-ideas/articles/cctv-iot-edge-for-covid-19-safe-environment-and-mask-detection.yml
[Data Lake]: https://azure.microsoft.com/solutions/data-lake
[Develop with Azure Digital Twins]: /training/paths/develop-azure-digital-twins
[Digital Twins Definition Language]: https://github.com/Azure/opendigitaltwins-dtdl/blob/master/DTDL/v3/DTDL.v3.md
[Digital Twins Definition Language (DTDL)]: /azure/digital-twins/concepts-models
[Digital Twins ontologies]: /azure/digital-twins/concepts-ontologies
[Digital Twins REST API]: /rest/api/iothub/service/digitaltwin
[Dynamics 365]: https://dynamics.microsoft.com
[End-to-end manufacturing using computer vision on the edge]: ../../reference-architectures/ai/end-to-end-smart-factory.yml
[Energy Grid Ontology]: https://github.com/Azure/opendigitaltwins-energygrid
[Event Hubs]: https://azure.microsoft.com/services/event-hubs
[Getting started with Azure IoT solutions]: ../../reference-architectures/iot/iot-architecture-overview.md
[Global sustainability leader targets new heights of carbon neutrality with Azure Digital Twins]: https://customers.microsoft.com/story/1373881459232543118-vasakronan-smartspaces-azure-iot
[HoloLens]: /dynamics365/mixed-reality/remote-assist/overview-hololens
[How an IoT Edge device can be used as a gateway]: /azure/iot-edge/iot-edge-as-gateway?view=iotedge-2018-06
[Ingest IoT Hub telemetry into Azure Digital Twins]: /azure/digital-twins/how-to-ingest-iot-hub-data?tabs=cli
[Integrate Azure Digital Twins with Azure SignalR Service]: /azure/digital-twins/how-to-integrate-azure-signalr
[IoT analytics with Azure Data Explorer]: ../../solution-ideas/articles/iot-azure-data-explorer.yml
[IoT solutions conceptual overview]: ../../example-scenario/iot/introduction-to-solutions.yml
[Microsoft Graph]: https://developer.microsoft.com/graph
[Microsoft Power Apps on Azure]: https://powerapps.microsoft.com
[Microsoft Teams]: https://www.microsoft.com/microsoft-teams/group-chat-software
[Overview of Azure IoT Device SDKs - Device capabilities]: /azure/iot-develop/about-iot-sdks#device-capabilities
[Power Automate]: https://flow.microsoft.com
[Power BI]: https://powerbi.microsoft.com
[Power Platform]: https://powerplatform.microsoft.com
[Power Virtual Agents]: https://powervirtualagents.microsoft.com
[Powering Microsoft smart buildings with Microsoft Azure Digital Twins]: https://www.microsoft.com/insidetrack/blog/powering-microsoft-smart-buildings-with-microsoft-azure-digital-twins/
[Principles of cost optimization]: /azure/architecture/framework/cost/overview
[RealEstateCore]: https://techcommunity.microsoft.com/t5/internet-of-things/realestatecore-a-smart-building-ontology-for-digital-twins-is/ba-p/1914794
[RealEstateCore ontology]: https://github.com/azure/opendigitaltwins-building
[RealWear HMT]: /MicrosoftTeams/flw-realwear
[Service Bus]: https://azure.microsoft.com/services/service-bus
[Smart Cities Ontology]: https://github.com/Azure/opendigitaltwins-smartcities
[SVG version of architecture diagram]: ./media/smart-places-diagram.svg
[UploadModels]: https://github.com/Azure/opendigitaltwins-tools/tree/master/ADTTools
[Vision with Azure IoT Edge]: ../../guide/iot-edge-vision/index.md
[What is Azure IoT Edge]: /azure/iot-edge/about-iot-edge?view=iotedge-2018-06
[What is Azure Synapse Link for Azure Cosmos DB?]: /azure/cosmos-db/synapse-link

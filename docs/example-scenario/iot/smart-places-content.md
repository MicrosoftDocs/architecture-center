Smart Places are physical environments, which bring together connected
devices and data sources to provide visibility into, and control of
products and systems, interior and exterior spaces, and personal
experiences with one's surroundings. These connected environments could
be a building, college or corporate campus, stadium, or even a city.
Smart Places solutions provide value to customers by helping property
owners, facility managers, and occupants operate and maintain their
space, making the space more efficient, cost effective, comfortable, and
productive. The catalyst to achieving value in these types of solutions
is to digitally model the space, bring the relevant data together, and
relate that data accurately to derive insights from the connections
between people, places, and devices.

## Business outcomes

In this example solution, a large commercial real estate owner wants to
digitally transform its commercial office property.  This improvement would bring together
legacy facilities management data with new features and technologies,
such as occupancy sensing, café queue optimization, parking,
shuttles, etc. This effort requires integrating with brownfield devices
communicating through common building transports such as BACnet
or Modbus, and modern IoT devices that monitor the physical
space. The company's goals include:

-   Optimize energy usage by diagnosing faults and streamlining field
    service management.  This optimization would integrate the existing building management system with devices.

-   Derive new spatial insights and offer innovative occupant
    experiences by connecting modern devices.

-   Bring together multiple sources of data into a cohesive
    digital model of the environment, expanding data analysis
    opportunities.

-   Create a scalable solution that will handle the demands of
    collecting and archiving millions of data points.

-   Build a solution that can easily add partner solutions in the future
    and bring that data into the same digital twin of the environment.

## Potential use cases

The reference architecture in this article is intended to show a viable
approach and best practices in a Smart Places solution that uses
current Azure services and design patterns. This solution could be applied to the following use cases:

- Smart campus
- Facilities management
- Smart office
- Energy optimization
- Many other use cases

## Architecture

The rectangular boxes containing multiple icons represent categories of
services that could either independently or together provide that
portion of the solution's functionality. When the rectangular boxes are
connected with an arrow, that solution area will communicate
with the solution area that is connected to. 

[ ![A diagram illustrating the recommended architecture for a Smart Places solution](media/smart-places.svg) ](media/smart-places.svg#lightbox)

The data flows through the solution as follows:

-   Brownfield devices, direct connect sensors, ISV-provided sensors,
    and existing business systems produce data and telemetry on premises
    and send data to the cloud.

-   Telemetry and commands flow through IoT Hub.

-   On premises business systems or databases send data through Azure
    Data Factory.

-   Telemetry is sent through Azure Digital Twins and placed in the
    spatial graph.  This data can be used for
    data propagation or real-time analysis.

-   Data may also be sent to simulation engines or AI tools.

-   Data is stored in long-term storage for reporting and higher-level
    analysis.

-   The solution access layer exists to provide a cohesive, secure
    interface for the core system to visualization tools and enterprise
    apps.

### Components

1.  **Protocols** - This section represents communication protocols
    typically found in a smart building environment. A given solution may have none, any, or all of these protocols in use.

2.  **Devices/Edge** - Telemetry can be generated from devices, sensors, actuators, etc. Within this subsection,
    there are multiple possibilities that depend on whether it is a
    legacy environment, the capabilities of devices, services offered by
    vendors, and the requirements of the solution:

    -   **Devices** This box shows devices that are capable of
        interacting directly with Azure IoT Hub. Microsoft recommends
        using the [Azure IoT SDKs](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-sdks) for devices to communicate with Azure IoT Hub, though this is not required.
        Devices may include those which use Azure RTOS or Azure Sphere devices.

    -   **IoT Edge/Gateway** - This box shows the use of IoT Edge either
        directly or as a
        [gateway](https://docs.microsoft.com/azure/iot-edge/iot-edge-as-gateway?view=iotedge-2018-06).
        When a solution has devices with low-power requirements or legacy/constrained devices deployed as part of their solution,
        using IoT Edge as a gateway is the recommended approach.
        Additionally, for higher capability devices, they may choose to
        use IoT Edge directly to take advantage of the [advanced
        functionality that IoT Edge
        enables](https://docs.microsoft.com/azure/iot-edge/about-iot-edge?view=iotedge-2018-06),
        such as Machine Learning and Azure Stream Analytics for real-time analytics.

    -   **External, batch, or legacy systems** - These systems are
        characterized by data that is not shared in real-time, and
        through files or database connections. The recommended pattern
        is to ingest through [Azure Data
        Factory](https://docs.microsoft.com/azure/data-factory/introduction)
        and flow directly into either the historian or into long-term
        storage.

3.  **B2B connector** - B2B connectors are a pattern needed to bridge between two disparate
    solutions that potentially use different data models. These
    connectors translate & stream data bidirectionally between vendor
    devices/solutions and Azure Digital Twins. With a growing ecosystem
    of vendors using industry standard ontologies with Digital
    Twins Definition Language [(DTDL)](https://docs.microsoft.com/azure/digital-twins/concepts-models) such as [RealEstateCore](https://techcommunity.microsoft.com/t5/internet-of-things/realestatecore-a-smart-building-ontology-for-digital-twins-is/ba-p/1914794), these
    integrations will become simpler over time.

4.  **Ingestion** - this solution requires two sets of data to be sent to Azure:

    -   [Azure IoT Hub](https://docs.microsoft.com/azure/iot-hub/about-iot-hub)
        is the preferred method of ingestion for device telemetry. IoT
        Hub offers device-level security, Device Provisioning services,
        device twins, command and control services, integration with IoT
        Edge, scale out and more.

5.  **Azure Data Factory** - Azure Data Factory is the service to
    move and transform potentially large blocks of data from one
    store/format to another. This service is
    recommended when bridging semi-static stores to the historian component (see below).

6.  **Azure Digital Twins** - [Azure Digital
    Twins](https://docs.microsoft.com/azure/digital-twins/overview)
    will hold the spatial graph of the buildings and environment. The
    environment is modeled with [Digital Twins Definition
    Language](https://github.com/Azure/opendigitaltwins-dtdl/blob/master/DTDL/v2/dtdlv2.md)
    (DTDL). 
    
    Azure Digital Twins has a [REST API](https://docs.microsoft.com/rest/api/iothub/service/digitaltwin), currently the only
    way to ingest data. This documentation also includes SDK references for supported languages for control and data plane operations.  When using IoT
    Hub or Event Hub, there must be a service that pulls the data
    from the source and calls the [API to submit to Azure Digital Twins](https://docs.microsoft.com/azure/digital-twins/how-to-ingest-iot-hub-data).

    The
    [ontology](https://docs.microsoft.com/azure/digital-twins/concepts-ontologies)
    can be built from the ground up with DTDL, or start with industry
    supported models such as
    [RealEstateCore](https://github.com/azure/opendigitaltwins-building),
    [Smart Cities
    Ontology](https://github.com/Azure/opendigitaltwins-smartcities), or
    the [Energy Grid
    Ontology](https://github.com/Azure/opendigitaltwins-energygrid/).
    When telemetry enters the Azure Digital Twins service, it is now in
    the context of the graph. At this point, the solution may need to
    perform immediate processing on the data, such as comparing it to
    other sensor data for fault detection, roll up information to
    related instances in the graph, etc. The recommended way to do this processing is via [Azure Functions](https://docs.microsoft.com/azure/digital-twins/how-to-create-azure-function?tabs=cli).

7.  **Historian** - Most solutions will require holding time series data, which is the purpose of the historian. Azure Digital Twins
    holds the current state of the properties; the historian will hold
    past data values. The best integration with Azure Digital Twins is
    with [Azure Data
    Explorer](https://docs.microsoft.com/azure/data-explorer/data-explorer-overview).
    Azure Digital Twins has an egress path through [Azure Event
    Grid](https://docs.microsoft.com/azure/digital-twins/concepts-route-events),
    and Azure Data Explorer offers [a simple ingestion path through
    Azure Event
    Grid](https://docs.microsoft.com/azure/data-explorer/one-click-ingestion-new-table),
    providing a seamless path from Azure Digital Twins to Azure Data
    Explorer.

8.  **Operational Rules and Insights** - this architectural component
    represents functionality that happens either in near real-time, at
    certain data thresholds, by user demand, or that requires more
    sophisticated or longer running processing than is appropriate to
    handle with inline processing in Azure Digital Twins. These operations could be done by
    invoking Cognitive Services, using AI models, or a partner simulation
    services.

9. **Solution API Layer** - All solutions must be protected by a
    security layer. All core Azure services have security built in, but
    most finished solutions will need to build a secure access path to
    the solution features, and in most cases do not want to expose core
    services directly to users or external services. [Azure API
    Management](https://azure.microsoft.com/services/api-management/)
    offers services to normalize, secure, rate limit, and customize
    APIs. In addition to traditional APIs, the solution may need to
    provide a publish/subscribe mechanism for service applications that
    need to exchange data asynchronously and/or at volume. For
    publish/subscribe, the solution may use IoT Hub, Service Bus queues,
    Event Hubs, or web hooks. For UIs that need to be updated as
    telemetry and data changes, [SignalR](https://docs.microsoft.com/azure/digital-twins/how-to-integrate-azure-signalr)
    is the recommended approach.

10. **Model Management** - This concept refers to maintaining the DTDL
    model. Microsoft recommends using the Azure Digital Twins Explorer, currently
    in public preview, for creation of a DTDL model.  Model creation could also be done via an ISV solution, custom-built tool, or text/code editor. The DTDL Ontology repo represents repositories where an
    existing ontology would be held. This repository could be GitHub for
    [RealEstateCore](https://github.com/Azure/opendigitaltwins-building),
    Smart Cities ontology, or the [Energy Grid
    ontology](https://github.com/Azure/opendigitaltwins-energygrid/). If
    the solution calls for a custom ontology, then there would be a need
    for an ontology repository that could range from solution-specific
    GitHub repo to more customized repositories. Finally, the Model Uploader is responsible for loading the model into Azure
    Digital Twins. There is a [Digital Twins tools repository](https://github.com/Azure/opendigitaltwins-tools) which also has samples for uploading DTDL
    models.

11. **Service Applications** - this represents a large subset of
    applications that either collect, analyze and prepare data to
    service end-user applications, or Microsoft tools directly to show
    data and insights (such as Power Apps, Power BI and Azure Maps). This
    category of application will interact primarily with the (9) Fine
    Grained Access Control API layer, but in cases such as Power BI and
    PowerApps that are optimized to work directly against Azure data
    stores, this will be accepted access path as well.

12. **Enterprise Applications** - this represents the broad assortment
    of applications that are in use in an enterprise, from Dynamics 365
    modules to ISV solutions, Teams apps, and field optimized solutions
    such as mobile and wearables such as
    [HoloLens](https://docs.microsoft.com/dynamics365/mixed-reality/remote-assist/overview-hololens)
    and [RealWear
    HMT](https://docs.microsoft.com/MicrosoftTeams/flw-realwear).

13. **Shared Services** (not pictured) These are Azure Services that support the
    individual services on which the solution is built. [Azure
    Monitor](https://azure.microsoft.com/services/monitor/) can
    collect, analyze, visualize, and send notifications from the
    operational telemetry across the services. Similarly, [Azure
    Defender for
    IoT](https://docs.microsoft.com/azure/defender-for-iot/overview)
    is a unified security service that works across Azure services to
    protect the solution. [Azure
    DevOps](https://azure.microsoft.com/services/devops/) is a set
    of services to manage the code, project, deployments that you need
    for a well-run development team. [Azure Active
    Directory](https://azure.microsoft.com/services/active-directory/)
    is the core of Microsoft identity and security services, and is
    critical to integration with other cloud services, ISV solutions and
    on premises solutions. [Azure Key
    Vault](https://azure.microsoft.com/services/key-vault/)
    provides a safe store for keys and secrets across the full solution.

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

## Pricing
The [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) can be used to estimate costs for an IoT solution. Other considerations are described in the Cost section in [Microsoft Azure Well-Architected Framework](https://docs.microsoft.com/azure/architecture/framework/cost/overview).

The [Azure IoT Reference Architecture](https://docs.microsoft.com/azure/architecture/reference-architectures/iot/) also has a discussion about how to optimize cost for several services commonly used in IoT solutions.

## Scalability considerations
Smart Places solutions range from relatively simple, low volume to sophisticated solutions with very high data volume (such as a solution that aggregates HVAC telemetry across a large campus.)   The core Azure services in this architecture are built to scale, but when they are integrated with one another to form a solution, the development team needs to ensure that they do not create unintentional choke points.  Avoiding these choke points is best addressed by having performance tests run at scheduled intervals to identify potential problems early in the development cycle.

## Flexibility considerations
Integration is mentioned in the article, but Smart Places solutions need to pay additional attention to building a solution that remains flexible.   Smart Places use cases are rapidly evolving, so new sensors, new data types, new Artificial Intelligence opportunities, and new visualization techniques will inevitably be required after initial deployment. The proposed architecture is loosely coupled which is a requirement for flexibility, the use of [industry standards for data ontology](https://docs.microsoft.com/azure/digital-twins/concepts-ontologies-adopt), will reduce the time to add new functionality and integrate new software, and the use of [Azure API Management](https://azure.microsoft.com/services/api-management/#overview) increases flexibility by providing a way to create multiple API styles and signatures to a single underlying API.

## Security considerations
Legacy building solutions often relied on a lack of external connectivity as the primary source of security.  In today’s world, even data that doesn’t identify people can still be used to draw conclusions about the business or the people in the building.   It is also common to use cameras to achieve use cases such as people counting, asset tracking, and security.  In these cases, be clear with specifics about where the images are processed, what gets saved and where, and ensure that the customer requirements for both privacy and use case are addressed. The bottom line on security for Smart Places solutions is that for all data, security must be top of mind throughout the data lifecycle.  Think about what is being collected, where it is being processed, where it will be stored, and what conclusions can be drawn from the collective set of data.

## Next steps
-	Learn [how Microsoft is powering their buildings with Azure Digital Twins](https://www.microsoft.com/itshowcase/blog/powering-microsoft-smart-buildings-with-microsoft-azure-digital-twins/)
-	[Learn more about Azure Digital Twins](https://docs.microsoft.com/learn/paths/develop-azure-digital-twins/)
-	[Learn how EDGE Next leverages Azure Digital Twins in their Smart Buildings platform](https://www.youtube.com/watch?v=sll7tJG1CcI)
-	[Brookfield Properties: real estate innovation with WillowTwin built on Azure Digital Twins](https://customers.microsoft.com/story/1373881459232543118-vasakronan-smartspaces-azure-iot)
-	[Vasakronan: sustainability and carbon neutrality with Idun ProptechOS built on Azure Digital Twins](https://customers.microsoft.com/story/1373881459232543118-vasakronan-smartspaces-azure-iot)

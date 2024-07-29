This article describes the automotive connected fleets reference architecture, which enables customers and partners to build composable, data-centric solutions. You can manage all aspects of your connected fleets, generate data-driven insights, and integrate fleet solutions with critical business processes. The connected fleets reference architecture is applicable to automotive original equipment manufacturers (OEMs), including small and emerging, fleet operators, fleet solution providers, and mobility service providers.

## Architecture

:::image type="content" source="./images/automotive-connected-fleets-high-level.svg" alt-text="Diagram of the connected fleets architecture." border="false" lightbox="./images/automotive-connected-fleets-high-level.svg":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/connected-fleets-diagrams.vsdx) of the diagrams in the architecture.*

The connected fleets reference architecture supports composability, innovation, and supportability by:

- Applying common messaging schemas and an updated automotive common data model, allowing partners to coordinate and add value in different areas of the fleet operations domain.
- Using a modular design to address the challenges of modernizing brownfield environments with new capabilities for managing both vehicles and business. Modules can be independently managed and integrated, simplifying and accelerating the integration of capabilities from different parties. Modules are adaptable and allow customers and partners to customize the functionality and scale their operations as needed.
- Being based on generally available Azure services. The architecture evolves as new Azure service features are introduced.

The architecture is composed of the following areas:

- **Vehicle Edge** is responsible for in-vehicle logic and connection to the cloud back-end.
- **Telematics** covers vehicle telemetry ingestion, message processing, and device management.
- **Fleet integration** covers the integration from the telemetry layer to the business and analytics layer.
- **Business data** encompasses the data model and links between the fleet common data model and existing Dynamics 365 modules.
- **Analytics** integrates and generates insights from diverse and large data sources.
- **Business operations** provides capabilities for the management and operation of vehicle fleets.
- **Business automation** provides low-code or no-code extensibility to implement use cases based on the business data.
- **Visualization** provides reporting and business intelligence capabilities.
- **Operations and security** provides monitoring and observability on all services and devices, secures network connectivity, and provides authentication or authorization to devices, applications, and users.

The following sections expand on architecture and workflow details.

### Telemetry ingestion workflow

The telemetry ingestion layer is responsible for receiving messages from the vehicle, authorization, decoding, and enrichment layers and routing the messages to the fleet integration layer.

:::image type="content" source="./images/automotive-connected-fleets-telematics.svg" alt-text="A diagram of the telemetry ingestion workflow." border="false" lightbox="./images/automotive-connected-fleets-telematics.svg":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/connected-fleets-diagrams.vsdx) of the diagrams in the architecture.*

1. Telemetry **messages from the vehicle** contain headers, or metadata, and a payload that can either protobuf-encoded or JSON format. These messages are sent via MQTT to the cloud broker. Headers include fields, such as vehicle UUID, message type, supplier, correlation identifier, message version, message UUID, and a standard timestamp in UTC. Headers are used for message type validation and routing.
1. The message is processed in a pipeline that performs the following steps:
      1. **Metadata validation** validates message headers including activities, such as confirming the device is authorized to send the type of message and required header fields.
      1. The **decode** step translates the input schema into a standardized format that's used by the cloud. The **decode** step also provides an abstraction layer between the device and the cloud if there's any versioning changes between device types or years. The decoding implementation can either be inline, as part of the function for better performance, or it can be a separate function call for added modularity.
      1. **Enrichment** involves data value manipulation and additions of new data fields. Examples of enrichment workloads include unit conversions, such as miles to kilometers, reverse geocoding, vehicle diagnostic trouble code description lookup, enriching with more data, and deriving and calculating extra values. Enrichment steps are invoked according to the message type.
      1. The **routing** step distributes the messages to the event hub in the fleet integration layer based on the message type. The fleet integration layer is a *warm* path, which is required for integrations that require near real-time access to the message data.
1. **Configuration** is managed in Azure Cosmos DB. The message processing app reads the known message types, device authorization claims, and step configuration to process and route incoming messages.
1. For **data analytics and debugging**, messages are stored in the customer’s data lake in separate tables. The following are example messages and exceptions:
      1. Original raw messages from Azure IoT Hub including headers.
      1. Decoded and enriched messages.
      1. Exceptions include messages that can't be validated against the schema, and failed decoding activities and messages that don't match existing vehicle or failed enrichment cases.
1. **Vehicle and device management** is accessible to external systems with a managed API. The message processing function uses vehicle data stored in Azure Cosmos DB to validate that the messages are registered to a vehicle.

Azure Event Grid provides an industry-compliant MQTT broker that supports version 3.1.1 and 5.0. For more information, see [Overview of MQTT Support in Azure Event Grid (Preview)](/azure/event-grid/mqtt-overview) and [Client authentication using a CA certificate chain](/azure/event-grid/mqtt-certificate-chain-client-authentication). Clients can be restricted to publish or subscribe to specific topics by using Azure role-based access control (RBAC). For more information, see [Microsoft Entra ID JWT authentication and Azure RBAC authorization to publish or subscribe MQTT messages](/azure/event-grid/mqtt-client-azure-ad-token-and-rbac).

It's also possible to use [IoT Hub](/azure/iot-hub) as an MQTT broker. It offers limited support for MQTT 3.1.1 and 5.0 with predefined topics and tight coupling between devices and cloud apps. For more information, see [Compare MQTT support in IoT Hub and Event Grid](/azure/iot/iot-mqtt-connect-to-iot-hub#compare-mqtt-support-in-iot-hub-and-event-grid).

The connection between devices and the cloud can be configured over a private link for enhanced network security.

### Fleet integration workflow

The fleet integration layer uses *standardized communication payloads* from the telematics layer. The payloads enable turnkey scenarios in fleet management for line-of-business and data analytics.

There are four common types of payload messages necessary to support fleet operations:

| Data payload | Description |
| ------------ |------------ |
| Vehicle status updates | The vehicle status update message is sent periodically during vehicle operations, usually in the seconds to minutes range. The message contains the position and the operational data for the vehicle. |
| Vehicle alerts and notifications | Vehicle alerts and notifications is a specialized status update. This update is triggered by the edge device or calculated and generated in the telematics layer when specific conditions are reached. Common events include crash, geofence violation, harsh driving, and unauthorized movement. |
| Vehicle health | The vehicle health contains information from the on-board diagnostics system. It contains a list of installed hardware and diagnostic trouble codes. This message type is sent with low frequency, usually a few times for each day, on demand, or as part of a priority message if there's an imminent or actual breakdown. |
| Trips | Some fleet applications don't transmit a constant stream of vehicle telemetry but instead send a single message at the completion of a trip containing the route and points of interest. |

The following architecture diagram shows the dataflow for these messages:

:::image type="content" source="./images/automotive-connected-fleets-fleet-integration.svg" alt-text="Diagram of the fleet integration workflow." border="false" lightbox="./images/automotive-connected-fleets-fleet-integration.svg":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/connected-fleets-diagrams.vsdx) of the diagrams in the architecture.*

1. A standardized message arrives to the fleet integration Azure Event Hubs namespace.
1. Periodic status messages are processed and sent directly to the analytics layer by using native Azure Data Explorer data ingestion.
1. Messages received as events, alerts, and notifications add rows to the corresponding events data table.
1. Messages containing trips create entries in the trips table.

### Business automation workflow

Line-of-business integration is achieved by using a Microsoft Power Platform data connector. The connector offers the possibility to create workflows in Microsoft Power Automate or Azure Logic Apps, enabling low-Code or no-Code integration for vehicle functions.

You can use data connectors to perform two operations:

- **Triggers** notify Microsoft Power Platform when specific events occur. A trigger starts a business workflow as a reaction to a message of a vehicle status change.
- **Actions** are changes directed by the user. Actions allow interaction from Microsoft Power Platform to the fleet integration layer.

:::image type="content" source="./images/automotive-connected-fleets-business-automation.svg" alt-text="Diagram of the business automation workflow." border="false" lightbox="./images/automotive-connected-fleets-business-automation.svg":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/connected-fleets-diagrams.vsdx) of the diagrams in the architecture.*

The following trigger and actions correspond to the previous diagram.:

1. **Triggers**
    1. *Incoming event messages*: Start a workflow on Microsoft Power Apps or Microsoft Power Platform based on an event message type. The payload of the message can be parsed and accessed in Microsoft Power Platform.
    1. *Life cycle management provisioning*: Notification of changes to the provisioning status of vehicles.
1. **Actions**
    1. Access *Vehicle last known values* and *History*: Allow you to read the last known values store and the message history.
    1. *Provisioning*: Contains functions to provision and deprovision vehicles and devices.

The data connector can be used independently from the Dynamics 365 integration. The connector enables business applications to be integrated with the architecture by using Microsoft Power Platform.

### Data analytics and visualization workflow

:::image type="content" source="./images/automotive-connected-fleets-data-analytics.svg" alt-text="Diagram of the  data analytics and visualization workflow." border="false" lightbox="./images/automotive-connected-fleets-data-analytics.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/connected-fleets-diagrams.vsdx) of the diagrams in the architecture.*

The analytics pipeline provides warm availability and cold storage for vehicle and business data.

1. The data lake stores data, including:
    - Original, raw messages from the vehicle.
    - Decoded and enriched messages from connected fleets message processing extensions.
    - Failed messages along the message processing extensions.
    - Line-of-business information pushed from Microsoft Dataverse via Azure Synapse Link.
    - Exports pushed from a third-party system.

1. Data is processed with Synapse pipelines in several steps:
    - Cleaned-up, decoded, and deduplicated data from raw *bronze* tables.
    - Enriched, deduplicated, and validated fleet operation data in *silver* tables.
    - Datasets that provide aggregated data and key performance indicators and insights derived from multiple data sources in *gold* tables.

1. Visualization through accessing the data from the lakehouse. Microsoft Power BI provides visualization capabilities to the lakehouse using Parquet connectors, and Azure Data Explorer clusters by using DirectQuery.

### Components

The following components are referenced in this automotive connected fleets reference architecture:

#### Messaging services

The following messaging services allow you to react to relevant events, provision, ingest, and communicate between attached devices.

- [Event Grid](https://azure.microsoft.com/en-us/products/event-grid/) is a highly scalable, fully managed publish-subscribe message distribution service that uses the MQTT and HTTP protocols. This service enables telematic devices to communicate with the cloud.
- [IoT Hub](https://azure.microsoft.com/en-us/products/iot-hub/) is a managed service that acts as a central message hub between the telematics devices and the cloud.
- [IoT Hub Device Provisioning Service](https://azure.microsoft.com/en-us/updates/azure-iot-hub-device-provisioning/) is a helper service that enables zero-touch, just-in-time provisioning of the telematic devices.
- [Event Hubs](https://azure.microsoft.com/en-us/products/event-hubs/) is a scalable event processing service that ingests and processes large volumes of events and data. It processes the high volume of events generated by the telematics devices.

#### Storage and database services

The following services allow you to optimize your data storage.

- [Azure Blob Storage](/azure/storage/blobs) is an object storage solution for the cloud. It stores information from the telematics devices such as messages, videos, and high-resolution data captures.
- [Azure Cosmos DB](/azure/cosmos-db) is a fully managed NoSQL and relational database for modern app development. It stores information about vehicles, devices, and users.

#### Integration services

The following services allow you to publish at scale, create and manage gateways, use updated infrastructure and resources, create web and mobile apps, and use geospatial capabilities.

- [Azure API Management](/azure/api-management) is a hybrid, multicloud management platform for APIs that simplifies the integration of data and services.
- [Azure Functions](/azure/azure-functions) is a serverless solution used for the real-time stream and event processing of telemetry messages and events. It also manages file uploads and performs inference with machine learning models.
- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) is an HTTP-based service for hosting web applications, REST APIs, and mobile back-ends. It provides a front-end experience for mobility users.
- [Azure Maps](/azure/azure-maps) is a collection of geospatial services and SDKs that provide geographic context to web and mobile applications.

#### Data and analytics services

The following services allow you to query and analyze high volumes of data.

- [Azure Synapse Analytics](/azure/synapse-analytics) is an enterprise analytics service that accelerates time to insight across data warehouses and big data systems.
- [Azure Data Explorer](/azure/data-explorer/data-explorer-overview) is a fully managed, high-performance, big data analytics platform that simplifies analyzing high volumes of vehicle telemetry data in near real time.

#### Security services

The following services allow you to manage your virtual network and user identities, and to control access to your apps, data, and resources.

- [Azure Private Link](/azure/private-link) enables access to Azure platform as a service (Paas) solutions over a private endpoint in your virtual network. Private Link avoids exposing services to the internet.
- [Microsoft Entra ID](/azure/active-directory) is a cloud-based identity and access management service. It provides a common experience across all applications, services, and users.

#### Business integration

The following services allow you to manage data, apps, workflows, build low-code apps, and increase insights.

- [Dataverse](/power-apps/maker/data-platform) is a cloud scale database used to securely store data for business applications built on Power Apps.
- [Power Automate](/power-automate) is a cloud-based service that allows users to automate repetitive tasks and streamline business processes with a low-code platform.
- [Power Apps](/power-apps) is a cloud-based service that enables users to rapidly build and share low-code apps.
- [Power BI](/power-bi) is a business analytics service for data visualization and insights.
- [Dynamics 365](/dynamics365) is a set of intelligent business applications that helps you run your entire business and deliver greater results through predictive, AI-driven insights.
- [Dynamics 365 Field Service](/dynamics365/field-service/overview) helps organizations deliver onsite service to customer locations.

## Scenario details

:::image type="content" source="./images/automotive-connected-fleets-diagrams.svg" alt-text="Diagram of the Connected Fleets reference architecture." border="false" lightbox="./images/automotive-connected-fleets-diagrams.svg":::

*Download a [PowerPoint file](https://archcenter.blob.core.windows.net/cdn/automotive-connected-fleets-diagrams.pptx) of this diagram.*

Independent software vendors (ISVs) can use the connected fleets reference architecture to build scenario-independent functionality that's critical to overall fleet management activities. The capabilities layer in the previous diagram depicts capabilities within two categories: the management of vehicles and the business functions in a fleet. Capabilities are divided into categories for the following reasons:

- Categories provide descriptive convenience.
- An ISV might develop more than one capability in more than one capability category.
- Multiple ISVs offer different versions of the same capability.

Solution integrators (SIs) combine capabilities to develop segment-specific scenarios for specific customers. The scenarios shown in the previous diagram are a nonexhaustive list of examples. Some scenarios lend themselves to a smaller number of fleet types, including last-mile logistics for delivery. Others might have different customizations for different segments, such as mobile field service for urban ride sharing versus for remote mining equipment. Some SIs develop their own fleet capabilities, maintaining them in the form of reusable *assets*. These SIs might play some of the roles of ISVs and the traditional SI role.

### Potential use cases

- **Mobile field service** supports companies operating *fleet as a service* or full-service OEMs in fields like agriculture and off-highway that have no fixed workshops. It enables dispatching *flying doctors*, also known as *technicians*, to the location of the vehicle if there are problems. Remote diagnostics can help you to determine the cause of the error and bring the right spare parts and repair manuals. An integrated service architecture might combine mobile service and service in static workshops.
- **Engineering self-service analytics** enable engineers working in automotive OEMs to generate actionable insights by using the data generated by vehicle fleet operation and tasks. Analytics includes vehicle performance, error root cause analysis, machine learning model training, and geospatial analytics. The scope includes production and preproduction test fleets where payloads and analysis are more dynamic.
- **Shared vehicle services** are a collection of services for taxi dispatching, self-service rentals and car shares, or carpooling. For taxi dispatching, use cases include requesting pickup and drop-off points,  automated matching of riders to drivers based on availability, and proximity to driver and schedule planning for the next pickup. In a self-service mode, the service enables users to make vehicle reservations, make payments, and facilitate secure access to vehicles. On the operator side, fleet managers can run reports on vehicle demand at specific locations to ensure that vehicles are positioned to match trends in demand. For carpooling, vehicle or seat reservations and payment services are covered. In highly integrated intelligent transportation systems, such capabilities might be common across multiple providers such as for city dispatch systems.
- **Last-mile logistics** focuses specifically on customers with complex scheduling requirements, requiring optimization of driver and vehicle selection for many waypoints in a given day. Customers include people who deliver groceries or parcels. The last-mile logistics ideally would be integrated with a customer interface to inform customers of expected delivery time. Customers benefit from a closer engagement with end customers through increased visibility on goods delivery, optimization of fleet size, and reduction in distance driven. Such capabilities extend to shared freight models where the endpoint, rather than carrier, organizes the packages, especially for compliance with ultra-low emission vehicle (ULEV) and zero- and low-emission vehicle (ZLEV) zone restrictions.
- **Customer service** lets fleet operators and owners track customer issues, record all interactions, unify routing to efficiently route work items, create and track service-level agreements (SLAs), and manage performance and productivity through reports and dashboards.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- Extra design is required to process messages related to health and safety. For example, correlating a crash signal to a 911 emergency call.
- The telematics hardware provider must guarantee functional safety for running commands.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Use Microsoft Defender and Microsoft Sentinel to identify and address device vulnerabilities and threats. Consider integrating the lightweight security agent in your device. For more information, see [What's Microsoft Defender for IoT for device builders?](/azure/defender-for-iot/device-builders/overview).
- Perform monitoring and observability of your devices. Collect metrics, logs, and traces at a rate that balances transparency with costs.
- Use [private endpoints](/azure/private-link/private-endpoint-overview) to secure the services that shouldn't be exposed to the public internet.
- Use [managed identities](/azure/active-directory/managed-identities-azure-resources/overview) to provide identities to your services and eliminate the management of credentials.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- The cost of connected fleet operations is directly related to the volume of messages for each vehicle.
  - Consider the required update frequency for each vehicle. Consider dynamically adjusting the update speed based on the use case.
  - Consider reducing the size of messages by using compression or encoding techniques such as protobuf and gzip.
  - Consider limiting the transmission of videos or vehicle data captures by using wireless LAN as opposed to cellular communication.
  - Consider delayed processing of large files such as videos and log files by using Azure Spot Virtual Machine instances.
  - Use topic aliases on frequent MQTT messages from the vehicles to save network bandwidth.
- The runtime for decoding and enrichment must be maintained as low as possible to reduce the size and scale of the function apps.
- Vehicle operations typically have periods of high and low demand during the day. Consider the use of automatic scaling for services that experience a demand to reduce costs.
- Processing speeds and costs have large differences for an IoT-based telemetry system (telematics layer) and the operational layer (Dataverse). Ensure that only events where a business operation is required trigger an update on the operational layer.

The [pricing calculator](https://azure.microsoft.com/pricing/calculator) can be used to create an estimation of the monthly costs of the Azure services required to use this solution.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- *Dead-lettering* messages in Azure Data Lake Analytics allows you to monitor the system for problems and configure alerts to detect problems with vehicle communication.
- A bug in the vehicle software can create a high load in the system. Vehicle message throttling concepts might be necessary to ensure that the system isn't overloaded.
- Consider creating a resource group for each layer in the architecture. Grouping resources simplifies management and cost control.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users. For more information, see [Overview of the performance efficiency pillar](/azure/architecture/framework/scalability/overview).

- High volume messages, such as periodic status updates, and deferred messages, such as trips, are separated from alerts and notifications to rightsize the event hubs.
- A mismatch between telemetry and Dataverse related to timing and error handling, such as the difference between push and pull, uses virtual tables to decouple data that rapidly updates.
- The current structure of the automotive common data model requires multiple entries for each vehicle status update. Each value requires updates in the device measure and the device meter. The information about the sensors should be surfaced from the fleet integration layer on demand.
- Spamming alert and notification messages creates problems in the Dataverse. The update frequency to Dataverse must be configurable and subject to throttle.
- The state store contains the latest information from the vehicle and can be accessed as part of business automation or Power Apps.

## Deploy this scenario

You can follow the step-by-step tutorial for [Connected Fleet Reference Architecture](https://github.com/microsoft/connected-fleet-refarch) to deploy the solution in your subscription.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Mario Ortegon-Cabrera](https://www.linkedin.com/in/marioortegon/) |  Principal Program Manager, MCIGET SDV & Mobility
- [David Peterson](https://www.linkedin.com/in/david-peterson-64456021) | Chief Architect, Mobility Service Line

Other contributors:

- [Saivendra Kayal](https://www.linkedin.com/in/saivendra/) | Senior Program Architect, Mobility Service Line
- [Ryan Matsumura](https://www.linkedin.com/in/ryan-matsumura-4167257b/)| Senior Program Manager, MCIGET SDV & Mobility
- [John Stenlake](https://www.linkedin.com/in/linkedein42) | Director, Vehicle Innovation & Mobility

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

The following reference architectures expand the connected fleets scenario:

- [Automotive messaging, data, and analytics reference architecture](/azure/event-grid/mqtt-automotive-connectivity-and-data-solution) covers more automotive and device messaging scenarios using the Event Grid MQTT broker.
- [Data analytics for automotive test fleets](/azure/architecture/industries/automotive/automotive-telemetry-analytics) is a dedicated  scenario where the collected data is used for engineering validation and root cause analysis.

## Related resources

The following reference architectures are related to the connected fleets scenario:

- [Autonomous vehicle operations (AVOps) design guide](../../guide/machine-learning/avops-design-guide.md) contains the approach for the development and model training of autonomous vehicle fleets.
- [Automated guided vehicles fleet control](../../example-scenario/iot/automated-guided-vehicles-fleet-control.yml) shows an end-to-end approach to control automated guided vehicles (AGVs) for just-in-time manufacturing and automated show-floor logistics.

The following patterns are relevant when implementing this architecture:

- [The Publisher-Subscriber pattern](../../patterns/publisher-subscriber.yml) describes how a device announces events to multiple interested applications.
- [The Event Sourcing pattern](../../patterns/event-sourcing.yml) describes the usage of an append-only store to record the full series of actions taken on entities such as vehicles, devices, and users instead of just the last known values.
- [Throttling](../../patterns/throttling.yml) is a pattern to control the consumption of resources to allow a system to continue to function and meet SLAs.
- [Cloud monitoring guide](/azure/cloud-adoption-framework/manage/monitor) provides an overview on the concepts required for implementing monitoring and observability.

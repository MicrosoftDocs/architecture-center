This example architecture explains how automotive original equipment manufacturers (OEMs) and mobility providers can develop advanced connected vehicle applications and digital services. It provides reliable messaging, data, and analytics infrastructure. This infrastructure includes message and command processing, state storage, and managed API integration. The architecture also provides a scalable, enhanced-security data solution for digital engineering, fleet operations, and sharing within the wider mobility ecosystem.

## Architecture

:::image type="complex" source="images/automotive-connectivity-and-data-solution-high-level-overview.svg" alt-text="Diagram of the high-level architecture." border="false" lightbox="images/automotive-connectivity-and-data-solution-high-level-overview.svg":::
    Diagram that shows a high-level overview of the automotive messaging, data, and analytics architecture. The diagram shows vehicles, mobile devices, and infrastructure as the devices. The vehicle messaging layer provides connectivity and processes message queuing telemetry transport (MQTT) messages and files. The data analytics layer supports both real-time and batch analytic workloads. A description of each layer is provided in the article.
:::image-end:::

_Download a [PowerPoint file](https://arch-center.azureedge.net/automotive-connectivity-and-data-solution.pptx) that contains this architecture diagram._

The preceding high-level architecture diagram shows the main logical blocks and services of an automotive messaging, data, and analytics solution. In this article, we don't discuss the shaded diagram elements. But the following list briefly explains the other diagram elements. You can find further details in the sections that follow.

- **Vehicle**: Each vehicle contains a collection of devices. Some of these devices are software-defined and can run software workloads managed from the cloud. The vehicle collects and processes a wide variety of data, such as sensor information from electro-mechanical devices, interactions, video, and software log files.

- **Mobile devices**: Mobile devices provide digital experiences to the driver or user and can receive messages from and send messages to the vehicles by using companion apps.

- **Mobility infrastructure**: Mobility infrastructure, such as battery charging stations, receives messages from and sends messages to the vehicles.

- **Messaging services**: Messaging services manage the communication to and from the vehicle, infrastructure, and mobile devices. They process messages, use workflows to carry out commands, and implement the management backend. They also track certificate registration and provisioning for all participants.

- **Vehicle and device management backend**: OEM systems manage the vehicle and device lifecycle from factory to after-sales support.

- **Data and analytics services**: Data and analytics services provide data storage, processing, and analytics capabilities for all users. These services transform data into insights that drive better business decisions.

- **Digital services**: The vehicle manufacturer provides digital services that add value for the customer. These services include companion apps for repair and maintenance tasks.

- **Business integration**: Several digital services require business integration to backend systems such as dealer management system (DMS), customer relationship management (CRM), or enterprise resource planning (ERP) systems.

- **Consent management**: The consent management backend is part of customer management and tracks user authorization for data collection according to applicable legislation.

- **Digital engineering**: Digital engineering systems use vehicle data to continuously improve hardware and software through analytics and machine learning.

- **Smart mobility ecosystem**: The smart mobility ecosystem consists of partner companies that provide other products and services, such as connected insurance based on user consent. They can subscribe  to and consume events and aggregated insights.

- **IT and operations**: IT operators use these services to maintain the availability and performance of both vehicles and backend systems.

- **Vehicle security operations center (VSOC)**: IT operators and engineers use VSOC to protect vehicles from threats.

*Microsoft is a member of the [Eclipse Software Defined Vehicle Working Group](https://www.eclipse.org/org/workinggroups/sdv-charter.php), which serves as a forum for open collaboration on vehicle software platforms that use open source.*

### Dataflow

The architecture uses the [Publisher-Subscriber messaging pattern](/azure/architecture/patterns/publisher-subscriber) to decouple vehicles from services. It uses Azure Event Grid to enable messaging between vehicles and services and to [route message queuing telemetry transport (MQTT) messages](/azure/event-grid/mqtt-routing) to Azure services.

#### Vehicle-to-cloud messages

The vehicle-to-cloud dataflow processes telemetry data from the vehicle. Telemetry data, such as vehicle state and sensor data, can be sent periodically. You can send data based on events, like triggers on error conditions, as a reaction to user actions, or as a response to remote requests.

:::image type="complex" source="images/automotive-connectivity-and-data-solution-messaging-dataflow.svg" alt-text="Diagram of the messaging dataflow." border="false" lightbox="images/automotive-connectivity-and-data-solution-messaging-dataflow.svg":::
    The diagram shows how the vehicle sends vehicle-to-cloud messages. The vehicle has an MQTT client that publishes messages to the Event Grid MQTT broker functionality. Depending on the message type, they're routed directly to a Lakehouse, streamed into an Eventhouse, or forwarded to a service bus.
:::image-end:::

1. API Management provides secure access to the vehicle, device, and user consent management service. The vehicle is configured for a customer based on their purchase options. The managed APIs provide access to:

    1. Provisioning information for vehicles and devices.

    1. Initial vehicle data collection configuration based on market and business considerations.

    1. Storage of initial user consent settings based on vehicle options and user acceptance defined in the consent management backend.

1. The vehicle publishes telemetry and events messages through an MQTT client with defined topics to the Event Grid MQTT broker feature in the vehicle messaging services.

1. The Event Grid routes messages to different subscribers based on topic, message attributes, or payload. For more information, see [Filtering of MQTT-routed messages](/azure/event-grid/mqtt-routing-filtering).

    1. An Azure Event Hubs instance buffers high-volume, low-priority messages that don’t require immediate processing, like those only used for analytics. Then it routes the messages directly to storage. For performance reasons, don't use payload filtering for these messages.

    1. An Event Hubs instance buffers high-priority messages that require immediate processing, like status changes in a user-facing application with low-latency expectations. Then it routes them to an Azure function.

1. The system stores low-priority messages directly in a lakehouse by using [event capture](/azure/stream-analytics/event-hubs-parquet-capture-tutorial). To optimize costs, these messages can use [batch decoding and processing](#data-analytics).

1. An Azure function processes high-priority messages. The function reads the vehicle, device, and user consent settings from the device registry and performs the following steps:

    1. Verifies that the vehicle and device are registered and active.

    1. Verifies that the user gave consent for the message topic.

    1. Decodes and enriches the payload.

    1. Adds more routing information.

1. The live telemetry Eventstream in the data and analytics solution receives the decoded messages. Eventhouse processes and stores messages as they come in.

1. The digital services layer receives the decoded messages. Azure Service Bus notifies applications about important changes and events about the state of the vehicle. Eventhouse provides the last known state of the vehicle and the short term history.

#### Cloud-to-vehicle messages

##### Broadcast dataflow

Digital services use the broadcast dataflow to provide notifications or messages to multiple vehicles about a common topic. Typical examples include traffic and weather services.

:::image type="complex" source="images/automotive-connectivity-and-data-solution-broadcast-dataflow.svg" alt-text="Diagram of the data analytics." border="false" lightbox="images/automotive-connectivity-and-data-solution-data-analytics.svg":::
    The diagram shows how the vehicle receives broadcast messages from the cloud. Vehicles subscribe to a general topic to receive notifications. A digital service broadcasts a message by publishing directly to the common topic.
:::image-end:::

1. The notification service is an [MQTT client](/azure/event-grid/mqtt-clients) that runs in the cloud. It's registered and authorized to publish messages to specific topics in Event Grid. The authorization can be done through [Microsoft Entra JSON Web Token authentication](/azure/event-grid/mqtt-client-microsoft-entra-token-and-rbac).

1. The notification service publishes a message. For example, a weather warning to topic `/weather/warning/`.

1. Event Grid verifies if the service is authorized to publish to the provided topic.

1. The vehicle messaging module is subscribed to the weather alerts and receives the notification.

1. The messaging module notifies a vehicle workload. For example, it notifies the infotainment system to display the content of the weather alert.

##### Command and control dataflow

The command and control dataflow performs remote commands in the vehicle from a digital service such as a companion app or communication with mobility infrastructure. These commands include use cases such as locking or unlocking the doors, setting climate control for the cabin, charging the battery, and making configuration changes. The success of these commands depends on the state of the vehicle. They might require some time to complete.

Vehicle commands often require user consent because they control vehicle functionality. These commands use the vehicle state to store intermediate results and evaluate successful execution. The messaging solution must have command workflow logic that checks user consent, tracks the command execution state, and notifies the digital service when the command is complete.

The following dataflow uses commands issued from a companion app digital service as an example. As in the previous example, companion app is an authenticated service that can publish messages to Event Grid.

:::image type="complex" source="images/automotive-connectivity-and-data-solution-command-and-control-dataflow.svg" alt-text="Diagram of the command and control dataflow." border="false" lightbox="images/automotive-connectivity-and-data-solution-command-and-control-dataflow.svg":::
    The diagram describes how to send command and control messages that require a workflow. A digital service uses an API to send a command. A workflow logic component publishes a message to the MQTT broker that requests command processing. The vehicle processes the command and sends status messages by publishing to a topic. The workflow logic subscribes to the status topic to monitor command processing. After the command is complete, it can notify the digital service.
:::image-end:::

1. API Management provides access to the vehicle, device, and consent management backend. The vehicle owner or user grants consent to perform the command and control functions through a digital service, such as a companion app. It usually happens when the user downloads or activates the app and the OEM activates their account. It triggers a configuration change on the vehicle to subscribe to the associated command topic in the MQTT broker.

1. The companion app uses the command and control managed API to request execution of a remote command. The command execution might have more parameters to configure options such as timeout, and store and forward options. The workflow logic processes the API call.

1. The workflow logic decides how to process the command based on the topic and other properties. It creates a state to track the status of the process. The command workflow logic checks against user consent information to determine if the message can be processed.

1. The command workflow logic publishes a message to Event Grid with the command and the parameter values.

1. Event Grid uses managed identities to authenticate the workflow logic. It then checks if the workflow logic is authorized to send messages to the provided topics.

1. The messaging module in the vehicle is subscribed to the command topic and receives the notification. It routes the command to the right workload.

1. The messaging module monitors the workload for completion or error. The workload is in charge of the physical execution of the command.

1. The messaging module publishes command status reports to Event Grid. The vehicle uses an X.509 certificate to authenticate to Event Grid.

1. The workflow logic is subscribed to command status updates and updates the internal state of command execution.

1. After the command execution is complete, the service app receives the execution result over the command and control API.

The command and control workflow logic can fail if the vehicle loses connectivity. The Event Grid MQTT broker feature supports [Last Will and Testament messages](/azure/event-grid/mqtt-support#last-will-and-testament-lwt-messages). If the device disconnects abruptly, the MQTT broker distributes a will message to all subscribers. The workflow logic registers to the will message to handle the disconnect, interrupt the processing, and notify the client with a suitable error code.

#### Vehicle and device provisioning

This dataflow describes the process to register and provision vehicles and devices to vehicle messaging services. The process is typically initiated as part of vehicle manufacturing. In the automotive industry, vehicle devices are commonly authenticated by using X.509 certificates. Event Grid requires a root or intermediate X.509 to authenticate client devices. For more information, see [Client authentication](/azure/event-grid/mqtt-client-authentication).

:::image type="complex" source="images/automotive-connectivity-and-data-solution-provisioning-dataflow.svg" alt-text="Diagram of the provisioning dataflow." border="false" lightbox="images/automotive-connectivity-and-data-solution-provisioning-dataflow.svg":::
    The diagram shows the vehicle provisioning process. The device receives an X.590 certificate during the manufacturing process. The factory system registers the vehicle and device in the vehicle messaging services, which also connects them to Event Grid. The device retrieves the connection strings from the device management component. The device connects to Event Grid by using the certificate.
:::image-end:::

1. The factory system commissions the vehicle device to the desired construction state. It can include firmware and software initial installation and configuration. As part of this process, the factory system writes the device X.509 certificate, issued by a Public Key Infrastructure Certificate Authority (CA), into storage designed specifically for that purpose, such as a Trusted Platform Module.

1. The factory system registers the vehicle and device by using the Vehicle and Device Provisioning API.

1. The factory system triggers the device provisioning client to connect to the device registration and provision the device. The device retrieves connection information to the MQTT broker.

1. The device registration application creates the device identity with MQTT broker.

1. The factory system triggers the device to establish a connection to the MQTT broker for the first time.

    1. The MQTT broker authenticates the device by using the CA Root Certificate and extracts the client information.

1. The MQTT broker manages authorization for allowed topics using the local registry.

1. For the part replacement, the OEM dealer system can trigger the registration of a new device.

> [!NOTE]
> Factory systems are usually on-premises and have no direct connection to the cloud.

### Data analytics

This dataflow covers analytics for vehicle data. You can use other data sources, such as factory information, fault data, repair reports, software logs, audio, or video, to enrich and provide context to vehicle data.

:::image type="complex" source="images/automotive-connectivity-and-data-solution-data-analytics.svg" alt-text="Diagram of the data analytics." border="false"     lightbox="images/automotive-connectivity-and-data-solution-data-analytics.svg":::
    Diagram that shows the data analytics services. Vehicle messages are stored in a bronze layer as raw data. Pipelines are used to further refine the information to a silver table and to create insights in a gold table. The messages are stored either in a Lakehouse or Eventhouse. Data engineers use Notebooks or Kusto Query Language (KQL) query sets to interact with the data, supported by the Fabric Copilot. Engineers use Power BI and Real-Time dashboards to create visualizations. Reflex processes real-time data and can trigger business processes.
:::image-end:::

1. The vehicle messaging services layer provides telemetry, events, commands, and configuration messages from the bidirectional communication to the vehicle.

1. The IT and operations layer provides information about the software that runs on the vehicle and the associated cloud digital services.

1. Data engineers use Notebooks and Kusto Query Language (KQL) query sets to analyze the data, create data products, and configure pipelines. [Microsoft Copilot in Fabric](/fabric/get-started/copilot-fabric-overview) supports the development process.

1. Pipelines process messages into a more refined state. Pipelines enrich and deduplicate the messages, create key performance indicators, and prepare training data sets for Machine Learning.

1. Engineers and business users visualize the data by using Power BI or real-time dashboards.

1. Data engineers use reflex to analyze enriched vehicle data in near real time to create events such as predictive maintenance requests.

1. Data engineers configure business integration of events and insights with Azure Logic Apps. The workflows update systems of record, such as Dynamics 365 and the Dataverse.

1. Azure Machine Learning Studio consumes generated training data to create or update machine learning models.

### Scalability

#### Deployment Stamps pattern

A connected vehicle and data solution can scale to millions of vehicles and thousands of services. Use the [Deployment Stamps pattern](/azure/architecture/patterns/deployment-stamp) to achieve scalability and elasticity.

:::image type="complex" source="images/automotive-connectivity-and-data-solution-scalability.svg" alt-text="Diagram of the scalability concept." border="false" lightbox="images/automotive-connectivity-and-data-solution-scalability.svg":::
    Diagram that describes an approach to scalability that uses the deployment stamps concept. The vehicle messaging scale unit handles communication with the vehicle. The application scale unit handles digital services. The common services mediate the interaction between both scale units.
:::image-end:::

Each vehicle messaging scale unit is designed to support a specific vehicle population. Factors such as geographical region or model year can define this population. The application scale unit scales the services that require sending or receiving messages to the vehicles. The common service is accessible from any scale unit and provides vehicle and device management and subscription services for applications and devices.

1. The application scale unit subscribes applications to messages of interest. The common service handles subscription to the vehicle messaging scale unit components.

1. The vehicle uses the device management service to discover its assignment to a vehicle messaging scale unit.

1. If necessary, the vehicle is provisioned by using the [vehicle and device provisioning](#vehicle-and-device-provisioning) workflow into a vehicle messaging scale unit.

1. The vehicle can now publish messages and subscribe to topics to the MQTT broker. Event Grid uses the subscription information to route the message.

The following previously used messaging examples illustrate the communication between the scale units:

**(A)** [Basic telemetry without intermediate processing](#vehicle-to-cloud-messages)

1. Messages that don't require processing and claims check are routed to an ingress hub on the corresponding application scale unit.

1. Applications consume messages from their app ingress Event Hubs instance.

**(B)** [Command and control](#command-and-control-dataflow)

1. Applications publish commands to the vehicle through an Event Hubs instance. These commands require processing, workflow control, and authorization by using the relevant workflow logic.

1. Status messages that require processing are routed to the workflow logic.

1. When the command is complete, the workflow logic forwards the notification to the corresponding event hub in the application scale unit for the application to consume.

1. The application consumes events from the associated event hub.

#### Event Grid custom domain names

You can assign custom domain names to your Event Grid namespace’s MQTT and HTTP host names along with the default host names. Custom domain configurations eliminate the need to modify client devices that are already linked to your domain. They also help you meet your security and compliance requirements. To simplify device configuration and migration scenarios, use [custom domain names](/azure/event-grid/custom-domains-namespaces).

### Components

This example architecture includes the following Azure components.

#### Connectivity

- [Event Grid](/azure/well-architected/service-guides/event-grid/reliability) lets you easily build applications with event-based architectures. In this solution, Event Grid manages device onboarding, authentication, and authorization. It also supports publish-subscribe messaging using MQTT.

- [Event Hubs](/azure/well-architected/service-guides/event-hubs) is a scalable event processing service designed to process and ingest massive amounts of telemetry data. In this solution, Event Hubs buffers messages and delivers them for further processing or storage.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions-security) is a serverless compute service that runs event-triggered code. In this solution, Functions processes vehicle messages. You can also use Functions to implement management APIs that require short-term operation.

- [Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) deploys complex workloads and services as containerized applications. In this solution, AKS hosts command and control workflow logic and implements the management APIs.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multi-model database service. In this solution, it stores the vehicle, device, and user consent settings.

- [Azure API Management](/azure/well-architected/service-guides/api-management/reliability) ensures secure and efficient handling of APIs. In this solution, API Management provides a managed API gateway to existing backend services such as vehicle lifecycle management, including over-the-air updates, and user consent management.

- [Azure Batch](/azure/well-architected/service-guides/azure-batch/reliability) is a platform service that provides job scheduling and virtual machine management capabilities. In this solution, Batch runs applications in parallel at scale. It also efficiently handles large compute-intensive tasks, such as vehicle communication trace ingestion.

#### Data and analytics

- [Microsoft Fabric](/fabric) is a unified platform for data analytics that includes data movement, processing, ingestion, transformation, event routing, and report building. It provides data analytics for all collected vehicle and business operation data.

#### Backend integration

- [Logic Apps](/azure/logic-apps/logic-apps-overview) is a platform for creating and running automated workflows. In this solution, it runs workflows for business integration based on vehicle data.

- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) is a fully managed platform for building, deploying, and scaling web apps. In this solution, it provides user-facing web apps and mobile back ends, such as the companion app.

- [Azure Cache for Redis](/azure/well-architected/service-guides/azure-cache-redis/reliability) provides high-performance data caching to accelerate applications. In this solution, it provides in-memory caching of data often used by user-facing applications such as the companion app.

- [Service Bus](/azure/well-architected/service-guides/service-bus/reliability) is a messaging service that ensures reliable communication, with enhanced security, between distributed applications and services. In this solution, it decouples vehicle connectivity from digital services and business integration.

- [Microsoft Dynamics 365](/dynamics365) is a suite of intelligent business applications across sales, service, finance, and operations. In this solution, it provides a connected customer experience and seamless business processes, which ensures better dealership and OEM operations.

- [Microsoft Dataverse](/power-apps/maker/data-platform/) stores and manages business applications data with enhanced security. In this architecture, it stores information about the customer and vehicle.

### Alternatives

Choosing the right compute for message processing and managed APIs depends on several factors. For more information, see [Choose an Azure compute service](/azure/architecture/guide/technology-choices/compute-decision-tree).

We recommend that you use:

- **Functions** for event-driven, short-lived processes such as telemetry ingestion.

- **Batch** for high-performance computing tasks such as decoding large CAN trace and video files.

- **AKS** for managed, fully fledged orchestration of containerized complex logic such as command and control workflow management.

As an alternative to event-based data sharing, you can use [Azure Data Share](/azure/data-share) if the objective is to perform batch synchronization at the data lake level.

For data analytics, you can use:

- [Azure Databricks](/azure/databricks/) to provide a set of tools to maintain enterprise-grade data solutions at scale. Databricks is required for long-running operations on large amounts of vehicle data.

- [Azure Data Explorer](/azure/data-explorer/data-explorer-overview) to provide exploration, curation, and analytics of time-series based vehicle telemetry data.

## Scenario details

:::image type="complex" source="images/automotive-connectivity-and-data-solution-scenario.svg" alt-text="Diagram of the high level view." border="false"lightbox="images/automotive-connectivity-and-data-solution-scenario.svg":::
    High-level diagram that shows the enabling layers of a connected vehicle infrastructure. These layers are messaging services, data and analytics services, automotive development toolchain, and IT operations. The vehicle has electromechanical components and a software stack. The end-to-end use cases include in-vehicle applications, digital engineering, digital services, connected fleets, and integration with the smart mobility ecosystem through data sharing.
:::image-end:::

Automotive OEMs are undergoing a significant transformation as they shift from producing fixed products to providing connected and software-defined vehicles (SDVs). Vehicles provide a range of features, such as over-the-air updates, remote diagnostics, and personalized user experiences. This transition enables OEMs to continuously improve their products based on real-time data and insights while also expanding their business models to include new services and revenue streams.

This example architecture describes how automotive manufacturers and mobility providers can:

- Use feedback data as part of the digital engineering process to drive continuous product improvement, proactively address root causes of problems, and create new customer value.

- Provide new digital products and services and digitalize operations with business integration with backend systems like ERP and CRM.

- Share data with enhanced security and address country or region-specific requirements for user consent by using the broader smart mobility ecosystems.

- Integrate with backend systems for vehicle lifecycle management and consent management to simplify and accelerate the deployment and management of connected vehicle solutions using an SDV DevOps toolchain.

- Store and provide compute at scale for vehicle and analytics.

- Manage vehicle connectivity to millions of devices in a cost-effective way.

### Potential use cases

OEM Automotive use cases are about enhancing vehicle performance, safety, and user experience.

- **Continuous product improvement** enhances vehicle performance by analyzing real-time data and applying updates remotely. For more information about how to develop software for the vehicle, see [SDV DevOps toolchain](software-defined-vehicle-reference-architecture.yml).

- **Engineering test fleet validation** ensures vehicle safety and reliability by collecting and analyzing data from test fleets. For more information, see [Data analytics for automotive test fleets](automotive-telemetry-analytics.yml).

- **Companion app and user portal** enables remote vehicle access and control through a personalized app and web portal.

- **Proactive repair and maintenance** predicts and schedules vehicle maintenance based on data-driven insights.

Broader ecosystem use cases enhance connected vehicle applications. These improvements benefit fleet operations, insurance, marketing, and roadside assistance across the entire transportation landscape.

- **Connected commercial fleet operations** optimize fleet management through real-time monitoring and data-driven decision making. For more information, see [Automotive connected fleets](automotive-connected-fleets.yml).

- **Digital vehicle insurance** customizes insurance premiums based on driving behavior and provides immediate accident reporting.

- **Location-based marketing** delivers targeted marketing campaigns to drivers based on their location and preferences.

- **Road assistance** uses vehicle location and diagnostic data to provide real-time support to drivers in need.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the Reliability pillar](/azure/architecture/framework/resiliency/overview).

- Increase reliability with horizontal scaling. For more information about scaling your message processing pipeline, see [Functions hosting options](/azure/azure-functions/functions-scale). For more information about scaling workflow execution logic and digital services, see [Scaling options for applications in AKS](/azure/aks/concepts-scale).

- Manage compute resources by dynamically scaling based on demand through autoscaling.

- Use [scale units](#deployment-stamps-pattern) to reduce the load on individual components and provide a bulkhead between vehicles. An outage on one stamp doesn't affect the others.

- Use [scale units](#deployment-stamps-pattern) to isolate geographical regions that have different regulations.

- Replicate data across multiple geographic locations for fault tolerance and disaster recovery by using geo redundancy.

Vehicle connection reliability is critical for automotive messaging. For more information, see [Reliability in Event Grid and Event Grid namespace](/azure/reliability/reliability-event-grid).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the Security pillar](/azure/architecture/framework/security/overview).

- Use X.509 certificates to help ensure secure communication between vehicles and Azure. For more information, see [Certificate management](/azure/event-grid).

- Establish a VSOC to detect threats, prevent cyber attacks, and comply with regulatory measures.

- Collect and merge information from multiple data sources. Establish processes for risk mitigation, data forensics, incident response, and attack mitigation.

- Create anomaly detection and early warning for networks, digital services, and electronic control units.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the Cost Optimization pillar](/azure/architecture/framework/cost/overview).

- Consider the cost per vehicle. The communication costs should vary based on the number of digital services provided. Calculate the return on investment for each digital service in relation to the operational costs.

- Establish practices for cost analysis based on message traffic. Connected vehicle traffic can increase over time as more services are added. Examples include increased data collection for telematics insurance products, generative AI powered in-vehicle digital assistants, and car sharing applications.

- Consider networking and mobile costs.

  - Use [MQTT topic aliases](/azure/event-grid/mqtt-support#topic-aliases) to reduce the length of your topic names. This approach helps reduce traffic volume.

  - Use an efficient method, such as Protobuf or gzipped JSON, to encode and compress payload messages.

- Manage traffic actively.

  - Vehicles tend to have recurring usage patterns that create daily and weekly demand peaks.

  - Prioritize messages by using [MQTT user properties](/azure/event-grid/mqtt-support#user-properties) in your routing configuration. You can use this approach to defer the processing of noncritical or analytic messages to smooth the load and optimize resource usage.

  - Consider context-specific processing based on operational requirements. For example, send more brake telemetry only during severe braking conditions.

  - Adjust capacity based on demand.

- Consider how long the data should be stored in hot, warm, or cold storage.

- Optimize costs by using reserved instances.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the Operational Excellence pillar](/azure/architecture/framework/devops/overview).

To enhance unified IT operations, consider monitoring the vehicle software. This software includes logs, metrics and traces, messaging services, data and analytics services, and related backend services.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Overview of the Performance Efficiency pillar](/azure/architecture/framework/scalability/overview).

- Consider using the [scale unit concept](#scalability) for solutions that scale above 50,000 devices, especially if multiple geographical regions are required.

- Consider the [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits) when you design your scale units.

- Consider the best way to ingest data, whether it's through messaging, streaming or batched methods. For example, handle high-priority messages like user requests immediately. Route analytics messages, such as vehicle performance data, directly to storage without processing. Design your system to minimize the number of high-priority messages that need immediate processing.

- Consider the best way to analyze data based on the use case, either through batched or near real time processing. Near real time analysis provides immediate notifications to users, such as alerting them to an imminent vehicle problem. Batched analytics run periodically and provide nonurgent notifications, like predicting upcoming maintenance.

## Deploy this scenario

The tutorial for the [Connected Fleet reference architecture](https://github.com/microsoft/connected-fleet-refarch) contains a sample implementation of the message processing pipeline.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Peter Miller](https://www.linkedin.com/in/peter-miller-ba642776/) | Principal Engineering Manager
- [Mario Ortegon-Cabrera](http://www.linkedin.com/in/marioortegon) | Principal Program Manager, MCI SDV & Mobility
- [David Peterson](https://www.linkedin.com/in/david-peterson-64456021/) | Chief Architect
- [Max Zilberman](https://www.linkedin.com/in/maxzilberman/) | Principal Software Engineering Manager

Other contributors:

- [Jeff Beman](https://www.linkedin.com/in/jeff-beman-4730726/) | Principal Program Manager
- [Frederick Chong](https://www.linkedin.com/in/frederick-chong-5a00224) | Principal PM Manager, MCI SDV & Mobility
- [Felipe Prezado](https://www.linkedin.com/in/filipe-prezado-9606bb14) | Principal Program Manager, MCI SDV & Mobility
- [Ashita Rastogi](https://www.linkedin.com/in/ashitarastogi/) | Principal PM Manager, Azure Messaging
- [Henning Rauch](https://www.linkedin.com/in/henning-rauch-adx) | Principal Program Manager, Azure Data Explorer (Kusto)
- [Rajagopal Ravipati](https://www.linkedin.com/in/rajagopal-ravipati-79020a4/) | Partner Software Engineering Manager, Azure Messaging
- [Seth Shanmugam](https://www.linkedin.com/in/henning-rauch-adx) | Senior Product Manager, Messaging

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

The following articles describe interactions between components in the architecture:

- [Configure streaming ingestion on your Azure Data Explorer cluster](/azure/data-explorer/ingest-data-streaming)
- [Capture Event Hubs data in parquet format and analyze with Azure Synapse Analytics](/azure/stream-analytics/event-hubs-parquet-capture-tutorial)

### Related resources

- [Create an Autonomous Vehicle Operations solution](../../solution-ideas/articles/avops-architecture.yml) provides a deeper look into automotive digital engineering for autonomous and assisted driving.
- [SDV DevOps toolchain](software-defined-vehicle-reference-architecture.yml) describes how to build, validate, and deploy workloads to the vehicle.
- [Data analytics for automotive test fleets](automotive-telemetry-analytics.yml) is a dedicated scenario where the collected data is used for engineering validation and root cause analysis.

The following articles cover some of the patterns used in the architecture:

- [Claim Check pattern](../../patterns/claim-check.yml) supports processing large messages, such as file uploads.
- [Deployment Stamps pattern](../../patterns/deployment-stamp.yml) covers the general concepts required to scale the solution to millions of vehicles.
- [Throttling pattern](../../patterns/throttling.yml) describes the concepts needed to manage an exceptional number of messages from vehicles.

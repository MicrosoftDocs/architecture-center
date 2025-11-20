[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Project 15 Open Platform was developed in partnership with the GEF Small Grants Programme, which the United Nations Development Programme implemented. For more information, see [Project 15 from Microsoft – A story in five parts](https://techcommunity.microsoft.com/blog/greentechblog/project-15-from-microsoft-%e2%80%93-a-story-in-five-parts/2323531).

## Architecture

The following sections describe the functionality and architecture of Project 15 Open Platform.

:::image type="complex" source="../media/project-15-reference-architecture.svg" alt-text="A diagram that shows how Project 15 Open Platform collects, processes, analyzes, stores, secures, visualizes, and monitors IoT device data." border="false" lightbox="../media/project-15-reference-architecture.svg":::
The diagram shows the Azure components that make up Project 15 Open Platform. Boxes represent layers of the solution, such as the gateway, the data process layer, the presentation layer, and the storage layer. Arrows illustrate the flow of data between these layers and the interactions of users and devices with the system.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/project-15-reference-architecture.vsdx) of this architecture.*

### Workflow

The following Azure services and configurations make up Project 15 Open Platform:

1. The Azure IoT Hub device provisioning service provisions Internet of Things (IoT) devices and connects them to IoT Hub.

1. Streaming platforms and services build the data pipeline that's necessary for basic telemetry and event processing:

   - Azure Event Hubs ingests telemetry and events from IoT devices.
   - Azure Event Grid provides a publish-subscribe model that routes events.

1. Azure Stream Analytics analyzes data. Azure Functions processes data. Azure Time Series Insights monitors, analyzes, and stores data. These three services also feed data into a presentation layer.

1. Users connect to the presentation layer through browsers. In that layer:

   - Azure SignalR Service messaging provides real-time visualization.
   - Azure App Service and its Web Apps feature provide platforms that you can use to build, deploy, and scale web apps.
   - Tools like Power BI visualize IoT devices, telemetry, and events in websites.
   - Tools like Power Apps and Power Automate provide low-code apps and automated workflows.

1. Databases, Azure Blob Storage, and tables store telemetry and file data from offices in the field.

1. Other Azure components provide more functionality:

   - Azure Functions and Azure API Management work to make device management events available in websites.
   - Microsoft Entra ID manages users.
   - API Management and Event Grid manage external data.
   - Azure Digital Twins provides modeling capabilities that you can use to optimize operations.
   - Microsoft Defender for Cloud secures the solution by establishing security policies and access controls.
   - Azure Notification Hubs and Azure Logic Apps handle notifications.
   - Azure Machine Learning provides AI capabilities to help you predict device behavior.
   - Azure Maps tracks geofencing data to provide location-based services.

### Components

- [IoT Hub][IoT Hub] is a managed service for secure and scalable device-to-cloud communication. In this architecture, it connects devices to Azure cloud resources and enables zero-touch provisioning through its [device provisioning service][device provisioning service of IoT Hub]. You can use IoT Hub queries to filter data that you send to the cloud.

- [Event Hubs][Event Hubs] is a managed big data streaming platform. In this architecture, Event Hubs ingests telemetry and event data from IoT devices to support real-time analytics and processing.

- [Event Grid][Event Grid] is a service that enables event-based architectures. In this architecture, it routes events from sources to destinations and decouples event publishers from event subscribers.

- [Stream Analytics][Stream Analytics] is a real-time serverless stream processing service that can run queries in the cloud and on devices on the edge of the network. In this architecture, it filters and aggregates telemetry data from IoT devices for further processing or storage.

- [Functions][Functions] is an event-driven serverless compute platform that you can use to build and debug locally without extra setup. In this architecture, Functions processes incoming data and integrates services by using triggers and bindings.

- [Azure SignalR Service][Azure SignalR Service] is an open-source software library that provides a way to send notifications to web apps in real time. In this architecture, SignalR enables live data visualization in the presentation layer.

- [App Service][App Service] and its [Web Apps](/azure/well-architected/service-guides/app-service-web-apps) feature are managed platforms for building, deploying, and scaling web apps. In this architecture, they support the deployment and scaling of web interfaces for interacting with IoT data.

- [Power BI][Power BI] is a collection of software services and apps that you use to connect and visualize unrelated sources of data. In this architecture, Power BI visualizes telemetry and event data from IoT devices in dashboards and reports.

- [Blob Storage][Blob Storage] is a service that provides optimized cloud object storage for unstructured data. In this architecture, Blob Storage stores telemetry and file data collected from field devices.

- The [API Apps][API Apps] feature of App Service enables you to use to build and consume APIs in the cloud by using the language of your choice. In this architecture, API Apps exposes device management events and data to external systems.

- [Azure Digital Twins][Azure Digital Twins] is a modeling service for digital representations of physical environments. In this architecture, Azure Digital Twins models IoT devices and ecosystems to optimize operations, minimize costs, and improve insights.

- [Defender for Cloud][Defender for Cloud] is a security management service for hybrid cloud environments. In this architecture, it enforces security policies and protects workloads from threats.

- [Notification Hubs][Notification Hubs] is a push notification service that provides a push engine that you can use to send notifications to any platform from any back end. In this architecture, it sends alerts and updates to users across platforms.

- [Logic Apps][Logic Apps] is a service that automates workflows and integrates systems, services, and data across organizations by using a visual designer and prebuilt connectors. In this architecture, it orchestrates data flows and integrates services without requiring custom code.

- [Machine Learning][Machine Learning] is a cloud-based environment that you can use to train, deploy, automate, manage, and track machine learning models. You can use these models to forecast future behavior, outcomes, and trends. In this architecture, Machine Learning predicts device behavior and trends to support proactive decision-making.

- [Azure Maps][Azure Maps] is a service that provides geospatial capabilities, including mapping, routing, traffic, and location data, to power applications with real-time geographic context. In this architecture, Azure Maps tracks geofencing data and supports location-based insights.

- [Microsoft Power Platform][Microsoft Power Platform] is a low-code development suite for analyzing data, automating processes, and building apps, websites, and virtual agents. In this architecture, it enables rapid development of custom apps and workflows for interacting with IoT data.

## Scenario details

The goal of [Project 15 Open Platform][Project 15 from Microsoft] is to bring the latest Microsoft cloud and IoT technologies together to help scientific teams build sustainability and conservation solutions like species tracking and observation, poaching prevention, ecosystem monitoring, and pollution detection.

The core goals of Project 15 Open Platform are to:

* **Close the skills gap, boost innovation, and accelerate problem-solving.** Project 15 Open Platform is a ready-made platform that scientific developers can use for specific scenarios.

* **Decrease the time to deployment.** Project 15 Open Platform gets teams to 80% completion of their projects. This boost dramatically reduces the time that teams need to start making crucial insights.

* **Reduce development costs.** Project 15 Open Platform reduces overall development costs and makes building connected device-based solutions on Azure less complex. The open platform also gives teams opportunities to partner with the open-source developer community and universities.

:::image type="complex" source="../media/project-15-open-platform-overview.svg" alt-text="A diagram that provides an overview of Project 15 Open Platform functionality. Colors indicate the level of customization that each area requires." border="false" lightbox="../media/project-15-open-platform-overview.svg":::
The diagram shows the components and describes the functionality of Project 15 Open Platform. Bars show areas of functionality, such as user management and security. Boxes represent actions, like connecting devices and ingesting data, that the platform handles. Arrows that indicate the flow of data in the system are between the boxes. The components are color coded. Light green elements are fully included in the platform. Dark green elements are included but need customization. Blue elements aren't included by default and require full customization. The diagram also shows images of animals and plants that are connected to sensors and trackers. Arrows indicate that this data flows into the system and that the system can manage these devices.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/project-15-open-platform-overview.vsdx) of this architecture.*

Developers at Microsoft currently maintain Project 15 Open Platform, but it isn't an official Microsoft product.

The solution has three main categories:

* **Components that are fully included**

  Azure services make up the core infrastructure of the solution. You deploy these services only once, and then you expand them as you add devices to the solution. You don't need to fully understand these services to take advantage of the platform. To get a better understanding of these core components, see the following resources:

  - [Internet of Things event learning path][Internet of Things Learning Path]
  - [Introduction to Azure IoT][Introduction to Azure IoT]

* **Components that are included but need customization**

  The platform deploys these services for you, but you need to modify them to meet your solution's requirements. For more information on these services, see [Project 15 Open Platform developer guide][Project 15 Open Platform developer guide].

* **Components that aren't included and require full customization**

   You deploy the services to your own Azure account where you can then customize them to create your solution. Your IP address resides in this account. 

### Potential use cases

Project 15 Open Platform contributes the latest Azure and IoT technologies to conservation and ecosystem sustainability efforts. These technologies help accelerate scientific innovation in areas like:

- Species tracking and observation
- Poaching prevention
- Ecosystem monitoring
- Pollution detection

## Deploy this scenario

Deploy to Azure with the push of a button. The main components of the infrastructure for a standard IoT solution are then up and running.

For more information, see [Deploying Project 15 from Microsoft Open Platform][Deploying Project 15 from Microsoft Open Platform].

## Contributors

*This article is maintained by Microsoft. It was originally written and updated by the following contributors.*

Principal authors:

- [Sarah Maston](https://www.linkedin.com/in/smwmaston/) | Director, Global Partner Strategy
- [Daisuke Nakahara](https://www.linkedin.com/in/daisuke-nakahara/) | Director, Sony Semiconductor Solutions
- [Linda Nichols](https://www.linkedin.com/in/lynnaloo/) | App Innovation Global Black Belt

## Next steps

- For more information about deploying to Azure and customizing conservation and ecological sustainability solutions, see [Project 15 Open Platform on GitHub][Project 15 on GitHub].
- [Introduction to Azure IoT][Introduction to Azure IoT]
- [Internet of Things event learning path][Internet of Things Learning Path]
- [Microsoft and sustainability][Microsoft & Sustainability]
- [Seeed Studio's IoT into the wild][Seeed Studio's IoT Into the Wild]

## Related resources

- [IoT architectures](/azure/architecture/browse/?azure_categories=iot)

[API Apps]: /azure/app-service/overview
[App Service]: /azure/well-architected/service-guides/app-service-web-apps
[Defender for Cloud]: /azure/defender-for-cloud/defender-for-cloud-introduction
[Azure Digital Twins]: /azure/digital-twins/overview
[Azure Maps]: /azure/azure-maps/about-azure-maps
[Azure SignalR Service]: /aspnet/signalr/overview/getting-started/introduction-to-signalr
[Blob Storage]: /azure/well-architected/service-guides/azure-blob-storage
[Deploying Project 15 from Microsoft Open Platform]: https://microsoft.github.io/project15/Deploy/Deployment.html
[device provisioning service of IoT Hub]: /azure/iot-dps
[Event Hubs]: /azure/well-architected/service-guides/event-hubs
[Event Grid]: /azure/well-architected/service-guides/event-grid/reliability
[Functions]: /azure/well-architected/service-guides/azure-functions
[IoT Hub]: /azure/well-architected/service-guides/azure-iot-hub
[Logic Apps]: /azure/logic-apps/logic-apps-overview
[Machine Learning]: /azure/well-architected/service-guides/azure-machine-learning
[Microsoft & Sustainability]: https://www.microsoft.com/sustainability
[Notification Hubs]: /azure/notification-hubs/notification-hubs-push-notification-overview
[Power BI]: /power-bi/fundamentals/power-bi-overview
[Project 15 on GitHub]: https://microsoft.github.io/project15/
[Project 15 from Microsoft]: /shows/Azure-Videos/project-15
[Project 15 Open Platform Developer Guide]: https://microsoft.github.io/project15/Developer-Guide/DeveloperGuide.html
[Stream Analytics]: /azure/stream-analytics/stream-analytics-introduction
[Microsoft Power Platform]: /power-platform
[Internet of Things Learning Path]: https://techcommunity.microsoft.com/blog/iotblog/internet-of-things---event-learning-path-learn-to-build-iot-solutions-on-microso/1636151
[Introduction to Azure IoT]: /training/modules/introduction-to-azure-iot/
[Seeed Studio's IoT Into the Wild]: https://www.seeedstudio.com/iot_into_the_wild.html

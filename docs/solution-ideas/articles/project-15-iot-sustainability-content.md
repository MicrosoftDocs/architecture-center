[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

The mission of [Project 15 from Microsoft][Project 15 from Microsoft] is to empower scientists and conservationists around the world. The project pairs conservation teams with a community of developers, students, and Microsoft partners. Backed by the power of Azure and an Internet of Things (IoT) open platform, the project helps these teams capture and analyze the data they need to preserve critical species and ecosystems.

A key part of these solutions is the Project 15 Open Platform, which Microsoft designed and built. This open-source software connects to the cloud and securely manages devices that conservation projects use. Its architecture serves as a reference for building end-to-end IoT solutions.

By getting teams roughly 80 percent of the way to finished solutions, the Project 15 Open Platform helps meet these goals:

- **Close the skill gap**. The ready-made platform boosts innovation. Scientific developers can expand into specific use cases.
- **Increase speed to deployment**. By helping teams overcome technical challenges, the platform reduces the time needed to build crucial insights.
- **Lower the development cost**. The platform reduces complexity, resulting in lower overall development costs. It also opens up opportunities for partnering with open-source developer communities and universities.

## Potential use cases

With its Open Platform, Project 15 contributes the latest Azure and IoT technologies to conservation and ecosystem sustainability efforts. In so doing, Project 15 accelerates scientific innovation in these and other areas:

- Species tracking and observation
- Poaching prevention
- Ecosystem monitoring
- Pollution detection

## Architecture

The following sections provide insight into Project 15 Open Platform functionality and architecture.

:::image type="complex" source="../media/project-15-open-platform-overview.png" alt-text="Diagram providing an overview of Project 15 Open Platform functionality. Colors indicate the level of customization that each area requires.":::
Diagram showing components and functionality of the Project 15 Open Platform. Bars show areas of functionality, such as user management and security. Boxes represent actions that the platform handles like connect devices and ingest data. Between the boxes are arrows that indicate the flow of data in the system. The components are color coded. Light green elements are fully included in the platform. Dark green elements are included but need customization. Blue elements aren't included by default and require full customization. Images of animals and plants connected to sensors and trackers are also visible. Arrows indicate that their data flows into the system, and the system can manage these devices.
:::image-end:::

Open Platform components fall into these categories:

- **Fully included:** Azure Services that you deploy once. You expand these components when you add devices to the solution.

- **Included but needing customization:** Services that the solution deploys. You modify these services to suit your use case. See [Project 15 Open Platform Developer Guide][Project 15 Open Platform Developer Guide] for detailed information on these services. For a high-level view of the services, see [Solution details][Solution details] later in this article.

- **Not included and requiring full customization:** The place where intellectual property resides. Once you deploy the solution to your own Azure account, it's yours to build out. Think of how you use a word processor. The word processor is a tool, and the book you write is yours. The story you publish is yours, and the revenue you generate is yours. With Project 15 Open Platform, the same idea applies. This solution is a tool you use to create your own solutions.

### Solution details

:::image type="complex" source="../media/project-15-ref-architecture.png" alt-text="Diagram showing how the Project 15 Open Platform collects, processes, analyzes, stores, secures, visualizes, and monitors IoT device data.":::
Diagram showing the Azure components that make up the Project 15 Open Platform. Boxes represent layers of the solution, such as the gateway, the data process layer, the presentation layer, and the storage layer. Arrows show how data flows between these layers. Additional arrows show how users and devices interact with the system.
:::image-end:::

Various Azure services and configurations make up the Project 15 Open Platform:

1. The Azure IoT Hub device provisioning service provisions IoT devices and connects them to IoT Hub.

1. Streaming platforms and services build the data pipeline that's necessary for basic telemetry and event processing:

   - Azure Event Hubs ingests telemetry and events from IoT devices.
   - Azure Event Grid provides a publish-subscribe model that routes events.

1. Azure Stream Analytics analyzes data (**3a**). Azure Functions processes data (**3b**). And Azure Time Series Insights monitors, analyzes, and stores data (**3c**). These three services also feed data into a presentation layer.

1. Users connect to the presentation layer through browsers. In that layer:

   - Azure SignalR Service messaging provides real-time visualization.
   - Azure App Service and its Web Apps feature provide platforms for building, deploying, and scaling web apps.
   - Tools like Time Series Insights and Power BI visualize IoT devices, telemetry, and events in websites.

1. Databases, Azure Blob Storage, and tables store telemetry and file data from offices in the field.

1. Other Azure components provide additional functionality:

   - Azure Functions and the API Apps feature of Azure App Service work to make device management events available in websites.
   - Azure Active Directory (Azure AD) manages users.
   - API Apps and Event Grid manage external data.
   - Azure Digital Twins offers modeling capabilities for optimizing operations.
   - Microsoft Defender for Cloud secures the solution by establishing security policies and access controls.
   - Azure Notification Hubs and Azure Logic Apps handle notifications.
   - Azure Machine Learning provides AI capabilities for forecasting device behavior.
   - Azure Maps tracks geofencing data to provide location-based services.

### Components

- [IoT Hub][IoT Hub] connects devices to Azure cloud resources. With this managed service, you can use queries to filter data that you send to the cloud.

- The [device provisioning service of IoT Hub][device provisioning service of IoT Hub] makes zero-touch, just-in-time provisioning possible. With this IoT Hub helper service, you can provision devices in a secure and scalable manner.

- [Event Hubs][Event Hubs] is a fully managed big data streaming platform.

- [Event Grid][Event Grid] simplifies event-based apps. While decoupling event publishers from event subscribers, this service routes events from sources to destinations.

- [Stream Analytics][Stream Analytics] provides real-time serverless stream processing that can run queries in the cloud and on devices on the edge of the network. Stream Analytics on IoT Edge can filter or aggregate data that you send to the cloud for further processing or storage.

- [Functions][Functions] is an event-driven serverless compute platform that you can use to build and debug locally without additional setup. With Functions, you can deploy and operate at scale in the cloud and use triggers and bindings to integrate services.

- [Time Series Insights][Time Series Insights] is an analytics platform that you can use to monitor, analyze, and visualize IoT time series data.

- [Azure SignalR Service][Azure SignalR Service] is an open-source software library that provides a way to send notifications to web apps in real time.

- [App Service][App Service] and its [Web Apps][Web Apps] feature are fully managed platforms for building, deploying, and scaling web apps.

- [Power BI][Power BI] is a collection of software services and apps that you use to connect and visualize unrelated sources of data.

- [Blob Storage][Blob Storage] provides optimized cloud object storage that manages massive amounts of unstructured data.

- [API Apps][API Apps] is a feature of App Service that you can use to build and consume APIs in the cloud while using the language of your choice.

- [Azure AD][Azure AD] is a multi-tenant, cloud-based identity service that controls access to Azure and other cloud apps.

- [Azure Digital Twins][Azure Digital Twins] creates models of IoT devices and environments. You can use these digital representations to develop better products, optimize operations, minimize costs, and improve customer experiences.

- [Microsoft Defender for Cloud][Azure Defender] offers extended detection and response (XDR) capabilities that protect hybrid cloud workloads against threats.

- [Notification Hubs][Notification Hubs] provides a push engine that you can use to send notifications to any platform from any back end.

- [Logic Apps][Logic Apps] automates workflows. With this service, you can connect apps and data across clouds without writing code.

- [Machine Learning][Machine Learning] is a cloud-based environment you can use to train, deploy, automate, manage, and track machine learning models. With these models, you can forecast future behavior, outcomes, and trends.

- [Azure Maps][Azure Maps] offers geospatial APIs for adding maps, spatial analytics, and mobility solutions to apps.

## Deploy this scenario

- Deployment to Azure happens with the push of a button. The main components of the infrastructure for a standard IoT solution are then up and running.

- See [Deploying Project 15 from Microsoft Open Platform][Deploying Project 15 from Microsoft Open Platform].

## Next steps

- Visit [Project 15 on GitHub][Project 15 on GitHub] to deploy to Azure and learn more about customizing conservation and ecological sustainability solutions.
- [Microsoft & Sustainability][Microsoft & Sustainability]
- [AI for Earth][AI for Earth]
- The Project 15 team periodically adds content to the [Project 15 YouTube Channel][Project 15 YouTube Channel] and other [Microsoft learning channels][Microsoft learning channels].
- See [Introduction to Azure IoT][Introduction to Azure IoT].

## Related resources

- [Azure IoT reference architecture](/azure/architecture/reference-architectures/iot)
- [Getting started with Azure IoT solutions](/azure/architecture/reference-architectures/iot/iot-architecture-overview)
- [Environment monitoring and supply chain optimization with IoT](/azure/architecture/solution-ideas/articles/environment-monitoring-and-supply-chain-optimization)

[AI for Earth]: https://www.microsoft.com/ai/ai-for-earth
[API Apps]: https://azure.microsoft.com/services/app-service/api/
[App Service]: https://azure.microsoft.com/services/app-service/
[Azure AD]: /azure/active-directory/fundamentals/active-directory-whatis
[Azure Defender]: https://azure.microsoft.com/services/azure-defender/
[Azure Digital Twins]: https://azure.microsoft.com/services/digital-twins/
[Azure Maps]: https://azure.microsoft.com/services/azure-maps/
[Azure SignalR Service]: /aspnet/signalr/overview/getting-started/introduction-to-signalr
[Blob Storage]: /azure/storage/blobs/storage-blobs-introduction
[Deploying Project 15 from Microsoft Open Platform]: https://microsoft.github.io/project15/Deploy/Deployment.html
[device provisioning service of IoT Hub]: /azure/iot-dps/
[Event Hubs]: /azure/event-hubs/event-hubs-about
[Event Grid]: https://azure.microsoft.com/services/event-grid/
[Functions]: https://azure.microsoft.com/services/functions/
[Introduction to Azure IoT]: /learn/paths/introduction-to-azure-iot/
[IoT Hub]: https://azure.microsoft.com/services/iot-hub/
[Logic Apps]: https://azure.microsoft.com/services/logic-apps/
[Machine Learning]: /azure/machine-learning/overview-what-is-azure-ml
[Microsoft learning channels]: /learn/
[Microsoft & Sustainability]: https://www.microsoft.com/sustainability
[Notification Hubs]: /azure/notification-hubs/notification-hubs-push-notification-overview
[Power BI]: /power-bi/fundamentals/power-bi-overview
[Project 15 on GitHub]: https://aka.ms/project15code
[Project 15 from Microsoft]: https://aka.ms/project15
[Project 15 Open Platform Developer Guide]: https://microsoft.github.io/project15/Developer-Guide/DeveloperGuide.html
[Project 15 YouTube Channel]: https://aka.ms/project15video
[Solution details]: #solution-details
[Stream Analytics]: https://azure.microsoft.com/services/stream-analytics
[Time Series Insights]: https://azure.microsoft.com/services/time-series-insights/
[Web Apps]: https://azure.microsoft.com/services/app-service/web/

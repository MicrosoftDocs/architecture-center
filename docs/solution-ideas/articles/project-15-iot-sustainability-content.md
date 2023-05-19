[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

## About Project 15 Open Platform

The goal with [Project 15 Open Platform][Project 15 from Microsoft] is to bring the latest Microsoft cloud and Internet of Things (IoT) technologies to accelerate scientific teams building sustainability and conservation solutions like species tracking & observation, poaching prevention, ecosystem monitoring, pollution detection, etc.

The core goals of the P15 Open Platform are:

* Close the Skill Gap Boost innovation with a ready-made platform, allowing the scientific developer to expand into specific use cases.
* Increase Speed to Deployment Open Platform get teams 80% of the way with their projects, dramatically reducing the time to start building crucial insights.
* Lower the development cost The Open Platform lowers the cost of overall development and reduces complexity. Opens up opportunities for partnering with the Open Source developer community and universities.

Currently maintained by developers at Microsoft, Project 15’s Open Platform is not an official product from Microsoft.

## Architecture

The following sections provide insight into Project 15 Open Platform functionality and architecture.

:::image type="complex" source="../media/project-15-open-platform-overview-new.png" alt-text="Diagram providing an overview of Project 15 Open Platform functionality. Colors indicate the level of customization that each area requires.":::
Diagram showing components and functionality of the Project 15 Open Platform. Bars show areas of functionality, such as user management and security. Boxes represent actions that the platform handles like connect devices and ingest data. Between the boxes are arrows that indicate the flow of data in the system. The components are color coded. Light green elements are fully included in the platform. Dark green elements are included but need customization. Blue elements aren't included by default and require full customization. Images of animals and plants connected to sensors and trackers are also visible. Arrows indicate that their data flows into the system, and the system can manage these devices.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/project-15-open-platform-overview.vsdx) of this architecture.*

### Solution Overview

The solution has three main categories:

* **Components that are fully included**

These are Azure services that if someone was standing up the solution these parts of the infrastructure only need to be deployed once and then expanded as devices get added to the solution. To learn all the ins and outs of these services is a lift and would take time. Our theory here is that by this method, the technologist doesn't need to know every nitty-gritty detail and can expand their learning as needed. For learning about building an IoT Solution, a great resource to ramp up quickly on the concepts with real world examples and labs is available at [Internet of Things Learning Path](Internet of Things Learning Path). Of course, if one wants to learn all the details, Microsoft Learn's [Introduction to Azure IoT](Introduction to Azure IoT) has all you need. All our learning resources here, are free to you.

* **Included Components but needs customization**

Here the solution will deploy these services for you, but you will start to modify and add to them based on your use case. The details of the services here are all explained in our [Project 15 Open Platform Developer Guide][Project 15 Open Platform Developer Guide]. The high level architecture of what services are involved, see below.

* **Not Included, requires full customization**

This is the part where your IP will reside.  How this works is once you `Deploy` the solution to your own Azure account, **it is yours to build out**. Think of how you use a word processor. The word processor is a tool and the book you write, is yours. Meaning the story you publish is yours, the revenue generated is yours. Same idea. This solution is a tool for you to use to write your own solutions.

### Solution details

:::image type="complex" source="../media/project-15-ref-arch-2023.png" alt-text="Diagram showing how the Project 15 Open Platform collects, processes, analyzes, stores, secures, visualizes, and monitors IoT device data.":::
Diagram showing the Azure components that make up the Project 15 Open Platform. Boxes represent layers of the solution, such as the gateway, the data process layer, the presentation layer, and the storage layer. Arrows show how data flows between these layers. Arrows show how users and devices interact with the system.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/project-15-ref-arch-2023.vsdx) of this architecture.*

Various Azure services and configurations make up the Project 15 Open Platform:

1. The Azure IoT Hub device provisioning service provisions IoT devices and connects them to IoT Hub.

1. Streaming platforms and services build the data pipeline that's necessary for basic telemetry and event processing:

   - Azure Event Hubs ingests telemetry and events from IoT devices.
   - Azure Event Grid provides a publish-subscribe model that routes events.

1. Azure Stream Analytics analyzes data (**3a**). Azure Functions processes data (**3b**). And Azure Time Series Insights monitors, analyzes, and stores data (**3c**). These three services also feed data into a presentation layer.

1. Users connect to the presentation layer through browsers. In that layer:

   - Azure SignalR Service messaging provides real-time visualization.
   - Azure App Service and its Web Apps feature provide platforms for building, deploying, and scaling web apps.
   - Tools like Power BI visualize IoT devices, telemetry, and events in websites.
   - Tools like Power Apps and Power Automate solve the "app gap challenge" and proview low-code apps and automated workflows.

1. Databases, Azure Blob Storage, and tables store telemetry and file data from offices in the field.

1. Other Azure components provide more functionality:

   - Azure Functions and Azure API Management work to make device management events available in websites.
   - Azure Active Directory (Azure AD) manages users.
   - API Management and Event Grid manage external data.
   - Azure Digital Twins offers modeling capabilities for optimizing operations.
   - Microsoft Defender for Cloud secures the solution by establishing security policies and access controls.
   - Azure Notification Hubs and Azure Logic Apps handle notifications.
   - Azure Machine Learning provides AI capabilities for forecasting device behavior.
   - Azure Maps tracks geofencing data to provide location-based services.

### Components

- [IoT Hub][IoT Hub] connects devices to Azure cloud resources. With this managed service, you can use queries to filter data that you send to the cloud.

- The [device provisioning service of IoT Hub][device provisioning service of IoT Hub] makes zero-touch, just-in-time provisioning possible. With this IoT Hub helper service, you can provision devices in a secure and scalable manner.

- [Event Hubs][Event Hubs] is a fully managed big data streaming platform.

- [Event Grid][Event Grid] simplifies event-based apps. This service routes events from sources to destinations while decoupling event publishers from event subscribers.

- [Stream Analytics][Stream Analytics] provides real-time serverless stream processing that can run queries in the cloud and on devices on the edge of the network. Stream Analytics on IoT Edge can filter or aggregate data that you send to the cloud for further processing or storage.

- [Functions][Functions] are an event-driven serverless compute platform that you can use to build and debug locally without extra setup. With Functions, you can deploy and operate at scale in the cloud and use triggers and bindings to integrate services.

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

- [Microsoft Power Platform][Microsoft Power Platform] provides a low-code development platform for analyzing data, automating processes, and building apps, websites, and virtual agents.

### Potential use cases

[Project 15 Open Platform][Project 15 on GitHub] contributes the latest Azure and IoT technologies to conservation and ecosystem sustainability efforts. In so doing, Project 15 accelerates scientific innovation in these and other areas:

- Species tracking and observation
- Poaching prevention
- Ecosystem monitoring
- Pollution detection

## Deploy this scenario

- Deployment to Azure happens with the push of a button. The main components of the infrastructure for a standard IoT solution are then up and running.

- See [Deploying Project 15 from Microsoft Open Platform][Deploying Project 15 from Microsoft Open Platform].

## Contributors

*This article is maintained by Microsoft. It was originally written and updated by the following contributors.*

Principal author:

 * [Sarah Maston](https://www.linkedin.com/in/smwmaston/) | Director, Global Partner Development
 * [Daisuke Nakahara](https://www.linkedin.com/in/daisuke-nakahara/) Director, Sony Semiconductor Solutions
 * [Linda Nichols]() | App Innovation Global Blackbelt
 * [Pamela Cortez](https://www.linkedin.com/in/pamelacortezhellotechie) | Azure IoT Principal PM

## Next steps

- Visit [Project 15 on GitHub][Project 15 on GitHub] to deploy to Azure and learn more about customizing conservation and ecological sustainability solutions.
- See [Introduction to Azure IoT][Introduction to Azure IoT]
- See [Internet of Things Learning Path](Internet of Things Learning Path)
- [Planetary Computer](https://planetarycomputer.microsoft.com/) 
- [Microsoft & Sustainability][Microsoft & Sustainability]
- [Seeed Studio’s IoT Into the Wild](https://www.seeedstudio.com/iot_into_the_wild.html)

## Related resources

- [Azure IoT reference architecture](/azure/architecture/reference-architectures/iot)
- [Getting started with Azure IoT solutions](/azure/architecture/reference-architectures/iot/iot-architecture-overview)
- [Environment monitoring and supply chain optimization with IoT](/azure/architecture/solution-ideas/articles/environment-monitoring-and-supply-chain-optimization)

[API Apps]: https://azure.microsoft.com/services/app-service/api
[App Service]: https://azure.microsoft.com/services/app-service
[Azure AD]: /azure/active-directory/fundamentals/active-directory-whatis
[Azure Defender]: https://azure.microsoft.com/services/azure-defender
[Azure Digital Twins]: https://azure.microsoft.com/services/digital-twins
[Azure Maps]: https://azure.microsoft.com/services/azure-maps
[Azure SignalR Service]: /aspnet/signalr/overview/getting-started/introduction-to-signalr
[Blob Storage]: /azure/storage/blobs/storage-blobs-introduction
[Deploying Project 15 from Microsoft Open Platform]: https://microsoft.github.io/project15/Deploy/Deployment.html
[device provisioning service of IoT Hub]: /azure/iot-dps
[Event Hubs]: /azure/event-hubs/event-hubs-about
[Event Grid]: https://azure.microsoft.com/services/event-grid
[Functions]: https://azure.microsoft.com/services/functions
[Introduction to Azure IoT]: /training/paths/introduction-to-azure-iot
[IoT Hub]: https://azure.microsoft.com/services/iot-hub
[Logic Apps]: https://azure.microsoft.com/services/logic-apps
[Machine Learning]: /azure/machine-learning/overview-what-is-azure-ml
[Microsoft & Sustainability]: https://www.microsoft.com/sustainability
[Notification Hubs]: /azure/notification-hubs/notification-hubs-push-notification-overview
[Power BI]: /power-bi/fundamentals/power-bi-overview
[Project 15 on GitHub]: https://aka.ms/project15code
[Project 15 from Microsoft]: /shows/Azure-Videos/project-15
[Project 15 Open Platform Developer Guide]: https://microsoft.github.io/project15/Developer-Guide/DeveloperGuide.html
[Project 15 YouTube Channel]: https://aka.ms/project15video
[Solution details]: #solution-details
[Stream Analytics]: https://azure.microsoft.com/services/stream-analytics
[Web Apps]: https://azure.microsoft.com/services/app-service/web
[Microsoft Power Platform]: https://powerplatform.microsoft.com
[Internet of Things Learning Path]: https://aka.ms/iotlp
[Introduction to Azure IoT]: https://docs.microsoft.com/learn/paths/introduction-to-azure-iot/

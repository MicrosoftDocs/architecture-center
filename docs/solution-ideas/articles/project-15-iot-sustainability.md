---
title: Project 15 from Microsoft Open Platform for Conservation and Ecological Sustainability Solutions
titleSuffix: Azure Solution Ideas
author: AltaOhms
description: Learn how to use Project 15 reference architecture and conservation and ecosystem sustainability to bring the latest Internet of Things (IoT) technologies to accelerate scientific teams building solutions like species tracking & observation, poaching prevention, ecosystem monitoring, pollution detection, and so on.
ms.date: 11/09/2020
ms.custom: iot, fcp
ms.service: architecture-center
ms.subservice: solution-idea
ms.category:
  - iot
---

# Project 15 from Microsoft Open Platform for Conservation and Ecological Sustainability Solutions

The mission of [Project 15 from Microsoft](https://aka.ms/project15) is to empower scientists and conservationists around the world. The project pairs conservation teams with a community of developers, students, and Microsoft partners. Backed by the power of the Microsoft cloud and an Internet of Things (IoT) open platform, the project helps these teams capture and analyze the data they need to preserve critical species and ecosystems.

A key part of solutions is the Project 15 Open Platform, which Microsoft designed and built. This open-source software connects to the cloud and securely manages devices that conservation projects use. Its architecture functions as a reference in teams' building-related end-to-end IoT solutions.

The Project 15 Open Platform gets teams roughly 80 percent of the way to finished solutions and helps them meet these goals:

- **Close the skill gap**  
  The ready-made platform boosts innovation. Scientific developers can expand into specific use cases.
- **Increase speed to deployment**  
  By helping teams overcome technical challenges, the platform reduces the time needed to build crucial insights.
- **Lower the development cost**  
  The platform reduces complexity, resulting in lower overall development costs. It also opens up opportunities for partnering with open-source developer communities and universities.

## Potential use cases

With its Open Platform, Project 15 contributes the latest Microsoft cloud and IoT technologies to conservation and ecosystem sustainability efforts. In so doing, Project 15 accelerates scientific innovation in these and other areas:

- Species tracking and observation
- Poaching prevention
- Ecosystem monitoring
- Pollution detection

## Architecture

The following sections provide an overview of Project 15 Open Platform functionality and a detailed view of its architecture.

### Solution overview

![Project 15 Open Platform Overview Architecture](../media/project-15-open-platform-overview.png)

Open Platform components fall into these categories:

- **Components that are fully included:** Azure Services that you deploy once. You expand these components when you add devices to the solution.

- **Components that are included but need customization:** Services that the solution deploys. You modify these services to suit your use case. See [Project 15 Open Platform Developer Guide](https://microsoft.github.io/project15/Developer-Guide/DeveloperGuide.html) for detailed information on these services. For a high-level view of the services, see [Solution details](#solution-details) later in this article.  

- **Components that aren't included and require full customization:** The place where intellectual property resides. Once you deploy the solution to your own Azure account, it's yours to build out. Think of how you use a word processor. The word processor is a tool, and the book you write is yours. The story you publish is yours, and the revenue you generate is yours. With Project 15 Open Platform, the same idea applies. This solution is a tool you use to create your own solutions.

### Solution details

![Project 15 Open Platform Reference Architecture](../media/project-15-ref-architecture.png)

Various Azure services and configurations make up the Project 15 Open Platform:

1. The Azure IoT Hub device provisioning service provisions IoT devices and connects them to IoT Hub.

1. Streaming platforms and services build the data pipeline that's necessary for basic telemetry and event processing:

   - Event Hubs ingests telemetry and events from IoT devices.
   - Event Grid provides a publish-subscribe model that routes events.

1. Stream Analytics analyzes data (**3a**). Azure Functions processes data (**3b**). And Time Series Insights monitors, analyzes, and stores data (**3c**). These three services also feed data into a presentation layer.

1. Users connect to the presentation layer through browsers. In that layer:

   - SignalR messaging provides real-time visualization.
   - App Service and Web Apps provide platforms for building, deploying, and scaling web apps.
   - Tools like Time Series Insights and Power BI visualize IoT devices, telemetry, and events in websites.

1. Databases, blob storage, and tables store telemetry and file data that offices upload.

1. Other Azure components provide additional functionality:

   - API Apps and Azure Functions work to make device management events available in websites.
   - Azure Active Directory manages users.
   - API Apps and Event Grid manage external data.
   - Azure Digital Twins offers modeling capabilities for optimizing operations.
   - Azure Defender secures the solution by establishing security policies and access controls.
   - Azure Notification Hubs and Azure Logic Apps handle notifications.
   - Azure Machine Learning provides AI capabilities for forecasting device behavior.
   - Azure Maps tracks geofencing data to provide location-based services.

## Components

- [Device Provisioning Service (DPS)](https://docs.microsoft.com/azure/iot-dps/) makes zero-touch, just-in-time provisioning possible. With this IoT Hub helper service, you can provision devices in a secure and scalable manner.
- [Azure Event Hubs](https://docs.microsoft.com/azure/event-hubs/event-hubs-about) is a fully managed big data streaming platform.
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/) connects devices to Azure cloud resources. With this managed service, you can use queries to filter data that you send to the cloud.
- [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics) provides real-time serverless stream processing that can run queries in the cloud and on devices on the edge of the network. ASA on IoT Edge can filter or aggregate data that you need to send to the cloud for further processing or storage.
- [Azure Functions](https://azure.microsoft.com/services/functions/) is an event-driven serverless compute platform that you can use to build and debug locally without additional setup. With Functions, you can deploy and operate at scale in the cloud. By using its triggers and bindings, you can integrate services.
- [Time Series Insights](https://azure.microsoft.com/services/time-series-insights/) is an analytics platform that you can use to monitor, analyze, and visualize IoT time series data.
- [Azure Maps](https://azure.microsoft.com/services/azure-maps/) offers geospatial APIs for adding maps, spatial analytics, and mobility solutions to apps.
- [App Service](https://azure.microsoft.com/services/app-service/) and [Web Apps](https://azure.microsoft.com/services/app-service/web/) are fully managed platforms for building, deploying, and scaling web apps.
- [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins/) creates models of IoT devices and environments. You can use these digital representations to learn how to develop better products, optimize operations, minimize costs, and improve customer experiences.
- [Azure Machine Learning](https://docs.microsoft.com/azure/machine-learning/overview-what-is-azure-ml) is a cloud-based environment you can use to train, deploy, automate, manage, and track machine learning models. With these models, you can forecast future behavior, outcomes, and trends.
- [Event Grid](https://azure.microsoft.com/services/event-grid/) simplifies event-based apps. While decoupling event publishers from event subscribers, this service routes events from sources to destinations.
- [API Apps](https://azure.microsoft.com/services/app-service/api/) is a feature of App Service that you can use to build and consume APIs in the cloud while using the language of your choice.
- [SignalR](https://docs.microsoft.com/aspnet/signalr/overview/getting-started/introduction-to-signalr) is an open-source software library that provides a way to send notifications to web apps in real time.
- [Power BI ](https://docs.microsoft.com/power-bi/fundamentals/power-bi-overview) is a collection of software services and apps that you use to connect and visualize unrelated sources of data.
- [Azure Active Directory](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis) is a multi-tenant, cloud-based identity service that controls access to Azure and other cloud apps.
- [Azure Defender](https://azure.microsoft.com/services/azure-defender/) offers extended detection and response (XDR) capabilities that protect hybrid cloud workloads against threats.
- [Azure Notification Hubs](https://docs.microsoft.com/azure/notification-hubs/notification-hubs-push-notification-overview) provides a push engine that you can use to send notifications to any platform from any back end.
- [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps/) automate workflows. With this service, you can connect apps and data across clouds without writing code.

## Deploy this scenario

- Deployment to Azure happens with the push of a button. The main components of the infrastructure for a standard IoT Solution are then up and running.

- Documentation is available for common scenarios such as simulating device data and connecting devices. Over time, the Project 15 team adds content to the [Project 15 YouTube Channel](https://aka.ms/project15video) and other [Microsoft learning channels](https://docs.microsoft.com/learn/).

## Next steps

Visit [Project 15 on GitHub](https://aka.ms/project15code) to deploy to Azure and learn more about customizing conservation and ecological sustainability solutions.

## Related resources

- [Microsoft & Sustainability](https://www.microsoft.com/sustainability)
- [AI for Earth](https://www.microsoft.com/ai/ai-for-earth)

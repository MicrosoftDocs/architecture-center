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

The mission of [Project 15 from Microsoft](https://aka.ms/project15) is to empower scientists and conservationists around the world. The project pairs conservation teams with a community of developers, students, and Microsoft partners. Backed by the power of the Microsoft cloud and the Internet of Things (IoT) Open Platform, the project helps these teams capture and analyze the data they need to preserve critical species and ecosystems.

The Project 15 Open Platform plays a key role in solutions. This open-source software, which Microsoft designed and built, connects to the cloud. The platform manages and secures devices that conservation projects use.

The Project 15 Open Platform gets teams roughly 80% of the way to a finished solution. The architecture functions as a reference in teams' building-related end-to-end IoT solutions. Project 15 Open Platform can help teams accomplish these goals:

- **Close the skill gap**  
  The ready-made platform boosts innovation. Scientific developers can expand into specific use cases.
- **Increase speed to deployment**  
  By helping teams overcome technical challenges, the platform reduces the time needed to build crucial insights.
- **Lower the development cost**  
  The Open Platform reduces complexity, resulting in lower overall development costs. The platform also opens up opportunities for partnering with the open-source developer community and universities.

Deployment to Azure happens with the push of a button. The main components of the infrastructure for a standard IoT Solution are then up and running. Documentation of common scenarios is available, such as simulating device data and connecting devices. Over time, the Project 15 team will add content to the [Project 15 YouTube Channel](https://aka.ms/project15video) and other Microsoft Learning channels.

## Potential use cases

By contributing the latest Microsoft cloud and IoT technologies to conservation and ecosystem sustainability open platforms, Project 15 accelerates scientific innovation in these and other areas:

- Species tracking and observation
- Poaching prevention
- Ecosystem monitoring
- Pollution detection

## Solution overview

![Project 15 Open Platform Overview Architecture](../media/project-15-open-platform-overview.png)

1. **Components that are fully included:** These components are Azure Services that only need to be deployed once and then expanded as devices get added to the solution.

1. **Included components, but needs customization:** The solution will deploy services, but services will need to be modify based on different use cases. The details of the services here are all explained in the [Project 15 Open Platform Developer Guide](https://microsoft.github.io/project15/Developer-Guide/DeveloperGuide.html). The high level architecture of what services are involved, see below.  

1. **Not included, requires full customization:** This is the part where intellectual property will reside. Once you deploy the solution to your own Azure account, **it is yours to build out**. Think of how you use a word processor. The word processor is a tool and the book you write is yours. Meaning the story you publish is yours, and the revenue generated is yours. Same idea. This solution is a tool for you to use to write your own solutions.

## Reference architecture

![Project 15 Open Platform Reference Architecture](../media/project-15-ref-architecture.png)

Project 15 Open Platform consists of multiple Azure services and configurations:

- Device Provisioning Service provisions IoT devices and connects them to IoT Hub.

- Streaming platforms and services build the data pipeline that's necessary for basic telemetry and event processing:

  - Event Hubs ingests telemetry and events from IoT devices.
  - Event Grid provides a publish-subscribe model that routes events.

- Databases, blob storage, and tables store telemetry and file data that offices upload.

- Azure Functions processes data. Stream Analytics analyzes data. And Time Series Insights monitors, analyzes, and stores data. These three services also feed data into a presentation layer.

- Users connect to the presentation layer through browsers. In that layer:

  - SignalR messaging provides real-time visualization.
  - App Service and Web App provide platforms for building, deploying, and scaling web apps.
  - Tools like Time Series Insights and Power BI visualize IoT devices, telemetry, and events in websites.

- Other Azure components provide additional functionality:

  - API Apps and Azure Functions work to make device management events available in websites.
  - Azure Active Directory manages users.
  - API Apps and Event Grid manage external data.
  - Azure Digital Twins offers modeling capabilities for optimizing operations.
  - Azure Defender secures the solution by establishing security policies and access controls.
  - Notification Hub and Logic Apps handle notifications.
  - Azure Machine Learning provides AI capabilities for forecasting device behavior.
  - Azure Maps tracks geofencing data to provide location-based services.

## Components

- [Device Provisioning Service (DPS)](https://docs.microsoft.com/azure/iot-dps/) makes zero-touch, just-in-time provisioning possible. With this IoT Hub helper service, you can provision devices in a secure and scalable manner.
- [Azure Event Hubs](https://docs.microsoft.com/azure/event-hubs/event-hubs-about) is a fully managed big data streaming platform.
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/) connects devices to Azure cloud resources. With this managed service, you can use queries to filter data that you send to the cloud.
- [Azure Stream Analytics (ASA)](https://azure.microsoft.com/services/stream-analytics) provides real-time serverless stream processing that can run queries in the cloud and on devices on the edge of the network. ASA on IoT Edge can filter or aggregate data that you need to send to the cloud for further processing or storage.
- [Azure Functions](https://azure.microsoft.com/services/functions/) is an event-driven serverless compute platform that you can use to build and debug locally without additional setup. With Functions, you can deploy and operate at scale in the cloud. And by using triggers and bindings, you can integrate services.
- [Time Series Insights](https://azure.microsoft.com/services/time-series-insights/) store and visualize time series data for the solution.
- [Azure Maps](https://azure.microsoft.com/services/azure-maps/) provides tracking and location information for the solution.
- [App Service](https://azure.microsoft.com/services/app-service/) and [Web Apps](https://azure.microsoft.com/services/app-service/web/) are fully managed platforms for building, deploying, and scaling web apps.
- [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins/) creates models of IoT devices and environments. You can use these digital representations to learn how to develop better products, optimize operations, minimize costs, and improve customer experiences.
- [Azure Machine Learning](https://docs.microsoft.com/azure/machine-learning/overview-what-is-azure-ml) is a cloud-based environment you can use to train, deploy, automate, manage, and track machine learning models. With these models, you can forecast future behavior, outcomes, and trends.
- [Event Grid](https://azure.microsoft.com/services/event-grid/) simplifies event-based apps. While decoupling event publishers from event subscribers, this service routes events from sources to destinations.
- [API Apps](https://azure.microsoft.com/services/app-service/api/) is a feature of App Service that you can use to build and consume APIs in the cloud while using the language of your choice.
- [SignalR](https://docs.microsoft.com/aspnet/signalr/overview/getting-started/introduction-to-signalr) is an open-source software library that provides a way to send notifications to web apps in real time.







## Next steps

Visit the [Project 15 on GitHub](https://aka.ms/project15code) to deploy to Azure and learn more about how to customize to different Conservation and Ecological Sustainability Solutions.

## Related resources

- [Microsoft & Sustainability](https://www.microsoft.com/sustainability)
- [AI for Earth](https://www.microsoft.com/ai/ai-for-earth)

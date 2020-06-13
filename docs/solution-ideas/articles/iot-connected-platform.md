---
title: IoT Connected Platform for COVID-19 detection and prevention
titleSuffix: Azure Solution Ideas
author: doodlemania2
description: Deploy a connected ecosystem of intelligent IoT Edge devices, Azure services, and cloud-powered apps to help detect and prevent COVID-19.
ms.date: 06/12/2020
ms.custom: iot, fcp
ms.service: architecture-center
ms.subservice: solution-idea
---

# IoT Connected Platform for COVID-19 detection and prevention

How can we reopen corporate and public spaces As Soon And Safely As Possible (ASASAP), so people can be and feel safe getting back to work and play? Insight's [Connected Platform for Detection and Prevention](https://www.insight.com/en_US/what-we-do/digital-innovation/solutions/connected-platform-for-detection-and-prevention.html) is a flexible and scalable solution to help create smarter and safer public spaces. Connected Platform can rapidly deploy and manage a connected ecosystem of [intelligent edge](https://azure.microsoft.com/overview/future-of-cloud/) technology like thermal cameras, proximity and occupancy monitors, hand sanitizer dispensers, and portable onsite virus testing pods.

This article describes a Connected Platform solution to help provide COVID-19 protection at a theme park.

- Thermal cameras and contactless thermometers take temperatures of people entering the park.
- Portable, interactive virus testing centers can provide rapid, discreet onsite virus testing for those who fail temperature checks.
- Anomaly-detecting smart cones monitor safe distancing in groups and lines.
- Smart, connected hand sanitizer dispensers monitor usage and supply levels throughout the park.
- Interactive, data-driven audio devices and bots deliver appropriate proximity alerts, reminders, and instructions to employees and guests.
- Data driven reporting lets stakeholders monitor results and overall trends.

## Potential use cases

- Controlled-entry spaces like offices, factories, airports, stadiums, and amusement parks.
- Large, high-usage spaces with potential for crowds and lines.

## Architecture

![Insight Connected Platform architecture](../media/insight-connected-platform.png)

1. Thermal cameras and other sensors provide temperature and visual data to the Internet of Things (IoT) Edge gateway, which does some preprocessing.
2. Azure IoT Hub communicates with and controls the IoT Edge network, and streams data to the Azure cloud.
3. In the cloud, data flows as appropriate to event processing, data analysis, and storage services like Azure Stream Analytics, Azure Databricks, and Azure Data Lake Storage.
4. Processed data and domain-specific information feed into [Docker](https://www.docker.com/) containerized microservices apps in Azure Kubernetes Service (AKS).
5. The microservices apps trigger alerting and messaging services like email and bots.
6. Azure API Management incorporates internal and external APIs when deploying to end-user experiences like web apps, mobile apps, Azure maps, and [Power BI](https://powerbi.microsoft.com) reports and visualizations.
7. Azure components and deployed apps can share Azure services like [Azure Active Directory](https://azure.microsoft.com/services/active-directory/), [Azure Key Vault](https://azure.microsoft.com/services/key-vault/), and [Azure Monitor](https://azure.microsoft.com/services/monitor/).

## Components

- [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge/) intelligent devices can recognize and respond to sensor input by using onboard processing. These devices can respond quickly or even offline, and limit costs by preprocessing and sending only necessary data to the cloud.
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/) connects virtually any IoT device with Azure cloud services. IoT Hub enables highly secure and reliable bi-directional communication, management, and provisioning for IoT Edge devices.
- [Azure Stream Analytics (ASA)](https://azure.microsoft.com/services/stream-analytics) provides real-time serverless stream processing with built-in machine learning (ML) models to perform anomaly detection directly in streaming jobs.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/) is a data lake storage solution for big data analytics, combining [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/) capabilities with a high-performance file system.
- [Azure Databricks](https://azure.microsoft.com/services/databricks/) is a fast, easy, and collaborative Apache Spark-based analytics service that can read and analyze data lake data.
- [Azure Cognitive Services](https://azure.microsoft.com/services/cognitive-services/) are artificial intelligence (AI) services and cognitive APIs that help build intelligent apps. For example, [Computer Vision](https://azure.microsoft.com/services/cognitive-services/computer-vision/) can help count and monitor people density and movements.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service/) is a service for developing, deploying, and managing containerized applications.
- Azure [API Management](https://azure.microsoft.com/services/api-management/) can deploy Azure and external APIs side by side to optimize traffic flow and provide unified management and observability, while ensuring security and compliance.

## Next steps

- For more information, please contact [iotcovid@microsoft.com](mailto:iotcovid@microsoft.com), and see [Connected Platform for Detection and Prevention](https://www.insight.com/en_US/what-we-do/digital-innovation/solutions/connected-platform-for-detection-and-prevention.html).
- For more information about the Insight Connected Platform, see [Connected Platform](https://www.insight.com/en_US/what-we-do/digital-innovation/connected-platform.html).

## Related resources
- [Anomaly detection in Azure Stream Analytics](https://docs.microsoft.com/azure/stream-analytics/stream-analytics-machine-learning-anomaly-detection)
- [Microservices architecture on Azure Kubernetes Service (AKS)](https://docs.microsoft.com/azure/architecture/reference-architectures/microservices/aks)

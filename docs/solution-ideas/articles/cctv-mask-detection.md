---
title: Contactless IoT interfaces with Azure intelligent edge
titleSuffix: Azure Solution Ideas
author: doodlemania2
description: Combine intelligent and perceptive edge devices with the storage and computing power of the cloud to create touch-free interfaces.
ms.date: 06/06/2020
ms.custom: iot, fcp
ms.service: architecture-center
ms.subservice: solution-idea
---

# People-safe solutions at the IoT Edge

The new normal workplace and other group spaces need to follow health and safety guidelines around safe social distancing, mask and PPE use, and occupancy limits. **Bosch COVID-19 Safe Solution** combines existing closed-circuit TV (CCTV) infrastructure with the [Azure intelligent edge](https://azure.microsoft.com/overview/future-of-cloud/) and other Azure and Microsoft services to help organizations monitor, comply, and update these health and safety practices.

This article showcases a COVID-19 Safe Solution implementation at a major North American auto manufacturing facility. Goals were to:

- Ensure a safe work environment when resuming manufacturing after the COVID-19 lockdown.
- Monitor and enforce compliance with face mask policy, social distancing, and occupancy limits on factory premises.
- Increase visibility and control through efficient reporting and interactive dashboards.
- Deliver alerts and notifications so health and safety stakeholders could address safety violations and concerns.
- Improve compliance, reduce violations, and enable well-informed safety decisions over time.

## Potential use cases

- Spaces with existing CCTV infrastructure.
- Stores, restaurants, offices, factories and warehouses, public transportation, hospitals, schools, and entertainment and recreation spaces.
- Organizations with multiple locations, to enable widespread, systemic data analysis and actions.

## Architecture

![Bosch COVID-19 Safe Solution architecture](../media/bosch-cctv-mask-detection.png)

1. CCTVs send video data to Internet of Things (IoT) Edge servers. Edge computing handles device registration, provisioning, and data ingestion.
2. The Bosch Algorithm Engineering and Model Training Environment uses custom vision analytics to continually retrain machine learning (ML) models, and directly updates edge servers.
3. Edge servers send data to onboard stream analytics and blob storage. IoT Edge intelligent devices limit costs by preprocessing and sending only necessary data to the cloud.
4. Stream analytics perform data enrichment and validation on both edge and cloud data.
5. Service bus device-to-cloud and cloud-to-device messaging send data and telemetry to and from the cloud.
6. Redis, mongoDB, and blob storage store cloud data for Power BI analysis and visualizations via custom connector.
7. The Azure cloud provides application logs, monitoring, security, application gateway and API management.
8. The app sends notifications and alerts via Microsoft Teams.

## Components

- [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge/) servers with built-in storage, computing, artificial intelligence (AI), machine learning (ML), and capabilities like [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins/) and [Azure Stream Analytics (ASA)](https://azure.microsoft.com/services/stream-analytics) can quickly recognize and respond to sensor input.
- Bosch video analytics use [Custom Vision](https://azure.microsoft.com/services/cognitive-services/custom-vision-service/) skills and [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning/) to continually improve monitoring, detection, and real-time alert triggering.
- [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins/) is an IoT service that can create comprehensive models of physical environments in a spatial intelligence graph. Rather than tracking individual devices, Digital Twins can virtually replicate the physical world by modeling the relationships between people, places, and devices.
- [Azure Stream Analytics (ASA)](https://azure.microsoft.com/services/stream-analytics) provides real-time serverless stream processing that can run the same queries in the cloud and on the edge. ASA on IoT Edge can filter or aggregate data that needs to be sent to the cloud for further processing or storage.
- [Azure Service Bus](https://azure.microsoft.com/services/service-bus/) messaging through [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/) connects devices to Azure cloud resources, and can use queries to filter data to be sent to the cloud.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service/ is a managed service for developing, deploying, and managing containerized applications. In this solution, AKS manages an interactive visual dashboard app that tracks and analyzes safety violations.
- By integrating with the Azure cloud, the solution can use services like [Azure Monitor](https://azure.microsoft.com/services/monitor/) and [Azure Security Center](https://azure.microsoft.com/services/security-center/).
- Integration with Microsoft [Teams](https://support.office.com/article/manage-notifications-in-teams-1cc31834-5fe5-412b-8edb-43fecc78413d) allows automated notifications of relevant stakeholders like HR and Security.
- [Microsoft Power BI](https://powerbi.microsoft.com) visualizations enable well-informed and data-driven reporting and decision making.

## Next steps
For more information, see:
- [https://www.bosch-india-software.com](https://www.bosch-india-software.com/en/)
- [Azure Kubernetes Services integration with Security Center](https://docs.microsoft.com/azure/security-center/azure-kubernetes-service-integration)
- [Azure Stream Analytics on IoT Edge](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-edge).

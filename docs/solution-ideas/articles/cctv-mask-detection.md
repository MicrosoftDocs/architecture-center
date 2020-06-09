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

The new normal workplace and other group spaces need to follow health and safety guidelines around safe social distancing, mask and PPE use, and occupancy limits. Bosch COVID-19 Safe Solution combines existing closed-circuit TV (CCTV) infrastructure with the [Azure intelligent edge](https://azure.microsoft.com/overview/future-of-cloud/) and other Azure and Microsoft services to help organizations monitor, comply, and update health and safety practices.

This article shows a COVID-19 Safe Solution implementation at a major North American auto manufacturing facility. Goals were to:

- Ensure a safe work environment when resuming manufacturing after the COVID-19 lockdown.
- Monitor and enforce compliance with face mask policy, social distancing, and occupancy limits on factory premises.
- Increase visibility and control through efficient reporting and interactive dashboards.
- Deliver alerts and notifications so health and safety stakeholders can address safety violations and concerns.
- Improve compliance, reduce violations, and enable well-informed safety decisions over time.

## Potential use cases

- Spaces with existing CCTV infrastructure.
- Stores, restaurants, offices, factories and warehouses, public transportation, hospitals, schools, and entertainment and recreation spaces.
- Organizations with multiple locations, to enable widespread, systemic data analysis and actions.

## Architecture

![Bosch COVID-19 Safe Solution architecture](../media/bosch-cctv-mask-detection.png)

1. CCTVs send video data to Internet of Things (IoT) Edge servers. Edge computing handles device registration and provisioning and data ingestion.
2. Bosch Algorithm Engineering and Model Training Environment uses custom vision analytics to train machine learning (ML) models, and directly updates edge servers.
3. Data enrichment, validation, Stream Analytics happen on both Edge and Cloud.
4. Edge servers also have Blob Storage with output sent to App Service for the dashboard app.
5. Azure Service Bus device-to-cloud sends data and device telemetry to and from the cloud. 
6. Redis, mongoDB, Blob Storage store cloud data.
7. Azure Application Logs, Monitoring, Security in cloud.
8. API Management, Application Gateway for dashboard app.
9. Notifications via Teams.
10. Power BI analytics and visualizations via custom connector.

## Components

- [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge/) servers with built-in storage, computing, artificial intelligence (AI), machine learning (ML), and capabilities like [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins/) and [Azure Stream Analytics (ASA)](https://azure.microsoft.com/services/stream-analytics) can quickly recognize and respond to sensor input. IoT Edge intelligent devices limit costs by preprocessing and sending only necessary data to the cloud.
- Bosch video analytics suite uses [Custom Vision](https://azure.microsoft.com/services/cognitive-services/custom-vision-service/) and [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning/) to continually improve monitoring, detection, and real-time alert triggering.
- [Azure Service Bus](https://azure.microsoft.com/services/service-bus/) messaging through [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/) connects devices to Azure cloud resources. Uses queries to filter data sent to cloud. Sends cloud-to-device messaging.
- Interactive visual display dashboard app helps safety officers track and analyze violations.
- Integration with MS Teams allows notification of relevant stakeholders like HR and Security.
- Power BI visualizations enable well-informed and data-driven safety decision making.

## Next steps
For more information, see:
- [https://www.bosch-india-software.com/en/](https://www.bosch-india-software.com/en/)

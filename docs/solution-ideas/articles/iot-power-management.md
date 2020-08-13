---
title: IoT-connected light and power for emerging markets
titleSuffix: Azure Solution Ideas
author: doodlemania2
description: Learn how Veriown uses solar-powered IoT devices with Azure cloud services to provide power and connectivity to remote rural customers.
ms.date: 08/12/2020
ms.custom: fcp
ms.service: architecture-center
ms.subservice: solution-idea
ms.category: iot
---

# Light and power for emerging markets

Globally, over 1 billion people lack access to electricity, and over 3 billion people have no internet access. Veriown is an energy company with a mission to provide life-changing electricity and connectivity access for remote and rural customers off the power grid. Veriown has run large-scale network and telecommunications infrastructures for years, but has never before provided such a wide scope of services at such low cost. Veriown's proprietary devices combine solar power with internet connectivity to deliver monumental improvements to quality of life.

The CONNECT devices combine Internet-of-Things (IoT) hardware and mobile applications with Azure cloud capabilities to act as clean energy and internet hubs. CONNECT delivers solar-powered clean electricity, LED light, and internet connectivity with very low cost, high reliability, and minimal downtime. An integrated SIM card and tablet provide access to online content and services like communications, telemedicine, education, news, entertainment, and commerce.

Azure powers two major workstreams in Veriown's system:
– Real-time telemetry from the IoT devices lets Veriown see transient or long-running anomalies and respond with real-time chatbots and device actions or retraining. For example, low-power conditions can trigger a customer's device to automatically reduce power usage for USB charging, so the customer continues to get a good experience.

- Post-processing data analytics let Veriown analyze usage and incidents to determine algorithms for future needs and preventive maintenance. For example, Veriown could send customers parts that are predicted to fail soon, or could improve the response time of an artificial intelligence (AI) chatbot. Since bandwidth is very limited and expensive in emerging markets, analyzing customer usage patterns lets Veriown target customers with only the right services at the right time.

## Potential use cases
A solar-powered CONNECT device in a customer's home or business can provide:
- LED light to replace kerosene
- USB device charging
- Communications
- Commerce and banking services
- Telemedicine support
- Education, news and weather, and entertainment programming

The basic CONNECT device provides light, electricity, and internet connectivity. Customers can purchase additional services and content as one-offs or subscriptions.

Content and service providers can use the devices' built-in Azure cloud capabilities to monitor and analyze usage and anomalies, and take real-time or future device actions.

## Architecture

![Diagram showing data stream coming from the power subsystem to IoT Edge and Azure cloud components.](../media/iot-power-architecture.png)

The overall system behaves as follows:
1. The data stream comes from the power subsystem to IoT Hub
2. Azure Synapse Analytics
3. Azure Databricks
4. Azure Cosmos DB
5. Power BI dashboard

The following diagram shows the data analytics loops:

![Diagram showing an analytics loop that runs post-processed telemetry data through a trained AI model to control the device.](../media/iot-power-analytics.png)

1. Devices send telemetry and user data to IoT Hub.
2. Databricks triggers alarms and sends data to Synapse analytics.
3. Analytics data feeds Power BI reports for system evaluation and future planning.
4. Data also feeds into Azure Machine Learning (ML) and combines with historical and actual weather data from Cosmos DB to retrain the ML model.
5. The retrained Power Management ML model adjusts device controls and schedules.

## Components
- Azure Machine Learning
- Artificial intelligence
- Big data
- Real-time streaming
- [Azure Databricks](https://azure.microsoft.com/services/databricks/)
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/)
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics)
- IoT Gateway
- Power BI
- Docker containers
- Kubernetes

## See also
- https://www.thehindubusinessline.com/info-tech/soon-a-solar-powered-device-will-bring-online-entertainment-education-to-villages/article26945331.ece
- [Predictive maintenance] 
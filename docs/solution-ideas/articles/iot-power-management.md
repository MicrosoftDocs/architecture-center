---
title: IoT Connected Platform for COVID-19 detection and prevention
titleSuffix: Azure Solution Ideas
author: doodlemania2
description: Deploy a connected ecosystem of intelligent IoT Edge devices, Azure services, and cloud-powered apps to create safe and healthy public spaces.
ms.date: 08/12/2020
ms.custom: fcp
ms.service: architecture-center
ms.subservice: solution-idea
ms.category: iot
---

# Light and power for emerging markets

Globally, over 1 billion people lack access to electricity, and over 3 billion people have no internet access. Veriown is an energy company with a mission to provide life-changing electricity and connectivity access for these remote and rural customers off the power grid.

Veriown has run large-scale network and telecommunications infrastructures for years, but has never before provided such a wide scope of services at such low cost. Veriown's proprietary Internet-of-Things (IoT) devices combine solar power with internet connectivity to deliver monumental improvements to quality of life.

Veriown's CONNECT device combines IoT hardware and mobile applications with Azure cloud services to act as a clean energy, internet, media, education, and commerce hub. CONNECT delivers solar-powered clean electricity, LED light, and internet connectivity with very low cost, high reliability, and minimal downtime. An integrated SIM card and tablet provide access to online content and services like communications, telemedicine, education, news, entertainment, and commerce.

Azure powers two major workstreams in Veriown's system:

– Real-time telemetry on each IoT device lets Veriown see transient or long-running anomalies and respond with real-time chatbots and direct software reprogramming. For example, low-power conditions can trigger the customer's device to automatically reduce power usage for USB charging, so the customer continues to get a good experience.

- Post-processing data analytics let Veriown analyze usage and incidents to determine algorithms for future needs and preventive maintenance. For example, based on analytics results, Veriown could send customers parts that are likely to fail soon, or improve the response time of an artificial intelligence (AI) chatbot. Since bandwidth is very limited and expensive in emerging markets, analyzing customer usage patterns lets Veriown target customers with only the right services at the right time.

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

1. The data stream coming from the power subsystem
2. IoT Hub
3. Azure Synapse Analytics
4. Azure Databricks
5. Azure Cosmos DB
6. Power BI dashboard

![Diagram showing an analytics loop that runs post-processed telemetry data through a trained AI model to control the device.](../media/iot-power-analytics.png)

## Components
Azure Machine Learning
, artificial intelligence
, big data, 
real-time streaming
[Azure Databricks](https://azure.microsoft.com/services/databricks/)
[Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/)
[Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics)
, IoT Edge and IoT Gateway, 
Power BI,  
Docker containers, 
Kubernetes 

## See also
- https://www.thehindubusinessline.com/info-tech/soon-a-solar-powered-device-will-bring-online-entertainment-education-to-villages/article26945331.ece
- [predictive maintenance] 
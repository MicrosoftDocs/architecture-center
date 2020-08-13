---
title: IoT connected light and power for emerging markets
titleSuffix: Azure Solution Ideas
author: doodlemania2
description: Learn how Veriown uses solar-powered IoT devices with Azure cloud services to provide low-cost power and connectivity to remote rural customers.
ms.date: 08/12/2020
ms.custom: fcp
ms.service: architecture-center
ms.subservice: solution-idea
ms.category: iot
---

# Light and power for emerging markets

Globally, over 1 billion people lack access to electricity, and over 3 billion people have no internet access. Veriown is an energy company that is providing life-changing, low-cost electricity and connectivity to remote and rural customers. Veriown's Internet-of-Things (IoT) devices combine solar power with internet communications to deliver monumental improvements to users' quality of life.

Veriown has run large-scale network and telecommunications infrastructures for years, but has never before provided such a wide scope of services at such low cost. Veriown's CONNECT devices combine IoT hardware and mobile applications with Azure cloud capabilities to act as energy and internet hubs. CONNECT delivers solar-powered clean electricity, light, and internet connectivity with low cost, high reliability, and minimal downtime. An integrated SIM card and tablet provide access to online content and services like telemedicine, education, news and weather, entertainment, and commerce.

Azure powers two major workstreams in Veriown's IoT solution:

- Real-time IoT device telemetry lets Veriown see transient or long-running anomalies and respond in real-time with chatbots and device actions. For example, low-power conditions can trigger a customer's device to automatically reduce power usage for USB charging, so the customer continues to get a good experience.

- Post-processing data analytics let Veriown analyze usage and incidents to determine algorithms for future needs and preventive maintenance. For example, Veriown could send customers parts that are predicted to fail soon, or could improve the responses of an artificial intelligence (AI) chatbot.

Since bandwidth is limited and expensive in emerging markets, analyzing usage patterns and incidents can help content and service owners target customers with only the services they need.

## Potential use cases
A solar-powered CONNECT device in a customer's home or business can provide:
- LED light to replace kerosene lanterns
- USB device charging
- Telemedicine support
- Online education
- Commerce and banking services
- News and weather
- Entertainment programming
- Emergency and support communications

The basic CONNECT device provides light, electricity, internet connectivity, and customer support. Customers can purchase additional services and content as one-offs or subscriptions.

## Architecture

![Diagram showing data stream coming from the power subsystem to Azure IoT edge and cloud components.](../media/iot-power-architecture.png)

1. Field sales and service agents can use a Power BI dashboard or mobile devices to interact with the cloud application via Azure Application Gateway.
1. The cloud app consists of containerized microservices that provide various functions and interfaces, like identity and access management and device upgrades.
1. End users use mobile devices to access and control their CONNECT devices. Device apps like account management interact with the cloud app via Application Gateway.
1. The CONNECT devices send streaming telemetry and user data to the cloud via Azure IoT Hub.
1. In the cloud, Azure Event Hub routes events, and Azure Databricks extracts, transforms, and loads the data.
1. Azure Synapse, a SQL big-data warehouse, performs analytics on the transformed data.
1. The analyzed data populates Power BI reports, for system evaluation and future planning.

The overall system includes the following data analysis and control loop:

![Diagram showing an analytics loop that runs post-processed telemetry data through a trained AI model to control the device.](../media/iot-power-analytics.png)

1. The CONNECT devices stream telemetry and user behavior to Azure IoT Hub.
1. Azure Databricks extracts, transforms, and loads the data.
1. Databricks sends some events, like alarms, directly to customer support for intervention.
1. Azure Synapse performs big-data analytics on the transformed data.
1. The analyzed data populates Power BI reports.
1. Databricks also sends the data to Azure Machine Learning (ML).
1. Azure ML combines the current data with external data, like historical weather and forecasts, and uses the updated data to retrain its power management ML models.
1. IoT Hub sends the retrained models to the CONNECT devices, which adjust their behavior and schedules to conform to the new models.

## Components
- [Azure Application Gateway]
- [Azure Machine Learning]
- [Azure Databricks](https://azure.microsoft.com/services/databricks/)
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/)
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics)
- Azure IoT Hub
- Power BI
- Azure Container Registry (ACR) Docker containers
- Azure Kubernetes Service (AKS)

## See also
- https://www.thehindubusinessline.com/info-tech/soon-a-solar-powered-device-will-bring-online-entertainment-education-to-villages/article26945331.ece
- veriown.com
- [Predictive maintenance] 
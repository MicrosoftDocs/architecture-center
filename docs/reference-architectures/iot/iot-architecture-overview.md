---
title: Getting started with Azure IoT solutions
titleSuffix: Azure Reference Architectures
description: An overview of Azure IoT architectures.  Learn basic concepts around getting started with Azure IoT, how to get started building an IoT solution, or understand how to optimize an IoT solution for production.
author: mcosner
manager: lizross
ms.service: architecture-center
ms.subservice: reference-architecture
ms.topic: conceptual
ms.date: 9/23/2021
ms.author: mcosner
ms.category:
  - iot
ms.custom:
  - internal-intro
categories:
  - iot
products:
  - azure-iot-hub
  - azure-iot-central
---

# Getting started with Azure IoT solutions

IoT (Internet of Things) is a collection of managed and platform services that connect and control IoT assets. For example, consider an industrial motor connected to the cloud. The motor collects and sends temperature data. This data is used to evaluate whether the motor is performing as expected. This information can then be used to prioritize a maintenance schedule for the motor.

Azure IoT supports a large range of devices, including industrial equipment, microcontrollers, sensors, and so on. When connected to the cloud, these devices can send data to your IoT solution. You can use the solution to monitor and manage the devices to achieve your objectives more efficiently.

## Industry specific IoT reference architectures

Many types of industries require IoT solutions. The following topics discuss different industries and use cases.

### Manufacturing and industry

* A hierarchy service enables your business to centrally define how production assets are organized within factories. For more information, see [Connected factory hierarchy service](../../solution-ideas/articles/connected-factory-hierarchy-service.yml).

* It can be problematic to interconnect the heterogenous legacy and modern devices that often coexist in a factory. The [Connected factory signal pipeline](../../example-scenario/iot/connected-factory-signal-pipeline.yml) solves this problem by introducing a common configuration interface to connect heterogenous devices.

* The Internet-of-things (IoT) Edge brings data processing and storage close to the data source, enabling fast, consistent responses with reduced dependency on cloud connectivity and resources. Edge computing can incorporate artificial intelligence (AI) and machine learning (ML) models to create intelligent edge devices and networks which can integrate with the cloud. For more information about how edge computing can be used in predictive maintenance, see [Predictive maintenance with IoT Edge](../../example-scenario/predictive-maintenance/iot-predictive-maintenance.yml).

* OPC UA (Open Platform Communication Unified Architecture) can be used to monitor equipment parameters to discover anomalies before they become critical issues. For more information, see [Condition monitoring for industrial IoT](../../solution-ideas/articles/condition-monitoring.yml).

* Fully automated smart factories use artificial intelligence (AI) and machine learning (ML) to analyze data, run systems, and improve processes over time. In manufacturing, computer vision on the edge is an increasingly popular Internet of Things (IoT) application used in safety and quality assurance applications. For more information, see [End-to-end manufacturing using conputer vision on the edge](../../reference-architectures/ai/end-to-end-smart-factory.yml).

### Smart Buildings

* Smart places are physical environments that bring together connected devices and data sources. They can include buildings, college campuses, corporate campuses, stadiums, and cities. They provide value by helping property owners, facility managers, and occupants operate and maintain sites. For more information, see [Create smart places by using Azure Digital Twins](../../example-scenario/iot/smart-places.yml).

### Retail industry

* During the COVID-19 pandemic, many customers made fewer trips to the market and many preferred to buy their merchandise online and pick it up in the store which is also known as curbside pickup. For more information about using Azure to facilitate curbside pickup, see [Buy online, pickup in store (BOPIS)](../../example-scenario/iot/vertical-buy-online-pickup-in-store.yml).

### Automotive

* Vehicle data ingestion, processing, and visualization are key capabilities needed to create connected car solutions. By capturing and analyzing this data, we can decipher valuable insights and create new solutions. For more information, see [Process real-time vehicle data using IoT](../../example-scenario/data/realtime-analytics-vehicle-iot.yml).

### Sustainability

The mission of Project 15 from Microsoft is to empower scientists and conservationists around the world. For more information, see [Project 15 Open Platform IoT sustainability](../../solution-ideas/articles/project-15-iot-sustainability.yml).

### Cross industry

* Automotive manufacturing relies on automated guided vehicles (AGVs) to deliver parts to assembly lines. AGVs are a mission-critical part of just-in-time manufacturing and automated shop-floor logistics. For more information, see [Automated guided vehicles fleet control](../../example-scenario/iot/automated-guided-vehicles-fleet-control.yml).

* Environmental monitoring has become an important activity in the global supply chain. It provides key signals that help drive real-time decisions that can impact suppliers and logistics. For more information, see [Environment monitoring and supply chain optimization with IoT](../../solution-ideas/articles/environment-monitoring-and-supply-chain-optimization.yml).

* You can use Azure IoT Central and other Azure services to track and manage assets in real time. For more information, see [Real-time asset tracking and management](../../solution-ideas/articles/real-time-asset-tracking-mgmt-iot-central.yml).

## IoT architecture patterns and guides

IoT architecture patterns are reusable building blocks that you can leverage to create IoT solutions. They are generic and can be used across different industry verticals.

### Patterns

* Internet of Things (IoT) applications often need real-time data from IoT devices. Unlike traditional polling apps in which a client asks a device for state changes, clients can receive updates from devices in real time. For more information, see [Real-time IoT updates](../../example-scenario/iot/real-time-iot-updates-cloud-apps.yml).

* The deployment stamping strategy in an Internet-of-Things (IoT) solution supports scaling up the number of connected IoT devices by replicating stamps. Stamps are discrete units of core solution components that optimally support a defined number of devices. For more information, see [Scale IoT solutions with deployment stamps](../../example-scenario/iot/application-stamps.yml).

* To learn how Azure IoT Hub supports shared access signature (SAS) token authentication in the client SDKs, see [Azure IoT client SDK support for third-party token servers](../../guide/iot/azure-iot-client-sdk-support.md).

* Edge devices are typically provisioned by deploying software container images. To use a reliable and resilient deployment capability for situations that have limited, intermittent, or low bandwidth, see [Efficient Docker image deployment](../../example-scenario/iot/efficient-docker-image-deployment.yml).

* To achieve near real-time analytics over fast flowing, high volume streaming data from IoT devices, see [IoT analytics with Azure Data Explorer](../../solution-ideas/articles/iot-azure-data-explorer.yml).

* An Internet of Things (IoT) solution might require that an on-premises edge network provide computing and data collecting, rather than the cloud. Edge devices often meet these needs better than the cloud. For more information, see [IoT Edge data storage and processing](../../solution-ideas/articles/data-storage-edge.yml).

### Guides for building IoT solutions

* There are many options for building and deploying your IoT cloud solutions. The technologies and services you choose depends on your scenario's development, deployment, and management needs. To compare PaaS vs. aPaaS approaches, see [Compare IoT solution approaches](../../example-scenario/iot/iot-central-iot-hub-cheat-sheet.md).

* Artificial intelligence for image analytics spans a wide variety of industries including manufacturing, retail, healthcare, and the public sector. For more information, see [Vision with Azure IoT Edge](../../guide/iot-edge-vision/index.md).

* There is a list of best practices you should follow when you move from test to production. For more information, see [Move an IoT solution from test to production](../../example-scenario/iot/iot-move-to-production.md).

* You can build Industrial Iot (IIoT) analytics solutions using Azure PaaS (Platform as a Service) components. Such an IIoT analytics solution relies on real-time and historical data from industrial devices and control systems. For more information, see [Azure industrial IoT analytics guidance](../../guide/iiot-guidance/iiot-architecture.md).

## Next steps

- [Azure IoT documentation](/azure/iot-fundamentals)
- [Azure IoT Central documentation](/azure/iot-central)
- [Azure IoT Hub](/azure/iot-hub)
- [Azure IoT Hub Device Provisioning Service](/azure/iot-dps)
- [Azure IoT Edge documentation](/azure/iot-edge)

## Related resources

See the related IoT architecture guides:

- [IoT solutions conceptual overview](../../example-scenario/iot/introduction-to-solutions.yml)
- [Choose an Internet of Things (IoT) solution in Azure](../../example-scenario/iot/iot-central-iot-hub-cheat-sheet.md)
- [Vision with Azure IoT Edge](../../guide/iot-edge-vision/index.md)
- [Azure Industrial IoT Analytics Guidance](../../guide/iiot-guidance/iiot-architecture.md)

See the related IoT reference architectures and example scenarios:

- [Azure IoT reference architecture](../iot.yml)
- [End-to-end manufacturing using computer vision on the edge](../ai/end-to-end-smart-factory.yml)
- [IoT and data analytics](../../example-scenario/data/big-data-with-iot.yml)
- [IoT using Cosmos DB](../../solution-ideas/articles/iot-using-cosmos-db.yml)
- [Retail - Buy online, pickup in store (BOPIS)](../../example-scenario/iot/vertical-buy-online-pickup-in-store.yml)
- [Predictive maintenance with the intelligent IoT Edge](../../example-scenario/predictive-maintenance/iot-predictive-maintenance.yml)

See the related IoT solution ideas:

- [Condition Monitoring for Industrial IoT](../../solution-ideas/articles/condition-monitoring.yml)
- [Contactless IoT interfaces with Azure intelligent edge](../../solution-ideas/articles/contactless-interfaces.yml)
- [COVID-19 safe environments with IoT Edge monitoring and alerting](../../solution-ideas/articles/cctv-iot-edge-for-covid-19-safe-environment-and-mask-detection.yml)
- [Environment monitoring and supply chain optimization with IoT](../../solution-ideas/articles/environment-monitoring-and-supply-chain-optimization.yml)
- [IoT connected light, power, and internet for emerging markets](../../solution-ideas/articles/iot-power-management.yml)
- [UVEN smart and secure disinfection and lighting](../../solution-ideas/articles/uven-disinfection.yml)
- [Mining equipment monitoring](../../solution-ideas/articles/monitor-mining-equipment.yml)
- [Predictive Maintenance for Industrial IoT](../../solution-ideas/articles/iot-predictive-maintenance.yml)
- [Process real-time vehicle data using IoT](../../example-scenario/data/realtime-analytics-vehicle-iot.yml)
- [Cognizant Safe Buildings with IoT and Azure](../../solution-ideas/articles/safe-buildings.yml)

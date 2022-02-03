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

Azure IoT supports a large range of devices, including industrial equipment, microcontrollers, sensors, and many others. When connected to the cloud, these devices can send data to your IoT solution. You can use the solution to monitor and manage the devices to achieve your objectives more efficiently.

This document links to guides that you can use to accelerate your creation of IoT solutions.

## Industry specific IoT reference architectures

IoT solutions solve specific business challenges in unique industries. In this section, we provide reference designs for industry-specific scenarios.

### Manufacturing and industrial

* [Connected factory hierarchy service](../../solution-ideas/articles/connected-factory-hierarchy-service.yml): A hierarchy service enables your business to centrally define how production assets are organized within factories.

* [Connected factory signal pipeline](../../example-scenario/iot/connected-factory-signal-pipeline.yml): It can be problematic to interconnect the heterogenous legacy and modern devices that often coexist in a factory. The connected factory signal pipeline solves this problem by introducing a common configuration interface to connect heterogenous devices.

* [Predictive maintenance with IoT Edge](../../example-scenario/predictive-maintenance/iot-predictive-maintenance.yml): The Internet-of-things (IoT) Edge brings data processing and storage close to the data source, enabling fast, consistent responses with reduced dependency on cloud connectivity and resources. Edge computing can incorporate artificial intelligence (AI) and machine learning (ML) models to create intelligent edge devices and networks that can integrate with the cloud.

* [Condition monitoring for industrial IoT](../../solution-ideas/articles/condition-monitoring.yml): OPC UA (Open Platform Communication Unified Architecture) can be used to monitor equipment parameters to discover anomalies before they become critical issues.

* [End-to-end manufacturing using computer vision on the edge](../../reference-architectures/ai/end-to-end-smart-factory.yml): Fully automated smart factories use artificial intelligence (AI) and machine learning (ML) to analyze data, run systems, and improve processes over time. In manufacturing, computer vision on the edge is an increasingly popular Internet of Things (IoT) application used in safety and quality assurance applications.

### Smart buildings

* [Create smart places by using Azure Digital Twins](../../example-scenario/iot/smart-places.yml): Smart places are physical environments that bring together connected devices and data sources. They can include buildings, college campuses, corporate campuses, stadiums, and cities. Smart places provide value by helping property owners, facility managers, and occupants operate and maintain sites.

### Retail

* [Buy online, pickup in store (BOPIS)](../../example-scenario/iot/vertical-buy-online-pickup-in-store.yml): During the COVID-19 pandemic, many customers made fewer trips to the market and many preferred to buy their merchandise online and pick it up in the store (BOPIS) which is also known as curbside pickup.

### Automotive

* [Process real-time vehicle data using IoT](../../example-scenario/data/realtime-analytics-vehicle-iot.yml): Vehicle data ingestion, processing, and visualization are key capabilities needed to create connected car solutions. By capturing and analyzing this data, we can decipher valuable insights and create new solutions.

### Sustainability

* [Project 15 Open Platform IoT sustainability](../../solution-ideas/articles/project-15-iot-sustainability.yml): The mission of Project 15 from Microsoft is to empower scientists and conservationists around the world.

### Cross industry

* [Automated guided vehicles fleet control](../../example-scenario/iot/automated-guided-vehicles-fleet-control.yml): Automotive manufacturing relies on automated guided vehicles (AGVs) to deliver parts to assembly lines. AGVs are a mission-critical part of just-in-time manufacturing and automated shop-floor logistics.

* [Environment monitoring and supply chain optimization with IoT](../../solution-ideas/articles/environment-monitoring-and-supply-chain-optimization.yml): Environmental monitoring has become an important activity in the global supply chain. It provides key signals that help drive real-time decisions that can impact suppliers and logistics.

* [Real-time asset tracking and management](../../solution-ideas/articles/real-time-asset-tracking-mgmt-iot-central.yml): You can use Azure IoT Central and other Azure services to track and manage assets in real time.

## IoT architecture patterns and guides

This section shares guides and building blocks that are useful when building IoT solutions. Patterns address key areas of the IoT solution that you should consider. IoT architecture patterns are reusable building blocks that you can leverage to create IoT solutions. They are generic and can be used across different industry verticals.

### Patterns

* [Real-time IoT updates](../../example-scenario/iot/real-time-iot-updates-cloud-apps.yml): Internet of Things (IoT) applications often need real-time data from IoT devices. Unlike traditional polling apps in which a client asks a device for state changes, clients can receive updates from devices in real time.

* [Scale IoT solutions with deployment stamps](../../example-scenario/iot/application-stamps.yml): The deployment stamping strategy in an Internet-of-Things (IoT) solution supports scaling up the number of connected IoT devices by replicating stamps. Stamps are discrete units of core solution components that optimally support a defined number of devices.

* [Azure IoT client SDK support for third-party token servers](../../guide/iot/azure-iot-client-sdk-support.md): Learn how Azure IoT Hub supports shared access signature (SAS) token authentication in the client SDKs.

* [Efficient Docker image deployment](../../example-scenario/iot/efficient-docker-image-deployment.yml): Edge devices are typically provisioned by deploying software container images. You can use a reliable and resilient deployment capability for situations that have limited, intermittent, or low bandwidth.

* [IoT analytics with Azure Data Explorer](../../solution-ideas/articles/iot-azure-data-explorer.yml): Achieve near real-time analytics over fast flowing, high volume streaming data from IoT devices.

* [IoT Edge data storage and processing](../../solution-ideas/articles/data-storage-edge.yml): An Internet of Things (IoT) solution might require that an on-premises edge network provide computing and data collecting, rather than the cloud. Edge devices often meet these needs better than the cloud.

### Guides for building IoT solutions

* [Compare IoT solution approaches](../../example-scenario/iot/iot-central-iot-hub-cheat-sheet-content.yml): There are many options for building and deploying your IoT cloud solutions. The technologies and services you choose depends on your scenario's development, deployment, and management needs. Use the linked article to compare PaaS and aPaaS approaches.

* [Vision with Azure IoT Edge](../../guide/iot-edge-vision/index.md): Artificial intelligence for image analytics spans a wide variety of industries including manufacturing, retail, healthcare, and the public sector.

* [Move an IoT solution from test to production](../../example-scenario/iot/iot-move-to-production.md) provides a list of best practices you should follow when you move from test to production.

* [Azure industrial IoT analytics guidance](../../guide/iiot-guidance/iiot-architecture.md): You can build Industrial Iot (IIoT) analytics solutions using Azure PaaS (Platform as a Service) components. Such an IIoT analytics solution relies on real-time and historical data from industrial devices and control systems.

## Next steps

Learn about the different Azure IoT services:

* [Azure IoT documentation](/azure/iot-fundamentals)
* [Azure IoT Central documentation](/azure/iot-central)
* [Azure IoT Hub](/azure/iot-hub)
* [Azure IoT Hub Device Provisioning Service](/azure/iot-dps)
* [Azure IoT Edge documentation](/azure/iot-edge)

## Related resources

See the related IoT architecture guides:

* [Azure IoT reference architecture](../iot.yml)
* [IoT solutions conceptual overview](../../example-scenario/iot/introduction-to-solutions.yml)
* [Choose an Internet of Things (IoT) solution in Azure](../../example-scenario/iot/iot-central-iot-hub-cheat-sheet-content.yml)

See the related IoT solution guides for COVID-19:

* [COVID-19 safe environments with IoT Edge monitoring and alerting](../../solution-ideas/articles/cctv-iot-edge-for-covid-19-safe-environment-and-mask-detection.yml)
* [IoT connected light, power, and internet for emerging markets](../../solution-ideas/articles/iot-power-management.yml)
* [UVEN smart and secure disinfection and lighting](../../solution-ideas/articles/uven-disinfection.yml)
* [Cognizant Safe Buildings with IoT and Azure](../../solution-ideas/articles/safe-buildings.yml)

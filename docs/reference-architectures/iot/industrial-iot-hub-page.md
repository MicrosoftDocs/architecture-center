---
title: Industry specific Azure IoT solutions
titleSuffix: Azure Reference Architectures
description: See example Azure IoT solutions and scenarios for manufacturing, smart buildings, retail, transportation, and across industries.
author: mcosner
manager: lizross
ms.service: architecture-center
ms.subservice: reference-architecture
ms.topic: conceptual
ms.date: 03/09/2022
ms.author: mcosner
ms.custom:
  - internal-intro
categories:
  - iot
products:
  - azure-iot-central
  - azure-iot-hub
---

# Industry specific Azure IoT solutions and scenarios

This article provides an overview of industry-specific Industrial IoT (IIoT) solutions. IIoT is the application of internet-of-things (IoT) technology to manufacturing and other industries. [Azure Industrial IoT](https://azure.github.io/Industrial-IoT) is a suite of Azure cloud microservices, IoT Hub and other Azure services, and Azure IoT Edge modules that integrate the cloud into industrial and manufacturing shop floors.

Azure IIoT relies on industry-standard open interfaces such as the [Open Platform Communications Unified Architecture (OPC UA)](https://opcfoundation.org/about/opc-technologies/opc-ua) to integrate device and sensor data into the Azure cloud. Cloud services can use this data to develop transformative business and industrial solutions.

For generic IIoT patterns and guides you can use across different industry verticals, see [Get started with Azure IoT solutions](iot-architecture-overview.md). The following Azure IIoT solutions solve unique business challenges in specific industries.

## Manufacturing

- [Connected factory hierarchy service](../../solution-ideas/articles/connected-factory-hierarchy-service.yml). A hierarchy service lets businesses centrally define how production assets are organized within factories.

- [Connected factory signal pipeline](../../example-scenario/iot/connected-factory-signal-pipeline.yml). The connected factory signal pipeline uses a common configuration interface based on OPC UA to connect heterogenous legacy and modern devices.

- [Condition monitoring for industrial IoT](../../solution-ideas/articles/condition-monitoring.yml). IoT devices connect to the cloud through OPC UA and Azure industrial IoT components. Condition monitoring helps manufacturers discover anomalies before they become critical.

- [End-to-end computer vision at the edge for manufacturing](../../reference-architectures/ai/end-to-end-smart-factory.yml). This series describes how industries use computer vision and machine learning (ML) for safety and quality assurance applications. An end-to-end approach to IoT computer vision analyzes data and improves processes over time.

## Retail

- [Buy online, pickup in store (BOPIS)](../../example-scenario/iot/vertical-buy-online-pickup-in-store.yml). Azure IoT and cloud components combine to implement a curbside pickup, or buy online and pick up in store (BOPIS), system for retail.

## Automotive and transportation

- [Automated guided vehicles fleet control](../../example-scenario/iot/automated-guided-vehicles-fleet-control.yml). Automated guided vehicles (AGVs) deliver parts to automotive assembly lines. AGVs are a mission-critical part of just-in-time manufacturing and automated shop-floor logistics.

- [Process real-time vehicle data using IoT](../../example-scenario/data/realtime-analytics-vehicle-iot.yml). Vehicle data ingestion, processing, and visualization are key capabilities of connected car solutions. Capturing and analyzing real-time vehicle data provides valuable insights to create new solutions.

- [Predictive maintenance with IoT Edge](../../example-scenario/predictive-maintenance/iot-predictive-maintenance.yml). Azzure IoT Edge brings data processing and storage close to the data source, enabling fast, consistent responses with reduced dependency on cloud connectivity and resources. Edge computing can incorporate artificial intelligence (AI) and machine learning (ML) models to create intelligent edge devices and networks.

## Cross industry

- [Create smart places by using Azure Digital Twins](../../example-scenario/iot/smart-places.yml). Smart places are physical environments that bring together connected devices and data sources. Smart places can include buildings, campuses, and cities. Azure Digital Twins stores digital representations of these environments to use for monitoring, analysis, and management.

- [Environment monitoring and supply chain optimization with IoT](../../solution-ideas/articles/environment-monitoring-and-supply-chain-optimization.yml). Environment monitoring is an important activity in the global supply chain. A warehouse management scenario monitors environmental conditions and processes the data with ML to generate predictions.

- [Real-time asset tracking and management](../../solution-ideas/articles/real-time-asset-tracking-mgmt-iot-central.yml). Azure IoT Central and other Azure services track and manage vehicles and other assets in real time.

- [Project 15 Open Platform IoT sustainability](../../solution-ideas/articles/project-15-iot-sustainability.yml). Open Platform open-source software connects to the cloud and securely manages devices for scientific and conservation projects. The architecture serves as a reference for building end-to-end IoT solutions.

## Next steps

- [What is Azure IIoT?](/azure/industrial-iot/overview-what-is-industrial-iot)
- [Azure Industrial IoT documentation](/azure/industrial-iot)

## Related resources

- [Azure industrial IoT analytics guidance](../../guide/iiot-guidance/iiot-architecture.md). This article series describes an Azure IIoT analytics solution that uses platform-as-a-service (PaaS) components.

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

# Industry specific Azure IoT solutions

This article provides an overview of industry-specific Industrial IoT (IIoT) solutions and scenarios. IIoT is the application of internet-of-things (IoT) technology to manufacturing and other industries. [Azure Industrial IoT](https://azure.microsoft.com/solutions/industry/manufacturing/iot) is a suite of Azure IoT Edge and IoT Hub components, Azure microservices, and other Azure services that integrate the cloud into industrial and manufacturing shop floors.

Azure IIoT relies on industry-standard open interfaces, such as the [Open Platform Communications Unified Architecture (OPC UA)](https://opcfoundation.org/about/opc-technologies/opc-ua), to bring device and sensor data into the Azure cloud. Cloud platform-as-a-service (PaaS) components use device data to develop transformative business and industrial solutions. For guidance in using Azure PaaS components in IIoT solutions, see the series on [Industrial IoT analytics](../../guide/iiot-guidance/iiot-architecture.yml).

For overall IoT patterns and guides that apply across industry verticals, see [Get started with Azure IoT solutions](iot-architecture-overview.md). The following Azure IIoT solutions and scenarios address unique business challenges for specific industries.

## Manufacturing

- [Connected factory hierarchy service](../../solution-ideas/articles/connected-factory-hierarchy-service.yml). A hierarchy service lets businesses centrally define how to organize production assets within factories.

- [Connected factory signal pipeline](../../example-scenario/iot/connected-factory-signal-pipeline.yml). The connected factory signal pipeline uses a common configuration interface based on OPC UA to connect heterogenous legacy and modern devices.

- [Condition monitoring for industrial IoT](../../solution-ideas/articles/condition-monitoring.yml). Condition monitoring helps manufacturers discover anomalies before they become critical. In this solution, IoT devices connect to the cloud through OPC UA and Azure industrial IoT components.

- [End-to-end computer vision at the edge for manufacturing](../../reference-architectures/ai/end-to-end-smart-factory.yml). Industries use computer vision and machine learning (ML) for safety and quality assurance applications. This example shows an end-to-end approach to IoT computer vision that improves processes over time.

- [Automated guided vehicles fleet control](../../example-scenario/iot/automated-guided-vehicles-fleet-control.yml). Automated guided vehicles (AGVs) are an important part of just-in-time manufacturing and automated shop-floor logistics. In this example, AGVs deliver parts to automotive assembly lines.

## Retail

- [Buy online, pickup in store (BOPIS)](../../example-scenario/iot/vertical-buy-online-pickup-in-store.yml). Azure IoT and cloud components combine to implement a curbside pickup, or buy online and pick up in store (BOPIS), system for retail.

## Automotive and transportation

- [Process real-time vehicle data using IoT](../../example-scenario/data/realtime-analytics-vehicle-iot.yml). Vehicle data ingestion, processing, and visualization are key capabilities of connected car solutions. Capturing and analyzing real-time vehicle data provides valuable insights to create new solutions.

- [Predictive maintenance with IoT Edge](../../example-scenario/predictive-maintenance/iot-predictive-maintenance.yml). Edge computing enables fast, consistent responses with reduced dependency on cloud connectivity and resources. The intelligent edge brings data processing and storage close to the data source in this train maintenance and safety solution.

## Energy and environment

- [Project 15 Open Platform IoT sustainability](../../solution-ideas/articles/project-15-iot-sustainability.yml). Open Platform open-source software connects to the cloud and securely manages devices for scientific and conservation projects. This architecture is a reference for building open-source, end-to-end IoT solutions.

## Facilities and real estate

- [Create smart places by using Azure Digital Twins](../../example-scenario/iot/smart-places.yml). Smart places are physical environments, like buildings, campuses, and cities, that bring together connected devices and data sources. Azure Digital Twins stores digital representations of physical environments to use for monitoring, analysis, and management.

## Cross industry

- [Environment monitoring and supply chain optimization with IoT](../../solution-ideas/articles/environment-monitoring-and-supply-chain-optimization.yml). Environment monitoring is an important activity in the global supply chain. A warehouse management scenario monitors environmental conditions and processes the data with ML to generate predictions.

- [Real-time asset tracking and management](../../solution-ideas/articles/real-time-asset-tracking-mgmt-iot-central.yml). Azure IoT Central and other Azure services track and manage vehicles and other assets in real time.

## Next steps

- [What is Azure IIoT?](/azure/industrial-iot/overview-what-is-industrial-iot)
- [Azure Industrial IoT on GitHub](https://azure.github.io/Industrial-IoT)
- [Azure Industrial IoT documentation](/azure/industrial-iot)

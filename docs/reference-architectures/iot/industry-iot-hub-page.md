---
title: Industry specific Azure IoT reference architectures
titleSuffix: Azure Reference Architectures
description: See example Azure IoT solutions and scenarios for environmental, facilities, manufacturing, retail, and transportation industries.
author: falloutxay
manager: lizross
ms.service: architecture-center
ms.subservice: reference-architecture
ms.topic: reference-architecture
ms.date: 01/11/2023
ms.author: ansyeo
ms.custom:
  - internal-intro
categories:
  - iot
products:
  - azure-iot-central
  - azure-iot-hub
---

# Industry specific Azure IoT reference architectures

This article provides an overview of industry-specific internet-of-things (IoT) reference architectures and example solutions.

The following Azure IoT solutions and example scenarios address unique business challenges for specific industries. For overall IoT patterns and guides that apply across industry verticals, see [Get started with Azure IoT solutions](iot-architecture-overview.md). 

## Automotive and transportation

- [Process real-time vehicle data using IoT](../../example-scenario/data/realtime-analytics-vehicle-iot.yml). Vehicle data ingestion, processing, and visualization are key capabilities of connected car solutions. Capturing and analyzing real-time vehicle data provides valuable insights to create new solutions.

- [Real-time asset tracking for vehicles](../../solution-ideas/articles/real-time-asset-tracking-mgmt-iot-central.yml). Azure IoT Central and other Azure services track and manage vehicles and other assets in real time.

- [Railway health system with IoT Edge](../../example-scenario/predictive-maintenance/iot-predictive-maintenance.yml). Edge computing enables fast, consistent responses with reduced dependency on cloud connectivity and resources. The intelligent edge brings data processing and storage close to the data source in this train maintenance and safety solution.

- [Automated guided vehicles fleet control](../../example-scenario/iot/automated-guided-vehicles-fleet-control.yml). Automated guided vehicles (AGVs) are an important part of just-in-time manufacturing and automated shop-floor logistics. In this example, AGVs deliver parts to automotive assembly lines.

## Energy and environment

- [Environmental monitoring and supply chain optimization with IoT](../../solution-ideas/articles/environment-monitoring-and-supply-chain-optimization.yml). Environmental monitoring is crucial for global supply chain management. A warehouse management scenario monitors environmental conditions and processes the data with machine learning (ML) to generate predictions.

- [Project 15 Open Platform IoT sustainability](../../solution-ideas/articles/project-15-iot-sustainability.yml). Open Platform open-source software connects to the cloud and securely manages devices for scientific and conservation projects. This architecture is a reference for building open-source, end-to-end IoT solutions.

## Facilities and real estate

- [Create smart places by using Azure Digital Twins](../../example-scenario/iot/smart-places.yml). Smart places are physical environments, like buildings, campuses, and cities, that bring together connected devices and data sources. Azure Digital Twins stores digital representations of physical environments to use for monitoring, analysis, and management.

- [Safe environments with IoT Edge monitoring and alerting](../../solution-ideas/articles/cctv-iot-edge-for-covid-19-safe-environment-and-mask-detection.yml). Combining existing closed-circuit TV infrastructure with the Azure intelligent edge and other Azure and Microsoft services helps organizations monitor, follow, and improve health and safety practices.

## Manufacturing

- [Connected factory hierarchy service](../../solution-ideas/articles/connected-factory-hierarchy-service.yml). A hierarchy service lets businesses centrally define how to organize production assets within factories.

- [Connected factory signal pipeline](../../example-scenario/iot/connected-factory-signal-pipeline.yml). The signal pipeline uses a common configuration interface based on the [Open Platform Communications Unified Architecture (OPC UA)](https://opcfoundation.org/about/opc-technologies/opc-ua) to connect heterogenous legacy and modern devices.

- [Condition monitoring for industrial IoT](../../solution-ideas/articles/condition-monitoring.yml). Condition monitoring helps manufacturers discover anomalies before they become critical. In this solution, IoT devices connect to the cloud through OPC UA and Azure industrial IoT components.

- [Predictive maintenance for industrial IoT](../../solution-ideas/articles/iot-predictive-maintenance.yml). Predictive maintenance diagnoses and predicts malfunctions and maintenance needs in OPC UA connected equipment. This solution uses mixed reality and digital twins technologies to optimize production in real time.

- [End-to-end computer vision at the edge for manufacturing](../../reference-architectures/ai/end-to-end-smart-factory.yml). Industries use computer vision and ML for safety and quality assurance applications. This example shows an end-to-end approach to IoT computer vision that improves processes over time.

## Retail

- [Video capture and analytics for retail](../../solution-ideas/articles/video-analytics.yml). Retailers like grocery stores can monitor storefront events and take immediate actions to improve customer experience. On-premises IoT Edge devices analyze video data in real time to detect and address issues like empty shelf space or long customer queues.

- [Buy online, pickup in store (BOPIS)](../../example-scenario/iot/vertical-buy-online-pickup-in-store.yml). Azure IoT and cloud components combine to implement a curbside pickup, or buy online and pick up in store (BOPIS), system for retail.

## Next steps

- [What is Azure IIoT?](/azure/industrial-iot/overview-what-is-industrial-iot)
 Cloud platform-as-a-service (PaaS) components use device data to develop business and industrial solutions. For guidance in using Azure PaaS components to create IIoT solutions, see the series on [Industrial IoT analytics](../../guide/iiot-guidance/iiot-architecture.yml).

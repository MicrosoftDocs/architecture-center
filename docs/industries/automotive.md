---
title: Solutions for the automotive, mobility, and transportation industries
titleSuffix: Azure Architecture Center
description: See architectures and ideas that use Azure services to build efficient, scalable, and reliable solutions in the automotive, mobility, and transportation industries.
author: martinekuan
ms.author: architectures 
ms.date: 07/26/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.custom: fcp 
keywords:
  - Azure
products:
  - "azure"
  - "azure-iot"
categories:
- "ai-machine-learning"
- "analytics"
- "compute"
- "iot"
---

# Solutions for the automotive, mobility, and transportation industries

The automotive, mobility, and transportation industries work to satisfy the ever-present need to move people and things safely, quickly, and efficiently. Powerful new technologies like cloud computing, IoT, AI, and machine learning can help companies meet that need. Azure provides services to help companies exploit the opportunities and meet the challenges that come with rapidly evolving digital technology.

The automotive industry includes truck and automobile manufacturing and sales, and related parts industries. The design and manufacturing aspects of the industry can take advantage of solutions that address those aspects for many industries, solutions such as [Azure for manufacturing](https://azure.microsoft.com/industries/discrete-manufacturing).

Another Azure solution, [Azure high-performance computing (HPC) for automotive](https://azure.microsoft.com/solutions/high-performance-computing/automotive), addresses issues that are specific to automotive, such as vehicle engineering, aerodynamic and physics simulations, sensor performance, and autonomous driving software. It offers a wide variety of specialized virtual machines for these areas and many others.

View the ways that the digital transformation is revolutionizing the automotive and mobility services industry:

<br>

> [!VIDEO https://www.youtube.com/embed/jZtckoQ6HmY]

The mobility services industry improves urban mobility with multi-modal route planning, mobile payment and ticketing, vehicle tracking, and analytics for planning and optimization. For related solutions on Azure, see [Emerging mobility services](https://www.microsoft.com/industry/automotive/emerging-mobility-services).

## Architectures for automotive, mobility, and transportation

The following articles provide detailed analysis of architectures created and recommended for the automotive, mobility, and transportation industries.

| Architecture | Summary | Technology focus |
| ------- | ------- | ------- |
|[Automated guided vehicles fleet control](../example-scenario/iot/automated-guided-vehicles-fleet-control.yml)|An example architecture that provides an end-to-end approach for automotive manufacturers that rely on automated guided vehicles (AGVs). |IoT|
|[Building blocks for autonomous-driving simulation environments](automotive/building-blocks-autonomous-driving-simulation-environments.yml)|An example architecture for automating driving tests, developing control systems, recording vehicle data, and simulating complex driving scenarios.|Containers|
|[Data science and machine learning with Azure Databricks](../solution-ideas/articles/azure-databricks-data-science-machine-learning.yml)|A solution idea for quick and cost-effective training, deployment, and life-cycle management of thousands of parallel machine learning models.|AI|
|[Efficient Docker image deployment for intermittent low-bandwidth connectivity](../example-scenario/iot/efficient-docker-image-deployment.yml)|An example architecture for situations where containers are part of the solution and connectivity is intermittent with low bandwidth. Possible uses are over-the-air automotive updates and other mobile scenarios.|IoT|
|[Process real-time vehicle data using IoT](../example-scenario/data/realtime-analytics-vehicle-iot.yml)|An example architecture for capturing, analyzing, and visualizing data from sensors and IoT devices—key capabilities for creating connected-car solutions.|IoT|
|[Real-time IoT updates](../example-scenario/iot/real-time-iot-updates-cloud-apps.yml)|An example architecture that outlines a way for clients like web pages or mobile apps to receive updates from devices in real time without HTTP polling. Instead, Azure SignalR Service pushes content to clients as soon as it's available. |IoT|
|[Run CFD simulations](../example-scenario/infrastructure/hpc-cfd.yml)|An example architecture that runs Computational Fluid Dynamics (CFD) simulations. It uses Azure to address the high-compute issues of cost, spare capacity, and long queue times.|Compute|

## Solution ideas for the automotive, mobility, and transportation industries

The following are other ideas that you can use as a starting point for your energy or environment solution.

- [COVID-19 safe environments with IoT Edge monitoring and alerting](../solution-ideas/articles/cctv-iot-edge-for-covid-19-safe-environment-and-mask-detection.yml)
- [Environment monitoring and supply chain optimization with IoT](../solution-ideas/articles/environment-monitoring-and-supply-chain-optimization.yml)
- [IoT analytics with Azure Data Explorer](../solution-ideas/articles/iot-azure-data-explorer.yml)
- [Machine teaching with the Microsoft Autonomous Systems platform](../solution-ideas/articles/autonomous-systems.yml)
- [Predictive aircraft engine monitoring](../solution-ideas/articles/aircraft-engine-monitoring-for-predictive-maintenance-in-aerospace.yml)
- [Predictive insights with vehicle telematics](../solution-ideas/articles/predictive-insights-with-vehicle-telematics.yml)
- [Real-time asset tracking and management](../solution-ideas/articles/real-time-asset-tracking-mgmt-iot-central.yml)

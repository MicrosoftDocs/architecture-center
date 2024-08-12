---
title: Solutions for the automotive, mobility, and transportation industries
titleSuffix: Azure Architecture Center
description: See architectures and ideas that use Azure services to build efficient, scalable, and reliable solutions in the automotive, mobility, and transportation industries.
author: msmarioo
ms.author: marioo
ms.date: 08/12/2024
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

The automotive, mobility, and transportation industries work to satisfy the ever-present need to move people and things safely, quickly, and efficiently. Powerful new technologies like cloud computing, IoT, Generative AI, and machine learning can help companies meet that need. Azure provides services to help companies exploit the opportunities and meet the challenges that come with rapidly evolving digital technology.

[Microsoft works closely with partners to redefine mobility](/industry/mobility/overview). We empower every player in the ecosystem to develop innovative digital and physical products and services, support the development of software-defined vehicles, develop autonomous driving and improve business operations with connectivity, data, and AI.

* [Azure high-performance computing (HPC) for automotive](https://azure.microsoft.com/solutions/high-performance-computing/automotive) addresses demanding computing needs specific to automotive. It supports areas such as vehicle engineering, aerodynamic and physics simulations, sensor performance, and autonomous driving software with specialized virtual machines.
* The automotive industry includes truck and automobile manufacturing and sales, and related parts industries. The design and manufacturing aspects of the industry can take advantage of solutions that address those aspects for many industries, solutions such as [Azure for manufacturing](https://azure.microsoft.com/industries/discrete-manufacturing).
* The mobility services industry improves urban mobility with multi-modal route planning, mobile payment and ticketing, vehicle tracking, and analytics for planning and optimization. For related solutions on Azure, see [Emerging mobility services](https://www.microsoft.com/industry/automotive/emerging-mobility-services).

View the ways that the digital transformation is revolutionizing the automotive and mobility services industry:

> [!VIDEO https://www.youtube.com/embed/jZtckoQ6HmY]

## Architectures for automotive, mobility, and transportation

The following articles provide detailed analysis of architectures created and recommended for the automotive, mobility, and transportation industries.

| Architecture | Summary | Technology focus |
| ------- | ------- | ------- |
| [Software-defined vehicle DevOps toolchain](automotive/software-defined-vehicle-reference-architecture.yml) | Describes how to use GitHub and Azure services to develop an end-to-end automotive software stack. It inclusdes software in the loop (SIL) testing,  orchestration of hardware in the loop (HIL) testing and vehicle fleet validation. | DevOps |
| [Data Analytics for automotive test fleets](automotive/automotive-telemetry-analytics.yml) | Describes how to collect high resolution telemetry and test drive recordings and perform root cause analysis and vehicle behavior validation with Microsoft Fabric. | IoT, Analytics |
| [Automotive Messaging, Data, and Analytics](/azure/event-grid/mqtt-automotive-connectivity-and-data-solution) | Describes how to use Azure services to implement advance connected vehicle applications and digital services. | IoT, Analytics |
| [Automotive Connected Fleets](automotive/automotive-connected-fleets.yml) | Describes how to create composable, data-centric solutions for mobility providers and commercial vehicle operators  | IoT, Analytics, BizApps |

## Solution ideas for the automotive, mobility, and transportation industries

The following are other ideas that you can use as a starting point for your energy or environment solution.

| Solution Idea | Summary | Technology focus |
| ------- | ------- | ------- |
| [Autonomous Vehicle Operations design guide](../guide/machine-learning/avops-design-guide.md) | Provides an overview on creating a back end to enable an autonomous vehicle development solution at scale | AVOps |
| [Data operations for autonomous vehicle development](../example-scenario/automotive/autonomous-vehicle-operations-dataops.yml) | presents a solution and guidance for offline data operations and management (DataOps) for an automated driving system. | DataOps|
|[Autonomous Vehicle Development solution](../solution-ideas/articles/avops-architecture.yml) | Provides guidance and recommendations for developing an automated driving development solution | AVOps |
|[Building blocks for autonomous-driving simulation environments](automotive/building-blocks-autonomous-driving-simulation-environments.yml)|An example architecture for automating driving tests, developing control systems, recording vehicle data, and simulating complex driving scenarios.|Containers|
| [Environment monitoring and supply chain optimization with IoT](../solution-ideas/articles/environment-monitoring-and-supply-chain-optimization.yml)| Describes a warehouse management scenario that monitors environmental conditions | IoT |
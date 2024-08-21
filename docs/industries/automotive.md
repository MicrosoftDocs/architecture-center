---
title: Solutions for the automotive, mobility, and transportation industries
titleSuffix: Azure Architecture Center
description: See architectures and ideas that use Azure services to build efficient, scalable, and reliable solutions in the automotive, mobility, and transportation industries.
author: msmarioo
ms.author: marioo
ms.date: 08/21/2024
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

The automotive, mobility, and transportation industries strive to satisfy the ever-present need to move people and things safely, quickly, and efficiently. Powerful new technologies like cloud computing, Internet of Things (IoT), generative AI, and machine learning can help companies meet that need. Azure provides services to help companies take advantage of opportunities and meet challenges that come with rapidly evolving digital technology.

Microsoft works closely with partners to redefine mobility. Organizations can use Azure services to develop innovative digital and physical products and services, support the development of software-defined vehicles, develop autonomous driving, and improve business operations with connectivity, data, and AI. For more information, see [How does Microsoft support mobility?](/industry/mobility/overview)

Azure services address the varied needs of the automotive, mobility and transportation value chain:

* [High-performance computing (HPC) on Azure](https://azure.microsoft.com/solutions/high-performance-computing) addresses the demanding automotive computing needs. HPC uses specialized virtual machines to support areas such as vehicle engineering, aerodynamic and physics simulations, sensor performance, and autonomous driving software.

* The automotive industry includes truck and automobile manufacturing and sales, and related parts industries. You can take advantage of solutions that address design and manufacturing aspects of the automotive industry and other related industries. For example, you can use [Microsoft Cloud for Manufacturing solutions](https://www.microsoft.com/industry/manufacturing/microsoft-cloud-for-manufacturing).
* The mobility services industry improves urban mobility with multi-modal route planning, mobile payment and ticketing, vehicle tracking, and analytics for planning and optimization. For more information about related solutions on Azure, see [Emerging mobility services](https://www.microsoft.com/industry/mobility).

The following video describes how digital transformation revolutionizes the automotive and mobility services industry.

> [!VIDEO https://www.youtube.com/embed/jZtckoQ6HmY]

## Architectures

The articles in the following table provide detailed architecture analyses that you can use in the automotive, mobility, and transportation industries.

| Architecture | Summary | Technology focus |
| ------- | ------- | ------- |
| [Software-defined vehicle DevOps toolchain](automotive/software-defined-vehicle-reference-architecture.yml) | Describes how to use GitHub and Azure services to develop an end-to-end automotive software stack. This architecture includes software-in-the-loop testing, orchestration of hardware-in-the-loop testing, and vehicle fleet validation. | DevOps |
| [Data analytics for automotive test fleets](automotive/automotive-telemetry-analytics.yml) | Describes how to collect high-resolution telemetry and test drive recordings. It also describes how to perform root cause analysis and vehicle behavior validation with Microsoft Fabric. | IoT, analytics |
| [Automotive messaging, data, and analytics](/azure/event-grid/mqtt-automotive-connectivity-and-data-solution) | Describes how to use Azure services to implement advanced connected vehicle applications and digital services. | IoT, analytics |
| [Automotive connected fleets](automotive/automotive-connected-fleets.yml) | Describes how to create composable, data-centric solutions for mobility providers and commercial vehicle operators.  | IoT, analytics, business applications |

## Solution ideas

Consider other ideas that you can use as a starting point for your energy or environment solution.

| Solution idea | Summary | Technology focus |
| ------- | ------- | ------- |
| [Autonomous vehicle operations design guide](../guide/machine-learning/avops-design-guide.md) | Provides an overview about how to create a back end to enable an autonomous vehicle development solution at scale | Autonomous vehicle operations |
| [Data operations for autonomous vehicle development](../example-scenario/automotive/autonomous-vehicle-operations-dataops.yml) | Presents a solution and guidance for offline data operations and management for an automated driving system | Data operations|
|[Autonomous vehicle development solution](../solution-ideas/articles/avops-architecture.yml) | Provides guidance and recommendations about how to develop an automated driving development solution | Autonomous vehicle operations |
|[Building blocks for autonomous-driving simulation environments](automotive/building-blocks-autonomous-driving-simulation-environments.yml)| Provides an example architecture to automate driving tests, develop control systems, record vehicle data, and simulate complex driving scenarios |Containers|
| [Environment monitoring and supply chain optimization with IoT](../solution-ideas/articles/environment-monitoring-and-supply-chain-optimization.yml)| Describes a warehouse management scenario that monitors environmental conditions | IoT |


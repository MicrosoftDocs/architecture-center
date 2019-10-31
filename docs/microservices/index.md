---
title: Building microservices on Azure
description: Designing, building, and operating microservices architectures on Azure
ms.date: 10/30/2019
author: MikeWasson
ms.topic: guide
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom: microservices
---

# Building microservices on Azure

Microservices are a popular architectural style for building applications that are resilient, highly scalable, independently deployable, and able to evolve quickly. But a successful microservices architecture requires a different approach to designing and building applications.

[!INCLUDE [microservices-intro](../includes/microservices-intro.md)]

## Process for building a microservices architecture

The articles listed here present a structured approach for designing, building, and operating a microservices architecture.

**Domain analysis.** To avoid some common pitfalls when designing microservices, use domain analysis to define your microservice boundaries. Follow these steps:

1. [Use domain analysis to model microservices](./model/domain-analysis.md).
1. [Use tactical DDD to design microservices](./model/tactical-ddd.md).
1. [Identify microservice boundaries](./model/microservice-boundaries.md).

**Design the services**. Microservices require a different approach to designing and building applications. For more information, see [Designing a microservices architecture](./design/index.md).

**Operate in production**. Because microservices architectures are distributed, you must have robust operations for deployment and monitoring.

- [CI/CD for microservices architectures](./ci-cd.md)
- [Build a CI/CD pipeline for microservices on Kubernetes](./ci-cd-kubernetes.md)
- [Monitor microservices running on Azure Kubernetes Service (AKS)](./logging-monitoring.md)

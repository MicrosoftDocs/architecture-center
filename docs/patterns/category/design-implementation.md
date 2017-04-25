---
title: Design and Implementation patterns
description: Good design encompasses factors such as consistency and coherence in component design and deployment, maintainability to simplify administration and development, and reusability to allow components and subsystems to be used in other applications and in other scenarios. Decisions made during the design and implementation phase have a huge impact on the quality and the total cost of ownership of cloud hosted applications and services.
keywords: design pattern
author: dragon119
ms.author: pnp
ms.date: 03/24/2017
ms.topic: article
ms.service: guidance

pnp.series.title: Cloud Design Patterns
---

# Design and Implementation patterns

[!INCLUDE [header](../../_includes/header.md)]

Good design encompasses factors such as consistency and coherence in component design and deployment, maintainability to simplify administration and development, and reusability to allow components and subsystems to be used in other applications and in other scenarios. Decisions made during the design and implementation phase have a huge impact on the quality and the total cost of ownership of cloud hosted applications and services.

| Pattern | Summary |
| ------- | ------- |
| [CQRS](../cqrs.md) | Segregate operations that read data from operations that update data by using separate interfaces. |
| [Compute Resource Consolidation](../compute-resource-consolidation.md) | Consolidate multiple tasks or operations into a single computational unit |
| [External Configuration Store](../external-configuration-store.md) | Move configuration information out of the application deployment package to a centralized location. |
| [Leader Election](../leader-election.md) | Coordinate the actions performed by a collection of collaborating task instances in a distributed application by electing one instance as the leader that assumes responsibility for managing the other instances. |
| [Pipes and Filters](../pipes-and-filters.md) | Break down a task that performs complex processing into a series of separate elements that can be reused. |
| [Runtime Reconfiguration](../runtime-reconfiguration.md) | Design an application so that it can be reconfigured without requiring redeployment or restarting the application. |
| [Static Content Hosting](../static-content-hosting.md) | Deploy static content to a cloud-based storage service that can deliver them directly to the client. |
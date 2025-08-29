---
title: Resiliency checklist for services
description: Resiliency is the ability to recover from failures and continue to function. Use this checklist to review the resiliency considerations for Azure services.
author: claytonsiemens77
ms.author: pnp
ms.date: 07/25/2023
ms.topic: conceptual
ms.subservice: architecture-guide
ms.custom:
  - resiliency
  - checklist
  - arb-web
---

<!-- cSpell:ignore BACPAC DTUs nonbootable VHDs -->

# Resiliency checklist for specific Azure services

Resiliency is the ability of a system to recover from failures and continue to function. Every technology has its own particular failure modes, which you must consider when designing and implementing your application. Use this checklist to review the resiliency considerations for specific Azure services. For more information about designing resilient applications, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

> [!IMPORTANT]
> Per service reliability product documentation is found in the [Reliability guides by service](/azure/reliability/overview-reliability-guidance). For prescriptive reliability considerations and recommendations when designing or evaluating a workload, see the Reliability section for your service in its [Azure Well-Architected Framework service guides](/azure/well-architected/service-guides/).
>
> The recommendations on this page are being migrated to these locations.


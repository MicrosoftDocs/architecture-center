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

## Virtual Network

**To allow or block public IP addresses, add a network security group to the subnet.** Block access from malicious users, or allow access only from users who have privilege to access the application.

**Create a custom health probe.** Load Balancer Health Probes can test either HTTP or TCP. If a VM runs an HTTP server, the HTTP probe is a better indicator of health status than a TCP probe. For an HTTP probe, use a custom endpoint that reports the overall health of the application, including all critical dependencies. For more information, see [Azure Load Balancer overview](/azure/load-balancer/load-balancer-overview).

**Don't block the health probe.** The Load Balancer Health probe is sent from a known IP address, 168.63.129.16. Don't block traffic to or from this IP in any firewall policies or network security group rules. Blocking the health probe would cause the load balancer to remove the VM from rotation.

**Enable Load Balancer logging.** The logs show how many VMs on the back-end are not receiving network traffic due to failed probe responses. For more information, see [Log analytics for Azure Load Balancer](/azure/load-balancer/load-balancer-monitor-log).

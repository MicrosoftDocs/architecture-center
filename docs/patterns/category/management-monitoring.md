---
title: Management and Monitoring patterns
description: Cloud applications run in in a remote datacenter where you do not have full control of the infrastructure or, in some cases, the operating system. This can make management and monitoring more difficult than an on-premises deployment. Applications must expose runtime information that administrators and operators can use to manage and monitor the system, as well as supporting changing business requirements and customization without requiring the application to be stopped or redeployed.
keywords: design pattern
author: dragon119
ms.author: pnp
ms.date: 02/21/2017
ms.topic: article
ms.service: guidance

pnp.series.title: Cloud Design Patterns
---

# Management and Monitoring patterns

[!INCLUDE [header](../../_includes/header.md)]

Cloud applications run in in a remote datacenter where you do not have full control of the infrastructure or, in some cases, the operating system. This can make management and monitoring more difficult than an on-premises deployment. Applications must expose runtime information that administrators and operators can use to manage and monitor the system, as well as supporting changing business requirements and customization without requiring the application to be stopped or redeployed.

| Pattern | Summary |
| ------- | ------- |
| [External Configuration Store](../external-configuration-store.md) | Move configuration information out of the application deployment package to a centralized location. |
| [Health Endpoint Monitoring](../health-endpoint-monitoring.md) | Implement functional checks in an application that external tools can access through exposed endpoints at regular intervals. |
| [Runtime Reconfiguration](../runtime-reconfiguration.md) | Design an application so that it can be reconfigured without requiring redeployment or restarting the application. |
---
title: Monitoring for reliability
description: Describes considerations for reliability in application monitoring.
author: v-aangie
ms.date: 02/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# Monitoring for reliability

Monitoring and diagnostics are crucial for resiliency. If something fails, you need to know *that* it failed, *when* it failed &mdash; and *why*.

## Checklist

**How do you monitor and measure application health?**
***

> [!div class="checklist"]
> - The application is instrumented with semantic logs and metrics.
> - Application logs are correlated across components.
> - All components are monitored and correlated with application telemetry.
> - Key metrics, thresholds, and indicators are defined and captured.
> - A health model has been defined based on performance, availability, and recovery targets.
> - Azure Service Health events are used to alert on applicable service level events.
> - Azure Resource Health events are used to alert on resource health events.
> - Monitor long-running workflows for failures.

## In this section

| Assessment  | Description |
| ------------- | ------------- |
| [Do you use monitoring and diagnostics to improve availability and resiliency?](./monitoring.md)  | Get an overall picture of application health. If something fails, you need to know *that* it failed, *when* it failed, and *why*. |
| [Has a health model been defined based on performance, availability, and recovery targets?](./monitor-model.md) | Define a health model to qualify what “healthy” and “unhealthy” states represent across all application components, in a measurable and observable format.

## Azure services for monitoring

- [Azure Monitor](/azure/azure-monitor/overview)
- [Application Insights](/azure/azure-monitor/app/app-insights-overview)
- [Azure Service Health](/azure/service-health/service-health-overview)
- [Azure Resource Health](/azure/service-health/resource-health-overview)
- [Azure Resource Manager](/azure/azure-resource-manager/management/overview)
- [Azure Policy](/azure/governance/policy/overview)

## Reference architecture

- [Hybrid availability and performance monitoring](../../hybrid/hybrid-perf-monitoring.yml)
- [Unified logging for microservices applications](../../example-scenario/logging/unified-logging.yml)

## Next step

>[!div class="nextstepaction"]
>[Application health](./monitoring.md)

## Related links

- [Azure Monitor](https://azure.microsoft.com/services/monitor/)
- [Continuous monitoring](/azure/azure-monitor/continuous-monitoring)

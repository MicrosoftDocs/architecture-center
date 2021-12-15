---
title: Monitor performance for scalability and reliability
description: Monitoring strategy should take into consideration scalability and reliability of the infrastructure, application, and dependent services.
author: PageWriter-MSFT
ms.date: 11/01/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-monitor
categories:
  - management-and-governance
ms.custom:
  - fasttrack-edit
---

# Monitor performance for scalability and reliability
The overall monitoring strategy should take into consideration scalability and reliability of the infrastructure, application, and dependent services.

## Scalability

A goal of analyzing metrics is to determine the thresholds for scale up, scale out, scale in, and scale down. The ability to scale dynamically is one of the biggest values of moving to the cloud.

- Know the minimum number of instances that should run at any given time.
- Determine what metrics are best for your solution to base your auto scaling rules.
- Configure the auto scaling rules for those services that include it.
- Create alert rules for the services that could be scaled manually.

For scalability, look at the metrics to determine how to provision resources dynamically and scale with demand.

## Reliability

Monitor your application for early warning signs that might require proactive intervention. Tools that assess the overall health of the application and its dependencies help you to recognize quickly when a system or its components suddenly become unavailable. Use them to implement an early warning system.

Monitoring systems should capture comprehensive details so that applications can be restored efficiently and, if necessary, designers and developers can modify the system to prevent the situation from recurring.

The raw data for monitoring can come from various sources, including:

- Application logs, such as those produced by [Azure Application Insights](/azure/azure-monitor/app/app-insights-overview).
- Operating system performance metrics collected by [Azure monitoring agents](/azure/azure-monitor/platform/agents-overview).
- [Azure resources](/azure/azure-monitor/platform/metrics-supported), including metrics collected by Azure Monitor.
- [Azure Service Health](/azure/service-health/overview), which offers a dashboard to help you track active events.
- [Azure AD logs](/azure/active-directory/reports-monitoring/howto-integrate-activity-logs-with-log-analytics) built into the Azure platform.

To learn more, see [Monitoring health for reliability](../resiliency/monitoring.md).

## Next section

Based on insights gained through monitoring, optimize your code. One option might be to consider other Azure services that may be more appropriate for your objectives.

> [!div class="nextstepaction"]
> [Optimize](optimize.md)

## Related links
> [Back to the main article](checklist.md)

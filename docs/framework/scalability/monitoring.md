---
title: Monitoring
description: None
author: faisalm
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: fasttrack-edit
---

# Monitoring for Scalability

Monitoring for scalability should be part of your overall monitoring strategy that utilizes [Azure Monitor](/azure/azure-monitor/). The overall monitoring strategy should take into consideration not only scalability, but resiliency (infrastructure, application and dependent services) and application performance as well. Most services in Azure offer the ability to turn on both data and management plane logs as well as metrics. For purposes of scalability, looking at the metrics would allow you to scale based scale up, scale out, scale in, and scale down. The ability to scale dynamically is one of the biggest values of moving to the cloud.  

## What are some of the reasons for setting up auto scaling

- Are the systems able to handle the current number of requests?
- Are the systems meeting the performance NFRs?
- Are the systems out of resources (CPU, Memory, I/O)?
- Is there an opportunity to have cost savings by not overprovisioning resources?

## What is the goal of auto scaling

- Scale up or out or in and down resources to meet the current demand.
- Decrease costs by scaling down when resources are not needed.
- Improve customer experience be offering uninterrupted service even when the demand peaks of valleys.

## How can metrics be used to auto scale

- As stated before, most Azure services offer the ability to export logs and metrics to services such as Log Analytics and external service like Splunk for example via Azure Event Hubs. Furthermore, application leveraging technologies such as Application Insights can further enhance the telemetry coming out of the applications.  
- The metrics coming out of Azure services include metrics such as CPU and memory,utilization, bandwidth information, current storage utilization information, and much more. You can refer to the [supported metrics for Azure Monitor](/azure/azure-monitor/platform/metrics-supported)

## How do Azure services auto scale

- App Services, ASE and VM ScaleSets can be configured with auto-scaling rules that can be based on several metrics including CPU, memory, bandwidth, etc. These rules can create new instances (scale in) or remove instances (scale in) or a running service. This capability can be enhanced by generating custom events from technologies like Application Insight that could be based on some other custom metrics.
- Azure Kubernetes Services offers both the ability to scale pods as well as to auto scale nodes. Scaling rules can be based on internal metrics or can leverage metrics from systems like Prometheus.
- Other services, such as Application Gateway, can be scaled manually. In this case, it is important to leverage services such as Log Analytics to raise alerts when the service is no longer able to handle the load.

- Monitor Metrics and auto scale on performance and schedule for [VMs and VM scalesets](/azure/azure-monitor/insights/vminsights-overview)

- For Container workloads, [container monitoring solution in Azure Monitor](/azure/azure-monitor/insights/containers) should be utilized.

## Monitoring best practices

- Know the minimum number of instances that should run at any given time.
- Determine what metrics are best for your solution to base your auto scaling rules.
- Configure the auto scaling rules for those service that include it.
- Create alert rules for those that could be scaled manually.
- Monitor your environment to make sure that auto scaling is working as expected. For example, watch out for scaling events from the telemetry coming out of the management plane.
- Monitor web applications using [Azure Application Insights](/azure/azure-monitor/learn/quick-monitor-portal).
- [Monitor network performance](/azure/azure-monitor/insights/network-performance-monitor).
  - Consider reviewing as applicable, [network performance monitor](/azure/azure-monitor/insights/network-performance-monitor-performance-monitor), [service connectivity monitor](/azure/azure-monitor/insights/network-performance-monitor-service-connectivity), [ExpressRoute monitor](/azure/azure-monitor/insights/network-performance-monitor-expressroute)
- For long term storage, consider [archiving of the Monitoring Data](/azure/azure-monitor/learn/tutorial-archive-data).
- Track activities using [Azure Security and Audit Logs](/azure/security/fundamentals/log-audit).

## Related Useful Resources

- [Azure Monitor Data Platform](/azure/azure-monitor/platform/data-platform)
- [Auto scaling best practices](/azure/azure-monitor/platform/autoscale-best-practices)
- [Manage log data and workspaces](/azure/azure-monitor/platform/manage-access)
in Azure Monitor.
- [Azure Diagnostic Logs and Schemas](/azure/azure-monitor/platform/diagnostic-logs-schema)

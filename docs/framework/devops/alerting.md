---
title: Alerting for DevOps
description: Describes how to use alerts in a well-architected application.
author: neilpeterson
ms.date: 01/18/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# Alerting

Alerting is the process of analyzing the monitoring and instrumentation data and generating a notification if a significant event is detected.

Alerting helps ensure that the system remains healthy, responsive, and secure. It's an important part of any system that makes performance, availability, and privacy guarantees to the users where the data might need to be acted on immediately. An operator might need to be notified of the event that triggered the alert. Alerting can also be used to invoke system functions such as autoscaling.

Alerting depends on the following instrumentation data:

- Security events. If the event logs indicate that repeated authentication and/or authorization failures are occurring, the system might be under attack and an operator should be informed.
- Performance metrics. The system must quickly respond if a particular performance metric exceeds a specified threshold.
- Availability information. If a fault is detected, it might be necessary to quickly restart one or more subsystems or failover to a backup resource. Repeated faults in a subsystem might indicate more serious concerns.

Operators might receive alert information by using many delivery channels such as email, a pager device, or an SMS text message. An alert might also include an indication of how critical a situation is. Many alerting systems support subscriber groups, and all operators who are members of the same group can receive the same set of alerts.

An alerting system should be customizable, and the appropriate values from the underlying instrumentation data can be provided as parameters. This approach enables an operator to filter data and focus on those thresholds or combinations of values that are of interest. Note that in some cases, the raw instrumentation data can be provided to the alerting system. In other situations, it might be more appropriate to supply aggregated data. (For example, an alert can be triggered if the CPU utilization for a node has exceeded 90 percent over the past 10 minutes). The details provided to the alerting system should also include any appropriate summary and context information. This data can help reduce the possibility that false-positive events will trip an alert.

## Alert rules and actions

When configuring alerts in Azure, monitor the following items are configured.

- Alert Rule - this includes the alert scope or set of resources on which to alert. The alert rule also includes an alert condition. The condition is a query of Azure monitor data and the data threshold on which to raise an alert.
- Action group - this defines the action to take once an alert has been triggered.

An alert rule can be defined using many different data streams such as [metric values](https://docs.microsoft.com/azure/azure-monitor/platform/alerts-metric-overview), [log search queries](https://docs.microsoft.com/azure/azure-monitor/platform/alerts-unified-log), and [activity log events](https://docs.microsoft.com/azure/azure-monitor/platform/activity-log-alerts).

For more information on alerts, see [Overview of alerts in Microsoft Azure](https://docs.microsoft.com/azure/azure-monitor/platform/alerts-overview)

## Defining owners

## Alert prioritization

Prioritizing alerts with a specific severity or urgency helps operational teams in cases where multiple events require intervention at the same time. For example, alerts concerning critical system flows might require special attention. When creating an alert, ensure to establish and set the correct priority.

![Azure Monitor alert severity as seen in the Azure portal.](../_images/devops/alert-sev.png)

## Alert notifications

## Alert dashboarding

## Alert integrations
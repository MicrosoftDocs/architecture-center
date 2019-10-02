---
title: Monitoring for DevOps 
description: Describes how to monitor your workload to ensure your DevOps infrastructure is working as intended.
author: david-stanford
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Monitoring for DevOps

## Implemented alerting and monitoring
Review monitoring and diagnostics guidance. Review monitoring Azure applications and resources guidance.

Train multiple people on Azure Monitor. Send alerts and notifications to multiple recipients.

Automation around alerts is critical due to the highly collaborative nature of DevOps and the inherent speed needed for effective incident management. Earlier this year, a report from DevOps.com came out stating that 80% of IT teams are alerted to critical incidents via email. Email is an effective form of communication, but it shouldn’t be the most common notification method for a critical issue.

Create, view, and manage alerts using Azure Monitor. Use Log Analytics Alerts based on conditions in Log Analytics data.

Use Azure Monitor, Azure Advisor, Azure Service Health, Activity Log, Azure Application Insights, Log Analytics, ExpressRoute monitor, Service Map, availability tests, and general monitoring Azure applications and resources.

## Notification
Use Azure alerts to get proactive notifications. Employ action groups to notify recipients to respond to alerts.

## Event correlation
This enables you to trace communications between applications distributed across systems/containers to identify errors and exceptions from your applications and resolve latency quickly.

Use Azure Log Analytics for viewing data for a particular application. Utilize Service Map and Application Map for logs across multiple components.

## Remote API/Database call statistics
Employ usage analysis with Application Insights.

## Retries
Review retry service-specific guidance.

## System alerts
Use action groups to ensure people receive alerts.

## On-call

## Service limits
Review Azure subscription limits.

## Support
Understand Azure support plans. Refer to Azure support FAQs. Familiarize your team with Azure support.

## Logging
A logging tool should collect logs from each system component, application-side or server-side, and provide access to them in one centralized location. Not all logging platforms are capable of maintaining speed as the amount of logs they process grows. Therefore, you should keep a critical eye on the process when trying out different solutions.

## Metrics
Dev ops metrics are critical for measuring production and project management

Use Azure Monitor for collection of metrics, activity logs, and diagnostic logs.

## KPIs

## Reporting
Use Azure dashboards to combine data into a single pane and share it with multiple stakeholders.

Export Log Analytics data to Power BI to create additional visualizations.

## Expiration
Use Azure VM expire and certificate monitoring.

## Underlying services
Use Azure Service Health to identify issues with services affecting application and plan for scheduled maintenance.

## Configuration changes
Utilize Activity Log for detecting configuration changes, health incidents, better utilization, and autoscale operations.
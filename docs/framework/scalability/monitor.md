---
title: Monitoring for performance efficiency
description: Considerations for using monitoring for performance efficiency
author: v-aangie
ms.date: 01/28/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-monitor
ms.custom:
  - fasttrack-edit
  - article
---

# Monitoring for performance efficiency

Continuously monitoring new services​ and the health of current workloads key in maintaining the overall performance of the workload. When designing an overall monitoring strategy consider these factors:
- Scalability
- Resiliency of the infrastructure, application, and dependent services
- Application performance

## Checklist
**How are you monitoring to ensure the workload is scaling appropriately?**
***
> [!div class="checklist"]
> - Enable and capture telemetry throughout your application.
> - For scalability, look at the metrics to determine how to provision resources dynamically and scale with demand.
> - Troubleshoot performance issues through data-driven decision and and reliable investigation.
> - Identify anti-patterns in the code.

## In this section

Follow these questions to assess the workload at a deeper level.

|Assessment|Description|
|---|---|
|**Are application events correlated across all application components?**||
|**Is it possible to evaluate critical application performance targets and non-functional requirements (NFRs)?**||
|**Is the end-to-end performance of critical system flows monitored?**||
|**Are you collecting Azure Activity Logs within the log aggregation tool?**||
|**Is resource level monitoring enforced throughout the application?**||
|**Are logs and metrics available for critical internal dependencies?**||
|**Are critical external dependencies monitored?**||
|**Are long-term trends analyzed to predict performance issues before they occur?**||
|**Have retention times been defined for logs and metrics, with housekeeping mechanisms configured?**||

## Next section

Based on insights gained through monitoring, optimize your code. One option might be to consider other Azure services that may be more appropriate for your objectives.  

> [!div class="nextstepaction"] 
> [Optimize](optimize.md)


  







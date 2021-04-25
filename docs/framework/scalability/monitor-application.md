---
title: Performance monitoring through application profiling
description: Collect instrumentation data from the application and correlated events across the entire stack.
author: PageWriter
ms.date: 04/28/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-monitor
ms.custom:
  - fasttrack-edit
  - article
---

## Application profiling

Continuously monitor the application with Application Performance Monitoring (APM) technology, such as Azure Application Insights. You can use this to manage the performance and availability of the application, aggregating application level logs, and events for subsequent interpretation. 

## Key points
> [!div class="checklist"]
> - Enable instrumentation and collect data using Azure Application Insights.
> - Use event correlation between the layers of the application to view activity across the complete application stack.
> - Include end-to-end transaction times for key technical functions.
> - Correlate application log events across critical system flows.

# Application instrumentation

Instrumentation of your code allows precise detection of underperforming pieces when load or stress tests are applied. It is critical to have this data available to improve and identify performance opportunities in the application code.

Use APM such as [Application Insights](/azure/azure-monitor/app/app-insights-overview) to continuously improve performance and usability. You need to enable Application Insights by installing an instrumentation package. The service provides extensive telemetry out of the box. You can customize what is captured for greater visibility.  After it's enabled, metrics and logs related to the performance and operations are collected. View and analyze the captured data in [Azure Monitor](/azure/azure-monitor/overview). 

**Are application events correlated across all application components?**
***

Event correlation between the layers of the application will provide the ability to connect tracing data of the complete application stack. Once this connection is made, you can see a complete picture of where time is spent at each layer. This will typically mean having a tool that can query the repositories of tracing data in correlation to a unique identifier that represents a completed transaction that has flowed through the system.

**Is it possible to evaluate critical application performance targets and non-functional requirements (NFRs)?**
***

Application level metrics should include end-to-end transaction times of key technical functions, such as database queries, response times for external API calls, failure rates of processing steps, etc.

**Is the end-to-end performance of critical system flows monitored?**
***
It should be possible to correlate application log events across critical system flows, such as user login, to fully assess the health of key scenarios in the context of targets and NFRs.


## Next
> [!div class="nextstepaction"] 
> [Monitor infrastructure](monitor-infrastructure.md)


## Related links
- [Application Insights](/azure/azure-monitor/app/app-insights-overview)
- [Azure Monitor](/azure/azure-monitor/overview)
> [Back to the main article](monitor.md)
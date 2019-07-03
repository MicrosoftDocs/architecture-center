---
title: Cloud monitoring guide – Collecting the right data
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Choose when to use Azure Monitor or System Center Operations Manager in Microsoft Azure
services: azure-monitor
keywords: 
author: mgoedtel
ms.author: magoedte
ms.date: 06/26/2019
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Cloud monitoring guide: Collecting the right data

This article describes some considerations for collecting monitoring data in a cloud application. 

To observe the health and availability of your cloud solution, you must configure the monitoring tools to collect a level of signals that are based on predictable failure states (the symptoms not the cause of the failure) using metrics and for advanced diagnostics and root cause analysis, use logs.  

Plan for monitoring and migration thoughtfully starting by including the monitoring service owner, the manager of operations, and other related personas during the planning phase, and continue engaging them throughout the development and release cycle. Their focus will be to develop a monitoring configuration that is based on the following criteria:

* What is the composition of the service and are those dependencies monitored today?  If so, are there multiple tools involved and is there an opportunity to consolidate to meet the 80% need without introducing risks that can bring cost efficiency?
* What is the SLA of the service and how will I measure and report it?
* What should the service dashboard look like when an incident is raised? What should the dashboard look like for the service owner, the team supporting the service, etc.?
* What metrics does the resource produce that I need to monitor?  
* How will the service owner, support teams, and other personas be searching the logs?

Based on how you answer those questions and the criteria for alerting, which is described in that section later in this article, determines how you will use the monitoring platform.  If migrating from an existing monitoring platform or set of monitoring tools, use the migration as an opportunity to reevaluate the signals you collect.  Especially now that there are several cost factors to consider when migrating or integrating with a cloud-based monitoring platform like Azure Monitor.  Remember, monitoring data needs to actionable and data collected should be optimized for providing a 10,000 foot view of the overall health of the service.  The instrumentation defined to identify real incidents should be as simple, predictable, and reliable as possible.

The monitoring service owner and team will typically follow a common set of set activities to develop a monitoring configuration that needs to be conducted starting at the initial planning stages, test and validate in a pre-production environment, and then deploy into production. Monitoring configurations are derived from known failure modes, test results of simulated failures, and experience from several personas in the organization (the service desk, operations, engineers, and developers, etc.) assuming the service already exists, is being migrated to the cloud, and hasn’t been rearchitected.  Monitoring the health and availability of these services earlier on in the development process becomes increasingly evident, service-level quality is delivered when monitoring of the new service is released in tandem, not afterwards.  Traditionally, the monitoring design of that service or application has been an afterthought and as a result, this approach has never been successful.  

To drive quicker resolution of the incident, consider the following recommendations:

* Define a dashboard for each service component.
* Metrics should be used to help guide further diagnosis to identify resolution or workaround of the issue if root cause cannot be uncovered to help restore service as quickly as possible.
* Use dashboard drill-down capabilities or support customizing the view to refine it. 
* If verbose logs are needed, metrics should have helped target the search criteria.  If not, improve your metrics for the next incident.

Embracing this guiding set of principles gives you near real-time insights as well as better management of your service.

## Next steps

> [!div class="nextstepaction"]
> [Alerting strategy](./alert.md)

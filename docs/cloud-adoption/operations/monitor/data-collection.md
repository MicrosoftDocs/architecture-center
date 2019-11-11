---
title: Cloud monitoring guide – Collecting the right data
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Choose when to use Azure Monitor or System Center Operations Manager in Microsoft Azure
author: MGoedtel
ms.author: magoedte
ms.date: 06/26/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: operate
services: azure-monitor
---

# Cloud monitoring guide: Collecting the right data

This article describes some considerations for collecting monitoring data in a cloud application.

To observe the health and availability of your cloud solution, you must configure the monitoring tools to collect a level of signals that are based on predictable failure states. These signals are the symptoms of the failure, not the cause. The monitoring tools use metrics, and, in the case of advanced diagnostics and root cause analysis, also use logs.

Plan for monitoring and migration carefully. Start by including the monitoring service owner, the manager of operations, and other related personnel during the planning phase, and continue engaging them throughout the development and release cycle. Their focus will be to develop a monitoring configuration that is based on the following criteria:

- What's the composition of the service, and are those dependencies monitored today? If so, are there multiple tools involved? Is there an opportunity to consolidate, without introducing risks?
- What is the SLA of the service, and how will I measure and report it?
- What should the service dashboard look like when an incident is raised? What should the dashboard look like for the service owner, and the team supporting the service?
- What metrics does the resource produce that I need to monitor?  
- How will the service owner, support teams, and other personnel be searching the logs?

How you answer those questions, and the criteria for alerting, determines how you'll use the monitoring platform. If you're migrating from an existing monitoring platform or set of monitoring tools, use the migration as an opportunity to reevaluate the signals you collect. This is especially true now that there are several cost factors to consider when migrating or integrating with a cloud-based monitoring platform like Azure Monitor. Remember, monitoring data needs to be actionable. You need to have optimized data collected to give you "a 10,000 foot view" of the overall health of the service. The instrumentation defined to identify real incidents should be as simple, predictable, and reliable as possible.

## Develop a monitoring configuration

The monitoring service owner and team typically follow a common set of activities to develop a monitoring configuration. These activities start at the initial planning stages, continue through testing and validating in a pre-production environment, and extend to deploying into production. Monitoring configurations are derived from known failure modes, test results of simulated failures, and the experience of several people in the organization (the service desk, operations, engineers, and developers). Such configurations assume the service already exists, is being migrated to the cloud, and hasn’t been rearchitected.

Monitor the health and availability of these services early on in the development process, for service-level quality results. If you monitor design of that service or application as an afterthought, your results won't be as successful.

To drive quicker resolution of the incident, consider the following recommendations:

- Define a dashboard for each service component.
- Use metrics to help guide further diagnosis, to identify a resolution or workaround of the issue if a root cause can't be uncovered.
- Use dashboard drill-down capabilities, or support customizing the view to refine it.
- If you need verbose logs, metrics should have helped target the search criteria. If not, improve your metrics for the next incident.

Embracing this guiding set of principles gives you near real-time insights, as well as better management of your service.

## Next steps

> [!div class="nextstepaction"]
> [Alerting strategy](./alert.md)

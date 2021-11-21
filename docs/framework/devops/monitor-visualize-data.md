---
title: Visualize data and raise alerts
description: Provides information about visualizing data and raising alerts as it relates to the health modeling and monitoring component of the Operational Excellence pillar.
author: v-stacywray
manager: david-stanford
ms.date: 11/18/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-monitor
  - azure-application-insights
categories:
  - management-and-governance    
ms.custom:
  - fasttrack-edit
  - article
---

# Visualize data and raise alerts

An important aspect of any monitoring system is the ability to present the data in such a way that an operator can quickly spot any trends or problems. Also important is the ability to quickly inform an operator if a significant event has occurred that might require attention.

Data presentation can take several forms, including visualization by using dashboards, alerting, and reporting.

## Use dashboards to visualize data

The most common way to visualize data is to use dashboards that can display information as a series of charts, graphs, or some other illustration. These items can be parameterized, and an analyst can select the important parameters, such as the time period, for any specific situation.

Dashboards can be organized hierarchically. Top-level dashboards can give an overall view of each aspect of the system but enable an operator to drill down to the details. For example, a dashboard that shows the overall disk I/O for the system should allow an analyst to view the I/O rates for each individual disk to determine whether one or more specific devices account for a disproportionate volume of traffic. Ideally, the dashboard should also display related information, such as the source of each request (the user or activity) that's generating this I/O. This information can then be used to determine whether (and how) to spread the load more evenly across devices, and whether the system would perform better if more devices were added.

A dashboard may also use color-coding or some other visual cues to indicate values that appear anomalous or that are outside an expected range. Using the previous example:

- A disk with an I/O rate that's approaching its maximum capacity over an extended period (a hot disk) can be highlighted in red.
- A disk with an I/O rate that periodically runs at its maximum limit over short periods (a warm disk) can be highlighted in yellow.
- A disk that's showing normal usage can be displayed in green.

For a dashboard system to work effectively, it must have the raw data to work with. If you're building your own dashboard system, or using a dashboard developed by another organization, you must understand the following concepts:

- Which instrumentation data do you need to collect?
- At what levels of granularity?
- How should you format data for the dashboard to consume?

A good dashboard doesn't only display information, it also enables an analyst to pose improvised questions about that information. Some systems provide management tools that an operator can use to complete these tasks and explore the underlying data. Instead, depending on the repository that's used to hold this information, it may be possible to query this data directly, or import it into tools such as Microsoft Excel for further analysis and reporting.

> [!NOTE]
> You should restrict access to dashboards to authorized personnel, because this information may be commercially sensitive. You should also protect the underlying data for dashboards to prevent users from changing it.

## Reporting

Reporting is used to generate an overall view of the system. It may incorporate historical data and current information. Reporting requirements fall into two broad categories: operational reporting and security reporting.

*Operational reporting* typically includes the following aspects:

- Aggregating statistics that you can use to understand resource utilization of the overall system or specified subsystems during a specified time window.
- Identifying trends in resource usage for the overall system or specified subsystems during a specified period.
- Monitoring exceptions that have occurred throughout the system or in specified subsystems during a specified period.
- Determining the efficiency of the application for the deployed resources, and understanding whether the volume of resources, and their associated cost, can be reduced without affecting performance unnecessarily.

*Security reporting* tracks customers' use of the system. It can include:

- *Auditing user operations*: This method requires recording the individual requests that each user completes, together with dates and times. The data should be structured to enable an administrator to quickly reconstruct the sequence of operations that a user completes over a specified period.
- *Tracking resource use by user*: This method requires recording how each request for a user accesses the various resources that compose the system, and for how long. An administrator can use this data to generate a utilization report, by user, over a specified period, possibly for billing purposes.

In many cases, batch processes can generate reports according to a defined schedule. Latency isn't normally an issue. Batch processes should also be available for generation on a spontaneous basis, if needed. As an example, if you are storing data in a relational database, such as Azure SQL Database, you can use a tool such as SQL Server Reporting Services to extract and format data, and present it as a set of reports.

## Next steps

> [!div class="nextstepaction"]
> [More information: Alerting](monitor-alerts.md)
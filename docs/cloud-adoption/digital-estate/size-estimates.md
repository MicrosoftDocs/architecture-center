---
title: "Enterprise Cloud Adoption: How can I estimate operational costs after migration is complete?"
description: Explanation of migration estimate sizing
author: BrianBlanchard
ms.date: 10/10/2018
---

# Enterprise Cloud Adoption: How can I estimate operational costs after migration is complete?

An analysis of the digital estate can produce cost estimates, which will in turn drive Return on Investment (ROI).
The steps to analyze a digital estate are below:

* [Determine analysis approach](approach.md)
* [Collect current state inventory](inventory.md)
* Evaluate the initial digital estate for accuracy and completeness
* [Rationalize the assets in the digital estate](rationalize.md)
* [Align assets to Cloud offerings to calculate pricing](price.md)

## Faster approach to costing estimates

To help understand high level estimates of cost, the following basic sizes have been created as a rough baseline.
Customers often plan a re-host effort based on a DataCenter that they'd like to eliminate. The following sizes are based on commonly seen distributions of specific VM types, grouped into small, medium, and large sized DataCenters.

**First Workload:** When customers deploy their first workload, it typically consists of a data source, like SQL Server, and 3-5 Virtual Machines (VMs) with medium performance requirements.

[Detailed Azure Cost Estimate](estimate.md)

**Small DataCenter:** A DataCenter, Co-location facility, or hosted environment consisting of around 100 Virtual Machines. Generally assuming that 5% of those VMs are large-sized SQL Servers, 5% are small sized admin VMs, 60% are medium-sized Windows VMs, and 30% are medium-sized linux workloads.

[Detailed Azure Cost Estimate](estimate.md)

**Medium DataCenter:** A DataCenter, Co-location facility, or hosted environment consisting of around 500 Virtual Machines. Generally assuming that 10% of those VMs are large-sized SQL Servers, 5% are small sized admin VMs, 45% are medium-sized Windows VMs, and 40% are medium-sized linux workloads.

[Detailed Azure Cost Estimate](estimate.md)

**Large DataCenter:** A DataCenter, Co-location facility, or hosted environment consisting of 1,000 Virtual Machines. Generally assuming that 5% of those VMs are large-sized SQL Server Clusters, 5% are small sized admin VMs, 45% are medium-sized Windows VMs, and 45% are medium-sized linux workloads.

[Detailed Azure Cost Estimate](estimate.md)

For more accurate cost estimates, it is suggested that the [Digital Estate be analyzed](overview.md).
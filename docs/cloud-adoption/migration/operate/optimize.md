---
title: "Fusion: Benchmark and Optimize"
description: A process within Cloud Migration that focuses on benchmarking performance and optimizing assets
author: BrianBlanchard
ms.date: 10/11/2018
---

# Fusion: Benchmark and Optimize Cloud Assets

The [Migration section](../overview.md) of the [Fusion framework](../../overview.md), outlines the processes typically required to migrate a datacenter to the cloud. This section of the framework, expands on the [Operate Process](overview.md) within migration by discussing options benchmark and optimize resources.

## Should assets be optimized during the [Migrate Process](../Migrate/overview.md) or during the [Operate Process](overview.md)?

This is one of the most common questions regarding optimization. When should an asset be optimized? The easy answer is both. However, that's not entirely accurate. To explain, lets start with two basic definitions:

* Resize: Often times an asset is so grossly oversized & underutilized that it can be easily resized during deployment. The ultimate test of resizing is the UAT test. When a power user performs a UAT test, does the user experience performance or functionality losses? If not, the asset has been successfully sized.
* Optimization: Optimization is a data-driven approach to resource size management. Using benchmarks of the asset and applications performance, an IT team can make educated decisions regarding the most appropriate size, services, scale, and architecture of a solution. They can then Resize and test performance theories.

During the [Migrate Process](../Migrate/overview.md), use educated guesses and experiment with sizing. However, true optimization of resources requires data based on actual performance in a cloud environment. for true optimization to occur, the IT team must first implement approaches to monitoring performance and resource utilization.

## Benchmark and Optimize with Azure Cost Management

Azure Cost Management licensed by Cloudyn, a Microsoft subsidiary, manages cloud spend with transparency and accuracy. This service monitors, benchmarks, allocates, and optimizes cloud costs.

Monitoring usage and spending is critically important for cloud infrastructures. Organizations pay for the resources they consume over time. When usage exceeds agreement thresholds, unexpected cost overages can quickly accumulate. Cost Management Reports monitor spending to analyze and track cloud usage, costs, and trends. Using Over Time reports, detect anomalies that differ from normal trends. Inefficiencies in cloud deployment are visible in optimization reports. Note inefficiencies in cost-analysis reports.

Historical data can help manage costs by analyzing usage and costs over time to identify trends. Trends are then used to forecast future spending. Cost Management also includes useful projected cost reports. Cost allocation manages costs by analyzing costs based on [tagging policy](../../infrastructure/resource-tags/overview.md). Use cost allocation for showback/chargeback to show resource utilization and associated costs to influence consumption behaviors or charge tenant customers. Access control helps manage costs by ensuring that users and teams access only the cost management data that they need. Alerting helps manage costs through automatic notification when unusual spending or overspending occurs. Alerts can also notify other stakeholders automatically for spending anomalies and overspending risks. Various reports support alerts based on budget and cost thresholds.

## Improve efficiency

Determine optimal VM usage, identify idle VMs, or remove idle VMs and unattached disks with Cost Management. Using information in Sizing Optimization and Inefficiency reports, create a plan to down-size or remove idle VMs.

## Limitations

However, alerts and optimization reports are not currently supported for cloud providers partner accounts or subscriptions.

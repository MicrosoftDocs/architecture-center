---
title: "Benchmark and resize cloud assets"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Benchmark and resize cloud assets
author: BrianBlanchard
ms.author: brblanch
ms.date: 5/19/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Benchmark and resize cloud assets

Monitoring usage and spending is critically important for cloud infrastructures. Organizations pay for the resources they consume over time. When usage exceeds agreement thresholds, unexpected cost overages can quickly accumulate. Cost Management reports monitor spending to analyze and track cloud usage, costs, and trends. Using overtime reports, detect anomalies that differ from normal trends. Inefficiencies in cloud deployment are visible in optimization reports. Note inefficiencies in cost-analysis reports.

In the traditional on-premises models of IT, requisition of IT systems is costly and time consuming. The processes often require lengthy capital expenditure review cycles and may even require an annual planning process. As such, it is common practice to buy more than is needed. It is equally common for IT administrators to then overprovision assets in preparation for anticipated future demands.

In the cloud, the accounting and provisioning models eliminate the time delays that lead to overbuying. When an asset needs additional resources, it can be scaled up or out almost instantly. This means that assets can safely be reduced in size to minimize resources and costs consumed. During benchmarking and optimization, the cloud adoption team seeks to find the balance between performance and costs, provisioning assets to be no larger and no smaller than necessary to meet production demands.

<!-- markdownlint-disable MD026 -->

## Should assets be optimized during or after the migration?

When should an asset be optimized&mdash;during or after the migration? The simple answer is *both*. However, that's not entirely accurate. To explain, take a look at two basic scenarios for optimizing resource sizing:

- **Planned resizing.** Often, an asset is clearly oversized and underutilized and should be resized during deployment. Determining if an asset has been successfully resized in this case requires user acceptance testing after migration. If a power user does not experience performance or functionality losses during testing, you can conclude the asset has been successfully sized.
- **Optimization.** In cases where the need for optimization is unclear, IT teams should use a data-driven approach to resource size management. Using benchmarks of the asset’s performance, an IT team can make educated decisions regarding the most appropriate size, services, scale, and architecture of a solution. They can then resize and test performance theories post-migration.

During the migration, use educated guesses and experiment with sizing. However, true optimization of resources requires data based on actual performance in a cloud environment. For true optimization to occur, the IT team must first implement approaches to monitoring performance and resource utilization.

## Benchmark and optimize with Azure Cost Management

[Azure Cost Management](/azure/cost-management/overview) licensed by Cloudyn, a Microsoft subsidiary, manages cloud spend with transparency and accuracy. This service monitors, benchmarks, allocates, and optimizes cloud costs.

Historical data can help manage costs by analyzing usage and costs over time to identify trends, which are then used to forecast future spending. Cost Management also includes useful projected cost reports. Cost allocation manages costs by analyzing costs based on tagging policies. Use cost allocation for showback/chargeback to show resource utilization and associated costs to influence consumption behaviors or charge tenant customers. Access control helps manage costs by ensuring that users and teams access only the Cost Management data that they need. Alerting helps manage costs through automatic notification when unusual spending or overspending occurs. Alerts can also notify other stakeholders automatically for spending anomalies and overspending risks. Various reports support alerts based on budget and cost thresholds.

## Improve efficiency

Determine optimal VM usage, identify idle VMs, or remove idle VMs and unattached disks with Cost Management. Using information in sizing optimization and inefficiency reports, create a plan to downsize or remove idle VMs.

## Next steps

After a workload has been tested and optimized, it is time to [ready the workload for promotion](./ready.md).

> [!div class="nextstepaction"]
> [Getting a migrated workload ready for production promotion](./ready.md)

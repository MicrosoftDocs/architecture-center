---
title: "Approaches to digital estate planning"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Learn about various approaches to digital estate planning.
author: BrianBlanchard
ms.author: brblanch
ms.date: 12/10/2018
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: plan
ms.custom: governance
---

# Approaches to digital estate planning

Digital estate planning can take several forms depending on the desired outcomes and size of the existing estate. There are various approaches that you can take. It's important to set expectations regarding the approach early in planning cycles. Unclear expectations often lead to delays associated with additional inventory-gathering exercises. This article outlines three approaches to analysis.

## Workload-driven approach

The top-down assessment approach evaluates security aspects. Security includes the categorization of data (high, medium, or low business impact), compliance, sovereignty, and security risk requirements. This approach assesses high-level architectural complexity. It evaluates aspects such as authentication, data structure, latency requirements, dependencies, and application life expectancy.

The top-down approach also measures the operational requirements of the application, such as service levels, integration, maintenance windows, monitoring, and insight. When all of these aspects have been analyzed and taken into consideration, the resulting score that reflects the relative difficulty of migrating this application to each of the cloud platforms: IaaS, PaaS, and SaaS.

In addition, the top-down assessment evaluates the financial benefits of the application, such as operational efficiencies, TCO, return on investment, and other appropriate financial metrics. The assessment also examines the seasonality of the application (for example, are there times of the year when demand spikes?) and overall compute load.

It also looks at the types of users it supports (casual/expert, always/occasionally logged on), and the required scalability and elasticity. Finally, the assessment concludes by examining business continuity and resiliency requirements, as well as dependencies for running the application if a disruption of service should occur.

> [!TIP]
> This approach requires interviews and anecdotal feedback from business and technical stakeholders. Availability of key individuals is the biggest risk to timing. The anecdotal nature of the data sources makes it more difficult to produce accurate cost or timing estimates. Plan schedules in advance and validate any data that's collected.

## Asset-driven approach

The asset-driven approach provides a plan based on the assets that support an application for migration. In this approach, you pull statistical usage data from a configuration management database (CMDB) or other infrastructure assessment tools.

This approach usually assumes an IaaS model of deployment as a baseline. In this process, the analysis evaluates the attributes of each asset: memory, number of processors (CPU cores), operating system storage space, data drives, network interface cards (NICs), IPv6, network load balancing, clustering, operating system version, database version (if necessary), supported domains, and third-party components or software packages, among others. The assets that you inventory in this approach are then aligned with workloads or applications for grouping and dependency mapping purposes.

> [!TIP]
> This approach requires a rich source of statistical usage data. The time that's needed to scan the inventory and collect data is the biggest risk to timing. The low-level data sources can miss dependencies between assets or applications. Plan for at least one month to scan the inventory. Validate dependencies before deployment.

## Incremental approach

We strongly suggest an incremental approach, as we do for many processes in the Cloud Adoption Framework. In the case of digital estate planning, that equates to a multiphase process:

- **Initial cost analysis:** If financial validation is required, start with an asset-driven approach, described earlier, to get an initial cost calculation for the entire digital estate, with no rationalization. This establishes a worst-case scenario benchmark.

- **Migration planning:** After you have assembled a cloud strategy team, build an initial migration backlog using a workload-driven approach that's based on their collective knowledge and limited stakeholder interviews. This approach quickly builds a lightweight workload assessment to foster collaboration.

- **Release planning:** At each release, the migration backlog is pruned and reprioritized to focus on the most relevant business impact. During this process, the next five to ten workloads are selected as prioritized releases. At this point, the cloud strategy team invests the time in completing an exhaustive workload-driven approach. Delaying this assessment until a release is aligned better respects the time of stakeholders. It also delays the investment in full analysis until the business starts to see results from earlier efforts.

- **Execution analysis:** Before migrating, modernizing, or replicating any asset, assess it both individually and as part of a collective release. At this point, the data from the initial asset-driven approach can be scrutinized to ensure accurate sizing and operational constraints.

> [!TIP]
> This incremental approach enables streamlined planning and accelerated results. It's important that all parties involved understand the approach to delayed decision making. It's equally important that assumptions made at each stage be documented to avoid loss of details.

## Next steps

Once an approach is selected, the inventory can be collected.

> [!div class="nextstepaction"]
> [Gather inventory data](inventory.md)

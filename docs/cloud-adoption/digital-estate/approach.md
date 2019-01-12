---
title: Approaches to digital estate planning
titleSuffix: Enterprise Cloud Adoption
description: Describes some approaches to digital estate planning
author: BrianBlanchard
ms.date: 12/10/2018
ms.topic: article
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Enterprise Cloud Adoption: Approaches to digital estate planning

Digital estate planning can take a number of shapes, depending on the desired outcomes and size of the existing estate. There are also a number of options regarding the approach taken. It's important to set expectations regarding the approach early in planning cycles. Unclear expectations often lead to delays associated with additional inventory gathering exercises. This article outlines three approaches to analysis.

## Workload-driven approach

The top-down assessment approach evaluates the security aspects, such as the categorization of data (high, medium, or low business impact), compliance, sovereignty, and security risk requirements. This approach then assesses high-level architectural complexity, evaluating aspects such as authentication, data structure, latency requirements, dependencies, and application life expectancy. Next, the top-down approach measures the operational requirements of the application, such as service levels, integration, maintenance windows, monitoring, and insight. When all of these aspects have been analyzed and taken into consideration, the result is a score that reflects the relative difficulty to migrate this application to each of the cloud platforms: IaaS, PaaS, and SaaS.

Second, the top-down assessment evaluates the financial benefits of the application, such as operational efficiencies, TCO, return on investment, or any other appropriate financial metrics. In addition, the assessment also examines the seasonality of the application (are there times of the year when demand spikes) and overall compute load. Also, it looks at the types of users it supports (casual/expert, always/occasionally logged on), and consequently the required scalability and elasticity. Finally, the assessment concludes by examining business continuity and resiliency requirements that the application might have, as well as dependencies to run the application if a disruption of service should occur.

> [!TIP]
> This approach requires interviews and anecdotal feedback from business and technical stakeholders. Availability of key individuals is the biggest risk to timing. The anecdotal nature of the data sources makes it more difficult to produce accurate cost or timing estimates. Plan schedules in advance and validate any data collected.

## Asset-driven approach

The asset-driven approach provides a plan based on the assets that support an application to migrate. In this approach, statistical usage data is pulled from a Configuration Management Database (CMDB) or other infrastructure assessment tools. This approach usually assumes an IaaS model of deployment as a baseline. In this process, the analysis evaluates the attributes of each asset: memory, number of processors (CPU cores), operating system storage space, data drives, network interface cards (NICs), IPv6, network load balancing, clustering, version of the operating system, version of the database (if required), domains supported, and third-party components or software packages, among others. The assets inventoried in this approach are then aligned with workloads or applications for grouping and dependency mapping purposes.

> [!TIP]
> This approach requires a rich source of statistical usage data. The time to scan the inventory and collect data is the biggest risk to timing. The low-level data sources can miss dependencies between assets or applications. Plan for at least one month to scan the inventory. Validate dependencies before deployment.

## Incremental approach

Like much of the Enterprise Cloud Adoption framework, an incremental approach is highly suggested. In the case of digital estate planning, that equates to a multi-phase process, as follows:

- Initial cost analysis: If financial validation is required, start with an asset-driven approach, described above, to get an initial cost calculation for the entire digital estate, with no rationalization. This establishes a worst-case scenario benchmark.

- Migration planning: Once a Cloud Strategy team has been assigned, build an initial migration backlog using a workload-driven approach, based solely on their collective knowledge and limited stakeholder interviews. This approach quickly builds a light-weight workload assessment to foster collaboration.

- Release planning: At each release, the migration backlog is pruned and re-prioritized to focus on the most relevant business impact. During this process, the next 5&ndash;10 workloads would be selected as prioritized releases. At this point, the Cloud Strategy team would invest the time in completing an exhaustive workload-driven approach. Delaying this assessment until a release is aligned, better respects the time of stakeholders. It also delays the investment in full analysis until the business starts to see results from earlier efforts.

- Execution analysis: Prior to the migration, modernization, or replication of any asset, the asset should be assessed individually and as part of a collective release. At this point, the data from the initial asset-driven approach can be scrutinized to ensure accurate sizing and operational constraints.

> [!TIP]
> This incremental approach allows for streamlined planning and accelerated results. It is very important that all parties involved understand the approach to delayed decision making. It is equally important that assumptions made at each stage be documented to avoid loss of details.

## Next steps

Once an approach is selected, the inventory can be collected.

> [!div class="nextstepaction"]
> [Gather inventory data](inventory.md)
---
title: "Estimate cloud costs prior to migration"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Explanation of the process of estimating cloud costs prior to migration.
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Estimate cloud costs

During migration, there are several factors that can affect decisions and execution activities. To help understand which of those options are best for different situations, this article discusses various options for estimating cloud costs.

## Digital estate size

The size of your digital estate directly affects migration decisions. Migrations that involve fewer than 250 VMs can be estimated much more easily than a migration involving 10,000+ VMs. It's highly recommended that you select a smaller workload as your first migration. This gives your team a chance to learn how to estimate the costs of a simple migration effort before attempting to estimate larger and more complicated workload migrations.

However, note that smaller, single-workload, migrations can still involve a widely varying amount of supporting assets. If your migration involves under 1,000 VMs, a tool like [Azure Migrate](/azure/migrate/migrate-overview) is likely sufficient to gather data on the inventory and forecast costs. Additional cost-estimate tooling options are described in the article on [digital estate cost calculations](../../../digital-estate/calculate.md).

For 1,000+ unit digital estates, it’s still possible to break down an estimate into four or five actionable iterations, making the estimation process manageable. For larger estates or when a higher degree of forecast accuracy is required, a more comprehensive approach, like that outlined in the "[Digital estate](../../../digital-estate/index.md)" section of the Cloud Adoption Framework, will likely be required.

## Accounting models

Accounting models

If you are familiar with traditional IT procurement processes, estimation in the cloud may seem foreign. When adopting cloud technologies, acquisition shifts from a rigid, structured capital expense model to a fluid operating expense model. In the traditional capital expense model, the IT team would attempt to consolidate buying power for multiple workloads across various programs to centralize a pool of shared IT assets that could support each of those solutions. In the operating expenses cloud model, costs can be directly attributed to the support needs of individual workloads, teams, or business units. This approach allows for a more direct attribution of costs to the supported internal customer. When estimating costs, it’s important to first understand how much of this new accounting capability will be used by the IT team.

For those wanting to replicate the legacy capital expense approach to accounting, use the outputs of either approach suggested in the "[Digital estate size](#digital-estate-size)" section above to get an annual cost basis. Next, multiply that annual cost by the company’s typical hardware refresh cycle. Hardware refresh cycle is the rate at which a company replaces aging hardware, typically measured in years. Annual run rate multiplied by hardware refresh cycle creates a cost structure similar to a capital expense investment pattern.

## Next steps

After estimating costs, migration can begin. However, it would be wise to review [partnership and support options](./partnership-options.md) before beginning any migration.

> [!div class="nextstepaction"]
> [Understanding partnership options](./partnership-options.md)

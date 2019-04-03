---
title: "Estimate cloud costs prior to migration"
description: Explanation of the process of estimating cloud costs prior to migration
author: BrianBlanchard
ms.date: 4/4/2019
---

# Estimate cloud costs

During migration, there are a number of factors that can impact decisions and execution activities. To help understand which of those options are best for different situations, this article discusses various options for estimating cloud costs.

## Digital Estate Size

The size of your digital estate directly impacts migration decisions. Migrations that involve fewer than 250 VMs can be estimated much more easily than a migration involving 10,000+ VMs. It's highly recommended that you select a smaller workload as your first migration. This gives your team a chance to learn how to estimate the costs of a simple migration effort before attempting to estimate larger and more complicated workload migrations. 

However, note that smaller, single-workload, migrations can still involve a widely varying amount of supporting assets. If your migration involves under 1,000 VMs, a tool like [Azure Migrate](/azure/migrate/migrate-overview) is likely sufficient to gather data on the inventory and forecast costs. Additional cost-estimate tooling options are described in the article on [digital estate cost calculations](../../../digital-estate/calculate.md).

For 1,000+ unit digital estates, it’s still possible to break down an estimate into four or five actionable iterations, making the estimation process manageable. For larger estates or when a higher degree of forecast accuracy is required, a more comprehensive approach, like that outlined in the "[Digital estate](../../../digital-estate/overview.md)" section of the Cloud Adoption Framework, will likely be required.

## Accounting Models

Accounting models

If you are familiar with traditional IT procurement processes, estimation in the cloud may seem foreign. When adopting cloud technologies, acquisition shifts from a rigid, structured capital expenditure (CapEx) model to a fluid operating expense (OpEx) one. In the traditional CapEx model, the IT team would attempt to consolidate buying power for multiple workloads across various programs to centralize a pool of shared IT assets that could support each of those solutions. In the OpEx-based cloud model, costs can be directly attributed to the support needs of individual workloads, teams, or business units. This approach allows for a more direct attribution of costs to the supported internal customer. When estimating costs, it’s important to first understand how much of this new accounting capability will be leveraged by the IT team.

For those who wish to replicate the legacy CapEx approach to accounting, leverage the outputs of either approach suggested in the "[Digital estate size](#digital-estate-size)" section above to get an annual cost basis. Next, multiply that annual cost by the company’s typical hardware refresh cycle. Hardware refresh cycle is the rate at which a company replaces aging hardware, usually measured in years. Annual run rate multiplied by hardware refresh cycle creates a cost structure very similar to a CapEx investment pattern.

## Next steps

After estimating costs, migration can begin. However, it would be wise to review [partnership and support options](./partnership-options.md) before beginning any migration.

> [!div class="nextstepaction"]
> [Understanding partnership options](./partnership-options.md)
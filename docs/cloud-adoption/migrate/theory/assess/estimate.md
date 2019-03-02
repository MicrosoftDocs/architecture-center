---
title: "Estimate cloud costs prior to migration"
description: Explanation of the process of estimating cloud costs prior to migration
author: BrianBlanchard
ms.date: 4/4/2019
---

# Estimate Cloud Costs

During migration, there are a number of factors that will impact decisions and execution activities. This article discusses various options for estimating cloud costs to help understand which of those options are best for the reader.

## Digital Estate Size

As with other decisions, the size of the digital estate will directly impact decisions. Migrations that involve less that 250 VMs can be estimated more easily that migrations of 10,000+ VMs. For 1,000+ unit digital estates, its still possible to break down an estimate into 4-5 actionable iterations making the estimation process manageable.

If the digital estate size is under 1,000 VMs, a tool like [Azure Migrate](/azure/migrate/migrate-overview) is likely sufficient to gather data on the inventory and forecast costs. Additional cost estimate tooling options are described in the article on [digital estate cost calculations](../../../digital-estate/calculate.md).

For larger estates or when a higher degree of forecast accuracy is required, a more comprehensive approach like that outlined in the [Digital Estate section of the Cloud Adoption Framework](../../../digital-estate/overview.md) will likely be required.

## Accounting Models

For readers who are familiar with traditional IT procurement processes, estimation in the cloud will seem foreign. When adopting cloud technologies, acquisition shifts from a rigid, structured capital expenditure (CapEx) to a fluid operating expense (OpEx) model. In the traditional CapEx model, the IT team would attempt to consolidate buying power for multiple applications across multiple programs to centralize a pool of share IT assets that could support each of those solutions. In the OpEx based cloud model, costs can be directly attributed to the support needs of individual applications, teams, or business units. This approach allows for a more direct attribution of costs to the supported internal customer. When estimating costs its important to first understand how much of this new accounting capability will be leveraged by the IT team.

For readers who wish to replicate the legacy CapEx approach to accounting, leverage the outputs of either approach suggested in the [Digital Estate Size](#digital-estate-size) section above to get an annual costs basis. Next, multiply that annual cost by the companies typical hardware refresh cycle. Hardware refresh cycle is the rate at which a company replaces aging hardware, this is usually measured in years. Annual run rate multiplied by hardware refresh cycle will create a cost structure very similar to a CapEx investment pattern.

## Next steps

After estimating costs, migration can begin. However, it would be wise to review [partnership and support options](partnership-options.md) before beginning any migration.

> [!div class="nextstepaction"]
> [Engaging Migration Partners and Support](partnership-options.md)
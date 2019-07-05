---
title: "Prioritize and define workloads for a cloud adoption plan"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Prioritize and define workloads for a cloud adoption plan
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/01/2019
ms.topic: guide
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Prioritize and define workloads for a cloud adoption plan

Establishing clear, actionable priorities is one of the secrets to successful cloud adoption. The natural temptation is to invest time in defining all workloads that could potential be impacted during cloud adoption. However, this practice is counterproductive, especially early in the adoption process. Instead it is suggested that the team focus on doing a thorough job of prioritizing and documenting the first 10 workloads. Once implementation of the adoption plan begins, the team can maintain a list of the next 10 highest priority workloads. This approach provides enough information to plan for the next few iterations. Limiting the plan to 10 workloads encourages agility and prioritization alignment as business criteria change. This approach also provides room for the cloud adoption team to learn and refine estimates. Most importantly, this approach removes extensive planning as a barrier to effective business change.

## What is a workload

In the context of a cloud adoption, a workload is a collection of IT assets (servers, VMs, applications, data, or appliances) which collectively support a defined process. Workloads may support more than one process. Workloads may be dependent on other share assets or larger platforms. However, a workload should have defined boundaries regarding the dependent assets and the processes that depend upon th workload. Often times workloads can be visualized by monitoring network traffic among IT assets.

## Prerequisites

The strategic inputs from the prerequisites checklist are designed to make the following tasks much easier to accomplish. For assistance aggregating the data referenced in this article, review the [prerequisites checklist](./prerequisites.md).

## Initial workload prioritization

During the process of [incremental rationalization](../digital-estate/rationalize.md), the team should have agreed on a power of 10 approach, which consists of 10 priority workloads. These workloads will serve as an initial boundary for adoption planning.

If it is decided that a digital estate rationalization isn't needed, then it is advised that the cloud adoption and cloud strategy teams agree on a list of 10 applications to serve as the initial focus of the migration. It is further advised that these 10 workloads contain a mixture of simple workloads (<10 assets in a self-contained deployment) and more complex workloads. Those 10 workloads will start the workload prioritization process.

> [!NOTE]
> The Power of 10 serves as an initial boundary for planning to focus the energy and investment in early stage analysis. However, the act of analyzing and defining workloads is likely to cause changes in the list of priority workloads.

## Add workloads to your cloud adoption plan

In the previous article, [Deploy your cloud adoption plan](./template.md), you created a cloud adoption plan in Azure DevOps.

The workloads in the Power of 10 list can now be represented in your cloud adoption plan. The easiest way to do this is via bulk editing in Microsoft Excel. To prepare your workstation for bulk editing, see [Bulk add or modify (Excel)](/azure/devops/boards/backlogs/office/bulk-add-modify-work-items-excel?view=azure-devops).

In Step 5 in the referenced article, it tells you to choose an Input list. Instead, you will want to choose a Query list. From the "Select a Query" dropdown, you will want to choose the "Workload Template" query. That will load all of the efforts related to the migration of a single workload into your spreadsheet.

Once the workload template work items are loaded, you can begin adding new workloads by following these steps:

1. Copy all of the items with the "Workload Template" tag listed in the far right column.
2. Paste the copied rows below the last line item in the table.
3. Change the title cell for the new feature from "Workload Template" to the name of your new workload.
4. Paste the new workload name cell into the tag column for all rows below the new feature. Be careful to not change the tags or name of the rows related to the actual "workload template" feature. You will need those work items when you add the next workload to the cloud adoption plan.
5. Skip forward to Step 8 in the bulk editing instructions to "Publish" the worksheet. This will create all of the work items required to migrate your workload.

Repeat steps 1&ndash;5 for each of the workloads in the Power of 10 list.

## Defining workloads

Once initial priorities are defined and workloads have been added to the plan, each of those workloads can be defined through deeper qualitative analysis. Before including any workload in the cloud adoption plan, attempt to provide the following data points for each workload.

### Business inputs

| Data point | Description | Input |
|---|---|---|
| Workload name | What is this workload called? |         |
| Workload description| In one sentence, what does this workload do? |         |
| Adoption motivation(s) | Which of the cloud adoption motivations are impacted by this workload? |         |
| Primary sponsor | Of those stakeholders impacted, who is the primary sponsor requesting the above motivation(s)? |         |
| Business unit | Which business unit is responsible for the cost of this workload? |         |
| Business process(es)| Which business processes will be impacted by changes to the workload? |         |
| Business teams| Which business teams will be affected by changes? |         |
| Business stakeholders | Are there any executives whose business will be impacted by changes? |         |
| Business outcomes | How will the business measure the success of this effort? |         |
| Metrics | What metrics will be used to track success? |         |
| Compliance | Are there any third-party compliance requirements for this workload? |         |
| Application owner(s) | Who is accountable for the business impact of any applications associated with this workload? |         |
| Business freeze periods | Are there any timeframes during which the business will not permit change? |         |
| Geography | Are there any geographies affected by this workload? |         |

### Technical inputs

| Data point | Description | Input |
|---|---|---|
| Adoption approach | Is this a candidate for Migration or Innovation? |         |
| Application Ops lead | List the responsible parties for performance and availability of this workload. |         |
| SLAs | List any service-level agreements (RTO/RPO requirements). |         |
| Criticality | List the current application criticality. |         |
| Data classification | List the classification of data sensitivity. |         |
| Operating geography | List any geographies in which the workload is or should be hosted. |         |
| Applications | Specify an initial list or count of any applications included in this workload. |         |
| VM | Specify an initial list or count of any VM or servers included in the workload. |         |
| Data source | Specify an initial list or count of any data sources included in the workload. |         |
| Dependencies | List any asset dependencies not included in the workload. |         |
| User traffic geographies | List geographies that have a significant collection of user traffic. |         |

## Confirm priorities

Based on the aggregated data, the cloud strategy team and cloud adoption team should meet to reevaluate priorities. Clarity regarding business data points may prompt changes in priorities. Technical complexity or dependencies may result in changes related to staffing allocations, timelines, or sequencing of technical efforts.

After a review, both team should be comfortable confirming the resulting priorities. This set of documented, validated, and confirmed priorities is the prioritized cloud adoption backlog.

## Next steps

For any workload in the prioritized cloud adoption backlog, the team is now ready to [align assets](./assets.md).

> [!div class="nextstepaction"]
> [Align assets for prioritized workloads](./assets.md)

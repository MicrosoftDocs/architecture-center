---
title: "Prioritize and define workloads for a cloud adoption plan"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Prioritize and define workloads for a cloud adoption plan
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/01/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: plan
---

# Prioritize and define workloads for a cloud adoption plan

Establishing clear, actionable priorities is one of the secrets to successful cloud adoption. The natural temptation is to invest time in defining all workloads that could potentially be affected during cloud adoption. But that's counterproductive, especially early in the adoption process.

Instead, we recommend that your team focus on thoroughly prioritizing and documenting the first 10 workloads. After implementation of the adoption plan begins, the team can maintain a list of the next 10 highest-priority workloads. This approach provides enough information to plan for the next few iterations.

Limiting the plan to 10 workloads encourages agility and alignment of priorities as business criteria change. This approach also makes room for the cloud adoption team to learn and to refine estimates. Most important, it removes extensive planning as a barrier to effective business change.

## What is a workload?

In the context of a cloud adoption, a workload is a collection of IT assets (servers, VMs, applications, data, or appliances) that collectively support a defined process. Workloads can support more than one process. Workloads can also depend on other shared assets or larger platforms. However, a workload should have defined boundaries regarding the dependent assets and the processes that depend upon the workload. Often, workloads can be visualized by monitoring network traffic among IT assets.

## Prerequisites

The strategic inputs from the prerequisites checklist make the following tasks much easier to accomplish. For help with gathering the data discussed in this article, review the [prerequisites checklist](./prerequisites.md).

## Initial workload prioritization

During the process of [incremental rationalization](../digital-estate/rationalize.md), your team should agree on a "Power of 10" approach, which consists of 10 priority workloads. These workloads serve as an initial boundary for adoption planning.

If you decide that a digital estate rationalization isn't needed, we recommend that the cloud adoption teams and the cloud strategy team agree on a list of 10 applications to serve as the initial focus of the migration. We recommend further that these 10 workloads contain a mixture of simple workloads (fewer than 10 assets in a self-contained deployment) and more complex workloads. Those 10 workloads will start the workload prioritization process.

> [!NOTE]
> The Power of 10 serves as an initial boundary for planning, to focus the energy and investment in early-stage analysis. However, the act of analyzing and defining workloads is likely to cause changes in the list of priority workloads.

## Add workloads to your cloud adoption plan

In the previous article, [Cloud adoption plan and Azure DevOps](./template.md), you created a cloud adoption plan in Azure DevOps.

You can now represent the workloads in the Power of 10 list in your cloud adoption plan. The easiest way to do this is via bulk editing in Microsoft Excel. To prepare your workstation for bulk editing, see [Bulk add or modify work items with Excel](/azure/devops/boards/backlogs/office/bulk-add-modify-work-items-excel?view=azure-devops).

Step 5 in that article tells you to select **Input list**. Instead, select **Query list**. Then, from the **Select a Query** drop-down list, select the **Workload Template** query. That query loads all the efforts related to the migration of a single workload into your spreadsheet.

After the work items for the workload template are loaded, follow these steps to begin adding new workloads:

1. Copy all the items that have the **Workload Template** tag in the far right column.
2. Paste the copied rows below the last line item in the table.
3. Change the title cell for the new feature from **Workload Template** to the name of your new workload.
4. Paste the new workload name cell into the tag column for all rows below the new feature. Be careful to not change the tags or name of the rows related to the actual **Workload Template** feature. You will need those work items when you add the next workload to the cloud adoption plan.
5. Skip to Step 8 in the bulk-editing instructions to publish the worksheet. This step creates all the work items required to migrate your workload.

Repeat steps 1 through 5 for each of the workloads in the Power of 10 list.

## Define workloads

After initial priorities have been defined and workloads have been added to the plan, each of the workloads can be defined via deeper qualitative analysis. Before including any workload in the cloud adoption plan, try to provide the following data points for each workload.

### Business inputs

| Data point | Description | Input |
|---|---|---|
| Workload name | What is this workload called? |         |
| Workload description | In one sentence, what does this workload do? |         |
| Adoption motivations | Which of the cloud adoption motivations are affected by this workload? |         |
| Primary sponsor | Of those stakeholders affected, who is the primary sponsor requesting the preceding motivations? |         |
| Business unit | Which business unit is responsible for the cost of this workload? |         |
| Business processes | Which business processes will be affected by changes to the workload? |         |
| Business teams | Which business teams will be affected by changes? |         |
| Business stakeholders | Are there any executives whose business will be affected by changes? |         |
| Business outcomes | How will the business measure the success of this effort? |         |
| Metrics | What metrics will be used to track success? |         |
| Compliance | Are there any third-party compliance requirements for this workload? |         |
| Application owners | Who is accountable for the business impact of any applications associated with this workload? |         |
| Business freeze periods | Are there any times during which the business will not permit change? |         |
| Geographies | Are any geographies affected by this workload? |         |

### Technical inputs

| Data point | Description | Input |
|---|---|---|
| Adoption approach | Is this adoption a candidate for migration or innovation? |         |
| Application ops lead | List the parties responsible for performance and availability of this workload. |         |
| SLAs | List any service-level agreements (RTO/RPO requirements). |         |
| Criticality | List the current application criticality. |         |
| Data classification | List the classification of data sensitivity. |         |
| Operating geographies | List any geographies in which the workload is or should be hosted. |         |
| Applications | Specify an initial list or count of any applications included in this workload. |         |
| VMs | Specify an initial list or count of any VMs or servers included in the workload. |         |
| Data sources | Specify an initial list or count of any data sources included in the workload. |         |
| Dependencies | List any asset dependencies not included in the workload. |         |
| User traffic geographies | List geographies that have a significant collection of user traffic. |         |

## Confirm priorities

Based on the assembled data, the cloud strategy team and the cloud adoption team should meet to reevaluate priorities. Clarification of business data points might prompt changes in priorities. Technical complexity or dependencies might result in changes related to staffing allocations, timelines, or sequencing of technical efforts.

After a review, both teams should be comfortable with confirming the resulting priorities. This set of documented, validated, and confirmed priorities is the prioritized cloud adoption backlog.

## Next steps

For any workload in the prioritized cloud adoption backlog, the team is now ready to [align assets](./assets.md).

> [!div class="nextstepaction"]
> [Align assets for prioritized workloads](./assets.md)

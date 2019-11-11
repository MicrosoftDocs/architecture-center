---
title: "Deploy the cloud adoption plan to Azure DevOps"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Deploy the template for the cloud adoption plan
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/01/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: plan
---

# Cloud adoption plan and Azure DevOps

Azure DevOps is the set of cloud-based tools for Azure customers who manage iterative projects. It also includes tools for managing deployment pipelines and other important aspects of DevOps. 

In this article, you'll learn how to quickly deploy a backlog to Azure DevOps by using a cloud adoption plan template. This template aligns cloud adoption efforts to a standardized process based on the guidance in the Cloud Adoption Framework.

## Create your cloud adoption plan

To deploy the cloud adoption plan, open the [Azure DevOps Demo Generator](https://aka.ms/adopt/plan/generator). This tool will deploy the template to your Azure DevOps tenant. Using the tool requires the following steps:

1. Verify that the **Selected Template** field is set to **Cloud Adoption Plan**. If it isn't, select **Choose template** to choose the right template.
2. Select your Azure DevOps organization from the **Select Organization** drop-down list box.
3. Enter a name for your new project. The cloud adoption plan will have this name when it's deployed to your Azure DevOps tenant.
4. Select **Create Project** to create a new project in your tenant, based on the plan template. A progress bar show your progress towards deploying the project.
5. When deployment is finished, select **Navigate to project** to see your new project.

After your project has been created, continue through this article series to see how you can modify the template to align to your cloud adoption plan.

For additional support and guidance on this tool, see [Azure DevOps Services Demo Generator](https://docs.microsoft.com/azure/devops/demo-gen/?toc=%2Fazure%2Fdevops%2Fdemo-gen%2Ftoc.json&bc=%2Fazure%2Fdevops%2Fdemo-gen%2Fbreadcrumb%2Ftoc.json&view=azure-devops).

## Bulk edit the cloud adoption plan

When the plan project has been deployed, you can use Microsoft Excel to modify it. It's much easier to create new workloads or assets in the plan by using Excel than by using the Azure DevOps browser experience.

To prepare your workstation for bulk editing, see [Bulk add or modify work items with Excel](https://docs.microsoft.com/azure/devops/boards/backlogs/office/bulk-add-modify-work-items-excel?view=azure-devops).

## Use the cloud adoption plan

The cloud adoption plan organizes activities by activity type:

- **Epics**: An *epic* represents an overall phase of the cloud adoption lifecycle.
- **Features**: Features are used to organize specific objectives within each phase. For instance, migration of a specific workload would be one feature.
- **User stories**: User stories group work into logical collections of activities based on a specific goal.
- **Tasks**: Tasks are the actual work to be done.

At each layer, activities are then sequenced based on dependencies. Activities are linked to articles in the Cloud Adoption Framework to clarify the objective or task at hand.

The clearest view of the cloud adoption plan comes from the **Epics** backlog view. For help with changing to the **Epics** backlog view, see the article on [viewing a backlog](https://docs.microsoft.com/azure/devops/boards/backlogs/define-features-epics?view=azure-devops#view-a-backlog-or-portfolio-backlog). From this view, it's easy to plan and manage the work required to complete the current phase of the adoption lifecycle.

> [!NOTE]
> The current state of the cloud adoption plan focuses heavily on migration efforts. Tasks related to governance, innovation, or operations must be populated manually.

## Align the cloud adoption plan

The overview pages for the strategy and planning phases of the cloud adoption lifecycle each reference the [Cloud Adoption Framework strategy and planning template](https://archcenter.blob.core.windows.net/cdn/fusion/readiness/Microsoft-Cloud-Adoption-Framework-Strategy-and-Plan-Template.docx). That template organizes the decisions and data points that will align the template for the cloud adoption plan with your specific plans for adoption. If you haven't done so already, you might want to complete the exercises related to [strategy](../business-strategy/index.md) and [planning](../plan/index.md) before aligning your new project.

The following articles support alignment of the cloud adoption plan:

- [Workloads](./workloads.md): Align features within the Cloud Migration epic to capture each workload to be migrated or modernized. Add and modify those features to capture the effort to migrate your top 10 workloads.
- [Assets](./assets.md): Each asset (VM, application, or data) is represented by the user stories under each workload. Add and modify those user stories to align with your digital estate.
- [Rationalization](./review-rationalization.md): As each workload is defined, the initial assumptions about that workload can be challenged. This might result in changes to the tasks under each asset.
- [Create release plans](./iteration-paths.md): Iteration paths establish release plans by aligning efforts with various releases and iterations.
- [Establish timelines](./timelines.md): Defining start and end dates for each iteration creates a timeline to manage the overall project.

These five articles help with each of the alignment tasks required to start managing your adoption efforts. The next step gets you started on the alignment exercise.

## Next steps

Start aligning your plan project by [defining and prioritizing workloads](./workloads.md).

> [!div class="nextstepaction"]
> [Define and prioritize workloads](./workloads.md)

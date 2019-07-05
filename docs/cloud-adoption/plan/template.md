---
title: "Deploy the cloud adoption plan to Azure DevOps"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Deploy the cloud adoption plan template
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/01/2019
ms.topic: guide
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Cloud adoption plan and Azure DevOps

Azure DevOps is the cloud-native tool for Azure customers managing iterative projects. It also includes tools for managing deployment pipelines and other important aspects of DevOps. In this article, we will teach you how to quickly deploy a backlog to Azure DevOps from the Cloud Adoption Framework's cloud adoption plan template. This template aligns cloud adoption efforts to a standardized process based on the guidance in the framework.

## Create your cloud adoption plan

To deploy the cloud adoption plan, open the [Azure DevOps Demo Generator](https://aka.ms/adopt/plan/generator). This tool will deploy the template to your Azure DevOps Tenant. Using the tool requires the following steps:

1. Verify that the "Selected Template" field is set to "Cloud Adoption Plan". If it is not, click the "Choose template" button to choose the right template.
2. Choose your Azure DevOps organization from the "Select Organization" dropdown box.
3. Enter a name for your new project. This is what the cloud adoption plan will be called when it is deployed to your Azure DevOps tenant.
4. Click "Create Project" to create a new project in your tenant, based on the Cloud Adoption Plan template.
5. The progress bar will show your progress towards deploying this project. When finished, you will be able to click the "Navigate to project" button to see your new project.

Once your project is created, continue through this article series to see how you can modify this template to align to your adoption plan.

For additional support and guidance on this tool, see the guidance regarding the [Azure DevOps Services Demo Generator](https://docs.microsoft.com/azure/devops/demo-gen/?toc=%2Fazure%2Fdevops%2Fdemo-gen%2Ftoc.json&bc=%2Fazure%2Fdevops%2Fdemo-gen%2Fbreadcrumb%2Ftoc.json&view=azure-devops)

## Bulk editing the cloud adoption plan

Once the cloud adoption plan project has been deployed, you can use Excel to more easily modify the project plan.
Creating new workloads or assets in the plan is much easier to do through Excel, as compared to the Azure DevOps browser experience.
Follow this article on [bulk add or modify (Excel)](https://docs.microsoft.com/azure/devops/boards/backlogs/office/bulk-add-modify-work-items-excel?view=azure-devops) to prepare your workstation for bulk editing.

## Using the cloud adoption plan

The cloud adoption plan organizes activities by activity type as follows:

- Epics: Epics represent the overall phase of the cloud adoption lifecycle.
- Features: Features are used to organize specific objectives within each phase. For instance, migration of a specific workload would be one epic.
- User Stories: User stories group work into logic collections of activities based on a specific goal.
- Tasks: Tasks are the actual work to be performed.

At each layer, activities are then sequenced based on dependencies and linked to articles in the Cloud Adoption Framework to provide clarity on the objective and/or the task at hand.

The clearest view of the cloud adoption plan comes from the Epic backlog view. For assistance changing to the Epic backlog view, see the article on [accessing the Epic backlog](https://docs.microsoft.com/azure/devops/boards/backlogs/define-features-epics?view=azure-devops#view-a-backlog-or-portfolio-backlog). From this view, it is easy to plan and manage the work required to complete the current phase of the adoption lifecycle.

> [!NOTE]
> The current state of the cloud adoption plan focuses heavily on migration efforts. Tasks related to governance, innovation, or operations would need to be manually populated.

## Aligning the cloud adoption plan

The overview pages for the strategy and planning phases of the cloud adoption lifecycle each reference the [Cloud Adoption Framework strategy and planning template](https://archcenter.blob.core.windows.net/cdn/fusion/readiness/Microsoft-Cloud-Adoption-Framework-Strategy-and-Plan-Template.docx). That template organizes the decisions and data points that will create alignment between the cloud adoption plan template and your specific plans for adoption. If you haven't done so already, you may want to complete the exercises related to [strategy](../business-strategy/index.md) and [planning](../plan/index.md) before aligning your new project.

Alignment of the cloud adoption plan is supported through the following articles:

- [Workloads](./workloads.md): Align features within the "Cloud Migration" epic to capture each workload to be migrated or modernized. Add & modify those features to capture the effort to migrate your top 10 workloads.
- [Assets](./assets.md): Each asset (VM, Application, or Data) is represented by the user stories under each workload. Add & modify those user stories to align with your digital estate.
- [Rationalization](./review-rationalization.md): As each workload is defined, the initial assumptions about that workload can be challenged. This may result in changes to the tasks under each asset.
- [Create release plans](./iteration-paths.md): Iteration paths establish release plans by grouping effort to various releases and iterations.
- [Establish timelines](./timelines.md): Defining start and end dates for each iteration will create a timeline to manage the overall project.

The above five articles will help with each of the alignment tasks required to start managing your adoption efforts using this adoption plan. The next step below will get you started on this exercise.

## Next steps

Start aligning your cloud adoption plan project by [defining and prioritizing workloads](./workloads.md).

> [!div class="nextstepaction"]
> [Define and prioritize workloads](./workloads.md)

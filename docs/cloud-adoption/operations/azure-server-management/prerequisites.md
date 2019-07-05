---
title: "Prerequisite planning for Azure server management services"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Prerequisite tools and planning for Azure server management services.
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/10/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Phase 1: Prerequisite planning for Azure server management services

In this phase, you'll become familiar with the Azure server management suite of services, and plan how to deploy the resources needed to implement these management solutions.

## Understand the tools and services

Review [Azure server management tools and services](./tools-services.md) for a detailed overview of the management areas involved in ongoing Azure operations, and the Azure services and tools that help support you in these areas. Meeting your management requirements will involve using several of these services together. These tools are referenced often throughout this guidance.

The sections below discuss the planning and preparation required to use these tools.

## Log Analytics workspace and Automation account planning

Many of the services you will use to onboard Azure management services require a Log Analytics workspace and a linked Azure Automation account.

A [Log Analytics workspace](/azure/azure-monitor/learn/quick-create-workspace) is a unique environment for storing Azure Monitor log data. Each workspace has its own data repository and configuration, and data sources and solutions are configured to store their data in a particular workspace. Azure monitoring solutions require all servers to be connected to a workspace, so that their log data can be stored and accessed.

Some of the management services require an [Azure Automation account](/azure/automation/automation-intro) account. Using this account and Azure Automation's capabilities, you can integrate Azure services and other public systems to deploy, configure, and manage your server management processes.

The following Azure server management services require a linked Log Analytics workspace and Automation account to function:

- [Azure Update Management](/azure/automation/automation-update-management)
- [Change Tracking and Inventory](/azure/automation/change-tracking)
- [Hybrid Runbook Worker](/azure/automation/automation-hybrid-runbook-worker)
- [Desired State Configuration](/azure/virtual-machines/extensions/dsc-overview)

The second phase of this guidance focuses on deploying services and automation scripts. The examples covered in this guidance assume a greenfield deployment that does not already have servers deployed to the cloud. It will show you how to create a Log Analytics workspace and Automation account and use Azure Policy to ensure new VMs will be connected to the right workspace. To learn more about the principles and considerations involved in planning your workspaces, see [Manage log data and workspaces in Azure Monitor](/azure/azure-monitor/platform/manage-access#determine-the-number-of-workspaces-you-need).

## Planning considerations

Consult the issues discussed below when preparing the workspaces and accounts you create for onboarding management services.

- **Azure geographies and regulatory compliance**. Azure regions are organized into geographies. An [Azure geography](https://azure.microsoft.com/global-infrastructure/geographies/) ensures that data residency, sovereignty, compliance, and resiliency requirements are honored within geographical boundaries. If your workloads are subject to data sovereignty or other compliance requirements, workspace and Automation accounts must be deployed to regions within the same Azure geography as the workload resources they support.
- **Number of workspaces**. As a guiding principle, create the minimum number of workspaces required per Azure geography. We recommend at least one workspace for each Azure geography where your compute or storage resources are located. This initial alignment helps avoid future regulatory issues when migrating data to different geographies.
- **Data retention and capping**. You may also need to take Data retention policies or data capping requirements into consideration when creating workspaces or Automation accounts. For more information about these principles and additional considerations when planning your workspaces, see [Manage log data and workspaces in Azure Monitor](/azure/azure-monitor/platform/manage-access#determine-the-number-of-workspaces-you-need).
- **Region mapping**. Linking a Log Analytics workspace and an Azure Automation account is only supported between certain Azure regions. For example, if the Log Analytics workspace is hosted in the *EastUS* region, the linked Automation account must be created in the *EastUS2* region in order to be used with management services. If you have an Automation account created in other regions, it will not be able to link to a workspace in *EastUS*.  Choice of deployment region can significantly affect Azure geography requirements. Consult the [region mapping table](/azure/automation/how-to/region-mappings) to decide which region should host your workspaces and Automation accounts.
- **Workspace multihoming**. Log Analytics Agent supports multihoming in some scenarios, but the agent faces several limitations and issues when running in this configuration. Unless Microsoft has specifically recommended using multihoming for your scenario, we don’t recommend configuring multihoming on the Log Analytics agent.

## Resource placement examples

In terms of which subscription to place the Log Analytics workspace and Automation account, there are several different models. In short, you should place the workspace and Automation accounts in a subscription owned by the team responsible for implementing the Update Management and Change Tracking and Inventory services.

The following examples illustrate some ways workspaces and Automation accounts can be deployed.

### Placement by geography

For small-to-medium environments with a single subscription and several hundred resources spanning multiple Azure geographies, create one Log Analytics workspace and one Azure Automation account in each geography. This example has one subscription with two resource groups, each located in a different geography. You can create one workspace and Azure Automation account pair in each resource group and deploy it in the corresponding geography to the virtual machines. Alternatively, if your data compliance policies do not dictate that resources reside in specific regions, you can create one pair to manage all the virtual machines. It is also recommended that you place the workspace and Automation account pairs in separate resource groups to provide more granular RBAC control.

![Workspace model for small-to-medium environments](./media/workspace-model-small.png)

### Placement in a management subscription

For larger environments that span multiple subscriptions and have a central IT department that owns monitoring and compliance, create workspace and Automation account pairs in an IT management subscription. In this model, virtual machine resources in a geography will store their data in the corresponding geography workspace in the IT management subscription. Application teams who need to run automation tasks but don't require workspace and Automation account linking can create separate Automation account in their own application subscriptions.

![Workspace model for large environments](./media/workspace-model-large.png)

### Decentralized placement

In an alternative model for large environments, responsibility for patching and management can lie with the Application team. In this case, you should place the workspace and Automation accounts pairs in the application team subscriptions alongside their other resources.

  ![Workspace account model for decentralized environments](./media/workspace-model-decentralized.png)

## Create a workspace and Automation account

After you've decided how best to place and organize workspace and account pairs, you'll need to ensure you have created these resources before starting the onboarding process. The automation examples included later in this guidance will create a workspace and Automation account pair for you. However, if you do not have an existing workspace and Automation account pair, you will need to create one if you want to onboard using the portal.

To create a Log Analytics workspace through the Azure portal, see [Create a workspace](/azure/azure-monitor/learn/quick-create-workspace#create-a-workspace). Next, create a matching Automation account for each workspace by following the steps in [Create an Azure Automation account](/azure/automation/automation-quickstart-create-account).

> [!NOTE]
> When creating an Automation account through the Azure portal, the default behavior attempts to create Run As accounts for both Resource Manager and the classic deployment model resources. However, if you don't have classic VMs in your environment and you are not the co-administrator on the subscription, the portal will create a Resource Manager Run As account, but will generate an error when deploying the classic Run As account. If you don't intend to support classic resources this error can be ignored.
>
> You can also create Run As accounts using [PowerShell](/azure/automation/manage-runas-account#create-run-as-account-using-powershell).

## Next steps

Learn how to [onboard your servers](./onboarding-overview.md) to Azure management services.

> [!div class="nextstepaction"]
> [Onboard to Azure server management services](./onboarding-overview.md)

---
title: "Onboard to Azure server management services"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Onboard to Azure server management services
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/10/2019
ms.topic: article
ms.service: cloud-adoption-framework
ms.subservice: operate
---

# Phase 2: Onboarding Azure server management services

When you are familiar with the [tools](./tools-services.md) and [planning](./prerequisites.md) involved in Azure management services, you're ready for the second phase, which provides step-by-step guidance for onboarding these services for use with your Azure resources. Start by evaluating this onboarding process before adopting it broadly in your environment.

> [!NOTE]
> The automation approaches discussed in later sections of this guidance are targeted at deployments that do not already have servers deployed to the cloud. They require that you have the Owner role on a subscription to create all the required resources and policies. If you already have Log Analytics workspace and Automation account resources created, we recommend that you pass these resources in the appropriate parameters when launching the example automation scripts.

## Onboarding processes

This section of the guidance covers the following onboarding processes for both Azure virtual machines and on-premises servers:

- **Enable management services on a single VM for evaluation by using the portal**. Use this process to familiarize yourself with the Azure server management services.
- **Configure management services for a subscription by using the portal**. This process helps you configure the Azure environment so that any new VMs that are provisioned will automatically use management services. Use this approach if you prefer the Azure portal experience to scripts and command lines.
- **Configure management services for a subscription by using Azure Automation**. This process is fully automated. You only need to create a subscription, and the scripts will configure the environment to use management services for any newly provisioned VM. Use this approach if you are familiar with PowerShell scripts and Azure Resource Manager templates, or if want to learn to use them.

The procedures for each of these approaches are different.

> [!NOTE]
> The sequence of onboarding steps when using the Azure portal differs from the automated onboarding steps, because the portal offers a simpler onboarding experience.

The following diagram shows the recommended deployment model for management services. 

![Diagram of the recommended deployment model](./media/recommended-deployment.png)

> [!NOTE]
> As shown in the preceding diagram, the Log Analytics agent has both an *auto-enroll* and *opt-in* configuration for on-premises servers. *Auto-enroll* means that when Log analytics agent is installed on a server and configured to connect to a workspace, the solutions enabled on that workspace will be automatically apply to the server. *Opt-in* means that even if the agent is installed and connected to the workspace, the solution will not be applied unless it's added to the server's scope configuration in the workspace.

## Next steps

Learn how to onboard a single VM by using the portal to evaluate the onboarding process.

> [!div class="nextstepaction"]
> [Onboard a single Azure VM for evaluation](./onboard-single-vm.md)

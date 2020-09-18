---
title: Automated Tasks
description: Automated Tasks
author: neilpeterson
ms.date: 09/02/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Automated Tasks

## Azure Functions 

Azure Functions allow you to run code without having to manage the underlying infrastructure on where the code is run. Azure functions provide a cost-effective, scalable, and event-driven platform for building applications and running operational tasks. Azure functions support running code written in C#, Java, JavaScript, Python, and PowerShell.

< add content on architectural aspects>

< add content around how functions facilitate operational tasks >

< add example screenshot and code >

**Learn more**

- [Docs: Azure Functions PowerShell developer guide](https://docs.microsoft.com/azure/azure-functions/functions-reference-powershell)
- [Code Sample: Function ARM template (PowerShell)](https://docs.microsoft.com/samples/browse/?terms=arm%20templates)
- [Code Sample: Function ARM template (Python)](https://docs.microsoft.com/samples/browse/?terms=arm%20templates)

## Azure Automation

PowerShell and Python are popular programming languages for automating operational tasks. Using these languages, performing operations like restarting services, moving logs between data stores, and scaling infrastructure to meet demand can be expressed in code and executed on demand. Alone, these languages do not offer a platform for centralized management, version control, or execution history. The languages also lack a native mechanism for responding to events like monitoring driven alerts. To provide these capibilities, an automation platform is needed.

Azure Automation provides an Azure-hosted platform for hosting and running PowerShell and Python code across Azure, non-Azure cloud, and on-premises environments. PowerShell and Python code is stored in an Azure Automation Runbook, which has the following attributes:

- Execute runbooks on demand, on a schedule, or through a webhook
- Execution history and logging
- Integrated secrets store
- Source Control integration

As seen in the following image, Azure Automation provides a portal experience for managing Azure Automation Runbooks. Use the included code sample (ARM template) to deploy an Azure automation account, automation runbook, and explore Azure Automation for yourself.

![](./images/azure-automation-powershell.png)

**Learn more**

- [Docs: What is Azure Automation](https://docs.microsoft.com/azure/automation/automation-intro)
- [Code Sample: Azure Automation example](https://docs.microsoft.com/samples/browse/?terms=arm%20templates)

## Logic apps

#### Next steps
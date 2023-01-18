---
title: #AzureSandbox
description: "Accelerate your Azure project with a fully functional sandbox environment."
author: doherty100
ms.author: rdoherty
ms.date: 01/10/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-bastion
  - azure-virtual-machines
  - azure-sql-virtual-machines
  - azure-sql-database
  - azure-database-mysql
categories:
  - popular
  - compute
  - databases
  - networking
  - storage
  - developer-tools
---

# #AzureSandbox

\#AzureSandbox is a collection of inter-dependent [cloud computing](https://azure.microsoft.com/overview/what-is-cloud-computing) configurations for implementing common [Microsoft Azure](https://azure.microsoft.com/overview/what-is-azure/) services on a single [subscription](https://learn.microsoft.com/azure/azure-glossary-cloud-terminology#subscription). Collectively these configurations provide a flexible and cost effective sandbox environment useful for experimenting with various Azure services and capabilities. Depending upon your Azure offer type and region, a fully provisioned #AzureSandbox environment costs approximately $50 USD / day. These costs can be further reduced by stopping / deallocating virtual machines when not in use, or by skipping optional configurations that you do not plan to use.
  
## Architecture

![diagram](./azuresandbox.drawio.svg)

## Workflow

- Connect to Windows Jumpbox VM from the Internet
  - Option 1: Internet facing access using a Web browser and Azure Bastion
  - Option 2: Point-to-site VPN connectivity via Azure Virtual WAN
- Leverage a pre-configured file share via Azure Files
- Use Windows Jumpbox VM as a developer workstation
  - Visual Studio Code pre-installed with Remote-SSH into a Linux Jumpbox
  - Azure Storage Explorer, AzCopy and Azure Data Studio pre-installed
  - SQL Server Management Studio pre-installed
  - MySQL Workbench pre-installed
- Leverage a pre-configured SQL Server Virtual Machine
- Leverage a pre-configured Azure SQL Database
- Leverage a pre-configured Azure MySQL Flexible Server  

## Prerequisites

Get your [prerequisites](https://github.com/Azure-Samples/azuresandbox#prerequisites) in place, including:

- Identify an Azure Active Directory tenant
- Identify an Azure subscription
- Create Azure RBAC role assignments
- Create a service principal
- Configure your client environment

## Components

[Deploy](https://github.com/Azure-Samples/azuresandbox#perform-default-sandbox-deployment) #AzureSandbox. You can deploy all the #AzureSandbox configurations, or just the ones you need, including:

- Shared services virtual network, bastion and Active Directory domain controller
- Application virtual network, Windows Server jumpbox, Linux jumpbox and Azure Files file share
- SQL Server virtual machine
- Azure SQL Database
- Azure Database for MySQL Flexible Server
- Azure Virtual WAN and point-to-site VPN

## Use cases

\#AzureSandbox is ideal for accelerating Azure projects. After your sandbox environment is deployed, you can add your own services and capabilities and use it in a variety of ways, including:

- Self-learning
- Hackathons
- Testing
- Development

## Disclaimer

\#AzureSandbox is not intended for production use. While some best practices are used, others are intentionally not used in favor of simplicity and cost.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Roger Doherty](https://www.linkedin.com/in/roger-doherty-805635b/) | Cloud Solution Architect

## Next steps

Navigate to the [#AzureSandbox GitHub Repository](https://github.com/Azure-Samples/azuresandbox) and begin with [Getting started](https://github.com/Azure-Samples/azuresandbox#getting-started).

## Related resources

- [Known Issues](https://github.com/Azure-Samples/azuresandbox#known-issues)
- [Microsoft Cloud Adoption Framework for Azure](https://learn.microsoft.com/azure/cloud-adoption-framework/)
- [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/azure/architecture/framework/)

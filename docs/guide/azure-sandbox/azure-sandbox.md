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

\#AzureSandbox is a collection of inter-dependent [cloud computing](https://azure.microsoft.com/en-us/overview/what-is-cloud-computing) configurations for implementing common [Microsoft Azure](https://azure.microsoft.com/en-us/overview/what-is-azure/) services on a single [subscription](https://docs.microsoft.com/en-us/azure/azure-glossary-cloud-terminology#subscription). Collectively these configurations provide a flexible and cost effective sandbox environment useful for experimenting with various Azure services and capabilities. Depending upon your Azure offer type and region, a fully provisioned #AzureSandbox environment costs approximately $50 USD / day. These costs can be further reduced by stopping / deallocating virtual machines when not in use, or by skipping optional configurations that you do not plan to use.
  
## Architecture

![diagram](./azuresandbox.drawio.svg)

## Prerequisites

Get your [prerequisites](https://github.com/doherty100/azuresandbox#prerequisites) in place, including:

- Identify an Azure Active Directory tenant
- Identify an Azure subscription
- Create Azure RBAC role assignments
- Create a service principal
- Configure your client environment

## Workflow

[Deploy](https://github.com/doherty100/azuresandbox#perform-default-sandbox-deployment) #AzureSandbox. You can deploy all the #AzureSandbox configurations, or just the ones you need, including:

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

Navigate to the [#AzureSandbox GitHub Repository](https://github.com/doherty100/azuresandbox) and begin with [Getting started](https://github.com/doherty100/azuresandbox#getting-started).

## Related resources

- [Known Issues](https://github.com/doherty100/azuresandbox#known-issues)
- [Microsoft Cloud Adoption Framework for Azure](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/)
- [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/architecture/framework/)

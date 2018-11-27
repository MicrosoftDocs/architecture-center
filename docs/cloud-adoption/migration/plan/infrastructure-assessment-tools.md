---
title: "Fusion: What tools can help assess on-prem infrastructure?"
description: Descriptions of commonly used tools for assessing on-prem infrastructure
author: BrianBlanchard
ms.date: 10/11/2018
---

# Fusion: What tools can help assess on-prem infrastructure?

The [Migration section](overview.md) of the [Fusion framework](../../overview.md), outlines the processes typically required to migrate a DataCenter to the cloud. This section of the framework, expands on the [Planning Process](overview.md) within migration, in particular this article will discuss tools that can be used to assess the infrastructure within an on-prem datacenter.

Assessing infrastructure for large, complex environments especially those in excess of 1,000 VMs may benefit from a broader focus. Fusion refers to the planning process for high-scale DataCenters as [Digital Estate planning](../../business-strategy/digital-estate.md). The [business strategy](../../business-strategy/overview.md) surrounding digital estate planning could be a better starting point for organizations with thousands of VMs, hundreds of applications, or petabytes of data.

## Inventory and Assessment tools

Planning for any technical change often starts with a good understanding of the current state. Cloud Transformations are no exception. One of the most common means of defining and quantifying current state, is through an inventory of Servers/VMs, Applications, Databases, and dependencies. This article outlines the most commonly used tool options provided by Microsoft.

For a full list of inventory and assessment tools from **Microsoft tools partners**, see the [Migration Center: Migration Partner Tools](https://azure.microsoft.com/en-us/migration/partners/).

## Microsoft-provided discovery and assessment tools

### Azure Migrate

The Azure Migrate service assesses on-premises machines for migration to Azure. It assesses the migration suitability of the machines and provides sizing recommendations for Azure VMs based on the performance history of on-premises VMs. It also provides estimated costs for running on-premises machines in Azure. Visualize dependencies of on-premises machines to create groups of machines to be assessed and/or migrated together. Additional features:

* Discover information about VMware virtual machines, including CPU and memory utilization, disk details, and networks.
* Group machines for migration assessment with higher confidence by setting up dependency visualization to view dependencies of a single VM or a group of VMs.
* Get advice on right-sizing cloud resources to proceed with confidence and better control migration costs based on efficient utilization.
* If Azure Migrate identifies specific VMs as problematic, follow step-by-step guidance for overcoming obstacles to help keep the migration on track.
* After running a cloud assessment with Azure Migrate, begin migrating on-premises VMs to Azure using services including Azure Site Recovery and Database Migration Service. 

Learn more about [Azure Migrate](https://azure.microsoft.com/en-in/services/azure-migrate/).

### Service Map

Service Map, part of Azure Log Analytics, is used by Azure Migrate to show dependencies between machines. Service Map automatically builds a common reference map of dependencies across servers, processes, and third-party services. Service Map discovers failed network connections that managed systems are attempting to make, helping identify potential server misconfiguration, service outage, and network issues. Service Map can currently be used for 180 days without incurring charges.

The output of the inventory discovery and assessment is typically a list of the items discovered, ranked according to business impact and value, with business-critical resources at the top and lower-value legacy workloads at the bottom. Tiering findings prioritizes migration operations. A thorough understanding of the applications to be migrating, their underlying architectural dependencies and business requirements, and the post-migration benefits that stakeholders expect can be extracted from the Service Map outputs.

### Microsoft Assessment and Planning (MAP) Toolkit

MAP is an agentless, automated, multi-product planning and assessment tool for quicker and easier desktop, server, and cloud migrations. MAP provides detailed readiness assessment reports and executive proposals with extensive hardware and software information, as well as actionable recommendations to help organizations accelerate their IT infrastructure planning process and gather more detail on assets that reside within their current environment. MAP also provides server utilization data for Hyper-V server virtualization planning, identifying server placements, and performing virtualization candidate assessments. It collects and organizes system resources and device information from a single networked computer. Assessment tools often require users to first deploy software agents on all computers to be inventoried, but this tool does not. MAP uses technologies already available in your IT environment to perform inventory and assessments.
The [Microsoft Assessment and Planning Toolkit](http://go.microsoft.com/fwlink/?LinkId=313396) can be downloaded [here](http://go.microsoft.com/fwlink/?LinkId=313396).

### Microsoft Data Migration Assistant (DMA)

DMA assesses and detects compatibility issues that can impact database functionality in Azure. It also assesses feature parity between your SQL Server source and target, and recommends performance and reliability improvements for your target environment. Additionally, it discovers new features in the target SQL Server platform that the database can benefit from after an upgrade. These are described as feature recommendations and organized in categories such as performance, security, and storage. DMA doesn’t only provide assessment for database migration from SQL Server to Azure SQL Server database, but also provides assessment for SQL Server to Azure SQL Database Managed Instance and Oracle to Azure SQL Database.

[Download the Data Migration Assistant](https://datamigration.microsoft.com/)

> [!NOTE]
> Technical Debt: This article will be expanded upon integration of content from [Azure Migration Center](https://azure.microsoft.com/en-in/migration/), [Azure Migration Guide for Windows Servers](https://azure.microsoft.com/mediahandler/files/resourcefiles/azure-migration-guide-for-windows-server/Azure_Migration_Guide_for_Windows_Server.pdf), [Azure Migration Scenarios](https://docs.microsoft.com/en-us/azure/migrate/migrate-scenarios-assessment), and [Database Migration Guide](https://datamigration.microsoft.com/) over the coming months. Until then, each of these models provides useful guidance for assessing inventory.
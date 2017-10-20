---
title: Choosing an OLAP data store
description: 
author: zoinerTejada
ms:date: 02/12/2018
---

# Choosing an online analytical processing (OLAP) data store

Online analytical processing (OLAP) is a technology that organizes large business databases and supports complex analysis. This topic compares the options for OLAP solutions in Azure.

> [!NOTE]
> For more information about when to use an OLAP data store, see [Online analytical processing](../scenarios/online-analytical-processing.md).

## What are your options when choosing an OLAP data store?
In Azure, all of the following data stores will meet the core requirements for OLAP:

- [SQL Server with Columnstore indexes](/sql/relational-databases/indexes/get-started-with-columnstore-for-real-time-operational-analytics)
- [Azure Analysis Services](/azure/analysis-services/analysis-services-overview)
- [SQL Server Analysis Services (SSAS)](/sql/analysis-services/analysis-services)

SQL Server Analysis Services (SSAS) offers OLAP and data mining functionality for business intelligence applications. You can either install SSAS on local servers, or host within a virtual machine in Azure. Azure Analysis Services is a fully managed service that provides the same major features as SSAS. Azure Analysis Services supports connecting to [various data sources](/azure/analysis-services/analysis-services-datasource) in the cloud and on-premises in your organization.

Clustered Columnstore indexes are available in SQL Server 2014 and above, as well as Azure SQL Database, and are ideal for OLAP workloads. However, beginning with SQL Server 2016 (including Azure SQL Database), you can take advantage of hybrid transactional/analytics processing (HTAP) through the use of updateable nonclustered columnstore indexes. HTAP enables you to perform OLTP and OLAP processing on the same platform, which removes the need to store multiple copies of your data, and eliminates the need for distinct OLTP and OLAP systems. For more information, see [Get started with Columnstore for real-time operational analytics](/sql/relational-databases/indexes/get-started-with-columnstore-for-real-time-operational-analytics).

## Key selection criteria

For OLAP scenarios, choose the appropriate system for your needs by answering these questions:

- Do you want a managed service rather than managing your own servers?

- Do you require secure authentication using Azure Active Directory (Azure AD)?

- Do you want to conduct real-time analytics? If so, narrow your options to those that support real-time analytics. 

    *Real-time analytics* in this context applies to a single data source, such as an enterprise resource planning (ERP) application, that will run both an operational and an analytics workload. If you need to integrate data from multiple sources, or require extreme analytics performance by using pre-aggregated data such as cubes, you might still require a separate data warehouse.

- Do you need to use pre-aggregated data, for example to provide semantic models that make analytics more business user friendly? If yes, choose an option that supports multidimensional cubes or tabular semantic models. 

    Providing aggregates can help users consistently calculate data aggregates. Pre-aggregated data can also provide a large performance boost when dealing with several columns across many rows. Data can be pre-aggregated in multidimensional cubes or tabular semantic models.

- Do you need to integrate data from several sources, beyond your OLTP data store? If so, consider options that easily integrate multiple data sources.

## Capability matrix

The following tables summarize the key differences in capabilities.

### General capabilities

| | Azure Analysis Services | SQL Server Analysis Services | SQL Server with Columnstore Indexes | Azure SQL Database with Columnstore Indexes |
| --- | --- | --- | --- | --- |
| Is managed service | Yes | No | No | Yes |
| Supports multidimensional cubes | No | Yes | No | No |
| Supports tabular semantic models | Yes | Yes | No | No |
| Easily integrate multiple data sources | Yes | Yes | No <sup>1</sup> | No <sup>1</sup> |
| Supports real-time analytics | No | No | Yes | Yes |
| Requires process to copy data from source(s) | Yes | Yes | No | No |
| Azure AD integration | Yes | No | No <sup>2</sup> | Yes |

[1] Although SQL Server and Azure SQL Database cannot be used to query from and integrate multiple external data sources, you can still build a pipeline that does this for you using [SSIS](/sql/integration-services/sql-server-integration-services) or [Azure Data Factory](/azure/data-factory/). SQL Server hosted in an Azure VM has additional options, such as linked servers and [PolyBase](/sql/relational-databases/polybase/polybase-guide). For more information, see [Pipeline orchestration, control flow, and data movement](../technology-choices/pipeline-orchestration-data-movement.md).

[2] Connecting to SQL Server running on an Azure Virtual Machine is not supported using an Azure AD account. Use a domain Active Directory account instead.

### Scalability Capabilities

| | Azure Analysis Services | SQL Server Analysis Services | SQL Server with Columnstore Indexes | Azure SQL Database with Columnstore Indexes |
| --- | --- | --- | --- | --- |
| Redundant regional servers for high availability  | Yes | No | Yes | Yes |
| Supports query scale out  | Yes | No | Yes | No |
| Dynamic scalability (scale up)  | Yes | No | Yes | No |


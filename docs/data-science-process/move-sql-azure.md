---
title: Move data to Azure SQL Database
description: Move data from flat files (CSV or TSV formats) or from data stored in a SQL Server to an Azure SQL Database.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.date: 03/02/2022
ms.author: tdsp
ms.custom:
  - previous-author=deguhath
  - previous-ms.author=deguhath
products:
  - azure-machine-learning
  - azure-open-datasets
categories:
  - ai-machine-learning
---
# Move data to Azure SQL Database for Azure Machine Learning

This article outlines the options for moving data either from flat files (CSV or TSV formats) or from data stored in SQL Server to an Azure SQL Database. These tasks for moving data to the cloud are part of the Team Data Science Process.

For a topic that outlines the options for migrating data from SQL Server into Azure SQL options, see [Migrate to Azure SQL](/azure/azure-sql/migration-guides).

The following table summarizes the options for moving data to an Azure SQL Database.

| <b>SOURCE</b> | <b>DESTINATION: Azure SQL</b> |
| --- | --- |
| <b>Flat file (CSV or TSV formatted)</b> |[Bulk Insert SQL Query](#bulk-insert-sql-query) |
| <b>On-premises SQL Server</b> |1.[Export to Flat File](#export-flat-file)<br> 2. [SQL Server Migration Assistant (SSMA)](#ssma)<br> 3. [Database back up and restore](#db-migration)<br> 4. [Azure Data Factory](#adf) |

## <a name="prereqs"></a>Prerequisites
The procedures outlined here require that you have:

* An **Azure subscription**. If you do not have a subscription, you can sign up for a [free trial](https://azure.microsoft.com/pricing/free-trial/).
* An **Azure storage account**. You use an Azure storage account for storing the data in this tutorial. If you don't have an Azure storage account, see the [Create a storage account](/azure/storage/common/storage-account-create) article. After you have created the storage account, you need to obtain the account key used to access the storage. See [Manage storage account access keys](/azure/storage/common/storage-account-keys-manage).
* Access to an **Azure SQL Database**. If you must set up an Azure SQL Database, [Getting Started with Microsoft Azure SQL Database](/azure/azure-sql/database/single-database-create-quickstart) provides information on how to provision a new instance of an Azure SQL Database.
* Installed and configured **Azure PowerShell** locally. For instructions, see [How to install and configure Azure PowerShell](/powershell/azure/).

**Data**: The migration processes are demonstrated using the [NYC Taxi dataset](https://chriswhong.com/open-data/foil_nyc_taxi/). The NYC Taxi dataset contains information on trip data and fares, which is either available through [Azure Open Datasets](/azure/open-datasets/dataset-taxi-yellow?tabs=azureml-opendatasets) or from the source [TLC Trip Record Data](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page). A sample and description of these files are provided in [NYC Taxi Trips Dataset Description](/azure/architecture/data-science-process/overview#dataset).

You can either adapt the procedures described here to a set of your own data or follow the steps as described by using the NYC Taxi dataset. To upload the NYC Taxi dataset into your SQL Server database, follow the procedure outlined in [Bulk Import Data into SQL Server Database](/azure/architecture/data-science-process/overview#dbload).

## <a name="file-to-azure-sql-database"></a> Moving data from a flat file source to an Azure SQL Database
Data in flat files (CSV or TSV formatted) can be moved to an Azure SQL Database using a Bulk Insert SQL Query.

### <a name="bulk-insert-sql-query"></a> Bulk Insert SQL Query
The steps for the procedure using the Bulk Insert SQL Query are similar to the directions for moving data from a flat file source to SQL Server on an Azure VM. For details, see [Bulk Insert SQL Query](move-sql-server-virtual-machine.md#insert-tables-bulkquery).

## <a name="sql-on-prem-to-sazure-sql-database"></a> Moving Data from SQL Server to an Azure SQL Database
If the source data is stored in SQL Server, there are various possibilities for moving the data to an Azure SQL Database:

1. [Export to Flat File](#export-flat-file)
2. [SQL Server Migration Assistant (SSMA)](#ssma)
3. [Database back up and restore](#db-migration)
4. [Azure Data Factory](#adf)

The steps for the first three are similar to those sections in [Move data to SQL Server on an Azure virtual machine](move-sql-server-virtual-machine.md) that cover these same procedures. Links to the appropriate sections in that topic are provided in the following instructions.

### <a name="export-flat-file"></a>Export to Flat File
The steps for this exporting to a flat file are similar to those directions covered in [Export to Flat File](move-sql-server-virtual-machine.md#export-flat-file).

### <a name="ssma"></a>SQL Server Migration Assistant (SSMA)
The steps for using the SQL Server Migration Assistant (SSMA) are similar to those directions covered in [SQL Server Migration Assistant (SSMA)](move-sql-server-virtual-machine.md#sql-migration).

### <a name="db-migration"></a>Database back up and restore
The steps for using database backup and restore are similar to those directions listed in [Database backup and restore](move-sql-server-virtual-machine.md#sql-backup).

### <a name="adf"></a>Azure Data Factory
Learn how to move data to an Azure SQL Database with Azure Data Factory (ADF) in this topic, [Move data from a SQL Server to SQL Azure with Azure Data Factory](move-sql-azure-adf.md). This topic shows how to use ADF to move data from a SQL Server database to an Azure SQL Database via Azure Blob Storage.

Consider using ADF when data needs to be continually migrated with hybrid on-premises and cloud sources.  ADF also helps when the data needs transformations, or needs new business logic during migration. ADF allows for the scheduling and monitoring of jobs using simple JSON scripts that manage the movement of data on a periodic basis. ADF also has other capabilities such as support for complex operations.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

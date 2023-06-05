---
title: Move Blob storage data with SSIS connectors
description: Learn how to move Data to or from Azure Blob Storage using SQL Server Integration Services Feature Pack for Azure.
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

# Move data to or from Azure Blob Storage using SSIS connectors

The [Azure Feature Pack for Integration Services (SSIS)](/sql/integration-services/azure-feature-pack-for-integration-services-ssis) provides components to connect to Azure, transfer data between Azure and on-premises data sources, and process data stored in Azure.

[!INCLUDE [blob-storage-tool-selector](../../includes/machine-learning-blob-storage-tool-selector.md)]

Once customers have moved on-premises data into the cloud, they can access their data from any Azure service to leverage the full power of the suite of Azure technologies. The data may be subsequently used, for example, in Azure Machine Learning or on an HDInsight cluster.

Examples for using these Azure resources are in the [SQL](/azure/architecture/data-science-process/overview) and [HDInsight](/azure/architecture/data-science-process/overview) walkthroughs.

For a discussion of canonical scenarios that use SSIS to accomplish business needs common in hybrid data integration scenarios, see [Doing more with SQL Server Integration Services Feature Pack for Azure](https://techcommunity.microsoft.com/t5/sql-server-integration-services/doing-more-with-sql-server-integration-services-feature-pack-for/ba-p/388238) blog.

> [!NOTE]
> For a complete introduction to Azure blob storage, refer to [Azure Blob Basics](/azure/storage/blobs/storage-quickstart-blobs-dotnet) and to [Azure Blob Service REST API](/rest/api/storageservices/blob-service-rest-api).
>
>

## Prerequisites
To perform the tasks described in this article, you must have an Azure subscription and an Azure Storage account set up. You need the Azure Storage account name and account key to upload or download data.

* To set up an **Azure subscription**, see [Free one-month trial](https://azure.microsoft.com/free/).
* For instructions on creating a **storage account** and for getting account and key information, see [About Azure Storage accounts](/azure/storage/common/storage-account-create).

To use the **SSIS connectors**, you must download:

* **SQL Server 2014 or 2016 Standard (or above)**: Install includes SQL Server Integration Services.
* **Microsoft SQL Server 2014 or 2016 Integration Services Feature Pack for Azure**: These connectors can be downloaded, respectively, from the [SQL Server 2014 Integration Services](https://www.microsoft.com/download/details.aspx?id=47366) and [SQL Server 2016 Integration Services](https://www.microsoft.com/download/details.aspx?id=49492) pages.

> [!NOTE]
> SSIS is installed with SQL Server, but is not included in the Express version. For information on what applications are included in various editions of SQL Server, see [SQL Server Technical Documentation](/sql/sql-server/)
>
>

For installing SSIS, see [Install Integration Services (SSIS)](/sql/integration-services/install-windows/install-integration-services)

For information on how to get up-and-running using SISS to build simple extraction, transformation, and load (ETL) packages, see [SSIS Tutorial: Creating a Simple ETL Package](/sql/integration-services/ssis-how-to-create-an-etl-package).

## Download NYC Taxi dataset
The example described here use a publicly available dataset, either available through [Azure Open Datasets](/azure/open-datasets/dataset-taxi-yellow?tabs=azureml-opendatasets) or from the source [TLC Trip Record Data](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page). The dataset consists of about 173 million taxi rides in NYC in the year 2013. There are two types of data: trip details data and fare data.

## Upload data to Azure blob storage
To move data using the SSIS feature pack from on-premises to Azure blob storage, we use an instance of the [**Azure Blob Upload Task**](/sql/integration-services/control-flow/azure-blob-upload-task), shown here:

![configure-data-science-vm](./media/move-data-to-azure-blob-using-ssis/ssis-azure-blob-upload-task.png)

The parameters that the task uses are described here:

| Field | Description |
| --- | --- |
| **AzureStorageConnection** |Specifies an existing Azure Storage Connection Manager or creates a new one that refers to an Azure Storage account that points to where the blob files are hosted. |
| **BlobContainer** |Specifies the name of the blob container that holds the uploaded files as blobs. |
| **BlobDirectory** |Specifies the blob directory where the uploaded file is stored as a block blob. The blob directory is a virtual hierarchical structure. If the blob already exists, it is replaced. |
| **LocalDirectory** |Specifies the local directory that contains the files to be uploaded. |
| **FileName** |Specifies a name filter to select files with the specified name pattern. For example, MySheet\*.xls\* includes files such as MySheet001.xls and MySheetABC.xlsx |
| **TimeRangeFrom/TimeRangeTo** |Specifies a time range filter. Files modified after *TimeRangeFrom* and before *TimeRangeTo* are included. |

> [!NOTE]
> The **AzureStorageConnection** credentials need to be correct and the **BlobContainer** must exist before the transfer is attempted.
>
>

## Download data from Azure blob storage
To download data from Azure blob storage to on-premises storage with SSIS, use an instance of the [Azure Blob Download Task](/sql/integration-services/control-flow/azure-blob-download-task).

## More advanced SSIS-Azure scenarios
The SSIS feature pack allows for more complex flows to be handled by packaging tasks together. For example, the blob data could feed directly into an HDInsight cluster, whose output could be downloaded back to a blob and then to on-premises storage. SSIS can run Hive and Pig jobs on an HDInsight cluster using additional SSIS connectors:

* To run a Hive script on an Azure HDInsight cluster with SSIS, use [Azure HDInsight Hive Task](/sql/integration-services/control-flow/azure-hdinsight-hive-task).
* To run a Pig script on an Azure HDInsight cluster with SSIS, use [Azure HDInsight Pig Task](/sql/integration-services/control-flow/azure-hdinsight-pig-task).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

- [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Introduction to Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [Copy and move blobs from one container or storage account to another](/training/modules/copy-blobs-from-command-line-and-code/)
- [Execute existing SSIS packages in Azure Data Factory or Azure Synapse Pipeline](/training/modules/execute-existing-ssis-packages-azure-data-factory/)
- [What is the Team Data Science Process (TDSP)?](overview.yml)

## Related resources

- [Explore data in Azure Blob storage](explore-data-blob.md)
- [Process Azure Blob Storage data with advanced analytics](data-blob.md)
- [Move data to and from Azure Blob Storage using Azure Storage Explorer](move-data-to-azure-blob-using-azure-storage-explorer.md)
- [Load data into storage environments for analytics](ingest-data.md)

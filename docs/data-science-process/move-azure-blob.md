---
title: Move data to and from Azure Blob storage 
description: Move Data to and from Azure Blob storage using Azure Storage Explorer, AzCopy, Python, and SSIS.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.date: 12/16/2021
ms.author: tdsp
ms.custom:
  - previous-author=deguhath
  - previous-ms.author=deguhath
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---
# Move data to and from Azure Blob storage

The Team Data Science Process requires that data be ingested or loaded into a variety of different storage environments to be processed or analyzed in the most appropriate way in each stage of the process.  [Azure Blob Storage has comprehensive documentation at this link](/azure/storage/blobs/) but this section in TDSP documentation provides a summary starter.

## Different technologies for moving data

The following articles describe how to move data to and from Azure Blob storage using different technologies.

* [Azure Storage Explorer](move-data-to-azure-blob-using-azure-storage-explorer.md)
* [AzCopy](/azure/storage/common/storage-use-azcopy-v10)
* [Python](/azure/storage/blobs/storage-quickstart-blobs-python)
* [SSIS](move-data-to-azure-blob-using-ssis.md)

Which method is best for you depends on your scenario. The [Scenarios for advanced analytics in Azure Machine Learning](/azure/architecture/data-science-process/overview) article helps you determine the resources you need for a variety of data science workflows used in the advanced analytics process.

> [!NOTE]
> For a complete introduction to Azure blob storage, refer to [Azure Blob Basics](/azure/storage/blobs/storage-quickstart-blobs-dotnet) and to [Azure Blob Service](/rest/api/storageservices/Blob-Service-Concepts).
>
>

## Using Azure Data Factory

As an alternative, you can use [Azure Data Factory](/azure/data-factory) to do the following:

* Create and schedule a pipeline that downloads data from Azure Blob storage.
* Pass it to a published Azure Machine Learning web service.
* Receive the predictive analytics results.
* Upload the results to storage.

For more information, see [Create predictive pipelines using Azure Data Factory and Azure Machine Learning](/azure/data-factory/transform-data-using-machine-learning).

## Prerequisites
This article assumes that you have an Azure subscription, a storage account, and the corresponding storage key for that account. Before uploading/downloading data, you must know your Azure Storage account name and account key.

* To set up an Azure subscription, see [Free one-month trial](https://azure.microsoft.com/free/).
* For instructions on creating a storage account and for getting account and key information, see [About Azure Storage accounts](/azure/storage/common/storage-account-create).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

- [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Introduction to Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [Copy and move blobs from one container or storage account to another](/training/modules/copy-blobs-from-command-line-and-code/)
- [What is the Team Data Science Process (TDSP)?](overview.yml)

## Related resources

- [Explore data in Azure Blob storage](explore-data-blob.md)
- [Process Azure Blob Storage data with advanced analytics](data-blob.md)
- [Set up data science environments for use in the Team Data Science Process](environment-setup.md)
- [Load data into storage environments for analytics](ingest-data.md)

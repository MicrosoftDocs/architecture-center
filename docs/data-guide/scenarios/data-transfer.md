---
title: Choose a data transfer technology
description: Learn about data transfer options like the Azure Import/Export service, Azure Data Box, Azure Data Factory, and command-line and graphical interface tools.
author: martinekuan
ms.author: architectures
ms.reviewer: tozimmergren
categories: azure
ms.date: 10/04/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories:
  - analytics
  - compute
  - databases
  - storage
products:
  - azure-cloud-services
  - azure-sql-database
  - azure-storage
ms.custom:
  - guide
  - engagement-fy23
---

<!-- cSpell:ignore SATA HDDs SDDs Distcp WASB Sqoop -->

# Transfer data to and from Azure

There are several options for transferring data to and from Azure, depending on your needs.

## Physical transfer

Using physical hardware to transfer data to Azure is a good option when:

- Your network is slow or unreliable.
- Getting more network bandwidth is cost-prohibitive.
- Security or organizational policies don't allow outbound connections when dealing with sensitive data.

If your primary concern is how long it takes to transfer your data, you might want to run a test to verify whether network transfer is slower than physical transport.

There are two main options for physically transporting data to Azure:

### The Azure Import/Export service

The [Azure Import/Export service](/azure/import-export/storage-import-export-service) lets you securely transfer large amounts of data to Azure Blob Storage or Azure Files by shipping internal SATA HDDs or SDDs to an Azure datacenter. You can also use this service to transfer data from Azure Storage to hard disk drives and have the drives shipped to you for loading on-premises.

### Azure Data Box

[Azure Data Box](https://azure.microsoft.com/services/storage/databox) is a Microsoft-provided appliance that works much like the Import/Export service. With Data Box, Microsoft ships you a proprietary, secure, and tamper-resistant transfer appliance and handles the end-to-end logistics, which you can track through the portal. One benefit of the Data Box service is ease of use. You don't need to purchase several hard drives, prepare them, and transfer files to each one. Data Box is supported by many industry-leading Azure partners to make it easier to seamlessly use offline transport to the cloud from their products.

## Command-line tools and APIs

Consider these options when you want scripted and programmatic data transfer:

- The [Azure CLI](/azure/hdinsight/hdinsight-upload-data#utilities) is a cross-platform tool that allows you to manage Azure services and upload data to Storage.

- **AzCopy**. Use AzCopy from a [Windows](/azure/storage/common/storage-use-azcopy) or [Linux](/azure/storage/common/storage-use-azcopy-linux) command line to easily copy data to and from Blob Storage, Azure File Storage, and Azure Table Storage with optimal performance. AzCopy supports concurrency and parallelism, and the ability to resume copy operations when interrupted. You can also use AzCopy to copy data from AWS to Azure. For programmatic access, the [Microsoft Azure Storage Data Movement Library](/azure/storage/common/storage-use-data-movement-library) is the core framework that powers AzCopy. It's provided as a .NET Core library.

- With **PowerShell**, the [Start-AzureStorageBlobCopy PowerShell cmdlet](/powershell/module/azure.storage/start-azurestorageblobcopy?view=azurermps-5.0.0&preserve-view=true) is an option for Windows administrators who are used to PowerShell.

- [AdlCopy](/azure/data-lake-store/data-lake-store-copy-data-azure-storage-blob) enables you to copy data from Blob Storage into Azure Data Lake Storage. It can also be used to copy data between two Data Lake Storage accounts. However, it can't be used to copy data from Data Lake Storage to Blob Storage.

- [Distcp](/azure/data-lake-store/data-lake-store-copy-data-wasb-distcp) is used to copy data to and from an HDInsight cluster storage (WASB) into a Data Lake Storage account.

- [Sqoop](/azure/hdinsight/hadoop/hdinsight-use-sqoop) is an Apache project and part of the Hadoop ecosystem. It comes preinstalled on all HDInsight clusters. It allows data transfer between an HDInsight cluster and relational databases such as SQL, Oracle, MySQL, and so on. Sqoop is a collection of related tools, including import and export tools. Sqoop works with HDInsight clusters by using either Blob Storage or Data Lake Storage attached storage.

- [PolyBase](/sql/relational-databases/polybase/get-started-with-polybase) is a technology that accesses data outside a database through the T-SQL language. In SQL Server 2016, it allows you to run queries on external data in Hadoop or to import or export data from Blob Storage. In Azure Synapse Analytics, you can import or export data from Blob Storage and Data Lake Storage. Currently, PolyBase is the fastest method of importing data into Azure Synapse Analytics.

- Use the [Hadoop command line](/azure/hdinsight/hdinsight-upload-data#hadoop-command-line) when you have data that resides on an HDInsight cluster head node. You can use the `hadoop -copyFromLocal` command to copy that data to your cluster's attached storage, such as Blob Storage or Data Lake Storage. In order to use the Hadoop command, you must first connect to the head node. Once connected, you can upload a file to storage.

## Graphical interface

Consider the following options if you're only transferring a few files or data objects and don't need to automate the process.

- [Azure Storage Explorer](https://azure.microsoft.com/features/storage-explorer) is a cross-platform tool that lets you manage the contents of your Azure storage accounts. It allows you to upload, download, and manage blobs, files, queues, tables, and Azure Cosmos DB entities. Use it with Blob Storage to manage blobs and folders, and upload and download blobs between your local file system and Blob Storage, or between storage accounts.

- **Azure portal**. Both Blob Storage and Data Lake Storage provide a web-based interface for exploring files and uploading new files. This option is a good one if you don't want to install tools or issue commands to quickly explore your files, or if you want to upload a handful of new ones.

## Data sync and pipelines

- [Azure Data Factory](/azure/data-factory) is a managed service best suited for regularly transferring files between many Azure services, on-premises systems, or a combination of the two. By using Data Factory, you can create and schedule data-driven workflows called pipelines that ingest data from disparate data stores. Data Factory can process and transform the data by using compute services such as Azure HDInsight Hadoop, Spark, Azure Data Lake Analytics, and Azure Machine Learning. You can create data-driven workflows for [orchestrating](../technology-choices/pipeline-orchestration-data-movement.md) and automating data movement and data transformation.

- [Pipelines and activities](/azure/data-factory/concepts-pipelines-activities) in Data Factory and Azure Synapse Analytics can be used to construct end-to-end data-driven workflows for your data movement and data processing scenarios. Additionally, the [Azure Data Factory integration runtime](/azure/data-factory/concepts-integration-runtime) is used to provide data integration capabilities across different network environments.

- [Azure Data Box Gateway](/azure/databox-gateway/data-box-gateway-overview) transfers data to and from Azure, but it's a virtual appliance, not a hard drive. Virtual machines residing in your on-premises network write data to Data Box Gateway by using the NFS and SMB protocols. The device then transfers your data to Azure.

## Key selection criteria

For data transfer scenarios, choose the appropriate system for your needs by answering these questions:

- Do you need to transfer large amounts of data, where doing so over an internet connection would take too long, be unreliable, or too expensive? If yes, consider physical transfer.

- Do you prefer to script your data transfer tasks, so they're reusable? If so, select one of the command-line options or Data Factory.

- Do you need to transfer a large amount of data over a network connection? If so, select an option that's optimized for big data.

- Do you need to transfer data to or from a relational database? If yes, choose an option that supports one or more relational databases. Some of these options also require a Hadoop cluster.

- Do you need an automated data pipeline or workflow orchestration? If yes, consider Data Factory.

## Capability matrix

The following tables summarize the key differences in capabilities.

<!-- markdownlint-disable MD024 -->

### Physical transfer

| Capability | The Import/Export service | Data Box |
| --- | --- | --- |
| Form factor | Internal SATA HDDs or SDDs | Secure, tamper-proof, single hardware appliance |
| Microsoft manages shipping logistics | No | Yes |
| Integrates with partner products | No | Yes |
| Custom appliance | No | Yes |

### Command-line tools

**Hadoop/HDInsight:**

| Capability | Distcp | Sqoop | Hadoop CLI |
| --- | --- | --- | --- |
| Optimized for big data | Yes | Yes |  Yes |
| Copy to relational database |  No | Yes | No |
| Copy from relational database |  No | Yes | No |
| Copy to Blob Storage |  Yes | Yes | Yes |
| Copy from Blob Storage | Yes |  Yes | No |
| Copy to Data Lake Storage | Yes | Yes | Yes |
| Copy from Data Lake Storage | Yes | Yes | No |

**Other:**

| Capability | Azure CLI | AzCopy | PowerShell | AdlCopy | PolyBase |
| --- | --- | --- | --- | --- | --- |
| Compatible platforms | Linux, OS X, Windows | Linux, Windows | Windows | Linux, OS X, Windows | SQL Server, Azure Synapse Analytics |
| Optimized for big data | No | Yes | No | Yes <sup>1</sup> | Yes <sup>2</sup> |
| Copy to relational database | No | No | No | No | Yes |
| Copy from relational database | No | No | No | No | Yes |
| Copy to Blob Storage | Yes | Yes | Yes | No | Yes |
| Copy from Blob Storage | Yes | Yes | Yes | Yes | Yes |
| Copy to Data Lake Storage | No | Yes | Yes | Yes |  Yes |
| Copy from Data Lake Storage | No | No | Yes | Yes | Yes |

[1] AdlCopy is optimized for transferring big data when used with a Data Lake Analytics account.

[2] PolyBase [performance can be increased](/sql/relational-databases/polybase/polybase-guide#performance) by pushing computation to Hadoop and using [PolyBase scale-out groups](/sql/relational-databases/polybase/polybase-scale-out-groups) to enable parallel data transfer between SQL Server instances and Hadoop nodes.

### Graphical interfaces, data sync, and data pipelines

| Capability | Azure Storage Explorer | Azure portal * | Data Factory | Data Box Gateway |
| --- | --- | --- | --- | --- |
| Optimized for big data | No | No | Yes | Yes |
| Copy to relational database | No | No | Yes | No |
| Copy from relational database | No | No | Yes | No |
| Copy to Blob Storage | Yes | No | Yes | Yes |
| Copy from Blob Storage | Yes | No | Yes | No |
| Copy to Data Lake Storage | No | No | Yes | No |
| Copy from Data Lake Storage | No | No | Yes | No |
| Upload to Blob Storage | Yes | Yes | Yes | Yes |
| Upload to Data Lake Storage | Yes | Yes | Yes | Yes |
| Orchestrate data transfers | No | No | Yes | No |
| Custom data transformations | No | No | Yes | No |
| Pricing model | Free | Free | Pay per usage | Pay per unit |

\* Azure portal in this case represents the web-based exploration tools for Blob Storage and Data Lake Storage.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect

## Next steps

- [What is Azure Import/Export service?](/azure/import-export/storage-import-export-service)
- [What is Azure Data Box?](/azure/databox/data-box-overview)
- [What is the Azure CLI?](/cli/azure/what-is-azure-cli)
- [Get started with AzCopy](/azure/storage/common/storage-use-azcopy-v10)
- [Get started with Storage Explorer](/azure/vs-azure-tools-storage-manage-with-storage-explorer)
- [What is Azure Data Factory?](/azure/data-factory/introduction)
- [What is Azure Data Box Gateway?](/azure/databox-gateway/data-box-gateway-overview)

## Related resources

- [Move archive data from mainframe systems to Azure](../../example-scenario/mainframe/move-archive-data-mainframes.yml)
- [Mainframe file replication and sync on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)
- [Replicate and sync mainframe data in Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)

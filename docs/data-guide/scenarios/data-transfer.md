---
title: Choose a Data Transfer Technology
description: Learn about data transfer options like the Azure Import/Export service, Azure Data Box, Azure Data Factory, Fabric Data Factory, and command-line and graphical interface tools.
author: josearper
ms.author: joaria
ms.date: 10/04/2022
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-data
---

<!-- cSpell:ignore SATA HDDs SDDs DistCp WASB Sqoop -->

# Choose a data transfer technology

This article describes several options that you can use to transfer data to and from Azure, depending on your needs.

## Physical transfer

Using physical hardware to transfer data to Azure is a good option when the following factors apply:

- Your network is slow or unreliable.
- Getting more network bandwidth is too expensive.
- Security or organizational policies don't allow outbound connections when handling sensitive data.

If your primary concern is how long it takes to transfer your data, consider testing to confirm whether network transfer is slower than physical transport.

The Azure Import/Export service and Azure Data Box are the two main options for physically transporting data to Azure.

### The Azure Import/Export service

The [Azure Import/Export service](/azure/import-export/storage-import-export-service) lets you securely transfer large amounts of data to Azure Blob Storage or Azure Files by shipping internal Serial Advanced Technology Attachment (SATA) hard disk drives (HDDs) or solid-state drives (SDDs) to an Azure datacenter. You can also use this service to transfer data from Azure Storage to HDDs and have the drives shipped to you for loading on-premises.

### Data Box

[Data Box](/azure/databox/data-box-overview) is a Microsoft appliance that functions similarly to the Azure Import/Export service. With Data Box, Microsoft ships you a proprietary, secure, and tamper-resistant transfer appliance and handles the end-to-end logistics, which you can track through the Azure portal. One benefit of the Data Box service is ease of use. You don't need to purchase several hard drives, prepare them, and transfer files to each one. Many Azure partners support Data Box, which makes it easier to use offline transport to the cloud within their solutions.

## Command-line tools and APIs

Consider the following options when you need scripted and programmatic data transfer:

- The [Azure CLI](/azure/hdinsight/hdinsight-upload-data#utilities) is a cross-platform tool that lets you manage Azure services and upload data to Storage.

- [AzCopy](/azure/storage/common/storage-use-azcopy-v10) is a command-line utility that lets you copy data to and from Blob Storage, Azure Files storage, and Azure Table Storage with optimal performance. AzCopy supports concurrency and parallelism, and the ability to resume copy operations when interrupted. You can also use AzCopy to copy data from Amazon Web Services (AWS) to Azure. For programmatic access, the [Microsoft Azure Storage Data Movement library](/azure/storage/common/storage-use-data-movement-library) is the core framework that powers AzCopy. It's provided as a .NET Core library.

- [Azure PowerShell](/powershell/module/az.storage/start-azstorageblobcopy) is a scripting environment where the `Start-AzureStorageBlobCopy` cmdlet provides an option for operators who are familiar with Azure PowerShell.

- [DistCp](/azure/data-lake-store/data-lake-store-copy-data-wasb-distcp) is a utility used to copy data between an Azure HDInsight cluster's default storage and other Blob Storage or Azure Data Lake Storage accounts.

- [Apache Sqoop](/azure/hdinsight/hadoop/hdinsight-use-sqoop) is an Apache project and part of the Hadoop ecosystem. It comes preinstalled on all HDInsight clusters. Sqoop transfers data between an HDInsight cluster and relational databases like SQL, Oracle, and MySQL. It's a collection of related tools, including import and export tools, and works with HDInsight clusters by using either Blob Storage or Data Lake Storage attached storage.

- [PolyBase](/sql/relational-databases/polybase/get-started-with-polybase) is a technology that accesses data outside a database through the T-SQL language. It lets you run queries on external data in Hadoop or import and export data from Blob Storage.

- The [Hadoop command line](/azure/hdinsight/hdinsight-upload-data#hadoop-command-line) is a tool that you can use when your data resides on an HDInsight cluster head node. You can use the `hadoop fs -copyFromLocal` command to copy that data to your cluster's attached storage, like Blob Storage or Data Lake Storage. To use the Hadoop command, you must first connect to the head node. After it's connected, you can upload a file to storage.

## Graphical interface

Consider the following options if you only need to transfer a few files or data objects and don't need to automate the process.

- [Azure Storage Explorer](/azure/storage/storage-explorer/vs-azure-tools-storage-manage-with-storage-explorer) is a cross-platform tool that lets you manage the contents of your Storage accounts. It lets you upload, download, and manage blobs, files, queues, tables, and Azure Cosmos DB entities. Use Storage Explorer with Blob Storage to manage blobs and folders, and upload and download blobs between your local file system and Blob Storage or between storage accounts.

- The [Azure portal](/azure/azure-portal/azure-portal-overview) is a web-based application that provides a unified interface to create, manage, and monitor Azure resources. Blob Storage and Data Lake Storage both provide a web-based interface for exploring and uploading files. This option is suitable if you don't want to install tools or run commands to quickly search your files, or if you only need to upload a few files.

- [Microsoft Fabric dataflows](/fabric/data-factory/dataflows-gen2-overview) are cloud-based capabilities that help you prepare and transform data without writing code. They provide a low-code interface for ingesting data from hundreds of sources, and transform your data by using built-in data transformers and loading the resulting data into [supported destinations](/fabric/data-factory/dataflow-gen2-data-destinations-and-managed-settings).

## Data sync and pipelines

- [Azure Data Factory](/azure/data-factory/introduction) is a managed service designed for regularly transferring files across Azure services, on-premises systems, or a combination of both. By using Data Factory, you can create and schedule data-driven workflows known as *pipelines* that ingest data from disparate data stores. Data Factory can process and transform the data by using compute services like Apache Spark and Azure Machine Learning. You can create data-driven workflows for [orchestrating](../technology-choices/pipeline-orchestration-data-movement.md) and automating data movement and data transformation.

- [Fabric Data Factory](/fabric/data-factory/data-factory-overview) is a data integration platform that enables you to orchestrate and automate data movement and transformation across cloud and hybrid environments. It lets you build and schedule data-driven workflows (pipelines) that ingest data from various sources, including cloud storage, databases, and on-premises systems. These pipelines support diverse activities like data movement, transformation, and control flow, and can use compute engines like Spark and SQL within Fabric workloads. With integration into [OneLake](/fabric/onelake/onelake-overview), Fabric ensures unified data access, governance, and collaboration across the entire data estate.

  The [integration runtime](/azure/data-factory/concepts-integration-runtime) in Data Factory, the [on-premises data gateway](/data-integration/gateway/service-gateway-onprem) in Fabric, and the [virtual network data gateway](/data-integration/vnet/overview) provide secure connectivity and data integration capabilities across cloud, on-premises, and virtual network environments.

- [Azure Data Box Gateway](/azure/databox-gateway/data-box-gateway-overview) transfers data to and from Azure, but it's a virtual appliance, not a hard drive. Virtual machines (VMs) that reside in your on-premises network write data to Data Box Gateway by using the Network File System (NFS) and Server Message Block (SMB) protocols. Then the device transfers your data to Azure.

## Key selection criteria

For data transfer scenarios, choose the right system for your needs by considering the following points:

- Determine if you need to transfer large amounts of data and transferring the data over an internet connection would take too long, be unreliable, or be too expensive. If yes, consider physical transfer.

- Determine if you prefer to script your data transfer tasks so that they're reusable. If yes, select one of the command-line options or Data Factory.

- Determine if you need to transfer a large amount of data over a network connection. If yes, select an option that's optimized for big data.

- Determine if you need to transfer data to or from a relational database. If yes, choose an option that supports one or more relational databases. Some of these options also require a Hadoop cluster.

- Determine if your data needs an automated pipeline or workflow orchestration. If yes, consider Data Factory.

## Capability matrix

The following tables summarize the key differences in capabilities.

<!-- markdownlint-disable MD024 -->

### Physical transfer

| Capability | The Azure Import/Export service | Data Box |
| --- | --- | --- |
| Form factor | Internal SATA HDDs or SDDs | Secure, tamper-proof, single hardware appliance |
| Microsoft manages shipping logistics | No | Yes |
| Integrates with partner products | No | Yes |
| Custom appliance | No | Yes |

### Command-line tools

The following tools are compatible with Hadoop and HDInsight.

| Capability | DistCp | Sqoop | Hadoop CLI |
| --- | --- | --- | --- |
| Optimized for big data | Yes | Yes | Yes |
| Copy to relational database | No | Yes | No |
| Copy from relational database | No | Yes | No |
| Copy to Blob Storage | Yes | Yes | Yes |
| Copy from Blob Storage | Yes | Yes | No |
| Copy to Data Lake Storage | Yes | Yes | Yes |
| Copy from Data Lake Storage | Yes | Yes | No |

The following table includes general-purpose data transfer tools.

| Capability | The Azure CLI | AzCopy | Azure PowerShell | PolyBase |
| --- | --- | --- | --- | --- |
| Compatible platforms | Linux, OS X, Windows | Linux, Windows | Windows | SQL Server |
| Optimized for big data | No | Yes | No | Yes <sup>[1](#note1)</sup> |
| Copy to relational database | No | No | No | Yes |
| Copy from relational database | No | No | No | Yes |
| Copy to Blob Storage | Yes | Yes | Yes | Yes |
| Copy from Blob Storage | Yes | Yes | Yes | Yes |
| Copy to Data Lake Storage | No | Yes | Yes | Yes |
| Copy from Data Lake Storage | No | No | Yes | Yes |

<sup>1</sup> <span id="note1"></span> PolyBase [performance can be improved](/sql/relational-databases/polybase/polybase-guide#performance) by pushing computation to Hadoop and using [PolyBase scale-out groups](/sql/relational-databases/polybase/polybase-scale-out-groups) to enable parallel data transfer between SQL Server instances and Hadoop nodes.

### Graphical interfaces, data sync, and data pipelines

| Capability | Storage Explorer | The Azure portal <sup>[2](#note2)</sup> | Data Factory | Data Box Gateway | Dataflows |
| --- | --- | --- | --- | --- | --- |
| Optimized for big data | No | No | Yes | Yes | Yes |
| Copy to relational database | No | No | Yes | No | Yes |
| Copy from relational database | No | No | Yes | No | Yes |
| Copy to Blob Storage | Yes | No | Yes | Yes | Yes |
| Copy from Blob Storage | Yes | No | Yes | No | Yes |
| Copy to Data Lake Storage | No | No | Yes | No | Yes |
| Copy from Data Lake Storage | No | No | Yes | No | Yes |
| Upload to Blob Storage | Yes | Yes | Yes | Yes | Yes |
| Upload to Data Lake Storage | Yes | Yes | Yes | Yes | Yes |
| Orchestrate data transfers | No | No | Yes | No | Yes |
| Custom data transformations | No | No | Yes | No | Yes |
| Pricing model | Free | Free | Pay per usage | Pay per unit | Pay per usage |

<sup>2</sup> <span id="note2"></span> The Azure portal in this case represents the web-based exploration tools for Blob Storage and Data Lake Storage.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect

Other contributors:

- [Prabhjot Kaur](https://www.linkedin.com/in/prabhkaur1/) | Senior Solution Engineer
- [Sriram Kolla](https://www.linkedin.com/in/sriram-kolla-2474296/) | Principal Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- [What is the Azure CLI?](/cli/azure/what-is-azure-cli)

## Related resources

- [Move archive data from mainframe systems to Azure](../../example-scenario/mainframe/move-archive-data-mainframes.yml)
- [Mainframe file replication and sync on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)
- [Replicate and sync mainframe data to Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)

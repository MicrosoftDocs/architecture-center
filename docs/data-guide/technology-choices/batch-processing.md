---
title: Choosing a batch processing technology
description: 
author: zoinerTejada
ms.date: 11/20/2019
ms.topic: guide
ms.service: architecture-center
ms.subservice: cloud-fundamentals
---

# Choosing a batch processing technology in Azure

Big data solutions often use long-running batch jobs to filter, aggregate, and otherwise prepare the data for analysis. Usually these jobs involve reading source files from scalable storage (like HDFS, Azure Data Lake Store, and Azure Storage), processing them, and writing the output to new files in scalable storage.

The key requirement of such batch processing engines is the ability to scale out computations, in order to handle a large volume of data. Unlike real-time processing, however, batch processing is expected to have latencies (the time between data ingestion and computing a result) that measure in minutes to hours.

## Technology choices for batch processing

### Azure Synapse Analytics

[Azure Synapse](/azure/sql-data-warehouse/) is a distributed system designed to perform analytics on large data. It supports massive parallel processing (MPP), which makes it suitable for running high-performance analytics. Consider Azure Synapse when you have large amounts of data (more than 1 TB) and are running an analytics workload that will benefit from parallelism.

### Azure Data Lake Analytics

[Data Lake Analytics](/azure/data-lake-analytics/data-lake-analytics-overview) is an on-demand analytics job service. It is optimized for distributed processing of very large data sets stored in Azure Data Lake Store.

- Languages: [U-SQL](/azure/data-lake-analytics/data-lake-analytics-u-sql-get-started) (including Python, R, and C# extensions).
- Integrates with Azure Data Lake Store, Azure Storage blobs, Azure SQL Database, and Azure Synapse.
- Pricing model is per-job.

### HDInsight

HDInsight is a managed Hadoop service. Use it deploy and manage Hadoop clusters in Azure. For batch processing, you can use [Spark](/azure/hdinsight/spark/apache-spark-overview), [Hive](/azure/hdinsight/hadoop/hdinsight-use-hive), [Hive LLAP](/azure/hdinsight/interactive-query/apache-interactive-query-get-started), [MapReduce](/azure/hdinsight/hadoop/hdinsight-use-mapreduce).

- Languages: R, Python, Java, Scala, SQL
- Kerberos authentication with Active Directory, Apache Ranger based access control
- Gives you full control of the Hadoop cluster

### Azure Databricks

[Azure Databricks](/azure/azure-databricks/) is an Apache Spark-based analytics platform. You can think of it as "Spark as a service." It's the easiest way to use Spark on the Azure platform.

- Languages: R, Python, Java, Scala, Spark SQL
- Fast cluster start times, autotermination, autoscaling.
- Manages the Spark cluster for you.
- Built-in integration with Azure Blob Storage, Azure Data Lake Storage (ADLS), Azure Synapse, and other services. See [Data Sources](https://docs.azuredatabricks.net/data/data-sources/index.html#data-sources).
- User authentication with Azure Active Directory.
- Web-based [notebooks](https://docs.azuredatabricks.net/notebooks/index.html#notebooks) for collaboration and data exploration.
- Supports [GPU-enabled clusters](https://docs.azuredatabricks.net/clusters/gpu.html#gpu-enabled-clusters)

### Azure Distributed Data Engineering Toolkit

The [Distributed Data Engineering Toolkit](https://github.com/azure/aztk) (AZTK) is a tool for provisioning on-demand Spark on Docker clusters in Azure.

AZTK is not an Azure service. Rather, it's a client-side tool with a CLI and Python SDK interface, that's built on Azure Batch. This option gives you the most control over the infrastructure when deploying a Spark cluster.

- Bring your own Docker image.
- Use low-priority VMs for an 80% discount.
- Mixed mode clusters that use both low-priority and dedicated VMs.
- Built in support for Azure Blob Storage and Azure Data Lake connection.

## Key selection criteria

To narrow the choices, start by answering these questions:

- Do you want a managed service rather than managing your own servers?

- Do you want to author batch processing logic declaratively or imperatively?

- Will you perform batch processing in bursts? If yes, consider options that let you auto-terminate the cluster or whose pricing model is per batch job.

- Do you need to query relational data stores along with your batch processing, for example to look up reference data? If yes, consider the options that enable querying of external relational stores.

## Capability matrix

The following tables summarize the key differences in capabilities.

### General capabilities

<!-- markdownlint-disable MD033 -->

| Capability | Azure Data Lake Analytics | Azure Synapse | HDInsight | Azure Databricks |
| --- | --- | --- | --- | --- |
| Is managed service | Yes | Yes | Yes <sup>1</sup> | Yes |
| Relational data store | Yes | Yes | No | No |
| Pricing model | Per batch job | By cluster hour | By cluster hour | Databricks Unit<sup>2</sup> + cluster hour |

[1] With manual configuration and scaling.

[2] A Databricks Unit (DBU) is a unit of processing capability per hour.

### Capabilities

| Capability | Azure Data Lake Analytics | Azure Synapse | HDInsight with Spark | HDInsight with Hive | HDInsight with Hive LLAP | Azure Databricks |
| --- | --- | --- | --- | --- | --- | --- |
| Autoscaling | No | No | No | No | No | Yes |
| Scale-out granularity  | Per job | Per cluster | Per cluster | Per cluster | Per cluster | Per cluster |
| In-memory caching of data | No | Yes | Yes | No | Yes | Yes |
| Query from external relational stores | Yes | No | Yes | No | No | Yes |
| Authentication  | Azure AD | SQL / Azure AD | No | Azure AD<sup>1</sup> | Azure AD<sup>1</sup> | Azure AD |
| Auditing  | Yes | Yes | No | Yes <sup>1</sup> | Yes <sup>1</sup> | Yes |
| Row-level security | No | Yes<sup>2</sup> | No | Yes <sup>1</sup> | Yes <sup>1</sup> | No |
| Supports firewalls | Yes | Yes | Yes | Yes <sup>3</sup> | Yes <sup>3</sup> | No |
| Dynamic data masking | No | Yes | No | Yes <sup>1</sup> | Yes <sup>1</sup> | No |

<!-- markdownlint-enable MD033 -->

[1] Requires using a [domain-joined HDInsight cluster](/azure/hdinsight/domain-joined/apache-domain-joined-introduction).

[2] Filter predicates only. See [Row-Level Security](/sql/relational-databases/security/row-level-security)

[3] Supported when [used within an Azure Virtual Network](/azure/hdinsight/hdinsight-extend-hadoop-virtual-network).

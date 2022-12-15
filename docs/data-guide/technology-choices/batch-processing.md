---
title: Choose a batch processing technology
description: Compare technology choices for big data batch processing in Azure, including key selection criteria and a capability matrix.
author: martinekuan
categories: azure
ms.author: architectures
ms.reviewer: tozimmergren
ms.date: 10/03/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories:
  - analytics
products:
  - azure-synapse-analytics
  - azure-data-lake
ms.custom:
  - guide
  - engagement-fy23
---

# Choose a batch processing technology in Azure

Big data solutions often use long-running batch jobs to filter, aggregate and otherwise prepare the data for analysis. Usually, these jobs involve reading source files from scalable storage (like HDFS, Azure Data Lake Store, and Azure Storage), processing them, and writing the output to new files in scalable storage.

The fundamental requirement of such batch processing engines is to scale out computations to handle a large volume of data. Unlike real-time processing, batch processing is expected to have latencies (the time between data ingestion and computing a result) that measure in minutes to hours.

## Technology choices for batch processing

### Azure Synapse Analytics

[Azure Synapse](/azure/sql-data-warehouse/) is a distributed system designed to perform analytics on large data. It supports massive parallel processing (MPP), which makes it suitable for running high-performance analytics. Consider Azure Synapse when you have large amounts of data (more than 1 TB) and are running an analytics workload that will benefit from parallelism.

### Azure Data Lake Analytics

[Data Lake Analytics](/azure/data-lake-analytics/data-lake-analytics-overview) is an on-demand analytics job service. It's optimized for distributed processing of large data sets stored in Azure Data Lake Store.

- Languages: [U-SQL](/azure/data-lake-analytics/data-lake-analytics-u-sql-get-started) (including Python, R, and C# extensions).
- Integrates with Azure Data Lake Store, Azure Storage blobs, Azure SQL Database, and Azure Synapse.
- Pricing model is per-job.

### HDInsight

HDInsight is a managed Hadoop service. Use it to deploy and manage Hadoop clusters in Azure. For batch processing, you can use [Spark](/azure/hdinsight/spark/apache-spark-overview), [Hive](/azure/hdinsight/hadoop/hdinsight-use-hive), [Hive LLAP](/azure/hdinsight/interactive-query/apache-interactive-query-get-started), [MapReduce](/azure/hdinsight/hadoop/hdinsight-use-mapreduce).

- Languages: R, Python, Java, Scala, SQL
- Kerberos authentication with Active Directory, Apache Ranger-based access control
- Gives you complete control of the Hadoop cluster

### Azure Databricks

[Azure Databricks](/azure/azure-databricks/) is an Apache Spark-based analytics platform. You can think of it as "Spark as a service." It's the easiest way to use Spark on the Azure platform.

- Languages: R, Python, Java, Scala, Spark SQL
- Fast cluster start times, autotermination, autoscaling.
- Manages the Spark cluster for you.
- Built-in integration with Azure Blob Storage, Azure Data Lake Storage (ADLS), Azure Synapse, and other services. See [Data Sources](/azure/databricks/data/data-sources/).
- User authentication with Azure Active Directory.
- Web-based [notebooks](/azure/databricks/notebooks/) for collaboration and data exploration.
- Supports [GPU-enabled clusters](/azure/databricks/clusters/gpu)

## Key selection criteria

To narrow the choices, start by answering these questions:

- Do you want a managed service rather than managing your own servers?

- Do you want to author batch processing logic declaratively or imperatively?

- Will you perform batch processing in bursts? If yes, consider options that let you auto-terminate the cluster or whose pricing model is per batch job.

- Do you need to query relational data stores along with your batch processing, for example, to look up reference data? If yes, consider the options that enable the querying of external relational stores.

## Capability matrix

The following tables summarize the key differences in capabilities.

### General capabilities

| Capability | Azure Data Lake Analytics | Azure Synapse | HDInsight | Azure Databricks |
| --- | --- | --- | --- | --- |
| Is managed service | Yes | Yes | Yes <sup>1</sup> | Yes |
| Relational data store | Yes | Yes | No | No |
| Pricing model | Per batch job | By cluster hour | By cluster hour | Databricks Unit<sup>2</sup> + cluster hour |

[1] With manual configuration.

[2] A Databricks Unit (DBU) is a unit of processing capability per hour.

### Capabilities

| Capability | Azure Data Lake Analytics | Azure Synapse | HDInsight with Spark | HDInsight with Hive | HDInsight with Hive LLAP | Azure Databricks |
| --- | --- | --- | --- | --- | --- | --- |
| Autoscaling | No | No | Yes | Yes | Yes | Yes |
| Scale-out granularity  | Per job | Per cluster | Per cluster | Per cluster | Per cluster | Per cluster |
| In-memory caching of data | No | Yes | Yes | No | Yes | Yes |
| Query from external relational stores | Yes | No | Yes | No | No | Yes |
| Authentication  | Azure AD | SQL / Azure AD | No | Azure AD<sup>1</sup> | Azure AD<sup>1</sup> | Azure AD |
| Auditing  | Yes | Yes | No | Yes <sup>1</sup> | Yes <sup>1</sup> | Yes |
| Row-level security | No | Yes<sup>2</sup> | No | Yes <sup>1</sup> | Yes <sup>1</sup> | No |
| Supports firewalls | Yes | Yes | Yes | Yes <sup>3</sup> | Yes <sup>3</sup> | No |
| Dynamic data masking | No | Yes | No | Yes <sup>1</sup> | Yes <sup>1</sup> | No |

[1] Requires using a [domain-joined HDInsight cluster](/azure/hdinsight/domain-joined/apache-domain-joined-introduction).

[2] Filter predicates only. See [Row-Level Security](/sql/relational-databases/security/row-level-security)

[3] Supported when [used within an Azure Virtual Network](/azure/hdinsight/hdinsight-extend-hadoop-virtual-network).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect

## Next steps

- [Create a lake database in Azure Synapse Analytics](/training/modules/create-metadata-objects-azure-synapse-serverless-sql-pools)
- [Create an Azure Databricks workspace](/azure/databricks/getting-started)
- [Explore Azure Databricks](/training/modules/explore-azure-databricks)
- [Get started with Azure Data Lake Analytics using the Azure portal](/azure/data-lake-analytics/data-lake-analytics-get-started-portal)
- [Introduction to Azure Synapse Analytics](/training/modules/introduction-azure-synapse-analytics)
- [What is Azure Databricks?](/azure/databricks/introduction)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)

## Related resources

- [Analytics architecture design](../../solution-ideas/articles/analytics-start-here.yml)
- [Choose an analytical data store in Azure](analytical-data-stores.md)
- [Choose a data analytics technology in Azure](analysis-visualizations-reporting.md)
- [Analytics end-to-end with Azure Synapse](../../example-scenario/dataplate2e/data-platform-end-to-end.yml)
- [Batch processing](../big-data/batch-processing.yml)

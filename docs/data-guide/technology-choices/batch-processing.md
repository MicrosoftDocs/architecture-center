---
title: Choosing a batch processing technology
description: 
author: zoinerTejada
ms:date: 02/12/2018
---

# Choosing a batch processing technology in Azure

Big data solutions often use long-running batch jobs to filter, aggregate, and otherwise prepare the data for analysis. Usually these jobs involve reading source files from scalable storage (like HDFS, Azure Data Lake Store, and Azure Storage), processing them, and writing the output to new files in scalable storage. 

The key requirement of such batch processing engines is the ability to scale out computations, in order to handle a large volume of data. Unlike real-time processing, however, batch processing is expected to have latencies (the time between data ingestion and computing a result) that measure in minutes to hours.

## What are your options when choosing a batch processing technology?

In Azure, all of the following data stores will meet the core requirements for batch processing:

- [Azure Data Lake Analytics](/azure/data-lake-analytics/)
- [Azure SQL Data Warehouse](/azure/sql-data-warehouse/sql-data-warehouse-overview-what-is)
- [HDInsight with Spark](/azure/hdinsight/spark/apache-spark-overview)
- [HDInsight with Hive](/azure/hdinsight/hadoop/hdinsight-use-hive)
- [HDInsight with Hive LLAP](/azure/hdinsight/interactive-query/apache-interactive-query-get-started)

## Key selection criteria

To narrow the choices, start by answering these questions:

- Do you want a managed service rather than managing your own servers?

- Do you want to author batch processing logic declaratively or imperatively?

- Will you perform batch processing in bursts? If yes, consider options that let you pause the cluster or whose pricing model is per batch job.

- Do you need to query relational data stores along with your batch processing, for example to look up reference data? If yes, consider the options that enable querying of external relational stores.

## Capability matrix

The following tables summarize the key differences in capabilities. 

### General capabilities

| | Azure Data Lake Analytics | Azure SQL Data Warehouse | HDInsight with Spark | HDInsight with Hive | HDInsight with Hive LLAP |
| --- | --- | --- | --- | --- | --- |
| Is managed service | Yes | Yes | Yes <sup>1</sup> | Yes <sup>1</sup> | Yes <sup>1</sup> |
| Supports pausing compute | No | Yes | No | No | No |
| Relational data store | Yes | Yes | No | No | No |
| Programmability | U-SQL | T-SQL | Python, Scala, Java, R | HiveQL | HiveQL |
| Programming paradigm | Mixture of declarative and imperative  | Declarative | Mixture of declarative and imperative | Declarative | Declarative | 
| Pricing model | Per batch job | By cluster hour | By cluster hour | By cluster hour | By cluster hour |  

[1] With manual configuration and scaling.

### Integration capabilities

| | Azure Data Lake Analytics | SQL Data Warehouse | HDInsight with Spark | HDInsight with Hive | HDInsight with Hive LLAP |
| --- | --- | --- | --- | --- | --- |
| Access from Azure Data Lake Store | Yes | Yes | Yes | Yes | Yes |
| Query from Azure Storage | Yes | Yes | Yes | Yes | Yes |
| Query from external relational stores | Yes | No | Yes | No | No |

### Scalability capabilities

| | Azure Data Lake Analytics | SQL Data Warehouse | HDInsight with Spark | HDInsight with Hive | HDInsight with Hive LLAP |
| --- | --- | --- | --- | --- | --- |
| Scale-out granularity  | Per job | Per cluster | Per cluster | Per cluster | Per cluster |
| Fast scale out (less than 1 minute) | Yes | Yes | No | No | No |
| In-memory caching of data | No | Yes | Yes | No | Yes | 

### Security capabilities

| | Azure Data Lake Analytics | SQL Data Warehouse | HDInsight with Spark | Apache Hive on HDInsight | Hive LLAP on HDInsight |
| --- | --- | --- | --- | --- | --- |
| Authentication  | Azure Active Directory (Azure AD) | SQL / Azure AD | No | local / Azure AD <sup>1</sup> | local / Azure AD <sup>1</sup> |
| Authorization  | Yes | Yes| No | Yes <sup>1</sup> | Yes <sup>1</sup> |
| Auditing  | Yes | Yes | No | Yes <sup>1</sup> | Yes <sup>1</sup> |
| Data encryption at rest | Yes| Yes <sup>2</sup> | Yes | Yes | Yes |
| Row-level security | No | Yes | No | Yes <sup>1</sup> | Yes <sup>1</sup> |
| Supports firewalls | Yes | Yes | Yes | Yes <sup>3</sup> | Yes <sup>3</sup> |
| Dynamic data masking | No | No | No | Yes <sup>1</sup> | Yes <sup>1</sup> |

[1] Requires using a [domain-joined HDInsight cluster](/azure/hdinsight/domain-joined/apache-domain-joined-introduction).

[2] Requires using Transparent Data Encryption (TDE) to encrypt and decrypt your data at rest.

[3] Supported when [used within an Azure Virtual Network](/azure/hdinsight/hdinsight-extend-hadoop-virtual-network).

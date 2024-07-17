---
title: Data lakes
description: Learn about data lake storage repositories, which can hold terabytes and petabytes of data in native, raw format.
author: PRASADA1207
ms.author: prasada
ms.date: 06/14/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories:
  - storage
products:
  - azure-data-lake
  - azure-data-lake-storage
ms.custom:
  - guide
---

# What is a data lake?

A data lake is a storage repository that holds a large amount of data in its native, raw format. Data lake stores are optimized for scaling to terabytes and petabytes of data. The data typically comes from multiple heterogeneous sources, and may be structured, semi-structured, or unstructured. The idea with a data lake is to store everything in its original, untransformed state. This approach differs from a traditional [data warehouse](../relational-data/data-warehousing.yml), which transforms and processes the data at the time of ingestion.

![A diagram that shows the different data lake use cases.](./images/data-lake-use-cases.jpg)

The following are key data lake use cases:
- Cloud and IoT data movement
- Big data processing
- Analytics
- Reporting
- On-premises data movement

Advantages of a data lake:

- Data is never thrown away, because the data is stored in its raw format. This is especially useful in a big data environment, when you may not know in advance what insights are available from the data.
- Users can explore the data and create their own queries.
- May be faster than traditional extract, transform, load (ETL) tools.
- More flexible than a data warehouse, because it can store unstructured and semi-structured data.

A complete data lake solution consists of both storage and processing. Data lake storage is designed for fault-tolerance, infinite scalability, and high-throughput ingestion of data with varying shapes and sizes. Data lake processing involves one or more processing engines built with these goals in mind, and can operate on data stored in a data lake at scale.

## When to use a data lake ?

Typical uses for a data lake include data exploration, data analytics, and machine learning.

A data lake can also act as the data source for a data warehouse. With this approach, the raw data is ingested into the data lake and then transformed into a structured queryable format. Typically this transformation uses an [extract, load, transform (ELT)](../relational-data/etl.yml#extract-load-and-transform-elt) (extract, load, transform) pipeline, where the data is ingested and transformed in place. Source data that is already relational may go directly into the data warehouse, using an ETL process, skipping the data lake.

Data lake stores are often used in event streaming or IoT scenarios, because they can persist large amounts of relational and nonrelational data without transformation or schema definition. They are built to handle high volumes of small writes at low latency, and are optimized for massive throughput.

The following table compares data lakes and data warehouses:

![A table that compares data lake features with data warehouse features.](./images/comparing-data-lakes-and-data-warehouses.png)


## Challenges

- Managing Large Volumes of Data: Handling vast amounts of raw and unstructured data can be complex and resource-intensive, requiring robust infrastructure and tools.
- Potential Bottlenecks: Data processing can experience delays and inefficiencies, especially when dealing with high volumes and diverse data types.
- Risk of Data Corruption: Without proper data validation and monitoring, there’s a risk of data corruption, which can compromise the integrity of the data lake.
- Quality Control Issues: Ensuring data quality is challenging due to the variety of data sources and formats, necessitating stringent data governance practices.
- Performance Issues: Query performance can degrade as the data lake grows, making it essential to optimize storage and processing strategies.


## Technology choices

When building a comprehensive data lake solution on Azure, consider the following technologies:

- [Azure Data Lake Storage Gen2](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction): It combines Azure Blob Storage with Data Lake capabilities, offering Hadoop-compatible access, hierarchical namespace, and enhanced security for efficient big data analytics.
- [Azure Databricks](https://learn.microsoft.com/en-us/azure/databricks/introduction/): A unified platform for processing, storing, analyzing, and monetizing data, supporting ETL, dashboards, security, data exploration, machine learning, and generative AI.
- [Azure Synapse Analytics](https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is): A unified experience to ingest, explore, prepare, manage, and serve data for immediate BI and machine learning needs. It integrates deeply with Azure Data Lake, enabling querying and analyzing large datasets efficiently.
- [Azure Data Factory](https://learn.microsoft.com/en-us/azure/data-factory/introduction): A cloud-based data integration service that allows you to create data-driven workflows for orchestrating and automating data movement and transformation.
- [Azure HD Insight](https://learn.microsoft.com/en-us/azure/hdinsight/hdinsight-overview): It is a managed cluster platform that makes it easy to run big data frameworks like Apache Spark, Apache Hive, LLAP, Apache Kafka, Apache Hadoop, and others in your Azure environment.



## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 - [Avijit Prasad](https://www.linkedin.com/in/avijit-prasad%F0%9F%8C%90-96768a42) | Cloud Consultant

## Next steps
-	[What is One Lake ?](https://learn.microsoft.com/en-us/fabric/onelake/onelake-overview)
- [What is Microsoft Fabric?](https://learn.microsoft.com/en-us/fabric/get-started/microsoft-fabric-overview)
- [Introduction to Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction)
- [Azure Data Lake Analytics Documentation](/azure/data-lake-analytics)
- [Introduction to Azure Data Lake Storage (training module)](/training/modules/intro-to-azure-data-lake-storage)

## Related resources
-	[Integration of Hadoop and Azure Data Lake Store](https://learn.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-use-data-lake-storage-gen2)
- [Connect to Azure Data Lake Storage Gen2 and Blob Storage](https://learn.microsoft.com/en-us/azure/databricks/connect/storage/azure-storage)
- [Load data into Azure Data Lake Storage Gen2 with Azure Data Factory](https://learn.microsoft.com/en-us/azure/data-factory/load-azure-data-lake-storage-gen2)
- [Choose an analytical data store in Azure](../technology-choices/analytical-data-stores.md)
- [Query a data lake or lakehouse by using Azure Synapse serverless](../../example-scenario/data/synapse-exploratory-data-analytics.yml)
- [Data management across Azure Data Lake with Microsoft Purview](../../solution-ideas/articles/azure-purview-data-lake-estate-architecture.yml)
- [Modern data warehouse for small and medium business](../../example-scenario/data/small-medium-data-warehouse.yml)

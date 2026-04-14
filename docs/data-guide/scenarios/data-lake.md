---
title: What Is a Data Lake?
description: Learn about the advantages of using data lake storage repositories, which can store terabytes and petabytes of data in its native, raw format.
author: PRASADA1207
ms.author: prasada
ms.date: 04/08/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# What is a data lake?

A data lake is a storage repository that holds large volumes of data in its native, raw format. Data lakes scale cost effectively to handle terabytes (TB) and petabytes (PB) of data, which makes them suitable for handling massive and diverse datasets. The data typically comes from many different sources and can include structured data like relational tables, semistructured data like JSON, XML, or log files, and unstructured data like images, audio, or video.

Data lakes store all data types in its original, untransformed state and apply transformation only when the data is needed. This approach is known as *schema-on-read*. In contrast, a [data warehouse](../relational-data/data-warehousing.yml) enforces structure and applies transformations as it ingests data. This approach is known as *schema-on-write*.

:::image type="complex" border="false" source="./images/data-lake-use-cases.jpg" alt-text="Diagram that shows data lake use cases." lightbox="./images/data-lake-use-cases.jpg":::
   The diagram includes five use cases for a data lake: data ingestion, big data processing, analytics and machine learning, business intelligence (BI) and reporting, and data archiving. A connecting line points from these sections and merges into an arrow that points to the data lake.
:::image-end:::

Common data lake use cases include:

- **Data ingestion and movement:** Collect and consolidate data from cloud services, Internet of Things (IoT) devices, on-premises systems, and streaming sources into a single repository.

- **Big data processing:** Handle high-volume, high-velocity data at scale by using distributed processing frameworks.

- **Analytics and machine learning:** Support exploratory analysis, advanced analytics, and AI model training and fine-tuning on large, diverse datasets.

- **Business intelligence (BI) and reporting:** Enable dashboards and reports by integrating curated subsets of lake data into warehouses or BI tools.

- **Data archiving and compliance:** Store historical or raw datasets for long-term retention, auditability, and regulatory compliance.

## Advantages of a data lake

- **Retains raw data for future use:** Data lakes store data in its raw format, which ensures long-term availability for future use. This approach is especially valuable in big data environments where the potential insights from the data might not be known in advance. You can also archive data as needed without losing its raw state.

- **Self-service exploration:** Analysts and data scientists can query data directly to experiment and discover patterns.

- **Flexible data support:** Unlike warehouses that require structured formats, data lakes handle structured, semistructured, and unstructured data natively.

- **Scalable and performant:** In distributed architectures, data lakes ingest and process data in parallel at scale. They frequently outperform traditional extract, transform, and load (ETL) pipelines in high-volume workloads. Gain these performance benefits through:

  - **Parallelism:** Distributed compute engines like Apache Spark partition data and run transformations across many nodes at the same time. Traditional ETL frameworks often depend on sequential or limited multithreaded processing.

  - **Scalability:** Distributed systems scale horizontally by elastically adding compute and storage nodes as needed. Traditional ETL pipelines usually depend on scaling a single host vertically, which meets resource limits quickly.

- **Foundation for hybrid architectures:** Data lakes often coexist with warehouses in a lakehouse approach that combines raw storage with structured query performance.

A modern data lake solution comprises two core components:

- **Storage:** Provides durability, fault tolerance, infinite scalability, and high-throughput ingestion of diverse data types.

- **Processing:** Engines like Spark in Azure Databricks and Microsoft Fabric power these solutions. These engines support large-scale transformations, analytics, and machine learning.

Mature solutions incorporate metadata management, security, and governance to maintain data quality, discoverability, and compliance.

## Typical data lake architecture

A typical Azure data lake architecture consists of multiple layers that organize data as it moves through the ingestion, transformation, and consumption stages.

Common layers include:

- **Raw (bronze) layer:** Stores ingested data in its original format with minimal transformation.

- **Cleansed (silver) layer:** Contains validated and transformed data optimized for analytics and machine learning workloads.

- **Curated (gold) layer:** Stores aggregated and business-ready datasets that teams use for reporting, dashboards, and downstream data applications.

This layered design, known as the *medallion architecture*, improves data quality, governance, and performance.

## When to use a data lake

We recommend that you use a data lake for exploratory analytics, advanced data science, and machine learning workloads. Data lakes retain data in raw form and support schema-on-read, so teams can experiment with diverse data types and uncover insights that traditional warehouses might not capture.

### Data lake as a source for data warehouses

A data lake can function as the upstream source for a data warehouse, where raw data is ingested from source systems and loaded into the lake. Modern warehouses like the Fabric Warehouse use built-in massively parallel processing (MPP) SQL engines to transform that raw data into a structured format through [extract, load, transform (ELT)](../relational-data/etl.yml#extract-load-and-transform-elt). This approach differs from traditional ETL pipelines, where the ETL engine extracts and transforms data before it loads it into the warehouse. Both approaches provide flexibility depending on the use case. They balance data quality, performance, and resource utilization and ensure that the warehouse is optimized for analytics.

### Event streaming and IoT scenarios

Data lakes are effective for event streaming and IoT use cases, where high-velocity data must persist at scale without upfront schema limits. Data lakes can ingest and store relational and nonrelational event streams, handle high volumes of small writes with low latency, and support massive parallel throughput. These capabilities make data lakes well suited for applications like real-time monitoring, predictive maintenance, and anomaly detection.

The following table compares data lakes and data warehouses.

| Feature | Data lake | Data warehouse |
|---|---|---|
| Data type | Raw, unstructured, semistructured, and structured | Structured and curated data organized into relational schemas |
| Query performance | Query performance depends on processing engines, and transformation might occur at query time (schema-on-read) | Optimized for high-performance analytical queries on structured data (schema-on-write) |
| Latency | Higher latency because of processing at query time | Low latency with preprocessed, structured data |
| Data transformation stage | Transformation occurs at query time, which affects overall processing time | Transformation occurs during the ETL or ELT process |
| Scalability | Highly scalable and cost effective for large volumes of diverse data | Scalable but more expensive, especially at large scale |
| Cost | Lower storage cost because of low-cost storage for raw data. Compute costs are incurred when data is processed or queried. | Higher cost because of dedicated compute and performance optimizations for analytical workloads |
| Use case fit | Best for big data, machine learning, and exploratory analytics. In medallion architectures, teams use the gold layer for reporting. | Ideal for BI, reporting, and structured data analysis |

## Challenges of data lakes

- **Scalability and complexity:** The management of PB of raw, unstructured, and semistructured data requires robust infrastructure, distributed processing, and careful cost management.

- **Processing bottlenecks:** As data volume and diversity increase, transformation and query workloads can introduce latency, which requires careful pipeline design and workload orchestration.

- **Data integrity risks:** Without strong validation and monitoring, errors or incomplete ingestions can compromise the reliability of the lake's contents.

- **Data quality and governance:** Diverse sources and formats complicate standards enforcement. Metadata management, cataloging, and governance frameworks are critical.

- **Performance at scale:** Query performance and storage efficiency can degrade as the lake grows, which requires optimization strategies like partitioning, indexing, and caching.

- **Security and access control:** Ensuring appropriate permissions and auditing across diverse datasets to prevent misuse of sensitive data requires planning.

- **Discoverability:** Without proper cataloging, lakes can devolve into *data swamps* where valuable information is present but inaccessible or misunderstood.

## Technology choices

When you build a comprehensive data lake solution on Azure, consider the following technologies:

- [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) combines Azure Blob Storage with data lake capabilities to provide Apache Hadoop-compatible access, hierarchical namespace capabilities, and enhanced security for efficient big data analytics. It handles massive amounts of structured, semistructured, and unstructured data.

- [Azure Databricks](/azure/databricks/introduction/) is a cloud-based data analytics and machine learning platform that combines the best of Spark with deep integration into the Azure ecosystem. It provides a collaborative environment where data engineers, data scientists, and analysts can ingest, process, analyze, and model large volumes of data.

- [Azure Data Factory](/azure/data-factory/introduction) is a cloud-based data integration and ETL service. You can use it to move, transform, and orchestrate data workflows across different sources, whether in the cloud or on-premises.

- [Fabric](/fabric/fundamentals/microsoft-fabric-overview) is an end-to-end data analytics platform that unifies data movement, data science, real-time analytics, and BI into a single software as a service (SaaS) experience.

  Each Fabric tenant is automatically provisioned with a single logical data lake known as *OneLake*. OneLake is built on Data Lake Storage and provides a unified storage layer that can handle structured and unstructured data.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Avijit Prasad](https://www.linkedin.com/in/avijit-prasad-96768a42/) | Cloud Consultant

Other contributor:

- [Raphael Sayegh](https://www.linkedin.com/in/raphael-sayegh/) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is OneLake?](/fabric/onelake/onelake-overview)
- [Introduction to Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction)
- [Training: Introduction to Data Lake Storage](/training/modules/introduction-to-azure-data-lake-storage/)
- [Use Data Lake Storage with Azure HDInsight clusters](/azure/hdinsight/hdinsight-hadoop-use-data-lake-storage-gen2)
- [Use Azure managed identities in Unity Catalog to access storage](/azure/databricks/connect/unity-catalog/cloud-storage/azure-managed-identities)
- [Load data into Data Lake Storage by using Data Factory](/azure/data-factory/load-azure-data-lake-storage-gen2)
- [Connect to Data Lake Storage in Microsoft Purview](/purview/register-scan-adls-gen2)
- [Best practices for using Data Lake Storage](/azure/storage/blobs/data-lake-storage-best-practices)

## Related resources

- [Choose an analytical data store in Azure](../technology-choices/analytical-data-stores.md)
- [Modern data warehouse for small and medium businesses](../../example-scenario/data/small-medium-data-warehouse.yml)

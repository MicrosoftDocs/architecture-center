---
title: Choose a batch processing technology
description: Compare technology choices for big data batch processing in Azure, including key selection criteria and a capability matrix.
author: pratimav0420
ms.author: prvalava
ms.reviewer: tozimmergren
ms.date: 07/31/2024
ms.topic: conceptual
ms.subservice: architecture-guide
---

# Choose a batch processing technology in Azure

Big data solutions often consist of discrete batch processing tasks that contribute to the overall data processing solution. You can use batch processing for workloads that don't require immediate access to insights. Batch processing can complement real-time processing requirements. You can also use batch processing to balance complexity and reduce cost for your overall implementation.

The fundamental requirement of batch processing engines is to scale out computations to handle a large volume of data. Unlike real-time processing, batch processing has latencies, or the time between data ingestion and computing a result, of minutes or hours.

## Choose a technology for batch processing

Microsoft offers several services that you can use to do batch processing.

### Microsoft Fabric

[Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview) is an all-in-one analytics and data platform for organizations. It's a software as a service offering that simplifies how you provision, manage, and govern an end-to-end analytics solution. Fabric handles data movement, processing, ingestion, transformation, and reporting. Fabric features that you use for batch processing include data engineering, data warehouses, lakehouses, and Apache Spark processing. Azure Data Factory in Fabric also supports lakehouses. To simplify and accelerate development, you can enable AI-driven Copilot.

- *Languages:* R, Python, Java, Scala, and SQL

- *Security:* Managed virtual network and OneLake role-based access control (RBAC)
- *Primary storage:* OneLake, which has shortcuts and mirroring options
- *Spark:* A prehydrated starter pool and a custom Spark pool with predefined node sizes

### Azure Synapse Analytics

[Azure Synapse Analytics](/azure/synapse-analytics/overview-what-is) is an enterprise analytics service that brings together both SQL and Spark technologies under a single construct of a workspace. Azure Synapse Analytics simplifies security, governance, and management. Every workspace has integrated data pipelines that you can use to author end-to-end workflows. You can also provision a dedicated SQL pool for large-scale analytics, a serverless SQL endpoint that you can use to directly query the lake, and a Spark runtime for distributed data processing.

- *Languages:* Python, Java, Scala, and SQL

- *Security:* Managed virtual network, RBAC and access control, and storage access control lists on Azure Data Lake Storage
- *Primary storage:* Data Lake Storage and also integrates with other sources
- *Spark:* Custom Spark configuration setup with predefined node sizes

### Azure Databricks

[Azure Databricks](/azure/azure-databricks/) is a Spark-based analytics platform. It features rich and premium Spark features that are built on top of open-source Spark. Azure Databricks is a Microsoft service that integrates with the rest of the Azure services. It features extra configurations for Spark cluster deployments. And Unity Catalog helps simplify the governance of Azure Databricks Spark objects.

- *Languages:* R, Python, Java, Scala, and Spark SQL.

- *Security:* User authentication with Microsoft Entra ID.
- *Primary storage:* Built-in integration with Azure Blob Storage, Data Lake Storage, Azure Synapse Analytics, and other services. For more information, see [Data sources](/azure/databricks/data/data-sources/).

Other benefits include:
- Web-based [notebooks](/azure/databricks/notebooks/) for collaboration and data exploration.

- Fast cluster start times, automatic termination, and autoscaling.
- Support for [GPU-enabled clusters](/azure/databricks/clusters/gpu).

## Key selection criteria

To choose your technology for batch processing, consider the following questions:

- Do you want a managed service, or do you want to manage your own servers?

- Do you want to author batch processing logic declaratively or imperatively?

- Do you perform batch processing in bursts? If yes, consider options that provide the ability to automatically terminate a cluster or that have pricing models for each batch job.

- Do you need to query relational data stores along with your batch processing, for example to look up reference data? If yes, consider options that provide the ability to query external relational stores.

## Capability matrix

The following tables summarize key differences in capabilities between services.

### General capabilities

| Capability | Fabric | Azure Synapse Analytics | Azure Databricks |
| --- | --- | --- | --- |
| Software as a service | Yes<sup>1</sup> | No | No |
| Managed service | No | Yes | Yes |
| Relational data store | Yes | Yes | Yes |
| Pricing model | Capacity units | SQL pool or cluster hour | Azure Databricks unit <sup>2</sup> and cluster hour |

[1] Assigned Fabric capacity.

[2] An Azure Databricks unit is the processing capability per hour.

### Other capabilities

| Capability | Fabric | Azure Synapse Analytics | Azure Databricks |
| --- | --- | --- | --- |
| Autoscaling | No | No | Yes |
| Scale-out granularity  | Per Fabric SKU | Per cluster or per SQL pool | Per cluster |
| In-memory caching of data | No | Yes | Yes |
| Query from external relational stores | Yes | No | Yes |
| Authentication  | Microsoft Entra ID | SQL or Microsoft Entra ID |Microsoft Entra ID |
| Auditing  | Yes | Yes | Yes |
| Row-level security | Yes | Yes <sup>1</sup> | Yes |
| Supports firewalls | Yes | Yes | Yes |
| Dynamic data masking | Yes | Yes | Yes |

[1] Filter predicates only. For more information, see [Row-level security](/sql/relational-databases/security/row-level-security).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect
- [Pratima Valavala](https://www.linkedin.com/in/pratimavalavala/) | Principal Solutions Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Fabric?](/fabric/get-started/microsoft-fabric-overview)
- [Fabric decision guide](/fabric/get-started/decision-guide-pipeline-dataflow-spark)
- [Training: Introduction to Azure Synapse Analytics](/training/modules/introduction-azure-synapse-analytics)
- [What is Azure HDInsight?](/azure/hdinsight/hdinsight-overview)
- [What is Azure Databricks?](/azure/databricks/introduction)

## Related resources

- [Analytics architecture design](../../solution-ideas/articles/analytics-start-here.yml)
- [Choose an analytical data store in Azure](analytical-data-stores.md)
- [Choose a data analytics technology in Azure](analysis-visualizations-reporting.md)
- [Analytics end-to-end with Azure Synapse Analytics](../../example-scenario/dataplate2e/data-platform-end-to-end.yml)

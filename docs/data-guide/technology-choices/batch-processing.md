---
title: Choose a batch processing technology
description: Compare technology choices for big data batch processing in Azure, including key selection criteria and a capability matrix.
titleSuffix: Azure Architecture Center
author: pratimav0420
ms.author: prvalava
categories: azure
ms.reviewer: tozimmergren
ms.date: 07/30/2024
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

Big data solutions are often composed of discrete batch processing tasks that contribute to the overall data processing solution. Batch processing is suitable for workloads that do not require immediate access to insights and can be complementary to real-time processing requirements. It is also a great option for balancing complexity and cost for the overall implementation. 

The fundamental requirement of such batch processing engines is to scale out computations to handle a large volume of data. Unlike real-time processing, batch processing is expected to have latencies (the time between data ingestion and computing a result) that measure in minutes to hours.

## Technology choices for batch processing

### Microsoft Fabric 

[Fabric](/fabric/get-started/microsoft-fabric-overview) Microsoft Fabric is an all-in-one analytics and data platform designed for enterprises seeking a unified solution. It is a software as a service (SAAS) offering that simplifies provisioning, management and governance required for running an end-to-end analytics solution. It covers data movement, processing, ingestion, transformation and reporting. In the context of batch processing Fabric services include Data Engineering, Data Factory with builtin Lakehouse, Data warehouse and spark processing experiences. It is also augmented by AI-driven Copilot experiences that can ease and speed up development. 

- Languages: R, Python, Java, Scala, SQL 

- Security: Managed V-net, OneLake RBAC 

- Primary Storage: One Lake, Shortcuts/Mirroring options available 

- Spark: Prehydrated Starter pool and Custom Spark pool with predefined node sizes 

### Azure Synapse Analytics

[Azure Synapse Analytics](/azure/synapse-analytics/overview-what-is) is an enterprise analytics service that brings together both SQL and Spark technologies under a single construct of a workspace that simplifies security, governance and management. Every workspace is enabled with an integrated data pipelines experience that developers can author end to end workflows. You can also provision a Dedicated SQL pool (formerly SQLDW) for large scale analytics, a Serverless SQL end point that you can use to directly query the lake and a Spark runtime for distributed data processing. 

- Languages: Python, Java, Scala, and SQL
- Security: Managed V-net, RBAC and access control, Storage ACLs on ADLS Gen2 
- Primary Storage: ADLS Gen2, Integrates with other sources 
- Spark: Custom Spark configuration setup with predefined node sizes 

### Azure Databricks

[Azure Databricks](/azure/azure-databricks/) is an Apache Spark-based analytics platform. It features rich and premium Spark features built on top of open-source Spark and can be considered as a premium spark offering enabling on Azure. It is offered as first party service with very tight integration with the rest of the Azure services. It features additional configurations for Spark cluster deployment and Unity Catalog that helps simplify governance of the Databricks spark objects. 

- Languages: R, Python, Java, Scala, Spark SQL
- Fast cluster start times, autotermination, autoscaling.
- Built-in integration with Azure Blob Storage, Azure Data Lake Storage, Azure Synapse, and other services. For more information, see [Data Sources](/azure/databricks/data/data-sources/).
- User authentication with Microsoft Entra ID.
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

| Capability | Microsoft Fabric | Azure Synapse Analytics | Azure Databricks |
| --- | --- | --- | --- |
| Is software as a service | Yes<sup>1</sup> | No | No |
| Is managed service | No | Yes | Yes |
| Relational data store | Yes | Yes | Yes |
| Pricing model | Capacity units | By SQL pool/cluster hour | Databricks unit (DBU)<sup>2</sup> + cluster hour |

[1] Assigned Fabric capacity.

[2] A Databricks unit (DBU) is a unit of processing capability per hour.

### Other capabilities

| Capability | Microsoft Fabric | Azure Synapse Analytics | Azure Databricks |
| --- | --- | --- | --- |
| Autoscaling | No | No | Yes |
| Scale-out granularity  | Per Fabric SKU | Per cluster/per SQL pool | Per cluster |
| In-memory caching of data | No | Yes | Yes |
| Query from external relational stores | Yes | No | Yes |
| Authentication  | Microsoft Entra ID | SQL / Microsoft Entra ID |Microsoft Entra ID |
| Auditing  | Yes | Yes | Yes |
| Row-level security | Yes | Yes <sup>1</sup> | Yes |
| Supports firewalls | Yes | Yes | Yes |
| Dynamic data masking | Yes | Yes | Yes |

[1] Filter predicates only. See [Row-Level Security](/sql/relational-databases/security/row-level-security)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect
- [Pratima Valavala](https://www.linkedin.com/in/pratimavalavala/) | Principal Solutions Architect 

## Next steps

- [What is Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview) 
- [Fabric Decision guide](/fabric/get-started/decision-guide-pipeline-dataflow-spark) 
- [Introduction to Azure Synapse Analytics](/training/modules/introduction-azure-synapse-analytics)
- [What is HdInsight](/azure/hdinsight/hdinsight-overview) 
- [What is Azure Databricks?](/azure/databricks/introduction)

## Related resources

- [Analytics architecture design](../../solution-ideas/articles/analytics-start-here.yml)
- [Choose an analytical data store in Azure](analytical-data-stores.md)
- [Choose a data analytics technology in Azure](analysis-visualizations-reporting.md)
- [Analytics end-to-end with Azure Synapse](../../example-scenario/dataplate2e/data-platform-end-to-end.yml)

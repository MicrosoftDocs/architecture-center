---
title: Choose a Data Pipeline Orchestration Technology
description: Choose an Azure data pipeline orchestration technology to automate pipeline orchestration, control flow, and data movement workflows.
author: claytonsiemens77
ms.author: pnp
ms.date: 07/25/2022
ms.topic: concept-article
ms.subservice: architecture-guide
---

<!-- cSpell:ignore Oozie SSMS -->

# Choose a data pipeline orchestration technology in Azure

Most big data solutions consist of repeated data processing operations, encapsulated in workflows. A pipeline orchestrator helps automate these workflows. It can schedule jobs, run workflows, and coordinate dependencies among tasks.

## Options for data pipeline orchestration

In Azure, the following services and tools meet the core requirements for pipeline orchestration, control flow, and data movement:

- [Azure Data Factory](/azure/data-factory)
- [Apache Oozie on Azure HDInsight](/azure/hdinsight/hdinsight-use-oozie-linux-mac)
- [SQL Server Integration Services (SSIS)](/sql/integration-services/sql-server-integration-services)
- [Fabric Data Factory](/fabric/data-factory/data-factory-overview)

You can use these services and tools independently or combine them to create a hybrid solution. For example, the integration runtime (IR) in Data Factory V2 can natively run SSIS packages in a managed Azure compute environment. These services share some functionality, but they have a few key differences.

## Key selection criteria

To narrow your options, consider the following factors:

- Determine whether you need big data capabilities to move and transform your data. These capabilities typically use multiple gigabytes (GBs) to terabytes (TBs) of data. If you require these capabilities, choose a service designed for big data.

- Identify whether you need a managed service that can operate at scale. If you do, choose a cloud-based service that doesn't depend on your local processing power.

- Check whether you have data sources located on-premises. If you do, choose a service that supports both cloud and on-premises data sources or destinations.

- Check whether you store source data in blob storage on a Hadoop Distributed File System (HDFS). If you do, choose a service that supports Hive queries.

- Determine whether you need advanced orchestration for complex extract, transform, and load (ETL) workflows across multiple data sources. If you do, choose Fabric Data Factory because it provides a set of connectors, pipeline orchestration, and integration with both on-premises and cloud environments. It's ideal for enterprise-scale data movement and transformation.

## Capability matrix

The following tables summarize the key differences in capabilities.

### General capabilities

| Capability | Data Factory | SSIS | Oozie on HDInsight | Fabric Data Factory |
| --- | --- | --- | --- | --- |
| Managed | Yes | No | Yes | Yes |
| Cloud-based | Yes | No (local) | Yes | Yes |
| Prerequisite | Azure subscription | SQL Server  | Azure subscription, HDInsight cluster | Fabric-enabled workspace |
| Management tools | Azure portal, PowerShell, CLI, .NET SDK | SQL Server Management Studio (SSMS), PowerShell | Bash shell, Oozie REST API, Oozie web user interface (UI) | Copy job, mirroring, pipeline activities, Dataflow Gen2 |
| Pricing | Pay per usage | Licensing, extra features add cost | Included with HDInsight cluster | Included with Fabric capacity |

### Pipeline capabilities

| Capability | Data Factory | SSIS | Oozie on HDInsight | Fabric Data Factory |
| --- | --- | --- | --- | --- |
| Copy data | Yes | Yes | Yes | Yes |
| Custom transformations | Yes | Yes | Yes (MapReduce, Pig, and Hive jobs) | Yes |
| Azure Machine Learning scoring | Yes | Yes (with scripting) | No | Yes (via integration) |
| HDInsight on-demand | Yes | No | No | No |
| Azure Batch | Yes | No | No | Yes |
| Pig, Hive, and MapReduce | Yes | No | Yes | Yes |
| Apache Spark | Yes | No | No | Yes |
| Run SSIS packages | Yes | Yes | No | Yes |
| Control flow | Yes | Yes | Yes | Yes |
| Access on-premises data | Yes | Yes | No | Yes |

### Scalability capabilities

| Capability | Data Factory | SSIS | Oozie on HDInsight | Fabric Data Factory |
| --- | --- | --- | --- | --- |
| Scale up | Yes | No | No | Yes |
| Scale out | Yes | No | Yes (by adding worker nodes to cluster) | Yes |
| Optimized for big data | Yes | No | Yes | Yes |

## Alternative approach

In addition to traditional batch-based orchestration, your platform can also use real-time intelligence through the [Fabric Real-Time Intelligence feature](/fabric/real-time-intelligence/event-streams/create-manage-an-eventstream). This approach enables continuous streaming data ingestion, in-flight transformation, and event-driven workflows so that you can respond instantly as data arrives. It supports high-value scenarios such as Internet of Things (IoT) telemetry processing, fraud detection, and operational monitoring.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Pipelines and activities in Fabric Data Factory](/fabric/data-factory/data-factory-overview)
- [Provision the Azure-SSIS integration runtime in Data Factory](/azure/data-factory/tutorial-deploy-ssis-packages-azure)
- [Use Oozie to run a workflow on HDInsight](/azure/hdinsight/hdinsight-use-oozie-linux-mac)
- [Medallion architecture in Fabric Real-Time Intelligence](https://blog.fabric.microsoft.com/blog/21597)

## Related resource

- [DataOps for the modern data warehouse](../../databases/architecture/dataops-mdw.yml)

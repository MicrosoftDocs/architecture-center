---
title: Choose a data pipeline orchestration technology
description: Choose an Azure data pipeline orchestration technology to automate pipeline orchestration, control flow, and data movement workflows.
author: claytonsiemens77
ms.author: pnp
ms.date: 07/25/2022
ms.topic: conceptual
ms.subservice: architecture-guide
---

<!-- cSpell:ignore Oozie HDFS SSMS -->

# Choose a data pipeline orchestration technology in Azure

Most big data solutions consist of repeated data processing operations, encapsulated in workflows. A pipeline orchestrator is a tool that helps to automate these workflows. An orchestrator can schedule jobs, execute workflows, and coordinate dependencies among tasks.

## What are your options for data pipeline orchestration?

In Azure, the following services and tools will meet the core requirements for pipeline orchestration, control flow, and data movement:

- [Azure Data Factory](/azure/data-factory/)
- [Oozie on HDInsight](/azure/hdinsight/hdinsight-use-oozie-linux-mac)
- [SQL Server Integration Services (SSIS)](/sql/integration-services/sql-server-integration-services)
- [Data Factory in Microsoft Fabric](/fabric/data-factory/data-factory-overview)

These services and tools can be used independently from one another, or used together to create a hybrid solution. For example, the Integration Runtime (IR) in Azure Data Factory V2 can natively execute SSIS packages in a managed Azure compute environment. While there is some overlap in functionality between these services, there are a few key differences.

## Key Selection Criteria

To narrow the choices, start by answering these questions:

- Do you need big data capabilities for moving and transforming your data? Usually this means multi-gigabytes to terabytes of data. If yes, then narrow your options to those that best suited for big data.

- Do you require a managed service that can operate at scale? If yes, select one of the cloud-based services that aren't limited by your local processing power.

- Are some of your data sources located on-premises? If yes, look for options that can work with both cloud and on-premises data sources or destinations.

- Is your source data stored in Blob storage on an HDFS filesystem? If so, choose an option that supports Hive queries.

- Do you need advanced orchestration for complex ETL workflows across multiple data sources? If yes, choose Data Factory in Microsoft Fabric, as it provides a rich set of connectors, pipeline orchestration, and integration with both on-premises and cloud environments, making it ideal for enterprise-scale data movement and transformation.

## Capability matrix

The following tables summarize the key differences in capabilities.

### General capabilities

| Capability | Azure Data Factory | SQL Server Integration Services (SSIS) | Oozie on HDInsight | Data Factory in Microsoft Fabric |
| --- | --- | --- | --- | --- |
| Managed | Yes | No | Yes | Yes |
| Cloud-based | Yes | No (local) | Yes | Yes |
| Prerequisite | Azure Subscription | SQL Server  | Azure Subscription, HDInsight cluster | Microsoft Fabric-enabled workspace |
| Management tools | Azure Portal, PowerShell, CLI, .NET SDK | SSMS, PowerShell | Bash shell, Oozie REST API, Oozie web UI | Copy job, Mirroring, Pipeline activities, Dataflow Gen2 |
| Pricing | Pay per usage | Licensing / pay for features | No additional charge on top of running the HDInsight cluster | Included with Fabric capacity |

### Pipeline capabilities

| Capability | Azure Data Factory | SQL Server Integration Services (SSIS) | Oozie on HDInsight | Data Factory in Microsoft Fabric |
| --- | --- | --- | --- | --- |
| Copy data | Yes | Yes | Yes | Yes |
| Custom transformations | Yes | Yes | Yes (MapReduce, Pig, and Hive jobs) | Yes |
| Azure Machine Learning scoring | Yes | Yes (with scripting) | No | Yes (via integration) |
| HDInsight On-Demand | Yes | No | No | No |
| Azure Batch | Yes | No | No | Yes |
| Pig, Hive, MapReduce | Yes | No | Yes | Yes |
| Spark | Yes | No | No | Yes |
| Execute SSIS Package | Yes | Yes | No | Yes |
| Control flow | Yes | Yes | Yes | Yes |
| Access on-premises data | Yes | Yes | No | Yes |

### Scalability capabilities

| Capability | Azure Data Factory | SQL Server Integration Services (SSIS) | Oozie on HDInsight | Data Factory in Microsoft Fabric |
| --- | --- | --- | --- | --- |
| Scale up | Yes | No | No | Yes |
| Scale out | Yes | No | Yes (by adding worker nodes to cluster) | Yes |
| Optimized for big data | Yes | No | Yes | Yes |


## Alternative approach

In addition to traditional batch-based orchestration, your platform can also use real-time intelligence through [Microsoft Fabric’s Real-Time Intelligence](/fabric/real-time-intelligence/event-streams/create-manage-an-eventstream) service. This approach enables continuous streaming data ingestion, in-flight transformation, and event-driven workflows, allowing organizations to respond instantly as data arrives. It supports high-value scenarios such as IoT telemetry processing, fraud detection, and operational monitoring.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect

## Next steps

- [Pipelines and activities in Data Factory in Microsoft Fabric](/fabric/data-factory/data-factory-overview)
- [Provision the Azure-SSIS integration runtime in Azure Data Factory](/azure/data-factory/tutorial-deploy-ssis-packages-azure)
- [Oozie on HDInsight](/azure/hdinsight/hdinsight-use-oozie-linux-mac)

## Related resources

- [DataOps for the modern data warehouse](../../databases/architecture/dataops-mdw.yml)
- [Medallion Architecture in Fabric Real-Time Intelligence](https://blog.fabric.microsoft.com/blog/21597)

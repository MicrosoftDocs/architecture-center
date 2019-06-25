---
title: Choosing a data pipeline orchestration technology
description: 
author: zoinerTejada
ms.date: 02/12/2018
ms.topic: guide
ms.service: architecture-center
ms.subservice: cloud-fundamentals
---

# Choosing a data pipeline orchestration technology in Azure

Most big data solutions consist of repeated data processing operations, encapsulated in workflows. A pipeline orchestrator is a tool that helps to automate these workflows. An orchestrator can schedule jobs, execute workflows, and coordinate dependencies among tasks.

## What are your options for data pipeline orchestration?

In Azure, the following services and tools will meet the core requirements for pipeline orchestration, control flow, and data movement:

- [Azure Data Factory](/azure/data-factory/)
- [Oozie on HDInsight](/azure/hdinsight/hdinsight-use-oozie-linux-mac)
- [SQL Server Integration Services (SSIS)](/sql/integration-services/sql-server-integration-services)

These services and tools can be used independently from one another, or used together to create a hybrid solution. For example, the Integration Runtime (IR) in Azure Data Factory V2 can natively execute SSIS packages in a managed Azure compute environment. While there is some overlap in functionality between these services, there are a few key differences.

## Key Selection Criteria

To narrow the choices, start by answering these questions:

- Do you need big data capabilities for moving and transforming your data? Usually this means multi-gigabytes to terabytes of data. If yes, then narrow your options to those that best suited for big data.

- Do you require a managed service that can operate at scale? If yes, select one of the cloud-based services that aren't limited by your local processing power.

- Are some of your data sources located on-premises? If yes, look for options that can work with both cloud and on-premises data sources or destinations.

- Is your source data stored in Blob storage on an HDFS filesystem? If so, choose an option that supports Hive queries.

## Capability matrix

The following tables summarize the key differences in capabilities.

### General capabilities

| Capability | Azure Data Factory | SQL Server Integration Services (SSIS) | Oozie on HDInsight
| --- | --- | --- | --- |
| Managed | Yes | No | Yes |
| Cloud-based | Yes | No (local) | Yes |
| Prerequisite | Azure Subscription | SQL Server  | Azure Subscription, HDInsight cluster |
| Management tools | Azure Portal, PowerShell, CLI, .NET SDK | SSMS, PowerShell | Bash shell, Oozie REST API, Oozie web UI |
| Pricing | Pay per usage | Licensing / pay for features | No additional charge on top of running the HDInsight cluster |

### Pipeline capabilities

| Capability | Azure Data Factory | SQL Server Integration Services (SSIS) | Oozie on HDInsight
| --- | --- | --- | --- |
| Copy data | Yes | Yes | Yes |
| Custom transformations | Yes | Yes | Yes (MapReduce, Pig, and Hive jobs) |
| Azure Machine Learning scoring | Yes | Yes (with scripting) | No |
| HDInsight On-Demand | Yes | No | No |
| Azure Batch | Yes | No | No |
| Pig, Hive, MapReduce | Yes | No | Yes |
| Spark | Yes | No | No |
| Execute SSIS Package | Yes | Yes | No |
| Control flow | Yes | Yes | Yes |
| Access on-premises data | Yes | Yes | No |

### Scalability capabilities

| Capability | Azure Data Factory | SQL Server Integration Services (SSIS) | Oozie on HDInsight
| --- | --- | --- | --- |
| Scale up | Yes | No | No |
| Scale out | Yes | No | Yes (by adding worker nodes to cluster) |
| Optimized for big data | Yes | No | Yes |

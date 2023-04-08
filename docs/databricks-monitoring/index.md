---
title: Monitor Azure Databricks
description: Learn how to extend the core monitoring functionality of Azure Databricks to send Apache Spark metrics, events, and logging information to Azure Monitor.
author: martinekuan
ms.author: architectures
ms.date: 07/25/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
  - management-and-governance
  - databases
categories:
  - management-and-governance
  - databases
products:
  - azure-databricks
  - azure-monitor
---

# Monitoring Azure Databricks

[Azure Databricks](/azure/azure-databricks) is a fast, powerful [Apache Spark](https://spark.apache.org)–based analytics service that makes it easy to rapidly develop and deploy big data analytics and artificial intelligence (AI) solutions. Many users take advantage of the simplicity of notebooks in their Azure Databricks solutions. For users that require more robust computing options, Azure Databricks supports the distributed execution of custom application code.

Monitoring is a critical part of any production-level solution, and Azure Databricks offers robust functionality for monitoring custom application metrics, streaming query events, and application log messages. Azure Databricks can send this monitoring data to different logging services.

The following articles show how to send monitoring data from Azure Databricks to [Azure Monitor](/azure/azure-monitor/overview), the monitoring data platform for Azure.

- [Send Azure Databricks application logs to Azure Monitor](./application-logs.md)
- [Use dashboards to visualize Azure Databricks metrics](./dashboards.md)
- [Troubleshoot performance bottlenecks](./performance-troubleshooting.md)

The code library that accompanies these articles extends the core monitoring functionality of Azure Databricks to send Spark metrics, events, and logging information to Azure Monitor.

The audience for these articles and the accompanying code library are Apache Spark and Azure Databricks solution developers. The code must be built into Java Archive (JAR) files and then deployed to an Azure Databricks cluster. The code is a combination of [Scala](https://www.scala-lang.org) and Java, with a corresponding set of [Maven](https://maven.apache.org) project object model (POM) files to build the output JAR files. Understanding of Java, Scala, and Maven are recommended as prerequisites.

## Next steps

Start by building the code library and deploying it to your Azure Databricks cluster.

> [!div class="nextstepaction"]
> [Send Azure Databricks application logs to Azure Monitor](./application-logs.md)

## Related resources

- [Modern analytics architecture with Azure Databricks](../solution-ideas/articles/azure-databricks-modern-analytics-architecture-experiment.yml)
- [Ingestion, ETL, and stream processing pipelines with Azure Databricks](../solution-ideas/articles/ingest-etl-stream-with-adb.yml)
- [Data science and machine learning with Azure Databricks](../solution-ideas/articles/azure-databricks-data-science-machine-learning.yml)
- [Orchestrate MLOps by using Azure Databricks](../reference-architectures/ai/orchestrate-mlops-azure-databricks.yml)

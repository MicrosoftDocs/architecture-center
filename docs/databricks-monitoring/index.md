---
title: Monitoring Azure Databricks with Azure Monitor
description: A scala library to enable monitoring of Azure Databricks in Azure Log Analytics
author: petertaylor9999
ms.date: 03/26/2019
ms.service: architecture-center
ms.subservice: reference-architecture
---

# Monitoring Azure Databricks

[Azure Databricks](/azure/azure-databricks/) is a fast, powerful [Apache Spark](https://spark.apache.org/)–based analytics service that makes it easy to rapidly develop and deploy big data analytics and artificial intelligence (AI) solutions. Many users take advantage of the simplicity of notebooks in their Azure Databricks solutions. For users that require more robust computing options, Azure Databricks supports the distributed execution of custom application code.

Monitoring is a critical part of any production-level solution, and Azure Databricks offers robust functionality for monitoring custom application metrics, streaming query events, and application log messages. Azure Databricks can send this monitoring data to different logging services.

The following articles show how to send monitoring data from Azure Databricks to [Azure Monitor](/azure/azure-monitor/overview), the monitoring data platform for Azure. 

- [Send Azure Databricks application logs to Azure Monitor](./application-logs.md)
- [Use dashboards to visualize Azure Databricks metrics](./dashboards.md)
- [Troubleshoot performance bottlenecks](./performance-troubleshooting.md)

The code library that accompanies these articles extends the core monitoring functionality of Azure Databricks to send Spark metrics, events, and logging information to Azure Monitor.

The audience for these articles and the accompanying code library are Apache Spark and Azure Databricks solution developers. The code must be built into Java Archive (JAR) files and then deployed to an Azure Databricks cluster. The code is a combination of [Scala](https://www.scala-lang.org/) and Java, with a corresponding set of [Maven](https://maven.apache.org) project object model (POM) files to build the output JAR files. Understanding of Java, Scala, and Maven are recommended as prerequisites.

## Next steps

Start by building the code library and deploying it to your Azure Databricks cluster.

> [!div class="nextstepaction"]
> [Send Azure Databricks application logs to Azure Monitor](./application-logs.md)
---
title: Azure and Power Platform scenarios
description: Learn about architectures and solutions that use Azure together with Microsoft Power Platform. 
author: martinekuan
ms.author: robbag
ms.date: 07/28/2022
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
products:
  - power-platform
  - power-apps
  - power-automate
  - power-bi
  - power-virtual-agents
categories:
  - ai-machine-learning
  - analytics
  - integration
  - web
  - devops
  - databases
  - iot
  - storage
ms.custom: fcp
---

# Azure and Power Platform scenarios

[Power Platform](https://powerplatform.microsoft.com) provides tools for analyzing data, building solutions, automating processes, and creating virtual agents. Power Platform includes these products:

- [Power BI](https://powerbi.microsoft.com). Enable your employees to generate data-driven insights.
- [Power Apps](https://powerapps.microsoft.com). Enable anyone to build custom apps.
- [Power Automate](https://powerautomate.microsoft.com). Give everyone the ability to automate organizational processes.
- [Microsoft Copilot Studio (formerly Power Virtual Agents)](https://powervirtualagents.microsoft.com). Build chatbots to engage with your customers and employees—no coding required.

This article provides summaries of solutions and architectures that use Power Platform together with Azure services. 

Anyone can be a developer with Power Platform. Check out this short video to learn more:
<br><br>

> [!VIDEO https://www.youtube.com/embed/2dscy89ks9I]

*Apache®, Apache Ignite, Ignite, and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Solutions across Azure and Power Platform

The following articles provide detailed analysis of solutions that feature integration between Azure and Power Platform.

### Power Platform (general)

|Architecture|Summary|Technology focus|
|--|--|--|
|[Citizen AI with Power Platform](../example-scenario/ai/citizen-ai-power-platform.yml)|Learn how to use Azure Machine Learning and Power Platform to quickly create a machine learning proof of concept and a production version.|AI|
|[Modern data warehouse for small and medium businesses](../example-scenario/data/small-medium-data-warehouse.yml)|Use Azure Synapse Analytics, Azure SQL Database, and Azure Data Lake Storage to modernize legacy and on-premises data. This solution integrates easily with Power Platform.| Analytics|

[Browse all our Power Platform solutions](/azure/architecture/browse/?products=power-platform).

### Power Apps

|Architecture|Summary|Technology focus|
|--|--|--|
[Eventual consistency between multiple Power Apps instances](/azure/architecture/guide/power-platform/eventual-consistency)|Handle dependent data in a resilient way in Power Apps.| Web|
[Web and mobile front ends](../solution-ideas/articles/front-end.yml) |Accelerate development by using a visual designer. Use Azure Functions for low-latency processing and Power Apps and Power Automate for out-of-the-box connectors.|Integration|

[Browse all our Power Apps solutions](/azure/architecture/browse/?expanded=power-platform&products=power-apps).

### Power Automate

|Architecture|Summary|Technology focus|
|--|--|--|
|[Extract text from objects using Power Automate and AI Builder](../example-scenario/ai/extract-object-text.yml)|Use AI Builder and Azure Form Recognizer in a Power Automate workflow to extract text from images. The text can be used for indexing and retrieval.| AI|
|[Web and mobile front ends](../solution-ideas/articles/front-end.yml)|Accelerate development by using a visual designer. Use Azure Functions for low-latency processing and Power Apps and Power Automate for out-of-the-box connectors. |Integration|

[Browse all our Power Automate solutions](/azure/architecture/browse/?expanded=power-platform&products=power-automate).

### Power BI

|Architecture|Summary|Technology focus|
|--|--|--|
|[Data analysis for regulated industries](/azure/architecture/example-scenario/data/data-warehouse)|Learn about an architecture that you can use for data analysis workloads in regulated industries. The architecture includes ETL/ELT and Power BI.| Analytics|
|[Intelligent apps using Azure Database for PostgreSQL](../databases/idea/intelligent-apps-using-azure-database-for-postgresql.yml)|Use Azure Database for PostgreSQL to develop sophisticated machine learning and visualization apps that provide analytics and information that you can act on. Power BI provides visualization and data analysis.| Databases|
|[Loan charge-off prediction with HDInsight Spark](../solution-ideas/articles/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.yml)|Learn how lending institutions can use Azure HDInsight and machine learning to predict the likelihood of loans getting charged off. Power BI provides a visualization dashboard.| Databases|
|[Modern analytics architecture with Azure Databricks](../solution-ideas/articles/azure-databricks-modern-analytics-architecture.yml)|Create a modern analytics architecture that uses Azure Databricks, Azure Data Lake Storage, Power BI, and other Azure services. Unify data, analytics, and AI workloads at any scale.| Analytics|
|[Project 15 Open Platform](../solution-ideas/articles/project-15-iot-sustainability.yml)|Use Internet of Things technologies with the Project 15 Open Platform to accelerate innovation in species tracking, ecosystem monitoring, and other areas. Power BI provides visualization.| IoT|

[Browse all our Power BI solutions](/azure/architecture/browse/?expanded=power-platform&products=power-bi).

## Related resources

- [Browse all our Power Platform architectures](/azure/architecture/browse/?products=power-platform)
- [Azure and Microsoft 365 scenarios](/azure/architecture/solutions/microsoft-365-scenarios)
- [Azure and Dynamics 365 scenarios](/azure/architecture/solutions/dynamics-365-scenarios)

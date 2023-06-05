---
title: DataOps architecture design
description: DataOps is a lifecycle approach to data analytics that uses agile practices to deliver high-quality data.
author: martinekuan
ms.author: architectures
ms.date: 07/25/2022
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
categories:
  - analytics
  - management-and-governance
  - databases
products:
  - azure-data-factory
  - azure-databricks
  - azure-synapse-analytics
  - power-bi
  - microsoft-purview
ms.custom:
  - overview
  - fcp
---

# DataOps architecture design

DataOps is a lifecycle approach to data analytics. It uses agile practices to orchestrate tools, code, and infrastructure to quickly deliver high-quality data with improved security. When you implement and streamline DataOps processes, your business can easily deliver cost effective analytical insights. DataOps helps you adopt advanced data techniques that can uncover insights and new opportunities.

There are many tools and capabilities to implement DataOps processes, like:

- [Apache NiFi](https://nifi.apache.org/). Apache NiFi provides a system for processing and distributing data.
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory). Azure Data Factory is a cloud-based ETL and data integration service. It enables you to create data-driven workflows to orchestrate data movement and transform data at scale.
- [Azure Databricks](https://azure.microsoft.com/services/databricks). Use Azure Databricks to unlock insights from all your data and build AI solutions. You can also quickly set up your Apache Spark environment, autoscale, and collaborate on shared projects.
- [Azure Data Lake](https://azure.microsoft.com/services/storage/data-lake-storage). Use a single data storage platform to optimize costs and protect your data with encryption at rest and advanced threat protection.
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics). A limitless analytics service that brings together data integration, enterprise data warehousing, and big data analytics.
- [Microsoft Purview](https://azure.microsoft.com/services/purview). Microsoft Purview is a unified data governance solution that helps you manage and govern your on-premises, multicloud, and software-as-a-service (SaaS) data.
- [Power BI](https://powerbi.microsoft.com). Unify data from many sources to create interactive, immersive dashboards and reports that provide actionable insights and drive business results.

*Apache®, Apache Spark®, Apache NiFi®, and NiFi® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Introduction to DataOps on Azure

If you're new to DataOps, the best place to start is Microsoft Learn. This free online platform offers videos, tutorials, and hands-on learning for various products and services.

The following resources can help you learn about the core services for DataOps:

- [Integrate data with Azure Data Factory or Azure Synapse Pipeline](/training/modules/data-integration-azure-data-factory)
- [Data engineering with Azure Databricks](/training/paths/data-engineer-azure-databricks)
- [Introduction to Azure Synapse Analytics](/training/modules/introduction-azure-synapse-analytics)
- [Analyze and optimize data warehouse storage in Azure Synapse Analytics](/training/modules/analyze-optimize-data-warehouse-storage-azure-synapse-analytics)
- [Read and write data in Azure Databricks](/training/modules/read-write-data-azure-databricks)
- [Integrate Azure Databricks with Azure Synapse](/training/modules/integrate-azure-databricks-other-azure-services)
- [Turn insight into action by combining SAP and other data](/training/modules/turn-insight-into-action-combine-sap-other-data)
- [Examine data visualizations with Power BI](/training/modules/examine-data-visualizations-power-bi)

## Path to production

To help you get started with DataOps production, consider these resources:

- Assess your DataOps process by using the [DataOps checklist](../checklist/data-ops.md).
- Get help choosing the right data solution with [Choose a data analytics and reporting technology in Azure](./technology-choices/analysis-visualizations-reporting.md).
- Start building your data storage system with [Build a scalable system for massive data](./scenarios/build-scalable-database-solutions-azure-services.md).

## Best practices

Depending on the DataOps technology you use, see the following best practices resources:

- [NiFi System Administrator’s Guide](https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html)
- [Microsoft Purview accounts architectures and best practices](/azure/purview/concept-best-practices-accounts)
- [Continuous integration and delivery in Azure Data Factory](/azure/data-factory/continuous-integration-delivery)
- [Repos for Git integration](/azure/databricks/repos)
- [Deploying and Managing Power BI Premium Capacities](/power-bi/guidance/whitepaper-powerbi-premium-deployment)
- [Continuous integration and delivery for an Azure Synapse Analytics workspace](/azure/synapse-analytics/cicd/continuous-integration-delivery)

You can also learn about the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

## Specific implementations

To learn about scenario-specific architectures, see the solutions in the following areas.

### Data governance

You can integrate Profisee data management with Azure Purview to build a foundation for data governance and management.

> [!div class="nextstepaction"]
> [Data governance with Profisee and Azure Purview](../reference-architectures/data/profisee-master-data-management-purview.yml)

### Modern data warehouse

Apply DevOps principles to data pipelines built according to the modern data warehouse (MDW) architectural pattern with Microsoft Azure.

> [!div class="nextstepaction"]
> [DataOps for the modern data warehouse](../example-scenario/data-warehouse/dataops-mdw.yml)

### Modernize a mainframe

Modernize IBM mainframe and midrange data and use a data-first approach to migrate this data to Azure.

> [!div class="nextstepaction"]
> [Modernize mainframe and midrange data](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure)

### Change data directly from Power BI

Provide data write-back functionality for Power BI reports. You can update data in Power BI, and then push the changes back to your data source.

> [!div class="nextstepaction"]
> [Power BI data write-back with Power Apps and Power Automate](../example-scenario/data/power-bi-write-back-power-apps.yml)

## Stay current with DataOps

Refer to [Azure updates](https://azure.microsoft.com/updates/?category=databases,devops,integration) to keep current with Azure technology related to DataOps.

## Additional resources

DataOps uses many tools and techniques to deliver data. The following resources can provide you with help on your DataOps journey.

### Example solutions

- [Azure Data Explorer monitoring](../solution-ideas/articles/monitor-azure-data-explorer.yml)
- [Data analysis workloads for regulated industries](/azure/architecture/example-scenario/data/data-warehouse)
- [Data management across Azure Data Lake with Azure Purview](../solution-ideas/articles/azure-purview-data-lake-estate-architecture.yml)
- [Hybrid ETL with Azure Data Factory](../example-scenario/data/hybrid-etl-with-adf.yml)
- [Ingestion, ETL, and stream processing pipelines with Azure Databricks](../solution-ideas/articles/ingest-etl-stream-with-adb.yml)

### Amazon Web Services (AWS) or Google Cloud professionals

These articles provide service mapping and comparison between Azure and other cloud services. This reference can help you ramp up quickly on Azure.

- [AWS to Azure services comparison](../aws-professional/services.md#big-data-and-analytics)
- [Google Cloud to Azure services comparison](../gcp-professional/services.md#big-data-and-analytics)
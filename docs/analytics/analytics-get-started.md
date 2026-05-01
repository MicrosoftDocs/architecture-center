---
title: Get Started with Analytics Architecture Design
description: Get an overview of Azure analytics technologies, guidance, solution ideas, and reference architectures.
ms.author: anaharris
author: anaharris-ms
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: category-get-started
ms.date: 01/26/2026
ai-usage: ai-assisted
---

# Get started with analytics architecture design

Organizations rely on the compute, storage, and analytical power of Azure to scale, stream, predict, and view their data. Analytics solutions transform volumes of data into useful business intelligence (BI), such as reports and visualizations, and inventive AI, such as forecasts based on machine learning. Azure offers a range of cloud-based analytics tools for organizations that are new to analytics and organizations that need to expand their implementation. Analytics solutions help organizations to use data at scale. You can use a [big data architecture](../guide/architecture-styles/big-data.md) or an [IoT architecture](../guide/architecture-styles/big-data.md#iot-architecture) to process raw data and then move it to an analytical data store. This data store becomes a single source of truth that can power insightful analytics solutions.

## Architecture

:::image type="complex" border="false" source="media/analytics-get-started-diagram.svg" alt-text="Diagram that shows the analytics solution journey on Azure." lightbox="media/analytics-get-started-diagram.svg":::
   Diagram that shows four columns, labeled Learn, Assign roles, Choose storage, and Choose tech. Two tiles appear in the Learn column, labeled Azure data services and Data modeling. Three user groups appear in the Assign roles column: data analysts, data engineers, and self-service users. One square tile labeled Analytical data store appears in the Choose storage column. Four functions appear in the Choose tech column: Report and visualize, Stream data, Make predictions, and Scale analytics.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/analytics-get-started-diagram.vsdx) of this architecture.*
  
The previous diagram demonstrates a typical basic or baseline analytics implementation. For real-world solutions that you can build in Azure, see [analytics architectures](#analytics-architectures).

## Explore analytics architectures and guides

The articles in this section include fully developed architectures that you can deploy in Azure and expand to production-grade solutions and guides. These articles can help you decide how to use analytics technologies in Azure. Solution ideas demonstrate implementation patterns and possibilities to consider as you plan your analytics proof-of-concept (POC) development.

### Analytics guides

**Technology choices:** The following articles help you evaluate and select the best analytics technologies for your workload requirements.

- [Choose a data analytics and reporting service](../data-guide/technology-choices/analysis-visualizations-reporting.md): Compare options for data analysis and visualization in Azure.

- [Choose a batch processing service](../data-guide/technology-choices/batch-processing.md): Evaluate batch processing technologies for big data workloads.

- [Choose a stream processing service](../data-guide/technology-choices/stream-processing.md): Compare stream processing technologies for real-time analytics.

- [Choose an analytical data store](../data-guide/technology-choices/analytical-data-stores.md): Guidance on analytical data store selection.

- [Choose an analytical data store in Microsoft Fabric](../data-guide/technology-choices/fabric-analytical-data-stores.md): Guidance on data stores in Fabric.

**Disaster recovery (DR):** The following articles provide guidance about DR strategies for Azure data platforms.

- [Overview](../data-guide/disaster-recovery/dr-for-azure-data-platform-overview.md): Overview of DR strategies for Azure data platforms.

- [Architecture](../data-guide/disaster-recovery/dr-for-azure-data-platform-architecture.md): Architecture patterns for DR in Azure data platforms.

- [Scenario details](../data-guide/disaster-recovery/dr-for-azure-data-platform-scenario-details.md): Detailed scenarios for DR implementation.

- [Recommendations](../data-guide/disaster-recovery/dr-for-azure-data-platform-recommendations.md): Best practice recommendations for DR.

### Analytics architectures

The following production-ready architectures demonstrate end-to-end analytics solutions that you can deploy and customize:

- [Analytics end-to-end with Fabric](../example-scenario/dataplate2e/data-platform-end-to-end.yml): Build a modern analytics platform by using Fabric.

- [Data warehousing and analytics](../example-scenario/data/data-warehouse.yml): Integrate data from multiple sources into a unified analytics platform.

- [Use Fabric to design an enterprise BI solution](../example-scenario/analytics/enterprise-bi-microsoft-fabric.yml): Design an enterprise BI solution by using Fabric.

- [Near real-time lakehouse data processing](../example-scenario/data/real-time-lakehouse-data-processing.yml): Use Azure Synapse Analytics and Azure Data Lake Storage for near real-time data lakehouse processing.

- [Real-time sync of MongoDB Atlas to Azure Synapse Analytics](../example-scenario/analytics/sync-mongodb-atlas-fabric-analytics.yml): Synchronize MongoDB Atlas data to Azure Synapse Analytics in real time.

- [Stream processing with Azure Databricks](../reference-architectures/data/stream-processing-databricks.yml): Create an end-to-end stream processing pipeline by using Azure Databricks.

- [Stream processing with Azure Stream Analytics](../reference-architectures/data/stream-processing-stream-analytics.yml): Build a stream processing pipeline that ingests data, correlates records, and calculates rolling averages.

- [Modern data warehouse for small and medium businesses](../example-scenario/data/small-medium-data-warehouse.yml): Build a modern data warehouse solution designed for small and medium businesses.

### Analytics solution ideas

The following solution ideas demonstrate implementation patterns and possibilities to explore:

- [Ingestion, extract, transform, and load (ETL), and stream processing pipelines with Azure Databricks](../solution-ideas/articles/ingest-etl-stream-with-adb.yml): Create ETL pipelines for batch and streaming data to simplify data lake ingestion.

- [Modern analytics architecture with Azure Databricks](../solution-ideas/articles/azure-databricks-modern-analytics-architecture.yml): Collect, process, analyze, and visualize data by using a modern data architecture.

- [Modern data platform for small and medium businesses](../solution-ideas/articles/small-medium-modern-data-platform.yml): Build a modern data platform architecture for small and medium businesses by using Fabric and Azure Databricks.

- [Real-time analytics with Azure Data Explorer](../solution-ideas/articles/analytics-service-bus.yml): Analyze data in real time by using Azure Data Explorer and Azure Service Bus.

## Learn about analytics on Azure

[Microsoft Learn](/training/?WT.mc_id=learnaka) provides free online training resources for Azure analytics technologies. The platform offers videos, tutorials, and interactive labs for specific products and services, along with learning paths organized by job role.

The following resources provide foundational knowledge for analytics implementations on Azure:

- [Browse Azure data articles](/training/browse/?products=azure&filter-products=data&terms=data)
- [Introduction to Microsoft Azure Data core data concepts](/training/paths/azure-data-fundamentals-explore-core-data-concepts/)
- [Get started with Fabric](/training/paths/get-started-fabric/)

### Learning paths by role

- **Data analyst:** [Get started with Microsoft data analytics](/training/paths/data-analytics-microsoft)
- **Data engineer:** [Implement a data analytics solution with Azure Databricks](/training/paths/data-engineer-azure-databricks/)
- **Data scientist:** [Build machine learning solutions by using Azure Databricks](/training/paths/build-operate-machine-learning-solutions-azure-databricks/)

## Organizational readiness

Organizations that start their cloud adoption can use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) to access proven guidance that accelerates cloud adoption. For more information on cloud-scale analytics, see [Cloud-scale analytics](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics).

To help ensure the quality of your analytics solution on Azure, follow the [Azure Well-Architected Framework](/azure/well-architected/). The Well-Architected Framework provides prescriptive guidance for organizations that seek architectural excellence and describes how to design, configure, and monitor cost-optimized Azure solutions. For data workload guidance aligned to the Well-Architected Framework pillars, see [Well-Architected Framework for data workloads](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/well-architected-framework).

## Best practices

Best practices in analytics ensure that solutions are scalable, reliable, cost-efficient, and secure.

### Data analytics

To use analytics on Azure, you need to decide how to [store your data](../data-guide/technology-choices/analytical-data-stores.md). Then you can choose the best [data analytics technology](../data-guide/technology-choices/analysis-visualizations-reporting.md) for your scenario.

Consider the following factors:

- **Data storage:** Choose between data lakes, data warehouses, and lakehouses based on your data structure and query patterns. For more information about the database solutions that power analytics workloads, see [Databases architecture design](../databases/database-get-started.md).

- **Processing model:** Determine whether batch processing, stream processing, or a combination best fits your workload requirements.

- **Analytics tools:** Select BI and AI technologies that meet your team's skills and business needs.

### Trustworthy data

For high-quality analytics, you need robust, trustworthy data. [Information security](/azure/well-architected/security) practices help ensure that your data is protected in transit and at rest. Access to your data must also be secure. To help produce trustworthy data, consider the following practices and controls:

- [Governance policies](/azure/well-architected/security/establish-baseline): Define clear data ownership, classification, and access policies.

- [Identity and access management](/azure/well-architected/security/identity-access): Implement role-based access control and least-privilege principles.

- [Network security controls](/azure/well-architected/security/networking): Protect data flows between services and prevent unauthorized access.

- [Data protection](/azure/well-architected/security/encryption): Encrypt data at rest and in transit.

At the platform level, the following [big data best practices](../guide/architecture-styles/big-data.md#best-practices) contribute to trustworthy analytics on Azure:

- **Orchestrate data ingestion:** Use an Azure Data Factory or Fabric pipelines-supported data workflow or pipeline solution.

- **Process data in place:** Use a distributed data store, which is a big data approach that supports larger volumes of data and a wider range of formats.

- **Scrub sensitive data early:** To avoid accidental storage in your data lake, remove or mask sensitive data as part of the ingestion workflow.

- **Consider total cost:** Balance the per-unit cost of the required compute nodes against the per-minute cost to run a job on those nodes.

- **Create a unified data lake:** Combine storage for files in multiple formats, whether structured, semi-structured, or unstructured. Use Data Lake Storage as your single centralized source. For more information, see [BI solution architecture in the Center of Excellence](/power-bi/guidance/center-of-excellence-business-intelligence-solution-architecture).

## Stay current with analytics

Azure analytics services evolve to address modern data challenges. Stay informed about the latest [updates and features](https://azure.microsoft.com/updates/).

To stay current with key analytics services, see the following articles:

- [What's new in Fabric](/fabric/fundamentals/whats-new?)
- [Azure Databricks release notes](/azure/databricks/release-notes/)
- [What's new in Azure Data Explorer](/azure/data-explorer/whats-new)
- [What's new in Power BI](/power-bi/fundamentals/whats-new)

## Other resources

The Analytics category covers a range of solutions. The following resources can help you discover more about Azure.

### Hybrid and multicloud

Most organizations need a hybrid approach to analytics because their data is hosted both on-premises and in the cloud. Organizations typically [extend on-premises analytics solutions to the cloud](/azure/cloud-adoption-framework/scenarios/hybrid/strategy). To connect environments, organizations must [choose a hybrid network architecture](/azure/architecture/reference-architectures/hybrid-networking/index).

Review the following key hybrid analytics scenarios:

- [Modernize mainframe and midrange data](../example-scenario/mainframe/modernize-mainframe-data-to-azure.yml): Integrate legacy data sources with modern analytics platforms.

- [Unified hybrid and multicloud operations](../databases/guide/hybrid-on-premises-and-cloud.md): Connect on-premises databases to cloud analytics.

- [Tutorial: Deploy Stream Analytics as an IoT Edge module](/azure/iot-edge/tutorial-deploy-stream-analytics): Process data at the edge and aggregate insights in the cloud.

### Real-time analytics

Real-time analytics enables organizations to act on data as it arrives. The following resources can help you get started with real-time analytics on Azure:

- [Real-time analytics on big data architecture](../solution-ideas/articles/real-time-analytics.yml): Process and analyze streaming data at scale.

- [IoT analytics with Azure Data Explorer](../solution-ideas/articles/iot-azure-data-explorer.yml): Analyze IoT personal data in real time.

- [Stream processing with Stream Analytics](../reference-architectures/data/stream-processing-stream-analytics.yml): Build serverless streaming solutions.

- [Create a modern analytics architecture by using Azure Databricks](../solution-ideas/articles/azure-databricks-modern-analytics-architecture.yml): Discover enterprise-grade analytics by using Apache Spark.
- 
-For more analytics examples, see the [Azure Architecture Center](../browse/index.yml?azure_categories=analytics)

## Amazon Web Services (AWS) or Google Cloud professionals

To help you get started quickly, the following articles compare Azure analytics options to other cloud services:

- [Relational database technologies on Azure and AWS](../aws-professional/databases.md)
- [Google Cloud to Azure services comparison](../gcp-professional/services.md)
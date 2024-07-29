This example workload illustrates a greenfield solution to build a robust, scalable data platform using the lakehouse design paradigm on Microsoft Fabric. Microsoft Fabric is a cutting-edge platform that seamlessly integrates data storage, processing, and analytics. Unlike traditional data warehouses, which often involve complex migrations and costly transformations, a greenfield lakehouse provides a clean slate for designing an efficient, future-proof data ecosystem.

## Who may benefit from this architecure

The greenfield data lakehouse architecture with Microsoft Fabric is beneficial for a wide range of scenarios including:

- Organisations looking to start fresh, unencumbered by legacy systems, when developing a data platfrom.
- Organisations that anticipate data volumes between 0.5 to 1.5 TB.
- Organisations with a preference for a simple and streamlined pattern that balances cost, complexity, and performance considerations.

## Architecture

:::image type="content" border="false" source="media/small-medium-lakehouse-fabric/small-medium-lakehouse-fabric.png" alt-text="Diagram illustrates a greenfield solution to build a robust, scalable data platform using the lakehouse design paradigm on Microsoft Fabric for SMBs." lightbox="media/small-medium-lakehouse-fabric/small-medium-lakehouse-fabric.png":::

_Download a [Visio file](https://arch-center.azureedge.net/small-medium-lakehouse-fabric.vsdx) of this architecture._

### Workflow

The following demonstrates a standard end-to-end workflow using this design pattern:

#### Cold path - Batch analytics

Data warehouses, which relied on relational SQL semantics, were the conventional approach for historical data analysis. However, this pattern has evolved over time and Lakehouses have emerged as the industry standard for batch data analysis. Lakehouse is built on top of open file formats, and unlike traditional data warehouses, caters for all types of data - structured, semi-structured, and unstructured. The compute layer in Lakehouse is typically built on top of the Apache Spark framework, which has become the preferred engine for processing big data due to its distributed computing capability and high performance.

Fabric offers a native Lakehouse experience based on the open Delta Lake file format and a managed Spark runtime. A Lakehouse implementation typically uses medallion architecture where bronze layer has the raw data, silver layer has the validated and deduplicated data, and the gold layer has highly refined data fit for supporting business facing use cases. This approach is agnostic of organizations and industries. While this is the general approach, organizations can customize it for their specific requirements. Let us explore how we can build a Lakehouse using native Fabric components.

##### 1. Data ingestion using Data Factory

Data factory experience in Fabric has been built leveraging the capabilities of Azure data factory, which is a widely used data integration service in the industry. While data factory in azure mainly provides orchestration capabilities using pipelines, in Fabric, it has pipelines and dataflow.

- Data pipelines enable you to leverage the out-of-the-box rich data orchestration capabilities to compose flexible data workflows that meet your enterprise needs.
- Dataflows enable you to leverage more than 300 transformations in the dataflows designer, letting you transform data using Power query like graphical interface - including smart AI-based data transformations. Dataflows can also write data to native data stores in Fabric - Lakehouse, Warehouse, Azure SQL and Kusto databases.

Depending on your requirements, you can use either or both experiences to build rich metadata driven ingestion framework. You can onboard data from various source systems at a defined schedule or event based triggers.

##### 2. Data transformations

For data preparation and transformation, there are two different approaches. There is Spark notebooks for users who prefer a code-first experience and dataflow for users who prefer a low-code or no-code experience.

Fabric notebook is a primary code item for developing Apache Spark jobs. It's a web-based interactive surface used by data engineers to write code benefiting from rich visualizations and Markdown text. Data engineers write code for data ingestion, data preparation, and data transformation. Data scientists also use notebooks to build machine learning solutions, including creating experiments and models, model tracking, and deployment.

Every workspace in Fabric comes with a Spark starter pool which is leveraged for default spark jobs. With starter pools, you can expect rapid Apache Spark session initialization, typically within 5 to 10 seconds, with no need for manual setup. You also get the flexibility to customize Apache Spark pools according to your specific data engineering requirements. You can size the nodes, autoscale, and dynamically allocate executors based on your Spark job requirements. For spark runtime customizations, you have the option to configure environments. Environment provides flexible configurations for running your Spark jobs (notebooks, Spark job definitions). In an Environment you can configure compute properties, select different runtime, setup library package dependencies based on your workload requirements.

Dataflows Gen2 allows you to extract data from various sources, transform it using a wide range of transformation operations, and load it into a destination. Traditionally, data engineers spend significant time extracting, transforming, and loading data into a consumable format for downstream analytics. The goal of Dataflows Gen2 is to provide an easy, reusable way to perform ETL tasks using Power Query Online. Adding a data destination to your dataflow is optional, and the dataflow preserves all transformation steps. To perform other tasks or load data to a different destination after transformation, create a Data Pipeline and add the Dataflow Gen2 activity to your orchestration.

##### 3. Lakehouse consumers

###### SQL analytics endpoint

A SQL analytics endpoint is a warehouse that is automatically generated from a Lakehouse in Microsoft Fabric. A customer can transition from the "Lake" view of the Lakehouse (which supports data engineering and Apache Spark) to the "SQL" view of the same Lakehouse. You can analyze data in Delta tables using T-SQL language, save functions, generate views, and apply SQL security. The SQL analytics endpoint is read-only, and data can only be modified through the "Lake" view of the Lakehouse using Spark.

###### Spark notebooks

###### Custom APIs

###### Power BI

###### Power Automate

###### M365

#### Hot path - Real-time analytics

##### 4. Speed ingestion

##### 5. RTI components

##### 6. RTI consumers

### Components

The following components are used to enable this solution:

- [Microsoft Fabric](): An end-to-end cloud-based data analytics platform designed for enterprises that offers a unified environment for various data tasks like data ingestion, transformation, analysis, and visualization.

  - [OneLake](https://learn.microsoft.com/fabric/onelake/onelake-overview): The central hub for all your data within Microsoft Fabric. It's designed as an open data lake, meaning it can store data in its native format regardless of structure.

  - [Data Factory](https://learn.microsoft.com/fabric/data-factory/data-factory-overview): A cloud-based ETL and orchestration service for automated data movement and transformation. It allows you to automate data movement and transformation at scale across various data sources.

  - [Data Engineering](https://learn.microsoft.com/fabric/data-engineering/data-engineering-overview): Tools that enable the collection, storage, processing, and analysis of large volumes of data.

  - [Data Science](https://learn.microsoft.com/fabric/data-science/data-science-overview): Tools that empower you to complete end-to-end data science workflows for the purpose of data enrichment and business insights.

  - [Real-Time Intelligence](https://learn.microsoft.com/fabric/real-time-intelligence/overview): Provides stream ingestion and processing capabilities. This allows you to gain insights from constantly flowing data, enabling quicker decision-making based on real-time trends and anomalies.

  - [Power BI](https://learn.microsoft.com/power-bi/fundamentals/power-bi-overview): Business intelligence tool for creating interactive dashboards and reports to visualize data and gain insights.

  - [Copilot](https://learn.microsoft.com/fabric/get-started/copilot-fabric-overview): Allows you to analyze data, generate insights, and create visualizations and reports in Microsoft Fabric and Power BI using natural language.

### Alternatives

Microsoft Fabric offers a robust set of tools, but depending on your specific needs, alternative services within the Azure ecosystem can be leveraged for enhanced functionality.

- [Azure Databricks](https://learn.microsoft.com/azure/databricks/introduction/) could replace or complement the Microsoft Fabric native Data Engineering capabilities. Azure Databricks offers an alternative for large-scale data processing by providing a cloud-based Apache Spark environment. Azure Databricks also extends this by providing common governance across your entire data estate, and capabilities to enable key use cases including data science, data engineering, machine learning, AI, and SQL-based analytics.

- [Azure Machine Learning](https://learn.microsoft.com/azure/machine-learning/overview-what-is-azure-machine-learning) could replace or complement the Microsoft Fabric native Data Science. Azure Machine Learning goes beyond the model experimentation and management capabilities in Microsoft Fabric by adding capabilities to allow you to host models for online inference use-cases, monitor models for drift, and provide capabilities to build custom Generative-AI applications.

## Scenario details

Several scenarios can benefit from this workload:

- Organisations starting fresh without legacy system constraints.
- Businesses needing a simple, cost-effective, and high-performance data platform that addresses reporting, analytics, and machine learning requirements.
- Organisations looking to integrate data from multiple sources for a unified view.

This solution isn't recommended for:

- Teams from a SQL or relational database background with limited skills on Apache Spark.
- Organisations who are migrating from a legacy system or data warehouse to a modern platform.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/).

The following considerations apply to this scenario.

### Availability

Fabric makes commercially reasonable efforts to support zone-redundant availability zones, where resources automatically replicate across zones, without any need for you to set up or configure.

During a zone-wide outage, no action is required during zone recovery. Fabric capabilities in regions listed in [supported regions](https://learn.microsoft.com/en-us/azure/reliability/reliability-fabric#supported-regions) self-heal and rebalance automatically to take advantage of the healthy zone.

### Operations

Microsoft Fabric provides many different components to help you manage your data platform. Each of these experiences support unique operations that can be viewed in the [Microsoft Fabric Capacity Metrics app](https://learn.microsoft.com/en-us/fabric/enterprise/metrics-app). The Microsoft Fabric Capacity Metrics app is designed to provide monitoring capabilities for Microsoft Fabric capacities. Use the app to monitor your capacity consumption and make informed decisions on how to use your capacity resources.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Microsoft fabric offers [capacity reservations](https://learn.microsoft.com/en-us/azure/cost-management-billing/reservations/fabric-capacity) for a given number of capacity units (CUs). Capacity reservations can help you save costs by committing to a reservation for your Fabric capacity usage for a duration of one year.

Other cost optimization considerations include:

- [Data Lake Storage Gen2](https://azure.microsoft.com/pricing/details/storage/data-lake/) pricing depends on the amount of data you store and how often you use the data. The sample pricing includes 1 TB of data stored, with further transactional assumptions. The 1 TB refers to the size of the data lake, not the original legacy database size.
- [Microsoft Fabric](https://azure.microsoft.com/en-us/pricing/details/microsoft-fabric/) pricing is based on Fabric F capacity price or Premium Per Person price. Serverless capacilities would consume CPU and memory from dedicated capacity that was purchased.
- [Event Hubs](https://azure.microsoft.com/pricing/details/event-hubs/) bills based on tier, throughput units provisioned, and ingress traffic received. The example assumes one throughput unit in Standard tier over one million events for a month.

## Contributors

_This article is being updated and maintained by Microsoft. It was originally written by the following contributors._

Principal author:

- [Amit Chandra](https://www.linkedin.com/in/amitchandra2005/) | Cloud Solution Architect
- [Nicholas Moore](https://www.linkedin.com/in/nicholas-moore/) | Cloud Solution Architect]

To see non-public LinkedIn profiles, sign in to LinkedIn.

## Next steps

Consult the relevent documentation to learn more about the different components and how to get started.

- [What is OneLake?](https://learn.microsoft.com/fabric/onelake/onelake-overview)
- [What is Data Factory?](https://learn.microsoft.com/fabric/data-factory/data-factory-overview)
- [What is Data Engineering?](https://learn.microsoft.com/fabric/data-engineering/data-engineering-overview)
- [What is Data science?](https://learn.microsoft.com/fabric/data-science/data-science-overview)
- [What is Real-Time Intelligence?](https://learn.microsoft.com/fabric/real-time-intelligence/overview)
- [What is Power BI?](https://learn.microsoft.com/power-bi/fundamentals/power-bi-overview)
- [Introduction to Copilot in Fabric](https://learn.microsoft.com/fabric/get-started/copilot-fabric-overview)

## Related resources

- Learn more about:
  - [Data lakes](../../data-guide/scenarios/data-lake.md)
  - [Data warehousing and analytics](data-warehouse.yml)
  - [Enterprise business intelligence](/azure/architecture/example-scenario/analytics/enterprise-bi-synapse)

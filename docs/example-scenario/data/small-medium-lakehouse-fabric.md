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

This design reflects the lambda architecture that separates data processing into two layers: a low-latency, high-throughput stream processing layer for real-time analytics, and a high-consistency batch processing layer for historical analysis. The stream processing path ingests and processes data in near real-time, ideal for dashboards and anomaly detection. The batch processing path handles the complete dataset, ensuring data consistency and enabling complex historical analysis. This two-pronged approach offers real-time insights while maintaining a reliable record for later exploration.

#### Cold path - Batch analytics

Data warehouses, which relied on relational SQL semantics, were the conventional approach for historical data analysis. However, this pattern has evolved over time and Lakehouses have emerged as the industry standard for batch data analysis. Lakehouse is built on top of open file formats, and unlike traditional data warehouses, cater for all types of data - structured, semi-structured, and unstructured. The compute layer in Lakehouse is typically built on top of the Apache Spark framework, which has become the preferred engine for processing big data due to its distributed computing capability and high performance. Fabric offers a native Lakehouse experience based on the open Delta Lake file format and a managed Spark runtime.

A Lakehouse implementation typically uses [medallion architecture](https://learn.microsoft.com/en-us/azure/databricks/lakehouse/medallion) where bronze layer has the raw data, silver layer has the validated and deduplicated data, and the gold layer has highly refined data fit for supporting business facing use cases. This approach is agnostic of organizations and industries. While this is the general approach, organizations can customize it for their specific requirements.  Let us explore how we can build a Lakehouse using native Fabric components.


##### 1. Data ingestion using Data Factory

[Data factory](https://learn.microsoft.com/en-us/fabric/data-factory/data-factory-overview) experience in Fabric has been built leveraging the capabilities of Azure data factory, which is a widely used data integration service in the industry. While data factory in azure mainly provides orchestration capabilities using pipelines, in Fabric, it has pipelines and dataflows.

- Data pipelines enable you to leverage out-of-the-box rich data orchestration capabilities to compose flexible data workflows that meet your enterprise needs.
- Dataflows enable you to leverage more than 300 transformations in the dataflows designer, letting you transform data using Power query like graphical interface - including smart AI-based data transformations. Dataflows can also write data to native data stores in Fabric - Lakehouse, Warehouse, Azure SQL and Kusto databases.

Depending on your requirements, you can use either or both experiences to build rich metadata driven ingestion framework. You can onboard data from various source systems at a defined schedule or on event based triggers.

##### 2. Data transformations

For data preparation and transformation, there are two different approaches. There is Spark notebooks for users who prefer a code-first experience and dataflow for users who prefer a low-code or no-code experience.
		
Fabric [noteboo](https://learn.microsoft.com/en-us/fabric/data-engineering/how-to-use-notebook) is a primary code item for developing Apache Spark jobs. It's a web-based interactive surface used by data engineers to write code benefiting from rich visualizations and Markdown text. Data engineers write code for data ingestion, data preparation, and data transformation. Data scientists also use notebooks to build machine learning solutions, including creating experiments and models, model tracking, and deployment.  
		
Every workspace in Fabric comes with a Spark [starter pool](https://learn.microsoft.com/en-us/fabric/data-engineering/configure-starter-pools) which is leveraged for default spark jobs. With starter pools, you can expect rapid Apache Spark session initialization, typically within 5 to 10 seconds, with no need for manual setup. You also get the flexibility to customize Apache Spark pools according to your specific data engineering requirements. You can size the nodes, autoscale, and dynamically allocate executors based on your Spark job requirements. For spark runtime customizations, you have the option to configure [environments](https://learn.microsoft.com/en-us/fabric/data-engineering/create-and-use-environment). In an Environment you can configure compute properties, select different runtime, setup library package dependencies based on your workload requirements.
		
[Dataflows](https://learn.microsoft.com/en-us/fabric/data-factory/create-first-dataflow-gen2) allow you to extract data from various sources, transform it using a wide range of transformation operations, and load it into a destination. Traditionally, data engineers spend significant time extracting, transforming, and loading data into a consumable format for downstream analytics. The goal of Dataflows Gen2 is to provide an easy, reusable way to perform ETL tasks using visual cues in Power Query Online. Adding a data destination to your dataflow is optional, and the dataflow preserves all transformation steps. To perform other tasks or load data to a different destination after transformation, create a Data Pipeline and add the Dataflow Gen2 activity to your pipeline orchestration. 

#### Hot path - Real-time analytics

Real-time data processing is vital for businesses that want to stay agile, make informed decisions quickly, and take advantage of immediate insights to improve operations and customer experiences.
In Fabric, this capability is provided by the real time intelligence service. It comprises of several fabric items bundled together and made discoverable using [Real-Time hub](https://learn.microsoft.com/en-us/fabric/real-time-hub/real-time-hub-overview). It is the single place for all data-in-motion across your entire organization. 

Real-Time Intelligence in Fabric enables analysis and data visualization for event-driven scenarios, streaming data, and data logs. It connects time-based data from various sources using a catalog of no-code connectors and provides an end-to-end solution for data ingestion, transformation, storage, analytics, visualization, tracking, AI, and real-time actions. Even though it's called "real-time," your data doesn't have to be flowing at high rates and volumes. Real-Time Intelligence gives you event-driven, rather than schedule-driven solutions. 

##### 3. Real time ingestion

[Eventstream](https://learn.microsoft.com/en-us/fabric/real-time-intelligence/event-streams/overview?tabs=enhancedcapabilities) is a Fabric item which enables a no-code way to ingest real-time events from various sources and send them to different destinations. They allow data filtering, transformation, aggregation, and routing based on content. They also enable creating new streams from existing ones that can be shared across organization in Real-Time hub. Event streams support multiple data sources and data destinations, including a wide range of connectors to external sources, for example: Apache Kafka clusters, database change data capture feeds, AWS streaming sources (Kinesis), and Google (GCP Pub/Sub).

You create an eventstream, add event data sources to the stream, optionally add transformations to transform the event data, and then route the data to supported [destinations](https://learn.microsoft.com/en-us/fabric/real-time-intelligence/event-streams/overview?tabs=enhancedcapabilities#route-events-to-destinations). One of the supported destinations is a Fabric Lakehouse. This gives you the ability to transform your real-time events before ingesting them into your lakehouse. Real-time events convert into Delta Lake format and then store in the designated lakehouse tables. This pattern enables data warehousing scenarios and historic analysis of your fast moving data.

##### 4. Real time analytics

Within Real time intelligence experience in Fabric, depending on your use cases, there are two typical path ways for streaming data - [Reflex](https://learn.microsoft.com/en-us/fabric/data-activator/data-activator-get-started#create-a-reflex-item) items and [Eventhouses](https://learn.microsoft.com/en-us/fabric/real-time-intelligence/eventhouse)

Reflex is a Fabric item which allows you to react to an occurrence of a data condition, as it happens. That 'reaction' can be a simple alert message via Email/Teams, or it can be invoking a custom action by triggering a Power automate flow. You can also trigger any Fabric item from your reflexes. There are many observability use cases supported by Reflex, one of which is reacting to streaming data as they arrive in Eventstreams.

Eventhouse is a collection of one or more KQL databases. KQL databases are specifically engineered for time-based, streaming events with structured, semi structured, and unstructured data. Data is automatically indexed and partitioned based on ingestion time, giving you incredibly fast and complex analytic querying capabilities, even as the data is streaming in. Data stored in eventhouses can be made available in OneLake for consumption by other Fabric experiences. Data stored in eventhouses can be queried using various code, low-code, or no-code options in Fabric. Data can be queried in native [KQL](https://learn.microsoft.com/en-us/fabric/real-time-intelligence/kusto-query-set?tabs=kql-database)(Kusto Query Language) or using T-SQL in the KQL queryset.

[Real time dashboards](https://learn.microsoft.com/en-us/fabric/real-time-intelligence/dashboard-real-time-create) are designed to provide immediate insights from data streaming into your eventhouses. You can add various types of visuals to the dashboard, such as charts and graphs, and customize them to fit your needs. RT dashboards serve specific use case of quickly identifying trends and anomalies on high velocity data arriving in an eventhouse. This is different from Power BI dashboards which is suitable for enterprise BI reporting workloads.

##### 4. Data Serving

Depending on the user persona, there are various low-code or pro-code options available to consume data from Fabric lakehouses and eventhouses.

###### SQL analytics endpoint

A [SQL analytics endpoint](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-overview#lakehouse-sql-analytics-endpoint) is automatically generated for every Lakehouse in Microsoft Fabric. The SQL analytics endpoint is read-only, and data can only be modified through "Lake" view of the Lakehouse using Spark. You can query data using SQL analytics endpoint directly in Fabric portal, by transitioning from 'Lake' to 'SQL' view of the Lakehouse. Alternatively, you can use the 'SQL connection string' of a Lakehouse to connect using client tools like Power BI, Excel, SQL Server Management Studio etc. This is suitable for data/business analyst personas in a data team.

###### Spark notebooks

Notebooks are a popular way to interact with Lakehouse data. Fabric provides a web-based interactive surface used by data workers to write code leveraging rich visualizations and markdown text. Data engineers write code for data ingestion, data preparation, and data transformation. Data scientists also use notebooks for data exploration, creating ML experiments and models, model tracking, and deployment. This option is suitable for professional data engineers and data scientists.

###### Power BI

Every Lakehouse in Fabric comes with a pre-built default semantic model. It is automatically created when you set up a Lakehouse and load data into it. These models inherit business logic from the Lakehouse, making it easier to create Power BI reports and dashboards directly inside the Lakehouse experience. You can also create custom semantic models on Lakehouse tables based on specific requirements from business. When you create Power BI reports on Lakehouse, you can leverage the [direct lake mode](https://learn.microsoft.com/en-us/fabric/get-started/direct-lake-overview) which does not require you to import data separately. You get in memory performance on your reports without moving your data out of the Lakehouse.

###### Custom APIs

Fabric has a rich API surface across its different items. Microsoft OneLake provides open access to all of Fabric items through existing ADLS Gen2 APIs and SDKs. You can access your data in OneLake through any API, SDK, or tool compatible with ADLS Gen2 just by using a OneLake URI instead. You can upload data to a Lakehouse through Azure Storage Explorer, or read a delta table through a shortcut from Azure Databricks. OneLake also supports the [Azure Blob Filesystem driver](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-abfs-driver) (ABFS) for more compatibility with ADLS Gen2 and Azure Blob Storage. For consuming streaming data in downstream apps, you can push Eventstream data to a custom API endpoint. This streaming output from Fabric can then be consumed using Eventhub or AMQP and Kafka protocols.

###### Power Automate

Power automate flow is a low code application platform which enables you to automate repetitive tasks in an enterprise and also 'act' on your data. Reflex item in Fabric provides Power automate flows as one of the supported destinations. This [integration](https://learn.microsoft.com/en-us/fabric/data-activator/data-activator-trigger-power-automate-flows) unlocks many use cases and allows you to trigger downstream actions using wide range of connectors, both Microsoft native and external systems.

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

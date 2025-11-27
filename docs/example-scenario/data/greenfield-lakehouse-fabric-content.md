This example workload illustrates a greenfield solution for creating a scalable data platform by using Microsoft Fabric and the lakehouse design paradigm. Fabric is a platform that integrates data storage, processing, and analytics. A greenfield lakehouse provides a clean start for designing an efficient, future-proof data ecosystem.

## Architecture

:::image type="complex" border="false" source="media/greenfield-lakehouse-fabric/greenfield-lakehouse-fabric.svg" alt-text="Diagram that illustrates a greenfield solution for building a robust, scalable data platform by using the lakehouse design paradigm on Fabric." lightbox="media/greenfield-lakehouse-fabric/greenfield-lakehouse-fabric.svg":::
   Diagram that shows a greenfield lakehouse architecture on Fabric. External data sources include relational databases (strongly typed, structured), semistructured sources (CSV, logs, JSON, XML), unstructured files (.pdf, .docx, .jpeg), and streams (IoT devices, sensors, gadgets). Azure Data Factory ingests data into the batch processing path, which uses the medallion architecture. In the batch path, arrows labeled notebook and dataflow connect the bronze lakehouse to the silver lakehouse, and the silver lakehouse to the gold lakehouse, which indicates data transformation and refinement. OneLake and Microsoft Purview serve as foundational services. The real-time processing path uses an eventstream to ingest streaming data. A dotted blue arrow from the eventstream points to the bronze lakehouse. Both batch and real-time paths output to the Consume/Serve section, which includes Microsoft 365, Power Automate, Custom API, Power BI, SQL endpoint, and Notebooks.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/greenfield-lakehouse-fabric.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram.

This design reflects the Lambda architecture, which separates data processing into two layers:

- A high-volume batch processing layer that's processed periodically for historical analysis

- A low-latency, high-throughput stream processing layer for real-time analytics

The batch processing path handles the complete dataset, which ensures data consistency and enables complex historical analysis. The stream processing path ingests and processes data in near real-time, which makes it ideal for dashboards and anomaly detection. This two-pronged approach provides real-time insights while maintaining a reliable record for later exploration.

#### Cold path for batch analytics

A data warehouse relies on relational SQL semantics and serves as the conventional approach for historical data analysis. But this pattern has evolved, and a lakehouse now serves as the industry standard for batch data analysis. A lakehouse is built on top of open-source file formats. Unlike a traditional data warehouse, it supports structured, semistructured, and unstructured data. The compute layer in a lakehouse is typically built on top of the Apache Spark framework, which is the preferred engine for processing big data because of its distributed computing capability and high performance. Fabric provides a native lakehouse experience that's based on the open-source Delta Lake file format and a managed Spark runtime.

A lakehouse implementation typically uses the [medallion architecture](/azure/databricks/lakehouse/medallion). In this architecture, the bronze layer contains the raw data, the silver layer contains the validated and deduplicated data, and the gold layer contains highly refined data that's suitable for supporting business-facing use cases. This approach works across all organizations and industries. The medallion architecture is the standard approach, but you can adapt it for your specific needs. This architecture creates a lakehouse by using native Fabric components.

##### Step 1: Data ingestion via Data Factory

The [Azure Data Factory](/fabric/data-factory/data-factory-overview) feature in Fabric provides the capabilities of the Azure Data Factory service, which is a widely used data integration service. The Data Factory service mainly provides orchestration capabilities via pipelines. But the feature in Fabric provides both pipelines and dataflows.

- Data pipelines provide built-in rich data orchestration capabilities for composing flexible data workflows that meet your enterprise needs.

- Dataflows provide a graphical interface, similar to Power Query, that supports over 300 built-in data transformations, including AI-based operations. Use dataflows to write data to native data stores in Fabric, such as lakehouse, warehouse, Azure SQL, and Kusto databases.

Depending on your requirements, you can use either or both of these capabilities to create a metadata-driven ingestion framework. You can onboard data from various source systems on a defined schedule or by using event triggers.

##### Step 2: Data transformation

There are two approaches to data preparation and transformation. If you prefer a code-first experience, you can use Spark notebooks. If you prefer a low-code or no-code experience, you can use dataflows.

Use [Fabric notebooks](/fabric/data-engineering/how-to-use-notebook) to develop Spark jobs. They provide a web-based interactive surface that data engineers use to write code. They also provide visualizations and enable the use of Markdown text. Data engineers write code for data ingestion, data preparation, and data transformation. Data scientists can use notebooks to create, track, and deploy machine learning models.

Every workspace in Fabric includes a Spark [starter pool](/fabric/data-engineering/configure-starter-pools) for default Spark jobs. Starter pools provide rapid Spark session initialization, typically within 5 to 10 seconds, without manual setup. You can also customize Spark pools according to your data engineering requirements. Size the nodes, autoscale, and dynamically allocate executors based on your Spark job requirements. For Spark runtime customizations, use [environments](/fabric/data-engineering/create-and-use-environment) to configure compute properties, select different runtimes, and set up library package dependencies based on your workload requirements.

Use [dataflows](/fabric/data-factory/create-first-dataflow-gen2) to extract data from various sources, transform it by using a wide range of operations, and optionally load it into a destination. Traditionally, data engineers spend significant time extracting, transforming, and loading data into a consumable format for downstream analytics. Dataflow Gen2 provides a reusable way to perform extract, transform, load (ETL) tasks by using visual cues in Power Query Online. The dataflow preserves all transformation steps. To perform other tasks or load data to a different destination after transformation, create a data pipeline and add the Dataflow Gen2 activity to your pipeline orchestration.

#### Hot path for real-time analytics

Real-time data processing helps you make timely decisions and act on recent insights to improve operations and customer experiences. Real-Time Intelligence in Fabric provides this capability. It bundles several Fabric features together and makes them available through the [Real-Time Intelligence hub](/fabric/real-time-hub/real-time-hub-overview). The Real-Time Intelligence hub provides a single place to stream data-in-motion across your organization.

Real-Time Intelligence in Fabric enables analysis and data visualization for event-driven scenarios, streaming data, and data logs. It connects time-based data from various sources by using a catalog of no-code connectors and provides an end-to-end solution for data ingestion, transformation, storage, analytics, visualization, tracking, AI, and real-time actions. The feature name uses the phrase *Real-Time*, but your data doesn't need to stream at high rates and volumes. Real-Time Intelligence provides event-driven solutions rather than schedule-driven solutions.

##### Step 3: Real-time ingestion


An [eventstream](/fabric/real-time-intelligence/event-streams/overview?tabs=enhancedcapabilities) is a Fabric feature that enables a no-code method for ingesting real-time events from various sources and sending them to different destinations. It allows data filtering, transformation, aggregation, and routing based on content. You can also use it to create new streams from existing streams and share them across your organization by using the Real-Time Intelligence hub. Eventstreams support multiple data sources and data destinations. You can use a wide range of connectors to external sources like Apache Kafka clusters, database change data capture (CDC) feeds, Amazon Web Services streaming sources like Kinesis, and Google Cloud Pub/Sub.

You create an eventstream, add event data sources to the stream, optionally add transformations to transform the event data, and then route the data to supported [destinations](/fabric/real-time-intelligence/event-streams/overview?tabs=enhancedcapabilities#route-events-to-destinations). A Fabric lakehouse is one of the supported destinations, so you can transform your real-time events before ingesting them into your lakehouse. Real-time events are converted into Delta Lake format and then stored in the designated lakehouse tables. This pattern enables data warehousing scenarios and historical analysis of your fast-moving data.

##### Step 4: Real-time analytics


To stream data in Real-Time Intelligence, use [Data Activator reflexes](/fabric/data-activator/data-activator-get-started) or [eventhouses](/fabric/real-time-intelligence/eventhouse) depending on your use case.

A reflex is a Fabric item that allows you to react to the occurrence of a data condition as it occurs. Reactions can include alert messages via email or Microsoft Teams, or custom actions triggered through Power Automate flows. You can also initiate any Fabric item from your reflexes. Reflexes support many observability use cases. For example, you can use them to react to streaming data as it arrives in eventstreams.

An eventhouse is a collection of one or more Kusto Query Language (KQL) databases. KQL databases are engineered for time-based, streaming events of structured, semistructured, and unstructured data. Data is automatically indexed and partitioned based on ingestion time, which provides fast and complex analytic querying capabilities, even during real-time data ingestion. Fabric can make data stored in eventhouses available in OneLake for other Fabric processes to use. To query this data, use various code, low-code, or no-code options in Fabric, including native [KQL](/fabric/real-time-intelligence/kusto-query-set?tabs=kql-database) and T-SQL in the KQL queryset.

[Real-Time Intelligence dashboards](/fabric/real-time-intelligence/dashboard-real-time-create) provide immediate insights from data streaming into your eventhouses. You can add various types of visuals to a dashboard, such as charts and graphs, and customize them to fit your needs. Real-Time Intelligence dashboards help identify trends and anomalies in high-velocity data that arrives in an eventhouse. They differ from Power BI dashboards, which work well for enterprise business intelligence (BI) reporting workloads.

##### Step 5: Data serving

There are various low-code or pro-code options available for consuming data from Fabric lakehouses and eventhouses.

###### SQL analytics endpoint

A [SQL analytics endpoint](/fabric/data-engineering/lakehouse-overview#lakehouse-sql-analytics-endpoint) is automatically generated for every lakehouse in Fabric. A SQL analytics endpoint is read-only. To modify data, you need to switch to lakehouse mode and use Spark. You can use the SQL analytics endpoint directly in the Fabric portal to query data by switching from the lakehouse mode to the SQL mode of the lakehouse. Alternatively, you can use the SQL connection string of a lakehouse to connect by using client tools like Power BI, Excel, and SQL Server Management Studio. This option is suitable for data and business analysts on a data team.

###### Spark notebooks

Notebooks are a popular way to interact with lakehouse data. Fabric provides a web-based interactive surface that data workers can use to write code. These workers can apply rich visualizations and Markdown text. Data engineers write code for data ingestion, data preparation, and data transformation. Data scientists use notebooks for data exploration, for creating machine learning experiments and models, and for tracking and deploying models. This option is suitable for professional data engineers and data scientists.

###### Power BI

Every lakehouse in Fabric includes a prebuilt default semantic model. It's automatically created when you set up a lakehouse and load data into it. These models inherit business logic from the lakehouse to simplify creating Power BI reports and dashboards from directly within the lakehouse experience. You can also create custom semantic models, based on specific business requirements, on lakehouse tables. When you create Power BI reports on a lakehouse, you can use [Direct Lake mode](/fabric/get-started/direct-lake-overview), which doesn't require you to import data separately. This mode allows you to get in-memory performance on your reports without moving your data out of the lakehouse.

Direct Lake mode in Power BI provides significant benefits in performance and latency. But some data scenarios still require reverting to Direct Query mode to fulfill specific queries. The following example scenarios can trigger a Direct Query fallback:

- Semantic model table stats exceed the associated [capacity guardrails](/fabric/fundamentals/direct-lake-overview#fabric-capacity-requirements).

- A semantic model has row-level security (RLS) applied.

- A semantic model references views instead of direct OneLake tables.

To handle these fallback scenarios, use the SQL Analytics endpoint as the data source for Power BI. If you enable Direct Lake on the SQL Analytics endpoint, semantic model queries automatically [fall back](/fabric/fundamentals/direct-lake-overview#directquery-fallback) to Direct Query mode where Direct Lake isn't supported.

###### Custom APIs

Fabric provides a rich API surface across its items. OneLake provides open access to all Fabric items through Azure Data Lake Storage APIs and SDKs. You can access your data in OneLake through any API, SDK, or tool that's compatible with Data Lake Storage by using a OneLake URI instead. You can upload data to a lakehouse by using Azure Storage Explorer or read a delta table via a shortcut from Azure Databricks. OneLake also supports the [Azure Blob Filesystem driver](/azure/storage/blobs/data-lake-storage-abfs-driver) for more compatibility with Data Lake Storage and Azure Blob Storage. To consume streaming data in downstream apps, you can push eventstream data to a custom API endpoint. You can then consume this streaming output from Fabric by using Azure Event Hubs or the Advanced Message Queuing Protocol (AMQP) or Kafka protocol.

###### Power Automate

Power Automate is a low-code application platform that you can use to automate repetitive tasks and also manipulate your data. The reflex item in Fabric supports Power Automate flows as a destination. This [integration](/fabric/real-time-intelligence/data-activator/activator-trigger-power-automate-flows) unlocks many use cases and allows you to trigger downstream actions by using a wide range of connectors, for both Microsoft and non-Microsoft systems.

### Components

- [Fabric](/fabric/fundamentals/microsoft-fabric-overview) is a cloud-based data analytics platform that unifies data ingestion, transformation, analysis, and visualization for enterprises. In this architecture, Fabric serves as the foundation for building and managing the lakehouse, which enables integration across all data tasks.

  - [OneLake](/fabric/onelake/onelake-overview) is the central data hub in Fabric, designed as an open data lake. In this architecture, it stores structured and unstructured data in its native format and serves as the unified storage layer for all components in the lakehouse architecture.

  - [Data Factory](/fabric/data-factory/data-factory-overview) is a cloud-based ETL and orchestration service. In this architecture, it automates data movement and transformation across diverse sources, which supports both scheduled and event-driven ingestion.

  - [Data Engineering](/fabric/data-engineering/data-engineering-overview) is a workload in Fabric that provides tools to collect, store, process, and analyze large datasets. In this architecture, it powers the transformation and preparation of data within the lakehouse by using Spark notebooks and pipelines.
  
  - [Data Science](/fabric/data-science/data-science-overview) is a workload in Fabric that provides tools to build machine learning models and generate insights. In this architecture, it supports experimentation, model tracking, and deployment within the lakehouse environment.

  - [Data Warehouse](/fabric/data-warehouse/data-warehousing) is an enterprise-scale relational warehouse on a data lake foundation. Every lakehouse in Fabric includes a SQL endpoint, which provides SQL-native warehouse semantics on top of the lakehouse. Use Data Warehouse to serve curated gold data from the lakehouse. Data analysts can use this feature for interactive analysis, and business users can generate reports.
  
  For more information about data ingestion, table management, data preparation, statistics, and querying best practices in warehouses and SQL analytics endpoints, see [Performance guidelines in Data Warehouse](/fabric/data-warehouse/guidelines-warehouse-performance).

  - [Real-Time Intelligence](/fabric/real-time-intelligence/overview) is a feature that provides stream ingestion and processing capabilities. In this architecture, it enables real-time analytics by capturing and analyzing data-in-motion through eventstreams and reflexes.

  - [Microsoft Copilot](/fabric/get-started/copilot-fabric-overview) is a natural language interface that generates insights and visualizations. In this architecture, it helps users interact with data in Fabric and Power BI.

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a BI tool for creating dashboards and reports. In this architecture, it visualizes lakehouse data by using semantic models and Direct Lake mode for in-memory performance.

### Alternatives

Fabric provides a comprehensive set of tools. But depending on your specific needs, you might benefit from functionality that alternative services in the Azure ecosystem provide.

- [Azure Databricks](/azure/databricks/introduction/) can replace or complement the native Fabric data engineering capabilities. Azure Databricks provides a cloud-based Spark environment for large-scale data processing. It also provides common governance across your entire data estate and capabilities to enable key use cases like data science, data engineering, machine learning, AI, and SQL-based analytics.

- [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) can replace or complement the native Data Science tools. Machine Learning extends the experimentation and management features of Fabric by enabling model hosting for online inference, drift monitoring, and the creation of custom generative AI applications.

## Scenario details

This architecture applies to the following scenarios:

- Organizations that are starting fresh without legacy system constraints.

- Organizations that prefer a simple pattern that balances cost, complexity, and performance considerations.

- Organizations that need a simple, cost-effective, and high-performance data platform that addresses reporting, analytics, and machine learning requirements.

- Organizations that want to integrate data from multiple sources for a unified view.

This architecture isn't recommended for the following scenarios:

- Teams with a SQL or relational database background that have limited skills in Spark.

- Organizations that are migrating from a legacy system or data warehouse to a modern platform.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Fabric automatically replicates resources across availability zones without requiring any configuration. For example, during a zone-wide outage, no action is required to recover a zone. In [supported regions](/azure/reliability/reliability-fabric), Fabric can self-heal and rebalance automatically to take advantage of a healthy zone.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

You can use Fabric to manage, control, and audit your security settings according to your changing needs and demands. Consider the following key security recommendations:

- **Authentication:** Configure single sign-on (SSO) in Microsoft Entra ID to provide access from various devices and locations.

- **Role-based access control (RBAC):** Implement workspace-based access control to manage who can access and interact with specific datasets.

- **Network security:** Use the Fabric inbound and outbound network security controls when you connect to data or services within or outside your network. Key features include [Microsoft Entra Conditional Access](/fabric/security/security-conditional-access), [private links](/fabric/security/security-private-links-overview), [trusted workspace access](/fabric/security/security-trusted-workspace-access), and [managed private endpoints](/fabric/security/security-managed-private-endpoints-overview).

- **Audit logs:** Use the detailed audit logs that Fabric provides to track user activities and ensure accountability across the platform.

For more information, see [Security in Fabric](/fabric/security/security-overview).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Fabric provides [capacity reservations](/azure/cost-management-billing/reservations/fabric-capacity) for a given number of capacity units (CUs). Capacity reservations can help you save costs when you commit to a reservation for your Fabric capacity usage for one year.

To maximize the utilization of your Fabric capacity, consider the following recommendations:

- Rightsize F SKUs. To determine the right capacity size, you can provision [trial capacities](/fabric/fundamentals/fabric-trial) or [pay-as-you-go F SKUs](/fabric/enterprise/buy-subscription#azure-skus). Use these options to measure actual capacity size before committing to a reserved instance. Perform a scoped proof of concept (POC) with a representative workload, monitor CU usage, and extrapolate the results to estimate CU usage for production. Fabric supports scaling. You can start with a conservative capacity size and scale up if you need more capacity.

- Monitor usage patterns. Regularly track and analyze your usage to identify peak and off-peak hours. This approach can help you understand when you use your resources most so that you can schedule noncritical tasks during off-peak times to avoid spikes in CU usage.

- Optimize queries and workloads. Ensure that your queries and workloads are optimized to reduce unnecessary compute usage. Optimize Data Analysis Expressions (DAX) queries, Python code, and other operations.

- Use the bursting and smoothing features of Fabric to handle CPU-intensive activities without requiring a higher SKU. This approach can help you manage costs while still maintaining performance. For more information, see [Evaluate and optimize your Fabric capacity](/fabric/enterprise/optimize-capacity).

- Set up alerts and notifications. Configure proactive alerts so that capacity admins can monitor and manage high compute usage. This approach can enable them to take timely actions to prevent cost overruns.

- Implement workload management. Schedule log-running jobs at staggered times based on resource availability and system demand to optimize capacity usage. For more information, see [Workload management](/fabric/data-warehouse/workload-management).

Also keep the following considerations in mind:

- [Data Lake Storage](https://azure.microsoft.com/pricing/details/storage/data-lake/) pricing depends on the amount of data that you store and how often you use it. The sample pricing includes 1 terabyte (TB) of data stored and other transactional assumptions. The 1 TB refers to the size of the data lake, not the original legacy database size.

- [Fabric](https://azure.microsoft.com/pricing/details/microsoft-fabric/) pricing is based on the Fabric F SKU capacity price or Premium per user price. Serverless capacities consume CPU and memory from purchased dedicated capacity.

- [Event Hubs](https://azure.microsoft.com/pricing/details/event-hubs/) bills based on tier, provisioned throughput units, and received ingress traffic. The example assumes one throughput unit in the Standard tier over one million events for a month.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Fabric provides many components to help you manage your data platform. Each of these components supports unique operations that you can view in the [Fabric Capacity Metrics app](/fabric/enterprise/metrics-app). Use this app to monitor your capacity consumption and make informed decisions about how to use your capacity resources.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Fabric provides several features to optimize performance across its components. These tools and practices can help you manage compute resources effectively, prevent overloading, and make informed decisions about scaling and optimizing workloads.

Consider the following key performance efficiency capabilities in Fabric:

- Both [bursting](/fabric/data-warehouse/burstable-capacity) and [smoothing](/fabric/data-warehouse/compute-capacity-smoothing-throttling) help ensure that CPU-intensive activities are completed quickly without requiring a higher SKU. You can schedule these activities at any time.

- [Throttling](/fabric/enterprise/throttling) delays or rejects operations when capacity experiences sustained CPU demand above the SKU limit.

- The [Fabric Capacity Metrics app](/fabric/enterprise/metrics-app) provides tools to visualize capacity usage, optimize the performance of artifacts, and optimize high-compute items. The app differentiates between interactive operations, such as DAX queries, and background operations, like semantic model refreshes. This differentiation allows for targeted optimizations specific to each type of operation.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Amit Chandra](https://www.linkedin.com/in/amitchandra2005/) | Cloud Solution Architect
- [Nicholas Moore](https://www.linkedin.com/in/nicholas-moore/) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is OneLake?](/fabric/onelake/onelake-overview)
- [What is Data Factory?](/fabric/data-factory/data-factory-overview)
- [What is Data Engineering?](/fabric/data-engineering/data-engineering-overview)
- [What is Data Science?](/fabric/data-science/data-science-overview)
- [What is Real-Time Intelligence?](/fabric/real-time-intelligence/overview)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [Introduction to Copilot in Fabric](/fabric/fundamentals/copilot-fabric-overview)

## Related resources

- [What is a data lake?](../../data-guide/scenarios/data-lake.md)
- [Data warehousing and analytics](data-warehouse.yml)
- [Use Microsoft Fabric to design an enterprise BI solution](../../example-scenario/analytics/enterprise-bi-microsoft-fabric.yml)

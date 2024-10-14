This example workload illustrates a greenfield solution for creating a scalable data platform by using Microsoft Fabric and the lakehouse design paradigm. Fabric is a platform that integrates data storage, processing, and analytics. A greenfield lakehouse provides a clean start for designing an efficient, future-proof data ecosystem.

This architecture is applicable to the following scenarios:

- Organizations that want to start fresh, unencumbered by legacy systems, when developing a data platform.
- Organizations that anticipate data volumes between 0.5 and 1.5 TB.
- Organizations that prefer a simple and streamlined pattern that balances cost, complexity, and performance considerations.

## Architecture

![Diagram that illustrates a greenfield solution for building a robust, scalable data platform by using the lakehouse design paradigm on Microsoft Fabric.](media/greenfield-lakehouse-fabric/greenfield-lakehouse-fabric.png)

*Download a [Visio file]() of this architecture.*

### Dataflow

This design reflects the Lambda architecture, which separates data processing into two layers:

- A high-volume batch processing layer that's processed periodically for historical analysis
- A low-latency, high-throughput stream processing layer for real-time analytics

The stream processing path ingests and processes data in near real-time, which makes it ideal for dashboards and anomaly detection. The batch processing path handles the complete dataset, ensuring data consistency and enabling complex historical analysis. This two-pronged approach offers real-time insights while maintaining a reliable record for later exploration.

#### Cold path: Batch analytics

Data warehouses, which rely on relational SQL semantics, are the conventional approach for historical data analysis. However, this pattern has evolved over time, and lakehouses are the current industry standard for batch data analysis. A lakehouse is built on top of open source file formats and, unlike traditional data warehouses, caters to all types of data: structured, semi-structured, and unstructured. The compute layer in a lakehouse is typically built on top of the Apache Spark framework, which is the preferred engine for processing big data because of its distributed computing capability and high performance. Fabric offers a native lakehouse experience that's based on the open source Delta Lake file format and a managed Spark runtime.

A lakehouse implementation typically uses the [medallion architecture](/azure/databricks/lakehouse/medallion). In this architecure, the bronze layer contains the raw data, the silver layer contains the validated and deduplicated data, and the gold layer contains highly refined data that's suitable for supporting business-facing use cases. This approach is agnostic of organizations and industries. Although this is the general approach, you can customize it for your requirements. This architecture shows how to create a lakehouse by using native Fabric components.

##### Data ingestion via Data Factory

(See step 1 in the diagram.) 

The [Azure Data Factory](/fabric/data-factory/data-factory-overview) feature in Fabric provides the capabilities of the Azure Data Factory service, which is a widely used data integration service. Although the Data Factory service mainly provides orchestration capabilities via pipelines, in the feature in Fabric provides both pipelines and dataflows.

- Data pipelines enable you to apply out-of-the-box rich data orchestration capabilities to compose flexible data workflows that meet your enterprise needs.
- Dataflows enable you to use more than 300 transformations in the dataflows designer. You can use these transformations to transform data by using a graphical interface that's simliar to the one in Power Query. These transformations include smart AI-based data transformations. Dataflows can also write data to native data stores in Fabric, such as lakehouse, warehouse, Azure SQL, and Kusto databases.

Depending on your requirements, you can use either or both of these capabilities to create a rich metadata-driven ingestion framework. You can onboard data from various source systems on a defined schedule or by using event triggers.

##### Data transformations

(See step 2 in the diagram.)

There are two approaches to data preparation and transformation. If you prefer a code-first experience, you can use Spark notebooks. If you prefer a low-code or no-code experience, you can use dataflows.

[Fabric notebooks](/fabric/data-engineering/how-to-use-notebook) are an important tool for developing Apache Spark jobs. They provide a web-based interactive surface that data engineers use to write code. They also provide rich visualizations and enable the use of Markdown text. Data engineers write code for data ingestion, data preparation, and data transformation. Data scientists use notebooks to create machine learning solutions, for example, to create experiments and models and to track and deploy models.

Every workspace in Fabric comes with a Spark [starter pool](/fabric/data-engineering/configure-starter-pools), which is used for default Spark jobs. With starter pools, you can expect rapid Apache Spark session initialization, typically within 5 to 10 seconds, without any manual setup. You also get the flexibility to customize Apache Spark pools according to your data engineering requirements. You can size the nodes, autoscale, and dynamically allocate executors based on your Spark job requirements. For Spark runtime customizations, you can use [environments](/fabric/data-engineering/create-and-use-environment). In an environment, you can configure compute properties, select different runtimes, and set up library package dependencies based on your workload requirements.

[Dataflows](/fabric/data-factory/create-first-dataflow-gen2) allow you to extract data from various sources, transform it by using a wide range of operations, and optionally load it into a destination. Traditionally, data engineers spend significant time extracting, transforming, and loading data into a consumable format for downstream analytics. Dataflow Gen2 provides an easy, reusable way to perform ETL tasks by using visual cues in Power Query Online. The dataflow preserves all transformation steps. To perform other tasks or load data to a different destination after transformation, create a Data Pipeline and add the Dataflow Gen2 activity to your pipeline orchestration.

#### Hot path: Real-time analytics

Real-time data processing is vital for businesses that want to stay agile, make informed decisions quickly, and take advantage of immediate insights to improve operations and customer experiences. In Fabric, this capability is provided by the Real-Time Intelligence service. It comprises several Fabric items that are bundled together and accessible via [Real-Time hub](/fabric/real-time-hub/real-time-hub-overview). Real-Time hub provides a single place for streaming data-in-motion across your organization.

Real-Time Intelligence in Fabric enables analysis and data visualization for event-driven scenarios, streaming data, and data logs. It connects time-based data from various sources by using a catalog of no-code connectors and provides an end-to-end solution for data ingestion, transformation, storage, analytics, visualization, tracking, AI, and real-time actions. Although the service name uses the phrase "Real-Time," your data doesn't have to be flowing at high rates and volumes. Real-Time Intelligence provides event-driven, rather than schedule-driven, solutions.

##### Real-time ingestion

(See step 3 in the diagram.)

[Event streams](/fabric/real-time-intelligence/event-streams/overview?tabs=enhancedcapabilities) is a Fabric feature that enables a no-code method for ingesting real-time events from various sources and sending them to different destinations. It allows data filtering, transformation, aggregation, and routing based on content. You can also use it to create new streams from existing ones and share them across the organization by using Real-Time hub. Eventstreams support multiple data sources and data destinations. You can use a wide range of connectors to external sources like Apache Kafka clusters, database Change Data Capture feeds, AWS streaming sources (Kinesis), and Google (GCP Pub/Sub).

You create an eventstream, add event data sources to the stream, optionally add transformations to transform the event data, and then route the data to supported [destinations](/fabric/real-time-intelligence/event-streams/overview?tabs=enhancedcapabilities#route-events-to-destinations). Fabric lakehouse is one of the supported destinations, so you can transform your real-time events before ingesting them into your lakehouse. Real-time events are converted into Delta Lake format and then stored in the designated lakehouse tables. This pattern enables data warehousing scenarios and historical analysis of your fast-moving data.

##### Real-time analytics

(See step 4 in the diagram.)

When you use Real-Time Intelligence in Fabric, depending on your use cases, there are two typical pathways for streaming data: [Reflex](/fabric/data-activator/data-activator-get-started#create-a-reflex-item) items and [eventhouses](/fabric/real-time-intelligence/eventhouse).

A reflex is a Fabric item that allows you to react to the occurrence of a data condition as it happens. That reaction can be a simple alert message via email or Microsoft Teams, or it can involve invoking a custom action by triggering a Power Automate flow. You can also trigger any Fabric item from your reflexes. Many observability use cases are supported by reflexes, one of which is reacting to streaming data as it arrives in eventstreams.

An eventhouse is a collection of one or more Kusto Query Language (KQL) databases. KQL databases are engineered for time-based, streaming events of structured, semi-structured, and unstructured data. Data is automatically indexed and partitioned based on ingestion time, which provides fast and complex analytic querying capabilities, even as the data is streaming in. Data stored in eventhouses can be made available in OneLake for consumption by other Fabric processes. You can query data stored in eventhouses by using various code, low-code, or no-code options in Fabric. You can query data in native [KQL](/fabric/real-time-intelligence/kusto-query-set?tabs=kql-database) or by using T-SQL in the KQL queryset.

[Real-Time Dashboards](/fabric/real-time-intelligence/dashboard-real-time-create) are designed to provide immediate insights from data streaming into your eventhouses. You can add various types of visuals to a dashboard, such as charts and graphs, and customize them to fit your needs. Real-Time Dashboards serve the specific purpose of quickly identifying trends and anomalies in high-velocity data that arrives in an eventhouse. They are different from Power BI dashboards, which are suitable for enterprise BI reporting workloads.

##### Data serving

(See step 5 in the diagram.)

There are various low-code or pro-code options available for consuming data from Fabric lakehouses and eventhouses.

###### SQL analytics endpoint

A [SQL analytics endpoint](/fabric/data-engineering/lakehouse-overview#lakehouse-sql-analytics-endpoint) is automatically generated for every lakehouse in Fabric. A SQL analytics endpoint is read-only. To modify data, you need to switch to lakehouse mode and use Spark. You can use the SQL analytics endpoint directly in the Fabric portal to query data by switching from the lakehouse mode to the SQL mode of the lakehouse. Alternatively, you can use the SQL connection string of a lakehouse to connect by using client tools like Power BI, Excel, and SQL Server Management Studio. This option is suitable for data and business analysts on a data team.

###### Spark notebooks

Notebooks are a popular way to interact with lakehouse data. Fabric provides a web-based interactive surface that data workers can use to write code. These workers can apply rich visualizations and Markdown text. Data engineers write code for data ingestion, data preparation, and data transformation. Data scientists use notebooks for data exploration, for creating machine learning experiments and models, and for tracking and deploying models. This option is suitable for professional data engineers and data scientists.

###### Power BI

Every lakehouse in Fabric comes with a prebuilt default semantic model. It's automatically created when you set up a lakehouse and load data into it. These models inherit business logic from the lakehouse to make it easier to create Power BI reports and dashboards from directly within the lakehouse experience. You can also create custom semantic models, based on specific business requirements, on lakehouse tables. When you create Power BI reports on a lakehouse, you can use [Direct Lake mode](/fabric/get-started/direct-lake-overview), which doesn't require you to import data separately. This allows you to achieve in-memory performance on your reports without moving your data out of the Lakehouse.

###### Custom APIs

Fabric has a rich API surface across its different items. Microsoft OneLake provides open access to all of Fabric items through existing ADLS Gen2 APIs and SDKs. You can access your data in OneLake through any API, SDK, or tool compatible with ADLS Gen2 just by using a OneLake URI instead. You can upload data to a Lakehouse through Azure Storage Explorer or read a delta table through a shortcut from Azure Databricks. OneLake also supports the [Azure Blob Filesystem driver](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-abfs-driver) (ABFS) for more compatibility with ADLS Gen2 and Azure Blob Storage. For consuming streaming data in downstream apps, you can push Eventstream data to a custom API endpoint. This streaming output from Fabric can then be consumed using Eventhub or AMQP and Kafka protocols.

###### Power Automate

Power Automate Flow is a low-code application platform that enables you to automate repetitive tasks in an enterprise and also 'act' on your data. The Reflex item in Fabric provides Power Automate flows as one of the supported destinations. This [integration](https://learn.microsoft.com/en-us/fabric/data-activator/data-activator-trigger-power-automate-flows) unlocks many use cases and allows you to trigger downstream actions using a wide range of connectors, both Microsoft native and external systems.

### Components

The following components are used to enable this solution:

- [Microsoft Fabric](): An end-to-end cloud-based data analytics platform designed for enterprises that offers a unified environment for various data tasks like data ingestion, transformation, analysis, and visualization.

  - [OneLake](https://learn.microsoft.com/fabric/onelake/onelake-overview): The central hub for all your data within Microsoft Fabric. It's designed as an open data lake, meaning it can store data in its native format regardless of structure.

  - [Data Factory](https://learn.microsoft.com/fabric/data-factory/data-factory-overview): A cloud-based ETL and orchestration service for automated data movement and transformation. It allows you to automate data movement and transformation at scale across various data sources.

  - [Data Engineering](https://learn.microsoft.com/fabric/data-engineering/data-engineering-overview): Tools that enable the collection, storage, processing, and analysis of large volumes of data.

  - [Data Science](https://learn.microsoft.com/fabric/data-science/data-science-overview): Tools that empower you to complete end-to-end data science workflows in data enrichment and business insights.

  - [Real-Time Intelligence](https://learn.microsoft.com/fabric/real-time-intelligence/overview): Provides stream ingestion and processing capabilities. This allows you to gain insights from constantly flowing data, enabling quicker decision-making based on real-time trends and anomalies.

  - [Power BI](https://learn.microsoft.com/power-bi/fundamentals/power-bi-overview): Business intelligence tool for creating interactive dashboards and reports to visualize data and gain insights.

  - [Copilot](https://learn.microsoft.com/fabric/get-started/copilot-fabric-overview): Allows you to analyze data, generate insights, and create visualizations and reports in Microsoft Fabric and Power BI using natural language.

### Alternatives

Microsoft Fabric offers a robust set of tools, but depending on your specific needs, alternative services within the Azure ecosystem can be used for enhanced functionality.

- [Azure Databricks](https://learn.microsoft.com/azure/databricks/introduction/) could replace or complement the Microsoft Fabric native Data Engineering capabilities. Azure Databricks offers an alternative for large-scale data processing by providing a cloud-based Apache Spark environment. Azure Databricks also extends this by providing common governance across your entire data estate, and capabilities to enable key use cases including data science, data engineering, machine learning, AI, and SQL-based analytics.

- [Azure Machine Learning](https://learn.microsoft.com/azure/machine-learning/overview-what-is-azure-machine-learning) could replace or complement the Microsoft Fabric native Data Science. Azure Machine Learning goes beyond the model experimentation and management capabilities in Microsoft Fabric by adding capabilities to allow you to host models for online inference use-cases, monitor models for drift, and provide capabilities to build custom Generative-AI applications.

## Scenario details

Several scenarios can benefit from this workload:

- Organizations starting fresh without legacy system constraints.
- Businesses needing a simple, cost-effective, and high-performance data platform that addresses reporting, analytics, and machine learning requirements.
- Organizations looking to integrate data from multiple sources for a unified view.

This solution isn't recommended for:

- Teams from a SQL or relational database background with limited skills on Apache Spark.
- Organizations who are migrating from a legacy system or data warehouse to a modern platform.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/).

The following considerations apply to this scenario.

### Reliability

Fabric automatically replicates resources across availability zones without any need for you to set up or configure. For example, during a zone-wide outage, no action is required to recover a zone. In [supported regions](https://learn.microsoft.com/en-us/azure/reliability/reliability-fabric#supported-regions), Fabric can self-heal and rebalance automatically to take advantage of the healthy zone.

### Security

Fabric also allows you to manage, control and audit your security settings, in line with your changing needs and demands. Key security considerations in Fabric include: 

- Authentication: Configure single sign-on (SSO) in Microsoft Entra ID for access across various devices and locations.

- Role-Based Access Control (RBAC): Implement workspace-based access control to precisely manage who can access and interact with specific datasets, ensuring users only access what they are authorized to.

- Network Security: Utilize Fabric’s inbound and outbound network security controls when connecting to data or services within or outside your network. Key features include: [Conditional Access](https://learn.microsoft.com/en-us/fabric/security/security-conditional-access), [Private Links](https://learn.microsoft.com/en-us/fabric/security/security-private-links-overview), [Trusted Workspace Access](https://learn.microsoft.com/en-us/fabric/security/security-trusted-workspace-access), [Managed Private Endpoints](https://learn.microsoft.com/en-us/fabric/security/security-managed-private-endpoints-overview), and more.

- Audit Logs: Use Fabric’s detailed audit logs to track user activities and ensure accountability across the platform.

For more information, see [Security in Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/security/security-overview). 

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Microsoft Fabric offers [capacity reservations](https://learn.microsoft.com/en-us/azure/cost-management-billing/reservations/fabric-capacity) for a given number of capacity units (CUs). Capacity reservations can help you save costs by committing to a reservation for your Fabric capacity usage for a duration of one year.

To maximise the utilisation of your capacity Microsoft Fabric connsider the following:

1. Right sizing F SKU - To help you determine the right capacity size, you can provision [trial capacities](https://learn.microsoft.com/en-us/fabric/get-started/fabric-trial) or [pay-as-you-go F SKUs](https://learn.microsoft.com/en-us/fabric/enterprise/buy-subscription#azure-skus) to measure the actual capacity size required before purchasing an F SKU reserved instance. It is recommended that you perform a scoped proof of concept with a representative workload, monitor the CU usage, and then extrapolate to arrive at an estimated CU usage in production. Fabric allows for seamless scaling. You can start with a conservative capacity size and scale up as you need more capacity.
 
2. Monitor Usage Patterns: Regularly track and analyze your usage to identify peak and off-peak hours. This helps in understanding when your resources are most utilized and can guide you in scheduling non-critical tasks during off-peak times to avoid spikes in CU usage.
 
3. Optimize Queries and Workloads: Ensure that your queries and workloads are optimized to reduce unnecessary compute usage. This includes optimizing DAX queries, Python code, and other operations to be more efficient.
 
4. Use Capacity Reservations: Consider committing to a capacity reservation for a year. This can provide significant cost savings compared to pay-as-you-go models. See details [here](https://learn.microsoft.com/en-us/azure/cost-management-billing/reservations/fabric-capacity).
 
5. Leverage Bursting and Smoothing: Utilize Fabric’s bursting and smoothing features to handle CPU-intensive activities without needing a higher SKU. This helps in managing costs while maintaining performance. See details [here](https://learn.microsoft.com/en-us/fabric/enterprise/optimize-capacity).
 
6. Set Up Alerts and Notifications: Configure proactive alerts for capacity admins to monitor and manage high compute usage. This can help in taking timely actions to prevent cost overruns.
 
7. Implement workload management: Schedule log-running jobs at staggered times based on resource availability and system demand to optimize capacity usage. See more information [here](https://learn.microsoft.com/en-us/fabric/data-warehouse/workload-management).

Other cost optimization considerations include:

- [Data Lake Storage Gen2](https://azure.microsoft.com/pricing/details/storage/data-lake/) pricing depends on the amount of data you store and how often you use the data. The sample pricing includes 1 TB of data stored, with further transactional assumptions. The 1 TB refers to the size of the data lake, not the original legacy database size.
- [Microsoft Fabric](https://azure.microsoft.com/en-us/pricing/details/microsoft-fabric/) pricing is based on Fabric F capacity price or Premium Per Person price. Serverless capacities would consume CPU and memory from dedicated capacity that was purchased.
- [Event Hubs](https://azure.microsoft.com/pricing/details/event-hubs/) bills based on tier, throughput units provisioned, and ingress traffic received. The example assumes one throughput unit in Standard tier over one million events for a month.

### Operational excellence

Microsoft Fabric provides many different components to help you manage your data platform. Each of these experiences supports unique operations that can be viewed in the [Microsoft Fabric Capacity Metrics app](https://learn.microsoft.com/en-us/fabric/enterprise/metrics-app). Use the Microsoft Fabric Capacity Metrics app to monitor your capacity consumption and make informed decisions on how to use your capacity resources.

### Performance efficiency

Microsoft Fabric provides several features to optimize performance across its components. These tools help manage compute resources effectively, prevent overloads, and guide scaling decisions. These tools and practices help you manage compute resources effectively, prevent overloading, and make informed decisions on scaling and optimizing workloads.

Some key performance efficiency capabilities in Fabric include:

- Use [bursting and smoothing](https://blog.fabric.microsoft.com/blog/fabric-capacities-everything-you-need-to-know-about-whats-new-and-whats-coming?ft=All#BurstSmooth) to ensure CPU-intensive activities are completed quickly without requiring a higher SKU. Schedule these activities at any time of the day.

- Use [throttling](https://learn.microsoft.com/en-us/fabric/enterprise/throttling) to delay or reject operations when capacity experiences sustained high CPU demand (above the SKU limit). More details here.

- Use the [Fabric Capacity Metrics App](https://learn.microsoft.com/en-us/fabric/enterprise/metrics-app) to visualize capacity usage, optimize performance of artifacts, and optimize high-compute items. It differentiates between interactive operations (like DAX queries) and background operations (like semantic model refreshes) for targeted optimizations.

## Contributors

_This article is being updated and maintained by Microsoft. It was originally written by the following contributors._

Principal author:

- [Amit Chandra](https://www.linkedin.com/in/amitchandra2005/) | Cloud Solution Architect
- [Nicholas Moore](https://www.linkedin.com/in/nicholas-moore/) | Cloud Solution Architect

To see non-public LinkedIn profiles, sign in to LinkedIn.

## Next steps

Consult the relevant documentation to learn more about the different components and how to get started.

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

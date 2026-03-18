This article describes how to integrate MongoDB Atlas with Microsoft Fabric by using the open mirroring feature in Fabric. We recommend this architecture for high‑fidelity, low‑latency ingestion of operational data into OneLake.

## Architecture

The MongoDB Atlas to Fabric mirroring accelerator implements the open mirroring feature. An open mirrored database in Fabric exposes a landing zone in OneLake. Applications write Parquet files that contain MongoDB change data to this landing zone by following the open mirroring specification.

The following diagram shows how a reference mirroring application deployed in Azure App Service streams MongoDB Atlas change events into Fabric.

:::image type="complex" source="media/mongodb-atlas-fabric.svg" alt-text="Architecture diagram that shows how Fabric integrates with MongoDB Atlas by using open mirroring." border="false" lightbox="media/mongodb-atlas-fabric.svg":::
   The flow begins with a user icon. An arrow points right to a box labeled Fabric generic mirroring with MirrorDB creation that contains Fabric, Power BI, OneLake logos. An arrow labeled MongoDB mirrored landing zone points from this box to another box that represents the deployment to Azure. A GitHub logo is above this box. Another arrow points right to the App Service icon. A box labeled Python app is to the left of the App Service icon. That box contains smaller boxes for app.py, mirror, listening, and initial sync. Arrows point from App Service to app.py to mirror listening and initial sync. An arrow points from the Python app box back to the Fabric generic mirroring box.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/mongodb-atlas-fabric.vsdx) of this architecture.*

### Dataflow

The following dataflow corresponds to the previous diagram:

1. Create an [open mirrored database](/fabric/mirroring/open-mirroring-tutorial) in Fabric via REST API or the Fabric portal.

1. Obtain the landing zone URL associated with the mirrored database.

1. Deploy the mirroring accelerator by using [Terraform](https://github.com/mongodb-partners/MongoDB_Fabric_Mirroring/tree/main/terraform) or Azure Resource Manager.

1. The application does several key functions:

   - Performs the initial historical data load from MongoDB
   - Subscribes to MongoDB change streams to capture ongoing insert, update, and delete operations
   - Writes the captured change data as Parquet files into the Fabric landing zone

1. Fabric automatically takes the following actions:

   1. Detects new Parquet files in the landing zone
   1. Converts new Parquet files into Delta tables that support schema evolution
   1. Keeps mirrored tables synced with the source MongoDB collections
   1. Generates a default semantic model for Power BI

1. Power BI, lakehouse in Fabric, and Fabric Data Warehouse workloads can consume the synced data for analytics and reporting.

### Components

- [Open mirroring in Fabric](/fabric/mirroring/open-mirroring) is a managed data replication capability that syncs external data sources into Fabric by using open table formats. In this architecture, it continuously ingests MongoDB change data by converting Parquet files into Delta tables and keeping them synced with MongoDB Atlas changes.

- [OneLake](/fabric/onelake/onelake-overview) is the unified, open data lake for Fabric that provides centralized storage for all Fabric workloads. In this architecture, it functions as the initial landing zone for change data and the shared storage layer that downstream Fabric services access.

- [Lakehouses](/fabric/data-warehouse/get-started-lakehouse-sql-analytics-endpoint) in Fabric are unified data platforms that combine data lake storage with analytics and SQL querying capabilities over Delta tables. In this architecture, a lakehouse exposes the mirrored Delta tables and provides built-in T‑SQL access for analytics and querying.

- [Semantic models](/fabric/data-warehouse/semantic-models) in Fabric are Power BI datasets that define business-friendly metadata and relationships to support analytical queries and reporting. In this architecture, the lakehouse automatically generates them to accelerate Power BI reporting and analytics.

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a fully managed platform for hosting web applications and background services. In this architecture, it hosts the Python-based mirroring application that orchestrates change ingestion into Fabric.

- [MongoDB change streams](https://www.mongodb.com/docs/manual/changeStreams/) provide a mechanism to capture real-time data changes from MongoDB collections. In this architecture, they capture insert, update, and delete operations from MongoDB Atlas to drive continuous data sync.

- [Terraform](/azure/developer/terraform/overview) is an infrastructure as code (IaC) tool used to declaratively provision cloud resources. In this architecture, the [templates](https://github.com/mongodb-partners/MongoDB_Fabric_Mirroring/tree/main/terraform) automate deployment of the required Azure and Fabric resources.

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a business intelligence (BI) platform for creating interactive dashboards and reports. In this architecture, it visualizes the mirrored Delta tables by using Direct Lake for high-performance, near real-time analytics.

The following diagram shows the mirroring integration architecture.

:::image type="complex" source="media/mongodb-mirrored-integrated-architecture.svg" alt-text="Diagram that shows the mirroring integration architecture." border="false" lightbox="media/mongodb-mirrored-integrated-architecture.svg":::
   On the left, a dashed box that represents the cloud contains an app icon. An arrow that represents insert, update, and delete operations points from the app to MongoDB Atlas. An arrow labeled near real-time incremental replication points right from MongoDB Atlas to OneLake. OneLake is inside another dashed box that represents a Fabric environment. Inside the Fabric box, arrows connect four vertically stacked icons to represent the flow from a mirrored MongoDB database to a default semantic model to a SQL analytics endpoint to OneLake with Delta or Parquet format.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/sync-mongodb-atlas-fabric.pptx) of this architecture.*

Open mirroring allows your application to write MongoDB change data directly into Fabric, convert it to Delta format, and make it immediately available for a lakehouse, Data Warehouse, real-time analytics, and Power BI.

### Alternatives

Fabric supports other patterns for integrating with MongoDB Atlas. These alternatives might suit your workload depending on latency thresholds, operational constraints, or existing infrastructure.

The following sections describe alternative ingestion approaches for various operational and analytical needs.

#### Real-Time Intelligence with eventstreams and eventhouses

Fabric Real-Time Intelligence provides a native, code-free ingestion path by using the [MongoDB change data capture (CDC) connector](/fabric/real-time-intelligence/event-streams/add-source-mongodb-change-data-capture) for an eventstream. The connector streams change events from MongoDB Atlas directly into Fabric.

Eventstreams route CDC events to the following destinations:

- **An eventhouse (KQL database)** for real-time analytics, anomaly detection, and observability
- **OneLake** for downstream lakehouse or Data Warehouse processing
- **Lakehouse folders** for Apache Spark, SQL analytics, or machine learning workloads

Use this approach when you need the following capabilities:

- Operational real-time dashboards
- High-throughput log and event processing
- KQL-based monitoring and detections
- Low-latency scenarios without custom code

#### Atlas triggers, functions, and OneLake (push model)

This approach uses [MongoDB Atlas triggers](https://github.com/mongodb/atlas-functions-triggers-examples) to invoke Fabric user data functions or Azure Functions. The function writes the updated document into OneLake by using an Azure Data Lake Storage-compatible API.

:::image type="complex" source="media/azure-fabric-analytics-mongodb.svg" alt-text="Architecture diagram that shows MongoDB Atlas triggers and functions that push data to OneLake." lightbox="media/azure-fabric-analytics-mongodb.svg" border="false":::
   The diagram consists of two boxes. The left box is labeled MongoDB Atlas. Inside the box, an arrow points from a cluster icon to a trigger icon and from the trigger icon to a function icon. Another arrow points right from the MongoDB Atlas box to a box labeled Microsoft Fabric. Inside this box, an arrow points from Fabric functions to OneLake. A Fabric pipeline icon connects OneLake and smaller box that contains icons for lakehouses and Data Warehouse.
:::image-end:::

##### Dataflow

1. The Atlas trigger detects an insert, update, or delete operation.

1. The trigger invokes an Atlas Function.

1. The Atlas Function posts a payload to a Fabric user data function or Azure Functions.

1. The Fabric user data function or Azure Functions writes the JSON document to OneLake.

1. Optionally, a Fabric pipeline transforms and loads the document into a lakehouse or Data Warehouse.

Use the push model when you need near real-time ingestion but can't deploy the mirroring accelerator, or when you prefer a serverless, event-driven integration.

#### Fabric pipelines and MongoDB connectors (pull model)

Fabric pipelines include a [MongoDB connector](/fabric/data-factory/connector-mongodb-overview) that supports on-premises MongoDB and MongoDB Atlas.

You typically use connectors for the following tasks:

- Historical data loads  
- Daily or hourly scheduled syncs  
- Incremental ingestion by using MongoDB queries  
- Multicloud or hybrid integration

Pipelines can load documents into a lakehouse that uses Delta, Parquet, Avro, JSON, or CSV. They can also load documents into Data Warehouse.  

We recommend this model for batch workloads or scenarios that don't require real-time ingestion. For example, you can use a Fabric pipeline to run a nightly copy from MongoDB Atlas into Data Warehouse for executive reporting. The data only needs to reflect end‑of‑day state, so a MongoDB connector-scheduled pipeline is sufficient and avoids the complexity of continuous ingestion.

*Apache® and Apache Spark™ are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

:::image type="complex" source="media/azure-fabric-mongodb-connectors.svg" alt-text="Connector architecture for integrating MongoDB with Fabric pipelines." lightbox="media/azure-fabric-mongodb-connectors.svg" border="false":::
   On the far left is a box labeled Consumers that includes internal apps, customer-facing services, and APIs for non-Microsoft consumption across any channel. A bidirectional arrow connects the consumers to a box labeled operational data layer. This box contains MongoDB Atlas on Azure, a document data model, distributed systems architecture, and cloud or on-premises components. Lines connect the operational data layer and the Relational Database Management System (RDBMS) in tabular format at the top and logs in unstructured format at the bottom. A pipeline icon that represents the MongoDB source connector connects the operational data layer to another box on the right labeled enterprise data warehouse. Inside this box, lines connect Spark, Fabric, and SQL to machine learning, big data analytics, and BI dashboard. A line connects the enterprise data warehouse box and a MongoDB sink connector icon and the MongoDB analytics store.
:::image-end:::

You can also use dataflows in Fabric to integrate with MongoDB Atlas. The pull model suits analyst‑driven or self‑service BI scenarios.

Dataflows provide a no‑code option focused on Power BI to ingest MongoDB Atlas data into OneLake. If you use Power BI as your primary analytics tool, you can use the Dataflow Gen2 MongoDB connector for the following tasks:

- Scheduled ingestion
- Filtered historical data retrieval
- Document shaping and transformation without code
- Results written directly into OneLake via a standard Dataflows Gen2 output

#### Batch integration

You can use batch or micro‑batch integration to move historical or filtered data from MongoDB Atlas into OneLake. Organizations can use Fabric pipelines and the MongoDB Spark Connector v10.x, which supports batch and streaming ingestion patterns.

- **Use Spark Connector for batch integration and streaming.** The MongoDB Spark Connector allows scalable DataFrame‑based ingestion into the Fabric lakehouse. It supports the following capabilities:

   - Full historical batch loads
   - Filtered or incremental loads by using MongoDB queries
   - Micro‑batch or continuous streaming by using Spark structured streaming
   - Writing into Delta or Parquet tables in OneLake

   This approach is optimal for teams that primarily work with Spark or for workloads that require transformations as part of ingestion.

- **Optionally, use Fabric pipelines for batch ingestion.** Fabric pipelines can orchestrate MongoDB batch ingestion through MongoDB Connector, but the Spark Connector provides more flexibility for batch and streaming scenarios.

## Scenario details

MongoDB Atlas is a common operational store for internal applications, customer-facing services, and non-Microsoft integrations. Organizations can use Fabric to unify Atlas data with relational, streaming, and unstructured sources to power analytics, BI, and machine learning at scale.

### Potential use cases

**Retail:**

- Product bundling and promotion optimization
- Customer 360 and hyper-personalization
- Demand sensing and stockout prediction
- Smart search and recommendations

**Banking and finance:**

- Fraud detection and prevention
- Personalized financial products and offers

**Telecommunications:**

- Network quality analytics and optimization
- Edge telemetry aggregation

**Automotive:**

- Connected vehicle intelligence
- Anomaly detection in Internet of Things (IoT) communication

**Manufacturing:**

- Predictive maintenance
- Inventory and warehouse optimization

#### Example: Bundle products for retail

Use sales pattern data to design bundles that increase basket size and margin.

**Data sources:**

- Product catalog in MongoDB Atlas
- Sales facts in Azure SQL

**Flow:**

1. Use a Fabric pipeline to ingest product and sales data into Data Warehouse or a lakehouse.

1. Apply CDC or event-driven updates for near real-time sync in addition to the initial load.

1. Model affinity and copurchase patterns, like market basket analysis, and expose metrics via Power BI.

:::image type="content" source="media/product-bundling-use-case-visualization.svg" alt-text="Screenshots of pipeline stages and charts for product bundling, including sales by product, year, region, and affinity." border="false" lightbox="media/product-bundling-use-case-visualization.svg":::

**Recommendations from analysis:**

- Bundle products, like *pen* and *ink refill*.  
- Promote the bundle in high‑affinity regions.

#### Example: Promote products for retail

Recommend complementary products by using customer behavior, profitability, and product affinity.

**Approach:**

- Train machine learning models in Fabric Spark notebooks or integrate with Azure Machine Learning.  
- Use OneLake as the feature store and serve predictions to Power BI or downstream apps.

:::image type="content" source="media/product-promotion-use-case-visualization.svg" alt-text="Screenshot of the data pipeline and machine learning workflow for product promotion by using customer behavior and product features." border="false" lightbox="media/product-promotion-use-case-visualization.svg":::

If the model achieves high accuracy, it produces a prioritized set of alternative product recommendations for each customer or segment.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Use HTTPS and the latest Transport Layer Security (TLS) versions for Fabric user data functions and Azure Functions endpoints.
- Validate inbound payloads as MongoDB change events.
- Set up Microsoft Entra ID authentication and least‑privilege role-based access control (RBAC) for Fabric.
- Set up OneLake to inherit Data Lake Storage security and authentication models.
- Use MongoDB Atlas for built‑in controls for access, network isolation, encryption, and auditing.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Rightsize Fabric capacity and consolidate workloads where reasonable.
- Batch change documents to reduce function invocations and small files.
- Compact and optimize lakehouse tables and schedule heavy transforms during off‑peak periods.
- Use Parquet or Delta compression, like Snappy, to reduce storage utilization and improve scan performance.
- Size Atlas clusters optimally and evaluate sharding and storage tiers.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Batch multiple change events to reduce small‑file overhead.
- Use Delta for optimized Spark, SQL, and BI queries.
- Choose partitioning and distribution strategies that suit large warehouses.
- Tune pipeline parallelism and apply pushdown filters on MongoDB connectors.
- Monitor ingestion lag and implement retries and idempotent upserts.
- Schedule `OPTIMIZE` and `VACUUM` operations for lakehouse maintenance.
- Use the push model for near real-time, event-driven ingestion.
- Use the pull model for scheduled, batch, or micro-batch workloads.
- Use Data Warehouse for governed relational models and enterprise BI.
- Use lakehouse SQL endpoints for lightweight SQL over Delta without warehouse provisioning.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Diana Annie Jenosh](https://www.linkedin.com/in/diana-jenosh-0b014814) | Advisory Solutions Architect - MongoDB Partners team
- [Rodrigo Rodríguez](https://www.linkedin.com/in/rod2k10/) | Senior Cloud Solution Architect, AI & Quantum

Other contributors:

- [Sunil Sabat](https://www.linkedin.com/in/sunilsabat/) | Principal Program Manager - Azure Data Factory team

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Fabric overview](/fabric/fundamentals/microsoft-fabric-overview)
- [MongoDB mirroring accelerator for Fabric](https://www.mongodb.com/company/blog/technical/near-real-time-analytics-mirroring-microsoft-fabric-for-mongodb-atlas)
- [MongoDB Atlas on Microsoft Marketplace](https://marketplace.microsoft.com/product/mongodb.mongodb_atlas_azure_native_prod?tab=Overview)
- [MongoDB use cases](https://www.mongodb.com/solutions/use-cases)
- [MongoDB industry-specific use cases](https://www.mongodb.com/solutions/industries)
- [App Service overview](/azure/app-service/overview)
- [Power BI overview](https://www.microsoft.com/power-platform/products/power-bi)

## Related resource

- [Real-time data analytics by using Azure Service Bus and Azure Data Explorer](../../solution-ideas/articles/analytics-service-bus.yml)

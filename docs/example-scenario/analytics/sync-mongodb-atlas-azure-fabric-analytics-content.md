This article describes how to integrate MongoDB Atlas with Microsoft Fabric using **Fabric Open Mirroring**, the recommended architecture for high‑fidelity, low‑latency ingestion of operational data into OneLake.

## Architecture

The **MongoDB Atlas Fabric Mirroring Accelerator** implements the Fabric **Open Mirroring** capability. An open mirrored database in Fabric exposes a **landing zone** in OneLake. Applications write Parquet files containing MongoDB change data to this landing zone following the open mirroring specification.

The following diagram shows how the reference mirroring application deployed in Azure App Service streams MongoDB Atlas change events into Fabric.

:::image type="content" source="media/mongodb-mirroring.png" alt-text="Architecture diagram for Fabric Open Mirroring integration with MongoDB Atlas." border="false" lightbox="media/mongodb-mirroring.png":::

### Dataflow

1. Create an [open mirrored database](/fabric/mirroring/open-mirroring-tutorial) in Fabric via API or the Fabric portal.  
2. Obtain the **landing zone URL** associated with the mirrored database.  
3. Deploy the mirroring accelerator [Terraform or ARM](https://github.com/mongodb-partners/MongoDB_Fabric_Mirroring/tree/main/terraform).  
4. The application:
   - Performs initial historical load.
   - Subscribes to MongoDB Change Streams.
   - Writes Parquet files into the landing zone.  
5. Fabric ingests, converts, and mirrors the data into Delta tables.  
6. Power BI, Lakehouse, and Data Warehouse workloads can consume the synchronized data.

Fabric automatically:

- Detects new Parquet files
- Converts them to Delta format
- Applies schema evolution
- Synchronizes mirrored tables with the source collections
- Generates a default semantic model for Power BI

### Components

- [Fabric Open Mirroring](/fabric/mirroring/open-mirroring). Primary ingestion mechanism; converts landed Parquet files to Delta and keeps mirrored tables synchronized.  
- [Fabric Onelake](/fabric/onelake/onelake-overview). File system folder used by the accelerator to deposit change data.  
- [Fabric Lakehouse](/fabric/data-warehouse/get-started-lakehouse-sql-analytics-endpoint). Auto-generated T‑SQL access to mirrored Delta tables.  
- [Semantic models](/fabric/data-warehouse/semantic-models). Created automatically to accelerate Power BI adoption.  
- [Azure App Service](/azure/app-service/overview). Hosts the mirroring Python application.  
- [MongoDB ChangeStreams](https://www.mongodb.com/docs/manual/changeStreams/). Streams inserts, updates, and deletes from Atlas.  
- [Terraform templates](https://github.com/mongodb-partners/MongoDB_Fabric_Mirroring/tree/main/terraform). Provided by the MongoDB team for automated deployment.
- [PowerBI](/power-bi/fundamentals/power-bi-overview). Consumes the mirrored Delta tables through Direct Lake, enabling high-performance real-time dashboards and analytics over MongoDB transactional data with no data movement.

The following diagram depicts the mirroring integration architecture:
:::image type="content" source="media/mongodb-mirroring-integrated-arch.png" alt-text="Diagram that shows the Fabric MongoDB Mirroring integrated architecture." border="false" lightbox="media/mongodb-mirroring-integrated-arch.png":::

Open Mirroring enables MongoDB change data to be written directly into Fabric, where it's automatically converted to Delta format and made immediately available for Lakehouse, Data Warehouse, Real-Time Analytics, and Power BI.

The article also provides guidance for alternative ingestion approaches—including Real-Time Intelligence (RTI), Azure Functions with Atlas triggers (push), and Fabric pipelines (pull)—to support a range of operational and analytical requirements.

### Alternatives

Fabric supports additional patterns for integrating MongoDB Atlas. These alternatives may be appropriate depending on latency, operational constraints, or existing infrastructure.

#### Real-Time Intelligence (Eventstream + Eventhouse)

Fabric Real-Time Intelligence (RTI) provides a native, code-free ingestion path using the [**MongoDB CDC connector**](/fabric/real-time-intelligence/event-streams/add-source-mongodb-change-data-capture) for Eventstream. The connector streams change events from MongoDB Atlas directly into Fabric.

Eventstream routes CDC events to:

- **Eventhouse (KQL Database)** – For real-time analytics, anomaly detection, and observability.  
- **OneLake** – For downstream Lakehouse or Data Warehouse processing.  
- **Lakehouse folders** – For Spark, SQL analytics, or ML workloads.

**When to use this approach**

- Operational real-time dashboards  
- High-throughput log/event processing  
- KQL-based monitoring and detections  
- Low-latency scenarios without custom code

#### Atlas triggers → Functions → OneLake (push model)

This approach uses [**MongoDB Atlas Triggers**](https://github.com/mongodb/atlas-functions-triggers-examples) to invoke a **Fabric Function** (or Azure Function when Fabric Function isn't available). The function writes the updated document into OneLake using the ADLS Gen2-compatible API.

:::image type="content" source="media/azure-fabric-analytics-mongodb.svg" alt-text="Architecture diagram showing MongoDB CDC ingestion using Fabric Real-Time Intelligence." lightbox="media/azure-fabric-analytics-mongodb.svg" border="false":::

**Dataflow**

1. Atlas trigger detects inserts/updates/deletes.  
2. Trigger invokes an Atlas Function.  
3. Atlas Function posts a payload to a Fabric Function/Azure Function.  
4. Function writes the JSON document to OneLake.  
5. Optional: A Fabric pipeline transforms and loads the document into Lakehouse or Data Warehouse.

This push model is useful when you need near real-time ingestion but can't deploy the mirroring accelerator, or when you prefer a serverless, event-driven integration.

#### Fabric Pipelines and MongoDB Connector (pull model)

Fabric pipelines include a [**MongoDB connector**](/fabric/data-factory/connector-mongodb-overview) that supports on-premises MongoDB and MongoDB Atlas.

**Typical uses**

- Historical data loads  
- Daily/hourly scheduled syncs  
- Incremental ingestion using MongoDB queries  
- Multicloud or hybrid integration

Pipelines can load documents into:

- **Lakehouse** (Delta/Parquet/Avro/JSON/CSV)  
- **Fabric Data Warehouse**

This model is recommended for batch workloads or scenarios where real-time ingestion isn't required.

:::image type="content" source="media/azure-fabric-mongodb-connectors.svg" alt-text="Connector architecture for integrating MongoDB with Fabric pipelines." lightbox="media/azure-fabric-mongodb-connectors.svg" border="false":::

Using Dataflow Gen2 (Power BI / self‑service pull model)

Dataflow Gen2 provides a no‑code, Power BI–centric option to ingest MongoDB Atlas data into OneLake. Customers using Power BI as their primary analytics tool can use the Dataflow Gen2 MongoDB connector to:

- Perform scheduled ingestion
- Retrieve filtered historical data
- Shape and transform documents without code
- Land results directly into OneLake via standard Dataflows Gen2 output

This option is especially suitable for analyst‑driven or self‑service BI scenarios.

#### Batch integration

You can use batch or micro‑batch integration to move historical or filtered data from MongoDB Atlas into OneLake.
In addition to Fabric Pipelines, organizations can leverage the MongoDB Spark Connector (v10.x), which supports both batch and streaming ingestion patterns.

**Spark Connector (batch and streaming)**

The MongoDB Spark Connector enables scalable DataFrame‑based ingestion into the Fabric Lakehouse. It supports:

- Full historical batch loads
- Filtered or incremental loads using MongoDB queries
- Micro‑batch or continuous streaming using Spark Structured Streaming
- Writing into Delta/Parquet tables in OneLake

This approach is optimal for Spark‑centric engineering teams or workloads that require transformations as part of ingestion.

**Fabric Pipelines (optional orchestration)**

Fabric Pipelines can still orchestrate MongoDB batch ingestion through the MongoDB connector if needed, but the Spark Connector provides a more flexible path for both batch and streaming scenarios.

## Scenario details

MongoDB Atlas is a common operational store for internal applications, customer-facing services, and third‑party integrations. With Fabric, organizations can unify Atlas data with relational, streaming, and unstructured sources to power analytics, BI, and ML at scale.

### Potential use cases

**Retail**

- Product bundling and promotion optimization  
- Customer 360 and hyper-personalization  
- Demand sensing and stockout prediction  
- Smart search and recommendations

**Banking and finance**

- Fraud detection and prevention  
- Personalized financial products and offers

**Telecommunications**

- Network quality analytics and optimization  
- Edge telemetry aggregation

**Automotive**

- Connected vehicle intelligence  
- Anomaly detection in IoT communication

**Manufacturing**

- Predictive maintenance  
- Inventory and warehouse optimization

#### Example: Product bundling (retail)

Use sales pattern data to design bundles that increase basket size and margin.

**Data sources**

- Product catalog in **MongoDB Atlas**  
- Sales facts in **Azure SQL**

**Flow**

1. Use a Fabric pipeline to ingest product and sales data into **Fabric Data Warehouse** (or Lakehouse).  
2. Apply **CDC** or event-driven updates for near real-time sync on top of the initial load.  
3. Model affinity and co‑purchase patterns (e.g., Market Basket Analysis) and expose metrics via **Power BI**.

:::image type="content" source="media/product-bundling-use-case-visualization.png" alt-text="Pipeline stages and charts for product bundling, including sales by product, year, region, and affinity." border="false" lightbox="media/product-bundling-use-case-visualization.png":::

**Recommendations from analysis**

- Bundle **pen + ink refill**  
- Promote the bundle in high‑affinity regions

#### Example: Product promotion (retail)

Recommend complementary products using customer behavior, profitability, and product affinity.

**Approach**

- Train **ML models** in Fabric **Spark notebooks** or integrate with **Azure Machine Learning**.  
- Use OneLake as the feature store and serve predictions to **Power BI** or downstream apps.

:::image type="content" source="media/product-promotion-use-case-visualization.png" alt-text="Data pipeline and ML workflow for product promotion using customer and product features." border="false" lightbox="media/product-promotion-use-case-visualization.png":::

If the model achieves high accuracy, it yields a prioritized set of alternative product recommendations per customer or segment.

---

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Use HTTPS and the latest TLS versions for Fabric Function/Azure Function endpoints.  
- Validate inbound payloads as MongoDB change events.  
- Configure **Microsoft Entra ID** authentication and least‑privilege RBAC for Fabric.  
- OneLake inherits ADLS Gen2 security and authentication models.  
- MongoDB Atlas provides built‑in controls for access, network isolation, encryption, and auditing.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Right‑size Fabric capacity and consolidate workloads where reasonable.  
- Batch change documents to reduce function invocations and small files.  
- Compact and OPTIMIZE Lakehouse tables; schedule heavy transforms off‑peak.  
- Use Parquet/Delta compression (Snappy) to lower storage and improve scan performance.  
- Size Atlas clusters appropriately; evaluate sharding and storage tiers.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Batch multiple change events to reduce small‑file overhead.  
- Use **Delta** for optimized Spark, SQL, and BI queries.  
- Choose partitioning and distribution strategies appropriate for large warehouses.  
- Tune pipeline parallelism; apply **pushdown filters** on MongoDB connectors.  
- Monitor ingestion lag; implement retries and idempotent upserts.  
- Schedule **OPTIMIZE** and **VACUUM** for Lakehouse maintenance.
- Push (Mirroring accelerator, triggers → Functions, RTI) – Best for near real-time, event-driven ingestion.
- Pull (pipelines) – Best for scheduled, batch, or micro-batch workloads.
- Data Warehouse – Use for governed relational models and enterprise BI.
- Lakehouse SQL endpoint – Use for lightweight SQL over Delta without warehouse provisioning.

## Conclusion

Microsoft Fabric and MongoDB Atlas integrate seamlessly through **Open Mirroring**, enabling real-time analytical experiences over operational data with minimal engineering effort. Alternative ingestion patterns—including Real-Time Intelligence, serverless event‑driven ingestion, and batch pipelines—provide flexibility to match diverse business and technical requirements.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Rodrigo Rodríguez](https://www.linkedin.com/in/rod2k10/) | Senior Cloud Solution Architect, AI & Quantum
- [Diana Annie Jenosh](https://www.linkedin.com/in/diana-jenosh-0b014814) | Advisory Solutions Architect - MongoDB Partners team

Other contributors:

- [Sunil Sabat](https://www.linkedin.com/in/sunilsabat/) | Principal Program Manager - ADF team

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Fabric overview](/fabric/fundamentals/microsoft-fabric-overview)
- [MongoDB mirroring accelerator for Microsoft Fabric](https://mongodb.com/company/blog/technical/near-real-time-analytics-mirroring-microsoft-fabric-for-mongodb-atlas)
- [MongoDB Atlas on Azure Marketplace](https://marketplace.microsoft.com/en-us/product/mongodb.mongodb_atlas_azure_native_prod?tab=Overview)
- [MongoDB horizontal use cases](https://www.mongodb.com/use-cases)
- [MongoDB industry-specific use cases](https://www.mongodb.com/industries)
- [App Service overview](/azure/app-service/overview)
- [What is Power BI?](https://powerbi.microsoft.com/what-is-power-bi)

## Related resource

- [Real-time analytics on data with Azure Service Bus and Azure Data Explorer](../../solution-ideas/articles/analytics-service-bus.yml)

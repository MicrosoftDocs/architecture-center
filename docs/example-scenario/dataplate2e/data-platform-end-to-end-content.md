<!-- cSpell:ignore fabraga -->

This solution integrates various components of Microsoft Fabric to ingest, store, process, enrich, and deliver data and insights from diverse sources—including structured, semi-structured, unstructured, and streaming data.

## Architecture

:::image type="complex" source="./media/azure-analytics-end-to-end.png" border="false" lightbox="./media/azure-analytics-end-to-end.png" alt-text="Architecture diagram for a modern data platform using Microsoft Fabric.":::
    The diagram presents a detailed architecture on a solution built on Microsoft Fabric. On the left, the architecture begins with diverse data sources including on-premises systems, AWS S3, Google Cloud Storage, and Azure Blob Storage. Real-time data is ingested via evenstreams, and data is mirrored from on-premises databases to cloud platforms like Azure SQL Database, Azure Databricks, and Snowflake. This data is stored in a Lakehouse for raw and semi-structured formats, and in a Data Warehouse for structured analytics, both hosted within Microsoft Fabric.Shortcuts enable seamless access across environments, enhancing agility and integration.

    Moving right, stored data is processed using notebooks, Stored procedures, DataFlow Gen2, and pipelines within Microsoft Fabric. Advanced analytics and machine learning models are applied to enrich the data, both before and after it is served. Processed data is made available through Lakehouse and SQL endpoints, Data Agents, and visualized using Power BI. This enrichment ensures high-quality, actionable insights for end-users.

    At the bottom, the platform layer supports the entire architecture with services like Microsoft Purview for governance, Entra ID for identity management, and Azure Key Vault for secure secrets. CI/CD is enabled through GitHub and Azure DevOps, while Azure Policy enforces compliance. Monitoring is handled via Workspace Monitoring, and Copilot in Fabric provides AI-assisted development. 
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/analytics-with-microsoft-fabric.vsdx) of this architecture*.

### Dataflow

In the following sections, OneLake is used as the home for data throughout the various stages of the data lifecycle. OneLake is the unified, enterprise-grade data lake built into Fabric that serves as a centralized storage Layer for all data workloads including Data Engineering, Data Factory, Data Science, Data Warehouse, Real-Time Intelligence, Databases, and Power BI. 
Fabric offers data stores built on top of OneLake

#### Lakehouse

Use [Lakehouse](/fabric/data-engineering/lakehouse-overview)  in Microsoft Fabric when you need a unified, scalable, and flexible platform.
It is ideal for managing structured, semi-structured, and unstructured data to support analytics, machine learning, and reporting. Follow the [medallion architecture](/fabric/onelake/onelake-medallion-lakehouse-architecture) with Bronze(raw), Silver(validated), Gold(business-ready) for organizing data using folders and files, databases, and tables.  

#### Warehouse

Use [Warehouse](/fabric/data-warehouse/data-warehousing) in Microsoft Fabric when you need a high-performance, fully managed, SQL-based analytics solution to manage structured and semi-structured data by organizing data into databases, schemas, and tables. It has full T-SQL support including creation of stored procedures, views, and joins. 

#### Eventhouse

Use [Eventhouse](/fabric/real-time-intelligence/eventhouse) in Microsoft Fabric to manage and analyze real-time, high-volume event data.
It supports structured, semi-structured, and unstructured data—such as logs, telemetry, and more—by organizing it into databases, schemas, and tables.

#### Fabric SQL Database

Use [SQL Database](/fabric/database/sql/overview) in Microsoft fabric when you need to unify transactional and analytical workload. Built on the same engine as Azure SQL Database, it offers full T-SQL support and is optimized for seamless integration with the broader Fabric ecosystem.  


The analytics use cases covered by the architecture are illustrated by the different data sources on the left-hand side of the diagram. Data flows through the solution from the bottom up as follows:

#### Azure Databases, external data sources (Azure Databricks, Snowflake) and relational databases

##### Ingest

1. [Mirroring](/fabric/mirroring/overview) enables you to have your existing data estate replicated into OneLake near real-time requiring no complex ETL (Extract Transform Load) processes. See the list of [supported Mirroring Data Sources](/fabric/mirroring/overview#types-of-mirroring). 

2. Use options with [Data Factory pipelines](/fabric/data-factory/data-factory-overview) with [Copy Activity](/fabric/data-factory/copy-data-activity), [Copy Job](/fabric/data-factory/what-is-copy-job), [Dataflows Gen2](/fabric/data-factory/dataflows-gen2-overview) that offers powerful data ingestion features to pull data from a wide variety of databases, both on-premises and in the cloud to include orchestration, transformation, and scheduling capabilities. Check out list of [supported connectors](/fabric/data-factory/connector-overview#supported-connectors-in-fabric) in Fabric. 

3. [T-SQL](/fabric/data-warehouse/ingest-data-tsql) offers powerful capabilities for loading data at scale from your existing Lakehouses and warehouses, enabling you to create new table versions with aggregated data, filtered subsets, or results from complex queries.

##### Store

1. Mirroring creates a read-only replica of your source database that is continuously synchronized with the source system using near real-time replication. The data is stored in Delta Lake format within OneLake. 

2. From the Data Factory pipeline, use a Copy data activity or a Copy Job to stage the data copied from the relational databases into the Lakehouse or the Warehouse. The Onelake architecture with the unification on Delta Lake format offers the flexibility to implement lakehouses using either a medallion framework or a warehouse that is aligned with your organizational needs. 

##### Process

1. Each mirrored database includes an auto-generated SQL Endpoint. You can use T-SQL to run complex aggregations or use Spark Notebooks for data exploration. 

2. Read-only SQL analytics endpoint can also be accessed using [SQL Server Management Studio(SSMS)](/sql/ssms/download-sql-server-management-studio-ssms),[ODBC](/fabric/data-warehouse/how-to-connect#connect-using-odbc), any query tool with the [SQL connection string](/fabric/data-warehouse/how-to-connect#find-the-warehouse-connection-string), or the [mssql extension with Visual Studio Code](/sql/tools/visual-studio-code/mssql-extensions?view=fabric&preserve-view=true).

3. Create Cross-database queries to access the data from your mirrored databases and combine the mirrored data with other Fabric data sources (for example, Lakehouses, Warehouses). 

4. Use Stored procedures to automate SQL logic for data transformations, aggregations in a Warehouse for reusability, and centralizing logic for repetitive tasks. 

5. Use T-SQL to write cross-database queries to warehouses and mirrored databases within the same Fabric Workspace. 

6. When Mirroring is first enabled, it creates a full snapshot for the selected tables from source database. After the initial load, Fabric uses the source database’s Change Data Capture (CDC) to track inserts, updates and deletes. These changes are continuously replicated into OneLake with low latency and near real-time synchronization. You can also create shortcuts to mirrored tables in a Lakehouse and query them via Spark notebooks. 

7. Use Dataflows Gen2 to clean and shape parsed data and to detect schema inconsistencies, nulls, or outliers. Once profiled and transformed, save processed data into Warehouse tables. 

8. For enriching data, use [Spark Notebooks](/fabric/data-engineering/author-execute-notebook) to load the data from Lakehouses or Warehouses. [Train or load ML Models](/fabric/data-science/model-training-overview) using libraries like scikit-learn, XGBoost, or SynapseML. Use [MLFlow to track experiments](/fabric/data-science/machine-learning-experiment) and register models. Score data with [scalable batch](/fabric/data-science/model-scoring-predict) and [realtime predictions](/fabric/data-science/model-endpoints). 

##### Serve

1. Creating a mirroring Database creates a mirrored SQL Database item and a [SQL Analytics Endpoint](/fabric/database/mirrored-database/explore#use-the-sql-analytics-endpoint). Use the SQL analytics endpoint to run read-only queries. You can use [Data Preview](/fabric/data-warehouse/data-preview) to view data within the SQL Analytical Endpoint, or [explore directly in OneLake](/fabric/database/mirrored-database/explore-data-directly). Alternatively you can explore data directly in OneLake or use the [SQL Query editor](/fabric/mirroring/explore#use-sql-queries-to-analyze-data) to create T-SQL queries against data in the Mirrored database item data. You can also access mirrored data with a Lakehouse shortcut and use Spark queries to process data. 

2. Data can be served directly to Power BI. You can create [Semantic models](/training/modules/design-model-power-bi) to simplify the analysis of business data and relationships. Business analysts use Power BI reports and dashboards to analyze data and derive business insights using [Direct Lake](/fabric/data-warehouse/semantic-models#direct-lake-mode) Capability. 

   1. Additionally, you can use a [Fabric Activator](/fabric/real-time-intelligence/data-activator/activator-introduction) to set up alerts on Power BI visuals to monitor metrics that change frequently, define alert conditions and receive Email or Microsoft Teams Notification 

3. Data can also be securely shared with other business units or external trusted partners using [Fabric external data sharing](/fabric/governance/external-data-sharing-overview) with a dedicated Fabric-Fabric Authentication. Data consumers access read-only data via OneLake Shortcuts in their own Lakehouse. 

4. Use the [Fabric API for GraphQL](/fabric/data-engineering/api-graphql-overview), which allows you to expose data from [supported Fabric data sources](/fabric/data-engineering/api-graphql-overview#supported-data-sources) through a single, flexible API endpoint. This is ideal for building modern applications that require efficient, real-time access to structured data. 

5. Serve real-time predictions from any registered ML model using secure, scalable [ML online endpoints](/fabric/data-science/model-endpoints) that are automatically configured. If you're looking for a fabric native real-time deployment, these endpoints are built-in properties for most Fabric models and can be called from other Fabric engines or external apps, for wider and reliable consumption.  

6. Enable seamless interaction with enterprise data using [Fabric Data Agent](/fabric/data-science/concept-data-agent) a customizable, AI-powered conversational interface that translates natural language queries into actionable insights. 

7. [Copilot in Fabric](/fabric/fundamentals/copilot-fabric-overview) acts as a generative AI assistive technology to deliver data to users and applications. All Copilot experiences in Microsoft Fabric act as a unified serving layer by translating natural language into actionable insights, code, or visualizations across workloads. They intelligently interpret user intent, enrich it with contextual data, and deliver tailored outputs—making complex tasks simpler and more accessible for users at every level. 

#### Cloud based data platform for Dataverse

##### Ingest

1. [Link to Microsoft Fabric for Dataverse](/power-apps/maker/data-platform/azure-synapse-link-view-in-fabric) enables you to have Dynamics and Dataverse data available near-real time in Microsoft Fabric immediately with no ETL or no data copy requirement. When using Link to Microsoft Fabric for Dataverse, Data engineers can use SQL, apply AI, combine data, reshape, and build summaries. 

##### Store

1.  When using Link to Microsoft Fabric for Dataverse, Dataverse creates a Lakehouse in OneLake that contains shortcuts to Dataverse tables with no physical data movement.  

##### Process

1. [View](/power-apps/maker/data-platform/fabric-work-data-and-power-bi#explore-the-dataverse-generated-azure-synapse-analytics-lakehouse) the Dataverse generated Lakehouse to explore the tables that are linked from your Dataverse environment. 

2. You can query the Dataverse generated Lakehouse with [SQL endpoint](/power-apps/maker/data-platform/fabric-work-data-and-power-bi#explore-data-with-sql-endpoint), explore data using [Spark Notebooks](/fabric/data-engineering/lakehouse-notebook-load-data), and access data using [SQL Server Management Studio(SSMS)](/sql/ssms/download-sql-server-management-studio-ssms) in addition to the SQL Editor 

3. Reference Dataverse data across other Lakehouses using [shortcuts](/fabric/onelake/onelake-shortcuts) to reuse the same data without copying or duplicating it.  

4. For enriching data, use the [Data Wrangler](/fabric/data-science/data-wrangler) a low-code/no-code tool within fabric notebooks to explore and prepare the data for exploratory data analysis. The operations generate code in either pandas or PySpark, which can be saved back into the notebook as a reusable function

##### Serve

1. Data can be served directly to Power BI. The shortcuts to Dataverse tables created in OneLake supports Delta Lake Format and connecting data using high performant [Direct Lake](/fabric/fundamentals/direct-lake-overview) mode. You can create Semantic models to simplify the analysis of business data and relationships. Business analysts use Power BI reports and dashboards to analyze data and derive business insights. 

   1. Additionally, you can use a [Fabric Activator](/fabric/real-time-intelligence/data-activator/activator-introduction) to set up alerts on Power BI visuals to monitor metrics that change frequently, define alert conditions and receive Email or Microsoft Teams Notification 

#### Semi-structured data sources and non-structured data sources

##### Ingest

1. Use [Data Factory pipelines](/fabric/data-factory/data-factory-overview) with [Copy Activity](/fabric/data-factory/copy-data-activity), [Copy Job](/fabric/data-factory/what-is-copy-job), [Dataflows Gen2](/fabric/data-factory/dataflows-gen2-overview), [Spark Notebooks](/fabric/data-engineering/lakehouse-notebook-load-data) to pull data from a wide variety of semi-structured data sources, both on-premises and in the cloud. For example: 

    - Ingest data from file-based sources containing CSV or JSON files.
    - XML files from legacy systems 
    - Parquet files from Storage accounts. 
    - Ingest PDF, MP3, images, logs, documents, and other binary files. that contain the source files.
    - Call [Fabric REST APIs](/fabric/data-factory/pipeline-rest-api-capabilities) as your data source for the pipeline.

2. Use [COPY INTO](/fabric/data-warehouse/ingest-data-copy) statement to work with data from external storage account for high-throughput data ingestion for SQL workloads. Supports PARQUET and CSV File Formats. 

3. Create [shortcuts](/fabric/onelake/onelake-shortcuts) in OneLake to external sources like Azure Data Lake Storage (Gen2), Amazon S3 Storage accounts, Google Cloud Storage account, and [other external supported storages](/fabric/onelake/create-onelake-shortcut) to enable zero-copy access and to avoid duplication. 

4. [Manually](/fabric/data-engineering/load-data-lakehouse#local-file-upload) or programmatically upload files to the Lakehouse folder. 

5. [Trigger pipelines](/fabric/data-factory/pipeline-storage-event-triggers#how-to-set-storage-event-triggers-on-a-pipeline)when new files arrive using Fabric's event-based Orchestration. 

##### Store

1. Within Fabric's OneLake unified data lake, [organize your data](/fabric/onelake/onelake-medallion-lakehouse-architecture) by following the best practices about which layers to create, what folder structures to use in each layer, and what files format to use for each analytics scenario. Land the unstructured data in the Bronze/Raw Zone to store unprocessed data in original format. 

2. Use [Eventhouse](/fabric/real-time-intelligence/eventhouse) for storing Telemetry, logs or time-series data. 

##### Process

1. Use [Spark notebooks](/training/modules/work-delta-lake-tables-fabric/) to parse and transform semi-structured data, for example Flatten nested JSON structures, convert XML to tabular format, or extract key fields from log files. 

2. Use Spark notebooks to extract content and transform unstructured data using Dataframes. 

3. Use T-SQL Ingestion to load the data from existing tables in Lakehouse's or warehouses. 

4. Use Dataflows Gen2 to clean and shape parsed data and to detect schema inconsistencies, nulls or outliers. Once profiled and transformed, save processed data into Lakehouse tables. 

5. Create Internal Shortcuts within the Fabric to reference data in a Lakehouse. 

6. For enriching data, use Spark Notebooks to load the data from Lakehouses or Warehouses. [Train or load ML Models](/fabric/data-science/model-training-overview) using libraries like scikit-learn, XGBoost, or SynapseML. Use [MLFlow to track experiments](/fabric/data-science/machine-learning-experiment) and register models. Score data with [scalable batch](/fabric/data-science/model-scoring-predict) and [realtime predictions](/fabric/data-science/model-endpoints).  

##### Serve

1. Fabric provides a [SQL Analytics endpoint](/fabric/database/mirrored-database/explore#use-the-sql-analytics-endpoint) for querying Lakehouse tables using T-SQL.  

2. Data can be served directly to Power BI. You can create Semantic models to simplify the analysis of business data and relationships. Use DirectLake mode for high-performance analytics. Additionally, you can use a Fabric Activator to set up alerts on Power BI visuals to monitor metrics that change frequently, define alert conditions and receive Email or Microsoft Teams Notification 

3. Data can also be securely shared with other business units or external trusted partners using Fabric external data sharing with a dedicated Fabric-Fabric Authentication. Data consumers access read-only data via OneLake Shortcuts in their own Lakehouse. 

4. Use the Fabric API for GraphQL, which allows you to expose data from supported Fabric data sources through a single, flexible API endpoint. This is ideal for building modern applications that require efficient, real-time access to structured data. 

5. Serve real-time predictions from any registered ML model using secure, scalable ML online endpoints that are automatically configured. If you're looking for a fabric native real-time deployment, these endpoints are built-in properties for most Fabric models and can be called from other Fabric engines or external apps, for wider and reliable consumption. 

6. Enable seamless interaction with enterprise data using [Fabric Data Agent](/fabric/data-science/concept-data-agent) a customizable, AI-powered conversational interface that translates natural language queries into actionable insights. 

7. [Copilot in Fabric](/fabric/fundamentals/copilot-fabric-overview) acts as a generative AI assistive technology to deliver data to users and applications. All Copilot experiences in Microsoft Fabric act as a unified serving layer by translating natural language into actionable insights, code, or visualizations across workloads. They intelligently interpret user intent, enrich it with contextual data, and deliver tailored outputs—making complex tasks simpler and more accessible for users at every level. 


#### Streaming

##### Ingest

1. Real-Time Intelligence in Microsoft Fabric enables users to collect data for real-time data ingestion using [Eventstream](/fabric/real-time-intelligence/event-streams/overview?tabs=enhancedcapabilities) from a wide range of sources such as IoT devices, applications external event hubs, and Fabric events such as Fabric [Workspace Item events](/fabric/real-time-intelligence/event-streams/add-source-fabric-workspace), [Fabric OneLake events](/fabric/real-time-intelligence/event-streams/add-source-fabric-onelake), [Fabric Job events](/fabric/real-time-intelligence/event-streams/add-source-fabric-job). Eventstream in Microsoft Fabric enables you to fetch event data by connecting to various [data sources](/fabric/real-time-intelligence/event-streams/add-manage-eventstream-sources?pivots=enhanced-capabilities). 

2. Ingest data using [Copy Assistant](https://blog.fabric.microsoft.com/en-us/blog/using-data-pipelines-for-copying-data-to-from-kql-databases-and-crafting-workflows-with-the-lookup-activity/) or [Data Factory Pipelines](https://blog.fabric.microsoft.com/en-us/blog/using-data-pipelines-for-copying-data-to-from-kql-databases-and-crafting-workflows-with-the-lookup-activity/)  

3. If you need to reference a source KQL Database such as an existing Azure Data explorer (ADX) in Real-Time Intelligence, you can create a [database shortcut](/fabric/real-time-intelligence/database-shortcut?tabs=workspace) to access this data without duplicating or reingesting data.  

##### Store

1. Eventstream supports routing data to different destinations listed [here](/fabric/real-time-intelligence/event-streams/add-manage-eventstream-destinations?pivots=enhanced-capabilities). 

2. Store large volumes of data in an [EventHouse](/fabric/real-time-intelligence/eventhouse) that is a high performant, optimized and scalable storage solution. You can create a [KQL Database](/fabric/real-time-intelligence/create-database) within an Eventhouse that is a specialized database designed for event-driven data analysis using the Kusto Query language. 

##### Process

1. Use [KQL Queryset](/fabric/real-time-intelligence/create-query-set) to run write, run, and manage Kusto Query Language (KQL) queries across various real-time data sources. It’s a central tool in the Real-Time Intelligence (RTI) experience, enabling users to explore, analyze, and visualize streaming or time-series data. 

2. You can use T-SQL in Microsoft Fabric’s Real-Time Intelligence (RTI) experience to query streaming data stored in KQL databases. While KQL is the primary language for real-time analytics, Fabric also supports T-SQL for users familiar with SQL-based analytics. 

3. For cross-engine processing, turn on [OneLake Availability](/fabric/real-time-intelligence/event-house-onelake-availability) to create a logical copy of KQL database data. You can query the data in your KQL database in Delta Lake format via other Fabric engines such as Direct Lake mode in Power BI, Warehouse, Lakehouse, Notebooks, and more.  

##### Serve

1. Business analysts can create a [Real-time dashboard](/fabric/real-time-intelligence/dashboard-real-time-create), a collection of tiles, each powered by a Kusto Query Language (KQL) query. These tiles can be organized into pages and are connected to [data sources](/fabric/real-time-intelligence/dashboard-real-time-create?tabs=create-manual%2Ckql-database#add-data-source). The dashboard updates automatically, providing near-instant visibility into data as it flows through the system. Additionally, you can add a [Fabric Activator](/fabric/real-time-intelligence/data-activator/activator-introduction) to a Real-Time Dashboard tile to monitor metrics that change frequently, define alert conditions and receive Email or Microsoft Teams Notification. 

2. Create a Power BI report to generate reports from Semantic Models built from the KQL database as a source. 

3. Data can also be securely shared with other business units or external trusted partners using Fabric external data sharing with a dedicated Fabric-Fabric Authentication. Data consumers access read-only data via OneLake Shortcuts in their own Lakehouse. 

4. Enable seamless interaction with enterprise data using [Fabric Data Agent](/fabric/data-science/concept-data-agent) a customizable, AI-powered conversational interface that translates natural language queries into actionable insights. 

5. [Copilot in Fabric](/fabric/fundamentals/copilot-fabric-overview) acts as a generative AI assistive technology to deliver data to users and applications. All Copilot experiences in Microsoft Fabric act as a unified serving layer by translating natural language into actionable insights, code, or visualizations across workloads. They intelligently interpret user intent, enrich it with contextual data, and deliver tailored outputs—making complex tasks simpler and more accessible for users at every level. 


### Components

The following Fabric and Azure services are used in the architecture:

- [Copilot in Fabric](/fabric/fundamentals/copilot-fabric-overview) is a generative AI assistant embedded across the Microsoft Fabric Platform. In this architecture it can be used to build scalable data pipelines, create Spark code for Data transformations, generate optimized SQL for Data Warehouse, create the KQL queries for Real-Time Intelligence, and build Semantic Models and DAX measures for Reporting.

- [Fabric Data Agent](/fabric/data-science/how-to-create-data-agent) is a powerful, AI-driven feature that helps users to interact with their orgnanizational data using natural language. In this architecture, Data Agents act as a conversational interface to translate natural language questions into structured queries (SQL,DAX,or KQL)

- [Microsoft Purview](/azure/purview/overview) is a unified platform for data governance, security, and compliance. In this architecture, Purview governs your entire estate and lineage of data from data source down to the Power BI report.

- [Fabric External data sharing](/fabric/governance/external-data-sharing-overview) is a feature that allows secure, cross-tenant collaboration by allowing users to share data from their Fabric environment with other users in other Fabric Tenant. In this architecture orgganizations can collaborate across tenant boundaries without data duplication.

- [Microsoft Fabric API for GraphQL](/fabric/data-engineering/api-graphql-overview) is a feature that allows developers to expose and interact with data using GraphQL query language. In this architecture, it allows users to develop data applications.

- [Microsoft Power BI](/power-bi/fundamentals/power-bi-overview) is a business intelligence and data visualization platform that provides business intelligence and visualization. In this architecture, it connects to Fabric OneLake to create dashboards and reports.

- [Microsoft Cost Management](/azure/cost-management-billing/costs/overview-cost-management) is a feature that helps you track, analyze, and optimize your  Microsoft Azure Resource invoices. In this architecture, your cost analysis and invoice in Microsoft Cost Management display multiple meters associated with your Fabric capacity resource.

- [Azure Key Vault](/azure/key-vault/general/overview) is a cloud-based service for securely storing and managing sensitive information like secrets, keys, and certificates. In this architecture, it manages credentials used in Fabric connections and Gateways.

- [Azure Policy](/azure/governance/policy/overview) is a governance tool that enforces governance rules across Azure resources. In this architecture, it ensures compliance, data governance, and cost control across the Fabric data platform.

- [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) is a comprehensive suite of development tools and services offered by Microsoft to support the entire software development lifecycle. In this architecture, Azure DevOps integrated with Fabric workspaces for Lifecycle Management and source control.

- [GitHub](https://docs.github.com/get-started/start-your-journey/about-github-and-git) is a cloud-based platform for version control and collaboration that allows developers to store, manage, and track changes to their code. In this architecture, GitHub is integrated with Fabric workspaces for Lifecycle Management and source control.

- [Workspace Monitoring](/fabric/fundamentals/workspace-monitoring-overview) is a feature that allows you to collect, analyze, visualize logs and metrics from Fabric items within a workspace. In this architecture, it helps with query diagnosis within your Fabric Environment, identify and resolve issues, build customized monitoring dashboards, and set alerts. 

### Alternatives

- Microsoft Fabric offers a robust suite of tools designed to efficiently manage data and analytics workloads. With a wide range of options available, choosing the right tool for your specific needs can be complex. The decision guides below serve as a roadmap to help you navigate those choices and identify the most suitable strategy. 

- For comparisons of other alternatives, see:

  - [Choosing type of ingestion in Fabric](/fabric/fundamentals/decision-guide-pipeline-dataflow-spark)
  - [Choose a data integration strategy in Fabric ](/fabric/data-factory/decision-guide-data-integration)
  - [Choosing a data movement strategy in Fabric ](/fabric/data-factory/decision-guide-data-movement)
  - [Choosing a data store in Fabric ](/fabric/fundamentals/decision-guide-data-store)
  - [Choosing between Warehouse and Lakehouse in Fabric ](/fabric/fundamentals/decision-guide-lakehouse-warehouse)

## Scenario details

This example scenario demonstrates how to use Fabric to build a modern data platform that's capable of handling the most common data challenges in an organization. 

### Potential use cases

This approach can also be used to:

- Enterprise Data Platform Modernization to replace fragmented data tools with a unified platform. 

- Establish a [medallion lake architecture](/fabric/onelake/onelake-medallion-lakehouse-architecture), using Fabric’s Lakehouse organized with bronze layer for raw data ingestion from data sources, silver Layer for cleansed and transformed data and gold layer for business ready data for analytics and AI. Warehouses can also be added as subject-area or domain-specific solutions tailored to particular topics that may require customized analytics.

- Integrate relational data sources with other unstructured datasets, with set of [Fabric compute engines](/fabric/fundamentals/microsoft-fabric-overview#fabric-compute-engines). 

- Real-Time Operational Analytics to monitor and act on real-time data using Real Time Intelligence. 

- AI powered customer Insights for data enrichment and deriving business insights. 

- Enterprise Reporting and Self-service BI use semantic modeling and powerful visualization tools for data analysis. 

- Cross-Tenant Data Sharing using OneLake shortcuts with [External data share](/fabric/governance/external-data-sharing-overview). 

- Integrate Microsoft Fabric Data Agents with [Azure AI Foundry](/fabric/data-science/data-agent-foundry) or [Copilot Studio](/fabric/data-science/data-agent-microsoft-copilot-studio) for building intelligent, conversational, and context-aware AI solutions for business users and applications. 

## Recommendations

### Discover and govern

Data governance is a common challenge in large enterprise environments. On one hand, business analysts need to be able to discover and understand data assets that can help them solve business problems. On the other hand, Chief Data Officers want insights on privacy and security of business data.

#### Microsoft Purview

1. [Microsoft Purview ](/purview/data-governance-overview)data governance consists of two solutions. The [Unified Catalog](/purview/unified-catalog) and [Data Map](/purview/data-map) offer a modern governance experience by consolidating metadata from diverse catalogs and sources. This enables comprehensive visibility, enhanced data confidence, and supports responsible innovation across the enterprise

2. Microsoft Purview can help you maintain a [glossary terms](/purview/unified-catalog-glossary-terms-create-manage) with the specific business terminology required for users to understand the semantics of what datasets mean and how they're meant to be used across the organization.

3. You can [register your data sources](/purview/data-map-data-sources-register-manage) and organize them into [Collections](/purview/data-map-domains-collections-manage), which also serves as a security boundary for your metadata.

4. Setup [regular scans](/purview/data-map-scan-ingestion) to automatically catalog and update relevant metadata about data assets in the organization. When a Microsoft Fabric tenant is scanned, [metadata and lineage](/purview/data-map-lineage-fabric) from Fabric assets—including Power BI—are automatically ingested into the Microsoft Purview Unified Data Catalog.

5. [Data classification](/purview/data-map-classification) and [data sensitivity](/purview/data-map-sensitivity-labels) labels can be added automatically to your data assets based on preconfigured or customs rules applied during the regular scans.

6. Data governance professionals can use the [Unified Catalog health management](/purview/unified-catalog-data-health-management) to monitor the overall health over the entire data landscape and protect the organization against any security and privacy issues.

7. A built-in [Purview Hub](/fabric/governance/use-microsoft-purview-hub?tabs=overview) within Fabric provides insights into data inventory, sensitivity labels, and endorsements, acting as a gateway to broader Purview capabilities. 


### Platform services

To improve the quality of your Azure solutions, follow the recommendations and guidelines defined in the [Azure Well-Architected Framework](/azure/well-architected/) five pillars of architecture excellence: Cost Optimization, Operational Excellence, Performance Efficiency, Reliability, and Security.

Microsoft Fabric supports several [deployment patterns](/azure/architecture/analytics/architecture/fabric-deployment-patterns) to help organizations align their data architecture with business needs, governance models, and performance requirements. These patterns are built around four levels of deployment: Tenant, Capacity, Workspace, and item. Each pattern offers different trade-offs in terms of scalability, isolation, cost and operational complexity. 

Following these recommendations, the services below should be considered as part of the design:

- [Microsoft Entra ID](https://azure.microsoft.com/services/active-directory): identity services, single sign-on and multi-factor authentication across Azure workloads.
- [Microsoft Cost Management](https://azure.microsoft.com/services/cost-management): financial governance over your Azure workloads.
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault): secure credential and certificate management. When you configure an [Azure key Vault in Fabric](/fabric/data-factory/azure-key-vault-reference-overview), you can retrieve credentials and certificates from Azure Key Vault used to securely access data stores.
- [Azure Monitor](https://azure.microsoft.com/services/monitor): collect, analyze, and act on telemetry information of your Azure resources to proactively identify problems and maximize performance and reliability.
- [Azure DevOps](https://azure.microsoft.com/solutions/devops) and [GitHub](https://azure.microsoft.com/products/github): implement DevOps practices to enforce automation and compliance with your Fabric workload development and deployment pipelines for seamless version control, collaboration, and lifecycle management.
- [Azure Policy](/azure/governance/policy): implement organizational standards and governance for resource consistency, regulatory compliance, security, cost, and management.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Microsoft Fabric - Pricing](https://azure.microsoft.com/pricing/details/microsoft-fabric/?msockid=154b803cd3036d3935a59673d2546c5d) to estimate costs. The ideal individual pricing tier and the total overall cost of each service included in the architecture is dependent on the amount of data to be processed and stored and the acceptable performance level expected. Use the guide below to learn more about top cost optimization strategies for Microsoft Fabric: 

- Fabric Capacity is a shared pool of capacity that powers all capabilities on Microsoft Fabric from Data engineering, Data warehousing and Data modelling to business intelligence and AI experiences. Microsoft prices CU by the hour with Pay-as-you-go or Reservation. PAYGO offers flexibility to pay only for the hours the Fabric capacity is used (consider pausing capacities when not in use to control costs) without the need for a monthly/yearly commitment. [Reservations](/azure/cost-management-billing/reservations/fabric-capacity) offer predictable billing and up to 40 % savings for stable workloads. 

- [OneLake Storage](https://azure.microsoft.com/pricing/details/microsoft-fabric/?msockid=154b803cd3036d3935a59673d2546c5d) offers a single copy of data across all the Analytical engines without the need for moving of duplication of data. 

- Use the [Fabric Capacity Estimator](https://www.microsoft.com/microsoft-fabric/capacity-estimator) tool to estimate your capacity needs. This tool helps you determine the appropriate SKU and storage requirements based on your workload characteristics. 

- Use the [Fabric Capacity Metrics App](/fabric/enterprise/metrics-app) to monitor usage and consumption by different Fabric Items to understand capacity utilization. 

- Use Azure Cost Management to monitor usage and set budget alerts. [Understand your Azure bill for a Fabric Capacity](/fabric/enterprise/azure-billing). 

- Use the [Microsoft Fabric Capacity troubleshooting guides](/fabric/enterprise/capacity-planning-troubleshoot-consumption) to monitor and optimize the capacity usage proactively.  

- The [Microsoft Fabric Chargeback App](/fabric/enterprise/chargeback-app) is a solution designed to help organizations track, analyze and allocate the capacity usage costs across different business units, users, and workloads using Microsoft Fabric. It supports chargeback and showback models enabling transparent and fair cost distribution based on actual consumption. 

- [Microsoft Purview](https://azure.microsoft.com/pricing/details/azure-purview) is priced based on the number of data assets in the catalog and the amount of compute power required to scan them. 


Similar architecture can also be implemented for preproduction environments where you can develop and test your workloads. Consider the specific requirements for your workloads and the capabilities of each service for a cost-effective pre-production environment. 

See what new features are coming in Fabric and when to expect them: [Microsoft Fabric Roadmap](https://roadmap.fabric.microsoft.com/?product=administration%2Cgovernanceandsecurity).

## Contributors

*This article is being updated and maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Lavanya Sreedhar](https://www.linkedin.com/in/lavanya-sreedhar-17b89015) | Senior Cloud Solution Architect
- [Kevin Lee](https://www.linkedin.com/in/kyungchul-kevin-lee-628607bb) | Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next step

- Review the guidelines defined in the [Fabric Adoption](/power-bi/guidance/fabric-adoption-roadmap) for building scalable analytics environment in Fabric.

- Explore the [Learning Paths](/training/paths/get-started-fabric/) at Microsoft learn for further training content and labs on the services involved in this reference architecture.

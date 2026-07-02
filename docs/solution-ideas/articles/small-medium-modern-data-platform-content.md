[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how small and medium businesses (SMBs) can build a modern data platform architecture by combining existing investments in Azure Databricks with a fully managed software as a service (SaaS) data platform such as Microsoft Fabric. SaaS data platforms are end-to-end data analytics solutions that integrate with tools like Azure Machine Learning, Foundry Tools, Power Platform, Microsoft Dynamics 365, and other Microsoft technologies.

## Simplified architecture

:::image type="complex" border="false" source="../media/small-medium-businesses-simplified-architecture.svg" alt-text="Diagram that shows a simplified modern data platform architecture for SMBs." lightbox="../media/small-medium-businesses-simplified-architecture.svg":::
  Diagram that shows a modern data platform architecture that flows from left to right. On the left, three categories of data sources appear. Unstructured data appears at the top and includes various notation and file types such as .pdf, .docx, and .jpeg for knowledge mines. Semistructured data appears in the middle and includes volume notation and file types such as CSV, logs, JSON, and XML that are loosely typed. Relational databases appear at the bottom and include strongly typed and structured types. An arrow connects these data sources to Azure Data Factory, which orchestrates data ingestion. From Data Factory, data flows into Data Lake Storage, where it's stored in Delta Lake format. A bidirectional arrow connects the store stage to the process and manipulate stage, which includes Azure Databricks for data transformation and analytics. From Azure Databricks, another bidirectional arrow connects to the rightmost stage labeled collaborate and consume. This stage includes Power BI for reports and visualization along with Fabric for extra data platform capabilities.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/small-medium-businesses-simplified-architecture.vsdx) of this architecture.*

The interoperability between Azure Databricks and Fabric provides a robust solution that minimizes data fragmentation while enhancing analytical capabilities.

Fabric provides an open and governed data lake, called OneLake, as the underlying SaaS storage. OneLake and Azure Databricks both use the Delta Parquet format. To access your Azure Databricks data from OneLake, you can [mirror the Azure Databricks Unity Catalog](/fabric/mirroring/azure-databricks) in Fabric to integrate data without replication or data movement. With this integration, you can augment your Azure Databricks analytics systems with generative AI on top of OneLake.

You can also use Direct Lake mode in Power BI on your Azure Databricks data in OneLake. Direct Lake mode simplifies the serving layer and improves report performance. OneLake supports APIs for Azure Data Lake Storage and stores all tabular data in Delta Parquet format.

As a result, Azure Databricks notebooks can use OneLake endpoints to access the stored data. The experience is the same as accessing the data through a Fabric warehouse. With this integration, you can use Fabric or Azure Databricks without reshaping your data.

## Architecture

:::image type="complex" border="false" source="../media/small-medium-businesses-architecture.svg" alt-text="Diagram that shows a complete modern data platform architecture for SMBs." lightbox="../media/small-medium-businesses-architecture.svg":::
  Diagram that shows a modern data platform architecture for SMBs. In step 1, the load and ingest section includes Azure Event Hubs, Azure IoT Hub, Microsoft Dataverse, and Azure Data Factory. An arrow points from Data Factory to Data Lake Storage, which serves as the storage layer and contains data stored in Delta Lake format. Within Data Lake Storage, Delta Lake organizes data into the bronze, silver, and gold medallion tiers that Azure Databricks processes. Structured and unstructured data moves into the existing data lake. In step 2, an arrow labeled Microsoft Fabric Link points from Dataverse to the process and manipulate section. An arrow labeled Azure Synapse Link points from Dataverse to Data Lake Storage. In step 3, an arrow points from streaming data to Event Hubs. Steps 4 and 5 show the cold and hot path, respectively. They split from the Lambda architecture. The cold path points to the store section. The hot path points to the process and manipulate section that includes Fabric Real-Time Intelligence, eventstream, and eventhouse. This section extends into the collaborate and consume section and includes the Fabric dashboard and activator. In step 6, OneLake and Copilot share a section with the Fabric data agent and Fabric analytics. It spans the process and manipulate and collaborate and consume sections. A double-sided arrow labeled Mirrored Azure Databricks Unity Catalog connects Azure Databricks and the OneLake and Copilot section. In step 7, a double-sided arrow connects Azure Databricks and Data Lake Storage. In the collaborate and consume section, an arrow points from Data Science and machine learning to the consume and serve section. The consume and serve section includes Power Apps, Microsoft Dynamics CRM, Power BI, Azure Functions apps, Logic Apps, and web apps. Near the bottom, a discover and govern section includes Microsoft Purview and Unity Catalog. Beneath that section, the platform section includes Microsoft Entra ID, Microsoft Cost Management, Azure Key Vault, Azure Monitor, Microsoft Defender for Cloud, Azure DevOps, and GitHub.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/small-medium-businesses-simplified-architecture.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram:

1. Use existing Azure Data Factory pipelines to ingest structured and unstructured data from source systems and land it in the existing data lake.

1. You can use Microsoft Dynamics 365 data sources to build centralized BI dashboards on augmented datasets by using Azure Synapse Link or Microsoft Fabric Link. Bring the fused, processed data back into Microsoft Dynamics 365 and Power BI for further analysis.

1. Streaming data can be ingested through Azure Event Hubs or Azure IoT Hub, depending on the protocols that send these messages.

1. In the cold path, you can use Azure Databricks to bring the streaming data into the centralized data lake for further analysis, storage, and reporting. This data can then be unified with other data sources for batch analysis.

1. In the hot path, you can analyze data in real time and create real-time dashboards through Microsoft Fabric Real-Time Intelligence.

1. You can use the existing Azure Databricks notebooks to perform data cleansing, unification, and analyses. Consider using medallion architecture such as:

   - Bronze, which holds raw data.
   - Silver, which contains cleaned, filtered data.
   - Gold, which stores aggregated data that's useful for business analytics.

1. For golden data or a data warehouse, continue to use Azure Databricks SQL or create a mirroring of the Azure Databricks Unity Catalog in Fabric. To enable reporting and analytics on a Fabric lakehouse, create a semantic model explicitly and build Power BI dashboards by using Direct Lake or DirectQuery for high performance. For more information, see [Semantic models in Fabric](/fabric/data-warehouse/semantic-models).

The following tools are used for governance, collaboration, security, performance, and cost monitoring.

- Discover and govern:

  - Microsoft Purview provides data discovery services, sensitive data classification, and governance insights across the data estate.

  - Unity Catalog provides centralized access control, auditing, lineage, and data discovery capabilities across Azure Databricks workspaces.

- Platform resources:

  - Microsoft Entra ID provides single sign-on (SSO) for Azure Databricks users. Azure Databricks supports automated user provisioning with Microsoft Entra ID to:

    - Create new users.
    - Assign each user an access level.
    - Remove users and deny them access.
  
  - Microsoft Cost Management provides financial governance services for Azure workloads.
  
  - Azure Key Vault manages secrets, keys, and certificates.

  - Azure Monitor collects and analyzes Azure resource telemetry. This service maximizes performance and reliability by proactively identifying problems.

  - Microsoft Defender for Cloud provides security posture management and threat protection for Azure resources and workloads.

  - Azure DevOps provides continuous integration and continuous deployment (CI/CD) and other integrated version control features.

  - GitHub provides version control and collaborative development capabilities for managing code and deployment pipelines.

### Components

- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a scalable data storage service designed for structured and unstructured data. In this architecture, Data Lake Storage serves as the underlying infrastructure for the Delta Lake. It's the primary storage layer for raw and processed data, which enables efficient data ingestion, storage, and retrieval for analytics and machine learning workloads.

- [Data Factory](/azure/data-factory/introduction) is a cloud-based data integration service that orchestrates and automates data movement and transformation. In this architecture, Data Factory creates, schedules, and orchestrates data pipelines that move and transform data across various data stores and services.

- [Event Hubs](/azure/well-architected/service-guides/azure-event-hubs) is a real-time data ingestion service that can process millions of events per second from any source. In this architecture, Event Hubs captures and streams large volumes of data from various sources to enable real-time analytics and event-driven processing.

- [IoT Hub](/azure/iot-hub/iot-concepts-and-iot-hub) is a managed service that improves security and reliable communication between Internet of Things (IoT) devices and the cloud. In this architecture, IoT Hub facilitates the ingestion, processing, and analysis of telemetry data from IoT devices to provide real-time insights and enable remote monitoring.

- [Microsoft Dataverse](/power-apps/maker/data-platform/data-platform-intro) is a scalable data platform that organizations can use to help securely store and manage data that business applications use. In this architecture, it serves as a data source that feeds into the analytics pipeline via Azure Synapse Link or Microsoft Fabric Link.

  - [Azure Synapse Link](/power-apps/maker/data-platform/export-to-data-lake) is a data integration feature that connects Dynamics applications with either Azure Synapse Analytics or Data Lake Storage. In this architecture, it copies data in near real-time from Dataverse to Data Lake Storage.

  - [Microsoft Fabric Link](/power-apps/maker/data-platform/azure-synapse-link-view-in-fabric) is a data integration feature that connects Dynamics applications to Fabric. In this architecture, it replicates data from Dataverse to Fabric in near real-time.

- [Azure Databricks](/azure/well-architected/service-guides/azure-databricks) is an Apache Spark-based analytics platform for big data processing, machine learning, and data engineering. In this architecture, it performs data cleansing, transformation, and analysis by using medallion architecture layers.

  - [Delta Lake](/azure/databricks/delta/) is an open-source storage layer that brings atomicity, consistency, isolation, and durability (ACID) transactions to Spark and big data workloads. In this architecture, Delta Lake enhances data reliability and performance within the data lake.

  - [Azure Databricks SQL](/azure/databricks/sql) is a SQL-based analytics service that enables users to run SQL queries on data stored in Azure Databricks. In this architecture, Azure Databricks SQL provides a powerful SQL interface to query and analyze data, which enables interactive analytics.

  - [AI and machine learning](/azure/databricks/machine-learning/) encompass a range of technologies and services that enable the development, deployment, and management of machine learning models. In this architecture, AI and Machine Learning services build, train, and deploy predictive models. This capability enables data-driven decision-making.

  - [Unity Catalog](/azure/databricks/data-governance/unity-catalog/) is a data governance solution that provides centralized access control, auditing, lineage, and data discovery capabilities across Azure Databricks workspaces. In this architecture, Unity Catalog helps ensure data governance and security by providing fine-grained access controls, auditing, and data lineage tracking.

- [Medallion lakehouse architecture](/fabric/onelake/onelake-medallion-lakehouse-architecture) is a data architecture pattern that organizes data into bronze, silver, and gold layers for efficient data processing and analytics. In this architecture, it structures data processing workflows by using Data Lake Storage, Delta Lake, and Azure Databricks to support scalable analytics.

- [Fabric](/fabric/fundamentals/microsoft-fabric-overview) is a comprehensive data platform that integrates various data services and tools to provide a seamless data management and analytics experience. In this architecture, Fabric connects and integrates data from multiple sources, which enables comprehensive data analysis and insights across the organization.

  - [Real-Time Intelligence](/fabric/real-time-intelligence/overview) is a data processing capability that enables organizations to ingest, process, and analyze data in real time. Real-Time Intelligence processes streaming data from various sources. In this architecture, it provides real-time insights and enables automated actions based on data patterns.

  - [OneLake shortcuts](/fabric/onelake/onelake-shortcuts) create an in-place link between OneLake and other data sources. In this architecture, they simplify data access and management, and provide a unified view of data across the organization.

  - [Fabric Copilot](/fabric/fundamentals/copilot-fabric-overview) is an AI-powered assistant integrated across Fabric workloads. It uses large language models (LLMs) to help users interact with data by using natural language. It simplifies tasks such as generating SQL, DAX, and transformations, and it creates reports or dashboards. Copilot supports conversational context, creates visualizations, and helps build analytics pipelines. It helps organizations accelerate data insights and optimize workflows without requiring deep coding expertise.

  - A [Fabric data agent](/fabric/data-science/concept-data-agent) is an intelligent, LLM-based service in Fabric that organizations use to query and analyze data across multiple sources, including lakehouses, warehouses, semantic models, KQL databases, and mirrored databases, through a single interface. It supports complex multiple‑step queries, applies custom logic through example queries and agent or data-source instructions, and publishes to Microsoft 365 Copilot or Teams. It provides business users with secure, governed access to enterprise data in natural language.

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a business analytics service that provides interactive visualizations and business intelligence (BI) capabilities. In this architecture, Power BI visualizes data from Fabric and Azure Databricks by using Direct Lake mode for improved performance.

- [Microsoft Purview](/purview/purview) is a unified data governance service that helps organizations manage and govern their data across various sources. In this architecture, it catalogs data, tracks lineage, and enforces compliance across the data estate. You can [integrate Unity Catalog into Purview](/purview/register-scan-azure-databricks-unity-catalog) to access Unity Catalog metadata from Purview.

- [Microsoft Entra ID](/entra/fundamentals/what-is-entra) is a cloud-based identity and access management solution that helps ensure secure sign-ins and access to resources like Microsoft 365, Azure, and other SaaS applications. In this architecture, Microsoft Entra ID provides secure identity and access management for Azure resources. This feature enables secure sign-ins, manages user identities, and helps ensure authorized access to data and resources.

- [Cost Management](/azure/cost-management-billing/costs/overview-cost-management) is a suite of FinOps tools that organizations can use to analyze, monitor, and optimize Microsoft Cloud costs. In this architecture, these tools provide financial governance over Azure resources.

- [Key Vault](/azure/key-vault/general/overview) is a cloud service that stores and manages secrets, such as API keys, passwords, certificates, and cryptographic keys. In this architecture, Azure Databricks can retrieve secrets from Key Vault to authenticate and access Data Lake Storage, which ensures secure integration.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) is a monitoring service that provides full-stack observability for applications, infrastructure, and networks. Azure Monitor enables users to collect, analyze, and act on telemetry data from their Azure and on-premises environments. In this architecture, Azure Monitor ensures performance and reliability by proactively identifying problems.

- [Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) is a cloud-native application protection platform that provides security posture management and threat protection across Azure, hybrid, and multicloud environments. In this architecture, Defender for Cloud secures data platforms and workloads by identifying vulnerabilities, detecting threats, and providing security recommendations across Azure resources.

- [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) is a set of development tools that support a collaborative culture and streamlined processes. These tools enable developers, project managers, and contributors to develop software more efficiently. Azure DevOps provides integrated features such as Azure Boards, Azure Repos, Azure Pipelines, Azure Test Plans, and Azure Artifacts. You can access these features through a web browser or an integrated development environment client. In this architecture, Azure DevOps supports automated deployment and version control for data pipelines and notebooks.

- [GitHub](https://azure.microsoft.com/products/github) is a cloud-based Git repository hosting service that simplifies version control and collaboration for developers. Individuals and teams can store and manage their code, track changes, and collaborate on projects. In this architecture, GitHub integrates with Azure DevOps to enforce automation and compliance in development workflows and deployment pipelines for Data Factory, Azure Databricks, and Fabric.

### Alternatives

- To create an independent Fabric environment, see [Greenfield lakehouse on Fabric](/azure/architecture/example-scenario/data/greenfield-lakehouse-fabric).

- To migrate an on-premises SQL analytics environment to Fabric, see [Modern data warehouses for SMBs](/azure/architecture/example-scenario/data/small-medium-data-warehouse).

#### Service alternatives within this architecture

- **Batch ingestion**

  - Optionally, use [data pipelines in Fabric](/fabric/data-factory/activity-overview) for data integration instead of Data Factory pipelines. The choice depends on several factors. For more information, see [Differences between Azure Data Factory and Fabric Data Factory](/fabric/data-factory/compare-fabric-data-factory-and-azure-data-factory).

- **Microsoft Dynamics 365 ingestion**

  - If you use Data Lake Storage as your data lake storage and want to ingest Dataverse data, use [Azure Synapse Link for Dataverse with Data Lake Storage](/power-apps/maker/data-platform/azure-synapse-link-data-lake). For Dynamics 365 Finance and Operations apps, see [Choose finance and operations data in Azure Synapse Link for Dataverse](/power-apps/maker/data-platform/azure-synapse-link-select-fno-data).
  
  - If you use a Fabric lakehouse as your data lake storage, see [Link your Dataverse environment to Fabric](/power-apps/maker/data-platform/azure-synapse-link-view-in-fabric).

- **Streaming data ingestion**

  - The decision between Azure IoT and Event Hubs depends on the source of the streaming data, whether you need cloning and bidirectional communication with the reporting devices, and the required protocols. For more information, see [Compare IoT Hub and Event Hubs](/azure/iot-hub/iot-hub-compare-event-hubs).

- **Lakehouse**

  - A Fabric lakehouse is a unified data architecture platform for managing and analyzing structured and unstructured data in an open format that primarily uses Delta Parquet files. It supports two storage types. These storage types are managed tables like CSV, Parquet, or Delta, and unmanaged files. Managed tables are automatically recognized. Unmanaged files require explicit table creation. The platform enables data transformations via Spark or SQL endpoints and integrates with other Fabric components. This integration allows data sharing without duplication. This concept aligns with the common medallion architecture that's used in analytic workloads. For more information, see [Lakehouse in Fabric](/fabric/data-engineering/lakehouse-overview).

- **Real-time analytics**

  - *Azure Databricks*

    - If you have an existing Azure Databricks solution, you might want to continue to use Spark structured streaming for real-time analytics. For more information, see [Streaming on Azure Databricks](/azure/databricks/structured-streaming/concepts).

  - *Fabric*

    - If you previously used other Azure services for real-time analytics or have no existing real-time analytics solution, see [Real-time Intelligence versus Azure streaming solutions](/fabric/real-time-intelligence/real-time-intelligence-compare).

    - Fabric structured streaming uses Spark structured streaming to process and ingest live data streams as continuously appended tables. Structured streaming supports various file sources, like CSV, JSON, ORC, Parquet, and messaging services like Kafka and Event Hubs. This approach ensures scalable and fault-tolerant stream processing, which optimizes high-throughput production environments. For more information, see [Data streaming into a lakehouse with Spark](/fabric/data-engineering/lakehouse-streaming-data).

- **Data engineering**

  - Use Fabric or Azure Databricks to write Spark notebooks. For more information, see [Use Fabric notebooks](/fabric/data-engineering/how-to-use-notebook). To learn how Fabric notebooks compare to what Azure Synapse Spark provides, see [Compare Fabric Data Engineering and Azure Synapse Spark](/fabric/data-engineering/comparison-between-fabric-and-azure-synapse-spark). For more information about Azure Databricks notebooks, see [Introduction to Azure Databricks notebooks](/azure/databricks/notebooks/).

- **Data warehouse or gold layer**

  - You can use either Fabric or Azure Databricks to create a SQL-based warehouse or gold layer. For a decision guide on how to choose a data warehouse or gold layer storage solution within Fabric, see [Choose a data store](/fabric/fundamentals/decision-guide-data-store). For more information about SQL warehouse types in Azure Databricks, see [SQL warehouse types](/azure/databricks/compute/sql-warehouse/warehouse-types).

- **Data science**

  - Use either Fabric or Azure Databricks for data science capabilities. For more information about the Fabric Data Science offering, see [Data Science in Fabric](/fabric/data-science/data-science-overview). For more information about the Azure Databricks offering, see [AI and machine learning on Azure Databricks](/azure/databricks/machine-learning/).

  - Fabric Data Science differs from Machine Learning. Machine Learning provides a comprehensive solution for managing workflows and deploying machine learning models. Fabric Data Science is tailored to an analysis and reporting scenario.

- **Power BI**

  - Azure Databricks integrated with Power BI enables data processing and visualization. For more information, see [Connect Power BI to Azure Databricks](/azure/databricks/partners/bi/power-bi).

  - By mirroring Azure Databricks Unity Catalog in Fabric, you can access data that Azure Databricks Unity Catalog manages directly from the Fabric workload. For more information, see [Mirror Azure Databricks Unity Catalog](/fabric/mirroring/azure-databricks). You can query this data from Power BI in [Direct Lake mode](/fabric/fundamentals/direct-lake-overview) without copying the data into the Power BI service.

## Scenario details

SMBs that have an existing Azure Databricks environment, and optionally, a lakehouse architecture, can benefit from this pattern. They currently use an Azure extract, transform, load (ETL) tool such as Data Factory and serve reports in Power BI. However, they might also have multiple data sources that use different proprietary data formats on the same data lake, which leads to data duplication and vendor lock-in concerns. This situation can complicate data management and increase dependency on specific vendors. They might also require up-to-date and near real-time reporting for decision-making and want to adopt AI tools across their environment.

Fabric is an open, unified, and governed SaaS foundation that you can use to:

- Centralize data in OneLake to store, manage, and analyze data in a single location without vendor lock-in concerns.

- Innovate faster with integrations to Microsoft 365 apps.

- Gain rapid insights with the benefits of Power BI Direct Lake mode.​

- Benefit from Copilot in every Fabric experience.

- Accelerate analysis by developing AI models on a single foundation.

- Keep data in place without movement, which reduces the time that data scientists need to provide value.

## Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

To estimate the cost of this solution, use the [preconfigured estimate in the Azure pricing calculator](https://azure.com/e/e656290b2a3f499b97ed8dcfaebc5607). The estimate reflects the architecture described in this article with representative sizing for an SMB workload. Adjust the values to match your actual usage patterns, data volumes, and performance requirements.

- Microsoft Fabric pricing depends on the capacity model. The estimate uses F2, which is a cost-effective entry point for SMBs. Consider reserved capacity for predictable workloads to reduce costs.

- Azure Databricks pricing depends on the workload type, tier, and compute hours. The estimate uses Premium tier All-Purpose Compute at 200 hours per month. Use Jobs Compute for scheduled batch workloads to reduce DBU costs.

- Data Lake Storage pricing depends on storage volume, access tier, and transaction counts. The estimate includes 1 TB of hot-tier storage with hierarchical namespace enabled.

- Azure Data Factory pricing depends on the number of activity runs, data movement volumes, and pipeline execution hours.

- Event Hubs pricing depends on the selected tier and throughput units. The estimate uses the Standard tier with one throughput unit.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Naren Jogendran](https://www.linkedin.com/in/naren-jogendran-46614972/) | Cloud Solution Architect
- [Bonita Rui](https://www.linkedin.com/in/bonita-rui-63b8a7133/) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Learning paths for data engineers](/training/roles/data-engineer)
- [Fabric - Get started with Microsoft Learn](/training/fabric/)
- [Fabric - Microsoft Learn modules](/training/browse/?products=fabric&resource_type=module)
- [Create a storage account for Data Lake Storage](/azure/storage/blobs/create-data-lake-storage-account)
- [Event Hubs quickstart - Create an event hub by using the Azure portal](/azure/event-hubs/event-hubs-create)
- [What is the medallion lakehouse architecture?](/azure/databricks/lakehouse/medallion)
- [What is a lakehouse in Fabric?](/fabric/data-engineering/lakehouse-overview)
  
## Related resource

- [Data lakes](../../data-guide/scenarios/data-lake.md)

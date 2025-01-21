[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how small and medium businesses (SMBs) can combine existing investments in Azure Databricks with a fully managed software as a service (SaaS) data platform such as Microsoft Fabric. SaaS data platforms are end-to-end data analytics solutions that integrate easily with tools like Azure Machine Learning, Azure AI Services, Power Platform, Microsoft Dynamics 365, and other Microsoft technologies.

## Simplified architecture

:::image type="content" source="../media/small-medium-businesses-simplified-architecture.svg" alt-text="Diagram that shows a simplified architecture for small and medium businesses." lightbox="../media/small-medium-businesses-simplified-architecture.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/small-medium-businesses-simplified-architecture.vsdx) of this architecture.*

The interoperability between Azure Databricks and Microsoft Fabric provides a robust solution that minimizes data fragmentation while enhancing analytical capabilities.

Microsoft Fabric provides an open and governed data lake, called OneLake, as the underlying SaaS storage. OneLake uses the Delta Parquet format, which is the same format that Azure Databricks uses. To access your Azure Databricks data from OneLake, you can use [OneLake shortcuts](/fabric/onelake/onelake-shortcuts) in Fabric or [mirror the Azure Databricks Unity Catalog](/fabric/database/mirrored-database/azure-databricks) in Fabric. This integration allows you to augment your Azure Databricks analytics systems with generative AI on top of OneLake.

You can also use the direct lake mode in Power BI on your Azure Databricks data in OneLake. Direct lake mode simplifies the serving layer and improves report performance. OneLake supports APIs for Azure Data Lake Storage and stores all tabular data in Delta Parquet format.

As a result, Azure Databricks notebooks can use OneLake endpoints to access the stored data. The experience is the same as accessing the data through a Microsoft Fabric warehouse. This integration allows you to use Fabric or Azure Databricks without reshaping your data.

## Architecture

:::image type="content" source="../media/small-medium-businesses-architecture.svg" alt-text="Diagram that shows an SMB architecture." lightbox="../media/small-medium-businesses-architecture.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/small-medium-businesses-simplified-architecture.vsdx) of this architecture.*

### Dataflow

1. **Azure Data Factory:** Use existing Azure Data Factory pipelines to ingest structured and unstructured data from source systems and land it in the existing data lake.

1. **Microsoft Dynamics 365:** You can use Microsoft Dynamics 365 data sources to build centralized BI dashboards on augmented datasets by using Azure Synapse Link or Microsoft Fabric Link. Bring the fused, processed data back into Microsoft Dynamics 365 and Power BI for further analysis.

1. **Streaming data ingestion:** Streaming data can be ingested through Azure Event Hubs or Azure IoT Hubs, depending on the protocols that are used to send these messages.

1. **Cold path:** You can bring the streaming data into the centralized data lake for further analysis, storage, and reporting by using Azure Databricks. This data can then be unified with other data sources for batch analysis.

1. **Hot path:** Streaming data can be analyzed in real-time and real-time dashboards can be created through Microsoft Fabric Real-Time Intelligence.

1. **Azure Databricks:** The existing Azure Databricks Notebooks can then be used to perform data cleansing, unification, and analyses as usual. Consider using medallion architecture such as:

   - Bronze, which holds raw data.

   - Silver, which contains cleaned, filtered data.

   - Gold, which stores aggregated data that's useful for business analytics.

1. **Golden data or a data warehouse:** For the golden data or a data warehouse, continue to use Azure Databricks SQL or create a mirroring the Azure Databricks Unity Catalog in Microsoft Fabric. Easily create dashboards based on serverless analysis of data in Fabric lakehouses without any setup required by using the Power BI semantic models that are automatically created for all Fabric lakehouses. Fabric Data Warehouse can also be used as the golden layer if analytical requirements require faster compute.

Tools that are used for governance, collaboration, security, performance, and cost monitoring include:

  - Discover and govern

    - Microsoft Purview provides data discovery services, sensitive data classification, and governance insights across the data estate.

    - Unity Catalog provides centralized access control, auditing, lineage, and data discovery capabilities across Azure Databricks workspaces.

  - Azure DevOps provides continuous integration and continuous deployment and other integrated version control features.

  - Azure Key Vault manages secrets, keys, and certificates.

  - Microsoft Entra ID provides single sign-on for Azure Databricks users. Azure Databricks supports automated user provisioning with Microsoft Entra ID to:

    - Create new users.

    - Assign each user an access level.

    - Remove users and deny them access.

  - Azure Monitor collects and analyzes Azure resource telemetry. This service maximizes performance and reliability by proactively identifying problems.

  - Microsoft Cost Management provides financial governance services for Azure workloads.

### Components

- [Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage/) is a scalable data storage service designed for structured and unstructured data. In this architecture, Data Lake Storage serves as the underlying infrastructure for the Delta Lake. It's the primary storage layer for raw and processed data, which enables efficient data ingestion, storage, and retrieval for analytics and machine learning workloads.

- [Azure Data Factory](https://azure.microsoft.com/products/data-factory/) is a cloud-based data integration service that orchestrates and automates data movement and transformation. Azure Data Factory is used to create, schedule, and orchestrate data pipelines that move and transform data across various data stores and services. It helps ensure seamless data flow and integration.

- [Event Hubs](/azure/well-architected/service-guides/event-hubs) is a real-time data ingestion service that can process millions of events per second from any source. In this architecture, Event Hubs captures and streams large volumes of data from various sources to enable real-time analytics and event-driven processing.

- [Azure IoT Hub](/azure/well-architected/service-guides/iot-hub/reliability) is a managed service that improves security and reliable communication between IoT devices and the cloud. Azure IoT Hub facilitates the ingestion, processing, and analysis of telemetry data from IoT devices to provide real-time insights and enable remote monitoring.

- [Microsoft Dataverse](/power-apps/maker/data-platform/data-platform-intro) is a scalable data platform that organizations can use to help securely store and manage data that business applications use. In this architecture, it's referenced as a potential data source.

  - [Azure Synapse Link](/power-apps/maker/data-platform/export-to-data-lake) connects Dynamics applications with either Azure Synapse Analytics or Data Lake Storage. In this architecture, it's used to copy data in near real-time from Dataverse to Data Lake Storage.

  - [Microsoft Fabric Link](/power-apps/maker/data-platform/azure-synapse-link-view-in-fabric) connects Dynamics applications to Microsoft Fabric. In this architecture, it's used to replicate data from Dataverse to Microsoft Fabric in near real-time.

- [Azure Databricks](https://azure.microsoft.com/products/databricks) is an Apache Spark-based analytics platform. Azure Databricks is used for big data processing, machine learning, and data engineering tasks. This platform provides a collaborative workspace for data scientists and engineers.

  - [Delta Lake](https://databricks.com/product/delta-lake-on-databricks) is an open-source storage layer that brings ACID transactions to Apache Spark and big data workloads. Delta Lake is used to provide this functionality to the data lake storage.

  - [Azure Databricks SQL](/azure/databricks/sql) is a SQL-based analytics service that enables users to run SQL queries on data that's stored in Azure Databricks. In this architecture, Azure Databricks SQL provides a powerful SQL interface to query and analyze data, which enables interactive and ad-hoc analytics.

  - [AI and Machine Learning](/azure/databricks/machine-learning/) encompass a range of technologies and services that enable the development, deployment, and management of machine learning models. AI and Machine Learning services are used to build, train, and deploy predictive models. This capability enables data-driven decision-making.

  - [Unity Catalog](/azure/databricks/data-governance/unity-catalog/) is a data governance solution that provides centralized access control, auditing, lineage, and data discovery capabilities across Databricks workspaces. Unity Catalog helps ensure data governance and security by providing fine-grained access controls, auditing, and data lineage tracking.

- [Medallion lakehouse architecture](/fabric/onelake/onelake-medallion-lakehouse-architecture) is a data architecture pattern that organizes data into bronze, silver, and gold layers for efficient data processing and analytics. This architecture pattern is implemented here by using Data Lake Storage, Delta Lake, and Azure Databricks, which enables scalable and efficient data processing and analytics.

- [Microsoft Fabric](/fabric/) is a comprehensive data platform that integrates various data services and tools to provide a seamless data management and analytics experience. Microsoft Fabric connects and integrates data from multiple sources, which enables comprehensive data analysis and insights across the organization.

  - [Real-Time Intelligence](/fabric/real-time-intelligence/overview) is a data processing capability that enables organizations to ingest, process, and analyze data in real time. Real-Time Intelligence processes streaming data from various sources. It provides real-time insights and enables automated actions based on data patterns.

  - [OneLake shortcuts](/fabric/onelake/onelake-shortcuts) create an in-place link between OneLake and another data source. OneLake shortcuts are used to streamline data access and management, which provides a unified view of data across the organization.

- [Power BI](https://azure.microsoft.com/products/power-bi/) is a business analytics service that provides interactive visualizations and business intelligence capabilities. It has a simple interface for users to create their own interactive reports and dashboards. These tools enable data visualization and insights for business users.

- [Microsoft Purview](https://azure.microsoft.com/products/purview) is a unified data governance service that helps organizations manage and govern their data across various sources. Microsoft Purview provides data cataloging, lineage tracking, and data governance capabilities. These features help ensure data compliance and security across the organization.

  - [Connect to and manage Azure Databricks Unity Catalog](/purview/register-scan-azure-databricks-unity-catalog?tabs=MI): You can integrate Unity Catalog into Purview to access Unity Catalog metadata from Purview.

- [Microsoft Entra ID](https://azure.microsoft.com/products/active-directory) is a cloud-based identity and access management solution that helps ensure secure sign-ins and access to resources like Microsoft 365, Azure, and other SaaS applications. In this architecture, Microsoft Entra ID provides secure identity and access management for Azure resources. This feature enables secure sign-ins, manages user identities, and helps ensure that access to data and resources is authorized.

- [Microsoft Cost Management](https://azure.microsoft.com/products/cost-management) is a suite of FinOps tools that organizations can use to analyze, monitor, and optimize Microsoft Cloud costs. These tools provide financial governance over Azure resources in this architecture.

- [Key Vault](https://azure.microsoft.com/products/key-vault) is a cloud service that stores and manages secrets, such as API keys, passwords, certificates, and cryptographic keys. This service allows users and applications to access these secrets safely. When you store your keys and secrets in Key Vault, you can manage them in a single place. In this architecture, Azure Databricks can retrieve secrets from Key Vault to authenticate and access Data Lake Storage. This process helps ensure secure and seamless integration between these services.

- [Azure Monitor](https://azure.microsoft.com/products/monitor) is a comprehensive monitoring service that provides full-stack observability for applications, infrastructure, and networks. Azure Monitor enables users to collect, analyze, and act on telemetry data from their Azure and on-premises environments to proactively identify problems and maximize performance and reliability.

- [Azure DevOps](https://azure.microsoft.com/products/devops) is a set of development tools that support a collaborative culture and streamlined processes. These tools enable developers, project managers, and contributors to develop software more efficiently. Azure DevOps provides integrated features such as Azure Boards, Azure Repos, Azure Pipelines, Azure Test Plans, and Azure Artifacts. You can access these features through a web browser or an integrated development environment client.

- [GitHub](https://azure.microsoft.com/products/github) is a cloud-based Git repository hosting service that simplifies version control and collaboration for developers. It allows individuals and teams to store and manage their code, track changes, and collaborate on projects by using Git. The user-friendly GitHub interface makes Git accessible to coders of all skill levels. You can use Azure DevOps and GitHub together to implement DevOps practices. These practices enforce automation and compliance in your workload development and deployment pipelines for Azure Data Factory, Azure Databricks, and Microsoft Fabric.

### Alternatives

- To create an independent Microsoft Fabric environment, see [Greenfield lakehouse on Microsoft Fabric](/azure/architecture/example-scenario/data/greenfield-lakehouse-fabric).

- To migrate an on-premises SQL analytics environment to Microsoft Fabric, see [Modern data warehouses for small and midsize-sized businesses](/azure/architecture/example-scenario/data/small-medium-data-warehouse).

#### Service alternatives within this architecture

- **Batch ingestion**

  - Optionally, use [Fabric Data Pipeline](/fabric/data-factory/activity-overview) for data integration instead of Data Factory pipelines. The choice depends on several factors. For more information, see [Getting from Azure Data Factory to Data Factory in Microsoft Fabric](/fabric/data-factory/compare-fabric-data-factory-and-azure-data-factory).

- **Microsoft Dynamics 365 ingestion**

  - If you use Azure Data Lake as your data lake storage and want to ingest Dataverse data, use [Azure Synapse Link for Dataverse with Azure Data Lake](/power-apps/maker/data-platform/azure-synapse-link-data-lake). For Dynamics Finance and Operations, see [FnO Azure Synapse Link for Dataverse](/power-apps/maker/data-platform/azure-synapse-link-select-fno-data).
  
  - If you use Microsoft Fabric Lakehouse as your data lake storage, see [Fabric Link](/power-apps/maker/data-platform/azure-synapse-link-view-in-fabric).

- **Streaming data ingestion**

  - The decision between Azure IoT and Event Hubs depends on the source of the streaming data, whether cloning and bidirectional communication with the reporting devices is needed, and the required protocols. For more information, see [Compare IoT Hub and Event Hubs](/azure/iot-hub/iot-hub-compare-event-hubs).

- **Lakehouse**

  - Microsoft Fabric Lakehouse is a unified data architecture platform for managing and analyzing structured and unstructured data in an open format that primarily uses Delta Parquet files. It supports two storage types. These storage types are managed tables like CSV, Parquet, or Delta, and unmanaged files. Managed tables are automatically recognized. Unmanaged files require explicit table creation. The platform enables data transformations via Spark or SQL endpoints and integrates seamlessly with other Microsoft Fabric components. This seamless integration allows data sharing without duplication. This concept aligns with the common medallion architecture that's used in analytic workloads. For more information, see [Lakehouse in Microsoft Fabric](/fabric/data-engineering/lakehouse-overview).

- **Real-time analytics**

  - *Azure Databricks*

    - If you have an existing Azure Databricks solution, you might want to continue to use Structured Streaming for real-time analytics. For more information, see [Streaming on  Databricks](/azure/databricks/structured-streaming/).

  - *Microsoft Fabric*

    - If you used other Azure services for real-time analytics in the past or have no existing real-time analytics solution, see [Fabric Real-time Intelligence versus Azure Streaming Solutions](/fabric/real-time-intelligence/real-time-intelligence-compare?branch=main).

    - Microsoft Fabric structured streaming uses Spark Structured Streaming to process and ingest live data streams as continuously appended tables. Structured streaming supports various file sources, like CSV, JSON, ORC, Parquet, and messaging services like Kafka and Event Hubs. This approach ensures scalable and fault-tolerant stream processing, which optimizes high-throughput production environments. For more information, see [Microsoft Fabric Spark Structured Streaming](/fabric/data-engineering/lakehouse-streaming-data).

- **Data engineering**

  - Use either Microsoft Fabric or Azure Databricks to write Spark notebooks. For more information, see [How to use Microsoft Fabric notebooks](/fabric/data-engineering/how-to-use-notebook). To learn how Fabric notebooks compare to what Azure Synapse Spark provides, see [Compare Fabric Data Engineering and Azure Synapse Spark](/fabric/data-engineering/comparison-between-fabric-and-azure-synapse-spark). For more information about Azure Databricks notebooks, see [Introduction to Databricks notebooks](/azure/databricks/notebooks/).

- **Data warehouse or gold layer**

  - You can use either Microsoft Fabric or Azure Databricks to create a SQL-based warehouse or gold layer. For a decision guide on how to choose a data warehouse or gold layer storage solution within Microsoft Fabric, see [Microsoft Fabric decision guide: choose a data store](/fabric/get-started/decision-guide-data-store). For more information about SQL warehouse types in Azure Databricks, see [SQL warehouse types](/azure/databricks/admin/sql/warehouse-types).

- **Data science**

  - Use either Microsoft Fabric or Azure Databricks for data science capabilities. For more information about the Microsoft Fabric Data Science offering, see [What is Data Science in Microsoft Fabric?](/fabric/data-science/data-science-overview). For more information about the Azure Databricks offering, see [AI and machine learning on Databricks](/azure/databricks/machine-learning/).

  - Microsoft Fabric Data Science differs from Machine Learning. Machine Learning provides a comprehensive solution for managing workflows and deploying machine learning models. Microsoft Fabric Data Science is tailored to an analysis and reporting scenario.

- **Power BI**

  - Azure Databricks, integrated with Power BI, enables seamless data processing and visualization. For more information, see [Connect Power BI to Azure Databricks](/azure/databricks/partners/bi/power-bi).

  - By mirroring Azure Databricks Unity Catalog in Fabric, you can access data that's managed by Azure Databricks Unity Catalog directly from the Fabric workload. For more information, see [Mirroring Azure Databricks Unity Catalog](/fabric/database/mirrored-database/azure-databricks).

  - Create a shortcut from the Data Lake Storage with Delta Lake into a Microsoft Fabric One Lake. For more information, see [Integrate Databricks Unity Catalog with OneLake](/fabric/onelake/onelake-unity-catalog). You can query this data from Power BI by using Direct Lake mode without copying data into the Power BI Service. For more information, see [Direct Lake Mode](/fabric/get-started/direct-lake-overview).

## Scenario details

Small and medium businesses that have an existing Azure Databricks environment, and optionally, a lakehouse architecture, can benefit from this pattern. They currently use an Azure extract, transform, load tool such as Azure Data Factory and serve reports in Power BI. However, they might also have multiple data sources that use different proprietary data formats on the same data lake, which leads to data duplication and concerns about vendor lock-in. This situation can complicate data management and increase dependency on specific vendors. They might also require up-to-date and near real-time reporting for decision-making and be interested in adopting AI tools across their environment.

Microsoft Fabric is an open, unified, and governed SaaS foundation that you can use to:

- Use OneLake to store, manage, and analyze data in a single location without concerns about vendor lock-in.

- Innovate faster with integrations to Microsoft 365 apps.

- Gain rapid insights with the benefits of Power BI direct lake mode.​

- Benefit from Copilots in every Microsoft Fabric experience.

- Accelerate analysis by developing AI models on a single foundation.

- Keep data in place without movement, which reduces the time that data scientists need to provide value.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Bonita Rui](https://www.linkedin.com/in/bonita-rui-63b8a7133/) | Cloud Solution Architect
- [Naren Jogendran](https://www.linkedin.com/in/naren-jogendran-46614972/) | Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Learning paths for data engineers](/training/roles/data-engineer)
- [Microsoft Fabric - Get Started MSLearn Path](/training/fabric/)
- [Microsoft Fabric - MSLearn modules](/training/browse/?products=fabric&resource_type=module)
- [Create a storage account for Data Lake Storage](/azure/storage/blobs/create-data-lake-storage-account)
- [Event Hubs Quickstart - Create an event hub by using the Azure portal](/azure/event-hubs/event-hubs-create)
- [What is the medallion lakehouse architecture?](/azure/databricks/lakehouse/medallion)
- [What is a lakehouse in Microsoft Fabric?](/fabric/data-engineering/lakehouse-overview)
  
## Related resource

- [Data lakes](../../data-guide/scenarios/data-lake.md)

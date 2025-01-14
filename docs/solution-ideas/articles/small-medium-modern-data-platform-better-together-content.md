[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how small and medium businesses (SMBs) can combine existing investments in Azure Databricks with a fully managed software as a service (SaaS) data platform such as Microsoft Fabric. SaaS data platforms are end-to-end data analytics solutions that integrate easily with tools like Azure Machine Learning, Azure AI Services, Power Platform, Microsoft Dynamics 365, and other Microsoft technologies.

## Simplified architecture

:::image type="content" source="../media/smb-simplified-architecture.svg" alt-text="Diagram that shows a simplified architecture for SMBs." lightbox="../media/smb-simplified-architecture.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/smb-simplified-architecture.vsdx) of this architecture.*

The interoperability between Azure Databricks and Microsoft Fabric delivers a robust solution that minimizes data fragmentation while enhancing analytical capabilities.

Microsoft Fabric provides an open and governed data lake, called OneLake, as the underlying SaaS storage. OneLake uses the Delta Parquet format, which is the same format Azure Databricks uses. To access your Azure Databricks data from OneLake, you can use [OneLake shortcuts](/fabric/onelake/onelake-shortcuts) in Fabric or [mirror the Azure Databricks Unity Catalog](/fabric/database/mirrored-database/azure-databricks) in Fabric. This integration allows you to augment your Azure Databricks analytics systems with generative AI on top of OneLake.

You can also use the direct lake mode in Power BI on your Azure Databricks data in OneLake. Direct lake mode simplifies the serving layer and improves report performance. OneLake supports APIs for Azure Data Lake Storage Gen2 and stores all tabular data in Delta Parquet format.

As a result, Azure Databricks notebooks can use OneLake endpoints to access the stored data. The experience is the same as accessing the data through a Microsoft Fabric warehouse. This integration allows you to use either Fabric or Azure Databricks without reshaping your data.

## Architecture

:::image type="content" source="../media/smb-architecture.svg" alt-text="Diagram that shows an SMB architecture." lightbox="../media/smb-architecture.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/smb-simplified-architecture.vsdx) of this architecture.*

### Dataflow

1. **Azure Data Factory:** Use existing Azure Data Factory pipelines to ingest structured and unstructured data from source systems and land it in the existing data lake.

1. **Microsoft Dynamics 365:** You can use Microsoft Dynamics 365 data sources to build centralized BI dashboards on augmented datasets by using Azure Synapse Link or Microsoft Fabric Link. Bring the fused, processed data back into Microsoft Dynamics 365 and Power BI for further analysis.

1. **Streaming data ingestion:** Streaming data can be ingested through Azure Event Hubs or Azure IoT Hubs, depending on the protocols used to send these messages.

1. **Cold Path:** The streaming data can be brought into the centralized data lake for further analysis, storage, and reporting by using Azure Databricks. This data can then be unified with other data sources for batch analysis.

1. **Hot Path:** Streaming data can be analyzed in real-time and real-time dashboards created through the Microsoft Fabric Real-Time Intelligence.

1. **Azure Databricks:** The existing Azure Databricks Notebooks can then be used to perform data cleansing, unification, and analyses as usual. Consider using medallion architecture such as:

   - Bronze, which holds raw data.

   - Silver, which contains cleaned, filtered data.

   - Gold, which stores aggregated data that's useful for business analytics.

1. **Golden data or a data warehouse:** For the golden data or a data warehouse, continue to use Azure Databricks SQL or create Mirroring the Azure Databricks Unity Catalog in Microsoft Fabric. Easily create dashboards based on serverless analysis of data in Fabric lakehouses without any setup required by using the Power BI semantic models that are automatically created for all Fabric lakehouses. However, Fabric Data Warehouse can also be used as the golden layer if analytical requirements require faster compute.

1. Tools used for governance, collaboration, security, performance, and cost monitoring include:

    - Discover and govern

      - Microsoft Purview provides data discovery services, sensitive data classification, and governance insights across the data estate.

      - Unity Catalog provides centralized access control, auditing, lineage, and data discovery capabilities across Azure Databricks workspaces.

    - Azure DevOps provides continuous integration and continuous deployment and other integrated version control features.

    - Azure Key Vault securely manages secrets, keys, and certificates.

    - Microsoft Entra ID provides single sign-on for Azure Databricks users. Azure Databricks supports automated user provisioning with Microsoft Entra ID to:

      - Create new users.

      - Assign each user an access level.

      - Remove users and denying them access.

    - Azure Monitor collects and analyses Azure resource telemetry. By proactively identifying problems, this service maximizes performance and reliability.

    - Azure Cost Management and Billing provides financial governance services for Azure workloads.

### Components

- [Azure Data Lake Gen2](https://azure.microsoft.com/solutions/data-lake)

- [Azure Data Factory](https://azure.microsoft.com/services/data-factory)

- [Event Hubs](https://azure.microsoft.com/services/event-hubs)

- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub)

- [Microsoft Dataverse](/power-apps/maker/data-platform/data-platform-intro)

  - [Azure Synapse Link](/power-apps/maker/data-platform/export-to-data-lake)

  - [Microsoft Fabric Link](/power-apps/maker/data-platform/azure-synapse-link-view-in-fabric)

- [Azure Databricks](https://azure.microsoft.com/services/databricks)

  - [Delta Lake](https://databricks.com/product/delta-lake-on-databricks)

  - [Azure Databricks SQL](/azure/databricks/sql)

  - [AI and Machine Learning](/azure/databricks/machine-learning/)

  - [Unity Catalog](/azure/databricks/data-governance/unity-catalog/)

- [Implement Medallion Lakehouse Architecture](/fabric/onelake/onelake-medallion-lakehouse-architecture)

- [Microsoft Fabric](/fabric/)

  - [Real-Time Intelligence](/fabric/real-time-intelligence/overview)

  - [OneLake shortcuts](/fabric/onelake/onelake-shortcuts)

  - [Power BI](/power-bi/fundamentals/power-bi-overview)

  - [Direct Lake in Power BI and Microsoft Fabric](/fabric/get-started/direct-lake-overview)

  - [Mirroring Azure Databricks Unity Catalog](/fabric/database/mirrored-database/azure-databricks)

  - [Integrate Databricks Unity Catalog with OneLake](/fabric/onelake/onelake-unity-catalog)

- [Microsoft Purview](https://azure.microsoft.com/services/purview)

  - [Connect to and manage Azure Databricks Unity Catalog](/purview/register-scan-azure-databricks-unity-catalog)

- [Microsoft Entra ID](https://azure.microsoft.com/services/active-directory)

- [Azure Cost Management and Billing](https://azure.microsoft.com/services/cost-management)

- [Key Vault](https://azure.microsoft.com/services/key-vault)

- [Azure Monitor](https://azure.microsoft.com/services/monitor)

- [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction)

- [Azure DevOps](https://azure.microsoft.com/services/devops)

- [Azure Policy](https://azure.microsoft.com/services/azure-policy)

### Alternatives

#### Alternative architectures

- To create an independent Microsoft Fabric environment, see [Greenfield lakehouse on Microsoft Fabric](/azure/architecture/example-scenario/data/greenfield-lakehouse-fabric).

- To migrate an on-premises SQL analytics environment to Microsoft Fabric, see [Modern data warehouses for small and midsize-sized businesses](/azure/architecture/example-scenario/data/small-medium-data-warehouse).

#### Service alternatives within this architecture

- **Batch ingestion**

  - Optionally, use [Fabric Data Pipeline](/fabric/data-factory/activity-overview) for data integration instead of Data Factory pipelines. The choice depends on several factors.
  
  - For a full list of considerations, see [Getting from Azure Data Factory to Data Factory in Microsoft Fabric](/fabric/data-factory/compare-fabric-data-factory-and-azure-data-factory).

- **Microsoft Dynamics 365 ingestion**

  - If you use Azure Data Lake Gen2 as your data lake storage and want to ingest Dataverse data, use [Azure Synapse Link for Dataverse with Azure Data Lake](/power-apps/maker/data-platform/azure-synapse-link-data-lake). For Dynamics Finance and Operations, see [FnO Azure Synapse Link for Dataverse](/power-apps/maker/data-platform/azure-synapse-link-select-fno-data).
  
  - If you use Microsoft Fabric Lakehouse as your data lake storage, see [Fabric Link](/power-apps/maker/data-platform/azure-synapse-link-view-in-fabric).

- **Streaming data ingestion**

  - The decision between Azure IoT and Event Hubs depends on the source of the streaming data, whether cloning and bidirectional communication with the reporting devices is needed, and what protocols are required.

  - For help with making this decision, see [Compare IoT Hub and Event Hubs](/azure/iot-hub/iot-hub-compare-event-hubs).

- **Lakehouse**

  - Microsoft Fabric Lakehouse is a unified data architecture platform for managing and analyzing structured and unstructured data in an open format that primarily uses Delta Parquet files. It supports two storage types. These types are managed tables like CSV, Parquet, or Delta, and unmanaged files. Managed tables are automatically recognized, while unmanaged files require explicit table creation. The platform enables data transformations via Spark or SQL endpoints and integrates seamlessly with other Microsoft Fabric components. This seamless integration allows data sharing without duplication. This concept aligns with the common medallion architecture used in analytic workloads.
  
  - For more information, see [Lakehouse in Microsoft Fabric](/fabric/data-engineering/lakehouse-overview).

- **Real-time analytics**

  - *Azure Databricks*

    - If you have an existing Azure Databricks solution, you might want to continue to use Structured Streaming for real-time analytics. For more information, see [Streaming on  Databricks](/azure/databricks/structured-streaming/).

  - *Microsoft Fabric*

    - If you used other Azure services for real-time analytics in the past or have no existing real-time analytics solution, see [Fabric RTI versus Azure Streaming Solutions](/fabric/real-time-intelligence/real-time-intelligence-compare?branch=main) for more information about the Microsoft Fabric Real-time Intelligence solution and how this compares to other Azure offerings.

    - Microsoft Fabric's structured streaming uses Spark Structured Streaming to process and ingest live data streams as continuously appended tables. Structured streaming supports various file sources like CSV, JSON, ORC, Parquet, and messaging services such as Kafka and Event Hubs. This approach ensures scalable and fault-tolerant stream processing, optimizing high-throughput production environments. For more information, see [Microsoft Fabric Spark Structured Streaming](/fabric/data-engineering/lakehouse-streaming-data).

- **Data engineering**

  - Use either Microsoft Fabric or Azure Databricks to write Spark notebooks. For more information about Microsoft Fabric notebooks, see [How to use Microsoft Fabric notebooks](/fabric/data-engineering/how-to-use-notebook). To learn how Fabric notebooks compare to what Azure Synapse Spark provides, see [Compare Fabric Data Engineering and Azure Synapse Spark](/fabric/data-engineering/comparison-between-fabric-and-azure-synapse-spark).

  - For more information about Azure Databricks notebooks, see [Introduction to Databricks notebooks](/azure/databricks/notebooks/).

- **Data warehouse or gold layer**

  - You can use either Microsoft Fabric and Azure Databricks to create a SQL-based warehouse or gold layer. For a decision guide on how to choose a data warehouse or gold layer storage solution within Microsoft Fabric, see [Microsoft Fabric decision guide: choose a data store](/fabric/get-started/decision-guide-data-store).

  - For more information about SQL warehouse types in Azure Databricks, see [SQL warehouse types](/azure/databricks/admin/sql/warehouse-types).

- **Data science**

  - Use either Microsoft Fabric or Azure Databricks for data science capabilities. For more information about the Microsoft Fabric Data Science offering, see [What is Data Science in Microsoft Fabric?](/fabric/data-science/data-science-overview). For more information about the Azure Databricks offering, see [AI and machine learning on Databricks](/azure/databricks/machine-learning/).

  - Microsoft Fabric Data Science differs from Machine Learning. Machine Learning provides a comprehensive solution for managing workflows and deploying machine learning models. Microsoft Fabric Data Science is tailored to an analysis and reporting scenario.

- **Power BI**

  - Azure Databricks, integrated with Power BI, enables seamless data processing and visualization. For more information, see [Connect Power BI to Azure Databricks](/azure/databricks/partners/bi/power-bi).

  - With a mirrored Azure Databricks Unity Catalog in Fabric you can access data that's managed by Azure Databricks Unity Catalog from the Fabric workload. For more information, see [Mirroring Azure Databricks Unity Catalog](/fabric/database/mirrored-database/azure-databricks).

  - Create a shortcut from the Azure Data Lake Storage (Delta Lake) into a Microsoft Fabric One Lake. For more information, see [Integrate Databricks Unity Catalog with OneLake](/fabric/onelake/onelake-unity-catalog). You can query this data from Power BI by using Direct Lake mode without copying data into the Power BI Service. For more information, see [Direct Lake Mode](/fabric/get-started/direct-lake-overview).

## Scenario details

Small and medium businesses that have an existing Azure Databricks environment and, optionally, already use a lakehouse architecture, can benefit from this pattern. They currently use an Azure ETL tool such as Azure Data Factory and serve reports in Power BI. However, they might also have multiple data sources using different proprietary data formats on the same data lake, which leads to data duplication and concerns about vendor lock-in. This situation can complicate data management and increase dependency on specific vendors. They might also require up-to-date and near real-time reporting for decision-making and be interested in adopting AI tools across their environment.

Microsoft Fabric is an open, unified, and governed SaaS foundation that you can use to:

- Use OneLake to store, manage, and analyze data in a single location without concerns about vendor lock-in.

- Innovate faster with integrations to Microsoft 365 apps.

- Gain rapid insights with the benefits of Power BI direct lake mode.​

- Benefit from Copilots in every Microsoft Fabric experience.

- Accelerate analysis by developing AI models on a single foundation.

- Keep data in place without movement, which reduces the time that data scientists need to deliver value.

## Contributors

*This article is being updated and maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- Bonita Rui | Cloud Solution Architect
- Naren Jogendran | Cloud Solution Architect

## Next steps

- For training content and labs, see [Data Engineer Learning Paths](/training/roles/data-engineer).
- [Microsoft Fabric - Get Started MSLearn Path](/training/fabric/)
- [Microsoft Fabric - MSLearn modules](/training/browse/?products=fabric&resource_type=module)
- [Create a storage account for Data Lake Storage Gen2](/azure/storage/blobs/create-data-lake-storage-account)
- [Event Hubs Quickstart - Create an event hub using the Azure portal](/azure/event-hubs/event-hubs-create)
- [What is the medallion lakehouse architecture? - Azure Databricks | Microsoft Learn](/azure/databricks/lakehouse/medallion)
- [What is a lakehouse in Microsoft Fabric?](/fabric/data-engineering/lakehouse-overview)
  
## Related resource

- Learn more about:
  - [Data lakes](../../data-guide/scenarios/data-lake.md)

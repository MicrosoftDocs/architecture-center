[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

As you load more data into Azure, the need to properly govern and manage that data across all your data sources and data consumers also grows.

If you don't have high-quality data in your Azure data estate, the business value of Azure is undermined. The solution is to build a foundation for data governance and management that can produce and deliver high-quality, trusted data.

Data needs to be managed at scale across on-premises, cloud, and multi-cloud storage to ensure it meets compliance requirements around security, privacy, and usage. Well-managed data can also improve self-discovery, data sharing, and quality, which improves the use of data in applications and analytics.

You can use Azure Purview to ensure definitions, classifications, and governance processes that will help to apply uniformly across all data.

By working with other Azure services, Azure Purview can automatically discover, catalog, classify, and manage data across Azure Data Lake offerings and partner services.

This article describes an architecture that uses these Azure services:

- Azure Data Factory
- Azure Data Lake Storage
- Azure Synapse Analytics
- Power BI

[Azure Purview](/azure/purview/overview) catalogs all data sources, identifies any sensitive information, and defines data lineage. It provides a central platform where you can apply definition and ownership to data. Also, with a single view on reports and insight, it can help you generate data standards that should be imposed on your data.

The main purpose of Azure Purview is to provide governance for finding, classifying, defining, and enforcing policies and standards across data.

## Potential use cases

The requirements for data management differ across industries. For all industries, the need to govern data at scale has increased as the size and complexity of data and data architectures grow. This architecture is appropriate for organizations that would benefit from the following outcomes of well-governed data:
- Automatic discovery of data to accelerate cloud adoption
- Improved security of data for compliance with data laws and regulations
- Improved access, discovery, and quality of managed data to enhance analytics

## Architecture

:::image type="complex" border="false" source="../media/data-lake-purview.png" alt-text="Architecture diagram that shows how Azure Purview scans and classifies data.":::
 Diagram that shows how Azure Purview scans and classifies data. Data Lake Storage connects to Azure Purview via a modern data platform. Azure Purview also connects to Power BI. The diagram also shows integration among these services and Azure AD, Azure Monitor, and Azure Key Vault.
:::image-end:::

_Download a [Visio file](https://arch-center.azureedge.net/data-lake-purview.vsdx) of this architecture._

### Dataflow
Azure Purview is a single, unified data management service across all the data from sources, in the data lake and in end reporting tools.

Scenarios for connecting Azure Purview to Data Lake services:

1. Azure Purview provides an improved-security connection to your data lake ingestion, storage, and analytics pipelines to automatically catalog data assets. It also provides lineage across these functions.
Services include Data Factory, Data Lake Storage, and Azure Synapse Analytics.

2. Azure Purview connects natively with Power BI and other reporting and visualization tools. It shows the lineage of data used in end reports. It also shares sensitivity information from the Power BI assets to prevent incorrect data use.

These scenarios illustrate the options available when you connect to Azure Purview with improved security.

> [!IMPORTANT]
> The information transferred from the sources to Azure Purview is metadata that describes the data within the scanned sources. No actual data is transferred from the sources to Azure Purview.

#### Capabilities

- [Catalog](/azure/purview/overview#data-catalog). The Azure Purview data catalog can automatically capture and describe core characteristics of data at source, including schema, technical properties, and location. The Azure Purview glossary allows a business-friendly definition of data to be layered on top, to improve search and discovery.

- [Classification](/azure/purview/concept-best-practices-classification). Azure Purview automatically classifies datasets and data elements with 100 predefined sensitive-data classifications. It also allows you to define your own custom classification schemes that you can apply manually and automatically.

- [Lineage](/azure/purview/concept-best-practices-lineage-azure-data-factory). Azure Purview diagrammatically visualizes lineage across Data Factory, Azure Synapse Analytics, and Power BI pipelines. These visualizations show the end-to-end flow of data at a granular level.

- [Access control](/azure/purview/how-to-access-policies-storage). The Azure Purview access control policy allows you to define and grant access to data assets from the catalog, directly on the underlying sources.

- Ownership. Azure Purview allows you to apply data ownership and stewardship to data assets and glossary items in the catalog.

- [Insight](/azure/purview/concept-insights). Insights in Azure Purview provide multiple predefined reports to help CDOs, data, and data governance professionals understand the data landscape in detail.

### Components

- [Azure Purview](https://azure.microsoft.com/services/purview) is a unified data catalog that manages on-premises, multicloud, and software as a service (SaaS) data. This data governance service maintains data landscape maps. Features include automated data discovery, sensitive data classification, and data lineage.

- [Data Factory](https://azure.microsoft.com/services/data-factory) is a fully managed, serverless data integration service that helps you construct ETL and ELT processes.

- [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) provides massively scalable, high-security, cost-effective cloud storage for high-performance analytics workloads.

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is a limitless analytics service that brings together data integration, enterprise data warehousing, and big data analytics.

- [Power BI](https://powerbi.microsoft.com/what-is-power-bi) is a collection of software services and apps. These services create and share reports that connect and visualize multiple sources of data. When you use Power BI with Azure Purview, it can catalog and classify your data and provide granular lineage that's illustrated from end to end.

- [Azure Private Link](https://azure.microsoft.com/services/private-link) provides private connectivity from a virtual network to Azure Platform as a Service (PaaS), customer-owned or Microsoft partner services.

- [Azure Key Vault](https://azure.microsoft.com/services/key-vault) stores and controls access to secrets such as tokens, passwords, and API keys. Key Vault also creates and controls encryption keys and manages security certificates.

- [Azure AD](https://azure.microsoft.com/services/active-directory) offers cloud-based identity and access management services. These features provide a way for users to sign in and access resources.

- [Azure Monitor](https://azure.microsoft.com/services/monitor) collects and analyzes data on environments and Azure resources. This data includes apps-telemetry, such as performance metrics and activity logs.

## Next steps

- [Read some of Azure Purview’s customer case studies](https://customers.microsoft.com/en-us/search?sq=%22Azure%20Purview%22&ff=&p=0&so=story_publish_date%20desc)
- [Explore Azure Purview’s technical documentation and best practice](https://docs.microsoft.com/azure/purview/concept-best-practices-accounts)
- [What is Azure Purview?](https://docs.microsoft.com/azure/purview/overview)
- [What is Power BI?](https://powerbi.microsoft.com/what-is-power-bi)
- [Azure Active Directory](https://azure.microsoft.com/services/active-directory)
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory)
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage)
- [Azure Databricks](https://azure.microsoft.com/services/databricks)
- [Azure Monitor](https://azure.microsoft.com/services/monitor)
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics)
- [Key Vault](https://azure.microsoft.com/services/key-vault)

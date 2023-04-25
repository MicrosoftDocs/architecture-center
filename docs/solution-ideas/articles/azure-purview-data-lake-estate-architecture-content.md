[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes a solution that uses Azure Purview to build a foundation for data governance and management that can produce and deliver high-quality, trusted data.

## Architecture

:::image type="complex" border="false" source="../media/data-lake-purview.svg" alt-text="Architecture diagram that shows how Azure Purview scans and classifies data.":::
 Diagram that shows how Azure Purview scans and classifies data. Data Lake Storage connects to Azure Purview via a modern data platform. Azure Purview also connects to Power BI. The diagram also shows integration among these services and Azure AD, Azure Monitor, and Azure Key Vault.
:::image-end:::

_Download a [Visio file](https://arch-center.azureedge.net/data-lake-purview.vsdx) of this architecture._

### Dataflow
Azure Purview provides a single, unified data management service for the data from all sources, in the data lake, and in end reporting tools.

Scenarios for connecting Azure Purview to Data Lake services:

1. Azure Purview provides an improved-security connection to your data lake ingestion, storage, and analytics pipelines to automatically catalog data assets. It also provides lineage across these services. Specific Azure services include Data Factory, Data Lake Storage, and Azure Synapse Analytics.

2. Azure Purview connects natively with Power BI and other reporting and visualization tools. It shows the lineage of data that's used in end reports. It also shares sensitivity information from the Power BI assets to prevent incorrect data use.

> [!IMPORTANT]
> The information that's transferred from the sources to Azure Purview is metadata that describes the data within the scanned sources. No actual data is transferred from the sources to Azure Purview.

#### Capabilities

- [Catalog](/azure/purview/overview#data-catalog). The Azure Purview Data Catalog can automatically capture and describe core characteristics of data at the source, including schema, technical properties, and location. The Azure Purview glossary allows a business-friendly definition of data to be layered on top, to improve search and discovery.

- [Classification](/azure/purview/concept-best-practices-classification). Azure Purview automatically classifies datasets and data elements with 100 predefined sensitive-data classifications. It also allows you to define your own custom classification schemes that you can apply manually and automatically.

- [Lineage](/azure/purview/concept-best-practices-lineage-azure-data-factory). Azure Purview diagrammatically visualizes lineage across Data Factory, Azure Synapse Analytics, and Power BI pipelines. These visualizations show the end-to-end flow of data at a granular level.

- [Access control](/azure/purview/tutorial-data-owner-policies-storage). Azure Purview access control policy allows you to define and grant access to data assets from the catalog, directly on the underlying sources.

- Ownership. Azure Purview allows you to apply data ownership and stewardship to data assets and glossary items in the catalog.

- [Insight](/azure/purview/concept-insights). Insights in Azure Purview provide multiple predefined reports to help CDOs, data professionals, and data governance professionals gain a detailed understanding of the data landscape.

### Components

- [Azure Purview](https://azure.microsoft.com/services/purview) is a unified data catalog that manages on-premises, multicloud, and software as a service (SaaS) data. This data governance service maintains data landscape maps. Features include automated data discovery, sensitive data classification, and data lineage.

- [Data Factory](https://azure.microsoft.com/services/data-factory) is a fully managed, serverless data integration service that helps you construct ETL and ELT processes.

- [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) provides massively scalable, high-security, cost-effective cloud storage for high-performance analytics workloads.

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is a limitless analytics service that brings together data integration, enterprise data warehousing, and big data analytics.

- [Power BI](https://powerbi.microsoft.com/what-is-power-bi) is a collection of software services and apps. These services create and share reports that connect and visualize multiple sources of data. When you use Power BI with Azure Purview, it can catalog and classify your data and provide granular lineage that's illustrated from end to end.

- [Azure Private Link](https://azure.microsoft.com/services/private-link) provides private connectivity from a virtual network to Azure platform as a service (PaaS) services, services that you own, or Microsoft partner services.

- [Azure Key Vault](https://azure.microsoft.com/services/key-vault) stores and controls access to secrets like tokens, passwords, and API keys. Key Vault also creates and controls encryption keys and manages security certificates.

- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) offers cloud-based identity and access management services. These features provide a way for users to sign in and access resources.

- [Azure Monitor](https://azure.microsoft.com/services/monitor) collects and analyzes data on environments and Azure resources. This data includes app telemetry, like performance metrics and activity logs.

## Scenario details

As you load more data into Azure, the need to properly govern and manage that data across all your data sources and data consumers also grows.

If you don't have high-quality data in your Azure data estate, the business value of Azure is diminished. The solution is to build a foundation for data governance and management that can produce and deliver high-quality, trusted data.

Data needs to be managed at scale across on-premises, cloud, and multicloud storage to ensure it meets compliance requirements for security, privacy, and usage. Well-managed data can also improve self-discovery, data sharing, and data quality, which improves the use of data in applications and analytics.

[Azure Purview](/azure/purview/overview) provides governance for finding, classifying, defining, and enforcing policies and standards across data. You can use it to apply definitions, classifications, and governance processes uniformly across data. It catalogs all data sources, identifies any sensitive information, and defines data lineage. It provides a central platform where you can apply definitions and ownership to data. With a single view on reports and insight, it can help you generate data standards that should be applied to your data.

Working with other Azure services, Azure Purview can automatically discover, catalog, classify, and manage data across Azure Data Lake offerings and partner services.

### Potential use cases

The requirements for data management differ across industries. For all industries, the need to govern data at scale has increased as the size and complexity of data and data architectures grow. This appropriate for organizations that would benefit from the following outcomes of well-governed data:

- Automatic discovery of data to accelerate cloud adoption.
- Improved security of data for compliance with data laws and regulations.
- Improved access, discovery, and quality of managed data to enhance analytics.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Isabel Arevalo](https://www.linkedin.com/in/isabel-arevalo-she-her-b24bb162) | Senior Cloud Solution Architect

## Next steps

- [Azure Purview customer case studies](https://customers.microsoft.com/en-us/search?sq=%22Azure%20Purview%22&ff=&p=0&so=story_publish_date%20desc)
- [Microsoft Purview technical documentation and best practices](/azure/purview/concept-best-practices-accounts)
- [What is Microsoft Purview?](/azure/purview/overview)
- [What is Power BI?](https://powerbi.microsoft.com/what-is-power-bi)
- [What is Azure Active Directory?](/azure/active-directory/fundamentals/active-directory-whatis)
- [What is Data Factory?](/azure/data-factory/introduction)
- [Introduction to Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction)
- [What is Azure Databricks?](/azure/databricks/scenarios/what-is-azure-databricks)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [What is Azure Key Vault?](/azure/key-vault/general/basic-concepts)

## Related resources
- [Data analysis workloads for regulated industries](/azure/architecture/example-scenario/data/data-analysis-regulated-industries)
- [Query a data lake or lakehouse by using Azure Synapse serverless](/azure/architecture/example-scenario/data/synapse-exploratory-data-analytics)
- [Choose an analytical data store in Azure](/azure/architecture/data-guide/technology-choices/analytical-data-stores)
- [Choose a data analytics technology in Azure](/azure/architecture/data-guide/technology-choices/analysis-visualizations-reporting)

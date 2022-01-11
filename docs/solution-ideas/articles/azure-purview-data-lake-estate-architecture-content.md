[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

As you load more data into Azure, the need to properly govern and manage that data across all your data sources and data consumers also grows.

Without high-quality data in your Azure data estate, the business value of Azure will be undermined. The solution is to build a foundation for data governance and management that can produce and deliver high-quality, trusted data.

Data needs to be managed at scale across on-premise, cloud, and multi-cloud storage to ensure it meets compliance requirements around security, privacy and usage. Well-managed data can also improve self-discovery, data sharing and quality, improving the use of data in applications and analytics.

With Purview, organizations can ensure definitions, classifications, and governance processes that will help to apply uniformly across all data.

Working together, Microsoft Purview can automatically discover, catalog, classify, and manage data across Microsoft's Azure Data Lake offerings and partner services.

Better together Microsoft services:

- Azure Data Factory.
- Azure Data Lake Storage.
- Azure Synapse Analytics.
- Power BI.

[Azure Purview](https://docs.microsoft.com/azure/purview/overview) catalogs all data sources, identifies any sensitive information and defines data lineage.

Purview provides a central platform where the organization can apply definition and ownership to data.

Also, with a single view on reports and insight, Purview can help you to generate data standards that should be imposed on your data.

Purview's focus is on governance to find, classify, define, and enforce policies and standards across data.

## Potential use cases

The requirements for data management differ across industries, but universally, the need to govern data at scale has increased as the size and complexity of data and data architectures grows. Outcomes of well-governed data include:

- Automatic discovery of data in the organization to accelerate cloud adoption.
- Secure data for compliance with data laws and regulations.
- Improved access, discovery, and quality of managed data to enhance analytics.

## Architecture

:::image type="complex" source="../media/azure-purview-data-lake-estate-architecture.png" alt-text="Architecture diagram showing how Purview scans and classify data a data lake storage":::
 The diagram contains several gray rectangles. Label one represents the connectivity between the data lake storage and Purview via a modern data platform. Number two represents the connectivity between Power BI and Purview. The bottom gray rectangle represents the integration between the services above and AAD, Monitor, and Key Vault
:::image-end:::

_Download a [Visio file](https://arch-center.azureedge.net/[filename].vsdx) of this architecture._

Azure Purview acts as a single, unified data management service across all the data from sources, in the data lake and in end reporting tools.

Scenarios for connecting Purview to Microsoft Data Lake services

1. Azure Purview securely connects to your data lake ingestion, storage, and analytics pipelines to automatically catalog data assets. Also it provides lineage across these functions.
These services include Azure Data Factory, Azure Data Lake Storage, Azure Synapse and more.

2. Azure Purview connects natively with Power BI and other reporting and visualization tools. Purview will show the lineage of data used in end reports. It also share sensitivity information from the Power BI assets to prevent data being used incorrectly.

These scenarios are illustrative of the options available to customers connecting to Purview securely.

> [!IMPORTANT]
> Note that the information transferred from the sources to Purview is metadata describing the data within the scanned sources, no actual data is transferred from the sources to Purview.

### Dataflow

#### Capabilities

- [Catalog](https://docs.microsoft.com/azure/purview/overview#data-catalog). Azure Purview’s data catalog can automatically capture and describe core characteristics of data at source including schema, technical properties, and location. Purview’s glossary allows a business-friendly definition of data to be layered on top to improve search and discovery.

- [Classification](https://docs.microsoft.com/azure/purview/concept-best-practices-classification). Azure Purview automatically classifies data sets and data elements with 100 pre-defined sensitive data classifications. It also allows users to define their own custom classification schemes to apply manually and automatically.

- [Lineage](https://docs.microsoft.com/azure/purview/concept-best-practices-lineage-azure-data-factory). Azure Purview diagrammatically visualizes lineage across ADF, Synapse, and, Power BI pipelines. Showing end-to-end flow of data at a granular level.

- [Access Control](https://docs.microsoft.com/azure/purview/how-to-access-policies-storage). Azure Purview’s access control policy allows users to define and grant access to data assets from the catalog, directly on the underlying sources.

- Ownership. Azure Purview allows data ownership and stewardship to be applied to data assets and glossary items within the catalog.

- [Insight](https://docs.microsoft.com/azure/purview/concept-insights). Insights in Azure Purview provide multiple pre-defined reports for CDOs, data, and data governance professionals to understand the data landscape in detail.

### Components

- [Azure Purview](https://azure.microsoft.com/services/purview/) is a unified data catalog that manages on-premises, multi-cloud, and software as a service (SaaS) data. This data governance service maintains data landscape maps. Features include automated data discovery, sensitive data classification, and data lineage.

- [Data Factory](https://azure.microsoft.com/services/data-factory/) is a fully managed, serverless data integration service to easily construct ETL and ELT processes.

- [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/) is Microsoft’s massively scalable, secure, and cost-effective cloud storage for high-performance analytics workloads.

- [Azure Synapse](https://azure.microsoft.com/services/synapse-analytics/) is a limitless analytics service that brings together data integration, enterprise data warehousing, and big data analytics.

- [Power BI](https://powerbi.microsoft.com/what-is-power-bi/)) is a collection of software services and apps. These services create and share reports that connect and visualize multiple sources of data. Together with Azure Purview, Power BI data can be cataloged, classified, and have granular lineage illustrated end to end.

- [Azure Private Link](https://azure.microsoft.com/services/private-link/) provides private connectivity from a virtual network to Azure Platform as a Service (PaaS), customer-owned or Microsoft partner services.

- [Azure Key Vault](https://azure.microsoft.com/services/key-vault/) stores and controls access to secrets such as tokens, passwords, and API keys. Key Vault also creates and controls encryption keys and manages security certificates.

- [Azure AD](https://azure.microsoft.com/services/active-directory/) offers cloud-based identity and access management services. These features provide a way for users to sign in and access resources.

- [Azure Monitor](https://azure.microsoft.com/services/monitor/) collects and analyzes data on environments and Azure resources. This data includes apps-telemetry, such as performance metrics and activity logs.

## Next steps

- [Read some of Azure Purview’s customer case studies](https://customers.microsoft.com/en-us/search?sq=%22Azure%20Purview%22&ff=&p=0&so=story_publish_date%20desc)
- [Explore Azure Purview’s technical documentation and best practice](https://docs.microsoft.com/azure/purview/concept-best-practices-accounts)
- [What is Azure Purview?](https://docs.microsoft.com/azure/purview/overview)
- [What is Power BI?](https://powerbi.microsoft.com/what-is-power-bi/)
- [Azure Active Directory](https://azure.microsoft.com/services/active-directory/)
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory/)
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage)
- [Azure Databricks](https://azure.microsoft.com/services/databricks/)
- [Azure Monitor](https://azure.microsoft.com/services/monitor/)
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/)
- [Key Vault](https://azure.microsoft.com/services/key-vault/)

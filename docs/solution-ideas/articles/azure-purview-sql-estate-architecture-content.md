[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

As more data is loaded into Azure, the need to properly govern and manage that data across all your data sources and data consumers also grows.

Without high-quality data in your Azure data estate, the business value may be undermined. The solution is to build a foundation for data governance and management that can produce and deliver high-quality, trusted data.

Data needs to be managed at scale across on-premise, cloud, and multi-cloud storage to ensure it meets compliance requirements around security, privacy and usage. Well-managed data can also improve self-discovery, data sharing and quality, improving the use of data in applications and analytics.

With Purview, organizations can ensure definitions, classifications, and governance processes that will help to apply uniformly across all data.

Working together, Microsoft Purview can automatically discover, catalog, classify, and manage data across Microsoft's SQL offerings, whether on premise or in Azure.

Better together Microsoft SQL services:

- On-prem SQL Server.
- Azure SQL.
- SQL Server Managed Instance.
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

:::image type="complex" source="../media/azure-purview-sql-estate-architecture.png" alt-text="Architecture diagram showing how Purview scans and classify data a data lake storage":::
The diagram contains several rectangles. Label on the rectangles read the connectivity between three different cases. Number one represents the connectivity between Azure Purview and On-prem SQL sources. Number two represents the connectivity between Azure SQL to Purview using Private Endpoint. Number three represents the connectivity between SQL Managed Instance to Purview using Private Endpoint. Number 4 represents the connectivity between Power BI and Purview. The rectangle on the bottom represents the integration between the services above and Azure AD, Azure Monitor, and Azure Key Vault.
:::image-end:::




_Download a [Visio file](https://arch-center.azureedge.net/[filename].vsdx) of this architecture._

1. Connecting Purview to **On Premises SQL** via Self-Hosted Integration Run time by Private Endpoint.

2. Connecting Purview to **Azure SQL**via Managed VNet by Managed Private End point.

3. Connecting Purview to **Azure SQL Managed Instance** via Self-Hosted Integration run time by Private end point.

4. Connecting Purview natively to **Power BI.**

These scenarios are illustrative of the options available to customers connecting to Purview securely.

> [!IMPORTANT]
> Note that the information transferred from the sources to Purview is metadata describing the data within the scanned sources, no actual data is transferred from the SQL sources to Purview.

### Dataflow

#### Capabilities

- [Catalog](https://docs.microsoft.com/azure/purview/overview#data-catalog). Azure Purview’s data catalog can automatically capture and describe core characteristics of data at source including schema, technical properties, and location. Purview’s glossary allows a business-friendly definition of data to be layered on top to improve search and discovery.

- [Classification](https://docs.microsoft.com/azure/purview/concept-best-practices-classification). Azure Purview automatically classifies data sets and data elements with over 100 pre-defined sensitive data classifications. It also allows users to define their own custom classification schemes to apply manually and automatically.

- Ownership. Azure Purview allows data ownership and stewardship to be applied to data assets and glossary items within the catalog.

- [Insights](https://docs.microsoft.com/azure/purview/concept-insights). Insights in Azure Purview provide multiple pre-defined reports for CDOs, data, and data governance professionals to understand the data landscape in detail.

### Components

The solution uses the following components:

- [Azure Purview](https://azure.microsoft.com/services/purview/) is a unified data catalog that manages on-premises, multi-cloud, and software as a service (SaaS) data. This data governance service maintains  data landscape maps. Features include automated data discovery, sensitive data classification, and data lineage.

- Microsoft SQL Server is a family of relational database management systems, or RDBMS. The Servers are deployed and managed by Microsoft’s customers.

- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database/) is a fully managed SQL database built for the cloud with automatic updates, provisioning, scaling, and backups.

- [Azure SQL Managed Instance](https://azure.microsoft.com/products/azure-sql/managed-instance) is a cloud database service that provides all the features of SQL server with added protection, connectivity, and automatic updates.

- [Power BI](https://powerbi.microsoft.com/what-is-power-bi) is a collection of software services and apps. These services create and share reports that connect and visualize sources of data.
Together with Azure, Power BI data can be cataloged, classified, and have granular lineage illustrated end to end.

- [Azure Private Link](https://azure.microsoft.com/services/private-link/) provides private connectivity from a virtual network to Azure Platform as a Service (PaaS), customer-owned or Microsoft partner services.

- [Azure Key Vault](https://azure.microsoft.com/services/key-vault) stores and controls access to secrets such as tokens, passwords, and API keys. Key Vault also creates and controls encryption keys and manages security certificates.

- [Azure AD](https://azure.microsoft.com/services/active-directory) offers cloud-based identity and access management services. These features provide a way for users to sign in and access resources.

- [Azure Monitor](https://azure.microsoft.com/services/monitor) collects and analyzes data on environments and Azure resources. This data includes apps-telemetry, such as performance metrics and activity logs.

## Next steps

- [Read some of Azure Purview’s customer case studies](https://customers.microsoft.com/en-us/search?sq=%22Azure%20Purview%22&ff=&p=0&so=story_publish_date%20desc)
- [Explore Azure Purview’s technical documentation and best practice](https://docs.microsoft.com/azure/purview/concept-best-practices-accounts)
- [What is Azure Purview?](https://docs.microsoft.com/azure/purview/overview)
- [What is Power BI?](https://powerbi.microsoft.com/what-is-power-bi)
- [Azure Active Directory](https://azure.microsoft.com/services/active-directory)
- [Azure Cost Management and Billing](https://azure.microsoft.com/services/cost-management)
- [Azure Monitor](https://azure.microsoft.com/services/monitor)
- [Key Vault](https://azure.microsoft.com/services/key-vault)

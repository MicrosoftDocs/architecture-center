[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

As more of your organization's data is loaded into Azure, the need to properly govern and manage that data across all your data sources and data consumers grow.

Without high-quality data in your Azure data estate, the business value can be undermined. The solution is to build a foundation for data governance and management that can produce and deliver trustworthy high-quality data.

Data needs to be managed at scale across on-premises, cloud, and multi-cloud storage. This management ensures compliance requirements are met around security, privacy, and usage. Well-managed data can also improve self-discovery, data sharing, and quality—improving the use of data in applications and analytics.

With [Azure Purview](/azure/purview/overview), organizations can:

- Ensure that definitions, classifications, and governance processes are applied uniformly for your data.
- Provide a central platform where the organization can apply definitions and ownership to your data.
- With a single view on reports and insights, you can generate data standards that should be imposed on your data.
- Focus on governance to find, classify, define, and enforce policies and standards across data.

Azure Purview can automatically discover, catalog, classify, and manage data across Microsoft's SQL offerings, whether on-premises or in Azure. To take advantage of Azure Purview, use these Microsoft SQL services together:

- On-prem SQL Server
- Azure SQL
- SQL Server Managed Instance
- Power BI

## Potential use cases

The requirements for data management differs across industries, but universally, the need to govern data at scale has increased as the size and complexity of data and data architectures grow. The outcomes of a well-governed data include:

- Automatic discovery of data in the organization to accelerate cloud adoption.
- Secure data for compliance with data laws and regulations.
- Improved access, discovery, and quality of managed data to enhance analytics.

## Architecture

:::image type="complex" source="../media/azure-purview-sql-estate-architecture.png" alt-text="Architecture diagram showing how Azure Purview scans and classify data a data lake storage" lightbox="../media/azure-purview-sql-estate-architecture.png ":::
The diagram contains several rectangles. Labels on the rectangles read the connectivity between three different scenarios. First scenario represents the connectivity between Azure Purview and on-premises SQL sources. Second scenario represents the connectivity between Azure SQL to Azure Purview using Private Endpoint. The third scenario represents the connectivity between SQL Managed Instance to Azure Purview using Private Endpoint. The fourth scenario represents the connectivity between Power BI and Azure Purview. The rectangle on the bottom represents the integration between the services above and Azure AD, Azure Monitor, and Azure Key Vault.
:::image-end:::

_Download a [Powerpoint file](https://arch-center.azureedge.net/azure-purview-sql-estate-architecture.pptx) of this architecture._

### Dataflow

The next four scenarios show the options available to customers connecting to Azure Purview securely.

1. Connect Azure Purview to **on-Premises SQL** via Self-Hosted Integration Run time by Private Endpoint.

2. Connect Azure Purview to **Azure SQL** via Managed VNet by Managed Private Endpoint.

3. Connect Azure Purview to **Azure SQL Managed Instance** via Self-Hosted Integration run time by Private Endpoint.

4. Connect Azure Purview natively to **Power BI.**

    > [!NOTE]
    > The information transferred from the sources to Azure Purview is metadata describing the data within the scanned sources. No actual data is transferred from the SQL sources to Azure Purview.
    >

#### Capabilities

- [Catalog](/azure/purview/overview#data-catalog). Azure Purview’s data catalog can automatically capture and describe core characteristics of data at the source. The characteristics include schema, technical properties, and location. Azure Purview’s glossary allows a business-friendly definition of data to be layered on top to improve search and discovery.

- [Classification](/azure/purview/concept-best-practices-classification). Azure Purview automatically classifies data sets and data elements with over 100 pre-defined sensitive data classifications. It also allows users to define their own custom classification schemes that can be applied manually and automatically.

- [Ownership](/azure/purview/quickstart-create-collection). Azure Purview allows data ownership and stewardship to be applied to data assets and glossary items within the catalog.

- [Insights](/azure/purview/concept-insights). Insights in Azure Purview provide multiple pre-defined reports for CDOs, data, and data governance professionals to understand the data landscape in detail.

### Components

The solution uses the following components:

- [Azure Purview](https://azure.microsoft.com/services/purview/) is a unified data catalog that manages on-premises, multi-cloud, and software as a service (SaaS) data. This data governance service maintains  data landscape maps. Features include automated data discovery, sensitive data classification, and data lineage.

- [Microsoft SQL Server](/sql) is a family of relational database management systems, or RDBMS. The Servers are deployed and managed by Microsoft’s customers.

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

## Related resources

- [Data governance with Profisee and Azure Purview](/azure/architecture/reference-architectures/data/profisee-master-data-management-purview)
- [Migrate master data services to Azure with CluedIn and Azure Purview](/azure/architecture/reference-architectures/data/migrate-master-data-services-with-cluedin)
- 

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

The solution described in this article demonstrates how to use Azure Synapse Analytics to build a modern data platform to ingest, process, store, serve, and visualize data from various sources.

## Architecture

:::image type="content" source="../media/big-data-analytics-enterprise-grade-security.svg" alt-text="Diagram showing the data flow in this solution. For a detailed explanation, see the following article text." lightbox="../media/big-data-analytics-enterprise-grade-security.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/big-data-analytics-enterprise-grade-security.vsdx) of this architecture.*

### Dataflow

The data flows through the solution as follows:

1.  The Synapse pipelines copy activities ingest raw structured data from external relational data warehouses, semistructured data such as logs, flat files, and xml, and other source systems. This ingested data is then stored in an Azure Data Lake Storage Gen2 location. Using a self-hosted integration runtime, you can also manage and run copy activities between a data store in your on-premises environment and the cloud.

2.  Azure Data Lake Storage Gen2 provides secure storage.

    -   Using a firewall to limit Storage Account access to trusted Azure services is recommended to limit external attack vulnerability.

    -   [Private endpoints](/azure/private-link/private-endpoint-overview) for your Azure Storage accounts allow clients on the virtual network (VNet) to securely access data over a [Private Link](/azure/private-link/private-link-overview). The private endpoint uses an IP address from the VNet address space for the storage account service. Network traffic between the clients on the VNet and the storage account traverses over the VNet and a private link on the Microsoft backbone network, eliminating exposure to the public internet.

3.  Data is encrypted at rest once it's ingested into the data lake. Using your own customer-managed keys can further protect your encryption keys and add more flexibility when managing access controls.

4.  Data is ingested using Synapse pipelines and processed in stages using the Synapse Spark pool and its Data Lake capabilities. Data is stored in the Azure Storage account using stage-specific Azure Data Lake Storage Gen 2 directories. These stages are:

    1.  The Synapse pipelines copy activities initially ingest data from the source systems. This ingested data is stored in its raw format using the data lake's *Bronze* directory.

    2.  The Synapse Spark pool then runs data quality rules to cleanse the raw data. This enriched data is then stored in the data lake's *Silver* directory.

    3.  After the cleansing process, the Spark pool applies any required normalization, data transformations, and business rules on the data in the Silver directory. This transformed data is then stored in the data lake's *Gold* directory.

5.  The Synapse Apache Spark to Synapse SQL connector pushes the normalized data to the Synapse SQL pool for consumption by downstream applications and reporting services such as Power BI. This connector is designed to optimally transfer data between the serverless Apache Spark pools and the SQL pools in the Azure Synapse Analytics workspace.

6.  The Power BI service uses DirectQuery mode to securely fetch data from the Synapse SQL pool. A data gateway installed in a virtual machine on the private VNet acts as a connecting platform between the Power BI service and the Synapse SQL pool, using Private Endpoint in the same VNet to securely connect.

7.  External applications can access data from the Synapse serverless pools or dedicated SQL pools by accessing the appropriate private endpoints connected to the VNet.

This example solution makes use of several Azure services and features:

-   [Azure Synapse Analytics](/azure/synapse-analytics/overview-what-is) is the core service used in this example solution to provide data ingestion, processing, and analytics.

-   [Azure Data Lake Storage (Gen2)](/azure/storage/blobs/data-lake-storage-introduction)  is built on top of [Azure Storage](/azure/storage/common/storage-introduction) services and provides data lake capabilities that other services in this example solution use when storing and processing data.

-   [Synapse pipelines](/azure/synapse-analytics/get-started-pipelines) copies data from original sources into the data lake storage locations.

-   [Apache Spark in Azure Synapse Analytics](/azure/synapse-analytics/spark/apache-spark-overview) cleanses, normalizes, and performs other processing tasks on data ingested from source locations.

-   [Dedicated SQL pool](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is?toc=/azure/synapse-analytics/toc.json&bc=/azure/synapse-analytics/breadcrumb/toc.json) (formerly SQL DW) provides data warehousing capabilities for data after it's been processed and normalized and is ready for use by your end users and applications.

-   [Serverless SQL pool](/azure/synapse-analytics/sql/on-demand-workspace-overview) allows users to quickly query and analyze processed and normalized data.

-   [Azure Synapse Managed Virtual Network](/azure/synapse-analytics/security/synapse-workspace-managed-vnet) creates an isolated managed virtual networking environment for the Azure Synapse workspace, offloading the need for you to manage networking configuration for the workspace resources.

-   [Azure Synapse Managed private endpoints](/azure/synapse-analytics/security/synapse-workspace-managed-private-endpoints) establish private links to Azure resources and route traffic between your Azure Synapse workspaces and other Azure resources using only the Microsoft backbone network.

-   [Azure Virtual Network (VNet)](/azure/virtual-network/virtual-networks-overview) provides private networking capabilities for Azure resources that aren't a part of the Azure Synapse workspace. It allows you to manage access, security, and routing between resources.

-   [Azure Private Endpoint](/azure/private-link/private-endpoint-overview) provides a private IP address from the solution's VNet to Azure managed services, effectively connecting a service to the VNet. This allows secure networking between the Azure Synapse workspace and other Azure services such as Azure Storage, Azure Cosmos DB, Azure SQL Database, or your own [Azure Private Link service](/azure/private-link/private-link-service-overview).

-   [Power BI](/power-bi) allows users to perform advanced analysis and share insights using the solution's processed data.

### Components

-   [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics)

-   [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage)

-   [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database)

-   [Virtual Network](https://azure.microsoft.com/services/virtual-network)

-   [Azure Private Link](https://azure.microsoft.com/services/private-link)

-   [Power BI](https://powerbi.microsoft.com)

## Scenario details

Azure Synapse Analytics brings together data integration, enterprise data warehousing, and big data analytics to help you build a modern data platform capable of handling the most common data challenges facing large organizations. Azure Virtual Network allows you to create your own private network in the Azure public cloud and managed network, and Azure Private Endpoint allows you to securely integrate managed cloud services into these private networks.

### Potential use cases

The solution described in this article demonstrates how to combine these technologies to build a modern data platform that can ingest, process, store, serve, and visualize data from different sources, both structured and semistructured, while meeting the high security standards your organization expects. This includes supporting common requirements, such as:

-   **Securing data sources.** Data sources inside the on-premises corporate network or on the virtual network are secured behind a firewall. These resources can be securely accessed by installing a self-hosted integration runtime on a resource hosted on-premises or on the virtual networks.

-   **Authentication and authorization using managed identities.** Communication between Azure services can be secured using managed identities, which provide an identity for applications to use when connecting to resources that support Azure Active Directory (Azure AD) authentication. In this example, Azure Synapse uses the managed identity to integrate pipelines.

-   **Private endpoints establishing a private link to Azure resources.** Azure Synapse provides fully managed private endpoint functionality for services within the Synapse workspace (such as Azure Storage or Azure Cosmos DB). Other Azure resources such as Azure applications, Microsoft Power BI, and Azure Synapse service are secured using Private Endpoints integrated into the example solution's virtual network. Network traffic between your private network and the Synapse pools uses Private Link to move traffic over the Microsoft backbone network, eliminating exposure to the public internet.

-   **Encrypting data in transit.** Data is encrypted in transit as all data transfers are via secure channel HTTPS and TLS over TCP to prevent man-in-the-middle attacks during communication with Azure services, ensuring end-to-end secure private data movement.

-   **Encrypting data at rest.** Transparent data encryption in Azure Synapse Analytics helps protect against malicious activity by performing real-time encryption and decryption of your data stored within the Synapse workspace. Azure Storage also encrypts all data in a storage account at rest. By default, data is encrypted with Microsoft-managed keys, but you can manage your own keys if you need additional control over encryption.

## Deploy this scenario

You must have an existing Azure account. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/?WT.mc_id=A261C142F) before you begin.

The Azure Resource Manager templates, which you'll need to deploy the components described in this architecture, are available in the [GitHub](https://github.com/vsuopys/SecureSynapse/tree/master/SecureSynapseARM) repository. These templates will deploy all the services shown in the architecture diagram **except for**: the Power BI Data Gateway, self-hosted integration runtime, and Azure Key Vault for customer managed keys.

It's up to the user to create the data lake folder structure and the Azure Synapse Analytics integration pipelines that are necessary to connect to the data sources.

Deploy the ARM template directly by clicking this button:

[![Deploy to Azure](../../_images/deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fvsuopys%2FSecureSynapse%2Fmaster%2FSecureSynapseARM%2Fazuredeploy.json)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Kiran Kalyanam](https://www.linkedin.com/in/kirankumarkalyanam) | Senior Software Engineer

## Next steps

To learn how to further develop this approach, learn the basics of Azure Synapse Analytics by completing the following tutorials:

-   [Get Started with Azure Synapse Analytics](/azure/synapse-analytics/get-started)

-   [Tutorial: Explore and Analyze data lakes with serverless SQL pool](/azure/synapse-analytics/sql/tutorial-data-analyst)

-   [Analyze data in a storage account](/azure/synapse-analytics/get-started-analyze-storage)

-   [Analyze data with dedicated SQL pools](/azure/synapse-analytics/get-started-analyze-sql-pool)

-   [Integrate with pipelines](/azure/synapse-analytics/get-started-pipelines)

## Related resources

Refer to these articles when planning and deploying solutions using Azure Synapse Analytics:

-   [Data exfiltration protection for Azure Synapse Analytics workspaces](/azure/synapse-analytics/security/workspace-data-exfiltration-protection)

-   [Azure Synapse Analytics IP firewall rules](/azure/synapse-analytics/security/synapse-workspace-ip-firewall)

-   [Azure Synapse Analytics Managed Virtual Network](/azure/synapse-analytics/security/synapse-workspace-managed-vnet)

-   [Synapse Managed private endpoints](/azure/synapse-analytics/security/synapse-workspace-managed-private-endpoints)

-   [Configure Azure Storage firewalls and virtual networks](/azure/storage/common/storage-network-security?tabs=azure-portal)

-   [Connect to Azure Synapse Studio using Azure Private Link Hubs](/azure/synapse-analytics/security/synapse-private-link-hubs)

-   [Connect to a secure Azure storage account from your Synapse workspace](/azure/synapse-analytics/security/connect-to-a-secure-storage-account)

-   [Use Azure Active Directory Authentication for authentication with Synapse SQL](/azure/synapse-analytics/sql/active-directory-authentication)

### Related architecture guidance

-   [Analytics end-to-end with Azure Synapse](../../example-scenario/dataplate2e/data-platform-end-to-end.yml)

-   [Choosing an analytical data store in Azure](../../data-guide/technology-choices/analytical-data-stores.md)

-   [Automated enterprise BI](../../reference-architectures/data/enterprise-bi-adf.yml)

-   [Enterprise business intelligence](/azure/architecture/example-scenario/analytics/enterprise-bi-synapse)

-   [Advanced Analytics Architecture](./advanced-analytics-on-big-data.yml)

-   [Real-time analytics on big data architecture](./real-time-analytics.yml)

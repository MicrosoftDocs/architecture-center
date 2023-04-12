[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Elastic Enterprise Search streamlines the search process for searches of all types of work documents, increasing user productivity.

## Architecture

:::image type="content" source="../media/elastic-workplace-search.png" alt-text="Architecture for Elastic Enterprise Search" lightbox="../media/elastic-workplace-search.png":::

### Dataflow

- Content: Enterprise Search automatically captures, syncs, and indexes the content and key info for all your content sources.
- Ingestion: Enterprise Search uses out-of-the-box connectors to ingest data from many different content sources, such as OneDrive, SharePoint, and GitHub. You can also use custom API sources to build your own connectors. Such connectors make it possible for you to create unique content repositories and send data to Enterprise Search via uniquely identifiable endpoints.
- Relevance: Go beyond global relevance tuning by adjusting relevance on a per-team and per-user basis. You can fine-tune results to ensure that every team in your company has the search engine that it needs to be successful.
- Consumption: Users can find the information that they need by using the Enterprise Search dashboard, or a web browser application, or a custom search.

### Components

The architecture components depend on your deployment choice: Elastic Cloud managed service, Elastic Cloud on Linux VMs, or Elastic Cloud on Kubernetes on Azure Kubernetes Service (AKS).

- [Azure App Service](https://azure.microsoft.com/products/app-service) is a fully managed service for building, deploying, and scaling web apps. You can build apps by using .NET, .NET Core, Node.js, Java, Python, or PHP. Apps can run in containers or on Windows or Linux.
- [AKS](https://azure.microsoft.com/products/kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications.
- [Azure Load Balancer](https://azure.microsoft.com/products/load-balancer) is a layer 4 (TCP, UDP) load balancer.
- [Linux virtual machines in Azure](https://azure.microsoft.com/products/virtual-machines/linux) are on-demand, scalable Linux computing resources that give you the flexibility of virtualization, but eliminate the maintenance demands of physical hardware. The VMs are an on-demand and scalable resource.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Azure Files](https://azure.microsoft.com/products/storage/files), [Azure Table Storage](https://azure.microsoft.com/products/storage/tables), and [Azure Queue Storage](https://azure.microsoft.com/products/storage/queues). Azure Files is often an effective tool for migrating mainframe workloads.
- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) provides secure private networks in the cloud. It connects VMs to one another, to the internet, and to on-premises networks.

## Scenario details

Elastic Enterprise Search helps Azure users optimize productivity by simplifying the process of searching through documents and data. It centralizes content that's on diverse platforms into a single, customizable search experience. Enterprise Search is compatible with various work platforms, including OneDrive and SharePoint. Automated keyword detection is user-friendly, and role-based permissions fortify security by enforcing access restrictions. Automated filtering eliminates the need for box checking and manual search processes. Azure users can deploy Enterprise Search on Elastic Cloud or download and manage it independently.

### Potential use cases

- Deploy Enterprise Search within employee portals and intranet, help desks, customer support apps, CRMs, and other systems to give your teams a single search experience across all their content sources.
- Use the same infrastructure for Elastic App Search: Advanced Search Made Simple.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Michael Yen-Chi Ho](https://www.linkedin.com/in/yenchiho) | Senior Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Elastic on Azure:

- [Elastic Cloud (Elasticsearch Service) on Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/elastic.ec-azure-pp?tab=Overview)
- [QuickStart: Get started with Elastic](/azure/partner-solutions/elastic/create)
- [Mr. Turing accelerates cognitive search, extends Elasticsearch with Azure](https://customers.microsoft.com/story/1557429616211490364-mister-turing-professional-services-azure)

Elastic site:

- [Native Azure integration](https://www.elastic.co/guide/en/cloud/current/ec-azure-marketplace-native.html)
- [Elastic Enterprise Search Guide](https://www.elastic.co/guide/en/workplace-search/current/index.html)

## Related resources

- [Magento e-commerce platform in Azure Kubernetes Service (AKS)](../../example-scenario/magento/magento-azure.yml)
- [Process free-form text for search](../../data-guide/scenarios/search.yml)
- [Intelligent product search engine for e-commerce](../../example-scenario/apps/ecommerce-search.yml)
- [Compliance risk analysis by using Azure Cognitive Search](../../guide/ai/compliance-risk-analysis.yml)

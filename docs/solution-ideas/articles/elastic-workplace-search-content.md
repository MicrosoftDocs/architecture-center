[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Elastic Workplace Search helps Azure users optimize productivity by streamlining the search process for all work documents and data. It centralizes content across a team's diverse platforms into a single, customizable search experience. Workplace Search boasts compatibility with a variety of popular work platforms including OneDrive and SharePoint. Automated keyword detection is user-friendly, and role-based permissions fortify security by restricting access to assigned users. Automated filtering removes the need for box checking and manual search processes. Azure users can deploy Workplace Search on Elastic Cloud or download and manage it independently.

## Potential use cases

- Deploy Workplace Search within employee portals and intranet, help desks, customer support apps, CRMs, and other systems to give your teams a single search experience across all their content sources.
- Use the same infrastructure for Elastic App Search: Advanced Search Made Simple.

## Architecture

:::image type="content" source="../media/elastic-workplace-search.svg" alt-text="Architecture for Elastic Workplace Search" lightbox="../media/elastic-workplace-search.png":::

*Download an [SVG file](../media/elastic-workplace-search.svg) of this architecture.*

- Content: Workplace Search automatically captures, syncs, and indexes the content and key info for all your content sources.
- Ingestion: Workplace Search ingests data from many different content sources, such as OneDrive, SharePoint, or GitHub, from out-of-the-box connectors. You can also build your own connectors using Custom API sources, which allows you to create unique content repositories on the platform and send data to Workplace Search via uniquely identifiable endpoints.
- Relevance: Go beyond global relevance tuning by adjusting relevance on a per-team and per-user basis. You can fine-tune results to ensure that every team in your company has the search engine it needs to be successful.
- Consumption: Users can find the information they need by using the Workplace Search dashboard, or a web browser application, or a custom search.

### Components

The architecture components depend on your deployment choice: Elastic Cloud managed service, Elastic Cloud on Linux VMs, or Elastic Cloud on Kubernetes on Azure Kubernetes Service.

- [Azure App Service](https://azure.microsoft.com/services/app-service) is a fully managed service for building, deploying, and scaling web apps. You can build apps using .NET, .NET Core, Node.js, Java, Python, or PHP. Apps can run in containers or on Windows or Linux.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications.
- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer) is a layer 4 (TCP, UDP) load balancer.
- [Linux virtual machines in Azure](https://azure.microsoft.com/services/virtual-machines/linux) are on-demand, scalable Linux computing resources that give you the flexibility of virtualization, but eliminate the maintenance demands of physical hardware. The VMs are an on-demand and scalable resource.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Azure Files](https://azure.microsoft.com/services/storage/files), [Azure Table Storage](https://azure.microsoft.com/services/storage/tables), and [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues). Azure Files is often an effective tool for migrating mainframe workloads.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/) is a secure private network in the cloud. It connects VMs to one another, to the internet, and to on-premises networks.
- [Elastic on Azure](https://azure.microsoft.com/en-us/overview/linux-on-azure/elastic/) is an open source tool that you can use to  take data from any source—reliably and securely, in any format—then search, analyze, and visualize that data in real time. Elastic on Azure can deliver sub-second response times when working at terabyte and petabyte scale.

## Next steps

### Elastic on Azure

- [Elastic Cloud on Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/elastic.ec-azure-pp?tab=Overview)
- [QuickStart: Get started with Elastic](/azure/partner-solutions/elastic/create)
- [Esri builds flexible mapping managed service in the cloud](https://customers.microsoft.com/en-us/story/esri)
- [Magento e-commerce platform in Azure Kubernetes Service (AKS)](../../example-scenario/magento/magento-azure.yml)

### Elastic NV

- [Getting started with the Azure Marketplace](https://www.elastic.co/guide/en/elastic-stack-deploy/current/azure-marketplace-getting-started.html#azure-marketplace-getting-started)
- [Elastic Workplace Search Guide](https://www.elastic.co/guide/en/workplace-search/current/index.html)

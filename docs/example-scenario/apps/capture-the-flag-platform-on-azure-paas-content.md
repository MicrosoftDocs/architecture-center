A Capture the Flag (CTF) event is a gamified exercise designed to test engineering skills such as cybersecurity, DevOps, or operational troubleshooting. This example scenario shows how to run a capture-the-flag game service by using Azure PaaS and the open-source [CTFd](https://github.com/CTFd/CTFd) platform.

## Architecture

:::image type="content" source="/azure/architecture/example-scenario/apps/media/architecture-ctfd.png" alt-text="Diagram showing the architecture overview of the Azure components involved in a CTFd system." lightbox="/azure/architecture/example-scenario/apps/media/architecture-ctfd.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/architecture-ctfd.pptx) of this architecture.*

### Workflow

This scenario covers an open-source capture-the-flag solution based on CTFd in which customers can provision and configure a game service.

1. A CTFd Docker image is pulled from Azure Container Registry and ready to serve customers.
2. CTF administrators and participants navigate to the Capture-the-flag web application from any device.
3. The web application is provided by [CTFd](https://github.com/CTFd/CTFd) platform as a Docker container that runs on an Azure App Service Web App for Containers.
4. The CTFd data is maintained in an Azure Database for MariaDB that includes users, challenges, flags, and game plays.
5. The state, user sessions, and other CTFd values are held in Azure Cache for Redis. This configuration makes it suitable for supporting scaling out to multiple CTFd instances.
6. The keys for both the database and cache are maintained in Azure Key Vault. Access to the secrets is granted only to the web application.
7. A virtual network connects Azure resources to each other and provides logical isolation. In this architecture, the web application communicates through the network with the database, cache, and key vault.
8. Logs from the web application are sent to Azure Log Analytics, where they're aggregated from all instances and can be queried easily.

### Network configuration

The template supports two network configurations: the preceding one and a simpler configuration without virtual network, using the *vnet* input parameter. In the latter case, the following diagram describes the solution, and step 7 in the preceding workflow is omitted.

:::image type="content" source="/azure/architecture/example-scenario/apps/media/architecture-ctfd-without-vnet.png" alt-text="Diagram showing the architecture overview of the Azure components involved in a CTFd system." lightbox="/azure/architecture/example-scenario/apps/media/architecture-ctfd-without-vnet.png":::

### Components

- [Azure App Service Web App for Container](https://azure.microsoft.com/products/app-service/containers/) hosts containerized web applications allowing autoscale and high availability without managing infrastructure.
- [Azure Database for MariaDB](https://azure.microsoft.com/products/mariadb/) is a cloud-based relational database service. This service is based on the [MariaDB](https://mariadb.org) community edition database engine.
- [Azure Cache for Redis](https://azure.microsoft.com/products/cache/) improves the performance and scalability of systems that rely heavily on backend data stores. It does this by temporarily copying frequently accessed data to fast storage that's close to the application.
- [Azure Key Vault](https://azure.microsoft.com/products/key-vault/) provides secure credential and certificate management.
- [Azure Log Analytics](https://azure.microsoft.com/products/monitor/), an Azure Monitor Logs tool, can be used for diagnostic or logging information and for querying this data to sort, filter, or visualize it. This service is priced by consumption and is perfect for hosting diagnostic and usage logs from all of the services in this solution.
- [Azure Networking](https://azure.microsoft.com/products/category/networking/) provides various networking capabilities in Azure, and the networks can peer with other virtual networks in Azure. Connections can also be established with on-premises datacenters via ExpressRoute or site-to-site. In this case, [private endpoints](/azure/private-link/private-endpoint-overview) for [Azure Database for MariaDB](/azure/mariadb/concepts-data-access-security-private-link), [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-private-link), and [Azure Key Vault](/azure/key-vault/general/private-link-service) are used within the virtual network, and an [Azure App Service virtual network integration](/azure/app-service/overview-vnet-integration) is enabled on the virtual network to ensure all the data is flowing only through the Azure virtual network.

### Alternatives

- You can use the Docker compose definition from [CTFd repository on GitHub](https://github.com/CTFd/CTFd/blob/master/docker-compose.yml). However, that provisions the required services (web-application, cache, and database) into a single host machine, which is neither scalable nor highly available.
- You can provision the required services, as described in the Docker compose definition from [CTFd repository on GitHub](https://github.com/CTFd/CTFd/blob/master/docker-compose.yml) to [Azure Kubernetes Service](https://azure.microsoft.com/products/kubernetes-service/), but then you're managing infrastructure as a service (IaaS).
- You can use a [CTFd paid tier](https://ctfd.io/pricing/) and get the platform as a service, with added features, per the chosen plan.

## Scenario details

Traditionally, [Capture the Flag](https://wikipedia.org/wiki/Capture_the_flag_(cybersecurity)) events are cybersecurity exercises in which “flags” are secretly hidden in a program or website, and competitors steal them from other competitors (attack/defense-style CTFs) or the organizers (Jeopardy-style challenges). However, you can teach and practice other engineering practices as CTF events. You might not always use the CTF term. For example, the Microsoft [OpenHack](https://github.com/microsoft/OpenHack) content packs are similar to what CTF is all about, and include topics such as AI-Powered Knowledge Mining, ML and DevOps, containers, Serverless, and Azure security.

Open-source CTF frameworks make it easy to turn any challenge into a CTF event with configurable challenge pages, leader boards, and other expected features of such an event, using zero code. For instance, [OWASP’s Juice-Shop](https://owasp.org/www-project-juice-shop/) has a [CTF plugin](https://github.com/juice-shop/juice-shop-ctf) that supports several common CTF platforms you can provision and run for your teams to do security training on.

One of the most popular open CTF platforms is [CTFd](https://github.com/CTFd/CTFd). It's easy to use and customize, and it's built with open-source components. It offers several [plans for managed hosting and features](https://ctfd.io/pricing/) from which you can choose, or you could deploy and maintain your own environment. Managing an environment has cost and maintenance implications, but you own the data, you can integrate it with your organization’s network if required, and it typically costs less. Furthermore, using PaaS maintained by your cloud vendor has the benefit of both worlds: free, open-source software and easier maintenance and IT handling than virtualized infrastructure components.

This document can help you set up a self-hosted CTFd environment using Azure PaaS, so your CTF environment is easy to maintain and scalable to accommodate your participants.

### Potential use cases

This solution is optimized for the developer, DevOps, and cybersecurity communities, and for teams that want to run a CTF event.

Ultimately, **any** up-skilling, hack, or bug bash event can use this setup to run [CTFd](https://github.com/CTFd/CTFd) to manage and track challenge-based, team, or individual, progress.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Review the security considerations in the appropriate [App Service web application reference architecture](/azure/architecture/web-apps/architectures/basic-web-app).
- All data in Azure Database for MariaDB is automatically [encrypted](/azure/mariadb/concepts-security) and backed up. You can configure Microsoft Defender for Cloud for further mitigation of threats. For more information, see [Enable Microsoft Defender for open-source relational databases and respond to alerts](/azure/defender-for-cloud/defender-for-databases-usage).
- Access to Azure Database for MariaDB over TLS helps protect against "man in the middle" attacks by encrypting the data stream between the server and your application. It requires the root certificate to be available in the Docker image. This solution uses a custom Docker image that fetches the certificate at build time. The custom image is managed in an Azure Container Registry.
- [Managed identities for Azure resources](/azure/app-service/app-service-managed-service-identity) provide access to other internal resources to your account. This solution uses a managed identity to authorize the web application in Azure App Service to read secrets from Azure Key Vault.
- Credentials such as database or cache connection strings are stored in Azure Key Vault as secrets. Azure App Service is configured to access the Key Vault with its managed identities to avoid storing secrets in application settings or code.
- Network security is considered throughout the design. All traffic from the publicly available web application to the internal services is routed through the Virtual Network, and all back-end services (database, cache, and key vault) do not allow public network access.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- The CTFd environment is ephemeral. You can easily deploy the environment with the required resources for the event, then tear it down just as easily.
- To estimate the cost of implementing this solution, use the [Azure Pricing Calculator](https://azure.com/e/bb4e865667354736a27887f0695a273e).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

Azure Monitor integrates with Azure App Service to support logging from all web application instances to a single location. Azure Monitor diagnostics settings collect CTFd container logs and send them to a Log Analytics workspace. From there, you can use the [Kusto query language](/azure/data-explorer/kusto/query) to write queries across the aggregated logs.

Azure Log Analytics and Azure Monitor are billed per gigabyte (GB) of data ingested into the service (see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/))

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- This solution requires at least the Basic tier, because lower tiers do not support [hybrid connections](https://azure.microsoft.com/pricing/details/app-service/linux/#pricing) into the virtual network.
- The CTFd web application component requires [at least 1 CPU and 1 GB of RAM per instance](https://docs.ctfd.io/docs/deployment/installation).
- For information about scaling a basic web app, see [Scaling the App Service app](/azure/architecture/web-apps/architectures/basic-web-app#scaling-the-app-service-app).
- You can [scale up](/azure/mariadb/concepts-pricing-tiers) Azure Database for MariaDB to meet higher demands. You can dynamically change the number vCores, the amount of storage, and the pricing tier (except to and from Basic), so you should carefully consider the right tier for your target workload.

## Deploy this scenario

You can find the solution deployment files as [Bicep](/azure/azure-resource-manager/bicep/overview) Infrastructure-as-Code at [GitHub](https://github.com/Azure-Samples/ctfd-azure-paas).

The easiest way to deploy the solution to your subscription is to use the **Deploy to Azure** button in the **Quickstart** section of the repo's main README.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Avishay Balter](https://www.linkedin.com/in/avishay-balter-67913138) | Senior Software Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [App Service documentation](/azure/app-service)
- [App Service networking features](/azure/app-service/networking-features)
- [Integrate your app with an Azure virtual network](/azure/app-service/web-sites-integrate-with-vnet)
- [Virtual Network service endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview)
- [Introduction to the App Service Environments](/azure/app-service/environment/intro)
- [Private-link resource](/azure/private-link/private-endpoint-overview#private-link-resource)
- [App Service overview](/azure/app-service/overview)
- [Reliability patterns](/azure/architecture/framework/resiliency/reliability-patterns)
- [Performance Efficiency patterns](/azure/architecture/framework/scalability/performance-efficiency-patterns)

## Related resources

- [Baseline architecture for a zone-redundant web application](../../web-apps/architectures/baseline-zone-redundant.yml)
- [Reference architecture for a multi-region web application](../../web-apps/architectures/multi-region.yml)
- [Scalable web and mobile applications using Azure Database for MySQL](../../solution-ideas/articles/scalable-web-and-mobile-applications-using-azure-database-for-mysql.yml)
- [Social app for mobile and web with authentication](../../solution-ideas/articles/social-mobile-and-web-app-with-authentication.yml)
- [Web applications architecture design](../../web-apps/index.md)
- [Architect scalable e-commerce web app](../../web-apps/idea/scalable-ecommerce-web-app.yml)
- [Scalable Sitecore marketing website](../../web-apps/hosting-applications/digital-marketing-sitecore.yml)
- [Scalable web application](../../reference-architectures/app-service-web-app/scalable-web-app.yml)
- [Web application monitoring on Azure](../../reference-architectures/app-service-web-app/app-monitoring.yml)

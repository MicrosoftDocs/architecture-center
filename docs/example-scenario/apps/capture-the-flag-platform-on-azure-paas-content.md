A Capture the Flag (CTF) event is a gamified exercise that you can use to test engineering skills such as cybersecurity, DevOps, or operational troubleshooting. This article describes how to use Azure platform as a service (PaaS) and the open-source [CTFd](https://github.com/CTFd/CTFd) platform to run a CTF game service.

## Architecture

:::image type="content" source="/azure/architecture/example-scenario/apps/media/architecture-ctfd.svg" alt-text="Diagram that shows the architecture overview of the Azure components involved in a CTFd system." lightbox="/azure/architecture/example-scenario/apps/media/architecture-ctfd.svg" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/architecture-ctfd.pptx) of this architecture.*

### Workflow

This scenario describes an open-source CTF solution based on CTFd in which customers can provision and configure a game service. The following workflow corresponds to the preceding diagram:

1. A CTFd Docker image is retrieved from Azure Container Registry and ready to serve customers.

1. CTF administrators and participants go to the CTF web application from any device.

1. The [CTFd](https://github.com/CTFd/CTFd) platform hosts the web application as a Docker container that runs on Azure App Service Web App for Containers.

1. Azure Database for MySQL maintains the CTFd data, including users, challenges, flags, and game plays.

1. Azure Cache for Redis stores the state, user sessions, and other CTFd values. This configuration enables support for scaling out to multiple CTFd instances.

1. Azure Key Vault maintains the keys for both the database and cache. Only the web application has access to the secrets.

1. A virtual network connects Azure resources to each other and provides logical isolation. In this architecture, the web application communicates through the network with the database, cache, and key vault.

1. The web application sends logs to Azure Log Analytics, which aggregates the logs from all instances so that services can easily query them.

### Network configuration

The template supports the preceding configuration and a simpler configuration without a virtual network that uses the *vnet* input parameter. The following diagram describes the solution for the simpler configuration. The preceding workflow doesn't include step 7.

:::image type="content" source="/azure/architecture/example-scenario/apps/media/architecture-ctfd-without-virtual-network.svg" alt-text="Diagram that shows the architecture overview of the Azure components involved in a CTFd system." lightbox="/azure/architecture/example-scenario/apps/media/architecture-ctfd-without-virtual-network.svg" border="false":::

### Components

- [App Service Web App for Containers](https://azure.microsoft.com/products/app-service/containers/) hosts containerized web applications to enable autoscaling and high availability without the need to directly manage infrastructure.

- [Azure Database for MySQL](https://azure.microsoft.com/products/mysql/) is a cloud-based relational database service. This service is based on the [MySQL](https://www.mysql.com/) community edition database engine.

- [Azure Cache for Redis](https://azure.microsoft.com/products/cache/) improves the performance and scalability of systems that rely heavily on back-end data stores. To improve system efficiency, it temporarily copies frequently accessed data to fast storage near the application.

- [Key Vault](https://azure.microsoft.com/products/key-vault/) provides secure credential and certificate management.

- [Log Analytics](https://azure.microsoft.com/products/monitor/) is an Azure Monitor Logs tool that you can use for information diagnostics, information logging, and to use a query to sort, filter, or visualize this data. Azure charges for this service based on consumption. You can use Log Analytics to host diagnostic and usage logs from all services in this solution.

- [Azure networking](https://azure.microsoft.com/products/category/networking/) provides diverse networking capabilities so that networks can peer with other virtual networks in Azure.

- You can establish connections with on-premises datacenters through Azure ExpressRoute or site-to-site. This architecture uses [private endpoints](/azure/private-link/private-endpoint-overview) for [Azure Database for MySQL](/azure/mysql/flexible-server/concepts-networking-private-link), [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-private-link), and [Key Vault](/azure/key-vault/general/private-link-service) within the virtual network. [App Service virtual network integration](/azure/app-service/overview-vnet-integration) is enabled on the virtual network to ensure that all the data flows only through the Azure virtual network.

### Alternatives

- You can use the [Docker Compose definition](https://github.com/CTFd/CTFd/blob/master/docker-compose.yml) from the CTFd repository on GitHub. But the Docker Compose definition provisions the required web application, cache, and database services into a single host machine, which isn't scalable or highly available.

- You can provision the required services described in the [Docker Compose definition](https://github.com/CTFd/CTFd/blob/master/docker-compose.yml) from CTFd repository on GitHub to [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/products/kubernetes-service/), but then you have to manage infrastructure as a service (IaaS).

- You can use a [CTFd paid tier](https://ctfd.io/pricing/) and get the PaaS with added features, in accordance with the chosen plan.

## Scenario details

[Capture the Flag](https://wikipedia.org/wiki/Capture_the_flag_(cybersecurity)) is a cybersecurity exercise in which a program or website contains hidden *flags*. Competitors try to steal the flags from each other in attack and defense-style CTFs or from the organizers in Jeopardy-style challenges.

You can teach and practice other engineering practices as CTF events, but you might not always use the term *CTF*. For example, the Microsoft [OpenHack](https://github.com/microsoft/OpenHack) content packs are similar to CTF and its processes. OpenHack includes topics such as AI-powered knowledge mining, machine learning, DevOps, containers, serverless computing, and Azure security.

Open-source CTF frameworks can turn any challenge into a CTF event with configurable challenge pages, leader boards, and other features that you expect from CTF, such as zero code. For instance, [Open Web Application Security Project (OWASP) Juice Shop](https://owasp.org/www-project-juice-shop/) has a [CTF plugin](https://github.com/juice-shop/juice-shop-ctf) that supports several common CTF platforms that you can provision and run for your teams to complete security training.

One of the most popular open CTF platforms is [CTFd](https://github.com/CTFd/CTFd). CTFd is built with open-source components and is easy to use and customize. You can choose from several [plans for managed hosting and features](https://ctfd.io/pricing/), or deploy and maintain your own environment. Managing an environment has cost and maintenance implications. But it typically costs less, you own the data, and you can integrate the environment with your organization’s network. Use a PaaS that your cloud vendor provides to get free, open-source software and easy maintenance and IT handling compared to virtualized infrastructure components.

Apply the guidance in this article, and use Azure PaaS to set up a self-hosted CTFd environment. Then you can easily maintain and scale your CTF environment to accommodate your participants.

### Potential use cases

This solution is optimized for the developer, DevOps, and cybersecurity communities, and for teams that want to run a CTF event.

Any up-skilling, hack, or bug bash event can use this setup to run [CTFd](https://github.com/CTFd/CTFd) to manage and track challenge-based progress, team progress, or individual progress.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Review the security considerations in the appropriate [App Service web application reference architecture](/azure/architecture/web-apps/app-service/architectures/basic-web-app#security).

- Azure Database for MySQL automatically [encrypts](/azure/mysql/flexible-server/overview#enterprise-grade-security-compliance-and-privacy) and backs up data. You can configure Microsoft Defender for Cloud for further mitigation of threats. For more information, see [Enable Microsoft Defender for open-source relational databases](/azure/defender-for-cloud/enable-defender-for-databases-azure) and [Respond to Defender open-source database alerts](/azure/defender-for-cloud/defender-for-databases-usage).

- Access to Azure Database for MySQL over Transport Layer Security (TLS) encrypts the data stream between the server and your application to help protect against *machine in the middle* attacks. The root certificate must be available in the Docker image. This solution uses a custom Docker image that fetches the certificate at build time. An Azure container registry manages the custom image.

- [Managed identities for Azure resources](/azure/app-service/app-service-managed-service-identity) provide access to other internal resources to your account. This solution uses a managed identity to authorize the web application in App Service to read secrets from Key Vault.

- Key Vault stores credentials, such as database or cache connection strings, as secrets. App Service uses managed identities to access Key Vault to avoid storing secrets in application settings or code.

- This architecture provides network security throughout the design. All traffic from the publicly available web application to the internal services is routed through the virtual network. And all back-end services, such as the database, cache, and key vault, don't allow public network access.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- The CTFd environment is ephemeral. You can easily deploy and then dismantle the environment with the required resources for the event.

- To estimate the cost of implementing this solution, use the [Azure pricing calculator](https://azure.com/e/e283b19ecaeb4fa5a428c56ede9d9bd3).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Azure Monitor integrates with App Service to support logging from all web application instances to a single location. Monitor diagnostics settings collect CTFd container logs and send them to a Log Analytics workspace. From there, you can use the [Kusto Query Language](/azure/data-explorer/kusto/query) to write queries across the aggregated logs.

Log Analytics and Monitor are billed per gigabyte (GB) of data ingested into the service. For more information, see [Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- This solution requires at least the Basic tier, because lower tiers don't support [hybrid connections](https://azure.microsoft.com/pricing/details/app-service/linux/#pricing) into the virtual network.

- The CTFd web application component requires [at least one CPU and one GB of RAM per instance](https://docs.ctfd.io/docs/deployment/installation).

- For more information about how to scale a basic web app, see [Scaling the App Service app](/azure/architecture/web-apps/app-service/architectures/basic-web-app#scaling-the-app-service-app).

- You can [scale up](/azure/mysql/flexible-server/concepts-service-tiers-storage) Azure Database for MySQL to meet higher demands. Dynamically change the number vCores and the amount of storage that you require for your target workload.

## Deploy this scenario

You can find the [solution deployment files](https://github.com/Azure-Samples/ctfd-azure-paas) as [Bicep](/azure/azure-resource-manager/bicep/overview) infrastructure as code (IaC) on GitHub.

The easiest way to deploy the solution to your subscription is to use the **Deploy to Azure** button in the **Quickstart** section of the repo's main README file.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Avishay Balter](https://www.linkedin.com/in/avishay-balter) | Principal Software Engineering Lead

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [App Service documentation](/azure/app-service)
- [App Service overview](/azure/app-service/overview)
- [App Service networking features](/azure/app-service/networking-features)
- [Integrate your app with an Azure virtual network](/azure/app-service/web-sites-integrate-with-vnet)
- [Virtual Network service endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview)
- [Introduction to App Service Environment](/azure/app-service/environment/intro)
- [Private link resource](/azure/private-link/private-endpoint-overview#private-link-resource)
- [Reliability patterns](/azure/well-architected/reliability/design-patterns)
- [Performance Efficiency patterns](/azure/well-architected/performance-efficiency/design-patterns)

## Related resources

- [Baseline architecture for a zone-redundant web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml)
- [Reference architecture for a multi-region web application](../../web-apps/app-service/architectures/multi-region.yml)
- [Scalable web and mobile applications using Azure Database for MySQL](../../solution-ideas/articles/scalable-web-and-mobile-applications-using-azure-database-for-mysql.yml)
- [Web applications architecture design](../../web-apps/index.md)
- [Architect scalable e-commerce web app](../../web-apps/idea/scalable-ecommerce-web-app.yml)
- [Scalable Sitecore marketing website](../../web-apps/hosting-applications/digital-marketing-sitecore.yml)
- [Web application monitoring on Azure](../../web-apps/guides/monitoring/app-monitoring.yml)

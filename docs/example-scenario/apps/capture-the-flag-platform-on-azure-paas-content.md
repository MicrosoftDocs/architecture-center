A Capture the Flag (CTF) event is a gamified exercise designed to test engineering skills such as cybersecurity, devops, or operational troubleshooting.
This example scenario shows how to run a capture-the-flag (CTF) game service using Azure PaaS and the open-source [CTFd][ctfd] platform.

## Architecture

![Diagram showing the architecture overview of the Azure components involved in a CTFd system.][architecture]

*Download a [PowerPoint file](https://arch-center.azureedge.net/architecture-ctfd.pptx) of this architecture.*

### Workflow

This scenario covers an open capture-the-flag solution based on CTFd where customers can provision and configure a game service.

1. CTFd docker image is pulled from the **Azure Container Registry** and ready to serve customers.
2. CTF administrators and participants navigate to the **capture-the-flag web application** from any device.
3. The web application is provided by [CTFd][ctfd] platform, as a docker container running on an **Azure App Service Web App for Containers**.
4. The CTFd data is maintained in an **Azure Database for MariaDB**. That includes users, challenges, flags, and game plays.
5. The state, user sessions, and other CTFd values are held in an **Azure Cache for Redis**, which makes it suitable for supporting scaling out to multiple CTFd instances.
6. The keys for both the database and cache are maintained in an **Azure Key Vault**, and access to the secrets is granted only to the web application.
7. A **Virtual network** connects Azure resources to each other and provides logical isolation. In this architecture, the web application communicates through the network with the database, cache, and key-vault.
8. Logs from the web application are sent to **Azure Log Analytics** where they are aggregated from all instances and can be queried easily.

### Network configuration

The template supports two network configurations, the one described above and a simpler configuration without virtual network, using the *vnet* input parameter. In that case, the following diagram describes the solution, and the workflow step 7 mentioned above is omitted.

![Diagram showing the architecture overview of the Azure components involved in a CTFd system.][architecture-no-vnet]

### Components

- [App Services - Web App for container][docs-webapps-service-page] hosts containerized web applications allowing autoscale and high availability without managing infrastructure.
- [Azure Database for MariaDB][mariadb] is a cloud-based relational database service. This service is based on the [MariaDB][mariadb-org] community edition database engine.
- [Azure Cache for Redis][docs-redis-cache] improves the performance and scalability of systems that rely heavily on backend data stores by temporarily copying frequently accessed data to fast storage close to the application.
- [Azure Key Vault][key-vault]: Secure credential and certificate management.
- [Azure Log Analytics][log-analytics], an Azure Monitor Logs tool, can be used for diagnostic or logging information and for querying this data to sort, filter, or visualize them. This service is priced by consumption and is perfect for hosting diagnostic and usage logs from all of the services in this solution.
- [Azure Networking][azure-networking] provides various networking capabilities in Azure, and the networks can peer with other virtual networks in Azure. Connections can also be established with on-premises datacenters via ExpressRoute or site-to-site. In this case, [private endpoints][private-endpoint] for [Azure Database for MariaDB][private-endpoint-mariadb], [Azure Cache for Redis][private-endpoint-redis], and [Azure Key Vault][private-endpoint-key-vault] are used within the virtual network, and an [Azure App Service VNet Integration][app-service-vnet-integration] is enabled on the virtual network to ensure all the data is flowing only through the Azure virtual network.

### Alternatives

- You could use the docker compose definition from [CTFd repository on GitHub][ctfd-docker-compose]. However, that will provision the required services; web-application, cache, and database, into a single host machine, which is neither scaleable nor highly available.
- You could provision the required services, as described in the docker compose definition from [CTFd repository on GitHub][ctfd-docker-compose] to [Azure Kubernetes Service][azure-kubernetes-service], but then you're managing Infrastructure-as-a-Service (IaaS).
- You could use a [CTFd paid tier][ctfd-pricing] and get the platform as a service, with added features, per the chosen plan.

## Scenario details

Traditionally, [Capture the Flag][ctf-wikipedia] events are cybersecurity exercises in which “flags” are secretly hidden in a program or website, and competitors steal them from other competitors (attack/defense-style CTFs), or the organizers (jeopardy-style challenges). However, more engineering practices can be taught and practiced as a CTF event. They may even not use the term CTF for it, such as Microsoft's [OpenHack][openhack-github] content packs which are very similar to what CTF is all about and include topics such as AI-Powered Knowledge Mining, ML and DevOps, containers, Serverless and Azure security.

Open-Source CTF frameworks make it easy to turn any challenge into a CTF event with configurable challenge pages, leader boards, and other expected features of such an event, using zero-code. For instance, [OWASP’s Juice-Shop][juice-shop] has a [CTF plugin][juice-shop-ctf] that supports several common CTF platforms that you can provision and run for your teams to do security training on.

One of the most popular open [CTF][ctfd] platforms is CTFd. It is easy to use, customize, and built with open-source components. It offers several [plans for managed hosting and features][ctfd-pricing] you may choose from, or you could deploy and maintain your environment. Managing an environment has cost and maintenance implications, but you own the data, you can integrate it with your organization’s network if required, and it typically costs less. Furthermore, using Platform as a Service (PaaS), maintained by your cloud vendor, has the benefit of both worlds; Free, open-source software and much easier maintenance and IT handling than virtualized infrastructure components.

This document will help you set up a self-hosted CTFd environment using Azure PaaS so your CTF environment is easy to maintain and can be scaled to accommodate the number of your participants.

### Potential use cases

This solution is optimized for the developer, DevOps, and cybersecurity communities and teams within organizations that want to run a CTF event.

Ultimately, **any** up-skilling, hack, or bug bash event can use this setup to run [CTFd][ctfd] to manage and track challenge-based, team, or individual, progress.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Review the security considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture].
- All data in Azure Database for MariaDB is automatically [encrypted][mariadb-security] and backed up. You can configure Microsoft Defender for Cloud for further mitigation of threats. For more information, see [Enable Microsoft Defender for open-source relational databases and respond to alerts](/azure/defender-for-cloud/defender-for-databases-usage).
- Accecss to Azure Database for MariaDB over TLS helps protect against "man in the middle" attacks by encrypting the data stream between the server and your application. It required the root certificate to be available in the docker image. A custom docker image which fetches the certificate at build time is used in this solution and manged in an Azure Container Registry.
- [Managed identities for Azure resources][msi] provide access to other internal resources to your account. In this solution, a managed identity is used to authorize the web application in Azure App Service to read secrets from Azure Key Vault.
- Credentials such as database or cache connection strings are stored in Azure Key Vault as secrets. Azure App Service is configured to access the key vault with its managed identities to avoid storing secrets in application settings or code.
- Network security is considered throughout the design. All traffic from the publicly available web application to the internal services is routed through the Virtual Network, and all backend services (database, cache, and key vault) do not allow public network access.

### Operational Excellence

#### Logging

Azure Monitor integrates with Azure App Service to support logging from all web application instances to a single location. Azure Monitor diagnostics settings collect CTFd container logs and send them to a Log Analytics workspace. From there, you can use the [Kusto query language][kusto-query] to write queries across the aggregated logs.

Azure Log Analytics and Azure Monitor are billed per gigabyte (GB) of data ingested into the service (see [Azure Monitor pricing][azure-monitor-pricing])

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- The CTFd environment is ephemeral. You can easily deploy the environment with the required resources for the event and then tear it down just as easily.
- To estimate the cost of implementing this solution, use the [Azure Pricing Calculator](https://azure.com/e/bb4e865667354736a27887f0695a273e).

## Performance efficiency
- App Service's lowest tier for this solution is Basic since lower tiers do not support [Hybrid Connections][app-service-pricing] into the virtual network.
- CTFd web application component requires at least 1 CPU and 1 GB of RAM per instance, [source][ctfd-installation].
- For information about scaling a basic web app, see [Scaling the App Service app](../../reference-architectures/app-service-web-app/basic-web-app.yml#scaling-the-app-service-app).
- Azure Database for MariaDB can be [scaled up][mariadb-pricing-tiers] to meet higher demands. You can dynamically change the number vCores, the amount of storage, and the pricing tier (except to and from Basic), so you should carefully consider the right tier for your target workload.

## Deploy this scenario

You can find the solution deployment files as [Bicep][bicep] Infrastructure-as-Code [GitHub][source-code].
The easiest way to deploy the solution to your subscription is to use the 'Deploy to Azure Button' from the repo's main README.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Avishay Balter](https://www.linkedin.com/in/avishay-balter-67913138) | Senior Software Engineer

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

- [Reference architecture for a multi-region web application][multi-region-web-app]
- [Scalable web and mobile applications using Azure Database for MySQL](../../solution-ideas/articles/scalable-web-and-mobile-applications-using-azure-database-for-mysql.yml)
- [Social app for mobile and web with authentication](../../solution-ideas/articles/social-mobile-and-web-app-with-authentication.yml)
- [Web applications architecture design](../../guide/web/web-start-here.md)
- [Architect scalable e-commerce web app](../../solution-ideas/articles/scalable-ecommerce-web-app.yml)
- [Scalable Sitecore marketing website](../../solution-ideas/articles/digital-marketing-sitecore.yml)
- [Scalable web application](../../reference-architectures/app-service-web-app/scalable-web-app.yml)
- [Web application monitoring on Azure](../../reference-architectures/app-service-web-app/app-monitoring.yml)

<!-- links -->
[ctfd]: https://github.com/CTFd/CTFd
[architecture]: ./media/architecture-ctfd.png
[architecture-no-vnet]: ./media/architecture-ctfd-without-vnet.png
[docs-webapps-service-page]: https://azure.microsoft.com/en-us/products/app-service/containers/
[mariadb]: https://azure.microsoft.com/services/mariadb/
[mariadb-org]: https://mariadb.org/
[docs-redis-cache]: https://www.microsoft.com/azure/redis-cache/cache-overview
[key-vault]: https://azure.microsoft.com/services/key-vault
[azure-networking]: /azure/virtual-network/virtual-networks-overview
[log-analytics]: /azure/azure-monitor/log-query/log-analytics-overview
[private-endpoint]: https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview
[private-endpoint-mariadb]: https://learn.microsoft.com/en-us/azure/mariadb/concepts-data-access-security-private-link
[private-endpoint-redis]: https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-private-link
[private-endpoint-key-vault]: https://learn.microsoft.com/en-us/azure/key-vault/general/private-link-service?tabs=portal
[app-service-vnet-integration]: https://learn.microsoft.com/en-us/azure/app-service/overview-vnet-integration
[ctfd-docker-compose]: https://github.com/CTFd/CTFd/blob/master/docker-compose.yml
[azure-kubernetes-service]: https://azure.microsoft.com/services/kubernetes-service
[ctfd-pricing]: https://ctfd.io/pricing/
[juice-shop]: https://owasp.org/www-project-juice-shop/
[juice-shop-ctf]: https://github.com/juice-shop/juice-shop-ctf
[ctf-wikipedia]: https://en.wikipedia.org/wiki/Capture_the_flag_(cybersecurity)
[openhack-github]: https://github.com/microsoft/OpenHack
[app-service-pricing]: https://azure.microsoft.com/en-us/pricing/details/app-service/linux/#pricing
[ctfd-installation]: https://docs.ctfd.io/docs/deployment/installation
[mariadb-pricing-tiers]: https://learn.microsoft.com/en-us/azure/mariadb/concepts-pricing-tiers
[app-service-reference-architecture]: ../../reference-architectures/app-service-web-app/basic-web-app.yml
[mariadb-security]: https://learn.microsoft.com/en-us/azure/mariadb/concepts-security
[msi]: /azure/app-service/app-service-managed-service-identity
[kusto-query]: /azure/data-explorer/kusto/query
[azure-monitor-pricing]: https://azure.microsoft.com/pricing/details/monitor/
[bicep]: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep
[source-code]: https://github.com/Azure-Samples/ctfd-azure-paas
[multi-region-web-app]: ../../reference-architectures/app-service-web-app/multi-region.yml

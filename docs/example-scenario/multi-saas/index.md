---
title: Multi-tenant SaaS in Azure
titleSuffix: Azure Example Scenarios
description: Build a multi-tenant SaaS solution on Azure, designed for high availability, scalability, data security and isolation using App Service, Azure Kubernetes Service, and SQL Elastic Pools
author: ivcafe413
ms.date: 03/01/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.custom:
- fcp
---

# Multi-tenant SaaS on Azure

Identifying a portion of a business' s software solution that can be white labeled and marketed to other businesses can add an entire new revenue stream for a company, but configuring said solution to account for the load that a slew of tenants brings is often a challenging obstacle to tackle. Azure offers a range of services for managing a software solution that flexibly maintains databases for all customers, scaling the business and logic tier of the solution to prevent bottleneck at the compute layer, integrating availability and regional failover, and providing end-to-end security at all levels of the solution.

## Potential use cases

These other uses cases have similar design patterns:

- Developing a CRM solution to be marketed and sold to clients.
- A CMS system delivered to multiple users could be implemented in this architecture.

## Architecture

*Architecture Diagram goes here*

- Traffic is secured and load balanced via a suite of Azure technologies. Azure Front Door handles the initial request, load balancing across the regions, SSL(HTTPS) termination and offloading, and failover in case of a regional outage. Azure DNS is used to manage DNS records and insure routing to the correct Front Door endpoint. Azure Active Directory(AD) can be used as the identity provider for authentication.
- Once routed to the appropriate region, the Application Gateway routes and load balances, directing requests to the appropriate App Service. App Service is the backbone for any HTTP-based application, serving web content, exposing RESTful APIs, and implementing business logic behind the front-end application. App Service can be configured to scale up and out automatically. This makes App Service a good fit for scaling a host of tenant HTTP-driven requests on demand.
- The data layer services are also independently scaled based on load. Data services manage data models, connection clients and drivers and provide a consistent data interface for all higher level services wishing to consume data in the application. These data services can be deployed and scaled using the Azure Kubernetes Service (AKS). Each AKS cluster can be made responsible for a set of related features in the layer. AKS can implement a microservice architecture, which features a series of containers that each encapsulate specific functionality within the cluster. This allows for a high degree of abstraction and de-coupling within the code. This also allows for clusters to scale out individually to account for increased load from multiple tenants. Each cluster can scale up its resources if load increases on the cluster, without affecting the other clusters in the resource group that are not experiencing as much traffic.
- Relational data is stored and managed outside of the application framework, providing a single point of data entry for either region. Replication, availability, scalability and security are achievable by leveraging the strength of Azure SQL Elastic Pools. Each tenant can be provisioned a database in a pool, and the resources available in the pool will be allocated to databases on-demand as load and requests come in. This optimizes database resources available for tenants against the developer's budget.

### Components

- [Azure Front Door] is a regional load balancer that routes customer traffic to the correct region, can failover to the second region in case of region failure, and secures the Internet-facing entry point via [Windows Application Firewall].
- [Azure Active Directory] (Azure AD) acts as the identity provider for the entire application, enforcing authentication and authorization of the request end-to-end in the application.
- [Azure DNS] is a hosting service in Azure for domain name resolution. In a multi-tenant solution, multiple customers will be accessing the solution via their own individual domains. Azure DNS can be used to configure and resolve customer requests to their correct application stack.
- [Application Gateway] routes and load-balances traffic internally in the application to the various services that satisfy customer business needs. While Azure Front Door balances load across high-level regions, it is the Application Gateway that has awareness of the load on individual services within a group. Azure Front Door + Application Gateway combine to provide complex load-balancing at all levels in a multi-tenant solution. For more information on load-balancing options in Azure, visit this [overview on Azure load-balancing][load-balancing].
- [App Service] is Azure's premier service for web applications and web-based APIs. Security is integrated with services such as Azure AD and [Azure Key Vault]. Scaling can be configured to happen automatically, and the amount of resources available to scale to is flexible between the various App Service plans that the app can run on. App Service can also leverage integrated DevOps capabilities for continuous integration and deployment to multiple environments. These and other supporting functionalities of the Azure platform allow for developers to focus on the development of their applications.
- [Azure Kubernetes Service](AKS) orchestrates instances of container images deployed to a cluster. Managing multiple clients' data often involves implementing a suite of components to manage data modeling, data source connectivity, ETL and import/export activities. Developing these many smaller components as container-based microservices creates an ideal scenario for the deployment to an AKS cluster. Built into the framework are tools for auto-scaling, load balancing and upgradability. AKS integrates well with a CI/CD strategy utilizing the available DevOps features and Azure Container Registry.
- [Azure SQL Elastic Pools] provide a solution for managing a set of databases flexibly with a pool of resources, allocating resources on demand to the databases. What this means for a developer of a multi-tenant SaaS is the power to deliver database resources to customers as they need it, while saving the budget and overhead of maintaining multiple SQL Servers with large chunks of unused compute resources at any given moment.
- [Azure Cognitive Search] (formerly known as Azure Search) is a service that adds a powerful indexing and query engine to your application. This gives clients access to strong query functionality that can even be enriched and enhanced by Azure's AI capabilities. Multitenancy can be accounted for in Azure Cognitive Search via either an index-per-tenant or service-per-tenant strategy.
- [Azure Cache for Redis] applies a caching layer as a service to the solution, providing an in-memory managed cache to decrease latency and increase performance for the clients. High throughput allows for a high volume of requests to handle multiple tenants accessing the system. The service itself can be scaled up flexibly as application loads increase, and supports encryption at rest to protect and isolate cached tenant data.

### Alternatives

- [VM Scale Sets] allow for the deployment of services to a VM environment that scales and grows automatically as needed.. VM Scale Sets integrate well with a [Load Balancer] or Application Gateway, depending on need, to automatically re-balance load as the Scale Set grows. Although VM Scale Sets provide the scalability this solution demands, in many cases it is unnecessary to manage the full VM environment, and we can defer that level of the stack to App Service or AKS.
- [Azure SQL Server] could be implemented as individual dedicated instances vs Elastic Pools. While this adds higher overhead in managing the instance directly as well as incurring more cost for allocated resources, this is a viable alternative in the case where the tenant requires a dedicated server, in particular if the client requires more control over the instance and dedicated available resources. Tenants requiring a dedicated SQL Server can exist side-by-side with tenants on an Elastic Pool configuration, and that tier of database could even be a pricing option that the developer makes available to tenants when purchasing licenses for the SaaS.
- SQL Server on Azure VMs is another option for the deployment of SQL databases. In the case that the tenant has pre-existing IT infrastructure, and in particular existing SQL Servers on-premises, the tenant may want to utilize their current licenses, either as a full migration or in a hybrid scenario. The decoupled nature of the SaaS allows for the data layer of the application to target any SQL Database via configuration.

## Considerations

### Multitenancy

A multi-tenant solution is the key consideration in this example, handling a number of clients simultaneously, allocating enough resources to process all client requests effectively while securing traffic from global endpoints and isolating client data to prevent any breaches or cross-contamination. Clients are deployed to a pair of regional resource groups based on their primary location, so that regional availability is optimized. Many clients can be deployed to a single compute group, as requests are isolated based on authentication and client keys, which differentiate requests based on these unique identifiers. All client requests can be encrypted separately by their keys, so that no client can decrypt any other client's data. Allowing the developer to manage multiple clients on single compute stacks gives the developer the ability to optimize resource allocation to provide clients the responsiveness they need at cost.

Client databases are managed in a similar way outside of the compute stack, since a client request could arrive from either of the regional compute stacks. Many client databases can exist on the same Elastic Pool, isolated and secured by Transparent data encryption (TDE). Each database can be configured to be encrypted by a client-managed key, and decrypted just-in-time (JIT) to protect client data from both the developer and other clients. The Elastic Pool is leveraged to provide resources on demand to the clients assigned to it, while keeping costs low for the developer. Replication policies can be assigned to each Elastic Pool to provide backup and failover for client data, and more Elastic Pools can be brought online as more clients are onboarded into the system.

### Scalability and Availability

This solution is specifically designed to account for a large number of tenants utilizing the SaaS. It takes advantage of the large number of scalable components and services to grow based on load. This architecture is not designed for solutions that do not service multiple tenants, or a large load of requests and data, so it could stress the budget of a solution targeting a single client or smaller load. It is also unnecessary to have the multi-region overhead where high, global availability is not a requirement, as it adds unnecessary complexity and cost.

### Security

Security from end-to-end is addressed at each level of the application:
- Azure Front Door provides built-in HTTPS support for its domains. All traffic to the SaaS application can therefor be encrypted. Azure Front Door also implements Azure Web Application Firewall, protecting the SaaS stack from attacks at the edge, before requests are routed to the application proper.
- Each application stack in each region lies within an Azure Virtual Network. Traffic into the VNET is restricted to accepting requests from Azure Front Door, protecting all application services from external traffic. Once inside the secure firewall, Application Gateway can terminate SSL and provide performant load balancing and routing within the application.
- All credentials, secrets and connection strings can be securely managed by Azure Key Vault. By managing this sensitive data as secrets, developers can inject credentials into the application at deployment time without polluting the code with sensitive information. This protects client data by ensuring that a breach in code or man-in-the-middle attack would not gain access to tenant databases.
- In this scenario, the data of multiple tenants may exist side-by-side on the same database server, if not the same database. Using Transparent Data Encryption and JIT(just-in-time) decryption protects data on the database. All data on the database is encrypted at rest, and only decrypted when requested by the tenant. Clients have the option to provide their own keys, and all customer keys can be stored in Azure Key Vault to manage encryption for multiple tenants. This protects client data end-to-end, prevents the developer from having access to client data, isolates data between tenants, and helps to meet compliance requirements for security and data.

## Pricing

Azure App Service provides a host of pricing tiers based on the expected compute resources required. For a multi-tenant SaaS, high availability and scale-out capabilities are a key component in choosing the service plan, and if many tenants are expected, choosing a Premium or Isolated tier may be necessary to provide the compute resources necessary to account for the high traffic. The Standard, Premium and Isolated tiers are all dedicated VM instances, so cost can be calculated per unit of time by how many VMs of said tier are specified. For more information, you can visit this [overview of App Service pricing plans][app-service-pricing].

Azure Kubernetes Service provides a cost-effective container service. Charges for AKS nodes only occurs on usage, so the developer is only charged for the VMs, storage and network resources actually consumed, scaling cost directly to usage. This makes AKS as the data tier service ideal in terms of price. For an estimate on pricing out a layer of AKS instances, please visit this [Kubernetes service calculator].

The Azure SQL Elastic Pool pricing is designed to be highly cost-effective in a multi-tenant scenario. Tenant databases in an Elastic Pool will share the available resources, so as demand shifts between tenants over time, resources will shift as well to provide the maximum available resources to demanded databases without the need for resource overhead on all databases, keeping cost low for the developer of the SaaS. The [Azure SQL Database pricing calculator][sql-database-pricing-calculator] can be used to price out and determine the tier and amount of resources needed to serve your tenants and their data.
- Utilizing a vCore pricing model provides greater flexibility in scaling to meet required resources. It comes with the added benefit of being able to take advantage of the Azure Hybrid Benefit. Existing SQL Server licenses provide a discount to vCore SQL Resources in the cloud. So in an instance when on-premises servers are already part of the developer infrastructure, cost can be managed even more by utilizing these discounts. You can estimate your potential savings using this [Azure Hybrid Benefit savings calculator][hybrid-benefit-savings-calc].
- In addition, cost can be saved on SQL Server resources through the purchase of [Azure SQL Database reserved capacity]. A purchase of reserved capacity marks a commitment of long-term SQL Database usage, between one to three years, in return for discounts on the compute costs of the resources in reservation. For instance, you could make a reservation of 32 General Purpose vCores for a year, which would reduce the cost of those 32 vCores for that year. Having multiple tenants purchasing licenses for an SaaS is a strong indicator that making use of Reserved capacity fits the solution, and an ideal cost saver in this workload.

The pricing structure for Azure Cache for Redis can be found [here][redis-cache-pricing]. The cache tier can be adjusted at any time between a Basic, Standard and Premium tier based on need, with higher pricing on the larger cache limits and additional features such as replication and disaster recover. Azure Cache for Redis also offers reserved capacity pricing if long-term usage commitments can be made by the developer.

Azure Front Door is priced based on the amount of data transfer in and out of the service. For outbound data, the pricing is different based on zones, so different regions will incur different costs and would need to be estimated separately. Some routing and domain capacity is included, but would incur costs past the initial limits. Web Application Firewall does incur a small additional charge per policy or rule applied. The pricing details for Azure Front Door can be found [here][azure-front-door-pricing].

The [pricing for Azure Cognitive Search][azure-cognitive-search-pricing] is a fully tiered system. A free tier is available for development/testing. After that, each tier incurs a per-hour cost for each Cognitive Search instance allocated. As the tiers increase, the total storage, number of indexes, and scale-out limits also increase. Image extraction as a service is provided at the same rate to all paid tiers.

## Next Steps

- [Multi-region, high availability web application][multi-region-high-availability-web-app] serves as a reference for the multi-region requirement of the solution.
- [Multitier web app for high availability and disaster recovery][web-app-high-availability-disaster-recovery] is a similar example workload scenario that describes many of the considerations for a large-scale application on Azure.

<!-- links -->
[calculator]: https://azure.com/e/
[availability]: /azure/architecture/checklist/availability
[resiliency]: /azure/architecture/resiliency/
[security]: /azure/security/
[scalability]: /azure/architecture/checklist/scalability

[Azure Front Door]: /azure/frontdoor/front-door-overview
[Azure Active Directory]: /azure/active-directory/fundamentals/active-directory-whatis
[Azure DNS]: /azure/dns/dns-overview
[Application Gateway]: /azure/application-gateway/overview
[App Service]: /azure/app-service/environment/intro
[Azure Kubernetes Service]: /azure/aks/intro-kubernetes
[Azure SQL Elastic Pools]: /azure/sql-database/sql-database-elastic-pool
[Azure Cognitive Search]: /azure/search/search-what-is-azure-search
[Azure Cache for Redis]: /azure/azure-cache-for-redis/cache-overview
[Windows Application Firewall]: /azure/web-application-firewall/ag/ag-overview
[Azure Key Vault]: /azure/key-vault/key-vault-overview

[VM Scale Sets]: /azure/virtual-machine-scale-sets/overview
[Azure SQL Server]: /azure/sql-database/sql-database-technical-overview
[Load Balancer]: /azure/load-balancer/load-balancer-overview

[load-balancing]: /azure/architecture/guide/technology-choices/load-balancing-overview

[app-service-pricing]: /azure/app-service/overview-hosting-plans
[hybrid-benefit-saving-calc]: https://azure.microsoft.com/en-us/pricing/hybrid-benefit/#sql-ahb-calculator
[sql-database-pricing-calculator]: https://azure.microsoft.com/en-us/pricing/details/sql-database/elastic/
[Kubernetes service calculator]: https://azure.microsoft.com/en-us/pricing/calculator/?service=kubernetes-service
[Azure SQL Database reserved capacity]: /azure/sql-database/sql-database-reserved-capacity
[redis-cache-pricing]: https://azure.microsoft.com/en-us/pricing/details/cache/
[azure-front-door-pricing]: https://azure.microsoft.com/en-us/pricing/details/frontdoor/
[azure-cognitive-search-pricing]: https://azure.microsoft.com/en-us/pricing/details/search/

[multi-region-high-availability-web-app]: /azure/architecture/reference-architectures/app-service-web-app/multi-region
[web-app-high-availability-disaster-recovery]: /azure/architecture/example-scenario/infrastructure/multi-tier-app-disaster-recovery

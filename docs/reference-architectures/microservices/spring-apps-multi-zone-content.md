This reference architecture shows how to run application workloads on Azure Spring Apps by using a zone-redundant configuration. [Zone-redundant services](/azure/reliability/availability-zones-service-support#azure-services-with-availability-zone-support) provide high availability by replicating your services and data across availability zones to protect against single points of failure. For a deployment of this architecture by using Terraform templates, see [Deploy this scenario](#deploy-this-scenario).

## Architecture

:::image type="content" source="./_images/zone-redundant-spring-apps-reference-architecture.png" alt-text="Diagram that shows a multi-region Azure Spring Apps reference architecture." lightbox="./_images/zone-redundant-spring-apps-reference-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/ha-zone-redundant-spring-apps-reference-architecture.vsdx) that contains this architecture diagram.*

### Workflow

1. The user accesses the application via a browser by using the HTTP host name of the application; for example, `www.contoso.com`. [Azure DNS](/azure/dns/dns-overview) or another public DNS service resolves the request for this host name to the public endpoint of  Azure Application Gateway.

1. Application Gateway deploys with [Azure Web Application Firewall](/azure/web-application-firewall/overview). The Application Gateway is configured with a custom domain name and TLS certificate name. Web Application Firewall adds checking for the Open Web Application Security Project ([OWASP](https://owasp.org/)) vulnerabilities.

1. Application Gateway forwards allowed traffic to the Azure Spring Apps load balancers, which allow incoming calls only from Application Gateway.

1. Azure Spring Apps runs the application workload inside a virtual network in a zone-redundant setup.

1. The components inside the virtual networks use [private endpoints](/azure/private-link/private-endpoint-overview) to connect privately and securely to other Azure services. This solution uses private endpoints to connect to Azure Key Vault. [Azure Key Vault](/azure/key-vault/general/overview) stores application secrets and certificates. The microservices that run in Azure Spring Apps use the application secrets. Azure Spring Apps, Application Gateway, and Azure Front Door use the certificates for host name preservation.

1. An [instance of Azure Database for MySQL with the flexible server deployment option](/azure/mysql/flexible-server/overview) is used for data storage, but you can use any database. For alternatives, see [Back-end database](#back-end-database). The database server is deployed within the virtual network.

1. The private endpoint and network-integrated connections use an [Azure private DNS zone](/azure/dns/private-dns-getstarted-cli).

### Components

- [Azure DNS](https://azure.microsoft.com/products/dns) is a hosting service for Domain Name System (DNS) domains that provides name resolution by using Azure infrastructure. This solution uses Azure DNS for DNS resolution from your custom domain to your Azure Application Gateway.
- [Application Gateway](https://azure.microsoft.com/products/application-gateway) is a web-traffic load balancer that you can use to manage traffic to your web applications. Application Gateway acts as a local reverse proxy in a region where your application runs. For alternative reverse proxy setups, see [Reverse proxy setup](#reverse-proxy-setup). The Application Gateway is also set up to use multiple availability zones.
- [Azure Web Application Firewall](https://azure.microsoft.com/products/web-application-firewall) provides centralized protection of your web applications from common exploits and vulnerabilities. Web Application Firewall on the Application Gateway tracks OWASP exploits.
- [Azure Spring Apps](https://azure.microsoft.com/products/spring-apps) makes it easy to deploy Java Spring Boot applications to Azure without any code changes. You can easily make it zone redundant by setting the `zone redundant` option. When you do so, all underlying infrastructure of the service is spread across multiple availability zones. This zone spreading supports an overall higher availability of your applications that use the service.
- [Azure Database for MySQL](https://azure.microsoft.com/products/mysql) is a relational database service in the Azure cloud that's based on the MySQL Community Edition.
- [Key Vault](https://azure.microsoft.com/products/key-vault) is one of several key-management solutions in Azure that help manage keys, secrets, and certificates. This solution uses Key Vault for storing application secrets and the certificates that Application Gateway and Azure Spring Apps use.
- [Azure resource groups](https://azure.microsoft.com/get-started/azure-portal/resource-manager) are logical containers for Azure resources. In this solution, resource groups organize components within a region. As a naming convention, the setup includes a short string for the component's region, so it's easy to identify in which region the component runs.
- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) is the fundamental building block for a private network in Azure. This solution uses a virtual network for each region that you use for deployment.
- [Azure Private Link](https://azure.microsoft.com/products/private-link) provides private endpoints that connect privately and securely to services. These network interfaces use private IP addresses to bring the services into the virtual networks. This solution uses private endpoints for the key vault.
- [Managed identities](/azure/active-directory/managed-identities-azure-resources/overview) in [Azure Active Directory (Azure AD)](https://azure.microsoft.com/products/active-directory) provide automatically managed identities that applications can use to connect to resources that support Azure AD authentication. Applications can use managed identities to get Azure AD tokens without having to manage any credentials. This architecture uses managed identities for several interactions, for example between Azure Spring Apps and the key vault.

### Alternatives

The following sections discuss alternatives for several aspects of this architecture.

#### Multi-region deployment

To increase application resilience and reliability, you can alternatively deploy the application to multiple regions. If you do, add an additional [Azure Front Door](/azure/frontdoor/front-door-overview) or [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) service to load balance requests to your applications across regions.

However, multi-region deployment doubles the cost of your setup, because you duplicate the full setup to a secondary region. For this reason, the choice is often made to provide an active-passive setup, where only one region is active and deployed. In this case, you add a global load balancer to the multi-region setup to provide an easy way of failing over your workloads after a secondary region becomes active. Whether active-active or active-passive is the best choice for your workload depends on the availability requirements you have for your application.

The biggest challenge with a multi-region setup is replicating the data for your application between multiple regions. This isn't an issue with the multi-zone setup. Azure availability zones are connected by a high-performance network with a round-trip latency of less than 2 ms. This latency is OK for most applications.

You can also combine a multi-zone solution with a multi-region solution.

#### Back-end database

This architecture uses a MySQL database for the back-end database. You can also use other database technologies, like [Azure SQL Database](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview), [Azure Database for PostgreSQL](/azure/postgresql/single-server/overview), [Azure Database for MariaDB](/azure/mariadb/overview), or [Azure Cosmos DB](/azure/cosmos-db/introduction).

You can also connect some of these databases to your virtual network through [Azure Private Link](https://azure.microsoft.com/products/private-link). Azure Private Link isn't necessary for [the flexible server deployment mode of Azure Database for MySQL](https://azure.microsoft.com/products/mysql), which directly supports virtual network integration through a dedicated subnet.

#### Reverse proxy setup

The current solution uses Application Gateway as a reverse proxy. You can, however, use different reverse proxies in front of Azure Spring Apps. You can combine Azure Application Gateway with Azure Front Door, or you can use Azure Front Door instead of Azure Application Gateway.

For information about different reverse proxy scenarios, how to set them up, and their security considerations, see [Expose Azure Spring Apps through a reverse proxy](spring-cloud-reverse-proxy.yml).

#### Key vault

This solution stores the application secrets and certificates in a single key vault. However, because application secrets and the certificates for host name preservation are different concerns, you might want to store them in separate key vaults. This alternative adds another key vault to your architecture.

## Solution details

This architecture describes a multi-zone design for Azure Spring Apps. This architecture is useful when you want to:

- Increase the availability of your applications.
- Increase the overall resilience and service level objective (SLO) of your application.

### Potential use cases

- Public website hosting
- Intranet portal
- Mobile app hosting
- E-commerce
- Media streaming
- Machine learning workloads

> [!IMPORTANT]
> For business-critical workloads, we recommend combining zone redundancy and regional redundancy to achieve maximum reliability and availability, with zone-redundant services deployed across multiple Azure regions.
> For more information, refer to the [Global distribution](/azure/architecture/framework/mission-critical/mission-critical-application-design#global-distribution) section of the mission-critical design methodology, and the [Mission-critical baseline architecture](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro).
> You can also use the [Deploy Azure Spring Apps to multiple regions guidance](/azure/architecture/reference-architectures/microservices/spring-apps-multi-region) for an automated setup across regions.

## Recommendations

The following recommendations apply to most scenarios. Follow these recommendations unless you have specific requirements that override them.

### Front-end IP Addresses

[Availability zone](/azure/virtual-network/ip-services/public-ip-addresses#availability-zone) support is available for public IP addresses with a standard SKU. When you use availability zones in your architecture,  make sure you use availability zones for all the components in your setup, including the public IP address used by the Application Gateway.

### Application Gateway

[Application Gateway v2](/azure/application-gateway/overview-v2) can be spread across multiple availability zones. When you use availability zones in your architecture, make sure you use availability zones for all the components in your setup, including the Application Gateway.

Enable [Web Application Firewall](/azure/web-application-firewall/) on your OWASP-enabled Application Gateway.

### Key Vault

Key Vault is automatically zone redundant in any region where availability zones are available. The instance of Key Vault that this architecture uses is deployed so that back-end services can access secrets. There's a private endpoint that's enabled, and public network access is disabled. For more information about private endpoints for Azure Key Vault, see [Integrate Key Vault with Azure Private Link](/azure/key-vault/general/private-link-service?tabs=cli).

### Azure Database for MySQL in flexible server mode

[Azure Database for MySQL with the flexible server deployment option](/azure/mysql/flexible-server/concepts-high-availability) deployed in a virtual network supports configuring high availability with automatic failover. The high-availability solution is designed to ensure that committed data is never lost because of failures and that the database isn't a single point of failure in your software architecture. When high availability is configured, flexible server automatically provisions and manages a standby replica. When you use availability zones in your architecture, make sure you use availability zones for all the components in your setup, including the database.

When you configure high availability for your Azure Database for MySQL with the flexible server deployment option, you can choose between `Zone-redundant HA` and `same-zone HA`. What option you choose depends on your latency requirements.

### Automated deployment

Automate your deployments as much as possible. You should automate infrastructure deployment and application code deployments.

Automating infrastructure deployments guarantees that infrastructure is configured identically, avoiding configuration drift (for example, between environments). Infrastructure automation can also help you test failing over and quickly bringing up a secondary region.

You can also use a [blue-green](/azure/architecture/example-scenario/blue-green-spring/blue-green-spring) or canary deployment strategy.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

This architecture explicitly increases the availability of your application over a single-zone deployment.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

From a networking perspective, this architecture is locked down to allow incoming calls only through the public endpoint exposed by Application Gateway. From the Application Gateway, the calls route to the back-end Azure Spring Apps service. Communication from Azure Spring Apps to supporting services, like the back-end database and the key vault, is also locked down by using either private endpoints or network integration.

This architecture provides extra security by using a managed identity to connect between different components. For example, Azure Spring Apps uses a managed identity to connect to Key Vault. Key Vault allows Azure Spring Apps only minimal access to read the needed secrets, certificates, and keys.

You should also protect your virtual networks with [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview). DDoS Protection, combined with application design best practices, provides enhanced mitigations to defend against distributed denial-of-service (DDoS) attacks.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

This solution has a higher cost than a single-zone version. This higher cost is because some components in the setup are deployed in multiple zones. Instead of one instance, they run two or even three instances. However, [Azure Spring Apps](/azure/spring-apps/how-to-enable-redundancy-and-disaster-recovery?tabs=azure-cli#pricing) doesn't have any extra cost associated with it when you enable zone redundancy on the service.

To address costs:

- You can deploy different applications and application types to a single instance of Azure Spring Apps. By deploying multiple applications, the cost of the underlying infrastructure is shared across applications.
- Azure Spring Apps supports application autoscaling triggered by metrics or schedules, which can improve utilization and cost efficiency.
- You can use Application Insights in [Azure Monitor](/azure/azure-monitor/overview) to lower operational costs. A comprehensive logging solution provides visibility for automation to scale components in real time. Analyzing log data can also reveal inefficiencies in application code that you can address to improve costs and performance.
- If you use Front Door in an alternative setup instead of Application Gateway, you're charged on a per-request basis. With Front Door, you don't have to provision multiple Application Gateway instances, and cost is calculated per actual request to your application.

All the services this architecture describes are pre-configured in an [Azure pricing calculator estimate](https://azure.com/e/414c5e0b15494e5081cc9f008d82fdaa) with reasonable default values for a small-scale application. You can update this estimate based on the throughput values you expect for your application.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

This architecture addresses the same aspects of operational excellence as the [single-region reference architecture for Azure Spring Apps](/azure/spring-cloud/reference-architecture). You can automate the full architecture rollout.

For operational excellence, integrate all components of this solution with Azure Monitor Logs to provide end-to-end insight into your application.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

This multi-zone architecture is better suited than a single-zone deployment to meet application demands because it spreads the load across availability zones.

Depending on your database setup, you might incur extra latency when data needs to be synchronized between zones.

This architecture has several components that can autoscale based on metrics:

- Application Gateway supports autoscaling. For more information, see [Scale Application Gateway v2 and WAF v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant).
- Azure Spring Apps also supports autoscaling. For more information, see [Set up autoscale for applications](/azure/spring-apps/how-to-setup-autoscale).

## Deploy this scenario

A deployment for this reference architecture is available at [Azure Spring Apps multi zone reference architecture](https://github.com/Azure-Samples/azure-spring-apps-multi-zone) on GitHub. The deployment uses Terraform templates. To deploy the architecture, follow the [step-by-step instructions](https://github.com/Azure-Samples/azure-spring-apps-multi-zone#getting-started).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Gitte Vermeiren](https://www.linkedin.com/in/gitte-vermeiren-b1b2221) | FastTrack for Azure Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What are Azure regions and availability zones?](/azure/reliability/availability-zones-overview)
- [Azure Spring Apps reference architecture](/azure/spring-cloud/reference-architecture)
- [What is Azure Web Application Firewall on Azure Application Gateway?](/azure/web-application-firewall/ag/ag-overview)

## Related resources

- [Deploy Azure Spring Apps to multiple regions](spring-apps-multi-region.yml)
- [Expose Azure Spring Apps through a reverse proxy](spring-cloud-reverse-proxy.yml)
- [High-availability blue/green deployment](../../example-scenario/blue-green-spring/blue-green-spring.yml)
- [Preserve the original HTTP host name between a reverse proxy and its back-end web application](../../best-practices/host-name-preservation.yml)
- [Multi-region web app with private connectivity to a database](../../example-scenario/sql-failover/app-service-private-sql-multi-region.yml)

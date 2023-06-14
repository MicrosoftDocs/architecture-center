This reference architecture describes an approach for running multiple Azure Spring Apps instances across regions in an active-active configuration.

This design builds on the [**Azure Spring Apps baseline architecture**](spring-apps-multi-zone.yml). The baseline deploys a Java Spring Boot application to multiple [availability zones](/azure/availability-zones/az-overview#availability-zones) within a single region. The multiple zones spread the application workload across separate locations so the workload can tolerate local failures within the Azure region.

However, if the entire region experiences an outage, the baseline becomes unavailable to the user. The intent of this design is to build high availability that can withstand a regional outage. 

This architecture is useful to meet the following goals:

- Increase the overall resilience and service level objective (SLO) of the application.
- Enable global reach for the application.
- Bring the workload closer to the end user and make latency as low as possible.
- Use a secondary region as a failover site for the primary region, and opt for an active-passive design.

To increase application resilience and reliability, you can deploy the application to multiple regions. For this design, you need a global router to load balance requests to your applications across regions. The global router in this architecture also addresses other goals. 

The biggest challenge with a multi-region setup is replicating the data for your application between multiple regions. This issue isn't a concern with the multi-zone setup. Azure availability zones are connected by a high-performance network with a round-trip latency of less than 2 ms. This latency period is sufficient for most applications.

> [!TIP]
> ![GitHub logo](../../_images/github.svg) The architecture is backed by an [**example implementation**](https://github.com/Azure-Samples/azure-spring-apps-multi-region) on GitHub that illustrates design choices to deal with the challenges of multi-region deployment, automation, and traffic routing.  

## Architecture

The following diagram depicts the architecture for this approach:

:::image type="content" source="./_images/spring-apps-reference-architecture-multi-region.png" alt-text="Diagram that shows a multi-region Azure Spring Apps reference architecture." lightbox="./_images/spring-apps-reference-architecture-multi-region.png" border="false":::

### Components

The components of this architecture are the same as the [**baseline architecture**](/azure/architecture/web-apps/spring-apps/spring-apps-multi-zone#components). The following list highlights only the changes to the baseline architecture. For product documentation about Azure services, see the [Related resources](#related-resources) section.

- **Azure Front Door** acts as the global load balancer. This service is used because of its capability to deliver higher availability with lower latency, greater scale, and caching at the edge. 

### Workflow

The reference architecture implements the following workflow:

1. The user sends a request to the HTTP host name of the application, such as `www.contoso.com`. Azure DNS resolves the request for this host name to Azure Front Door.

1. Azure Front Door uses various load balancing configurations to forward the incoming requests to the public endpoint of Azure Application Gateway in each region. The Application Gateway instances are configured with the same custom domain name and TLS certificate name as Azure Front Door. 

1. Application Gateway with integrated Azure Web Application Firewall inspects the request. Web Application Firewall allows incoming requests only from the specified Azure Front Door profile.

1. Application Gateway forwards the allowed traffic to the IP address of the load balancer in the provisioned Spring Apps instance. 

1. The internal load balancer only routes the traffic from Application Gateway to the back-end services. These services are hosted in Spring Apps instance inside a virtual network in each region.

1. As part of processing the request, the application communicates with other Azure services inside the virtual network. Examples include the application communicating with Azure Key Vault for secrets and the database for storing state. 

## Global distribution

If you're designing for high availability, you can set up this architecture in an *active-active*, *active-passive with hot standby*, or *active-passive with cold standby* mode.

Your choice depends on the availability requirements for your application. This architecture uses active-active deployment in two regions because the sample organization wants to have a global presence with high uptime SLA (Service Level Agreement). If you're running mission-critical applications and want higher availability, you need to use more than two regions.

> [!NOTE] 
> Multi-region deployment doubles the workload cost because the complete setup is duplicated to a secondary region.

### Active-active

In active-active mode, all regions process requests simultaneously. The greatest challenge with active-active mode is keeping the data synchronization between the regions. This mode is a costly approach because you pay twice for almost all components.

### Active-passive with hot standby

In active-passive mode with hot standby, the secondary region doesn't receive any requests from Azure Front Door as long as the primary region is active. Make sure you replicate your application data from your primary to your secondary region. If a failure occurs in your primary region, you need to change the roles of your back-end databases and fail over all traffic through Azure Front Door to your secondary region.

In active-passive mode, failover is expected to take some time, which makes it easier to ensure all data remains synchronized. However, the active-passive mode with hot standby is as costly as working with active-active mode.
  
### Active-passive with cold standby

In active-passive mode with cold standby, the primary region has all the resources and serves traffic. The secondary region might have fewer components or components with lower compute resources. The technology choices depend on how much downtime is acceptable according to the business requirements. The extent of your secondary region setup also affects costs. Make sure that at least application data is present in the secondary region.

As mentioned, active-passive mode includes failover taking some time, so it's easier to keep all data in sync. Active-passive mode with cold standby is the most cost effective approach because you don't deploy all the resources to both regions.

If your entire solution setup uses templates, you can easily deploy a cold standby secondary region by creating its resources as needed. You can use Terraform, Bicep, or Azure Resource Manager (ARM) templates, and automate infrastructure setup in a continuous integration/continuous deployment (CI/CD) pipeline. You should regularly test your configuration by recreating your secondary region to ensure your templates are deployable in an emergency.

The [deployment stamps](../../patterns/deployment-stamp.yml) pattern is recommended because multiple independent copies of an application or component can be deployed from a single template to multiple regions.

> [!IMPORTANT]
> For mission-critical workloads, we recommend combining zone redundancy and regional redundancy to achieve maximum reliability and availability, with zone-redundant services deployed across multiple Azure regions.
> For more information, see the [Global distribution](/azure/architecture/framework/mission-critical/mission-critical-application-design#global-distribution) section of the mission-critical design methodology, and the [Mission-critical baseline architecture](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro).

### Mode comparison

The following table summarizes the effort required to synchronize data for each mode and compares the cost.

| Mode | Synchronization effort | Cost | 
| --- | --- | --- |
| **Active-active** | **Significant**, maintain data synchronization between regions | **Costly**, pay twice for nearly all components |
| **Active-passive with hot standby** | **Easier**, failover should take some time | **Costly**, same as active-active mode |
| **Active-passive with cold standby** | **Easier**, same as active-passive mode with hot standby | **Cost effective**, don't deploy all resources to both regions |

## Routing between regions

This reference architecture uses [Geographical nodes (Geodes)](/azure/architecture/patterns/geodes) where any region can service any request. 

Azure Front Door is configured with equal routing between the two deployment regions. Azure Front Door also provides other [traffic routing methods to origin](/azure/frontdoor/routing-methods). If you want to route clients to their closest origin, latency-based routing makes the most sense. If you're designing for an active-passive solution, priority-based routing is more appropriate.

The reference architecture example uses an equal-weight load balancing rule between the two regions. Azure Front Door is configured with:

- A custom domain and a transport-layer security (TLS) certificate with the same name as the application host name such as `www.contoso.com`.

- One origin per region where the application is deployed, where each origin is an [Azure Application Gateway](/azure/application-gateway/overview) instance.

### Resource group layout

Use Azure resource groups to manage resources deployed to each region as a single collection. Consider placing the primary region, secondary region, and Azure Front Door into separate resource groups, as shown in the following diagram:

:::image type="content" source="./_images/spring-apps-resource-groups.png" alt-text="Diagram that shows regions deployed in separate resource groups." border="false":::

The diagram shows the following configuration of resource groups:

- Azure Front Door is deployed in the `Application-shared` resource group.
- All resources hosted in the West Europe region (`weu`) are deployed in the `Application-weu` resource group.
- Resources hosted in the East US region (`eus`) are hosted in the `Application-eus` resource group.
- Resources hosted in the Japan East region (`jae`) are hosted in the `Application-jae` resource group.

Resources in the same resource group share the same lifecycle and can be easily created and deleted together. Each region has its own set of resources in a dedicated resource group that follows a naming convention based on the region name. Azure Front Door is in its own resource group because it must exist even if other regions are added or removed.

### Reverse proxy setup

Azure Front Door does global load balancing between regions. This reverse proxy helps distribute the traffic if you deploy a workload to multiple regions. As an alternative, you can use [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview). Traffic Manager is a DNS-based traffic load balancer that load balances only at the domain level.

Azure Front Door has integrated content delivery networks (CDNs) that deliver content from Microsoft's global edge network with points of presence (PoPs) distributed around the world.

The current solution uses two reverse proxies to maintain consistency with the baseline architecture. Azure Front Door is the global router. Application Gateway acts as a load balancer per region. In most cases, this setup isn't required. You can remove Application Gateway if you address the following requirements:

- Because Azure Web Application Firewall is attached to Application Gateway, you need to attach Web Application Firewall to the Azure Front Door service instead.
- You need a way to ensure that incoming calls originate only from your Azure Front Door instance. You can add the `X-Azure-FDID header` check and the Azure Front Door IP ranges check in the Spring Cloud Gateway application. For more information, see [Use Azure Front Door as the reverse proxy](spring-cloud-reverse-proxy.yml#scenario-4-using-azure-front-door-as-the-reverse-proxy).

For information about different reverse proxy scenarios, how to set them up, and their security considerations, see [Expose Azure Spring Apps through a reverse proxy](spring-cloud-reverse-proxy.yml).

### Back-end database

For multi-region deployment, you need to have a data replication strategy. When the application is available across regions, data should be synchronized so users don't see stale data. 

The current architecture uses a MySQL database for the back-end database, but this configuration doesn't address data synchronization. When you choose a database technology, check how to best replicate and synchronize data between regions. One option is the Azure SQL Database, which has an [active geo-replication](/azure/azure-sql/database/active-geo-replication-overview) feature that provides a continuously synchronized, readable secondary database for a primary database. 

You can use this feature in the following scenarios:

- If your secondary region is a cold standby that doesn't receive active requests
- To fail over if your primary region fails
- To set up primary and secondary databases with private link connections to their respective regions via [virtual network peering](/azure/virtual-network/virtual-network-peering-overview) between the two regions. For more information, see [Multiregion web app with private connectivity to a database](../../example-scenario/sql-failover/app-service-private-sql-multi-region.yml).

Another approach is to use Azure Cosmos DB. This service can [globally distribute](/azure/cosmos-db/distribute-data-globally) data by transparently replicating the data to all regions in your Azure Cosmos DB account. You can also configure Azure Cosmos DB with [multiple write regions](/azure/cosmos-db/high-availability#multiple-write-regions). For more information, see [Geode pattern](../../patterns/geodes.yml) and [Globally distributed applications with Azure Cosmos DB](/azure/architecture/solution-ideas/articles/globally-distributed-mission-critical-applications-using-cosmos-db).

## Automated deployment

Automate your infrastructure deployment and application code deployments as much as possible.

Automating infrastructure deployments guarantees that infrastructure is configured identically, which helps to avoid configuration drift such as between regions. Infrastructure automation can also test fail over operations.

For application deployment, make sure your deployment systems target the multiple regions to which they need to deploy. You can also use multiple regions in a [blue-green](blue-green-spring.yml) or canary deployment strategy. With these deployment strategies, you roll out new versions of applications to one region for testing and to other regions after testing is successful.

## Performance and scalability

This architecture is better suited than the [**baseline architecture**](./spring-apps-multi-zone.yml) to meet application demands because it spreads the load across regions. If you configure Azure Front Door to route requests based on latency, users get better response times because requests are routed to the regions closest to them.

Depending on your database setup, you might incur extra latency when data needs to be synchronized between regions. You can overcome this latency by using Azure Cosmos DB with a more relaxed [consistency level](/azure/cosmos-db/consistency-levels).

This reference architecture has several components that can autoscale based on metrics:

- Azure Front Door can autoscale based on demand. You can use other Azure Front Door features like traffic acceleration and caching capabilities to bring assets closer to your end users.
- Application Gateway supports autoscaling. For more information, see [Scale Application Gateway v2 and Web Application Firewall v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant).
- Azure Spring Apps also supports autoscaling. For more information, see [Set up autoscale for applications](/azure/spring-apps/how-to-setup-autoscale).

## Cost considerations

This solution effectively doubles the cost estimates of the [**baseline architecture**](/azure/architecture/web-apps/spring-apps/spring-apps-multi-zone#cost-considerations). 

The main drivers for costs associated with this architecture include:

- The primary and secondary databases must use the same service tier; otherwise, the secondary database might not keep up with replication changes.
- Significant cross-region traffic increases costs. Network traffic between Azure regions incurs charges.

To manage these costs, consider these recommendations for your implementation:

- Use scaled-down versions of resources like Azure Spring Apps and Application Gateway in the standby region, and scale up the resources only when the standby becomes active.
- If your business scenarios allow, create an active-passive setup to save on costs.
- Implement a multi-zone setup in a single region to meet availability and resilience business needs. This option can be more cost effective because you only pay for most resources once.
- Choose the alternative setup that uses only one reverse proxy to help save on costs. Keep in mind that you need to apply extra configuration to maintain the security of this alternative.

We estimated the cost of services in this architecture with the [Azure pricing calculator](https://azure.com/e/414c5e0b15494e5081cc9f008d82fdaa) by using reasonable default values for a small-scale application. You can update this estimate based on the expected throughput values for your application.

## Other considerations

The design considerations for the multi-zone [**baseline architecture**](spring-apps-multi-zone.yml) also apply to the multi-region solution described in this article. Review the following points in the context of the multi-region architecture: 

- **Network security**. It's important to control the communication through the network. This solution allows incoming calls from Azure Front Door only, where the calls are routed to Application Gateway in each region. From Application Gateway, the calls route to the back-end Azure Spring Apps service. Communication from Azure Spring Apps to supporting services like Key Vault is also controlled by using private endpoints. For more information, see [Baseline architecture: Network security](/azure/architecture/web-apps/spring-apps/spring-apps-multi-zone#network-security).

- **Identity and access management**. Implement more secure access by using managed identities to connect between different components. An example is how Azure Spring Apps uses a managed identity to connect to Key Vault. For more information, see [Baseline architecture: Identity and access management](/azure/architecture/web-apps/spring-apps/spring-apps-multi-zone#identity-and-access-management).

- **Monitoring**. You can add instrumentation and enable distributed tracing to collect data from the application. Combine that data source with platform diagnostics to get an end-to-end insight into your application. For more information, see [Baseline architecture: Monitoring](/azure/architecture/web-apps/spring-apps/spring-apps-multi-zone#monitoring).

- **Secret management**. The multi-region solution stores the application secrets and certificates in a single key vault. For more information, see [Baseline architecture: Secret management](/azure/architecture/web-apps/spring-apps/spring-apps-multi-zone#secret-management).

## Scenario deployment

A deployment for this reference architecture is available at [Azure Spring Apps multiregion reference architecture](https://github.com/Azure-Samples/azure-spring-apps-multi-region) on GitHub. The deployment uses Terraform templates.

To deploy the architecture, [follow the step-by-step instructions](https://github.com/Azure-Samples/azure-spring-apps-multi-region#getting-started).

## Contributors

*Microsoft maintains this content. The following contributor developed the original content.*

Principal author:

- [Gitte Vermeiren](https://www.linkedin.com/in/gitte-vermeiren-b1b2221) | FastTrack for Azure Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

To integrate this workload with shared services managed by central teams in your organization, deploy it in an Azure application landing zone. 

> [!div class="nextstepaction"]
> [Azure Spring Apps integrated with landing zones](spring-apps-landing-zone.yml)

## Related resources

For documentation on the Azure services and features used in this architecture, see the following articles:

- [Azure Spring Apps](/azure/spring-apps/)
- [Azure Front Door](/azure/frontdoor/)
- [Azure Application Gateway v2](/azure/application-gateway/overview-v2)
- [Azure Database for MySQL](/azure/mysql/overview)
- [Azure Key Vault](/azure/key-vault/)
- [Azure DNS](/azure/dns/dns-overview)
- [Azure Web Application Firewall](/azure/web-application-firewall/overview)
- [Azure Private Link](/azure/private-link/private-link-overview)
- [Azure AD-managed identities for Azure resources](/azure/active-directory/managed-identities-azure-resources/overview)

We recommend the following guides for a deeper understanding about the configuration choices involved with this architecture:

- [Expose Azure Spring Apps through a reverse proxy](spring-cloud-reverse-proxy.yml)
- [High-availability blue/green deployment for applications](./blue-green-spring.yml)
- [Preserve the original HTTP host name between a reverse proxy and its back-end web application](../../best-practices/host-name-preservation.yml)
- [Multiregion web app with private connectivity to a database](../../example-scenario/sql-failover/app-service-private-sql-multi-region.yml)

This architecture is designed in alignment with the pillars of the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework). We recommend that you review the design principles for each pillar.

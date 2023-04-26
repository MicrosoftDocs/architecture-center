This reference architecture describes an approach for running Java Spring Boot workloads on Azure Spring Apps. The design is focused on achieving high availability through zonal redundancy. The intent is to prevent the application from going down if all datacenters in a zone experience outage. 

This architecture is useful when you want to:

- Increase the availability of your application over a single-zone deployment.
- Increase the overall resilience and service level objective (SLO) of your application.

> [!TIP]
> ![GitHub logo](../../_images/github.svg) The architecture is backed by an [**example implementation**](https://github.com/Azure-Samples/azure-spring-apps-multi-zone) that illustrates some of design choices. Consider the implementation as your first step towards production.

## Architecture

:::image type="content" source="./_images/spring-apps-reference-architecture-single-region-zone-redundant.png" alt-text="Diagram that shows a multi-region Azure Spring Apps reference architecture." lightbox="./_images/spring-apps-reference-architecture-single-region-zone-redundant.png":::

*Download a [Visio file](https://arch-center.azureedge.net/ha-zone-redundant-spring-apps-reference-architecture.vsdx) that contains this architecture diagram.*

### Components

Here are the Azure services used in this architecture. For product documentation about Azure services, see [Related resources](#related-resources). 

- **Azure Spring Apps Standard** hosts a sample Java Spring Boot application implemented as microservices. 

- **Azure Application Gateway Standard_v2** is the load balancer and manages traffic to the applications. It acts a local reverse proxy in a region where your application runs. 

    This SKU has integrated Azure Web Application Firewall (WAF) that provides centralized protection of your web applications from common exploits and vulnerabilities. Web Application Firewall on the Application Gateway tracks OWASP exploits.

- **Azure DNS** resolves requests sent to the host name of the application to the public endpoint of Azure Application Gateway.

- **Azure Database for MySQL** stores state in a backend relational database. 

- **Azure Key Vault** stores application secrets and the certificates. The microservices that run in Azure Spring Apps use the application secrets. Azure Spring Apps and Application Gateway use the certificates for host name preservation.


### Workflow

1. The user accesses the application by using the HTTP host name of the application; for example, `www.contoso.com`. Azure DNS resolves the request for this host name to the public endpoint of Azure Application Gateway.

1. Application Gateway with integrated WAF inspects the request and forwards the allowed traffic to the IP address of the load balancer in the provisioned Azure Spring Apps instance.

1. The internal load balancer routes the traffic to the backend services.

1. As part of processing the request, the application communicates with other Azure services inside the virtual network. For example, it reaches Key Vault for secrets and the database for storing state. 

## Redundancy

Building redundancy in the workload can minimize single points of failure. In this architecture, components are replicated across zones within the selected region. When you use availability zones in your architecture, make sure you use availability zones for all the components in your setup.

Azure services aren't supported in all regions and not all regions support zones. Before selecting a region, check regional and zone support in [Products available by region](https://azure.microsoft.com/global-infrastructure/services/) and [Azure services with availability zone support](/azure/reliability/availability-zones-service-support#azure-services-with-availability-zone-support).

The following table shows the resiliency types for the services in this architecture. Zone-redundant services replicate or distribute resources across zones automatically. Always-available services are always available across all Azure geographies, and are resilient to both zone-wide and region-wide outages.

|Service|Resiliency|
|---|---|
|Azure DNS|Always available|
|Application Gateway|Zone redundant|
|Azure Spring Apps|Zone redundant|
|Azure Database for MySQL|Zone redundant|
|Key Vault|Zone redundant|
|Virtual Network|Zone redundant|
|Azure private endpoints|Zone redundant|

Azure Spring Apps supports zonal redundancy. With this feature, all underlying infrastructure of the service is spread across multiple availability zones providing higher availability for the application. The advantage is that applications are horizontally scaled without any code changes. Azure availability zones are connected by a high-performance network with a roundtrip latency of less than 2 ms. An added benefit is that you don't have to rely on asynchronous replication for data workloads, which often presents extra design challenges.

Multiple availability zones are set up for Application Gateway including the public IP address used by the Application Gateway. [Availability zone](/azure/virtual-network/ip-services/public-ip-addresses#availability-zone) support is available for public IP addresses with a standard SKU.

Azure Database for MySQL with the flexible server deployment option was chosen to support high availability with automatic failover. You can choose between `Zone-redundant HA` and `same-zone HA`. That choice depends on your latency requirements. With high availability configuration, flexible server automatically provisions and manages a standby replica. If there's an outage, committed data isn't lost. 

Key Vault is automatically zone redundant in any region where availability zones are available. The instance of Key Vault that this architecture uses is deployed so that backend services can access secrets. 

## Scalability

The workload should be able to meet the demands placed on it by users in an efficient manner. 

The multi-zone approach is better suited than a single-zone deployment because it spreads the load across availability zones.

This architecture has several components that can autoscale based on metrics:

- Application Gateway supports autoscaling. For more information, see [Scale Application Gateway v2 and WAF v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant).
- Azure Spring Apps also supports autoscaling. For more information, see [Set up autoscale for applications](/azure/spring-apps/how-to-setup-autoscale).

Depending on your database setup, you might incur extra latency when data needs to be synchronized between zones.


## Network security

The application needs to be protected from unauthorized access from the internet, systems in private networks, other Azure services, and even some tighly coupled dependencies.

[Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) is the fundamental building block for a private network in Azure. This architecture uses a virtual network for each region that you use for deployment. Components are placed in subnets to create further isolation. For example, Azure Spring Apps requires a dedicated subnet for the service runtime and a separate subnet for Spring Boot applications.

You should also protect your virtual networks with [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview). DDoS Protection, combined with application design best practices, provides enhanced mitigations to defend against distributed denial-of-service (DDoS) attacks.

The design incorporates several PaaS services that participate in processing a user request. Strict network controls should be placed on those services to make sure the application isn't impacted.

##### Private connectivity

Communication from Azure Spring Apps to supporting services, like the back-end database and the key vault, is also locked down by using either private endpoints or network integration.

You can control access by using private endpoints. These network interfaces use private IP addresses to bring the services into the virtual network. 

The architecture has Azure services that automatically set up the private endpoints. 

Azure Spring Apps is deployed into that network using [vnet-injection](/azure/spring-apps/how-to-deploy-in-azure-virtual-network). As part of provisioning the necessary private endpoints are automatically created. The application is accessed by reaching the private IP address.

The database also follows a similar model. The [flexible server deployment mode of Azure Database for MySQL](https://azure.microsoft.com/products/mysql) supports virtual network integration through a dedicated subnet.

There are other services, such as Azure Key Vault, which are connected to the virtual network through [Azure Private Link](https://azure.microsoft.com/products/private-link). For Private Link, you need to enable a private endpoint so that public network access is disabled. For more information about private endpoints for Azure Key Vault, see [Integrate Key Vault with Azure Private Link](/azure/key-vault/general/private-link-service?tabs=cli).

Private endpoints should be put in a dedicated subnet. Private IP addresses to the private endpoints are assigned from that subnet.

The private endpoint and network-integrated connections use an [Azure private DNS zone](/azure/dns/private-dns-getstarted-cli).

##### Controls on the traffic flow

This architecture is locked down to allow incoming calls only through the public endpoint exposed by Application Gateway.

The traffic still needs to be inspected to block common exploits and vulnerabilities. Web Application Firewall on the Application Gateway tracks Open Web Application Security Project (OWASP) vulnerabilities. Incoming traffic is inspected based on the configured rules with an action to follow. 

Azure Spring Apps instance has an internal load balancer that routes and distributes traffic to the backend services. The load balancer has been configured only to accept traffic from Application Gateway.

The application might need to connect with other endpoints over the public internet. To restrict that flow, consider placing Azure Firewall on the egress path.

##### Reverse proxy setup

The current solution uses Application Gateway as a reverse proxy. You can, however, use different reverse proxies in front of Azure Spring Apps. You can combine Azure Application Gateway with Azure Front Door, or you can use Azure Front Door instead of Azure Application Gateway.

For information about different reverse proxy scenarios, how to set them up, and their security considerations, see [Expose Azure Spring Apps through a reverse proxy](spring-cloud-reverse-proxy.yml).


## Identity and access management

Network controls aren't enough. The security posture must be hardened by using identity as the perimeter. 

The application should authenticate itself when it connects with the backend services. For example, when it needs to get secrets from key vault. The recommended way is to enable [Managed identities](/azure/active-directory/managed-identities-azure-resources/overview) for the application. That configuration assigns an identity to the application and allows it to obtain [Azure Active Directory (Azure AD)](https://azure.microsoft.com/products/active-directory) tokens. This approach reduces the overhead of managing any credentials. 

This architecture uses System Assigned managed identities for several interactions.

The backend services should allow access to the service principal allocated to the managed identity. Also, the service should define minimal access policies for certain actions. In this architecture, Key Vault allows the application to get and list the secrets, certificates, and keys.  

## Secret management

This solution stores the application secrets and certificates in a single key vault. However, because application secrets and the certificates for host name preservation are different concerns, you might want to store them in separate key vaults. This alternative adds another key vault to your architecture.

## Monitoring

Integrate all components of this solution with [Azure Monitor](/azure/azure-monitor/overview) logs to provide end-to-end insight into your application.

You can use [Application Insights](/azure/azure-monitor/app/app-insights-overview) in [Azure Monitor](/azure/azure-monitor/overview) to get logs and metrics from the application. This  comprehensive logging solution provides visibility for automation to scale components in real time. Analyzing log data can also reveal inefficiencies in application code that you can address to improve costs and performance.

## Automated deployment

Automate your deployments as much as possible. You should automate infrastructure deployment and application code deployments.

Automating infrastructure deployments guarantees that infrastructure is configured identically, avoiding configuration drift (for example, between environments). Infrastructure automation can also test fail over operations and quickly bringing up a secondary region.

You can also use a [blue-green](/azure/architecture/example-scenario/blue-green-spring/blue-green-spring) or canary deployment strategy.

## Cost considerations

There's a tradeoff on cost. Expect higher cost because the components are deployed in multiple zones. Instead of one instance, they run two or even three instances. However, [Azure Spring Apps](/azure/spring-apps/how-to-enable-redundancy-and-disaster-recovery?tabs=azure-cli#pricing) doesn't have any extra cost associated with it when you enable zone redundancy on the service.

To address costs:

- You can deploy different applications and application types to a single instance of Azure Spring Apps. When multiple applications are deployed, the cost of the underlying infrastructure is shared across applications.
- Azure Spring Apps supports application autoscaling triggered by metrics or schedules, which can improve utilization and cost efficiency.
- You can use Application Insights in [Azure Monitor](/azure/azure-monitor/overview) to lower operational costs. 

The cost of services was estimated in [Azure pricing calculator](https://azure.com/e/414c5e0b15494e5081cc9f008d82fdaa) with reasonable default values for a small-scale application. You can update this estimate based on the throughput values you expect for your application.


## Deploy this scenario

A deployment for this reference architecture is available at [Azure Spring Apps multi zone reference architecture](https://github.com/Azure-Samples/azure-spring-apps-multi-zone) on GitHub. The deployment uses Terraform templates. 

To deploy the architecture, follow the [step-by-step instructions](https://github.com/Azure-Samples/azure-spring-apps-multi-zone#getting-started).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Gitte Vermeiren](https://www.linkedin.com/in/gitte-vermeiren-b1b2221) | FastTrack for Azure Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

To increase application resilience and reliability, you can deploy the application to multiple regions.

> [!div class="nextstepaction"]
> [Deploy Azure Spring Apps to multiple regions](spring-apps-multi-region.yml)

To integrate this workload with shared services managed by central teams in your organization, deploy it in Azure application landing zone. 

> [!div class="nextstepaction"]
> [Azure Spring Apps integrated with landing zones](spring-apps-landing-zone.yml)

## Related resources

For documentation on the Azure services and features used in this architecture, see these articles.

- [Azure Spring Apps](https://azure.microsoft.com/products/spring-apps)
- [Azure Application Gateway v2](/azure/application-gateway/overview-v2)
- [Azure Database for MySQL](/azure/mysql/overview)
- [Azure Key Vault](/azure/key-vault/)
- [Azure DNS](/azure/dns/dns-overview)
- [Azure Web Application Firewall](/azure/web-application-firewall/overview)
- [Azure Private Link](/azure/private-link/private-link-overview)
- [Managed identities](/azure/active-directory/managed-identities-azure-resources/overview)

We recommend these guides to get deeper understanding around the choices made in this architecture:

- [Expose Azure Spring Apps through a reverse proxy](spring-cloud-reverse-proxy.yml)
- [High-availability blue/green deployment](../../example-scenario/blue-green-spring/blue-green-spring.yml)


This architecture has been designed keeping alignment with the pillars of the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework). We recommend that you review the design principles for each pillar.


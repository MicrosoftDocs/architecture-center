This reference architecture describes an approach for running Java Spring Boot workloads on Azure Spring Apps. The design is focused on achieving high availability through zonal redundancy. The intent is to prevent the application from going down if all datacenters in a zone experience outage. 

This architecture is useful to meet the following goals:

- Increase the availability of your application over a single-zone deployment.
- Increase the overall resilience and service level objective (SLO) of your application.

This solution presents a **baseline** strategy for Azure Spring Apps deployment. Other solutions area available that build on this architecture, including [deployment to multiple regions](spring-apps-multi-region.yml) and [deployment with integrated landing zones](spring-apps-landing-zone.yml).

> [!TIP]
> ![GitHub logo](../../_images/github.svg) The architecture is backed by an [**example implementation**](https://github.com/Azure-Samples/azure-spring-apps-multi-zone) on GitHub that illustrates some of the design choices. Consider the implementation as your first step toward production.

## Architecture

The following diagram depicts the architecture for this approach:

:::image type="content" source="./_images/spring-apps-reference-architecture-single-region-zone-redundant.png" alt-text="Diagram that shows a multi-region Azure Spring Apps reference architecture." lightbox="./_images/spring-apps-reference-architecture-single-region-zone-redundant.png" border="false":::

### Components

The following Azure services are the components in this architecture. For product documentation about Azure services, see the [Related resources](#related-resources) section. 

- **Azure Spring Apps Standard** hosts a sample Java Spring Boot application implemented as microservices. 

- **Azure Application Gateway Standard_v2** is the load balancer and manages traffic to the applications. It acts a local reverse proxy in a region where your application runs. 

    This SKU has the integrated Azure Web Application Firewall that provides centralized protection of your web applications from common exploits and vulnerabilities. Web Application Firewall on Application Gateway tracks Open Web Application Security Project (OWASP) exploits.

- **Azure DNS** resolves requests sent to the host name of the application to the public endpoint of Application Gateway. Azure Private DNS zones resolve requests to the private endpoints used to access the named [Azure Private Link](https://azure.microsoft.com/products/private-link) resources.

- **Azure Database for MySQL** stores state in a back-end relational database. 

- **Azure Key Vault** stores application secrets and the certificates. The microservices that run in Azure Spring Apps use the application secrets. Azure Spring Apps and Application Gateway use the certificates for host name preservation.

### Workflow

The reference architecture implements the following workflow:

1. The user accesses the application by using the HTTP host name of the application such as `www.contoso.com`. Azure DNS resolves the request for this host name to the public endpoint of Application Gateway.

1. Application Gateway with integrated Web Application Firewall inspects the request and forwards the allowed traffic to the IP address of the load balancer in the provisioned Azure Spring Apps instance.

1. The internal load balancer routes the traffic to the back-end services.

1. As part of processing the request, the application communicates with other Azure services inside the virtual network. Examples include the application communicating with Key Vault for secrets and the database for storing state. 

## Redundancy

Building redundancy in the workload can minimize single points of failure. In this architecture, components are replicated across zones within the selected region. When you use availability zones in your architecture, make sure you use availability zones for all the components in your setup.

Azure services aren't supported in all regions and not all regions support zones. Before selecting a region, check regional and zone support in [Products available by region](https://azure.microsoft.com/global-infrastructure/services/) and [Azure services with availability zone support](/azure/reliability/availability-zones-service-support#azure-services-with-availability-zone-support).

The following table shows the resiliency types for the services in this architecture. Zone-redundant services replicate or distribute resources across zones automatically. Always-available services are always available across all Azure geographies, and are resilient to both zone-wide and region-wide outages.

|Service|Resiliency|
|---|---|
|Azure DNS|Always available|
|Azure Application Gateway|Zone redundant|
|Azure Spring Apps|Zone redundant|
|Azure Database for MySQL|Zone redundant|
|Azure Key Vault|Zone redundant|
|Azure Virtual Network|Zone redundant|
|Azure private endpoints|Zone redundant|

Azure Spring Apps supports zonal redundancy. With this feature, all underlying infrastructure of the service is spread across multiple availability zones, which provides higher availability for the application. The advantage is that applications are horizontally scaled without any code changes. Azure availability zones are connected by a high-performance network with a roundtrip latency of less than 2 ms. An added benefit is that you don't have to rely on asynchronous replication for data workloads, which often presents extra design challenges.

Multiple availability zones are set up for Application Gateway including the public IP address used by the Application Gateway. [Availability zone](/azure/virtual-network/ip-services/public-ip-addresses#availability-zone) support is available for public IP addresses with a standard SKU.

This architecture uses Azure Database for MySQL with the flexible server deployment option to support high availability with automatic failover. You can choose between `Zone-redundant HA` and `same-zone HA` depending on your latency requirements. With the high availability configuration, the flexible server option automatically provisions and manages a standby replica. If there's an outage, committed data isn't lost. 

Key Vault is automatically zone redundant in any region where availability zones are available. The Key Vault instance used by this architecture is deployed to enable back-end services to access secrets. 

## Scalability

Scalability indicates the ability of the workload to meet the demands placed on it by users in an efficient manner. The multi-zone approach is better suited than a single-zone deployment because it spreads the load across availability zones.

This architecture has several components that can autoscale based on metrics:

- Application Gateway supports autoscaling. For more information, see [Scale Application Gateway v2 and Web Application Firewall v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant).
- Azure Spring Apps also supports autoscaling. For more information, see [Set up autoscale for applications](/azure/spring-apps/how-to-setup-autoscale).

Depending on your database setup, you might incur extra latency when data needs to be synchronized between zones.

## Network security

The application needs to be protected from unauthorized access from the internet, systems in private networks, other Azure services, and even some tightly coupled dependencies.

[Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) is the fundamental building block for a private network in Azure. This architecture uses a virtual network for the region that you use for deployment. Components are placed in subnets to create further isolation. Azure Spring Apps requires a dedicated subnet for the service runtime and a separate subnet for Java Spring Boot applications.

You should also protect your virtual networks with [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview). Distributed denial of service (DDoS) protection combined with application design best practices provides enhanced mitigations to defend against DDoS attacks.

The architecture design incorporates several PaaS services that participate in processing a user request. Strict network controls should be placed on those services to make sure the application isn't affected.

##### Private connectivity

Communication from Azure Spring Apps to supporting services like Key Vault and Azure Database for MySQL is also controlled by using either private endpoints or network integration.

You can control access by using private endpoints. These network interfaces use private IP addresses to bring the services into the virtual network. The architecture has Azure services that automatically set up the private endpoints. 

Azure Spring Apps is deployed into the network via the [VNET injection](/azure/spring-apps/how-to-deploy-in-azure-virtual-network) process. The application is accessed by reaching the private IP address.

<!-- Reviewers: Consider changing the following link for flexible server information to this target: https://azure.microsoft.com/en-us/resources/azure-database-for-mysql-flexible-server-infographic/ -->

The database also follows a similar model. The [flexible server deployment mode of Azure Database for MySQL](https://azure.microsoft.com/products/mysql) supports virtual network integration through a dedicated subnet.

There are other services, such as Azure Key Vault, which are connected to the virtual network through Private Link. For Private Link, you need to enable a private endpoint in order to disable public network access. For more information about private endpoints for Key Vault, see [Integrate Key Vault with Azure Private Link](/azure/key-vault/general/private-link-service?tabs=cli).

Private endpoints don't require a dedicated subnet, but it's good practice to put them in a separate subnet. Private IP addresses to the private endpoints are assigned from that subnet.

The private endpoint and network-integrated connections use an [Azure private DNS zone](/azure/dns/private-dns-getstarted-cli).

##### Controls on the traffic flow

This architecture allows incoming requests only through the public endpoint exposed by Application Gateway. The traffic still needs to be inspected to block common exploits and vulnerabilities. Web Application Firewall on the Application Gateway tracks OWASP vulnerabilities. Incoming traffic is inspected based on the configured rules with an action to follow. 

The Azure Spring Apps instance has an internal load balancer that routes and distributes traffic to the back-end services. The load balancer is configured to accept traffic only from Application Gateway.

The application might need to connect with other endpoints over the public internet. To restrict that flow, consider placing Azure Firewall on the egress path.

##### Reverse proxy setup

The current solution uses Application Gateway as a reverse proxy. However, you can use different reverse proxies in front of Azure Spring Apps. You can combine Application Gateway with Azure Front Door, or you can use Front Door instead of Application Gateway.

For information about different reverse proxy scenarios, how to set them up, and their security considerations, see [Expose Azure Spring Apps through a reverse proxy](spring-cloud-reverse-proxy.yml).

## Identity and access management

Network controls aren't enough. The security posture must be strengthened by using identity as the perimeter. 

The application should authenticate itself when it connects with the back-end services, such as when it needs to retrieve secrets from key vault. The recommended approach is to enable [Azure Active Directory (Azure AD) managed-identities for Azure resources](/azure/active-directory/managed-identities-azure-resources/overview) for the application. This method of configuration assigns an identity to the application and allows it to obtain [Azure AD](https://azure.microsoft.com/products/active-directory) tokens, which reduces the overhead of managing any credentials. 

This architecture uses [system-assigned managed identities](/azure/active-directory/managed-identities-azure-resources/overview#managed-identity-types) for several interactions.

The back-end services should allow access to the service principal that's allocated to the managed identity. Also, the service should define minimal access policies for certain actions. In this architecture, Key Vault allows the application to get and list the secrets, certificates, and keys.  

## Secret management

This architecture stores the application secrets and certificates in a single key vault. However, because application secrets and the certificates for host name preservation are different concerns, you might want to store these items in separate key vaults. This alternate approach adds another key vault to your architecture.

## Monitoring

Add instrumentation to your application to emit log and metrics at the code level. Also consider enabling distributed tracing for observability across different services within the Azure Spring Apps instance. Use an Application Performance Management (APM) tool to collect that data. The [Azure Application Insights](/azure/azure-monitor/app/app-insights-overview) Java agent for [Azure Monitor](/azure/azure-monitor/overview) is a good choice for the APM tool.

In addition, use platform diagnostics to get logs and metrics from all the Azure services. Integrate all data with [Azure Monitor Logs](/azure/azure-monitor/logs/data-platform-logs) to provide end-to-end insight into your application.

This comprehensive logging solution provides visibility for automation to scale components in real time. Analyzing log data can also reveal inefficiencies in application code that you can address to improve costs and performance.

## Automated deployment

Automate your infrastructure deployment and application code deployments as much as possible.

Automating infrastructure deployments guarantees that infrastructure is configured identically, which helps to avoid configuration drift such as between environments. Infrastructure automation can also test fail over operations.

You can also use a [blue-green](/azure/architecture/example-scenario/blue-green-spring/blue-green-spring) or canary deployment strategy for your applications.

## Cost considerations

There's a tradeoff on cost. Expect higher cost because the components are deployed in multiple zones. Instead of one instance of Spring Apps, they run two or even three instances. However, there's no extra cost for enabling zone redundancy on the service. For more information, see [Spring Apps - Pricing](/azure/spring-apps/how-to-enable-redundancy-and-disaster-recovery?tabs=azure-cli#pricing).

Consider the following implementation choices to address costs:

- You can deploy different applications and application types to a single instance of Spring Apps. When you deploy multiple applications, the cost of the underlying infrastructure is shared across applications.
- Spring Apps supports application autoscaling triggered by metrics or schedules, which can improve utilization and cost efficiency.
- You can use Application Insights in Azure Monitor to lower operational costs. Continuous monitoring can help address issues quicker and improve costs and performance.

We estimated the cost of services in this architecture with the [Azure pricing calculator](https://azure.com/e/414c5e0b15494e5081cc9f008d82fdaa) by using reasonable default values for a small-scale application. You can update this estimate based on the expected throughput values for your application.

## Scenario deployment

A deployment for this reference architecture is available at [Azure Spring Apps multi-zone reference architecture](https://github.com/Azure-Samples/azure-spring-apps-multi-zone) on GitHub. The deployment uses Terraform templates. 

To deploy the architecture, follow the [step-by-step instructions](https://github.com/Azure-Samples/azure-spring-apps-multi-zone#getting-started).

## Contributors

*Microsoft maintains this content. The following contributor developed the original content.*

Principal author:

- [Gitte Vermeiren](https://www.linkedin.com/in/gitte-vermeiren-b1b2221) | FastTrack for Azure Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

To increase application resilience and reliability, you can deploy the application to multiple regions.

> [!div class="nextstepaction"]
> [Deploy Azure Spring Apps to multiple regions](spring-apps-multi-region.yml)

To integrate this workload with shared services managed by central teams in your organization, deploy the architecture in an Azure application landing zone. 

> [!div class="nextstepaction"]
> [Azure Spring Apps integrated with landing zones](spring-apps-landing-zone.yml)

## Related resources

For documentation on the Azure services and features used in this architecture, see the following articles:

- [Azure Spring Apps](https://azure.microsoft.com/products/spring-apps)
- [Azure Application Gateway v2](/azure/application-gateway/overview-v2)
- [Azure Database for MySQL](/azure/mysql/overview)
- [Azure Key Vault](/azure/key-vault/)
- [Azure DNS](/azure/dns/dns-overview)
- [Azure Private DNS zone](/azure/dns/private-dns-privatednszone)
- [Azure Web Application Firewall](/azure/web-application-firewall/overview)
- [Azure Private Link](/azure/private-link/private-link-overview)
- [Azure AD-managed identities for Azure resources](/azure/active-directory/managed-identities-azure-resources/overview)

We recommend the following guides for a deeper understanding about the configuration choices involved with this architecture:

- [Expose Azure Spring Apps through a reverse proxy](spring-cloud-reverse-proxy.yml)
- [High-availability blue/green deployment for applications](../../example-scenario/blue-green-spring/blue-green-spring.yml)

This architecture is designed in alignment with the pillars of the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework). We recommend that you review the design principles for each pillar.

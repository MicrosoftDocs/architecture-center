This reference architecture describes how to run Java Spring Boot workloads on Azure Spring Apps. The design uses zone redundancy to achieve high availability. Implement this design to prevent an application from failing if there's an outage in all datacenters in a zone.

This architecture helps you:

- Increase the availability of your application over a single-zone deployment.
- Increase the overall resilience and service-level objective (SLO) of your application.

This solution presents a baseline strategy for Azure Spring Apps deployment. For other solutions that build on this architecture, see [Deploy Azure Spring Apps to multiple regions](spring-apps-multi-region.yml) and [Azure Spring Apps integrated with landing zones](spring-apps-landing-zone.yml).

> [!TIP]
> ![GitHub logo](../../../_images/github.svg) See an [example implementation](https://github.com/Azure-Samples/azure-spring-apps-multi-zone) that illustrates some of the design choices of this architecture. Consider this implementation as your first step toward production.

## Architecture

The following diagram shows the architecture for this approach:

:::image type="content" source="../_images/deploy-spring-web-applications.svg" alt-text="Diagram that shows a multi-region Azure Spring Apps reference architecture." lightbox="../_images/deploy-spring-web-applications.svg" border="false":::
*Download a [Visio file](https://arch-center.azureedge.net/deploy-spring-web-applications.vsdx) of this architecture.*

### Workflow

This workflow corresponds to the previous diagram:

1. The user accesses the application by using the HTTP host name of the application, such as `www.contoso.com`. Azure DNS is used to resolve the request for this host name to the Azure Application Gateway public endpoint.

1. Application Gateway is used to inspect the request. It's also used to forward the allowed traffic to the IP address of the load balancer that's in the provisioned Azure Spring Apps instance. Application Gateway is integrated with Azure Web Application Firewall.

1. The internal load balancer is used to route the traffic to the back-end services.

1. While the request is being processed, the application communicates with other Azure services inside the virtual network. For example, the application might receive secrets from Azure Key Vault or the storing state from the database.

### Components

The following Azure services are the components in this architecture:

- The standard version of [Azure Spring Apps](https://azure.microsoft.com/products/spring-apps) is used to host a sample Java Spring Boot application that's implemented as microservices.

- The standard v2 version of [Application Gateway](https://azure.microsoft.com/products/application-gateway) is used to manage traffic to the applications. It acts as a local reverse proxy in the region that your application runs.

    This SKU has [Web Application Firewall](https://azure.microsoft.com/products/web-application-firewall) integrated to help protect your web applications from exploits and vulnerabilities. Web Application Firewall on Application Gateway tracks Open Web Application Security Project (OWASP) exploits.

- [Azure DNS](https://azure.microsoft.com/products/dns) is used to resolve requests that are sent to the host name of the application. It resolves those requests to the Application Gateway public endpoint. [Azure DNS private zones](/azure/dns/private-dns-privatednszone) are used to resolve requests to the private endpoints that access the named [Azure Private Link](https://azure.microsoft.com/products/private-link) resources.

- [Azure Database for MySQL](https://azure.microsoft.com/products/mysql) is used to store state in a back-end relational database.

- [Key Vault](https://azure.microsoft.com/products/key-vault) is used to store application secrets and certificates. The microservices that run in Azure Spring Apps use the application secrets. Azure Spring Apps and Application Gateway use the certificates for host name preservation.

### Alternatives

Azure Database for MySQL isn't the only option for a database. You can also use:

- [Azure Database for PostgreSQL](https://azure.microsoft.com/products/postgresql)
- [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db)
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database/)

## Redundancy

Build redundancy in your workload to minimize single points of failure. In this architecture, you replicate components across zones within a region. In your architecture, ensure that you use availability zones for all components in your setup.

Azure services aren't supported in all regions and not all regions support zones. Before you select a region, verify its [regional](https://azure.microsoft.com/global-infrastructure/services) and [zone support](/azure/reliability/availability-zones-service-support#azure-services-with-availability-zone-support).

Zone-redundant services automatically replicate or distribute resources across zones. Always-available services are always available across all Azure geographies and are resilient to zone-wide and region-wide outages.

The following table shows the resiliency types for the services in this architecture:

|Service|Resiliency|
|---|---|
|Azure DNS|Always available|
|Application Gateway|Zone redundant|
|Azure Spring Apps|Zone redundant|
|Azure Database for MySQL|Zone redundant|
|Key Vault|Zone redundant|
|Azure Virtual Network|Zone redundant|
|Azure private endpoints|Zone redundant|

Azure Spring Apps supports zone redundancy. With zone redundancy, all underlying infrastructure of the service is spread across multiple availability zones, which provides higher availability for the application. Applications scale horizontally without any code changes. A high-performance network connects Azure availability zones. The connection has a roundtrip latency of less than 2 milliseconds (ms). You don't have to rely on asynchronous replication for data workloads, which often presents design challenges.

Multiple availability zones are set up for Application Gateway, including the public IP address that Application Gateway uses. Public IP addresses with a standard SKU support [availability zones](/azure/virtual-network/ip-services/public-ip-addresses#availability-zone).

This architecture uses Azure Database for MySQL with the Flexible Server deployment option to support high availability with automatic failover. Depending on your latency requirements, choose *zone-redundant high availability* or *same-zone high availability*. With a high-availability configuration, the Flexible Server option automatically provisions and manages a standby replica. If there's an outage, committed data isn't lost.

Key Vault is automatically zone redundant in any region in which availability zones are available. The Key Vault instance that's used in this architecture is deployed to store secrets for back-end services.

## Scalability

Scalability indicates the ability of the workload to efficiently meet the demands that users place on it. The multi-zone approach is better for scalability than a single-zone deployment because it spreads the load across availability zones.

This architecture has several components that can autoscale based on metrics:

- Application Gateway supports automatic scaling. For more information, see [Scale Application Gateway v2 and Web Application Firewall v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant).

- Azure Spring Apps supports autoscaling. For more information, see [Set up autoscale for applications](/azure/spring-apps/how-to-setup-autoscale).

Depending on your database setup, you might incur extra latency when you need to synchronize data between zones.

## Network security

Protect your application from unauthorized access from the internet, systems in private networks, other Azure services, and tightly coupled dependencies.

[Virtual Network](https://azure.microsoft.com/products/virtual-network) is the fundamental building block for a private network in Azure. This architecture uses a virtual network for the deployment's region. Place components in subnets to create further isolation. Azure Spring Apps requires a dedicated subnet for the service runtime and a separate subnet for Java Spring Boot applications.

Protect your virtual networks with [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview). Combine distributed denial of service (DDoS) protection with application design best practices to provide enhanced mitigations to defend against DDoS attacks.

The architecture design incorporates several platform as a service (PaaS) solutions that help process a user request. Place strict network controls on those services to make sure the application isn't affected.

### Private connectivity

Use private endpoints or network integration to provide communication from Azure Spring Apps to supporting services, like Key Vault and Azure Database for MySQL.

Use private endpoints to control access. The network interfaces use private IP addresses to transfer the services into the virtual network. This architecture uses Azure services that automatically set up the private endpoints.

Deploy Azure Spring Apps into the network via the [virtual network injection process](/azure/spring-apps/how-to-deploy-in-azure-virtual-network). The application is accessed by reaching the private IP address.

The database follows a similar model. The [Flexible Server deployment mode of Azure Database for MySQL](/azure/mysql/flexible-server/overview) supports virtual network integration via a dedicated subnet.

Other services, such as Key Vault, are connected to the virtual network via [Private Link](/azure/private-link/private-link-overview). For Private Link, you need to enable a private endpoint to disable public network access. For more information, see [Integrate Key Vault with Private Link](/azure/key-vault/general/private-link-service).

Private endpoints don't require a dedicated subnet, but it's good practice to place them in a separate subnet. Private IP addresses to the private endpoints are assigned from that subnet.

The private endpoint and network-integrated connections use an [Azure DNS private zone](/azure/dns/private-dns-getstarted-cli).

### Controls on the traffic flow

With this architecture, incoming requests are allowed only through the public endpoint that's exposed by Application Gateway. The traffic still needs to be inspected to block exploits and vulnerabilities. Web Application Firewall on the Application Gateway tracks OWASP vulnerabilities. Incoming traffic is inspected based on the configured rules with an action to follow.

The Azure Spring Apps instance has an internal load balancer that routes and distributes traffic to the back-end services. The load balancer is configured to accept traffic only from Application Gateway.

The application might need to connect with other endpoints over the public internet. To restrict that flow, consider placing Azure Firewall on the egress path.

### Reverse proxy setup

This solution uses Application Gateway as a reverse proxy. But you can use different reverse proxies in front of Azure Spring Apps. You can combine Application Gateway with Azure Front Door, or you can use Azure Front Door instead of Application Gateway.

For information about reverse proxy scenarios, how to set them up, and their security considerations, see [Expose Azure Spring Apps through a reverse proxy](../guides/spring-cloud-reverse-proxy.yml).

## Identity and access management

In addition to using network controls, strengthen the security posture by using identity as the perimeter.

The application should authenticate itself when it connects with the back-end services, like if the application retrieves secrets from Key Vault. In the application, the recommended approach is to enable [Microsoft Entra managed identities for Azure resources](/azure/active-directory/managed-identities-azure-resources/overview). This method of configuration assigns an identity to the application so it can obtain [Microsoft Entra ID](https://azure.microsoft.com/products/active-directory) tokens, which reduces the overhead of managing credentials.

This architecture uses [system-assigned managed identities](/azure/active-directory/managed-identities-azure-resources/overview#managed-identity-types) for several interactions.

The back-end services should allow access to the service principal that's allocated to the managed identity. The service should define minimal access policies for certain actions. In this architecture, Key Vault is used to give the application access to the secrets, certificates, and keys.  

## Secret management

This architecture stores the application secrets and certificates in a single key vault. Application secrets and the certificates for host name preservation are different concerns, so you might want to store these items in separate key vaults. This alternate approach adds another key vault to your architecture.

## Monitoring

[Azure Monitor](/azure/azure-monitor/overview) is a monitoring solution for collecting, analyzing, and responding to monitoring data from your cloud and on-premises environments.

Add instrumentation to your application to emit logs and metrics at the code level. Consider enabling distributed tracing to provide observability across services within the Azure Spring Apps instance. Use an application performance management (APM) tool to collect logs and metrics data. The [Application Insights](/azure/azure-monitor/app/app-insights-overview) Java agent for Azure Monitor is a good choice for the APM tool.

Use platform diagnostics to get logs and metrics from all Azure services, such as Azure Database for MySQL. Integrate all data with [Azure Monitor Logs](/azure/azure-monitor/logs/data-platform-logs) to provide end-to-end insight into your application and the platform services.  

[Azure Log Analytics workspace](/azure/azure-monitor/logs/log-analytics-overview) is the monitoring data sink that collects logs and metrics from the Azure resources and Application Insights. This logging solution provides visibility, which helps automation processes to scale components in real time. Analyzing log data can also reveal inefficiencies in application code that you can address to improve costs and performance.

For Spring App-specific monitoring guidance, see [Monitor applications end-to-end](/azure/spring-apps/quickstart-monitor-end-to-end-enterprise) and [Monitor with Dynatrace Java OneAgent](/azure/spring-apps/how-to-dynatrace-one-agent-monitor).

## Automated deployment

Automate your infrastructure deployment and application code deployments as much as possible.

Automating infrastructure deployments guarantees that infrastructure configuration is identical, which helps to avoid configuration drift, potentially between environments. You can also use infrastructure automation to test failover operations.

You can use a [blue-green](/azure/architecture/web-apps/spring-apps/guides/blue-green-spring) or canary deployment strategy for your applications.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

The following considerations provide guidance for implementing the pillars of the Azure Well-Architected Framework in the context of this architecture.

### Reliability

Reliability ensures that your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Implement the following suggestions to create a more reliable application:

- [Deploy Azure Spring Apps to multiple regions](/azure/architecture/web-apps/spring-apps/architectures/spring-apps-multi-region).

- Use a [blue-green deployment](/azure/spring-apps/concepts-blue-green-deployment-strategies) to make it easy to roll back to a previous healthy state if critical problems occur.

- [Set up autoscale for applications](/azure/spring-apps/how-to-setup-autoscale) to help your application perform better when demand changes.

- Enable [Spring Boot web graceful shutdown](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#web.graceful-shutdown) and configure [Azure Spring Apps graceful termination](/azure/spring-apps/how-to-configure-health-probes-graceful-termination#graceful-termination) to forcibly halt processes that run in the app instance.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Implement the following suggestions to create a more secure application:

- Use mature identity and access management (IAM) solutions, like Microsoft Entra ID. Enable multifactor authentication. For more information, see:
  - [Add sign-in with a Microsoft Entra account to a Spring Boot web app](/azure/developer/java/spring-framework/configure-spring-boot-starter-java-app-with-azure-active-directory)
  - [Add sign-in with Azure Active Directory (Azure AD) B2C to a Spring Boot web app](/azure/developer/java/spring-framework/configure-spring-boot-starter-java-app-with-azure-active-directory-b2c-oidc).

- Avoid using passwords when possible. For more information, see:
  - [Migrate an application to use passwordless connections with Azure Database for PostgreSQL](/azure/developer/java/spring-framework/migrate-postgresql-to-passwordless-connection)
  - [Load a secret from Key Vault in a Spring Boot application](/azure/developer/java/spring-framework/configure-spring-boot-starter-java-app-with-azure-key-vault)

- For recommendations on how to secure your Azure Spring app, see [Azure security baseline for Azure Spring Apps](/security/benchmark/azure/baselines/azure-spring-apps-security-baseline).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

For this architecture, expect higher cost because you deploy components in multiple zones. Instead of one instance of Azure Spring Apps, you run two or even three instances. But there's no extra cost for enabling zone redundancy on the service. For more information, see [Azure Spring Apps pricing](/azure/spring-apps/how-to-enable-redundancy-and-disaster-recovery#pricing).

Consider the following implementation choices to address costs:

- You can deploy different applications and application types to a single instance of Azure Spring Apps. When you deploy multiple applications, the cost of the underlying infrastructure is shared across applications.

- Azure Spring Apps supports application autoscaling triggered by metrics or schedules, which can improve utilization and cost efficiency.

- You can use Application Insights in Azure Monitor to lower operational costs. Continuous monitoring can help address issues quicker and improve costs and performance.

- Choose the best pricing tier based on your requirements:
  - [Azure Spring Apps pricing](https://azure.microsoft.com/pricing/details/spring-apps/)
  - [Azure Database for PostgreSQL pricing](https://azure.microsoft.com/pricing/details/postgresql/server/)

- Use [autoscale for applications](/azure/spring-apps/how-to-setup-autoscale) to scale up and down based on demand.

For an estimated cost of services for this architecture, see the [Azure pricing calculator](https://azure.com/e/414c5e0b15494e5081cc9f008d82fdaa). This estimate uses reasonable default values for a small-scale application. You can update the estimate based on the expected throughput values for your application.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

In addition to the [monitoring guidance](#monitoring) covered previously, implement the following suggestions to help you deploy and monitor your application.

- Automate application deployments by using [Azure DevOps](/azure/spring-apps/how-to-cicd) or [GitHub Actions](/azure/spring-apps/how-to-github-actions).

- [Monitor Azure Spring Apps apps by using logs, metrics, and tracing](/azure/spring-apps/quickstart-logs-metrics-tracing).

- [Monitor metrics on Azure Database for PostgreSQL by using Flexible Server](/azure/postgresql/flexible-server/concepts-monitoring).

- Use [Azure Managed Grafana](/azure/managed-grafana/overview) to view and analyze application and infrastructure telemetry data in real time.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Overview of the performance efficiency pillar](/azure/architecture/framework/scalability/overview).

Implement the following suggestions to create a more efficient application:

- Scale apps [manually](/azure/spring-apps/how-to-scale-manual) or [automatically](/azure/spring-apps/how-to-setup-autoscale).

- [Scale operations by using Flexible Server](/azure/postgresql/flexible-server/how-to-scale-compute-storage-portal).

## Deploy this scenario

To deploy this architecture, follow the step-by-step instructions in [Azure Spring Apps multi-zone reference architecture](https://github.com/Azure-Samples/azure-spring-apps-multi-zone). The deployment uses Terraform templates.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Gitte Vermeiren](https://www.linkedin.com/in/gitte-vermeiren-b1b2221) | FastTrack for Azure Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Quickstart: Deploy your first web application to Azure Spring Apps](/azure/spring-apps/quickstart-deploy-web-app)
- [What are managed identities for Azure resources?](/azure/active-directory/managed-identities-azure-resources/overview)

## Related resources

- [Azure Spring Apps integrated with landing zones](spring-apps-landing-zone.yml)
- [Deploy Azure Spring Apps to multiple regions](spring-apps-multi-region.yml)
- [Expose Azure Spring Apps through a reverse proxy](../guides/spring-cloud-reverse-proxy.yml)
- [High-availability blue-green deployments for applications](../../../example-scenario/blue-green-spring/blue-green-spring.yml)
- [Identity and access management for the Azure Spring Apps landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/spring-apps/identity-and-access-management)

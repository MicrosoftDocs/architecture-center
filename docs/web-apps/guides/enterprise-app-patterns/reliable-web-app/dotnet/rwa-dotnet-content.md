---
ms.custom: devx-track-dotnet
---

This article shows you how to apply the Reliable Web App pattern. he Reliable Web App pattern is a set of [principles and implementation techniques](../../overview.md) that define how you should modify web apps (replatform) when migrating to the cloud. It focuses on the minimal code updates you need to make to be successful in the cloud.

To facilitate the application of this guidance, there's a **[reference implementation](https://aka.ms/eap/rwa/dotnet)** of the Reliable Web App pattern that you can deploy.

[![Diagram showing the architecture of the reference implementation.](../../../_images/reliable-web-app-dotnet.svg)](../../../_images/reliable-web-app-dotnet.svg)
*Architecture of the reference implementation. Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-dotnet-1.1.vsdx) of this architecture.*

The following guidance uses the reference implementation as an example throughout. To plan an implementation of the Reliable Web App pattern, follow these steps:

## Define business goals

The initial step in transitioning to cloud computing is to articulate your business objectives. The Reliable Web App pattern emphasizes the importance of setting both immediate and future objectives for your web application. These objectives influence your choice of cloud services and the architecture of your web application in the cloud.

*Example:* The fictional company Relecloud sells tickets through its on-premises web application. Relecloud has a positive sales forecast and anticipates increased demand on their ticketing web app. To meet this demand, they defined the goals for the web application:

- Apply low-cost, high-value code changes
- Reach a service level objective (SLO) of 99.9%
- Adopt DevOps practices
- Create cost-optimized environments
- Improve reliability and security

Relecloud's on-premises infrastructure wasn't a cost-effective solution to reach these goals. So, they decided that migrating their web application to Azure was the most cost effective way to achieve their immediate and future objectives.

## Choose the right managed services

When you move a web app to the cloud, you should select Azure services that meet your business requirements and align with the current features of the on-premises web app. The alignment helps minimize the replatforming effort. For example, use services that allow you to keep the same database engine and support existing middleware and frameworks. The following sections provide guidance for selecting the right Azure services for your web app.

*Example:* Before the move to the cloud, Relecloud's ticketing web app was an on-premises, monolithic, ASP.NET app. It ran on two virtual machines and had a Microsoft SQL Server database. The web app suffered from common challenges in scalability and feature deployment. This starting point, their business goals, and SLO drove their service choices.

### Application platform

Choose the best application hosting platform for your web app. Azure has many different compute options to meet a range of web apps requirements. For help with narrowing options, see the Azure [compute decision tree](/azure/architecture/guide/technology-choices/compute-decision-tree).

*Example:* Relecloud chose [Azure App Service](/azure/app-service/overview) as the application platform for the following reasons:

- *High service level agreement (SLA):* It has a high SLA that meets the production environment SLO of 99.9%.

- *Reduced management overhead:* It's a fully managed solution that handles scaling, health checks, and load balancing.

- *.NET support:* It supports the version of .NET that the application is written in.

- *Containerization capability:* The web app can converge on the cloud without containerizing, but the application platform also supports containerization without changing Azure services

- *Autoscaling:* The web app can automatically scale up, down, in, and out based on user traffic and settings.

### Identity management

Choose the best identity management solution for your web app. For more information, see [compare identity management solutions](/entra/identity/domain-services/compare-identity-solutions) and [authentication methods](/entra/identity/hybrid/connect/choose-ad-authn).

*Example:* Relecloud chose [Microsoft Entra ID](/entra/fundamentals/whatis) for the following reasons:

- *Authentication and authorization:* The application needs to authenticate and authorize call center employees.

- *Scalable:* It scales to support larger scenarios.

- *User-identity control:* Call center employees can use their existing enterprise identities.

- *Authorization protocol support:* It supports OAuth 2.0 for managed identities.

### Database

Choose the best database for your web app. For help with narrowing the options, see the Azure [data store decision tree](/azure/architecture/guide/technology-choices/data-store-decision-tree).

*Example:* The web app used SQL Server on-premises, and Relecloud wanted to use the existing database schema, stored procedures, and functions. Several SQL products are available on Azure, but Relecloud chose [Azure SQL Database](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview?view=azuresql) for the following reasons:

- *Reliability:* The general-purpose tier provides a high SLA and multi-region redundancy. It can support a high user load.

- *Reduced management overhead:* It provides a managed SQL database instance.

- *Migration support:* It supports database migration from on-premises SQL Server.

- *Consistency with on-premises configurations:* It supports the existing stored procedures, functions, and views.

- *Resiliency:* It supports backups and point-in-time restore.

- *Expertise and minimal rework:* SQL Database takes advantage of in-house expertise and requires minimal work to adopt.

### Application performance monitoring

Choose to an application performance monitoring for your web app. [Application Insights](/azure/azure-monitor/app/app-insights-overview) is the Azure-native application performance management (APM) solution. It's a feature of Azure's monitoring solution, [Azure Monitor](/azure/azure-monitor/overview).

*Example:* Relecloud chose to use Application Insights for the following reasons:

- *Integration with Azure Monitor:* It provides the best integration with Azure Monitor.

- *Anomaly detection:* It automatically detects performance anomalies.

- *Troubleshooting:* It helps you diagnose problems in the running app.

- *Monitoring:* It collects information about how users are using the app and allows you to easily track custom events.

- *Visibility gap:* The on-premises solution didn't have application performance monitoring solution. Application Insights provides easy integration with the application platform and code.

### Cache

Choose whether to add cache to your web app architecture. [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) is Azure's primary cache solution. It's a managed in-memory data store based on the Redis software.

*Example:* Relecloud's web app load is heavily skewed toward viewing concerts and venue details. It added Azure Cache for Redis for the following reasons:

- *Reduced management overhead:* It's a fully managed service.

- *Speed and volume:* It has high-data throughput and low latency reads for commonly accessed, slow changing data.

- *Diverse supportability:* It's a unified cache location for all instances of the web app to use.

- *External data store:* The on-premises application servers performed VM-local caching. This setup didn't offload highly frequented data, and it couldn't invalidate data.

- *Nonsticky sessions:* Externalizing session state supports nonsticky sessions.

### Load balancer

Choose the best load balancer for your web app. Azure has several load balancers. For help with narrowing the options, see [choose the best load balancer for your app](/azure/architecture/guide/technology-choices/load-balancing-overview).

*Example:* Relecloud needed a layer-7 load balancer that could route traffic across multiple regions. Relecloud needed a multi-region web app to meet the SLO of 99.9%. Relecloud chose [Azure Front Door](/azure/frontdoor/front-door-overview) for the following reasons:

- *Global load balancing:* It's a layer-7 load balancer that can route traffic across multiple regions.

- *Web application firewall:* It integrates natively with Azure Web Application Firewall.

- *Routing flexibility:* It allows the application team to configure ingress needs to support future changes in the application.

- *Traffic acceleration:* It uses anycast to reach the nearest Azure point of presence and find the fastest route to the web app.

- *Custom domains:* It supports custom domain names with flexible domain validation.

- *Health probes:* The application needs intelligent health probe monitoring. Azure Front Door uses responses from the probe to determine the best origin for routing client requests.

- *Monitoring support:* It supports built-in reports with an all-in-one dashboard for both Front Door and security patterns. You can configure alerts that integrate with Azure Monitor. It lets the application log each request and failed health probes.

- *DDoS protection:* It has built-in layer 3-4 DDoS protection.

- *Content delivery network:* It positions Relecloud to use a content delivery network. The content delivery network provides site acceleration.

### Web application firewall

Choose a web application firewall to protect your web app from web attacks. [Azure Web Application Firewall](/azure/web-application-firewall/overview) (WAF) is Azure's web application firewall and provides centralized protection of from common web exploits and vulnerabilities.

*Example:* Relecloud needed to protect the web app from web attacks. They used Azure Web Application Firewall for the following reasons:

- *Global protection:* It provides improved global web app protection without sacrificing performance.

- *Botnet protection:* The team can monitor and configure to address security concerns from botnets.

- *Parity with on-premises:* The on-premises solution was running behind a web application firewall managed by IT.

- *Ease of use:* Web Application Firewall integrates with Azure Front Door.

### Configuration storage

Choose whether to add app configuration storage to your web app. [Azure App Configuration](/azure/azure-app-configuration/overview) is a service for centrally managing application settings and feature flags. Review [App Configuration best practices](/azure/azure-app-configuration/howto-best-practices#app-configuration-bootstrap) to decide whether this service is a good fit for your app.

*Example:* Relecloud wanted to replace file-based configuration with a central configuration store that integrates with the application platform and code. They added App Configuration to the architecture for the following reasons:

- *Flexibility:* It supports feature flags. Feature flags allow users to opt in and out of early preview features in a production environment without redeploying the app.

- *Supports Git pipeline:* The source of truth for configuration data needed to be a Git repository. The pipeline needed to update the data in the central configuration store.

- *Supports managed identities:* It supports managed identities to simplify and help secure the connection to the configuration store.

### Secrets manager

Use [Azure Key Vault](/azure/key-vault/general/overview) if you have secrets to manage in Azure. You can incorporate Key Vault in .NET apps by using the [ConfigurationBuilder object](/azure/azure-app-configuration/quickstart-dotnet-core-app).

*Example:* Relecloud's on-premises web app stored secrets in code configuration files, but it's a better security practice to externalize secrets. While [managed identities](/entra/architecture/service-accounts-managed-identities) are the preferred solution for connecting to Azure resources, Relecloud had application secrets they needed to manage. Relecloud used Key Vault for the following reasons:

- *Encryption:* It supports encryption at rest and in transit.

- *Managed identities:* The application services can use managed identities to access the secret store.

- *Monitoring and logging:* It facilitates audit access and generates alerts when stored secrets change.

- *Integration:* It provides native integration with the Azure configuration store (App Configuration) and web hosting platform (App Service).

### Storage solution

Choose the best storage solution for your web app. For more information, see [Review your storage options](/azure/architecture/guide/technology-choices/storage-options).

*Example:* On-premises, the web app had disk storage mounted to each web server, but the team wanted to use an external data storage solution. Relecloud chose [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) for the following reasons:

- *Secure access:* The web app can eliminate endpoints for accessing storage exposed to the public internet with anonymous access.

- *Encryption:* It encrypts data at rest and in transit.

- *Resiliency:* It supports zone-redundant storage (ZRS). Zone-redundant storage replicates data synchronously across three Azure availability zones in the primary region. Each availability zone is in a separate physical location that has independent power, cooling, and networking. This configuration should make the ticketing images resilient against loss.

### Endpoint security

Choose to enable private only access to Azure services. [Azure Private Link](/azure/private-link/private-link-overview) provides access to platform-as-a-service solutions over a private endpoint in your virtual network. Traffic between your virtual network and the service travels across the Microsoft backbone network.

*Example:* Relecloud used Private Link for the following reasons:

- *Enhanced security communication:* It lets the application privately access services on the Azure platform and reduces the network footprint of data stores to help protect against data leakage.

- *Minimal effort:* The private endpoints support the web app platform and database platform the web app uses. Both platforms mirror existing on-premises configurations for minimal change.

### Network security

Choose whether to add network security services to your virtual networks. [Azure Firewall](/azure/firewall/overview) is stateful, network firewall that inspects network traffic. [Azure Bastion](/azure/bastion/bastion-overview) allows you to connect to virtual machines securely without exposing RDP/SSH ports.

*Example:* Relecloud adopted a hub and spoke network topology and wanted to put shared network security services in the hub. Azure Firewall improves security by inspecting all outbound traffic from the spokes to increase network security. Relecloud needed Azure Bastion for secure deployments from a jump host in the DevOps subnet.

## Choose the right architecture

After you define what *available* means for your web app and select the best cloud services, you need to determine the best architecture for your web app. Your architecture needs to support your business requirements, technical requirements, and SLO.

### Choose architecture redundancy

The business goals determine the level of infrastructure and data redundancy your web app needs. The web app SLO provides a good baseline for understanding your redundancy requirements. Calculate the [composite SLA](/azure/well-architected/reliability/metrics#slos-and-slas) all the dependencies on the critical path of *availability*. Dependencies should include Azure services and non-Microsoft solutions.

Assign an availability estimate for each dependency. Service level agreements (SLAs) provide a good starting point, but SLAs don't account for code, deployment strategies, and architectural connectivity decisions.

*Example:* Relecloud identified the services on the critical path of availability. They used Azure SLAs for availability estimates. Based on the composite SLA calculation, Relecloud needed a multi-region architecture to meet the SLO of 99.9%.

### Choose a network topology

Choose the right network topology for your web and networking requirements. A hub and spoke network topology is standard configuration in Azure. It provides cost, management, and security benefits. It also supports hybrid connectivity options to on-premises networks.

*Example:* Relecloud chose a hub and spoke network topology to increase the security of their multi-region deployment at reduced cost and management overhead.

### Choose data redundancy

Ensure data reliability by distributing it across Azure's regions and availability zones; the greater their geographical separation, the higher the reliability.

- *Set a recovery point objective (RPO).* RPO defines the maximum tolerable data loss during an outage, guiding how frequently data needs replication. For instance, an RPO of one hour means accepting up to an hour's worth of recent data loss.

- *Implement data replication.* Align data replication with your architecture and RPO. Azure typically supports synchronous replication within availability zones. Utilize multiple zones to enhance reliability easily. For multi-region web apps in an active-passive setup, replicate data to the passive region as per the web app's RPO, ensuring replication frequency surpasses the RPO. Active-active configurations require near real-time data synchronization across regions, which might necessitate code adjustments.

- *Create a failover plan.* Develop a failover (disaster recovery) plan outlining response strategies to outages, determined by downtime or functionality loss. Specify the recovery time objectives (RTO) for maximum acceptable downtime. Ensure the failover process is quicker than RTO. Decide on automated or manual failover mechanisms for consistency and control, and detail the return to normal operations process. Test the failover plan to ensure effectiveness.

---
ms.custom: devx-track-dotnet
---
This article shows you how to apply the Reliable Web App pattern. The Reliable Web App pattern is a set of [principles and implementation techniques](../../overview.md) that define how you should modify web apps (replatform) when migrating to the cloud. It focuses on the minimal code updates you need to make to be successful in the cloud.

To facilitate the application of this guidance, there's a **[reference implementation](https://aka.ms/eap/rwa/dotnet)** of the Reliable Web App pattern that you can deploy.

[![Diagram showing the architecture of the reference implementation.](../../../_images/reliable-web-app-dotnet.svg)](../../../_images/reliable-web-app-dotnet.svg)
*Architecture of the reference implementation. Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-dotnet-1.1.vsdx) of this architecture.*

The following guidance uses the reference implementation as an example throughout. To apply the Reliable Web App pattern, follow these recommendations aligned to the pillars of the Well-Architected Framework:

## Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see the [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

The Reliable Web App pattern introduces two key design patterns at the code level to enhance reliability: the Retry pattern and the Circuit Breaker pattern.

### Use the Retry pattern

The [Retry pattern](/azure/architecture/patterns/retry) addresses temporary service disruptions, termed [transient faults](/azure/architecture/best-practices/transient-faults), which usually resolve within seconds. These faults often result from service throttling, dynamic load distribution, and network issues in cloud environments. Implementing the Retry pattern involves resending failed requests, allowing configurable delays and attempts before conceding failure.

Applications using the Retry pattern should integrate Azure's client software development kits (SDKs) and service-specific retry mechanisms for enhanced efficiency. Applications lacking this pattern should adopt it using the following guidance.

#### Try the Azure service and client SDKs first

Most Azure services and client SDKs have a [built-in retry mechanism](/azure/architecture/best-practices/retry-service-specific). You should use the built-in retry mechanism for Azure services to expedite the implementation.

*Example:* The reference implementation uses the [connection resiliency in Entity Framework Core](/ef/core/miscellaneous/connection-resiliency) to apply the Retry pattern in requests to [Azure SQL Database](/azure/architecture/best-practices/retry-service-specific#sql-database-using-entity-framework-core) (*see the following code*).

```csharp
services.AddDbContextPool<ConcertDataContext>(options => options.UseSqlServer(sqlDatabaseConnectionString,
    sqlServerOptionsAction: sqlOptions =>
    {
        sqlOptions.EnableRetryOnFailure(
        maxRetryCount: 5,
        maxRetryDelay: TimeSpan.FromSeconds(3),
        errorNumbersToAdd: null);
    }));
```

#### Use the Polly library when the client library doesn't support retries

You might need to make calls to a dependency that isn't an Azure service or doesn't support the Retry pattern natively. In that case, you should use the Polly library to implement the Retry pattern. [Polly](https://github.com/App-vNext/Polly) is a .NET resilience and transient-fault-handling library. With it, you can use fluent APIs to describe behavior in a central location of the application.

*Example:* The reference implementation uses Polly to set up the ASP.NET Core dependency injection. Polly enforces the Retry pattern every time the code constructs an object that calls the `IConcertSearchService` object. In the Polly framework, that behavior is known as a *policy*. The code extracts this policy in the `GetRetryPolicy` method, and the `GetRetryPolicy` method applies the Retry pattern every time the front-end web app calls web API concert search services  (*see the following code*).

```csharp
private void AddConcertSearchService(IServiceCollection services)
{
    var baseUri = Configuration["App:RelecloudApi:BaseUri"];
    if (string.IsNullOrWhiteSpace(baseUri))
    {
        services.AddScoped<IConcertSearchService, MockConcertSearchService>();
    }
    else
    {
        services.AddHttpClient<IConcertSearchService, RelecloudApiConcertSearchService>(httpClient =>
        {
            httpClient.BaseAddress = new Uri(baseUri);
            httpClient.DefaultRequestHeaders.Add(HeaderNames.Accept, "application/json");
            httpClient.DefaultRequestHeaders.Add(HeaderNames.UserAgent, "Relecloud.Web");
        })
        .AddPolicyHandler(GetRetryPolicy())
        .AddPolicyHandler(GetCircuitBreakerPolicy());
    }
}

private static IAsyncPolicy<HttpResponseMessage> GetRetryPolicy()
{
    var delay = Backoff.DecorrelatedJitterBackoffV2(TimeSpan.FromMilliseconds(500), retryCount: 3);
    return HttpPolicyExtensions
      .HandleTransientHttpError()
      .OrResult(msg => msg.StatusCode == System.Net.HttpStatusCode.NotFound)
      .WaitAndRetryAsync(delay);
}
```

The policy handler for the `RelecloudApiConcertSearchService` instance applies the Retry pattern on all requests to the API. It uses the `HandleTransientHttpError` logic to detect HTTP requests that it can safely retry and then to retry the request based on the configuration. It includes some randomness to smooth out potential bursts in traffic to the API if an error occurs.

### Use the Circuit Breaker pattern

Pairing the Retry and Circuit Breaker patterns expands an application's capability to handle service disruptions that aren't related to transient faults. The [Circuit Breaker pattern](/azure/architecture/patterns/circuit-breaker) prevents an application from continuously attempting to access a nonresponsive service. The Circuit Breaker pattern releases the application and avoids wasting CPU cycles so the application retains its performance integrity for end users.

*Example:* The reference implementation adds the Circuit Breaker pattern in the `GetCircuitBreakerPolicy` method (*see the following code*).

```csharp
private static IAsyncPolicy<HttpResponseMessage> GetCircuitBreakerPolicy()
{
    return HttpPolicyExtensions
        .HandleTransientHttpError()
        .OrResult(msg => msg.StatusCode == System.Net.HttpStatusCode.NotFound)
        .CircuitBreakerAsync(5, TimeSpan.FromSeconds(30));
}
```

In the code, the policy handler for the `RelecloudApiConcertSearchService` instance applies the Circuit Breaker pattern on all requests to the API. It uses the `HandleTransientHttpError` logic to detect HTTP requests that it can safely retry but limits the number of aggregate faults over a specified period of time.

## Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist). The Reliable Web App pattern uses managed identities to implement identity-centric security. Private endpoints, web application firewall, and restricted access to the web app provide a secure ingress.

### Enforce least privileges

To ensure security and efficiency, only grant users (user identities) and Azure services (workload identities) the permissions they need.

#### Assign permissions to user identities

Assess your application's needs to define a set of roles that cover all user actions without overlap. Map each user to the most appropriate role. Ensure they receive access only to what's necessary for their duties.

#### Assign permissions to workload identities

Grant only the permissions that are critical for the operations, such as CRUD actions in databases or accessing secrets. Workload identity permissions are persistent, so you can't provide just-in-time or short-term permissions to workload identities.

- *Prefer role-based access control (RBAC).* Always start with [Azure RBAC](/azure/role-based-access-control/overview) to assign permissions. It offers precise control, ensuring access is both auditable and granular. Use Azure RBAC to grant only the permissions necessary for the service to perform its intended functions.

- *Supplement with Azure service-level access controls.* If Azure RBAC doesn't cover a specific scenario, supplement with Azure-service level access policies.

### Configure user authentication and authorization

Authentication and authorization are critical aspects of web application security. *Authentication* is the process of verifying the identity of a user. *Authorization* specifies the actions a user is allowed to perform within the application. The goal is to implement authentication and authorization without weakening your security posture. To meet this goal, you need to use the features of the Azure application platform (Azure App Service) and identity provider (Microsoft Entra ID).

#### Configure user authentication

Secure your web app by enabling user authentication through your platform's features. [Azure App Service](/azure/app-service/overview-authentication-authorization) supports authentication with identity providers like Microsoft Entra ID, offloading the authentication workload from your code.

### Configure service authentication and authorization

Configure service authentication and authorization so the services in your environment have the permissions to perform necessary functions. Use [Managed Identities](/entra/identity/managed-identities-azure-resources/overview-for-developers) in Microsoft Entra ID to automate the creation and management of service identities, eliminating manual credential management. A managed identity allows your web app to securely access Azure services, like Azure Key Vault and databases. It also facilitates CI/CD pipeline integrations for deployments to Azure App Service. However, in scenarios like hybrid deployments or with legacy systems, continue using your on-premises authentication solutions to simplify migration. Transition to managed identities when your system is ready for a modern identity management approach.

#### Use DefaultAzureCredential to set up code

Use [`DefaultAzureCredential`](/dotnet/api/azure.identity.defaultazurecredential?view=azure-dotnet) to provide credentials for local development and managed identities in the cloud. `DefaultAzureCredential` generates a `TokenCredential` for OAuth token acquisition. It handles most Azure SDK scenarios and Microsoft client libraries. It detects the application's environment to use the correct identity and requests access tokens as needed. `DefaultAzureCredential` streamlines authentication for Azure-deployed applications.

*Example:* The reference implementation uses the `DefaultAzureCredential` class during start up to enable the use of managed identity between the web API and Key Vault  (*see the following code*).

```csharp
builder.Configuration.AddAzureAppConfiguration(options =>
{
     options
        .Connect(new Uri(builder.Configuration["Api:AppConfig:Uri"]), new DefaultAzureCredential())
        .ConfigureKeyVault(kv =>
        {
            // Some of the values coming from Azure App Configuration are stored Key Vault. Use
            // the managed identity of this host for the authentication.
            kv.SetCredential(new DefaultAzureCredential());
        });
});
```

#### Use infrastructure as code to create managed identities

You should use Bicep templates to create and configure the Azure infrastructure to support managed identities. Managed identities don't use secrets or passwords, so you don't need Key Vault or a secret rotation strategy to ensure integrity. You can store the connection strings in the App Configuration Service.

*Example:* The reference implementation uses Bicep templates to (1) create the managed identity, (2) associate the identity with the web app, and (3) grant the identity permission to access the SQL database. The `Authentication` argument in the connection string tells the Microsoft client library to connect with a managed identity  (*see the following code*).

```csharp
    Server=tcp:my-sql-server.database.windows.net,1433;Initial Catalog=my-sql-database;Authentication=Active Directory Default
 ```

For more information, see [Connect to SQL database from .NET App Service](/azure/app-service/tutorial-connect-msi-sql-database).

### Use a central secrets store to manage secrets

When you move your application to the cloud, use [Azure Key Vault](/azure/key-vault/secrets/about-secrets) to securely store all such secrets. This centralized repository offers secure storage, key rotation, access auditing, and monitoring for services not supporting managed identities. For application configurations, [Azure App Configuration](/azure/azure-app-configuration/overview) is recommended.

*Example:* The reference implementation stores the following secrets in Key Vault: (1) PostgreSQL database username and password, (2) Redis Cache password, and (3) the client secret for Microsoft Entra ID associated with the Microsoft Authentication Library (MSAL) implementation.

#### Don't put Key Vault in the HTTP-request flow

Load secrets from Key Vault at application startup instead of during each HTTP request. Key Vault is intended for securely storing and retrieving sensitive data during deployment. High-frequency access within HTTP requests can exceed Key Vault's throughput capabilities, leading to request limitations and HTTP status code 429 errors. For more information, see [Key Vault transaction limits](/azure/key-vault/general/service-limits#secrets-managed-storage-account-keys-and-vault-transactions).

#### Use one method to access secrets in Key Vault

When configuring a web app to access secrets in Key Vault, you have two primary options:

- *App Service App setting:* Use an app setting in App Service to inject the secret directly as an [environment variable](/azure/app-service/app-service-key-vault-references#azure-resource-manager-deployment).

- *Direct secret reference:* Directly reference the secret within your application code. Add a specific reference in your application's properties file, such as `application.properties` for Java applications, so your app to communicate with Key Vault.

It's important to choose one of these methods and stick with it for simplicity and to avoid unnecessary complexity.

#### Prefer temporary access methods

Use temporary permissions to safeguard against unauthorized access and breaches. Use [shared access signatures (SASs)](/rest/api/storageservices/delegate-access-with-shared-access-signature) for temporary access. Use User Delegation SAS to maximize security when granting temporary access. It's the only SAS that uses Microsoft Entra credentials and doesn't require a storage account key.

### Use private endpoints

Use private endpoints in all production environments for all supported Azure services. Private endpoints provide private connections between resources in an Azure virtual network and Azure services. By default, communication to most Azure services crosses the public internet. Private endpoints don't require any code changes, app configurations, or connection strings. For more information, see [How to create a private endpoint](/azure/architecture/example-scenario/private-web-app/private-web-app#deploy-this-scenario) and [Best practices for endpoint security](/azure/architecture/framework/security/design-network-endpoints).

*Example:* Azure App Configuration, Azure SQL Database, Azure Cache for Redis, Azure Storage, Azure App Service, and Key Vault use a private endpoint.

### Use web application firewall and restrict inbound internet traffic

All inbound internet traffic to the web app must pass through a web application firewall to protect against common web exploits. Force all inbound internet traffic to pass through the public load balancer, if you have one, and the web application firewall.

*Example:* The reference implementation forces all inbound internet traffic through Front Door and Azure Web Application Firewall. In production, [preserve the original HTTP host name](/azure/architecture/best-practices/host-name-preservation).

### Configure database security

Administrator-level access to the database grants permissions to perform privileged operations. Privileged operations include creating and deleting databases, modifying table schemas, or changing user permissions. Developers often need administrator-level access to maintain the database or troubleshoot issues.

- *Avoid permanent elevated permissions.* You should only grant the developers just-in-time access to perform privileged operations. With just-in-time access, users receive temporary permissions to perform privileged tasks

- *Don't give application elevated permissions.* You shouldn't grant administrator-level access to the application identity. You should configure least-privileged access for the application to the database. It limits the blast radius of bugs and security breaches.

## Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and management overhead. For more information, see the [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist). The Reliable Web App pattern implements rightsizing techniques, autoscaling, and efficient resource usage for a more cost optimized web app.

### Rightsize resources for each environment

Understand the different performance tiers of Azure services and only use the appropriate SKU for the needs of each environment. Production environments need SKUs that meet the service level agreements (SLA), features, and scale needed for production. Nonproduction environments typically don't need the same capabilities. For extra savings, consider [Azure Dev/Test pricing options](https://azure.microsoft.com/pricing/dev-test/#overview), [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations), and [Azure savings plans for compute](/azure/cost-management-billing/savings-plan/savings-plan-compute-overview).

*Example:* The reference implementation uses Bicep parameters to trigger resource deployment configurations. One of these parameters indicates the resource tiers (SKUs) to deploy. The web app uses the more performant and expensive SKUs for the production environments and the cheaper SKUs for the nonproduction environment (*see the following code*).

```bicep
var redisCacheSkuName = isProd ? 'Standard' : 'Basic'
var redisCacheFamilyName = isProd ? 'C' : 'C'
var redisCacheCapacity = isProd ? 1 : 0
```

### Use autoscale

Autoscale automates horizontal scaling for production environments. Autoscale based on performance metrics. CPU utilization performance triggers are a good starting point if you don't understand the scaling criteria of your application. You need to configure and adapt scaling triggers (CPU, RAM, network, and disk) to correspond to the behavior of your web application. Don't scale vertically to meet frequent changes in demand. It's less cost efficient. For more information, see [Scaling in Azure App Service](/azure/app-service/manage-scale-up) and [Autoscale in Microsoft Azure](/azure/azure-monitor/autoscale/autoscale-overview).

*Example:* The reference implementation uses the following configuration in the Bicep template. It creates an autoscale rule for the Azure App Service. The rule scales up to 10 instances and defaults to one instance. It uses CPU usage as the trigger for scaling in and out. The web app hosting platform scales out at 85% CPU usage and scales in at 60%. The scale-out setting of 85%, rather than a percentage closer to 100%, provides a buffer to protect against accumulated user traffic caused by sticky sessions. It also protects against high bursts of traffic by scaling early to avoid maximum CPU usage. These autoscale rules aren't universal (*see the following code*).

```csharp
resource autoScaleRule 'Microsoft.Insights/autoscalesettings@2022-10-01' = if (autoScaleSettings != null) { 
  name: '${name}-autoscale' 
  location: location 
  tags: tags 
  properties: { 
    targetResourceUri: appServicePlan.id 
    enabled: true 
    profiles: [ 
      { 
        name: 'Auto created scale condition' 
        capacity: { 
          minimum: string(zoneRedundant ? 3 : autoScaleSettings!.minCapacity) 
          maximum: string(autoScaleSettings!.maxCapacity) 
          default: string(zoneRedundant ? 3 : autoScaleSettings!.minCapacity) 
        } 
        rules: [ 
          ... 
        ] 
      } 
    ] 
  } 
}
```

### Use resources efficiently

- *Use shared services.* Centralizing and sharing certain resources provides cost optimization and lower management overhead. Place shared network resources in the hub virtual network.

    *Example:* The reference implementation places Azure Firewall, Azure Bastion, and Key Vault in the hub virtual network.

- *Delete unused environments.* Delete nonproduction environments after hours or during holidays to optimize cost. You can use infrastructure as code to delete Azure resources and entire environments. Remove the declaration of the resource that you want to delete from the Bicep template. Use the what-if operation to preview the changes before they take effect. Back up data you need later. Understand the dependencies on the resource you're deleting. If there are dependencies, you might need to update or remove those resources as well. For more information, see [Bicep deployment what-if operation](/azure/azure-resource-manager/bicep/deploy-what-if).

- *Colocate functionality.* Where there's spare capacity, colocate application resources and functionality on a single Azure resource. For example, multiple web apps can use a single server (App Service Plan) or a single cache can support multiple data types.

    *Example:* The reference implementation uses a single Azure Cache for Redis instance for session management in both front-end (storing cart and MSAL tokens) and back-end (holding Upcoming Concerts data) web apps. It opts for the smallest Redis SKU, offering more than needed capacity, efficiently utilized by employing multiple data types to control costs.

## Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see the [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist). The Reliable Web App pattern implements infrastructure as code for infrastructure deployments and monitoring for observability.

### Automate deployment

Use a CI/CD pipeline to deploy changes from source control to production. If you're using Azure DevOps, you should use Azure Pipelines. If you're using GitHub, use GitHub actions. Azure supports ARM template (JSON), Bicep, and Terraform and has templates for every Azure resource For more information, see [Bicep, Azure Resource Manager, and Terraform templates](/azure/templates/) and [Repeatable infrastructure](/azure/architecture/framework/devops/automation-infrastructure).

*Example:* The reference implementation uses Azure Dev CLI and infrastructure as code (Bicep templates) to create Azure resources, setup configuration, and deploy the required resources.  

### Configure monitoring

To monitor your web app, collect and analyze metrics and logs from your application code, infrastructure (runtime), and the platform (Azure resources). Add a diagnostic setting for every Azure resource in your architecture. Each Azure service has a different set of logs and metrics you can capture. For more information, see [Monitor the platform](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#monitoring) and [Monitor App Service](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#app-service-2).

#### Monitor baseline metrics

Use Azure Application Insights to track baseline metrics, such as request throughput, average request duration, errors, and dependency monitoring. Use `AddApplicationInsightsTelemetry` from the NuGet package `Microsoft.ApplicationInsights.AspNetCore` to enable telemetry collection. For more information, see [Enable Application Insights telemetry](/azure/azure-monitor/app/asp-net-core) and [Dependency injection in .NET](/dotnet/core/extensions/dependency-injection).

*Example:* The reference implementation uses code to configure baseline metrics in Application Insights (*see the following code*).

```csharp
public void ConfigureServices(IServiceCollection services)
{
   ...
   services.AddApplicationInsightsTelemetry(Configuration["App:Api:ApplicationInsights:ConnectionString"]);
   ...
}
```

#### Create custom telemetry as needed

Use Application Insights to gather custom telemetry to better understand your web app users. Create an instance of the `TelemetryClient` class and use the `TelemetryClient` methods to create the right metric. Turn the query into an Azure Dashboard widget.

*Example:* The reference implementation adds metrics that help the operations team identify that the web app is completing transactions successfully. It validates that the web app is online by monitoring whether customers can place orders, not by measuring the number of requests or CPU usage. The reference implementation uses `TelemetryClient` via dependency injection and the `TrackEvent` method to gather telemetry on events related to cart activity. The telemetry tracks the tickets that users add, remove, and purchase (*see the following code*).

- `AddToCart` counts how many times users add a certain ticket (`ConcertID`) to the cart.
- `RemoveFromCart` records tickets that users remove from the cart.
- `CheckoutCart` records an event every time a user buys a ticket.

`this.telemetryClient.TrackEvent` counts the tickets added to the cart. It supplies the event name (`AddToCart`) and specifies a dictionary that has the `concertId` and `count` (*see the following code*).

```csharp
this.telemetryClient.TrackEvent("AddToCart", new Dictionary<string, string> {
    { "ConcertId", concertId.ToString() },
    { "Count", count.ToString() }
});
```

For more information, see:

- [Application Insights API for custom events and metrics](/azure/azure-monitor/app/api-custom-events-metrics#trackevent)
- [TelemetryClient class](/dotnet/api/microsoft.applicationinsights.telemetryclient)
- [Telemetry client methods](/dotnet/api/microsoft.applicationinsights.telemetryclient)

#### Gather log-based metrics

Track log-based metrics to gain more visibility into essential application health and metrics. You can use [Kusto Query Language (KQL)](/azure/data-explorer/kusto/query/) queries in Application Insights to find and organize data. For more information, see [Azure Application Insights log-based metrics](/azure/azure-monitor/essentials/app-insights-metrics) and [Log-based and preaggregated metrics in Application Insights](/azure/azure-monitor/app/pre-aggregated-metrics-log-metrics).

#### Enable platform diagnostics

A diagnostic setting in Azure allows you to specify the platform logs and metrics you want to collect and where to store them. Platform logs are built-in logs that provide diagnostic and auditing information. You can enable platform diagnostics for most Azure services, but each service defines its own log categories. Different Azure services have log categories to choose.

- *Enable diagnostics for all supported services.* Azure services create platform logs automatically, but the service doesn't store them automatically. You must enable the diagnostic setting for each service, and you should enable it for every Azure service that supports diagnostics.

- *Send diagnostics to same destination as the application logs.* When you enable diagnostics, you pick the logs you want to collect and where to send them. You should send the platform logs to the same destination as the application logs so you can correlate the two datasets.

## Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see the [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist). The Reliable Web App pattern uses the Cache-Aside pattern to minimize the latency for highly requested data.

### Use the Cache-Aside pattern

The [Cache-Aside pattern](/azure/architecture/patterns/cache-aside) is a caching strategy that improves in-memory data management. The pattern assigns the application the responsibility of handling data requests and ensuring consistency between the cache and a persistent storage, such as a database. When the web app receives a data request, it first searches the cache. If the data is missing, it retrieves it from the database, responds to the request, and updates the cache accordingly. This approach shortens response times and enhances throughput and reduces the need for more scaling. It also bolsters service availability by reducing the load on the primary datastore and minimizing outage risks.

*Example:* The reference implementation enhances application efficiency by caching critical data, such as information for upcoming concerts crucial for ticket sales. It uses ASP.NET Core's distributed memory cache for in-memory item storage. The application automatically uses Azure Cache for Redis when it finds a specific connection string. It also supports local development environments without Redis to simplify setup and reduce costs and complexity. The method (`AddAzureCacheForRedis`) configures the application to use Azure Cache for Redis (*see the following code*).

```csharp
private void AddAzureCacheForRedis(IServiceCollection services)
{
    if (!string.IsNullOrWhiteSpace(Configuration["App:RedisCache:ConnectionString"]))
    {
        services.AddStackExchangeRedisCache(options =>
        {
            options.Configuration = Configuration["App:RedisCache:ConnectionString"];
        });
    }
    else
    {
        services.AddDistributedMemoryCache();
    }
}
```

For more information, see [Distributed caching in ASP.NET Core](/aspnet/core/performance/caching/distributed) and [AddDistributedMemoryCache method](/dotnet/api/microsoft.extensions.dependencyinjection.memorycacheservicecollectionextensions.adddistributedmemorycache).

#### Cache high-need data

Prioritize caching for the most frequently accessed data. Identify key data points that drive user engagement and system performance. Implement caching strategies specifically for these areas to optimize the effectiveness of the Cache-Aside pattern, significantly reducing latency and database load. Use Azure Monitor to track the CPU, memory, and storage of the database. These metrics help you determine whether you can use a smaller database SKU.

*Example:* The reference implementation caches the data that supports the Upcoming Concerts. The Upcoming Concerts page creates the most queries to SQL Database and produces a consistent output for each visit. The Cache-Aside pattern caches the data after the first request for this page to reduce the load on the database. The following code uses the `GetUpcomingConcertsAsync` method to pull data into the Redis cache from SQL Database. The method populates the cache with the latest concerts. The method filters by time, sorts the data, and returns the data to the controller to display the results (*see the following code*).

```csharp
public async Task<ICollection<Concert>> GetUpcomingConcertsAsync(int count)
{
    IList<Concert>? concerts;
    var concertsJson = await this.cache.GetStringAsync(CacheKeys.UpcomingConcerts);
    if (concertsJson != null)
    {
        // There is cached data. Deserialize the JSON data.
        concerts = JsonSerializer.Deserialize<IList<Concert>>(concertsJson);
    }
    else
    {
        // There's nothing in the cache. Retrieve data from the repository and cache it for one hour.
        concerts = await this.database.Concerts.AsNoTracking()
            .Where(c => c.StartTime > DateTimeOffset.UtcNow && c.IsVisible)
            .OrderBy(c => c.StartTime)
            .Take(count)
            .ToListAsync();
        concertsJson = JsonSerializer.Serialize(concerts);
        var cacheOptions = new DistributedCacheEntryOptions {
            AbsoluteExpirationRelativeToNow = TimeSpan.FromHours(1)
        };
        await this.cache.SetStringAsync(CacheKeys.UpcomingConcerts, concertsJson, cacheOptions);
    }
    return concerts ?? new List<Concert>();
}
```

#### Keep cache data fresh

Schedule regular cache updates to sync with the latest database changes. Determine the optimal refresh rate based on data volatility and user needs. This practice ensures the application uses the Cache-Aside pattern to provide both rapid access and current information.

*Example:* The reference implementation caches data only for one hour. It has a process for clearing the cache key when the data changes. The `CreateConcertAsync` method clears the cache key (*see the following code*).

```csharp
public async Task<CreateResult> CreateConcertAsync(Concert newConcert)
{
    database.Add(newConcert);
    await this.database.SaveChangesAsync();
    this.cache.Remove(CacheKeys.UpcomingConcerts);
    return CreateResult.SuccessResult(newConcert.Id);
}
```

#### Ensure data consistency

Implement mechanisms to update the cache immediately after any database write operation. Use event-driven updates or dedicated data management classes to ensure cache coherence. Consistently synchronizing the cache with database modifications is central to the Cache-Aside pattern.

*Example:* The reference implementation uses the `UpdateConcertAsync` method to keep the data in the cache consistent (*see the following code*).

```csharp
public async Task<UpdateResult> UpdateConcertAsync(Concert existingConcert), 
{
   database.Update(existingConcert);
   await database.SaveChangesAsync();
   this.cache.Remove(CacheKeys.UpcomingConcerts);
   return UpdateResult.SuccessResult();
}
```

### Test database performance

Database performance can affect the performance and scalability of an application. It's important to test the performance of your database to ensure it's optimized. Some key considerations include choosing the right cloud region, connection pooling, cache-aside pattern, and optimizing queries.

- *Test network hops.* Moving an application to the cloud can introduce extra network hops and latency to your database. You should test for extra hops that the new cloud environment introduces.

- *Establish a performance baseline.* You should use on-premises performance metrics as the initial baseline to compare application performance in the cloud.

## Next steps

Deploy the **[reference implementation](https://aka.ms/eap/rwa/dotnet)** by following the instructions in the GitHub repository. Use the following resources to learn more about .NET applications, web apps, cloud best practices, and migration.

### Upgrading .NET Framework applications

The reference implementation deploys to an App Service that runs Windows, but it can run on Linux. The App Service Windows platform enables you to move .NET Framework web apps to Azure without upgrading to newer framework versions. For information about Linux App Service plans or new features and performance improvements added to the latest versions of .NET, see the following guidance.

- [Overview of porting from .NET Framework to .NET](/dotnet/core/porting/). Get guidance based on your specific type of .NET app.
- [Overview of the .NET Upgrade Assistant](/dotnet/core/porting/upgrade-assistant-overview). Learn about a console tool that can help you automate many of the tasks associated with upgrading .NET Framework projects.
- [Migrating from ASP.NET to ASP.NET Core in Visual Studio](https://devblogs.microsoft.com/dotnet/introducing-project-migrations-visual-studio-extension/). Learn about a Visual Studio extension that can help you with incremental migrations of web apps.

### Introduction to web apps on Azure

For a hands-on introduction to .NET web applications on Azure, see this [guidance for deploying a basic .NET web application](https://github.com/Azure-Samples/app-templates-dotnet-azuresql-appservice).

### Cloud best practices

For Azure adoption and architectural guidance, see:

- [Cloud Adoption Framework](/azure/cloud-adoption-framework/overview). Can help your organization prepare and execute a strategy to build solutions on Azure.
- [Well-Architected Framework](/azure/architecture/framework/). A set of guiding tenets that can be used to improve the quality of a workload.

For applications that require a higher SLO than the Reliable Web App pattern, see [mission-critical workloads](/azure/architecture/framework/mission-critical/mission-critical-overview).

### Migration guidance

The following tools and resources can help you migrate on-premises resources to Azure.

- [Azure Migrate](/azure/migrate/migrate-services-overview) provides a simplified migration, modernization, and optimization service for Azure that handles assessment and migration of web apps, SQL Server, and virtual machines.
- [Azure Database Migration Guides](/data-migration/) provides resources for different database types, and different tools designed for your migration scenario.
- [Azure App Service landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator) provides guidance for hardening and scaling App Service deployments.
- [Azure Migrate application and code assessment](/azure/migrate/appcat/dotnet)


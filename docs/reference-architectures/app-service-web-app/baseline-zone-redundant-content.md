This article provides a baseline architecture for running web applications on Azure App Service in a single region. It details guidance for designing a secure, zone-redundant, and highly available web application on Azure. The architecture exposes a public endpoint via Azure Application Gateway with Web Application Firewall. It routes requests to Azure App Service through Private Link. The App Service application uses virtual network integration and Private Link to securely communicate to Azure PaaS services such as Azure Key Vault and Azure SQL Database.

## Architecture

:::image type="complex" source="images/baseline-app-service-architecture.svg" lightbox="images/baseline-app-service-architecture.svg" alt-text="Diagram that shows a baseline App Service architecture with zonal redundancy and high availability.":::
    The diagram shows a virtual network with three subnets. One subnet contains Azure Application Gateway with Azure Web Application Firewall. The second subnet contains private endpoints for Azure PaaS services, while the third subnet contains a virtual interface for Azure App Service network integration. The diagram shows App Gateway communicating to Azure App Service via private endpoint. App Service shows a zonal configuration. The diagram also shows App Service using virtual network integration and private endpoints to communicate to Azure SQL Database, Azure Key Vault and Azure Storage.
:::image-end:::
*Figure 1: Baseline Azure App Service architecture*

*Download a [Visio file](https://arch-center.azureedge.net/web-app-services.vsdx) of this architecture.*

## Components

- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/products/active-directory/) is a cloud-based identity and access management service. It provides a single identity control plane to manage permissions and roles for users accessing your web application. It integrates with App Service and simplifies authentication and authorization for web apps.
- [Application Gateway](https://azure.microsoft.com/products/application-gateway/) is a layer 7 (HTTP/S) load balancer and web traffic manager. It uses URL path-based routing to distribute incoming traffic across availability zones and offloads encryption to improve application performance.
- [Web Application Firewall (WAF)](https://azure.microsoft.com/products/web-application-firewall/) is a cloud-native service that protects web apps from common exploits such as SQL injection and cross-site scripting. WAF provides visibility into the traffic to and from your web application, enabling you to monitor and secure your application.
- [App Service](https://azure.microsoft.com/services/app-service) is a fully managed platform for building, deploying, and scaling web applications.
- [Azure Key Vault](https://azure.microsoft.com/products/key-vault/) is a service that securely stores and manages secrets, encryption keys, and certificates. It centralizes the management of sensitive information.
- [Azure Monitor](https://azure.microsoft.com/products/monitor/) is a monitoring service that collects, analyzes, and acts on telemetry data across your deployment. 
- [Azure virtual network (VNet)](https://azure.microsoft.comproducts/virtual-network/) is a service that enables you to create isolated and secure private virtual networks in Azure. For a web application on App Service, you need a VNet to use private endpoints for network-secure communication between resources.
- [Private Link](https://azure.microsoft.com/products/private-link/) makes it possible for clients to access Azure platform as a service (PaaS) services directly from private virtual networks without using public IP addressing.
- [Azure DNS](https://azure.microsoft.com/services/dns) is a hosting service for DNS domains that provides name resolution using Microsoft Azure infrastructure. Private DNS zones provide a way to map a service's fully-qualified domain name (FQDN) to the private IP address of a private endpoint.
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/product-overview) is a managed relational database service for relational data. 

## Networking

Network security is at the core of the App Services baseline architecture (*see Figure 2*). From a high level, the network architecture ensures three things:

1. A single secure entry point
2. Virtual network integration
3. Network segmentation

### Network flows

:::image type="complex" source="images/baseline-app-service-network-architecture.svg" lightbox="images/baseline-app-service-network-architecture.svg" alt-text="Diagram that shows a baseline App Service network architecture.":::
    The diagram is the same as the Baseline Azure App Service architecture with two numbered network flows. The inbound flow shows a line from the user to the Azure Application Gateway with Web Application Firewall (WAF). The second number is for WAF. The third number shows that private DNS zones are linked to the virtual network. The fourth number shows App Gateway using private endpoints to communicate to App Service. The first number in the outbound flow shows an arrow from App Service to a virtual interface. The second, again shows that private DNS zones are linked to the virtual network. The third shows arrows from the virtual interface communicating via private endpoints to Azure PaaS services.
:::image-end:::
*Figure 2: Network architecture of the baseline Azure App Service application*

The following are descriptions of the inbound flow of internet traffic to the App Service instance, and the outbound flow from the App Service to Azure services.

#### Inbound flow

1. The user issues a request to the Application Gateway public IP. 
2. The WAF Rules are evaluated. WAF rules positively affect the reliability of the system by protecting against various attacks such as cross-site scripting (XSS) and SQL injection. Azure Application Gateway returns an error to the requester if a WAF rule is violated, and processing stops. If there are no WAF rules violated, Application Gateway routes the request to the backend pool, which in this case is the App Service default domain.
3. The private DNS zone `privatelink.azurewebsites.net` is linked to the virtual network. The DNS zone has an A record that maps the App Service default domain to the private IP address of the App Service private endpoint. This linked private DNS zone allows Azure DNS to resolve the default domain to the private endpoint IP address.
4. The request is routed to an App Service instance through the private endpoint.

#### Outbound flow

1. App Service makes a request to the DNS name of the required Azure Service. The request could be to Azure Key Vault to get a secret, Azure Storage to get a publish zip file, Azure SQL Database, or any other Azure service that supports Private Link. The App Service [virtual network integration](/azure/app-service/overview-vnet-integration) feature routes the request through the virtual network.
2. Like step 3 in the inbound flow, the linked private DNS zone has an A record that maps the Azure Service domain to the private IP address of the private endpoint. Again, this linked private DNS zone allows Azure DNS to resolve the domain to the private endpoint IP address of the service.
3. The request is routed to the service through the private endpoint.

### Ingress to App Services

Application Gateway is a regional resource that meets the requirements of this baseline architecture. Application Gateway is a scalable, regional, layer 7 load balancer that supports features such as web application firewall and TLS offloading. Consider the following points when implementing Application Gateway for ingress to Azure App Services.

- Deploy Application Gateway and configure a [WAF policy](/azure/web-application-firewall/ag/policy-overview) with a Microsoft-managed ruleset. Use Prevention mode to mitigate web attacks that might cause an origin service (App Service in the architecture) to become unavailable.
- Implement [end-to-end TLS encryption](/azure/application-gateway/ssl-overview#end-to-end-tls-encryption).
- Use [private endpoints to implement inbound private access to your App Service](/azure/app-service/networking/private-endpoint).
- Consider implementing [autoscaling](/azure/application-gateway/overview-v2) for Application Gateway to remove the requirement to choose the correct instance count when provisioning. 
- Configure a minimum instance count of no less than three and use all the availability zones your region supports. While Application Gateway is deployed in a highly available fashion, [creating a new instance upon a failure can take up to 7 minutes](/azure/application-gateway/application-gateway-autoscaling-zone-redundant#autoscaling-and-high-availability). Deploying multiple instances across Availability Zones help ensure, upon a failure, an instance is running while a new instance is being created.
- Disable public network access on the App Service to ensure network isolation. In Bicep, this is accomplished by setting `publicNetworkAccess: 'Disabled'` under properties/siteConfig.

### Egress from App Services to Azure services

This architecture uses [virtual network integration](/azure/app-service/overview-vnet-integration) for the App Service. It routes traffic to private endpoints through the virtual network. The baseline architecture doesn't enable *all traffic routing* to force all outbound traffic through the virtual network, just traffic bound for private endpoints.

Azure services that don't require access from the public internet should have private endpoints enabled and public endpoints disabled. Private endpoints are used throughout this architecture to improve security by allowing your App Service to connect to Private Link services directly from your private virtual network without using public IP addressing.

In this architecture, Azure SQL Database, Azure Storage and Key Vault all have public endpoints disabled.  Azure service firewalls are used to only allow traffic from other authorized Azure services. You should configure other Azure services, such as Azure Cosmos DB and Azure Redis Cache, with private endpoints as well. In this architecture, Azure Monitor doesn't use a private endpoint, but it could.

The baseline architecture implements a private DNS zone for each service. The private DNS zone contains an A record that maps between the service fully qualified domain name and the private endpoint private IP address. The zones are linked to the virtual network. Private DNS zone groups ensure that private link DNS records are automatically created and updated.

Consider the following points when implementing virtual network integration and private endpoints.

- Use the DNS zone name of `privatelink.vaultcore.azure.net` for the Key Vault private DNS zone. Don’t use *privatelink.vault.azure.net*. In Bicep, using the environment().suffixes.keyvaultDns resolves to the latter (*privatelink.vault.azure.net*). Currently, you must hardcode the name to *privatelink.vaultcore.azure.net*.
- To ensure the storage account and key vault can only be connected to privately, set the following network ACLs on each:

  ```bash
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Deny'
    }
  ```

- To ensure you can only connect to the SQL Database privately, set the *publicNetworkAccess* to *Disabled*.

### Virtual network segmentation and security

The network in this architecture has separate subnets for the Application Gateway, App Service integration components, and private endpoints. Each subnet has a network security group that limits both inbound and outbound traffic for those subnets to just what is required. The following table shows a simplified view of the NSG rules the baseline adds to each subnet. The tables gives the rule name and function.

| Subnet   | Inbound | Outbound |
| -------  | ---- | ---- |
| snet-AppGateway    | `AppGw.In.Allow.ControlPlane`: Allow inbound control plane access<br><br>`AppGw.In.Allow443.Internet`: Allow inbound internet HTTPS access | `AppGw.Out.Allow.AppServices`: Allow outbound access to AppServicesSubnet<br><br>`AppGw.Out.Allow.PrivateEndpoints`: Allow outbound access to PrivateEndpointsSubnet<br><br>`AppPlan.Out.Allow.AzureMonitor`: Allow outbound access to Azure Monitor
| snet-PrivateEndpoints | Default rules: Allow inbound from vnet | Default rules: Allow outbound to vnet
| snet-AppService | Default rules: Allow inbound from vnet  | `AppPlan.Out.Allow.PrivateEndpoints`: Allow outbound access to PrivateEndpointsSubnet<br><br>`AppPlan.Out.Allow.AzureMonitor`: Allow outbound access to Azure Monitor |

Consider the following points when implementing virtual network segmentation and security.

- Enable [DDoS protection](https://ms.portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyDetailBlade/definitionId/%2Fproviders%2FMicrosoft.Authorization%2FpolicyDefinitions%2Fa7aca53f-2ed4-4466-a25e-0b45ade68efd) for the virtual network with a subnet that is part of an application gateway with a public IP.
- [Add an NSG](/azure/virtual-network/network-security-groups-overview) to every subnet where possible. You should use the strictest rules possible that enable web app functionality.
- Use [application security groups](/azure/virtual-network/tutorial-filter-network-traffic#create-application-security-groups). Application security groups allow you to group NSGs and make rule creation easier for complex environments.

## Reliability  

The baseline App Services architecture focuses on zonal redundancy for key regional services. Availability Zones provide zonal redundancy for [supporting services](/azure/reliability/availability-zones-service-support#azure-regions-with-availability-zone-support) when two or more instances are deployed in [supporting regions](/azure/reliability/availability-zones-service-support#azure-regions-with-availability-zone-support). When one zone experiences downtime, the other zones are unaffected.

The architecture also ensures there are enough instances of the Azure services to meet demand. The following sections provide reliability guidance for key services in the architecture.

### Application Gateway

- Deploy Azure Application Gateway v2 in a zone redundant configuration. Set the minimum capacity of the autoscale configuration to at least two to avoid the six to seven-minute startup time for an instance of Application Gateway if there is a failure.
- Implement autoscaling for Application Gateway to scale in or out to meet demand.

### App Services

- Deploy a minimum of three instances of App Services with Availability Zone support. Availability zones are physically separate locations within a region. They help you achieve reliability by providing high availability and fault tolerance.
- Implement health check endpoints in your apps and configure the App Service health check feature to reroute requests away from unhealthy instances. For more information about App Service Health check, see [Monitor App Service instances using health check](/azure/app-service/monitor-instances-health-check). For more information about implementing health check endpoints in ASP.NET applications, see [Health checks in ASP.NET Core](https://learn.microsoft.com/aspnet/core/host-and-deploy/health-checks).
- Create autoscale rules to automatically add more instances to take the load if a zone or instance fails. For more information about autoscale best practices in Azure, see [Autoscaling](/azure/architecture/best-practices/auto-scaling).
- Over provision capacity to be able to handle zone failures.

### SQL Database  

- Deploy Azure SQL DB General Purpose, Premium, or Business Critical with zone-redundancy enabled. The General Purpose, Premium, and Business Critical tiers support [Zone-redundancy in Azure SQL DB](/azure/azure-sql/database/high-availability-sla#general-purpose-service-tier-zone-redundant-availability).  
- [Configure SQL DB backups](/azure/azure-sql/database/automated-backups-overview#configure-backup-storage-redundancy-by-using-the-azure-cli) to use zone-redundant storage (ZRS) or geo-zone-redundant storage (GZRS).

### Blob storage

- Azure [Zone-Redundant Storage](/azure/storage/common/storage-redundancy#zone-redundant-storage) (ZRS) replicates your data synchronously across three availability zones in the region. Create Standard ZRS or Standard GZRS storage accounts to ensure that data is replicated across availability zones.
- Create separate storage accounts for deployments, web assets, and other data, so that you can manage and configure the accounts separately.

## Scalability

Scalability allows applications to handle increases and decreases in demand while optimizing performance and cost. The following sections discuss scalability for key components in this architecture.

### Application Gateway

- Implement autoscaling for Application Gateway to scale in or out to meet demand.
- Set the maximum instance count to a number higher than your expected need. You'll only be charged for the Capacity Units you use.
- Set a minimum instance count that can handle small spikes in traffic. Autoscaling takes six to seven minutes to scale out and provision instances ready to take traffic. You can use [average Compute Unit usage](/azure/application-gateway/high-traffic-support#set-your-minimum-instance-count-based-on-your-average-compute-unit-usage) to calculate your minimum instance count.
- Ensure your Application Gateway subnet has enough available IP addresses to meet your scaling needs. If your scaling needs exceed your subnet size, you'll have to redeploy your Application Gateway in a new, larger subnet.

### App Service

- Use Standard or higher plans with two or more worker instances for high availability.
- Enable [Autoscale](/azure/azure-monitor/autoscale/autoscale-get-started) to make sure you can scale up and down to meet demand.
- Consider [opening a support ticket to increase the maximum number of workers to two times the instance count](/azure/well-architected/services/compute/azure-app-service/reliability#configuration-recommendations) if your App Service consistently uses half the number of maximum instances. The maximum number of instances defaults to up to 30 for a Premium App Service plan and 10 for a Standard plan.
- Consider deploying multiple stamps of the application when your App Service starts hitting the upper limits.
- Choose the right [Azure App Service plan]( /azure/app-service/overview-hosting-plans#manage-an-app-service-plan) that meets your workload requirements.
- [Add Azure CDN to Azure App Service](/azure/cdn/cdn-add-to-web-app) to serve static content.

### SQL Server

Scaling database resources is a complex topic outside of the scope of this architecture. Consider the following resources when scaling your database,

- [Dynamically scale database resources with minimal downtime]( /azure/azure-sql/database/scale-resources)
- [Scaling out with Azure SQL Database]( /azure/azure-sql/database/elastic-scale-introduction)
- [Use read-only replicas to offload read-only query workloads]( /azure/azure-sql/database/read-scale-out)
- Consider [App Service Environment]( /azure/app-service/environment/overview) if noisy neighbors are a concern.

### Other scalability guidance

- Review [subscription limits and quotas](/azure/azure-resource-manager/management/azure-subscription-service) to ensure that services scale to demand.
- Consider [caching](/azure/architecture/best-practices/caching) for the following kinds of data to increase performance and scalability:
  - Semi-static transaction data.
  - Session state.
  - HTML output. This can be useful in applications that render complex HTML output.
- Cache static content in [Azure Content Delivery Network](https://azure.microsoft.com/products/cdn/).

## Security

The baseline App Service architecture focuses on essential security recommendations for your web app. Understanding how encryption and identity work at every layer is critical to securing your workload.

### Encryption

A production web app needs to encrypt data in transit using HTTPS. HTTPS protocol relies on Transport Layer Security (TLS) and uses public and private keys for encryption. You need to store a certificate (X.509) in Key Vault and give Application Gateway permission to retrieve the private key. For data at rest, some services automatically encrypt data and others allow you to customize.

#### Data in transit

In the baseline architecture, data in transit is encrypted from the user to the web app in App Service. The following workflow describes how the encryption works at a high level.

:::image type="complex" source="images/baseline-app-service-encryption-flow.svg" lightbox="images/baseline-app-service-encryption-flow.svg" alt-text="Diagram that shows a baseline App Service encryption flow.":::
    The diagram adds numbers to the Baseline Azure App Service architecture to indicate the encryption flow. Number one is the user. Number two is Application Gateway with WAF. Number three is Azure Key Vault, storing the X.509 certificate. Number four represents the encrypted traffic sent from the application gateway to App Service.
:::image-end:::

1. The user sends an HTTPS request to the web app.
1. The HTTPS request reaches the the application gateway.
1. The application gateway uses a certificate (X.509) in Key Vault to create a secure TLS connection with the user's web browser. The application gateway decrypts the HTTPS request so the web application firewall can inspect it.
1. The application gateway creates a TLS connection with App Service to re-encrypt the user request. App Service provides native support for HTTPS, so you don’t need to add a certificate to App Service. The application gateway sends the encrypted traffic to App Service. App Service decrypts the traffic, and the web app processes the request.

Consider the following recommendations when configuring encryption of data in transit.

- Create or upload your certificate to Key Vault. HTTPS encryption requires a certificate (X.509). You need a certificate from a trusted certificate authority for your custom domain.
- Store the private key to the certificate in Key Vault.
- Follow the guidance in [Grant permission to applications to access an Azure key vault using Azure RBAC](/azure/key-vault/general/rbac-guide) and [Managed identities for Azure resources](/azure/active-directory/managed-identities-azure-resources/overview) to provide Application Gateway access to the certificate private key. Don’t use Key Vault policies to provide access. Key Vault policies only let you to grant permissions to an entire key vault, not just a specific secret.
- [Enable end to end encryption](/azure/application-gateway/ssl-overview#end-to-end-tls-encryption). App Service is the backend pool for the application gateway. When you configure the backend setting for the backend pool, use the HTTPS protocol over the backend port 443.

#### Data at rest

- Encrypt sensitive data in Azure SQL Database using [transparent data encryption](/azure/azure-sql/database/transparent-data-encryption-tde-overview#manage-transparent-data-encryption). Transparent data encrypts the entire database, backups, and transaction log files and requires no changes to your web application.
- Minimize database encryption latency. To minimize encryption latency, place the data you need to secure in its own database and only enable encryption for that database.
- [Azure Storage automatically encrypts](/azure/storage/common/storage-service-encryption) data at rest using server-side encryption (256-bit AES).
- Azure Monitor automatically encrypts data at rest using Microsoft-managed key (MMKs).

### Identity

The App Service baseline configures authentication and authorization for user identities (users) and workload identities (Azure resources) and implements the principle of least privilege.

#### User identities

- Use the [integrated authentication mechanism for App Service (“EasyAuth”)](/azure/app-service/overview-authentication-authorization). EasyAuth simplifies the process of integrating identity providers into your web app. It handles authentication outside your web app, so you don’t have to make any code changes.
- Configure the reply URL for the custom domain. You need to redirect the web app to `https://<application-gateway-endpoint>/.auth/login/<provider>/callback`. Replace `<application-gateway-endpoint>` with either the public IP address or the custom domain name associated with your application gateway. Replace `<provider>` with the authentication provider you're using such as "aad" for Azure Active Directory. You can use [the Azure Front documentation](/azure/app-service/overview-authentication-authorization#considerations-when-using-azure-front-door) to set up this flow with Application Gateway or [Setting up Application Gateway](https://techcommunity.microsoft.com/t5/apps-on-azure-blog/setting-up-application-gateway-with-an-app-service-that-uses/ba-p/392490).

#### Workload identities

- Use managed identity for workload identities. Managed identity eliminates the need for developers to manage authentication credentials.
- Use user-assigned managed identities. A system-assigned identity can cause infrastructure-as-code deployments to fail. You should use user-assigned managed identities to avoid deployment errors. For more information, see [Managed identities](/azure/active-directory/managed-identities-azure-resources/managed-identity-best-practice-recommendations).

## Deployment

Deployment for the baseline App Service application follows the guidance in [CI/CD for Azure Web Apps with Azure Pipelines](/azure/architecture/solution-ideas/articles/azure-devops-continuous-integration-and-continuous-deployment-for-azure-web-apps). In addition to that guidance, the App Services baseline architecture takes into account that the application and deployment storage account are network secured. The architecture denies public access to App Service. This means you can't deploy from outside the virtual network. The baseline shows you how to deploy the application code within the virtual network using self-hosted deployment agents. The following deployment guidance focuses on deploying the application code and not deploying infrastructure or database changes. 

:::image type="complex" source="images/baseline-app-service-deployments.svg" lightbox="images/baseline-app-service-deployments.svg" alt-text="Diagram that shows a baseline App Service deployment architecture.":::
    The diagram shows a subnet containing self-hosted deployment agents. It also adds an Azure Pipelines with managed agents. The last change is numbered for the deployment flow. Number one is on Azure Pipelines. Number two is an arrow from the self-hosted agents to Azure Pipelines. Three is an arrow from the self-hosted agent to the private endpoint for Azure Storage. Four is again above Azure Pipelines and the managed agents. Five is in App Services. Six is again over Azure Pipelines and the managed agents.
:::image-end:::
*Figure 3: Deploying Azure App Service applications*

### Deployment flow

1. As part of the release pipeline, the pipeline posts a job request for the self-hosted agents in the job queue. The job request is for the agent to upload the *publish zip file* build artifact to an Azure Storage Account.
2. The self-hosted deployment agent picks up the new job request through polling. It downloads the job and the build artifact.
3. The self-hosted deployment agent uploads the zip file to the storage account through the storage account private endpoint.
4. The pipeline continues, and a managed agent picks up a subsequent job. The managed agent [makes a CLI call to update the appSetting](https://learn.microsoft.com/cli/azure/webapp/config/appsettings) WEBSITE_RUN_FROM_PACKAGE to the name of the new publish zip file for the staging slot.

  ```bash
  az webapp config appsettings set -g MyResourceGroupName -n MyUniqueApp --slot staging --settings WEBSITE_RUN_FROM_PACKAGE=UriToNewZip
  ```

5. Azure App Service pulls the new publish zip file from storage via the storage account private endpoint. The staging instance restarts with the new package because WEBSITE_RUN_FROM_PACKAGE was set to a different file name.
6. The pipeline resumes and runs any smoke tests or waits for approval. If the tests pass or the approval is given, the pipeline swaps the staging and production slots.

### Deployment guidance

The following highlights key deployment guidance for the baseline architecture.

- Use [run from package](/azure/app-service/deploy-run-package) to avoid deployment conflicts. When you run your app directly from a package in Azure App Service, the files in the package aren't copied to the wwwroot directory. Instead, the ZIP package itself gets mounted directly as the read-only wwwroot directory. This eliminates file lock conflicts between deployment and runtime and ensures only fully deployed apps are running at any time
- Include version numbers in the deployed package zip files. Updating the `WEBSITE_RUN_FROM_PACKAGE` appSetting to the deployment package with a different file name causes App Services to automatically pick up the new version and restart the service.
- Use Deployment slots for resilient code deployments.
- Consider using a blend of managed and self-hosted agents.
  - Use [Self-hosted agents](/azure/devops/pipelines/agents/agents#install) to upload the package zip file to the storage account over the private endpoint. The [agent initiates communication to the pipeline through polling](/azure/devops/pipelines/agents/agents#communication) so it isn't required to open up the network for an inbound call.
  - Use managed agents for the other jobs in the pipeline.
- Automate infrastructure deployments with [Infrastructure as Code (IaC)](https://learn.microsoft.com/devops/deliver/what-is-infrastructure-as-code).
- Continuously validate the workload to test the performance and resilience of the entire solution using services such as [Azure Load Testing](https://azure.microsoft.com/products/load-testing/) and [Azure Chaos Studio](https://azure.microsoft.com/products/chaos-studio/).

## Configuration

Applications require both configuration values and secrets. Use the following guidance for configuration and secrets management.

- Never check secrets such as passwords or access keys into source control.
- Use [Azure Key Vault](/azure/key-vault/general/overview) to store secrets.
- Use [App Service configuration](/azure/app-service/configure-common) for your application configuration. If you need to externalize the configuration from your application config or require [feature flag support](/azure/azure-app-configuration/concept-feature-management), consider using [Azure App Configuration](/azure/azure-app-configuration/overview).
- [Use Key Vault references](/app-service/app-service-key-vault-references) in App Service configuration to securely expose secrets in your application.
- Create app settings that stick to a slot and don't get swapped if you need different production and staging settings. When you swap a deployment slot, the app settings are swapped by default.
- Set local environment variables for local development or take advantage of application platform features. App Services configuration exposes app settings as environment variables. Visual Studio, for example, lets you set environment variables in launch profiles. It also allows you to use App Settings and user secrets to store local application settings and secrets.

## Monitoring

Monitoring is the collection and analysis of data from IT systems. The goal of monitoring is observability at multiple layers to track web app health and security. Observability is a key facet of the baseline App Service architecture.

To monitor your web app, you need to collect and analyze metrics and logs from your application code, infrastructure (runtime), and the platform (Azure resources). For more information, see [Azure activity log](/azure/azure-monitor/essentials/activity-log?tabs=powershell), [Azure resource logs](/azure/azure-monitor/essentials/resource-logs), and Application logs.

### Monitor the platform

Platform monitoring is the collection of data from the Azure services in your architecture. Consider the following guidance regarding platform monitoring.

- Add a diagnostic setting for every Azure resource. Each Azure service has a different set of logs and metrics you can capture. Use the following table to figure out the metrics and logs you want to collect.

  |Azure resource | Metrics and logs descriptions |
  | --- | --- |
  |Application Gateway | [Application Gateway metrics and logs descriptions](/azure/application-gateway/monitor-application-gateway-reference) |
  |Web Application Firewall | [Web application firewall metrics and logs descriptions](/azure/web-application-firewall/ag/application-gateway-waf-metrics) |
  |App Service | [App Service metrics and logs descriptions](/azure/app-service/monitor-app-service-reference) |
  |Azure SQL Database | [Azure SQL Database metrics and logs description](/azure/azure-sql/database/monitoring-sql-database-azure-monitor-reference?view=azuresql) |
  |CosmosDB | [Azure Cosmos DB metrics and logs descriptions](/azure/cosmos-db/monitor-reference)
| Key Vault | [Key Vault metrics and logs descriptions](/azure/key-vault/general/monitor-key-vault-reference) |
  |Blob Storage | [Azure Blob Storage metrics and logs descriptions](/azure/storage/blobs/monitor-blob-storage-reference) |
  | Application Insights | [Application Insights metrics and logs descriptions](/azure/azure-monitor/app/api-custom-events-metrics) |
  | Public IP address | [Public IP address metrics and logs descriptions](/azure/virtual-network/ip-services/monitor-public-ip) |

- Understand the cost of collecting metrics and logs. In general, the more metrics and logs you collect, the more it costs. For more information, see [Log Analytics cost calculations and options](/azure/azure-monitor/logs/cost-logs) and [Pricing for Log Analytics workspace](https://azure.microsoft.com/pricing/details/monitor/).
- Create alerts. You should create alerts for all the Azure resources in the architecture and configure Actions to remediate issues. Pick common and recommended alert rules to start with and modify over time as needed. For more information, see:

  - [Overview of Azure Monitor alerts](/azure/azure-monitor/alerts/alerts-overview)
  - [Application Gateway alerts](/azure/application-gateway/high-traffic-support#alerts-for-application-gateway-v2-sku-standard_v2waf_v2)
  - [App Service alerts](/azure/app-service/monitor-app-service#alerts)
  - [Azure SQL Database alerts](/azure/app-service/monitor-app-service#alerts)
  - [Blob storage alerts](/azure/storage/blobs/monitor-blob-storage?tabs=azure-portal#alerts)
  - [Key vault alerts](/azure/key-vault/general/monitor-key-vault#alerts)

#### Application Gateway

Application Gateway automatically monitors the health of resources in its backend pool. Use the Application Gateway Access logs to information like the timestamp, the HTTP response code, and the URL path. For more information, see [Application Gateway default health probe](/azure/application-gateway/application-gateway-probe-overview#default-health-probe) and [Backend health and diagnostic logs](/azure/application-gateway/application-gateway-diagnostics#diagnostic-logging).

#### App Service

App Service has built-in and integrated monitoring tools that you should enable for improved observability. If your web app already has telemetry and monitoring features (“in-process instrumentation”), it should continue to work on App Service.

- [Enable auto-instrumentation.](/azure/azure-monitor/app/codeless-overview) App Service has an instrumentation extension that you can enable with no code changes. You gain application performance monitoring (APM) visibility. For more information, see [Monitor Azure App Service performance](/azure/azure-monitor/app/azure-web-apps).
- [Enable distributed tracing.](/azure/azure-monitor/app/distributed-tracing-telemetry-correlation) Auto-instrumentation offers a way to monitor distributed cloud systems via distributed tracing and a performance profiler.
- Use code-based instrumentation for custom telemetry. ­Azure Application Insights also supports code-based instrumentation for custom application telemetry. Add the Application Insights SDK to your code and use the Application Insights API.
- [Enable App Service logs](/azure/app-service/troubleshoot-diagnostic-logs). The App Service platform supports four additional logs that you should enable to support troubleshooting. These logs are application logs, web server logs, detailed error messages, and failed request tracing.
- Use structured logging. Add a structured logging library to your application code. Update your code to use key-values pairs and enable Application logs in App Service to store these logs in your Log Analytics Workspace.
- [Turn on the App Service Health check.](/azure/app-service/monitor-instances-health-check) Health check reroutes requests away from unhealthy instances and replaces the unhealthy instances. Your App Service plan needs to use two or more instances for Health checks to work.

## Database

- User database Insights. For Azure SQL databases, you should configure [SQL Insights in Azure Monitor](/azure/azure-sql/database/sql-insights-overview). Database Insights uses dynamic management views to expose the data that you need to monitor health, diagnose problems, and tune performance. For more information, see [Monitoring Azure SQL Database with Azure Monitor.](/azure/azure-sql/database/monitoring-sql-database-azure-monitor?view=azuresql)
- If your architecture includes CosmosDB, you don't need to enable or configure anything to use [Cosmos DB insights](/azure/cosmos-db/insights-overview).

## Governance

Web apps benefit from Azure Policy by enforcing architectural and security decisions. Azure Policy can make it (1) impossible to deploy (deny) or (2) easy to detect (audit) configuration drift from your preferred desired state. This helps you catch IaC deployments or Azure portal changes that deviate from agreed upon architecture.
You should place all resources in your architecture under Azure Policy governance. Use built-in policies or policy initiatives where possible to enforce key network topology, service feature, security, and monitoring decisions, for example:

- App Service should disable public network access
- App service should use virtual network integration
- App Service should use private link
- App Service should have local authentication methods disabled for FTP & SCM site deployments
- App Service should have remote debugging turned off
- App Service apps should use the latest TLS version
- Microsoft Defender for App Service should be enabled
- Web Application Firewall (WAF) should be enabled for Application Gateway

See more built-in policies for key services such as [Application Gateway and networking components](/azure/governance/policy/samples/built-in-policies#network), [App Service](/azure/governance/policy/samples/built-in-policies#app-service), [Key Vault](/azure/governance/policy/samples/built-in-policies#key-vault), and [Monitoring](/azure/governance/policy/samples/built-in-policies#monitoring). It's possible to create custom policies or use community policies (such as from Azure Landing Zones) if built-in policies do not fully cover your needs. Prefer built-in policies when they are available.

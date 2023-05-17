This architecture provides guidance for designing a network-secure, zone-redundant, and highly available web application on Azure. The architecture exposes a public endpoint via Azure Application Gateway with Web Application Framework and routes requests to Azure App Service through Private Link. The App Service application uses virtual network integration and Private Link to securely communicate to Azure PaaS services such as Azure Key Vault and Azure SQL Database.

## Architecture

:::image type="complex" source="images/baseline-app-service-architecture.svg" lightbox="images/baseline-app-service-architecture.svg" alt-text="Diagram that shows a baseline App Service architecture with zonal redundancy and high availability.":::
    The diagram shows a virtual network with three subnets. One subnet contains Azure Application Gateway with Azure Web Application Firewall. The second subnet contains private endpoints for Azure PaaS services, while the third subnet contains a virtual interface for Azure App Service network integration. The diagram shows App Gateway communicating to Azure App Service via private endpoint. App Service shows a zonal configuration. The diagram also shows App Service using virtual network integration and private endpoints to communicate to Azure SQL Database, Azure Key Vault and Azure Storage.
:::image-end:::
*Figure 1: Baseline Azure App Service architecture*

*Download a [Visio file](https://arch-center.azureedge.net/web-app-services.vsdx) of this architecture.*

## Components

- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/products/active-directory/): Azure AD is a cloud-based identity and access management service. It provides a single identity control plane to manage permissions and roles for users accessing your web application. Azure AD supports single sign-on, multi-factor authentication, and social identity providers for user authentication. It integrates with "Easy Auth" in App Service, a feature that simplifies authentication and authorization for web apps. With Easy Auth, users attempting to access your application are redirected to Azure AD for authentication. Azure AD validates the user's credentials and returns a token to the application, which is then used to authenticate and authorize the user.
- [Application Gateway](https://azure.microsoft.com/products/application-gateway/): Application Gateway is a layer 7 (HTTP/S) load balancer and web traffic manager. It uses URL path-based routing to distribute incoming traffic across availability zones and offloads encryption to improve application performance. It provides additional security features such as SSL termination and an integrated web application firewall.
- [Web Application Firewall (WAF)](https://azure.microsoft.com/products/web-application-firewall/): WAF is a cloud-native service that protects web apps from common web-hacking techniques such as SQL injection and cross-site scripting. WAF provides visibility into the traffic to and from your web application, enabling you to monitor and secure your application.
- [App Service](https://azure.microsoft.com/services/app-service): App Service is a fully managed platform for building, deploying, and scaling web applications. It supports various programming languages and frameworks and simplifies the deployment process, allowing developers to focus on code. Every web app (App Service) needs an App Service plan. An app service plan is a container for your web app that defines the compute resources that your app can use, such as CPU, memory, and storage. The App Service plan also determines the geographic location of the servers that host your app. You can have multiple web apps (App Services) running under a single app service plan, and you can scale the number of instances up or down as needed to meet the demand for your app. Each web app has its own URL and scales independently of other web apps on the same plan.
- [Key Vault](https://azure.microsoft.com/products/key-vault/): Azure Key Vault is a service that securely stores and manages secrets, encryption keys, and certificates. Its importance in a web application is to centralize the management of sensitive information, reducing the risk of unauthorized access and maintaining compliance.
- [Azure Monitor](https://azure.microsoft.com/products/monitor/): Azure Monitor is a monitoring service that collects, analyzes, and acts on telemetry data from various Azure resources. It enables you to gain insights into the performance and health of your web application and diagnose issues, helping to ensure optimal performance and availability. Web apps should enable Application Insights and a Log Analytics workspace, two features of Azure Monitor, to gather web app metrics, telemetry, and logs.
- [Virtual network](https://azure.microsoft.comproducts/virtual-network/): Azure Virtual Network (VNet) is a service that enables you to create isolated and secure private networks in Azure. For a web application on App Service, you need a VNet to use private endpoints for more secure communication between resources.
- [Private Link](https://azure.microsoft.com/products/private-link/): Private Link enables you to create private endpoints that provide private IP access to Azure services within a virtual network. Private endpoints enhance the security of web applications by ensuring data does not traverse the public internet.
- [Azure DNS](https://azure.microsoft.com/services/dns): Azure DNS is a hosting service for DNS domains that provides name resolution using Microsoft Azure infrastructure. You can create private DNS zones for custom domain name resolution within your virtual networks. A web app with private endpoints should use private DNS zone to make network configuration easier to manage. You can create custom DNS names that map to the private IP address of the private endpoint. You can then use easy-to-remember domain names to access your Azure services over the private endpoint, rather than the private IP address directly.
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/product-overview): Azure SQL is a managed relational database service. In a web application, it stores and manages structured data, offering scalability, high availability, and data security.

## Networking

Network security is at the core of the App Services baseline architecture. From a high level, the network architecture ensures three things:

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
3. Because a private DNS zone, `privatelink.azurewebsites.net`, is linked to the virtual network. The DNS zone has an A record that maps the App Service default domain to the private IP address of the App Service private endpoint. This linked private DNS zone allows Azure DNS to resolve the default domain to the private endpoint IP address.
4. The request is routed to an App Service instance through the private endpoint.

#### Outbound flow

1. App Service makes a request to the DNS name of the required Azure Service. These requests could be a call to Azure Key Vault to get a secret, to Azure Storage to get a publish zip file, to an Azure SQL Database, or any number of other Private Link enabled Azure Services. Because [virtual network integration](/azure/app-service/overview-vnet-integration) is configured for App Services, the request is routed through the virtual network.
2. Like step 3 in the inbound flow, the linked private DNS zone has an A record that maps the Azure Service domain to the private IP address of the private endpoint. Again, this linked private DNS zone allows Azure DNS to resolve the domain to the private endpoint IP address of the service.
3. The request is routed to the service through the private endpoint.

### Ingress to App Services

Application Gateway is a regional resource that meets the requirements of this baseline architecture. Application Gateway is a scalable, regional, layer 7 load balancer that supports features such as web application firewall and TLS offloading. Consider the following points when implementing Application Gateway for ingress to Azure App Services.

- Deploy Application Gateway and configure a [WAF policy](/azure/web-application-firewall/ag/policy-overview) with a Microsoft-managed ruleset. Use Prevention mode to mitigate web attacks that might cause an origin service (App Service in the architecture) to become unavailable.
- Implement [end-to-end TLS encryption](/azure/application-gateway/ssl-overview#end-to-end-tls-encryption).
- Use [private endpoints to implement inbound private access to your App Service](/azure/app-service/networking/private-endpoint).
- Consider implementing [autoscaling](/azure/application-gateway/overview-v2) for Application Gateway to remove the requirement to choose the correct instance count when provisioning. 
- Configure a minimum instance count of no less than and use all the availability zones your region supports. While Application Gateway is deployed in a highly available fashion, [creating a new instance upon a failure can take up to 7 minutes](/azure/application-gateway/application-gateway-autoscaling-zone-redundant#autoscaling-and-high-availability). Deploying multiple instances across Availability Zones help ensure, upon a failure, an instance is running while a new instance is being created.
- Ensure that public network access is disabled on the App Service to ensure network isolation. In Bicep, this is accomplished by setting `publicNetworkAccess: 'Disabled'` under properties/siteConfig.

### Egress from App Services to Azure services

This architecture uses [virtual network integration](/azure/app-service/overview-vnet-integration) for the App Service. It routes traffic to private endpoints through the virtual network. The baseline architecture doesn't enable *all traffic routing* to force all outbound traffic through the virtual network, just traffic bound for private endpoints.

Azure services that don't require access from the public internet should have private endpoints enabled and public endpoints disabled. Private endpoints are used throughout this architecture to improve security by allowing your App Service to connect to Private Link services directly from your private virtual network without using public IP addressing.

In this architecture, Azure SQL Database, Azure Storage and Key Vault all have public endpoints disabled.  
Azure service firewalls are used to only allow traffic from other authorized Azure services. Other Azure services such as Azure Cosmos DB and Azure Redis Cache should be configured with private endpoints, as well. Azure Monitor isn't configured to use private endpoints in this architecture but could be.

The baseline architecture implements a pPrivate DNS zone is created for each service and that contains an A record that maps between the service fully qualified domain name and the private endpoint private IP address. The zones are linked to the virtual network. Private DNS zone groups ensure that private link DNS records are automatically created and updated.

Consider the following points when implementing virtual network integration and private endpoint connectivity.

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

The network in this architecture is divided into subnets for the Application Gateway, App Service integration components and private endpoints. Each subnet has a network security group that limits both inbound and outbound traffic for those subnets to just what is required.  

Consider the following points when implementing virtual network segmentation and security.

- Enable [DDoS protection](https://ms.portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyDetailBlade/definitionId/%2Fproviders%2FMicrosoft.Authorization%2FpolicyDefinitions%2Fa7aca53f-2ed4-4466-a25e-0b45ade68efd) for the virtual network with a subnet that is part of an application gateway with a public IP.
- Add a network security group to every subnet. You should use the strictest rules possible to enable web app functionality. The web app baseline adds network security groups (NSGs) to all three subnets in the virtual network. For more information, see [Network security groups overview](/azure/virtual-network/network-security-groups-overview).
- Use application security groups. Application security groups allow you to group network security groups. They make rule creation easier for complex environments. You can create NSG rules that have application security groups as the source or destination of the rule. The rule applies to every NSG in the application security group, so you don’t have to create the same rule for every subnet. For more information, see [Create application security groups](/azure/virtual-network/tutorial-filter-network-traffic#create-application-security-groups).

## Reliability  

The baseline App Services architecture focuses on zonal redundancy for key regional services. Availability Zones provide zonal redundancy for [supporting services](/azure/reliability/availability-zones-service-support#azure-regions-with-availability-zone-support) when two or more instances are deployed in [supporting regions](/azure/reliability/availability-zones-service-support#azure-regions-with-availability-zone-support). When one zone experiences downtime with power, cooling or networking, the other zones are unaffected.

Ensuring there are enough instances of services to meet demand is also addressed in this architecture. The following sections provide reliability guidance for key services in the architecture.

### Application Gateway

- Deploy Azure Application Gateway v2 in a zone redundant configuration. Set the minimum capacity to at least 2 to avoid the six to seven-minute startup time for an instance of Application Gateway if there is a failure.
- Implement autoscaling for Application Gateway to scale in or out to meet demand.

### App Services

- Deploy a minimum of three instances of App Services with Availability Zone support. Availability zones are physically separate locations within a region. They help you achieve reliability by providing high availability and fault tolerance.
- Implement health check endpoints in your apps and configure the App Service health check feature to reroute requests away from unhealthy instances. For more information about App Service Health check, see [Monitor App Service instances using health check](/azure/app-service/monitor-instances-health-check). For more information about implementing health check endpoints in ASP.NET applications, see [Health checks in ASP.NET Core](https://learn.microsoft.com/aspnet/core/host-and-deploy/health-checks).
- Create autoscale rules to automatically add more instances to take the load if a zone or instance fails. For more information about autoscale best practices in Azure, see [Autoscaling](/azure/architecture/best-practices/auto-scaling).
- Over provision capacity to be able to handle zone failures.

### SQL Database  

- Deploy Azure SQL DB General Purpose, Premium, or Business Critical with zone-redundancy enabled. [Zone-redundancy in Azure SQL DB](/azure/azure-sql/database/high-availability-sla#general-purpose-service-tier-zone-redundant-availability) is supported in General Purpose, Premium, and Business Critical tiers.  
- [Configure SQL DB backups](/azure/azure-sql/database/automated-backups-overview#configure-backup-storage-redundancy-by-using-the-azure-cli) to use zone-redundant storage (ZRS) or geo-zone-redundant storage (GZRS).

### Blob storage

- Azure [Zone-Redundant Storage](/azure/storage/common/storage-redundancy#zone-redundant-storage) (ZRS) replicates your data synchronously across three availability zones in the region. Create Standard ZRS or Standard GZRS storage accounts to ensure that data is replicated across availability zones.
- Create separate storage accounts for deployments, web assets, and other data, so that the accounts can be managed and configured separately.

## Scalability

Scalability allows applications to handle increases and decreases in demand while optimizing performance and cost. The following sections discuss scalability for key components in this architecture.

### Application Gateway

- Implement autoscaling for Application Gateway to scale in or out to meet demand.
- Set the maximum instance count to a number higher than your expected need. You'll only be charged for the Capacity Units you use.
- Ensure you set a minimum instance count that can handle small spikes in traffic. Autoscaling takes six to seven minutes to scale out and provision instances ready to take traffic. You can use [average Compute Unit usage](/azure/application-gateway/high-traffic-support#set-your-minimum-instance-count-based-on-your-average-compute-unit-usage) to calculate your minimum instance count.
- Ensure your Application Gateway subnet has enough available IP addresses to meet your scaling needs. If your scaling needs exceed your subnet size, you'll have to redeploy your Application Gateway in a new, larger subnet.

### App Service

- Use Standard or higher plans with two or more worker instances for high availability.
- Enable [Autoscale](/azure/azure-monitor/autoscale/autoscale-get-started) to make sure you can scale up and down to meet demand.
- If your App Service consistently uses half the number of maximum instances, consider [opening a support ticket to increase the maximum number of workers to two times the instance count](/azure/well-architected/services/compute/azure-app-service/reliability#configuration-recommendations). The maximum number of instances defaults to up to 30 for a Premium App Service plan and 10 for a Standard plan.
- Once your App Service starts hitting the upper limits, consider deploying multiple stamps of the application.
- Choose the right [Azure App Service plan]( /azure/app-service/overview-hosting-plans#manage-an-app-service-plan) that meets your workload requirements.
- [Add Azure CDN to Azure App Service](/azure/cdn/cdn-add-to-web-app) to serve static content.

### SQL Server

Scaling database resources is a complex topic outside of the scope of this architecture. Consider the following resources when scaling your database,

- [Dynamically scale database resources with minimal downtime]( /azure/azure-sql/database/scale-resources)
- [Scaling out with Azure SQL Database]( /azure/azure-sql/database/elastic-scale-introduction)
- [Use read-only replicas to offload read-only query workloads]( /azure/azure-sql/database/read-scale-out)
- Consider [App Service Environment]( /azure/app-service/environment/overview) if noisy neighbors are a concern.

## Security

The baseline App Service architecture focuses on essential security recommendations for your web app. Understanding how encryption and identity work at every layer is critical to securing your workload.

### Encryption

A production web app needs to encrypt data in transit using HTTPS. HTTPS protocol relies on Transport Layer Security (TLS) and uses public and private keys for encryption. You need to store a certificate (X.509) in Key Vault and give Application Gateway permission to retrieve the private key. For data at rest, some services automatically encrypt data and others allow you to customize.

#### Workflow

:::image type="complex" source="images/baseline-app-service-encryption-flow.png" lightbox="images/baseline-app-service-encryption-flow.png" alt-text="Diagram that shows a baseline App Service encryption flow.":::
    The diagram adds numbers to the Baseline Azure App Service architecture to indicate the encryption flow. Number one is the user. Number two is Application Gateway with WAF. Number three is Azure Key Vault. Number four is again Application Gateway with WAF. Number 5 is the arrow to App Service. There are three number sixes. They are on Azure SQL Database, Azure Storage and Azure Monitor.
:::image-end:::

1. The user sends an HTTPS request to the web app.
1. The HTTPS request reaches the the application gateway.
1. The application gateway uses a certificate (X.509) in Key Vault to create a secure TLS connection with the user's web browser.
1. The web application firewall inspects incoming traffic. The rules either allow or deny the inbound traffic.
1. The application gateway re-encrypts inbound traffic and sends the encrypted traffic to the web app. The application gateway creates an HTTPS connection with App Service. App Service provides native support for HTTPS, so you don’t need to add a certificate to App Service. Application gateway sends the encrypted traffic to App Service. App Service decrypts the traffic, and the web app processes the request.
1. The baseline architecture encrypts all the data at rest in Azure Storage, Azure SQL Database, and Azure Monitor (Log Analytic workspace).

#### Data in transit

- Create or upload your certificate to Key Vault. HTTPS encryption requires a certificate (X.509). You need a certificate from a trusted certificate authority for your custom domain.
- Store the private key to the certificate in Key Vault.
- Follow the guidance in [Grant permission to applications to access an Azure key vault using Azure RBAC](/azure/key-vault/general/rbac-guide) and [Managed identities for Azure resources](/azure/active-directory/managed-identities-azure-resources/overview) to provide the Application Gateway access to the certificate private key. Don’t use Key Vault policies to provide access. Key Vault policies only let you to grant permissions to an entire key vault, not just a specific secret.
- [Enable end to end encryption](/azure/application-gateway/ssl-overview#end-to-end-tls-encryption). App Service is the backend pool for the application gateway. When you configure the backend setting for the backend pool, use the HTTPS protocol over the backend port 443.

#### Data at rest

- Encrypt sensitive data in Azure SQL Database using [transparent data encryption](/azure/azure-sql/database/transparent-data-encryption-tde-overview#manage-transparent-data-encryption). Transparent data encrypts the entire database, backups, and transaction log files and requires no changes to your web application.
- Minimize database encryption latency. To minimize encryption latency, place the data you need to secure in its own database and only enable encryption for that database.
- [Azure Storage automatically encrypts](/azure/storage/common/storage-service-encryption) data at rest using server-side encryption (256-bit AES).
- Azure Monitor automatically encrypts data at rest using Microsoft-managed key (MMKs).

### Identity

The App Service baseline configures authentication and authorization for user identities (users) and workload identities (Azure resources) and implements the principle of least privilege.

#### User identities

- Use the [integrated authentication mechanism for App Service (“EasyAuth”)](/azure/app-service/overview-authentication-authorization). EasyAuth simplifies the process of integrating identity providers into your web app. It handles authentication outside your web app, so you don’t have to make any code changes. Authentication ("EasyAuth") in App Service.
- Configure the reply URL for the custom domain. You need to redirect the web app to `https://<application-gateway-endpoint>/.auth/login/<provider>/callback`. Replace `<application-gateway-endpoint>` with either the public IP address or the custom domain name associated with your application gateway. Replace `<provider>` with the authentication provider you're using such as "aad" for Azure Active Directory. You can use [the Azure Front documentation](/azure/app-service/overview-authentication-authorization#considerations-when-using-azure-front-door) to set up this flow with Application Gateway or [Setting up Application Gateway](https://techcommunity.microsoft.com/t5/apps-on-azure-blog/setting-up-application-gateway-with-an-app-service-that-uses/ba-p/392490).

#### Workload identities

- Use managed identity for workload identities. Managed identity eliminates the need for developers to manage authentication credentials.
- Use user-assigned managed identities. A system-assigned identity can cause infrastructure-as-code deployments to fail. You should use user-assigned managed identities to avoid deployment errors. For more information, see [Managed identities](/azure/active-directory/managed-identities-azure-resources/managed-identity-best-practice-recommendations).

## Deployment

Deployment for the baseline App Service application follows the guidance in [CI/CD for Azure Web Apps with Azure Pipelines](/azure/architecture/solution-ideas/articles/azure-devops-continuous-integration-and-continuous-deployment-for-azure-web-apps). In addition to that guidance, the App Services baseline architecture takes into account that the application and deployment storage account are network secured. The architecture denies public access to App Service. This means you can't deploy from outside the virtual network. The baseline shows you how to deploy the application code within the virtual network using self-hosted deployment agents. The deployment guidance is targeted at deploying the application code and doesn't address deploying the infrastructure or database changes. 

:::image type="complex" source="images/baseline-app-service-deployments.svg" lightbox="images/baseline-app-service-deployments.svg" alt-text="Diagram that shows a baseline App Service deployment architecture.":::
    The diagram adds to the Baseline Azure App Service architecture by adding a new subnet containing self-hosted deployment agents. It also adds an Azure Pipelines with managed agents. The last change is numbers for the deployment flow. Number one is on Azure Pipelines. Number two is an arrow from the self-hosted agents to Azure Pipelines. Three is an arrow from the self-hosted agent to the private endpoint for Azure Storage. Four is again above Azure Pipelines and the managed agents. Five is in App Services. Six is again over Azure Pipelines and the managed agents.
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

## Configuration

Applications require both configuration values and secrets. Use the following guidance for configuration and secrets management.

- Never check secrets such as passwords or access keys into source control.
- Use [Azure Key Vault] (/azure/key-vault/general/overview) to store secrets.
- Use [App Service configuration] (/azure/app-service/configure-common) for your application configuration instead. If you have the need to externalize configuration from your application config or require [feature flag support] (/azure/azure-app-configuration/concept-feature-management), consider using [Azure App Configuration] (/azure/azure-app-configuration/overview).
- [Use Key Vault references](/app-service/app-service-key-vault-references) in App Service configuration to securely expose secrets in your application.
- When you swap a deployment slot, the app settings are swapped by default. If you need different production and staging settings, you can create app settings that stick to a slot and don't get swapped.
- Set local environment variables for local development or take advantage of application platform features. App Services configuration exposes app settings as environment variables. Visual Studio, for example, lets you set environment variables in launch profiles. It also allows you to use App Settings and user secrets to store local application settings and secrets.

## Monitoring

Monitoring is the collection and analysis of data from IT systems. The goal of monitoring is observability at multiple layers to track web app health and security. Observability is a key facet of the baseline App Service architecture.

To monitor your web app, you need to collect and analyze metrics and logs from your application code, infrastructure (runtime), and the platform (Azure resources).For more information, see [Azure activity log](/azure/azure-monitor/essentials/activity-log?tabs=powershell), [Azure resource logs](/azure/azure-monitor/essentials/resource-logs), and  Application logs.

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
Key Vault | [Key Vault metrics and logs descriptions](/azure/key-vault/general/monitor-key-vault-reference) |
|Blob Storage | [Azure Blob Storage metrics and logs descriptions](/azure/storage/blobs/monitor-blob-storage-reference) |
| Application Insights | [Application Insights metrics and logs descriptions](/azure/azure-monitor/app/api-custom-events-metrics) |
| Public IP address | [Public IP address metrics and logs descriptions](/azure/virtual-network/ip-services/monitor-public-ip) |

- Understand the cost of collecting metrics and logs. general, the more metrics an logs you collect, the more it costs. For more information, see [Log Analytics cost calculations and options](/azure/azure-monitor/logs/cost-logs) and [Pricing for Log Analytics workspace](https://azure.microsoft.com/pricing/details/monitor/).
- Create alerts. You should create alerts for all the Azure resources in the architecture and configure Actions to remediate issues. Pick common and recommended alert rules to start with and modify over time as needed. For more information, see:

- [Overview of Azure Monitor alerts](/azure/azure-monitor/alerts/alerts-overview)
- [Application Gateway alerts](/azure/application-gateway/high-traffic-support#alerts-for-application-gateway-v2-sku-standard_v2waf_v2)
- [App Service alerts](/azure/app-service/monitor-app-service#alerts)
- [Azure SQL Database alerts](/azure/app-service/monitor-app-service#alerts)
- [Blob storage alerts](/azure/storage/blobs/monitor-blob-storage?tabs=azure-portal#alerts)
- [Key vault alerts](/azure/key-vault/general/monitor-key-vault#alerts)

#### Application Gateway

- Application Gateway automatically monitors the health of resources in its backend pool. Use the Application Gateway Access logs to information like the timestamp, the HTTP response code, and the URL path. For more information, see [Application Gateway default health probe](/azure/application-gateway/application-gateway-probe-overview#default-health-probe) and [Backend health and diagnostic logs](/azure/application-gateway/application-gateway-diagnostics#diagnostic-logging).

#### App Service

App Service has built-in and integrated monitoring tools that you should enable for improved observability. A web app that already has telemetry and monitoring features (“in-process instrumentation”) should continue to work on App Service.

- [Enable auto-instrumentation.](/azure/azure-monitor/app/codeless-overview) App Service has an instrumentation extension that you can enable with no code changes. You gain application performance monitoring (APM) visibility. For more information, see [Monitor Azure App Service performance](/azure/azure-monitor/app/azure-web-apps).
- [Enable distributed tracing.](/azure/azure-monitor/app/distributed-tracing-telemetry-correlation) Auto-instrumentation offers a way to monitor distributed cloud systems via distributed tracing and a performance profiler.
- Use code-based instrumentation for custom telemetry. ­Azure Application Insights also supports code-based instrumentation for custom application telemetry. Add the Application Insights SDK to your code and use the Application Insights API.
- [Enable App Service logs](/azure/app-service/troubleshoot-diagnostic-logs). The App Service platform supports four additional logs that you should enable to support troubleshooting. These logs are application logs, web server logs, detailed error messages, and failed request tracing.
- Use structured logging. Add a structured logging library to your application code. Update your code to use key-values pairs and enable Application logs in App Service to store these logs in the filesystem (temporary) or blob storage.
- [Turn on the App Service Health check.](/azure/app-service/monitor-instances-health-check) Health check reroutes requests away from unhealthy instances and replaces the unhealthy instances. Your App Service plan needs to use two or more instances for Health checks to work.

## Database

- User database Insights. For Azure SQL databases, you should configure [SQL Insights in Azure Monitor](/azure/azure-sql/database/sql-insights-overview). Database Insights uses dynamic management views to expose the data that you need to monitor health, diagnose problems, and tune performance. For more information, see [Monitoring Azure SQL Database with Azure Monitor.](/azure/azure-sql/database/monitoring-sql-database-azure-monitor?view=azuresql)

If your architecture includes CosmosDB, you don't need to enable or configure anything to use [Cosmos DB insights](/azure/cosmos-db/insights-overview).

This reference architecture uses [Azure Integration Services][integration-services] to orchestrate calls to enterprise back-end systems. Integration Services encompasses several components, including Azure Logic Apps, Azure API Management, Azure Service Bus, Azure Event Grid, Azure Functions, and Azure Data Factory. This basic architecture uses only Logic Apps and API Management. The companion article [Use a message broker and events to integrate enterprise systems](../../example-scenario/integration/queues-events.yml) covers more advanced scenarios that incorporate message queues and events. For greater reliability and scalability, use message queues and events to decouple the back-end systems. Back-end systems can include software as a service (SaaS) systems, Azure services, or existing web services in your enterprise.

## Architecture

:::image type="complex" source="images/simple-enterprise-integration.svg" border="false" lightbox="images/simple-enterprise-integration.svg" alt-text="Architecture diagram that shows a simple enterprise integration.":::
   The diagram shows how an application authenticates through Microsoft Entra and interacts with APIs, workflows, and back-end systems inside a resource group. On the left, Microsoft Entra connects to an application through a dotted line labeled authentication. The application sends an HTTP request to an API gateway in the API Management section. Inside this section, the API gateway sits above a developer portal. A dotted line labeled publish interfaces extends downward from Logic Apps to the developer portal. To the right, a workflow and orchestration section contains a Logic Apps icon. Two arrows point from Logic Apps to Azure services and SaaS services in the back-end systems section. A dashed border encloses API Management, the developer portal, and the workflow and orchestration box, with a label at the bottom that reads resource group.
:::image-end:::

*Download a [Visio file][integration-arch-visio] of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram:

1. The application is a client that calls the API gateway after it authenticates with Microsoft Entra ID. The application can be a web app, mobile app, or any other client that makes HTTP requests.

1. Microsoft Entra ID authenticates the client application. The client application obtains an access token from Microsoft Entra ID and includes it in the request to the API gateway.

1. API Management consists of two related components:

   - The **API gateway** accepts HTTP calls from the client application, validates the token from Microsoft Entra ID, and forwards the request to the back-end service. The API gateway can also transform requests and responses, and cache responses.

   - Developers use the **[developer portal][apim-dev-portal]** to discover and interact with the APIs. You can customize the developer portal to match your organization's branding.

1. Logic apps orchestrate the calls to the back-end services. Various events can trigger logic apps, and logic apps can call various services. In this architecture, Logic Apps calls the back-end services and provides connectivity through [connectors][logic-apps-connectors], which reduces the need for custom code.

1. The back-end services can be any service or line-of-business (LOB) application, like a database, web service, or SaaS application. The back-end services can be hosted in Azure or on-premises.

### Components

- [Integration Services][integration-services] is a collection of services that you can use to integrate applications, data, and processes. This solution uses two of these services:

  - [Logic Apps][logic-apps] is a serverless platform for building enterprise workflows that integrate applications, data, and services. In this architecture, Logic Apps facilitates message-based integration between systems, orchestrates the calls to the back-end services, and provides connectivity through connectors. This approach reduces the need for custom code.

  - [API Management][apim-reliability] is a managed service for publishing catalogs of HTTP APIs. You can use it to promote the reuse and discoverability of your APIs and deploy an API gateway to proxy API requests. API Management also provides a developer portal for clients to discover and interact with the APIs. In this architecture, API Management provides a façade for the back-end services that gives clients a consistent interface. It also provides capabilities like rate limiting, authentication, and caching to the back-end services.

- [Azure DNS][dns] is a hosting service for Domain Name System (DNS) domains. Azure DNS hosts the public DNS records for the API Management service. With DNS hosting, clients resolve the DNS name to the IP address of the API Management service.

- [Microsoft Entra ID][entra] is a cloud-based identity and access management service. Enterprise employees can use Microsoft Entra ID to access external and internal resources. In this architecture, Microsoft Entra ID secures the API Management service by using [OAuth 2.0][apim-oauth] and the developer portal by using [Microsoft Entra External ID][apim-ext-id].

- [Azure Key Vault][keyvault] is a cloud service for securely storing and managing secrets, encryption keys, and certificates. In this architecture, Key Vault provides centralized secret storage for Logic Apps and API Management.

## Scenario details

Integration Services is a collection of services that you can use to integrate applications, data, and processes for your enterprise. This architecture uses [Logic Apps][logic-apps] to orchestrate workflows and [API Management][apim] to create catalogs of APIs.

In this architecture, you build composite APIs by [importing logic apps][apim-logic-app] as APIs. You can also import existing web services by [importing OpenAPI][apim-openapi] (Swagger) specifications or [importing SOAP APIs][apim-soap] from Web Services Description Language (WSDL) specifications.

The API gateway helps to decouple front-end clients from the back end. For example, it can rewrite URLs or transform requests before they reach the back end. It also handles cross-cutting concerns like authentication, cross-origin resource sharing (CORS) support, and response caching.

### Potential use cases

This architecture is sufficient for basic integration scenarios in which synchronous calls to back-end services trigger the workflow. A more advanced architecture that uses [queues and events](../../example-scenario/integration/queues-events.yml) builds on this basic architecture.

## Recommendations

You can apply the following recommendations to most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### API Management

API Management has [eight tiers][apim-features]. These tiers provide a production service-level agreement (SLA) and support scale-out within the Azure region.

We don't recommend the API Management Consumption tier for this solution. It doesn't support the developer portal or Microsoft Entra integration, which this architecture requires.

The Developer tier is specifically for nonproduction environments and not recommended for production workloads.

API Management measures throughput capacity in *units*. Each pricing tier has a maximum scale-out. The Premium tier supports scale-out across multiple Azure regions. Choose your tier based on your feature set and the level of required throughput. To learn about differences between the tiers, see the [feature-based comparison of the API Management tiers][apim-features]. For more information, see [API Management pricing][apim-pricing] and [Capacity of an API Management instance][apim-capacity].

Each API Management instance has a default domain name, which is a subdomain of `azure-api.net`, like `contoso.azure-api.net`. Consider configuring a [custom domain][apim-domain] for your organization.

### Logic Apps

Logic Apps works best in scenarios that don't require low latency for a response, like asynchronous or API calls with moderate run times. If low latency is required, like in a call that blocks a user interface (UI), use a different technology. For example, use Functions or a web API deployed to Azure App Service. Use API Management to front the API to your API consumers.

### Region

To minimize network latency, put API Management and Logic Apps in the same region. In general, choose the region that's closest to your users or your back-end services.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Review the [SLAs for each service][sla].

If you deploy API Management across two or more regions with the Premium tier, API Management is eligible for a higher SLA. For more information, see [API Management pricing][apim-pricing].

#### Backups

Regularly [back up your API Management configuration][apim-backup]. The built-in backup and restore feature is available on classic Developer, Basic, Standard, and Premium tiers only. v2 tiers and the Consumption tier don't support it. For v2 deployments, adopt an infrastructure as code (IaC) approach to ensure recoverability. Store your backup files in a location or Azure region that differs from the region where you deploy the service. Based on your recovery time objective (RTO), choose a disaster recovery (DR) strategy:

- In a DR event, provision a new API Management instance, restore the backup to the new instance, and repoint the DNS records.

- Keep a passive instance of the API Management service in another Azure region. Regularly restore backups to that instance to keep it synced with the active service. To restore the service during a DR event, you only need to repoint the DNS records. This approach incurs extra costs because you pay for the passive instance, but it reduces recovery time.

For Logic Apps, we recommend a configuration as code (CAC) approach for backup and restore. Logic apps are serverless, so you can quickly recreate them from Azure Resource Manager templates. Save the templates in source control and integrate the templates with your continuous integration and continuous deployment (CI/CD) process. In a DR event, deploy the template to a new region.

If you deploy a logic app to a different region, update the configuration in API Management. You can update the API's `Back end` property by using a PowerShell script.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This list doesn't cover all security best practices. The following security considerations apply to this architecture:

- Restrict access to Logic Apps endpoints to only the IP address of API Management. On classic (non-v2) tiers, API Management has a fixed public IP address. If you use a v2 tier, a static IP isn't provided. In that case, consider alternative approaches like a custom domain with Azure DNS for IP address-based access restrictions. For more information, see [Restrict inbound IP addresses][logic-apps-restrict-ip].

- Use Azure role-based access control (Azure RBAC) to ensure that users have appropriate access levels.

- Secure public API endpoints in API Management by using OAuth or OpenID Connect (OIDC). To secure public API endpoints, set up an identity provider and add a JSON Web Token (JWT) validation policy. For more information, see [Protect an API by using OAuth 2.0 with Microsoft Entra ID and API Management][apim-oauth].

- Connect to back-end services from API Management by using [mutual certificates][apim-cert].

- Enforce HTTPS on the API Management APIs.

#### Store secrets

Never check passwords, access keys, or connection strings into source control. If these values are required, secure and deploy these values by using the appropriate techniques.

If a logic app works with sensitive data, see [Secure access and data for workflows in Logic Apps][logic-apps-secure].

API Management manages secrets by using objects called *named values* or *properties*. These objects securely store values that you can access through API Management policies. For more information, see [Use named values in API Management policies][apim-properties].

Use Key Vault to centrally store and manage passwords, API keys, connection strings, and certificates. Key Vault provides a hardened, encrypted secrets store with fine-grained access control and audit logging. Logic Apps can retrieve secrets from Key Vault by using managed identities or the built-in Key Vault connector, and API Management named values support direct references to Key Vault secrets. This approach keeps sensitive configuration out of application code and deployment templates. For more information, see [Well-Architected Framework guidance for protecting application secrets][waf-sec-secret].

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs.

#### API Management

The service charges for all API Management instances while they run. If you scale up and don't need that performance level at all times, scale down manually or set up [autoscaling][apim-autoscale].

#### Logic Apps

The Logic Apps Consumption plan uses a serverless model to calculate bills based on action and connector runs. If you use Logic Apps Standard (single-tenant), the hosting plan determines costs. For more information, see [Logic Apps pricing][logic-apps-pricing].

For more information, see the cost section in the [Well-Architected Framework][waf-cost].

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

#### DevOps

Create separate resource groups for production and dev/test environments. Separate resource groups make it easier to manage deployments, delete test deployments, and assign access rights.

When you assign resources to resource groups, consider these factors:

- **Life cycle:** In general, put resources that have the same life cycle in the same resource group.

- **Access:** To apply access policies to the resources in a group, you can use [Azure RBAC][rbac].

- **Billing:** You can view rollup costs for the resource group.

- **Pricing tier for API Management:** Use the Developer tier for dev/test environments. To minimize costs during preproduction, deploy a replica of your production environment, run your tests, and shut down the API Management instance.

##### Deployment

Use [Resource Manager templates][arm] to deploy the Azure resources and follow the infrastructure as code (IaC) process. Templates make it easier to automate deployments by using [Azure DevOps services][az-devops] or other CI/CD solutions.

##### Staging

Consider staging your workloads, which means that you deploy to various stages and run validations at each stage before you continue to the next stage. If you use this approach, you can push updates to your production environments in a highly controlled way and minimize unanticipated deployment problems. Use [blue-green deployment][blue-green-dep] or [canary releases][canary-releases] to update live production environments. Consider a good rollback strategy for when a deployment fails. For example, you can automatically redeploy an earlier, successful deployment from your deployment history. The `--rollback-on-error` flag parameter on the `az deployment group create` Azure CLI command can automatically redeploy an earlier successful deployment from your deployment history if the current deployment fails.

##### Workload isolation

Put API Management and any individual logic apps in their own separate Resource Manager templates. With separate templates, you can store the resources in source control systems. You can deploy the templates together or individually as part of a CI/CD process.

##### Versions

Each time you change a logic app's configuration or deploy an update through a Resource Manager template, Azure keeps a copy of that version and all versions that have a run history. You can use these versions to track historical changes or promote a version as the logic app's current configuration. For example, you can roll back a logic app to a previous version.

API Management supports two distinct but complementary versioning concepts:

- With **versions**, API consumers can choose an API version based on their needs, like v1, v2, preview, or production.

- With **revisions**, API admins can make nonbreaking changes in an API and deploy those changes, along with a changelog to inform API consumers.

You can make a revision in a development environment and deploy that change in other environments by using Resource Manager templates. For more information, see [Publish multiple versions of your API][apim-versions].

You can also use revisions to test an API before you make the changes current and reachable to users. We don't recommend this method for load testing or integration testing. Use separate test or preproduction environments instead.

#### Diagnostics and monitoring

Use [Azure Monitor][monitor] to monitor operations in API Management and Logic Apps. Azure Monitor provides information based on the metrics that you set up for each service and is enabled by default. For more information, see the following articles:

- [Monitor published APIs][apim-monitor]
- [Monitor status, set up diagnostics logging, and turn on alerts for Logic Apps][logic-apps-monitor]

Each service also has these options:

- For deeper analysis and dashboarding, send Logic Apps logs to [Azure Log Analytics][logic-apps-log-analytics].

- For DevOps monitoring, set up Azure Application Insights for API Management.

- API Management supports the [Power BI solution template for custom API analytics][apim-pbi]. You can use this solution template to create your own analytics solution. For business users, Power BI makes reports available.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

To increase the scalability of API Management, add [caching policies][apim-caching] where appropriate. Caching also helps reduce the load on back-end services.

To provide greater capacity, you can scale out API Management Basic, Standard, and Premium tiers in an Azure region. To analyze the usage for your service, select **Capacity Metric** on the **Metrics** menu and then scale up or scale down as appropriate. The upgrade or scale process can take from 15 to 45 minutes to apply.

Recommendations for scaling an API Management service:

- Consider traffic patterns when you scale. Customers that have more volatile traffic patterns need more capacity.

- Consistent capacity that's greater than 66% might indicate a need to scale up.

- Consistent capacity that's less than 20% might indicate an opportunity to scale down.

- Before you enable the load in production, always load-test your API Management service with a representative load.

With the Premium tier, you can scale an API Management instance across multiple Azure regions. This configuration makes API Management eligible for a higher SLA. You can also provision services near users in multiple regions.

The Logic Apps serverless model removes the need for admins to plan for service scalability. The service scales automatically to meet demand.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Karl Rissland](https://www.linkedin.com/in/karl-rissland/) | Solutions Engineer, Azure AI and Applications

Other contributor:

- [Pooya Tolouei](https://au.linkedin.com/in/nicolas-tolou) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Logic Apps overview][logic-apps]
- [API Management overview][apim]
- [Azure DNS overview][dns]

## Related resources

- [API Management landing zone architecture](../../example-scenario/integration/app-gateway-internal-api-management-function.yml)
- [On-premises data gateway for Logic Apps](../../hybrid/gateway-logic-apps.yml)

<!-- links -->
[apim]: /azure/api-management/api-management-key-concepts
[apim-autoscale]: /azure/api-management/api-management-howto-autoscale
[apim-backup]: /azure/api-management/api-management-howto-disaster-recovery-backup-restore
[apim-caching]: /azure/api-management/api-management-howto-cache
[apim-capacity]: /azure/api-management/api-management-capacity
[apim-cert]: /azure/api-management/api-management-howto-mutual-certificates
[apim-dev-portal]: /azure/api-management/api-management-key-concepts#developer-portal
[apim-domain]: /azure/api-management/configure-custom-domain
[apim-ext-id]: /azure/api-management/api-management-howto-aad#enable-access-by-external-users
[apim-features]: /azure/api-management/api-management-features
[apim-logic-app]: /azure/api-management/import-logic-app-as-api
[apim-monitor]: /azure/api-management/api-management-howto-use-azure-monitor
[apim-oauth]: /azure/api-management/api-management-howto-protect-backend-with-aad
[apim-openapi]: /azure/api-management/import-api-from-oas
[apim-pbi]: https://azure.microsoft.com/updates/azure-api-management-analytics-powerbi-solution-template
[apim-pricing]: https://azure.microsoft.com/pricing/details/api-management/
[apim-properties]: /azure/api-management/api-management-howto-properties
[apim-reliability]: /azure/well-architected/service-guides/azure-api-management
[apim-soap]: /azure/api-management/import-soap-api
[apim-versions]: /azure/api-management/api-management-get-started-publish-versions
[arm]: /azure/azure-resource-manager/templates/syntax
[az-devops]: /azure/virtual-machines/infrastructure-automation#azure-devops-services
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator/
[blue-green-dep]: https://martinfowler.com/bliki/BlueGreenDeployment.html
[canary-releases]: https://martinfowler.com/bliki/CanaryRelease.html
[dns]: /azure/dns/dns-overview
[entra]: /entra/fundamentals/what-is-entra
[integration-arch-visio]: https://arch-center.azureedge.net/simple-enterprise-integration.vsdx
[integration-services]: https://azure.microsoft.com/products/category/integration/
[keyvault]: /azure/key-vault/general/overview
[logic-apps-connectors]: /azure/connectors/apis-list
[logic-apps-log-analytics]: /azure/logic-apps/monitor-workflows-collect-diagnostic-data
[logic-apps-monitor]: /azure/logic-apps/view-workflow-status-run-history
[logic-apps-pricing]: https://azure.microsoft.com/pricing/details/logic-apps/
[logic-apps-restrict-ip]: /azure/logic-apps/logic-apps-securing-a-logic-app#restrict-inbound-ip-addresses
[logic-apps-secure]: /azure/logic-apps/logic-apps-securing-a-logic-app
[logic-apps]: /azure/logic-apps/logic-apps-overview
[monitor]: /azure/azure-monitor/fundamentals/overview
[rbac]: /azure/role-based-access-control/overview
[sla]: https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services
[waf-cost]: /azure/well-architected/cost-optimization
[waf-sec-secret]: /azure/well-architected/security/application-secrets

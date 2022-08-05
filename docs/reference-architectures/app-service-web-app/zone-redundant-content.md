<!-- cSpell:ignore CNAME -->

This reference architecture shows how to run a web-app workload on Azure App Services in a zone-redundant configuration. [Zone-redundant services][az-ha-services] provide high-availability by replicating your services and data across Availability zones to protect from single points of failure. [**Deploy this scenario**.](#deploy-this-scenario)

## Architecture

![Reference architecture for a web application with high availability](./images/zone-redundant-web-app-diagram.png)

_Download a [Visio file](https://arch-center.azureedge.net/architecture.vsdx) that contains this architecture diagram. This file must be uploaded to `https://arch-center.azureedge.net/`_

This architecture builds on [Availability zones infrastructure][azs] found in many Azure regions today. For a list of Azure regions that support Availability Zones see [Azure regions with Availability Zones][az-regions].

Availability Zones spread a solution across multiple independent zones within a region, allowing for an application to continue functioning when one zone fails. Most foundational and mainstream Azure services, and many Specialized Azure services provide support for Availability Zones today. All of the Azure services in this architecture are zone-redundant, simplifying deployment and management. For a list of Azure services that support Availability Zones see [Azure Services that support Availability Zones][az-services].

Zone-redundant Azure services automatically manage and mitigate failures, including zone failures, to maintain their [service level agreements (SLAs)](https://azure.microsoft.com/support/legal/sla/). Zone-redundancy offers effective recovery times of zero for zone failure. If a single zone within a region becomes unavailable, you shouldn't expect to lose any data, and your workload should continue to run.

### Workflow and components

A SPA (single page application) running in a browser requests static assets including scripts, stylesheets and media assets. Once loaded, the SPA makes API calls that provide functionality.

* SPA users are authenticated by [Azure Active Directory (Azure AD)][aad] or [Azure AD B2C][aad-b2c]. The browser performs DNS lookups to resolve addresses to Azure Front Door front-ends.
* [Azure Front Door][afd] is the public front-end for all internet requests, acting as a global HTTP reverse proxy and cache in front of several back-end (origin) services. Front Door also provides automatic protection from layer 4 DDoS attacks.
* [Azure Static Web Apps][swa] hosts all of the SPA assets, including scripts, stylesheets and media.
* [Azure App Services][app-services] hosts the API applications and services, also providing a front-end for back-end services. Deployment slots are used to provide zero-downtime releases.
* App Services and Functions Apps use [Virtual Network (VNet) Integration][vnet-integration] to connect to backend services over a private VNet.
* [Azure Functions Apps][functions] host backend Functions that connect to backend services and databases.
* [Azure Cache for Redis][redis] provides a high-performance distributed cache for output, session and general-purpose caching.
* [Azure Service Bus][service-bus] acts as a high-speed bus between front-end and back-end services for asynchronous messaging.
* [Azure Cosmos DB][cosmos-db] provides "no-sql" document databases for front-end services.
* [Azure SQL DB][sql-db] provides relational databases for back-end services.
* [Azure Cognitive Search][cog-search] indexes Cosmos DB documents, allowing them to be searched via front-end APIs.
* [Azure Blob Storage][storage] stores meta-data and trigger state for Function Apps.
* [Private Endpoints][peps] allow connections to back-end Azure services from private VNets, and allow the public endpoints on these services to be disabled.
* [Azure Key Vault][akv] securely stores secrets and certificates to be accessed by Azure services.
* [Azure Monitor - Application Insights][insights] collects application performance metrics for observability.

### Alternatives

* Either Azure Active Directory (Azure AD) or Azure AD B2C can be used as an IDP in this scenario. Azure AD is designed for business-to-business (B2B) scenarios, while Azure AD B2C is designed for business-to-consumer (B2C) scenarios.
* You can choose Azure-managed DNS, which is recommended, or you can choose to use your own DNS provider.
* [Azure Application Gateway][appgw] could be used instead of Azure Front Door if most internet users were located close by, and content caching wasn't an important requirement.
* [Azure Content Delivery Network][cdn] (Azure CDN) could be used alongside Application Gateway to cache static assets. Azure Front Door was chosen for this architecture due to its global network presence, improved performance through WAN acceleration, and built-in content cache. Operational excellence is also improved with a single configuration point for custom domain names, TLS/SSL certificates, Web Application Firewall and routing rules.
* [Static website hosting in Azure Storage][storage-spa] may be considered in place of Azure Static Web Apps, if already using Azure CDN for example. However static website hosting in Azure Storage does have limitations. For more information, see [Static website hosting in Azure Storage][storage-spa]. Azure Static Web Apps was chosen for its global high availability, and its simple deployment and configuration.
* In this architecture, Functions are hosted in a zone-redundant Premium Functions plan. Azure Static Web Apps also has the capability to host Functions, either fully managed or bring-your-own. For more information about hosting Functions in Static Web Apps, see [API support in Azure Static Web Apps with Azure Functions][swa-apis]. 

### Solution details

Customers want the convenience of websites and apps that are available when they need them. Keeping hosting platforms highly available at scale has been problematic in the past, requiring complex and expensive multi-region deployments. These problems are resolved with [Availability Zones][azs], physically separate locations within each Azure region that are tolerant to local failures. With zone-redundant deployments a customer can spread workloads across multiple independent zones, improving availability. 

This architecture shows how to combine zone-redundant services into a solution that provides exceptional availability and is resilient to zone failure. The solution is less complex than multi-region alternatives, offering more cost-optimization opportunities simplifying operational requirements. There are many more benefits including:

* No zone pinning or zonal deployments required. Zone-redundancy is configured at deployment time and is automatically managed by services throughout their lifetime.
* Recovery time from zone failure is much shorter than a multi-region deployment. Recovery time from zone-failure for zone-redundant services is practically zero.
* Simplified networking. All VNet traffic can remain in the same Azure region.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Front Door

Azure Front Door is a global service offering resilience to zone and region failures. 

* Use [Azure managed certificates][afd-certs] on all frontends to prevent certificate mis-configuration and expiration issues.
* Enable [Caching][afd-cache] on routes where appropriate to improve availability by distributing content to the Azure POP (point of presence) edge nodes.
* Deploy Azure Front Door Premium and configure a [WAF policy][afd-waf] with a Microsoft-managed ruleset. Apply the policy to all frontends in Prevention mode to mitigate DDOS attacks that may cause an origin service to become unavailable.

### Azure Static Web Apps

Azure Static Web Apps is a global service resilient to zone and region failures. Deploy a Standard plan for production apps. API support and Enterprise-grade edge aren't required for this architecture as Premium Functions and Azure Front Door are used instead. 

### App Services

[App Service Premium v2, Premium v3][app-services-zr] and [Isolated v3][ise-zr] App Service Plans offer zone redundancy with a minimum of three instances. In this configuration App Service Plan instances are distributed across multiple availability zones to protect from zone failure.

* Deploy a minimum of three instances for zone-redundancy.
* Practice [staging slot deployments][app-service-staging] for zero-downtime releases.
* Enable [Virtual Network (VNet) Integration][appservice-vnet] for private networking with backend services.

### Azure Functions

[Azure Functions Elastic Premium][functions-zr] offers zone redundancy with a minimum of three instances.

* Deploy a minimum of three instances for zone-redundancy.
* Enable a Private endpoint and deny access to public endpoint traffic.
* Integrate the Private endpoint with an Azure Private DNS zone.
* Enable Virtual Network (VNet) Integration for private networking with backend services.

For more information about Private endpoints and VNet integration in Azure Functions, see [Integrate Azure Functions with an Azure virtual network][func-vnet].

### SQL Database

[Zone-redundancy in Azure SQL DB][sql-gp-zr] is supported in General Purpose, Premium, and Business Critical tiers.

* Deploy Azure SQL DB General Purpose, Premium, or Business Critical with zone-redundancy enabled.
* [Configure SQL DB backups][sql-backups-zr] to use ZRS (zone-redundant storage) or GZRS (geo-zone-redundant storage).
* [Create a Private link for Azure SQL DB][sql-pep] and disable the public endpoint.
* Integrate the Private endpoint with an Azure Private DNS zone.

### Cosmos DB

Enable [zone-redundancy in Azure Cosmos DB][cosmos-ha] when selecting a region to associate with your Azure Cosmos account.

* Enable zone-redundancy when adding the local read/write region to the Azure Cosmos account.
* [Enable continuous backups][cosmos-backup].
* [Configure private link for the Cosmos account][cosmos-pep]. Enabling the private endpoint will disable the public endpoint.
* Integrate the Private endpoint with an Azure Private DNS zone.

### Blob Storage

Azure [Zone-Redundant Storage][zrs] (ZRS) replicates your data synchronously across three Azure availability zones in the region.

* Create a Standard ZRS or Standard GZRS storage account for hosting web assets.
* Create separate storage accounts for web assets, Azure Functions meta-data, and other data, so that the accounts can be managed and configured separately.
* [Use private endpoints for Azure Storage][storage-pep]
* Configure the Storage firewall to deny public internet traffic.
* Integrate the Private endpoint with an Azure Private DNS zone.

### Service Bus

[Service Bus Premium][servicebus-az] supports Availability Zones, providing fault-isolated locations within the same Azure region.

* Enable zone-redundancy on a new Azure Service Bus Premium namespace.
* [Configure private link][sb-pep] for the Azure Service Bus namespace.
* Integrate the Private endpoint with an Azure Private DNS zone.
* Specify at least one IP rule or virtual network rule for the namespace to allow traffic only from the specified IP addresses or subnet of a virtual network. Adding a rule will disable the public endpoint.

### Cache for Redis

Cache for Redis supports [zone-redundancy][redis-zr] in the Premium, Enterprise and Enterprise Flash tiers. To enable zone redundancy for Azure Cache for Redis:

* Configure a minimum of three replicas.
* Select all three Availability Zones.

For more information, see [Enable zone redundancy for Azure Cache for Redis][enable-redis-zr].

In this architecture, Azure Cache for Redis is deployed with a private endpoint and the public endpoint is disabled.

* Deploy a new Azure Cache for Redis with a private endpoint, or add a private endpoint to an existing cache.
* Set the `publicNetworkAccess` flag to `Disabled` to disable the public endpoint.

For more information about private endpoints on Azure Redis Cache, see [Azure Cache for Redis with Azure Private Link][redis-pep].

### Cognitive Search

You can utilize [Availability Zones with Azure Cognitive Search][cog-search-az] by adding more replicas to your search service. Each replica will be placed in a different Availability Zone within the region.

* Deploy a minimum of three replicas for zone-redundancy.
* [Create a private endpoint for Azure Cognitive Search][cog-search-pep]. Adding a private endpoint will disable the public endpoint.
* Integrate the private endpoint with an Azure Private DNS zone.

### Key Vault

Key Vault is automatically zone-redundant in any region where Availability zones are available. The Key Vault used in this architecture is deployed with a private endpoint enabled and public disabled for backend services to access secrets. For more information about Private endpoints for Azure Key Vault, see [Integrate Key Vault with Azure Private Link][akv-pep].

### Azure DNS Private Zones

Integrate Private Endpoints with Azure DNS Private Zones to simplify DNS management. For more information, see [Azure Private Endpoint DNS configuration][pep-dns].

## Considerations

<!--

> Are there any lessons learned from running this that would be helpful for new customers?  What went wrong when building it out?  What went right?
> How do I need to think about managing, maintaining, and monitoring this long term?

-->

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

<!-- 

> This section includes resiliency and availability considerations. They can also be H4 headers in this section, if you think they should be separated.
> Are there any key resiliency and reliability considerations (past the typical)?

-->

#### Availability

This reference architecture is designed to provide high availability through availability zone infrastructure. When implemented properly this architecture will provide excellent availability for lower cost and operational overhead than other solutions. However, improvements can always be made. The risk of a zone failure in an Azure region is mitigated by this design. Zone redundant services in Azure are designed to withstand a zone failure while still operating within SLA. 

Region failures; where services are unavailable for any reason are unlikely, but possible. Region failures can be mitigated by combining this zone-redundant architecture with a multi-region architecture, to reduce recovery time if an entire region was impacted. Multi-region designs are more complex and often more expensive than single region - multi-zone designs. A risk assessment should be made to determine if a multi-region architecture is required for the assessed risk.

#### Resilience

Multi-zone designs based on Availability zones offer levels of availability and resilience that meet or exceed the business requirements of most customers. However, for customers who want to replicate data to a secondary region for disaster recovery, several options are available including [Object replication for block blobs][object-replication]. Azure data services like Cosmos DB also offer replication of data to other Azure regions with continuous backup to be used if a disaster occurs. For more information, see [Continuous backup with point-in-time restore in Azure Cosmos DB][cosmos-continuous-backup].

Global services can also fail, although the likelihood is increasingly unlikely. Customers can improve recovery times from global service failure by preparing and rehearsing a runbook to be used if a failure occurs. For example, the risk of Front Door service downtime can be mitigated with a runbook that changes DNS CNAME records to point to an alternative reverse HTTP Proxy like [Azure App Gateway][appgw]. 

Architects can increase resilience to Azure Active Directory (Azure AD) failures by following important guidance. For more information, see [Build resilience in your identity and access management infrastructure][aad-resilience].

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This architecture establishes network segmentation boundaries along public and private lines. Azure Front Door, Azure Static Web Apps and Azure App Services are designed to operate on the public internet. These services have their public endpoints enabled. Backend services have their public endpoints disabled and private endpoints are used instead.

All service to service communication in Azure is TLS (transport layer security) encrypted by default. Azure Front Door, Azure App Services and Azure Static Web Apps are configured to only accept HTTPS traffic.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

<!-- 

> How much will this cost to run? See if you can answer this without dollar amounts.
> Are there ways I could save cost?
> If it scales linearly, than we should break it down by cost/unit. If it does not, why?
> What are the components that make up the cost?
> How does scale affect the cost?

> Link to the pricing calculator (https://azure.microsoft.com/pricing/calculator) with all of the components in the architecture included, even if they're a $0 or $1 usage.
> If it makes sense, include small/medium/large configurations. Describe what needs to be changed as you move to larger sizes.

-->

Zone-redundant architectures are less expensive than multi-region alternatives because services can be deployed in a single region. However, there are several cost implications that customers should be aware of:

* Some zone-redundant services incur charges for inter-zone bandwidth. For more information, see [Bandwidth pricing][bandwidth-pricing].
* Some services require a minimum number of instances or replicas to be deployed to achieve zone-redundancy.
* Zone redundant storage (ZRS) is priced differently to Locally redundant storage (LRS). For more information, see [Storage pricing][storage-pricing].
* Private Endpoints incur hourly and bandwidth (data) charges. For more information, see [Private Link pricing][pep-pricing].

Some cost optimization considerations include:

* Save money when you reserve resources in advance. Several services in this architecture are eligible for Reserved capacity pricing. For more information about Reserved capacity, see [Reservations][reservations].
* Function Apps can be hosted in the same dedicated App Service Plan as the API Apps. Combining the plans removes the segmentation of frontend and backend services and introduces risk of noisy neighbor effect; backend services could consume resources needed by frontend services, and vice-versa.
* Private endpoints can be removed to save costs. Conduct a risk assessment to determine the risk of enabling public endpoints on backend services. Use [Managed Identities][msi] and enable service firewalls to provide defense in depth.

> An example bill of materials for this architecture can be viewed in [Azure Pricing Calculator][bom].

<!-- 
### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

<!-- 

> This includes DevOps, monitoring, and diagnostics considerations.
> How do I need to think about operating this solution?

-- >

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

<!--

> This includes scalability considerations.
> Are there any key performance considerations (past the typical)?
> Are there any size considerations around this specific solution? What scale does this work at? At what point do things break or not make sense for this architecture?

-- >

-->

## Deploy this scenario

<!-- 

> REQUIRED: Reference Architectures require a deployment. If you cannot provide a deployment, use the Example Workload template instead. 

_Describe a step-by-step process for implementing the reference architecture solution. Best practices are to add the solution to GitHub, provide a link (use boilerplate text below), and explain how to roll out the solution._

A deployment for a reference architecture that implements these recommendations and considerations is available on [GitHub](https://www.github.com/path-to-repo).

1. First step
2. Second step
3. Third step ...

-->

Deploy this reference architecture using the [Azure Quickstart Template][quickstart]. 

* Azure AD / Azure AD B2C and Azure DNS aren't deployed by this sample. 
* Custom domain names and TLS/SSL certificates aren't created and configured. Default frontend DNS names are used instead.

## Contributors

<!-- 
> (Expected, but this section is optional if all the contributors would prefer to not be mentioned.)

> Start with the explanation text (same for every section), in italics. This makes it clear that Microsoft takes responsibility for the article (not the one contributor). Then include the "Principal authors" list and the "Other contributors" list, if there are additional contributors (all in plain text, not italics or bold). Link each contributor's name to the person's LinkedIn profile. After the name, place a pipe symbol ("|") with spaces, and then enter the person's title. We don't include the person's company, MVP status, or links to additional profiles (to minimize edits/updates). (The profiles can be linked to from the person's LinkedIn page, and we hope to automate that on the platform in the future). Implement this format:

--> 

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

<!-- Only the primary authors. Listed alphabetically by last name. Use this format: Fname Lname. If the article gets rewritten, keep the original authors and add in the new one(s). -->

 - [Daniel Larsen](https://www.linkedin.com/in/daniellarsennz/) | FastTrack for Azure Customer Engineer
 
Other contributors: 

<!-- Include contributing (but not primary) authors, major editors (not minor edits), and technical reviewers. Listed alphabetically by last name. Use this format: Fname Lname. It's okay to add in newer contributors. -->

 - [John Downs](https://www.linkedin.com/in/john-downs/) | FastTrack for Azure Customer Engineer

<!-- 
## Next steps

<!-- 

> Link to Docs and Learn articles. Could also be to appropriate sources outside of Docs, such as GitHub repos, third-party documentation, or an official technical blog post.

Examples:
* [Azure Machine Learning documentation](/azure/machine-learning)
* [What are Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)

-- >

## Related resources

<!--

> Use "Related resources" for architecture information that's relevant to the current article. It must be content that the Azure Architecture Center TOC refers to, but may be from a repo other than the AAC repo.
> Links to articles in the AAC repo should be repo-relative, for example (../../solution-ideas/articles/article-name.yml).

> Here is an example section:

Fully deployable architectures:

* [Chatbot for hotel reservations](/azure/architecture/example-scenario/ai/commerce-chatbot)
* [Build an enterprise-grade conversational bot](/azure/architecture/reference-architectures/ai/conversational-bot)
* [Speech-to-text conversion](/azure/architecture/reference-architectures/ai/speech-ai-ingestion)

-- >
-->



<!-- links -->
[aad]:https://azure.microsoft.com/services/active-directory/
[aad-b2c]:https://azure.microsoft.com/services/active-directory/external-identities/b2c/
[afd]:https://azure.microsoft.com/services/frontdoor/
[swa]:https://azure.microsoft.com/services/app-service/static/
[app-services]:https://azure.microsoft.com/services/app-service/
[vnet-integration]:https://docs.microsoft.com/azure/app-service/overview-vnet-integration#regional-virtual-network-integration
[functions]:https://azure.microsoft.com/services/functions/
[redis]:https://azure.microsoft.com/services/cache/
[service-bus]:https://azure.microsoft.com/services/service-bus/
[cosmos-db]:https://azure.microsoft.com/services/cosmos-db/
[sql-db]:https://azure.microsoft.com/products/azure-sql/database/
[cog-search]:https://azure.microsoft.com/services/search/
[storage]:https://azure.microsoft.com/services/storage/blobs/
[peps]:https://docs.microsoft.com/azure/private-link/private-endpoint-overview
[akv]:https://azure.microsoft.com/services/key-vault/
[insights]:https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview
[appgw]:https://azure.microsoft.com/services/application-gateway/
[cdn]:https://azure.microsoft.com/services/cdn/
[storage-spa]:https://docs.microsoft.com/azure/storage/blobs/storage-blob-static-website
[azs]:https://azure.microsoft.com/global-infrastructure/availability-zones/
[az-ha-services]:https://docs.microsoft.com/azure/availability-zones/az-region#highly-available-services
[zrs]: https://docs.microsoft.com/azure/storage/common/storage-redundancy#zone-redundant-storage
[storage-pep]:https://docs.microsoft.com/azure/storage/common/storage-private-endpoints
[az-regions]:https://docs.microsoft.com/azure/availability-zones/az-region#azure-regions-with-availability-zones
[az-services]:https://docs.microsoft.com/azure/availability-zones/az-region
[servicebus-az]:https://docs.microsoft.com/azure/service-bus-messaging/service-bus-outages-disasters#availability-zones
[redis-zr]:https://docs.microsoft.com/azure/azure-cache-for-redis/cache-high-availability#zone-redundancy
[enable-redis-zr]:https://docs.microsoft.com/azure/azure-cache-for-redis/cache-how-to-zone-redundancy
[redis-pep]:https://docs.microsoft.com/azure/azure-cache-for-redis/cache-private-link
[cog-search-az]:https://docs.microsoft.com/azure/search/search-performance-optimization#availability-zones
[cog-search-pep]:https://docs.microsoft.com/azure/search/service-create-private-endpoint
[akv-pep]:https://docs.microsoft.com/azure/key-vault/general/private-link-service
[app-services-zr]:https://docs.microsoft.com/azure/app-service/how-to-zone-redundancy
[functions-zr]:https://docs.microsoft.com/azure/azure-functions/azure-functions-az-redundancy
[func-vnet]:https://docs.microsoft.com/azure/azure-functions/functions-create-vnet
[ise-zr]:https://docs.microsoft.com/azure/app-service/environment/overview-zone-redundancy
[sql-gp-zr]:https://docs.microsoft.com/azure/azure-sql/database/high-availability-sla#general-purpose-service-tier-zone-redundant-availability
[cosmos-ha]:https://docs.microsoft.com/azure/cosmos-db/high-availability
[waf]:https://docs.microsoft.com/azure/architecture/framework/
[object-replication]:https://docs.microsoft.com/azure/storage/blobs/object-replication-overview
[cosmos-continuous-backup]:https://docs.microsoft.com/azure/cosmos-db/continuous-backup-restore-introduction
[afd-certs]:https://docs.microsoft.com/azure/frontdoor/standard-premium/how-to-configure-https-custom-domain#azure-managed-certificates
[afd-cache]:https://docs.microsoft.com/azure/frontdoor/front-door-caching?pivots=front-door-standard-premium
[afd-waf]:https://docs.microsoft.com/azure/web-application-firewall/afds/afds-overview
[app-service-staging]:https://docs.microsoft.com/azure/app-service/deploy-staging-slots
[appservice-vnet]:https://docs.microsoft.com/azure/app-service/configure-vnet-integration-enable
[sql-backups-zr]:https://docs.microsoft.com/azure/azure-sql/database/automated-backups-overview?view=azuresql&tabs=single-database#configure-backup-storage-redundancy-by-using-the-azure-cli
[sql-pep]:https://docs.microsoft.com/azure/azure-sql/database/private-endpoint-overview?view=azuresql
[cosmos-backup]:https://docs.microsoft.com/azure/cosmos-db/provision-account-continuous-backup
[cosmos-pep]:https://docs.microsoft.com/azure/cosmos-db/how-to-configure-private-endpoints
[storage-spa]:https://docs.microsoft.com/azure/storage/blobs/storage-blob-static-website
[sb-pep]:https://docs.microsoft.com/azure/service-bus-messaging/private-link-service
[swa-apis]:https://docs.microsoft.com/azure/static-web-apps/apis-functions
[pep-dns]:https://docs.microsoft.com/azure/key-vault/general/private-link-service
[aad-resilience]:https://docs.microsoft.com/azure/active-directory/fundamentals/resilience-in-infrastructure
[bandwidth-pricing]:https://azure.microsoft.com/pricing/details/bandwidth/
[storage-pricing]:https://azure.microsoft.com/pricing/details/storage/blobs/
[pep-pricing]:https://azure.microsoft.com/pricing/details/private-link/
[reservations]:https://azure.microsoft.com/reservations/
[bom]:https://azure.com/e/888e1c7e5e814e998da8364b612c292a
[msi]:https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview
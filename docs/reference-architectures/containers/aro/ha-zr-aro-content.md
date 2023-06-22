<!-- cSpell:ignore CNAME -->

This reference architecture shows the holistic view of a web-app workload on Azure Red Hat OpenShift in a zone-redundant configuration. [Zone-redundant services][az-ha-services] provide high-availability by replicating your services and data across Availability zones to protect from single points of failure.

This document builds on top of the ["Azure Red Hat OpenShift landing zone accelerator"](https://learn.microsoft.com/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator), focusing on zone-redundant configuration with Azure Red Hat OpenShift. Please read "Azure Red Hat OpenShift landing zone accelerator" before starting building production environment with Azure Red Hat OpenShift.

## Architecture

:::image type="content" source="./images/openshift-zonal-architecture.svg" alt-text="Reference architecture for a web application with high availability":::

_Download a [Visio file](https://arch-center.azureedge.net/openshift-zonal-architecture.vsdx) that contains this architecture diagram._

This architecture builds on [Availability zones infrastructure][azs] found in many Azure regions today. For a list of Azure regions that support Availability Zones, see [Azure regions with Availability Zones][az-regions].

Availability zones spread a solution across multiple independent zones within a region, allowing for an application to continue functioning when one zone fails. Most foundational and mainstream Azure services, and many specialized Azure services provide support for availability zones today. All of the Azure services in this architecture are zone-redundant, simplifying deployment and management. For a list of Azure services that support availability zones see [Azure Services that support Availability Zones][az-services].

Zone-redundant Azure Red Hat OpenShift automatically manage and mitigate failures, including zone failures, to maintain their [service level agreements (SLAs)][sla]. Zone-redundancy offers effective recovery times of zero for zone failure. If a single zone within a region becomes unavailable, you shouldn't expect to lose any data, and your workload should continue to run.

### Workflow

A client sends a request to Azure. The request is received by Azure Front Door and routed to a web application hosted on Azure Red Hat OpenShift. The web application executes the client request using other Azure services, and then sends a response back to the client.

### Components

* End users are authenticated by [Azure Active Directory (Azure AD)][aad] or [Azure AD B2C][aad-b2c]. The browser performs DNS lookups to resolve addresses to Azure Front Door.
* [Azure Front Door][afd] is the public front-end for all internet requests, acting as a global HTTP reverse proxy and cache in front of several back-end (origin) services. Front Door also provides automatic protection from layer 4 DDoS attacks, and a range of other features to enhance the security and performance of your application.
* [Azure Red Hat OpenShift][aro] is the Kubernetes-based container orchestrator and hosts the API applications and services, also providing a front-end for back-end services.
* [Azure Container Registry][acr] is the registry supporting Docker and Open Container Initiative (OCI) compliant container images.
* Azure Red Hat OpenShift uses [Virtual Network (VNet) Integration][vnet-integration] to connect to backend services over a private VNet.
* [Azure Cosmos DB][cosmos-db] provides NoSQL document databases for front-end services.
* [Private Endpoints][peps] allow connections to back-end Azure services from private VNets, and allow the public endpoints on these services to be disabled.
* [Azure private DNS][private-dns] automatically configures and updates the DNS records required by private endpoint services.
* [Azure Key Vault][akv] securely stores secrets and certificates to be accessed by Azure services.
* [Azure Monitor][azmon] and [Application Insights][insights] collects service logs and application performance metrics for observability.

### Alternatives

* Either Azure Active Directory (Azure AD) or Azure AD B2C can be used as an IDP in this scenario. Azure AD is designed for internal applications and business-to-business (B2B) scenarios, while Azure AD B2C is designed for business-to-consumer (B2C) scenarios.
* Azure-managed DNS is recommended, but user's own DNS provider can be used as an alternative.
* [Azure Application Gateway][appgw] could be used instead of Azure Front Door if most of your users are located close to the Azure region that hosts your workload, and when you don't need content caching. [Azure DDoS Protection][ddosp] Standard is recommended for protecting internet-facing Application Gateway services.
* A premium [Azure API Manager][apim] instance deployed with zone-redundancy enabled is a good alternative for hosting frontend APIs, backend APIs or both. For more information about zone-redundancy in API Manager, see [availability zone support][apim-zr].
* OpenShift Container Platform or OKD onto [Azure Virtual Machines][az-vm] can be used instead of Azure Red Hat OpenShift. OpenShift Container Platform or OKD are IaaS alternatives to a fully platform managed (PaaS) service like Azure Red Hat OpenShift. Customers must purchase the necessary entitlements for OpenShift Container Platform or OKD and are responsible for installation and management of the entire infrastructure. For more information, see [OpenShift in Azure][openshift-in-azure].

## Scenario details

Traditionally, it's been hard to keep hosting platforms highly available at scale. High availability has historically required complex and expensive multi-region deployments, with tradeoffs between data consistency and high performance.

[Availability zones][azs] resolve many of these issues. Availability zones are physically separate locations within each Azure region that are tolerant to local failures. Availability zones spread a solution across multiple independent zones within a region, allowing an application to continue functioning when one zone fails.

Zone-redundant Azure services automatically manage and mitigate failures to maintain their [service level agreements (SLAs)](https://azure.microsoft.com/support/legal/sla). Zone-redundancy offers effective recovery times of zero for zonal failure. If a single zone within a region becomes unavailable, you shouldn't expect to lose any data, and your workload should continue to run within the remaining available zones. Zone redundancy is configured at deployment time and is automatically managed by services throughout their lifetime, so there is no need to manage zone pinning or zonal deployments.

This architecture shows how to compose zone-redundant services into a solution that provides high availability and is resilient to zonal failures.

All of the Azure services in this architecture are either globally available or zone-redundant services. Azure Front Door, Azure AD and Azure DNS are globally available non-regional services that are resilient to zone and region-wide outages. All other services are zone-redundant.

### Potential use cases

Azure Red Hat OpenShift is a general purpose container orchestration service using Kubernetes suitable for a variety of use cases.

* Banking
* Stock trading
* E-commerce
* Social media
* Web applications
* Mobile applications
* Batch processing applications
* Media streaming
* Machine learning workloads

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Front Door

Azure Front Door is a global service offering resilience to zone and region failures.

* Use [Azure managed certificates][afd-certs] on all frontends to prevent certificate mis-configuration and expiration issues.
* Enable [Caching][afd-cache] on routes where appropriate to improve availability. Front Door's cache distributes your content to the Azure PoP (point of presence) edge nodes. In addition to improving your performance, caching reduces the load on your origin servers.
* Deploy Azure Front Door Premium and configure a [WAF policy][afd-waf] with a Microsoft-managed ruleset. Apply the policy to all custom domains. Use Prevention mode to mitigate web attacks that might cause an origin service to become unavailable.

### Red Hat OpenShift

An [Azure Red Hat OpenShift][aro] cluster is automatically deployed across three availability zones in Azure regions that support them. A cluster consists of three control-plane nodes and three or more worker nodes, each of which is spread across zones to improve redundancy.

* Ensure that the Azure region where Azure Red Hat OpenShift is to be deployed supports availability zones. For more information, see [Azure regions with availability zone support][az-regions].
* Ensure that all services that an Azure Red Had OpenShift cluster depends on support and are configured for zone redundancy. For more information, see [Azure services with availability zone support][az-ha-services].
* Remove state from containers and make use of Azure storage or database services instead.
* Set up multiple replicas in deployments, with appropriate disruption budget configuration, to continuously provide application service over disruptions like hardware failures in zones.
* Secure access to Azure Red Hat OpenShift so that only Front Door traffic is allowed. This ensures that requests are not able to bypass the Azure Front Door WAF (Web Application Firewall). For more information about restricting access to a specific Azure Front Door instance, see [Secure access to Azure Red Hat OpenShift with Azure Front Door][aro-afd].

### Container Registry

[Azure Container Registry][acr] supports zone redundancy making Azure Continer registry highly available and resilient to zone failure. Azure Container Registry also supports [geo-replication][acr-georeplica], which replicates the service across multiple regions. 

* Zone redundancy is a feature of the Premium container registry service tier. For information about registry service tiers and limits, see [Azure Container Registry service tiers][acr-tier].
* Ensure that [a region which a container registry is deployed in supports availability zones][az-regions].
* Once a container registry is deployed, its zone redundancy option cannot be changed. After deployment, zone redundancy option in the container registry cannot be disabled or enabled.
* ACR Tasks doesn't support availability zones yet.

For more information, see [Enable zone redundancy in Azure Container Registry for resiliency and high availability][acr-zoneredundancy] and [Use Azure Container Registry with Azure Red Hat OpenShift (ARO)][aro-acr].

### Cosmos DB

Enable [zone-redundancy in Azure Cosmos DB][cosmos-ha] when selecting a region to associate with your Azure Cosmos account.

* Enable zone-redundancy when adding the local read/write region to the Azure Cosmos account.
* [Enable continuous backups][cosmos-backup].
* [Configure private link for the Cosmos DB account][cosmos-pep]. Enabling the private endpoint will disable the public endpoint.
* Integrate the Private endpoint with an Azure Private DNS zone.

### Key Vault

Key Vault is automatically zone-redundant in any region where Availability zones are available. The Key Vault used in this architecture is deployed with a private endpoint enabled and public endpoint disabled. For more information about Private endpoints for Azure Key Vault, see [Integrate Key Vault with Azure Private Link][akv-pep].

### Azure DNS Private Zones

Integrate Private Endpoints with Azure DNS Private Zones to simplify DNS management. For more information, see [Azure Private Endpoint DNS configuration][pep-dns].

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](https://learn.microsoft.com/azure/architecture/framework/resiliency/overview).

* Define Pod resource requests and limits in application deployment manifests, and enforce with Azure Policy.
* Separate applications to dedicated machine sets based on specific requirements.

#### Availability

This reference architecture is designed to provide high availability through availability zone infrastructure. When implemented properly this architecture provides excellent availability for lower cost and operational overhead than other solutions. The risk of a zone failure in an Azure region is mitigated by this design, since zone-redundant services are designed to withstand a zonal failure while still operating within the defined SLA.

Regional failures are unlikely, but are possible. Region failures are where services are unavailable throughout all availability zones within a region. It's important to understand the types of risks that you mitigate by using multi-zone and multi-region architectures.

Mitigate the risk of region failure by combining this zone-redundant architecture with a multi-region architecture. You should understand how to plan your multi-region architecture to reduce your solution's recovery time if an entire region is unavailable.

Multi-region designs are more complex and often more expensive than multi-zone designs within a single region, but provide an opportunity to  further optimize availability and overall reliability.

> [!NOTE]
> You should perform a risk assessment to determine if a [multi-region architecture](https://learn.microsoft.com/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro) is required for your solution.

#### Resilience

Multi-zone designs based on availability zones offer levels of availability and resilience that meet or exceed the business requirements of most customers. However, for customers who want to replicate data to a secondary region for disaster recovery, the options you have available depend on the Azure services that you use.

For example, Azure Storage supports [object replication for block blobs][object-replication]. Azure data services like Cosmos DB also offer replication of data to other Azure regions with continuous backup. You can use these features to restore your solution if a disaster occurs. For more information, see [Continuous backup with point-in-time restore in Azure Cosmos DB][cosmos-continuous-backup].

#### Global services

Failures in global services like Azure Front Door and Azure Active Directory (Azure AD) are rare, but the impact can be high. Improve recovery by preparing and rehearsing runbooks to be used if failure occurs.

For example, Front Door service downtime may be reduced with a runbook that deploys an [Azure Application Gateway][appgw] and changes DNS records, redirecting traffic until Front Door service is restored.

See also this important guidance for increasing resilience to Azure AD failures by [building resilience in identity and access management infrastructure][aad-resilience].

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](https://learn.microsoft.com/azure/architecture/framework/security/overview).

* Consider deploying a private cluster
* Private endpoints are used on Azure services that don't need to be accessed from the public internet.
* All service-to-service communication in Azure is TLS (transport layer security) encrypted by default. Azure Front Door should be configured to accept HTTPS traffic only, and the minimum TLS version set.
* Managed identities are used for authenticating Azure service-to-service communication, where available. For more information about managed identities, see [What are managed identities for Azure resources?](https://learn.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview).
* To manage and protect secrets, certificates, and connection strings in your cluster, consider connecting Azure Red Hat OpenShift cluster to Azure Arc-enabled Kubernetes and use the Azure Key Vault Secrets Provider extension to fetch secrets.
* Configure Microsoft Defender for Containers supported via Arc enabled Kubernetes to secure clusters, containers, and applications. Also scan your images for vulnerabilities with Microsoft Defender or any other image scanning solution.
* Configure Azure AD integration to use Azure AD to authenticate users in your Azure Red Hat OpenShift cluster.
* Use Microsoft Defender for Containers supported via Arc enabled Kubernetes to secure clusters, containers, and applications. Also scan your images for vulnerabilities with Microsoft Defender or any other image scanning solution.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](https://learn.microsoft.com/azure/architecture/framework/cost/overview).

Zone-redundant architectures are less expensive than multi-region alternatives because services can be deployed in a single region. However, there are several cost implications that customers should be aware of:

* Some zone-redundant services incur charges for inter-zone bandwidth. For more information, see [Bandwidth pricing][bandwidth-pricing].
* Some services require a minimum number of instances or replicas to be deployed to achieve zone redundancy.
* Zone-redundant storage (ZRS) is priced differently than locally redundant storage (LRS). For more information, see [Storage pricing][storage-pricing].
* Private endpoints are mostly available on Premium Azure service SKUs. Private endpoints incur hourly and bandwidth (data) charges. For more information, see [Private Link pricing][pep-pricing].

Costs can be optimized by reserving resources in advance. Several services in this architecture are eligible for reserved capacity pricing. For more information about reserved capacity, see [Reservations][reservations].

An example bill of materials for this architecture can be viewed in the [Azure pricing calculator][bom].

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](https://learn.microsoft.com/azure/architecture/framework/devops/overview).

All Azure PaaS (platform as a service) services are integrated with [Azure Monitor][azmon]. Follow [Azure monitor best practices][azmon-bp] to:

* Build a [health model](https://learn.microsoft.com/azure/architecture/framework/mission-critical/mission-critical-health-modeling#video-define-a-health-model-for-your-mission-critical-workload) to quantify application health in the context of business requirements.
* Configure the right amount of log data collection.
* Create Azure Dashboards for "single pane of glass" views for operations teams.
* Create a successful alerting strategy.
* Integrate [Application Insights][insights] into apps to track application performance metrics.  
* Use an alerting system to provide notifications when things need direct action: Container Insights metric alerts or in-built Alerting UI.
* Be aware of ways to monitor and log Azure Red Hat OpenShift to gain insights into the health of your resources and to foresee potential issues.
* Review the Azure Red Hat OpenShift responsibility matrix to understand how responsibilities for clusters are shared between Microsoft, Red Hat, and customers.

Automate service deployments with [Bicep][bicep], a template language for deploying Infrastructure as Code.

[Continuously validate](https://learn.microsoft.com/azure/architecture/framework/mission-critical/mission-critical-deployment-testing#video-continuously-validate-your-mission-critical-workload) the workload to test the performance and resilience of the entire solution using services such as [Azure Load Testing][load-tests] and [Azure Chaos Studio][chaos].

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](https://learn.microsoft.com/azure/architecture/framework/scalability/overview).

This architecture can be highly optimized for performance and scale:

* Cache assets in Azure Front Door to distribute workloads to the Azure Microsoft Edge.
* Review [subscription limits and quotas][quotas] to ensure that services scale to demand.
* Monitor application performance using [Azure Monitor Application Insights][insights].
* Performance-test workloads to measure latency caused by cross-zone connections, if any.
* Azure Red Hat OpenShift has a rich operator ecosystem and should be used to perform and automate operational activities with efficiency and accuracy.
* Choose appropriate virtual machine sizes for your workloads, large enough to so you get the benefits of increased density, but not so large that your cluster can't handle the workload of a failing node.
* Use pod requests and limits to manage the compute resources within a cluster. Pod requests and limits inform the Kubernetes scheduler, which assigns compute resources to a pod. Restrict resource consumption in a project using limit ranges.
* Optimize the CPU and memory request values, and maximize the efficiency of the cluster resources using vertical pod autoscaler.
* Scale pods to meet demand using horizontal pod autoscaler.
* Define ClusterAutoScaler and MachineAutoScaler to scale machines when your cluster runs out of resources to support more deployments.

## Deploy this scenario

To deploy this reference architecture scenario see the [Azure Red Hat OpenShift landing zone accelerator](https://learn.microsoft.com/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator) and the associated [GitHub repository](https://github.com/Azure/ARO-Landing-Zone-Accelerator).

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal author:

* [Hiro Tarusawa](https://www.linkedin.com/in/hiro-tarusawa-bb29a2137/) | FastTrack for Azure Customer Engineer
* [Daniel Mossberg](https://www.linkedin.com/in/danielmossberg/) | FastTrack for Azure Customer Engineer

Other contributor:

* [Daniel Larsen](https://www.linkedin.com/in/daniellarsennz) | FastTrack for Azure Customer Engineer
* [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji) | FastTrack for Azure Customer Engineer

_To see non-public LinkedIn profiles, sign in to LinkedIn._

## Next steps

* [Azure services that support availability zones][az-services]
* [Azure regions with availability zones][az-regions]
* [Find an availability zone region near you][region-roadmap]
* [Microsoft Azure Well-Architected Framework - Reliability][learn-ha]
* [Microsoft Azure Well-Architected Framework - Mission-critical workloads](https://learn.microsoft.com/azure/architecture/framework/mission-critical/mission-critical-overview)

## Related resources

* [Mission-critical baseline architecture](https://learn.microsoft.com/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro)
* [Design principles for mission-critical workloads](https://learn.microsoft.com/azure/architecture/framework/mission-critical/mission-critical-design-principles)

<!-- links -->
[aad]:https://azure.microsoft.com/services/active-directory/
[aad-b2c]:https://azure.microsoft.com/services/active-directory/external-identities/b2c/
[acr]:https://azure.microsoft.com/products/container-registry/
[acr-georeplica]:https://learn.microsoft.com/azure/container-registry/container-registry-geo-replication
[acr-tier]:https://learn.microsoft.com/azure/container-registry/container-registry-skus
[acr-zoneredundancy]:https://learn.microsoft.com/azure/container-registry/zone-redundancy
[afd]:https://azure.microsoft.com/services/frontdoor/
[afd-cache]:https://learn.microsoft.com/azure/frontdoor/front-door-caching?pivots=front-door-standard-premium
[afd-certs]:https://learn.microsoft.com/azure/frontdoor/standard-premium/how-to-configure-https-custom-domain#azure-managed-certificates
[afd-waf]:https://learn.microsoft.com/azure/web-application-firewall/afds/afds-overview
[akv]:https://azure.microsoft.com/services/key-vault/
[akv-pep]:https://learn.microsoft.com/azure/key-vault/general/private-link-service?tabs=portal
[apim]:https://azure.microsoft.com/products/api-management/
[apim-zr]:https://learn.microsoft.com/azure/availability-zones/migrate-api-mgt
[appgw]:https://azure.microsoft.com/products/application-gateway/#overview
[aro]:https://azure.microsoft.com/products/openshift/#overview
[aro-acr]:https://learn.microsoft.com/ja-jp/azure/openshift/howto-use-acr-with-aro
[aro-afd]:https://learn.microsoft.com/azure/openshift/howto-secure-openshift-with-front-door
[az-ha-services]:https://docs.microsoft.com/azure/availability-zones/az-region#azure-services-with-availability-zone-support
[az-regions]:https://docs.microsoft.com/azure/availability-zones/az-region#azure-regions-with-availability-zone-support
[az-services]:https://docs.microsoft.com/azure/availability-zones/az-region
[az-vm]:https://azure.microsoft.com/products/virtual-machines/
[azmon]:https://azure.microsoft.com/services/monitor/
[azs]:https://azure.microsoft.com/global-infrastructure/availability-zones/
[bandwidth-pricing]:https://azure.microsoft.com/pricing/details/bandwidth/
[chaos]:https://azure.microsoft.com/services/chaos-studio/
[cosmos-backup]:https://learn.microsoft.com/azure/cosmos-db/provision-account-continuous-backup
[cosmos-db]:https://azure.microsoft.com/services/cosmos-db/
[cosmos-ha]:https://learn.microsoft.com/azure/cosmos-db/high-availability
[cosmos-pep]:https://learn.microsoft.com/azure/cosmos-db/how-to-configure-private-endpoints
[ddosp]:https://learn.microsoft.com/azure/ddos-protection/ddos-protection-overview
[ha-zoneredundant-webapp]:https://learn.microsoft.com/azure/architecture/reference-architectures/app-service-web-app/zone-redundant#scenario-details
[insights]:https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview
[load-tests]:https://azure.microsoft.com/services/load-testing/
[openshift-in-azure]:https://learn.microsoft.com/azure/virtual-machines/linux/openshift-get-started
[openshift-jboss]:https://learn.microsoft.com/azure/openshift/howto-deploy-java-jboss-enterprise-application-platform-app
[openshift-serverless]:https://learn.microsoft.com/azure/openshift/howto-deploy-with-serverless
[openshift-websphere]:https://learn.microsoft.com/azure/openshift/howto-deploy-java-liberty-app?tabs=with-mysql-devc%2Cwith-mysql-image%2Cwith-mysql-deploy-console
[pep-dns]:https://learn.microsoft.com/azure/private-link/private-endpoint-dns
[pep-pricing]:https://azure.microsoft.com/pricing/details/private-link/
[peps]:https://docs.microsoft.com/azure/private-link/private-endpoint-overview
[private-dns]:https://docs.microsoft.com/azure/dns/private-dns-overview
[region-roadmap]:https://azure.microsoft.com/global-infrastructure/geographies/
[sla]:https://azure.microsoft.com/support/legal/sla/
[vnet-integration]:https://docs.microsoft.com/azure/app-service/overview-vnet-integration#regional-virtual-network-integration
[storage-pricing]:https://azure.microsoft.com/pricing/details/storage/blobs/
[reservations]:https://azure.microsoft.com/reservations/
[aad-resilience]:https://learn.microsoft.com/azure/active-directory/fundamentals/resilience-in-infrastructure
[azmon-bp]:https://learn.microsoft.com/azure/azure-monitor/best-practices
[bicep]:https://learn.microsoft.com/azure/azure-resource-manager/bicep/overview?tabs=bicep
[cosmos-continuous-backup]:https://learn.microsoft.com/azure/cosmos-db/continuous-backup-restore-introduction
[quotas]:https://learn.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits
[learn-ha]:https://learn.microsoft.com/learn/modules/azure-well-architected-reliability/
[object-replication]:https://learn.microsoft.com/azure/storage/blobs/object-replication-overview

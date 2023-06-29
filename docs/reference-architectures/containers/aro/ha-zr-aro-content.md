<!-- cSpell:ignore CNAME -->

This article provides a comprehensive overview of a web app workload on Azure Red Hat OpenShift in a zone-redundant configuration. [Zone-redundant services][az-ha-services] replicate your services and data across availability zones to protect them from single points of failure and provide high availability.

Before you build a production environment with Azure Red Hat OpenShift, read [Azure Red Hat OpenShift landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator).

## Architecture

:::image type="content" source="./images/openshift-zonal-architecture.png" alt-text="Diagram that shows the architecture for a web application with high availability." lightbox="./images/openshift-zonal-architecture.png" border="false":::

_Download a [Visio file](https://arch-center.azureedge.net/openshift-zonal-architecture.vsdx) of this architecture._

### Workflow

* A user sends a request to Azure.
* Azure Front Door receives the request and routes the request to a web application that's hosted on Azure Red Hat OpenShift.
* The web application runs the request by using Azure Key Vault, Azure Cosmos DB, and Azure Container Registry.
* The web application sends a response back to the user.

### Components

* [Azure Active Directory (Azure AD)][aad] or [Azure AD B2C][aad-b2c] authenticates users. The browser performs DNS lookups to resolve addresses to Azure Front Door.
* [Azure Front Door][afd] is the public interface for all internet requests. It acts as a global HTTP reverse proxy and cache for back-end services. Azure Front Door provides features that enhance the security and performance of your application, like protection from layer 4 distributed denial-of-service (DDoS) attacks.
* [Azure Red Hat OpenShift][aro] is the Kubernetes-based container orchestrator that hosts the API applications and services, and provides an interface for back-end services.
* [Container Registry][acr] supports Docker and Open Container Initiative (OCI) compliant container images. Container Registry supports zone redundancy, which makes it highly available and resilient to zone failure. It also supports [geo-replication][acr-georeplica], which replicates the service across multiple regions.
* Azure Red Hat OpenShift uses [virtual network integration][vnet-integration] to connect to back-end services over a private virtual network.
* [Azure Cosmos DB][cosmos-db] provides NoSQL document databases for front-end services.
* [Private endpoints][peps] enable connections to back-end Azure services from private virtual networks and allow you to disable the public endpoints on these services.
* [Azure Private DNS][private-dns] configures and updates the DNS records that the private endpoint services require.
* [Key Vault][akv] securely stores secrets and certificates that are accessed by Azure services.
* [Azure Monitor][azmon] and [Application Insights][insights] collect service logs and application performance metrics for observability.

### Alternatives

* You can use Azure AD or Azure AD B2C as an identity provider in this scenario. Azure AD is for internal applications and business-to-business (B2B) scenarios. Azure AD B2C is for business-to-consumer (B2C) scenarios.
* Azure-managed DNS is recommended, but you can use your own DNS provider.
* You can use [Azure Application Gateway][appgw] instead of Azure Front Door if most of your users are located close to the Azure region that hosts your workload and if you don't need content caching. Use [Azure DDoS Protection][ddosp] to protect internet-facing Application Gateway services.
* Deploy a premium [Azure API Management][apim] instance with zone-redundancy as an alternative for hosting front-end APIs, back-end APIs, or both. For more information about API Management zone-redundancy, see [Migrate Azure API Management to availability zone support][apim-zr].
* You can use OpenShift Container Platform or Origin Community Distribution of Kubernetes (OKD) on [Azure Virtual Machines][az-vm] instead of Azure Red Hat OpenShift. OpenShift Container Platform or OKD are infrastructure-as-a-service (IaaS) alternatives to a fully platform-managed service, like Azure Red Hat OpenShift. For more information, see [Azure Red Hat OpenShift][openshift-in-azure].

## Scenario details

This architecture describes how to compose zone-redundant services into a solution that provides high availability and is resilient to zonal failures.

Availability zones are separate physical locations in each Azure region. Availability zones spread a solution across multiple independent zones in a region, which allows an application to continue functioning when one zone fails. This architecture builds on the [availability zones infrastructure][azs] that's found in many regions. For a list of regions that support Azure availability zones, see [Azure regions with availability zones][az-regions].

When hosting platforms are at scale, it's often difficult to keep them highly available. High availability has historically required complex and expensive multi-region deployments with data-consistency and high-performance tradeoffs. [Availability zones][azs] resolve many of these issues. Most mainstream Azure services and many specialized Azure services provide support for availability zones. All Azure services in this architecture are zone-redundant, which simplifies the deployment and management. For more information, see [Azure services that support availability zones][az-services].

To maintain the [service-level agreements (SLAs)][sla], zone-redundant Azure Red Hat OpenShift manages and mitigates failures, including zone failures. Zone redundancy provides a recovery time of zero for zone failure. If a single zone in a region is unavailable, you don't lose any data, and your workload continues to run. Zone redundancy is configured at deployment time and is managed by services, so you don't need to manage zone pinning or zonal deployments.

In this architecture, an [Azure Red Hat OpenShift][aro] cluster is deployed across three availability zones in Azure regions that support them. A cluster consists of three control plane nodes and three or more worker nodes. To improve redundancy, the nodes are spread across the zones.

Azure Front Door, Azure AD, and Azure DNS are globally available services that are resilient to zone and region-wide outages. All other services in this architecture are zone-redundant.

### Potential use cases

Azure Red Hat OpenShift is a container orchestration service that uses Kubernetes. It's suitable for many use cases, such as:

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

The following recommendations apply to most scenarios.

### Azure Front Door

* Use [Azure-managed certificates][afd-certs] on all front-end applications to prevent certificate misconfiguration and expiration issues.
* Enable [caching][afd-cache] on routes to improve availability. The Azure Front Door cache distributes your content to the Azure point-of-presence (POP) edge nodes. Caching reduces the load on origin servers and improves performance.
* Deploy Azure Front Door Premium and configure a [WAF policy][afd-waf] with a Microsoft-managed ruleset. Apply the policy to all custom domains. Use prevention mode to mitigate web attacks that might cause an origin-service failure.

### Azure Red Hat OpenShift

* Ensure that the Azure region where Azure Red Hat OpenShift is deployed supports availability zones. For more information, see [Azure regions with availability zone support][az-regions].
* An Azure Red Hat OpenShift cluster depends on some services. Ensure that those services support and are configured for zone redundancy. For more information, see [Azure services with availability zone support][az-ha-services].
* Remove the state from containers, and use Azure storage or database services instead.
* Set up multiple replicas in deployments with appropriate disruption budget configuration to continuously provide application service despite disruptions, like hardware failures in zones.
* Secure access to Azure Red Hat OpenShift. To ensure that requests can't bypass the Azure Front Door WAF (Web Application Firewall), allow only Azure Front Door traffic. For more information about restricting access to a specific Azure Front Door instance, see [Secure access to Azure Red Hat OpenShift with Azure Front Door][aro-afd].

### Container Registry

* The Premium Container Registry service tier offers zone redundancy. For information about registry service tiers and limits, see [Container Registry service tiers][acr-tier].
* [The region where a container registry is deployed must support availability zones][az-regions].
* After a container registry is deployed, you can't change the zone redundancy option.
* ACR Tasks doesn't support availability zones.

For more information, see [Enable zone redundancy in Container Registry for resiliency and high availability][acr-zoneredundancy] and [Use Container Registry with Azure Red Hat OpenShift][aro-acr].

### Azure Cosmos DB

* Enable [zone redundancy][cosmos-ha] when you add the local read/write region to your Azure Cosmos DB account.
* [Enable continuous backups][cosmos-backup].
* [Configure Azure Private Link for your Azure Cosmos DB account][cosmos-pep]. When you enable the private endpoint, you disable the public endpoint.
* Integrate the private endpoint with a private Azure DNS zone.

### Key Vault

Key Vault is zone-redundant in any region where availability zones are available. In this architecture, Key Vault is deployed with a private endpoint enabled and a public endpoint disabled. For more information about private endpoints for Key Vault, see [Integrate Key Vault with Private Link][akv-pep].

### Private Azure DNS zones

To simplify DNS management, integrate private endpoints with private Azure DNS zones. For more information, see [Azure private endpoint DNS configuration][pep-dns].

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](https://learn.microsoft.com/azure/architecture/framework/resiliency/overview).

This architecture ensures reliability by providing availability, resilience, and dependable global service features.

#### Availability

When the availability zone infrastructure is implemented properly, this architecture provides excellent availability for lower cost and lower operational overhead than other solutions. This architecture mitigates the risk of a zone failure in an Azure region because zone-redundant services withstand the failure while still operating within the defined SLA.

Regional failures are unlikely but possible. In a regional failure, services are unavailable throughout all availability zones within a region. Combine this zone-redundant architecture with a multi-region architecture to mitigate the risk of region failure. Plan your multi-region architecture to reduce the recovery time if an entire region is unavailable.

Multi-region designs are more complex and often more expensive than multi-zone designs in a single region, but multi-region designs provide an opportunity to further optimize availability and overall reliability.

> [!NOTE]
> Perform a risk assessment to determine if your solution requires a [multi-region architecture](https://learn.microsoft.com/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro).

#### Resilience

Multi-zone designs that are based on availability zones offer availability and resilience that meets or exceeds the business requirements of most organizations. But if you want to replicate data to a secondary region for disaster recovery, your options depend on the Azure services that you use.

For example, Azure Storage supports [object replication for block blobs][object-replication]. Azure data services, like Azure Cosmos DB, offer data replication to other Azure regions that have continuous backup. You can use these features to restore your solution if a disaster occurs. For more information, see [Continuous backup with point-in-time restore in Azure Cosmos DB][cosmos-continuous-backup].

#### Global services

Failures in global services, like Azure Front Door and Azure AD, are rare, but the effect of a failure can be high. To improve recovery if a failure occurs, prepare and rehearse runbooks.

For example, you can reduce Azure Front Door downtime by using a runbook to deploy [Azure Application Gateway][appgw] and change DNS records to redirect traffic until Azure Front Door is restored.

For more information, see [Building resilience in identity and access management infrastructure][aad-resilience].

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](https://learn.microsoft.com/azure/architecture/framework/security/overview).

* Consider deploying a private cluster.
* Use private endpoints on Azure services that aren't accessed from the public internet.
* By default, all service-to-service communication in Azure is Transport Layer Security (TLS) encrypted. Configure Azure Front Door to accept HTTPS traffic only, and set the minimum TLS version.
* Managed identities authenticate Azure service-to-service communication where it's available. For more information, see [What are managed identities for Azure resources?](https://learn.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview)
* To manage and protect secrets, certificates, and connection strings in your cluster, connect the Azure Red Hat OpenShift cluster to Azure Arc-enabled Kubernetes. Use the Key Vault Secrets Provider extension to fetch secrets.
* Configure Microsoft Defender for Containers to provide security for clusters, containers, and applications. Defender for Containers is supported via Azure Arc-enabled Kubernetes. Scan your images for vulnerabilities with Microsoft Defender or another image scanning solution.
* Configure Azure AD integration to use Azure AD to authenticate users in your Azure Red Hat OpenShift cluster.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](https://learn.microsoft.com/azure/architecture/framework/cost/overview).

Zone-redundant architectures are less expensive than multi-region alternatives because services are deployed in a single region. But there are several cost implications to be aware of:

* Some zone-redundant services incur charges for inter-zone bandwidth. For more information, see [Bandwidth pricing][bandwidth-pricing].
* Some services require a minimum number of instances or replicas to be deployed to achieve zone redundancy.
* Zone-redundant storage (ZRS) and locally redundant storage (LRS) have different pricing. For more information, see [Storage pricing][storage-pricing].
* Private endpoints are mostly available on premium Azure service SKUs. Private endpoints incur hourly charges and bandwidth charges. For more information, see [Private Link pricing][pep-pricing].

Optimize costs by reserving resources in advance. Many services in this architecture are eligible for reserved-capacity pricing. For more information, see [Reservations][reservations].

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate costs.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

All Azure services that are platform as a service (PaaS) are integrated with [Azure Monitor][azmon]. Follow [Azure Monitor best practices][azmon-bp] to:

* Build a [health model](/azure/architecture/framework/mission-critical/mission-critical-health-modeling#video-define-a-health-model-for-your-mission-critical-workload) to quantify application health in the context of business requirements.
* Configure the proper amount of log data collection.
* Create Azure dashboards to unify data into a single view for operations teams.
* Create a successful alerting strategy.
* Integrate [Application Insights][insights] into apps to track application performance metrics.  
* To provide notifications when direct action is needed, use an alerting system, like Container insights metric alerts or the Azure Red Hat OpenShift alerting UI.
* Consider various methods for monitoring and logging Azure Red Hat OpenShift to gain insights into the health of your resources and to foresee potential issues.
* Review the Azure Red Hat OpenShift responsibility matrix to understand how Microsoft, Red Hat, and customers share responsibilities for clusters.
* Automate service deployments with [Bicep][bicep], a template language for deploying infrastructure as code (IaC).
* [Continuously validate](/azure/architecture/framework/mission-critical/mission-critical-deployment-testing#continuous-validation-and-testing) the workload to test the performance and resilience of the entire solution by using services, such as [Azure Load Testing][load-tests] and [Azure Chaos Studio][chaos].

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Overview of the performance efficiency pillar](/azure/architecture/framework/scalability/overview).

* Cache assets in Azure Front Door to distribute workloads to edge locations.
* Review [subscription limits and quotas][quotas] to ensure that services scale to demand.
* Monitor application performance by using [Application Insights][insights].
* Performance test workloads to measure any latency that's caused by cross-zone connections.
* Choose appropriate virtual machine sizes for your workloads. Choose a size that's large enough to get the benefits of increased density but not so large that your cluster can't handle the workload of a failing node.
* Use pod requests and limits to manage the compute resources within a cluster. Pod requests and limits inform the Kubernetes scheduler, which assigns compute resources to a pod. Restrict resource consumption in a project by using limit ranges.
* Define pod resource requests and limits in the application deployment manifests, and enforce them with Azure Policy.
* Optimize the CPU and memory request values, and maximize the efficiency of the cluster resources by using the Vertical Pod Autoscaler.
* Scale pods to meet demand by using the Horizontal Pod Autoscaler.
* Define ClusterAutoScaler and MachineAutoScaler to scale machines when your cluster runs out of resources to support more deployments.

## Deploy this scenario

To deploy this architecture, see the [Azure Red Hat OpenShift landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator) and the associated [GitHub repository](https://github.com/Azure/ARO-Landing-Zone-Accelerator).

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal authors:

* [Daniel Mossberg](https://www.linkedin.com/in/danielmossberg/) | FastTrack for Azure Customer Engineer
* [Hiro Tarusawa](https://www.linkedin.com/in/hiro-tarusawa-bb29a2137/) | FastTrack for Azure Customer Engineer

Other contributors:

* [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji) | FastTrack for Azure Customer Engineer
* [Daniel Larsen](https://www.linkedin.com/in/daniellarsennz) | FastTrack for Azure Customer Engineer

_To see non-public LinkedIn profiles, sign in to LinkedIn._

## Next steps

* [Azure services that support availability zones][az-services]
* [Azure regions with availability zones][az-regions]
* [Find an availability zone region near you][region-roadmap]
* [Azure Well-Architected Framework - Reliability training module][learn-ha]

## Related resources

* [Design principles for mission-critical workloads][mission]
* [Azure Well-Architected Framework - Mission-critical workloads][WAF-mission]
* [Mission-critical baseline architecture][mission-arch]

<!-- links -->
[aad]:https://azure.microsoft.com/services/active-directory/
[aad-b2c]:https://azuremarketplace.microsoft.com/marketplace/apps/amestofortytwoas1653635920536.b2c
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
[aro-acr]:https://learn.microsoft.com/azure/openshift/howto-use-acr-with-aro
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
[mission]:/azure/architecture/framework/mission-critical/mission-critical-design-principles
[mission-arch]:/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro
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
[WAF-mission]:/azure/architecture/framework/mission-critical/mission-critical-overview

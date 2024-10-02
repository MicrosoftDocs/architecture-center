<!-- cSpell:ignore CNAME -->

This article provides a comprehensive overview of a web app workload on Azure Red Hat OpenShift in a zone-redundant configuration. [Zone-redundant services](/azure/availability-zones/az-region#azure-services-with-availability-zone-support) replicate your services and data across availability zones to protect them from single points of failure and provide high availability.

Before you build a production environment with Azure Red Hat OpenShift, read [Azure Red Hat OpenShift landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator).

## Architecture

:::image type="content" source="./images/openshift-zonal-architecture.png" alt-text="Diagram that shows the architecture for a web application with high availability." lightbox="./images/openshift-zonal-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/openshift-zonal-architecture.vsdx) of this architecture.*

### Workflow

* A user sends a request to Azure.
* Azure Front Door receives the request and routes the request to a web application that's hosted on Azure Red Hat OpenShift.
* The web application runs the request by using Azure Key Vault, Azure Cosmos DB, and Azure Container Registry.
* The web application sends a response back to the user.

### Components

* [Microsoft Entra ID](https://www.microsoft.com/security/business/identity-access/microsoft-entra-id) or [Azure AD B2C](https://azure.microsoft.com/products/active-directory-b2c/) authenticates users. The browser performs DNS lookups to resolve addresses to Azure Front Door. In this architecture, Microsoft Entra ID provides customers with secure, granular access to external resources.
* [Azure Front Door](https://azure.microsoft.com/products/frontdoor/) is the public interface for all internet requests. It acts as a global HTTP reverse proxy and cache for back-end services. In this architecture, Azure Front Door enhances the security and performance of your application, like protection from layer 4 distributed denial-of-service (DDoS) attacks. For more information, see the [Well-Architected Framework perspective on Azure Front Door](/azure/well-architected/service-guides/azure-front-door).
* [Azure Red Hat OpenShift](https://azure.microsoft.com/products/openshift/) is the Kubernetes-based container orchestrator that hosts the API applications and services, and provides an interface for back-end services. Azure Red Hat OpenShift serves as the primary compute platform in this architecture. 
* [Container Registry](https://azure.microsoft.com/products/container-registry/) supports Docker and Open Container Initiative (OCI) compliant container images. Container Registry supports zone redundancy, which makes it highly available and resilient to zone failure. It also supports [geo-replication](/azure/container-registry/container-registry-geo-replication), which replicates the service across multiple regions. In this architecture, Container Registry provides applications with secure access to container images. 
* Azure Red Hat OpenShift uses [virtual network integration](/azure/app-service/overview-vnet-integration#regional-virtual-network-integration) to connect to back-end services over a private virtual network. Virtual network integration provides a secure network with Azure Red Hat OpenShift and other Azure services in this architecture.
* [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db/) provides NoSQL document databases for front-end services. Azure Cosmos DB stores user data in this architecture. For more information, see [Well-Architected Framework review – Azure Cosmos DB for NoSQL](/azure/well-architected/service-guides/cosmos-db).
* [Private endpoints](/azure/private-link/private-endpoint-overview) enable connections to back-end Azure services from private virtual networks and allow you to disable the public endpoints on these services. In this architecture, private endpoints with virtual network integration provide a secure network for Azure Red Hat OpenShift and other Azure services.   
* [Azure Private DNS](/azure/dns/private-dns-overview) configures and updates the DNS records that the private endpoint services require. In this architecture, Azure Private DNS is used for name resolution in private networks.
* [Key Vault](https://azure.microsoft.com/products/key-vault/) securely stores secrets and certificates that are accessed by Azure services. In this architecture, Azure Key Vault securely stores secrets for the applications running on Azure Red Hat OpenShift.  
* [Azure Monitor](https://azure.microsoft.com/products/monitor/) and [Application Insights](/azure/azure-monitor/app/app-insights-overview) collect service logs and application performance metrics for observability. In this architecture, Azure Monitor and Application insights collect, save, and show logs and metrics.  

### Alternatives

* You can use Microsoft Entra ID or Azure AD B2C as an identity provider in this scenario. Microsoft Entra ID is for internal applications and business-to-business (B2B) scenarios. Azure AD B2C is for business-to-consumer (B2C) scenarios.
* Azure-managed DNS is recommended, but you can use your own DNS provider.
* You can use [Azure Application Gateway](https://azure.microsoft.com/products/application-gateway/) instead of Azure Front Door if most of your users are located close to the Azure region that hosts your workload and if you don't need content caching. Use [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) to protect internet-facing Application Gateway services.
* Deploy a premium [Azure API Management](https://azure.microsoft.com/products/api-management/) instance with zone-redundancy as an alternative for hosting front-end APIs, back-end APIs, or both. For more information about API Management zone-redundancy, see [Migrate Azure API Management to availability zone support](/azure/reliability/migrate-api-mgt).
* You can use OpenShift Container Platform or Origin Community Distribution of Kubernetes (OKD) on [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines/) instead of Azure Red Hat OpenShift. OpenShift Container Platform or OKD are infrastructure-as-a-service (IaaS) alternatives to a fully platform-managed service, like Azure Red Hat OpenShift. For more information, see [Azure Red Hat OpenShift](/azure/openshift/intro-openshift).

## Scenario details

This architecture describes how to compose zone-redundant services into a solution that provides high availability and is resilient to zonal failures.

Availability zones are separate physical locations in each Azure region. Availability zones spread a solution across multiple independent zones in a region, which allows an application to continue functioning when one zone fails. This architecture builds on the [availability zones infrastructure](https://azure.microsoft.com/explore/global-infrastructure/availability-zones/) that's found in many regions. For a list of regions that support Azure availability zones, see [Azure regions with availability zones](/azure/reliability/availability-zones-service-support#azure-regions-with-availability-zone-support).

When hosting platforms are at scale, it's often difficult to keep them highly available. High availability has historically required complex and expensive multi-region deployments with data-consistency and high-performance tradeoffs. [Availability zones](https://azure.microsoft.com/explore/global-infrastructure/availability-zones/) resolve many of these issues. Most mainstream Azure services and many specialized Azure services provide support for availability zones. All Azure services in this architecture are zone-redundant, which simplifies the deployment and management. For more information, see [Azure services that support availability zones](/azure/reliability/availability-zones-service-support).

To maintain the [service-level agreements (SLAs)](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services), zone-redundant Azure Red Hat OpenShift manages and mitigates failures, including zone failures. Zone redundancy provides a recovery time of zero for zone failure. If a single zone in a region is unavailable, you don't lose any data, and your workload continues to run. Zone redundancy is configured at deployment time and is managed by services, so you don't need to manage zone pinning or zonal deployments.

In this architecture, an [Azure Red Hat OpenShift](https://azure.microsoft.com/products/openshift/) cluster is deployed across three availability zones in Azure regions that support them. A cluster consists of three control plane nodes and three or more worker nodes. To improve redundancy, the nodes are spread across the zones.

Azure Front Door, Microsoft Entra ID, and Azure DNS are globally available services that are resilient to zone and region-wide outages. All other services in this architecture are zone-redundant.

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

* Use [Azure-managed certificates](/azure/frontdoor/standard-premium/how-to-configure-https-custom-domain?tabs=powershell#azure-managed-certificates) on all front-end applications to prevent certificate misconfiguration and expiration issues.
* Enable [caching](/azure/frontdoor/front-door-caching?pivots=front-door-standard-premium) on routes to improve availability. The Azure Front Door cache distributes your content to the Azure point-of-presence (POP) edge nodes. Caching reduces the load on origin servers and improves performance.
* Deploy Azure Front Door Premium and configure a [web application firewall (WAF) policy](/azure/web-application-firewall/afds/afds-overview) with a Microsoft-managed ruleset. Apply the policy to all custom domains. Use prevention mode to mitigate web attacks that might cause an origin-service failure.

### Azure Red Hat OpenShift

* Ensure that the Azure region where Azure Red Hat OpenShift is deployed supports availability zones. For more information, see [Azure regions with availability zone support](/azure/reliability/availability-zones-service-support#azure-regions-with-availability-zone-support).
* An Azure Red Hat OpenShift cluster depends on some services. Ensure that those services support and are configured for zone redundancy. For more information, see [Azure services with availability zone support](/azure/availability-zones/az-region#azure-services-with-availability-zone-support).
* Remove the state from containers, and use Azure storage or database services instead.
* Set up multiple replicas in deployments with appropriate disruption budget configuration to continuously provide application service despite disruptions, like hardware failures in zones.
* Secure access to Azure Red Hat OpenShift. To ensure that requests can't bypass the Azure Front Door WAF, allow only Azure Front Door traffic. For more information about restricting access to a specific Azure Front Door instance, see [Secure access to Azure Red Hat OpenShift with Azure Front Door](/azure/openshift/howto-secure-openshift-with-front-door).

### Container Registry

* The Premium Container Registry service tier offers zone redundancy. For information about registry service tiers and limits, see [Container Registry service tiers](/azure/container-registry/container-registry-skus).
* [The region where a container registry is deployed must support availability zones](/azure/reliability/availability-zones-service-support#azure-regions-with-availability-zone-support).
* After a container registry is deployed, you can't change the zone redundancy option.
* ACR Tasks doesn't support availability zones.

For more information, see [Enable zone redundancy in Container Registry for resiliency and high availability](/azure/container-registry/zone-redundancy) and [Use Container Registry with Azure Red Hat OpenShift](/azure/openshift/howto-use-acr-with-aro).

### Azure Cosmos DB

* Enable [zone redundancy](/azure/reliability/reliability-cosmos-db-nosql) when you add the local read/write region to your Azure Cosmos DB account.
* [Enable continuous backups](/azure/cosmos-db/provision-account-continuous-backup).
* [Configure Azure Private Link for your Azure Cosmos DB account](/azure/cosmos-db/how-to-configure-private-endpoints). When you enable the private endpoint, you disable the public endpoint.
* Integrate the private endpoint with a private Azure DNS zone.

### Key Vault

Key Vault is zone-redundant in any region where availability zones are available. In this architecture, Key Vault is deployed with a private endpoint enabled and a public endpoint disabled. For more information about private endpoints for Key Vault, see [Integrate Key Vault with Private Link](/azure/key-vault/general/private-link-service).

### Private Azure DNS zones

To simplify DNS management, integrate private endpoints with private Azure DNS zones. For more information, see [Azure private endpoint DNS configuration](/azure/private-link/private-endpoint-dns).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

This architecture ensures reliability by providing availability, resilience, and dependable global service features.

#### Availability

When the availability zone infrastructure is implemented properly, this architecture provides excellent availability for lower cost and lower operational overhead than other solutions. This architecture mitigates the risk of a zone failure in an Azure region because zone-redundant services withstand the failure while still operating within the defined SLA.

Regional failures are unlikely but possible. In a regional failure, services are unavailable throughout all availability zones within a region. Combine this zone-redundant architecture with a multi-region architecture to mitigate the risk of region failure. Plan your multi-region architecture to reduce the recovery time if an entire region is unavailable.

Multi-region designs are more complex and often more expensive than multi-zone designs in a single region, but multi-region designs provide an opportunity to further optimize availability and overall reliability.

> [!NOTE]
> Perform a risk assessment to determine if your solution requires a [multi-region architecture](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro).

#### Resilience

Multi-zone designs that are based on availability zones offer availability and resilience that meets or exceeds the business requirements of most organizations. But if you want to replicate data to a secondary region for disaster recovery, your options depend on the Azure services that you use.

For example, Azure Storage supports [object replication for block blobs](/azure/storage/blobs/object-replication-overview). Azure data services, like Azure Cosmos DB, offer data replication to other Azure regions that have continuous backup. You can use these features to restore your solution if a disaster occurs. For more information, see [Continuous backup with point-in-time restore in Azure Cosmos DB](/azure/cosmos-db/continuous-backup-restore-introduction).

#### Global services

Failures in global services, like Azure Front Door and Microsoft Entra ID, are rare, but the effect of a failure can be high. To improve recovery if a failure occurs, prepare and rehearse runbooks.

For example, you can reduce Azure Front Door downtime by using a runbook to deploy [Azure Application Gateway](https://azure.microsoft.com/products/application-gateway/) and change DNS records to redirect traffic until Azure Front Door is restored.

For more information, see [Building resilience in identity and access management infrastructure](/entra/architecture/resilience-in-infrastructure).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

* Consider deploying a [private cluster](/azure/openshift/howto-create-private-cluster-4x).
* Use private endpoints on Azure services that aren't accessed from the public internet.
* By default, all service-to-service communication in Azure is Transport Layer Security (TLS) encrypted. Configure Azure Front Door to accept HTTPS traffic only, and set the minimum TLS version.
* Managed identities authenticate Azure service-to-service communication where it's available. For more information, see [What are managed identities for Azure resources?](/azure/active-directory/managed-identities-azure-resources/overview)
* To manage and protect secrets, certificates, and connection strings in your cluster, [connect the Azure Red Hat OpenShift cluster to Azure Arc-enabled Kubernetes](https://cloud.redhat.com/experts/aro/azure-arc-integration/). Use the Key Vault Secrets Provider extension to fetch secrets.
* Configure Microsoft Defender for Containers to provide security for clusters, containers, and applications. Defender for Containers is supported via Azure Arc-enabled Kubernetes. Scan your images for vulnerabilities with Microsoft Defender or another image scanning solution.
* Configure Microsoft Entra integration to use Microsoft Entra ID to authenticate users (for example, SRE, SecOps, or application developers) in your Azure Red Hat OpenShift cluster.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Zone-redundant architectures are less expensive than multi-region alternatives because services are deployed in a single region. But there are several cost implications to be aware of:

* Some services require a minimum number of instances or replicas to be deployed to achieve zone redundancy.
* Zone-redundant storage (ZRS) and locally redundant storage (LRS) have different pricing. For more information, see [Storage pricing](https://azure.microsoft.com/pricing/details/storage/blobs/).
* Private endpoints are mostly available on premium Azure service SKUs. Private endpoints incur hourly charges and bandwidth charges. For more information, see [Private Link pricing](https://azure.microsoft.com/pricing/details/private-link/).

Optimize costs by reserving resources in advance. Many services in this architecture are eligible for reserved-capacity pricing. For more information, see [Reservations](https://azure.microsoft.com/pricing/reservations/).

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate costs.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/well-architected/operational-excellence/).

All Azure services that are platform as a service (PaaS) are integrated with [Azure Monitor](https://azure.microsoft.com/products/monitor/). Follow Azure Monitor best practices ([reliability](/azure/azure-monitor/best-practices-reliability), [security](/azure/azure-monitor/best-practices-security), [cost optimization](/azure/azure-monitor/best-practices-cost), [operational excellence](/azure/azure-monitor/best-practices-operation), and [performance efficiency](/azure/azure-monitor/best-practices-performance)) to:

* Build a [health model](/azure/well-architected/mission-critical/mission-critical-health-modeling#video-define-a-health-model-for-your-mission-critical-workload) to quantify application health in the context of business requirements.
* Configure the proper amount of log data collection.
* Create Azure dashboards to unify data into a single view for operations teams.
* Create a successful alerting strategy.
* Integrate [Application Insights](/azure/azure-monitor/app/app-insights-overview) into apps to track application performance metrics.  
* To provide notifications when direct action is needed, use an alerting system, like Container insights metric alerts or the Azure Red Hat OpenShift alerting UI.
* Consider various methods for monitoring and logging Azure Red Hat OpenShift to gain insights into the health of your resources and to foresee potential issues.
* Review the Azure Red Hat OpenShift responsibility matrix to understand how Microsoft, Red Hat, and customers share responsibilities for clusters.
* Automate service deployments with [Bicep](/azure/azure-resource-manager/bicep/overview), a template language for deploying infrastructure as code (IaC).
* [Continuously validate](/azure/well-architected/mission-critical/mission-critical-deployment-testing#continuous-validation-and-testing) the workload to test the performance and resilience of the entire solution by using services, such as [Azure Load Testing](https://azure.microsoft.com/products/load-testing/) and [Azure Chaos Studio](https://azure.microsoft.com/products/chaos-studio/).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Overview of the performance efficiency pillar](/azure/well-architected/performance-efficiency/).

* Cache assets in Azure Front Door to distribute workloads to edge locations.
* Review [subscription limits and quotas](/azure/azure-resource-manager/management/azure-subscription-service-limits) to ensure that services scale to demand.
* Monitor application performance by using [Application Insights](/azure/azure-monitor/app/app-insights-overview).
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

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

* [Daniel Mossberg](https://www.linkedin.com/in/danielmossberg/) | FastTrack for Azure Customer Engineer
* [Hiro Tarusawa](https://www.linkedin.com/in/hiro-tarusawa-bb29a2137/) | FastTrack for Azure Customer Engineer

Other contributors:

* [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji) | FastTrack for Azure Customer Engineer
* [Daniel Larsen](https://www.linkedin.com/in/daniellarsennz) | FastTrack for Azure Customer Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

* [Azure services that support availability zones](/azure/reliability/availability-zones-service-support)
* [Azure regions with availability zones](/azure/reliability/availability-zones-service-support#azure-regions-with-availability-zone-support)
* [Find an availability zone region near you](https://azure.microsoft.com/explore/global-infrastructure/geographies/)
* [Azure Well-Architected Framework - Reliability training module](/training/modules/azure-well-architected-reliability/)

## Related resources

* [Design principles for mission-critical workloads](/azure/well-architected/mission-critical/mission-critical-design-principles)
* [Azure Well-Architected Framework - Mission-critical workloads](/azure/well-architected/mission-critical/mission-critical-overview)
* [Mission-critical baseline architecture](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro)

This article describes how to deliver a mission-critical advanced analytical solution with Azure Data Factory. This architecture is an extension of the [baseline architecture](azure-data-factory-on-azure-landing-zones-baseline.yml) and the [enterprise hardened architecture](azure-data-factory-enterprise-hardened.yml). This article provides specific guidance about the recommended changes needed to manage a workload as a mission-critical operation.

This architecture aligns with the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) best practices and guidance and the recommendations for [mission-critical workloads](/azure/well-architected/mission-critical/).

## Create a mission-critical architecture

In the [baseline architecture](azure-data-factory-on-azure-landing-zones-baseline.yml), Contoso operates a [medallion lakehouse](/azure/databricks/lakehouse/medallion) that supports their first data workloads for the financial department. Contoso hardens and extends this system to support the analytical data needs of the enterprise. This strategy provides data science capabilities and self-service functionality.

In the [enterprise hardened architecture](azure-data-factory-enterprise-hardened.yml), Contoso has implemented a [medallion lakehouse architecture](/azure/databricks/lakehouse/medallion) that supports their enterprise analytical data needs and enables business users by using a domain model. As Contoso continues its global expansion, the finance department has used Azure Machine Learning to create a deal fraud model. This model now needs further refinement to function as a mission-critical, operational service.

### Key requirements

There are several key requirements to deliver a mission-critical advanced analytical solution by using Data Factory:

- The machine learning model must be designed as a mission-critical, operational service that is globally available to the various deal-operational systems.

- The machine learning model outcomes and performance metrics must be available for retraining and auditing.

- The machine learning model auditing trails must be retained for 10 years.

- The machine learning model currently targets the US, Europe, and South America, with plans to expand into Asia in the future. The solution must adhere to data compliance requirements, like the General Data Protection Regulation for European countries or regions.

- The machine learning model is expected to support up to 1,000 concurrent users in any given region during peak business hours. To minimize costs, the machine learning processing must scale back when not in use.

### Key design decisions

- A requirement doesn't justify the cost and complexity of redesigning the platform to meet mission-critical specifications. The machine learning model should instead be containerized and then deployed to a mission-critical solution. This approach minimizes cost and complexity by isolating the model service and adhering to [mission-critical guidance](/azure/well-architected/mission-critical/mission-critical-application-platform#containerization). This design requires the model to be developed on the platform and then containerized for deployment.

- After the model is containerized, it can be served out through an API by using a [scale-unit architecture](/azure/well-architected/mission-critical/mission-critical-application-design#scale-unit-architecture) in US, European, and South American Azure regions. Only [paired regions that have availability zones](https://azure.microsoft.com/explore/global-infrastructure/geographies/#geographies) are in scope, which supports redundancy requirements.

- Because of the simplicity of a single API service, we recommend that you use the [web app for containers](https://azure.microsoft.com/products/app-service/containers/) feature to host the app. This feature provides simplicity. You can also use [Azure Kubernetes Service (AKS)](/azure/well-architected/mission-critical/mission-critical-application-platform#design-considerations-and-recommendations-for-azure-app-service), which provides more control but increases complexity.

- The model is deployed through an [MLOps framework](/azure/machine-learning/concept-model-management-and-deployment). Data Factory is used to move data in and out of the mission-critical implementation.

- To do containerization, you need:

  - An API front end to serve the model results.

  - To offload audit and performance metrics to a storage account, which can then be transferred back to the main platform through Data Factory by using a [scheduled job](/azure/data-factory/how-to-create-schedule-trigger).

  - Deployment and rollback deployment pipelines, which enable each regional deployment to synchronize with the correct current version of the model.

  - Service [health modeling](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-health-modeling) to measure and manage the overall health of a workload.

- Audit trails can be initially stored within a Log Analytics workspace for real-time analysis and operational support. After 30 days, or 90 days if using Microsoft Sentinel, audit trails can be automatically transferred to Azure Data Explorer for long-term retention. This approach allows for interactive queries of up to two years within the Log Analytics workspace and the ability to keep older, infrequently used data at a reduced cost for up to 12 years. Use Azure Data Explorer for data storage to enable running cross-platform queries and visualize data across both Azure Data Explorer and Microsoft Sentinel. This approach provides a cost-effective solution for meeting long-term storage requirements while maintaining support optionality. If there's no requirement to hold excessive data, you should consider deleting it.

## Architecture

:::image type="content" source="_images/azure-data-factory-mission-critical.png" alt-text="Diagram that shows the design for a mission-critical workload." border="false"lightbox="_images/azure-data-factory-mission-critical.png":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-data-factory-mission-critical-logical.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the preceding diagram:

1. The machine learning model is developed on the data platform. This design change requires the following updates to the architecture:

    - [Azure Container Registry](/azure/container-registry/) enables the build, storage, and management of Docker container images and artifacts in a private registry that supports the machine learning model deployment.

    - The [web app for containers](https://azure.microsoft.com/products/app-service/containers/) feature enables the continuous integration and continuous deployment activities that are required to deliver the machine learning model outputs as an API service.

    - Data Factory enables the migration of any data required by the model to run and enables the ingestion of model output and performance metrics from the mission-critical implementation.

    - The data lake bronze layer (or the *raw layer*) directory structure stores the model output and performance metrics by using the [archive tier](/azure/storage/blobs/access-tiers-overview) to meet the data retention requirement.

2. [Azure DevOps](/azure/devops) orchestrates the deployment of the model codebase and the creation and retirement of regional deployments for all supporting services.

3. The machine learning model is deployed as a dedicated mission-critical workload within its own defined subscription. This approach ensures that the model avoids any [component limits or service limits](/azure/azure-resource-manager/management/azure-subscription-service-limits) that the platform might impose.

4. A set of shared resources span the entire solution and are therefore defined as global:

    - [Container Registry](/azure/container-registry/) enables the distribution of the current machine learning model version across the regional deployments.

    - [Azure Front Door](/azure/frontdoor/front-door-overview) provides load-balancing services to distribute traffic across regional deployments.

    - A monitoring capability uses [Log Analytics](/azure/azure-monitor/logs/log-analytics-overview) and [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction).

5. The regional [deployment stamp](/azure/well-architected/mission-critical/mission-critical-architecture-pattern#regional-stamp-resources) is a set of solution components that you can deploy into any target region. This approach provides scale, service resiliency, and regional-specific service.

    - Depending on the nature of the machine learning model, there might be regional data compliance requirements that require the machine learning model to adhere to sovereignty regulations. This design supports these requirements.

    - Each regional deployment comes with its own monitoring and storage stack, which provides isolation from the rest of solution.

6. The [scale unit](/azure/well-architected/mission-critical/mission-critical-application-design#scale-unit-architecture) of the solution has the following components:

    - The [web app for containers](https://azure.microsoft.com/products/app-service/containers/) feature hosts the machine learning model and serves its outputs. As the core service component in this solution, you should consider the [scale limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#app-service-limits) for web app for containers as the key constraints. If these limits don't support the solutions requirements, considering using AKS instead.

    - [Azure Key Vault](/azure/key-vault/) enforces appropriate controls over secrets, certificates, and keys at the regional scope, secured through [Azure Private Link](/azure/key-vault/general/private-link-service).

    - [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) provides data storage, which is secured through [Private Link](/azure/storage/common/storage-private-endpoints).

    - [Azure DNS](/azure/dns/dns-overview) provides name resolution that enables service resiliency and simplifies load balancing across the solution.

7. To facilitate support and troubleshooting of the solution, the following components are also included:

    - [Azure Bastion](/azure/bastion/) provides a secure connection to jump hosts without requiring a public IP address.

    - [Azure Virtual Machines](/azure/virtual-machines/) acts as a jump host for the solution, which enables a better security posture.

    - [Self-hosted build agents](/azure/devops/pipelines/agents/agents) provide scale and performance to support solution deployments.

### Network design

:::image type="complex" source="./_images/azure-data-factory-mission-critical-network.png" alt-text="Diagram that shows a hardened network design for a Data Factory workload." border="false" lightbox="_images/azure-data-factory-baseline-network.png":::
    Diagram that shows an example of the workflow for a system using the Valet Key pattern. Boxes on the left show on-premises infrastructure and user connectivity. A box on the upper right shows ingress infrastructure in the Connectivity Hub subscription. Underneath the ingress infrastructure box are the main components of the design that all use private endpoints. To the right of the main infrastructure is a box with monitoring infrastructure in the shared services subscription.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-data-factory-mission-critical-network.vsdx) of this architecture.*

- You should use a next-generation firewall like [Azure Firewall](/azure/firewall/overview) to secure network connectivity between your on-premises infrastructure and your Azure virtual network.

- You can deploy a self-hosted integration runtime (SHIR) on a virtual machine (VM) in your on-premises environment or in Azure. Consider deploying the VM in Azure as part of the shared support resource landing zone to simplify governance and security. You can use the SHIR to securely connect to on-premises data sources and perform data integration tasks in Data Factory.

- Machine learning-assisted data labeling doesn't support default storage accounts because they're secured behind a virtual network. First create a storage account for machine learning-assisted data labeling. Then apply the labeling and secure it behind the virtual network.

- [Private endpoints](/azure/private-link/private-endpoint-overview) provide a private IP address from your virtual network to an Azure service. This process effectively brings the service into your virtual network. This functionality makes the service accessible only from your virtual network or connected networks, which ensures a more secure and private connection. Private endpoints use [Private Link](/azure/private-link/private-link-overview), which secures the connection to the platform as a service (PaaS) solution. If your workload uses any resources that don't support private endpoints, you might be able to use [service endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview). We recommend that you use private endpoints for mission-critical workloads whenever possible.

For more information, see [Networking and connectivity](/azure/well-architected/mission-critical/mission-critical-networking-connectivity).

> [!IMPORTANT]
> Determine whether your use case is operational, like this scenario, or if it's related to the data platform. If your use case includes the data platform, such as data science or analytics, it might not qualify as mission-critical. Mission-critical workloads require substantial resources and should only be defined as such if they justify the resource investment.

## Alternatives

- You can use [AKS](/azure/aks/what-is-aks) to host the containers. For this use case, the management burden required for AKS makes it a less ideal option.

- You can use [Azure Container Apps](/azure/container-apps/overview) instead of the web apps for containers feature. Private endpoints aren't currently supported for Container Apps, but the service can be integrated into an existing or new virtual network.

- You can use [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) as a load-balancing alternative. Azure Front Door is preferred for this scenario because of the extra available functionality and a quicker [failover performance](/azure/architecture/guide/technology-choices/load-balancing-overview#azure-load-balancing-services).

- If the model requires read and write capabilities as part of its data processing, consider using [Azure Cosmos DB](/azure/well-architected/mission-critical/mission-critical-data-platform#globally-distributed-multi-region-write-datastore).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Compared to the baseline architecture, this architecture:

- Aligns with the [mission-critical architecture](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro).

- Follows the guidance from the mission-critical [reliability](/azure/well-architected/mission-critical/mission-critical-design-principles#reliability) design considerations.

- Deploys an initial [health model](/azure/well-architected/mission-critical/mission-critical-health-modeling) for the solution to maximize reliability.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Compared to the baseline architecture, this architecture:

- Follows the guidance from the mission-critical [security](/azure/well-architected/mission-critical/mission-critical-design-principles#security) design considerations.

- Implements the [security guidance](/azure/well-architected/mission-critical/mission-critical-security) from the mission-critical reference architecture.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Mission-critical designs are [expensive](/azure/well-architected/mission-critical/mission-critical-design-principles#cost-optimization), which makes implementing controls important. Some controls include:

- Aligning the component SKU selection to the solution [scale-unit boundaries](/azure/well-architected/mission-critical/mission-critical-application-design#scale-unit-architecture) to prevent overprovisioning.

- Available and practical operating expense-saving benefits, such as [Azure reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) for stable workloads, [savings plans](/azure/cost-management-billing/savings-plan/scope-savings-plan) for dynamic workloads, and Log Analytics [commitment tiers](/azure/azure-monitor/logs/cost-logs).

- Cost and budget alerting through [Microsoft Cost Management](/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Compared to the baseline architecture, this architecture:

- Follows the guidance from the mission-critical [operational excellence](/azure/well-architected/mission-critical/mission-critical-design-principles#operational-excellence) design considerations.

- Separates out global and regional monitoring resources to prevent a single of point failure in [Observability](/azure/well-architected/mission-critical/mission-critical-health-modeling#unified-data-sink-for-correlated-analysis).

- Implements the [deployment and testing guidance](/azure/well-architected/mission-critical/mission-critical-deployment-testing) and [operational procedures](/azure/well-architected/mission-critical/mission-critical-operational-procedures) from the mission-critical reference architecture.

- Aligns the solution with [Azure engineering roadmaps](/azure/well-architected/mission-critical/mission-critical-cross-cutting-issues#azure-roadmap-alignment) and [regional rollouts](https://azure.microsoft.com/updates) to account for constantly evolving services in Azure.

### Performance Efficiency

Performance Efficiency is the ability of your workload to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Compared to the baseline architecture, this architecture:

- Follows the guidance from the mission-critical [performance efficiency](/azure/well-architected/mission-critical/mission-critical-design-principles#performance-efficiency) design considerations.

- Completes a [Well-Architected assessment for mission-critical workloads](/azure/well-architected/mission-critical/mission-critical-assessment) to provide a baseline of readiness for the solution. Regularly revisit this assessment as part of a proactive cycle of measurement and management.

## Antipatterns

- **The shopping list approach:** Business stakeholders are often presented with a shopping list of features and service levels, without the context of cost or complexity. It's important to ensure that any solution is based upon validated requirements and the solution design is supported by financial modeling with options. This approach allows stakeholders to make informed decisions and pivot if necessary.

- **Not challenging the requirements:** Mission-critical designs can be expensive and complex to implement and maintain. Business stakeholders should be questioned about their requirements to ensure that "mission-critical" is truly necessary.

- **Deploy and forget:** The model is deployed without continuous monitoring, updates, or support mechanisms in place. After the model is deployed, it requires little to no ongoing maintenance and is left to operate in isolation. This neglect can lead to performance degradation, drift in model accuracy, and vulnerabilities to emerging data patterns. Ultimately, neglect undermines the reliability and effectiveness of the model in serving its intended purpose.

## Next steps

- [Well-Architected Framework mission-critical guidance](/azure/well-architected/mission-critical/)
- [Cloud Adoption Framework](/azure/cloud-adoption-framework/)

## Related resources

- [Data Factory baseline architecture](azure-data-factory-on-azure-landing-zones-baseline.yml)
- [Enterprise-hardened architecture](azure-data-factory-enterprise-hardened.yml)

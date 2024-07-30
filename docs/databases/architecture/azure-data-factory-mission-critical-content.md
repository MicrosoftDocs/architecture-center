This reference architecture describes how to deliver a mission-critical advanced analytical solution with Azure Data Factory. It is an extension of the [baseline architecture](azure-data-factory-on-azure-landing-zones-baseline.yml) and the [enterprise hardened architecture](azure-data-factory-enterprise-hardened.yml). This article provides guidance specifically on the recommended changes needed to manage the workload as a mission-critical operation.

This architecture aligns with the [Microsoft Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) for best practices and guidance and the recommendations for [mission-critical workloads](/azure/well-architected/mission-critical/).

## Context and key design decisions

According to the [enterprise-hardened architecture](azure-data-factory-enterprise-hardened.yml), Contoso has implemented a [medallion lakehouse architecture](/azure/databricks/lakehouse/medallion) that supports their enterprise analytical data needs and enables business users through a domain model. With the global expansion of Contoso, the Finance Department has developed a deal fraud model by using Azure Machine Learning. This model now requires further refinement to function as a mission-critical, operational service.

### Key requirements

- The machine learning model must be designed as a mission-critical, operational service that is globally available to the various deal operational systems.  

- The machine learning model outcomes and performance metrics must be made available for retraining and auditing.

- The machine learning model auditing trails must be retained for 10 years.

- While the machine learning model targets the US, Europe, and South America, there are plans to expand into Asia as well.

  - The solution must adhere to the region's data compliance requirements, like GDPR for European countries.
  
- The machine learning model is expected to support up to 1,000 concurrent users in any given region during peak business hours.

  - To minimize costs, the machine learning processing must scale back when not in use.

### The key design decisions

- The requirement does not justify the cost and complexity of rearchitecting the platform to meet mission-critical specifications. Instead, the machine learning model should be containerized and then deployed to a mission-critical solution. This approach minimizes cost and complexity by isolating the model service and adhering to [mission-critical guidance](/azure/well-architected/mission-critical/mission-critical-application-platform#containerization).

  - This design requires the model to be developed on the platform and then containerized for deployment.
  
- Once the model is containerized, it can be served out through an API by using a [scale-unit architecture](/azure/well-architected/mission-critical/mission-critical-application-design#scale-unit-architecture) in US, European, and South American Azure regions.

  - Only [paired regions that have availability zones](https://azure.microsoft.com/explore/global-infrastructure/geographies/#geographies) are in scope, which supports redundancy requirements.
  
- Given the nature of a simple, single API service, [Web App for Containers](https://azure.microsoft.com/products/app-service/containers/?activetab=pivot:deploytab) is the chosen app hosting service. This is a trade-off for simplicity versus control and the steep learning curve of [Azure Kubernetes Service (AKS)](/azure/well-architected/mission-critical/mission-critical-application-platform#design-considerations-and-recommendations-for-azure-app-service).  

- The model is deployed through an [MLOps framework](/azure/machine-learning/concept-model-management-and-deployment?view=azureml-api-2), and Azure Data Factory will be used to move data in and out of the mission-critical implementation.

- As part of the containerization, the following work is required:

  - An API front-end to serve the model results.
  
  - Offloading audit and performance metrics to a storage account, which can then be transferred back to the main platform through Data Factory by using a [scheduled job](/azure/data-factory/how-to-create-schedule-trigger?tabs=data-factory).
  
  - Deployment and rollback deployment pipelines, which enables each regional deployment to sync with the correct current version of the model.
  
  - Service [health modeling](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-health-modeling) required to measure and manage the overall health of a workload.

    - Audit trails can be initially stored within a Log Analytics workspace for real-time analysis and operational support. After 30 days or 90 days if using Microsoft Sentinel, they can be automatically transferred to Azure Data Explorer for long-term retention. This approach allows for interactive queries of up to two years within the Log Analytics Workspace and the ability to keep older, less frequently used data at a reduced cost for up to 12 years. Use Azure Data Explorer for data storage to enable running cross-platform queries and visualize data across both Azure Data Explorer and Microsoft Sentinel. This approach provides a cost-effective solution for meeting long-term storage requirements while maintaining support optionality. If there's no requirement to hold excessive data, the guidance is to consider deleting it.
  
## Architecture

:::image type="content" source="_images/azure-data-factory-mission-critical.png" alt-text="Diagram that shows the design for a mission-critical workload." border="false"lightbox="_images/azure-data-factory-mission-critical.png":::

### Workflow

The following workflow corresponds to the preceding diagram:

1. The data platform is where the machine learning model will be developed and tested. This design change requires the following updates to the architecture:

    - [Azure Container registry](/azure/container-registry/) enables the build, storage, and management of Docker container images and artifacts in a private registry that supports the machine learning model deployment.

    - [Web App for Containers](https://azure.microsoft.com/products/app-service/containers/?activetab=pivot:deploytab) enables the continuous integration and continuous deployment activities required to deliver the machine learning model outputs as an API service.

    - Data Factory enables the migration of any data required by the model to run and the ingestion of model output and performance metrics from the mission-critical implementation.

    - The data lake's bronze layer (or the _raw layer_) directory structure stores the model output and performance metrics by using the [Archive tier](/azure/storage/blobs/access-tiers-overview) to meet the data retention requirement.

2. Deployment of the model codebase, as well as the creation and retirement of regional deployments for all supporting services, are orchestrated by using [Azure DevOps](/azure/devops/?view=azure-devops).
  
3. The machine learning model is deployed as a dedicated, mission-critical workload within its own defined subscription. This approach ensures that the model avoids any [component or service limits](/azure/azure-resource-manager/management/azure-subscription-service-limits) that might be affected by the data platform.

4. A set of shared resources that span the entire solution and are therefore defined as global, such as:

    - [Azure Container registry](/azure/container-registry/) that enables the distribution of the current machine learning model version across the regional deployments.

    - [Azure Front Door](/azure/frontdoor/front-door-overview) that provides load-balancing services to distribute traffic across regional deployments.

    - A monitoring capability that uses [Azure Log Analytics](/azure/azure-monitor/logs/log-analytics-overview) and [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction).
  
5. The regional [deployment stamp](/azure/well-architected/mission-critical/mission-critical-architecture-pattern#regional-stamp-resources) is a set of solution components that can be deployed into any target region. This approach provides scale, service resiliency, and regional-specific service.

    - Depending on the nature of the machine learning model, there might be regional data compliance requirements that require the machine learning model to adhere to sovereignty regulations. This design will support these requirements.

    - Each regional deployment comes with its own monitoring and storage stack, providing isolation from the rest of solution.

6. The [scale unit](/azure/well-architected/mission-critical/mission-critical-application-design#scale-unit-architecture) of the solution has the following components:

    - [Web App for Containers](https://azure.microsoft.com/products/app-service/containers/?activetab=pivot:deploytab) hosts the machine learning model and serving its outputs.

        - As the core service component in this solution, Web App for Containers [scale limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#app-service-limits) are the key constraints to be aware of. If these limits don't support the solutions requirements, considering using AKS instead.
  
    - [Azure Key Vault](/azure/key-vault/) enforces appropriate controls over secrets, certificates, and keys at the regional scope, secured through [Private Link](/azure/key-vault/general/private-link-service?tabs=portal).

    - [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) provides data storage, secured through [Private Link](/azure/storage/common/storage-private-endpoints).

    - [Azure DNS](/azure/dns/dns-overview) provides name resolution enabling service resiliency and ease of use for load balancing across the solution.

7. To enable support and trouble shooting of the solution, the following components are also included:

    - [Azure Bastion](/azure/bastion/) provides a secure connection to jump hosts, without requiring a public IP address.

    - [Azure VM](/azure/virtual-machines/) acts as a jump host to the solution, which enables a better security posture.

    - [Self-hosted build agents](/azure/devops/pipelines/agents/agents) provide scale and performance to support solution deployments.

### Network design

:::image type="complex" source="./_images/azure-data-factory-mission-critical-network.png" alt-text="Diagram of a hardened network design for an Azure Data Factory workload." border="false" lightbox="_images/azure-data-factory-baseline-network.png":::
    Diagram that shows an example of the workflow for a system using the valet key pattern. Boxes on the left show on-premises infrastructure and user connectivity. A box on the upper right shows ingress infrastructure in the Connectivity Hub subscription. Below that are the main components of the design that all use Private Endpoints. To the right of the main infrastructure is a box with monitoring infrastructure in the shared services subscription.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-data-factory-mission-critical.vsdx) of this architecture.*

- You should use a next generation firewall like [Azure Firewall](/azure/firewall/overview) to secure network connectivity between your on-premises infrastructure and your Azure virtual network.

- You can deploy self-hosted integration runtime (SHIR) on a virtual machine (VM) in your on-premises environment or in Azure. Consider deploying the VM in Azure as part of the shared support resource landing zone to simplify governance and security. You can use SHIR to securely connect to on-premises data sources and perform data integration tasks in Data Factory.

- Machine learning-assisted data labeling doesn't support default storage accounts because they're secured behind a virtual network. First create a storage account for machine learning-assisted data labeling, apply the labeling and secure it behind the virtual network.

- [Private endpoints](/azure/private-link/private-endpoint-overview) provide a private IP address from your virtual network to an Azure service, effectively bringing the service into your virtual network. This functionality makes the service accessible only from your virtual network or connected networks, ensuring a more secure and private connection. Private endpoints use [Azure Private Link](/azure/private-link/private-link-overview), which secures the connection to the platform as a service (PaaS) service. If your workload uses any resources that don't support private endpoints, you might be able to use [service endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview). We recommend that you use private endpoints for mission-critial workloads whenever possible.

For more information, see [Networking and connectivity](/azure/well-architected/mission-critical/mission-critical-networking-connectivity).

## Callouts

In your use case, determine if the usage is operational, like it in this scenario, or related to the data platform. If your use case includes the data platform, such as data science or analytics, it might not qualify as mission-critical. Mission-critical workloads require substantial resources and should only be defined as such if they justify the resource investment.

## Alternatives

- [AKS](/azure/aks/what-is-aks) is a managed Kubernetes service that can host the containers. For this use case, the management burden required for AKS makes it a less ideal option for the solution.

- [Azure Container Apps](/azure/container-apps/overview) is a serverless container hosting service that you can use instead of Azure Web Apps for Containers. Private endpoints aren't currently supported for Azure Container Apps, but the service can be integrated into an existing or new virtual network.

- [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) as an alternative for load balancing. Azure Front Door is preferred for this scenario due to the additional functionality available and a quicker [failover performance](/azure/architecture/guide/technology-choices/load-balancing-overview#azure-load-balancing-services).

- If the model requires Read/Write capabilities as part of its data processing, consider using [Cosmos DB](/azure/well-architected/mission-critical/mission-critical-data-platform#globally-distributed-multi-region-write-datastore).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

This architecture provides the following deltas:

- Aligns with the [mission-critical baseline architecture](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro) reference architecture.

- Follows the guidance from the mission-critical [reliability](/azure/well-architected/mission-critical/mission-critical-design-principles#reliability) design considerations.

- Deploys an initial [health model](/azure/well-architected/mission-critical/mission-critical-health-modeling) for the solution to maximize reliability.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This architecture provides the following deltas:

- Follows the guidance from the mission-critical [security](/azure/well-architected/mission-critical/mission-critical-design-principles#security) design considerations.

- Implements the [security guidance](/azure/well-architected/mission-critical/mission-critical-security) from the mission-critical reference architecture.  

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Mission-critical designs are [expensive](/azure/well-architected/mission-critical/mission-critical-design-principles#cost-optimization), which makes implementing controls important. Some controls include:

- Aligning the component SKU selection to the solution [scale-unit boundaries](/azure/well-architected/mission-critical/mission-critical-application-design#scale-unit-architecture) to prevent overprovisioning.

- Available and practical operating expenses (OpEx) saving benefits, such as [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) for stable workloads, [savings plans](/azure/cost-management-billing/savings-plan/scope-savings-plan) for dynamic workloads, and Log Analytics [commitment tiers](/azure/azure-monitor/logs/cost-logs).

- Cost and budget alerting through [Cost Management](/azure/cost-management-billing/costs/cost-mgt-alerts-monitor-usage-spending).

### Operational efficiency

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

This architecture provides the following deltas:

- Follows the guidance from the mission-critical [operational excellence](/azure/well-architected/mission-critical/mission-critical-design-principles#operational-excellence) design considerations.

- Separates out global and regional monitoring resources to prevent a single of point failure in [observability](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro#unified-data-sink).

- Implements the [Deployment and testing guidance](/azure/well-architected/mission-critical/mission-critical-deployment-testing) and [Operational procedures](/azure/well-architected/mission-critical/mission-critical-operational-procedures) from the mission-critical reference architecture.  

- Aligns the solution with [Azure engineering roadmaps](/azure/well-architected/mission-critical/mission-critical-cross-cutting-issues#azure-roadmap-alignment) and [regional rollouts](https://azure.microsoft.com/updates/) to account for Azure's constantly evolving services.  

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

This architecture provides the following deltas:

- Follows the guidance from the mission-critical [performance efficiency](/azure/well-architected/mission-critical/mission-critical-design-principles#performance-efficiency) design considerations.

- Completes a [Well-Architected assessment for mission-critical workloads](/azure/well-architected/mission-critical/mission-critical-assessment) to provide a baseline of readiness for the solution. Regularly revisit this assessment as part of a proactive cycle of measure and manage.

## Antipatterns

- **The shopping list approach**: Business stakeholders are often presented with a shopping list of features and service levels, without the context of cost or complexity. It's important to ensure that any solution is based upon validated requirements and the solution design is supported by financial modeling with options. This approach allows stakeholders to make informed decisions and pivot if necessary.

- **Not challenging the requirements**: Mission-critical designs can be expensive and complex to implement and maintain. Business stakeholders should be challenged on their requirements to ensure that "mission-critical" is actually required.

- **Deploy and forget**: The model is deployed without continuous monitoring, updates, or support mechanisms in place. Once deployed, there's little to no ongoing maintenance, and the model is left to operate in isolation. This neglect can lead to performance degradation, drift in model accuracy, and vulnerabilities to emerging data patterns. Ultimately, it undermines the reliability and effectiveness of the model in serving its intended purpose.

## Related resources

- [Azure Well-Architected Framework mission-critical guidance](/azure/well-architected/mission-critical/)
- [Microsoft Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/)
- [Data Factory baseline architecture](azure-data-factory-on-azure-landing-zones-baseline.yml)
- [Enterprise-hardened architecture](azure-data-factory-enterprise-hardened.yml)

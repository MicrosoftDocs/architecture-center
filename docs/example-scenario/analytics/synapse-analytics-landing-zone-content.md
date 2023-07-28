This article provides an architectural approach for preparing Azure landing zone subscriptions for a scalable, enhanced-security deployment of Azure Synapse Analytics. Azure Synapse, an enterprise analytics service, combines data warehousing, big data processing, data integration, and management. 

The article assumes that you've already implemented the platform foundation that's required to effectively construct and operationalize a [landing zone](/azure/cloud-adoption-framework/ready/landing-zone).

*Apache®, [Spark](https://spark.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="media/azure-synapse-landing-zone.svg" alt-text="Diagram that shows an Azure Synapse Analytics reference architecture." lightbox="media/azure-synapse-landing-zone.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/SynapseESLZ-v1.vsdx) of this architecture.*
 
### Dataflow

- The core component of this architecture is Azure Synapse, a unified service that provides a range of functions, from data ingestion and data processing to serving and analytics. Azure Synapse in a [Managed Virtual Network](/azure/synapse-analytics/security/synapse-workspace-managed-vnet) provides network isolation for the workspace. By enabling [data exfiltration protection](/azure/synapse-analytics/security/workspace-data-exfiltration-protection), you can limit outbound connectivity to only approved targets.
- Azure Synapse resources, the Azure integration runtime, and Spark pools that are located in the Managed Virtual Network can connect to Azure Data Lake Storage, Azure Key Vault, and other Azure data stores with heightened security by using [Managed private endpoints](/azure/synapse-analytics/security/synapse-workspace-managed-private-endpoints). Azure Synapse SQL pools that are hosted outside the Managed Virtual Network can connect to Azure services via private endpoint in the enterprise virtual network. 
- Administrators can enforce private connectivity to the Azure Synapse workspace, Data Lake Storage, Key Vault, Log Analytics, and other data stores via Azure policies applied across data landing zones at the management group level. They can also enable data exfiltration protection to provide enhanced security for egress traffic.
- Users access Synapse Studio by using a web browser from a restricted on-premises network via Azure Synapse [Private Link Hubs](/azure/synapse-analytics/security/synapse-private-link-hubs#azure-private-link-hubs). Private Link Hubs are used to load Synapse Studio over private links with enhanced security. A single Azure Synapse Private Link Hubs resource is deployed in a Connectivity subscription with a private endpoint in the hub virtual network. The hub virtual network is connected to the on-premises network via [Azure ExpressRoute](https://azure.microsoft.com/products/expressroute). The Private Link Hubs resource can be used to privately connect to all Azure Synapse workspaces via Synapse Studio.
- Data engineers use the Azure Synapse pipelines Copy activity, executed in a [self-hosted integration runtime](/azure/data-factory/create-self-hosted-integration-runtime), to ingest data between a data store that's hosted in an on-premises environment and cloud data stores like Data Lake Storage and SQL pools. The on-premises environment is connected via ExpressRoute to the hub virtual network on Azure. 
- Data engineers use the Azure Synapse Data Flow activity and Spark pools to transform data hosted on cloud data stores that are connected to the Azure Synapse Managed Virtual Network via Managed private endpoints. For data located in the on-premises environment, transformation with Spark pools requires connectivity via custom Private Link service. The custom Private Link service uses Network Address Translation (NAT) VMs to connect to the on-premises data store. For information about setting up Private Link service to access on-premises data stores from a Managed Virtual Network, see [How to access on-premises SQL Server from Data Factory Managed VNet using Private Endpoint](/azure/data-factory/tutorial-managed-virtual-network-on-premise-sql-server). 
- If data exfiltration protection is enabled in Azure Synapse, Spark application logging to the Log Analytics workspace is routed via an [Azure Monitor Private Link Scope](/azure/azure-monitor/logs/private-link-security) resource that's connected to the Azure Synapse Managed Virtual Network via Managed private endpoint. As shown in the diagram, a single Azure Monitor Private Link Scope resource is hosted in a Connectivity subscription with private endpoint in the hub virtual network. All Log Analytics workspaces and Application Insights resources can be reached privately via Azure Monitor Private Link Scope.

### Components

- [Azure Synapse Analytics](https://azure.microsoft.com/products/synapse-analytics) is an enterprise analytics service that accelerates time to insight across data warehouses and big data systems. 
- [Azure Synapse Managed Virtual Network](/azure/synapse-analytics/security/synapse-workspace-managed-vnet) provides network isolation to Azure Synapse workspaces from other workspaces.
- [Azure Synapse Managed private endpoints](/azure/synapse-analytics/security/synapse-workspace-managed-private-endpoints) are private endpoints that are created in a Managed Virtual Network that's associated with an Azure Synapse workspace. Managed private endpoints establish private link connectivity to Azure resources outside the Managed Virtual Network.
- [Azure Synapse workspace with data exfiltration protection](/azure/synapse-analytics/security/workspace-data-exfiltration-protection) prevents exfiltration of sensitive data to locations that are outside of an organization's scope.
- [Azure Private Link Hubs](/azure/synapse-analytics/security/synapse-private-link-hubs) are Azure resources that act as connectors between your secured network and the Synapse Studio web experience.
- [Integration runtime](/azure/data-factory/concepts-integration-runtime) is the compute infrastructure that Azure Synapse pipelines use to provide data integration capabilities across different network environments. Run the Data Flow activity in the managed Azure compute integration runtime or the Copy activity across networks by using a self-hosted compute integration runtime.
- [Azure Private Link](https://azure.microsoft.com/products/private-link) provides private access to services that are hosted on Azure. Azure Private Link service is the reference to your own service that's powered by Private Link. You can enable your service that's running behind Azure standard load balancer for Private Link access. You can then extend Private Link service to the Azure Synapse Managed Virtual Network via Managed private endpoint. 
- [Apache Spark in Azure Synapse](/azure/synapse-analytics/spark/apache-spark-overview) is one of several Microsoft implementations of Apache Spark in the cloud. Azure Synapse makes it easy to create and configure Spark capabilities on Azure.
- [Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage) uses Azure Storage as the foundation for building enterprise data lakes on Azure.
- [Key Vault](https://azure.microsoft.com/products/key-vault) allows you to store secrets, keys, and certificates with enhanced security.
- [Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions) are the outputs of a multi-subscription Azure environment that account for scale, security governance, networking, and identity. A landing zone enables migration, modernization, and innovation at enterprise scale on Azure.

## Scenario details

This article provides an approach for preparing Azure landing zone subscriptions for a scalable, enhanced security deployment of Azure Synapse. The solution adheres to Cloud Adoption Framework for Azure best practices and focuses on the [design guidelines](/azure/cloud-adoption-framework/ready/enterprise-scale/design-guidelines) for enterprise-scale landing zones.

Many large organizations with decentralized, autonomous business units want to adopt analytics and data science solutions at scale. It's critical that they build the right foundation. Azure Synapse and Data Lake Storage are the central components for implementing cloud-scale analytics and a data mesh architecture. 

This article provides recommendations for deploying Azure Synapse across management groups, subscription topology, networking, identity, and security. 

By using this solution, you can achieve:

- A well-governed, enhanced-security analytics platform that scales according to your needs across multiple data landing zones. 
- Reduced operational overhead for data application teams. They can focus on data engineering and analytics and leave Azure Synapse platform management to the data landing zone operations team.
- Centralized enforcement of organizational compliance across data landing zones.

### Potential use cases

This architecture is useful for organizations that require:

- A fully integrated and operational control and data plane for Azure Synapse workloads, right from the start.
- An enhanced-security implementation of Azure Synapse, with a focus on data security and privacy.

This architecture can serve as a starting point for large-scale deployments of Azure Synapse workloads across data landing zone subscriptions.

### Subscription topology

Organizations building large scale data and analytics platforms look for ways to scale their efforts consistently and efficiently over time.

- By using [subscriptions as a scale unit](/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions) for data landing zones, organizations can overcome subscription-level limitations, ensure proper isolation and access management, and get flexible future growth for the data platform footprint. Within a data landing zone, you can group Azure Synapse and other data assets for specific analytics use cases within a resource group.
- The management group and subscription setup are the responsibility of the landing zone platform owner who provides the required access to data platform administrators to provision Azure Synapse and other services.
- All organization-wide data compliance policies are applied at the management group level to enforce compliance across the data landing zones. 

### Networking topology

 For recommendations for landing zones that use virtual WAN network topology (hub and spoke), see [Virtual WAN network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/virtual-wan-network-topology). These recommendations are aligned with  [Cloud Adoption Framework](/azure/cloud-adoption-framework/overview) best practices.

Following are some recommendations for Azure Synapse networking topology:

- Implement network isolation for Azure Synapse resources via Managed Virtual Network. Implement data exfiltration protection by restricting outbound access to approved targets only.
- Configure private connectivity to: 
   - Azure services like Data Lake Storage, Key Vault, and Azure SQL, via Managed private endpoints.
   - On-premises data stores and applications over ExpressRoute, via a self-hosted integration runtime. Use custom Private Link service to connect Spark resources to on-premises data stores if you can't use a self-hosted integration runtime.
  - Synapse Studio, via private link hubs that are deployed in a Connectivity subscription.
  - The Log Analytics workspace, via Azure Monitor Private Link Scope, deployed in a Connectivity subscription.

### Identity and access management

Enterprises typically use a least-privileged approach for operational access. They use Azure Active Directory (Azure AD), [Azure role-based access control](/azure/role-based-access-control/overview) (RBAC), and custom role definitions for access management. 

- Implement fine-grained access controls in Azure Synapse by using Azure roles, Azure Synapse roles, SQL roles, and Git permissions. For more information about Azure Synapse workspace access control, see [this overview](/azure/synapse-analytics/security/synapse-workspace-access-control-overview#overview).
- [Azure Synapse roles](/azure/synapse-analytics/security/synapse-workspace-synapse-rbac-roles) provide sets of permissions that you can apply at different scopes. This granularity makes it easy to grant appropriate access to administrators, developers, security personnel, and operators to compute resources and data.
- You can simplify access control by using security groups that are aligned with job roles. To manage access, you just need to add and remove users from appropriate security groups.
- You can provide security for communication between Azure Synapse and other Azure services, like Data Lake Storage and Key Vault, by using user-assigned managed identities. Doing so eliminates the need to manage credentials. Managed identities provide an identity that applications can use when they connect to resources that support Azure AD authentication.

### Application automation and DevOps

- Continuous integration and delivery for an Azure Synapse workspace is achieved via Git integration and promotion of all entities from one environment (development, test, production) to another environment.
- Implement automation with Bicep / Azure Resource Manager templates to create or update workspace resources (pools and workspace). Migrate artifacts like SQL scripts and notebooks, Spark job definitions, pipelines, datasets, and other artifacts by using Synapse Workspace Deployment tools in Azure DevOps or on GitHub, as described in [Continuous integration and delivery for an Azure Synapse Analytics workspace](/azure/synapse-analytics/cicd/continuous-integration-delivery).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures that your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- Azure Synapse, Data Lake Storage, and Key Vault are managed platform as a service (PaaS) services that have built-in high availability and resiliency. You can use redundant nodes to make the self-hosted integration runtime and NAT VMs in the architecture highly available.
- For SLA information, see [SLA for Azure Synapse Analytics](https://azure.microsoft.com/support/legal/sla/synapse-analytics/v1_1).
- For business continuity and disaster recovery recommendations for Azure Synapse, see [Database-restore points for Azure Synapse Analytics](/azure/cloud-adoption-framework/migrate/azure-best-practices/analytics/azure-synapse).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- [This security baseline](/security/benchmark/azure/baselines/synapse-analytics-security-baseline) applies guidance from Azure Security Benchmark 2.0 to Azure Synapse dedicated SQL pools.
- For information about Azure Policy security controls for Azure Synapse, see [Azure Policy Regulatory Compliance controls for Azure Synapse Analytics](/azure/synapse-analytics/security-controls-policy).
- For important built-in policies for Azure Synapse workspace, see [Azure Policy built-in definitions for Azure Synapse Analytics](/azure/synapse-analytics/policy-reference).

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- The analytics resources are measured in Data Warehouse Units (DWUs), which track CPU, memory, and IO. We recommend that you start with small DWUs and measure performance for resource-intensive operations, like heavy data loading or transformation. Doing so can help you determine how many units you need to optimize your workload.
- Save money with pay-as-you-go prices by using pre-purchased Azure Synapse Commit Units (SCUs).
- To explore pricing options and estimate the cost of implementing Azure Synapse, see [Azure Synapse Analytics pricing](https://azure.microsoft.com/pricing/details/synapse-analytics).
- [This pricing estimate](https://azure.com/e/2a113ea9dd97470f88bcd15d97ea91fc) contains the costs for deploying services by using the automation steps described in the next section.

## Deploy this scenario

**Prerequisites**: You must have an Azure account. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/?WT.mc_id=A261C142F) before you start.

All code for this scenario is available in [the 
SynapseEnterpriseCodebase repository on GitHub](https://github.com/Azure/SynapseEnterpriseCodebase).

The automated deployment uses Bicep templates to deploy the following components:

-	A resource group
-	A virtual network and subnets
-	Storage tiers (Bronze, Silver, and Gold) with private endpoints
-	An Azure Synapse workspace with a Managed Virtual Network
-	Private Link service and endpoints
-	Load balancer and NAT VMs
-	A self-hosted integration runtime resource

A PowerShell script for orchestrating the deployment is available in the repository. You can run the PowerShell script or use the *pipeline.yml* file to deploy it as a pipeline in Azure Devops.

For more information about the Bicep templates, deployment steps, and assumptions, see the [readme](https://github.com/Azure/SynapseEnterpriseCodebase/blob/main/readme.md) file. 

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

- [Vidya Narasimhan](https://www.linkedin.com/in/vidya-narasimhan-124ba393) | Principal Cloud Solution Architect
- [Sabyasachi Samaddar](https://www.linkedin.com/in/sabyasachi-samaddar-57060716) | Senior Cloud Solution Architect

Other contributor: 

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For information on creating an end-to-end data and analytics platform, see [cloud-scale analytics](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/scale-architectures) guidance.
- Explore [data mesh](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/what-is-data-mesh) as an architectural pattern for implementing enterprise data platforms in large, complex organizations.
- See the [Azure Synapse security white paper](/azure/synapse-analytics/guidance/security-white-paper-introduction).

For more information on the services described in this article, see these resources:

- [Azure Synapse Analytics](/azure/synapse-analytics)
- [Azure Private Link](/azure/private-link/private-link-overview)
- [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction)
- [Azure Key Vault](/azure/key-vault/general/overview)

## Related resources

- [Analytics end-to-end with Azure Synapse](../../example-scenario/dataplate2e/data-platform-end-to-end.yml)
- [Modern analytics architecture with Azure Databricks](../../solution-ideas/articles/azure-databricks-modern-analytics-architecture.yml)
- [Logical data warehouse with Azure Synapse serverless SQL pools](../../solution-ideas/articles/logical-data-warehouse.yml)

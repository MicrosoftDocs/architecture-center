This article provides an architectural approach for preparing Azure landing zone subscriptions for a scalable, enhanced security deployment of Azure Synapse Analytics. The solution adheres to Cloud Adoption Framework for Azure best practices and focuses on the [design guidelines](/azure/cloud-adoption-framework/ready/enterprise-scale/design-guidelines) for enterprise-scale landing zones.

Azure Synapse, an enterprise analytics service, combines data warehousing, big data processing, data integration, and management. 

Large organizations with decentralized, autonomous business units want to adopt analytics and data science solutions at scale. It's critical that they build the right foundation. Azure Synapse and Azure Data Lake Storage are the central components for implementing cloud-scale analytics and a data mesh architecture. 

This article provides recommendations for deploying Azure Synapse across management groups, subscription topology, networking, identity, and security. The article is written with the assumption that the platform foundation that's required to effectively construct and operationalize a [landing zone](/azure/cloud-adoption-framework/ready/landing-zone) is already implemented.

By using this solution, you can achieve:

- A well-governed, enhanced-security analytics platform that scales as per your needs across multiple data landing zones. 
- Reduced operational overhead for data application teams because they can focus on data engineering and analytics and leave Azure Synapse platform management to the data landing zone operations team.
- Centralized enforcement of organizational compliance across data landing zones.

### Potential use cases

This architecture is useful for organizations that require:

- A fully integrated and operational control and data plane for Azure Synapse workloads, right from the start.
- An enhanced-security implementation of Azure Synapse, with a focus on data security and privacy.

This architecture can serve as a starting point for large-scale deployments of Azure Synapse workloads across data landing zone subscriptions.

## Architecture

diagram 

Pic.1 Azure Synapse reference architecture 

*Download a [Visio file](https://microsoftapc.sharepoint.com/:u:/t/MyDocuments2021/EeksJdatzdlPkANRO4T9ISsB5EBVh2e3B6HXJhXESDtB2A?e=Atd45e) of this architecture.*
 
### Dataflow

- The core component of this architecture is Azure Synapse, a unified service that provides a range of functions, from data ingestion and data processing to serving and analytics. Azure Synapse in a [Managed Virtual Network](/azure/synapse-analytics/security/synapse-workspace-managed-vnet) provides network isolation for the workspace. By enabling [data exfiltration protection](/azure/synapse-analytics/security/workspace-data-exfiltration-protection), you can limit outbound connectivity to only approved targets.
- Azure Synapse resources, the Azure integration runtime, and Spark pools that are located in the Managed Virtual Network can connect to Azure Data Lake Storage, Azure Key Vault, and other Azure data stores with heightened security by using [Managed private endpoints](/azure/synapse-analytics/security/synapse-workspace-managed-private-endpoints). Azure Synapse SQL pools that are hosted outside the Managed Virtual Network can connect to Azure services via private endpoint in the customer virtual network. 
- Administrators can enforce private connectivity to the Synapse workspace, Azure Data Lake Storage, Key Vault, Log Analytics, and other data stores via Azure policies applied across data landing zones at a management group level. They can also enable data exfiltration protection to provide enhanced security for egress traffic.
- Users access Synapse Studio by using a web browser from a restricted on-premise network via Azure Synapse [private link hubs](/azure/synapse-analytics/security/synapse-private-link-hubs#azure-private-link-hubs). Private link hubs are used to load Synapse Studio over private links with enhanced security. A single Azure Synapse private link hub resource is deployed in the Connectivity subscription with a private endpoint in Hub VNet that in turn is connected to the on-premises network via [Azure ExpressRoute](https://azure.microsoft.com/products/expressroute). The private link hub resource can be used to privately connect to all Azure Synapse workspaces via Synapse Studio.
- Data engineers use the Azure Synapse pipelines Copy activity, executed in a [self-hosted integration runtime](/azure/data-factory/create-self-hosted-integration-runtime), to ingest data between a data store that's hosted in an on-premises environment and cloud data stores like Azure Data Lake Storage and SQL pools. The on-premises environment is connected via ExpressRoute to Hub VNet on Azure. 
- Data engineers use the Azure Synapse Data Flow activity and Spark pools to transform data hosted on cloud data stores that are connected to Azure Synapse the Managed Virtual Network via managed private endpoint. For data located in the on-premises environment, transformation with Spark pools requires connectivity via custom private link service. The custom private link service uses Network Address Translation (NAT) VMs to connect to the on-premises data store. For information about setting up private link service to access on-premises data stores from managed virtual network, see [How to access on-premises SQL Server from Data Factory Managed VNet using Private Endpoint](/azure/data-factory/tutorial-managed-virtual-network-on-premise-sql-server). 
- If data exfiltration protection is enabled in Azure Synapse, Spark application logging to the Log Analytics workspace is routed via [Azure Monitor Private Link Scope](/azure/azure-monitor/logs/private-link-security), connected to Azure Synapse Managed virtual network via managed private endpoint. As shown in the diagram, a single Azure Monitor Private Link Scope resource is hosted in a Connectivity subscription with private endpoint in Hub VNet. All Log Analytics workspaces and Application Insights resources can be reached privately via Azure Monitor Private Link Scope.

### Components

- [Azure Synapse Analytics](https://azure.microsoft.com/products/synapse-analytics) is an enterprise analytics service that accelerates time to insight across data warehouses and big data systems. 
- [Azure Synapse Managed Virtual Network](/azure/synapse-analytics/security/synapse-workspace-managed-vnet) provides network isolation to Azure Synapse workspaces from other workspaces.
- [Synapse Managed Private Endpoint](/azure/synapse-analytics/security/synapse-workspace-managed-private-endpoints) - Managed private endpoints are private endpoints created in managed virtual network associated with Azure Synapse workspace. Managed private endpoints establishes private link connectivity to Azure resources outside managed VNet.
- [Synapse Workspace with Data Exfiltration Protection](/azure/synapse-analytics/security/workspace-data-exfiltration-protection) – data exfiltration protection enabled Synapse workspace prevents exfiltration of sensitive data to locations outside of an organization’s scope.
- [Private Link Hubs](/azure/synapse-analytics/security/synapse-private-link-hubs) - Synapse Analytics private link hubs are Azure resources which act as connectors between your secured network and the Synapse Studio web experience.
- [Integration Runtime](/azure/data-factory/concepts-integration-runtime) - Integration Runtime (IR) is the compute infrastructure used by Synapse pipelines to provide data integration capabilities across different network environments. Execute data flow in managed Azure compute IR or copy activity across networks using self-hosted compute IR (SHIR).
- [Azure Private Link](https://azure.microsoft.com/products/private-link) - Azure Private Link service is the reference to your own service that is powered by Private Link. Your service that is running behind Azure Standard Load Balancer can be enabled for Private Link access. The private link service can then be extended to Synapse managed VNet via managed private endpoint. 
- [Synapse Spark Pool](/azure/synapse-analytics/spark/apache-spark-overview) - Apache Spark in Azure Synapse Analytics is one of Microsoft's implementations of Apache Spark in the cloud. Synapse makes it easy to create and configure Spark capabilities in Azure.
- [Azure Data Lake Storage Gen2](https://azure.microsoft.com/products/storage/data-lake-storage) - Data Lake Storage Gen2 uses Azure Storage as the foundation for building enterprise data lakes on Azure.
- [Azure Key Vault](https://azure.microsoft.com/products/key-vault) – Key management solutions in Azure that allows you to safely store secrets, keys & certificates.
- [Azure Landing Zone](/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions) - Azure landing zone is the output of a multi-subscription Azure environment that accounts for scale, security governance, networking, and identity. A landing zone enables migration, modernization, and innovation at enterprise-scale in Azure.

Design areas

These design areas provide considerations & guidance for deploying Synapse in a landing zone.

Subscription topology

Organizations building large scale data & analytics platforms are looking for ways to scale their efforts consistently and efficiently over time. 
- Embracing "[subscription as scale-unit](/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions)" for data landing zones allows organizations to overcome subscription-level limitations, ensures proper isolation & access management, provides flexible future growth of data platform footprint. Within a Data Landing Zone, Synapse Analytics and other data assets for specific analytics use case can be grouped within a resource group.
- The management group and subscription setup are the responsibility of the Landing Zone platform owner who provides the required access to the data platform administrators to provision Synapse and other services.
- All organization-wide data compliance policies are applied to the management group level to enforce compliance across the Data Landing zones. 

Networking topology

Aligned with  [Cloud Adoption Framework](/azure/cloud-adoption-framework/overview) best practices, recommendations for the landing zone using virtual WAN network topology (hub & spoke) are documented [here](/azure/cloud-adoption-framework/ready/azure-best-practices/virtual-wan-network-topology). 

Synapse Analytics recommendations around networking topology are:
- Network isolation for Synapse resources via Managed VNet. Data exfiltration protection by restricting outbound access to approved targets only.
- Private connectivity to Azure services e.g., ADLS, Key Vault, Azure SQL etc. via managed private endpoint.
- Private connectivity to on-premises data stores and applications over ExpressRoute using SHIR. Leverage custom private link service to connect Spark resources with on-premises data stores where SHIR is not an option.
- Private connectivity to Synapse Studio via Azure Private Link Hubs deployed in Connectivity subscription.
- Private connectivity to Log Analytics workspace via Azure Monitor Private Link Scope deployed in Connectivity subscription.

Identity and Access Management

Enterprise organizations typically follow a least-privileged approach to operational access designed through Azure AD, [Azure role-based access control](/azure/role-based-access-control/overview) (RBAC), and custom role definitions. 

- Use fine grained access controls in Synapse by leveraging Azure roles, Synapse roles, SQL roles & GIT permissions. Synapse workspace access control details are described [here](/azure/synapse-analytics/security/synapse-workspace-access-control-overview#overview).
- Azure [Synapse roles](/azure/synapse-analytics/security/synapse-workspace-synapse-rbac-roles) provide sets of permissions that can be applied at different scopes. This granularity makes it easy to grant appropriate access to administrators, developers, security personnel, and operators to compute resources and data.
- Access control can be simplified by using security groups that are aligned with people's job roles. You only need to add and remove users from appropriate security groups to manage access.
- Communication between Synapse and other Azure services such as ADLS, Key Vault etc. can be secured using user-assigned managed identities eliminating the need to manage credentials. Managed identities provide an identity for applications to use when connecting to resources that support Azure Active Directory (Azure AD) authentication.

Application Automation and DevOps

- Continuous integration and delivery for an Azure Synapse Analytics workspace is achieved via Git integration and promotion of all entities from one environment (development, test, production) to another environment.
- Build automation with Bicep/ARM template to create or update workspace resources (pools and workspace). Migrate artifacts like SQL scripts and notebooks, Spark job definitions, pipelines, datasets, and other artifacts by using Synapse Workspace Deployment tools in Azure DevOps or on GitHub as described [here](/azure/synapse-analytics/cicd/continuous-integration-delivery).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/resiliency/overview).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- Services included in the architecture are Synapse Analytics, ADLS Gen2 and Key Vault which are managed PaaS services that have built-in high availability & resiliency. SHIR & NAT VMs depicted in the architecture can be made highly available through redundant nodes.
- Synapse Analytics provides an [SLA](https://www.azure.cn/support/sla/synapse-analytics) guarantee that, at least 99.9% of the time client operations executed on this service will succeed.
- Business continuity & disaster recovery recommendations for Synapse Analytics are well described [here](/azure/cloud-adoption-framework/migrate/azure-best-practices/analytics/azure-synapse).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- This [security baseline](/security/benchmark/azure/baselines/synapse-analytics-security-baseline) applies guidance from the Azure Security Benchmark version 2.0 to Synapse dedicated SQL pool.
- Azure Policy driven security controls for Azure Synapse analytics are detailed [here](/azure/synapse-analytics/security-controls-policy).
- Important built-in policies for Synapse Workspace are listed [here](/azure/synapse-analytics/policy-reference).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- The analytics resources are measured in Data Warehouse Units (DWUs), which tracks CPU, memory, and IO. It is recommended to start with smaller DWUs and measure performance for resource intensive operations, such as heavy data loading or transformation. This will help determine the number of units needed to optimize your workload.
- Enjoy cost savings through pay-as-you-go prices using pre-purchase Azure Synapse Analytics Commit Units (SCUs).
- Use Synapse Analytics [pricing link](https://azure.microsoft.com/pricing/details/synapse-analytics) to explore further pricing options & estimate the cost of implementing the service. 
- This [pricing estimate](https://azure.com/e/2a113ea9dd97470f88bcd15d97ea91fc) contains cost for deploying services using the automation steps provided in the next section.

## Deploy this scenario

**Prerequisites**: You must have an existing Azure account. If you do not have an Azure subscription, create a [free account](https://azure.microsoft.com/free/?WT.mc_id=A261C142F) before you begin.

All the code for this scenario is available in this [repository](https://github.com/Azure/SynapseEnterpriseCodebase/tree/main/SynapseEnterprise-BicepTemplate/SynapseEnterprise-BicepTemplate).

The automated deployment uses Bicep templates to deploy the following components of the architecture:

-	Resource group
-	VNet & subnets
-	Storage tiers (Bronze, Silver, and Gold) with private endpoints
-	Synapse workspace with managed VNet
-	Private link service & endpoints
-	Load balancer & Nat VMs
-	Self-hosted integration runtime resource

A PowerShell script has been provided in the repository to orchestrate the deployment. You can choose to run the PowerShell script or use the pipeline.yml file to deploy it as a pipeline in Azure Devops.

More details about the Bicep templates, deployment steps & assumptions are provided in the [README](https://github.com/Azure/SynapseEnterpriseCodebase/blob/main/SynapseEnterprise-BicepTemplate/SynapseEnterprise-BicepTemplate/readme.md) file. 

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 
•	[Vidya Narasimhan](https://www.linkedin.com/in/vidya-narasimhan-124ba393) | Principal Cloud Solution Architect
•	[Sabyasachi Samaddar](https://www.linkedin.com/in/sabyasachi-samaddar-57060716) | Senior Cloud Solution Architect

line 

## Next steps

- [Cloud-Scale Analytics](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/scale-architectures) : While this article focuses on Azure Synapse Analytics deployment at scale, as a next step, please review Cloud-Scale Analytics guidance to build end to end data and analytics platform. 
- [Data mesh](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/what-is-data-mesh) : Explore data mesh as an architectural pattern for implementing enterprise data platforms in large, complex organizations.
- [Synapse security white paper](/azure/synapse-analytics/guidance/security-white-paper-introduction)

## Related resources

- [Analytics end-to-end with Azure Synapse](/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end)

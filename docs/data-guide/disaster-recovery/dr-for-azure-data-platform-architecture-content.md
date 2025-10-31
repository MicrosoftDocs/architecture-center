## Use case definition

To support this worked example, the fictitious firm "Contoso" will be used with an Azure data platform based upon Microsoft reference architectures.

Microsoft is responsible for maintaining the reliability, availability, and security of the Azure infrastructure and platform services. This includes ensuring that the physical datacenters, networking, and core services are resilient and protected. However, Microsoft does not automatically configure workload-specific recovery strategies for customers.

Customers are responsible for designing and implementing disaster recovery plans that meet their own business requirements for Recovery Time Objective (RTO) and Recovery Point Objective (RPO). This means customers must configure features such as cross-region failover, geo-redundant backups, and replication policies to achieve their desired recovery targets. They also need to select appropriate service tiers, enable features like failover groups or active geo-replication, and regularly test these configurations through disaster recovery drills.

To address RTO and RPO concerns, customers should start by assessing the criticality of their workloads and defining acceptable downtime and data loss. They can then leverage Azure services such as Site Recovery for automated failover and Azure Backup for frequent backups. Designing for multi-region resilience, automating failover processes, and maintaining clear documentation are essential steps to ensure that recovery objectives are met. For more details, refer to the [Shared responsibility in the cloud](/azure/security/fundamentals/shared-responsibility).

### Data Service - Component View
Contoso has implemented the following foundational Azure architecture, which is a subset of the [Enterprise Landing Zone](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture) design.
[![Diagram that shows an example Enterprise Azure landing zone.](../images/dr-for-azure-data-platform-landing-zone-architecture.png)](../images/dr-for-azure-data-platform-landing-zone-architecture.png#lightbox)

*The numbers in the following descriptions correspond to the preceding diagram above.*

### Contoso's Azure Foundations - Workflow

1. **Enterprise enrollment** - Contoso's top parent enterprise enrollment within Azure reflecting its commercial agreement with Microsoft, its organizational account structure and available Azure subscriptions. It provides the billing foundation for subscriptions and how the digital estate is administered.
1. **Identity and access management** – The components required to provide identity, authentication, resource access and authorization services across Contoso's Azure estate.
1. **Management group and subscription organization** - A scalable group hierarchy aligned to the data platform's core capabilities, allowing operationalization at scale using centrally managed security and governance where workloads have clear separation. Management groups provide a governance scope above subscriptions.
1. **Management subscription** - A dedicated subscription for the various management level  functions of required to support the data platform.
1. **Connectivity subscription** - A dedicated subscription for the connectivity functions of the data platform enabling it to identify named services, determine secure routing and communication across and between internal and external services.
1. **Landing zone subscription** – One-to-many subscriptions for Azure native, online applications, internal and external facing workloads and resources
1. **DevOps platform** - The DevOps platform that supports the entire Azure estate. This platform contains the code base source control repository and CI/CD pipelines enabling automated deployments of infrastructure as code (IaC).

> [!NOTE]
> Many customers still retain a large infrastructure as a service (IaaS) footprint. To provide recovery capabilities across IaaS, the key component to be added is [Azure Site recovery](/azure/site-recovery/site-recovery-overview). [Site Recovery](/azure/site-recovery/site-recovery-faq) will orchestrate and automate the replication of Azure VMs between regions, on-premises virtual machines and physical servers to Azure, and on-premises machines to a secondary datacenter.

Within this foundational structure, Contoso has implemented the following elements to support its enterprise business intelligence needs, aligned to the guidance in [Data platform end-to-end](/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end).

[![Diagram that shows architecture for a modern data platform using Azure data services.](../images/azure-analytics-end-to-end.png)](../images/azure-analytics-end-to-end.png#lightbox)
*Contoso's data platform*

### Contoso's Data Platform - Workflow

The workflow is read left to right, following the flow of data:

- **Data sources** - The sources or types of data that the data platform can consume from.
    
- **Ingest**
    - Ingest structured, semi-structured, and unstructured data into [OneLake](/fabric/onelake/onelake-overview) using [Data Factory](/fabric/data-factory/data-factory-overview), [Event Streams](/fabric/real-time-intelligence/event-streams/overview), [Notebooks](/fabric/data-engineering/how-to-use-notebook), [Shortcuts](/fabric/onelake/onelake-shortcuts), or [Mirroring](/fabric/mirroring/overview).
    - Use Data Factory for batch ETL/ELT pipelines and Event Streams for real-time ingestion via [Real-Time Hub](/fabric/real-time-hub/).
    - Mirror supported databases for near real-time replication or use Shortcuts to access external data without copying the data into OneLake.
    - Real-time ingestion is supported via Event Streams, enabling a [Lambda architecture](/azure/architecture/data-guide/big-data/#lambda-architecture).
        
- **Store**
    - All ingested data is stored in OneLake, Microsoft Fabric’s unified data lake, which serves as the foundation for all Fabric experiences. OneLake supports open formats such as Delta, Parquet, and CSV, and provides built-in geo-redundancy and [Business Continuity and Disaster Recovery (BCDR) options for OneLake](/fabric/onelake/onelake-disaster-recovery) to ensure durability and resilience. On top of OneLake, Fabric offers specialized services to organize data.
        - Lakehouse: It ombines the flexibility of a data lake with the structured querying capabilities of a data warehouse, enabling large-scale analytics and machine learning workloads while maintaining schema enforcement for organized data management.
        - Data warehouse: It is a fully managed, scalable SQL-based environment optimized for structured queries and enterprise analytics. It offers high performance for BI and reporting workloads.
        - Eventhouse: It is designed for real-time event streaming and processing, enabling the ingestion and analysis of time-sensitive data for scenarios such as IoT telemetry and operational monitoring.
        - Mirrored database: It provides near real-time replication of operational data from sources such as Azure SQL Database or Cosmos DB into OneLake, ensuring analytics are always up to date without complex ETL processes.
      
- **Process**
    - Microsoft Fabric offers multiple ways to process and transform data, giving users flexibility to choose the right approach based on their workload and skill set. Whether you need low-code ETL, advanced data engineering, real-time analytics, or embedded business logic, Fabric provides integrated tools that work seamlessly with OneLake. These options ensure that data can be cleansed, enriched, and prepared for analytics or machine learning in a unified environment.
        - [Notebook](/fabric/data-engineering/how-to-use-notebook): Run a Fabric notebook to perform advanced transformations, data cleansing, and enrichment using languages like PySpark or SQL.
        - [DataFlow Gen2](/fabric/data-factory/create-first-dataflow-gen2): Create a /fabric/data-factory/create-first-dataflow-gen2 pipeline for low-code ETL operations, ideal for ingesting and shaping data from multiple sources.
        - Stored Procedure: Execute stored procedures within your Fabric SQL environment to apply business logic or batch transformations directly on your OneLake tables.
        - [Run KQL queries](/fabric/real-time-intelligence/kusto-query-set) on Eventhouse (Kusto DB) for real-time analytics and event-driven insights.
      
- **Serve**
    - Serve curated data through [SQL Analytics Endpoints](/fabric/database/sql/tutorial-use-analytics-endpoint), which provide secure, governed access to [lakehouse](/fabric/data-engineering/lakehouse-overview), [data warehouse](/fabric/data-warehouse/data-warehousing) and [mirrored databases](/fabric/mirroring/overview) without exposing raw storage or direct connections.
    - Create a [semantic model](/power-bi/connect-data/service-datasets-understand) in [Direct Lake storage mode](/fabric/fundamentals/direct-lake-overview) to optimize performance and share governed datasets with business users for self-service analytics.
    - Build [real-time dashboards](/fabric/real-time-intelligence/dashboard-real-time-create) in Real-Time Intelligence (RTI) hub in Microsoft Fabricto visualize streaming data and enable instant insights for operational decision-making..
    - Expose data programmatically via [Microsoft Fabric API for GraphQL](/fabric/data-engineering/api-graphql-overview), allowing developers to query multiple curated sources efficiently through a single endpoint.
      
- **Enrich**
    - Leverage Fabric’s integrated data science tools and Azure ML to build, train, and deploy machine learning models directly on its unified data foundation, enabling enriched datasets and real-time predictive insights within analytics experiences.
    - Engage with [data agent](/fabric/data-science/concept-data-agent) in Microsoft Fabric to explore insights through conversational queries. Leverage Azure AI Foundry integration with the Data Agent to access enterprise data and enable data-driven decision-making.
      
- **Data share**
    - [External data sharing](/fabric/governance/external-data-sharing-overview) in Microsoft Fabric enables a provider tenant to securely share OneLake data with a consumer tenant, allowing cross-tenant access and collaboration without data movement. In the above diagram, a provider tenant is the organization that shares data externally, while a consuming tenant is the organization that accesses and uses that shared data. 
    - Disaster recovery DR ensures that shared data remains accessible and consistent even during outages or failures. Key aspects include:
        - Geo-redundancy: OneLake data is stored in geo-replicated regions, so shared datasets remain available if the primary region experiences downtime.
        - Failover Support: In the event of a regional outage, the provider tenant’s DR strategy automatically redirects access to the secondary region, ensuring continuity for consumer tenants.
        - Metadata Synchronization: Sharing configurations (permissions, access policies) are replicated across regions to maintain external sharing integrity during failover.
        
- **Discover and govern** - Use [Microsoft Purview](https://learn.microsoft.com/en-us/fabric/governance/microsoft-purview-fabric), [OneLake catalog](/fabric/governance/onelake-catalog-overview), and Microsoft Fabric governance tools for lineage, metadata, and access control.
      
- **Platform** - Fabric provides an end-to-end, unified SaaS analytics platform unified SaaS experience with centralized data storage with OneLake and embedded AI capabilities.

> [!NOTE]
> For many customers, the conceptual level of the Data Platform reference architecture used will align, but the physical implementation might vary. For example, ELT (extract, load, transform) processes might be performed through [Azure Data Factory](/azure/data-factory/), and data modeling by [Azure SQL server](/azure/azure-sql/?view=azuresql). To address this concern, the [Stateful vs stateless components](#stateful-vs-stateless-components) section below will provide guidance.

For the Data Platform, Contoso has selected the lowest recommended production service tiers for all components and has chosen to adopt a "Redeploy on disaster" disaster recovery (DR) strategy based upon an operating cost-minimization approach.

The following sections will provide a baseline understanding of the DR process and levers available to customers to uplift this posture.

## Azure service and component view

The following tables present a breakdown of each Azure service and component used across the Contoso – Data platform, with options for DR uplift.
> [!NOTE]
> The sections below are organized by stateful vs stateless services.

### Stateful foundational components

- **Microsoft Entra ID including role entitlements**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Microsoft
    - Contoso SKU selection: Premium P1
    - DR uplift options: the Microsoft Entra resiliency is part of its software as a service (SaaS) offering.
    - Notes
        - [Advancing service resilience in Microsoft Entra ID](https://azure.microsoft.com/en-us/blog/advancing-service-resilience-in-azure-active-directory-with-its-backup-authentication-service/)

- **Azure Key Vault**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Microsoft
    - Contoso SKU selection: N/A
    - DR uplift options: N/A, Covered as part of the Azure service.

- **Recovery Services Vault**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Microsoft
    - Contoso SKU selection: Default (geo-redundant storage (GRS))
    - DR uplift options: Enabling [Cross Region Restore](/azure/backup/backup-create-rs-vault#set-cross-region-restore) creates data restoration in the secondary, [paired region](/azure/reliability/cross-region-replication-azure).
    - Notes
        - While locally redundant storage (LRS) and zone-redundant storage (ZRS) are available, it requires configuration activities from the default setting.

- **Azure DevOps**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Microsoft
    - Contoso SKU selection: DevOps Services
    - DR uplift options: DevOps [service and data resiliency](/azure/devops/organizations/security/data-protection?view=azure-devops#data-availability) is part of its SaaS offering.
    - Notes
        - DevOps Server as the on-premises offering will remain the customer's responsibility for disaster recovery.
        - If third party services (SonarCloud, Jfrog Artifactory, Jenkins build servers for example) are used, they'll remain the customer's responsibility for recovery from a disaster.
        - If IaaS VMs are used within the DevOps toolchain, they'll remain the customer's responsibility for recovery from a disaster.

- **GitHub**
    - Component recovery responsibility: GitHub (Microsoft)
    - Workload/configuration recovery responsibility: GitHub (Microsoft
    - Contoso SKU selection: GitHub Enterprise Cloud
    - DR uplift options:
        - Users can take [backups of repositoires](https://docs.github.com/en/enterprise-cloud@latest/repositories/archiving-a-github-repository/backing-up-a-repository) for disaster recovery purposes.
        - Users can follow [disaster recovery for GitHub Codespaces](https://docs.github.com/en/enterprise-cloud@latest/codespaces/reference/disaster-recovery-for-github-codespaces) and prepare for the possbility that there is an outage of an entire region. If an entire region experiences a service disruption, the locally redundant copies of your data would be temporarily unavailable.
    - Notes
        - GitHub Enterprise Server (self-hosted/on-premises) remains the customer’s responsibility for disaster recovery, including backup and restore of repositories and configuration.
        - Any third-party integrations (e.g., CI/CD tools, artifact repositories) are the customer’s responsibility for recovery.
        - If GitHub Actions runners are hosted on customer-managed infrastructure (VMs or containers), their recovery is also the customer’s responsibility.

### Stateless Foundational Components

- **Subscriptions**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Microsoft
    - Contoso SKU selection: N/A
    - DR uplift options: N/A, Covered as part of the Azure service.

- **Management Groups**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Microsoft
    - Contoso SKU selection: N/A
    - DR uplift options: N/A, Covered as part of the Azure service.

- **Azure Monitor**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Microsoft
    - Contoso SKU selection: N/A
    - DR uplift options: N/A, Covered as part of the Azure service.

- **Azure Cost Management**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Microsoft
    - Contoso SKU selection: N/A
    - DR uplift options: N/A, Covered as part of the Azure service.

- **Microsoft Defender for Cloud**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Microsoft
    - Contoso SKU selection: N/A
    - DR uplift options: N/A, Covered as part of the Azure service.

- **Azure DNS**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Microsoft
    - Contoso SKU selection: Single Zone - Public
    - DR uplift options: N/A, DNS is highly available by design.

- **Network Watcher**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Microsoft
    - Contoso SKU selection: N/A
    - DR uplift options: N/A, Covered as part of the Azure service.

- **Virtual Networks, including Subnets, user-defined route (UDR) & network security groups (NSG)**
    - Component recovery responsibility: Contoso
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: N/A
    - DR uplift options: [VNETs can be replicated](/azure/virtual-network/virtual-network-disaster-recovery-guidance#business-continuity) into the secondary, paired region.

- **Azure Firewall**
    - Component recovery responsibility: Contoso
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: Standard
    - DR uplift options: Azure Firewall is [highly available by design](/azure/firewall/features#built-in-high-availability) and can be created with [Availability Zones](/azure/firewall/deploy-availability-zone-powershell) for increased availability.

- **Azure DDoS**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: DDoS Network Protection
    - DR uplift options: N/A, Covered as part of the Azure service.

### Stateful data platform-specific services

- **Storage Account: Azure Data Lake Gen2**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: LRS
    - DR uplift options: Storage Accounts have a broad range of [data redundancy](/azure/storage/common/storage-redundancy) options from primary region redundancy up to secondary region redundancy.
    - Notes
        - GRS is recommended to uplift redundancy, providing a copy of the data in the paired region.

- **Azure Database for PostgreSQL Flexible Server**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: General Purpose or Memory Optimized tiers
    - DR uplift options:
        - Enable Geo-redundant backup storage for restore in paired region.
        - Configure Cross-region read replicas for DR and read scale.
    - Notes:
        - Automatic backups with retention up to 35 days; HA with zone redundancy available.
        - For details on Azure CosmosDB disaster recovery, see [Geo-disaster recovery in Azure Database for PostgreSQL](/azure/postgresql/flexible-server/concepts-geo-disaster-recovery)

- **Azure Databricks**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: Premium or Enterprise tier
    - DR uplift options:
        - Deploy secondary workspace in a paired region and replicate configurations and data.
        - Use Azure Storage geo-redundant options for underlying data in ADLS Gen2.
    - Notes:
        - In-region HA is built-in with zone redundancy; cross-region DR requires manual setup.
        - For details on Azure Databricks disaster recovery, see [Disaster recovery - Azure Databricks](/azure/databricks/admin/disaster-recovery).

- **Azure Data Explorer**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: Pay As You Go (or cluster size based on workload)
    - DR uplift options:
        - Azure Data Explorer does not provide automatic regional failover. For disaster recovery, deploy multiple clusters in paired regions (Active/Active or Active/Passive) and replicate ingestion pipelines.
        - Use Zone Redundant Storage (ZRS) for intra-region resiliency and select Availability Zones during cluster creation to protect against zone-level failures. For regional resiliency, combine ZRS with multi-cluster architecture and ingestion redundancy via Event Hubs or IoT Hub.
    - Note:
        - For details on Azure Data Explorer disaster recovery, see [Disaster Recovery - Azure Data Explorer](/azure/data-explorer/business-continuity-overview).
  
- **Azure Event Hubs**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: Standard/Premium/Dedicated tiers
    - DR uplift options:
        - Enable Geo-disaster recovery for metadata replication across paired namespaces.
        - For full data replication, use Geo-replication (Premium/Dedicated tiers only).
    - Notes:
        - Geo-disaster recovery replicates metadata only, not event data.
        - Geo-replication replicates both metadata and data for business continuity.
        - For details on Azure Event Hubs disaster recovery, see [Azure Event Hubs - Geo-disaster recovery](/azure/event-hubs/event-hubs-geo-dr).

- **Azure Machine Learning**
    - Component recovery responsibility: Contoso and Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: General Purpose, D Series instances
    - DR uplift options:
        - Azure Machine Learning depends on multiple Azure services, some of which are [provisioned in the customer's subscription](/azure/machine-learning/how-to-high-availability-machine-learning#understand-azure-services-for-azure-machine-learning). As such, the customer remains responsible for the high-availability configuration of these services.
        - Resiliency can be uplifted via a [multi-regional deployment](/azure/machine-learning/how-to-high-availability-machine-learning#plan-for-multi-regional-deployment).
    - Notes:
        - Azure Machine Learning itself doesn't [provide automatic failover or disaster recovery](/azure/machine-learning/how-to-high-availability-machine-learning).

- **Azure SQL Database**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: Business Critical or Premium tier recommended
    - DR uplift options:
        - Enable Failover Groups for automatic cross-region failover.
        - Use Active Geo-replication for readable secondary databases.
        - Configure Geo-redundant backup storage for geo-restore capability.
    - Notes:
        - For details on Azure SQL Database disaster recovery, see [Disaster recovery guidance - Azure SQL Database](/azure/azure-sql/database/disaster-recovery-guidance).

- **Dataverse**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Microsoft
    - Contoso SKU selection: N/A
    - DR uplift options:
        - Built-in DR with Azure availability zones for in-region resilience.
        - Self-service cross-region failover available for production environments.
    - Notes:
        - For details on Dynamics 365 and Power Platform disaster recovery SaaS applications, see [Business continuity and disaster recovery - Dynamic 365 and Power Platform](/power-platform/admin/business-continuity-disaster-recovery)

- **Power BI**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Microsoft
    - Contoso SKU selection: Power BI Pro
    - DR uplift options: N/A, Power BI's resiliency is part of its SaaS offering.
    - Notes
        - Power BI resides in the Office365 tenancy, not that of Azure.
        - [Power BI uses Azure Availability Zones](/power-bi/enterprise/service-admin-failover#what-does--high-availability--mean-for-power-bi-) to protect Power BI reports, applications and data from datacenter failures.
        - In the case of regional failure, Power BI will [failover to a new region](/power-bi/enterprise/service-admin-failover#what-is-a-power-bi-failover-), usually in the same geographical location, as noted in the [Microsoft Trust Center](https://www.microsoft.com/en-us/trust-center/product-overview?rtc=1).

- **Microsoft Purview**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: N/A
    - DR uplift options: N/A
    - Notes
        - [Microsoft Purview doesn't support automated business continuity and disaster recovery (BCDR)](/azure/purview/disaster-recovery#achieve-business-continuity-for-azure-purview). Until that support is added, the customer is responsible for all backup and restore activities.

 - **Microsoft Fabric: OneLake**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: Fabric Capacity
    - DR uplift options:
        - Enable BCDR for Fabric capacity.
    - Notes
        - For further details regarding disaster recovery for OneLake, refer to [Disaster recovery and data protection for OneLake](/fabric/onelake/onelake-disaster-recovery).

- **Microsoft Fabric: SQL database in Fabric**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: Fabric Capacity
    - DR uplift options:
        - Manual geo-backup or geo-replication for active/active setups across regions.
    - Notes
        - Geo-redundancy must be manually configured.
        - For further details regarding disaster recovery for SQL Databse in Fabric, refer to [Experience-specific disaster recovery guidance - SQL Database](/fabric/security/experience-specific-guidance#sql-database).

- **Microsoft Fabric: Data Engineering**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: Fabric Capacity (Memory Optimized SKU)
    - DR uplift options:
        - Backup notebooks, Spark job definitions, and Lakehouse data in a workspace in another region.
    - Notes
        - Notebooks can be redployed via CI/CD.
        - For further details regarding disaster recovery for Data Engineering in Fabric, refer to [Experience-specific disaster recovery guidance - Data Engineering](/fabric/security/experience-specific-guidance#data-engineering).
        
- **Microsoft Fabric: Data Warehouse**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: Fabric Capacity
    - DR uplift options:
        - Manual geo-backup or geo-replication for active/active setups across regions.
    - Notes
        - Follow step-by-step guides for [Experience-specific disaster recovery guidance - Data Warehouse](/fabric/security/experience-specific-guidance#data-warehouse).
        - For customers who need cross-regional disaster recovery and fully automated business continuity, we recommend keeping two Fabric Warehouse setups in two different regions and maintaining code and data parity by doing regular deployments and data ingestion to both sites.

- **Microsoft Fabric: SQL Analytics Endpoint**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: Fabric Capacity
    - DR uplift options:
        - Enable DR Capacity in Fabric for cross-region replication of Lakehouse and Warehouse data via OneLake.
        - Use CI/CD pipelines to redeploy SQL objects (views, stored procedures, security roles) in the DR region.
        - Use metadata sync API or UI refresh to ensure SQL endpoint schema is up-to-date after failover.
    - Notes:
        - SQL analytics endpoint is read-only over Delta Lake tables stored in OneLake.

- **Microsoft Fabric: Mirrored Database**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: Fabric Capacity
    - DR uplift options:
        - Manual geo-backup or geo-replication for active/active setups across regions.
    - Note:
        - Mirrored databases from the primary region remain unavailable to customers and the settings aren't replicated to the secondary region.
        - Recreate mirrored database in another workspace from a different region.
      
### Stateless data platform-specific services

  - **Azure AI Foundry**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: Pay As You Go
    - DR uplift options: Applications utilizing Azure OpenAI resources that require strong resiliency and business continuity may need to take [extra measures to reinforce their model infrastructure](/azure/ai-foundry/openai/how-to/business-continuity-disaster-recovery).
    - Notes
        - Refer to [Customer-enabled disaster recovery](/azure/ai-foundry/how-to/disaster-recovery) for guidance on business continuity and disaster recovery with Azure AI Foundry.

- **Microsoft Fabric: Real-Time Intelligence**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: Fabric Capacity
    - DR uplift options:
        - Configure two or more KQL databases in different regions, and keep data and policies in sync between the databases. 
    - Notes
        - Refer to recovery procedures for [Experience-specific disaster recovery guidance - Real-Time Intelligence](/fabric/security/experience-specific-guidance#real-time-intelligence).

- **Microsoft Fabric: Data Factory**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: Fabric Capacity
    - DR uplift options:
        - Cross-region pipeline deployment.
    - Notes
        - Pipelines can be redeployed via CI/CD.
        - When On-Prem or vNet Data Gateway are used in data pipelines, the gateways need to be reconfigured in another workspace from a different region.
        - Follow step-by-step guides for [Experience-specific disaster recovery guidance - Data Factory](/fabric/security/experience-specific-guidance#data-factory).

- **Microsoft Fabric: Data Science**
    - Component recovery responsibility: Microsoft
    - Workload/configuration recovery responsibility: Contoso
    - Contoso SKU selection: Fabric Capacity
    - DR uplift options:
        - Create workspaces in two different regions, then copy your data and import notebooks, machine learning experiments and models into the secondary workspace.
    - Notes
        - Disaster recovery for Data Science in Microsoft Fabric involves manual copying and recreation of resources in a secondary region, with no built-in cross region replication.
        - For further details regarding disaster recovery for Fabric Data Science, refer to [Disaster recovery guidance for Fabric Data Science](/fabric/data-science/data-science-disaster-recovery).

## Stateful vs stateless components

The speed of innovation across the Microsoft product suite means the set of components used in this example will continue to evolve. To help future-proof this guidance and make it easier to apply to components not explicitly covered here, the section below offers direction based on a simple classification of state.

A component or service is considered stateful if it's designed to retain information from previous events or interactions. Examples include Lakehouse, Eventhouse, and Warehouse, which store data and metadata that must be protected and recovered. By contrast, stateless components keep no record of prior interactions; each request is processed independently using only the information provided at that moment. Examples include Data Factory and Notebooks, which orchestrate or process data without persisting it, relying on external stateful components for storage.

For a DR scenario that calls for redeployment:

- Components/services that are "stateless", like Azure Functions and Azure Data Factory pipelines, can be redeployed from source control with at least a smoke test to validate availability before being introduced into the broader system.
- Components/services that are "stateful", like Azure SQL Database and storage accounts, require more attention.
    - When procuring the component, a key decision will be selecting the data redundancy feature. This decision typically focuses on a trade-off between availability and durability with operating costs.
- Datastores will also need a data backup strategy. The data redundancy functionality of the underlying storage mitigates this risk for some designs, while others, like SQL databases will need a separate backup process.
    - If necessary, the component can be redeployed from source control with a validated configuration via a smoke-test.
    - A redeployed datastore must have its dataset rehydrated. Rehydration can be accomplished through data redundancy (when available) or a backup dataset. When rehydration has been completed, it must be validated for accuracy and completeness.
        - Depending on the nature of the backup process, the backup datasets might require validation before being applied. Backup process corruption or errors might result in an earlier backup being used in place of the latest version available.
    - Any delta between the component date/timestamp and the current date should be addressed by reexecuting or replaying the data ingestion processes from that point forward.
    - Once the component's dataset is up to date, it can be introduced into the broader system.

## Other key services

This section contains high availability (HA) and DR guidance for other key Azure data components and services.

- Azure Analysis Services - HA guidance can be found in the [product documentation](/analysis-services/azure-analysis-services/analysis-services-bcdr).
- Azure Database for MySQL
    - Flexible Server HA guidance can be found in the [product documentation](/azure/mysql/flexible-server/concepts-business-continuity).
    - Single Server HA guidance can be found in the [product documentation](/azure/mysql/).
- SQL
    - SQL on Azure VMs guidance can be found in the [product documentation](/azure/azure-sql/virtual-machines/windows/business-continuity-high-availability-disaster-recovery-hadr-overview).
    - Azure SQL and Azure SQL Managed Instance guidance can be found in the [product documentation](/azure/azure-sql/database/business-continuity-high-availability-disaster-recover-hadr-overview).
- Azure AI services - If AI services has been deployed via customer deployed [Docker containers](/azure/ai-services/cognitive-services-container-support), recovery remains the responsibility of the customer.
- Azure AI Search - There's [no built-in mechanism for disaster recovery](/azure/reliability/reliability-ai-search#disaster-recovery-and-service-outages). If continuous service is required during a catastrophic failure, the recommendation is to have a second service in a different region, and implementing a geo-replication strategy to ensure indexes are fully redundant across all services.
- Azure IoT Hubs - IoT Hub provides Microsoft-Initiated Failover and Manual Failover by replicating data to the paired region for each IoT hub. IoT Hub provides [Intra-Region HA](/azure/iot-hub/how-to-schedule-broadcast-jobs?pivots=programming-language-csharp#intra-region-ha) and will automatically use an availability zone if created in a [predefined set of Azure regions](/azure/iot-hub/how-to-schedule-broadcast-jobs?pivots=programming-language-csharp#availability-zones).
- Azure Stream Analytics - While Azure Stream Analytics is a fully managed platform as a service (PaaS) offering, it doesn't provide automatic geo-failover. [Geo-redundancy](/azure/stream-analytics/geo-redundancy) can be achieved by deploying identical Stream Analytics jobs in multiple Azure regions.
- Azure Data Share - The Azure Data Share resiliency can be uplifted by [HA deployment into a secondary region](/azure/data-share/disaster-recovery#achieving-business-continuity-for-azure-data-share).

## Next steps
Now that you've learned about the scenario's architecture, you can learn about the [scenario details](../disaster-recovery/dr-for-azure-data-platform-scenario-details.yml).

## Related resources

- [DR for Azure Data Platform - Overview](dr-for-azure-data-platform-overview.yml)
- [DR for Azure Data Platform - Scenario details](dr-for-azure-data-platform-scenario-details.yml)
- [DR for Azure Data Platform - Recommendations](dr-for-azure-data-platform-recommendations.yml)

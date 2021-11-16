Scaling AI and machine learning initiatives in regulated environments poses significant challenges to organizations, no matter their digital maturity and size. In this article, we discuss key architectural decisions to consider when adopting Azure's data engineering and machine learning services in regulated industries. These decisions are based on what was learned from a recent implementation in a Fortune 500 global life sciences and healthcare company.

The architecture presented in this article follows the Enterprise Scale Analytics and AI reference architecture design and was one of its first implementations.

Setup of data science projects and development of machine learning models in life sciences and healthcare environments will, in almost all cases, require access to high business impact data sources. These sources can be clinical trial protocol information (without patient data), molecules chemical formulae, or manufacturing processes secrets, just to list some examples.

In regulated industries, IT systems are classified based on the classification of the data sources those systems access. AI and machine learning environments running on Azure are classified as high business impact (HBI), and are required to comply with an extensive set of information security risk management (ISRM) policies and controls.

In this article, we discuss Azure architectural considerations related to the analysis and implementation of common high-risk tier classification ISRM controls.

## Potential use cases

The architectural considerations discussed in this article have their source in the life sciences and healthcare industries. However, they're also relevant for organizations in other regulated industries, including:

- Financial services
- Healthcare providers
- Oil and gas

Implementation of Enterprise Scale Analytics and AI reference architecture in regulated environments follows similar design patterns.

## Architecture

The architecture is shown in the diagram below and follows the principle of [Enterprise Scale Landing Zones](/azure/cloud-adoption-framework/ready/enterprise-scale/architecture), specifically the Analytics and AI reference architecture.

[![Diagram of a scalable AI platform for regulated industries.](media/scale-ai-and-machine-learning-in-regulated-industries.png)](media/scale-ai-and-machine-learning-in-regulated-industries.png#lightbox)

[Download a copy of this Visio.](https://arch-center.azureedge.net/scalable-ai-platform-regulated-industries-v1.vsdx)

The architecture consists of the workflow described below. Each component of the architecture has a corresponding number in the diagram. We describe the main purpose of the component, how it fits into the architecture, and any other important considerations that should be taken when adopting it:

1. **Platform subscriptions** – Core Azure subscriptions that provide identity (through Azure AD), management, and connectivity. They aren't outlined here in more detail and are assumed to be ready and available as part of the core Enterprise Scale setup.

### Data management

1. **Data Management Zone** – Responsible for data governance across the platform and enforces guardrails to provide more flexibility downstream in the Data Landing Zones. It has its own subscription and hosts centralized services such as data cataloging, monitoring, audits, and so on. This environment is highly controlled and subject to stringent audits. All data classification types are stored in the central data catalog (Azure Purview). Depending on metadata, different policies and access patterns are enforced. There's only one Data Management Zone subscription for the whole tenant. The Data Management Zone is peered (through VNET peering) with all other Data Landing Zones. Private endpoints are used whenever possible to ensure that the deployed services aren't accessible via public internet.
1. **Networking resource group** – Azure Virtual Networks, Network Security Groups, and all other networking-related resources needed for the Data Management Zone are provisioned within this resource group.
1. **Deployment resource group** – Hosts private Azure DevOps CI/CD agents (virtual machines) needed for the Data Management Zone and a Key Vault for storing any deployment-related secrets.
1. **Data governance resource group** – Azure Purview is used as a data governance and data catalog solution and is used to enforce the necessary guardrails for datasets to follow data requirements and data regulations that are imposed by law or other entities. Purview is hosted centrally within this resource group, along with a Key Vault instance for storing secrets.
1. **Centralized assets** – Hosts important and valuable assets that are central to the platform, such as:
   - Azure Container Registries that host base images used in Azure ML-based data products (images that are previously scanned and vulnerability-free)
   - AI/ML models that are published and made available to consumers on the platform (so they can be deployed to one or more data landing zones if needed).
1. **Additional services** – Any other services that should be centralized can be hosted in one of these resource groups, which can include centralized API Management instances, third-party software, and so on.
1. **Data visualization resource group** – Hosts data visualization solutions that are shared across data landing zones. Solutions can be Power BI, Tableau, or any other visualization solution.
1. **Additional infrastructure controls & governance** – Microsoft Defender for Cloud and Azure Monitor are used as baseline security and monitoring solutions.

### Data landing zone

1. **Data Landing Zone** – A subscription that represents a unit of scale within the data platform. Data Landing Zones are deployed based on the core data landing zone architecture (blueprint), including all key capabilities to host an analytics & AI platform. There can be one or many Data Landing Zones within the environment. Azure Policies are applied to keep access and configurations of various Azure services secure. The Data Landing Zone is peered (through VNET peering) with all other Data Landing Zones and the Data Management Zone. Private endpoints are used whenever possible to ensure that the deployed services aren't accessible via public internet.
1. **Networking resource group** – Azure Virtual Networks, Network Security Groups, and all other networking-related resources needed for the Data Landing Zone are provisioned within this resource group.
1. **Deployment resource group** – Hosts private Azure DevOps CI/CD agents (virtual machines) needed for the Data Landing Zone and a Key Vault for storing any deployment-related secrets.
1. **Data storage resource group** – Contains the main data storage accounts for this data landing zone, deployed as Azure Data Lake Storage Gen2, with hierarchical namespace. They're spread across three main areas:
   - **Raw** (where data is ingested from the data source in its original state)
   - **Curated & Enriched** (where data is cleansed, validated, and aggregated)
   - **Workspace** (where specific data products can store their datasets or the outputs of the ML models, and so on.).

    The arrows in the diagrams show the expected data flow, from raw data to curated and enriched (trusted) data, and over to workspace for exploration, analytics, and providing extra value out of the data product.
1. **Data integration resource group** – Hosts an Azure Data Factory that is used to share connectivity with the on-premises self-hosted integration runtime (SHIR). Its main purpose is to establish connectivity, and is reused by other Data Factory instances so that connectivity is maintained only in one place. Its other purpose is to host the self-hosted integration runtime for the Azure Purview service so that it can access the data sources on this data landing zone (for scanning purposes).
1. **Metadata management resource group** – Hosts metadata for Databricks (the Hive meta store) and Azure Data Factory ingestion and processing pipelines, and a Key Vault to store secrets for accessing this data. Azure SQL Database is used to host the metadata.
1. **Data ingestion resource group** – Hosts an Azure Data Factory instance where all data ingestion pipelines specific for a data domain are deployed. Azure Databricks is used as a processing engine to load and transform the data and store it in the data lake accounts.
1. **Analytics resource group** – Includes two shared services for further data analytics and exploration: Azure Synapse and Azure Databricks. Both of these services provide extensive compute and scale for massive data exploration and analytics purposes.
1. **Data product resource group** – A blueprint for a data product, with a resource group containing basic Azure resources that a data product might need. The deployment should be configurable through an Azure DevOps pipeline based on the specific needs of the business. The core Azure services deployed here are as follows:
   - Azure Machine Learning workspace as the basis for any enterprise machine learning project with related services such as Key Vault (for storing secrets)
   - Application Insights (for model monitoring)
   - Azure storage (for storing datasets)
   - An Azure Container Registry for storing model images during development

   Cognitive Services is deployed as a bundle to provide API access to multiple AI-backed services, and Azure Machine Learning Compute Instance and Compute Clusters are used for development and model building / testing purposes. Azure Data Factory is used to orchestrate batch scoring of models (if needed). App Service and Cosmos DB provide an extra layer for deployment of the data product, where a custom application or API can be hosted with its own internal data store.

   Regulated industries usually have strict data access restrictions, and usually allow production data to be hosted only within the production environment. Because of this reason, the development lifecycle of data products is occurring only in the production data landing zone, and a separate environment (resource group) is provisioned for development, testing, and deployment purposes.
1. **Additional data products** – These resource groups host other data products, since one data landing zone can host one or many data products.
1. **Shared compute resource group** – Any shared compute that is needed for hosting and deploying data products is provisioned within this resource group. An Azure Kubernetes cluster is an example.
1. **Additional infrastructure controls & governance** – Microsoft Defender for Cloud, and Azure Monitor are used as baseline security and monitoring solutions.
1. **Additional Data Landing Zones** – A placeholder for extra Azure subscriptions that would be used for hosting new data landing zones. They're based on criteria mentioned before, such as data residency requirements, or a different business unit that has its own cross-functional team and a set of use cases to be delivered.

### Components

- [Azure Active Directory](https://azure.microsoft.com/services/active-directory)
- [Azure Purview](https://azure.microsoft.com/services/purview)
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network)
- [Azure DevOps](https://azure.microsoft.com/services/devops)
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry)
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning)
- [Microsoft Defender for Cloud](https://azure.microsoft.com/services/security-center)
- [Azure Monitor](https://azure.microsoft.com/services/monitor)
- [Azure Policy](https://azure.microsoft.com/services/azure-policy)
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage)
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory)
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database)
- [Azure Databricks](https://azure.microsoft.com/services/databricks)
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics)
- [Azure Kubernetes Service](https://azure.microsoft.com/services/kubernetes-service)

### Alternatives

In distributed organizations, business groups operate independently and with high degrees of autonomy. As such, they might consider an alternative solution design, with full isolation of use cases in Azure landing zones, sharing a minimal set of common services. Although this design allows a fast start, it requires high effort from IT and ISRM organizations, since design of individual use cases will quickly diverge from blueprint designs. Additionally, it requires independent ISRM processes, and audits, for each of the AI/ML "products" hosted in Azure.

## Design principles

This architecture is based on the following principles:

- It follows the concept of Enterprise-scale, which is an architectural approach and a reference implementation aligned with the Azure roadmap and part of the Microsoft Cloud Adoption Framework (CAF). It enables effective construction and operationalization of landing zones on Azure, at scale. The name Landing Zone is used as a boundary in which new or migrated applications land in Azure, and in this scenario, it refers to parts of the data platform that are used to host the data and the AI/ML models.
- Traditional monolithic data platform architectures have an inherent limitation that slows the delivery of features and values. The architecture described here lets organizations scale their data estate and address the challenges of a centralized monolithic data lake by using a decentralized approach with separation of ownership (data mesh). The approach lets organizations scale to thousands of ingest pipelines and data products, while keeping the data platform secure and maintainable by decoupling the core data platform and data management services (deployed in a separate landing zone called Data Management Zone) from data domains and data products (deployed to one or more Data Landing Zones).
- Subscriptions are used as units of management and scale aligned with business needs and priorities. Scaling is achieved by providing new subscriptions (Data Landing Zones) to business units, based on criteria such as different business stakeholders, different business goals and requirements, and data residency requirements (where data needs to be hosted in a specific geo-region).
- Azure Policies are used to provide guardrails and ensure continued compliance within the company's IT landscape.
- Single control and management plane (through the Azure portal) provides a consistent experience across all Azure resources and provisioning channels subject to role-based access and policy-driven controls. Azure-native platform services and capabilities are used whenever possible.
- Cross-functional teams take ownership of the design, development, and operations to shorten the time to market and the agility within the platform. Core principles like DevOps, Infrastructure as Code (IaC), and resilient designs are used to avoid human error and single points of failure.
- Data Domains can be used by domain and data source subject matter experts (SMEs) to pull in data assets from Azure, third-party, or on-premises environments. A Data Domain is a resource group within a Data Landing Zone that can be used by cross-functional teams for custom data ingestion. There can be one or many Data Domains within a Data Landing Zone. Data Domains can be viewed similarly to domains in Domain Driven Design (DDD) where they provide a context boundary and are self-sufficient and isolated. An example of a Data Domain would be clinical trial data or supply chain data.

## Measuring adoption and value

To scale AI and machine learning in regulated environments, and drive rapid adoption across organization's business areas, we recommend you design and put in place an adoption framework to measure, monitor, and evaluate the value created by the Azure services. From our life sciences and healthcare industry example, the following business value levers and key performance indicators (KPI) were evaluated:

**Scalability** – To ensure Azure architecture can scale alongside business requirements, no matter the scale point, the following KPIs are suggested:

- Number of compute instances, and total storage and memory used
- Number of experiments ran
- Number of models deployed

**Acceleration of AI development** – To accelerate AI/ML solution development, the following KPIs are suggested:

- Number of different business units consuming Azure's AI/ML services
- Number of users onboarded, per category – for example, data engineers, data scientists, citizen data scientists, and business users
- Number of experiments ran
- Time between onboarding of users and active usage
- Time to provision services – from change configuration request to service provisioning completion

**Compliance** – To ensure continuous compliance of deployed AI/ML solutions, the following KPIs are suggested:

- Overall compliancy with applicable ISRM controls
- Number of Security vulnerability warnings
- Number of Security incidents for the last period

**User Experience** – To ensure that high quality and consistent user experiences are available, the following KPIs are suggested:

- Number of user help desk requests
- Net Promoter Score (NPS)

**Secure Foundations** – To ensure safe and secure foundations are in place, the following KPIs are suggested:

- Critical services uptime
- Number of incidents reported related to performance availability

## Considerations

In this section, we discuss lessons learned from the implementation of the architecture described above in a life sciences and healthcare regulated environment. We also cover high-level design considerations to meet common ISRM controls and policies.

### Environments

In regulated environments, IT systems classified as HBI are required to have multiple segregated environments, such as development, quality, and production (or similar). Access to protected data sources is only authorized in production-certified environments.

Since AI and machine learning development requires access to sensitive data sets, the different stages of the MLOps process, such as model build, training, and inference (or similar), will all take place in production. Development and quality environments will typically be restricted to infrastructure, operations, and data engineering type of work, to ensure continuous enhancements as new Azure services and features are made available.

AI and data science development activities are expected to be carried out in production environments, with the exception of sandbox or early exploratory work.

### Encryption

IT systems accessing, storing, and processing sensitive business data are required to implement specific requirements on encryption keys management, like FIPS 140-2 level 2 or level 3 policies, with Customer-Managed Keys (CMK) integration. Protected data must always be encrypted at rest and in transit, using TLS 1.2 or higher protocols.

During architecture design, a careful analysis of the support and integration of Azure services to an organization's CMK infrastructure is required. Any exceptions to data encryption must be documented. Support for hardware security module (HSM) vendors is always being expanded, and additional information can be found at [Azure Key Vault Managed Hardware Security Module](/azure/storage/common/customer-managed-keys-overview).

### Network design and ring fencing

AI/ML environments must have ring-fencing in place, with network segmentation and network access controls implemented. Network communication between architecture components is limited to required data flows and underlying infrastructure to function (in an allowlisting approach). Signature-based analysis and behavior-based analysis should be applied.

Enforce network access controls across several layers in the architecture, including Azure Firewalls, inspecting inbound and outbound network connectivity, network security groups (NSGs), and access to web application endpoint protected with web application firewall (WAF).

### Logging and monitoring

All Azure services must ingest their security events into an organization's Security Operations Center (SOC) platform, and the following security events should be recorded:

- Successful and failed authentication attempts
- Sensitive data access
- Changes to security policy
- Changes to admin user groups, users, or roles
- Sensitive data transfers to external locations, if applicable
- Activation and deactivation of protection systems (such as ABAC controls)
- Updated access to logs and interruption to logging

Azure security logs can be ingested into SOC through different patterns:

- A central Azure Log Analytics workspace
- Event Hub connected to SOC platform systems, such as Splunk
- Windows VM and other compute resources deployed with SOC agents

### Authorization management

AI and machine learning environments running on Azure must be integrated with an organization's main account provisioning system, where requests to grant access to critical business applications are submitted, approved, and audited.

Account provisioning systems are expected to connect to an organization's Active Directory and Azure Active Directory (AAD), so that business authorization roles map to corresponding AD/AAD security groups.

AI/ML environments follow a Role-Based Access Control (RBAC) model, and access level control authorizations ensure that users can only perform the tasks and actions for their job role and business requirement. Machine learning use cases are expected to be high segregated, as data scientists working in a particular use case are only allowed to access the resources part of that use case, following a principle of least privilege. These resources can include:

- Storage accounts
- Azure Machine Learning (AML) workspaces
- Computing instances

Role-Based Access Control (RBAC) uses security groups in Azure Active Directory (AAD).

### Multifactor authentication

Multifactor authentication (MFA) must be in place and implemented for access to all environments running on Azure and classified as high-business impact. MFA can be enforced using Azure Active Directory Multi-Factor Authentication (MFA) services. Application endpoints &mdash; including Azure DevOps, Azure Management Portal, Azure Machine Learning, Databricks, and Azure Kubernetes Services (AKS) &mdash; are expected to be configured in MFA access control policies.

MFA must be enforced to all users, including Azure service managers, data engineers, and data scientists.

### DevOps

In regulated environments, IT systems must follow strict waterfall-style quality control processes, with formal approvals (or gates) between process phases &mdash; like user requirements specifications, functional specifications, design, and testing specifications (or similar) &mdash; with extensive and time-consuming supporting documentation.

Azure environments and data science development follow iterative processes, anchored in a DevOps culture. A significant effort in scaling AI/ML initiatives will be spent communicating the pillars of a DevOps organization and creating automated end-to-end traceability mapping between Azure DevOps epics, features, user stories, test plans and CI/CD pipelines, and required quality control entities and evidence.

## Pricing

Cost management is an important part of design in the implementation of scalable AI/ML platforms, since running costs don't follow simple and predictable patterns. Cost is primarily driven by the number and size of the AI/ML experiments being executed in the platform, and more specifically, on the number and SKUs of the compute resources used in model training and inference.

Below are some highly recommended practices:

- Every use case and AI/ML "product" should have its own Azure services budget, contributing to a good cost management practice.
- Establish a transparent cost model for platform shared services.
- Use tags consistently to associate use case and "product" resources with cost centers.
- Use Azure Advisor and Azure Budget to understand where resources aren't being used in the most optimal way and review configurations regularly.

## Next steps

Learn how to train and deploy models and manage the ML lifecycle (MLOps) with Azure Machine Learning. Tutorials, code examples, API references, and more, available here:

- [Azure Machine Learning Documentation](/azure/machine-learning)

Learn how to implement an enterprise scale landing zone for data analytics and AI in Azure:

- [Enterprise Scale Analytics and AI reference architecture](/azure/cloud-adoption-framework/scenarios/data-management/enterprise-scale-landing-zone)

Product documentation:

- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning)
- [Machine Learning Operations (MLOps)](https://azure.microsoft.com/services/machine-learning/mlops)
- [Azure Databricks](https://azure.microsoft.com/services/databricks)
- [Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)

## Related resources

Azure Architecture Center overview articles:

- [Machine learning at scale](/azure/architecture/data-guide/big-data/machine-learning-at-scale)
- [Implementing the Azure blueprint for AI](/previous-versions/azure/industry-marketing/health/sg-healthcare-ai-blueprint)
- [Microsoft Azure Well-Architected Framework](/azure/architecture/framework)

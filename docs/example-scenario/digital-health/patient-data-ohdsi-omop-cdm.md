The ability to federate, harmonize, visualize, segment, and analyze clinical patient data has rapidly become a popular use case in the healthcare industry. Many organizations, including academic institutions, government agencies, and organizations in the private sector, are looking for ways to use of their patient health data in the acceleration of research and development. Unfortunately, most IT teams struggle to collaborate effectively with researchers to provide a work environment where researchers can feel productive and empowered.

[OHDSI](https://ohdsi.org/who-we-are) (Observational Health Data Sciences and Informatics) is an initiative that includes thousands of collaborators in over 70 countries across the globe. It offers one of few available solutions in an open-source format for researchers. OHDSI created and maintains the [OMOP CDM](https://www.ohdsi.org/data-standardization/the-common-data-model) (Observational Medical Outcomes Partnership Common Data Model) standard and associated OHDSI software tools to visualize and analyze their clinical health data. These tools facilitate the design and execution of analyses on standardized, patient-level, observational data.

OHDSI on Azure allows organizations that want to use the OMOP CDM and the associated analytical tools to easily deploy and operate the solution on the Azure platform.

### Potential use cases

Several types of healthcare organizations can benefit from this solution, including:

- Academic institutions that want to enable scientific researchers to tackle observational cohort studies by using clinical data.
- Governmental agencies that want to federate large amounts of disparate data sources to accelerate scientific discovery.
- Private sector companies that want to streamline the identification of potential patients for clinical trials.

## Architecture

:::image type="content" source="images/ohdsi-azure.png" alt-text="Diagram that shows an architecture for analyzing patient data by using OHDSI." lightbox="images/ohdsi-azure.png":::

link

The preceding diagram illustrates the solution architecture at a high level. The solution is made up of two major resource groups:
- Bootstrap resource group. A foundational set of Azure resources that support the deployment of the OMOP resource group.
- OMOP resource group. Contains the OHDSI-specific Azure resources.

All deployment automation is orchestrated via Azure Pipelines.

This article is primarily intended for DevOps engineering teams. If you plan to deploy this scenario, you should have experience with the Azure portal and Azure DevOps.

### Workflow

1. Deploy the Bootstrap resource group to support the resources and permissions needed for deployment of the OHDSI resources.
1. Deploy the OMOP resource group for the OHDSI-specific Azure resources. This should complete all your infrastructure-related setup.
1. Provision the OMOP CDM and vocabularies to deploy the data model and populate the [OMOP controlled vocabularies](https://ohdsi.github.io/TheBookOfOhdsi/StandardizedVocabularies.html) into the Azure SQL CDM.
1. Deploy the OHDSI applications:
   1. Set up the Atlas UI and WebAPI using the BroadSea WebTools image. [Atlas](https://www.ohdsi.org/atlas-a-unified-interface-for-the-ohdsi-tools) is a web UI that integrates features from various OHDSI applications, which is supported by the [WebAPI](https://www.ohdsi.org/web/wiki/doku.php?id=documentation:software:webapi) layer.
   1. Set up Achilles and Synthea using the BroadSea Methods image. [Achilles](https://www.ohdsi.org/web/wiki/doku.php?id=documentation:software:achilles) is an R-based script that runs data characterization and quality assessments on the OMOP CDM. The [Synthea ETL](https://github.com/OHDSI/ETL-Synthea) script is an optional tool that allows the user to load synthetic patient data into the OMOP CDM.
   
### Components

- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) is the Microsoft multitenant cloud-based directory and identity management service. Azure AD is a foundational service that's used to manage permissions for environment deployment.
- [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines) automatically builds and tests code projects. This [Azure DevOps](https://azure.microsoft.com/services/devops) service combines continuous integration (CI) and continuous delivery (CD). Azure Pipelines uses these practices to constantly and consistently test and build code and ship it to any target. These pipelines are define and run this deployment approach for OHDSI on Azure.
- [Azure Virtual Machine Scale Sets](https://azure.microsoft.com/services/virtual-machine-scale-sets) enable you to create and manage a group of heterogeneous load-balanced virtual machines (VMs). These VMs coordinate the deployment of the environment.
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) is a storage service that's optimized for storing massive amounts of unstructured data. Blob Storage is used to store the [Terraform state file](/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli) and the raw [OMOP vocabulary files](https://www.ohdsi.org/data-standardization/vocabulary-resources) (before ingestion into the CDM).
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault) is an Azure service for storing and accessing secrets, keys, and certificates with improved security. Key Vault provides HSM-backed security and audited access through role-based access controls that are integrated with Azure AD. In this architecture, Key Vault stores all secrets, including API keys, passwords, cryptographic keys, and certificates.
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) is a fully managed platform as a service (PaaS) database engine. SQL Database handles database management functions like upgrading, patching, backups, and monitoring. This service houses the OMOP CDM and all associated relational data.
- [Azure Web Application Firewall](https://azure.microsoft.com/services/web-application-firewall) helps protect applications from common web-based attacks like [OWASP](https://owasp.org) vulnerabilities, SQL injection, and cross-site scripting. This technology is cloud native. It doesn't require licensing and is pay-as-you-go.
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry) enables you to build, store, and manage container images and artifacts in a private registry for all types of container deployments. In this solution, it stores the various OHDSI application images (BroadSea WebTools and BroadSea Methods) for deployment into Azure App Service.
- [Azure App Service](https://azure.microsoft.com/services/app-service) is an HTTP-based service for hosting web applications, REST APIs, and mobile back ends. This service supports the OHDSI WebAPI and Atlas applications.

### Alternatives

If you require more scalability or control, consider these alternatives:

- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) or [Azure Container Apps](https://azure.microsoft.com/services/container-apps) instead of App Service.
- [Azure Synapse](https://azure.microsoft.com/services/synapse-analytics) instead of Azure SQL Database.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Azure SQL Database includes zone-redundant databases, failover groups, geo-replication, and automatic backups. These features allow your application to continue running if there's a maintenance event or outage. For more information, see [Azure SQL Database availability capabilities](/azure/sql-database/sql-database-technical-overview#availability-capabilities).

You might want to consider using Application Insights to monitor the health of your application. With Application Insights, you can generate alerts and respond to performance problems that would affect the customer experience. For more information, see [What is Application Insights?](/azure/application-insights/app-insights-overview).

For other reliability articles, see [Designing reliable Azure applications](/azure/architecture/framework/resiliency/app-design).

### Security

This scenario uses [Managed identities for Azure resources](/azure/active-directory/managed-identities-azure-resources/overview), which provide an identity for applications to use when connecting to resources that support Azure Active Directory (Azure AD) authentication. This eliminates the need for engineers to manage secrets and credentials for each Azure resource.

[SQL Database uses a layered approach](/azure/azure-sql/database/security-overview) to protect customer data, which covers network security, access management, threat protection and information protection. For additional information on SQL Database security, see [Azure SQL Database security and compliance](/azure/sql-database/sql-database-technical-overview#advanced-security-and-compliance).

If secure networking is a critical requirement, consider using [Azure Private Link](/azure/private-link/private-link-overview) to securely [connect Azure App Service to Azure SQL](/azure/architecture/example-scenario/private-web-app/private-web-app). This removes public internet access to the SQL database, which is a commonly used attack vector. You can also use [Azure Private Endpoints for Azure Storage](/azure/storage/common/storage-private-endpoints) to securely access data over an Azure Private Link. These additions are not currently included in the solution but can be added in as required.

For general guidance on designing secure solutions, see the [Azure Security documentation](/azure/security).

### Cost optimization

To better understand the cost of running this scenario on Azure, use the [Azure pricing calculator](https://azure.com/e/c57b00bcd0f747e296b1c2bcc3986957). This estimate assumes the default configuration of all Azure resources deployed via infrastructure as code. These cost estimates can change based on the size of your data, and from other potentially shared resources in your organization (for example, Azure Active Directory and Azure Dev Ops).

### Performance efficiency

This scenario uses Azure App Service, which can be enabled to automatically scale the number of instances that support the Atlas UI. This functionality allows us to keep up with end-user demand. For more information on auto-scale, see [Autoscaling best practices](../../best-practices/auto-scaling.md) in the Azure Architecture Center.

For other scalability articles, see the [performance efficiency checklist](/azure/architecture/framework/scalability/performance-efficiency) in the Azure Architecture Center.

## Deploy this scenario

Check out our [OHDSI on Azure OSS project](https://github.com/microsoft/OHDSIonAzure) for guides on how to deploy an OHDSI tool suite and additional detailed technical documentation.

## Next steps

- [OHDSI on Azure – Introduction](https://github.com/microsoft/OHDSIonAzure/blob/main/README.md)
- [Creating your OHDSI CDM environment](https://github.com/microsoft/OHDSIonAzure/blob/main/docs/creating_your_environment.md)

## Related resources

- [OHDSI homepage](https://www.ohdsi.org)
- [OHDSI Atlas demo environment](https://atlas-demo.ohdsi.org/#/home)
- [OHDSI GitHub](https://github.com/OHDSI)
- [OHDSI YouTube channel](https://www.youtube.com/user/OHDSIJoinTheJourney)
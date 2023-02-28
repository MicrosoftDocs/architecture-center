Observational Health Data Sciences and Informatics (OHDSI) created and maintains the [Observational Medical Outcomes Partnership Common Data Model (OMOP CDM)](https://www.ohdsi.org/data-standardization/the-common-data-model) standard and associated OHDSI software tools to visualize and analyze clinical health data. These tools facilitate the design and execution of analyses on standardized, patient-level, observational data.

OHDSI on Azure allows organizations that want to use the OMOP CDM and the associated analytical tools to easily deploy and operate the solution on the Azure platform.

*"Terraform" is either a registered trademark or a trademark of HashiCorp in the United States and/or other countries. No endorsement by HashiCorp is implied by the use of this mark.*

## Architecture

:::image type="content" source="images/ohdsi-omop-azure.png" alt-text="Diagram that shows an architecture for analyzing patient data by using OHDSI." lightbox="images/ohdsi-omop-azure.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/ohdsi-azure.vsdx ) of this architecture.*

The preceding diagram illustrates the solution architecture at a high level. The solution is made up of two major resource groups:
- **Bootstrap resource group.** Contains a foundational set of Azure resources that support the deployment of the OMOP resource group. 
- **OMOP resource group.** Contains the OHDSI-specific Azure resources.

Azure Pipelines orchestrates all deployment automation.

This article is primarily intended for DevOps engineering teams. If you plan to deploy this scenario, you should have experience with the Azure portal and Azure DevOps.

### Workflow

1. Deploy the Bootstrap resource group to support the resources and permissions needed for deployment of the OHDSI resources.
1. Deploy the OMOP resource group for the OHDSI-specific Azure resources. This step should complete your infrastructure-related setup.
1. Provision the OMOP CDM and vocabularies to deploy the data model and populate the [OMOP controlled vocabularies](https://ohdsi.github.io/TheBookOfOhdsi/StandardizedVocabularies.html) into the CDM in Azure SQL.
1. Deploy the OHDSI applications:
   1. Set up the Atlas UI and WebAPI by using the BroadSea WebTools image. [Atlas](https://www.ohdsi.org/software-tools/) is a web UI that integrates features from various OHDSI applications. It's supported by the [WebAPI](https://www.ohdsi.org/web/wiki/doku.php?id=documentation:software:webapi) layer.
   1. Set up Achilles and Synthea by using the BroadSea Methods image. [Achilles](https://www.ohdsi.org/web/wiki/doku.php?id=documentation:software:achilles) is an R-based script that runs data characterization and quality assessments on the OMOP CDM. The [Synthea ETL](https://github.com/OHDSI/ETL-Synthea) script is an optional tool that enables users to load synthetic patient data into the OMOP CDM.
   
### Components

- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) is a multitenant cloud-based directory and identity management service. Azure AD is used to manage permissions for environment deployment.
- [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines) automatically builds and tests code projects. This [Azure DevOps](https://azure.microsoft.com/services/devops) service combines continuous integration (CI) and continuous delivery (CD). Azure Pipelines uses these practices to constantly and consistently test and build code and ship it to any target. Pipelines define and run this deployment approach for OHDSI on Azure.
- [Azure Virtual Machine Scale Sets](https://azure.microsoft.com/services/virtual-machine-scale-sets) enable you to create and manage a group of heterogeneous load-balanced virtual machines (VMs). These VMs coordinate the deployment of the environment.
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) is a storage service that's optimized for storing massive amounts of unstructured data. Blob Storage is used to store the [Terraform state file](/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli) and the raw [OMOP vocabulary files](https://www.ohdsi.org/data-standardization/vocabulary-resources) (before ingestion into the CDM).
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault) is an Azure service for storing and accessing secrets, keys, and certificates with improved security. Key Vault provides HSM-backed security and audited access through role-based access controls that are integrated with Azure AD. In this architecture, Key Vault stores all secrets, including API keys, passwords, cryptographic keys, and certificates.
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) is a fully managed platform as a service (PaaS) database engine. SQL Database handles database management functions like upgrading, patching, backups, and monitoring. This service houses the OMOP CDM and all associated relational data.
- [Azure Web Application Firewall](https://azure.microsoft.com/services/web-application-firewall) helps protect applications from common web-based attacks like [OWASP](https://owasp.org) vulnerabilities, SQL injection, and cross-site scripting. This technology is cloud native. It doesn't require licensing and is pay-as-you-go.
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry) enables you to build, store, and manage container images and artifacts in a private registry for all types of container deployments. In this solution, it stores OHDSI application images (BroadSea WebTools and BroadSea Methods) for deployment into Azure App Service.
- [Azure App Service](https://azure.microsoft.com/services/app-service) is an HTTP-based service for hosting web applications, REST APIs, and mobile back ends. This service supports the OHDSI WebAPI and Atlas applications.

### Alternatives

If you require more scalability or control, consider these alternatives:

- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) or [Azure Container Apps](https://azure.microsoft.com/services/container-apps) instead of App Service.
- [Azure Synapse](https://azure.microsoft.com/services/synapse-analytics) instead of SQL Database.

## Scenario details

The ability to federate, harmonize, visualize, segment, and analyze clinical patient data has rapidly become a popular use case in the healthcare industry. Many organizations, including academic institutions, government agencies, and organizations in the private sector, are looking for ways to use their patient health data to accelerate research and development. Unfortunately, most IT teams struggle to collaborate effectively with researchers to provide a work environment where researchers can feel productive and empowered.

[OHDSI](https://ohdsi.org/who-we-are) is an initiative that includes thousands of collaborators in over 70 countries/regions. It offers one of the few available solutions in an open-source format for researchers. OHDSI created and maintains the [OMOP CDM](https://www.ohdsi.org/data-standardization/the-common-data-model) standard and associated OHDSI software tools to visualize and analyze clinical health data.

### Potential use cases

Several types of healthcare organizations can benefit from this solution, including:

- Academic institutions that want to enable scientific researchers to tackle observational cohort studies by using clinical data.
- Governmental agencies that want to federate large amounts of disparate data sources to accelerate scientific discovery.
- Private sector companies that want to streamline the identification of potential patients for clinical trials.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

SQL Database includes zone-redundant databases, failover groups, geo-replication, and automatic backups. These features allow your application to continue running if there's a maintenance event or outage. For more information, see [Azure SQL Database availability capabilities](/azure/sql-database/sql-database-technical-overview#availability-capabilities).

You might want to consider using Application Insights to monitor the health of your application. With Application Insights, you can generate alerts and respond to performance problems that affect the customer experience. For more information, see [What is Application Insights?](/azure/application-insights/app-insights-overview).

For more information about reliability, see [Designing reliable Azure applications](/azure/architecture/framework/resiliency/app-design).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This scenario uses [Managed identities for Azure resources](/azure/active-directory/managed-identities-azure-resources/overview), which provide an identity for an application to use when it connects to resources that support Azure AD authentication. Managed identities eliminate the need to manage secrets and credentials for each Azure resource.

[SQL Database uses a layered approach](/azure/azure-sql/database/security-overview) to help protect customer data. It covers network security, access management, threat protection, and information protection. For more information on SQL Database security, see [Azure SQL Database security and compliance](/azure/sql-database/sql-database-technical-overview#advanced-security-and-compliance).

If high-security networking is a critical requirement, consider using [Azure Private Link](/azure/private-link/private-link-overview) to [connect App Service to Azure SQL](../../example-scenario/private-web-app/private-web-app.yml). Doing so removes public internet access to the SQL database, which is a commonly used attack vector. You can also use [private endpoints for Azure Storage](/azure/storage/common/storage-private-endpoints) to access data over an Azure private link with increased security. These implementations aren't currently included in the solution, but you can add them if you need to.

For general guidance on designing secure solutions, see the [Azure Security documentation](/azure/security).

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To better understand the cost of running this scenario on Azure, use the [Azure pricing calculator](https://azure.com/e/c57b00bcd0f747e296b1c2bcc3986957). This estimate uses the default configuration of all Azure resources deployed via infrastructure as code. These cost estimates can change based on the size of your data and because of other resources in your organization that might be shared, like Azure AD or Azure DevOps.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

This scenario uses App Service, which you can optionally use to automatically scale the number of instances that support the Atlas UI. This functionality allows you to keep up with end-user demand. For more information about autoscaling, see [Autoscaling best practices](../../best-practices/auto-scaling.md).

For more information, see [Performance efficiency checklist](/azure/architecture/framework/scalability/performance-efficiency).

## Deploy this scenario

See these resources for more information on deploying an OHDSI tool suite and for additional detailed documentation:

- [OHDSI on Azure OSS project](https://github.com/microsoft/OHDSIonAzure)
- [OHDSI on Azure – Introduction](https://github.com/microsoft/OHDSIonAzure/blob/main/README.md)
- [Creating your OHDSI CDM environment](https://github.com/microsoft/OHDSIonAzure/blob/main/docs/creating_your_environment.md)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:

- [Andy Gee](https://www.linkedin.com/in/andy-gee-00946239) | Senior Software Engineer
- [Kaipo Lucas](https://www.linkedin.com/in/kaipolucas) | Senior Program Manager
- [Yvonne Radsmikham](https://www.linkedin.com/in/yvonne-radsmikham-223b4096) | Senior Software Engineer
- [Cory Stevenson](https://www.linkedin.com/in/corygstevenson) | Senior Specialist

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Heather Camm](https://www.linkedin.com/in/heather-camm-2367ba15) | Senior Program Manager
- [Gayatri Jaiswal](https://www.linkedin.com/in/gayatrijaiswal) | Program Manager
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure AD documentation](/azure/active-directory)
- [What is Azure Pipelines?](/azure/devops/pipelines/get-started/what-is-azure-pipelines)
- [What is Azure DevOps?](/azure/devops/user-guide/what-is-azure-devops)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [OHDSI home page](https://www.ohdsi.org)
- [OHDSI Atlas demo environment](https://atlas-demo.ohdsi.org/#/home)
- [OHDSI GitHub](https://github.com/OHDSI)
- [OHDSI YouTube channel](https://www.youtube.com/user/OHDSIJoinTheJourney)
 
## Related resources

- [Solutions for the healthcare industry](../../industries/healthcare.md)
- [What is Microsoft Cloud for Healthcare?](/industry/healthcare/overview)
- [Clinical insights with Microsoft Cloud for Healthcare](../../example-scenario/mch-health/medical-data-insights.yml)
- [Confidential computing on a healthcare platform](../../example-scenario/confidential/healthcare-inference.yml)

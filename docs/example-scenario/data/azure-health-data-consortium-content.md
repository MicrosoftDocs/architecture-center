Traditional clinical trials can be complex, time consuming, and costly. To address these issues, a growing number of healthcare organizations are partnering together to build data consortiums.

Data consortiums offer several benefits:

- Make research data available.
- Provide new revenue streams.
- Lead to cost-effective regulatory decisions by providing quick access to data.
- Keep patients safer and healthier by accelerating innovation.

This architecture outlines a plan for a data consortium that uses Azure components. It offers these capabilities:

- Provide a way for multiple organizations to share data.
- Centralize data orchestration efforts.
- Ensure data security.
- Guarantee patient privacy.
- Support data interoperability.
- Offer customization options to meet specific organizations' requirements.

## Potential use cases

Many types of healthcare professionals can benefit from this architecture:

- Organizations that use real-world observational data like patient outcomes to determine treatments.
- Physicians who specialize in personalized or precision medicine.
- Telemedicine providers who need easy access to patient data.
- Researchers who work with genomic data.

## Architecture

:::image type="complex" source="./media/azure-health-data-consortium-architecture.png" alt-text="Architecture diagram showing a Unisys Dorado mainframe system working with Azure components and with Astadia and Micro Focus emulation technology." border="false":::
   The diagram contains two areas, one for Azure components, and one for on-premises components. The on-premises area is simple, with icons for a user and a network service. The Azure area is complex. Boxes containing icons fill the Azure area. The boxes represent a virtual network, sets of virtual machines, third-party software, database services, storage solutions, and other components. Arrows connect some boxes. Number and letter labels link parts of the diagram with the description in the document.
:::image-end:::

1. Raw data originates in on-premises and third-party sources. Members of the consortium load this data into any of these storage services in Azure Data Share:

   - Synapse Analytics
   - Azure SQL Database
   - Azure Data Lake Gen2
   - Azure Data Explorer

1. The consortium asks members to share data. As data producers, members can either share snapshots or use in-place sharing.

1. As a data consumer, the consortium receives the shared member data. This data enters Azure Data Lake Gen2 in the consortium's Data Share for further transformation.

1. Data Factory and Databricks clean the member data and transform it into a common format.

1. The consortium combines the member data and stores it in a service. The data's structure and volume determine the type of storage service that's most suitable. Possibilities include:

   - Synapse Analytics
   - Azure SQL Database
   - Azure Data Lake Gen2
   - Azure Data Explorer

1. As a data share producer, the consortium invites members to receive data. Members can accept either snapshot data or in-place sharing data.

1. As data consumers, members receive the shared data. The data enters member data stores for research and analysis.


Throughout the system:

- Azure AD, Key Vault, and Security Center manage access and provide security.
- Azure Pipelines, a service of Azure DevOps, builds, tests, and releases code.

### Components

This architecture uses the following components:

- These healthcare platforms provide data:

  - Electronic Health Records (EHRs) are digital versions of real-time information on patients.
  - [Fast Healthcare Interoperability Resources (FHIR)](https://www.hl7.org/fhir/index.html) is a standard for health care data exchange that Health Level Seven International (HL7) publishes.
  - The [Internet of Medical Things (IoMT)](https://azure.microsoft.com/en-us/overview/iot/industry/healthcare/#use-cases) is the collection of medical devices and apps that connect to IT systems through online computer networks.
  - [Genomics](https://www.genome.gov/about-genomics/fact-sheets/A-Brief-Guide-to-Genomics) data provides information on how genes interact with each other and the environment.
  - [Imaging](https://www.dicomstandard.org/) data includes the images that radiology, cardiology imaging, radiotherapy, and other devices produce.
  - Customer relationship management (CRM), billing, and third-party systems provide data on patients.

- These Azure components secure, load, and store data:

  - [Azure Data Share][What is Azure Data Share?] provides a way for multiple organizations to securely share data. With this tool, data providers stay in control of data that they share. And it's simple to manage and monitor who shared what data at what time. Azure Data Share also makes it easy to enrich analytics and AI scenarios by combining data from different members.

  - [Azure Synapse Analytics][What is Azure Synapse Analytics?] is an analytics service for data warehouses and big data systems. With this tool, you can query data with serverless, on-demand resources or with provisioned ones. Azure Synapse Analytics works well with a high volume of structured data.

  - [Azure SQL Database][What is Azure SQL Database?] is a fully managed platform as a service (PaaS) database engine. With AI-powered, automated features, SQL Database handles database management functions like upgrading, patching, backups, and monitoring. This service is a good fit for structured data.

  - [Azure Data Lake Gen2][Introduction to Azure Data Lake Storage Gen2] is a massively scalable and secure data lake for high-performance analytics workloads. This service can manage multiple petabytes of information while sustaining hundreds of gigabits of throughput. Azure Data Lake Gen2 provides a way to store structured and unstructured data from multiple members in one location.

  - [Azure Data Explorer][What is Azure Data Explorer?] is a fast, fully managed data analytics service. You can use this tool for real-time analysis on large volumes of data. Data Explorer can handle diverse data streams from applications, websites, IoT devices, and other sources. Azure Data Explorer is a good fit for in-place sharing of streaming telemetry and log data.

  - [Azure Data Factory][What is Azure Data Factory?] is a hybrid data integration service. You can use this fully managed, serverless solution for data integration and transformation workflows. It offers a code-free UI and an easy-to-use monitoring panel. In this solution, Data Factory pipelines ingest data from disparate member data shares.

  - [Azure Databricks][What is Azure Databricks?] is a data analytics platform. Based on the latest Apache Spark distributed processing system, Azure Databricks supports seamless integration with open-source libraries. This solution uses Azure Databricks notebooks to transform all member data into a common format.

  - [Azure Active Directory][What is Azure Active Directory?] is a multi-tenant, cloud-based identity and access management service.

  - [Azure Key Vault][About Azure Key Vault] securely stores and controls access to secrets like API keys, passwords, certificates, and cryptographic keys. This cloud service also manages security certificates.

  - [Azure Pipelines][What is Azure Pipelines?] automatically builds and tests code projects. This [Azure DevOps][What is Azure DevOps?] service combines continuous integration (CI) and continuous delivery (CD). Using these practices, Azure Pipelines constantly and consistently tests and builds code and ships it to any target.

  - [Azure Security Center][What is Azure Security Center?] provides unified security management and advanced threat protection across hybrid cloud workloads.

### Customizations

Modify the reference architecture to fit your specific requirements by answering these questions:

- What and where are your data sources?
- What type of Azure services do member data stores use to receive source data?
- What data can members share with the consortium?
- What type of Azure services can the consortium use to receive shared data?
- Is member data already in a common format, or do you need to clean and transform it?
- Can members share data in batches as snapshots? Or can they stream data with in-place sharing?
- What data can the consortium share with members?

### Alternatives

With Azure Data Share, [many alternatives exist for data storage][Supported data stores in Azure Data Share]. Your choice of service depends on your sharing method and your volume and type of data:

- For snapshot sharing of batch data, use any of these services:

  - Azure Synapse Analytics
  - Azure SQL Database
  - Azure Data Lake Gen2
  - Azure Blob Storage

  For more information, see [Modern data warehouse architecture][Modern data warehouse architecture].

- For in-place sharing of streaming telemetry and log data, use Azure Data Explorer. For more information, see [Azure Data Explorer interactive analytics][Azure Data Explorer interactive analytics].

- Some datasets are very large or non-relational. Some don't contain data in standardized formats. For these types of datasets, consider using Blob or Data Lake Storage when receiving data from and sending data to Data Share. These solutions work better than Synapse Analytics or Azure SQL Database in this case. For more information, see [Medical data storage solutions][Medical data storage solutions].

If Data Share isn't a viable option, you can use a site-to-site virtual private network (VPN) to transfer data between member and consortium data stores.

## Considerations

The technologies in this architecture meet most company's requirements for security, scalability and availability. They also help control costs.

### Security considerations

- [Security features in Azure Data Share][Security overview for Azure Data Share] protect data in these ways:

  - Encrypting data at rest, where the underlying data store supports at-rest encryption.
  - Encrypting data in transit by using Transport Layer Security (TLS) 1.2.
  - Encrypting metadata about a data share at rest and in transit.
  - Not storing contents of shared customer data.

- [Azure Synapse Analytics offers a comprehensive security model][Securing your Data Warehouse with Azure Synapse Analytics]. You can use its fine-grained controls to secure your data at every level, from single cells to entire databases.

- [Azure SQL Database][An overview of Azure SQL Database and SQL Managed Instance security capabilities] uses a layered approach to protect customer data. The strategy covers these areas:

  - network security
  - access management
  - threat protection
  - information protection

- [Azure Data Lake Gen2][Access control lists (ACLs) in Azure Data Lake Storage Gen2] provides access control. The model supports these types of controls:

  - Azure role-based access control (Azure RBAC)
  - Portable Operating System Interface (POSIX) access control lists (ACLs)

- [Azure Data Explorer protects data][Security in Azure Data Explorer] in these ways:

  - Uses Azure AD-managed identities for Azure resources.
  - Uses role-based access control (RBAC) to segregate duties and limit access.
  - Blocks traffic that originates from non-Azure Data Explorer network segments.
  - Safeguards data and helps you comply with committments by using Azure Disk Encryption. This service:
    - Provides volume encryption for virtual machine data disks and the OS.
    - Integrates with Azure Key Vault, which encrypts secrets with Microsoft-managed keys or customer-managed keys.

### Availability considerations

This solution uses a single-region deployment. Some scenarios require a multi-region deployment for high-availability, disaster recovery, or proximity. In those cases, you can use a paired Azure region with the following configurations:

- [Azure Synapse Analytics provides high availability of the warehouse][High availability for Azure Synapse Analytics] by using database snapshots.

- The [high availability architecture of Azure SQL Database][High availability for Azure SQL Database and SQL Managed Instance] provides a 99.99 percent uptime guarantee.

- [Azure Data Explorer offers high availability][High availability of Azure Data Explorer] through a persistence layer, a compute layer, and a leader-follower configuration.

## Pricing

Pricing for this architecture depends on several factors:

- The services you choose
- Your system's capacity and throughput
- The transformations that you use on data
- Your business continuity level
- Your disaster recovery level

For more information, see [pricing details][Azure pricing calculator].

## Next steps

- [Clinical insights with Microsoft Cloud for Healthcare][Clinical insights with Microsoft Cloud for Healthcare]
- [Confidential computing on a healthcare platform][Confidential computing on a healthcare platform]
- [What is Microsoft Cloud for Healthcare?][What is Microsoft Cloud for Healthcare?]

## Related resources

- [Azure API for FHIR](https://azure.microsoft.com/en-us/services/azure-api-for-fhir/)
- [Azure IoT Connector](https://docs.microsoft.com/en-us/azure/healthcare-apis/overview#iot-connector-preview)
- [Microsoft DICOM](https://github.com/microsoft/dicom-server)
- [Microsoft Genomics](https://azure.microsoft.com/en-us/services/genomics/)

[About Azure Key Vault]: /azure/key-vault/general/overview
[Access control lists (ACLs) in Azure Data Lake Storage Gen2]: /azure/storage/blobs/data-lake-storage-access-control
[Azure Data Explorer interactive analytics]: /azure/architecture/solution-ideas/articles/interactive-azure-data-explorer
[Azure pricing calculator]: https://azure.microsoft.com/en-us/pricing/calculator/
[Clinical insights with Microsoft Cloud for Healthcare]: /azure/architecture/example-scenario/mch-health/medical-data-insights
[Confidential computing on a healthcare platform]: /azure/architecture/example-scenario/confidential/healthcare-inference
[High availability of Azure Data Explorer]: /azure/data-explorer/business-continuity-overview#high-availability-of-azure-data-explorer
[High availability for Azure SQL Database and SQL Managed Instance]: /azure/azure-sql/database/high-availability-sla
[High availability for Azure Synapse Analytics]: /azure/cloud-adoption-framework/migrate/azure-best-practices/analytics/azure-synapse
[Introduction to Azure Data Lake Storage Gen2]: /azure/storage/blobs/data-lake-storage-introduction
[Medical data storage solutions]: /azure/architecture/solution-ideas/articles/medical-data-storage
[Modern data warehouse architecture]: /azure/architecture/solution-ideas/articles/modern-data-warehouse
[An overview of Azure SQL Database and SQL Managed Instance security capabilities]: /azure/azure-sql/database/security-overview
[Security in Azure Data Explorer]: /azure/data-explorer/security
[Securing your Data Warehouse with Azure Synapse Analytics]: /resources/videos/securing-your-data-warehouse-with-azure-synapse-analytics/
[Security overview for Azure Data Share]: /azure/data-share/security
[Supported data stores in Azure Data Share]: /azure/data-share/supported-data-stores
[What is Azure Active Directory?]: /azure/active-directory/fundamentals/active-directory-whatis
[What is Azure Data Factory?]: /azure/data-factory/introduction
[What is Azure Data Explorer?]: /azure/data-explorer/data-explorer-overview
[What is Azure Data Share?]: /azure/data-share/overview
[What is Azure Databricks?]: /azure/databricks/scenarios/what-is-azure-databricks
[What is Azure DevOps?]: /azure/devops/user-guide/what-is-azure-devops?view=azure-devops
[What is Azure Pipelines?]: /azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops
[What is Azure Security Center?]: /azure/security-center/security-center-introduction
[What is Azure SQL Database?]: /azure/azure-sql/database/sql-database-paas-overview
[What is Azure Synapse Analytics?]: /azure/synapse-analytics/overview-what-is
[What is Microsoft Cloud for Healthcare?]: /industry/healthcare/overview


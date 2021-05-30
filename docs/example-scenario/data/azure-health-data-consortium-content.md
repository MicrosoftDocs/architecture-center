Traditional clinical trials can be complex, time consuming, and costly. To address these issues, a growing number of healthcare organizations are partnering to build data consortiums for conducting clinical trials.

Data consortiums benefit healthcare in many ways:

- Make research data available.
- Provide new revenue streams.
- Lead to cost-effective regulatory decisions by providing quick access to data.
- Keep patients safer and healthier by accelerating innovation.

This solution for a data consortium uses Azure components. It meets these goals:

- Provide a way for multiple organizations to share data.
- Centralize data orchestration efforts.
- Ensure data security.
- Guarantee patient privacy.
- Support data interoperability.
- Offer customization options to meet specific organizations' requirements.

## Potential use cases

Many types of healthcare professionals can benefit from this solution:

- Organizations that use real-world observational data like patient outcomes to determine treatments.
- Physicians who specialize in personalized or precision medicine.
- Telemedicine providers who need easy access to patient data.
- Researchers who work with genomic data.

## Architecture

:::image type="complex" source="./media/azure-health-data-consortium-architecture.png" alt-text="Architecture diagram showing how members of a consortium share data. The data flow starts with data sources and ends with storage and analysis." border="false":::
   Dotted boxes represent data sources, a member data store, a consortium data store, and shared services. The sources box contains several colored icons that represent data sources. The member and consortium data store boxes contain smaller dotted boxes. In the member box, one smaller box contains icons for Azure components that store and analyze data. The other box contains icons for data share members. The consortium data store box contains a smaller box filled with data storage icons. The consortium box also contains a box with icons for Azure data loading components. Besides those two boxes, the consortium box also contains the same two boxes that the member box contains. Arrows point from left to right between all the boxes. One final arrow loops back from the consortium data share box to the member box. Below those boxes, a dotted box contains icons for shared services.
:::image-end:::

1. Raw data originates in on-premises and third-party sources. Members of the consortium load this data into any of these storage services in Azure Data Share:

   - Azure Synapse Analytics
   - Azure SQL Database
   - Azure Data Lake Storage
   - Azure Data Explorer

1. The consortium asks members to share data. As data producers, members can either share snapshots or use in-place sharing.

1. As a data consumer, the consortium receives the shared member data. This data enters Data Lake Storage in the consortium's Data Share for further transformation.

1. Azure Data Factory and Azure Databricks clean the member data and transform it into a common format.

1. The consortium combines the member data and stores it in a service. The data's structure and volume determine the type of storage service that's most suitable. Possibilities include:

   - Azure Synapse Analytics
   - SQL Database
   - Data Lake Storage
   - Azure Data Explorer

1. As a data share producer, the consortium invites members to receive data. Members can accept either snapshot data or in-place sharing data.

1. As data consumers, members receive the shared data. The data enters member data stores for research and analysis.

Throughout the system:

- Azure Active Directory (Azure AD), Azure Key Vault, and Azure Security Center manage access and provide security.
- Azure Pipelines, a service of Azure DevOps, builds, tests, and releases code.

### Components

This solution uses the following components:

#### Healthcare platforms

- Electronic Health Records (EHRs) are digital versions of real-time information on patients.

- [Fast Healthcare Interoperability Resources (FHIR)][Fast Healthcare Interoperability Resources (FHIR)] is a standard for healthcare data exchange that Health Level Seven International (HL7) publishes.

- The [Internet of Medical Things (IoMT)][Internet of Medical Things (IoMT)] is the collection of medical devices and apps that connect to IT systems through online computer networks.

- [Genomics][Genomics] data provides information on how genes interact with each other and the environment.

- [Imaging][Imaging] data includes the images that radiology, cardiology imaging, radiotherapy, and other devices produce.

- Customer relationship management (CRM), billing, and third-party systems provide data on patients.

#### Azure components

- [Data Share][What is Azure Data Share?] provides a way for multiple organizations to securely share data. With this service, data providers stay in control of data that they share. It's simple to manage and monitor who shared what data at what time. Data Share also makes it easy to enrich analytics and AI scenarios by combining data from different members.

- [Azure Synapse Analytics][What is Azure Synapse Analytics?] is an analytics service for data warehouses and big data systems. With this product, you can query data with serverless, on-demand resources or with provisioned ones. Azure Synapse Analytics works well with a high volume of structured data.

- [SQL Database][What is Azure SQL Database?] is a fully managed platform as a service (PaaS) database engine. With AI-powered, automated features, SQL Database handles database management functions like upgrading, patching, backups, and monitoring. This service is a good fit for structured data.

- [Data Lake Storage][Introduction to Azure Data Lake Storage Gen2] is a massively scalable and secure data lake for high-performance analytics workloads. This service can manage multiple petabytes of information while sustaining hundreds of gigabits of throughput. Data Lake Storage provides a way to store structured and unstructured data from multiple members in one location.

- [Azure Data Explorer][What is Azure Data Explorer?] is a fast, fully managed data analytics service. You can use this service for real-time analysis on large volumes of data. Azure Data Explorer can handle diverse data streams from applications, websites, IoT devices, and other sources. Azure Data Explorer is a good fit for in-place sharing of streaming telemetry and log data.

- [Data Factory][What is Azure Data Factory?] is a hybrid data integration service. You can use this fully managed, serverless solution for data integration and transformation workflows. Data Factory offers a code-free UI and an easy-to-use monitoring panel. In this solution, Data Factory pipelines ingest data from disparate member data shares.

- [Azure Databricks][What is Azure Databricks?] is a data analytics platform. Based on the latest Apache Spark distributed processing system, Azure Databricks supports seamless integration with open-source libraries. This solution uses Azure Databricks notebooks to transform all member data into a common format.

- [Azure AD][What is Azure Active Directory?] is a multi-tenant, cloud-based identity and access management service.

- [Key Vault][About Azure Key Vault] securely stores and controls access to secrets like API keys, passwords, certificates, and cryptographic keys. This cloud service also manages security certificates.

- [Azure Pipelines][What is Azure Pipelines?] automatically builds and tests code projects. This [Azure DevOps][What is Azure DevOps?] service combines continuous integration (CI) and continuous delivery (CD). Using these practices, Azure Pipelines constantly and consistently tests and builds code and ships it to any target.

- [Security Center][What is Azure Security Center?] provides unified security management and advanced threat protection across hybrid cloud workloads.

### Alternatives

With Data Share, [many alternatives exist for data storage][Supported data stores in Azure Data Share]. Your choice of service depends on your sharing method and your volume and type of data:

- For snapshot sharing of batch data, use any of these services:

  - Azure Synapse Analytics
  - SQL Database
  - Data Lake Storage
  - Azure Blob Storage

  For information on combining different types of data, see [Modern data warehouse architecture][Modern data warehouse architecture].

- For in-place sharing of streaming telemetry and log data, use Azure Data Explorer. For more information on analyzing data from various sources, see [Azure Data Explorer interactive analytics][Azure Data Explorer interactive analytics].

- Some datasets are large or non-relational. Some don't contain data in standardized formats. For these types of datasets, Blob Storage or Azure Data Lake Storage work better than Azure Synapse Analytics and SQL Database for exchanging data with Data Share. For more information on storing medical data efficiently, see [Medical data storage solutions][Medical data storage solutions].

If Data Share isn't an option, consider a virtual private network (VPN) instead. You can use a site-to-site VPN to transfer data between member and consortium data stores.

## Considerations

The technologies in this solution meet most companies' requirements for security, scalability, and availability.

### Security considerations

Because of the sensitivity of medical information, several components play a role in securing data:

- [Security features in Data Share][Security overview for Azure Data Share] protect data in these ways:

  - Encrypting data at rest, where the underlying data store supports at-rest encryption.
  - Encrypting data in transit by using Transport Layer Security (TLS) 1.2.
  - Encrypting metadata about a data share at rest and in transit.
  - Not storing contents of shared customer data.

- [Azure Synapse Analytics offers a comprehensive security model][Securing your Data Warehouse with Azure Synapse Analytics]. You can use its fine-grained controls to secure your data at every level, from single cells to entire databases.

- [SQL Database uses a layered approach][An overview of Azure SQL Database and SQL Managed Instance security capabilities] to protect customer data. The strategy covers these areas:

  - Network security
  - Access management
  - Threat protection
  - Information protection

- [Data Lake Storage provides access control][Access control lists (ACLs) in Azure Data Lake Storage Gen2]. The model supports these types of controls:

  - Azure role-based access control (RBAC)
  - Portable Operating System Interface (POSIX) access control lists (ACLs)

- [Azure Data Explorer protects data][Security in Azure Data Explorer] in these ways:

  - Uses Azure AD–managed identities for Azure resources.
  - Uses RBAC to segregate duties and limit access.
  - Blocks traffic that originates from network segments outside Azure Data Explorer.
  - Safeguards data and helps you meet commitments by using [Azure Disk Encryption][Azure Disk Encryption for virtual machines and virtual machine scale sets]. This service provides volume encryption for virtual machine data disks and the OS. Azure Disk Encryption also integrates with Key Vault, which encrypts secrets with Microsoft-managed keys or customer-managed keys.

### Availability considerations

This solution uses a single-region deployment. Some scenarios require a multi-region deployment for high availability, disaster recovery, or proximity. For those cases, the following services offer paired Azure regions for high availability:

- [Azure Synapse Analytics provides high warehouse availability][High availability for Azure Synapse Analytics] by using database snapshots.

- The [high-availability architecture of SQL Database][High availability for Azure SQL Database and SQL Managed Instance] provides a 99.99 percent uptime guarantee.

- [Azure Data Explorer offers high availability][High availability of Azure Data Explorer] through a persistence layer, a compute layer, and a leader-follower configuration.

## Pricing

Pricing for this solution depends on several factors:

- The services you choose
- Your system's capacity and throughput
- The transformations that you use on data
- Your business continuity level
- Your disaster recovery level

For more information, see [pricing details][Azure pricing calculator].

## Next steps

- Learn about related solutions:

  - [Clinical insights with Microsoft Cloud for Healthcare][Clinical insights with Microsoft Cloud for Healthcare]
  - [Confidential computing on a healthcare platform][Confidential computing on a healthcare platform]
  - [What is Microsoft Cloud for Healthcare?][What is Microsoft Cloud for Healthcare?]

- Determine how to customize the solution by clarifying these points:

  - The data sources that are available
  - The location of each data source
  - Which Azure services members can use to receive source data
  - Which data members can share with the consortium
  - How members can share data: In batches as snapshots or as data streams with in-place sharing
  - Which Azure services the consortium can use to receive shared data
  - The format of the member data and whether it needs cleaning or transforming
  - Which data the consortium can share with members

## Related resources

- [Azure API for FHIR][Azure API for FHIR]
- [Azure IoT Connector for FHIR][Azure IoT Connector]
- [Medical Imaging Server for DICOM][Microsoft DICOM]
- [Microsoft Genomics][Microsoft Genomics]

[About Azure Key Vault]: /azure/key-vault/general/overview
[Access control lists (ACLs) in Azure Data Lake Storage Gen2]: /azure/storage/blobs/data-lake-storage-access-control
[Azure API for FHIR]: https://azure.microsoft.com/services/azure-api-for-fhir/
[Azure Data Explorer interactive analytics]: /azure/architecture/solution-ideas/articles/interactive-azure-data-explorer
[Azure Disk Encryption for virtual machines and virtual machine scale sets]: /azure/security/fundamentals/azure-disk-encryption-vms-vmss
[Azure IoT Connector]: /azure/healthcare-apis/fhir/overview#azure-iot-connector-for-fhir-preview
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator/
[Clinical insights with Microsoft Cloud for Healthcare]: /azure/architecture/example-scenario/mch-health/medical-data-insights
[Confidential computing on a healthcare platform]: /azure/architecture/example-scenario/confidential/healthcare-inference
[Fast Healthcare Interoperability Resources (FHIR)]: https://www.hl7.org/fhir/index.html
[Genomics]: https://www.genome.gov/about-genomics/fact-sheets/A-Brief-Guide-to-Genomics
[High availability of Azure Data Explorer]: /azure/data-explorer/business-continuity-overview#high-availability-of-azure-data-explorer
[High availability for Azure SQL Database and SQL Managed Instance]: /azure/azure-sql/database/high-availability-sla
[High availability for Azure Synapse Analytics]: /azure/cloud-adoption-framework/migrate/azure-best-practices/analytics/azure-synapse
[Imaging]: https://www.dicomstandard.org/
[Internet of Medical Things (IoMT)]: https://azure.microsoft.com/overview/iot/industry/healthcare/#use-cases
[Introduction to Azure Data Lake Storage Gen2]: /azure/storage/blobs/data-lake-storage-introduction
[Medical data storage solutions]: /azure/architecture/solution-ideas/articles/medical-data-storage
[Microsoft DICOM]: https://github.com/microsoft/dicom-server
[Microsoft Genomics]: https://azure.microsoft.com/services/genomics/
[Modern data warehouse architecture]: /azure/architecture/solution-ideas/articles/modern-data-warehouse
[An overview of Azure SQL Database and SQL Managed Instance security capabilities]: /azure/azure-sql/database/security-overview
[Security in Azure Data Explorer]: /azure/data-explorer/security
[Securing your Data Warehouse with Azure Synapse Analytics]: https://azure.microsoft.com/resources/videos/securing-your-data-warehouse-with-azure-synapse-analytics/
[Security overview for Azure Data Share]: /azure/data-share/security
[Supported data stores in Azure Data Share]: /azure/data-share/supported-data-stores
[What is Azure Active Directory?]: /azure/active-directory/fundamentals/active-directory-whatis
[What is Azure Data Factory?]: /azure/data-factory/introduction
[What is Azure Data Explorer?]: /azure/data-explorer/data-explorer-overview
[What is Azure Data Share?]: /azure/data-share/overview
[What is Azure Databricks?]: /azure/databricks/scenarios/what-is-azure-databricks
[What is Azure DevOps?]: /azure/devops/user-guide/what-is-azure-devops
[What is Azure Pipelines?]: /azure/devops/pipelines/get-started/what-is-azure-pipelines
[What is Azure Security Center?]: /azure/security-center/security-center-introduction
[What is Azure SQL Database?]: /azure/azure-sql/database/sql-database-paas-overview
[What is Azure Synapse Analytics?]: /azure/synapse-analytics/overview-what-is
[What is Microsoft Cloud for Healthcare?]: /industry/healthcare/overview

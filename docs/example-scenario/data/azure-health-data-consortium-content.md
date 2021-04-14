Traditional clinical trials can be complex, time consuming, and costly. To address these issues, a growing number of healthcare organizations are partnering together to build data consortiums.

Data consortiums offer several benefits:

- Make research data available.
- Provide new revenue streams.
- Lead to cost-effective regulatory decisions by providing quick access to data.
- Keep patients safer and healthier by accelerating innovation.

This architecture for a data consortium uses Azure components. It offers these capabilities:

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



Data flows through the solution as follows:

1. **Data Source to Member Data Store:** Data from various sources whether on-premises or from 3rd party are loaded into one or more the data storage services, including Synapse Analytics, Azure SQL Database, Azure Data Lake Gen2 or Azure Data Explorer in to Members Data Store.
2. **Member as Data Share Producer:** Members, the Data Producers receives a Data Share invitation from Data Consumer Consortium for Snapshot and/or In-Place Sharing to share data from these data storage services.
3. **Consortium as Data Share Consumer:** Consortium, the Data Consumer receives the shared data into Azure Data Lake Gen2 in Consortium Data Share for further transformation.
4. **Consortium Data Transformation:** Data Factory and/or Databricks cleanses and transforms all the Member data into a common format.
5. **Consortium Data Consolidation:** Combined Member's data is stored in one or more data storage services, including Synapse Analytics, Azure SQL Database, Azure Data Lake Gen2 or Azure Data Explorer depending on the structure and volume.
6. **Consortium as Data Share Producer:** Consortium, the Data Producer receives a Data Share invitation from Data Consumer Members for Snapshot and/or In-Place Sharing to share data.
7. **Member as Data Share Consumer:** Members, the Data Consumers receives the shared data into Member Data Store for further research and analysis.

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

### Alternatives

- Use Azure Synapse Analytics, Azure SQL Database, Azure Data Lake Gen2 and Azure Blob Storage for Snapshot Sharing of batch data. For more information, see [Modern Data Warehouse reference architecture](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/modern-data-warehouse).

- Azure Data Explorer for In-Place Sharing of streaming telemetry and log data. See [Azure Data Explorer reference architecture](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/interactive-azure-data-explorer) for more information.

- If the datasets are very large, non-relational or not in a common format, consider using Blob or Data Lake Storage when receiving and sending from Data Share instead of Synapse Analytics or Azure SQL Database. For more information, see [Data Storage reference architecture](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/medical-data-storage).

- If Data Share is not a viable option, a site to site VPN could be used to push data from Member Data Store to Consortium Data Store and vice versa.

## Considerations

The following considerations apply to this solution:

### Security considerations

The technologies in this architecture were chosen because they meet most company's requirements for security, scalability and availability, while helping control costs.

- [Azure Data Share](https://docs.microsoft.com/en-us/azure/data-share/security) leverages the underlying security that Azure offers to protect data at rest and in transit. Data is encrypted at rest, where supported by the underlying data store. Data is also encrypted in transit using TLS 1.2. Metadata about a data share is also encrypted at rest and in transit. Azure Data Share does not store contents of the customer data being shared.

- [Azure Synapse Analytics](https://azure.microsoft.com/en-us/resources/videos/securing-your-data-warehouse-with-azure-synapse-analytics/) provides comprehensive security model gives you the fine grained controls you need to secure your data at every level.

- [Azure SQL Database](https://docs.microsoft.com/en-us/azure/azure-sql/database/security-overview) provides layered defense-in-depth approach to security including network security, access management, threat protection, information protection and customer data.

- [Azure Data Lake Gen2](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-access-control) implements an access control model that supports both Azure role-based access control (Azure RBAC) and POSIX-like access control lists (ACLs). 

- [Azure Data Explorer](https://docs.microsoft.com/en-us/azure/data-explorer/security) uses Azure AD managed identities for Azure resources. Azure Disk Encryption helps protect and safeguard your data to meet your organizational security and compliance commitments. Data is encrypted with Microsoft-managed keys or customer-managed keys.

### Availability considerations

This solution is currently designed as a single-region deployment. If your scenario requires a multi-region deployment for high-availability, disaster recovery, or even proximity, you may need a Paired Azure Region with the following configurations.

- [Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/azure-best-practices/analytics/azure-synapse) uses database snapshots to provide high availability of the warehouse.

- [Azure SQL Database](https://docs.microsoft.com/en-us/azure/azure-sql/database/high-availability-sla) high availability architecture is to guarantee that your database is up and running minimum of 99.99% of time.

- [Azure Data Explorer](https://docs.microsoft.com/en-us/azure/data-explorer/business-continuity-overview#high-availability-of-azure-data-explorer) high availability includes the persistence layer, compute layer, and a leader-follower configuration.

## Pricing

To estimate the cost of implementing this solution, use the [Azure pricing calculator][Pricing calculator].

Pricing for this architecture is going to be based on the services chosen, the capacity, throughput, transformations done on the data, as well as business continuity and disaster recovery. It can start from around $2,500/mo and scale from there

[To customize and get pricing estimates](https://azure.microsoft.com/en-us/pricing/calculator/).

## Next steps

Learn more about
- [Azure Data Share](https://docs.microsoft.com/en-us/azure/data-share/overview)
- [Azure Synapse Analytics](https://azure.microsoft.com/en-us/resources/videos/securing-your-data-warehouse-with-azure-synapse-analytics/)
- [Azure SQL Database](https://docs.microsoft.com/en-us/azure/azure-sql/database/security-overview)
- [Azure Data Lake Gen2](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-access-control)
- [Azure Data Explorer](https://docs.microsoft.com/en-us/azure/data-explorer/security)

Modify the reference architecture above to fit your specific requirements by answering these questions:
- What and where are your Data sources?
- Which Azure data store(s) will this be data landed in Member Data Store?
- What Member data will be shared with Consortium?
- Which data store(s) will Consortium land the shared data?
- Is the Member data already in common format or needs cleansing and transformation?
- Will the data be shared as batch or Snapshot, or streaming or In-Place?
- What data will Consortium share with Members?

## Related resources

- [Azure API for FHIR](https://azure.microsoft.com/en-us/services/azure-api-for-fhir/)
- [Azure IoT Connector](https://docs.microsoft.com/en-us/azure/healthcare-apis/overview#iot-connector-preview)
- [Microsoft DICOM](https://github.com/microsoft/dicom-server)
- [Microsoft Genomics](https://azure.microsoft.com/en-us/services/genomics/)

[About Azure Key Vault]: /azure/key-vault/general/overview
[Introduction to Azure Data Lake Storage Gen2]: /azure/storage/blobs/data-lake-storage-introduction
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


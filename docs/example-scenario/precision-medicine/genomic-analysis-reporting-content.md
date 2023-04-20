This article presents a solution for genomic analysis and reporting. The processes and results are appropriate for [precision medicine][Precision medicine definition] scenarios, or areas of medical care that use genetic profiling. 

## Architecture

:::image type="complex" source="./media/genomic-analysis-reporting-architecture.svg" alt-text="Architecture diagram showing how information flows through a genomics analysis and reporting pipeline." border="false":::
   The diagram contains two boxes. The first, on the left, has the label Azure Data Factory for orchestration. The second box has the label Clinician views. The first box contains several smaller boxes that represent data or various Azure components. Arrows connect the boxes, and numbered labels on the arrows correspond with the numbered steps in the document text. Two arrows flow between the boxes, ending in the Clinician views box. One arrow points to a clinician icon. The other points to a Power BI icon.
:::image-end:::
*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

### Workflow

Azure Data Factory orchestrates the workflow:

1. Data Factory transfers the initial sample file to Azure Blob Storage. The file is in FASTQ format.
1. Microsoft Genomics runs secondary analysis on the file.
1. Microsoft Genomics stores the output in Blob Storage in one of these formats:

   - Variant call format (VCF)
   - Genomic VCF (GVCF)

1. Jupyter Notebook annotates the output file. The notebook runs on Azure Databricks.
1. Azure Data Lake Storage stores the annotated file.
1. Jupyter Notebook merges the file with other datasets and analyzes the data. The notebook runs on Azure Databricks.
1. Data Lake Storage stores the processed data.
1. Azure Healthcare APIs packs the data into a Fast Healthcare Interoperability Resources (FHIR) bundle. The clinical data then enters the patient electronic health record (EHR).
1. Clinicians view the results in Power BI dashboards.

### Components

The solution uses the following components:

#### Microsoft Genomics

[Microsoft Genomics][Microsoft Genomics - Documentation] offers an efficient and accurate genomics pipeline that implements the industry's best practices. Its high-performance engine is optimized for these tasks:

- Reading large files of genomic data
- Processing them efficiently across many cores
- Sorting and filtering the results
- Writing the results to output files

To maximize throughput, this engine operates a Burrows-Wheeler Aligner (BWA) and a Genome Analysis Toolkit (GATK) HaplotypeCaller variant caller. The engine also uses several other components that make up standard genomics pipelines. Examples include duplicate marking, base quality score recalibration, and indexing. In a few hours, the engine can process a single genomic sample on a single multi-core server. The processing starts with raw reads. It produces aligned reads and variant calls.

Internally, the Microsoft Genomics controller manages these aspects of the process:

- Distributing batches of genomes across pools of machines in the cloud
- Maintaining a queue of incoming requests
- Distributing the requests to servers that run the genomics engine
- Monitoring the servers' performance and progress
- Evaluating the results
- Ensuring that processing runs reliably and securely at scale, behind a secure web service API

You can easily use Microsoft Genomics results in tertiary analysis and machine learning services. And because Microsoft Genomics is a cloud service, you don't need to manage or update hardware or software.

#### Other components

- [Data Factory][Data Factory] is an integration service that works with data from disparate data stores. You can use this fully managed, serverless platform to orchestrate and automate workflows. Specifically, [Data Factory pipelines][Data Factory pipelines] transfer data to Azure in this solution. A sequence of pipelines then triggers each step of the workflow.

- [Blob Storage][Blob Storage] offers optimized cloud object storage for large amounts of unstructured data. In this scenario, Blob Storage provides the initial landing zone for the FASTQ file. This service also functions as the output target for the VCF and GVCF files that Microsoft Genomics generates. [Tiering functionality][Tiering functionality] in Blob Storage provides a way to archive FASTQ files in inexpensive long-term storage after processing.

- [Azure Databricks][Azure Databricks] is a data analytics platform. Its fully managed Spark clusters process large streams of data from various sources. In this solution, Azure Databricks provides the computational resources that Jupyter Notebook needs to annotate, merge, and analyze the data.

- [Data Lake Storage][Data Lake Storage] is a scalable and secure data lake for high-performance analytics workloads. This service can manage multiple petabytes of information while sustaining hundreds of gigabits of throughput. The data may be structured, semi-structured, or unstructured. It typically comes from multiple, heterogeneous sources. In this architecture, Data Lake Storage provides the final landing zone for the annotated files and the merged datasets. It also gives downstream systems access to the final output.

- [Power BI][Power BI] is a collection of software services and apps that display analytics information. You can use Power BI to connect and display unrelated sources of data. In this solution, you can populate Power BI dashboards with the results. Clinicians can then create visuals from the final dataset.

- [Azure Healthcare APIs][Azure Healthcare APIs] is a managed, standards-based, compliant interface for accessing clinical health data. In this scenario, Azure Healthcare APIs passes an FHIR bundle to the EHR with the clinical data.

## Scenario details

This article presents a solution for genomic analysis and reporting. The processes and results are appropriate for [precision medicine][Precision medicine definition] scenarios, or areas of medical care that use genetic profiling. Specifically, the solution provides a clinical genomics workflow that automates these tasks:

- Taking data from a sequencer
- Moving the data through secondary analysis
- Providing results that clinicians can consume

The growing scale, complexity, and security requirements of genomics make it an ideal candidate for moving to the cloud. Consequently, the solution uses Azure cloud services in addition to open-source tools. This approach takes advantage of the security, performance, and scalability features of the Azure cloud:

- Scientists plan on sequencing hundreds of thousands of genomes in coming years. The task of storing and analyzing this data requires significant computing power and storage capacity. With data centers around the world that provide these resources, Azure can meet these demands.
- Azure is certified for major global security and privacy standards, such as ISO 27001.
- Azure complies with the security and provenance standards that the Health Insurance Portability and Accountability Act (HIPAA) establishes for personal health information.

A key component of the solution is [Microsoft Genomics][Microsoft Genomics]. This service offers an optimized secondary analysis implementation that can process a [30x genome][30x genome definition] in a few hours. Standard technologies can take days.

### Potential use cases

This solution is ideal for the healthcare industry. It applies to many areas:

- Risk scoring patients for cancer
- Identifying patients with genetic markers that predispose them to disease
- Generating patient cohorts for studies

## Considerations

The following considerations align with the [Microsoft Azure Well-Architected Framework][Microsoft Azure Well-Architected Framework] and apply to this solution:

### Availability

The service level agreements (SLAs) of most Azure components guarantee availability:

- [At least 99.9 percent of Data Factory pipelines are guaranteed to run successfully][SLA for Azure Data Factory].
- The [Azure Databricks SLA guarantees 99.95 percent availability][Azure Databricks service page].
- [Microsoft Genomics offers a 99.99 percent availability SLA for workflow requests][Microsoft Genomics - Keep your business running].
- Blob Storage and Data Lake Storage are part of Azure Storage, which offers [availability through redundancy][Azure Storage redundancy].

### Scalability

Most Azure services are scalable by design:

- [Data Factory transforms data at scale][Azure Data Factory FAQ].
- [The clusters in Azure Databricks resize as needed][Azure Databricks clusters resize as needed].
- For information on optimizing scalability in Blob Storage, see [Performance and scalability checklist for Blob Storage].
- [Data Lake Storage can manage exabytes of data][Introduction to Azure Data Lake Storage Gen2].
- [Microsoft Genomics runs exabyte-scale workloads][Microsoft Genomics - Support your most demanding sequencing needs].

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

The technologies in this solution meet most companies' requirements for security.

#### Guidelines

Because of the sensitive nature of medical data, establish governance and security by following the guidelines in these documents:

- [Security in the Microsoft Cloud Adoption Framework for Azure][Security in the Microsoft Cloud Adoption Framework for Azure]
- [Practical guide to designing secure health solutions using Microsoft Azure][Practical guide to designing secure health solutions using Microsoft Azure]
- [Enterprise-scale landing zones][Enterprise Scale Landing Zones]

#### Regulatory compliance

- See these documents for information on complying with HIPAA and the Health Information Technology for Economic and Clinical Health (HITECH) Act:

  - [HIPAA - Azure Compliance][HIPAA - Azure Compliance]
  - [Health Insurance Portability and Accountability Act (HIPAA) & Health Information Technology for Economic and Clinical Health (HITECH) Act][Health Insurance Portability and Accountability Act (HIPAA) & Health Information Technology for Economic and Clinical Health (HITECH) Act]

- Components of this solution are in scope for HIPAA according to [Microsoft Azure Compliance Offerings][Microsoft Azure Compliance Offerings]. If you substitute any other components, validate them first against the list in that document's appendix.

#### General security features

Several components also secure data in other ways:

- [Data Factory encrypts data that it transfers. It also uses Azure Key Vault or certificates to encrypt credentials.][Security considerations for data movement in Azure Data Factory]
- [Azure Databricks provides many tools for securing network infrastructure and data][Azure Databricks security guide]. Examples include [access control lists][Access control in Azure Databricks], [secrets][Secret management in Azure Databricks], and [no public IP (NPIP)][Secure cluster connectivity (No Public IP / NPIP)].

- [Blob storage supports storage service encryption (SSE)][Azure Storage encryption for data at rest], which automatically encrypts data before storing it. It also provides [many other ways to protect data and networks][Security recommendations for Blob Storage].
- [Data Lake Storage provides access control][Access control lists (ACLs) in Azure Data Lake Storage Gen2]. Its model supports these types of controls:

  - Azure role-based access control (RBAC)
  - Portable Operating System Interface (POSIX) access control lists (ACLs)

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

With most Azure services, you can reduce costs by only paying for what you use:

- With [Data Factory, your activity run volume determines the cost][Data Factory pricing].
- [Azure Databricks offers many tiers, workloads, and pricing plans][Azure Databricks general pricing information] to help you minimize costs.
- [Blob Storage costs depend on data redundancy options and volume][Azure Storage costs].
- With [Data Lake Storage, pricing depends on many factors: your namespace type, storage capacity, and choice of tier][Data Lake Storage pricing].
- For [Microsoft Genomics, the charge depends on the number of gigabases that each workflow processes][Microsoft Genomics - pricing].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:

 - [Wylie Graham](https://www.linkedin.com/in/wyliegraham) | Senior Program Manager
 - [Matt Hansen](https://www.linkedin.com/in/matthansen0) | Senior Cloud Solution Architect
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Microsoft Genomics: Common questions][Microsoft Genomics - Common questions]
- [Genomics quickstart starter kit][Genomics Quickstart Starter Kit]
- [Burrows-Wheeler Aligner][Burrows-Wheeler Aligner]
- [Genome Analysis Toolkit][Genome Analysis Toolkit]

## Related resources

Fully deployable architectures:

### Data Factory solutions

- [Automated enterprise BI][Automated enterprise BI]
- [Hybrid ETL with Azure Data Factory][Hybrid ETL with Azure Data Factory]
- [Replicate and sync mainframe data in Azure][Replicate and sync mainframe data in Azure]

### Analytics solutions

- [Data warehousing and analytics][Data warehousing and analytics]
- [Geospatial data processing and analytics][Geospatial data processing and analytics]
- [Stream processing with Azure Databricks][Stream processing with Azure Databricks]

### Healthcare solutions

- [Clinical insights with Microsoft Cloud for Healthcare][Clinical insights with Microsoft Cloud for Healthcare]
- [Health data consortium on Azure][Health data consortium on Azure]
- [Population health management for healthcare][Population health management for Healthcare]

[30x genome definition]: https://sequencing.com/blog/post/what-30x-and-04x-whole-genome-sequencing#what-is-30x-whole-genome-sequencing
[Access control lists (ACLs) in Azure Data Lake Storage Gen2]: /azure/storage/blobs/data-lake-storage-access-control
[Access control in Azure Databricks]: /azure/databricks/security/access-control
[Automated enterprise BI]: ../../reference-architectures/data/enterprise-bi-adf.yml
[Azure Data Factory FAQ]: /azure/data-factory/frequently-asked-questions#data-flows
[Azure Databricks]: https://azure.microsoft.com/services/databricks
[Azure Databricks clusters resize as needed]: https://databricks.com/blog/2018/05/02/introducing-databricks-optimized-auto-scaling.html
[Azure Databricks general pricing information]: ../../reference-architectures/data/stream-processing-databricks.yml#azure-databricks
[Azure Databricks security guide]: /azure/databricks/security
[Azure Databricks service page]: https://azure.microsoft.com/services/databricks
[Azure Healthcare APIs]: /azure/healthcare-apis/fhir/overview
[Azure Storage costs]: https://azure.microsoft.com/pricing/details/storage
[Azure Storage encryption for data at rest]: /azure/storage/common/storage-service-encryption
[Blob Storage]: https://azure.microsoft.com/services/storage/blobs
[Burrows-Wheeler Aligner]: http://bio-bwa.sourceforge.net
[Clinical insights with Microsoft Cloud for Healthcare]: ../mch-health/medical-data-insights.yml
[Security in the Microsoft Cloud Adoption Framework for Azure]: /azure/cloud-adoption-framework/secure/
[Data Factory]: https://azure.microsoft.com/services/data-factory
[Data Factory pipelines]: /azure/data-factory/concepts-pipelines-activities
[Data Factory pricing]: https://azure.microsoft.com/pricing/details/data-factory
[Data Lake Storage]: https://azure.microsoft.com/services/storage/data-lake-storage
[Data Lake Storage pricing]: https://azure.microsoft.com/pricing/details/storage/data-lake
[Data warehousing and analytics]: ../data/data-warehouse.yml
[Enterprise Scale Landing Zones]: /azure/cloud-adoption-framework/ready/enterprise-scale
[Genome Analysis Toolkit]: https://gatk.broadinstitute.org/hc
[Genomics Quickstart Starter Kit]: https://github.com/microsoft/Genomics-Quickstart
[Geospatial data processing and analytics]: ../data/geospatial-data-processing-analytics-azure.yml
[Health data consortium on Azure]: ../data/azure-health-data-consortium.yml
[Health Insurance Portability and Accountability Act (HIPAA) & Health Information Technology for Economic and Clinical Health (HITECH) Act]: /compliance/regulatory/offering-hipaa-hitech
[HIPAA - Azure Compliance]: /azure/compliance/offerings/offering-hipaa-us
[Hybrid ETL with Azure Data Factory]: ../data/hybrid-etl-with-adf.yml
[Introduction to Azure Data Lake Storage Gen2]: /azure/storage/blobs/data-lake-storage-introduction#scalability
[Azure Storage redundancy]: /azure/storage/common/storage-redundancy
[Microsoft Azure Compliance Offerings]: https://azure.microsoft.com/mediahandler/files/resourcefiles/microsoft-azure-compliance-offerings/Microsoft%20Azure%20Compliance%20Offerings.pdf
[Microsoft Azure Well-Architected Framework]: /azure/architecture/framework/index
[Microsoft Genomics]: https://azure.microsoft.com/services/genomics
[Microsoft Genomics - Documentation]: /azure/genomics
[Microsoft Genomics - Common questions]: /azure/genomics/frequently-asked-questions-genomics
[Microsoft Genomics - Keep your business running]: /azure/genomics/overview-what-is-genomics#keep-your-business-running
[Microsoft Genomics - pricing]: https://azure.microsoft.com/pricing/details/genomics
[Microsoft Genomics - Support your most demanding sequencing needs]: /azure/genomics/overview-what-is-genomics#support-your-most-demanding-sequencing-needs
[Performance and scalability checklist for Blob Storage]: /azure/storage/blobs/storage-performance-checklist
[Population health management for healthcare]: ../../solution-ideas/articles/population-health-management-for-healthcare.yml
[Power BI]: /power-bi/fundamentals/power-bi-overview
[Practical guide to designing secure health solutions using Microsoft Azure]: https://aka.ms/azureindustrysecurity
[Precision medicine definition]: https://wikipedia.org/wiki/Precision_medicine
[Replicate and sync mainframe data in Azure]: ../../reference-architectures/migration/sync-mainframe-data-with-azure.yml
[Secure cluster connectivity (No Public IP / NPIP)]: /azure/databricks/security/secure-cluster-connectivity
[Secret management in Azure Databricks]: /azure/databricks/security/secrets
[Security considerations for data movement in Azure Data Factory]: /azure/data-factory/data-movement-security-considerations
[Security recommendations for Blob Storage]: /azure/storage/blobs/security-recommendations
[SLA for Azure Data Factory]: https://azure.microsoft.com/support/legal/sla/data-factory/v1_2
[Stream processing with Azure Databricks]: ../../reference-architectures/data/stream-processing-databricks.yml
[Tiering functionality]: /azure/storage/blobs/storage-blob-storage-tiers
[Visio version of architecture diagram]: https://arch-center.azureedge.net/US-1848830-PR-3162-genomic-analysis-reporting-architecture.vsdx

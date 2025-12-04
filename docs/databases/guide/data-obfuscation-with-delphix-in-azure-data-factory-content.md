The following architecture outlines the use of Delphix Continuous Compliance (Delphix CC) in an Azure Data Factory [extract, transform, and load (ETL)](/azure/architecture/data-guide/relational-data/etl) pipeline to identify and mask sensitive data.

## Architecture

:::image type="complex" source="_images/delphix-continuous-compliance-architecture.svg" lightbox="_images/delphix-continuous-compliance-architecture.svg" alt-text="Diagram that shows the Delphix CC architecture." border="false":::
The diagram shows a left-to-right data processing workflow that uses Microsoft Azure services. It consists of three main sections. A Data Factory section that includes several components is in the middle, and sections that include Data Factory and Azure Synapse Analytics data stores are on either side of the main section. In step 1, data is pulled from supported data stores by Data Factory or Azure Synapse Analytics and stored in source Azure Files. Source Azure Files points to a ForEach activity, which represents step 2. In step 6, the ForEach activity points to another ForEach activity. In step 8, the second ForEach activity points to the Data Factory and Azure Synapse Analytics data stores via an arrow labeled load. In step 3, the first ForEach activity points to a Delphix section via an arrow labeled initiate masking. The Delphix section includes a flow: read unmasked data, preprocess, data mask, postprocess, and write masked data. This section is also labeled Azure self-hosted integration runtime. In step 5, this section points to target Azure Files and then to the step 8 arrow. A double-sided arrow labeled check status points from the Delphix section to the second ForEach activity, which represents step 7. The Delphix section and main Data Factory section are connected via virtual networks.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/delphix-continuous-compliance-architecture.vsdx) of this architecture.*

> [!NOTE]
> This solution is specific to Azure Data Factory and Azure Synapse Analytics Pipelines. Delphix CC Profiling and Delphix CC Masking templates are not yet available for Microsoft Fabric Data Factory. Contact your Perforce Delphix account representative about [Microsoft Fabric support](https://www.perforce.com/solutions/microsoft-compliance).

### Dataflow

The following dataflow corresponds to the previous diagram:

1. Data Factory extracts data from source data stores to a container in Azure Files by using the Copy Data activity. This container is referred to as the source data container, and the data is in CSV format.

1. Data Factory initiates an iterator (ForEach activity) that loops through a list of masking jobs configured within Delphix. These preconfigured masking jobs mask sensitive data in the source data container.
1. For each job in the list, the Initiate Masking activity authenticates and initiates the masking job by calling the REST API endpoints on the Delphix CC engine.
1. The Delphix CC engine reads data from the source data container and runs through the masking process.
1. In this masking process, Delphix masks data in-memory and writes the resultant masked data back to a target Azure Files container, which is referred to as the *target data container*.
1. Data Factory initiates a second iterator (ForEach activity) that monitors the implementations.
1. For each implementation (masking job) that starts, the Check Status activity checks the result of masking.
1. After all masking jobs complete successfully, Data Factory loads the masked data from the target data container to the specified destination.

### Components

- [Data Factory](/azure/data-factory/introduction) is an ETL service for scale-out serverless data integration and data transformation. It provides a code-free UI for intuitive authoring and unified monitoring and management. In this architecture, Data Factory orchestrates the entire data masking workflow. This workflow includes extracting data, initiating masking jobs, monitoring operations, and loading masked data into destination stores.

- [Azure Synapse Analytics](/azure/synapse-analytics/overview-what-is) is an analytics service that combines data integration, enterprise data warehousing, and big data analytics. In this architecture, Azure Synapse Analytics can serve as the destination for masked data and includes Data Factory pipelines for data integration.
- [Azure Storage](/azure/storage/common/storage-introduction) is a cloud-based solution that provides scalable storage for both structured and unstructured data. In this architecture, it stores both the raw source data and the masked output data. Azure Storage serves as the intermediary storage layer for data that loads into destination data stores.
- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a private, isolated network environment in Azure. In this architecture, Virtual Network provides private networking capabilities for Azure resources that aren't a part of the Azure Synapse Analytics workspace. It allows you to manage access, security, and routing between resources.
- Other components might include various source and destination data stores, depending on the specific use case. These components integrate into the architecture based on the data sources that you use, such as SAP, Salesforce, or Oracle EBS.

### Alternatives

You can also perform data obfuscation by using Microsoft Presidio. For more information, see [Presidio data protection and de-identification SDK](https://microsoft.github.io/presidio/).

## Scenario details

Data volume rapidly increased in recent years. To unlock the strategic value of data, it needs to be dynamic and portable. Data in silos limits its strategic value and is difficult to use for analytical purposes.

Breaking down data silos presents challenges:

- Data must be manipulated to fit to a common format. ETL pipelines must be adapted to each system of record and must scale to support the massive datasets of modern enterprises.

- Compliance with regulations regarding sensitive information must be maintained when data is moved from systems of record. Customer data and other sensitive elements must be obscured without affecting the business value of the dataset.

<a name='what-is-azure-data-factory-adf'></a>

### What is Data Factory?

[Data Factory](/azure/data-factory/introduction) is a managed, serverless data integration service. It provides a visual experience for integrating data sources with more than 100 built-in, maintenance-free connectors at no added cost. Easily construct ETL and extract, load, transform (ELT) processes code-free in an intuitive environment, or write your own code. To unlock your data's power through business insights, deliver integrated data to Azure Synapse Analytics. Azure Synapse Analytics also includes Data Factory pipelines.

### What is Delphix CC?

[Delphix CC](https://www.delphix.com/platform/continuous-compliance) identifies sensitive information and automates data masking. It offers an automated, API-driven way to provide secure data.

<a name='how-do-delphix-cc-and-adf-solve-automating-compliant-data'></a>

### How do Delphix CC and Data Factory solve automating compliant data?

Delphix simplifies consistent data compliance, while Data Factory enables connecting and moving data. Together, Delphix and Data Factory combine industry-leading compliance and automation offerings to simplify the delivery of on-demand, compliant data.

This solution uses Data Factory data source connectors to create two ETL pipelines that automate the following steps:

- Read data from the system of record and write it to CSV files in Azure Blob Storage.

- Provide Delphix CC with requirements to identify columns that might contain sensitive data and assign appropriate masking algorithms.

- Run a Delphix masking job against the files to replace sensitive data elements with similar but fictitious values.

- Load the compliant data to any Data Factory-supported data store.

### Potential use cases

#### Activate Azure data services for industry-specific solutions safely

- Identify and mask sensitive data in large and complex applications, where customer data is otherwise difficult to identify. Delphix enables users to automatically move compliant data from sources like SAP, Salesforce, and Oracle E-Business Suite (EBS) to high-value service layers, like Azure Synapse Analytics.

- Use Microsoft Azure connectors to safely unlock, mask, and migrate your data from any source.

#### Solve complex regulatory compliance for data

- Use the Delphix Algorithm Framework to address regulatory requirements for your data.

- Apply data-ready rules for regulatory needs, such as California Consumer Privacy Act (CCPA), General Data Protection Law (Lei Geral de Proteção de Dados, LGPD), and Health Insurance Portability and Accountability Act (HIPAA).

#### Accelerate the DevSecOps shift left

- Provide production-grade data to your development and analytics pipelines, such as Azure DevOps, Jenkins, and Harness, and other automation workflows. To do so, mask sensitive data in centralized Data Factory pipelines.

- Mask data consistently across data sources to maintain referential integrity for integrated application testing. For example, the name George must always be masked to Elliot. Or a given social security number (SSN) must always be masked to the same SSN, whether George and George's SSN appear in Oracle, Salesforce, or SAP.

#### Speed up AI and machine learning algorithm training by using compliant analytics

- Mask data without increasing training cycles.

- Retain data integrity while masking to avoid affecting model and prediction accuracy.

- Use any Data Factory or Azure Synapse Analytics connector to facilitate a given use case.

### Key benefits

- Universal connectivity
- Realistic, deterministic masking that maintains referential integrity
- Preemptive identification of sensitive data for key enterprise applications
- Native cloud implementation
- Template-based deployment
- Scalable

### Example architecture

The following example shows how you might architect an environment for this masking use case.

:::image type="complex" source="_images/example-architecture.png" lightbox="_images/example-architecture.png" alt-text="Diagram of a sample architecture." border="false":::
The diagram presents a multi-layered architecture divided into three main sections: Azure Akora production data, customer's Azure cloud production environment, and enterprise production shared services. On the left, the Azure Akora section includes zones labeled landing zone, single region zone (SRZ), enterprise curated zone, and line-of-business (LOB) curated zone. These zones connect to Data Factory, which moves unmasked production data into an In Folder and later into an Out Folder after processing. In the center, the customer's Azure cloud production environment shows a sequence of four numbered steps that Data Factory manages: retrieve credentials, instantiate AKS pods and mount Network File System (NFS) folders, run Delphix jobs, and terminate pods. These steps interact with Delphix CC engine PODs that run in Azure Kubernetes Service (AKS). The engine accesses the In Folder via NFS, performs masking, and writes masked data to the Out Folder. On the right, the enterprise production shared services section includes Microsoft Entra ID, Azure Container Registry, and GitHub repositories, which support authentication, container management, and metadata configuration. The diagram uses directional arrows to show dataflow between components and includes a legend to explain icons and color-coded lines that represent unmasked and masked data.
:::image-end:::

The previous example architecture has the following components:

- Data Factory or Azure Synapse Analytics ingests and connects to production, unmasked data in the landing zone.
- Data is moved to data staging in Storage.
- A Network File System (NFS) mount of production data to Delphix CC PODs enables the pipeline to call the Delphix CC service.
- Masked data is returned for distribution within Data Factory and lower environments.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Delphix CC irreversibly masks data values with realistic data that remains fully functional, which enables the development of higher-quality code. Among the set of algorithms available to transform data to user specifications, Delphix CC has a patented algorithm. The algorithm intentionally produces data collisions and allows you to salt data with specific values needed for potential validation routines on the masked dataset. From a zero trust perspective, operators don't need access to the actual data to mask it. The entire delivery of masked data from point A to point B can be automated via APIs.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

To see how your specific requirements affect cost, adjust values in the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/).

**Azure Synapse Analytics:** You can scale compute and storage levels independently. Compute resources are charged per hour, and you can scale or pause these resources on demand. Storage resources are billed per terabyte, so your costs increase as you ingest data.

**Data Factory or Azure Synapse Analytics:** Costs are based on the number of read and write operations, monitoring operations, and orchestration activities for each workload. Costs increase with each extra data stream and the amount of data that each one processes.

**Delphix CC:** Unlike other data compliance products, Delphix doesn't require a full physical copy of the environment to perform masking.

Environment redundancy can be expensive because of several reasons:

- The time that it takes to set up and maintain the infrastructure
- The cost of the infrastructure itself
- The time that you spend repeatedly loading physical data into the masking environment

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Delphix CC is horizontally and vertically scalable. The transformations occur in memory and can be parallelized. The product runs both as a service and as a multi-node appliance, so you can design solution architectures of any size based on the application. Delphix is the market leader in delivering large masked datasets.

Masking streams can be increased to engage multiple CPU cores in a job. For more information about how to alter memory allocation, see [Create masking jobs](https://maskingdocs.delphix.com/Securing_Sensitive_Data/Creating_Masking_Job/).

For optimal performance of datasets larger than 1 TB in size, [Delphix Hyperscale Masking](https://hyperscale-compliance.delphix.com/3.0.0/) breaks the datasets into numerous modules and then orchestrates the masking jobs across multiple continuous compliance engines.

## Deploy this scenario

1. [Deploy the Delphix CC engine on Azure](https://maskingdocs.delphix.com/Getting_Started/Installation/Azure_Installation/).

1. In Data Factory, deploy both the **Delphix CC Profiling** and **Delphix CC Masking** templates. These templates work for both Azure Synapse Analytics and Data Factory pipelines.
1. In the Copy Data components, configure the desired source and target data stores. In the Web Activity components, input the Delphix application IP address or host name and the credentials to authenticate with Delphix CC APIs.
1. Run the **Delphix CC Profiling** Data Factory template for initial setup and anytime you want to re-identify sensitive data, such as a schema change. This template provides Delphix CC with the initial configuration that it requires to scan for columns that might contain sensitive data.
1. Create a [rule set](https://maskingdocs.delphix.com/Connecting_Data/Managing_Rule_Sets/) that indicates the collection of data that you want to profile. Run a [profiling job](https://maskingdocs.delphix.com/Identifying_Sensitive_Data/Running_A_Profiling_Job/) in the Delphix UI to identify and classify sensitive fields for that rule set and assign appropriate masking algorithms.
1. Review and modify results from the [inventory screen](https://masking.delphix.com/docs/latest/managing-inventories) as desired. When you want to apply masking, [create a masking job](https://maskingdocs.delphix.com/Securing_Sensitive_Data/Creating_Masking_Job/).
1. In the Data Factory UI, open the **Delphix CC Masking** Data Factory template. Provide the masking job ID from the previous step, then run the template.
1. Masked data appears in the target data store of your choice.

> [!NOTE]
> You need the Delphix application IP address and host name with credentials to authenticate to the Delphix APIs.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Tess Maggio](https://www.linkedin.com/in/tessmaggio) | Product Manager 2
- [Arun Saju](https://www.linkedin.com/in/arunsajukurian) | Senior Staff Engineer
- [David Wells](https://www.linkedin.com/in/david-wells-986a654) | Senior Director, Continuous Compliance Product Lead

Other contributors:

- [Jon Burchel](https://www.linkedin.com/in/jon-burchel-8068917b) | Senior Content Developer
- [Abhishek Narain](https://www.linkedin.com/in/narain-abhishek/) | Senior Program Manager
- [Doug Smith](https://www.linkedin.com/in/doug-smith-b2324b5/) | Global Practice Director, DevOps, CI/CD
- [Michael Torok](https://www.linkedin.com/in/michaelatorok/) | Senior Director, Community Management & Experience

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

See the following Delphix resources:

- [Get set up with Delphix CC](https://help.delphix.com/cc/)
- [Use Delphix CC to find where sensitive data resides](https://maskingdocs.delphix.com/Identifying_Sensitive_Data/Discovering_Your_Sensitive_Data_-_Intro/)

Learn more about the key Azure services in this solution:

- [What is Data Factory?](/azure/data-factory/introduction)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [Introduction to Storage](/azure/storage/common/storage-introduction)
- [What is Virtual Network?](/azure/virtual-network/virtual-networks-overview)

## Related resources

- [ETL overview](/azure/architecture/data-guide/relational-data/etl)
- [Replicate and sync mainframe data in Azure](/azure/architecture/reference-architectures/migration/sync-mainframe-data-with-azure)
- [Analytics end-to-end with Synapse](/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end)

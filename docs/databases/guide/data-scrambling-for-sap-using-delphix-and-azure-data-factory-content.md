In many enterprises, SAP is the most mission-critical application and the primary system of record for a wide range of data. Companies must be able to harness insightful data for analytics from both SAP and its upstream and downstream applications in a cost-effective, scalable, and flexible manner. At the same time, companies also need to keep this data in compliance with myriad regulations.

## Architecture

The following architecture outlines the use of Delphix Continuous Compliance (Delphix CC) in an Azure Data Factory or Azure Synapse Analytics pipeline to identify and mask sensitive data.

:::image type="complex" source="_images/data-scrambling-for-sap-using-delphix-and-azure-data-factory-architecture.svg" lightbox="_images/data-scrambling-for-sap-using-delphix-and-azure-data-factory-architecture.svg" border="false" alt-text="Diagram that shows the architecture of the environment required to use Delphix to scramble SAP data for use with Azure Data Factory.":::
The diagram shows a left-to-right data processing workflow that uses Microsoft Azure services. It consists of three main sections. A section that includes several components is in the middle, a section that includes SAP HANA is on the left, and a section that includes Data Factory and Azure Synapse Analytics data stores is on the right. In step 1, data is pulled from SAP HANA and stored in source Azure Files. Source Azure Files points to a ForEach activity, which represents step 2. In step 6, the ForEach activity points to another ForEach activity. In step 8, the second ForEach activity points to the Data Factory and Azure Synapse Analytics data stores via an arrow labeled load. In step 3, the first ForEach activity points to a Delphix section via an arrow labeled initiate masking. The Delphix section includes a flow: read unmasked data, preprocess, data mask, postprocess, and write masked data. This section is also labeled Azure virtual machine. In step 5, this section points to target Azure Files and then to the step 8 arrow. A double-sided arrow labeled check status points from the Delphix section to the second ForEach activity, which represents step 7. The Delphix section and main section are connected via virtual networks.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/data-scrambling-for-sap-using-delphix-and-azure-data-factory-architecture.vsdx) of this architecture.*

> [!NOTE]
> This solution is specific to Azure Data Factory and Azure Synapse Analytics Pipelines. **Data Masking with Delphix** and **Sensitive Data Discovery with Delphix** pipeline templates are not yet available for Microsoft Fabric Data Factory. Contact your Perforce Delphix account representative about [Microsoft Fabric support](https://www.perforce.com/solutions/microsoft-compliance).

### Dataflow

The following dataflow corresponds to the previous diagram:

1. Data Factory extracts data from the source datastore (SAP HANA) to a container in Azure Files by using the Copy Data activity. This container is referred to as the *source data container*. The data is in CSV format. To use the SAP HANA connector, Microsoft recommends deploying a self-hosted integration runtime. For more information, see [Copy data from SAP HANA by using Data Factory or Azure Synapse Analytics](/azure/data-factory/connector-sap-hana).

1. Data Factory initiates an iterator (ForEach activity) that loops through a list of masking jobs configured within Delphix. These preconfigured masking jobs mask sensitive data in the source data container.
1. For each job in the list, the Initiate Masking activity authenticates and initiates the masking job by calling the REST API endpoints on the Delphix CC engine.
1. The Delphix CC engine reads data from the source data container and runs through the masking process.
1. In this masking process, Delphix masks data in memory and writes the resultant masked data back to a target Azure Files container, which is referred to as a *target data container*.
1. Data Factory now initiates a second iterator (ForEach activity) that monitors the operations.
1. For each operation (Masking Job) that starts, the Check Status activity checks the result of masking.
1. After all masking jobs complete successfully, Data Factory loads the masked data from the target data container to Azure Synapse Analytics.

### Components

- [Data Factory](/azure/data-factory/introduction) is an extract, transform, load (ETL) service for scale-out serverless data integration and data transformation. It provides a code-free UI for intuitive authoring and unified monitoring and management. In this architecture, Data Factory orchestrates the entire data masking workflow. This workflow includes extracting data from SAP HANA, initiating masking jobs, monitoring operations, and loading masked data into Azure Synapse Analytics.

- [Azure Storage](/azure/storage/common/storage-introduction) provides scalable cloud storage for structured and unstructured data. In this architecture, it stores both the raw source data and the masked output data. It serves as the intermediary storage layer between extraction and loading.
- A [self-hosted integration runtime](/azure/data-factory/create-self-hosted-integration-runtime?tabs=data-factory) is a component that enables secure data movement between on-premises and cloud environments. In this architecture, it facilitates data extraction from SAP HANA by using the required Open Database Connectivity (ODBC) driver.
- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a private, isolated network environment in Azure. In this architecture, it enables secure communication between services that aren't part of the Azure Synapse Analytics workspace. It helps manage access, security, and routing between resources.

## What is Data Factory?

[Data Factory](/azure/data-factory/introduction) is a managed, serverless data integration service. It provides a visual experience for integrating data sources with more than 100 built-in, maintenance-free connectors at no added cost. Easily construct ETL and extract, load, transform (ELT) processes code-free in an intuitive environment, or write your own code. To unlock your data's power through business insights, deliver integrated data to Azure Synapse Analytics.

## What is Delphix CC?

[Delphix CC](https://www.delphix.com/platform/continuous-compliance) identifies sensitive information and automates data masking and scrambling. It offers an automated, API-driven way to provide secure data.

## How do Delphix CC and Data Factory solve automating compliant data?

The movement of secure data is a challenge for all organizations. Delphix simplifies achieving consistent data compliance, while Data Factory enables data integration and movement. Together, Delphix CC and Data Factory combine industry-leading compliance and automation offerings to simplify the delivery of on-demand, compliant data.

This solution uses Data Factory data source connectors to create an ETL pipeline that allows a user to automate the following steps:

1. Read data from the system of record (SAP HANA), and write it to CSV files on Azure Storage.

1. Run a Delphix masking job against the files to replace sensitive data elements with similar but fictitious values.
1. Load the compliant data to Azure Synapse Analytics.

### Potential use cases

- Move compliant data from SAP applications to Microsoft Synapse automatically to get the necessary data for testing in a cost-sensitive, fast, and scalable manner. This architecture is specific to SAP applications that have a HANA back end. Perform millions of scrambling operations in minutes.

- Use the Delphix Algorithm Framework to address regulatory requirements for your data, for example, to comply with California Consumer Privacy Act (CCPA), General Data Protection Law (Lei Geral de Proteção de Dados, LGPD), and Health Insurance Portability and Accountability Act (HIPAA).
- Mask and scramble data consistently across data sources, while maintaining referential integrity for integrated application testing. For example, the name George must always be masked to Elliot. Or a given social security number (SSN) must always be masked to the same fictitious SSN, whether George and George's SSN appear in SAP, Oracle, Salesforce, or any other application.
- Mask and scramble data without increasing training cycles or affecting model and prediction accuracy.
- Configure a solution that works for both on-premises and the cloud by altering the source connectors. For example, you can pull data from an on-premises SAP application, replicate that data to the cloud, and ensure compliance before loading it into Azure Synapse Analytics.

## Key benefits

- Realistic, deterministic masking and scrambling that maintains referential integrity
- Preemptive identification of sensitive data for most common SAP tables and modules
- Native cloud implementation
- Template-based deployment
- Scalable
- Low-cost alternative to expensive in-memory HANA hardware

## Deploy this scenario

1. [Deploy the Delphix CC engine on Azure](https://maskingdocs.delphix.com/Getting_Started/Installation/Azure_Installation/).

1. In Data Factory, deploy the **Data Masking with Delphix** and **Sensitive Data Discovery with Delphix** templates. These templates work for both Azure Synapse Analytics pipelines and Data Factory pipelines.
1. [Set up a self-hosted integration runtime](/azure/data-factory/connector-sap-hana) to extract data from SAP HANA.
1. In the Copy Data components, configure the desired source as SAP HANA in the Extract step and Synapse as the desired target in the Load step. In the Web Activity components, input the Delphix application IP address or host name and the credentials to authenticate with Delphix CC APIs.
1. Run the **Sensitive Data Discovery with Delphix** Data Factory template for initial setup and anytime you want to preidentify sensitive data, such as a schema change. This template provides Delphix CC with the initial configuration that it requires to scan for columns that might contain sensitive data. You can also use this workflow with the Delphix Compliance Accelerator for SAP, preidentified sensitive fields, and masking algorithms to protect data in core SAP tables, such as finance, human resources, and logistics modules. Contact Delphix to apply this option.
1. Create a [rule set](https://maskingdocs.delphix.com/Connecting_Data/Managing_Rule_Sets/) that indicates the collection of data that you want to profile. Run a [profiling job](https://maskingdocs.delphix.com/Identifying_Sensitive_Data/Running_A_Profiling_Job/) in the Delphix UI to identify and classify sensitive fields for that rule set and assign appropriate masking algorithms.
1. Run the template. After completed, Azure Synapse Analytics contains masked data, including fields from key tables and modules that the Delphix Compliance Accelerator for SAP preidentified.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

## Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Delphix CC irreversibly masks data values with realistic data that remains fully functional, which enables the development of higher-quality code. Among the set of algorithms available to transform data to user specifications, Delphix CC has a patented algorithm. The algorithm intentionally produces data collisions and allows you to salt data with specific values needed for potential validation routines on the masked dataset. From a zero trust perspective, operators don't need access to the actual data in order to mask it. The entire delivery of masked data from point A to point B can be automated via APIs.

## Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

To see how your specific requirements affect cost, adjust values in the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/).

**Azure Synapse Analytics:** You can scale compute and storage levels independently. Compute resources are charged per hour, and you can scale or pause these resources on demand. Storage resources are billed per terabyte, so your costs increase as you ingest data.

**Data Factory:** Costs are based on the number of read and write operations, monitoring operations, and orchestration activities for each workload. Costs increase with each extra data stream and the amount of data that each one processes.

**Delphix CC:** Unlike other data compliance products, Delphix doesn't require a full physical copy of the environment to perform masking.

Environment redundancy can be expensive because of several reasons:

- The time that it takes to set up and maintain the infrastructure
- The cost of the infrastructure itself
- The time that you spend repeatedly loading physical data into the masking environment

## Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Delphix CC is horizontally and vertically scalable. The transformations occur in memory and can be parallelized. The product runs both as a service and as a multi-node appliance, so you can design solution architectures of any size based on the application. Delphix is the market leader in delivering large masked datasets.

Masking streams can be increased to engage multiple CPU cores in a job. For more information about how to alter memory allocation, see [Create masking jobs](https://maskingdocs.delphix.com/Securing_Sensitive_Data/Creating_Masking_Job/).

For optimal performance of datasets larger than 1 TB in size, [Delphix Hyperscale Masking](https://hyperscale-compliance.delphix.com/3.0.0/) breaks the datasets into numerous modules and then orchestrates the masking jobs across multiple continuous compliance engines.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Tess Maggio](https://www.linkedin.com/in/tessmaggio) | Product Manager 2
- [Arun Saju](https://www.linkedin.com/in/arunsajukurian) | Senior Staff Engineer
- [Mick Shieh](https://www.linkedin.com/in/mick-shieh-9219641/) | SAP Global Practice Leader

Other contributors:

- [Jon Burchel](https://www.linkedin.com/in/jon-burchel-8068917b) | Senior Content Developer
- [Abhishek Narain](https://www.linkedin.com/in/narain-abhishek/) | Senior Program Manager
- [Michael Torok](https://www.linkedin.com/in/michaelatorok/) | Senior Director of Digital Customer Experience

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Get set up with Delphix CC](https://help.delphix.com/cc/)
- [Consistent data masking across SAP and other data sources](https://www.delphix.com/video/data-compliance-and-security-across-datasets)

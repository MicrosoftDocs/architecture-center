The following architecture outlines the use of Delphix Continuous Compliance in an Azure Data Factory (ADF) [extract, transform, and load](/azure/architecture/data-guide/relational-data/etl) (ETL) pipeline to identify and mask sensitive data.

## Architecture

:::image type="content" source="./media/delphix-continuous-compliance-architecture.svg" lightbox="./media/delphix-continuous-compliance-architecture.svg" alt-text="Diagram showing the Delphix Continuous Compliance architecture.":::

*Download a [Visio file](https://arch-center.azureedge.net/delphix-continuous-compliance-architecture.vsdx) of this architecture.*

### Dataflow

The data flows through the scenario as follows:

1. Azure Data Factory (ADF) extracts data from source datastore(s) to a container in Azure File storage using the Copy Data activity. This container is referred to as the Source Data Container and the data is in CSV format.
1. ADF initiates an iterator (ForEach activity) that loops through a list of masking jobs configured within Delphix. These masking jobs will be pre-configured and will mask sensitive data present in the Source Data Container.
1. For each job in the list, the Initiate Masking activity authenticates and initiates the masking job by calling the REST API endpoints on the Delphix CC Engine.
1. The Delphix CC Engine reads data from the Source Data Container and runs through the masking process.
1. In this masking process, Delphix masks data in-memory and writes the resultant masked data back to a target Azure File Storage container (referred to as Target Data Container).
1. ADF now initiates a second iterator (ForEach activity) that monitors the executions.
1. For each execution (Masking Job) that was started, the Check Status activity checks the result of masking.
1. Once all masking jobs have successfully completed, ADF loads the masked data from Target Data Container to the specified destination.

### Components

- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is Azure's cloud extract, transform, and load (ETL) service for scale-out serverless data integration and data transformation. It offers a code-free UI for intuitive authoring and single-pane-of-glass monitoring and management.
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is an analytics service that brings together data integration, enterprise data warehousing, and big data analytics. It includes Azure Data Factory pipelines to provide data integration.
- [Azure Storage](https://azure.microsoft.com/services/storage) stores the data extracted from source datastore(s) and the masked data that will be loaded into destination data store(s).
- Optional: [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) provides private networking capabilities for Azure resources that aren't a part of the Azure Synapse workspace. It allows you to manage access, security, and routing between resources.
- Other Components: Based on the datastores used as source and destination, other components may need to be added. These datastores can vary depending on your requirements.

### Alternatives

You can also perform data obfuscation using GitHub with Microsoft Presidio.  Learn more about this option at [microsoft/presidio: Context aware, pluggable and customizable data protection and anonymization SDK for text and images](https://github.com/microsoft/presidio).

## Scenario details

There has been an explosion of data in recent years. In order to unlock the strategic value of data, it needs to be dynamic and portable. Data present in silos limits its strategic value and is difficult to use for analytical purposes.

Breaking down data silos is difficult:

- Data must be manipulated to fit to a common format. ETL pipelines must be adapted to each system of record and must scale to support the massive data sets of modern enterprises.
- Compliance with regulations regarding sensitive information must be maintained when data is moved from systems of record. Customer content and other sensitive elements must be obscured without impacting the business value of the data set.

### What is Azure Data Factory (ADF)?

[Azure Data Factory](/azure/data-factory/introduction) is a fully managed, serverless data integration service. It provides a rich visual experience for integrating data sources with more than 100 built-in, maintenance-free connectors at no added cost. Easily construct ETL and ELT processes code-free in an intuitive environment or write your own code. Then, deliver integrated data to Azure Synapse Analytics to unlock your data’s power through business insights.  Data factory pipelines are also available in Azure Synapse Analytics.

### What is Delphix Continuous Compliance (Delphix CC)?

[Delphix Continuous Compliance](https://www.delphix.com/platform/continuous-compliance) identifies sensitive information and automates data masking. It offers a fast, automated, API-driven way to provide secure data where it's needed in organizations. 

### How do Delphix CC and ADF solve automating compliant data?

The movement of secure data is a challenge for all organizations. Delphix makes achieving consistent data compliance easy while ADF enables connecting and moving data seamlessly. Together Delphix and ADF are combining industry-leading compliance and automation offerings to make the delivery of on-demand, compliant data easy for everyone. 

By using the data source connectors offered by ADF, we've created two ETL pipelines that automate the following steps: 

- Read data from the system of record and write it to CSV files on Azure Blob Storage.  

- Provide Delphix Continuous Compliance with what it requires in order to identify columns that may contain sensitive data and assign appropriate masking algorithms. 

- Execute a Delphix masking job against the files to replace sensitive data elements with similar but fictitious values. 

- Load the compliant data to any ADF-supported datastore.

### Potential use cases

#### Safely activate Azure Data Services for industry-specific solutions

- Identify and mask sensitive data in large and complex applications, where customer content would otherwise be difficult to identify. Delphix enables end users to automatically move compliant data from sources like SAP, Salesforce, and Oracle EBS to high-value service layers, like Microsoft Synapse.
- Use the powerful and comprehensive connectors provided by Microsoft Azure to safely unlock, mask, and migrate your data - no matter where it originates. 

#### Solve complex regulatory compliance for data

- Automatically put the exhaustive Delphix Algorithm framework to work addressing any regulatory requirements for your data.
- Apply data-ready rules for regulatory needs like CCPA, LGPD, HIPAA, and others.

#### Accelerate the “DevSecOps” shift left

- Equip your developer and analytics pipelines (Azure DevOps, Jenkins, Harness) and other automation workflows with production grade data by systematically and deterministically masking sensitive data in central ADF pipelines.
- Mask data consistently across data sources, maintaining referential integrity for integrated application testing. For example, the name George must always be masked to Elliot or a given social security number (SSN) must always be masked to the same SSN, whether George and his SSN appear in Oracle, Salesforce, or SAP.

#### Reduce AI/ML algorithm training time with compliant analytics

- Mask data in a manner that doesn't increase training cycles.
- Retain data integrity while masking to avoid impacting model/prediction accuracy.

Any Azure Data Factory or Synapse Analytics connector can be used to facilitate a given use case.

### Key benefits

- Universal connectivity
- Realistic, deterministic masking that maintains referential integrity
- Preemptive identification of sensitive data for key enterprise applications
- Native cloud execution
- Template-based deployment
- Scalable

### Example architecture

The following example was provided by an anonymous customer. It is intended only as a sample for how one might architect an environment for this masking use case.

:::image type="content" source="./media/example-architecture.png" lightbox="./media/example-architecture.png" alt-text="Diagram of a sample architecture provided by an anonymous customer.":::

In the above example architecture:

- Azure Data Factory or Synapse Analytics ingests / connects to production, unmasked data in the landing zone
- Data is moved to Data Staging in Azure Storage
- NFS mount of production data to Delphix CC PODs enables the pipeline to call the Delphix CC service
- Masked data is returned for distribution within ADF and lower environments

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Delphix CC irreversibly masks data values with realistic data that remains fully functional, enabling the development of higher-quality code.  Among the rich set of algorithms available to transform data to user specifications, Delphix CC has a patented algorithm that intentionally produces data collisions, while at the same time allows for salting data with specific values needed for potential validation routines run on the masked data set. From a Zero Trust perspective, operators don't need access to the actual data in order to mask it. In addition, the entire delivery of masked data from point A to point B can be automated via APIs.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

By adjusting values on the Azure pricing calculator (https://azure.microsoft.com/pricing/calculator/), you can see how your particular requirements impact cost.
Azure Synapse: You can scale compute and storage levels independently. Compute resources are charged per hour, and you can scale or pause these resources on demand. Storage resources are billed per terabyte, so your costs will increase as you ingest more data.

Data Factory or Synapse Analytics: Costs are based on the number of read/write operations, monitoring operations, and orchestration activities performed in a workload. Your costs will increase with each additional data stream and the amount of data processed by each one.

Delphix CC: Unlike other data compliance products on the market, masking doesn't require a full physical copy of the environment being masked. Environment redundancy can be extremely expensive because of the time to set up and maintain the infrastructure, the cost of the infrastructure itself, and the time spent repeatedly loading physical data into the masking environment.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Delphix CC is horizontally and vertically scalable. The transformations occur in memory and can be parallelized. The product runs both as a service and as a multi-node appliance allowing solution architectures of all sizes depending upon the application. Delphix is the market leader in delivering extremely large masked data sets.

Masking streams can be increased to engage multiple CPU cores in a job. (Configuration recommendations and details on how to alter memory allocation can be found here: https://maskingdocs.delphix.com/Securing_Sensitive_Data/Creating_Masking_Job/).

For optimal performance for datasets larger than 1 TB in size, Delphix Hyperscale Masking (https://hyperscale-compliance.delphix.com/3.0.0/) breaks the large and complex datasets into numerous modules and then orchestrates the masking jobs across multiple Continuous Compliance Engines.

## Deploy this scenario

1. [Deploy the Delphix CC Engine on Azure](https://maskingdocs.delphix.com/Getting_Started/Installation/Azure_Installation/)
1. In ADF, deploy both the Delphix Continuous Compliance: Profiling (Delphix CC Profiling) and Delphix Continuous Compliance: Masking (Delphix CC Masking) ADF templates. These templates work for both Azure Synapse Analytics and Azure Data Factory pipelines.
1. In the Copy Data components, configure the desired source and target datastores. In the Web Activity components, input the Delphix application IP address / host name and the credentials to authenticate with Delphix CC APIs.
1. Run the Delphix CC Profiling ADF template for initial setup, and anytime you would like to reidentify sensitive data (ex: if there has been a schema change). This template provides Delphix CC with the initial configuration it requires to scan for columns that may contain sensitive data.
1. Create a [Ruleset](https://maskingdocs.delphix.com/Connecting_Data/Managing_Rule_Sets/#managing-rule-sets) indicating the collection of data that you would like to profile. Run a [Profiling Job](https://maskingdocs.delphix.com/Identifying_Sensitive_Data/Running_A_Profiling_Job/) in the Delphix UI to identify and classify sensitive fields for that Ruleset and assign appropriate masking algorithms.
1. Review and modify results from the [Inventory screen](https://maskingdocs.delphix.com/Connecting_Data/Managing_Inventories/#the-inventory-screen) as desired. Once you're satisfied with the results and would like to mask accordingly, [create a masking job](https://maskingdocs.delphix.com/Securing_Sensitive_Data/Creating_Masking_Job/).
1. Back in the ADF UI, open the Delphix CC Masking ADF template. Provide the Masking Job ID from the above step, then run the template.
1. At the end of this step, you'll have masked data in the target datastore of your choice.

> [!NOTE]
> You will need the Delphix application IP address and host name with credentials to authenticate to the Delphix APIs.

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal authors:

- [Tess Maggio](https://www.linkedin.com/in/tessmaggio) | Product Manager 2
- [Arun Saju](https://www.linkedin.com/in/arunsajukurian) | Senior Staff Engineer
- [David Wells](https://www.linkedin.com/in/david-wells-986a654) | Senior Director, Continuous Compliance Product Lead

Other contributors:

- [Jon Burchel](https://www.linkedin.com/in/jon-burchel-8068917b) | Senior Content Developer
- [Abhishek Narain](https://www.linkedin.com/in/narain-abhishek/) | Senior Program Manager
- [Doug Smith](https://www.linkedin.com/in/doug-smith-b2324b5/) | Global Practice Director, DevOps, CI/CD
- [Michael Torok](https://www.linkedin.com/in/michaelatorok/) | Senior Director, Community Management & Experience

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

See the following Delphix resources:

- [Learn about getting set up with Delphix CC](https://maskingdocs.delphix.com/)
- [Learn about using Delphix CC to find where sensitive data resides](https://maskingdocs.delphix.com/Identifying_Sensitive_Data/Discovering_Your_Sensitive_Data_-_Intro/) 
- [Learn more about customers using Delphix on Azure](https://www.delphix.com/solutions/cloud/azure)

Learn more about the key Azure services in this solution:

- [What is Azure Data Factory?](/azure/data-factory/introduction)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [Introduction to Azure Storage](/azure/storage/common/storage-introduction)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)

## Related resources

- [Extract, transform, and load](/azure/architecture/data-guide/relational-data/etl)
- [Hybrid ETL with Azure Data Factory](/azure/architecture/example-scenario/data/hybrid-etl-with-adf)
- [Batch integration with Azure Data Factory for Azure Digital Twins](/azure/architecture/example-scenario/iot/batch-integration-azure-data-factory-digital-twins)
- [Data warehousing in Microsoft Azure](/azure/architecture/data-guide/relational-data/data-warehousing)
- [Replicate and sync mainframe data in Azure](/azure/architecture/reference-architectures/migration/sync-mainframe-data-with-azure)
- [Analytics end-to-end with Azure Synapse](/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end)

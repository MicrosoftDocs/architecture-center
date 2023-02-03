In many enterprises, SAP is the most mission-critical application and the primary system of record for a wide range of data. Companies must be able to harness insightful data for analytics from both SAP, as well as its upstream/downstream applications in a cost-effective, scalable, and flexible manner. At the same time, companies also need to ensure this data is in compliance with myriad regulations.

## Architecture

The following architecture outlines the use of Delphix CC in an Azure Data Factory/Azure Synapse pipeline to identify and mask sensitive data.

:::image type="content" source="media/data-scrambling-for-sap-using-delphix-and-azure-data-factory-architecture.png" alt-text="Diagram showing the architecture of the environment required to use Delphix to scramble SAP data for use with Azure Data Factory.":::

## What is Azure Data Factory?

[Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/introduction) is a fully managed, serverless data integration service. It provides a rich visual experience for integrating data sources with more than 100 built-in, maintenance-free connectors at no added cost. Easily construct ETL and ELT processes code-free in an intuitive environment or write your own code. Then, deliver integrated data to Azure Synapse Analytics to unlock your data’s power through business insights.

## What is Delphix Continuous Compliance (Delphix CC)?

[Delphix Continuous Compliance (Delphix CC)](https://www.delphix.com/platform/continuous-compliance) identifies sensitive information and automates data masking/scrambling. It offers a fast, automated, API-driven way to provide secure data where it is needed in organizations.

## How do Delphix CC and Azure Data Factory Solve Automating Compliant Data?

The movement of secure data is a challenge for all organizations. Delphix makes achieving consistent data compliance easy while Azure Data Factory enables connecting and moving data seamlessly. Together Delphix CC and Azure Data Factory are combining industry-leading compliance and automation offerings to make the delivery of on-demand, compliant data easy for everyone.
By leveraging the data source connectors offered by Azure Data Factory, we have created an ETL pipeline that allows an end user to automate the following steps:

1. Read data from the system of record (SAP HANA) and write it to CSV files on Azure Storage. 
1. Execute a Delphix masking job against the files to replace sensitive data elements with similar but fictitious values.
1. Load the compliant data to Azure Synapse Analytics.

## Dataflow

The data flows through the scenario as follows:

1. Azure Data Factory extracts data from the source datastore (SAP HANA) to a container in Azure File Storage using the Copy Data activity. This container is referred to as the Source Data Container and the data is in CSV format. To use the SAP HANA connector, Microsoft recommends the use of a Self Hosted Integration Runtime. Please refer to this [how to guide](https://learn.microsoft.com/en-us/azure/data-factory/connector-sap-hana?tabs=data-factory) for more information.
1. Data factory initiates an iterator (ForEach activity) that loops through a list of masking jobs configured within Delphix. These masking jobs will be pre-configured and will mask sensitive data present in the Source Data Container.
1. For each job in the list, the Initiate Masking activity authenticates and initiates the masking job by calling the REST API endpoints on the Delphix CC Engine.
1. The Delphix CC Engine reads data from the Source Data Container and runs through the masking process.
1. In this masking process, Delphix masks data in memory and writes the resultant masked data back to a target Azure File Storage container (referred to as Target Data Container).
1. Data factory now initiates a second iterator (ForEach activity) that monitors the executions.
1. For each execution (Masking Job) that was started, the Check Status activity checks the result of masking.
1. Once all masking jobs have successfully been completed, data factory loads the masked data from Target Data Container to Azure Synapse Analytics.

## Components

* [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is Azure's cloud extract, transform, and load (ETL) service for scale-out serverless data integration and data transformation. It offers a code-free UI for intuitive authoring and single-pane-of-glass monitoring and management. 
* [Azure Storage](https://azure.microsoft.com/services/storage) stores the data extracted from source datastore(s) and the masked data that will be loaded into destination data store(s).
* [Resource Groups](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal) is a logical container for Azure resources. Resource groups organize everything related to this project in the Azure console.
* [Self Hosted Integration Runtime ](https://learn.microsoft.com/en-us/azure/data-factory/create-self-hosted-integration-runtime?tabs=data-factory) must be set up and a SAP HANA ODBC driver must be installed for data extraction from SAP HANA.
* Optional: [Azure Virtual Network](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview) provides private networking capabilities for Azure resources that are not a part of the Azure Synapse workspace. It allows you to manage access, security, and routing between resources.

## Potential use cases

* Automatically move compliant data from SAP applications (the architecture described here is specific to SAP applications with a HANA backend) to Microsoft Synapse to get analysts the data they need for testing in a cost-sensitive, fast, and scalable manner. Perform millions of scrambling operations in minutes.
* Automatically put the exhaustive Delphix Algorithm framework to work addressing any regulatory requirements for your data (for example, to comply with GDPR, CCPA, LGPD, and HIPAA).
* Mask/Scramble data consistently across data sources, while maintaining referential integrity for integrated application testing. For example, the name George must always be masked to Elliot or a given social security number (SSN) must always be masked to the same fictitious SSN, whether George and his SSN appear in SAP, Oracle, Salesforce, or any other application.
* Mask/Scramble data in a manner that does not increase training cycles, and that does not impact model or prediction accuracy.
* Configure a solution that works for both on-prem and the cloud, simply by altering the source connectors. For example, one might pull data from an on-prem SAP application, replicate that data to the cloud, and ensure compliance before loading into Synapse.

## Key benefits

* Realistic, deterministic masking/scrambling that maintains referential integrity
* Preemptive identification of sensitive data for most common SAP tables and modules
* Native cloud execution
* Template-based deployment
* Scalable
* Low-cost alternative to expensive in-memory HANA HW

## Getting started

1. [Deploy the Delphix CC Engine on Azure](https://maskingdocs.delphix.com/Getting_Started/Installation/Azure_Installation/).
1. In Azure Data Factory, deploy the Data Masking with Delphix and Sensitive Data Discovery with Delphix templates.
Note: These templates work for both Azure Synapse Analytics pipelines as well as Azure Data Factory pipelines.
1. Set up a Self Hosted Integration Runtime as detailed in this [how to guide](https://learn.microsoft.com/en-us/azure/data-factory/connector-sap-hana?tabs=data-factory) to extract data from SAP HANA.
1. In the Copy Data components, configure the desired source as SAP HANA in the Extract step and Synapse as the desired target in the Load step. In the Web Activity components, input the Delphix application IP address /host name and the credentials to authenticate with Delphix CC APIs.
1. Run the Sensitive Data Discovery with Delphix Azure Data Factory template for initial setup, and anytime you would like to re-identify sensitive data (for example, if there has been a schema change). This template provides Delphix CC with the initial configuration it requires to scan for columns that might contain sensitive data. You can also use this in tandem with the Delphix Compliance Accelerator for SAP, pre-identified sensitive fields and masking algorithms to protect data in core SAP tables, for example, Finance, HR, and Logistics modules. Please contact Delphix if you are interested in this option.
1. Create a [Ruleset](https://maskingdocs.delphix.com/Connecting_Data/Managing_Rule_Sets/#managing-rule-sets) indicating the collection of data you would like to profile. Run a [Profiling Job](https://maskingdocs.delphix.com/Identifying_Sensitive_Data/Running_A_Profiling_Job/) in the Delphix UI to identify and classify sensitive fields for that Ruleset and assign appropriate masking algorithms.
1. Run the template. Once completed, you will have masked data (as preidentified for top tables/modules by the Delphix Compliance Accelerator for SAP) in Azure Synapse Analytics.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

## Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Delphix CC irreversibly masks data values with realistic data that remains fully functional, enabling the development of higher-quality code.  Among the rich set of algorithms available to transform data to user specifications, Delphix CC has a patented algorithm that intentionally produces data collisions, and at the same time allows for salting data with specific values needed for potential validation routines run on the masked data set. From a Zero Trust perspective, operators do not need access to the actual data in order to mask it. In addition, the entire delivery of masked data from point A to point B can be completely automated via APIs.

## Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

By adjusting values on the Azure pricing calculator (https://azure.microsoft.com/en-us/pricing/calculator/), you can see how your particular requirements impact cost.

Azure Synapse: You can scale compute and storage levels independently. Compute resources are charged per hour, and you can scale or pause these resources on demand. Storage resources are billed per terabyte, so your costs will increase as you ingest more data.

Data Factory: Costs are based on the number of read/write operations, monitoring operations, and orchestration activities performed in a workload. Your Data Factory costs will increase with each additional data stream and the amount of data processed by each one.

Delphix CC: Unlike other data compliance products on the market, masking does not require a full physical copy of the environment being masked. Environment redundancy can be extremely expensive because of the time to set up and maintain the infrastructure, the cost of the infrastructure itself, and the time spent repeatedly loading physical data into the masking environment. 

## Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Delphix CC is horizontally and vertically scalable. The transformations occur in memory and can be parallelized. The product runs both as a service and as a multi-node appliance allowing solution architectures of all sizes depending upon the application. Delphix is the market leader in delivering extremely large masked data sets. 

Masking streams can be increased to engage multiple CPU cores in a job. (Configuration recommendations, as well as how to alter memory allocation can be found here: https://maskingdocs.delphix.com/Securing_Sensitive_Data/Creating_Masking_Job/)

For optimal performance for datasets larger than 1 TB in size, Delphix Hyperscale Masking (https://hyperscale-compliance.delphix.com/3.0.0/) breaks the large and complex datasets into numerous modules and then orchestrates the masking jobs across multiple Continuous Compliance Engines.

## Contributors

This article is maintained by Microsoft and Delphix. It was originally written by the following contributors.

Principal authors: 
* Tess Maggio – Product Manager 2, Delphix
* Arun Saju – Senior Staff Engineer, Delphix
* Mick Shieh – SAP Global Practice Leader, Delphix

Other contributors:
* Michael Torok – Senior Director of Digital Customer Experience, Delphix
* Jon Burchel - Senior Content Developer, Microsoft

## Next steps

* [Learn about getting set up with Delphix CC](https://maskingdocs.delphix.com/)
* [Learn about consistent data masking across SAP and other data sources](https://www.delphix.com/video/data-compliance-and-security-across-datasets)
* [Learn more about customers using Delphix on Azure](https://www.delphix.com/solutions/cloud/azure)

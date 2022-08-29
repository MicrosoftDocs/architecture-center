---
title: Data obfuscation using Delphix in Azure Data Factory
description: Learn about how to perform data obfuscation using Delphix in Azure Data Factory.
author: nabhishek
ms.date: 08/30/2022
ms.topic: how-to
ms.service: architecture-center
ms.subservice: 
azureCategories: 
categories: 
products:
  - azure-data-factory
ms.custom:

---

# Data obfuscation on Azure using Delphix and Azure Data Factory

There has been an explosion of data in recent years. In order to unlock the strategic value of data, it needs to be dynamic and portable. Data present in silos limits its strategic value and is difficult to use for analytical purposes.

Breaking down data silos is difficult:

- Data must be manipulated to fit to a common format. ETL pipelines must be adapted to each system of record and must scale to support the massive data sets of modern enterprises.
- Compliance with regulations regarding sensitive information must be maintained when data is moved from systems of record. PII and other sensitive elements must be obscured without impacting the business value of the data set.

### What is Azure Data Factory?

[Azure Data Factory](/data-factory/introduction) is a fully managed, serverless data integration service. It provides a rich visual experience for integrating data sources with more than 100 built-in, maintenance-free connectors at no added cost. Easily construct ETL and ELT processes code-free in an intuitive environment or write your own code. Then, deliver integrated data to Azure Synapse Analytics to unlock your data’s power through business insights.

### What is Delphix Continuous Compliance (Delphix CC)?

[Delphix Continuous Compliance](https://www.delphix.com/platform/continuous-compliance) identifies sensitive information and automates data masking. It offers a fast, automated, API-driven way to provide secure data where it is needed in organizations. 

### How do Delphix CC and ADF Solve Automating Compliant Data?

The movement of secure data is a challenge for all organizations. Delphix makes achieving consistent data compliance easy while ADF enables connecting and moving data seamlessly. Together Delphix and ADF are combining industry-leading compliance and automation offerings to make the delivery of on-demand, compliant data easy for everyone. 

By leveraging the data source connectors offered by ADF, we have created two ETL pipelines that automate the following steps: 

Read data from the system of record and write it to CSV files on Azure Blob Storage.  

Provide Delphix Continuous Compliance with what it requires in order to identify columns that may contain sensitive data and assign appropriate masking algorithms. 

Execute a Delphix masking job against the files to replace sensitive data elements with similar but fictitious values. 

Load the compliant data to any ADF-supported datastore.

## Architecture

The following architecture outlines the use of Delphix Continuous Compliance in an ADF ETL pipeline to identify and mask sensitive data.

:::image type="content" source="delphix-continuous-compliance-architecture.png" alt-text="Diagram showing the Delphix Continous Compliance architecture.":::

Download a [Visio file](https://delphixit-my.sharepoint.com/:u:/g/personal/arun_saju_delphix_com/EVswtxQQs5JGpdNkbPfMNvUBmhw_EJ4_Sg88IpQmmbdjvg?e=7b8OG8) of this architecture.

## Dataflow

The data flows through the scenario as follows:

1. ADF extracts data from source datastore(s) to a container in Azure File Storage using the Copy Data activity. This container is referred to as the Source Data Container and the data is in CSV format.
1. ADF initiates an iterator (ForEach activity) that loops through a list of masking jobs configured within Delphix. These masking jobs will be pre-configured and will mask sensitive data present in the Source Data Container.
1. For each job in the list, the Initiate Masking activity authenticates and initiates the masking job by calling the REST API endpoints on the Delphix CC Engine.
1. The Delphix CC Engine reads data from the Source Data Container and runs through the masking process.
1. In this masking process, Delphix masks data in-memory and writes the resultant masked data back to a target Azure File Storage container (referred to as Target Data Container).
1. ADF now initiates a second iterator (ForEach activity) that monitors the executions.
1. For each execution (Masking Job) that was started, the Check Status activity checks the result of masking.
1. Once all masking jobs have successfully completed, ADF loads the masked data from Target Data Container to the specified destination.

## Components

- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is Azure's cloud extract, transform, and load (ETL) service for scale-out serverless data integration and data transformation. It offers a code-free UI for intuitive authoring and single-pane-of-glass monitoring and management.
- [Azure Storage](https://azure.microsoft.com/services/storage) stores the data extracted from source datastore(s) and the masked data that will be loaded into destination data store(s).
- [Resource Groups](/azure-resource-manager/management/manage-resource-groups-portal) is a logical container for Azure resources. Resource groups organize everything related to this project in the Azure console.
- Optional: [Azure Virtual Network](/virtual-network/virtual-networks-overview) provides private networking capabilities for Azure resources that are not a part of the Azure Synapse workspace. It allows you to manage access, security, and routing between resources.
- Additional Components: Based on the datastores used as source and destination, additional components may need to be added. These datastores can vary depending on your requirements.

## Alternatives
You can also perform data obfuscation using GitHub with Microsoft Presidio.  Learn more about this option at [microsoft/presidio: Context aware, pluggable and customizable data protection and anonymization SDK for text and images](https://github.com/microsoft/presidio).

## Potential use cases

### Safely Activate Azure Data Services for Industry Specific Solutions

- Identify and mask sensitive data in large and complex applications, where personally identifiable information (PII) would otherwise be difficult to identify. Delphix enables end users to automatically move compliant data from sources like SAP, Salesforce, and Oracle EBS to high-value service layers, like Microsoft Synapse.
- Leverage the powerful and comprehensive connectors provided by Microsoft Azure to safely unlock, mask, and migrate your data - no matter where it originates. 

### Solve Complex Regulatory Compliance for Data

- Automatically put the exhaustive Delphix Algorithm framework to work addressing any regulatory requirements for your data.
- Apply data-ready rules for regulatory needs like GDPR, CCPA, LGPD, and HIPAA.

### Accelerate the “DevSecOps” Shift Left

- Equip your developer & analytics pipelines (Azure DevOps, Jenkins, Harness) and other automation workflows with production grade data by systematically and deterministically masking sensitive data in central ADF pipelines.
- Mask data consistently across data sources, maintaining referential integrity for integrated application testing. For example, the name George must always be masked to Elliot or a given social security number (SSN) must always be masked to the same SSN, whether George and his SSN appear in Oracle, Salesforce, or SAP.

### Reduce AI/ML Algorithm Training Time with Compliant Analytics

- Mask data in a manner that does not increase training cycles.
- Retain data integrity while masking to avoid impacting model/prediction accuracy.

Any Azure Data Factory connector can be used to facilitate a given use case.

## Key benefits

- Universal connectivity
- Realistic, deterministic masking that maintains referential integrity
- Preemptive identification of sensitive data for key enterprise applications
- Native cloud execution
- Template-based deployment
- Scalable

## Getting started

1. [Deploy the Delphix CC Engine on Azure](https://maskingdocs.delphix.com/Getting_Started/Installation/Azure_Installation/)
1. In ADF, deploy both the Delphix Continuous Compliance: Profiling (Delphix CC Profiling) and Delphix Continuous Compliance: Masking (Delphix CC Masking) ADF templates. These templates work for both Azure Synapse Analytics pipelines as well as ADF pipelines.
1. In the Copy Data components, configure the desired source and target datastores. In the Web Activity components, input the Delphix application IP address / host name and the credentials to authenticate with Delphix CC APIs.
1. Run the Delphix CC Profiling ADF template for initial setup, and any time you would like to re-identify sensitive data (ex: if there has been a schema change). This template provides Delphix CC with the initial configuration it requires to scan for columns that may contain sensitive data.
1. Create a [Ruleset](https://maskingdocs.delphix.com/Connecting_Data/Managing_Rule_Sets/#managing-rule-sets) indicating the collection of data that you would like to profile. Run a [Profiling Job](https://maskingdocs.delphix.com/Identifying_Sensitive_Data/Running_A_Profiling_Job/) in the Delphix UI to identify and classify sensitive fields for that Ruleset and assign appropriate masking algorithms.
1. Review and modify results from the [Inventory screen](https://maskingdocs.delphix.com/Connecting_Data/Managing_Inventories/#the-inventory-screen) as desired. Once you are satisfied with the results and would like to mask accordingly, [create a masking job](https://maskingdocs.delphix.com/Securing_Sensitive_Data/Creating_Masking_Job/).
1. Back in the ADF UI, open the Delphix CC Masking ADF template. Provide the Masking Job ID from the above step, then run the template.
1. At the end of this step, you will have masked data in the target datastore of your choice.

> [!NOTE]
> You will need the Delphix application IP address / host name with credentials to authenticate to Delphix APIs.

## Example architecture

Provided by an anonymous customer, this is intended only as a sample for how one might architect an environment for this masking use case.

:::image type="content" source="example-architecture.png" alt-text="Diagram of a sample architecture provided by an anonymous customer.":::

In the above example architecture:

- Azure Data Factory ingests / connects to production, unmasked data in the landing zone
- Data is moved to Data Staging in Azure Storage
- NFS mount of production data to Delphix CC PODs enables the pipeline to call the Delphix CC service
- Masked data is returned for distribution within ADF and lower environments

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Delphix CC irreversibly masks data values with realistic data that remains fully functional, enabling the development of higher-quality code.  Among the rich set of algorithms available to transform data to user specifications, Delphix CC has a patented algorithm that intentionally produces data collisions, and at the same time allows for salting data with specific values needed for potential validation routines run on the masked data set. From a Zero Trust perspective, operators do not need access to the actual data in order to mask it. In addition, the entire delivery of masked data from point A to point B can be completely automated via APIs.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

By adjusting values on the Azure pricing calculator (https://azure.microsoft.com/pricing/calculator/), you can see how your particular requirements impact cost.
Azure Synapse: You can scale compute and storage levels independently. Compute resources are charged per hour, and you can scale or pause these resources on demand. Storage resources are billed per terabyte, so your costs will increase as you ingest more data.

Data Factory: Costs are based on the number of read/write operations, monitoring operations, and orchestration activities performed in a workload. Your Data Factory costs will increase with each additional data stream and the amount of data processed by each one.

Delphix CC: Unlike other data compliance products on the market, masking does not require a full physical copy of the environment being masked. Environment redundancy can be extremely expensive because of the time to set up and maintain the infrastructure, the cost of the infrastructure itself, and the time spent repeatedly loading physical data into the masking environment.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Delphix CC is horizontally and vertically scalable. The transformations occur in memory and can be parallelized. The product runs both as a service and as a multi-node appliance allowing solution architectures of all sizes depending upon the application. Delphix is the market leader in delivering extremely large masked data sets.

Masking streams can be increased to engage multiple CPU cores in a job. (Configuration recommendations, as well as how to alter memory allocation can be found here: https://maskingdocs.delphix.com/Securing_Sensitive_Data/Creating_Masking_Job/).

For optimal performance for datasets larger than 1 TB in size, Delphix Hyperscale Masking (https://hyperscale-compliance.delphix.com/3.0.0/) breaks the large and complex datasets into numerous modules and then orchestrates the masking jobs across multiple Continuous Compliance Engines.

## Contributors

This article is maintained by Microsoft and Delphix. It was originally written by the following contributors.

Principal authors:

- [Tess Maggio](https://www.linkedin.com/in/tessmaggio/) | Product Manager 2 (Delphix)
- [Arun Saju](https://www.linkedin.com/in/arunsajukurian/) | Senior Staff Engineer (Delphix)
- [David Wells](https://www.linkedin.com/in/david-wells-986a654/) | Senior Director, Continuous Compliance Product Lead (Delphix)

Other contributors:

- [Doug Smith](https://www.linkedin.com/in/doug-smith-b2324b5/) | Global Practice Director, DevOps, CICD (Delphix)
- [Michael Torok](https://www.linkedin.com/in/michaelatorok/) | Senior Director, Community Management & Experience (Delphix)

## Next Steps

- [Learn about getting set up with Delphix CC](https://maskingdocs.delphix.com/)
- [Learn about using Delphix CC to find where sensitive data resides](https://maskingdocs.delphix.com/Identifying_Sensitive_Data/Discovering_Your_Sensitive_Data_-_Intro/) 
- [Learn more about customers using Delphix on Azure](https://www.delphix.com/solutions/cloud/azure)

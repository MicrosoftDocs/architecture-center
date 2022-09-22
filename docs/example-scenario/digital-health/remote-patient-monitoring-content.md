> [!NOTE]
> **SECTION TODOS**
> - intro is typically *"1-2 sentences to briefly explain this architecture. The full scenario info will go in the "Scenario details" section"*
> - review and finalize this section

Health systems, hospitals, and large physician practices are shifting to hospital@home initiatives (also known as remote patient monitoring). Remote patient monitoring is a subset of clinical care where care is accessed and delivered using remote health devices and care is based on individualized care plan parameters. 

This article provides guidance on how to design a solution using Azure Health Data Services and devices for intelligent remote patient monitoring. The solution will help alleviate many of the device integration challenges your organization is bound to face when building such a solution at scale. 

## Architecture

> [!NOTE]
> **SECTION TODOS**
> - diagram: replace Apple/Google/fitbit logos with generic mobile device icons; Jenna has a slide with some examples
> - diagram: review the Visio; when final upload to blob storage and create new .png
> - dataflow: review steps 1 thru 8
> - components: review and complete after dataflow section is completed
> - alternatives: TBD - do we have anything?

:::image type="content" source="./images/remote-patient-monitoring.png" alt-text="Diagram of remote patient monitoring architecture using healthcare devices and Azure services." lightbox="./images/remote-patient-monitoring.png" border="false" :::

*Download a [Visio file](https://arch-center.azureedge.net/[file-name].vsdx) of this architecture.*

### Dataflow

1. Patient devices generate [Fast Healthcare Interoperability Resources (FHIR®)](https://hl7.org/fhir/)-compliant health measurement/reading data. The data is then extracted from the devices using one of the available Microsoft open-source (OSS) SDKs and ingested by Azure Event Hubs.

1. Life365.health remote patient monitoring devices generate FHIR-compliant health measurement/reading data. The data is transmitted to the Life365.health API for storage, then extracted and ingested by Azure Event Hubs.

1. The Azure MedTech service pulls the FIHR-compliant data from Azure Event Hubs, and passes it into the Azure FHIR service. The Azure Health Data Services workspace is a logical container for healthcare service instances, such as the FHIR and MedTech services.  

1. FHIR CRUD events from inside of your workspace are published to Azure Event Grid and made available to event subscribers.

1. An FHIR Analytics Pipelines OSS pipeline moves FHIR data to Azure Data Lake, where it can be used by other analytics tools. 

1. Further analysis of the FHIR data is done using Azure Synapse Analytics, Apache Spark pools, Azure Databricks, and Azure Machine Learning (ML).

1. SQL Management Studio is used to create native SQL queries against Azure Synapse Analytics SQL pools.

1. Power BI is used for querying and analyzing FHIR data, using:
   - Power BI Template for FHIR Observation
   - Power BI Parquet Connector
   - Power BI FHIR Connector
   - Power BI SQL Connector

### Components

#### Devices

**Consumer devices**

Microsoft provides open-source SDKs to facilitate transfer of data from various consumer devices for ingestion by Azure Event Hubs:

- The [Fitbit on FHIR](https://github.com/microsoft/FitbitOnFHIR) OSS SDK supports Fitbit devices.
- The [Fit on FHIR](https://github.com/microsoft/fit-on-fhir) OSS SDK supports Google Fit devices.
- The [HealthKitToFhir Swift Library](https://github.com/microsoft/healthkit-to-fhir) OSS SDK supports Apple devices.

**Life365.health medical devices**

[Life365.health remote patient monitoring](https://www.life365.health/solutions-remote-patient-monitoring) supports [over 300 FDA approved bluetooth devices](https://www.life365.health/supported-devices) for ingestion by Azure Event Hubs. The devices span multiple categories and OEMs, including blood pressure monitors, glucometers, pulse oximeters, thermometers, weight scales, pill reminders and more.

#### Azure services

- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs/) - a fully managed, real-time data ingestion service that’s simple, trusted, and scalable. Stream millions of events per second from any source to build dynamic data pipelines and immediately respond to business challenges. In this architecture it's used for collecting and aggregating the device data, for transfer to Azure Health Data Services.

- [Azure Health Data Services](https://azure.microsoft.com/services/health-data-services/) is a set of managed API services based on open standards and frameworks that enable workflows to improve healthcare and offer scalable and secure healthcare solutions. The services used in this architecture include:

   - [Azure FHIR service](/azure/healthcare-apis/fhir/) - makes it easy to securely store and exchange Protected Health Information (PHI) in the cloud. Device data is transformed into FHIR-based [Observation](https://www.hl7.org/fhir/observation.html) resources to support remote patient monitoring. FHIR enables MedTech to successfully link devices, health data, labs, and remote in-person care to support the clinician, care team, patient, and family. As a result, this capability can facilitate the discovery of important clinical insights and trend capture. It can also help make connections to new device applications and enable advanced research projects. 

   - Azure [MedTech service](/azure/healthcare-apis/iot/) - a cornerstone of [Microsoft Cloud for Healthcare](https://www.microsoft.com/industry/health/microsoft-cloud-for-healthcare), used to support remote patient monitoring. MedTech is a Platform as a service (PaaS) that enables you to gather near-real-time data from diverse medical devices and convert it into an FHIR-compliant service format and store in an FHIR service. MedTech service's device data translation capabilities make it possible to transform a wide variety of data into a unified FHIR format that provides secure health data management in a cloud environment.  

     MedTech service is important for remote patient monitoring because healthcare data can be difficult to access or analyze when it comes from diverse or incompatible devices, systems, or formats. Medical information that isn't easy to access can be a barrier on gaining clinical insights and a patient's health care plan. The ability to translate health data into a unified FHIR format enables MedTech service to successfully link devices, health data, labs, and remote in-person care to support the clinician, care team, patient, and family. As a result, this capability can facilitate the discovery of important clinical insights and trend capture. It can also help make connections to new device applications and enable advanced research projects. Just as care plans can be individualized per use case, remote patient monitoring scenarios and use cases can vary per individualized need.  

- [Azure Health Data Services workspace](/azure/healthcare-apis/workspace-overview) - serves as a container for the other Azure Health Data Services instances, creating a compliance boundary (HIPAA, HITRUST) within which protected health information can travel. 

- [Azure Event Grid](https://azure.microsoft.com/services/event-grid/) - the [Azure Health Data Services events service](/azure/healthcare-apis/events/) generates FHIR CRUD events, which can be consumed by Azure Event Grid.

- [FHIR Analytics Pipelines OSS](https://github.com/microsoft/FHIR-Analytics-Pipelines) - an OSS project used to build components and pipelines for rectangularizing and moving FHIR data, from Azure FHIR servers to [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake/). In this architecture the project's **FHIR to Synapse sync agent** is used to extract data from the Azure FHIR service, convert to [Parquet-formatted files](/azure/databricks/data/data-sources/read-parquet), and write the data to Azure Data Lake. This solution enables you to query against the entire FHIR data with tools such as Synapse Studio, SQL Server Management Studio, Power BI and more.

#### Analytics

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/) - a limitless analytics service that brings together data integration, enterprise data warehousing, and big data analytics. It gives you the freedom to query data on your terms, using either serverless or dedicated options—at scale. Azure Synapse brings these worlds together with a unified experience to ingest, explore, prepare, transform, manage, and serve data for immediate BI and machine learning needs.
- [Apache Spark pools](/azure/synapse-analytics/spark/apache-spark-overview) - Apache Spark is a parallel processing framework that supports in-memory processing to boost the performance of big data analytic applications. Apache Spark in Azure Synapse Analytics is one of Microsoft's implementations of Apache Spark in the cloud. Azure Synapse makes it easy to create and configure a serverless Apache Spark pool in Azure. Spark pools in Azure Synapse are compatible with Azure Storage and Azure Data Lake Generation 2 Storage. So you can use Spark pools to process your data stored in Azure.
- [Azure Databricks](https://azure.microsoft.com/products/databricks/) - a data analytics platform optimized for the Microsoft Azure cloud services platform. Databricks provides a unified analytics platform for data analysts, data engineers, data scientists, and machine learning engineers. Three environments are offered for developing data intensive applications: Databricks SQL, Databricks Data Science & Engineering, and Databricks Machine Learning.
- [Azure Machine Learning (ML)](https://azure.microsoft.com/services/machine-learning/) - an Azure cloud service for accelerating and managing the machine learning project lifecycle. Machine learning professionals, data scientists, and engineers can use it in their day-to-day workflows: Train and deploy models, and manage MLOps. You can create a model in Azure Machine Learning or use a model built from an open-source platform, such as Pytorch, TensorFlow, or scikit-learn. MLOps tools help you monitor, retrain, and redeploy models.
- [Power BI](https://powerbi.microsoft.com/) - provides self-service analytics at enterprise scale, allowing you to:
   - Create a data-driven culture with business intelligence for all.
   - Keep your data secure with industry-leading data security capabilities including sensitivity labeling, end-to-end encryption, and real-time access monitoring.is used for further analysis of FHIR data.
- [Power Query connectors](/power-query/connectors/) and templates used with Power BI in this architecture include: 
   - [Power BI Template for FHIR Observation]() - TBD 
   - [Power BI Parquet Connector]() - TBD
   - [Power BI FHIR Connector]() - TBD
   - [Power BI SQL Connector]() - TBD
- [SQL Management Studio](/sql/ssms/download-sql-server-management-studio-ssms) - a desktop app used to create native SQL queries against SQL data stores, such as Azure Synapse Analytics SQL pools.

### Alternatives

> Use this section to talk about alternative Azure services or architectures that you might consider for this solution. Include the reasons why you might choose these alternatives. Customers find this valuable because they want to know what other services or technologies they can use as part of this architecture.
> What alternative technologies were considered and why didn't we use them?

## Scenario details

> [!NOTE]
> **SECTION TODOS**
> - needs review

There's a plenitude of medical and wearable/consumer devices out there today. To access the devices' measurements/readings, many of the in-home monitoring devices (such as blood pressure devices, scale…etc.) provide Bluetooth connectivity (such as Bluetooth Low Energy, or other older versions of the Bluetooth standard). There are also consumer wearable devices, as well as more advanced in-home devices that provide API connectivity to access the devices measurements. In this case the devices can sync the readings directly to the API (Wifi enabled) or connect to a mobile app on a smart phone (via Bluetooth), allowing the app to sync the reading back to the API.  

### Problem statement

Given the wide range of wearable and in-home medical devices and connectivity options (from Bluetooth to API specification), multiplied by the number of patients within the healthcare organization, data integration and orchestration may become a daunting task. 

### Potential use cases

- **Clinical trials and research** – Help clinical research teams integrate and offer a wide range of in-home and wearable medical devices to the study participant. In other words, offer a quasi-Bring-Your-Own-Device (BYOD) option to your study participants.

- **Data scientist and population health analytics** – The physiological dataset (the readings and measurements from those devices) will be available in the industry FHIR standard as well as other open-source data formats (JSON and Parquet). In addition to the data format, native connectors are provided to help with the data analysis and transformation. Including connectors such as the Power BI connector for FHIR, Synapse Serverless SQL views and Spark clusters in Synapse.

- **Enable healthcare providers** - Providers will be able to: 
   - gain better insights into patient health status
   - create proactive digital health care models
   - take more informed actions based on the physiological indicators/notifications
   - provide pathways for remote physiologic monitoring reimbursement 

## Considerations

> [!NOTE]
> **SECTION TODOS**
> - complete the mandatory Cost Optimization section
> - determine which 2 of the other 4 sections to include, and complete them

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

> Are there any lessons learned from running this that would be helpful for new customers?  What went wrong when building it out?  What went right?
> How do I need to think about managing, maintaining, and monitoring this long term?

> REQUIREMENTS: 
>   You must include the "Cost optimization" section. 
>   You must include at least two of the other H3 sub-sections/pillars

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

> This section includes resiliency and availability considerations. They can also be H4 headers in this section, if you think they should be separated.
> Are there any key resiliency and reliability considerations (past the typical)?

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

> This section includes identity and data sovereignty considerations.
> Are there any security considerations (past the typical) that I should know about this?
> Because security is important to our business, be sure to include your Azure security baseline assessment recommendations in this section. See https://aka.ms/AzureSecurityBaselines

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

> How much will this cost to run? See if you can answer this without dollar amounts.
> Are there ways I could save cost?
> If it scales linearly, then we should break it down by cost/unit. If it does not, why?
> What are the components that make up the cost?
> How does scale affect the cost?

> Link to the pricing calculator (https://azure.microsoft.com/en-us/pricing/calculator) with all of the components in the architecture included, even if they're a $0 or $1 usage.
> If it makes sense, include small/medium/large configurations. Describe what needs to be changed as you move to larger sizes.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

> This includes DevOps, monitoring, and diagnostics considerations.
> How do I need to think about operating this solution?

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

> This includes scalability considerations.
> Are there any key performance considerations (past the typical)?
> Are there any size considerations around this specific solution? What scale does this work at? At what point do things break or not make sense for this architecture?

## Deploy this scenario

> [!NOTE]
> **SECTION TODOS**
> - do we have a repo with a completed solution, that can be deployed?
 
> (Optional, but greatly encouraged)

> Is there an example deployment that can show me this in action?  What would I need to change to run this in production?

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors: 

 - [Mustafa Al-Durra](https://www.linkedin.com/in/mustafaaldurra/) | Healthcare Industry Architect
 - [Janna Templin](https://www.linkedin.com/in/janna-templin-9081a165/) | Senior Program Manager


Other contributors: 

 - [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Development Engineer
 - [Bryan Lamos](https://www.linkedin.com/in/bryanlamos/) | Senior Content Developer
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

> [!NOTE]
> **SECTION TODOS**
> - add links to other articles that would be next in sequence: Docs and Learn articles, third-party documentation
 
## Related resources

> [!NOTE]
> **SECTION TODOS**
> - add links to related healthcare example workloads
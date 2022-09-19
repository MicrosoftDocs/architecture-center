> [!NOTE]
> **SECTION TODOS**
> - cull/reconcile intro content from Janna and Mustafa's doc contributions
> - intro is typically *"1-2 sentences to briefly explain this architecture. The full scenario info will go in the "Scenario details" section"*

[Janna:]  
Remote patient monitoring is a subset of clinical care where care is accessed and delivered using remote health devices and care is based on individualized care plan parameters. Combining single or multiple Internet of Things (IoT) devices allows for a more holistic health data picture to optimize treatment plans and clinician workflows. The stack of Azure Health Data Services and features within can support the remote monitoring of health data allowing for sense making and health data analytics  

This article provides an overview of the Azure Health Data Services that support solutions for remote patient monitoring.  You'll learn about the different data processing stages within the Health Data services that transforms device data into Fast Healthcare Interoperability Resources (FHIR®)-based [Observation](https://www.hl7.org/fhir/observation.html) resources to support remote patient monitoring. The [MedTech service](/azure/healthcare-apis/iot/iot-connector-overview) feature will be the first step in setting up remote patient monitoring. 


[Mustafa:]  
Health Systems, hospitals, and large physician practices are shifting to hospital@home initiatives (also known as remote patient monitoring). Many of these enterprise clients are already integrated with the Microsoft Cloud for Healthcare platform to help implementing remote patient monitoring at scale, in a secured and cost-effective manner. One of the corner stones of the Microsoft Cloud for Healthcare is the MedTech service in Azure Health Data Services. MedTech is a Platform as a service (PaaS) that enables you to gather data from diverse medical devices and convert it into a Fast Healthcare Interoperability Resources (FHIR®) service format. 

FHIR enables MedTech to successfully link devices, health data, labs, and remote in-person care to support the clinician, care team, patient, and family. As a result, this capability can facilitate the discovery of important clinical insights and trend capture. It can also help make connections to new device applications and enable advanced research projects. 

## Architecture

> [!NOTE]
> **SECTION TODOS**
> - diagram: decide whether to pursue trademark/logo usage perms from Apple/Google/fitbit, or replace with generic mobile device icons
> - diagram: review/complete the Visio; when final upload to blob storage and create new .png
> - dataflow: review/complete steps 1 thru 8
> - components: complete after dataflow section is completed
> - alternatives: TBD

The following example provides an intelligent remote patient monitoring solution. It will help alleviate many of the device integration challenges your organization is bound to face when building such a solution at scale. 

:::image type="content" source="./images/remote-patient-monitoring.png" alt-text="Diagram of remote patient monitoring architecture using healthcare devices and Azure services." lightbox="./images/remote-patient-monitoring.png" border="false" :::

*Download a [Visio file](https://arch-center.azureedge.net/[file-name].vsdx) of this architecture.*

### Dataflow

1. Patient devices generate [FHIR-compliant](https://hl7.org/fhir/) health measurement/reading data, and store it in the corresponding data stores. The data is then extracted and ingested by [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs/) using one of the available Microsoft open-source (OSS) SDKs:  
   - The [Fitbit on FHIR](https://github.com/microsoft/FitbitOnFHIR) OSS SDK supports Fitbit devices.
   - The [Fit on FHIR](https://github.com/microsoft/fit-on-fhir) OSS SDK supports Google Fit devices.
   - The [HealthKitToFhir Swift Library](https://github.com/microsoft/healthkit-to-fhir) OSS SDK supports Apple devices.

1. [Life365.health remote patient monitoring](https://www.life365.health/solutions-remote-patient-monitoring) supports over 400 FDA approved bluetooth devices. FHIR-compliant health measurement/reading data is generated from the devices and transmitted to the Life365.health API for storage, then extracted and ingested by Azure Event Hubs.

1. The Azure [MedTech service](/azure/healthcare-apis/iot/) pulls the FIHR-compliant data collected by Azure Event Hubs, and passes it into the [Azure FHIR service](/azure/healthcare-apis/fhir/). Both of these services are part of [Azure Health Data Services](https://azure.microsoft.com/services/health-data-services/), and are instantiated through an [Azure Health Data Services workspace](/azure/healthcare-apis/workspace-overview). The Azure Health Data Services workspace is a logical container for all of your healthcare service instances, such as the FHIR and MedTech services. The workspace also creates a compliance boundary (HIPAA, HITRUST) within which protected health information can travel. 

1. FHIR CRUD events from inside of your workspace are generated by the [Azure Health Data Services events service](/azure/healthcare-apis/events/). They're published to [Azure Event Grid](https://azure.microsoft.com/services/event-grid/) and made available to event subscribers.

1. The [FHIR Analytics Pipelines OSS](https://github.com/microsoft/FHIR-Analytics-Pipelines) project is used to build components and pipelines for rectangularizing and moving FHIR data, from Azure FHIR servers to [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake/). In this architecture the project's **FHIR to Synapse sync agent** is used to extract data from the Azure FHIR service, convert to [Parquet-formatted files](/azure/databricks/data/data-sources/read-parquet), and write the data to Azure Data Lake. This solution enables you to query against the entire FHIR data with tools such as Synapse Studio, SQL Server Management Studio, Power BI and more.

1. For further analysis of the FHIR data ...
   - [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/) [Apache Spark pools]()
   - [Azure Databricks](https://azure.microsoft.com/products/databricks/)
   - [Azure Machine Learning (ML)](https://azure.microsoft.com/services/machine-learning/)  

1. Use [SQL Management Studio](/sql/ssms/download-sql-server-management-studio-ssms) for creating native SQL queries against Azure Synapse Analytics SQL pools.

1. [Power BI](https://powerbi.microsoft.com/) also provides multiple options for querying and analyzing FHIR data:  
   **TODO: Need links: PowerBI Template for FHIR Observation; also are the others Power BI or [Power Query connectors](/power-query/connectors/)?**
   - [Power BI Template for FHIR Observation]()
   - [Power BI Parquet Connector]()
   - [Power BI FHIR Connector]()
   - [Power BI SQL Connector]()  

### Components

#### Devices

**Consumer devices**

**Life365.health devices**

#### Azure services

**MedTech service** 

[Janna:]  
MedTech service is an integral feature within Azure Health Data Services to support remote patient monitoring. MedTech service is a Platform as a service (PaaS) that enables you to gather data from desperate medical devices and IoMT devices. The health data is converted into a Fast Healthcare Interoperability Resources (FHIR®) service format to be stored in a FHIR service. MedTech service's device data translation capabilities make it possible to transform a wide variety of data into a unified FHIR format that provides secure health data management in a cloud environment. 

MedTech service is important for remote patient monitoring because healthcare data can be difficult to access or analyze when it comes from diverse or incompatible devices, systems, or formats. Medical information that isn't easy to access can be a barrier on gaining clinical insights and a patient's health care plan. The ability to translate health data into a unified FHIR format enables MedTech service to successfully link devices, health data, labs, and remote in-person care to support the clinician, care team, patient, and family. As a result, this capability can facilitate the discovery of important clinical insights and trend capture. It can also help make connections to new device applications and enable advanced research projects. Just as care plans can be individualized per use case, remote patient monitoring scenarios and use cases can vary per individualized need.  

#### Analytics tools

**Power BI**

**SQL Server Management Studio**

### Alternatives

> Use this section to talk about alternative Azure services or architectures that you might consider for this solution. Include the reasons why you might choose these alternatives. Customers find this valuable because they want to know what other services or technologies they can use as part of this architecture.
> What alternative technologies were considered and why didn't we use them?

## Scenario details

> [!NOTE]
> **SECTION TODOS**
> - review and complete

[Mustafa:]  
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
> 
> (Optional, but greatly encouraged)

> Is there an example deployment that can show me this in action?  What would I need to change to run this in production?

## Contributors

> [!NOTE]
> **SECTION TODOS**
> - do we want this section?

> (Expected, but this section is optional if all the contributors would prefer to not be mentioned.)

> Start with the explanation text (same for every section), in italics. This makes it clear that Microsoft takes responsibility for the article (not the one contributor). Then include the "Principal authors" list and the "Other contributors" list, if there are additional contributors (all in plain text, not italics or bold). Link each contributor's name to the person's LinkedIn profile. After the name, place a pipe symbol ("|") with spaces, and then enter the person's title. We don't include the person's company, MVP status, or links to additional profiles (to minimize edits/updates). Implement this format:

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors: > Only the primary authors. Listed alphabetically by last name. Use this format: Fname Lname. If the article gets rewritten, keep the original authors and add in the new one(s).

 - [Author 1 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - [Author 2 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - > Continue for each primary author (even if there are 10 of them).

Other contributors: > Include contributing (but not primary) authors, major editors (not minor edits), and technical reviewers. Listed alphabetically by last name. Use this format: Fname Lname. It's okay to add in newer contributors.

 - [Contributor 1 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - [Contributor 2 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - > Continue for each additional contributor (even if there are 10 of them).
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

> [!NOTE]
> **SECTION TODOS**
> - add links to other articles that would be next in sequence: Docs and Learn articles, third-party documentation
 
## Related resources

> [!NOTE]
> **SECTION TODOS**
> - add links to related healthcare example workloads
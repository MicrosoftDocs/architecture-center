<!---
Comment: DONE
#Introductory section - no heading

#> This should be an introduction of the business problem and why this scenario was built to solve it.
#>> What industry is the customer in?
#>> What prompted them to solve the problem?
#>> What services were used in building out this solution?
#>> What does this example scenario show? What are the customer's goals?

#> What were the benefits of implementing the solution described below?
-->

In recent years, the demand for business users capability to consume, transform, model, and visualize large amounts of complex data from multiple heterogenous sources has increased dramatically. To meet this demand in a cost effective, scalable way many large companies have benefitted from moving to cloud-based data platforms. This move allows companies to leverage the economy of scale the cloud provides to achieve lower total cost of ownership and faster time to value from data. Regulated industries are no exception to this as these companies need to store and process vast amounts of highly sensitive data (e.g., protected health information) every day. However, due to the sensitive nature of this data, there are many regulations (e.g., HIPAA) in place to constrain the methods for storing, transporting, and processing the data. As a result of this, regulated industries have been hesitant to adopt cloud-based data platforms due to the large financial penalties for a regulatory violation as well as the perceived loss of control that comes from moving to a cloud-based platform. 

The worldwide COVID-19 pandemic changed all of this as many regulated industries on-premises data platforms were largely unable to cope with the increased workload coming as a direct result of the pandemic. While these companies are now embracing cloud-based data platforms, they are typically doing so in two extreme ways. Either with highly complex and detailed security requirements or with limited knowledge of security capabilities and practices in cloud. This makes rapid deployment of services and solutions challenging as many security options can be disabled, overlooked or simply ignored, leaving these companies open to regulatory action (e.g., financial penalties) if left unchecked.

The Infrastructure Accelerator pattern is designed to ameliorate this issue by tackling data analysis workloads in regulated industries. This pattern is specifically designed to help ensure the detailed security and privacy requirements of different regulated industries are met by leveraging configurable, template based service deployment automation. All build on Azure managed services to reduce management overhead. Specifically, the pattern focuses on high quality security standards, auditing, monitoring key protection, encryption capabilities, and tight integration with security perimeters (when applicable). You can think about this guidance as Enterprise Ready plug-able infrastructure building block for Data Analytics workloads utilizing Microsoft Best Practices for Landing Zones.
Users of this pattern will have the flexibility to choose which data processing services (e.g., Azure Data Factory, Azure Databricks, Azure Synapse Analytics) they want to use with the comfort of knowing the services will be deployed using both Microsoft best practices for Landing Zones as well as any company specific policy requirements. In short, we believe that all customers from regulated industries will benefit from this pattern and infrastructure deployment accelerator tools.

Some of the key benefits of this pattern are:

- Speed of deployment and consistency between projects and environments (DEV/TEST/STG/PROD).
- Coverage of major data analysis use cases ETL/ELT + PowerBI (Ingestion/Transformation/Storage/Data Lake/SQL/PowerBI).
- Focus on automated support of enterprise-grade security standards.
- Strong support for auditing, monitoring and diagnostics data.
- Constraint of network communication to network/security perimeters (when applicable).
- Easy consumption of data sources from inside perimeter along with cloud-based data analysis.
- Benefit from cloud managed services with reduced management and operation overhead.
- Seamless integration with cloud native tools (e.g., Power Platform).
- Automated protection and encryption of storage containing potentially sensitive data.
- Secure protection of keys and credentials.
- Designed to support easy customer-based customization
- No Azure landing zone needed but can integrate seamlessly, including hub-and-spoke network topology.

## Potential use cases

<!---
Comment: DONE
#> Are there any other use cases or industries where this would be a fit?
#> How similar or different are they to what's in this article?
-->

Any customer looking for PaaS solution for Data and AI workloads plus visualization (ETL/ELT + PowerBI)
integrated with network perimeter and with focus on high security standards,
protecting data, Auditing, Monitoring should benefit from this pattern.

<!---
Comment: DONE
#These other uses cases have similar design patterns:

#- List of example use cases
-->

- Regulated industries generally
- Financial sector
- Health Care Clinical Trials
- Financial reporting and financial departments
- Supply chain management
- Manufacturing

## Architecture

<!---
Comment: DONE
#_Architecture diagram goes here_

#> What does the solution look like at a high level?
#> Why did we build the solution this way?
#> What will the customer need to bring to this?  (Software, skills, etc?)

#Under the diagram, include a numbered list that describes the data flow or workflow.
-->

The following diagram shows high level overview of the architecture for this infrastructure accelerator for data analysis workloads in regulated industries.
Focus is to provide the highest security level as this deployment pattern is used in Highly Regulated Industries.

[![Graphical example of an infrastructure accelerator architecture.](media/data-analysis-architecture-01.png)](media/data-analysis-architecture-01.png#lightbox)

In upper part you can see capabilities of this infrastructure pattern for data analysis workloads. Items like input and target data sources (can be in cloud or onPrem), ingestion area, storing and snapshot data (versioning) in raw and cheap way, transform raw data, storing optimized data in structured way and with metadata for consumers and consume capabilities through front ends.

Bottom part is on the other hand showing responsibilities of different IT roles typically involved for such data analysis cloud workloads.

This architecture allows to provide strong and typical data analysis capabilities along with strong governance and security model regulated industries need.

Implementation of such architecture and pattern in full range with major benefits requires specific skill-set like:

- People who understands how to configure, monitor and operate Azure cloud, governance model, security, policies, landing zone, automation in cloud
- People who understands configure and monitor cloud networking, private links, DNS, routing, access control lists, firewall, VPN integrations
- People who understands and monitor cloud security, security incidents, constantly evaluating security threads
- People who understands Azure Data Tools like Azure Data Factory, Azure Databricks, Azure Data lake, Azure SQL Database and can integrate data components (ETL/ELT), create semantic models, use different data formats
- End users who can use Power BI for self service reporting

Description of implementation workflow:

- Infrastructure and Governance model
  - Cloud Ops Team provisions in repeatable and consistent way the Data Analysis environment with existing optimized security
  settings for regulated industries through automated and parametrized way. They can use existing scripts and optionally modify them to fit to the enterprise specific standards and policies. Cloud Ops and Cloud security team can start to see security compliance reports. Billing information for the environment can be monitored.
  - Network team typically integrates the environment with Enterprise network (ideally Hub-and-spoke model with Enterprise Firewall), enables private links for endpoints and can start to monitor a traffic. Integration of Microsoft Power BI with virtual network (to use private traffic) is recommended.
  - Cloud Security Team reviews infrastructure through built-in or Enterprise specific Azure policies, reviews security score of the environment in Azure Advisor and Security Center. Security team can also own and maintain credentials stored in the Key vault to specific data source systems and encryption keys. Security team can also start to monitor audit information stored in the central Log Analytics Workspace.
- Usage and Data Analysis Capabilities
  - Data Administrators/Data Developers can start to prepare ETL/ELT pipelines and semantic models for self-service BI. This covers complete data preparation life cycle (Ingest/Store/Transform/Store in Optimized Model/Consume).
  - Business users can start to consume and present data through business semantic models prepared by Data Developers. Typically through front end applications like Microsoft Power BI or custom applications.

Following diagram shows more components based view and integration with an enterprise environment.

[![Components view and integration with an enterprise environment.](media/data-analysis-architecture-02.png)](media/data-analysis-architecture-02.png#lightbox)

### Description of Pattern and Architecture in Details

Business Users needs to present, consume, slice and dice data in quick way on multiple devices from multiple places. Ideally on data model which is optimized (transformed) for data domain they are aligned to.

To achieve this, you typically need to get data in scalable way from multiple data sources in raw format (typically sitting on-prem), store them in scalable way with potentially huge volumes. Store them to cheap storage in multiple versions and with history, clean data, combine data Together, pre-aggregate data and store them again in structured way with indexing capability to provide speed for access. You probably also want to mask data and secure/hide data which should not be seen by users from other geo regions or departments.

For that, you need to understand (propagate security context) who is viewing the data from reporting tool to structured storage and ensure you are filtering data for target user based on role. (Role Based Access Control, Row Level Security). You do not want to do it manually, database engine should do it for you based on roles.

_**Business Users needs to present, consume, slice and dice data in quick way on multiple devices from multiple places**_

This can be achieved by easy-to-use PowerBI reporting tool, which can be used from anywhere and on multiple platforms and devices.

PowerBI runs in cloud as managed service. Service can be also integrated with perimeter for access from devices and can also access data sources which are part of perimeter (on-premises or in cloud via private link).

You do not want to use PowerBI gateway for perimeter access which is typically multiplexing accessing users to one service identity and thus undermining security context against target database which is important to preserve.

PowerBI also supports integration with Azure Active Directory (cloud identity) and advanced security features. Identity and whole
security context can be thus propagated through PowerBI to the database engine and database engine can use native filtering capabilities based on role accessing user belongs to.

Example can be: user from mobile device outside perimeter needs to access predefined and optimized report which is accessing and rendering sensitive data from data source hosted inside a perimeter. User might be required to establish VPN connectivity first, will be prompted to authenticate to PowerBI, verified with MFA and PowerBI rendering engine will pass user's identity of accessing user to the target database hosted in the perimeter. Database can verify accessing user and understand user's role/security group. With that database engine can do query/data filtering and show only data user was allowed to see.

_**Need to get data in scalable way from multiple data sources in raw format (typically sitting on-prem), store them in scalable way with huge volumes to cheap storage in multiple versions and with history**_

PowerBI ideally needs to consume optimized data models for specific data domain which improves user experience, reduces waiting time and improves data model maintenance. Before that, you typically need to run some ETL process which will first get data from multiple data sources from many places, in raw format (snapshots) and store them for further processing.

In this architecture load is mainly role of Azure Data Factory - Easy to use ETL tool along with Azure Storage in Azure Data Lake (Hierarchical namespace) mode.

Azure Data Factory managed PaaS service allows you to connect many data sources through massive list of ever-growing list of supported connectors.
Azure Data Factory has a workspace where ETL process can be designed and executed at scale. Workspace can be accessed from anywhere as access policy allows and is specified by security administrators. Similar approach like accessing O365 workspace.

Azure Data Factory also understands and can store data in multiple file formats (standard or proprietary). Azure Data Factory can access data and store them in scalable manner as snapshots to Azure Data Lake Storage. Basically, get data in scalable way from anywhere and store them in raw format to Azure Data Lake Storage in versioned way so more sophisticated data models can be built based on such data.

To access data sources from cloud you need to have some kind of gateway which will not require to punch hole into the enterprise firewall. This is what Azure Data Factory Self Host Integration Runtime provides. This component needs to be installed in the on-premises environment (physical or virtual machine) and needs to be allowed to open communication to the cloud. Azure Data Factory then can consume data from allowed data sources inside organization and process them in cloud by specific associated and only allowed Azure Data Factory instance.

Azure Data Lake is very cheap, practically unlimited storage space where data can be stored in raw formats, in multiple versions (e.g daily snapshots) and storage is providing very secure (Role Based Access Control) way to store data. This storage is also optimized for support of massive parallel processing of data. To provide even better security story, Azure Data Lake Storage is part of perimeter without exposing any public endpoint.

Storage will not be accessed directly by PowerBI (although technically possible and supported). Storage is kind of staging area in this case.
PowerBI should work with more structured and optimized domain driven data source built from raw data from storage.

_**Store data in structured way with indexing capability to provide speed for access. Data model which is optimized (transformed) for data domain data are aligned to.**_

Once the data are snapshot and available in cheap storage in raw, versioned, and complete form, it's time to transform them to the most useful product.
As domain data model expectations changes during a time it's very useful to keep data in complete - raw form and with history.
This allows at any point in time to introduce new dimension or attribute to domain data model with projection to the history.

ADAW supports transformations of data in mainly two ways (Azure Data Factory and Azure Databricks).
Both very capable and scalable tools with rich transformational features and adapters.

Solution was designed for reading data from Azure Data Lake Storage through private endpoint (part of perimeter), cleaning/normalizing data at scale, transforming at scale, aggregating/merging/combining data at scale and with cost control (Azure Data Factory and/or Azure Databricks - fast transformation with more horse power for higher cost vs slower transformation with less power for better price) and storing cleaned/transformed/aggregated and domain optimized data to highly structured database with indexed data and business/domain specific vocabulary (Azure SQL Database).

Azure Databricks should be deployed with Premium SKU to enable advanced security features like RBAC for Cluster, Jobs, Notebooks and Azure AD passthrough.

Also Azure Databricks Virtual Network integrated with data sources and perimeter and Firewall for egress control should be enabled.

Azure Data Factory and Azure Databricks Workspace (not data) can be accessed through public endpoint with Azure Active Directory Authentication and enabled conditional access.

Azure SQL Database in this solution is playing key role as data source consumed by PowerBI clients. Model is optimized for business domain, for PowerBI reports, with right business terminology and attributes and security trimming done at the database engine level through native capabilities.
Also PowerBI is configured in the way to consume data over private endpoints from Azure SQL Database (point-to-point) and
ingest data from Azure Databricks / Azure Data Factory Self Host Integration Runtime to improve security posture.

_**Mask data and secure/hide data which should not be seen by users from other geo regions or departments.**_

Data stored in the business data domain database (here Azure SQL Database) will probably contain data across whole organization and with sensitive data.
It's important to allow access only to subset of data based on roles accessing user belongs to. Typically, data cross regions from different units in different geo locations, etc.
It's not best approach to do such filtering manually in code (error prone) and also it is not desired to do it in reports itself.
Such filtering based on security context should be done purely on the database level and all other consuming tools (including reporting tools) will receive already filtered data. Accessing tools should pass identity of viewing user - not service accounts.
This allows to stay compliant with different auditing and traceability requirements.

Fortunately, Azure SQL Database implements such native features on the database engine level (row-level security) which makes implementation of such security trimming and auditing easier.

This requires propagating security context from viewing user to the database level. PowerBI can understand a propagate security context (user's cloud identity) to the business data domain database and database is able to use such identity, authenticate, authorize and filter data for such user based on the identity or roles this user belongs to.

### Components

<!---
#A bulleted list of components in the architecture (including all relevant Azure services) with links to the service pages.
> Why is each component there?
> What does it do and why was it necessary?
#> Link the name of the service (via embedded link) to the service's product service page. Be sure to exclude the localization part of the URL (such as "en-US/").

- Examples: 
  - [Azure App Service](https://azure.microsoft.com/services/app-service)
  - [Azure Bot Service](https://azure.microsoft.com/services/bot-service)
  - [Azure Cognitive Services Language Understanding](https://azure.microsoft.com/services/cognitive-services/language-understanding-intelligent-service)
  - [Azure Cognitive Services Speech Services](https://azure.microsoft.com/services/cognitive-services/speech-services)
  - [Azure SQL Database](https://azure.microsoft.com/services/sql-database)
  - [Azure Monitor](https://azure.microsoft.com/services/monitor): Application Insights is a feature of Azure Monitor.
  - [Resource Groups][resource-groups] is a logical container for Azure resources.  We use resource groups to organize everything related to this project in the Azure console.
-->

Key Components and services used in this pattern:

- [Azure Data Lake Store Generation 2](https://azure.microsoft.com/services/storage/data-lake-storage)
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database)
- [Azure Databricks](https://azure.microsoft.com/services/databricks)
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory)
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs)
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault)
- [Azure Monitor and Log Analytics](https://azure.microsoft.com/services/monitor)
- [Power BI or Power BI Premium + VNET Integration - Optional](https://docs.microsoft.com/data-integration/vnet/use-data-gateways-sources-power-bi)
- [Azure Data Factory Self Host Integration Runtime - Optional](https://docs.microsoft.com/azure/data-factory/create-self-hosted-integration-runtime)

### Alternatives

<!---
Comment: DONE
#Use this section to talk about alternative Azure services or architectures that you might consider for this #solution. Include the reasons why you might choose these alternatives.

#> What alternative technologies were considered and why didn't we use them?
-->

This pattern is effectively building something what is available in the Azure Synapse Analytics product. Use of Azure Synapse Analytics product should be the preferred way. However, sometimes customers cannot use/deploy Azure Synapse Analytics for whatever reason and in those cases this pattern can help and can be more adjustable solution.

See [Enterprise Data Warehouse Architecture](/azure/architecture/solution-ideas/articles/enterprise-data-warehouse) as alternative solution to this pattern.

## Considerations

<!---
> Are there any lessons learned from running this that would be helpful for new customers?  What went wrong when building it out?  What went right?
> How do I need to think about managing, maintaining, and monitoring this long term?
> Note that you should have at least two of the H3 sub-sections.
-->

TODO

### Availability

<!---
> How do I need to think about managing, maintaining, and monitoring this long term?
-->

TODO

### Operations

<!---
> How do I need to think about operating this solution?
-->

TODO

### Performance

<!---
> Are there any key performance considerations (past the typical)?
-->

TODO

### Scalability

<!---
Comment: DONE
#> Are there any size considerations around this specific solution?
#> What scale does this work at?
#> At what point do things break or not make sense for this architecture?
-->

This architecture pattern is based at managed Azure services with great built-in scalability features which allows to find right balance between speed and cost.

This solution can work with petabytes of data.

If data ingestion is done from on premises data sources and perhaps through Azure Data Factory Self Host Integration Runtime, the limitation can be bandwidth and latency of VPN network and horse power of Self Host Integration Runtime machine.

Address range / Size of virtual network for Data Analytical Workspace can limit number of VMs used by Azure Databricks.

### Security

<!---
Comment: DONE
#> Are there any security considerations (past the typical) that I should know about this? 
-->

Consider following security monitoring and practices:

- Use Azure Active Directory Identity Protection, configure MFA, Conditional Access and Monitor Azure Active Directory
- Use Azure Security Center to monitor environments, recommendations, security score and potential issues and incidents
- Use Azure Policies to monitor and Enforce security standards
- Use and Monitor Diagnostic settings, vulnerability scans and Auditing Logs, forward logs to SIEM
- Monitor Network traffic, routing, firewall, access control list and keep traffic in perimeter through private link and VPN feature
- Store Credentials, Keys and secrets in Key Vault, limit access to Key Vault to limited number of people, do keys rotations and monitor operations and access to Key Vault

### Resiliency

<!---
Comment: DONE
#> Are there any key resiliency considerations (past the typical)?
-->

This pattern builds on Azure PaaS services hosted in one specific region. It might be beneficial to utilize other Azure regions as well to increase Resiliency of this solution but it brings additional complexity. Geo redundancy is currently out of the scope of this pattern description.

### DevOps

<!---
Comment: DONE
#> Are there any key DevOps considerations (past the typical)?
-->

Not observed

## Deploy this scenario

<!---
Comment: DONE
#> (Optional, but greatly encouraged)
#>
#> Is there an example deployment that can show me this in action?  What would I need to change to run this in production?
-->

To implement this pattern go to the link to the project page: [Azure Data Analytical Workspace (ADAW) - Reference Architecture 2021 for Regulated Industries](https://github.com/jbinko/ADAW).
Link includes deployment scripts, to successfully deploy workspace for data analysis based on Azure services.

Data Analytical Workspace can be deployed in automated way through provided scripts in cloud native way. This provides consistent experience with focus on high quality security standards. Approve once, deploy multiple times in the same secure way.

## Pricing

<!---
> How much will this cost to run?
> Are there ways I could save cost?
> If it scales linearly, than we should break it down by cost/unit. If it does not, why?
> What are the components that make up the cost?
> How does scale affect the cost?
>
> Link to the pricing calculator with all of the components in the architecture included, even if they're a $0 or $1 usage.
> If it makes sense, include small/medium/large configurations. Describe what needs to be changed as you move to larger sizes.
-->

TODO

## Next steps

<!---
Comment: DONE
#> Where should I go next if I want to start building this?
#> Are there any reference architectures that help me build this?
#> Be sure to link to the Architecture Center, to related architecture guides and architectures.
 
- Examples:
  - [Artificial intelligence (AI) - Architectural overview](/azure/architecture/data-guide/big-data/ai-overview)
  - [Choosing a Microsoft cognitive services technology](/azure/architecture/data-guide/technology-choices/cognitive-services)
  - [What are Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)
  - [What is Language Understanding (LUIS)?](/azure/cognitive-services/luis/what-is-luis)
  - [What is the Speech service?](/azure/cognitive-services/speech-service/overview)
  - [What is Azure Active Directory B2C?](/azure/active-directory-b2c/overview)
  - [Introduction to Bot Framework Composer](/composer/introduction)
  - [What is Application Insights](/azure/azure-monitor/app/app-insights-overview)
  - [Chatbot for hotel reservations](/azure/architecture/example-scenario/ai/commerce-chatbot)
  - [Build an enterprise-grade conversational bot](/azure/architecture/reference-architectures/ai/conversational-bot)
  - [Speech-to-text conversion](/azure/architecture/reference-architectures/ai/speech-ai-ingestion)
-->

To implement this pattern go to the link to the project page: [Azure Data Analytical Workspace (ADAW) - Reference Architecture 2021 for Regulated Industries](https://github.com/jbinko/ADAW).
Link includes deployment scripts, to successfully deploy workspace for data analysis based on Azure services.

Also see:
  - [Enterprise Data Warehouse Architecture](/azure/architecture/solution-ideas/articles/enterprise-data-warehouse)
  - [Modern data warehouse for small and medium business](/azure/architecture/example-scenario/data/small-medium-data-warehouse)
  - [Data warehousing and analytics](/azure/architecture/example-scenario/data/data-warehouse)

## Related resources

<!---
Comment: DONE
#> Are there any relevant case studies or customers doing something similar?
#> Is there any other documentation that might be useful?
#> Are there product documents that go into more detail on specific technologies that are not already linked?

[calculator]: https://azure.com/e/
-->

See the link to the project page: [Azure Data Analytical Workspace (ADAW) - Reference Architecture 2021 for Regulated Industries](https://github.com/jbinko/ADAW)

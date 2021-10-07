<!---
#Introductory section - no heading

> This should be an introduction of the business problem and why this scenario was built to solve it.
#>> What industry is the customer in?
>> What prompted them to solve the problem?
#>> What services were used in building out this solution?
#>> What does this example scenario show? What are the customer's goals?

#> What were the benefits of implementing the solution described below?
-->



@DJ: We need to describe more on high level why we built this pattern (that it is ETL/ELT + PowerBI - something what we pitched to the customer, that we are seeing this with other customers, pros/cons), why not Synapse, benefits, etc.
They are not focused on deployment scripts here, etc.
I think my text here below is not optimal and not fully fitting to their expectations to describe reusable pattern.
Maybe some text can be reused from here: <https://github.com/jbinko/ADAW#architecture-overview>


This is description of Infrastructure Accelerator pattern for Data Analysis workloads for regulated industries with focus on high quality security standards, auditing, monitoring keys protection and encryptions capabilities and integration with perimeter where applicable. All build on Azure managed services to reduce management overhead.

You can think about this guidance as Enterprise Ready plug-able infrastructure building block for Data Analytics workloads compatible with Microsoft Best Practices for Landing Zones.

All customers from regulated industries should benefit from this pattern.

Business Users needs to present, consume, slice and dice data in quick way on multiple devices from multiple places. Ideally on data model which is optimized (transformed) for data domain they are aligned to.

To achieve this, you typically need to get data in scalable way from multiple data sources in raw format (typically sitting on-prem), store them in scalable way with potentially huge volumes. Store them to cheap storage in multiple versions and with history, clean data, combine data Together, pre-aggregate data and store them again in structured way with indexing capability to provide speed for access. This pattern is supporting such Data Analysis workloads with high Enterprise security standards.

Key benefits of this pattern:

- Speed of deployment and consistency between projects an environments (DEV/TEST/STG/PROD)
- Should cover major Data Analysis use cases ETL/ELT + PowerBI (Ingestion/Transformation/Storage/Data Lake/SQL/PowerBI)
- Focus on Enterprise Grade Security standards
- Strong Support for Auditing, Monitoring and Diagnostics data
- Integrate and Keep network communication in perimeter where applicable
- Allow consumption of data sources inside perimeter, analyze data in cloud
- Benefit from Cloud Managed Services, reduce management and operations overhead
- Integrations with other cloud native tools - mainly Power Platform
- Protect and encrypt storage where potentially sensitive data are stored
- Protect keys and credentials in secure place
- Designed to support customizations / Every customer is different
- Does NOT require mature Azure landing zone (Can be from NONE to Enterprise)

## Potential use cases

<!---
> Are there any other use cases or industries where this would be a fit?
> How similar or different are they to what's in this article?
-->



@DJ: Please provide your additional thoughts



Any customer looking for PaaS solution for Data and AI workloads (ETL/ELT + PowerBI)
integrated with network perimeter and with focus on high security standards,
protecting data, Auditing, Monitoring should benefit from this pattern.

<!---
These other uses cases have similar design patterns:

- List of example use cases
-->

@DJ: Please provide your additional thoughts


- Health Care Clinical Trails
- Health Care Financial reporting
- Supply chain management
- Financial sector

## Architecture

<!---
_Architecture diagram goes here_

> What does the solution look like at a high level?
> Why did we build the solution this way?
> What will the customer need to bring to this?  (Software, skills, etc?)

Under the diagram, include a numbered list that describes the data flow or workflow.
-->

TODO

### Components

<!---
A bulleted list of components in the architecture (including all relevant Azure services) with links to the service pages.

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

- [Azure Data Lake Store Gen2](https://azure.microsoft.com/services/storage/data-lake-storage)
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database)
- [Azure Databricks](https://azure.microsoft.com/services/databricks)
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory)
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs)
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault)
- [Azure Monitor and Log Analytics](https://azure.microsoft.com/services/monitor)
- [Power BI Premium + VNET Integration - Optional](https://docs.microsoft.com/data-integration/vnet/use-data-gateways-sources-power-bi)
- [Azure Data Factory Self HostIntegration Runtime - Optional](https://docs.microsoft.com/azure/data-factory/create-self-hosted-integration-runtime)

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
> Are there any size considerations around this specific solution?
> What scale does this work at?
> At what point do things break or not make sense for this architecture?
-->

TODO

### Security

<!---
> Are there any security considerations (past the typical) that I should know about this? 
-->

TODO

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

Azure is used as the core of many digital transformation programs, but it is dependent on the quality and consistency of data from multiple sources—business applications, databases, data feeds, and so on—and delivers value through business intelligence, analytics, machine learning, and more. Profisee's Master Data Management (MDM) solution completes the Azure data estate with a practical method to 'align and combine' data from multiple sources by enforcing consistent data standards on source data (match, merge, standardize, verify, correct). Native integration with Azure Data Factory and other Azure Data Services further streamlines this process to accelerate the delivery Azure business benefits.

A core aspect of how MDM solutions function is that they combine data from multiple sources to create a "golden record master" that contains the best-known and trusted data for each record. This structure is built out domain-by-domain according to requirements, but it nearly always requires multiple domains. Common domains are customer, product, and location, but domains can represent anything from reference data to contracts and drug names. In general, the better domain coverage that can be built out relative to the broad Azure data requirements the better.

This architectural pattern demonstrates how MDM can be incorporated into the Azure data services ecosystem to improve the quality of data used for analytics and operational decision making. MDM solves several common challenges including the identification and management of duplicate data (match and merge), flagging, and resolving data quality issues, standardizing, and enriching data, and the ability for data stewards to proactively manage and improve the data. This pattern presents a modern approach to MDM, with all technologies deployable natively in Azure, including Profisee, which can be deployed via containers and orchestrated with Azure Kubernetes Service.

## Architecture

:::image type="content" source="images/profisee-data-flow.png" border="false" alt-text="Image that shows the MDM Profisee data flow.":::

#### Data flow

1. **Source data load:** Source data from business applications is copied to Azure Data Lake, where it is initially stored for further transformation and use in downstream analytics. Source data can generally be classified into one of three categories:
   - Structured master data – The information that describes customers, products, locations, and so on. Master data is low volume, high complexity, and changes slowly over time, is often the data that organizations struggle the most with data quality.
   - Structured transactional data – Business events that occur at a specific point in time, such as an order, invoice, or interaction. Transactions include the metrics for that transaction (for example, sales price) and references to master data (for example, the product and customer involved in a purchase). Transactional data is typically high volume, low complexity, and static (does not change over time).
   - Unstructured data – Can include documents, images, videos, social media content, audio, and so on. Modern analytics platforms can increasingly use unstructured data to glean new insights previously unavailable. Unstructured data is often associated to master data, such as the customer associated to a social media account, or the product associated to an image.

2. **Source master data load:** Master data from source business applications is loaded into the MDM application. Source data should be loaded "as is", with complete lineage information and minimal transformations.

3. **Automated MDM processing:** The MDM solution uses automated processes to standardize, verify, and enrich data (or example, verify and standardize address data), identify data quality issues, group duplicate records (or example, duplicate customers), and generate master records (also known as golden records).

4. **Data stewardship:** As necessary, data stewards can review and manage groups of matched records, create/manage data relationships, fill in missing information, and resolve data quality issues. Multiple alternate hierarchical roll-ups can be managed as required (for example, product hierarchies).

5. **Managed master data load:** High-quality master data flows into downstream analytics solutions. This process is again simplified because data integrations no longer require any data quality transformations.

6. **Transactional and unstructured data load:** Transactional and unstructured data is loaded into the downstream analytics solution, where it is combined with high-quality master data.

7. **Visualization and analysis:** Data is modeled and made available to business users for analysis. High-quality master data eliminates common data quality issues, and improved insights are gained.

### Components

- Azure [Data Factory](https://azure.microsoft.com/services/data-factory/) is a hybrid data integration service that allows you to create, schedule, and orchestrate your ETL/ELT workflows.

- [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake/) provides limitless storage for analytics data.

- [Profisee](https://profisee.com/platform/) is a scalable MDM platform that is designed to easily integrate with the Microsoft ecosystem.

- Azure [Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/) is the fast, flexible, and trusted cloud data warehouse that lets you scale, compute, and store elastically and independently, with a massively parallel processing architecture.

- [Power BI](https://powerbi.microsoft.com/) is a suite of business analytics tools that deliver insights throughout your organization. Connect to hundreds of data sources, simplify data prep, and drive improvised analysis. Produce beautiful reports, then publish them for your organization to consume on the web and across mobile devices.

### Alternatives

Absent a purpose-built MDMapplication, some of the technical capabilities needed to build a MDM solution may be found within the Azure ecosystem.

- Data quality - When loading to an analytics platform, data quality can be built into integration processes. For example, applying data quality transformations in an [Azure Data Factory](https://azure.microsoft.com/services/data-factory/) pipeline can be accomplished with hardcoded scripts.
- Data standardization and enrichment - [Azure Maps](https://azure.microsoft.com/services/azure-maps/) is available to provide data verification and standardization for address data. These can be used in Azure Functions and/or Azure Data Factory.  Standardization of other data may require development of hardcoded scripts.
- Duplicate data management - Azure Data Factory can be used to [deduplicate rows](/azure/data-factory/how-to-data-flow-dedupe-nulls-snippets) where sufficient identifiers are available for an exact match.  In this case, the logic to merge matched with appropriate survivorship would likely require custom hardcoded scripts.
- Data stewardship - [Power Apps](https://powerapps.microsoft.com/) can be used to quickly develop simple data stewardship solutions to manage data in Azure, along with appropriate user interfaces for review, workflow, alerts, and validations.

## MDM integration pipeline

:::image type="content" source="images/profisee-integration-pipeline.png" border="false" alt-text="Image that shows the MDM Profisee integration pipeline.":::

The preceding image shows the details for integrating with the Profisee MDM solution. Key to note is that Azure Data Factory and Profisee include native REST integration support, providing a lightweight and modern integration.

1. **Load source data to MDM:** Azure Data Factory is used to extract data from the data lake, transform it to match the master data model, and stream it into the MDM repository via a REST sink.

2. **MDM processing:** The MDM platform processes source master data through a sequence of activities to verify, standardize, and enrich the data, and to execute data-quality processes. Finally, matching and survivorship are performed to identify and group duplicate records and create master records. Optionally, data stewards can be issues tasks to perform data stewardship. The result is a set of master data for use in downstream analytics.

3. **Load master data for analytics:** Azure Data Factory uses its REST source to stream master data from Profisee to Azure Synapse Analytics.

### Azure Data Factory templates for Profisee

In collaboration with Microsoft, Profisee has developed a set of Azure Data Factory templates that make it faster and easier to integrate Profisee into the Azure Data Services ecosystem. These templates use Azure Data Factories REST data source and data sink to read and write data from Profisee's REST Gateway API. Templates are provided for both reading from and writing to Profisee.

:::image type="content" source="images/profisee-data-factory-template.png" alt-text="Screenshot that shows MDM Profisee and the Azure Data Factory template.":::

### Example Data Factory template: JSON to Profisee over REST

The following screenshots illustrate an Azure Data Factory template that copies data from a JSON file in an Azure Data Lake to Profisee via REST.

The source JSON data is copied:

:::image type="content" source="images/profisee-source-json-data.png" alt-text="Screenshot that shows the source JSON data.":::

Then, data is synced to Profisee via REST:

:::image type="content" source="images/profisee-rest-sync.png" alt-text="Screenshot that shows REST sync to Profisee.":::

For more information, see [Azure Data Factory templates for Profisee](https://github.com/profisee/azuredatafactory).

## MDM processing

In an analytical MDM use case, data is often processed through the MDM solution on an automated basis as part of the broader integration process to load data for analytics. Below illustrates a typical process for customer data in this context.

#### 1. Source data load

Source data is loaded into the MDM solution from source systems, including lineage information. In this case, we have two source records, one from CRM and one from the ERP application, which upon visual inspection, appear to both represent the same person.

| Source Name | Source Address | Source State | Source Phone | Source ID | Standard Address | Standard State | Standard Name | Standard Phone | Similarity |
| --------------- | ------------------------- | ----------------- | ----------------------- | -------------------- | --------------------- | ------------------- | ------------------ | ------------------- | -------------- |
| Alana  Bosh     | 123  Main Street          | GA                | 7708434125              | CRM-100              |                       |                     |                    |                     |                |
| Bosch,  Alana   | 123  Main St              | Georgia           | 404-854-7736            | CRM-121              |                       |                     |                    |                     |                |
| Alana  Bosch    |                           | (404)  854-7736   | ERP-988                 |                      |                       |                     |                    |                     |                |

#### 2. Data verification and standardization

Verification and standardization rules and services are used to standardize and verify address, name, and phone number information.

| Source Name | Source Address | Source State | Source Phone | Source ID | Standard Address | Standard State | Standard Name | Standard Phone | Similarity |
| --------------- | ------------------------- | ----------------- | ----------------------- | -------------------- | --------------------- | ------------------- | ------------------ | ------------------- | -------------- |
| Alana  Bosh     | 123  Main Street          | GA                | 7708434125              | CRM-100              | 123 Main St           | GA                  | Alana Bosh         | 770 843 4125        |                |
| Bosch,  Alana   | 123  Main St              | Georgia           | 404-854-7736            | CRM-121              | 123 Main St           | GA                  | Alana Bosch        | 404 854 7736        |                |
| Alana  Bosch    |                           | (404)  854-7736   | ERP-988                 |                      |                       | Alana Bosch         | 404 854 7736       |                     |                |

#### 3. Matching

With data standardized, matching is performed, identifying the similarity between records in the group. In this scenario, two records match each other exactly on Name and Phone, and the other fuzzy matches on Name and Address.

| Source Name | Source Address | Source State | Source Phone | Source ID | Standard Address | Standard State | Standard Name | Standard Phone | Similarity |
| --------------- | ------------------------- | ----------------- | ----------------------- | -------------------- | --------------------- | ------------------- | ------------------ | ------------------- | -------------- |
| Alana  Bosh     | 123  Main Street          | GA                | 7708434125              | CRM-100              | 123 Main St           | GA                  | Alana Bosh         | 770 843 4125        | .9             |
| Bosch,  Alana   | 123  Main St              | Georgia           | 404-854-7736            | CRM-121              | 123 Main St           | GA                  | Alana Bosch        | 404 854 7736        | 1.0            |
| Alana  Bosch    |                           | (404)  854-7736   | ERP-988                 |                      |                       | Alana Bosch         | 404 854 7736       | 1.0                 |                |

#### 4. Survivorship

With a group formed, survivorship creates and populates a master record (also called a "golden record") to represent the group.

| Source Name     | Source Address | Source State | Source Phone | Source ID | Standard Address | Standard State | Standard Name | Standard Phone | Similarity |
| ------------------- | ------------------------- | ----------------- | ----------------------- | -------------------- | --------------------- | ------------------- | ------------------ | ------------------- | -------------- |
| Alana  Bosh         | 123  Main Street          | GA                | 7708434125              | CRM-100              | 123 Main St           | GA                  | Alana Bosh         | 770 843 4125        | .9             |
| Bosch,  Alana       | 123  Main St              | Georgia           | 404-854-7736            | CRM-121              | 123 Main St           | GA                  | Alana Bosch        | 404 854 7736        | 1.0            |
| Alana  Bosch        |                           | (404)  854-7736   | ERP-988                 |                      |                       | Alana Bosch         | 404 854 7736       | 1.0                 |                |
| **Master  Record:** | **123 Main St**           | **GA**            | **Alana Bosch**         | **404 854 7736**     |                       |                     |                    |                     |                |

This master record, along with improved source data and lineage information can be loaded into the downstream analytics solution, where it can be tied back to transactional data.

This example shows basic automated MDM processing. Data quality rules can also be used to automatically calculate/update values, and flag missing or invalid values for data stewards to resolve. Data stewards can also manage the data, including managing hierarchical rollups of data.

### The impact of MDM on integration complexity

As illustrated above, MDM addresses several common challenges encountered when integrating data into an analytics solution. It includes correcting data quality issues, standardizing/enriching data, and rationalizing duplicate data. Incorporating MDM into your analytics architecture fundamentally changes the data flow by eliminating hardcoded logic the integration process, and offloading it to the MDM solution, significantly simplifying integrations. The table below outlines some common differences in the integration process with and without MDM.

| Capability                       | Without MDM                                             | With MDM                                                 |
| ------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Data quality                         | Data quality  rules and transformations are hardcoded into integration processes to fix and  correct data as it is moved. It requires technical resources for both the  initial implementation and ongoing maintenance of these rules, making data  integration processes complicated and expensive to develop and maintain. | Data quality  logic and rules are configured and enforced by the MDM solution. Integration  processes perform no data quality transformations, instead moving the data  "as-is" into the MDM solution. Data integration processes are simple and  affordable to develop and maintain. |
| Data  standardization and enrichment | Logic to  standardize and align reference and master data are hardcoded into  integration processes. Integrations must be developed with third-party  services to perform standardization of address, name, email, and phone data. | Using built  in rules and out of the box integrations with third-party data services, data  can be standardized within the MDM solution, simplifying integration  processes. |
| Duplicate  data management           | Duplicate  records that exist within and across applications are identified and grouped  based on existing unique identifiers. This requires identifiers to be shared  across systems (for example, SSN or email), and these can only be matched and  grouped when identical. More sophisticated approaches require significant  investments in integration engineering. | Built-in  machine learning matching capabilities identify duplicate records within and  across systems, generating a golden record to represent the group. This  enables records to be "fuzzy matched", grouping records that are similar,  with explainable results. Groups can be managed in scenarios where the ML  engine is unable to form a group with high confidence. |
| Data  stewardship                    | Data  stewardship activities are confined to updating data in the source  applications (for example, ERP or CRM). Typically, issues are discovered when  performing analytics such as missing, incomplete, or incorrect data. The  issues are corrected in the source application, and then are updated in the  analytics solution during the next update. Any new information to manage must  be added to source applications, which can take time and be costly. | MDM solutions  have built-in data stewardship capabilities, enabling users to access and  manage data. Ideally, the system is configured to flag issues and prompt data  stewards to correct them. New information or hierarchies can be quickly  configured in the solution so that they can be managed by data stewards. |

## MDM use cases

While there are numerous use cases for MDM, there are a small number of use cases that cover most real-world MDM implementations. Note that although these use cases are focused on a single domain, they are unlikely to be built from only that domain. In other words, even these focused use cases are most likely to include multiple master data domains.

### Customer 360

Consolidating customer data for analytics is the most common MDM use case. Organizations capture customer data across an increasing number of applications, creating duplicate customer data within and across applications with inconsistencies and discrepancies. This poor-quality data makes it difficult to realize the value of modern analytics solutions due to poor quality customer data. Symptoms include the following challenges:

* Hard to answer basic business questions like "Who are our top customers" and "How many new customers did we have", requiring significant manual effort.

* Missing and inaccurate customer information, making it difficult to roll up or drill down into data.

* Inability to analyzing customer data across systems or business units due to an inability to uniquely identify a customer across organizational and system boundaries.

* Poor-quality insights from AI and machine learning due to poor-quality input data.

### Product 360

Product data is often spread across multiple enterprise applications, such as ERP, PLM, or e-commerce. The result is a challenge understanding the total catalog of products that have inconsistent definitions for properties such as the product's name, description, and characteristics. This is complicated by different definitions of reference data. Symptoms include the following challenges:

* Inability to support different alternative hierarchical rollup and drill-down paths for product analytics.

* Whether finished goods or material inventory, difficulty understanding exactly what products you have on hand, the vendors your products are purchased from, and duplicate products, leading to excess inventory.

* Hard to rationalize products due to conflicting definitions, leading to missing or inaccurate information in analytics.

### Reference data 360

In the context of analytics, reference data exists as numerous lists of data that is often used to further describe other sets of master data. For example, lists of countries, currencies, colors, sizes, and units of measure. Inconsistent reference data leads to obvious errors in downstream analytics. Symptoms include:

* Multiple representations of the same thing. For example, the state Georgia as "GA" and "Georgia", making it difficult to aggregate and drill down into data consistently.

* Difficulty aggregating data from across applications due to an inability to crosswalk the reference data values between systems. For example, the color red is represented by "R" in the ERP system, and "Red" in PLM system.

* Difficult to tie numbers across organizations due to differences in agreed upon reference data values for categorizing data.

### Finance 360

Financial organizations rely heavily on data for critical activities such as monthly, quarterly, and annual reporting. Organizations with multiple finance and accounting systems often have financial data across multiple general ledgers, which need to be consolidated to produce financial reports. MDM can provide a centralized place to map and manage Accounts, Cost Centers, Business Entities, and other financial data sets to a consolidated view. Symptoms include the following challenges:

* Difficulty aggregating financial data across multiple systems into a consolidated view

* Lack of process for adding and mapping new data elements in the financial systems

* Delays in producing end of period financial reports

## Considerations

### Availability

Profisee runs natively on Azure Kubernetes Service and Azure SQL Database. Both services offer out of the box capabilities to support high availability.

### Scalability

Profisee runs natively on Azure Kubernetes Service and Azure SQL Database. Azure Kubernetes Service can be configured to scale Profisee up and out, depending on need. Azure SQL Database can be deployed in numerous configurations to balance performance, scalability, and costs.

### Security

Profisee authenticates users using OpenID Connect, which implements an OAuth 2.0 authentication flow. Most organizations configure Profisee to authenticate users against Azure Active Directory, ensuring enterprise policies for authentication can be applied and enforced.

## Deploy the scenario

To deploy this scenario:

1. Deploy Profisee into Azure using an [ARM template](https://github.com/Profisee/kubernetes/tree/master/Azure-ARM).
2. Create an [Azure Data Factory](/azure/data-factory/quickstart-create-data-factory-portal).
3. Configure your Azure Data Factory to [connect to a Git repository](/azure/data-factory/source-control).
4. Add [Profisee's Azure Data Factory templates](https://github.com/profisee/azuredatafactory).
5. Create a new Pipeline [using a template](/azure/data-factory/solution-templates-introduction).

## Pricing

Running costs consist of a software license and Azure consumption. For more information, contact Profisee at https://profisee.com/contact/.

## Next steps

Understand the capabilities of the [REST Copy Connector](/azure/data-factory/connector-rest) in Azure Data Factory.

Learn more about [Profisee running natively in Azure](https://profisee.com/profisee-microsoft/).

Learn how to deploy Profisee to Azure using an [ARM template](https://github.com/Profisee/kubernetes/tree/master/Azure-ARM).

View the [Profisee Azure Data Factory templates](https://github.com/profisee/azuredatafactory).

## Related resources

### Architecture guides

- [Extract, transform, and load (ETL)](../../data-guide/relational-data/etl.yml)
- [Integration runtime in Azure Data Factory](/azure/data-factory/concepts-integration-runtime)
- [Data warehousing](../../data-guide/relational-data/data-warehousing.yml)
- [Batch processing](../../data-guide/big-data/batch-processing.yml)
- [Choosing a data pipeline orchestration technology in Azure](../../data-guide/technology-choices/pipeline-orchestration-data-movement.md)

### Reference architectures

- [Hybrid ETL with Azure Data Factory](../../example-scenario/data/hybrid-etl-with-adf.yml)
- [DevTest Image Factory](../../solution-ideas/articles/dev-test-image-factory.yml)
- [Automated enterprise BI](./enterprise-bi-adf.yml)
- [Modernize mainframe & midrange data](../migration/modernize-mainframe-data-to-azure.yml)
- [DataOps for the modern data warehouse](../../example-scenario/data-warehouse/dataops-mdw.yml)
- [Data warehousing and analytics](../../example-scenario/data/data-warehouse.yml)

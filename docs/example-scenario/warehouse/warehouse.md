Commercial Software Engineering
​© 2020 Microsoft Corporation. All rights reserved. This document is provided "as-is." Information and views expressed in this document, including URL and other Internet Web site references, may change without notice. You bear the risk of using it.

Some examples are for illustration only and are fictitious. No real association is intended or inferred.

This document does not provide you with any legal rights to any intellectual property in any Microsoft product. You may copy and use this document for your internal, reference purposes.

# Data Warehouse Migration to Azure Modern Data Warehouse


# Contents

[Executive Summary 3](#_Toc25037143)

[Background 3](#_Toc25037144)

[Customer Scenario 3](#_Toc25037145)

[Requirements 4](#_Toc25037146)

[Technical Scenario 5](#_Toc25037147)

[Architecture 5](#_Toc25037148)

[Technologies Scoped 6](#_Toc25037149)

[Known Issues 7](#_Toc25037150)

[Application to other Scenarios 8](#_Toc25037151)

[Conclusion 8](#_Toc25037152)

[Lessons learned 8](#_Toc25037153)

[Highlights 8](#_Toc25037154)

[Recommendations 9](#_Toc25037155)

[Identified Patterns 9](#_Toc25037156)

[Resources 9](#_Toc25037157)

[Engagement Team 9](#_Toc25037158)

# Executive Summary

In this whitepaper, we describe the modernization process of an enterprise data warehouse from a secure, on-premises enterprise data warehouse to a cloud-based Modern Data Warehouse implementation that features an Enterprise Data Lake, an analytics engine (Azure Databricks), and visualization with tools such as PowerBI. This solution enables more agile processes around data warehouse development, can enable additional workloads (such as Machine Learning) on data feeding the warehouse, and can provide insights from BI and advanced analytics on data wherever it was originally stored.

In the Modern Data Warehouse, the Data Lake store provides one repository for capturing data of any type, size or speed without having to make changes to applications as the data lake can dynamically scale. The Data Lake is designed for high performance processing and tools and supports low latency workloads without being restricted by file sizes or fixed account limits. Powerful analytics tools can deliver intelligence from data regardless of how fast it's coming in.

## Background

Members of the Commercial Software Engineering (CSE) team worked with a customer on a proof of concept (PoC) replacement for a traditional on-premises enterprise data warehouse by migrating it to a Modern Data Warehouse/Enterprise Data Lake pattern.

The goals of the PoC were to move a variety of data through the entire process from the ingestion of raw files in storage through to consumption with PowerBI; to implement DevOps best practices at every step of the development and deployment process; to provide for the ability to do full integration testing on a known good data set; and to ensure that data loaded into the enterprise data lake could be made available for use by other – sometimes yet unknown – processes or applications.

## Customer Scenario

The customer's data warehouse was built on-premises using Oracle and SQL Server Analysis Services (Tabular). They have approximately 100 total business users consuming this data. They currently have over 5TB of data in the data warehouse, and their anticipated annual growth is expected to be about 1TB per year. Although they are using Oracle on the back end, they have contemplated using other database software.

This customer's implementation also included a custom-built Enterprise Service Bus (ESB) to perform data transformation, mapping to canonical samples, scheduling and running jobs and delivering data from one location to another destination.

The customer had no pressing need to move the data warehouse away from the current architecture but wanted guidance from CSE on a proof-of-concept (PoC). The PoC would use synthetic data that matched the structure of data on the production system, allowing the customer to explore features that might not necessarily meet all their core requirements while gathering appropriate feedback for the respective product groups on potential feature gaps.

## Requirements

The customer identified a list of core requirements for migrating their data warehouse to Azure.

- _Deploy new environments (test/UAT) in an automated manner._ This was accomplished through the "Infrastructure as Code" workstream with a few minor manual interventions.
- _Perform integration tests on changes using a full sample data set._ This was enabled.
- _Pause processing at a defined point, allow domain experts to adjust the data, then restart the processing either from the beginning or from the mid-point._ The customer implemented this during the workshop with blob storage triggers in Azure Data Factory (ADF).
- _Pipeline run triggers should be event-based where an ESB will send/receive messages to trigger workflows and actions based on the events triggered._ The event will be sent once all source data has been ingested. The customer was able to do this through blob storage triggers but will require message bus consumer triggering ADF through an API.
- _The system should support future agile development, including the enablement of data science workloads_. The customer's system, as designed and implemented, will enable this.
- _Support for both row-level and object-level security._ This ability was demonstrated in the pre-workshop prototype through SQL Database, but is also available in SQL Data Warehouse, Azure Analysis Services (AAS) and Power BI.
- _Support for encryption of data at rest and in-transit_. Bring-your-own-Key (BYOK) encryption at rest is supported in SQL Database, SQL Data Warehouse and Azure Data Lake Storage (ADLS) Gen2. AAS and Power BI support encryption at rest with Microsoft keys. Data in transit is not encrypted between Azure Databricks nodes.
- _Encryption at rest must exist, and the customer wants to use customer-managed keys_. ADLS Gen2, SQL Database and SQL Data Warehouse set up with BYOK encryption at rest; AAS and Power BI support encryption at rest, but with Microsoft-managed keys; VMs can have BYOK disk encryption, but this was not implemented during the workshop.
- _All services must be locked down to accessibility via a VNet._ Azure Databricks was deployed into the customer's VNet; SQL Database, SQL Data Warehouse, Key Vault and ADLS Gen2 were locked down via Service Endpoints; a self-hosted Integration Runtime (IR) runs on an IaaS VM in the VNet; AAS and Power BI were deprioritized from workshop. The control/management plane is still public.
- _Track data lineage through the entire processing pipeline._ The customer deprioritized this, but we are providing guidance in our public documentation.
- _The system should support 10 concurrent dashboard users and 20 concurrent power users._ Dashboarding consumption was de-prioritized during the workshop, but historical experience shows that the tools chosen will be able to support the identified load.

# Technical Scenario

## Architecture

![](CSE%20Technical%20Whitepaper%20-%20Migration%20to%20Azure%20Modern%20Data%20Warehouse_html_4af4c46c70978aae.gif)

ESB

 ![](CSE%20Technical%20Whitepaper%20-%20Migration%20to%20Azure%20Modern%20Data%20Warehouse_html_8b1edc1222c331db.png)

_Figure 1: Architecture diagram_

The architecture diagram illustrates the end-to-end flow from the ingestion of raw data to its consumption. The architectural elements are defined below.

1. **Source** : Raw data, in the form of structured, semi-structured and unstructured data can be brought into the data lake.
2. **Ingest** : Raw data files for the system are ingested into the enterprise data lake by the ESB – currently a home-grown data movement and transformation application, like Biztalk.

_Note: Since the ESB implementation was not Azure-enabled, files used in the PoC were manually loaded into the storage layer._

1. **Store** : Raw, semi-processed, and processed data for the system is stored in Azure Data Lake Storage Gen2 accounts.
2. **Process** : Data processing for the system is done with Azure Databricks (based on the Apache Spark Engine).
3. **Serve** : The serving layer for the system incorporates three different tools:
  1. Azure SQL Database – To perform intermediate staging and data inspection prior to finalization into the data warehouse.
  2. Azure SQL Data Warehouse – Stores the processed data for general consumption.
  3. Azure Analysis Services – Presents the data in a tabular model for consumption by reporting tools such as Excel and Power BI.
4. **Consume** : The consumption layer for the system incorporates six different tools:
  1. Azure Databricks & Machine Learning Library – Used by scientists to explore raw, semi-processed and processed data.
  2. SQL Server Management Studio – Provides ad-hoc querying and data exploration of staging and finalized warehouse data.
  3. Excel, Power BI and Power BI Desktop – These tools are for exploring tabular models and presenting end-user dashboards.
5. **Orchestrate** : Data pipeline orchestration for the system is accomplished through Azure Data Factory.

## Technologies Scoped

The following technologies were used in the implementation of this migration solution:

- Azure DevOps, for Continuous Integration/Continuous Deployment (CI/CD)
- Azure Data Factory, for data flow orchestration
- Azure Data Lake Storage Gen2, for storage
- Azure Databricks, for processing data & Machine Learning
- Azure SQL Data Warehouse, for serving data
- Azure Analysis Services, for serving data
- Power BI, for the visualization of data

## Known Issues

Some of the feedback from the customer about various aspects of the solution provided valuable lessons for the CSE team around issues that they encountered.

**New Issues Identified During Workshop:**

- When using locked-down resources, it is not possible to browse ADLS Gen2 to select the file path when creating an ADF data set.
- Putting a delete lock on the resource group prevents ADF from being deployed from the editor.
- Triggering pipeline runs from a folder other than the root of the container causes Databricks job not to start.
- Logical SQL Server does not allow a Service Principal to be set as the AAD Admin – it must be added to a group and the group set as the administrator.
- Databricks requires either a region-dependent IP address or all Azure Services allowed for secured Key Vault secret scope.
- AAS will require the use of a VM-based Data Management Gateway to use locked-down data sources.
- Unable to automate the install/configuration of the Data Management Gateway for AAS.
- When deploying ADF artifacts via an ARM template, the FQDN of SQL DB connections are not populated properly
- Deploying SQL Data Warehouse from a Data-tier Application package (DacPac) to a new database creates a SQL Database instead of a SQL Data Warehouse.
- Databricks does not support encryption in transit for inter-node communications.
- Azure Data Factory requires PAT to connect to Databricks rather than MSI.
- Azure Data Factory triggers only support blob storage add/delete events.
- AAS does not support service endpoints – just firewall rules.

**Existing Issues Seen During Workshop:**

- KeyVault-backed secret scopes in Azure Databricks need to be created manually in the UI.
- Manual PAT generation for Azure Databricks blocks automated deployments.
- AAS does not support encryption at rest with customer-managed keys.
- Azure Databricks does not support Service Endpoints or firewalls for job submission API.

## Application to other Scenarios

This solution is applicable to those who want to migrate an existing enterprise data warehouse to a Modern Data Warehouse. Potential use cases could include any scenario that involves unification of disparate data sets that are stored in distributed storage.

# Conclusion

This section covers lessons learned, recommendations, highlights and potential usage patterns, and additional resources for more information.

## Lessons learned

During the implementation of this solution, there were some challenges around security and identity. Since the customer had an environment that was locked down, it was difficult to create Azure Active Directory (AAD) groups, which could likewise make it difficult for some automation tasks to function. Additionally, locking down with a VNet with Service Endpoints was limiting, because access to resources must originate from within the VNet. Routing from other VNets or from on-premises could not be done.

Another challenge the team encountered was around automation and identity, due to inconsistent implementations. Since there are different ways to set up firewall rules between services, this can cause confusion when it comes to which commands to run for automation. Additionally, operations implemented from the user interface can potentially prevent some automation tasks from running. And finally, not all services support Service Principals or Managed Service Identities (MSIs) for authentication/authorization. All of these issues can lead to implementation delays and negatively impact productivity.

## Highlights

In the implementation of this solution, the customer realized some additional benefits. Leveraging Infrastructure-as-code and DevOps has increased automation, making results happen faster, reducing errors, and enabling higher productivity. They leveraged the expertise of other experts to make better estimates and identify both solution gaps and knowledge gaps on their teams. And finally, they now have multiple solution options available for singular problems they want to address.

As a result of this engagement, we created Automated Infrastructure-as-Code scripts that can build an end-to-end Azure Modern Data Warehouse cluster with all the necessary components (e.g. Databricks, Key Vaults, ADAF, etc.) and configurations.

## Recommendations

Consider the following recommendations around planning, preparation, and technical work when implementing this solution.

**Planning and preparation**

In this scenario, CSE felt that with more time, additional preparation work could have been done prior to migration to get everything done that they had scoped and to provide more advance training to optimize time. CSE and the customer felt that they spent more time setting up the infrastructure, leaving less time to work on the application.

Before the migration, CSE planned a workshop with the customer. Prior to this workshop, the CSE team conducted some pre-work, building the prototype environment, extracting PowerShell scripts that would automatically re-create the environment, and creating a repository with build and release pipelines. During this time, the customer created a set of sample data and flow definitions that would be implemented. While this prep work helped save some time, separating into two workshops – one for infrastructure and DevOps, and another one for the application, could have been more effective.

**Technical**

Network jump host connectivity was easier for members from the Microsoft team to operate rather than for members of the customer due to the customer's security and identity constraints; in future engagements, we would recommend validating any additional security VMs network ports that need to be open and address those before the workshop. And adding service principals to AAD groups could have improved security.

## Identified Patterns

This is an implementation of the Modern Data Warehouse architecture.

# Resources

- [One-pager](https://aka.ms/02_ModernDataWarehouse_1Pager): Migration to Azure Modern Data Warehouse
- [Reference Architecture](https://aka.ms/02_ModernDataWarehouse_ReferenceArchitecture): Migration to Azure Modern Data Warehouse
- FOLSOM: Infrastructure-as-Code[package](https://dev.azure.com/csedtd/Folsom)
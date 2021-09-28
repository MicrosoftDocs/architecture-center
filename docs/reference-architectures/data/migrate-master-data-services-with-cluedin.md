Master Data has been given the task to solve data quality, data governance, and mastering of the most important business data within a company. If you are currently using an on-premises or cloud-hosted SQL master data services (MDS) instance or instances, then the following scenario simplifies the experience of moving to a native Azure master data management solution by CluedIn. 

The architecture encapsulates many pillars of master data management (MDM) into a coherent, consistent, end-to-end MDM solution. CluedIn has introduced a _zero-modelling_ MDM approach that has been proven to accelerate MDM projects and increase success rates of the MDM initiatives.

CluedIn provides a side-by-side feature parity to SQL MDS that provides user-familiarity for data stewards and MDM teams to easily migrate their daily workloads from MDS to CluedIn. In addition to this, CluedIn provides many more valuable data master functionality to provide a foundation of ready-for-insight data to your business.

## Architecture

The following diagram demonstrates the CluedIn architectural structure and data flow.

[Replace with diagram image]

CluedIn uses the Azure virtual private network (VPN) to allow you to connect to migrate on-premises MDS instances, or to connect directly to a cloud hosted SQL VM with a hosted MDS instance. All CluedIn needs is to point to the Windows Communication Foundation (WCF) service of MDS, and it will automate the process of moving the data, rules, workflows, and everything else into CluedIn or the respective Microsoft service.

With native integration to Azure Cost Management + Billing, you can easily forecast your CluedIn MDM workloads, as you move from MDS to CluedIn. CluedIn utilizes the Azure Autoscale feature, to be able to scale the environment up and down. CluedIn also integrates natively into budgets in Azure, so that you can easily control your spending in the cloud. This eliminates the need for time-consuming forecasting and budgeting, because the costs will become obvious within the Azure platform.

SSIS packages can be migrated to Azure Data Factory, to move all your ETL pipelines into a cloud-native solution. 

### Components

CluedIn provides native integration to 27 Azure services, including the following:

•	[Azure Data Lake Gen2](/azure/storage/blobs/data-lake-storage-introduction)
•	[Azure Purview](https://azure.microsoft.com/services/purview)
•	[Azure Active Directory](https://azure.microsoft.com/services/active-directory)
•	[Azure Key Vault](https://azure.microsoft.com/services/key-vault)
•	[Azure Event Hubs](https://azure.microsoft.com/services/event-hubs)
•	[Azure Service Bus](https://azure.microsoft.com/services/service-bus)
•	[Azure Monitor](https://azure.microsoft.com/services/monitor)
•	[Azure SQL Managed Instances](https://azure.microsoft.com/products/azure-sql/managed-instance)
•	[Azure Databricks](https://azure.microsoft.com/services/databricks)
•	[Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics)
•	[Microsoft Dataverse](https://powerplatform.microsoft.com/dataverse)
•	[Azure Functions]()
•	[Power Automate]()
•	[Power Apps]()
•	[Power BI]()
•	[Virtual Chat Bots]()
•	[Azure DevOps]()
•	[Azure Container Registry]()
•	[Azure Data Factory]()
•	[Azure Redis]()
• [Azure Auto-Scaler]()

### Alternatives

You can also extend the platform to alternative scenarios to the core features of CluedIn.

In this version of CluedIn, extending the platform is all done with native Azure Services. All events are exposed on the Event Hub, for your developers to interact with them in any way that they want. Azure Data Factory can be used to push data to CluedIn, which offers support to bring in data across all of the different Azure Services into CluedIn. Azure Functions can be used to subscribe to the Event Hubs, in which you can create your customizations in any of the supported languages in Azure Functions.



## CluedIn features

Master data services traditionally contain the following main functionality:
- Support for model versioning
- Business rules
- Data quality services
- Workflow
- Hierarchies
- Excel plugin

CluedIn provides functionality for all of the above. In addition, the following use-cases are also enabled: 
  - Hierarchies can now be visualized natively in Power BI. 
  - Workflows are migrated and can be built and extended directly in Power Automate.
  - Business rules and data quality services are natively migrated into the CluedIn Rules engine. 
  - CluedIn provides built-in data enrichment for your MDS records, to automatically fix and validated addresses, company information, and more.
  - Manage consent and run data subject access requests.
  - Write back to the MDS instance, if necessary.

CluedIn also supports migrating data change history, and it can automatically build up data quality history from your MDS instances.
You can also run an MDS solution and CluedIn in-sync, if you don't want to turn your MDS instances off as soon as the migration process has finished. 

CluedIn natively supports the Common Data Model / Dataverse. In other words,  Power Apps, Power Automate, Power BI, virtual chatbots, and Microsoft Dynamics users can all natively utilize data from CluedIn, without the need for any extra setup or integration.

### CluedIn natively integrates with Azure Purview 

Azure Purview brings data governance capabilities to the Microsoft Azure cloud, and CluedIn provides native integration to its functionality.

For Azure customers who need fine-grained details on the processing of data across their data estate, CluedIn writes its transformation log directly into the Purview Data Map and lineage. If you need to show a full end-to-end lineage of how data moves and transforms through your Azure stack, CluedIn can be utilized to write this information to Purview. 

 - The Azure Purview Glossary is available directly in CluedIn and vice-versa. 
 - CluedIn can ingest assets that have been registered in Purview.
 - CluedIn scans the personally identifiable information (PII) from Purview, and it can pinpoint to a record level where the PII is. It also adds supports for PII in unstructured and semi-structed data, not just structured. 
 - CluedIn will use the schema set in Purview to auto-map data sets into CluedIn. 
 - CluedIn extends the Purview Lineage with detailed processing logs. 
-	CluedIn can initiate Purview Scans before a new data ingestion is scheduled. 

The following image demonstrates the Lineage feature set.

[Replace with customer orders image]

### Azure Data Factory support

Azure Data Factory (ADF) brings support for connecting to over 100+ services. This data can be directly delivered into CluedIn using live streams of push data from ADF. CluedIn not only allows you to connect to your Master Data Service (MDS) instances, but it also connects to hundreds of data sources from across SAAS, databases, data lakes, and more. 

The following are key ADF support features:
  - You can set it up to listen to events from Event Hub, and then you can feed the data right back into CluedIn.
  - Native support is available directly within CluedIn to set up ADF-specific endpoints. 
  - You can easily utilize existing ADF pipelines with a new target sink. 

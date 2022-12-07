---
# required metadata
title: Data management in the retail industry
author: dstarr
ms.author: dastarr
ms.date: 04/26/2022
ms.topic: conceptual
ms.service: industry
products:
  - azure-data-lake
  - azure-data-factory
categories:
  - databases
  - storage
description: Retailors have large data stores of unused data from which they may gain valuable insights. This article discusses how Microsoft Azure can help effectively use that data.
---
# Data management in the retail industry

## Introduction

Data is the foundation for developing and delivering better retail experiences. Data is found in every facet of a retail organization and can be used to extract insights across the value chain into operational performance and customer behavior, as well as leveraged to power improved service experiences. From online browsing to social engagement to in-store purchasing, data abounds. However, capturing data is only a portion of data management. Stitching together disparate data  for analysis requires proper handling of data across an organization—thus improving a retailer’s ability to make impactful decisions about running their business.

For example, with the growth of mobile shopping, customers have come to expect that retailers have a reasonable amount of data about their shopping habits to be used to improve the experience. A use case example is a personalized product and promotion offering sent directly to a customer’s mobile device when shopping in a specific location within a physical retail store. Leveraging data on what, where, how, how many and how often, plus additional inputs such as store product availability, creates opportunities to send real-time promotion messages to a customer’s device when the customer is shopping in proximity of a targeted product. 

Effective data usage can activate the customer to buy by helping the retailer delivering a more relevant experience; for example, retailers might send the customer a notification with a discount code for the retailer’s eCommerce website.  Further, this data will drive actionable insights from which company leaders may steer their actions with data-backed decisions

The action to offer a promotion is informed by a combination of data points and triggered by the customer entering the store. The ability to make these connections and the resulting actions are based on the data management model shown below.

![Process Flow](./images/retail-data-management-overview/process-flow.png)

Figure 1

When bringing data into Azure, consider the 3Ps of data sources and their applicability to the scenarios the retailer wants to enable. The 3Ps of data sources are Purchased, Public, and Proprietary.

> **Purchased** data typically augments and enhances the organization’s existing data most often with market and demographic data that supplements the organization’s data capture reach. For example, a retailer may purchase additional demographic data to augment a master customer record, ensuring the record is accurate and complete. 
>
> **Public** data is freely available and may be harvested from social media, government resources (e.g. geography), and other online sources. This data can infer insights such as weather patterns that correlate with purchasing patterns or social engagement that signals product popularity amongst a specific geography. Public data is often available via APIs.
>
> **Proprietary** data resides within the organization. It may be a retailer’s on-premises systems, SaaS applications, or cloud providers. To access the data in a SaaS application provider, and other vendor data, APIs are typically used to communicate the vendor’s system. This includes data such as eCommerce site logs, POS sales data, and inventory management systems.

These different data types are used for various insights coming from the data management pipeline.

## Ingest

Initially, data is loaded into Azure in its native format, and is stored accordingly. Receiving and managing disparate data sources can be daunting, but Microsoft Azure offers services to load data into the cloud quickly and easily, making it available for processing in the data management pipeline. 

Azure has several helpful services for migrating data. The choice depends on the type of data being migrated. [Azure Database Migration](/azure/dms/dms-overview?WT.mc_id=retaildm-docs-dastarr) Services for SQL Server and the [Azure Import/Export Service](/azure/storage/common/storage-import-export-service?WT.mc_id=retaildm-docs-dastarr) are services to help get data into Azure. Other data ingress services to consider include [Azure Data Factory](/azure/data-factory?WT.mc_id=retaildm-docs-dastarr) and [Azure Logic Apps](/azure/logic-apps/?WT.mc_id=retaildm-docs-dastarr) connectors. Each has its own features and should be investigated to see which technology works best for the given situation.

Data ingestion isn’t limited to Microsoft technologies. Through the [Azure Marketplace](https://azuremarketplace.microsoft.com?WT.mc_id=retaildm-docs-dastarr), retailers may configure many different vendor databases in Azure to work with existing on-premises systems. 

Not all data must be maintained in Azure. For example, Point of Sale (POS) data may be held on-premises so Internet outages do not impact sales transactions. This data can be queued and uploaded to Azure on a schedule (perhaps nightly or weekly) for use in analysis, but always treating the on-premises data as the source of truth.

## Prepare

Before analysis begins, the data must be prepared. This shaping of data is important to ensure quality of predictive models, reporting KPIs and relevancy of data.

There are two types of data to address when preparing data for analysis, structured and unstructured. Structured data is easier to deal with since it is already formed and formatted. It may require just a simple transformation to go from structured data in source format to structured data which is ready for analysis jobs. Unstructured data typically provides more challenges. Unstructured data isn’t stored in a fixed record length format. Examples include documents, social media feeds, and digital images and videos. These data must be managed differently than structured data and often require a dedicated process to ensure these data end up in the right data store, in a useable way.

Data shaping occurs during the Extract-Transform-Load (ETL) process, in the preparation stage. Data is extracted from the unchanged data sources imported into Azure, “cleaned” or reformatted as needed, and stored in a new, more structured format. A common ETL data preparation operation is to transform .csv or Excel files into parquet files, which are easier for machine learning systems like Apache Spark to read and process quickly. Another common scenario is to create XML files or JSON from .csv files, or other formats. The resulting format is easier to use with other analysis engines.

In Azure, there are several transformation technologies available as a ETL services to reshape data. Options include [Azure Databricks](/azure/azure-databricks?WT.mc_id=retaildm-docs-dastarr), [Azure Functions](/azure/azure-functions/?WT.mc_id=retaildm-docs-dastarr) or Logic Apps. Databricks is a fully managed instance of Apache Spark, and is used to transform data from one form to another. Azure Functions are stateless (or “serverless”) functions with triggers to fire them and run code. Logic Apps integrates services.

## Store

Storing data before processing requires consideration. Data can come in structured or unstructured formats and the shape of the data often determines its storage destination. For example, highly structured data may be suitable for Azure SQL. Less structured data may be held in blob storage, file storage, or table storage.

Data stored in Azure has great performance backed up by a solid service-level agreement (SLA). Data services provide easier to manage solutions, high availability, replication across multiple geographic locations and—above all—Azure offers the data stores and services needed to drive Machine Learning.

Both structured and unstructured data can be stored in [Azure Data Lake](/azure/data-lake-store/data-lake-store-overview?WT.mc_id=retaildm-docs-dastarr) and queried using [U-SQL](/azure/data-lake-analytics/data-lake-analytics-u-sql-get-started?WT.mc_id=retaildm-docs-dastarr), a query language specific to Azure Data Lake. Examples of data that may be included in a Data Lake include the following, which are divided into commonly structured and unstructured data sources.

### Structured data

- CRM data and other line of business applications
- POS transaction data
- Sensor data
- Relational data
- eCommerce transaction data

### Unstructured data

- Social feeds
- Video
- Digital images
- Website clickstream analysis

There are a growing number of use cases supporting unstructured data to generate value. This is propelled by the desire for data-driven decisions and the advancement in technology such as AI to enable capture and processing of data at scale. For example, data can include photos or streaming video. For example, streaming video can be leveraged to detect customer shopping selections for a seamless checkout; or product catalog data can be merged seamlessly with a customer’s photo of their favorite dress to provide a view of similar, or recommended items. 

Examples of structured data include relational database data feeds, sensor data, Apache Parquet files, and ecommerce data. The inherent structure of these data makes them well-suited for a Machine Learning pipeline.

Azure Data Lake service also enables batch and interactive queries along with real time analytics using [Data Lake Analytics](/azure/data-lake-analytics/data-lake-analytics-overview?WT.mc_id=retaildm-docs-dastarr). Also, Data Lake is specifically well-suited for very large data analysis workloads. Finally, data in the Data Lake is persistent and has no time limit.

Other data stores such as relational databases, Blob storage, Azure Files storage, and Azure Cosmos DB document storage may also hold clean data ready for downstream analysis in the data management pipeline. There is no requirement that one uses a Data Lake.

## Analyze

For problems like reducing cost of inventory, retailors can use analysis performed by a Machine Learning process.

Data analysis prepares data for processing through a Machine Learning engine to gain deeper insights into the customer experience. This process produces a model that “learns” and may be applied to future data to predict outcomes. Models define the data that will be examined and how the data will be analyzed through various algorithms. Using the output data from the analysis with data visualization is what could trigger an insight—such as offering an in-store coupon for an item from the customer’s wish list in the retailors eCommerce platform.

Data analysis occurs by feeding learning ecosystems with data stored for processing. Typically, this is machine learning performed by Hadoop, Databricks, or a self-managed Spark instance running on a virtual machine. This can also be done simply by querying for data. Insight into KPIs can often be found in clean data without going through a machine learning pipeline.

[Hadoop](/azure/hdinsight/hdinsight-hadoop-architecture?WT.mc_id=retaildm-docs-dastarr) is part of the fully managed Azure service, [HDInsight](/azure/hdinsight/?WT.mc_id=retaildm-docs-dastarr). HDInsight is a collection of data learning tools used for training data models, outputting data to a data warehouse, and performing queries on Hadoop through the Hive query language. HDInsight can analyze streaming or historical data.

A variety of learning algorithms may be applied to the data as part of training and to maintain data models. A data model explicitly determines the structure of data produced for analysts.

First, the data is cleaned and formed appropriately. It is then processed by a machine learning system such as HDInsight or Apache Spark. To do this, existing data is used to train a model, which in turn is used in analysis of data. The trained model is updated periodically with new known good data to increase its accuracy during analysis. Machine learning services use the model to perform an analysis of the data being processed.

After model training and running a data analysis process, data derived from machine learning analysis can be stored in a data warehouse, or normalized storage databases for analytics data. Microsoft provides [Power BI](/power-bi/?WT.mc_id=retaildm-docs-dastarr), a fully featured data analytics tool, for deep analysis of data in the data warehouse.

## Action

Data in retail moves constantly, and systems that handle it must do so in a timely manner. For example, eCommerce shopper data needs to be processed quickly. This is so items in a buyer’s cart can be used to offer additional services, or add-on items during the checkout process. This form of data handling and analysis must occur almost immediately and is typically carried out by systems performing “micro-batch” transactions. That is, data is analyzed in a system which has access to already processed data and is run through a model.

Other “batch” operations may occur at regular intervals but need not occur in near real time. When batch analysis occurs on-premises, these jobs often run at night, on weekends, or when resources are not in use. With Azure, scaling large batch jobs and the virtual machines needed to support them may occur at any time.

Use the following steps to get started.

1. Create a data ingestion plan for data stores providing value to the analysis to be performed. With a detailed data synchronization or migration plan in place, get the data into Azure in its original format. 

2. Determine the actionable insights needed and choose a data processing pipeline to accommodate the data processing activities. 

3. With these data features in mind, create a data processing pipeline using the appropriate algorithms to gain the insights being sought.

4. Use a common data model for output into a data warehouse, if possible; this can expose the most interesting data features. This usually means reading data in the original Azure storage systems and writing the cleaned version to another data store.

5. Process the data through the machine learning pipelines provided by Spark or Hadoop. Then feed the output to a data warehouse. There are many default algorithms to process the data, or retailers can implement their own. In addition to ML scenarios, load data into standard data storage and enforce a common data model, then query for KPI data. For example, data may be stored in a star schema or other data store.

With data now ready to be used by data analysts, actionable insights may be discovered, and action taken to exploit this new knowledge. For example, a customer’s purchase preferences may be loaded back into the retailer’s systems and used to improve several customer touchpoints such as the following.

- Increase the average eCommerce or POS transaction by bundling products
- Purchase history in CRM to support customer call center inquiries
- Product suggestions tailored by an e-commerce recommendation engine
- Targeted and relevant ads based on customer data
- Updated inventory availability based on product movement within the supply chain

Another type of insight that may arise are patterns not previously questioned. For example, it may be discovered that more inventory loss happens between the hours of 3:00 PM and 7:00 PM. This might imply the need for additional data to determine a root cause and a course of action—such as improved security or standard operating procedures.

## Conclusion

Data management in retail is complex. But it offers the valuable ability to deliver relevance and an improved customer experience. Using the techniques in this article, insights may be gained to improve the customer experience, drive profitable business outcomes and uncover trends that may drive operational improvements.

## Components

- [Azure Database Migration Service](https://azure.microsoft.com/services/database-migration)
- [Azure Import/Export Service](https://azure.microsoft.com/services/storage/import-export/)
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory)
- [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps)
- [Azure Databricks](https://azure.microsoft.com/free/databricks)
- [Azure Functions](https://azure.microsoft.com/services/functions)
- [Azure Data Lake Analytics](https://azure.microsoft.com/services/data-lake-analytics)
- [Azure HDInsight](https://azure.microsoft.com/free/hdinsight)
- [Power BI](https://powerbi.microsoft.com)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [David Starr](https://www.linkedin.com/in/davidstarr) | Principal Solutions Architect
- [Mariya Zorotovich](https://www.linkedin.com/in/mariyazoro) | Head of Customer Experience, HLS & Emerging Technology

## Next steps

To continue to understand more of Azure capabilities related to implementing a data management pipeline, read the following:

- See how [Azure Data Factory](/azure/data-factory/?WT.mc_id=retaildm-docs-dastarr) can help ingest data from on-premises data stores into Azure.
- Learn more about how [Azure Data Lake](/azure/data-lake-store/data-lake-store-overview?WT.mc_id=retaildm-docs-dastarr) can serve as a store all data, both structured and unstructured.
- See actual retail reports illustrating how [Power BI](https://powerbi.microsoft.com/en-us/industries/retail/?WT.mc_id=retaildm-docs-dastarr) can give deeper insights into known questions, but enable trend analysis.
- Visit the [Azure Marketplace](https://azuremarketplace.microsoft.com/?WT.mc_id=retaildm-docs-dastarr) to find solutions compatible with those already on-premises.

Product documentation

- [What is Azure Database Migration Service?](/azure/dms/dms-overview)
- [What is Azure Import/Export Service?](/azure/import-export/storage-import-export-service)
- [What is Azure Logic Apps?](/azure/logic-apps/logic-apps-overview)
- [What is Azure Databricks?](/azure/databricks/scenarios/what-is-azure-databricks)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)
- [What is Azure HDInsight?](/azure/hdinsight/hdinsight-overview)

## Related resources

- [Data management in banking](../finance/data-management-banking-overview.yml)
- [Data warehousing and analytics](../../example-scenario/data/data-warehouse.yml)
- [Modern data warehouse for small and medium business](../../example-scenario/data/small-medium-data-warehouse.yml)
- [Real-time asset tracking and management](../../solution-ideas/articles/real-time-asset-tracking-mgmt-iot-central.yml)

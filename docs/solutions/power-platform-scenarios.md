---
title: Azure and Power Platform scenarios
description: <Write a 100-160 character description that ends with a period and ideally starts with a call to action. This becomes the browse card description.>
author: <contributor's GitHub username. If no GitHub account, use EdPrice-MSFT>
ms.author: <contributor's Microsoft alias. If no alias, use edprice>
ms.date: <publish or major update date - mm/dd/yyyy>
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - <choose 1-5 products from the list at https://review.docs.microsoft.com/en-us/help/contribute/architecture-center/aac-browser-authoring?branch=master#products>
  - <1-5 products>
  - <1-5 products>
categories:
  - <choose at least one category from the list at https://review.docs.microsoft.com/en-us/help/contribute/architecture-center/aac-browser-authoring?branch=master#azure-categories>
  - <there can be more than one category>
ms.custom: fcp
---

# Azure and Power Platform scenarios
intro 

intro to video 
<br><br>


> [!VIDEO https://www.youtube.com/embed/2dscy89ks9I]

Apache®, Apache Ignite, Ignite, and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.

## Power Platform (general)

|Architecture|Summary|Technology focus|
|--|--|--|
|[Citizen AI with the Power Platform](/azure/architecture/example-scenario/ai/citizen-ai-power-platform)|Learn how to use Azure Machine Learning and Power Platform to quickly create a machine learning proof of concept and a production version.|AI|
|[Custom business processes](/azure/architecture/solution-ideas/articles/custom-business-processes)|Deploy portals that use Power Apps to automate manual or paper-based processes and provide rich user experiences. Power BI is used to generate reports.|Integration|
|[Virtual health on Microsoft Cloud for Healthcare](/azure/architecture/example-scenario/mch-health/virtual-health-mch)| Develop a virtual health solution by using Microsoft Cloud for Healthcare. This solution uses Power Apps to host a patient portal and store data, Power BI for reporting, and Power Automate to trigger notifications.|Web|

## Power Apps

|Architecture|Summary|Technology focus|
|--|--|--|
|[Custom business processes](/azure/architecture/solution-ideas/articles/custom-business-processes)|Deploy portals that automate manual or paper-based processes and provide rich user experiences. Power BI is used to generate reports.| Integration|
[CI/CD for Microsoft Power Platform](/azure/architecture/solution-ideas/articles/azure-devops-continuous-integration-for-power-platform)|Learn how to create an Azure CI/CD pipeline to manage your Power Platform application lifecycle.| DevOps|
[Eventual consistency between multiple Power Apps instances](/azure/architecture/reference-architectures/power-platform/eventual-consistency)|Handle dependent data in a resilient way in Power Apps.| Web|
[Line of business extension](/azure/architecture/solution-ideas/articles/lob)|Modernize legacy systems by automating processes. Schedule calculations, connect to third-party data sources or legacy systems, and process and share data. Power Apps retrieves the data, and Power BI provides reporting.| Integration|
[Web and mobile front ends](/azure/architecture/solution-ideas/articles/front-end) |Accelerate development by using a visual designer. Use Azure Functions for low-latency processing and Power Apps and Power Automate for out-of-box connectors.|Integration|

## Power Automate

|Architecture|Summary|Technology focus|
|--|--|--|
|[Extract text from objects using Power Automate and AI Builder](/azure/architecture/example-scenario/ai/extract-object-text)|Use AI Builder and Azure Form Recognizer in a Power Automate workflow to extract text from images. The text can be used for indexing and retrieval.| AI|
|[Power Automate deployment at scale](/azure/architecture/example-scenario/power-automate/power-automate)|Learn how to use a hub-and-spoke architectural model to deploy Power Automate parent and child flows.| Integration|
|[Web and mobile front ends](/azure/architecture/solution-ideas/articles/front-end)|Accelerate development with a visual designer. Use Azure Functions for low-latency processing and Power Apps and Power Automate for out-of-box connectors. |Integration|


## Power BI

|Architecture|Summary|Technology focus|
|--|--|--|
|[Advanced analytics](/azure/architecture/solution-ideas/articles/advanced-analytics-on-big-data)|Combine any data at any scale and then use custom machine learning to get near real-time data analytics on streaming services. Power BI provides querying and reporting.| Analytics
|[Azure Machine Learning architecture](/azure/architecture/solution-ideas/articles/azure-machine-learning-solution-architecture)|Learn how to build, deploy, and manage high-quality models with Azure Machine Learning, a service for the end-to-end machine learning lifecycle. Power BI provides data visualization.| AI|
|[Campaign optimization with Azure HDInsight Spark](/azure/architecture/solution-ideas/articles/campaign-optimization-with-azure-hdinsight-spark-clusters)|Use Microsoft Machine Learning Server to build and deploy a machine learning model to maximize the purchase rate of leads that are targeted by a marketing campaign. Power BI provides summaries of the effectiveness of the campaign recommendations.| Databases|
|[Campaign optimization with SQL Server](/azure/architecture/solution-ideas/articles/campaign-optimization-with-sql-server)|Use machine learning and SQL Server 2016 R Services to optimize when and how to contact potential customers. Power BI provides data visualization.| Databases|
|[Clinical insights with Microsoft Cloud for Healthcare](/azure/architecture/example-scenario/mch-health/medical-data-insights)|Gather insights from clinical and medical data by using Microsoft Cloud for Healthcare. Power BI reports provide insights on healthcare metrics.| Web|
|[Data analysis for regulated industries](/azure/architecture/example-scenario/data/data-analysis-regulated-industries)|Learn about an architecture that you can use for data analysis workloads in regulated industries. The architecture includes ETL/ELT and Power BI.| Analytics|
|[Data governance with Profisee and Azure Purview](/azure/architecture/reference-architectures/data/profisee-master-data-management-purview)|Integrate Profisee master data management with Azure Purview to build a foundation for data governance and management. Produce and deliver high-quality, trusted data. Power BI is used as an analytics tool. | Databases|
|[Data management across Azure Data Lake with Azure Purview](/azure/architecture/solution-ideas/articles/azure-purview-data-lake-estate-architecture)|Use Azure Purview to build a foundation for data governance and management that can produce and deliver high-quality, trusted data. Azure Purview connects natively with Power BI.| Analytics|
|[Defect prevention with predictive maintenance](/azure/architecture/solution-ideas/articles/defect-prevention-with-predictive-maintenance)|Predict failures before they happen with real-time assembly line data, Azure Machine Learning, and Azure Synapse Analytics. Power BI enables visualization of real-time assembly-line data from Stream Analytics, and the predicted failures and alerts from Azure SQL Data Warehouse.| AI|
|[Deliver highly scalable customer service and ERP applications](/azure/architecture/solution-ideas/articles/erp-customer-service)|Use Azure SQL and Azure Cosmos DB to deliver highly scalable customer service and enterprise resource planning (ERP) applications that work with structured and unstructured data.| Analytics|
|[Demand forecasting for shipping and distribution](/azure/architecture/solution-ideas/articles/demand-forecasting-for-shipping-and-distribution)|Use historical demand data and the Microsoft AI platform to train a demand forecasting model for shipping and distribution solutions.| Analytics|
|[Finance management apps using Azure Database for PostgreSQL](/azure/architecture/solution-ideas/articles/finance-management-apps-using-azure-database-for-postgresql)|Use Azure Database for PostgreSQL to store critical data with improved security and get high-value analytics and insights over aggregated data.| Databases|
|[Finance management apps using Azure Database for MySQL](/azure/architecture/solution-ideas/articles/finance-management-apps-using-azure-database-for-mysql)|Use Azure Database for MySQL to store critical data with improved security and get high-value analytics and insights over aggregated data.| Databases|
|[Forecast energy and power demand](/azure/architecture/solution-ideas/articles/forecast-energy-power-demand)|Forecast spikes in demand for energy products and services by using Azure Machine Learning.| AI|
|[HIPAA-compliant and HITRUST-compliant health data AI](/azure/architecture/solution-ideas/articles/security-compliance-blueprint-hipaa-hitrust-health-data-ai)|Store, manage, and analyze HIPAA-compliant and HITRUST-compliant health data and medical records with a high level of built-in security.| Serverless|
|[Intelligent apps using Azure Database for MySQL](/azure/architecture/solution-ideas/articles/intelligent-apps-using-azure-database-for-mysql)|Use Azure Database for MySQL to develop sophisticated machine learning and visualization apps that provide analytics and information that you can act on.| Databases|
|[Intelligent apps using Azure Database for PostgreSQL](/azure/architecture/solution-ideas/articles/intelligent-apps-using-azure-database-for-postgresql)|Use Azure Database for PostgreSQL to develop sophisticated machine learning and visualization apps that provide analytics and information that you can act on.| Databases|
|[Interactive querying with HDInsight](/azure/architecture/solution-ideas/articles/interactive-querying-with-hdinsight)|Use Apache Hive Live Long and Process (LLAP) to perform fast, interactive SQL queries at scale over structured or unstructured data.| Databases|
|[IoT-connected light, power, and internet for emerging markets](/azure/architecture/solution-ideas/articles/iot-power-management)|Learn how energy provider Veriown uses solar-powered IoT devices with Azure services to provide clean, low-cost power, light, and internet service to remote customers.| IoT|
|[IoT using Azure Cosmos DB](/azure/architecture/solution-ideas/articles/iot-using-cosmos-db)|Scale instantly and elastically to accommodate diverse and unpredictable IoT workloads without sacrificing ingestion or query performance.| IoT|
|[Line of business extension](/azure/architecture/solution-ideas/articles/lob)|Modernize legacy systems by automating processes. Schedule calculations, connect to third party data sources or legacy systems, and process and share data.| Integration|
|[Loan charge-off prediction with HDInsight Spark](/azure/architecture/solution-ideas/articles/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters)|By using Azure HDInsight, a lending institution can use machine learning to predict the likelihood of loans getting charged off.| Databases|
|[Loan charge-off prediction with SQL Server](/azure/architecture/solution-ideas/articles/loan-chargeoff-prediction-with-sql-server)|Build and deploy a machine learning model with SQL Server 2016 with R Services to predict whether a bank loan will soon need to be charged off.| Databases|
|[Loan credit risk and default modeling](/azure/architecture/solution-ideas/articles/loan-credit-risk-analyzer-and-default-modeling)|SQL Server 2016 with R Services can help lenders issue fewer unprofitable loans by predicting borrower credit risk and default probability.| Databases|
|[Loan credit risk with SQL Server](/azure/architecture/solution-ideas/articles/loan-credit-risk-with-sql-server)|Lending institutions can use the predictive analytics of SQL Server 2016 with R Services to reduce the number of loans to borrowers most likely to default.| Databases|
|[Manage data across your Azure SQL estate with Azure Purview](/azure/architecture/solution-ideas/articles/azure-purview-sql-estate-architecture)|Improve your organization's governance process by using Azure Purview in your Azure SQL estate.| Analytics|
|[Master data management with Azure and CluedIn](/azure/architecture/reference-architectures/data/cluedin)|Use CluedIn eventual connectivity data integration to blend data from many siloed data sources and prepare it for analytics and business operations.| Databases|
|[Master data management with Profisee and Azure Data Factory](/azure/architecture/reference-architectures/data/profisee-master-data-management-data-factory)|Integrate Profisee master data management with Azure Data Factory to deliver high-quality, trusted data for Azure Synapse, and all analytic applications.| Databases|
|[Medical data storage solutions](/azure/architecture/solution-ideas/articles/medical-data-storage)|Store healthcare data effectively and affordably with cloud-based solutions from Azure. Manage medical records with the highest level of built-in security.| Storage|
|[Modern analytics architecture with Azure Databricks](/azure/architecture/solution-ideas/articles/azure-databricks-modern-analytics-architecture)|Create a modern analytics architecture with Azure Databricks, Data Lake Storage, and other Azure services. Unify data, analytics, and AI workloads at any scale.| Analytics|
|[Modern data warehouse for small and medium business](/azure/architecture/example-scenario/data/small-medium-data-warehouse)|Use Azure Synapse Analytics, SQL Database, and Data Lake Storage to modernize SMB legacy and on-premises data. Easily integrate fused data with other services.| Analytics|
|[Optimize Marketing with Machine Learning](/azure/architecture/solution-ideas/articles/optimize-marketing-with-machine-learning)|Build a machine-learning model with Azure Machine Learning, Azure Synapse Analytics and Power BI that optimizes big data marketing campaigns.| AI|
|[Population Health Management for Healthcare](/azure/architecture/solution-ideas/articles/population-health-management-for-healthcare)|Use population health management to improve clinical and health outcomes and reduce costs. Track, monitor, and benchmark data with this tool.| AI|
|[Predict Length of Stay and Patient Flow](/azure/architecture/solution-ideas/articles/predict-length-of-stay-and-patient-flow-with-healthcare-analytics)|Predict capacity and patient flow for your hospital or healthcare facility so that you can enhance the quality of care and improve operational efficiency.| AI|
|[Predict the length of stay in hospitals](/azure/architecture/solution-ideas/articles/predicting-length-of-stay-in-hospitals)|Length of stay predictions for hospital admissions can enhance care quality and operational workload efficiency and reduce readmissions.| Analytics|
|[Predictive Insights with Vehicle Telematics](/azure/architecture/solution-ideas/articles/predictive-insights-with-vehicle-telematics)|Car dealerships, manufacturers, and insurance companies can use Microsoft Azure to gain predictive insights on vehicle health and driving habits.| AI|
|[Predictive marketing with machine learning](/azure/architecture/solution-ideas/articles/predictive-marketing-campaigns-with-machine-learning-and-spark)|Optimize big data marketing campaigns with a machine-learning model using Microsoft Machine Learning and Azure HDInsight Spark clusters.| AI|
|[Product recommendations for retail using Azure](/azure/architecture/solution-ideas/articles/product-recommendations)|Aggregate customer data into complete profiles. Use advanced Azure machine learning models to provide predictive insights on simulated customers.| AI|
|[Project 15 Open Platform](/azure/architecture/solution-ideas/articles/project-15-iot-sustainability)|Use Internet of Things technologies with the Project 15 Open Platform to accelerate innovation in species tracking, ecosystem monitoring, and other areas.| IoT|
|[Quality Assurance](/azure/architecture/solution-ideas/articles/quality-assurance)|Build a quality assurance system that collects data and improves productivity by identifying potential problems in a manufacturing pipeline before they occur.| AI|
|[Serverless computing solution for LOB apps](/azure/architecture/solution-ideas/articles/onboarding-customers-with-a-cloud-native-serverless-architecture)|Build and run customer onboarding applications without managing or maintaining infrastructure. Improve developer productivity with this serverless architecture.| Serverless|
|[Use a demand forecasting model for price optimization](/azure/architecture/solution-ideas/articles/demand-forecasting-price-optimization-marketing)|Predict future customer demand and optimize pricing to maximize profitability using big-data and advanced-analytics services from Microsoft Azure.| Analytics|

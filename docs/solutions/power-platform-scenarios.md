---
title: Azure and Power Platform scenarios
description: Learn about architectures and solutions that use Azure together with Microsoft Power Platform. 
author: martinekuan
ms.author: architectures
ms.date: 07/28/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - power-platform
  - power-apps
  - power-automate
  - power-bi
  - power-virtual-agents
categories:
  - ai-machine-learning
  - analytics
  - integration
  - web
  - devops
  - databases
  - iot
  - storage
ms.custom: fcp
---

# Azure and Power Platform scenarios

[Power Platform](https://powerplatform.microsoft.com) provides tools for analyzing data, building solutions, automating processes, and creating virtual agents. Power Platform includes these products:

- [Power BI](https://powerbi.microsoft.com). Enable your employees to generate data-driven insights.
- [Power Apps](https://powerapps.microsoft.com). Enable anyone to build custom apps.
- [Power Automate](https://powerautomate.microsoft.com). Give everyone the ability to automate organizational processes.
- [Power Virtual Agents](https://powervirtualagents.microsoft.com). Build chatbots to engage with your customers and employees—no coding required.

This article provides summaries of solutions and architectures that use Power Platform together with Azure services. 

Anyone can be a developer with Power Platform. Check out this short video to learn more:
<br><br>

> [!VIDEO https://www.youtube.com/embed/2dscy89ks9I]

*Apache®, Apache Ignite, Ignite, and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Solutions across Azure and Power Platform

The following articles provide detailed analysis of solutions that feature integration between Azure and Power Platform.

### Power Platform (general)

|Architecture|Summary|Technology focus|
|--|--|--|
|[Citizen AI with Power Platform](../example-scenario/ai/citizen-ai-power-platform.yml)|Learn how to use Azure Machine Learning and Power Platform to quickly create a machine learning proof of concept and a production version.|AI|
|[Custom business processes](../solution-ideas/articles/custom-business-processes.yml)|Deploy portals that use Power Apps to automate manual or paper-based processes and provide rich user experiences. Use Power BI to generate reports.|Integration|
|[Modern data warehouse for small and medium businesses](../example-scenario/data/small-medium-data-warehouse.yml)|Use Azure Synapse Analytics, Azure SQL Database, and Azure Data Lake Storage to modernize legacy and on-premises data. This solution integrates easily with Power Platform.| Analytics|
|[Virtual health on Microsoft Cloud for Healthcare](../example-scenario/mch-health/virtual-health-mch.yml)| Develop a virtual health solution by using Microsoft Cloud for Healthcare. This solution uses Power Apps to host a patient portal and store data, Power BI for reporting, and Power Automate to trigger notifications.|Web|

[Browse all our Power Platform solutions](/azure/architecture/browse/?products=power-platform).

### Power Apps

|Architecture|Summary|Technology focus|
|--|--|--|
|[Custom business processes](../solution-ideas/articles/custom-business-processes.yml)|Deploy portals that use Power Apps to automate manual or paper-based processes and provide rich user experiences. | Integration|
[CI/CD for Microsoft Power Platform](../solution-ideas/articles/azure-devops-continuous-integration-for-power-platform.yml)|Learn how to create an Azure CI/CD pipeline to manage your Power Platform application lifecycle.| DevOps|
[Eventual consistency between multiple Power Apps instances](/azure/architecture/guide/power-platform/eventual-consistency)|Handle dependent data in a resilient way in Power Apps.| Web|
[Line of business extension](../solution-ideas/articles/lob.yml)|Modernize legacy systems by automating processes. Schedule calculations, connect to third-party data sources or legacy systems, and process and share data. Power Apps retrieves the data, and Power BI provides reporting.| Integration|
[Web and mobile front ends](../solution-ideas/articles/front-end.yml) |Accelerate development by using a visual designer. Use Azure Functions for low-latency processing and Power Apps and Power Automate for out-of-the-box connectors.|Integration|

[Browse all our Power Apps solutions](/azure/architecture/browse/?expanded=power-platform&products=power-apps).

### Power Automate

|Architecture|Summary|Technology focus|
|--|--|--|
|[Extract text from objects using Power Automate and AI Builder](../example-scenario/ai/extract-object-text.yml)|Use AI Builder and Azure Form Recognizer in a Power Automate workflow to extract text from images. The text can be used for indexing and retrieval.| AI|
|[Power Automate deployment at scale](../example-scenario/power-automate/power-automate.yml)|Learn how to use a hub-and-spoke architectural model to deploy Power Automate parent and child flows.| Integration|
|[Web and mobile front ends](../solution-ideas/articles/front-end.yml)|Accelerate development by using a visual designer. Use Azure Functions for low-latency processing and Power Apps and Power Automate for out-of-the-box connectors. |Integration|

[Browse all our Power Automate solutions](/azure/architecture/browse/?expanded=power-platform&products=power-automate).

### Power BI

|Architecture|Summary|Technology focus|
|--|--|--|
|[Advanced analytics](../solution-ideas/articles/advanced-analytics-on-big-data.yml)|Combine any data at any scale and then use custom machine learning to get near real-time data analytics on streaming services. Power BI provides querying and reporting.| Analytics
|[Azure Machine Learning architecture](../solution-ideas/articles/azure-machine-learning-solution-architecture.yml)|Learn how to build, deploy, and manage high-quality models with Azure Machine Learning, a service for the end-to-end machine learning lifecycle. Power BI provides data visualization.| AI|
|[Campaign optimization with Azure HDInsight Spark](/azure/architecture/solution-ideas/articles/optimize-marketing-with-machine-learning)|Use Microsoft Machine Learning Server to build and deploy a machine learning model to maximize the purchase rate of leads that are targeted by a marketing campaign. Power BI provides summaries of the effectiveness of the campaign recommendations.| Databases|
|[Campaign optimization with SQL Server](../solution-ideas/articles/campaign-optimization-with-sql-server.yml)|Use machine learning and SQL Server 2016 R Services to optimize when and how to contact potential customers. Power BI provides data visualization.| Databases|
|[Clinical insights with Microsoft Cloud for Healthcare](../example-scenario/mch-health/medical-data-insights.yml)|Gather insights from clinical and medical data by using Microsoft Cloud for Healthcare. Power BI reports provide insights on healthcare metrics.| Web|
|[Data analysis for regulated industries](/azure/architecture/example-scenario/data/data-warehouse)|Learn about an architecture that you can use for data analysis workloads in regulated industries. The architecture includes ETL/ELT and Power BI.| Analytics|
|[Data governance with Profisee and Azure Purview](../reference-architectures/data/profisee-master-data-management-purview.yml)|Integrate Profisee master data management with Azure Purview to build a foundation for data governance and management. Produce and deliver high-quality, trusted data. Power BI is used as an analytics tool. | Databases|
|[Data management across Azure Data Lake with Azure Purview](../solution-ideas/articles/azure-purview-data-lake-estate-architecture.yml)|Use Azure Purview to build a foundation for data governance and management that can produce and deliver high-quality, trusted data. Azure Purview connects natively with Power BI.| Analytics|
|[Defect prevention with predictive maintenance](../solution-ideas/articles/defect-prevention-with-predictive-maintenance.yml)|Predict failures before they happen with real-time assembly line data, Azure Machine Learning, and Azure Synapse Analytics. Power BI enables visualization of real-time assembly-line data from Stream Analytics, and the predicted failures and alerts from Azure SQL Data Warehouse.| AI|
|[Deliver highly scalable customer service and ERP applications](../solution-ideas/articles/erp-customer-service.yml)|Use Azure SQL, Azure Cosmos DB, and Power BI to deliver highly scalable customer service and enterprise resource planning (ERP) applications that work with structured and unstructured data.| Analytics|
|[Demand forecasting for shipping and distribution](../solution-ideas/articles/demand-forecasting-for-shipping-and-distribution.yml)|Use historical demand data and the Microsoft AI platform to train a demand forecasting model for shipping and distribution solutions. A Power BI dashboard displays the forecasts.| Analytics|
|[Finance management apps using Azure Database for PostgreSQL](../solution-ideas/articles/finance-management-apps-using-azure-database-for-postgresql.yml)|Use Azure Database for PostgreSQL to store critical data with improved security and get high-value analytics and insights over aggregated data. Power BI supports native connectivity with PostgreSQL to ingest data for analytics.| Databases|
|[Finance management apps using Azure Database for MySQL](../solution-ideas/articles/finance-management-apps-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL to store critical data with improved security and get high-value analytics and insights over aggregated data. Power BI provides analytics.| Databases|
|[Forecast energy and power demand](../solution-ideas/articles/forecast-energy-power-demand.yml)|Forecast spikes in demand for energy products and services by using Azure Machine Learning and Power BI.| AI|
|[HIPAA-compliant and HITRUST-compliant health data AI](../solution-ideas/articles/security-compliance-blueprint-hipaa-hitrust-health-data-ai.yml)|Store, manage, and analyze HIPAA-compliant and HITRUST-compliant health data and medical records with a high level of built-in security. Power BI provides data visualization.| Serverless|
|[Intelligent apps using Azure Database for MySQL](../solution-ideas/articles/intelligent-apps-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL to develop sophisticated machine learning and visualization apps that provide analytics and information that you can act on. Power BI provides visualization and data analysis.| Databases|
|[Intelligent apps using Azure Database for PostgreSQL](../solution-ideas/articles/intelligent-apps-using-azure-database-for-postgresql.yml)|Use Azure Database for PostgreSQL to develop sophisticated machine learning and visualization apps that provide analytics and information that you can act on. Power BI provides visualization and data analysis.| Databases|
|[Interactive querying with HDInsight](../solution-ideas/articles/interactive-querying-with-hdinsight.yml)|Use Apache Hive Live Long and Process (LLAP) to perform fast, interactive SQL queries at scale over structured or unstructured data. Power BI provides visualization and data analysis.| Databases|
|[IoT-connected light, power, and internet for emerging markets](../solution-ideas/articles/iot-power-management.yml)|Learn how energy provider Veriown uses solar-powered IoT devices with Azure services to provide clean, low-cost power, light, and internet service to remote customers. Power BI provides reporting.| IoT|
|[IoT using Azure Cosmos DB](../solution-ideas/articles/iot-using-cosmos-db.yml)|Scale instantly and elastically to accommodate diverse and unpredictable IoT workloads without sacrificing ingestion or query performance. Use Power BI to analyze warehoused data. | IoT|
|[Line of business extension](../solution-ideas/articles/lob.yml)|Modernize legacy systems by automating processes. Schedule calculations, connect to third-party data sources or legacy systems, and process and share data by using Power BI.| Integration|
|[Loan charge-off prediction with HDInsight Spark](../solution-ideas/articles/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.yml)|Learn how lending institutions can use Azure HDInsight and machine learning to predict the likelihood of loans getting charged off. Power BI provides a visualization dashboard.| Databases|
|[Loan charge-off prediction with SQL Server](../solution-ideas/articles/loan-chargeoff-prediction-with-sql-server.yml)|Build and deploy a machine learning model that uses SQL Server 2016 R Services to predict whether a bank loan will soon need to be charged off. Power BI provides interactive reports. | Databases|
|[Loan credit risk and default modeling](../example-scenario/ai/loan-credit-risk-analyzer-default-modeling)|Learn how SQL Server 2016 R Services can help lenders issue fewer unprofitable loans by predicting borrower credit risk and default probability. Power BI provides a dashboard to help lenders make decisions based on the predictions.| Databases|
|[Loan credit risk with SQL Server](../solution-ideas/articles/loan-credit-risk-with-sql-server.yml)|Learn how lending institutions can use the predictive analytics of SQL Server 2016 R Services to reduce the number of loans to borrowers most likely to default. Power BI provides a dashboard to help lenders make decisions based on the predictions.| Databases|
|[Manage data across your Azure SQL estate with Azure Purview](../solution-ideas/articles/azure-purview-sql-estate-architecture.yml)|Improve your organization's governance process by using Azure Purview in your Azure SQL estate. Azure Purview connects natively to Power BI.| Analytics|
|[Master data management with Azure and CluedIn](../reference-architectures/data/cluedin.yml)|Use CluedIn eventual connectivity data integration to blend data from many siloed data sources and prepare it for analytics and business operations. Power BI helps you to generate insights from the data. | Databases|
|[Master data management with Profisee and Azure Data Factory](../reference-architectures/data/profisee-master-data-management-data-factory.yml)|Integrate Profisee master data management with Azure Data Factory to get high-quality data for Azure Synapse and other analytics applications. Power BI provides data analysis.| Databases|
|[Medical data storage solutions](../solution-ideas/articles/medical-data-storage.yml)|Store healthcare data effectively and affordably with cloud-based solutions from Azure. Manage medical records with the highest level of built-in security. Power BI provides data analysis.| Storage|
|[Modern analytics architecture with Azure Databricks](../solution-ideas/articles/azure-databricks-modern-analytics-architecture.yml)|Create a modern analytics architecture that uses Azure Databricks, Azure Data Lake Storage, Power BI, and other Azure services. Unify data, analytics, and AI workloads at any scale.| Analytics|
|[Optimize marketing with machine learning](../solution-ideas/articles/optimize-marketing-with-machine-learning.yml)|Build a machine learning model with Azure Machine Learning, Azure Synapse Analytics, and Power BI that optimizes big data marketing campaigns.| AI|
|[Population health management for healthcare](../solution-ideas/articles/population-health-management-for-healthcare.yml)|Use population health management to improve clinical and health outcomes and reduce costs. Track, monitor, and benchmark data by using this process. Power BI provides analytics.| AI|
|[Predict length of stay and patient flow](/azure/architecture/example-scenario/digital-health/predict-patient-length-of-stay)|Predict capacity and patient flow for your healthcare facility so that you can enhance the quality of care and improve operational efficiency.  Power BI provides a dashboard to help you make decisions based on the predictions.| AI|
|[Predict the length of stay in hospitals](/azure/architecture/example-scenario/digital-health/predict-patient-length-of-stay)|Predict length of stay for hospital admissions to enhance care quality and operational workload efficiency and reduce re-admissions. Power BI provides data visualization.| Analytics|
|[Predictive insights with vehicle telematics](../solution-ideas/articles/predictive-insights-with-vehicle-telematics.yml)|Learn how car dealerships, manufacturers, and insurance companies can use Azure to gain predictive insights on vehicle health and driving habits. Power BI provides data visualizations for reporting.| AI|
|[Predictive marketing with machine learning](../solution-ideas/articles/predictive-marketing-campaigns-with-machine-learning-and-spark.yml)|Optimize big data marketing campaigns by using Azure Machine Learning and HDInsight Spark clusters. Power BI provides a dashboard to help you make decisions based on the predictions.| AI|
|[Product recommendations for retail using Azure](../solution-ideas/articles/product-recommendations.yml)|Aggregate customer data into complete profiles. Use advanced Azure Machine Learning models to provide predictive insights on simulated customers. Use Power BI for data visualization.| AI|
|[Project 15 Open Platform](../solution-ideas/articles/project-15-iot-sustainability.yml)|Use Internet of Things technologies with the Project 15 Open Platform to accelerate innovation in species tracking, ecosystem monitoring, and other areas. Power BI provides visualization.| IoT|
|[Quality assurance](../solution-ideas/articles/quality-assurance.yml)|Build a quality assurance system that collects data and improves productivity by identifying potential problems in a manufacturing pipeline before they occur. Use Power BI to visualize real-time operational dashboards.| AI|
|[Serverless computing solution for LOB apps](../solution-ideas/articles/onboarding-customers-with-a-cloud-native-serverless-architecture.yml)|Build and run customer onboarding applications without managing or maintaining infrastructure. Improve developer productivity with this serverless architecture. Power BI is used to store customer information.| Serverless|
|[Use a demand forecasting model for price optimization](../solution-ideas/articles/demand-forecasting-price-optimization-marketing.yml)|Predict future customer demand and optimize pricing by using big-data and advanced-analytics services from Azure. Use Power BI to monitor the results.| Analytics|

[Browse all our Power BI solutions](/azure/architecture/browse/?expanded=power-platform&products=power-bi).

## Related resources

- [Browse all our Power Platform architectures](/azure/architecture/browse/?products=power-platform)
- [Azure and Microsoft 365 scenarios](/azure/architecture/solutions/microsoft-365-scenarios)
- [Azure and Dynamics 365 scenarios](/azure/architecture/solutions/dynamics-365-scenarios)

This scenario demonstrates a solution for creating predictive models of the Customer Lifetime Value (CLV). The solution can help retail companies understanding their customers better, and doing so by using Azure AI technologies. 


#### Customer Lifetime Value (CLV) & Churn Rate

In marketing, Customer Lifetime Value (CLV) is a determination of the net profit contributed to the whole future relationship with a customer. The prediction model can have varying levels of sophistication and accuracy, ranging from a crude heuristic to the use of complex predictive analytics techniques. [From Wikipedia](https://en.wikipedia.org/wiki/Customer_lifetime_value). This metric can help businesses concentrate their activities around their most “profitable” clients. The better a business understands CLV, thus further informing their retention strategies for their best customers. Other metrics that are important for understanding how customers behave is Churn or [Churn Rate](https://en.wikipedia.org/wiki/Churn_rate). Churn is a measure of the number of individuals or items moving out of a collective group over a specific period. It is one of two primary factors that determine the steady-state level of customers a business will support.

Customer lifetime and customer churn are key metrics that are used by commercial customers to determine their ability to retain a certain customer and the total worth to a business of a customer over the whole period of their relationship. 

This solution demonstrates how to interconnect the following Azure AI technologies:

- use Azure Data Lake and Azure Databricks to orchestrate DataOps best practices
- use Azure Databricks to perform Exploratory Data Analysis (EDA)
- batch experiment training of a sklearn machine learning model on Azure Databricks 
- machine learning experiments tracking using MLFlow
- batch scoring of machine learning models on Azure Databricks
- machine learning model registration and deployment using AzureML
- MLOps pipeline orchestration using Azure Data Factory and Azure Databricks notebooks 

We use a retail customer scenario where we classify customers based on marketing and economic measures to calculate their customer lifetime value. We then perform customer segmentation based on several metrics, and we train a multi-class classifier on new data.   The resulting supervised multi-class classifier model scores batches of new customer orders through a regularly scheduled Azure Databricks notebook job.

## Potential use cases

In general, determining the true value of a customer over its lifetime, can help answering a few questions. 

- In marketing: How much should I spend to acquire a customer?
- For a product team: How can I offer products and services tailored for my best customers?
- For Customer Support: How much should I spend to service and retain a customer?
- In sales: What types of customers should sales reps spend the most time on trying to acquire?

## Architecture

![Architecture Diagram](architecture-customerlifetime-churn.png)
=======



## Data flow

####  Ingestion and Orchestration Phase

The customer's historical, transactional data along with other third party such as Adobe Analytics is ingested from on-premises data sources using Azure Data Factory
and it is stored in Azure Data Lake Storage.

####  Data Processing 

In the data processing phase raw data is picked up and cleansed using Azure Databricks from the Azure Data Lake Gen2 bronze layer and stored in the silver layer in ADLS Gen2.

####  Feature Engineering

With Databricks, data is loaded from the silver layer and further enriched using pyspark. After data wrangling and preparation, feature engineering is performed to provide better representation of data and improve the performance of the machine learning algorithm.

####  Model Training

In the Model Training phase, the silver tier data will be serving as the model training dataset. You can use MLflow to manage machine learning experiments and keep track of all metrics needed to evaluate your machine learning experiment. MLflow Parameters and MLflow Metrics are used for storing model-related parameters, such as training hyperparameters, and for storing model performance metrics. 
Additionally, the machine learning model is itenrativly retrained using Azure Data Factory pipelines according to the conditions metioned below. The model retraining pipeline retreives the updated training data from the Azure Data Lake Gen2 (silver tier) and retrains the ML model. The model retraining pipeline kicks off in two different ways: 

-- when the accuracy of the current model in production drops below a certain threshold that is tracked by MLflow
 
-- calendar based triggering based on the customer defined rules.

-- when data drift is detected

####  Machine Learning Registry

In this phase, an Azure Data Factory pipeline registers the best machine learning model in the Azure Machine Learning Service according to the metrics chosend to pick up the best model.


####  Serving Phase

In this phase, you can pull the predictions of your model into different reporting tools, such as Power BI, Microstrategy, Analyses Services or any other tool you currently use.   

## Components

- [Azure Storage](https://azure.microsoft.com/product-categories/storage/) and [Azure Files](https://azure.microsoft.com/services/storage/files/) offer fully managed file shares in the cloud that are accessible via the industry- standard Server Message Block (SMB) protocol. Azure file shares can be mounted concurrently by cloud or on-premises deployments of Windows, Linux, and macOS.

- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database/) is a fully managed platform as a service (PaaS) database engine that handles most of the database management functions without user involvement, including upgrading, patching, backups, and monitoring. Azure SQL Database is always running on the latest stable version of the SQL Server database engine and patched OS with 99.99-percent availability. PaaS capabilities that are built into Azure SQL Database enable you to focus on the domain-specific database administration and optimization activities that are critical for your business.

- [Azure Blob Storage](https://azure.microsoft.com/en-us/services/storage/blobs/) is a cloud service for storing large amounts of unstructured data such as text, binary data, audio, and documents more-easily and cost-effectively. Azure Blob Storage allows data scientists quick access to data for experimentation and AI model building.

- [Azure Databricks](https://azure.microsoft.com/en-us/services/databricks/)  a data analytics platform optimized for the Microsoft Azure cloud services platform.

- [Azure Machine Learning](https://azure.microsoft.com/en-us/services/machine-learning/) empowers scientists and developers with a wide range of productive experiences to build, train, and deploy machine learning models and foster team collaboration. Accelerate time to market with industry-leading MLOps—machine learning operations, or DevOps for machine learning. Innovate on a secure, trusted platform, designed for responsible machine learning.

- [Azure Data Factory](https://azure.microsoft.com/en-us/services/data-factory/)  provides a data integration and transformation layer that works across your digital transformation initiatives.

- [MLflow](https://docs.microsoft.com/en-us/azure/databricks/applications/mlflow/), an open-source platform for managing the end-to-end machine learning life cycle.

## Alternatives

- Data Factory orchestrates the workflows for your data pipeline. If you want to load data only one time or on demand, you could use tools like SQL Server bulk copy (bcp) and AzCopy to copy data into Blob storage. You can then load the data directly into Azure Synapse using PolyBase.

- [Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/): Analytics service that brings together enterprise data warehousing and Big Data analytics.

## Considerations

Some BI tools may not support Azure Analysis Services, therefore the curated data can be accessed directly from Azure SQL Databasw. In this reference implementation, the data is stored using Azure Data Lake Storage Gen2 and pulled using Azure Databricks storage for data processing.

### Availability

The service level agreements (SLAs) of most Azure components guarantee availability:

- [At least 99.9 percent of Data Factory pipelines are guaranteed to run successfully.](https://azure.microsoft.com/en-us/support/legal/sla/data-factory/v1_2/)
- [The Azure Databricks SLA guarantees 99.95 percent availability.](https://azure.microsoft.com/en-us/services/databricks/)
- Blob Storage and Data Lake Storage are part of Azure Storage, which offers [availability through redundancy.](https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy)

### Scalability

This scenario uses Azure Data Lake Storage to store data for machine learning models and predictions. Azure Storage is scalable by design and it is able to store and serve many exabytes of data. This amount of storage is available with throughput measured in gigabits per second (Gbps) at high levels of input/output operations per second (IOPS). Processing is executed at near-constant per-request latencies that are measured at the service, account, and file levels.

Additionally this scenario uses Azure Databricks clusters, which enable autoscaling by default. This autoscaling feature enables Databricks during runtime to dynamically reallocates workers to account for the characteristics of your job. Autoscaling makes it easier to achieve high cluster utilization, because you don't need to provision the cluster to match a workload. 

### Security considerations

Assets are protected by placing controls on network traffic originating in Azure, between on-premises and Azure hosted resources, and traffic to and from Azure. For instance, Azure Self-Hosted Integration runtime is used to securely move the data between on-premises data storage to Azure. Azure Keyvault and Databricks Scoped Secrete is used to access the data in Azure ADLS Gen2. All of the Azure services are deployed in a secure VNet or the access is privisioned using Azure Private Link feature. If neccessary, Row Level Security (RLS) is impleted in Azure Analysis Services or SQL DB to provide granular access to individua users.

### Cost considerations

Azure Databricks is a premium Spark offering with an associated cost. In addition, there are standard and premium Databricks pricing tiers. For this scenario, the standard pricing tier is sufficient. However, if your specific application requires automatically scaling clusters to handle larger workloads or interactive Databricks dashboards, the premium level could increase costs further.

### Storage considerations

In this reference implementation, the data is stored in [Azure Data Lake Storage](https://azure.microsoft.com/en-us/services/storage/data-lake-storage/).  

- Azure Data Factory orchestrates the workflows for your data pipeline. If you want to load data only one time or on demand, you could use tools like SQL Server bulk copy (bcp) and AzCopy to copy data into Blob storage. You can then load the data directly into Azure Synapse using PolyBase.

- [Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/): Analytics service that brings together enterprise data warehousing and Big Data analytics.


## Pricing

Costs related to this use case will depend on the standard pricing for the following services, based on your usage:

- [Azure Databricks pricing](https://azure.microsoft.com/pricing/details/databricks/)

- [Azure Data Lake Storage pricing](https://azure.microsoft.com/en-us/pricing/details/storage/data-lake/)

- [Azure Data Factory pricing](https://azure.microsoft.com/en-us/pricing/details/data-factory/data-pipeline/)

- [Azure Machine Learning pricing](https://azure.microsoft.com/en-us/pricing/details/machine-learning/)

To estimate the cost of Azure products and configurations, visit the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/).

## Next steps

- [Get Started with Azure Machine Learning](https://docs.microsoft.com/en-us/azure/machine-learning/)
- [Get Started with Azure Data Lake Storage](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction)
- [Get Started with Azure Databricks](https://docs.microsoft.com/en-us/azure/databricks/)
- [Get Started with Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/)



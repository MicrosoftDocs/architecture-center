Loan originations in the Financial Industry needs to observe the credit risk of the individuals or businesses that need the credit lines. The model evaluates the delinquency and default probability of the party requesting for the funds. The Machine Learning based models’ decisions are based on the fiscal behaviour of the requester and will understand the huge set of data points that can segment/score the eligibility of the customer.

The following article describes an architecture built with Azure Machine Learning (ML) using Azure Synapse Analytics, Data Factory, Azure App Service and Power BI for an end-to-end solution.

## Architecture

image

link 

### Dataflow

1.	Store: Data is retained in a database like Synapse pools if it is structured. There could be older SQL databases that can be integrated into the loan processing system. The semi and unstructured data of any volumes can be organized into a data lake. 
2.	Ingestion and Pre-processing: Synapse processing pipelines and ETL processing can connect to data housed in Azure or 3rd party sources with built-in connectors. Synapse supports multiple analysis methodologies using Sql/Spark/ADX /PowerBI. You can also use existing Azure Data Factory (ADF) orchestration for the data pipelines. 
3.	Process: Azure Machine Learning enables the development and management of machine learning models, throughout their lifecycle. Azure ML supports code-first and low/no-code approaches to machine learning.
    1.	Pre-Processing: During this stage, raw data is processed creating a curated dataset that will train a machine learning model. Typical operations include data type formatting; imputation of missing values; feature engineering; feature selection; dimensionality reduction; amongst others.

     1.   Model Training: During the training stage, Azure  ML uses the pre-processed dataset to train and select the best credit risk model.
       
     - Model training: A wide range of machine learning models can be used, including classical machine learning, as well as deep learning models. Additionally, hyperparameter tunning allows for the optimisation of the model performance.
       
     - Model evaluation: The evaluation of models allows Azure ML to assess the performance of each trained model and enables you to select the best performing model for deployment.
      
      -  Model Registration: The model with best performance is registered in Azure Machine Learning, which makes it available for deployment.
    
    c. Responsible AI: Responsible Artificial Intelligence (Responsible AI) is an approach to developing, assessing, and deploying AI systems in a safe, trustworthy, and ethical way. Since the model infers an approval / denial decision for a loan request, implementing the principles of Responsible AI is very important  as listed below:

    - Fairness metrics assess the impact of unfair behavior and enable mitigation strategies. Sensitive features /attributes are identified across the entire dataset and cohorts of the population. [Fairness Documentation](/azure/machine-learning/concept-fairness-ml)

    - Interpretability is important to understand the behavior of the model. This component helps to generate human-understandable descriptions of the predictions of a machine learning model. [Interpretability Documentation](/azure/machine-learning/how-to-machine-learning-interpretability)

4.	Real time ML Deployment: Real-time model inference is needed when the request needs to be reviewed immediately for approval.
    1. Managed ML Online Endpoint – For Real-time scoring, the deployment options need to be appropriate compute selection.
    1. The online requests for loans need real-time scoring based on the inputs from the customer forms or loan application.
    1. The decision and the inputs used for the model scoring need to be stored in persistent storage and can be retrieved for any future reference.
5.	Batch ML Deployment: For offline loan processing, the model is scheduled to be triggered at regular intervals.
    1. Managed ML Endpoint: The batch inference is scheduled and the result dataset is created with decisioning based on the credit worthiness of the applicant.
    1. The result set of scoring from batch processing is persisted in the Database or Synapse data warehouse 
6.	Interface to Storage on the customer activity: The details plugged in by the customer, the internal credit profile and the model decision are all staged/stored in the appropriate data services. These are used in the decision engine for future scoring and are hence documented.
    - Storage: Each detail of the credit processing is retained in persistent storage infrastructure.
    - User Interface: The decision outcome of the model approval /denial from the model scoring is presented to the customer.
7.	Reporting: The real time insight into the no. of applications processed, approve/deny outcomes is continuously presented to the managers and leadership. Examples are near real-time reports with amounts approved, the loan portfolio created,  model performance etc. 

### Components

- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) provides scalable and secure object storage for unstructured data. It is optimized for storing files like binary files, activity logs, streaming audio/video  and files that does not adhere to any formats.
- [Azure Data Lake Storage Gen2]( ) is the storage foundation for building cost effective enterprise scale data lake on Azure. It is blob storage with hierarchical folder structure with enhanced performance, management, and security. It services multiple petabytes of information while sustaining hundreds of gigabits of throughput.
- [Azure Synapse]() is an enterprise analytics service   that brings together the best of SQL and Spark technologies with unified user experience for Data explorer, pipelines. It integrates seamlessly with PowerBI / Cosmos DB and Azure ML.  The tool supports both dedicated and serverless form factors and the ability to switch between the analysis methods.
- [Azure Sql DB]() fully managed relational database service built for the cloud. Build your next app with the simplicity and flexibility of a multi-model database that scales to meet demand. The DB is built with intelligent threat protection and built-in HA with performance SLA of 99.995%. Fully managed and always on the latest version of SQL. Eliminate the complexity of configuring and managing high availability, tuning, backups, and other database tasks.
- [Azure Machine Learning]() is a cloud service for accelerating and managing the machine learning project lifecycle. It is an integrated environment for data exploration, model building/management and deploying. The wizard-based model building aimed for citizen developers, notebook experience for the data scientists, organized into workspaces and managed by and admin.
- [Power BI]() is the Azure Paas Service visualization tool with easier integration to Azure resources. It has a rich set of connectors for non-azure and on-prem services. It’s a low/no code environment with business insights tool with drill down capabilities into granular level data for users with personas ranging from developers, report creators, business users and executives.
- [Azure App Services]() : Azure PaaS service enables you to build and host web apps, mobile back ends, and RESTful APIs with cloud scale infrastructure. You can develop in your favorite language, be it .NET, .NET Core, Java, Ruby, Node.js, PHP, or Python. 
 
### Alternatives

- [Databricks](): The first party solution to develop, build, deploy and manage ML models and analytics. The platform integrates with cloud storage and security in your cloud account and is a unified environment for model development.

## Scenario details

The Financial services industry aims at maximizing the loan originations and keep the charged off losses to minimum. The loans are issued to individuals with responsible credit behaviours. This customer profiling is a balancing act of profitability and loss mitigation. The quality of the portfolio needs to be evaluated continuously against the economic variables. 

Loan processing is heavily prediction exercise. It involves deeper analysis of the past population behaviour, classification of current customer base into segments to understand the fiscal responsibility. The other variables in this analysis are the market factors and the economic conditions. There is a strong influence of the current financial situation of the country on top of behavioural patterns and the financial worthiness of the individual. 

**Data Challenges**: The data input is the analysis of 10s of millions of customer profiles. and analysing their credit behaviour and spending habits by crunching billions of records that are coming from disparate systems like internal customer activity. The third-party economic conditions data, country market analysis could be monthly or quarterly snapshot that needs loading and maintaining 100s of GB of files.  The data would be structured purchase activity of the credit lines, free form text of the request and customer service notes. The credit bureau information pertaining to the requesting party or semi structured rows of customer, cross joins between these datasets and quality checks to validate the integrity of the data is needed. 

The data is usually wide tables of the customer information from credit bureaus along with the Market analysis. The customer activity is records with dynamic layout that may not be structured. There is also data available in free form text coming in from the customer service notes and the customer interactions forms. 

Churning through the huge volumes of the data and updating the results to the most recent timeframe needs a streamlined processing. The storage and retrieval process needs to be low latency. The data infrastructure should scale to support disparate data sources with the ability to manage and secure the data perimeter. The machine learning platform needs to support the complex analysis of the many models that are trained/tested/validated across many population segments.

**Data Sensitivity and Privacy**: The data processing involves Personal Identifiable Information (PII) data and demographics details. All the personally identifiable information should be restricted for any access to the direct visibility example account number, credit card details, SSN, name/address, zip codes.

Profiling of the population is a possibility that needs to be avoided. The credit card and bank account number is sensitive data that always needs to be obfuscated.  Certain data elements need to be masked and always encrypted with no access to the underlying information but enabled for analysis using different techniques. 

The data needs to be encrypted at rest, at transit times and at processing (secure enclaves). The access to the data items is logged in to a monitoring solution. The production system needs to be set up with appropriate CI/CD pipelines with approvals that trigger model deployments and processes. Audit of the logs and workflow should give the interactions with the data for any compliance needs. 

**Processing**: The effort needs high computational power for analysing, contextualising, and model training/deployment. The model scoring is validated against random samples to ensure the credit decisioning is not involving any race/gender/ethnic/geolocation bias. The credit decisioning model needs to be documented and archived for any future reference. Every factor that was involved in the approval/deny outcomes are stored. 

Data processing involves high CPU usage, with sql processing of structured data in DB and json format, or spark processing of the data frames or big data analytics on top of the Terabytes of information on different document formats. The data ELT/ETL jobs are scheduled or triggered at regular intervals or real time based on the value of most recent data.

**Compliance / Regulatory framework**: every detail of the loan processing needs to be documented starting from the application submitted, the features used in model scoring, the result set of the model output. The model training information, the data used for training and the training results should be registered for future reference and audit /compliance requests. 

**Batch /Realtime scoring**: Certain campaigns/programs from the loan offerings are proactive and can be batch processing (example: pre-approved balance transfers). And some requests need the real time approval (example: online credit line increases)

There is real-time access needed for the status of the online loan requests to the customer. The loan issuing financial institution continuously monitors the performance of the credit model and needs insights into the loan approval status, no. of loans approves, dollar issued, quality of the new originations, etc.

### Responsible AI

The [Responsible AI Dashboard](/azure/machine-learning/concept-responsible-ai-dashboard?view=azureml-api-2) provides a single interface to multiple mature tools to implement Responsible AI. Microsoft built the Responsible AI Standard according to six principles: 

image 

**Fairness and inclusiveness in Azure Machine Learning**: Fairness Assessment component of Responsible AI Dashboard (RAI) helps to evaluate unfair behaviors by avoiding the harm of allocation and harm of quality of service. It enables fairness towards the sensitive groups defined in terms of gender, age, ethnicity etc. During assessment, Fairness is quantified through disparity metrics. Use the mitigation algorithms in the [Fairlearn](https://fairlearn.org/) package using parity constraints. 

**Reliability and safety in Azure Machine Learning**:  The error analysis component of RAI helps.
- Get a deep understanding of how failure is distributed for a model.
- Identify cohorts (subsets) of data with a higher error rate than the overall benchmark.


**Transparency in Azure Machine Learning**: Crucial part of Transparency is understanding how the features affect the ML model. Model Interpretability and counter-factual-what-if analysis of RAI generated human understandable descriptions of the model predictions.
 - Model Interpretability helps you to understand what influences the behavior of the model. “diagnose” stage of the model lifecycle workflow by generating human-understandable descriptions of the predictions of ML model. This understanding helps to trust the model and debug/improve your model. [MLInterpret](https://interpret.ml/) can help with understanding the structure of Glass-Box models or relationship of the features in Black-Box deep neural network models.
- The counterfactual what-if component enables understanding and debugging a machine learning model in terms of how it reacts to feature changes and perturbations.

**Privacy and security in Azure Machine Learning**: ML administrators need to create a secure configuration to develop, manage, deployment of the models. There are Azure cloud [Foundation Security controls](/azure/machine-learning/concept-enterprise-security?view=azureml-api-2) that could be leveraged to comply with the company security policies. Also, there are other tools that helps to assess and secure the models. 

**Accountability in Azure Machine Learning**: MLOps framework enables the streamlined DevOps capabilities to increase the efficiency of AI workflows. This helps the complete ML model lifecycle management with register, package and deploy models and notify alerts with changes in the models. It captures governance data for end-to-end flow and monitor the application for operational issues.

**MLOps framework using Azure ML**:

image 

### Potential use cases

You can apply this solution to the following scenarios:
- Financial Industry: The solution can help with financial or cross sales analysis of a customer for targeted marketing campaigns.
- Health Care: The solution can also be built into a health care solution for any treatment offerings with patient information as the driver for the analysis.
- Hospitality: The design can be used to build a customer profile and create offerings for hotels/flights/cruise packages and memberships.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

The machine learning solutions needs to be scalable and standardized for the easier management/maintenance inline with the MLOps. Ensure the solution you implement supports ongoing inference with retraining cycles and automated redeployments of models. 

For more information, see [Azure MLOps (v2) solution accelerator](https://github.com/Azure/mlops-v2).

### Security

Azure solutions provide Defense in Depth with a Zero Trust approach. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Consider implementing the following security features in this architecture:
- https://learn.microsoft.com/azure/virtual-network/virtual-network-for-azure-services
- [Azure SQL Database security capabilities](/azure/azure-sql/database/security-overview?view=azuresql)
- [Secure the credentials in Data Factory by using Key Vault](/azure/data-factory/store-credentials-in-key-vault)
- [Enterprise security and governance for Azure Machine Learning](/azure/machine-learning/concept-enterprise-security)
- [Azure security baseline for Synapse Analytics Workspace](/security/benchmark/azure/baselines/synapse-analytics-workspace-security-baseline)

### Cost optimization

Building operational efficiencies and reducing costs with on-demand resources is an easier way to reduce costs. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Consider these resources for planning on the expenses and cost control:
- To estimate the cost of implementing this solution, use the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator).
- [Plan and manage costs for Azure Synapse Analytics](/azure/synapse-analytics/plan-manage-costs)
- [Plan to manage costs for Azure Machine Learning](/azure/machine-learning/concept-plan-manage-cost)

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Consider these resources for building efficiencies into the solution:
- For more information about designing scalable solutions, see [Performance efficiency checklist](/azure/architecture/framework/scalability/overview).
- [Scale AI and machine learning initiatives in regulated industries](../../example-scenario/ai/scale-ai-and-machine-learning-in-regulated-industries.yml)
- Manage Synapse environment with appropriate [SQL](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-manage-compute-overview) , [Spark](/azure/synapse-analytics/spark/apache-spark-autoscale) and [Serverless Sql](/azure/synapse-analytics/sql/on-demand-workspace-overview)
 
## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Charitha Basani](https://www.linkedin.com/in/charitha-basani-54196031) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign into LinkedIn.*

## Next steps
- Azure security baseline for Azure Machine Learning
- Azure Synapse Analytics
- Deploy machine learning models to Azure
- MLOps framework
- Responsible Artificial Intelligence

## Related resources

- https://learn.microsoft.com/azure/machine-learning/concept-responsible-ai



This architecture provides a predictive health analytics framework in the cloud to accelerate the path of model development, deployment, and consumption.

## Architecture

This framework makes use of native Azure analytics services for data ingestion, storage, data processing, analysis, and model deployment.

:::image type="content" source="media/predict-hospital-readmissions-machine-learning.svg" lightbox="media/predict-hospital-readmissions-machine-learning.svg" alt-text="Diagram demonstrates the architecture of a multi-tier app.":::

*Download a [Visio file](https://arch-center.azureedge.net/predict-hospital-readmissions-machine-learning.vsdx) of this architecture.*

### Workflow

The workflow of this architecture is described in terms of the roles of the participants.

1. **Data Engineer:** Responsible for ingesting the data from the source systems and orchestrating data pipelines to move data from the source to the target. May also be responsible for performing data transformations on the raw data.
   - In this scenario, historical hospital readmissions data is stored in an on-premises SQL Server database.
   - The expected output is readmissions data that's stored in a cloud-based storage account.

1. **Data Scientist:** Responsible for performing various tasks on the data in the target storage layer, to prepare it for model prediction. The tasks include cleansing, feature engineering, and data standardization.
   - **Cleansing:** Pre-process the data, removing null values, dropping unneeded columns, and so on. In this scenario, drop columns with too many missing values.
   - **Feature Engineering:**
     1. Determine the inputs that are needed to predict the desired output.
     1. Determine possible predictors for readmittance, perhaps by talking to professionals such as doctors and nurses. For example, real-world evidence may suggest that a diabetic patient being overweight is a predictor for hospital readmission.
   - **Data Standardization:**
     1. Characterize the location and variability of the data to prepare it for machine learning tasks. The characterizations should include data distribution, skewness, and kurtosis.
        - Skewness responds to the question: What is the shape of the distribution?
        - Kurtosis responds to the question: What is the measure of thickness or heaviness of the distribution?
     1. Identify and correct anomalies in the dataset—the prediction model should be performed on a dataset with a normal distribution.
     1. The expected output is these training datasets:
        - One to use for creating a satisfactory prediction model that's ready for deployment.
        - One that can be given to a Citizen Data Scientist for automated model prediction (AutoML).
1. **Citizen Data Scientist:** Responsible for building a prediction model that's based on training data from the Data Scientist. A Citizen Data Scientist most likely uses an AutoML capability that doesn't require heavy coding skills to create prediction models.

   The expected output is a satisfactory prediction model that's ready for deployment.

1. **Business Intelligence (BI) Analyst:** Responsible for performing operational analytics on raw data that the Data Engineer produces. The BI Analyst may be involved in creating relational data from unstructured data, writing SQL scripts, and creating dashboards.

   The expected output is relational queries, BI reports, and dashboards.

1. **MLOps Engineer:** Responsible for putting models into production that the Data Scientist or Citizen Data Scientist provides.

   The expected output is models that are ready for production and reproducible.

Although this list provides a comprehensive view of all the potential roles that may be interacting with healthcare data at any point in the workflow, the roles may be consolidated or expanded as needed.

### Components

- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is an orchestration service that can move data from on-premises systems to Azure, to work with other Azure data services. Pipelines are used for data movement, and mapping data flows are used to perform various transformation tasks such as extract, transform, load (ETL) and extract, load, transform (ELT). In this architecture, the Data Engineer uses Data Factory to run a pipeline that copies historical hospital readmission data from an on-premises SQL Server to cloud storage.
- [Azure Databricks](https://azure.microsoft.com/services/databricks) is a Spark-based analytics and machine learning service that's used for data engineering and ML workloads. In this architecture, the Data Engineer uses Databricks to call a Data Factory pipeline to run a Databricks notebook. The notebook is developed by the Data Scientist to handle the initial data cleansing and feature engineering tasks. The Data Scientist may write code in additional notebooks to standardize the data and to build and deploy prediction models.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) is a massively scalable and secure storage service for high-performance analytics workloads. In this architecture, the Data Engineer uses Data Lakes Storage to define the initial landing zone for the on-premises data that's loaded to Azure, and the final landing zone for the training data. The data, in raw or final format, is ready for consumption by various downstream systems.
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is a collaborative environment that's used to train, deploy, automate, manage, and track machine learning models. Automated machine learning (AutoML) is a capability that automates the time-consuming and iterative tasks that are involved in ML model development. The Data Scientist uses Machine Learning to track ML runs from Databricks, and to create AutoML models to serve as a performance benchmark for the Data Scientist's ML models. A Citizen Data Scientist uses this service to quickly run training data through AutoML to generate models, without needing detailed knowledge of machine learning algorithms.
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is an analytics service that unifies data integration, enterprise data warehousing, and big data analytics. Users have the freedom to query data by using serverless or dedicated resources, at scale. In this architecture:
  - The Data Engineer uses Synapse Analytics to easily create relational tables from data in the data lake to be the foundation for operational analytics.
  - The Data Scientist uses it to quickly query data in the data lake and develop prediction models by using Spark notebooks.
  - The BI Analyst uses it to run queries using familiar SQL syntax.
- [Microsoft Power BI](https://powerbi.microsoft.com) is a collection of software services, apps, and connectors that work together to turn unrelated sources of data into coherent, visually immersive, and interactive insights. The BI Analyst uses Power BI to develop visualizations from the data, such as a map of each patient's home location and nearest hospital.
- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) is a cloud-based identity and access management service. In this architecture, it controls access to the Azure services.
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault) is a cloud service that provides a secure store for secrets such as keys, passwords, and certificates. Key Vault holds the secrets that Databricks uses to gain write access to the data lake.
- [Microsoft Defender for Cloud](https://azure.microsoft.com/services/security-center) is a unified infrastructure security management system that strengthens the security posture of data centers, and provides advanced threat protection across hybrid workloads in the cloud and on-premises. You can use it to monitor security threats against the Azure environment.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications. AKS simplifies deployment of a managed AKS cluster in Azure by offloading the operational overhead to Azure.

### Alternatives

- **Data Movement:** You can use Databricks to copy data from an on-premises system to the data lake. Typically, Databricks is appropriate for data that has a streaming or real-time requirement, such as telemetry from a medical device.

- **Machine Learning:** H2O.ai, DataRobot, Dataiku, and other vendors offer automated machine learning capabilities that are similar to Machine Learning AutoML. You can use such platforms to supplement Azure data engineering and machine learning activities.

## Scenario details

This architecture represents a sample end-to-end workflow for predicting hospital readmissions for diabetes patients, using [publicly available data](https://archive.ics.uci.edu/ml/datasets/diabetes+130-us+hospitals+for+years+1999-2008) from 130 US hospitals over the 10 years from 1999 to 2008. First it evaluates a [binary classification](https://www.learndatasci.com/glossary/binary-classification) algorithm for predictive power, then benchmarks it against predictive models that are generated by using automated machine learning. In situations where automated machine learning can't correct for [imbalanced data](/azure/machine-learning/concept-manage-ml-pitfalls#handle-imbalanced-data), alternative techniques should be applied. A final model is selected for deployment and consumption.

As healthcare and life science organizations strive to provide a more personalized experience for patients and caregivers, they're challenged to use data from legacy systems to provide predictive insights that are relevant, accurate, and timely. Data collection has moved beyond traditional operational systems and electronic health records (EHRs), and increasingly into unstructured forms from consumer health apps, fitness wearables, and smart medical devices. Organizations need the ability to quickly centralize this data and harness the power of data science and machine learning to stay relevant to their customers.

To achieve these objectives, healthcare and life science organizations should aim to:

- Create a data source from which predictive analytics can provide real-time value to healthcare providers, hospital administrators, drug manufacturers, and others.
- Accommodate their industry subject matter experts (SMEs) that don't have data science and machine learning skills.
- Provide to data science and machine learning (ML) SMEs the flexible tools that they need to create and deploy predictive models efficiently, accurately, and at scale.

### Potential use cases

- Predict hospital readmissions
- Accelerate patient diagnosis through ML-powered imaging
- Perform text analytics on physician notes
- Predict adverse events by analyzing remote patient monitoring data from the Internet of Medical Things (IoMT)

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Availability

Providing real-time clinical data and insights is critical for many healthcare organizations. Here are ways to minimize downtime and keep data safe:

- Data Lake Storage is always [replicated three times](/azure/storage/common/storage-redundancy) in the primary region, with the option to choose locally redundant storage (LRS) or zone-redundant storage (ZRS).
- Synapse Analytics provides [database restore points and disaster recovery](/azure/cloud-adoption-framework/migrate/azure-best-practices/analytics/azure-synapse).
- Data Factory data is stored and replicated in an [Azure paired region](/azure/data-factory/concepts-data-redundancy) to ensure business continuity and disaster recovery.
- Databricks provides [disaster recovery guidance](/azure/databricks/administration-guide/disaster-recovery) for its data analytics platform.
- The Machine Learning deployment can be [multi-regional](/azure/machine-learning/how-to-high-availability-machine-learning).

### Performance

 The Data Factory self-hosted integration runtime can be [scaled up for high availability and scalability](/azure/data-factory/create-self-hosted-integration-runtime#high-availability-and-scalability).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Healthcare data often includes sensitive protected health information (PHI) and personal information. The following resources are available to secure this data:

- Data Lake Storage uses Azure role-based access control (RBAC) and access control lists (ACLs) to create an [access control model](/azure/storage/blobs/data-lake-storage-access-control-model).
- Synapse Analytics provides a number of [access and security controls](/azure/azure-sql/database/logins-create-manage?bc=/azure/synapse-analytics/sql-data-warehouse/breadcrumb/toc.json&toc=/azure/synapse-analytics/sql-data-warehouse/toc.json) at the database, column, and row levels. Data can also be protected at the cell level and through [data encryption](/azure/azure-sql/database/transparent-data-encryption-tde-overview?bc=/azure/synapse-analytics/sql-data-warehouse/breadcrumb/toc.json&toc=/azure/synapse-analytics/sql-data-warehouse/toc.json).
- Data Factory provides a [basic security infrastructure](/azure/data-factory/data-movement-security-considerations) for data movement in both hybrid and cloud scenarios.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Pricing for this solution is based on:

- The Azure services that are used.
- Volume of data.
- Capacity and throughput requirements.
- ETL/ELT transformations that are needed.
- Compute resources that are needed to perform machine learning tasks.

You can estimate costs by using the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Matt Hansen](https://www.linkedin.com/in/matthansen0) | Senior Cloud Solution Architect
- [Sandy Su](https://www.linkedin.com/in/sandylsu/) | Cloud Solution Architect

## Next steps

### Azure services

- [What is Azure Data Factory?](/azure/data-factory/introduction)
- [What is Azure Databricks?](/azure/databricks/scenarios/what-is-azure-databricks)
- [Track ML models with MLflow and Azure Machine Learning](/azure/machine-learning/how-to-use-mlflow)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-ml)
- [What is automated machine learning (AutoML)?](/azure/machine-learning/concept-automated-ml)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [Unleash the power of predictive analytics in Azure Synapse with machine learning and AI](https://techcommunity.microsoft.com/t5/azure-synapse-analytics/unleash-the-power-of-predictive-analytics-in-azure-synapse-with/ba-p/1961252)
- [Advanced analytics architecture](../../solution-ideas/articles/advanced-analytics-on-big-data.yml)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [What is Azure Active Directory?](/azure/active-directory/fundamentals/active-directory-whatis)
- [About Azure Key Vault](/azure/key-vault/general/overview)
- [What is Microsoft Defender for Cloud?](/azure/security-center/security-center-introduction)

### Healthcare solutions

- [Microsoft Cloud for Healthcare](https://www.microsoft.com/industry/health/microsoft-cloud-for-healthcare)
- [Azure for healthcare](https://azure.microsoft.com/industries/healthcare)
- [Azure API for FHIR](https://azure.microsoft.com/services/azure-api-for-fhir/?WT.mc_id=iot-c9-niner)
- [IoMT FHIR Connector for Azure](https://azure.microsoft.com/blog/accelerate-iomt-on-fhir-with-new-microsoft-oss-connector)
- [Remote Patient Monitoring with Internet of Medical Things (IoMT)](/shows/Internet-of-Things-Show/Remote-Patient-Monitoring-with-Internet-of-Medical-Things-IoMT)

## Related resources

- [Batch scoring of Python models on Azure](../../reference-architectures/ai/batch-scoring-python.yml)
- [Citizen AI with the Power Platform](../../example-scenario/ai/citizen-ai-power-platform.yml)
- [Deploy AI and ML computing on-premises and to the edge](../../hybrid/deploy-ai-ml-azure-stack-edge.yml)
- [MLOps for Python models using Azure Machine Learning](../../reference-architectures/ai/mlops-python.yml)
- [Data science and machine learning with Azure Databricks](../../solution-ideas/articles/azure-databricks-data-science-machine-learning.yml)
- [Predict Length of Stay and Patient Flow](/azure/architecture/example-scenario/digital-health/predict-patient-length-of-stay)
- [Population Health Management for Healthcare](../../solution-ideas/articles/population-health-management-for-healthcare.yml)

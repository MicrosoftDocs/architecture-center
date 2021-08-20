> If you'd like to see us expand this article with more information, implementation details, pricing guidance, or code examples, let us know with [GitHub Feedback](https://github.com/MicrosoftDocs/architecture-center/issues/new)!

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

As your organization recognizes the power of data science and machine learning, you can transform your results across industries. You can improve efficiency, transform customer experiences, and predict changes. To achieve these goals in business-critical use cases, you need a consistent and reliable pattern for these tasks:

- Tracking experiments
- Reproducing results
- Deploying machine learning models into production

This article outlines a solution that meets those needs. Azure Databricks forms the core of the solution. This platform integrates seamlessly with other services such as Azure Data Lake Storage, Azure Machine Learning, and Azure Kubernetes Service (AKS). Together, these services provide a solution for data science and machine learning with these qualities:

- **Simple**: An open data lake with a curated layer in an open-source format simplifies the architecture. Delta Lake provides access to the Azure Data Lake Storage data lake. Delta Lake supports atomicity, consistency, isolation, and durability (ACID) transactions for reliability. Delta Lake is optimized for transforming and cleansing batch and streaming data. Time travel features provide consistent snapshots of source data. Data scientists can train models on those snapshots instead of creating separate copies.
- **Open**: Support for open source, open standards, and open frameworks help future proof your architecture. Azure Databricks and Azure Machine Learning natively support MLflow and Delta Lake for industry-leading MLOps. Track experiments, projects and models in a central location. A standard model format helps you integrate with a broad ecosystem of deployment tools.
- **Collaborative**: Data science and MLOps teams can work together, using MLflow tracking to record and query experiments, including code, data, config, and results, then deploy models to the central MLflow model registry. Data engineering teams can easily leverage deployed models as part of their data ingestion, ETL and streaming pipelines.

## Potential use cases

The platform that AGL built for energy forecasting inspired this solution. Besides energy providers, any organization that performs these tasks can also benefit from this solution:

- Uses data science
- Builds and trains machine learning models
- Runs machine learning models in production

Examples include organizations in these areas:

- Retail and e-commerce
- Banking and finance
- Healthcare and life sciences
- Automotive industries and manufacturing

## Architecture

:::image type="complex" source="../media/azure-databricks-data-science-machine-learning-architecture.png" alt-text="Architecture diagram showing how to sync on-premises and Azure databases during mainframe modernization." border="false":::
   The diagram contains two parts, one for on-premises components, and one for Azure components. The on-premises part contains rectangles, one that pictures databases and one that contains integration tools. A server icon that represents the self-hosted integration runtime is also located in the on-premises part. The Azure part also contains rectangles. One is for pipelines. Others are for services that the solution uses for staging and preparing data. Another contains Azure databases. Arrows point from on-premises components to Azure components. These arrows represent the flow of data in the replication and sync processes. One of the arrows goes through the on-premises data gateway.
:::image-end:::

This reference architecture is inspired by the platform built by [AGL Energy](https://customers.microsoft.com/en-us/story/844796-agl-energy-azure), allowing quick and cost-effective training, deployment, and lifecycle management for thousands of parallel models.

1. Code from a variety of languages, frameworks, and libraries prepares the data. Coding possibilities include:

   - Python
   - R
   - SQL
   - Spark
   - Pandas
   - Koalas

   Azure Data Lake Storage stores the prepared, refined, and cleansed data in Delta Lake format. Delta Lake forms the curated layer of the data lake. It makes the refined data available in an open-source format.

1. Azure Databricks organizes data into layers:

   - Bronze tables hold raw data.
   - Silver tables contain cleaned, filtered data.
   - Gold tables store aggregated data that's ready for analytics and reporting.

   Azure Databricks runs data science workloads and builds and trains machine learning models. This platform uses pre-installed, optimized libraries. Examples include scikit-learn, TensorFlow, PyTorch, and XGBoost. MLflow tracking captures the experiments, model runs, and results.

1. When the best model is ready for production, Azure Databricks deploys it to the MLflow model repository. This centralized registry stores information on production models. It also makes models available to other components:

   - Spark and Python pipelines can ingest models. These pipelines handle batch workloads or streaming extract-transform-load (ETL) processes.
   - REST APIs provide access to models for many purposes:

     - Interactive scoring in mobile and web applications
     - Testing

1. The solution can also deploy models in other services, such as Azure Machine Learning and Azure Kubernetes Service.

This solution uses a shared data lake that's based on the open Delta Lake format. It provides a consistent standard for data preparation, model training, and model serving. To minimize the need for future updates, this architecture uses open frameworks. A variety of services, applications, frameworks, and tools can consume the models as a result.

### Components

- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) brings together streaming and batch data, including structured, unstructured, and semi-structured data (logs, files, and media).

- [Azure Databricks](https://docs.microsoft.com/en-us/azure/azure-databricks/) provides scalable compute and GPU clusters to perform data science, build and train machine learning models using pre-installed, optimized libraries. MLflow integration provides experiment tracking, model repository and model serving. Azure Databricks offers scalability:

  - Single-node compute clusters handle small data sets and single-model runs.
  - For large data sets, multi-node compute or graphics processing unit (GPU) clusters are available. These clusters use libraries and frameworks like HorovodRunner and Hyperopt for parallel-model runs.

- [Machine Learning](https://docs.microsoft.com/en-us/azure/machine-learning) helps you easily build, deploy, and manage predictive analytics solutions.

- [AKS](https://docs.microsoft.com/en-us/azure/aks/) is a highly available, secure, and fully managed Kubernetes service that makes it easy to deploy and manage containerized applications.

## Next steps

- [AGL Energy](https://customers.microsoft.com/en-us/story/844796-agl-energy-azure) builds a standardized platform, allowing quick and cost-effective training, deployment, and lifecycle management for thousands of parallel models.
- [Open Grid Europe (OGE)](https://customers.microsoft.com/en-us/story/1378282338316029794-open-grid-europe-azure-en) monitors gas pipelines using artificial intelligence models developed using Azure Databricks and MLflow.
- [SAS](https://customers.microsoft.com/en-us/story/781802-sas-travel-transportation-azure-machine-learning) collaborates on research and develops new models to improve everyday operations and identify patterns in the company’s data.
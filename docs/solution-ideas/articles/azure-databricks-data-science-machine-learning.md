> If you'd like to see us expand this article with more information, implementation details, pricing guidance, or code examples, let us know with [GitHub Feedback](https://github.com/MicrosoftDocs/architecture-center/issues/new)!

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

As your organization recognizes the power of data science and machine learning, you can transform your results across industries. You can improve efficiency, transform customer experiences, and predict changes. To achieve these goals in business-critical use cases, you need a consistent and reliable pattern for these tasks:

- Tracking experiments
- Reproducing results
- Deploying machine learning models into production

This article outlines a solution that meets those needs. Azure Databricks forms the core of the solution. This platform integrates seamlessly with other services such as Azure Data Lake Storage, Azure Machine Learning, and Azure Kubernetes Service (AKS). Together, these services provide a solution for data science and machine learning with these qualities:

- **Simple**: Simplify your architecture for data science and machine learning using an open data lake to store all your data, with a curated layer in an open-source format. Delta Lake on Azure Data Lake Gen2 supports ACID transactions for reliability and is optimized for transforming and cleansing both batch and streaming data. With time travel, data scientists can train models on a consistent snapshot of the source data without having to create a separate copy. 
- **Open**: Support for open source, open standards, and open frameworks help future proof your architecture. Azure Databricks and Azure Machine Learning natively support MLflow and Delta Lake for industry-leading MLOps. Track experiments, projects and models in a central location. A standard model format helps you integrate with a broad ecosystem of deployment tools.
- **Collaborative**: Data science and MLOps teams can work together, using MLflow tracking to record and query experiments, including code, data, config, and results, then deploy models to the central MLflow model registry. Data engineering teams can easily leverage deployed models as part of their data ingestion, ETL and streaming pipelines.

## Potential use cases
The platform that AGL built for energy forecasting inspired this solution. Besides the energy sector, any organization that performs data science, builds and trains machine learning models or runs ML models in production can also benefit from this solution. Examples include:

- Retail and e-commerce
- Banking and finance
- Healthcare and life sciences
- Automotive and manufacturing

## Architecture

:::image type="complex" source="../media/azure-databricks-data-science-machine-learning-architecture.png" alt-text="Architecture diagram showing how to sync on-premises and Azure databases during mainframe modernization." border="false":::
   The diagram contains two parts, one for on-premises components, and one for Azure components. The on-premises part contains rectangles, one that pictures databases and one that contains integration tools. A server icon that represents the self-hosted integration runtime is also located in the on-premises part. The Azure part also contains rectangles. One is for pipelines. Others are for services that the solution uses for staging and preparing data. Another contains Azure databases. Arrows point from on-premises components to Azure components. These arrows represent the flow of data in the replication and sync processes. One of the arrows goes through the on-premises data gateway.
:::image-end:::


## Data Flow
This reference architecture is inspired by the platform built by [AGL Energy](https://customers.microsoft.com/en-us/story/844796-agl-energy-azure), allowing quick and cost-effective training, deployment, and lifecycle management for thousands of parallel models.
1. The process begins with data that has been prepared, refined, and cleansed on an open, curated data lake. Data is prepared using a variety of languages, frameworks and libraries, including Python, R, SQL, Spark, Pandas, and koalas then saved in Delta Lake format in Azure Data Lake Storage. 
2. Organizations then use Azure Databricks to perform data science, build and train machine learning models using pre-installed, optimized libraries such as scikit-learn, TensorFlow, PyTorch, and XGBoost. Users can scale from single-node compute clusters for smaller data sets and single model runs to multi-node compute or GPU clusters for larger data or parallel model runs using libraries and frameworks such as HorovodRunner and hyperopt. All experiments, model runs and results are captured in MLflow tracking.
3. Once the best model is prepared for production, the model is deployed to the MLflow model repository. This centralized repository for all of your production models can serve those models for batch or streaming ETL pipelines in Spark or Python and can also serve those models as REST APIs for interactive scoring for use in mobile and web applications or for testing the model before deploying to other services.
4. Optionally, models can be deployed in other services such as Azure Machine Learning and Azure Kubernetes Service.

The architecture leverages a shared data lake based on the open Delta Lake format. It provides a consistent standard for data preparation, model training and model serving. This architecture leverages open frameworks, enabling the models to be consumed from a variety of services, applications, frameworks, and tools in order to future-proof the architecture.

### Components

- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) brings together streaming and batch data, including structured, unstructured, and semi-structured data (logs, files, and media). 
- [Azure Databricks](https://docs.microsoft.com/en-us/azure/azure-databricks/) provides scalable compute and GPU clusters to perform data science, build and train machine learning models using pre-installed, optimized libraries. MLflow integration provides experiment tracking, model repository and model serving.
- [Machine Learning](https://docs.microsoft.com/en-us/azure/machine-learning) helps you easily build, deploy, and manage predictive analytics solutions.
- [AKS](https://docs.microsoft.com/en-us/azure/aks/) is a highly available, secure, and fully managed Kubernetes service that makes it easy to deploy and manage containerized applications.

## Next steps

- [AGL Energy](https://customers.microsoft.com/en-us/story/844796-agl-energy-azure) builds a standardized platform, allowing quick and cost-effective training, deployment, and lifecycle management for thousands of parallel models.
- [Open Grid Europe (OGE)](https://customers.microsoft.com/en-us/story/1378282338316029794-open-grid-europe-azure-en) monitors gas pipelines using artificial intelligence models developed using Azure Databricks and MLflow.
- [SAS](https://customers.microsoft.com/en-us/story/781802-sas-travel-transportation-azure-machine-learning) collaborates on research and develops new models to improve everyday operations and identify patterns in the company’s data.
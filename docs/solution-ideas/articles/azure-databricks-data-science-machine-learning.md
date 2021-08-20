> If you'd like to see us expand this article with more information, implementation details, pricing guidance, or code examples, let us know with [GitHub Feedback](https://github.com/MicrosoftDocs/architecture-center/issues/new)!

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

As your organization recognizes the power of data science and machine learning, you can transform your results across industries. You can improve efficiency, transform customer experiences, and predict changes. To achieve these goals in business-critical use cases, you need a consistent and reliable pattern for these tasks:

- Tracking experiments
- Reproducing results
- Deploying machine learning models into production

This article outlines a solution that meets those needs. Azure Databricks forms the core of the architecture. The storage layer Delta Lake and the machine learning platform MLflow also play significant roles. These components integrate seamlessly with other services such as Azure Data Lake Storage, Azure Machine Learning, and Azure Kubernetes Service (AKS). Together, these services provide a solution for data science and machine learning with these qualities:

- **Simple**: An open data lake with a curated layer in an open-source format simplifies the architecture. Delta Lake provides access to the Azure Data Lake Storage data lake. This platform supports atomicity, consistency, isolation, and durability (ACID) transactions for reliability. Delta Lake is optimized for transforming and cleansing batch and streaming data. Its time travel features provide consistent snapshots of source data. Data scientists can train models on those snapshots instead of creating separate copies.
- **Open**: To minimize the need for future updates, the solution supports open-source code, open standards, and open frameworks. Azure Databricks and Azure Machine Learning natively support MLflow and Delta Lake. Together, these components provide industry-leading *machine learning operations (MLOps)*, or DevOps for machine learning. You can use the solution to track experiments, projects, and models in a central location. A broad range of deployment tools integrate with the solution's standardized model format.
- **Collaborative**: Data science and MLOps teams work together with this solution. They use MLflow tracking to record and query experiments. Stored information includes code, data, config, and results. The teams also deploy models to the central MLflow model registry. Data engineers then use deployed models in data ingestion, extract-transform-load (ETL), and streaming pipelines.

## Potential use cases

A [platform that AGL built for energy forecasting](https://customers.microsoft.com/en-us/story/844796-agl-energy-azure) inspired this solution. That platform provides quick and cost-effective training, deployment, and lifecycle management for thousands of parallel models. Besides energy providers, this solution can benefit any organization that performs these tasks:

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

1. Intro statement for the first step:

   - Code from a variety of languages, frameworks, and libraries prepares the data. Coding possibilities include Python, R, SQL, Spark, Pandas, and Koalas.
   - Azure Data Lake Storage stores the prepared, refined, and cleansed data in Delta Lake format.
   - Delta Lake forms the curated layer of the data lake. It makes the refined data available in an open-source format.

1. Azure Databricks organizes data into layers:

   - Bronze tables hold raw data.
   - Silver tables contain cleaned, filtered data.
   - Gold tables store aggregated data that's ready for analytics and reporting.

   Azure Databricks runs data science workloads and builds and trains machine learning models. This platform uses pre-installed, optimized libraries. Examples include scikit-learn, TensorFlow, PyTorch, and XGBoost. MLflow tracking captures the experiments, model runs, and results.

1. When the best model is ready for production, Azure Databricks deploys it to the MLflow model repository. This centralized registry stores information on production models. It also makes models available to other components:

   - Spark and Python pipelines can ingest models. These pipelines handle batch workloads or streaming ETL processes.
   - REST APIs provide access to models for many purposes:

     - Interactive scoring in mobile and web applications
     - Testing

1. The solution can also deploy models to other services, such as Azure Machine Learning and Azure Kubernetes Service.

### Components

- [Data Lake Storage][Data Lake Storage] is a scalable and secure data lake for high-performance analytics workloads. This service can manage multiple petabytes of information while sustaining hundreds of gigabits of throughput. The data may be structured, semi-structured, or unstructured. It typically comes from multiple, heterogeneous sources like logs, files, and media. And it may be static, from batches, or streaming.

- [Azure Databricks][Azure Databricks] is a data analytics platform. Its fully managed Spark clusters run data science workloads. Azure Databricks also uses pre-installed, optimized libraries to build and train machine learning models. MLflow integration with Azure Databricks provides a way to track experiments, store models in repositories, and make models available to other services. Azure Databricks offers scalability:

  - Single-node compute clusters handle small data sets and single-model runs.
  - For large data sets, multi-node compute or graphics processing unit (GPU) clusters are available. These clusters use libraries and frameworks like HorovodRunner and Hyperopt for parallel-model runs.

- [Delta Lake][Delta Lake] is a storage layer that uses an open file format. This layer runs on top of cloud storage such as Data Lake Storage. Delta Lake supports data versioning, rollback, and transactions for updating, deleting, and merging data. Delta Lake format provides a consistent standard for data preparation, model training and model serving.

- [MLflow][MLflow] is an open-source platform for the machine learning lifecycle. Its components monitor machine learning models during training and running. MLflow also stores models and loads them in production. Because MLflow uses open frameworks, a variety of services, applications, frameworks, and tools can consume the models.

- [Machine Learning][Machine Learning] is a cloud-based environment that helps you build, deploy, and manage predictive analytics solutions. With these models, you can forecast behavior, outcomes, and trends.

- [AKS][AKS] is a highly available, secure, and fully managed Kubernetes service. AKS makes it easy to deploy and manage containerized applications.

## Next steps

- [AGL Energy][AGL Energy] builds a standardized platform that provides quick and cost-effective training, deployment, and lifecycle management for thousands of parallel models.
- [Open Grid Europe (OGE)][Open Grid Europe (OGE)] uses artificial intelligence models to monitor gas pipelines. OGE uses Azure Databricks and MLflow to develop the models.
- [Scandinavian Airlines (SAS)](https://customers.microsoft.com/story/781802-sas-travel-transportation-azure-machine-learning) collaborates with Azure Databricks on research and uses Azure Machine Learning to develop predictive models. By identifying patterns in the company's data, the models improve everyday operations.

## Related resources

- [Choose an analytical data store in Azure][Choose an analytical data store in Azure]
- [Batch scoring of Spark models on Azure Databricks][Batch scoring of Spark models on Azure Databricks]
- [Stream processing with Azure Databricks][Stream processing with Azure Databricks]
- [Ingestion, ETL, and stream processing pipelines with Azure Databricks][Ingestion, ETL, and stream processing pipelines with Azure Databricks]
- [Modern analytics architecture with Azure Databricks][Modern analytics architecture with Azure Databricks]

[AGL Energy]: https://customers.microsoft.com/story/844796-agl-energy-azure
[AKS]: https://azure.microsoft.com/services/kubernetes-service/
[Azure Databricks]: https://azure.microsoft.com/services/databricks/
[Batch scoring of Spark models on Azure Databricks]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/ai/batch-scoring-databricks
[Choose an analytical data store in Azure]: https://docs.microsoft.com/azure/architecture/data-guide/technology-choices/analytical-data-stores
[Data Lake Storage]: https://azure.microsoft.com/services/storage/data-lake-storage
[Delta Lake]: https://databricks.com/product/delta-lake-on-databricks
[Ingestion, ETL, and stream processing pipelines with Azure Databricks]: https://docs.microsoft.com/azure/architecture/solution-ideas/articles/ingest-etl-stream-with-adb
[Machine Learning]: https://azure.microsoft.com/services/machine-learning/
[MLflow]: https://mlflow.org/
[Modern analytics architecture with Azure Databricks]: https://docs.microsoft.com/azure/architecture/solution-ideas/articles/azure-databricks-modern-analytics-architecture
[Open Grid Europe (OGE)]: https://customers.microsoft.com/story/1378282338316029794-open-grid-europe-azure-en
[Scandinavian Airlines (SAS)][Scandinavian Airlines (SAS)]: https://customers.microsoft.com/story/781802-sas-travel-transportation-azure-machine-learning
[Stream processing with Azure Databricks]: https://docs.microsoft.com/azure/architecture/reference-architectures/data/stream-processing-databricks
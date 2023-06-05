[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture shows how you can improve operations by using Azure Databricks, Delta Lake, and MLflow for data science and machine learning. You can improve your overall efficiency and the customer experience by developing, training, and deploying machine learning models.

## Architecture

:::image type="complex" source="../media/azure-databricks-data-science-machine-learning-architecture.svg" alt-text="Architecture diagram showing how Azure Databricks works with data storage services to refine and analyze data and make it available for other services." border="false":::
   The diagram contains three gray rectangles: one labeled Process, one labeled Serve, and one labeled Store. The Process and Serve rectangles are next to each other in the upper part of the diagram. The Serve rectangle contains a white box with icons for Machine Learning and Azure Kubernetes Service. Another white box straddles the Process and Serve rectangles. It contains icons for Azure Databricks and MLflow. An arrow points from that box to the white box in the Serve rectangle. Below the Process rectangle is the Store rectangle. It contains a white box with icons for Data Lake Storage, Delta Lake, and three database tables labeled Bronze, Silver, and Gold. Three lines connect the Process and Store rectangles, with arrows at each end of each line.
:::image-end:::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

The solution stores, processes, and serves data:

### Dataflow

#### Store

Data Lake Storage stores the data in Delta Lake format. Delta Lake forms the curated layer of the data lake. A medallion architecture organizes the data into three layers:

- Bronze tables hold raw data.
- Silver tables contain cleaned, filtered data.
- Gold tables store aggregated data that's ready for analytics and reporting.

#### Process

- Code from various languages, frameworks, and libraries prepares, refines, and cleanses the raw data (**1**). Coding possibilities include Python, R, SQL, Spark, Pandas, and Koalas.

- Azure Databricks runs data science workloads. This platform also builds and trains machine learning models (**2**). Azure Databricks uses pre-installed, optimized libraries. Examples include scikit-learn, TensorFlow, PyTorch, and XGBoost.

- MLflow tracking captures the machine learning experiments, model runs, and results (**3**). When the best model is ready for production, Azure Databricks deploys that model to the MLflow model repository. This centralized registry stores information on production models. The registry also makes models available to other components:

  - Spark and Python pipelines can ingest models. These pipelines handle batch workloads or streaming ETL processes.
  - REST APIs provide access to models for many purposes. Examples include testing and interactive scoring in mobile and web applications.

#### Serve

Azure Databricks can deploy models to other services, such as Machine Learning and AKS (**4**).

### Components

- [Azure Databricks][Azure Databricks] is a data analytics platform. Its fully managed Spark clusters run data science workloads. Azure Databricks also uses pre-installed, optimized libraries to build and train machine learning models. MLflow integration with Azure Databricks provides a way to track experiments, store models in repositories, and make models available to other services. Azure Databricks offers scalability:

  - Single-node compute clusters handle small data sets and single-model runs.
  - For large data sets, multi-node compute clusters or graphics processing unit (GPU) clusters are available. These clusters use libraries and frameworks like HorovodRunner and Hyperopt for parallel-model runs.

- [Data Lake Storage][Data Lake Storage] is a scalable and secure data lake for high-performance analytics workloads. This service manages multiple petabytes of information while sustaining hundreds of gigabits of throughput. The data can have these characteristics:

  - Be structured, semi-structured, or unstructured.
  - Come from multiple, heterogeneous sources like logs, files, and media.
  - Be static, from batches, or streaming.

- [Delta Lake][Delta Lake] is a storage layer that uses an open file format. This layer runs on top of cloud storage such as Data Lake Storage. Delta Lake is optimized for transforming and cleansing batch and streaming data. This platform supports these features and functionality:

  - Data versioning and rollback.
  - Atomicity, consistency, isolation, and durability (ACID) transactions for reliability.
  - A consistent standard for data preparation, model training, and model serving.
  - Time travel for consistent snapshots of source data. Data scientists can train models on the snapshots instead of creating separate copies.

- [MLflow][MLflow] is an open-source platform for the machine learning life cycle. MLflow components monitor machine learning models during training and running. Stored information includes code, data, configuration information, and results. MLflow also stores models and loads them in production. Because MLflow uses open frameworks, various services, applications, frameworks, and tools can consume the models.

- [Machine Learning][Machine Learning] is a cloud-based environment that helps you build, deploy, and manage predictive analytics solutions. With these models, you can forecast behavior, outcomes, and trends.

- [AKS][AKS] is a highly available, secure, and fully managed Kubernetes service. AKS makes it easy to deploy and manage containerized applications.

## Scenario details

As your organization recognizes the power of data science and machine learning, you can improve efficiency, enhance customer experiences, and predict changes. To achieve these goals in business-critical use cases, you need a consistent and reliable pattern for:

- Tracking experiments.
- Reproducing results.
- Deploying machine learning models into production.

This article outlines a solution for a consistent, reliable machine learning framework. Azure Databricks forms the core of the architecture. The storage layer Delta Lake and the machine learning platform MLflow also play significant roles. These components integrate seamlessly with other services such as Azure Data Lake Storage, Azure Machine Learning, and Azure Kubernetes Service (AKS).

Together, these services provide a solution for data science and machine learning that's:

- **Simple**: An open data lake simplifies the architecture. The data lake contains a curated layer, Delta Lake. That layer provides access to the data in an open-source format.

- **Open**: The solution supports open-source code, open standards, and open frameworks. This approach minimizes the need for future updates. Azure Databricks and Machine Learning natively support MLflow and Delta Lake. Together, these components provide industry-leading *machine learning operations (MLOps)*, or DevOps for machine learning. A broad range of deployment tools integrate with the solution's standardized model format.

- **Collaborative**: Data science and MLOps teams work together with this solution. These teams use MLflow tracking to record and query experiments. The teams also deploy models to the central MLflow model registry. Data engineers then use deployed models in data ingestion, extract-transform-load (ETL) processes, and streaming pipelines.

### Potential use cases

A [platform that AGL built for energy forecasting][AGL achieves machine learning at scale with a standardized platform on Azure Machine Learning] inspired this solution. That platform provides quick and cost-effective training, deployment, and life-cycle management for thousands of parallel models.

Besides energy providers, this solution can benefit any organization that:

- Uses data science.
- Builds and trains machine learning models.
- Runs machine learning models in production.

Examples include organizations in:

- Retail and e-commerce.
- Banking and finance.
- Healthcare and life sciences.
- Automotive industries and manufacturing.

## Next steps

- [AGL Energy][AGL achieves machine learning at scale with a standardized platform on Azure Machine Learning] builds a standardized platform for thousands of parallel models. The platform provides quick and cost-effective training, deployment, and life-cycle management for the models.
- [Open Grid Europe (OGE)][Open Grid Europe (OGE)] uses artificial intelligence models to monitor gas pipelines. OGE uses Azure Databricks and MLflow to develop the models.
- [Scandinavian Airlines (SAS)][Scandinavian Airlines (SAS)] uses Azure Databricks during a collaborative research phase. The airline also uses Machine Learning to develop predictive models. By identifying patterns in the company's data, the models improve everyday operations.

## Related resources

- [Choose an analytical data store in Azure][Choose an analytical data store in Azure]
- [Batch scoring of Spark models on Azure Databricks][Batch scoring of Spark models on Azure Databricks]
- [Stream processing with Azure Databricks][Stream processing with Azure Databricks]
- [Ingestion, ETL, and stream processing pipelines with Azure Databricks][Ingestion, ETL, and stream processing pipelines with Azure Databricks]
- [Modern analytics architecture with Azure Databricks][Modern analytics architecture with Azure Databricks]

[AGL achieves machine learning at scale with a standardized platform on Azure Machine Learning]: https://customers.microsoft.com/story/844796-agl-energy-azure
[AKS]: https://azure.microsoft.com/services/kubernetes-service
[Azure Databricks]: https://azure.microsoft.com/services/databricks
[Batch scoring of Spark models on Azure Databricks]: ../../reference-architectures/ai/batch-scoring-databricks.yml
[Choose an analytical data store in Azure]: ../../data-guide/technology-choices/analytical-data-stores.md
[Data Lake Storage]: https://azure.microsoft.com/services/storage/data-lake-storage
[Delta Lake]: https://databricks.com/product/delta-lake-on-databricks
[Ingestion, ETL, and stream processing pipelines with Azure Databricks]: ./ingest-etl-stream-with-adb.yml
[Machine Learning]: https://azure.microsoft.com/services/machine-learning
[MLflow]: https://mlflow.org
[Modern analytics architecture with Azure Databricks]: ./azure-databricks-modern-analytics-architecture.yml
[Open Grid Europe (OGE)]: https://customers.microsoft.com/story/1378282338316029794-open-grid-europe-azure-en
[Scandinavian Airlines (SAS)]: https://customers.microsoft.com/story/781802-sas-travel-transportation-azure-machine-learning
[Stream processing with Azure Databricks]: ../../reference-architectures/data/stream-processing-databricks.yml
[Visio version of architecture diagram]: https://arch-center.azureedge.net/US-1862911-azure-databricks-data-science-machine-learning-architecture-diagram.vsdx

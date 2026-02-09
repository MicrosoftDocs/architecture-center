This article describes an architecture for many models that uses Azure Machine Learning and compute clusters. A many-models architecture provides versatility for situations that require complex setup.

## Architecture

:::image type="complex" border="false" source="_images/many-models-machine-learning-azure.svg" alt-text="Diagram that shows the many-models architecture." lightbox="_images/many-models-machine-learning-azure.svg":::
   This diagram illustrates the many models architecture. It starts with data ingestion, where Azure Data Factory transfers data to Azure Data Lake Storage and stores it in a Machine Learning data store as a tabular dataset. The model-training pipeline prepares and groups data into datasets to train multiple models in parallel, then registers them and their metrics. The model-promotion pipeline evaluates models and registers those that meet the criteria for deployment. The batch-scoring pipeline scores datasets in parallel and writes results to Data Lake Storage, with real-time scoring handled through a managed online endpoint. Predictions and metrics are saved in Synapse SQL, where Power BI retrieves them for presentation.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/many-models-machine-learning-azure.vsdx) of this architecture.*

### Dataflow

The following dataflow corresponds to the previous diagram:

1. **Data ingestion:**

   1. Azure Data Factory retrieves data from a source database and copies it to Azure Data Lake Storage.

   1. The data is then stored in a Machine Learning data store as a tabular dataset.

1. **Model-training pipeline:**

   1. **Prepare data:**

      1. The training pipeline retrieves the data from the data store and transforms it as needed.

      1. The data is grouped into datasets for training the models.

   1. **Train models:**

      1. The pipeline trains models for all the datasets created during data preparation.

      1. It uses the `ParallelRunStep` class to train multiple models in parallel.

      1. After the models are trained, the pipeline registers the models and their testing metrics in Machine Learning.

1. **Model-promotion pipeline:**

   1. **Evaluate models:**

      1. The promotion pipeline evaluates the trained models before it moves them to production.

      1. A DevOps pipeline applies business logic to determine whether a model meets the criteria for deployment. For example, it might verify that the accuracy on testing data exceeds 80%.

   1. **Register models:**

      1. The promotion pipeline registers qualifying models into the production Machine Learning workspace.

1. **Model batch-scoring pipeline:**

   1. **Prepare data:**

      1. The batch-scoring pipeline retrieves data from the data store and transforms each file as needed.

      1. The data is grouped into datasets for scoring.

   1. **Score models:**

      1. The pipeline uses the `ParallelRunStep` class to score multiple datasets in parallel.

      1. It identifies the appropriate model for each dataset in Machine Learning by searching model tags.

      1. The model is downloaded and used to score the dataset.

      1. The `DataTransferStep` class writes the results back to Azure Data Lake.

      1. Predictions are passed from Azure Data Lake to Synapse SQL for serving.

      1. The managed online endpoint provides real-time scoring.

      1. Because of the large number of models, they're loaded on demand instead of pre-loaded.

1. **Results:**

   - **Predictions:** The batch-scoring pipeline saves predictions to Synapse SQL.

   - **Metrics:** Microsoft Power BI connects to the model predictions to retrieve and aggregate results for presentation.

### Components  

- [Azure Data Factory](/azure/data-factory/introduction) is a cloud-based data integration service that allows the creation of data-driven workflows for orchestrating and automating data movement and transformation. In this architecture, Azure Data Factory ingests enterprise data and third-party metadata into Data Lake Storage.

- [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) is a set of developer services that provide comprehensive application and infrastructure lifecycle management. It includes tools for continuous integration and continuous delivery (CI/CD) pipelines, work tracking, source control, build pipelines, package management, and testing solutions. In this architecture, Azure DevOps is used to manage CI/CD pipelines for automating model promotion, testing, and deployment to production environments.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a fully managed relational cloud database. In this architecture, SQL Database is used to store structured data that might be queried or analyzed as part of the data pipeline.

- [Azure Stream Analytics](/azure/stream-analytics/stream-analytics-introduction) is a real-time analytics and complex event-processing service designed to analyze and process high volumes of fast streaming data. In this architecture, Stream Analytics can be used for real-time data processing.

- [Azure Synapse Analytics](/azure/synapse-analytics/overview-what-is) is an analytics service that unifies data integration, enterprise data warehousing, and big data analytics. It's used in this architecture to store batch-scoring results. This approach enables efficient querying and retrieval of predictions for reporting or analysis. Synapse SQL is used to serve predictions to downstream applications and enable visualization tools like Power BI to access aggregated results.

- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a massively scalable and secure storage service for high-performance analytics workloads. In this architecture, Data Lake Storage serves as the primary storage layer for raw and transformed datasets, and for storing results from scoring pipelines.

- [Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is an enterprise-grade machine learning service for building and deploying models quickly. It provides users at all skill levels with tools such as a low-code designer, automated machine learning, and a hosted Jupyter notebook environment that supports various integrated development environments. In this architecture, Machine Learning is used to manage the lifecycle of models, including training, evaluation, and deployment. It also orchestrates pipelines for tasks such as training, promotion, and scoring.

  - [Managed online endpoints](/azure/machine-learning/how-to-deploy-online-endpoints) are a feature of Machine Learning used for real-time scoring. In this architecture, a managed online endpoint helps provide a scalable and secure way to serve predictions in near real-time by loading machine learning models on demand.

  - The [ParallelRunStep class](/python/api/azureml-pipeline-steps/azureml.pipeline.steps.parallelrunstep) is a component of Machine Learning pipelines used to run parallel jobs efficiently. It enables scalable processing of batch tasks, such as training or scoring many models simultaneously. In this architecture, the `ParallelRunStep` class is used in both the model-training and batch-scoring pipelines to train or score multiple datasets or models in parallel, which significantly reduces the runtime of these operations.

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a collection of software services, apps, and connectors that work together to turn unrelated sources of data into coherent, visually immersive, and interactive insights. In this architecture, Power BI connects to Synapse SQL to retrieve and present predictions and aggregated metrics through interactive dashboards.
  
### Alternatives

- You can use any database for source data.

- You can use Azure Kubernetes Service (AKS) for real-time inferencing instead of managed online endpoints. AKS allows you to deploy containerized models and provides more control over deployment. These capabilities enable dynamic loading of models to handle incoming requests without depleting resources.

## Scenario details

Many machine learning problems are too complex for a single machine learning model to solve. Whether it's predicting sales for every item of every store or modeling maintenance for hundreds of oil wells, having a model for each instance might improve results on many machine learning problems. This *many models* pattern is common across a wide range of industries, and has many real-world use cases. With the use of Machine Learning, an end-to-end many models pipeline can include model training, batch-inferencing deployment, and real-time deployment.

A many models solution requires a different dataset for every model during training and scoring. For instance, if the task is to predict sales for each item in every store, each dataset corresponds to a unique item-store combination.

### Potential use cases

- **Retail:** A grocery store chain needs to create a separate revenue forecast model for each store and item, totaling over 1,000 models for each store.

- **Supply chain:** For each combination of warehouse and product, a distribution company needs to optimize inventory.

- **Restaurants:** A chain with thousands of franchises needs to forecast the demand for each franchise.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

- **Data partitions:** Dividing the data into partitions is essential for implementing the many models pattern. If you want one model for each store, each dataset contains all the data for a single store, so there are as many datasets as there are stores. If you want to model products by store, there's a dataset for every combination of product and store. Depending on the source data format, it might be easy to partition the data, or it might require extensive data shuffling and transformation. Spark and Synapse SQL scale well for these tasks, while Python pandas doesn't because it runs on a single node and process.

- **Model management:** The training and scoring pipelines identify and invoke the right model for each dataset. They do this by calculating tags that characterize the dataset, and then use the tags to find the matching model. The tags identify the data partition key and the model version, and might also provide other information.

- **Choose the right architecture:**

  - Spark is suitable when your training pipeline has complex data transformation and grouping requirements. It provides flexible splitting and grouping techniques to group data by combinations of characteristics, such as product-store or location-product. The results can be placed in a Spark DataFrame for use in subsequent steps.
  
  - If your machine learning training and scoring algorithms are straightforward, you might be able to partition data with libraries such as scikit-learn. In this scenario, you might not need Spark, so you can avoid possible complexities that arise when you install Azure Synapse Analytics or Azure Databricks.
  
  - If your training datasets are already created, like when they're stored in separate files or organized into distinct rows or columns, you don't need Spark for complex data transformations.
  
  - The Machine Learning and compute clusters solution provides versatility for situations that require complex setup. For example, you can make use of a custom Docker container, download files, or download pretrained models. Computer vision and natural language processing deep learning are examples of applications that might require this versatility.

- **Separate model repos:** To protect the deployed models, consider storing them in their own repository that the training and testing pipelines don't access.

- **ParallelRunStep class:** The Python [ParallelRunStep class](/python/api/azureml-pipeline-steps/azureml.pipeline.steps.parallelrunstep) is a powerful option for running many models training and inferencing. It can partition your data in various ways and then apply your machine learning script on elements of the partition in parallel. Like other forms of Machine Learning training, you can specify a custom training environment that has access to Python Package Index (PyPI) packages, or a more advanced custom Docker environment for configurations that require more than standard PyPI. There are many CPUs and GPUs to choose from.

- **Online inferencing:** If a pipeline loads and caches all models from the beginning, the models might deplete the container's memory. Therefore, load the models on demand in the run method, even though it might increase latency slightly.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

To better understand the cost to run this scenario on Azure, use the [pricing calculator](https://azure.microsoft.com/pricing/calculator). You should assume that:

- The serving models are trained daily to keep them current.

- You need about 30 minutes to process a dataset that contains 40 million rows of 10 thousand unique store-product combinations. The dataset trains on Azure Databricks by using a cluster that's provisioned with 12 virtual machines (VMs) that use Ls16_v2 instances. Batch scoring with the same set of data takes about 20 minutes.

- You can use Machine Learning to deploy real-time inferencing. Depending on your request volume, choose a suitable type of VM and cluster size.

- An AKS cluster automatically scales as needed, which results in an average of two active nodes each month.

To see how pricing differs for your use case, change the variables in the pricing calculator to match your expected data size and serving load requirements. For larger or smaller training data sizes, increase or decrease the size of the Azure Databricks cluster. To handle more concurrent users during model serving, increase the AKS cluster size.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [James Nguyen](https://www.linkedin.com/in/james-nguyen-6575a431/) | Principal Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Configure a Kubernetes cluster for Machine Learning](https://github.com/Azure/AML-Kubernetes#azure-arc-enabled-machine-learning)
- [ParallelRunStep class](/python/api/azureml-pipeline-steps/azureml.pipeline.steps.parallelrunstep?view=azure-ml-py)
- [DataTransferStep class](/python/api/azureml-pipeline-steps/azureml.pipeline.steps.data_transfer_step.datatransferstep)
- [Create datastores](/azure/machine-learning/how-to-datastore)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [Deploy a model to an AKS cluster](/azure/machine-learning/how-to-deploy-azure-kubernetes-service?tabs=python)

## Related resources

- [Analytics architecture design](../../solution-ideas/articles/analytics-get-started.md)
- [Choose an analytical data store in Azure](../../data-guide/technology-choices/analytical-data-stores.md)
- [Choose a data analytics technology in Azure](../../data-guide/technology-choices/analysis-visualizations-reporting.md)

 This article describes an architecture for many models that uses Machine Learning and compute clusters. It provides great versatility for situations that require complex setup.

A companion article, [Many models machine learning at scale in Azure with Spark](many-models-machine-learning-azure-spark.yml), uses Apache Spark in either Azure Databricks or Azure Synapse Analytics.

## Architecture

:::image type="content" source="_images/many-models-machine-learning-azure.png" alt-text="Architecture diagram for many models machine learning at scale on Azure with Azure Machine Learning." lightbox="_images/many-models-machine-learning-azure.png":::

*Download a [Visio file](https://arch-center.azureedge.net/many-models-machine-learning-azure.vsdx) of this architecture.*

### Workflow  

1. **Data Ingestion:**
   - Azure Data Factory pulls data from a source database and copies it to Azure Data Lake Storage.
   - The data is then stored in a Machine Learning datastore as a tabular dataset.

1. **Model-Training Pipeline:**
   1. **Prepare Data:**
      - The training pipeline pulls the data from the datastore and transforms it further, as needed.
      - The data is grouped into datasets for training the models.
   2. **Train Models:**
      - The pipeline trains models for all the datasets created during data preparation.
      - It uses the `ParallelRunStep` class to train multiple models in parallel.
      - After training, the pipeline registers the models in Machine Learning along with their testing metrics.  

1. **Model-Promotion Pipeline:**
   1. **Evaluate Models:**
      - The promotion pipeline evaluates the trained models before moving them to production.
      - A DevOps pipeline applies business logic to determine whether a model meets the criteria for deployment (e.g., checking that the accuracy on testing data exceeds 80%).
   1. **Register Models:**
      - The promotion pipeline registers qualifying models into the production Machine Learning workspace.  

1. **Model Batch-Scoring Pipeline:**
   1. **Prepare Data:**
      - The batch-scoring pipeline pulls data from the datastore and transforms each file further, as needed.
      - The data is grouped into datasets for scoring.
   1. **Score Models:**
      - The pipeline uses the `ParallelRunStep` class to score multiple datasets in parallel.
      - It identifies the appropriate model for each dataset in Machine Learning by searching model tags.
      - The model is downloaded and used to score the dataset.
      - The `DataTransferStep` class is used to write the results back to Azure Data Lake.
      - Predictions are then passed from Azure Data Lake to Synapse SQL for serving.  

1. **Real-Time Scoring:**
   - Managed Online Endpoint is used to provide real-time scoring.
   - Because of the large number of models, they are loaded on demand rather than pre-loaded.  

1. **Results:**
   - **Predictions:** The batch-scoring pipeline saves predictions to Synapse SQL.
   - **Metrics:** Power BI connects to the model predictions to retrieve and aggregate results for presentation.  

### Components  

- [Azure Data Factory](/azure/data-factory/introduction) is a cloud-based data integration service that allows the creation of data-driven workflows for orchestrating and automating data movement and transformation. In this architecture, Azure Data Factory is used to ingest enterprise data and third-party metadata into Azure Data Lake Storage.

- [Azure Stream Analytics](/azure/stream-analytics/overview) is a real-time analytics and complex event-processing service designed to analyze and process high volumes of fast streaming data. In this architecture, Azure Stream Analytics could potentially be used for real-time data processing, although it is not explicitly shown in the workflow.

- [Azure Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is an enterprise-grade machine learning service for building and deploying models quickly. It provides users at all skill levels with tools such as a low-code designer, automated ML (AutoML), and a hosted Jupyter notebook environment that supports various IDEs. In this architecture, Azure Machine Learning is used to manage the lifecycle of machine learning models, including training, evaluation, deployment, and orchestrating pipelines like training, promotion, and scoring.

  [Managed Online Endpoint](/azure/machine-learning/how-to-deploy-online-endpoints) is a feature of Azure Machine Learning used for real-time scoring. In this architecture, it provides a scalable and secure way to serve predictions in near real-time by loading machine learning models on demand.  

- [ParallelRunStep](/azure/machine-learning/how-to-use-parallel-run-step) is a component of Azure Machine Learning pipelines used for running parallel jobs efficiently. It enables scalable execution of batch processes, such as training or scoring many models simultaneously. In this architecture, the `ParallelRunStep` is used in both the model-training and batch-scoring pipelines to train or score multiple datasets or models in parallel, significantly reducing the runtime of these operations.
  
- [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a massively scalable and secure storage service for high-performance analytics workloads. In this architecture, Azure Data Lake Storage serves as the primary storage layer for raw and transformed datasets, as well as for storing results from scoring pipelines.  
  
- [Azure Synapse Analytics](/azure/synapse-analytics/overview-what-is) is an analytics service that unifies data integration, enterprise data warehousing, and big data analytics. It is used in this architecture to store batch-scoring results, enabling efficient querying and retrieval of predictions for reporting or analysis. Synapse SQL is specifically used to serve predictions to downstream applications and enable visualization tools like Power BI to access aggregated results.  
  
- [Azure SQL Database](/azure/sql-database/sql-database-technical-overview) is a fully managed relational database as a service. In this architecture, Azure SQL Database is used to store structured data that may be queried or analyzed as part of the data pipeline.  
  
- [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) is a set of developer services that provide comprehensive application and infrastructure lifecycle management. It includes tools for work tracking, source control, build and CI/CD, package management, and testing solutions. In this architecture, Azure DevOps is used to manage CI/CD pipelines for automating model promotion, testing, and deployment to production environments.  
  
- [Microsoft Power BI](/power-bi/fundamentals/power-bi-overview) is a collection of software services, apps, and connectors that work together to turn unrelated sources of data into coherent, visually immersive, and interactive insights. In this architecture, Power BI connects to Synapse SQL to retrieve and present predictions and aggregated metrics through interactive dashboards.  
  


### Alternatives

- The source data can come from any database.
- You can use Azure Kubernetes Service (AKS) for real-time inferencing instead of Managed Online Endpoints. AKS allows deploying containerized models and provides more control over deployment, enabling dynamic loading of models to handle incoming requests without exhausting resources.

## Scenario details

Many machine learning problems are too complex for a single machine learning model to solve. Whether it's predicting sales for every item of every store, or modeling maintenance for hundreds of oil wells, having a model for each instance might improve results on many machine learning problems. This *many models* pattern is common across a wide variety of industries, and has many real-world use cases. With the use of Azure Machine Learning, an end-to-end many models pipeline can include model training, batch-inferencing deployment, and real-time deployment.

A many models solution requires a different dataset for every model during training and scoring. For instance, if the task is to predict sales for every item of every store, every dataset will be for a unique item-store combination.

### Potential use cases

- **Retail:** A grocery store chain needs to create a separate revenue forecast model for each store and item, totaling over 1,000 models per store.
- **Supply chain:** For each combination of warehouse and product, a distribution company needs to optimize inventory.
- **Restaurants:** A chain with thousands of franchises needs to forecast the demand for each.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

- **Data partitions** Partitioning the data is the key to implementing the many models pattern. If you want one model per store, a dataset comprises all the data for one store, and there are as many datasets as there are stores. If you want to model products by store, there will be a dataset for every combination of product and store. Depending on the source data format, it might be easy to partition the data, or it might require extensive data shuffling and transformation. Spark and Synapse SQL scale very well for such tasks, while Python pandas doesn't, since it runs only on one node and process.
- **Model management:** The training and scoring pipelines identify and invoke the right model for each dataset. To do this, they calculate tags that characterize the dataset, and then use the tags to find the matching model. The tags identify the data partition key and the model version, and might also provide other information.
- **Choosing the right architecture:**
  - Spark is appropriate when your training pipeline has complex data transformation and grouping requirements. It provides flexible splitting and grouping techniques to group data by combinations of characteristics, such as product-store or location-product. The results can be placed in a Spark DataFrame for use in subsequent steps.
  - When your machine learning training and scoring algorithms are straightforward, you might be able to partition data with libraries such as scikit-learn. In such cases, you might not need Spark, so you can avoid possible complexities that can arise when installing Azure Synapse or Azure Databricks.
  - When the training datasets are already created—for example, they're in separate files or in separate rows or columns—you don't need Spark for complex data transformations.
  - The Machine Learning and compute clusters solution provides great versatility for situations that require complex setup. For example, you can make use of a custom Docker container, or download files, or download pre-trained models. Computer vision and natural language processing (NLP) deep learning are examples of applications that might require such versatility.
- **Separate model repos:** To protect the deployed models, consider storing them in their own repository that the training and testing pipelines don't touch.
- **ParallelRunStep Class:** The Python [ParallelRunStep Class](/python/api/azureml-pipeline-steps/azureml.pipeline.steps.parallelrunstep?view=azure-ml-py) is a powerful option to run many models training and inferencing. It can partition your data in a variety of ways, and then apply your machine learning script on elements of the partition in parallel. Like other forms of Machine Learning training, you can specify a custom training environment with access to Python Package Index (PyPI) packages, or a more advanced custom Docker environment for configurations that require more than standard PyPI. There are many CPUs and GPUs to choose from.
- **Online inferencing:** If a pipeline loads and caches all models at the start, the models might exhaust the container's memory. Therefore, load the models on demand in the run method, even though it might increase latency slightly.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

To better understand the cost of running this scenario on Azure, use the [pricing calculator](https://azure.microsoft.com/pricing/calculator). Good starting assumptions are:

- The serving models are trained daily to keep them current.
- For a dataset of 40 million rows with 10 thousand combinations of store and product, training on Azure Databricks using a cluster provisioned with 12 VMs that use Ls16_v2 instances, takes about 30 minutes.
- Batch scoring with the same set of data takes about 20 minutes.
- You can use Machine Learning to deploy real-time inferencing. Depending on your request volume, choose an appropriate VM type and cluster size.
- An AKS cluster autoscales as needed, resulting in two nodes per month being active on average.

To see how pricing differs for your use case, change the variables to match your expected data size and serving load requirements. For larger or smaller training data sizes, increase or decrease the size of the Azure Databricks cluster. To handle more concurrent users during model serving, increase the AKS cluster size.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [James Nguyen](https://www.linkedin.com/in/james-nguyen-6575a431/) | Principal Cloud Solution Architect

## Next steps

- [Configure a Kubernetes cluster for Azure Machine Learning](https://github.com/Azure/AML-Kubernetes#azure-arc-enabled-machine-learning)
- [Many Models Solution Accelerator GitHub repository](https://github.com/microsoft/solution-accelerator-many-models#many-models-solution-accelerator)
- [ParallelRunStep Class](/python/api/azureml-pipeline-steps/azureml.pipeline.steps.parallelrunstep?view=azure-ml-py)
- [DataTransferStep Class](/python/api/azureml-pipeline-steps/azureml.pipeline.steps.data_transfer_step.datatransferstep)
- [Connect to storage services on Azure](/azure/machine-learning/how-to-access-data)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [Deploy a model to an Azure Kubernetes Service cluster](/azure/machine-learning/how-to-deploy-azure-kubernetes-service?tabs=python)

## Related resources

- [Analytics architecture design](../../solution-ideas/articles/analytics-start-here.yml)
- [Choose an analytical data store in Azure](../../data-guide/technology-choices/analytical-data-stores.md)
- [Choose a data analytics technology in Azure](../../data-guide/technology-choices/analysis-visualizations-reporting.md)
- [Many models machine learning at scale in Azure with Spark](many-models-machine-learning-azure-spark.yml)

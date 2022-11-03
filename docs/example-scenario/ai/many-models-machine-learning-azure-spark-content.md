 This article describes an architecture for many models that uses Apache Spark in either Azure Databricks or Azure Synapse Analytics. Spark is a powerful tool for the large and complex data transformations that some solutions require.

> [!Note]
> Use Spark versions 3.0 and later for many models applications. The data transformation capabilities and support for Python and pandas are much better than in earlier versions.

A companion article, [Many models machine learning (ML) at scale with Azure Machine Learning](many-models-machine-learning-azure-machine-learning.yml), uses Machine Learning and compute clusters.

## Architecture

:::image type="content" source="media/many-models-machine-learning-azure-spark.png" alt-text="Architecture diagram for many models machine learning at scale on Azure with Spark." lightbox="media/many-models-machine-learning-azure-spark.png":::

*Download a [Visio file](https://arch-center.azureedge.net/many-models-machine-learning-azure-spark.vsdx) of this architecture.*

### Dataflow

1. **Data ingestion:**
   Azure Data Factory pulls data from a source database and copies it to Azure Data Lake Storage.
1. **Model-training pipeline:**
   1. **Prepare data:** The training pipeline pulls the data from Data Lake Storage and uses Spark to group it into datasets for training the models.
   1. **Train models:** The pipeline trains models for all the datasets that were created during data preparation. It uses the pandas function API to train multiple models in parallel. After a model is trained, the pipeline registers it into Machine Learning along with the testing metrics.
1. **Model-promotion pipeline:**
   1. **Evaluate models:** The promotion pipeline evaluates the trained models before moving them to production. A DevOps pipeline applies business logic to determine whether a model meets the criteria for deployment. For example, it might check that the accuracy of the testing data is over 80 percent.
   1. **Register models:** The promotion pipeline registers the models that qualify to the production Machine Learning workspace.
1. **Model batch-scoring pipeline:**
   1. **Prepare data:** The batch-scoring pipeline pulls data from Data Lake Storage and uses Spark to group it into datasets for scoring.
   1. **Score models:** The pipeline uses the pandas function API to score multiple datasets in parallel. It finds the appropriate model for each dataset in Machine Learning by searching the model tags. Then it downloads the model and uses it to score the dataset. It uses the Spark connector to Synapse SQL to retain the results.
1. **Real-time scoring:** Azure Kubernetes Service (AKS) can do real-time scoring if needed. Because of the large number of models, they should be loaded on demand, not pre-loaded.
1. **Results:**
   1. **Predictions:** The batch-scoring pipeline saves predictions to Synapse SQL.
   1. **Metrics:** Power BI connects to the model predictions to retrieve and aggregate results for presentation.

### Components

- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is an enterprise-grade ML service for building and deploying models quickly. It provides users at all skill levels with a low-code designer, automated ML (AutoML), and a hosted Jupyter notebook environment that supports various IDEs.
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is an analytics service that unifies data integration, enterprise data warehousing, and big data analytics.
- Synapse SQL is a distributed query system for T-SQL that enables data warehousing and data virtualization scenarios and extends T-SQL to address streaming and ML scenarios. It offers both serverless and dedicated resource models.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) is a massively scalable and secure storage service for high-performance analytics workloads.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications. AKS simplifies deployment of a managed AKS cluster in Azure by offloading the operational overhead to Azure.
- [Azure DevOps](https://azure.microsoft.com/services/devops) is a set of developer services that provide comprehensive application and infrastructure lifecycle management. DevOps includes work tracking, source control, build and CI/CD, package management, and testing solutions.
- [Microsoft Power BI](https://powerbi.microsoft.com) is a collection of software services, apps, and connectors that work together to turn unrelated sources of data into coherent, visually immersive, and interactive insights.

### Alternatives

- You can use Spark in Azure Synapse instead of Spark in Azure Databricks for model training and scoring.
- The source data can come from any database.
- You can use a managed online endpoint or AKS to deploy real-time inferencing.

## Scenario details

Many machine learning (ML) problems are too complex for a single ML model to solve. Whether it's predicting sales for every item of every store, or modeling maintenance for hundreds of oil wells, having a model for each instance might improve results on many ML problems. This *many models* pattern is very common across a wide variety of industries, and applies to many real-world use cases. With the use of Azure Machine Learning, an end-to-end many models pipeline can include model training, batch-inferencing deployment, and real-time deployment.

A many models solution requires a different dataset for every model during training and scoring. For instance, if the task is to predict sales for every item of every store, every dataset will be for a unique item-store combination.

### Potential use cases

- **Retail:** A grocery store chain needs to create a separate revenue forecast model for each store and item, totaling over 1,000 models per store.
- **Supply chain:** For each combination of warehouse and product, a distribution company needs to optimize inventory.
- **Restaurants:** A chain with thousands of franchises needs to forecast the demand for each.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

- **Data partitions** Partitioning the data is the key to implementing the many models pattern. If you want one model per store, a dataset comprises all the data for one store, and there are as many datasets as there are stores. If you want to model products by store, there will be a dataset for every combination of product and store. Depending on the source data format, it might be easy to partition the data, or it can require extensive data shuffling and transformation. Spark and Synapse SQL scale very well for such tasks, while Python pandas doesn't, since it runs only on one node and process.
- **Model management:** The training and scoring pipelines identify and invoke the right model for each dataset. To do this, they calculate tags that characterize the dataset, and then use the tags to find the matching model. The tags identify the data partition key and the model version, and might also provide other information.
- **Choosing the right architecture:**
  - Spark is appropriate when your training pipeline has complex data transformation and grouping requirements. It provides flexible splitting and grouping techniques to group data by combinations of characteristics, such as product-store or location-product. The results can be placed in a Spark DataFrame for use in subsequent steps.
  - When your ML training and scoring algorithms are straightforward, you might be able to partition data with libraries such as Scikit-learn. In such cases, you might not need Spark, so you can avoid possible complexities that can arise when installing Azure Synapse or Azure Databricks.
  - When the training datasets are already created—for example, they're in separate files or in separate rows or columns—you don’t need Spark for complex data transformations.
  - The Machine Learning and compute clusters solution provides great versatility for situations that require complex setup. For example, you can make use of a custom Docker container, or download files, or download pre-trained models. Computer vision and natural language processing (NLP) deep learning are examples of applications that might require such versatility.
- **Spark training and scoring:** When you use the Spark architecture, you can use the Spark pandas function API for parallel training and scoring.
- **Separate model repos:** To protect the deployed models, consider storing them in their own repository that the training and testing pipelines don't touch.
- **Online inferencing:** If a pipeline loads and caches all models at the start, the models might exhaust the container's memory. Therefore, load the models on demand in the run method, even though it might increase latency slightly.
- **Training scalability:** By using Spark, you can train hundreds of thousands of models in parallel. Spark spins up multiple training processes in every VM in a cluster. Each core can run a separate process. While this means good utilization of resources, it's important to size the cluster accurately and choose the right SKU, especially if the training process is expensive and long running.
- **Implementation details:** For detailed information on implementing a many models solution, see [Implement many models for ML in Azure](https://github.com/microsoft/csa-misc-utils/tree/master/sa-dsml-many-models).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

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

- [James Nguyen](https://www.linkedin.com/in/james-nguyen-6575a431) | Principal Cloud Solution Architect

## Next steps

- [What are compute targets in Azure Machine Learning?](/azure/machine-learning/concept-compute-target)
- [Azure Arc-enabled Machine Learning](https://github.com/Azure/AML-Kubernetes#azure-arc-enabled-machine-learning)
- [Many Models Solution Accelerator](https://github.com/microsoft/solution-accelerator-many-models#many-models-solution-accelerator)
- [ParallelRunStep Class](/python/api/azureml-pipeline-steps/azureml.pipeline.steps.parallelrunstep?view=azure-ml-py)
- [pandas function APIs](/azure/databricks/spark/latest/spark-sql/pandas-function-apis)
- [Connect to storage services on Azure](/azure/machine-learning/how-to-access-data)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [Deploy a model to an Azure Kubernetes Service cluster](/azure/machine-learning/how-to-deploy-azure-kubernetes-service?tabs=python)

## Related resources

- [Analytics architecture design](../../solution-ideas/articles/analytics-start-here.yml)
- [Choose an analytical data store in Azure](../../data-guide/technology-choices/analytical-data-stores.md)
- [Choose a data analytics technology in Azure](../../data-guide/technology-choices/analysis-visualizations-reporting.md)
- [Many models machine learning (ML) at scale with Azure Machine Learning](many-models-machine-learning-azure-machine-learning.yml)
- [Batch scoring of Spark models on Azure Databricks](../../reference-architectures/ai/batch-scoring-databricks.yml)

This reference architecture shows how to build a scalable solution for batch scoring an Apache Spark classification model on a schedule using [Azure Databricks][databricks]. Azure Databricks is an Apache Spark-based analytics platform optimized for Azure. Azure Databricks offers three environments for developing data intensive applications: Databricks SQL, Databricks Data Science & Engineering, and Databricks Machine Learning. Databricks Machine Learning is an integrated end-to-end machine learning environment incorporating managed services for experiment tracking, model training, feature development and management, and feature and model serving. You can use this reference architecture as a template that can be generalized to other scenarios. A reference implementation for this architecture is available on [GitHub][github].

*Apache® and Apache Spark® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

![Diagram showing batch scoring of Apache Spark classification models on Azure Databricks.](./_images/batch-scoring-spark-models-databricks.svg)

*Download a [Visio file](https://arch-center.azureedge.net/batch-scoring-spark-models-databricks.vsdx) of this architecture.*

### Workflow

The architecture defines a data flow that is entirely contained within [Azure Databricks][databricks] based on a set of sequentially executed [notebooks][notebooks]. It consists of the following components:

**Data files**. The reference implementation uses a simulated data set contained in five static data files.

**Ingestion**. The data ingestion notebook downloads the input data files into a collection of Databricks data sets. In a real-world scenario, data from IoT devices would stream onto Databricks-accessible storage such as Azure SQL or Azure Blob storage. Databricks supports multiple [data sources][data-sources].

**Training pipeline**. This notebook executes the feature engineering notebook to create an analysis data set from the ingested data. It then executes a model building notebook that trains the machine learning model using the [Apache Spark MLlib][mllib] scalable machine learning library.

**Scoring pipeline**. This notebook executes the feature engineering notebook to create scoring data set from the ingested data and executes the scoring notebook. The scoring notebook uses the trained [Spark MLlib][mllib-spark] model to generate predictions for the observations in the scoring data set. The predictions are stored in the results store, a new data set on the Databricks data store.

**Scheduler**. A scheduled Databricks [job][job] handles batch scoring with the Spark model. The job executes the scoring pipeline notebook, passing variable arguments through notebook parameters to specify the details for constructing the scoring data set and where to store the results data set.

## Solution details

The scenario is constructed as a pipeline flow. Each notebook is optimized to perform in a batch setting for each of the operations: ingestion, feature engineering, model building, and model scorings. The feature engineering notebook is designed to generate a general data set for any of the training, calibration, testing, or scoring operations. In this scenario, we use a temporal split strategy for these operations, so the notebook parameters are used to set date-range filtering.

Because the scenario creates a batch pipeline, we provide a set of optional examination notebooks to explore the output of the pipeline notebooks. You can find these notebooks in the [GitHub repository notebooks folder][github]:

- `1a_raw-data_exploring.ipynb`
- `2a_feature_exploration.ipynb`
- `2b_model_testing.ipynb`
- `3b_model_scoring_evaluation.ipynb`

### Potential use cases

A business in an asset-heavy industry wants to minimize the costs and downtime associated with unexpected mechanical failures. Using IoT data collected from their machines, they can create a predictive maintenance model. This model enables the business to maintain components proactively and repair them before they fail. By maximizing mechanical component use, they can control costs and reduce downtime.

A predictive maintenance model collects data from the machines and retains historical examples of component failures. The model can then be used to monitor the current state of the components and predict if a given component will fail soon. For common use cases and modeling approaches, see [Azure AI guide for predictive maintenance solutions][ai-guide].

This reference architecture is designed for workloads that are triggered by the presence of new data from the component machines. Processing involves the following steps:

1. Ingest the data from the external data store onto an Azure Databricks data store.

1. Train a machine learning model by transforming the data into a training data set, then building a Spark MLlib model. MLlib consists of most common machine learning algorithms and utilities optimized to take advantage of Spark data scalability capabilities.

1. Apply the trained model to predict (classify) component failures by transforming the data into a scoring data set. Score the data with the Spark MLLib model.

1. Store results on the Databricks data store for post-processing consumption.

Notebooks are provided on [GitHub][github] to perform each of these tasks.

## Recommendations

Databricks is set up so you can load and deploy your trained models to make predictions with new data. Databricks also provides other advantages:

- Single sign-on support using Azure Active Directory credentials.
- Job scheduler to execute jobs for production pipelines.
- Fully interactive notebook with collaboration, dashboards, REST APIs.
- Unlimited clusters that can scale to any size.
- Advanced security, role-based access controls, and audit logs.

To interact with the Azure Databricks service, use the Databricks [Workspace][workspace] interface in a web browser or the [command-line interface][cli] (CLI). Access the Databricks CLI from any platform that supports Python 2.7.9 to 3.6.

The reference implementation uses [notebooks][notebooks] to execute tasks in sequence. Each notebook stores intermediate data artifacts (training, test, scoring, or results data sets) to the same data store as the input data. The goal is to make it easy for you to use it as needed in your particular use case. In practice, you would connect your data source to your Azure Databricks instance for the notebooks to read and write directly back into your storage.

Monitor job execution through the Databricks user interface, the data store, or the Databricks [CLI][cli] as necessary. Monitor the cluster using the [event log][log] and other [metrics][metrics] that Databricks provides.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Performance

An Azure Databricks cluster enables autoscaling by default so that during runtime, Databricks dynamically reallocates workers to account for the characteristics of your job. Certain parts of your pipeline may be more computationally demanding than others. Databricks adds extra workers during these phases of your job (and removes them when they're no longer needed). Autoscaling makes it easier to achieve high [cluster utilization][cluster], because you don't need to provision the cluster to match a workload.

Develop more complex scheduled pipelines by using [Azure Data Factory][adf] with Azure Databricks.

### Storage

In this reference implementation, the data is stored directly within Databricks storage for simplicity. In a production setting, however, you can store the data on cloud data storage such as [Azure Blob Storage][blob]. [Databricks][databricks-connect] also supports [Azure Data Lake Store][azure-data-lake], [Azure Synapse Analytics][azure-synapse], [Azure Cosmos DB][azure-cosmos], [Apache Kafka][apache-kafka], and [Apache Hadoop][apache-hadoop].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

In general, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs. Other considerations are described in the Cost section in [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/cost/overview).

Azure Databricks is a premium Spark offering with an associated cost. In addition, there are standard and premium Databricks [pricing tiers][pricing].

For this scenario, the standard pricing tier is sufficient. However, if your specific application requires automatically scaling clusters to handle larger workloads or interactive Databricks dashboards, the premium level could increase costs further.

The solution notebooks can run on any Spark-based platform with minimal edits to remove the Databricks-specific packages. See the following similar solutions for various Azure platforms:

- [SQL Server R services][sql-r]
- [PySpark on an Azure Data Science Virtual Machine][py-dvsm]

## Deploy this scenario

To deploy this reference architecture, follow the steps described in the [GitHub][github] repository to build a scalable solution for scoring Spark models in batch on Azure Databricks.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [John Ehrlinger](https://www.linkedin.com/in/ehrlinger) | Senior Applied Scientist
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Perform data science with Azure Databricks][learn1]
- [Deploy batch inference pipelines with Azure Machine Learning][learn2]
- [Tutorial: Build an Azure Machine Learning pipeline for batch scoring][aml-tut]

## Related resources

- [Build a Real-time Recommendation API on Azure][aac-recommendation]
- [Batch scoring for deep learning models using Azure Machine Learning pipelines][aac-batch-deep]
- [Batch scoring of Python Models on Azure][aac-batch-python]

<!-- links -->

[aac-batch-deep]: ../../reference-architectures/ai/batch-scoring-deep-learning.yml
[aac-batch-python]: ../../reference-architectures/ai/batch-scoring-python.yml
[aac-recommendation]: ../../reference-architectures/ai/real-time-recommendation.yml
[adf]: https://azure.microsoft.com/blog/operationalize-azure-databricks-notebooks-using-data-factory
[ai-guide]: /azure/machine-learning/team-data-science-process/cortana-analytics-playbook-predictive-maintenance
[aml-tut]: /azure/machine-learning/tutorial-pipeline-batch-scoring-classification
[apache-hadoop]: https://hadoop.apache.org
[apache-kafka]: https://kafka.apache.org
[azure-cosmos]: https://azure.microsoft.com/services/cosmos-db
[azure-data-lake]: https://azure.microsoft.com/services/storage/data-lake-storage
[azure-synapse]: https://azure.microsoft.com/services/synapse-analytics
[blob]: https://docs.databricks.com/spark/latest/data-sources/azure/azure-storage.html
[cli]: https://docs.databricks.com/user-guide/dev-tools/databricks-cli.html
[cluster]: /azure/databricks/clusters/configure
[databricks]: /azure/azure-databricks
[databricks-connect]: /azure/azure-databricks/databricks-connect-to-data-sources
[data-sources]: https://docs.databricks.com/spark/latest/data-sources/index.html
[github]: https://github.com/Azure/BatchSparkScoringPredictiveMaintenance
[job]: https://docs.databricks.com/user-guide/jobs.html
[learn1]: /training/paths/perform-data-science-azure-databricks
[learn2]: /training/modules/deploy-batch-inference-pipelines-with-azure-machine-learning
[log]: https://docs.databricks.com/user-guide/clusters/event-log.html
[metrics]: https://docs.databricks.com/user-guide/clusters/metrics.html
[mllib]: https://docs.databricks.com/spark/latest/mllib/index.html
[mllib-spark]: https://docs.databricks.com/spark/latest/mllib/index.html#apache-spark-mllib
[notebooks]: https://docs.databricks.com/user-guide/notebooks/index.html
[pricing]: https://azure.microsoft.com/pricing/details/databricks
[py-dvsm]: https://gallery.azure.ai/Tutorial/Predictive-Maintenance-using-PySpark
[sql-r]: https://gallery.azure.ai/Tutorial/Predictive-Maintenance-Modeling-Guide-using-SQL-R-Services-1
[workspace]: https://docs.databricks.com/user-guide/workspace.html

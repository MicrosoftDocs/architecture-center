---
ms.custom:
  - devx-track-python
---
This architecture guide shows how to build a scalable solution for batch scoring models [Azure Machine Learning][amls]. The solution can be used as a template and can generalize to different problems.

## Architecture

:::image type="content" alt-text="Architecture diagram that shows the batch scoring of Python models on Azure" source="./_images/batch-scoring-python.png" lightbox="./_images/batch-scoring-python.png":::

*Download a [Visio file](https://arch-center.azureedge.net/batch-scoring-python.vsdx) of this architecture.*

### Workflow

This architecture guide is applicable for both streaming and static data, provided that the ingestion process is adapted to the data type. The following steps and components describe the ingestion of these two types of data.

**Streaming data:**

1. Streaming data originates from IoT Sensors, where new events are streamed at frequent intervals.
2. Incoming streaming events are queued using Azure Event Hubs, and then pre-processed using Azure Stream Analytics.
    - [Azure Event Hubs][event-hubs]. This message ingestion service can ingest millions of event messages per second. In this architecture, sensors send a stream of data to the event hub.
    - [Azure Stream Analytics][stream-analytics]. An event-processing engine. A Stream Analytics job reads the data streams from the event hub and performs stream processing.

**Static data:**

3. Static datasets can be stored as files within [Azure Data Lake Storage][adls] or in tabular form in [Azure Synapse][synapse] or [Azure SQL Database][sql].
4. [Azure Data Factory][adf] can be used to aggregate or pre-process the stored dataset.

The remaining architecture, after data ingestion, is equal for both streaming and static data, and consists of the following steps and components:

5. The ingested, aggregated and/or pre-processed data can be stored as documents within [Azure Data Lake Storage][adls] or in tabular form in [Azure Synapse][synapse] or [Azure SQL Database][sql]. This data will then be consumed by Azure Machine Learning.
6. [Azure Machine Learning][amls] is used for training, deploying, and managing machine learning models at scale. In the context of batch scoring, Azure Machine Learning creates a cluster of virtual machines with an automatic scaling option, where jobs are executed in parallel as of Python scripts.
7. Models are deployed as [Managed Batch Endpoints][m-endpoints], which are then used to do batch inferencing on large volumes of data over a period of time. Batch endpoints receive pointers to data and run jobs asynchronously to process the data in parallel on compute clusters.
8. The inference results can be stored as documents within [Azure Data Lake Storage][adls] or in tabular form in [Azure Synapse][synapse] or [Azure SQL Database][sql].
9. Visualize: The stored model results can be consumed through user interfaces, such as Power BI dashboards, or through custom-built web applications.


### Components

- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs)
- [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics)
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database)
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/)
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/)
- [Azure Data Factory](https://azure.microsoft.com/services/data-factory/)
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning)
- [Azure Machine Learning Endpoints](/azure/machine-learning/concept-endpoints)
- [Microsoft Power BI on Azure](https://azure.microsoft.com/services/developer-tools/power-bi/)
- [Azure Web Apps](https://azure.microsoft.com/services/app-service/web/)

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Performance

For standard Python models, it's generally accepted that CPUs are sufficient to handle the workload. This architecture uses CPUs. However, for [deep learning workloads][deep], GPUs generally outperform CPUs by a considerable amount; a sizeable cluster of CPUs is usually needed to get comparable performance.

#### Parallelize across VMs versus cores

When you run scoring processes of many models in batch mode, the jobs need to be parallelized across VMs. Two approaches are possible:

- Create a larger cluster using low-cost VMs.
- Create a smaller cluster using high performing VMs with more cores available on each.

In general, scoring of standard Python models isn't as demanding as scoring of deep learning models, and a small cluster should be able to handle a large number of queued models efficiently. You can increase the number of cluster nodes as the dataset sizes increase.

For convenience in this scenario, one scoring task is submitted within a single [Azure Machine Learning pipeline][pipeline] step. However, it can be more efficient to score multiple data chunks within the same pipeline step. In those cases, write custom code to read in multiple datasets and execute the scoring script during a single-step execution.

### Management

- **Monitor jobs**. It's important to monitor the progress of running jobs. However, it can be a challenge to monitor across a cluster of active nodes. To inspect the state of the nodes in the cluster, use the [Azure portal][portal] to manage the [Machine Learning workspace][ml-workspace]. If a node is inactive or a job has failed, the error logs are saved to blob storage, and are also accessible in the **Pipelines** section. For richer monitoring, connect logs to [Application Insights][app-insights], or run separate processes to poll for the state of the cluster and its jobs.
- **Logging**. Machine Learning logs all stdout/stderr to the associated Azure Storage account. To easily view the log files, use a storage navigation tool such as [Azure Storage Explorer][explorer].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The most expensive components used in this architecture guide are the compute resources. The compute cluster size scales up and down depending on the jobs in the queue. Enable automatic scaling programmatically through the [Python SDK][python-sdk] by modifying the compute's provisioning configuration. Or, use the [Azure CLI][cli] to set the automatic scaling parameters of the cluster.

For work that doesn't require immediate processing, configure the automatic scaling formula so the default state (minimum) is a cluster of zero nodes. With this configuration, the cluster starts with zero nodes and only scales up when it detects jobs in the queue. If the batch scoring process happens only a few times a day or less, this setting enables significant cost savings.

Automatic scaling might not be appropriate for batch jobs that occur too close to each other. Because the time that it takes for a cluster to spin up and spin down incurs a cost, if a batch workload begins only a few minutes after the previous job ends, it might be more cost effective to keep the cluster running between jobs. This strategy depends on whether scoring processes are scheduled to run at a high frequency (every hour, for example), or less frequently (once a month, for example).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Carlos Alexandre Santos](https://www.linkedin.com/in/carlosafsantos) | Senior Specialized AI Cloud Solution Architect
- [Said Bleik](https://www.linkedin.com/in/said-bleik-34b55156) | Principal Applied Scientist Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Product documentation:

- [What is Azure Blob Storage?](/azure/storage/blobs/storage-blobs-overview)
- [Introduction to private Docker container registries in Azure](/azure/container-registry/container-registry-intro)
- [Azure Event Hubs](/azure/event-hubs/event-hubs-about)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [Welcome to Azure Stream Analytics](/azure/stream-analytics/stream-analytics-introduction)

Microsoft Learn modules:

- [Deploy Azure SQL Database](/training/modules/deploy-azure-sql-database)
- [Enable reliable messaging for Big Data applications using Azure Event Hubs](/training/modules/enable-reliable-messaging-for-big-data-apps-using-event-hubs)
- [Explore Azure Event Hubs](/training/modules/azure-event-hubs)
- [Implement a Data Streaming Solution with Azure Streaming Analytics](/training/paths/implement-data-streaming-with-asa)
- [Introduction to machine learning](/training/modules/introduction-to-machine-learning)
- [Manage container images in Azure Container Registry](/training/modules/publish-container-image-to-azure-container-registry)

## Related resources

- [Artificial intelligence (AI) - Architectural overview](../../data-guide/big-data/ai-overview.md)
- [Batch scoring for deep learning models using Azure Machine Learning pipelines](batch-scoring-deep-learning.yml)
- [Batch scoring of Spark models on Azure Databricks](batch-scoring-databricks.yml)
- [MLOps for Python models using Azure Machine Learning](mlops-python.yml)
- [Real-time scoring of machine learning models in Python](real-time-scoring-machine-learning-models.yml)
- [Tune hyperparameters for machine learning models in Python](/azure/architecture/example-scenario/ai/training-python-models)

[acr]: /azure/container-registry/container-registry-intro
[amls]: /azure/machine-learning/overview-what-is-azure-machine-learning
[batch-scoring]: /azure/machine-learning/service/how-to-run-batch-predictions
[cli]: /cli/azure
[create-resources]: https://github.com/microsoft/az-ml-batch-score/blob/master/01_DataPrep.ipynb
[deep]: ./batch-scoring-deep-learning.yml
[event-hubs]: /azure/event-hubs/event-hubs-geo-dr
[explorer]: https://azure.microsoft.com/features/storage-explorer
[github]: https://github.com/Microsoft/AMLBatchScoringPipeline
[one-class-svm]: http://scikit-learn.org/stable/modules/generated/sklearn.svm.OneClassSVM.html
[portal]: https://portal.azure.com
[python-sdk]: /python/api/overview/azure/ml/intro
[ml-workspace]: /azure/machine-learning/studio/create-workspace
[pipeline]: /azure/machine-learning/service/concept-ml-pipelines
[pyscript]: https://github.com/Microsoft/AMLBatchScoringPipeline/blob/master/scripts/predict.py
[storage]: /azure/storage/blobs/storage-blobs-overview
[stream-analytics]: /azure/stream-analytics
[sql-database]: /azure/sql-database
[app-insights]: /azure/application-insights/app-insights-overview
[synapse]: https://azure.microsoft.com/services/synapse-analytics/
[adls]: https://azure.microsoft.com/services/storage/data-lake-storage/
[adf]: https://azure.microsoft.com/services/data-factory/
[m-endpoints]: /azure/machine-learning/concept-endpoints
[sql]: https://azure.microsoft.com/products/azure-sql/database

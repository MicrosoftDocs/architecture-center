<!--cSpell:ignore njray precompute -->

This reference architecture shows how to train a recommendation model by using Azure Databricks, and then deploy the model as an API by using Azure Cosmos DB, Azure Machine Learning, and Azure Kubernetes Service (AKS). This architecture can be generalized for most recommendation engine scenarios, including recommendations for products, movies, and news.

For a reference implementation of this architecture see [Building a Real-time Recommendation API][als-example] on GitHub.

## Potential use cases

**Scenario**: A media organization wants to provide movie or video recommendations to its users. By providing personalized recommendations, the organization meets several business goals, including increased click-through rates, increased engagement on its website, and higher user satisfaction.

This solution is optimized for the retail industry and for the media and entertainment industries.

## Architecture

![Diagram showing architecture of a machine learning model for training movie recommendations.](_images/recommenders-architecture.png)

*Download a [Visio file](https://arch-center.azureedge.net/ai-real-time-recommendation.vsdx) of this architecture.*

This reference architecture is for training and deploying a real-time recommender service API that can provide the top 10 movie recommendations for a user.

### Dataflow

1. Track user behaviors. For example, a back-end service might log when a user rates a movie or clicks a product or news article.
1. Load the data into Azure Databricks from an available [data source][data-source].
1. Prepare the data and split it into training and testing sets to train the model. ([This guide][guide] describes options for splitting data.)
1. Fit the [Spark Collaborative Filtering][als] model to the data.
1. Evaluate the quality of the model using rating and ranking metrics. ([This guide][eval-guide] provides details about the metrics that you can use to evaluate your recommender.)
1. Precompute the top 10 recommendations per user and store as a cache in Azure Cosmos DB.
1. Deploy an API service to AKS using the Machine Learning APIs to containerize and deploy the API.
1. When the back-end service gets a request from a user, call the recommendations API hosted in AKS to get the top 10 recommendations and display them to the user.

### Components

- [Azure Databricks][databricks]. Databricks is a development environment used to prepare input data and train the recommender model on a Spark cluster. Azure Databricks also provides an interactive workspace to run and collaborate on notebooks for any data processing or machine learning tasks.
- [Azure Kubernetes Service][aks] (AKS). AKS is used to deploy and operationalize a machine learning model service API on a Kubernetes cluster. AKS hosts the containerized model, providing scalability that meets your throughput requirements, identity and access management, and logging and health monitoring.
- [Azure Cosmos DB][cosmosdb]. Cosmos DB is a globally distributed database service used to store the top 10 recommended movies for each user. Azure Cosmos DB is well-suited for this scenario, because it provides low latency (10 ms at 99th percentile) to read the top recommended items for a given user.
- [Machine Learning][mls]. This service is used to track and manage machine learning models, and then package and deploy these models to a scalable AKS environment.
- [Microsoft Recommenders][github]. This open-source repository contains utility code and samples to help users get started in building, evaluating, and operationalizing a recommender system.

## Considerations

[Batch scoring of Spark models on Azure Databricks][batch-scoring] describes a reference architecture that uses Spark and Azure Databricks to execute scheduled batch scoring processes. We recommend this approach for generating new recommendations.

### Performance efficiency

Performance is a primary consideration for real-time recommendations, because recommendations usually fall in the critical path of a user request on your website.

The combination of AKS and Azure Cosmos DB enables this architecture to provide a good starting point to provide recommendations for a medium-sized workload with minimal overhead. Under a load test with 200 concurrent users, this architecture provides recommendations at a median latency of about 60 ms and performs at a throughput of 180 requests per second. The load test was run against the default deployment configuration (a 3x D3 v2 AKS cluster with 12 vCPUs, 42 GB of memory, and 11,000 [Request Units (RUs) per second][ru] provisioned for Azure Cosmos DB).

![Graph of performance](_images/recommenders-performance.png)

![Graph of throughput](_images/recommenders-throughput.png)

Azure Cosmos DB is recommended for its turnkey global distribution and usefulness in meeting any database requirements your app has. To [reduce latency][latency] slightly, consider using [Azure Cache for Redis][redis] instead of Azure Cosmos DB to serve lookups. Azure Cache for Redis can improve performance of systems that rely heavily on data in back-end stores.

### Scalability

If you don't plan to use Spark, or you have a smaller workload that doesn't need distribution, consider using a [Data Science Virtual Machine][dsvm] (DSVM) instead of Azure Databricks. A DSVM is an Azure virtual machine with deep learning frameworks and tools for machine learning and data science. As with Azure Databricks, any model you create in a DSVM can be operationalized as a service on AKS via Machine Learning.

During training, either provision a larger fixed-size Spark cluster in Azure Databricks, or configure [autoscaling][autoscaling]. When autoscaling is enabled, Databricks monitors the load on your cluster and scales up and down as needed. Provision or scale out a larger cluster if you have a large data size and you want to reduce the amount of time it takes for data preparation or modeling tasks.

Scale the AKS cluster to meet your performance and throughput requirements. Take care to scale up the number of [pods][scale] to fully utilize the cluster, and to scale the [nodes][nodes] of the cluster to meet the demand of your service. You can also set autoscaling on an AKS cluster. For more information, see [Deploy a model to an Azure Kubernetes Service cluster][blog].

To manage Azure Cosmos DB performance, estimate the number of reads required per second, and provision the number of [RUs per second][ru] (throughput) needed. Use best practices for [partitioning and horizontal scaling][partition-data].

### Cost optimization

The main drivers of cost in this scenario are:

- The Azure Databricks cluster size required for training.
- The AKS cluster size required to meet your performance requirements.
- Azure Cosmos DB RUs provisioned to meet your performance requirements.

Manage the Azure Databricks costs by retraining less frequently and turning off the Spark cluster when not in use. The AKS and Azure Cosmos DB costs are tied to the throughput and performance required by your site and will scale up and down depending on the volume of traffic to your site.

## Deploy this scenario

To deploy this architecture, follow the **Azure Databricks** instructions in the [setup document][setup]. Briefly, the instructions require you to:

1. Create an [Azure Databricks workspace][workspace].
1. Create a new cluster with the following configuration in Azure Databricks:
    - Cluster mode: Standard
    - Databricks runtime version: 4.3 (includes Apache Spark 2.3.1, Scala 2.11)
    - Python version: 3
    - Driver type: Standard\_DS3\_v2
    - Worker type: Standard\_DS3\_v2 (min and max as required)
    - Auto termination: (as required)
    - Spark configuration: (as required)
    - Environment variables: (as required)
1. Create a personal access token within the [Azure Databricks workspace][workspace]. See the Azure Databricks authentication [documentation][adbauthentication] for details.
1. Clone the [Microsoft Recommenders][github] repository into an environment where you can execute scripts (for example, your local computer).
1. Follow the **Quick install** setup instructions to [install the relevant libraries][setup] on Azure Databricks.
1. Follow the **Quick install** setup instructions to [prepare Azure Databricks for operationalization][setupo16n].
1. Import the [ALS Movie Operationalization notebook][als-example] into your workspace. After logging into your Azure Databricks workspace, do the following:
   1. Click **Home** on the left side of the workspace.
   1. Right-click on white space in your home directory. Select **Import**.
   1. Select **URL**, and paste the following into the text field:
      `https://github.com/Microsoft/Recommenders/blob/master/examples/05_operationalize/als_movie_o16n.ipynb`
   1. Click **Import**.
1. Open the notebook within Azure Databricks and attach the configured cluster.
1. Run the notebook to create the Azure resources required to create a recommendation API that provides the top-10 movie recommendations for a given user.

## Next steps

- [Building a Real-time Recommendation API][als-example]
- [What is Azure Databricks?](/azure/databricks/scenarios/what-is-azure-databricks)
- [Azure Kubernetes Service](/azure/aks/intro-kubernetes)
- [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)

## Related resources

- [Batch scoring of Spark models on Azure Databricks][batch-scoring]
- [Build a content-based recommendation system](../../example-scenario/ai/scalable-personalization-with-content-based-recommendation-system.yml)
- [Build a movie recommendation system using machine learning](../../example-scenario/ai/movie-recommendations-with-machine-learning.yml)
- [Optimize and reuse an existing recommendation system](../../industries/retail/recommendation-engine-optimization.yml)
- [Product recommendations for retail using Azure](../../solution-ideas/articles/product-recommendations.yml)
- [Personalization using Cosmos DB](../../solution-ideas/articles/personalization-using-cosmos-db.yml)
- [Retail assistant with visual capabilities](../../solution-ideas/articles/retail-assistant-or-vacation-planner-with-visual-capabilities.yml)
- [Create personalized marketing solutions in near real time](../../solution-ideas/articles/personalized-marketing.yml)
- [Personalized offers](../../solution-ideas/articles/personalized-offers.yml)

<!-- links -->

[adbauthentication]: /azure/databricks/dev-tools/api/latest/authentication
[aks]: /azure/aks/intro-kubernetes
[als]: https://spark.apache.org/docs/latest/ml-collaborative-filtering.html
[als-example]: https://github.com/Microsoft/Recommenders/blob/master/examples/05_operationalize/als_movie_o16n.ipynb
[autoscaling]: /azure/databricks/clusters/configure#autoscaling
[batch-scoring]: ../../reference-architectures/ai/batch-scoring-databricks.yml
[blog]: /azure/machine-learning/how-to-deploy-azure-kubernetes-service?tabs=python#autoscaling
[cosmosdb]: /azure/cosmos-db/introduction
[data-source]: /azure/databricks/data/data-sources/
[databricks]: /azure/azure-databricks/what-is-azure-databricks
[dsvm]: /azure/machine-learning/data-science-virtual-machine/overview
[eval-guide]: https://github.com/Microsoft/Recommenders/blob/master/examples/03_evaluate/evaluation.ipynb
[github]: https://github.com/Microsoft/Recommenders
[guide]: https://github.com/Microsoft/Recommenders/blob/master/examples/01_prepare_data/data_split.ipynb
[latency]: https://github.com/jessebenson/azure-performance
[mls]: /azure/machine-learning/service
[nodes]: /azure/aks/scale-cluster
[partition-data]: /azure/cosmos-db/partition-data
[redis]: /azure/azure-cache-for-redis/cache-overview
[ru]: /azure/cosmos-db/request-units
[setup]: https://github.com/Microsoft/Recommenders/blob/master/SETUP.md#repository-installation
[setupo16n]: https://github.com/Microsoft/Recommenders/blob/master/SETUP.md#prepare-azure-databricks-for-operationalization
[scale]: /azure/aks/tutorial-kubernetes-scale
[workspace]: /azure/azure-databricks

<!-- cSpell:ignore gramhagen scgraham Criteo anonymized hyperparameters precompute mmlspark -->

This example scenario shows how your business can use machine learning to automate content-based personalization for your customers.

## Architecture

![Architectural diagram: training, evaluation, and deployment of a machine learning model for content-based personalization on Apache Spark using Azure Databricks.](./media/architecture-scalable-personalization.png)

This example scenario covers the training, evaluation, and deployment of a machine learning model for content-based personalization on Apache Spark using [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks). In this case, a model is trained with a supervised classification algorithm on a dataset containing user and item features. The label for each example is a binary value indicating that the user engaged with (for example, clicked) an item. This scenario covers a subset of the steps required for a full end-to-end recommendation system workload. The broader context of this scenario is based on a generic e-commerce website with a front end that serves rapidly changing content to users. The website uses cookies and user profiles to personalize the content for each user. Along with user profiles, the website sometimes has information about the items it serves to each user.

### Dataflow

Once the data is available, the following steps are executed to build and operationalize a recommendation system:

1. The sets of distinct user and item data are pre-processed and joined, which results in a mixture of numeric and categorical features to be used for predicting user-item interactions (clicks). This table is uploaded to [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction). For demonstration purposes, the [Criteo display advertising challenge dataset](https://labs.criteo.com/2014/02/download-dataset/) is used. This dataset matches the described anonymized table because it contains a binary label for observed user clicks, 13 numerical features, and another 26 categorical features.
1. The [MMLSpark] library enables the training of a [LightGBM] classifier on [Azure Databricks] to predict the click probability as a function of the numeric and categorical features that were created in the previous step. LightBGM is a highly efficient machine learning algorithm, and MMLSpark enables the distributed training of LightGBM models over large datasets.
1. The trained classifier is serialized and stored in the Azure Model Registry. With Azure Model Registry, you can store and organize different versions of the model (for example, based on newer data or different hyperparameters) within an Azure Machine Learning workspace.
1. A serving script is defined using the [MML Spark Serving] library to provide predictions from the trained model.
1. Machine Learning is used to create a Docker image in the [Azure Container Registry](/azure/container-registry/) that holds the image with the scoring script and all necessary dependencies for serving predictions.
1. Machine Learning is also used to provision the compute for serving predictions. A Kubernetes cluster is configured using [Azure Kubernetes Service](/azure/aks/intro-kubernetes) (AKS) with the number of nodes needed to handle expected load. The virtual machine size can be adjusted based on the model's computation and memory requirements.
1. The scoring service is deployed as a web service on the AKS cluster. The service provides an endpoint where user and item features can be sent to receive the predicted probability of a click for that user and item.

### Components

This architecture makes use of the following components:

- [Azure Blob Storage] is a storage service that's optimized for storing massive amounts of unstructured data. In this example scenario, the input data is stored here.
- [Azure Databricks] is a managed Apache Spark cluster for model training and evaluation. The scenario also uses [MMLSpark], a Spark-based framework designed for large-scale machine learning.
- [Azure Container Registry] is used to package the scoring script as a container image, which is used to serve the model in production.
- [Azure Kubernetes Service] is used to deploy the trained model to web or app services.
- [Azure Machine Learning] is used in this scenario to register the machine learning model and to deploy AKS.
- [Microsoft Recommenders] is an open-source repository that contains utility code and samples. By using this repository, users can start to build, evaluate, and operationalize a recommender system.

## Scenario details

Recommendations are a main revenue driver for many businesses and are used in different kinds of industries, including retail, news, and media. With the availability of large amounts of data, you can now provide highly relevant recommendations using machine learning.

There are two main types of recommendation systems: collaborative filtering and content-based. Collaborative filtering identifies similar patterns in customer behavior and recommends items that other similar customers have interacted with. Content-based recommendation uses information about the items to learn customer preferences and recommends items that share properties with items that a customer has previously interacted with. The approach described in this article focuses on a content-based recommendation system.

This example scenario shows how your business can use machine learning to automate content-based personalization for your customers. At a high level, you use [Azure Databricks] to train a model that predicts the probability that a user will engage with an item. That model is deployed to production as a prediction service using [Azure Kubernetes Service]. In turn, you can use this prediction to create personalized recommendations by ranking items based on the content that a user is most likely to consume.

### Potential use cases

This solution is ideal for the retail industry. This scenario is relevant to the following use cases:

- Content recommendations for websites or mobile apps
- Product recommendations for e-commerce sites
- Displayed ad recommendations for websites

## Considerations

### Scalability

For training, you can scale [Azure Databricks] up or down based on the size of the data used and the compute necessary for model training. To scale, you can adjust the total number of cores or amount of memory available to the cluster. Just edit the number or type of [Virtual Machines](https://azure.microsoft.com/pricing/details/virtual-machines/linux/) (VMs) used. The Criteo dataset contains 45.8 million rows in this example; it was trained in a few minutes on a cluster with 10 standard [L8s](/azure/virtual-machines/lsv2-series) VMs.

For deployment, you can scale the compute resources based on the expected load for the scoring service and latency requirements. The scoring service uses [MML Spark Serving] running separately on each node in the Kubernetes cluster. With this practice, you can seamlessly transfer the feature transformation and model prediction pipeline developed on [Azure Databricks] to the production side. The practice also removes the need to precompute scores for all possible user and item combinations, which might be difficult if you're using dynamic user features such as time of day.

### Availability

Machine learning tasks are split into two resource components: resources for training, and resources for production deployment. Resources required for training generally don't need high availability, as live production requests don't directly hit these resources. Resources required for serving need to have high availability to serve customer requests.

Training on [Azure Databricks] can happen on any one of the [regions](https://azure.microsoft.com/global-infrastructure/services/?products=databricks) with a [service level agreement][1] (SLA) to support your needs. For production deployment, [Azure Kubernetes Service] is used to provide broad geographic availability with this [SLA][1].

### Security

This scenario can use Azure Active Directory (Azure AD) to authenticate users to the [Azure Databricks] workspace and the [Azure Kubernetes](/azure/aks/concepts-security) cluster. Permissions can be managed via Azure AD authentication or role-based access control.

### Cost optimization

To better understand the cost of running this scenario on Azure, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/). Good starting assumptions are:

- Training data is of the same scale as the example dataset used (45.8 million rows).
- Training needs to happen daily to update the serving model.
- Training will occur on [Azure Databricks] by using a cluster provisioned with 12 VMs using **L8s** instances.
- Training will take an hour, including feature processing and model training plus validation.
- [Azure Machine Learning] will be used to deploy the model to AKS with a small three-node cluster using **D3** instances.
- AKS cluster will autoscale as needed, resulting in two nodes per month being active on average.

To see how pricing differs for your use case, change the variables to match your expected data size and serving load requirements. For larger or smaller training data sizes, the size of the Azure Databricks cluster can be increased or reduced, respectively. To handle larger numbers of concurrent users during model serving, the AKS cluster should be increased. For more information on scaling AKS to support latency and load requirements, review the [operationalization notebook](https://github.com/microsoft/recommenders/blob/master/examples/05_operationalize/lightgbm_criteo_o16n.ipynb).

## Deploy this scenario

### Prerequisites

You must have an existing Azure account.

### Walkthrough

All the code for this scenario is available in the [Microsoft Recommenders] repository.

To run the notebooks for training and deploying the recommendation model on [Azure Databricks]:

1. [Create an Azure Databricks workspace](/azure/machine-learning/service/how-to-configure-environment#aml-databricks) from the Azure portal.
1. Follow the [setup instructions](https://github.com/Microsoft/Recommenders/blob/master/SETUP.md#setup-guide-for-azure-databricks) to install utilities from the [Microsoft Recommenders] repository on a cluster within your workspace.
   1. Include the `--mmlspark` option in the install script to have [MMLSpark] installed.
   1. Also, [MMLSpark] requires autoscaling to be disabled in the cluster setup.
1. Import the training notebook into your workspace. After logging into your [Azure Databricks] workspace:
   1. Select **Home** on the left side of the workspace.
   1. Right-click whitespace in your home directory.
   1. Select **Import**.
   1. Select **URL**, and paste the following string into the text field: `https://aka.ms/recommenders/lgbm-criteo-training`.
   1. Select **Import**.
1. Repeat step 3 for the operationalization notebook here: `https://aka.ms/recommenders/lgbm-criteo-o16n`.
1. Select the notebook to open it, attach the configured cluster, and execute the notebook.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Scott Graham](https://www.linkedin.com/in/scott-graham-3a23822) | Principal Data Scientist

## Next steps

- To see more examples, tutorials, and tools to help you build your own recommendation system, visit the [Microsoft Recommenders] GitHub repository.
- See the blog post, [Building recommender systems with Azure Machine Learning service](https://azure.microsoft.com/blog/building-recommender-systems-with-azure-machine-learning-service).

## Related resources

- [Build a real-time recommendation API on Azure](../../reference-architectures/ai/real-time-recommendation.yml)
- [Build a movie recommendation system using machine learning](movie-recommendations-with-machine-learning.yml)
- [Optimize and reuse an existing recommendation system](../../industries/retail/recommendation-engine-optimization.yml)
- [Product recommendations for retail using Azure](../../solution-ideas/articles/product-recommendations.yml)
- [Personalization using Cosmos DB](../../solution-ideas/articles/personalization-using-cosmos-db.yml)
- [Batch scoring of Spark models on Azure Databricks](../../reference-architectures/ai/batch-scoring-databricks.yml)
- [Retail assistant with visual capabilities](../../solution-ideas/articles/retail-assistant-or-vacation-planner-with-visual-capabilities.yml)
- [Create personalized marketing solutions in near real time](../../solution-ideas/articles/personalized-marketing.yml)
- [Personalized offers](../../solution-ideas/articles/personalized-offers.yml)

<!-- links -->

[Azure Blob Storage]: https://azure.microsoft.com/services/storage/blobs
[Azure Databricks]: https://azure.microsoft.com/services/databricks
[Azure Container Registry]: https://azure.microsoft.com/services/container-registry
[Azure Kubernetes Service]: https://azure.microsoft.com/services/kubernetes-service
[Azure Machine Learning]: https://azure.microsoft.com/services/machine-learning-service
[Microsoft Recommenders]: https://github.com/Microsoft/Recommenders
[MMLSpark]: https://aka.ms/spark
[MML Spark Serving]: https://mmlspark.blob.core.windows.net/website/index.html
[LightGBM]: https://github.com/Microsoft/LightGBM
[1]: https://azure.microsoft.com/support/legal/sla/summary

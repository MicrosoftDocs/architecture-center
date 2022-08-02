<!-- cSpell:ignore gramhagen scgraham Criteo anonymized hyperparameters precompute mmlspark -->

This example scenario shows how your business can use machine learning to automate content-based personalization for your customers.

## Architecture

:::image type="content" alt-text="Architectural diagram: training, evaluation, and deployment of a machine learning model for content-based personalization on Apache Spark using Azure Databricks." source="./media/architecture-scalable-personalization.png" lightbox="./media/architecture-scalable-personalization.png":::

*Download a [Visio file](https://arch-center.azureedge.net/architecture-scalable-personalization.vsdx) of this architecture.*

This example scenario covers the training, evaluation, and deployment of a machine learning model for content-based personalization on Apache Spark by using [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks). In this case, a model is trained with a supervised classification algorithm on a dataset that contains user and item features. The label for each example is a binary value that indicates whether a user engaged with an item, for example by selecting the item. This scenario covers a subset of the steps that are required for a full end-to-end recommendation system workload. The broader context of this scenario is based on a generic e-commerce website with a front end that serves rapidly changing content to users. The website uses cookies and user profiles to personalize the content for each user. Along with user profiles, the website sometimes has information about the items it serves to each user.

### Dataflow

When the data is available, the following steps are taken to build and operationalize a recommendation system:

1. The sets of distinct user and item data are pre-processed and joined, which results in a mixture of numeric and categorical features to be used for predicting user-item interactions (clicks). This table is uploaded to [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction). For demonstration purposes, the [Criteo display advertising challenge dataset](https://labs.criteo.com/2014/02/download-dataset) is used. This dataset matches the described anonymized table because it contains a binary label for observed user clicks, 13 numerical features, and another 26 categorical features.
1. The [MMLSpark][MMLSpark] library enables the training of a [LightGBM][LightGBM] classifier on Azure Databricks to predict the click probability as a function of the numeric and categorical features that were created in the previous step. LightBGM is a highly efficient machine learning algorithm, and MMLSpark enables the distributed training of LightGBM models over large datasets.
1. The trained classifier is serialized and stored in the Azure Model Registry. With Azure Model Registry, you can store and organize different versions of the model (for example, based on newer data or different hyperparameters) within an Azure Machine Learning workspace.
1. A serving script is defined by using the [MML Spark Serving][MML Spark Serving] library to provide predictions from the trained model.
1. Machine Learning is used to create a Docker image in [Azure Container Registry](/azure/container-registry) that holds the image with the scoring script and all necessary dependencies for serving predictions.
1. Machine Learning is also used to provision the compute for serving predictions. A Kubernetes cluster is configured by using [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes) with the number of nodes that are needed to handle the expected load. The virtual machine (VM) size can be adjusted based on the model's computation and memory requirements.
1. The scoring service is deployed as a web service on the AKS cluster. The service provides an endpoint where user and item features can be sent to receive the predicted probability of a click for that user and item.

### Components

This architecture makes use of the following components:

- [Blob Storage][Azure Blob Storage] is a storage service that's optimized for storing massive amounts of unstructured data. In this example scenario, the input data is stored here.
- [Azure Databricks][Azure Databricks] is a managed Apache Spark cluster for model training and evaluation. The scenario also uses [MMLSpark][MMLSpark], a Spark-based framework that's designed for large-scale machine learning.
- [Container Registry][Azure Container Registry] is used to package the scoring script as a container image, which is used to serve the model in production.
- [AKS][Azure Kubernetes Service] is used to deploy the trained model to web or app services.
- [Machine Learning][Azure Machine Learning] is used in this scenario to register the machine learning model and to deploy AKS.
- [Microsoft Recommenders][Microsoft Recommenders] is an open-source repository that contains utility code and samples. By using this repository, users can start to build, evaluate, and operationalize a recommender system.

## Scenario details

Recommendations are a main revenue driver for many businesses and are used in different kinds of industries, including retail, news, and media. With the availability of large amounts of data, you can now provide highly relevant recommendations by using machine learning.

There are two main types of recommendation systems: collaborative filtering and content-based. Collaborative filtering identifies similar patterns in customer behavior and recommends items that other similar customers have interacted with. Content-based recommendation uses information about the items to learn customer preferences and recommends items that share properties with items that a customer has previously interacted with. The approach that's described in this article focuses on a content-based recommendation system.

This example scenario shows how your business can use machine learning to automate content-based personalization for your customers. At a high level, you use Azure Databricks to train a model that predicts the probability that a user will engage with an item. That model is deployed to production as a prediction service by using AKS. In turn, you can use this prediction to create personalized recommendations by ranking items based on the content that a user is most likely to consume.

### Potential use cases

This solution is ideal for the retail industry. This scenario is relevant to the following use cases:

- Content recommendations for websites or mobile apps
- Product recommendations for e-commerce sites
- Displayed ad recommendations for websites

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Machine learning tasks are split into two resource components: resources for training, and resources for production deployment. Resources that are required for training generally don't need high availability, because live production requests don't directly hit these resources. Resources that are required for serving need to have high availability to serve customer requests.

Training on Azure Databricks can happen on any one of the [regions](https://azure.microsoft.com/global-infrastructure/services/?products=databricks) with a service level agreement (SLA) to support your needs. For production deployment, AKS is used to provide broad geographic availability. For the SLA of this service, see [SLA summary for Azure services][1].

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This scenario can use Azure Active Directory (Azure AD) to authenticate users to the Azure Databricks workspace and the [AKS](/azure/aks/concepts-security) cluster. Permissions can be managed via Azure AD authentication or role-based access control.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To better understand the cost of running this scenario on Azure, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). Good starting assumptions are:

- Training data is of the same scale as the example dataset that's used, which has 45.8 million rows.
- Training needs to happen daily to update the serving model.
- Training occurs on Azure Databricks by using a cluster that's provisioned with 12 VMs that use **L8s** instances.
- Training  takes an hour, including feature processing and model training plus validation.
- Machine Learning is used to deploy the model to AKS with a small three-node cluster that uses **D3** instances.
- The AKS cluster autoscales as needed, resulting in two nodes per month being active on average.

To see how pricing differs for your use case, change the variables to match your expected data size and serving load requirements. For larger or smaller training data sizes, the size of the Azure Databricks cluster can be increased or reduced, respectively. To handle larger numbers of concurrent users during model serving, increase the AKS cluster. For more information about scaling AKS to support latency and load requirements, review the operationalization notebook, [Deploying a Real-Time Content Based Personalization Model](https://github.com/microsoft/recommenders/blob/master/examples/05_operationalize/lightgbm_criteo_o16n.ipynb).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

For training, you can scale Azure Databricks up or down based on the size of the data that you use and the compute that's necessary for model training. To scale, you can adjust the total number of cores or amount of memory available to the cluster. Just edit the number or type of VMs that you use. For more information, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux). The Criteo dataset contains 45.8 million rows in this example. It was trained in a few minutes on a cluster with 10 standard L8s instances. For more information, see [Lsv2-series](/azure/virtual-machines/lsv2-series).

For deployment, you can scale the compute resources based on the expected load for the scoring service and latency requirements. The scoring service uses MML Spark Serving running separately on each node in the Kubernetes cluster. With this practice, you can seamlessly transfer the feature transformation and model prediction pipeline that's developed on Azure Databricks to the production side. The practice also removes the need to precompute scores for all possible user and item combinations, which might be difficult if you're using dynamic user features such as time of day.

## Deploy this scenario

Use the information in the following sections to deploy this solution.

### Prerequisites

You need an Azure account.

### Walkthrough

All the code for this scenario is available in the [Microsoft Recommenders][Microsoft Recommenders] repository.

To run the notebooks for training and deploying the recommendation model on Azure Databricks, follow these steps:

1. [Create an Azure Databricks workspace](/azure/machine-learning/service/how-to-configure-environment#aml-databricks) from the Azure portal.
1. Follow the [setup instructions](https://github.com/Microsoft/Recommenders/blob/master/SETUP.md#setup-guide-for-azure-databricks) to install utilities from the Microsoft Recommenders repository on a cluster within your workspace.
   1. Include the `--mmlspark` option in the install script to have [MMLSpark][MMLSpark] installed.
   1. Disable autoscaling in the cluster setup. MMLSpark requires that it's disabled.
1. Import the training notebook into your workspace. After signing in to your Azure Databricks workspace:
   1. Select **Home** on the left side of the workspace.
   1. Right-click the whitespace in your home directory.
   1. Select **Import**.
   1. Select **URL**, and paste the following string into the text field: `https://aka.ms/recommenders/lgbm-criteo-training`.
   1. Select **Import**.
1. Repeat step 3 for the following operationalization notebook: `https://aka.ms/recommenders/lgbm-criteo-o16n`.
1. Select the notebook to open it, attach the configured cluster, and run the notebook.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Scott Graham](https://www.linkedin.com/in/scott-graham-3a23822) | Principal Data Scientist

## Next steps

- For general information about recommendation systems, see these resources:

  - For examples, tutorials, and tools that can help you build your own recommendation system, see the [Microsoft Recommenders GitHub repository](https://github.com/Microsoft/Recommenders).
  - For a blog post about a GitHub repository that provides examples and best practices for building recommendation systems, see [Building recommender systems with Azure Machine Learning service](https://azure.microsoft.com/blog/building-recommender-systems-with-azure-machine-learning-service).

- For information about the solution components, see these resources:

  - [Introduction to Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
  - [What is Azure Databricks?](/azure/databricks/scenarios/what-is-azure-databricks)
  - [Introduction to Container registries in Azure](/azure/container-registry/container-registry-intro)
  - [Azure Kubernetes Service](/azure/aks/intro-kubernetes)
  - [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)

- For courses about recommendation systems and machine learning, see these resources:

  - [Work with product recommendations in Dynamics 365 Commerce](/learn/modules/product-recommendations)
  - [Create machine learning models](/learn/paths/create-machine-learn-models)

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

---
title: Scalable (automated, content-based) personalization in Azure
description: <Article Description>
author: gramhagen
ms.author: scgraham
ms.date: 05/31/2019
---
# Scalable personalization in Azure

Recommendations are used in a variety of industries from retail to news and media and is a main revenue driver for many businesses. With the availability of large amounts of data, it is now possible to provide highly relevant recommendations using machine learning.

There are two main types of recommendation systems: collaborative filtering and content-based recommendations. Collaborative filtering identifies similar patterns in customer behavior and recommends items that other similar customers have interacted with. Content based recommendation uses information about the items to learn customer preferences and recommends items that share properties with items that a customer has previously interacted with. The approach described in this document focuses on the latter, content based, recommendation system.￼

This example scenario shows how a business can use machine learning to automate content-based personalization for their customers. At a high level, we use [Azure Databricks] to train a model that predicts the probability a user will engage with an item. That model is deployed to production as a prediction service using [Azure Kubernetes Service]. In turn, this estimate can be used to generate personalized recommendations by ranking items based on the content that a user is most likely to consume.

## Relevant use cases

This scenario is relevant to the following use cases:

- Content recommendations on a website or in a mobile application
- Product recommendation on an e-commerce site
- Displayed ad recommendation on a website

## Architecture

*Architecture Diagram goes here*

This scenario covers the training, evaluation, and deployment of a machine learning model for content-based personalization on Apache Spark using [Azure Databricks]. Specifically, a model is trained with a supervised classification algorithm on a dataset containing user and item features. The ground truth is implicit binary feedback indicating an interaction between the user and an item. This particular scenario covers a subset of the steps required for a full an end-to-end recommendation system workload. The broader context of this scenario includes the following:

1. A generic e-commerce website has a front-end which serves rapidly changing content to its users. This website leverages cookies and user profiles to track user information that is useful in personalizing the content for that user. In addition to user profiles, the website may have information about each of the items it serves to each user.
2. The sets of distinct user and item data are preprocessed and joined. This results in a mixture of numeric and categorical features to be used for predicting user-item interactions (clicks). This table is uploaded to Azure Blob storage. For demonstration purposes, the [Criteo display advertising challenge dataset](https://labs.criteo.com/2014/02/download-dataset/) is used. This dataset matches the described anonymized table as it contains a binary label for observed user clicks and 13 numerical features as well as an additional 26 categorical features.
3. The [MMLSpark] library provides the ability to train a LightGBM classifier on [Azure Databricks] in order to predict the probability of a click as a function of the numeric and categorical features created in step 2. LightGBM is a highly efficient machine learning algorithm, and [MMLSpark] enables distributed training of LightGBM models over large datasets.
4. The trained classifier is serialized and stored in the Azure Model Registry. Azure Model Registry allows for different versions of the model (for example, based on newer data or different hyperparameters) to be stored and organized within an Azure Machine Learning (Azure ML) Workspace.
5. Azure ML is used to create a Docker image in the Azure Container Registry which holds the scoring service image.
6. The scoring service is deployed through Azure ML to a Kubernetes cluster using [Azure Kubernetes Service] (AKS), which provides an endpoint for sending user and feature data and receiving the predicted probability of a click for that user and item.

### Components

This architecture makes use of the following components:

1. [Azure Blob Storage] is a storage service optimized for storing massive amounts of unstructured data. In this case, the input data is stored here.
2. [Azure Databricks] is a managed Apache Spark cluster where model training and evaluating is performed.  In addition, we utilize [MMLSpark], a Spark-based framework designed for large scale machine learning.
3. [Azure Container Registry] is used to package the scoring script as a container image, which is used to serve the model in production.
4. [Azure Kubernetes Service] is used to deploy the trained model to web or app services.
5. [Azure Machine Learning service] is used in this scenario to register the machine learning model and to deploy AKS.
6. [Microsoft Recommenders] is an open-source repository that contains utility code and samples to help users get started in building, evaluating, and operationalizing a recommender system.

## Considerations

### Availability

Machine learning tasks are split into two resource components: resources for training, and resources for production deployment. Resources required for training generally do not need high availability, as live production requests do not directly hit these resources. Resources required for serving need to have high availability to serve customer requests.

For training, [Azure Databricks] is available across many [regions](https://docs.azuredatabricks.net/administration-guide/cloud-configurations/regions.html) and provides the following [service level agreement][1] (SLA) to support businesses. For production deployment, [Azure Kubernetes Service] is used to provide broad geographic availability with the following [SLA][1].

### Scalability

For training, [Azure Databricks] can be scaled up or down based on the size of the data used and the compute necessary for model training.  This can be accomplished by adjusting the total amount of Cores or Memory available to the cluster by editing the number or type of [Virtual Machines](https://azure.microsoft.com/pricing/details/virtual-machines/linux/) (VMs) used. In this example, the Criteo dataset contains 45.8 million rows, which was trained in a matter of minutes on a cluster with 10 Standard **L8s** Virtual Machines.

For dep￼loyment, the compute resources can be scaled up or down based on the expected load for the scoring service and latency requirements. The scoring service utilizes MML Spark Serving running separately on each node in the Kubernetes cluster. This allows the feature transformation and model prediction pipeline developed on [Azure Databricks] to be transferred seamlessly to the production side. This also removes the need to precompute scores for all possible user and item combinations, which can be particularly difficult if dynamic user features are being used, such as time of day.

### Security

This scenario can use Azure Active Directory (Azure AD) to authenticate users to the Databricks workspace as well as to the [Azure Kubernetes](/azure/aks/concepts-security) cluster. Permissions can be managed via Azure AD authentication or role-based access control.

## Deploy this scenario

### Prerequisites

You must have an existing Azure account.

### Walkthrough

All the code for this scenario is available in the [Microsoft Recommenders] repository.

Follow these steps to run the notebooks for training and deploying the recommendation model on [Azure Databricks].

1. [Create an Azure Databricks workspace](/azure/machine-learning/service/how-to-configure-environment#aml-databricks) from the Azure portal.
2. Follow the [setup instructions](https://github.com/Microsoft/Recommenders/blob/master/SETUP.md#setup-guide-for-azure-databricks) for installing utilities from the [Microsoft Recommenders] repository on a cluster within your workspace.
   1. Be sure to include the `--mmlspark` option in the install script to have [MMLSpark] installed.
   2. Also, [MMLSpark] requires autoscaling to be disabled in the Cluster setup.
3. Import the training notebook into your workspace. After logging into your [Azure Databricks] Workspace, do the following:
   1. Select **Home** on the left side of the workspace.
   2. Right-click whitespace in your home directory.
   3. Select **Import**.
   4. Select **URL**, and paste the following into the text field: `https://aka.ms/recommenders/lgbm-criteo-training`.
   5. Select **Import**.
4. Repeat step 3 for the operationalization notebook here: `https://aka.ms/recommenders/lgbm-criteo-o16n`.
5. Select the notebook to open it, attach the configured cluster, and execute the notebook.

## Pricing

To better understand the cost of running this scenario on Azure, we provide a pricing estimator based on the following assumptions:

1. Training data is of the same scale as the example dataset used (45.8 million rows).
2. Training needs to happen daily to update the serving model.
3. Training will occur on [Azure Databricks] using a cluster provisioned with 12 VMs using **L8s** instances.
4. Training will take an hour, including feature processing and model training plus validation.
5. [Azure Machine Learning service] will be used to deploy the model to AKS with a small 3 node cluster using **D3** instances.
6. AKS cluster will autoscale as needed, resulting in two nodes per month being active on average.

To see how the pricing would change for your particular use case, change the appropriate variables to match your expected data size and serving load requirements. For larger or smaller training data sizes, the size of the Databricks cluster can be increased or decreased, respectively. To handle larger numbers of concurrent users during model serving, the AKS cluster should be increased. For more information on scaling AKS to support latency and load requirements, review the operationalization notebook.

## Related resources

For an in-depth guide to building and scaling a recommender service, see [Build a real-time recommendation API on Azure](/azure/architecture/reference-architectures/ai/real-time-recommendation). For additional tutorials and examples of recommendation systems, see the [Microsoft Recommenders] Github repository.

<!-- links -->
[calculator]: https://azure.com/e/
[availability]: /azure/architecture/checklist/availability
[resource-groups]: /azure/azure-resource-manager/resource-group-overview
[resiliency]: /azure/architecture/resiliency/
[security]: /azure/security/
[scalability]: /azure/architecture/checklist/scalability
[Azure Blob Storage]: https://azure.microsoft.com/services/storage/blobs/
[Azure Databricks]: https://azure.microsoft.com/services/databricks/
[Azure Container Registry]: https://azure.microsoft.com/services/container-registry/
[Azure Kubernetes Service]: https://azure.microsoft.com/services/kubernetes-service/
[Azure Machine Learning Service]: https://azure.microsoft.com/services/machine-learning-service/
[Microsoft Recommenders]: https://github.com/Microsoft/Recommenders
[MMLSpark]: https://aka.ms/spark
[1]: https://azure.microsoft.com/support/legal/sla/databricks/v1_0/
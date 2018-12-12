---
title: Movie recommendations on Azure
description: Use  machine learning to automate movie, product, and other recommendations using machine learning and an Azure Data Science Virtual Machine (DSVM) to train a model on Azure.
author: njray
ms.date: 12/7/2018
ms.custom: product-team
---

# Movie recommendations on Azure

This example scenario shows how a business can use machine learning to automate product recommendations to their customers.  An Azure Data Science Virtual Machine (DSVM) is used to train a model on Azure that recommends movies to users based on the current ratings users have given to movies.

Recommendations can be useful in various industries from retail to news to media. Potential applications include providing  product recommendations in a virtual store, providing news or post recommendations, or providing music recommendations.  Traditionally, businesses had to hire and train assistants to make personalized recommendations to customers. Today, we can  provide customized recommendations at scale by utilizing Azure to train models to understand customer preferences.

## Relevant use cases

Consider this scenario for the following use cases:

* Movie recommendations on a website.
* Consumer product recommendations in a mobile app.
* News recommendations on streaming media.

## Architecture

![Architecture of a machine learning model for training movie recommendations][architecture]

This scenario covers the training and evaluating of the machine learning model by using the Spark [alternating least squares][als] (ALS) algorithm on a dataset with ratings of movies. The steps for this scenario are as following:

1. The front-end website or app service collects historical user-movie interaction data, which are usually represented in a table of user, item, and numerical rating tuples.
2. The collected historical data is stored in a blob storage.
3. A DSVM is often used to experiment with or productize a Spark ALS recommender model. The ALS model is trained using a training dataset, which is produced from the overall dataset by applying the appropriate data splitting strategy. For example, the dataset can be split into sets randomly, chronologically, or stratified, depending on the business requirement. Similar to other machine learning tasks, a recommender is validated by using evaluation metrics (for example, precision\@*k*, recall\@*k*, [MAP][map], [nDCG\@k][ndcg]).
4. Azure Machine Learning service is used for coordinating the experimentation, such as hyperparameter sweeping and model management.
5. A trained model is preserved on Azure Cosmos DB, which can then be applied for recommending the top *k* movies for a given user.
6. The model is then deployed onto a web or app service by using Azure Container Instances or Azure Kubernetes Service.

### Components

* [Data Science Virtual Machine][dsvm] (DSVM) is an Azure virtual machine with deep learning frameworks and tools for machine learning and data science. The DSVM has a standalone Spark environment that can be used to run ALS.
* [Azure Blob storage][blob] stores the dataset for movie recommendations.
* [Azure Machine Learning service][mls] is used to accelerate the building, managing, and deploying of machine learning models.
* [Azure Cosmos DB][cosmosdb] enables globally distributed and multi-model database storage.
* [Azure Container Instances][aci](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview) is used to deploy the trained models to web or app services, optionally using [Azure Kubernetes Service][aks].

### Alternatives

[Azure Databricks][databricks] is a managed Spark cluster where model training and evaluating is performed. You can set up a managed Spark environment in minutes, and [autoscale][autoscale] up and down to help reduce the resources and costs associated with scaling clusters manually. Another resource-saving option is to configure inactive [clusters][clusters] to terminate automatically.

## Considerations

### Availability

The DSVM is available in [multiple regions][regions]  around the globe and meets the [service level agreement][sla] (SLA) for virtual machines.

The [availability checklist][availability] in the Azure Architecture Center lists more best practices.

### Scalability

You can scale a VM up or down by changing the [VM size][vm-size]. To scale out horizontally, put two or more VMs behind a load balancer as in a typical [n-tier architecture][n-tier].

### Security

This scenario uses [Azure Active Directory B2C][aad] (Business 2 Consumer) to authenticate users. For general guidance on designing secure solutions, see the [Azure Security Documentation][sec-docs].

### Resiliency

All the components in this scenario are managed, making them resilient at a regional level. For general guidance on designing resilient solutions, see [Designing resilient applications for Azure][resiliency].

## Deploy this scenario

**Prerequisites**: You must have an existing Azure account. If you don't have an Azure subscription, create a [free account][free] before you begin.

All the code for this scenario is available in the [Microsoft Recommenders repository][github].

Follow these steps to run the [ALS quick start notebook][notebook]:

1. [Create a DSVM][dsvm-ubuntu] from the Azure portal.
2. Clone the repo in the Notebooks folder:

    ```shell
    cd notebooks
    git clone https://github.com/Microsoft/Recommenders
    ```

3. Install the conda dependencies following the steps described in the [SETUP.md][setup] file.
4. In a browser, go to your jupyterlab VM and navigate to `notebooks/00_quick_start/als_pyspark_movielens.ipynb`.
5. Execute the notebook.

## Related resources

For tutorials and examples of recommendation systems, see [Microsoft Recommenders repository][github].

[architecture]: ./media/architecture-movie-recommender.png
[aci]: /azure/container-instances/container-instances-overview
[aad]: /azure/active-directory-b2c/active-directory-b2c-overview
[aks]: /azure/aks/intro-kubernetes
[als]: https://spark.apache.org/docs/latest/ml-collaborative-filtering.html
[autoscale]: https://docs.azuredatabricks.net/user-guide/clusters/sizing.html#autoscaling
[availability]: /azure/architecture/checklist/availability
[blob]: /azure/storage/blobs/storage-blobs-introduction
[clusters]: https://docs.azuredatabricks.net/user-guide/clusters/configure.html
[cosmosdb]: /azure/cosmos-db/introduction
[databricks]: /azure/azure-databricks/what-is-azure-databricks
[dsvm]: /azure/machine-learning/data-science-virtual-machine/overview
[dsvm-ubuntu]: /azure/machine-learning/data-science-virtual-machine/dsvm-ubuntu-intro
[free]: https://azure.microsoft.com/free/?WT.mc_id=A261C142F
[github]: https://github.com/Microsoft/Recommenders
[map]: https://en.wikipedia.org/wiki/Evaluation_measures_(information_retrieval)
[mls]: /azure/machine-learning/service/
[n-tier]: /azure/architecture/reference-architectures/n-tier/n-tier-cassandra
[ndcg]: https://en.wikipedia.org/wiki/Discounted_cumulative_gain
[notebook]: https://github.com/Microsoft/Recommenders/notebooks/00_quick_start/als_pyspark_movielens.ipynb
[regions]: https://azure.microsoft.com/en-us/global-infrastructure/services/?products=virtual-machines&regions=all
[resiliency]: /azure/architecture/resiliency/
[sec-docs]: /azure/security/
[setup]: https://github.com/Microsoft/Recommenders/blob/master/SETUP.md%60
[sla]: https://azure.microsoft.com/en-us/support/legal/sla/virtual-machines/v1_8/
[vm-size]: /azure/virtual-machines/virtual-machines-linux-change-vm-size
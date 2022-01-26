This example scenario shows how businesses can use machine learning to automate product recommendations for their customers. Specifically, an [Azure Data Science Virtual Machine (DSVM)][dsvm] is used to train a model on Azure that recommends movies to users based on movie ratings.

Personalized recommendations can be useful in various industries from retail to news to media. Potential applications include providing product recommendations in a virtual store, providing news or post recommendations, or providing music recommendations. Instead of hiring staff to make personalized recommendations to customers, businesses can provide customized recommendations at scale by using Azure to train models to understand customer preferences.

## Relevant use cases

Consider this scenario for the following use cases:

- Movie recommendations on a website.
- Consumer product recommendations in a mobile app.
- News recommendations on streaming media.

## Architecture of a movie recommendation system

![Architecture of a machine learning model for training movie recommendations][architecture]

This scenario covers the training and evaluating of the machine learning model using the Spark [alternating least squares][als] (ALS) algorithm on a dataset of movie ratings. The steps for this scenario are:

1. The front-end website or app service collects historical data of user-movie interactions, which are represented in a table of user, item, and numerical rating tuples.

2. The collected historical data is stored in blob storage.

3. A Data Science Virtual Machine (DSVM) is often used for smaller workloads to experiment or develop a product based on a Spark ALS recommender model. The ALS model is trained using a training dataset, which is produced from the overall dataset by applying a data splitting strategy. For example, the dataset can be split into sets randomly, chronologically, or stratified, depending on the business requirement. Similar to other machine learning tasks, a recommender is validated by using evaluation metrics (for example, precision\@*k*, recall\@*k*, [MAP][map], [nDCG\@k][ndcg]).

4. Azure Machine Learning coordinates the experimentation, such as hyperparameter sweeping and model management.

5. A trained model is saved to Azure Cosmos DB, which can then be applied for recommending the top *k* movies for a given user.

6. The model is then deployed onto a web or app service by using Azure Container Instances or Azure Kubernetes Service.

For an in-depth guide to building and scaling a recommender service, see the article [Build a real-time recommendation API on Azure][ref-arch].

### Components

- [Data Science Virtual Machine][dsvm] (DSVM) is an Azure virtual machine with deep learning frameworks and tools for machine learning and data science. The DSVM has a standalone Spark environment that can be used to run ALS. Use a DSVM when you have a smaller workload and you don't need a distributed solution.

- [Azure Blob storage][blob] stores the dataset for movie recommendations.

- [Azure Machine Learning][mls] is used to accelerate the building, managing, and deploying of machine learning models.

- [Azure Cosmos DB][cosmos-db] enables globally distributed and multi-model database storage.

- [Azure Container Instances][aci] is used to deploy the trained models to web or app services, optionally using [Azure Kubernetes Service][aks].

### Alternative to DSVM

[Azure Databricks][databricks] is a managed Spark cluster where model training and evaluating is performed. You can set up a managed Spark environment in minutes, and [autoscale][autoscale] up and down to help reduce the resources and costs associated with scaling clusters manually. Another resource-saving option is to configure inactive [clusters][clusters] to terminate automatically.

## Considerations

### Availability

Resources for apps based on machine learning are typically split into resources for training and resources for serving. Resources required for training generally don't need high availability, as live production requests don't directly hit these resources. Resources required for serving need to have high availability to serve customer requests.

For training, the DSVM is available in [multiple regions][regions] around the globe and meets the [service level agreement][sla] (SLA) for virtual machines. For serving, Azure Kubernetes Service provides a [highly available][ha] infrastructure. Agent nodes also follow the [SLA][sla-aks] for virtual machines.

### Scalability

If you have a large data set, you can scale your DSVM to shorten training time. You can scale a VM up or down by changing the [VM size][vm-size]. Choose a memory size large enough to fit your dataset in-memory and increase the vCPU count in order to decrease the amount of time that training takes.

### Security

This scenario can use Azure Active Directory to authenticate users for [access to the DSVM][dsvm-id], which contains your code, models, and (in-memory) data. Data is stored in Azure Storage prior to being loaded on a DSVM, where it is automatically encrypted using [Storage Service Encryption][storage-security]. Permissions can be managed via Azure Active Directory authentication or role-based access control.

## Deploy this scenario

**Prerequisites**: You must have an existing Azure account. If you don't have an Azure subscription, create a [free account][free] before you begin.

All the code for this scenario is available in the [Microsoft Recommenders repository][github].

Follow these steps to run the [ALS quickstart notebook](https://github.com/microsoft/recommenders/blob/master/examples/00_quick_start/als_movielens.ipynb):

1. [Create a DSVM][dsvm-ubuntu] from the Azure portal.

2. Clone the repo in the Notebooks folder:

    ```shell
    cd notebooks
    git clone https://github.com/Microsoft/Recommenders
    ```

3. Install the conda dependencies following the steps described in the [SETUP.md][setup] file.

4. In a browser, go to your JupyterLab VM and navigate to `notebooks/00_quick_start/als_pyspark_movielens.ipynb`.

5. Execute the notebook.

## Next steps

See other Azure Architecture Center articles:

- [Build a real-time recommendation API on Azure][ref-arch] - An in-depth guide to building and scaling a recommender service.
- [Product recommendations for retail using Azure][ref-sol-idea] - An example of developing predictive insights on customer behavior.

Try some code:

- [Microsoft Recommenders repository][github] - Contains tutorials and examples of recommendation systems.
- [Create and connect to a Data Science Virtual Machine][ms-learn] - A Microsoft Learn module.

[architecture]: ./media/architecture-movie-recommender.png
[aci]: /azure/container-instances/container-instances-overview
[aks]: /azure/aks/intro-kubernetes
[als]: https://spark.apache.org/docs/latest/ml-collaborative-filtering.html
[autoscale]: https://docs.azuredatabricks.net/user-guide/clusters/sizing.html#autoscaling
[blob]: /azure/storage/blobs/storage-blobs-introduction
[clusters]: /azure/databricks/clusters/configure
[cosmos-db]: /azure/cosmos-db/introduction
[databricks]: /azure/azure-databricks/what-is-azure-databricks
[dsvm]: /azure/machine-learning/data-science-virtual-machine/overview
[dsvm-id]: /azure/machine-learning/data-science-virtual-machine/dsvm-common-identity
[dsvm-ubuntu]: /azure/machine-learning/data-science-virtual-machine/dsvm-ubuntu-intro
[free]: https://azure.microsoft.com/free/?WT.mc_id=A261C142F
[github]: https://github.com/Microsoft/Recommenders
[ha]: /azure/aks/container-service-quotas
[map]: https://en.wikipedia.org/wiki/Evaluation_measures_(information_retrieval)
[mls]: /azure/machine-learning/service
[ms-learn]: /learn/modules/intro-to-azure-data-science-virtual-machine/
[ndcg]: https://en.wikipedia.org/wiki/Discounted_cumulative_gain
[notebook]: https://github.com/microsoft/recommenders/blob/master/notebooks/00_quick_start/als_movielens.ipynb
[ref-arch]: ../../reference-architectures/ai/real-time-recommendation.yml
[ref-sol-idea]: ../../solution-ideas/articles/product-recommendations.yml
[regions]: https://azure.microsoft.com/global-infrastructure/services/?products=virtual-machines&regions=all
[setup]: https://github.com/microsoft/recommenders/blob/master/SETUP.md
[sla]: https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_8
[sla-aks]: https://azure.microsoft.com/support/legal/sla/kubernetes-service/v1_0
[storage-security]: /azure/storage/common/storage-service-encryption
[vm-size]: /azure/virtual-machines/linux/change-vm-size

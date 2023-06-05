The solution described in this article uses machine learning to create movie recommendations automatically and at scale.

## Architecture

:::image type="content" alt-text="Diagram of the architecture of a machine learning model for training movie recommendations." source="media/architecture-movie-recommender.png" lightbox="media/architecture-movie-recommender.png":::

*Download a [Visio file](https://arch-center.azureedge.net/architecture-movie-recommender.vsdx) of this architecture.*

### Workflow

1. The front-end website or app service collects a history of viewer movie ratings.
1. It stores the history in Azure Blog Storage.
1. A DSVM trains the Machine Learning model using a training dataset that's a subset of the ratings history.
   - The workload is small enough that a DSVM is suitable to experiment and to develop a product.
   - The training dataset is drawn from the ratings history by applying a data splitting strategy. For example, the dataset can be split into sets randomly, chronologically, or stratified, depending on the business requirement.
   - As with other machine learning tasks, the model is validated by using evaluation metrics such as precision\@*k*, recall\@*k*, [MAP][map], and [nDCG\@k][ndcg]).
1. Machine Learning coordinates the experimentation, doing tasks such as hyperparameter sweeping and model management.
1. The DSVM saves the trained model to Azure Cosmos DB. Now the model can be used to recommend the top *k* movies for a given user.
1. The model is deployed onto a web or app service by using Azure Container Instances or Azure Kubernetes Service (AKS).

For an in-depth guide to building and scaling a recommender service, see the article [Build a real-time recommendation API on Azure][ref-arch].

### Components

- [Data Science Virtual Machines][dsvm-service] provides DSVMs, which are Azure Virtual Machine images that are pre-installed, configured, and tested with tools for data analytics, machine learning, and AI training. A DSVM has a standalone Spark environment that can be used to run ALS. Use a DSVM when you have a smaller workload and you don't need a distributed solution.
- [Azure Storage][storage-service] is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes Azure Files, Blob Storage, Azure Table Storage, Azure Queue Storage, and other services.
- [Blob Storage][blob-service] is scalable and secure object storage for unstructured data. You can use it for archives, data lakes, high-performance computing, machine learning, and cloud-native workloads. In this solution it holds the movie recommendations dataset.
- [Machine Learning][mls-service] is an enterprise-grade machine learning service for building and deploying models quickly. It provides users at all skill levels with a low-code designer, automated machine learning, and a hosted Jupyter notebook environment that supports various IDEs.
- [Azure Cosmos DB][cosmos-db-service]  is a fully managed, highly responsive, scalable NoSQL database for modern app development. It provides enterprise-grade security and supports APIs for many databases, languages, and platforms. Examples include SQL, MongoDB, Gremlin, Table, and Apache Cassandra. Serverless, automatic scaling options in Azure Cosmos DB efficiently manage the capacity demands of applications.
- [Container Instances][aci-service] provides the fastest and simplest way to run a container in Azure. It doesn't require that you manage virtual machines or adopt a higher-level service. AKS can use the Virtual Kubelet to provision pods inside Container Instances that start in seconds. This enables AKS to run with just enough capacity for your average workload. As you run out of capacity in your AKS cluster, scale out additional pods in ACI without any creating more servers to manage.
- [AKS][aks-service] is a highly available, secure, and fully managed [Kubernetes][kuber] service. It provides simplified deployment and management of Kubernetes by offloading critical tasks like health monitoring and maintenance to Azure. AKS hosts open source big data processing engines such as [Apache Spark][spark]. By using AKS, you can run large-scale stream processing jobs in a managed environment.

### Alternatives

[Azure Databricks][databricks-service] is an alternative to Azure DSVMs. It's a managed Spark cluster for training and evaluating models. You can set up a managed Spark environment in minutes, and [autoscale][autoscale] up and down to help reduce the resources and costs associated with scaling clusters manually. Another resource-saving option is to configure inactive [clusters][clusters] to terminate automatically.

## Scenario details

Providing personalized product recommendations to customers can be an effective way for a business to increase sales. It can also be cost effective, because in many cases you can use machine learning to provide the recommendations.

The solution described in this article uses machine learning to create movie recommendations automatically and at scale. Azure Machine Learning calculates the recommendations by applying the [alternating least squares][als] (ALS) algorithm to a dataset of viewer movie ratings. A data science virtual machine (DSVM) coordinates the process of training the Machine Learning model.

### Potential use cases

Personalized recommendations can be useful in many industries, including retail, news, and media/entertainment. Potential applications include:

- Product recommendations in an online store.
- News or post recommendations on a news or social media site.
- Music recommendations on a streaming app or online store.
- Movie recommendations on a movie streaming app.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- Resources for apps that are based on machine learning are typically split into resources for training and resources for serving. Resources required for training generally don't need high availability, as live production requests don't directly hit these resources. Resources required for serving need to have high availability to serve customer requests.
- For training, DSVMs are available in [multiple regions][regions] around the globe. They meet the [service level agreement][sla] (SLA) for virtual machines. For serving, AKS provides a [highly available][ha] infrastructure. Agent nodes also follow the [SLA][sla-aks] for virtual machines.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- This scenario can use Azure Active Directory (Azure AD) to authenticate users for [access to the DSVM][dsvm-id], which contains your code, models, and (in-memory) data. Data is stored in Azure Storage prior to being loaded on a DSVM, where it is automatically encrypted using [Storage Service Encryption][storage-security]. Permissions can be managed via Azure AD authentication or role-based access control.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- If you have a large data set, you can scale your DSVM to shorten training time. You can scale a VM up or down by changing the [VM size][vm-size]. Choose a memory size large enough to fit your dataset in-memory and increase the vCPU count in order to decrease the amount of time that training takes.

## Deploy this scenario

**Prerequisites**: You must have an existing Azure account. If you don't have an Azure subscription, create a [free account][free] before you begin.

All the code for this scenario is available in the [Microsoft Recommenders repository][github].

Follow these steps to run the [ALS quickstart notebook][als-quickstart]:

1. [Create a DSVM][dsvm-ubuntu] from the Azure portal.
1. Clone the repo in the Notebooks folder:

   ```shell
   cd notebooks
   git clone https://github.com/Microsoft/Recommenders
   ```

1. Install the conda dependencies following the steps described in the [SETUP.md][setup] file.
1. In a browser, go to your JupyterLab VM and navigate to `notebooks/00_quick_start/als_pyspark_movielens.ipynb`.
1. Execute the notebook.

## Next steps

- [What is the Azure Data Science Virtual Machine for Linux and Windows?][dsvm]
- [Introduction to Azure Blob storage][blob]
- [Microsoft Recommenders repository][github] - Contains tutorials and examples of recommendation systems.
- [Create and connect to a Data Science Virtual Machine][ms-learn] - A Microsoft Learn module.
- [Azure Machine Learning documentation][mls]
- [Welcome to Azure Cosmos DB][cosmos-db]
- [What is Azure Container Instances?][aci]

## Related resources

- [Build a real-time recommendation API on Azure][ref-arch] - An in-depth guide to building and scaling a recommender service.
- [Product recommendations for retail using Azure][ref-sol-idea] - An example of developing predictive insights on customer behavior.
- [Build a content-based recommendation system](/azure/architecture/solution-ideas/articles/build-content-based-recommendation-system-using-recommender)
- [Retail assistant with visual capabilities](../../solution-ideas/articles/retail-assistant-or-vacation-planner-with-visual-capabilities.yml)
- [Campaign optimization with SQL Server and machine learning](../../solution-ideas/articles/campaign-optimization-with-sql-server.yml)

[aci]: /azure/container-instances/container-instances-overview
[aci-service]: https://azure.microsoft.com/services/container-instances
[aks]: /azure/aks/intro-kubernetes
[aks-service]: https://azure.microsoft.com/services/kubernetes-service
[als]: https://spark.apache.org/docs/latest/ml-collaborative-filtering.html
[als-quickstart]: https://github.com/microsoft/recommenders/blob/master/examples/00_quick_start/als_movielens.ipynb
[autoscale]: /azure/databricks/clusters/configure#cluster-size-and-autoscaling
[blob]: /azure/storage/blobs/storage-blobs-introduction
[blob-service]: https://azure.microsoft.com/services/storage/blobs
[clusters]: /azure/databricks/clusters/configure
[cosmos-db]: /azure/cosmos-db/introduction
[cosmos-db-service]: https://azure.microsoft.com/services/cosmos-db
[databricks]: /azure/azure-databricks/what-is-azure-databricks
[databricks-service]: https://azure.microsoft.com/services/databricks
[dsvm]: /azure/machine-learning/data-science-virtual-machine/overview
[dsvm-id]: /azure/machine-learning/data-science-virtual-machine/dsvm-common-identity
[dsvm-service]: https://azure.microsoft.com/services/virtual-machines/data-science-virtual-machines
[dsvm-ubuntu]: /azure/machine-learning/data-science-virtual-machine/dsvm-ubuntu-intro
[free]: https://azure.microsoft.com/free/?WT.mc_id=A261C142F
[github]: https://github.com/Microsoft/Recommenders
[ha]: /azure/aks/container-service-quotas
[kuber]: https://kubernetes.io
[map]: https://en.wikipedia.org/wiki/Evaluation_measures_(information_retrieval)
[mls]: /azure/machine-learning/service
[mls-service]: https://azure.microsoft.com/services/machine-learning
[ms-learn]: /training/modules/intro-to-azure-data-science-virtual-machine
[ndcg]: https://en.wikipedia.org/wiki/Discounted_cumulative_gain
[ref-arch]: ../../reference-architectures/ai/real-time-recommendation.yml
[ref-sol-idea]: ../../solution-ideas/articles/product-recommendations.yml
[regions]: https://azure.microsoft.com/global-infrastructure/services/?products=virtual-machines&regions=all
[setup]: https://github.com/microsoft/recommenders/blob/master/SETUP.md
[sla]: https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_8
[sla-aks]: https://azure.microsoft.com/support/legal/sla/kubernetes-service/v1_0
[spark]: https://spark.apache.org
[storage-security]: /azure/storage/common/storage-service-encryption
[storage-service]: https://azure.microsoft.com/product-categories/storage
[vm-size]: /azure/virtual-machines/linux/change-vm-size
[well-architected-framework]: /azure/architecture/framework
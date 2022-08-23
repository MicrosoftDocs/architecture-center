[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Recommendations are a key revenue driver for many businesses and are used in different kinds of industries, including retail, news, and media. With the availability of large amounts of data, you can now provide highly relevant recommendations by using machine learning.

## Scenario details

The approach described in this article focuses on building a content-based recommendation system. For more information about the best practices of building recommendation systems, see [Best Practices on Recommendation Systems](https://github.com/microsoft/recommenders).

This example scenario shows how you can use machine learning to automate content-based personalization for your customers. The solution uses [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks) to train a model that predicts the probability that a user will engage with an item. [Batched Managed Endpoints](/azure/machine-learning/concept-endpoints#what-are-batch-endpoints) deploys that model to production as a prediction service. You can use this prediction to create personalized recommendations by ranking items based on the content that a user is most likely to consume. 

### Potential use cases

This solution is ideal for the retail industry. This scenario is relevant to the following use cases:

- Content recommendations for websites and mobile apps
- Product recommendations for e-commerce sites
- Displayed ad recommendations for websites

### Types of recommendation systems

There are three main types of recommendation systems in supervised learning techniques: 

- **Collaborative filtering.** Collaborative filtering identifies similar patterns in customer behavior and recommends items that other similar customers have interacted with. An advantage of collaborative filtering is the ease of generating data—users create data while interacting with listings of items and products. Moreover, customers can discover new items and products outside of those that are curated from their historical interactions. However, the downside of collaborative filtering is dealing with the "cold start" problem: since there's a scarcity of interactions between users and new offerings, newly added items aren't recommended by an algorithm that depends entirely on customer interactions. 

- **Content-based.** Content-based recommendation uses information about the items to learn customer preferences, and it recommends items that share properties with items that a customer has previously interacted with. Content-based recommendation systems aren't hampered by the cold-start problem and can adapt to the introduction of new items. However, the recommendations are limited to the features of the original item that a customer interacted with.

- **Hybrid method.** Another approach to building recommendation systems is an amalgamation of content-based and collaborative filtering. This system recommends items based on user ratings and on information about items. The hybrid approach extracts the advantages of both collaborative filtering and content-based recommendation.

## Architecture

:::image type="content" alt-text="Architectural diagram that shows training, evaluation, and development of a machine learning model for content-based personalization that uses Azure Databricks." source="../media/build-content-based-recommendation-system-using-recommender-architecture.svg" lightbox="../media/build-content-based-recommendation-system-using-recommender-architecture.svg":::

### Dataflow

1. **Store.** Azure Data Lake Storage Gen2 stores large amounts of data about user and consumer behavior. 

1. **Read.** [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks) connects to and reads from Azure Data Lake Storage Gen2. Ingestion into Databricks enables preprocessing and training to register the model. 

1. **Preprocess.** Data preprocessing cleanses, transforms, and prepares data to be fed to the recommendations system model. 

1. **Train.** Training has two steps: feature engineering and model training. During model training, Azure Databricks uses the preprocessed dataset to train and explain the best recommendation model. 

1. **Postprocess.** Postprocessing involves model evaluation and selection based on which model performs best. 

1. **Deploy.** Azure Databricks maintains the model. [Batch Managed Endpoints](/azure/machine-learning/concept-endpoints) deploys the model for exposure to front-end display. As the model is deployed, the new data is accessible via new endpoints. Batch and near-real-time recommendations are supported.

1. **Write.** User interfaces, such as web applications can consume the stored model results. The results are written to and captured in Azure Synapse. The model runs as batch inference and stores the results in the respective datastore. 

### Components

This architecture makes use of the following components:

- [Azure Data Lake Storage](https://azure.microsoft.com/pricing/details/storage/data-lake/) is a set of storage capabilities that are dedicated to big data analytics and that provide file system semantics, file-level security, and scaling.

- [Azure Databricks](https://azure.microsoft.com/services/databricks/) is a managed Apache Spark cluster for model training and evaluation. 

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/) is the fast, flexible, and trusted cloud data warehouse that lets you scale, compute, and store elastically and independently, with a massively parallel processing architecture.

- [Microsoft Recommenders](https://github.com/Microsoft/Recommenders) is an open-source repository that contains utility code and samples. By using this repository, you can start to build, evaluate, and operationalize a recommender system.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Scott Graham](https://www.linkedin.com/in/scott-graham-3a23822) | Principal Data Scientist

Other contributor:

- Andrew Ajulawa | Program Manager
- [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- To see more examples, tutorials, and tools to help you build your own recommendation system, see [Microsoft Recommenders](https://github.com/Microsoft/Recommenders), a GitHub repository.

- See [Building recommender systems with Azure Machine Learning service](https://azure.microsoft.com/blog/building-recommender-systems-with-azure-machine-learning-service), a post on the Microsoft Azure blog.

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


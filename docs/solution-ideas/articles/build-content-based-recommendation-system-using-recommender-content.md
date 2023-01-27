[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Recommendations are a key revenue driver for many businesses and are used in different kinds of industries, including retail, news, and media. With the availability of large amounts of data about customer activity, you can provide highly relevant recommendations by using machine learning.

## Architecture

:::image type="content" alt-text="Architectural diagram that shows training, evaluation, and development of a machine learning model for content-based personalization that uses Azure Databricks." source="../media/build-content-based-recommendation-system-using-recommender-architecture.svg" lightbox="../media/build-content-based-recommendation-system-using-recommender-architecture.svg":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/build-content-based-recommendation-system-using-recommender.pptx) of this architecture.*

### Dataflow

1. **Store.** Azure Data Lake Storage stores large amounts of data about user and consumer behavior. 

1. **Read.** Azure Databricks connects to and reads from Azure Data Lake Storage. Ingestion into Databricks enables preprocessing and training to register the model. 

1. **Preprocess.** Data preprocessing cleanses, transforms, and prepares data to be fed to the recommendations system model. 

1. **Train.** Training has two steps: [feature engineering](/azure/machine-learning/how-to-configure-auto-features#feature-engineering-and-featurization) and [model training](/windows/ai/windows-ml/what-is-a-machine-learning-model). During model training, Azure Databricks uses the preprocessed dataset to train and explain the behavior of the best recommendation model. 

1. **Postprocess.** Postprocessing involves model evaluation and selection based on which model performs best. 

1. **Deploy.** Azure Databricks maintains the model. Batch managed endpoints deploy the model for exposure to front-end display. As the model is deployed, the new data is accessible via new endpoints. Batch and near-real-time recommendations are supported.

1. **Write.** User interfaces, such as web applications, can consume the stored model results. The results are written to and captured in Azure Synapse. The model runs as batch inference and stores the results in the respective datastore. 

### Components

This architecture makes use of the following components:

- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/) is a set of storage capabilities that are dedicated to big data analytics and that provide file system semantics, file-level security, and scaling.

- [Azure Databricks](https://azure.microsoft.com/services/databricks/) is a managed Apache Spark cluster for model training and evaluation. 

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/) is the fast, flexible, and trusted cloud data warehouse that lets you scale, compute, and store elastically and independently, with a massively parallel processing architecture.

## Scenario details

The approach described in this article focuses on building a content-based recommendation system. For more information about the best practices of building recommendation systems, see the documentation and examples for [Recommenders](https://github.com/microsoft/recommenders) on GitHub.

This example scenario shows how you can use machine learning to automate content-based personalization for your customers. The solution uses [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks) to train a model that predicts the probability that a user will be interested in an item. [batched managed endpoints](/azure/machine-learning/concept-endpoints#what-are-batch-endpoints) deploys that model as a prediction service. You can use this service to create personalized recommendations by ranking items based on the content that a user is most likely to be interested in. 

### Potential use cases

This solution is ideal for the retail industry. It's relevant to the following use cases:

- Content recommendations for websites and mobile apps
- Product recommendations for e-commerce sites
- Displayed ad recommendations for websites

### Types of recommendation systems

There are three main types of recommendation systems: 

- **Collaborative filtering.** Collaborative filtering identifies similar patterns in customer behavior and recommends items that other similar customers have interacted with. An advantage of collaborative filtering is the ease of generating data—users create data while interacting with listings of items and products. Moreover, customers can discover new items and products other than those that are curated from their historical interactions. However, the downside of collaborative filtering is the *cold start* problem: since there's a scarcity of interactions between users and new offerings, newly added items aren't recommended by an algorithm that depends entirely on customer interactions. 

- **Content-based.** Content-based recommendation uses information about the items to learn customer preferences, and it recommends items that share properties with items that a customer has previously interacted with. Content-based recommendation systems aren't hampered by the cold-start problem and can adapt to the introduction of new items. However, the recommendations are limited to the features of the original item that a customer interacted with.

- **Hybrid method.** Another approach to building recommendation systems is to blend content-based and collaborative filtering. This system recommends items based on user ratings and on information about items. The hybrid approach has the advantages of both collaborative filtering and content-based recommendation.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Scott Graham](https://www.linkedin.com/in/scott-graham-3a23822) | Principal Data Scientist

Other contributor:

- Andrew Ajaluwa | Program Manager
- [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- To see more examples, tutorials, and tools to help you build your own recommendation system, see [Microsoft Recommenders](https://github.com/Microsoft/Recommenders), a GitHub repository.

- See [Building recommender systems with Azure Machine Learning service](https://azure.microsoft.com/blog/building-recommender-systems-with-azure-machine-learning-service), a post on the Microsoft Azure blog.

## Related resources

- [Build a real-time recommendation API on Azure](../../reference-architectures/ai/real-time-recommendation.yml)
- [Build a movie recommendation system using machine learning](../../example-scenario/ai/movie-recommendations-with-machine-learning.yml)
- [Product recommendations for retail using Azure](../../solution-ideas/articles/product-recommendations.yml)
- [Personalization using Azure Cosmos DB](../../solution-ideas/articles/personalization-using-cosmos-db.yml)
- [Batch scoring of Spark models on Azure Databricks](../../reference-architectures/ai/batch-scoring-databricks.yml)
- [Retail assistant with visual capabilities](../../solution-ideas/articles/retail-assistant-or-vacation-planner-with-visual-capabilities.yml)
- [Create personalized marketing solutions in near real time](../../solution-ideas/articles/personalized-marketing.yml)
- [Personalized offers](../../solution-ideas/articles/personalized-offers.yml)

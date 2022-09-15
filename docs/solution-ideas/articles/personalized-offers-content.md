[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

In today's highly competitive and connected environment, modern businesses can no longer survive with generic, static online content. Furthermore, marketing strategies using traditional tools are often expensive, hard to implement, and don't produce the desired return on investment. These systems often fail to take full advantage of the data collected to create a more personalized experience for the user.

Surfacing offers that are customized for the user has become essential to building customer loyalty and remaining profitable. On a retail website, customers desire intelligent systems that provide offers and content, based on their unique interests and preferences. Today's digital marketing teams can build this intelligence using the data generated from all types of user interactions.

Marketers have the unique opportunity to deliver highly relevant and personalized offers to each user by analyzing massive amounts of data. However, building a reliable and scalable big data infrastructure, and developing sophisticated machine learning models that personalize to each user isn't trivial.

Intelligent Recommendations offers capabilities to drive desired outcomes such as item based recommendations based on user interactions and Metadata. It can be used to promote and personalize any content type such as sellable products, media, documents, offers and more.

Personalizer service can be used to determine what product to suggest to shoppers or to figure out the optimal position for an advertisement. Personalizer acts as the additional last-step ranker. After the recommendations are shown to the user, the user's reaction is monitored and reported as a reward score back to the Personalizer service. This ensures that the service is learning continuously and enhances the Personalizer's ability to select the best items based on the contextual information received.

## Potential use cases

This solution applies to marketing of goods and services based on customer data (products viewed and / or purchased). This could be applicable in the following areas:

* **E-commerce** - This is an area where personalization is very widely used with customer behavior and product recommendations

* **Retail** - Based on prior purchase data, recommendations and offers can be provided on products

* **Telecom** - Based on user interaction in this area, recommendations can be provided. Compared to other industries, the product and offer ranges might be limited


## Architecture

![Architecture diagram shows how personalized offers are generated (product or offer views).](../media/personalized-offers.png)
*Download an [SVG](../media/personalized-offers.svg) of this architecture.*

### Dataflow

1. Raw User activity(product and offer clicks) and offers made to users on the website is captured with an Azure Function app to Azure Event Hub. In areas where user activity is not available, the simulated user activity is stored in Azure cache for Redis.
1. Azure Stream Analytics analyzes the data to provide near real-time analytics on the input stream from the Azure Event Hub.
1. The aggregated data is sent to Azure CosmosDB SQL API.
1. Power BI is used to look for insights on the aggregated data.
1. The raw data is sent to Azure Data Lake Storage.
1. Intelligent Recommendations uses the raw data from Azure Data Lake Storage and provides recommendations to Personalizer Service.
1. Personalizer Service serves the top contextual and personalized products and offers.
1. Simulated user activity data is provided to Personalizer service to provide personalized products and offers.
1. The results are provided on the web app that the user is accessing 
1. User feedback is captured based on the reaction of the user to the displayed offers and products and the reward score is provided to the Personalizer service to make it perform better over time
1. Retraining for Intelligent Recommendations for better recommendations can also be done by using refreshed data from Azure Data Lake Storage.

### Components

This solution combines several Azure services to provide powerful advantages:

* [Azure Event Hubs](/azure/event-hubs) collects real-time consumption data.
* [Azure Stream Analytics](/azure/stream-analytics) aggregates the streaming data and makes it available for visualization and updates to the data used in making personalized offers to the customer.
* [Azure CosmosDB SQL API](/azure/cosmos-db/introduction) stores the customer, product, and offer information. In the GitHub implementation, Azure Document DB was used, but this storage can also be [achieved using Azure Cosmos DB SQL API](https://azure.microsoft.com/blog/dear-documentdb-customers-welcome-to-azure-cosmos-db).
* [Azure Storage](/azure/storage) is used to manage the queues that simulate user interaction.
* [Azure Functions](/azure/azure-functions) is used as a coordinator for the user simulation and as the central portion of the solution for generating personalized offers.
* [Azure Machine Learning](/azure/machine-learning) implements and executes the user to product affinity scoring, by considering user preference and product history
* When no user history is available.
[Azure Cache for Redis](/azure/azure-cache-for-redis) is used to provide pre-computed product affinities for the customer.
* [Power BI Dashboard](/power-bi/create-reports) visualizes the real-time activity for the system and with the data from CosmosDB SQL API the behavior of the various offers.

## Solution details

Save time and let a trained SI partner help you with a proof of concept, deployment, and integration of this solution.

Microsoft Azure provides advanced analytics tools - data ingestion, data storage, data processing, and advanced analytics components - all of the essential elements for building a personalized offer solution.

## Next steps

* [Deep-dive into the classifiers used in this model](https://github.com/Azure/cortana-intelligence-personalization-data-science-playbook/blob/master/Personalized_Offers_from_Classifiers_Use_Case.md#types)
* [Learn how to implement MLOps](/azure/machine-learning/concept-model-management-and-deployment)
* [Build a Real-time Recommendation API on Azure](../../reference-architectures/ai/real-time-recommendation.yml)
* Grow your skillsets in Azure Machine Learning and Data Science through our [Microsoft Certified: Data Scientist Associate certification](/learn/certifications/azure-data-scientist)
* [Implement a classification model in Azure Machine Learning Studio](/learn/modules/create-classification-model-azure-machine-learning-designer). No coding required!
* [Learn how to create a drag-and-drop ML model](/learn/modules/use-automated-machine-learning)

## Related resources

* [Artificial intelligence (AI) - Architectural overview](../../data-guide/big-data/ai-overview.md)
* [Azure Machine Learning documentation](/azure/machine-learning)
* [Movie recommendations on Azure](../../example-scenario/ai/movie-recommendations-with-machine-learning.yml)
* [Personalized marketing solutions](./personalized-marketing.yml)
* [Product recommendations for retail using Azure](./product-recommendations.yml)




[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Personalized marketing is essential for building customer loyalty and remaining profitable. Reaching customers and getting them to engage is harder than ever, and generic offers are easily missed or ignored. Current marketing systems fail to take advantage of data that can help solve this problem.

Marketers using intelligent systems and analyzing massive amounts of data can deliver highly relevant and personalized offers to each user, cutting through the clutter and driving engagement. For example, retailers can provide offers and content based on each customer's unique interests and preferences, putting products in front of the people most likely to buy them.

By personalizing your offers, you'll deliver an individualized experience for every current or prospective customer, boosting engagement and improving customer conversion, lifetime value, and retention.

## Architecture

![Architecture Diagram](../media/personalized-marketing.png)
*Download an [SVG](../media/personalized-marketing.svg) of this architecture.*

## Components

* [Event Hubs](https://azure.microsoft.com/services/event-hubs) ingests raw click-stream data from Functions and passes it on to Stream Analytics.
* [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics): Stream Analytics aggregates clicks in near real-time by product, offer, and user to write to Azure Cosmos DB and also archives raw click-stream data to Azure Storage.
* [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) stores aggregated data of clicks by user, product, and offer as well as user-profile information.
* [Storage Accounts](https://azure.microsoft.com/services/storage): Azure Storage stores archived raw click-stream data from Stream Analytics.
* [Azure Functions](https://azure.microsoft.com/services/functions) takes in user clickstream data from website and reads existing user history from Azure Cosmos DB. These data are then run through the Machine Learning web service or used along with the cold-start data in Azure Cache for Redis to obtain product-affinity scores. Product-affinity scores are used with the personalized-offer logic to determine the most relevant offer to present to the user.
* [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning): Machine Learning helps you design, test, operationalize, and manage predictive analytics solutions in the cloud.
* [Azure Cache for Redis](https://azure.microsoft.com/services/cache) stores pre-computed cold-start product affinity scores for users without history.
* [Power BI](https://powerbi.microsoft.com) Visualizes user activity data as well as offers presented by reading in data from Cosmos DB.

## Next steps

* [Learn more about Event Hubs](/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Learn more about Stream Analytics](/azure/stream-analytics/stream-analytics-introduction)
* [Learn how to use Azure Cosmos DB](/azure/cosmos-db)
* [Learn more about Azure Storage](/azure/storage/common/storage-introduction)
* [Learn how to create functions](/azure/azure-functions)
* [Learn more about machine learning](/azure/machine-learning/overview-what-is-azure-ml)
* [Learn how to use Azure Cache for Redis](/azure/redis-cache/cache-dotnet-how-to-use-azure-redis-cache)
* [Learn about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page)
---
title: Personalized marketing solutions
description: Find essential technology to market your products with personalized offers. Individualize your marketing for greater customer response using big-data insights.
author: adamboeglin
ms.date: 10/18/2018
---
# Personalized marketing solutions
Personalized marketing is essential for building customer loyalty and remaining profitable. Reaching customers and getting them to engage is harder than ever, and generic offers are easily missed or ignored. Current marketing systems fail to take advantage of data that can help solve this problem.
Marketers using intelligent systems and analyzing massive amounts of data can deliver highly relevant and personalized offers to each user, cutting through the clutter and driving engagement. For example, retailers can provide offers and content based on each customers unique interests and preferences, putting products in front of the people most likely to buy them.
By personalizing your offers, youll deliver an individualized experience for every current or prospective customer, boosting engagement and improving customer conversion, lifetime value, and retention.

## Architecture
<img src="media/personalized-marketing.svg" alt='architecture diagram' />

## Components
* [Event Hubs](http://azure.microsoft.com/services/event-hubs/) ingests raw click-stream data from Functions and passes it on to Stream Analytics.
* [Stream Analytics](http://azure.microsoft.com/services/stream-analytics/) aggregates clicks in near real-time by product, offer, and user to write to Azure Cosmos DB and also archives raw click-stream data to Azure Storage.
* [Azure Cosmos DB](http://azure.microsoft.com/services/cosmos-db/) stores aggregated data of clicks by user, product, and offer as well as user-profile information.
* Azure [Storage](http://azure.microsoft.com/services/storage/) stores archived raw click-stream data from Stream Analytics.
* Azure [Functions](http://azure.microsoft.com/services/functions/) takes in user clickstream data from website and reads existing user history from Azure Cosmos DB. These data are then run through the Machine Learning web service or used along with the cold-start data in Redis Cache to obtain product-affinity scores. Product-affinity scores are used with the personalized-offer logic to determine the most relevant offer to present to the user.
* [Machine Learning Studio](href="http://azure.microsoft.com/services/machine-learning-studio/): Machine Learning helps you easily design, test, operationalize, and manage predictive analytics solutions in the cloud.
* [Redis Cache](http://azure.microsoft.com/services/cache/) stores pre-computed cold-start product affinity scores for users without history.
* [Power BI](https://powerbi.microsoft.comhttp://azure.microsoft.com/) Visualizes user activity data as well as offers presented by reading in data from Cosmos DB.

## Next Steps
* [Learn more about Event Hubs](https://docs.microsoft.com/azure/event-hubs/event-hubs-what-is-event-hubs)
* [Learn more about Stream Analytics](https://docs.microsoft.com/azure/stream-analytics/stream-analytics-introduction)
* [Learn how to use Azure Cosmos DB](https://docs.microsoft.com/azure/cosmos-db)
* [Learn more about Azure Storage](https://docs.microsoft.com/azure/storage/storage-introduction)
* [Learn how to create functions](https://docs.microsoft.com/azure/azure-functions)
* [Learn more about machine learning](https://docs.microsoft.com/azure/machine-learning/machine-learning-what-is-machine-learning)
* [Learn how to use Redis Cache](https://docs.microsoft.com/azure/redis-cache/cache-dotnet-how-to-use-azure-redis-cache)
* [Learn about Power BI](https://powerbi.microsoft.com/documentation/powerbi-landing-page/)
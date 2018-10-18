---
title: Personalized Offers 
description: In today's highly competitive and connected environment, modern businesses can no longer survive with generic, static online content. Furthermore, marketing strategies using traditional tools are often expensive, hard to implement, and do not produce the desired return on investment. These systems often fail to take full advantage of the data collected to create a more personalized experience for the user.
author: adamboeglin
ms.date: 10/18/2018
---
# Personalized Offers 
In today's highly competitive and connected environment, modern businesses can no longer survive with generic, static online content. Furthermore, marketing strategies using traditional tools are often expensive, hard to implement, and do not produce the desired return on investment. These systems often fail to take full advantage of the data collected to create a more personalized experience for the user.
Surfacing offers that are customized for the user has become essential to building customer loyalty and remaining profitable. On a retail website, customers desire intelligent systems which provide offers and content based on their unique interests and preferences. Today's digital marketing teams can build this intelligence using the data generated from all types of user interactions. By analyzing massive amounts of data, marketers have the unique opportunity to deliver highly relevant and personalized offers to each user. However, building a reliable and scalable big data infrastructure, and developing sophisticated machine learning models that personalize to each user is not trivial.

## Architecture
<img src="media/personalized-offers.svg" alt='architecture diagram' />

## Data Flow
1. User activity on the website is simulated with an Azure Function and a pair of Azure Storage Queues.
1. Personalized Offer Functionality is implemented as an Azure Function. This is the key function that ties everything together to produce an offer and record activity. Data is read in from Azure Redis Cache and Azure DocumentDb, product affinity scores are computed from Azure Machine Learning (if no history for the user exists then pre-computed affinities are read in from Azure Redis Cache).
1. Raw user activity data (Product and Offer Clicks), Offers made to users, and performance data (for Azure Functions and Azure Machine Learning) are sent to Azure Event Hub.
1. The offer is returned to the User. In our simulation this is done by writing to an Azure Storage Queue and picked up by an Azure Function in order to produce the next user action.
1. Azure Stream Analytics analyzes the data to provide near real-time analytics on the input stream from the Azure Event Hub. The aggregated data is sent to Azure DocumentDB. The raw data is sent to Azure Data Lake Storage.
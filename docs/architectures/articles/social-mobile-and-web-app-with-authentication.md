---
title: Social App for Mobile and Web with Authentication 
description: View a detailed, step-by-step diagram depicting the build process and implementation of the mobile client app architecture that offers social image sharing with a companion web app and authentication abilities, even while offline.
author: adamboeglin
ms.date: 10/29/2018
---
# Social App for Mobile and Web with Authentication 
This mobile client app offers social image sharing with a companion web app. The app back end service does background image processing using an Azure Function and can notify users of progress via a notification hub. Non-image data is stored in CosmosDB. The web app accesses the back end service data and images via Traffic Manager.
The mobile client app works in offline mode, allowing you to view and upload images even when you dont have a network connection.

## Architecture
<img src="media/social-mobile-and-web-app-with-authentication.svg" alt='architecture diagram' />

## Data Flow
1. Create the app using Visual Studio and Xamarin.
1. Add the Azure App Service Mobile Apps back end service to the app solution.
1. Implement authentication through social identity providers.
1. Store non-image data in CosmosDB and cache it in Azure Cache for Redis.
1. Store uploaded images in Azure Blob Storage.
1. Queue messages about newly uploaded images.
1. Use Azure Functions to dequeue messages and process images retrieved from blob storage.
1. Send push notifications to users through a notification hub.
1. Build and test the app through Visual Studio App Center and publish it.
1. Control the distribution of user traffic to service endpoints in different datacenters.
1. Use Application Insights to monitor the app service.

## Components
* Build the web front end, mobile apps, and back end services with C# in [Visual Studio](https://docs.microsoft.comhttp://azure.microsoft.com/visualstudio) 2017 or [Visual Studio](https://docs.microsoft.comhttp://azure.microsoft.com/visualstudio) for Mac.
* [Xamarin](https://docs.microsoft.comhref="http://azure.microsoft.com/xamarin): Create mobile apps for iOS and Android using C# and Azure SDKs.
* [Visual Studio App Center](href="http://azure.microsoft.com/services/app-center/): App Center enables a continuous integration and deployment workflow by pulling code from BitBucket, GitHub, and Visual Studio Team Services.
* An [App Service](http://azure.microsoft.com/services/app-service/) web app can host a customer-facing web app and a service that is used by both the web and mobile client.
* Use Azure [Functions](http://azure.microsoft.com/services/functions/) for serverless background processing. For example, one Azure function can automatically resize new blobs when they're added to a container, while another function listens for messages on a queue in order to delete multiple background images.
* Application Insights: Detect issues, diagnose crashes, and track usage in your web app with Application Insights. Make informed decisions throughout the development lifecycle.
* [Azure Cosmos DB](http://azure.microsoft.com/services/cosmos-db/) is a fully-managed NoSQL document database service. It offers querying and transaction-processing over schema-free data, predictable and reliable performance, and rapid development.
* Azure [Queue storage](http://azure.microsoft.com/services/storage/queues/) is used for durable messaging between the App Service backend and Azure Functions.
* [Blob storage](href="http://azure.microsoft.com/services/storage/blobs/): Images are stored in Azure Storage to take advantage of better scalability with lower cost. Communication between the web app and the Azure function is often performed using blob triggers and Azure Queue storage.
* Azure [Notification Hubs](http://azure.microsoft.com/services/notification-hubs/) are used for scalable, cross-platform push notifications.
* Azure [Traffic Manager](http://azure.microsoft.com/services/traffic-manager/) controls the distribution of user traffic for service endpoints in different datacenters in order to deliver a highly responsive and available application.

## Next Steps
* [Visual Studio Documentation](https://docs.microsoft.com/visualstudio)
* [Xamarin Documentation](https://docs.microsoft.com/xamarin)
* [Visual Studio App Center Documentation](https://docs.microsoft.com/appcenter)
* [Azure App Service Overview](href="http://azure.microsoft.com/services/app-service/)
* [Azure Functions Documentation](https://docs.microsoft.com/azure/azure-functions/functions-triggers-bindings)
* [Application Insights Documentation](https://docs.microsoft.com/azure/application-insights/)
* [Azure CosmosDB Documentation](https://docs.microsoft.com/azure/cosmos-db/)
* [Queue Storage Documentation](https://docs.microsoft.com/azure/storage/queues/storage-dotnet-how-to-use-queues)
* [Blob Storage Documentation](https://docs.microsoft.com/azure/storage/blobs/storage-dotnet-how-to-use-blobs)
* [Notification Hubs Documentation](https://docs.microsoft.com/azure/notification-hubs/)
* [Traffic Manager Documentation](https://docs.microsoft.com/azure/traffic-manager/traffic-manager-overview)
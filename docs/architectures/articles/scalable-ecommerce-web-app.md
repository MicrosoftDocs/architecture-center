---
title: Architect scalable e-commerce web app 
description: The e-commerce website includes simple order processing workflows with the help of Azure services. Using Azure Functions and Web Apps, developers can focus on building personalized experiences and let Azure take care of the infrastructure.
author: adamboeglin
ms.date: 10/18/2018
---
# Architect scalable e-commerce web app 

## Architecture
<img src="media/scalable-ecommerce-web-app.svg" alt='architecture diagram' />

## Data Flow
1. User accesses the web app in browser and signs in.
1. Browser pulls static resources such as images from Azure Content Delivery Network.
1. User searches for products and queries SQL database.
1. Web site pulls product catalog from database.
1. Web app pulls product images from Blob Storage.
1. Page output is cached in Azure Redis Cache for better performance.
1. User submits order and order is placed in the queue.
1. Azure Functions processes order payment.
1. Azure Functions makes payment to third party and records payment in SQL database.

## Components
* [Web Apps](href="http://azure.microsoft.com/services/app-service/web/): An App Service Web App runs in a single region, accessible to web and mobile browsers
* [Azure SQL Database](href="http://azure.microsoft.com/services/sql-database/): Managed relational SQL Database as a service
* [Functions](href="http://azure.microsoft.com/services/functions/): Process events with serverless code
* Application Insights

## Next Steps
* [Get started easily with Web Apps using the five-minute quick starts](https://docs.microsoft.com/azure/app-service/)
* [Build an ASP.NET app in Azure with SQL Database](https://docs.microsoft.com/azure/app-service/app-service-web-tutorial-dotnet-sqldatabase)
* [Learn what can you do with Azure Functions](https://docs.microsoft.com/azure/azure-functions/functions-overview)
* [Application Performance Management with Application Insights](https://docs.microsoft.com/hazure/application-insights/app-insights-overview)
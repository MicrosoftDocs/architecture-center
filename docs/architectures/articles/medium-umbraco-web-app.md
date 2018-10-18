---
title: Scalable Umbraco CMS web app
description: Medium Umbraco CMS web app configured to scale and optimal for high-traffic sites. It uses two web apps, one for your front-end app and the other for your back-office app, deployed in a single region with autoscaling enabled.
author: adamboeglin
ms.date: 10/18/2018
---
# Scalable Umbraco CMS web app
Medium Umbraco CMS web app configured to scale and optimal for high-traffic sites. It uses two web apps, one for your front-end app and the other for your back-office app, deployed in a single region with autoscaling enabled.
This solution is built on the Azure managed services: Azure SQL Database, Storage, Application Insights and Redis Cache. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture
<img src="media/medium-umbraco-web-app.svg" alt='architecture diagram' />

## Components
* Run an Umbraco CMS on the [Web Apps](http://azure.microsoft.com/services/app-service/web/) feature of Azure App Service with the front-end and back-office apps running on the same app.
* Store your sites content in [Azure SQL Database](http://azure.microsoft.com/services/sql-database/). The back-office web app and front-end web app use the same database. Use [Azure SQL Database](http://azure.microsoft.com/services/sql-database/)s features such as backup and high availability.
* Store all your media in Azure [Storage](http://azure.microsoft.com/services/storage/), so you can reduce I/O operation on the web app file server and improve performance.
* Application Insights: Detect issues, diagnose crashes, and track usage in your web app with Application Insights. Make informed decisions throughout the development lifecycle.
* Store session state and output cache on Azure [Redis Cache](http://azure.microsoft.com/services/cache/) to improve performance and reduce the load on your web front ends.

## Next Steps
* [Create a web app from the Azure Marketplace](https://docs.microsoft.com/api/Redirect/documentation/articles/app-service-web-create-web-app-from-marketplace/)
* [SQL Database tutorial: Create a SQL database in minutes by using the Azure portal](https://docs.microsoft.com/api/Redirect/documentation/articles/sql-database-get-started/)
* [Get started with Azure Blob storage using .NET](https://docs.microsoft.com/api/Redirect/documentation/articles/storage-dotnet-how-to-use-blobs/)
* [Logs, exceptions and custom diagnostics for ASP.NET in Application Insights](https://docs.microsoft.com/api/Redirect/documentation/articles/app-insights-search-diagnostic-logs/)
* [How to create a Web App with Redis Cache](https://docs.microsoft.com/api/Redirect/documentation/articles/cache-web-app-howto/)
---
title: Scalable Sitecore marketing website
description: With the Sitecore Experience Platform (xP), you have at your fingertips the complete data, integrated tools, and automation capabilities to engage your customers throughout an iterative life cyclethe technology foundation necessary to win customers for life.
author: adamboeglin
ms.date: 10/29/2018
---
# Scalable Sitecore marketing website
With the Sitecore Experience Platform (xP), you have at your fingertips the complete data, integrated tools, and automation capabilities to engage your customers throughout an iterative life cyclethe technology foundation necessary to win customers for life.
This solution is built on the Azure managed services: Azure SQL Database, Azure Cache for Redis, Azure Search and Application Insights. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture
<img src="media/digital-marketing-sitecore.svg" alt='architecture diagram' />

## Components
* App Service [Web Apps](http://azure.microsoft.com/services/app-service/web/) runs in multiple regions, accessible to web and mobile browsers, and is scaled out across multiple server instances. Used by Sitecore to host its content delivery, content management, reporting, and processing roles.
* [Azure SQL Database](href="http://azure.microsoft.com/services/sql-database/): A SQL Database stores and serves data about the site.
* [Azure Cache for Redis](http://azure.microsoft.com/services/cache/) enables very fast queries, and improves scalability by reducing the load on the main database. Sitecores Session State session state is managed by [Azure Cache for Redis](http://azure.microsoft.com/services/cache/).
* An [Azure Search](http://azure.microsoft.com/services/search/) service used for quick look up of data. All Sitecore search indexes are stored in [Azure Search](http://azure.microsoft.com/services/search/) for quick look up and scalability.
* Application Insights: Application Insights provides service health and performance monitoring, and diagnostics. Application Insights provides Sitecore with a solution for its health and performance monitoring needs.

## Next Steps
* [Deploy an ASP.NET web app to Azure App Service, using Visual Studio](https://docs.microsoft.com/api/Redirect/documentation/articles/web-sites-dotnet-get-started/)
* [SQL Database tutorial: Create a SQL database in minutes by using the Azure portal](https://docs.microsoft.com/api/Redirect/documentation/articles/sql-database-get-started/)
* [How to create a Web App with Azure Cache for Redis](https://docs.microsoft.com/api/Redirect/documentation/articles/cache-web-app-howto/)
* [Use Azure Search](href="http://azure.microsoft.com/services/search/)
* [Application Performance Management with Application Insights](https://docs.microsoft.com/api/Redirect/documentation/articles/app-insights-overview/)
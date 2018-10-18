---
title: Simple branded website 
description: Quickly build and launch digital campaigns that automatically scale based on customer demand.
author: adamboeglin
ms.date: 10/18/2018
---
# Simple branded website 
Quickly build and launch digital campaigns that automatically scale based on customer demand. Start simple with the content management system that enables you to easily maintain the messaging on your website in real time, from a browser, with no coding required.

## Architecture
<img src="media/simple-branded-website.svg" alt='architecture diagram' />

## Data Flow
1. User accesses Web Apps from Azure App Service in a browser.
1. Application Insights detects issues and analyzes usage for your web apps.
1. Web App connects to SQL Database and Azure Redis Cache for better performance.
1. Browser pulls static resources such as video from Azure Content Delivery Network to reduce load time.

## Components
* [Web Apps](href="http://azure.microsoft.com/services/app-service/web/): Build and deploy web apps faster at scale
* [Azure SQL Database](href="http://azure.microsoft.com/services/sql-database/): Managed relational SQL Database as a service
* [Content Delivery Network](href="http://azure.microsoft.com/services/cdn/): Ensure secure, reliable content delivery with broad global reach
* [Redis Cache](href="http://azure.microsoft.com/services/cache/): Power applications with high-throughput, low-latency data access
* Application Insights

## Next Steps
* [Deploy web apps with CMS using pre-built templates](href="http://azure.microsoft.com/resources/templates/?term=CMS)
* [Build an ASP.NET app in Azure with SQL Database](https://docs.microsoft.com/azure/app-service/app-service-web-tutorial-dotnet-sqldatabase)
* [Use Azure Content Delivery Network in Azure App Service](https://docs.microsoft.com/azure/cdn/cdn-add-to-web-app)
* [How to use Azure Redis Cache](https://docs.microsoft.com/azure/redis-cache/cache-dotnet-how-to-use-azure-redis-cache)
* [Application Performance Management with Application Insights](https://docs.microsoft.com/azure/application-insights/app-insights-detect-triage-diagnose)
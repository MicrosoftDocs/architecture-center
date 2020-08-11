---
title: Architect scalable e-commerce web app
titleSuffix: Azure Solution Ideas
author: doodlemania2
ms.date: 12/16/2019
description: The e-commerce website includes simple order processing workflows with the help of Azure services. Using Azure Functions and Web Apps, developers can focus on building personalized experiences and let Azure take care of the infrastructure.
ms.custom: acom-architecture, ecommerce, scalability, web-app, architect scalable e-commerce web app, web apps, search for products, submits order, process order payment, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/scalable-ecommerce-web-app/'
ms.service: architecture-center
ms.category:
  - web
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/scalable-ecommerce-web-app.png
---

# Architect scalable e-commerce web app

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

## Architecture

<!-- cSpell:ignore helvetica -->

![Architecture Diagram](../media/scalable-ecommerce-web-app.png)
*Download an [SVG](../media/scalable-ecommerce-web-app.svg) of this architecture.*

## Data Flow

1. User accesses the web app in browser and signs in.
1. Browser pulls static resources such as images from Azure Content Delivery Network.
1. User searches for products and queries SQL database.
1. Web site pulls product catalog from database.
1. Web app pulls product images from Blob Storage.
1. Page output is cached in Azure Cache for Redis for better performance.
1. User submits order and order is placed in the queue.
1. Azure Functions processes order payment.
1. Azure Functions makes payment to third party and records payment in SQL database.

## Components

* [Web Apps](https://azure.microsoft.com/services/app-service/web): An App Service Web App runs in a single region, accessible to web and mobile browsers
* [Azure SQL Database](https://azure.microsoft.com/services/sql-database): Managed, intelligent SQL in the cloud
* [Azure Functions](https://azure.microsoft.com/services/functions): Process events with serverless code
* Application Insights: Detect, triage, and diagnose issues in your web apps and services

## Next steps

* [Get started easily with Web Apps using the five-minute quick starts](https://docs.microsoft.com/azure/app-service)
* [Build an ASP.NET app in Azure with SQL Database](https://docs.microsoft.com/azure/app-service/app-service-web-tutorial-dotnet-sqldatabase)
* [Learn what can you do with Azure Functions](https://docs.microsoft.com/azure/azure-functions/functions-overview)
* [Application Performance Management with Application Insights](https://docs.microsoft.com/azure/application-insights/app-insights-overview)

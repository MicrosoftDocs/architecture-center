


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

* [Get started easily with Web Apps using the five-minute quick starts](/azure/app-service)
* [Build an ASP.NET app in Azure with SQL Database](/azure/app-service/app-service-web-tutorial-dotnet-sqldatabase)
* [Learn what can you do with Azure Functions](/azure/azure-functions/functions-overview)
* [Application Performance Management with Application Insights](/azure/application-insights/app-insights-overview)
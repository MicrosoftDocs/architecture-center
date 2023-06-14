[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Medium Umbraco CMS web app configured to scale and optimal for high-traffic sites. It uses two web apps, one for your front-end app and the other for your back-office app, deployed in a single region with autoscaling enabled.

## Architecture

![Architecture Diagram](../media/medium-umbraco-web-app.png)
*Download an [SVG](../media/medium-umbraco-web-app.svg) of this architecture.*

### Components

* Run an Umbraco CMS on the [Web Apps](https://azure.microsoft.com/services/app-service/web) feature of Azure App Service with the front-end and back-office apps running on the same app.
* Store your site's content in [Azure SQL Database](https://azure.microsoft.com/services/sql-database). The back-office web app and front-end web app use the same database. Use [Azure SQL Database](https://azure.microsoft.com/services/sql-database)'s features such as backup and high availability.
* [Storage Accounts](https://azure.microsoft.com/services/storage): Store all your media in Azure Storage, so you can reduce I/O operation on the web app file server and improve performance.
* Application Insights: Detect issues, diagnose crashes, and track usage in your web app with Application Insights. Make informed decisions throughout the development lifecycle.
* Store session state and output cache on [Azure Cache for Redis](https://azure.microsoft.com/services/cache) to improve performance and reduce the load on your web front ends.

## Scenario details

This solution is built on the Azure managed services: [Azure SQL Database](https://azure.microsoft.com/services/sql-database), [Storage Accounts](https://azure.microsoft.com/services/storage), Application Insights and [Azure Cache for Redis](https://azure.microsoft.com/services/cache). These services run in a high-availability environment, patched and supported, which allows you to focus on your solution instead of the environment it runs in.

### Potential use cases

Some industries that utilize Umbraco include:

- Banking, finance, and financial services
- Retail
- Logistics, distribution, and manufacturing

## Deploy this scenario

Use the following pre-built template to deploy this architecture to Azure:

- [Deploy to Azure](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2Fapplication-workloads%2Fumbraco%2Fumbraco-cms-webapp-redis-cache%2Fazuredeploy.json)
- [View template source](https://azure.microsoft.com/resources/templates/umbraco-cms-webapp-redis-cache)

## Next steps

<!-- markdownlint-disable MD024 -->
* [Create a Web App](https://azure.microsoft.com/get-started/web-app)
* [Quickstart: Create an Azure SQL Database single database](/azure/azure-sql/database/single-database-create-quickstart)
* [Quickstart: Azure Blob Storage client library v12 for .NET](/azure/storage/blobs/storage-quickstart-blobs-dotnet)
* [Azure Blob Storage Samples for .NET](/samples/azure-samples/storage-blob-dotnet-getting-started/storage-blob-dotnet-getting-started)
* [Diagnose exceptions in web apps with Application Insights](/azure/azure-monitor/app/asp-net-exceptions)
* [Explore .NET/.NET Core and Python trace logs in Application Insights](/azure/azure-monitor/app/asp-net-trace-logs)
* Azure Cache for Redis:
   * [Quickstart: Use Azure Cache for Redis with an ASP.NET web app](/azure/azure-cache-for-redis/cache-web-app-howto)
   * [Quickstart: Use Azure Cache for Redis in .NET Core](/azure/azure-cache-for-redis/cache-dotnet-core-quickstart)
   * [Create a Web App plus Azure Cache for Redis using a template](/azure/azure-cache-for-redis/cache-web-app-arm-with-redis-cache-provision)
   * [Tutorial: Create a cache-aside leaderboard on ASP.NET](/azure/azure-cache-for-redis/cache-web-app-cache-aside-leaderboard)

## Related resources

* [Web applications architecture design](../../web-apps/index.md)
* [Architect scalable e-commerce web app](../../web-apps/idea/scalable-ecommerce-web-app.yml)
* [Scalable Sitecore marketing website](../../solution-ideas/articles/digital-marketing-sitecore.yml)
* [Scalable web application](../../reference-architectures/app-service-web-app/scalable-web-app.yml)
* [Web application monitoring on Azure](../../reference-architectures/app-service-web-app/app-monitoring.yml)

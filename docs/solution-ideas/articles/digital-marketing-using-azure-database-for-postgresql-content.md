[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Engage with customers around the world through rich, personalized digital marketing experiences. Quickly build and launch digital campaigns that automatically scale based on customer demand.

Create personalized and timely customer experiences, increase campaign performance to win new customers, drive more revenue for your business, and get maximum performance by automatically scaling on demand.

## Architecture

![Architecture Diagram](../media/digital-marketing-using-azure-database-for-postgresql.png)

*Download an [SVG](../media/digital-marketing-using-azure-database-for-postgresql.svg) of this architecture.*

### Data flow

1. Use Azure App Service to build and host a content management system (CMS) of your choice without managing infrastructure. It offers autoscaling and high availability.
2. Azure Content Delivery Network (CDN) efficiently delivers web content to users by caching their content at strategically placed nodes across the world, thus reducing latency for users.
3. Manage customer data in Azure Database for PostgreSql with a fully managed and intelligent Azure database for PostgreSQL that provides high availability and scalability.
4. Store session state and output cache in Azure Cache for Redis to improve performance and reduce load times of your web front end.
5. Detect issues, diagnose crashes, and track usage in your web app with Azure Monitor Application Insights. Application Insights is designed to help you continuously improve performance and usability.

### Components

* [Azure App Service Web Apps](https://azure.microsoft.com/services/app-service/web): An Azure App Service web app runs in a single region and is accessible to web and mobile browsers. A CMS provides the service to manage content and deploy it to your website.
* [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql): A fully managed and intelligent Azure database for PostgreSQL.
* [Azure Monitor Application Insights](https://azure.microsoft.com/services/monitor): Application Insights provides health and performance monitoring and diagnostics.
* [Azure CDN](https://azure.microsoft.com/services/cdn): A content delivery network serves static content like images, scripts, and CSS, and it reduces the load on web app servers.
* [Azure Cache for Redis](https://azure.microsoft.com/services/cache): Enables very fast queries and improves scalability by reducing the load on the main database.

## Next steps

Review these articles to learn more:

* [Deploy an ASP.NET web app](/azure/app-service/quickstart-dotnetcore)
* [PostgreSQL Database tutorial: Create an Azure Database for PostgreSQL server by using the Azure portal](/azure/postgresql/quickstart-create-server-database-portal)
* [Start monitoring your website with Azure Monitor Application Insights](/azure/azure-monitor/app/website-monitoring)
* [Add Azure CDN to an Azure App Service web app](/azure/cdn/cdn-add-to-web-app)
* [Use Azure Cache for Redis in .NET Core](/azure/azure-cache-for-redis/cache-dotnet-core-quickstart)
* [Digital marketing solution architectures](https://azure.microsoft.com/solutions/digital-marketing)
* [Discover CMS templates in Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/category/web?page=1&subcategories=blogs-cmss)

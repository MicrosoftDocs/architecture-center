[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article outlines a three-tier application for securely storing data and providing high-value analytics over aggregated data. The architecture takes advantage of Azure built-in security and high-performance features.

## Architecture

:::image type="content" source="../media/finance-management-apps-using-azure-database-for-mysql.svg" alt-text="Architecture diagram of a three-tier application. Data flows from a browser and other sources to hosts, into a database, and on to analytics services." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/finance-management-apps-mysql.vsdx) of this architecture.*

### Dataflow

The architecture shows the flow of data in a common three-tier application design:

- A client interacts with the application's presentation tier—a mobile app or a web app in a browser.
- Azure App Service hosts back-end APIs and business logic in the application tier. These components process and aggregate the financial data.
- Azure Database for MySQL stores the financial data in the data tier.
- Power BI ingests data for analytics.

### Components

- [App Service](https://azure.microsoft.com/products/app-service) enables you to build and host web apps, mobile back ends, and RESTful APIs in the programming language of your choice without managing infrastructure.
- [Azure Database for MySQL](https://azure.microsoft.com/products/mysql) is a relational database service that's powered by the MySQL community edition.
- [Power BI](https://powerbi.microsoft.com) is a collection of software services, apps, and connectors that work together to turn your unrelated sources of data into coherent, visually immersive, and interactive insights.

## Scenario details

This solution is a basic example of a three-tier application on Azure:

- The presentation tier consists of a web app or browser and a mobile app.
- In the application tier, App Service provides the logic and computing power for the application.
- In the data tier, Azure Database for MySQL offers a fully managed OSS database.

Power BI, which supports native connectivity with MySQL, provides data analytics in this solution.

### Potential use cases

You can use this solution to manage financial data. The architecture also applies to various other use cases, including retail, education, and travel scenarios.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Jon Dobrzeniecki](https://www.linkedin.com/in/jonathan-dobrzeniecki) | Cloud Solution Architect

## Next steps

- [Connect an existing Azure App Service to Azure Database for MySQL server](/azure/mysql/howto-connect-webapp)
- [Tutorial: Design an Azure Database for MySQL database using the Azure portal](/azure/mysql/tutorial-design-database-using-portal)
- [Power BI MySQL database connector](/power-query/connectors/mysqldatabase)
- [App Service documentation](/azure/app-service)
- [Azure Database for MySQL documentation](/azure/mysql)
- [Power BI get started documentation](/power-bi/fundamentals)

## Related resources

- [Finance management apps using Azure Database for PostgreSQL](./finance-management-apps-using-azure-database-for-postgresql.yml)
- [Retail and e-commerce using Azure Database for MySQL](./retail-and-ecommerce-using-azure-database-for-mysql.yml)
- [Scalable web and mobile applications using Azure Database for MySQL](./scalable-web-and-mobile-applications-using-azure-database-for-mysql.yml)
- [Tier applications and data for analytics](./tiered-data-for-analytics.yml)

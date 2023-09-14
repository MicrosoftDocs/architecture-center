[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article outlines a three-tier application for securely storing data and providing high-value analytics over aggregated data. The architecture takes advantage of Azure built-in security and high-performance features.

## Architecture

:::image type="content" source="../media/finance-management-apps-using-azure-database-for-postgresql.svg" alt-text="Architecture diagram of a three-tier application. Data flows from a browser and other sources to hosts, into a database, and on to analytics services." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/finance-management-apps-postgresql.vsdx) of this architecture.*

### Dataflow

The architecture shows the flow of data in a common three-tier application design:

- A client interacts with the application's presentation tier—a mobile app or a web app in a browser.
- Azure App Service hosts back-end APIs and business logic in the application tier. These components process and aggregate the financial data.
- Azure Database for PostgreSQL stores the financial data in the data tier.
- Power BI ingests data for analytics.

### Components

- [App Service](https://azure.microsoft.com/products/app-service) enables you to build and host web apps, mobile back ends, and RESTful APIs in the programming language of your choice without managing infrastructure.
- [Azure Database for PostgreSQL](https://azure.microsoft.com/products/postgresql) is a relational database service that's powered by the PostgreSQL community edition.
- [Power BI](https://powerbi.microsoft.com) is a collection of software services, apps, and connectors that work together to turn your unrelated sources of data into coherent, visually immersive, and interactive insights.

## Scenario details

This solution is a basic example of a three-tier application on Azure:

- The presentation tier consists of a web app or browser and a mobile app.
- In the application tier, App Service provides the logic and computing power for the application.
- In the data tier, Azure Database for PostgreSQL offers a fully managed OSS database.

Power BI, which supports native connectivity with PostgreSQL, provides data analytics in this solution.

### Potential use cases

You can use this solution to manage financial data. The architecture also applies to various other use cases, including retail, education, and travel scenarios.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Jon Dobrzeniecki](https://www.linkedin.com/in/jonathan-dobrzeniecki) | Cloud Solution Architect

## Next steps

- [Best practices for building an application with Azure Database for PostgreSQL](/azure/postgresql/single-server/application-best-practices)
- [Tutorial: Design an Azure Database for PostgreSQL - Single Server using the Azure portal](/azure/postgresql/tutorial-design-database-using-azure-portal)
- [Tutorial: Create an Azure Database for PostgreSQL - Flexible Server with App Services Web App in Virtual network](/azure/postgresql/flexible-server/tutorial-webapp-server-vnet)
- [Power BI PostgreSQL database connector](/power-query/connectors/postgresql)
- [App Service documentation](/azure/app-service)
- [Azure Database for PostgreSQL documentation](/azure/postgresql)
- [Power BI get started documentation](/power-bi/fundamentals)

## Related resources

- [Finance management apps using Azure Database for MySQL](./finance-management-apps-using-azure-database-for-mysql.yml)
- [Retail and e-commerce using Azure Database for PostgreSQL](./retail-and-ecommerce-using-azure-database-for-postgresql.yml)
- [Intelligent apps using Azure Database for PostgreSQL](./intelligent-apps-using-azure-database-for-postgresql.yml)
- [Tier applications and data for analytics](./tiered-data-for-analytics.yml)

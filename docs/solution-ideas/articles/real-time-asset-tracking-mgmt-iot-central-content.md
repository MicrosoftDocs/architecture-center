[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution demonstrates real-time asset tracking and management.

It uses Azure IoT Central to receive data from IoT sensors and export it to Azure Event Hubs, which creates data streams. Other Azure services—such as Azure Stream Analytics, Azure Functions, and Azure Notification Hubs—receive the streams. They transform and analyze the streamed data, and create rule-based alerts. They also store the data for use by reporting tools and custom applications.

## Potential use cases

These other uses cases have similar design patterns:

- **Management and inventory:** Track vehicles and assets.
- **Driver scoring:** Use metrics such as location, speed, out-of-route distance, and hard braking to monitor driver behavior.
- **Vehicle monitoring and maintenance:** Schedule preventive and breakdown maintenance based on real-time engine alerts.
- **App-based alerts:** Use app-based alerts to monitor for speeding and geofence violations, and other events.
- **Reporting analytics:** Generate reports on asset history, alerts, and trip history.

## Architecture

:::image type="content" source="../media/real-time-asset-tracking-mgmt-iot-central-content.svg" lightbox="../media/real-time-asset-tracking-mgmt-iot-central-content.svg" alt-text="The solution diagram shows devices sending data to IoT Central, which exports it to Event Hubs for use by various alerting and reporting services.":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1839204-PR-3091-real-time-asset-tracking-mgmt-iot-central.vsdx) of this architecture.*

1. IoT sensors installed on vehicles and other assets send telemetry to cloud gateway devices.
1. Gateway devices send telemetry and aggregated insights to Azure IoT Central.
1. Azure IoT Central continuously exports data to Event Hubs for other Azure services to use.
1. Azure Stream Analytics jobs stream data from Event Hubs.
1. Stream Analytics jobs aggregate the data from Event Hubs, and store it in Azure SQL Database. The jobs also compare the data to threshold values stored in SQL database and generate alerts if thresholds are exceeded.
1. Stream Analytics jobs use Azure Functions to send real-time alerts to mobile and web apps.
1. Stream Analytics jobs use Azure Notification Hubs to send real-time alerts to mobile and web apps.
1. Event Hubs stores events in Azure Data Lake Storage for historical data analytics.
1. API Management makes the processed telemetry available to data users such as web apps, mobile apps, Azure maps, and Azure Power BI. It can also make the data available to third parties.
1. Web and mobile applications built with Azure App Service provide custom functionality based on data from Azure API Management. The apps can use Azure Maps for real-time tracking of vehicles and other assets. Web apps can display Power BI reports and custom visualizations for analytics and summary reports.

### Components

- [Azure IoT Central](https://azure.microsoft.com/services/iot-central/) is a hosted and secure IoT application platform that connects IoT devices to the cloud quickly and easily.
- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs/) is a big-data streaming platform and event ingestion service. It can receive and process millions of events per second. A real-time analytics provider, batching adapter, or storage adapter can transform and store data that is sent to an event hub.
- [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/) provides real-time, serverless stream processing that can run the same queries in the cloud and on the edge. Stream Analytics on Azure IoT Edge can filter or aggregate data locally and send it to the cloud for further processing or storage.
- [Azure Functions](https://azure.microsoft.com/services/functions/) provides an environment for running small pieces of code, called functions, without having to establish an application infrastructure. You can use it to process bulk data, integrate systems, work with IoT, and build simple APIs and microservices.
- [Azure Notification Hubs](https://azure.microsoft.com/services/notification-hubs/) pushes notifications to major platforms like iOS, Android, Windows, Kindle, and Baidu from any back end in the cloud or on-premises.
- [Azure SQL Database](https://azure.microsoft.com/services/sql-database/) is a fully managed relational database with built-in intelligence.
- [Azure App Service](https://azure.microsoft.com/services/app-service/) is a fully managed service for building, deploying, and scaling web apps. You can build apps using .NET, .NET Core, Node.js, Java, Python, or PHP. The apps can run in containers or on Windows or Linux.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/) is a storage repository that holds a large amount of data in its native, raw format. Data lake stores are optimized for scaling to terabytes and petabytes of data. The data typically comes from multiple, heterogeneous sources and may be structured, semi-structured, or unstructured.
- [Azure API Management](https://azure.microsoft.com/services/api-management/) supports the publishing, routing, securing, logging, and analytics of APIs. You can control how the data is presented and extended, and which apps can access it. You can restrict access to your apps only, or make it available to third parties.
- [Azure Maps](https://azure.microsoft.com/services/azure-maps/) has geospatial APIs for adding maps, spatial analytics, and mobility solutions to your apps. It's available to verify and standardize address data. Your apps can use real-time location intelligence powered by mobility technology partners TomTom, AccuWeather, and Moovit.
- [Power BI](https://powerbi.microsoft.com) is a suite of business analytics tools that deliver insights throughout your organization. You can use it to produce beautiful reports and publish them on the web and across mobile devices.
- [Power BI Embedded](https://azure.microsoft.com/services/power-bi-embedded/) puts Power BI into your applications, so that you can quickly and easily provide interactive reports, dashboards, and analytics in your applications, and brand them as your own.

## Next steps

- [What is Azure IoT Central?](/azure/iot-central/core/overview-iot-central)
- [Export IoT data to cloud destinations using data export](/azure/iot-central/core/howto-export-data?tabs=javascript)
- [Azure Event Hubs — A big data streaming platform and event ingestion service](/azure/event-hubs/event-hubs-about)
- [Welcome to Azure Stream Analytics](/azure/stream-analytics/stream-analytics-introduction)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)

## Related resources

See these related architectures:

- [Environment monitoring and supply chain optimization with IoT](./environment-monitoring-and-supply-chain-optimization.yml)
- [Retail - Buy online, pickup in store (BOPIS)](../../example-scenario/iot/vertical-buy-online-pickup-in-store.yml)

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how you can speed up front-end and business process development by using Power Apps.

## Architecture

![Diagram that shows an architecture that implements Power Apps, Power Automate, and Azure Functions.](../media/front-end.png)

*Download a [Visio file](https://arch-center.azureedge.net/front-end.vsdx)* of this architecture.

### Dataflow

1. Power Automate reads and writes data to and from Azure Table Storage and retrieves data from a third-party auditing system.
1. Power Automate calls Azure Functions, which converts raw data into HTML.
1. Power Apps reads data from custom web APIs, surfaced via Functions.
1. Power Apps presents rich information across iOS, Android, and the web.
1. Telemetry data is written to Table Storage.

### Components

- [Power Apps](https://powerapps.microsoft.com) can help you rapidly build low-code apps.
- [Azure Functions](https://azure.microsoft.com/services/functions) is an event-driven, serverless platform.
- [Power Automate](https://flow.microsoft.com) can help you streamline repetitive tasks and business processes.
- [Azure Table Storage](https://azure.microsoft.com/services/storage/tables) stores nonrelational structured data in the cloud, providing a key/attribute store with a schemaless design. 

## Scenario details

This solution idea illustrates how to use Power Apps, Power Automate, and Functions for low-latency processing and quick reads and writes to and from Table Storage. Power Apps and Power Automate provide out-of-the-box connectors that you can use to integrate with data sources, including third-party systems.

## Next steps

- [Power Apps learning paths and modules](/training/browse/?products=power-apps)
- [Get started with Power Automate](/power-automate/getting-started)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)

## Related resources

- [Azure and Power Platform scenarios](../../solutions/power-platform-scenarios.md)
- [Serverless functions architecture design](../../serverless-quest/serverless-overview.md)
- [Power BI data write-back with Power Apps and Power Automate](../../example-scenario/data/power-bi-write-back-power-apps.yml)
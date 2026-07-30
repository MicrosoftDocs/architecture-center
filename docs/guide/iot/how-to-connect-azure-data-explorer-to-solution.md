---
title: "Connect Azure Data Explorer to the reference solution"
description: "Learn how to ingest and analyze OPC UA PubSub industrial IoT data in Azure Data Explorer by using Event Hubs and KQL."
author: erichb
ms.author: erichb
ms.service: azure-iot
ms.topic: how-to
ms.date: 07/22/2026
---

# Connect Azure Data Explorer to the reference solution

[Azure Data Explorer](/azure/data-explorer/data-explorer-overview) is a fast, fully managed data analytics service for real-time analysis on large volumes of streaming data such as the OPC UA telemetry produced by this reference solution. It is purpose-built for time-series and log data, ingests millions of events per second with low latency, and lets you explore the data interactively using the powerful Kusto Query Language (KQL). Built-in capabilities for time-series analysis, pattern recognition, anomaly detection, and forecasting make it ideal for industrial use cases such as condition monitoring, overall equipment effectiveness (OEE) calculation, and predictive maintenance, and its native dashboards visualize the results without any extra tooling.

:::image type="complex" source="media/databricks-solution-architecture.png" alt-text="Architecture diagram of the reference solution that adds Azure Databricks as a parallel analytics option to Azure Data Explorer." lightbox="media/databricks-solution-architecture.png" border="false":::
The diagram shows a reference architecture with Azure Event Hubs at the center and two parallel analytics paths. On the left, Azure Data Explorer is the default analytics option. On the right, Azure Databricks is a second analytics option. Two inbound streams, typically labeled data and metadata, flow into Event Hubs. Databricks reads those streams through a dedicated databricks consumer group, so both analytics paths ingest side by side.

Inside the Databricks path, Structured Streaming notebooks or jobs ingest Event Hubs messages and write them to Delta Lake tables. The tables separate telemetry and metadata and you can join them later by shared identifiers. The Delta tables feed a SQL warehouse layer, and that layer feeds an AI/BI dashboard for condition monitoring, OEE, energy, production, and diagnostics across sites such as Munich and Seattle. Arrows show left-to-right flow from ingestion to storage, query, and visualization.
:::image-end:::

## Automated deployment

Select the **Deploy** button to deploy all required resources to your Azure subscription:

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdigitaltwinconsortium%2FManufacturingOntologies%2Fmain%2FDeployment%2Farm.json)

> [!NOTE]
> Please be patient! The deployment can take up to 100 minutes to complete. After the deployment is complete, you can access the VM via SSH using the credentials you provided during deployment.

## Use cases for condition monitoring, OEE calculation, anomaly detection, and predictions in Azure Data Explorer

You can deploy a [sample dashboard](https://github.com/digitaltwinconsortium/ManufacturingOntologies/blob/main/Tools/ADXQueries/dashboard-ontologies.json). To learn how to deploy a dashboard, see [Visualize data with Azure Data Explorer dashboards &gt; create from file](/azure/data-explorer/azure-data-explorer-dashboards#to-create-new-dashboard-from-a-file). After you import the dashboard, update its data source. Specify the HTTPS endpoint of your Azure Data Explorer server cluster in the top-right corner of the dashboard. The HTTPS endpoint looks like: `https://<ADXInstanceName>.<AzureRegion>.kusto.windows.net/`.

To display the OEE for a specific shift, select **Custom Time Range** in the **Time Range** drop-down in the top-left corner of the Azure Data Explorer Dashboard and enter the date and time from start to end of the shift you're interested in.

The sample dashboard also includes a **Unified NameSpace (UNS) / ISA-95 Graph** tile that renders the Unified Namespace / ISA-95 asset hierarchy as an interactive node-link graph.

## I3X API

An [**I3X API**](https://i3x.dev) container app named `<resourcesName>-i3x4kusto` is deployed, exposing ADX over the I3X REST API. Its URL can be retrieved from the Azure portal and the Swagger endpoint is accessible by adding /swagger to its URL.

The I3X API is protected with HTTP Basic authentication. Every request (including the Swagger "Authorize" dialog and any I3X client) must supply the credentials you provided during deployment:

- **Username**: the `adminUsername` you specified at deployment.
- **Password**: the `adminPassword` you specified at deployment.

The health/capabilities endpoint (`GET /v1/info`) and the Swagger UI itself remain accessible without credentials; all data endpoints require the Basic auth header (for example `curl -u <adminUsername>:<adminPassword> https://<i3x-url>/v1/namespaces`).

## Run a query

Open your ADX database and select `Queries`. Because the telemetry `Subject` is the numeric `DataSetWriterId`, the station and production line are matched on the metadata `DataSetName` (built from the OPC UA server's ApplicationUri and NodeId) and then joined to the telemetry on `Subject`. Enter the following query in the text box, and select `Run`:

```kql
let _startTime = ago(1h);
let _endTime = now();
opcua_metadata_lkv
| where DataSetName contains "assembly"
| where DataSetName contains "munich"
| join kind=inner (
    opcua_telemetry
    | where Name == "Status"
    | where Timestamp > _startTime and Timestamp < _endTime
) on Subject
| extend energy = todouble(Value)
| project Timestamp1, status
| sort by Timestamp1 desc
| render linechart
```

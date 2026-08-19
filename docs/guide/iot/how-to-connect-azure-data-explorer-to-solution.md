---
title: "Connect Azure Data Explorer to the reference solution"
description: "Learn how to ingest and analyze OPC UA industrial IoT data in Azure Data Explorer by using Azure Event Hubs and KQL."
author: erichb
ms.author: erichb
ms.topic: concept-article
ms.subservice: architecture-guide
ms.date: 07/22/2026
ai-usage: ai-assisted
---

# Connect Azure Data Explorer to the OPC UA reference solution

This article describes how to connect Azure Data Explorer to the [OPC UA reference solution](iot-industrial-solution-architecture.md).

[Azure Data Explorer](/azure/data-explorer/data-explorer-overview) is a fast, fully managed data analytics service for real-time analysis on large volumes of streaming data, such as the OPC Unified Architecture (OPC UA) telemetry produced by this reference solution. Azure Data Explorer is purpose-built for time-series and log data, ingests millions of events per second with low latency, and lets you explore the data interactively by using Kusto Query Language (KQL). Built-in capabilities for time-series analysis, pattern recognition, anomaly detection, and forecasting make it ideal for industrial use cases such as condition monitoring, overall equipment effectiveness (OEE) calculation, and predictive maintenance. Its native dashboards visualize the results without any extra tooling.

## Architecture

The following diagram illustrates the OPC UA solution. It shows Azure Data Explorer as an analytics back end. It also shows Azure Databricks as an alternative analytics back end.

:::image type="complex" source="media/databricks-solution-architecture.svg" alt-text="Architecture diagram of the OPC UA reference solution. Azure Databricks is shown as an optional alternative analytics back end." lightbox="media/databricks-solution-architecture.svg" border="false":::
The diagram shows the end-to-end architecture of the OPC UA reference solution, organized into eight vertical columns that represent zones from left to right: Control (ISA-95 Level 2), Operations management (ISA-95 Level 3), Edge (with internet access), Edge management, Data acquisition and brokering, Data analytics and storage, API, and Apps.
In the control and operations management zones, a box labeled two production lines in two locations (simulated on a Windows VM) contains an MES. Below the MES are two groups of assets. The first group, labeled OPC UA-enabled assets, uses the OPC UA Client/Server protocol to communicate with an edge gateway. The second group, labeled Non-OPC UA assets, connects through a Web of Things connectivity solution by using any interface and then connects to the edge gateway. In the edge zone, an edge gateway contains nested infrastructure layers. The outermost layer is Linux. Kubernetes runs inside that layer. In the Kubernetes layer, several components are shown: the OPC UA connector ingests data, UA-CloudAction handles cloud-to-edge commands, MQ represents the MQTT broker, dataflows connect MQ to Event Hubs, and a schema registry manages schemas. These components operate under Azure IoT Operations. In the edge management zone, Azure Arc and Azure IoT Operations send management signals to the edge gateway. In the Data acquisition and brokering zone, an Event Hubs Kafka message broker receives data from the edge gateway. In the Data analytics and storage zone, the diagram shows a primary path and an alternative path. The primary path leads from Event Hubs to Azure Data Explorer, which stores and queries the ingested OPC UA telemetry. The alternative path routes the same Event Hubs data to Azure Databricks. In the API zone, the primary path connects from a component labeled I3X4Kusto to Azure Data Explorer via an arrow labeled Queries. In the alternative path, queries connect to Azure Databricks. In the Apps zone, the primary path branches into two destinations: Azure Data Explorer dashboards and a custom app. The alternative path terminates in Azure Databricks dashboards.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/how-to-connect-azure-data-explorer.pptx) of this architecture.*


## Automated deployment

Select **Deploy to Azure** to deploy all required resources to your Azure subscription:

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdigitaltwinconsortium%2FManufacturingOntologies%2Fmain%2FDeployment%2Farm.json)

> [!NOTE]
> The deployment can take up to 100 minutes to complete. After the deployment finishes, you can access the VM via SSH by using the credentials you provided during deployment.

## Deploy a dashboard

You can deploy a [sample dashboard](https://github.com/digitaltwinconsortium/ManufacturingOntologies/blob/main/Tools/ADXQueries/dashboard-ontologies.json). For more information, see [To create new dashboard from a file](/azure/data-explorer/azure-data-explorer-dashboards#to-create-new-dashboard-from-a-file). After you import the dashboard, update its data source. Specify the HTTPS endpoint of your Azure Data Explorer server cluster in the top-right corner of the dashboard. The HTTPS endpoint looks like this: `https://<ADXInstanceName>.<AzureRegion>.kusto.windows.net/`.

To display the OEE for a specific shift, select **Custom Time Range** in the **Time Range** list in the top-left corner of the Azure Data Explorer dashboard and enter the date and time for the start and end of the shift you're interested in.

The sample dashboard also includes a **Unified NameSpace (UNS) / ISA-95 Graph** tile that renders the Unified Namespace / ISA-95 asset hierarchy as an interactive node-link graph.

## i3X API

An [i3X API](https://i3x.dev) container app named `<resourcesName>-i3x4kusto` is deployed, exposing Azure Data Explorer over the i3X REST API. You can get its URL from the Azure portal. You can access the Swagger endpoint by adding `/swagger` to the URL.

The i3X API is protected with HTTP Basic authentication. All requests, including those from the Swagger **Authorize** dialog or an i3X client, must include the credentials you provided during deployment:

- **Username**: the `adminUsername` you specified at deployment
- **Password**: the `adminPassword` you specified at deployment

The health/capabilities endpoint (`GET /v1/info`) and the Swagger UI itself can be accessed without credentials. All data endpoints require the Basic authorization header (for example `curl -u <adminUsername>:<adminPassword> https://<i3x-url>/v1/namespaces`).

## Run a query

Open your Azure Data Explorer database and select **Queries**. Because the telemetry `Subject` is the numeric `DataSetWriterId`, the station and production line are matched on the metadata `DataSetName` (built from the OPC UA server's `ApplicationUri` and `NodeId`) and then joined to the telemetry on `Subject`. Enter the following query in the text box, and then select **Run**:

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
|  extend status = toint(Value)
| project Timestamp1, status
| sort by Timestamp1 desc
| render linechart
```

## Next steps

- [Azure Data Explorer](/azure/data-explorer/data-explorer-overview)

## Related resources

- [OPC UA reference solution](iot-industrial-solution-architecture.md)
- [Connect Azure Databricks to the reference solution](how-to-connect-databricks-to-solution.md)
- [Connect Fabric to the reference solution](how-to-connect-fabric-to-solution.md)

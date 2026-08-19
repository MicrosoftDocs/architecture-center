---
title: "Connect Azure Databricks to the Reference Solution"
description: "Learn how to ingest and analyze OPC UA industrial IoT data in Azure Databricks by using Delta Lake and Structured Streaming."
author: erichb
ms.author: erichb
ms.subservice: architecture-guide
ms.topic: concept-article
ms.date: 07/22/2026
ai-usage: ai-assisted
---

# Connect Azure Databricks to the OPC UA reference solution

This article describes how to connect Azure Databricks to the [OPC UA reference solution](iot-industrial-solution-architecture.md).

[Azure Databricks](/azure/databricks/introduction/) is a unified, open analytics platform for creating, deploying, and maintaining data engineering, data science, and machine learning workloads at scale. It's built on Apache Spark and the Delta Lake lakehouse architecture. In this reference solution, it uses Structured Streaming to ingest OPC UA telemetry from Azure Event Hubs into governed Delta Lake tables. Azure Databricks provides reliable, ACID-compliant storage that combines the flexibility of a data lake with the performance of a data warehouse. Its collaborative notebooks, built-in machine learning and MLflow, and integration with the rest of the Azure ecosystem make it well suited to advanced analytics such as forecasting and anomaly detection over industrial data.

## Architecture

The following diagram illustrates the OPC UA solution. It shows Azure Databricks as an analytics back end, marked here as an alternative option. It also shows Azure Data Explorer as an analytics back end.

:::image type="complex" source="media/databricks-solution-architecture.svg" alt-text="Architecture diagram of the OPC UA reference solution. It shows the data flow from OPC UA assets through an edge gateway and Azure Event Hubs to Azure Databricks. This path is marked as an optional alternative. Azure Data Explorer is shown as a second analytics back end." lightbox="media/databricks-solution-architecture.svg" border="false":::
The diagram shows the end-to-end architecture of the OPC UA reference solution, organized into eight horizontal columns that represent zones from left to right: Control (ISA-95 Level 2), Operations management (ISA-95 Level 3), Edge (with internet access), Edge management, Data acquisition and brokering, Data analytics and storage, API, and Apps. In the control and operations management zones, a box labeled two production lines in two locations (simulated on a Windows VM) contains an MES. Below the MES are two groups of assets. The first group, labeled OPC UA-enabled assets, uses the OPC UA Client/Server protocol to communicate with the edge gateway. The second group, labeled Non-OPC UA assets, connects through a Web of Things connectivity solution by using any interface and then connects to the edge gateway. In the edge zone, an edge gateway contains nested infrastructure layers. The outermost layer is Linux. Kubernetes runs inside that layer. In the Kubernetes layer, several components are shown inside an Azure IoT Operations box: the OPC UA connector ingests data, UA-Cloud Action handles cloud-to-edge commands, MQ represents the MQTT broker, dataflows connect MQ to Event Hubs, and a schema registry manages schemas. In the edge management zone, Azure Arc and Azure IoT Operations send management signals back to the edge gateway. In the Data acquisition and brokering zone, an Event Hubs Kafka message broker receives data from the edge gateway. In the Data analytics and storage zone, the diagram shows a primary path and an alternative path. The primary path leads from Event Hubs to Azure Data Explorer, which stores and queries the ingested OPC UA telemetry. The alternative path routes the same Event Hubs data to Azure Databricks. In the API zone, the primary path connects from a component labeled I3X4Kusto to Azure Data Explorer via an arrow labeled Queries. In the alternative path, queries connect to Azure Databricks. In the Apps zone, the primary path branches into two destinations: Azure Data Explorer dashboards and a custom app. The alternative path terminates in Azure Databricks dashboards.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/how-to-connect-azure-data-explorer.pptx) of this architecture.*

## Automated deployment

The reference solution's deployment script can automatically deploy and configure Azure Databricks as a second analytics option alongside Azure Data Explorer. To enable Azure Databricks, set the Deploy Databricks (`deployDatabricks`) parameter to `true`. Azure Data Explorer remains the default and is unaffected. Azure Databricks reads the same `data` and `metadata` event hubs through a separate `databricks` consumer group, so both databases ingest the data side by side.

The deployment creates a Premium workspace and a serverless SQL warehouse. Deploy to a [region that supports Databricks SQL Serverless](/azure/databricks/resources/feature-region-support#serverless-availability).

Select **Deploy to Azure** to deploy all required resources to your Azure subscription:

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdigitaltwinconsortium%2FManufacturingOntologies%2Fmain%2FDeployment%2Farm.json)

## Use the sample dashboard

The reference solution includes a sample AI/BI dashboard that mirrors the use cases of the Azure Data Explorer dashboard: condition monitoring, overall equipment effectiveness (OEE) calculation, energy consumption, production, and diagnostics for the Munich and Seattle production lines. The dashboard is already imported and published against a SQL warehouse. Just open it from **Dashboards** in your workspace.

## Run a query

You can query your Delta Lake data by using SQL or PySpark. The following example query joins metadata and telemetry. It's equivalent to the Azure Data Explorer and Fabric queries. Because the telemetry `Subject` is the numeric `DataSetWriterId`, the station and production line match on the metadata `DataSetName`, which is derived from the OPC UA server's ApplicationUri and NodeId. The station and production line then join to the telemetry on `Subject`. (In Azure IoT Operations, the station and production line usually aren't encoded in `DataSetName`. Replace these filters with values that match your asset or database naming convention.)

```sql
-- The notebook creates these objects in the `ontologies` schema of your workspace catalog by default.
-- Replace <your_catalog> with your workspace catalog name. (Run `SELECT current_catalog()` to find it.)
USE CATALOG `<your_catalog>`;
USE SCHEMA ontologies;

-- Find the status of all assembly stations in Munich in the last hour.
SELECT
    m.DataSetName,
    m.DisplayName,
    m.Workcell,
    m.Line,
    t.Timestamp,
    t.Value
FROM opcua_metadata_lkv m
INNER JOIN opcua_telemetry t
    ON m.Subject = t.Subject
WHERE m.DataSetName LIKE '%assembly%'
  AND m.DataSetName LIKE '%munich%'
  AND t.Name = 'Status'
  AND t.Timestamp > current_timestamp() - INTERVAL 1 HOUR;
```

## Next steps

- [Azure Databricks](/azure/databricks/introduction/)

## Related resources

- [OPC UA reference solution](iot-industrial-solution-architecture.md)
- [Connect Azure Data Explorer to the OPC UA reference solution](how-to-connect-azure-data-explorer-to-solution.md)  
- [Connect Fabric to the OPC UA reference solution](how-to-connect-fabric-to-solution.md)
---
title: Connect Azure Managed Grafana to the OPC UA Reference Solution
description: Learn how to connect Azure Managed Grafana to the Open Platform Communications Unified Architecture (OPC UA) reference solution to get visualization for your data.
author: barnstee
ms.author: erichb
ms.topic: concept-article
ms.subservice: architecture-guide
ms.date: 07/22/2026
---

# Connect Azure Managed Grafana to the OPC UA reference solution

You can use [Azure Managed Grafana](/azure/managed-grafana/overview) to create a dashboard on Azure for the [OPC UA reference solution](iot-industrial-solution-architecture.md). Use Grafana in manufacturing to create dashboards that display real-time data. This article shows how to enable Grafana on Azure and create a dashboard with simulated production line data from Azure Data Explorer.

## Architecture

The following diagram illustrates the OPC UA solution. It shows Azure Managed Grafana querying Azure Data Explorer for industrial IoT analytics dashboards.

:::image type="complex" source="./media/grafana-solution-architecture.svg" alt-text="Architecture diagram of the reference solution that shows Azure Managed Grafana querying Azure Data Explorer for industrial IoT analytics dashboards." lightbox="./media/grafana-solution-architecture.svg" border="false":::
The diagram shows an industrial data pipeline that starts in an on-premises environment and ends in cloud visualization. On the left, source systems publish operational streams, including telemetry and metadata, into Azure Event Hubs in the center. Event Hubs acts as the shared ingestion layer, and arrows show both streams moving into the hub and then continuing to the analytics store. To the right of Event Hubs, Azure Data Explorer receives and stores the incoming streams as the primary query layer. Farther to the right, Azure Managed Grafana connects to Azure Data Explorer as a data source. Arrows indicate query traffic from Azure Managed Grafana to Azure Data Explorer and results flowing back to dashboards. The final stage is a Grafana dashboard surface for near real-time views, with the flow emphasizing progression from ingestion to analytics, and then to visualization and alerting.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/how-to-connect-grafana.pptx) of this architecture.*

## Enable the Azure Managed Grafana service

Create an Azure Managed Grafana instance and configure it with permissions to access the ontologies database:

1. In the Azure portal, search for *Grafana*, and then select the **Azure Managed Grafana** service.
1. On the **Azure Managed Grafana** page, select **Create**.
1. On the **Create Grafana Workspace** page, enter a name for your instance. Use the default values for the other options.
1. Select **Review + create**. After validation passes, select **Create**.
1. After the service is created, make sure your Azure Managed Grafana instance has a system-assigned managed identity. In the Azure portal, go to the page for your Azure Managed Grafana instance. Go to **Settings** > **Identity**. If the system-assigned managed identity isn't enabled, enable it. Note the **Object (principal) ID** value. You'll need it later.
1. To grant permission for the managed identity to access the ontologies database in Azure Data Explorer:

    1. Go to your Azure Data Explorer instance in the Azure portal.
    1. Under **Overview**  > **Permissions**, select **Add** > **Viewer**.
    1. Search for and select the **Object (principal) ID** value that you noted earlier.

## Add a new data source in Grafana

Add a new data source to connect to Azure Data Explorer. For this solution, use a system-assigned managed identity to connect to Azure Data Explorer.

To add the data source in Grafana, follow these steps:

1. Go to the endpoint URL for your Grafana instance. You can find the endpoint URL on the Azure Managed Grafana page for your instance in the Azure portal. 
1. Sign in to your Grafana instance.
1. In the Grafana dashboard, select **Connections** > **Data sources**, and then select **Add new data source**. Scroll down and select **Azure Data Explorer Datasource**.
1. Choose **Managed Identity** as the authentication method.
1. Add the URL of your Azure Data Explorer cluster. You can find the URL on the **Overview** page of your Azure Data Explorer instance in the Azure portal under **URI**.
1. Select **Save & test** to verify the datasource connection.

## Import a sample dashboard

Now you're ready to import the sample dashboard.

1. Download the [Sample Grafana Manufacturing Dashboard](https://github.com/digitaltwinconsortium/ManufacturingOntologies/blob/main/Tools/GrafanaDashboard/samplegrafanadashboard.json).
1. In the left pane of Grafana, go to **Dashboards** and then select **New** > **Import**.
1. Select **Upload dashboard JSON file**, and then select the **samplegrafanadashboard.json** file that you downloaded earlier. Select **Import**.
1. On the menu on the **OEE Station** tile, select **Edit**, and then select the Azure Data Explorer data source that you set up earlier.
1. Select **KQL** in the **Queries** pane and add the following query: `print round (CalculateOEEForStation('${Station}', '${Location}', '${CycleTime}', '${__from:date:iso}', '${__to:date:iso}') * 100, 2)`. Select **Apply** to apply your changes and go back to the dashboard.
1. On the menu on the **OEE Line** tile, select **Edit**, and then select the Azure Data Explorer data source that you set up earlier. 
1. Select **KQL** in the **Queries** pane and add the following query: `print round(CalculateOEEForLine('${Location}', '${CycleTime}', '${__from:date:iso}', '${__to:date:iso}') * 100, 2)`. Select **Apply** to apply your changes and go back to the dashboard.
 1. On the menu on the **Discarded products** tile, select **Edit**, and then select the Azure Data Explorer data source that you set up earlier. 
 1. Select **KQL** in the **Queries** pane and add the following query: `opcua_metadata_lkv | where DataSetName contains '${Station}' | where DataSetName contains '${Location}' | join kind=inner (opcua_telemetry | where Name == "NumberOfDiscardedProducts" | where Timestamp > todatetime('${__from:date:iso}') and Timestamp < todatetime('${__to:date:iso}')) on Subject | extend numProd = toint(Value) | summarize max(numProd)`. Select **Apply** to apply your changes and go back to the dashboard.
1. On the menu on the **Manufactured products** tile, select **Edit**, and then select the Azure Data Explorer data source that you set up earlier. 
1. Select **KQL** in the **Queries** pane and add the following query: `opcua_metadata_lkv | where DataSetName contains '${Station}' | where DataSetName contains '${Location}' | join kind=inner (opcua_telemetry | where Name == "NumberOfManufacturedProducts" | where Timestamp > todatetime('${__from:date:iso}') and Timestamp < todatetime('${__to:date:iso}')) on Subject | extend numProd = toint(Value) | summarize max(numProd)`. Select **Apply** to apply your changes and go back to the dashboard.
1. On the menu on the **Energy Consumption** tile, select **Edit**, and then select the Azure Data Explorer data source that you set up earlier. 
1. Select **KQL** in the **Queries** pane and add the following query: `opcua_metadata_lkv | where DataSetName contains '${Station}' | where DataSetName contains '${Location}' | join kind=inner (opcua_telemetry | where Name == "EnergyConsumption" | where Timestamp > todatetime('${__from:date:iso}') and Timestamp < todatetime('${__to:date:iso}')) on Subject | extend NodeValue = todouble(Value) | project Timestamp1, NodeValue`. Select **Apply** to apply your changes and go back to the dashboard.
1. On the menu on the **Pressure** tile, select **Edit**, and then select the Azure Data Explorer data source that you set up earlier. 
1. Select **KQL** in the **Queries** pane and add the following query: `opcua_metadata_lkv| where DataSetName contains '${Station}'| where DataSetName contains '${Location}'| join kind=inner (opcua_telemetry    | where Name == "Pressure"    | where Timestamp > todatetime('${__from:date:iso}') and Timestamp < todatetime('${__to:date:iso}')) on Subject | extend NodeValue = toint(Value)| project Timestamp1, NodeValue`. Select **Apply** to apply your changes and go back to the dashboard.

## Configure alerts

In Grafana, you can also create alerts. In this example, you create a low OEE alert for one of the production lines.

1. In the left pane of Grafana, go to **Alerting** > **Alert rules**.
1. Select **New alert rule**.
1. Enter a name for your alert, and select **Azure Data Explorer** as the data source. Under **Define query and alert condition**, select **KQL**.
1. In the query field, enter the following query. This example uses the Seattle production line:

    ```kql
    let oee = CalculateOEEForStation("assembly", "seattle", 10000, now(-1h), now());
    print round(oee * 100, 2)
    ```
1. Select **Set as alert condition**.
1. Scroll down to the **Expressions** section. Delete the **Reduce** expression.
1. For the alert threshold, select **A** as **Input**. Select **IS BELOW** and enter **10**.
1. Scroll down to the **Set evaluation behavior** section. Create a new **Folder** to save your alerts. Create a new **Evaluation group** and specify **2m**.
1. Select **Save rule and exit** in the upper right corner.

In the overview of your alerts, you can now see that an alert is triggered when your OEE is less than 10.

## Next steps

- [What is Azure Managed Grafana?](/azure/managed-grafana/overview)

## Related resources

- [OPC UA reference solution](iot-industrial-solution-architecture.md)
- [Connect Azure Data Explorer to the OPC UA reference solution](how-to-connect-azure-data-explorer-to-solution.md)
- [Connect Power BI to the OPC UA reference solution](how-to-connect-power-bi-to-the-solution.md)
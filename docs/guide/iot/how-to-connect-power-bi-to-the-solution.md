---
title: "Connect Power BI to the OPC UA Reference Solution"
description: "Learn how to connect Power BI to the Open Platform Communications Unified Architecture (OPC UA) reference solution to provide visualization for your data."
author: erichb
ms.author: erichb
ms.topic: concept-article
ms.subservice: architecture-guide
ms.date: 07/22/2026
ai-usage: ai-assisted
---

# Connect Power BI to the OPC UA reference solution

This article describes how to connect Microsoft Power BI to the [OPC UA reference solution](iot-industrial-solution-architecture.md).

[Power BI](/power-bi/fundamentals/power-bi-overview) is a unified, self-service business intelligence platform that turns data from many sources into interactive, shareable dashboards and reports. For this reference solution, it connects to the OPC UA telemetry and lets business users and plant managers explore key manufacturing metrics, such as OEE, production counts, and energy consumption, by using interactive visualizations. Mobile access and sharing capabilities make the industrial data available to decision-makers.

To connect the solution to Power BI, you need access to a Power BI subscription.

## Architecture

The following diagram illustrates the OPC UA solution. It shows industrial telemetry flowing through Azure IoT Operations and Azure Data Explorer into Power BI dashboards.

:::image type="complex" source="./media/power-bi-solution-architecture.svg" alt-text="Architecture diagram that shows industrial telemetry flowing through Azure IoT Operations and Azure Data Explorer into Power BI dashboards." lightbox="./media/power-bi-solution-architecture.svg" border="false":::
The diagram shows an industrial data pipeline from edge assets to business reporting. On the left, OPC UA-enabled and non-OPC UA production-line assets connect through an edge gateway that runs Azure IoT Operations services on Kubernetes, including the OPC UA connector, message queue, dataflows, and schema registry. Telemetry flows through a firewall to Azure Event Hubs and then to Azure Data Explorer, where data is stored and queried. On the right, Power BI connects to Azure Data Explorer to visualize metrics such as production, OEE, energy usage, and station performance.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/how-to-connect-power-bi.pptx) of this architecture.*

To create the Power BI dashboard, complete the following steps:

1. Install [Power BI Desktop](/power-bi/fundamentals/desktop-latest-update).
1. Sign in to Power BI Desktop with the user account that has access to the Power BI subscription.
1. In the Azure portal, go to the **ontologies** Azure Data Explorer database and grant **Viewer** permission to the Microsoft Entra ID user who connects from Power BI.
1. In Power BI, create a new report and select Azure Data Explorer time-series data as a data source: **Get data** > **Azure** > **Azure Data Explorer (Kusto)**.
1. In the dialog box, enter the Azure Data Explorer endpoint of your cluster (`https://<your cluster name>.<location>.kusto.windows.net`), the database name (`ontologies`), and the following query:

    ```kql
    let _startTime = ago(1h);
    let _endTime = now();
    opcua_metadata_lkv
    | where DataSetName contains "assembly"
    | where DataSetName contains "munich"
    | join kind=inner (opcua_telemetry
        | where Name == "ActualCycleTime"
        | where Timestamp > _startTime and Timestamp < _endTime
    ) on Subject
    | extend NodeValue = todouble(Value)
    | project Timestamp1, NodeValue
    ```

1. Sign in to Azure Data Explorer by using the Microsoft Entra ID user you gave permission to access the Azure Data Explorer database.
1. Select **Load**. This action imports the actual cycle time of the assembly station of the Munich production line for the last hour.
1. From the `Table view`, select the **NodeValue** column, and then select **Don't summarize** under **Summarization**.
1. Switch to the `Report view`.
1. Under **Visualizations**, select the **Line Chart** visualization.
1. Under **Visualizations**, move the `Timestamp1` field from the `Data` source to the `X-axis`, select it, and then select **Timestamp1**.
1. Under **Visualizations**, move the `NodeValue` field from the `Data` source to the `Y-axis`, select it, and then select **Median**.
1. Save your new report.

>[!Tip]
>Use the same approach to add other data from Azure Data Explorer to your report.

[![Screenshot that shows a Power BI view.](./media/power-bi.png)](./media/power-bi.png#lightbox)

## Next steps

- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)

## Related resources

- [OPC UA reference solution](iot-industrial-solution-architecture.md)
- [Connect Azure Data Explorer to the OPC UA reference solution](how-to-connect-azure-data-explorer-to-solution.md)
- [Connect Azure Managed Grafana to the OPC UA reference solution](how-to-connect-grafana-to-solution.md)
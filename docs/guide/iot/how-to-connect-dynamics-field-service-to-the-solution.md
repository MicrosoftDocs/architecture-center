---
title: Connect Dynamics 365 Field Service to the OPC UA Reference Solution
description: Learn how to use Logic Apps and Azure Data Explorer to create customer assets and IoT alerts in Dynamics 365 Field Service from industrial OPC UA telemetry.
author: barnstee
ms.author: erichb
ms.topic: concept-article
ms.subservice: architecture-guide
ms.date: 07/22/2026
ai-usage: ai-assisted
---

# Connect Dynamics 365 Field Service to the OPC UA reference solution

This article describes how to connect the [OPC UA reference solution](iot-industrial-solution-architecture.md) to Microsoft Dynamics 365 Field Service by using Azure Logic Apps. You use Azure Data Explorer queries and Microsoft Dataverse actions to populate customer assets and automatically create IoT alerts when telemetry crosses certain thresholds. This approach helps you connect plant telemetry to service workflows so operations teams can respond faster.

## Architecture

:::image type="complex" source="./media/field-service-solution-architecture.svg" alt-text="Architecture diagram that shows industrial telemetry from edge assets flowing through Azure IoT Operations, Event Hubs, Azure Data Explorer, and Logic Apps into Dynamics 365 Field Service." lightbox="./media/field-service-solution-architecture.svg" border="false":::
The diagram shows an end-to-end flow from industrial assets to service operations. On the left, OPC UA-enabled and non-OPC UA assets in two simulated production lines connect through an edge gateway that hosts Azure IoT Operations components, like the OPC UA connector, message queue, dataflows, and schema registry on Kubernetes. Telemetry moves through a firewall to Event Hubs and then into Azure Data Explorer, where time-series data is stored and queried. Azure Logic Apps reads query results and runs workflow actions in Dynamics 365 Field Service to create or update customer assets and generate IoT alerts.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/connect-to-dynamics-365.pptx) of this architecture.*

This integration supports the following scenarios:

- Upload assets from the reference solution to Dynamics 365 Field Service.
- Create alerts in Dynamics 365 Field Service when a certain threshold on reference solution telemetry data is reached.

The integration uses Logic Apps. With Logic Apps, you can use no-code workflows to connect business-critical apps and services. This example shows how to retrieve data from Azure Data Explorer and trigger actions in Dynamics 365 Field Service.

If you're not a Dynamics 365 Field Service customer, you can activate a [30-day trial](https://dynamics.microsoft.com/field-service/field-service-management-software/free-trial).

> [!TIP]
> To avoid the need to configure cross-tenant authentication, use the same Microsoft Entra ID that you used to deploy the reference solution.

## Create a Logic Apps workflow to create assets in Dynamics 365 Field Service

To upload assets from the reference solution into Dynamics 365 Field Service:

1. Go to the Azure portal and create a new logic app resource. Give the logic app a name, and place it in the same resource group as the reference solution.
1. In the left pane of the logic app page, select **Workflows** > **Workflows**.
1. On the **Workflows** page, select **Create**.
1. Give your workflow a name. For this scenario, use the stateful workflow type because assets aren't flows of data. Select **Create**.
1. After the workflow is created, select the workflow name in the list of workflows.
1. In the workflow designer, select **Add a trigger**. Create a **Recurrence** trigger to run every day. Or you can change the trigger to occur more frequently.
1. To add an action after the recurrence trigger, select the plus sign below the trigger on the main screen, and then select **Add an action**. In the **Add an action** pane, search for **Azure Data Explorer** and then select **Run KQL query**. Leave the default authentication: **OAuth**. Enter your Azure Data Explorer cluster URL and `ontologies` as the database name.
1. Under **Query**, enter the following query to get assets from the reference solution. This query checks what kind of assets you have.

   ```kql
   opcua_telemetry
   | join kind=inner (
       opcua_metadata
       | distinct DataSetName, Subject
       | extend AssetList = split(DataSetName, ';')
       | extend AssetName = tostring(AssetList[0])
   ) on Subject
   | project AssetName
   | summarize by AssetName
   ```

1. To get your asset data into Dynamics 365 Field Service, you need to connect to Dataverse. In **Add an action**, search for **Dataverse** and select **Add a new row**. Leave the default authentication: **OAuth**. Connect to your Dynamics 365 Field Service instance and use the following configuration:

    - In the **Table Name** box, select **Customer Assets**.
    - In the **Name** box, select **Enter data from a previous step**, and then select **AssetName**.

    :::image type="content" source="media/add-asset-name.png" alt-text="Screenshot of workflow designer that shows how to add the asset names to the table." lightbox="media/add-asset-name.png" border="false":::
1. Save your workflow and run it. You can see that the new assets are created in Dynamics 365 Field Service:

    :::image type="content" source="/en-us/azure/architecture/solution-ideas/media/concepts-iot-industrial-solution-architecture/dynamics-asset-table.png" alt-text="Screenshot that shows the new asset definitions in the field service asset table." lightbox="/en-us/azure/architecture/solution-ideas/media/concepts-iot-industrial-solution-architecture/dynamics-asset-table.png" border="false":::

## Create a Logic Apps workflow to create alerts in Dynamics 365 Field Service

This workflow creates alerts in Dynamics 365 Field Service when the `FaultyTime` for an asset in the reference solution reaches a threshold.

1. To retrieve the data, create an Azure Data Explorer function. In the Azure Data Explorer query page in the Azure portal, run the following code to create a `FaultyFieldAssets` function in the **ontologies** database:

   ```kql
   .create-or-alter function FaultyFieldAssets() {
   let Lw_start = ago(3m);
   opcua_telemetry
   | where Name == 'FaultyTime'
   | where todouble(Value) > 0
   | where Timestamp between (Lw_start .. now())
   | join kind=inner (
       opcua_metadata
       | extend AssetList = split(DataSetName, ';')
       | extend AssetName = tostring(AssetList[0])
       ) on Subject
   | project AssetName, Name, Value, Timestamp}
   ```

1. Create a new stateful workflow in your logic app.
1. In the workflow designer for the new workflow, create a recurrence trigger that runs every three minutes. Then add an action. Select the **Run KQL query** action.
1. Enter your Azure Data Explorer cluster URL, enter **ontologies** as the database name, and enter **FaultyFieldAssets()** as the query.
1. To get your asset data into Dynamics 365 Field Service, you need to connect to Dataverse. In **Add an action**, search for **Dataverse** and select **Add a new row**. Leave the default authentication: **OAuth**. Connect to your Dynamics 365 Field Service instance and use the following configuration:

    - In the **Table Name** box, select **IoT Alerts**.
    - In the **Description** box, use **Enter data from a previous step** to build a message: "**[AssetName]** has a **[Name]** of **[Value]**". **AssetName**, **Name**, and **Value** are the fields from the previous step.
    - In the **Alert Time** box, select **Enter data from a previous step**, and then select **Timestamp**.
    - In the **Alert Type** box, select **Anomaly**.

    :::image type="content" source="media/add-alert-details.png" alt-text="Screenshot that shows the logic app configuration to create an alert." lightbox="media/add-alert-details.png" border="false":::
1. Run the workflow to see new alerts generated in your Dynamics 365 Field Service **IoT Alerts** dashboard:

    :::image type="content" source="media/dynamics-iot-alerts.png" alt-text="Screenshot of alerts in Dynamics 365 Field Service." lightbox="media/dynamics-iot-alerts.png" border="false":::

## Next steps

- [Overview of Dynamics 365 Field Service](/dynamics365/field-service/overview)

## Related resources

- [OPC UA reference solution](iot-industrial-solution-architecture.md)
- [Connect Azure Data Explorer to the OPC UA reference solution](how-to-connect-azure-data-explorer-to-solution.md)
- [Connect Azure Managed Grafana to the reference solution](how-to-connect-grafana-to-solution.md)
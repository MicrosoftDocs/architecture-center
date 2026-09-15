---
title: Connect an On-Premises SAP System to the OPC UA Reference Solution
description: Learn how to connect an on-premises SAP ERP system to the OPC UA reference solution by using Azure Logic Apps and Azure Data Explorer.
author: barnstee
ms.author: erichb
ms.topic: concept-article
ms.subservice: architecture-guide
ms.date: 07/22/2026
---

# Connect on-premises SAP systems to the OPC UA reference solution

Many manufacturers use on-premises SAP Enterprise Resource Planning (ERP) systems. Manufacturers often connect SAP systems to industrial IoT solutions and use the connected system to retrieve data for manufacturing processes, customer orders, and inventory status. This article describes how to connect these SAP-based ERP systems to an industrial IoT solution.

> [!IMPORTANT]
> Before you can deploy this solution, you must first complete the [Azure Data Explorer deployment](how-to-connect-azure-data-explorer-to-solution.md).

This solution uses [IEC 62541, Open Platform Communications (OPC) Unified Architecture (UA)](https://opcfoundation.org) for all operational technology data.

## Architecture

The following diagram shows an overview of the solution:

:::image type="complex" source="media/sap-solution-architecture.svg" alt-text="Architecture diagram that shows SAP ERP integration with the OPC UA reference solution." lightbox="media/sap-solution-architecture.svg" border="false" :::
The diagram contains three ISA-95 layers on the left and cloud services on the right. On the left, simulated production lines, OPC UA-enabled assets, and non-OPC UA assets connect to an edge gateway. Non-OPC UA assets connect through a WoT connectivity solution. OPC UA assets connect directly via OPC UA Client/Server. A manufacturing execution system exchanges information with an SAP ERP system in the resource-planning layer. The SAP ERP system uses an SAP connector and RFC workflow trigger to call a data gateway at the edge. Inside the Linux-based edge gateway, Azure IoT Operations runs on Kubernetes and includes the OPC UA connector, message queue, dataflows, schema registry, and a UA-CloudAction component. Management flows connect Azure Arc and Azure IoT Operations to the edge environment. To the right, in the Data acquisition and brokering zone, Logic Apps receives an HTTP workflow trigger from the edge-management path and sends workflow actions into Azure Data Explorer in the Data analytics and storage zone. Telemetry from Azure IoT Operations flows through Azure Event Hubs as the message broker and is stored in Azure Data Explorer as a time-series database. Azure Data Explorer also returns query results that Logic Apps can use to drive actions, linking operational telemetry with SAP-driven business workflows.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/how-to-connect-sap.pptx) of this architecture.*

To learn more about the components in the solution, see the [OPC UA reference solution](iot-industrial-solution-architecture.md).

## Prerequisites

To complete the SAP connection as described in this article, you need an Azure industrial IoT solution deployed in an Azure subscription, as described in [OPC UA reference solution](iot-industrial-solution-architecture.md).

## Connect the reference solution to on-premises SAP systems

The Azure Logic Apps service handles connectivity to your on-premises SAP systems. Logic Apps is a no-code Azure service that orchestrates workflows that can trigger actions.

> [!NOTE]
> If you want to try out SAP connectivity before connecting your real SAP system, you can deploy and use an [SAP S/4 HANA Fully-Activated Appliance](https://cal.sap.com/catalog#/applianceTemplates) in your Azure subscription.

### Configure Logic Apps

The Logic Apps workflow moves data from your on-premises SAP system to Logic Apps. The workflow also stores the data that the SAP system sends to your Azure Storage account. To create a new Logic Apps workflow, follow these steps:

1. In the Azure portal, create a new Azure Storage account. Note the name of your account. You'll need it later when you configure the workflow.

1. In your storage account, select **Storage browser** in the left pane. Select **File shares** > **Add file share**. Enter **sap** as the name, select **Review and create**, and then select **Create**.

1. Deploy an instance of Logic Apps in the same region as your reference solution deployment. Select the consumption-based hosting option.

1. In the left pane of the Logic Apps instance, select **Development Tools** > **Logic app designer**. Select **Add a trigger**, and then select the **When an HTTP request is received** trigger template.

1. To add a new step, select the plus sign below the trigger and then select **Add an action**. In the **Add an action** pane, search for **Azure File Storage**, and then select **Create file**. Enter a name for the connection, the name of the storage account you created earlier, and the storage account key. Select **Create new**.

1. On the next page, in **Folder path**, enter **sap**, in **File name**, enter **IDoc.xml**, and in **File content**, select the lightning bolt icon and then select **Body**.

1. Save your workflow.

1. Select **Run** and wait for the run to finish. Verify that there are green check marks on both components of your workflow. If you see any red exclamation points, select the component for more information about the error.

Copy the **HTTP URL** from the HTTP trigger in your workflow. You need it when you configure your SAP system in the next step.

### Create a table in Azure Data Explorer

To store the data from your SAP system, create a table in your Azure Data Explorer database. To create the table, follow these steps:

1. In the Azure portal, go to your Azure Data Explorer database. You can use the **ontologies** database that's in the OPC UA reference solution.

1. Run the following Azure Data Explorer query:

    ```kusto
    .create table SAP (name:string, label:string)
    ```

    This query creates a table named **SAP** with two columns: **name** and **label**.

### Configure an on-premises SAP system

To configure an on-premises SAP system to send data to your Logic Apps workflow, follow these steps:

1. Sign in to the SAP Windows virtual machine.

1. On the virtual machine desktop, select **SAP Logon**.

1. Select **Log On** and sign in with your username and password:

    :::image type="content" source="media/log-on.png" alt-text="Screenshot that shows an SAP Log On button." lightbox="media/log-on.png":::

1. In the search box, enter **SM59** to display the **Configuration of RFC Connections** screen:

    :::image type="content" source="media/sm95-search.png" alt-text="Screenshot that shows the Configuration of RFC Connections screen." lightbox="media/sm95-search.png":::

1. Select **Edit > Create** in the application menu.

1. Enter **LOGICAPP** in the **Destination** field.

1. In the **Connection Type** list, select **G HTTP Connection to external server**. To save your changes, select the green check mark:

    :::image type="content" source="media/connection-logic-app.png" alt-text="Screenshot that shows the Create Destination dialog." lightbox="media/connection-logic-app.png":::

1. Enter **LOGICAPP** in **Description 1**.

1. On the **Technical Settings** tab, in the **Host** box, enter the first part of the HTTP GET URL from your Logic Apps workflow. For example: `https://example-18.westeurope.logic.azure.com`. In the **Port** box, enter **443**. In **Path Prefix**, enter the rest of the HTTP GET URL, starting with `/workflows/`:

    :::image type="content" source="media/add-get-url.png" alt-text="Screenshot that shows how to add a GET URL." lightbox="media/add-get-url.png":::

1. Select the **Login & Security** tab.

1. Scroll down to **Security Options**, and set **SSL** to **Active**.

1. Select **Save**.

1. In the search box, enter **WE21**. The **Ports in IDoc processing** screen appears.

1. Select the **XML HTTP** folder, and then select **Create**.

1. In the **Port** field, enter **LOGICAPP**.

1. In **RFC Destination**, select **LOGICAPP**.

1. To save your changes, select the green check mark:

    :::image type="content" source="media/port-select-logic-app.png" alt-text="Screenshot that shows port selection for a Logic App." lightbox="media/port-select-logic-app.png":::

1. In the search box, enter **WE20**. The **Partner profiles** screen appears.

1. Expand the **Partner Profiles** folder, and then select the **Partner Type LS** folder.

1. In the **Partner No.** box, select the **S4HCLNT100** partner profile.

1. Select the **Create outbound parameter** button:

    :::image type="content" source="media/outbound.png" alt-text="Screenshot that shows how to create an outbound parameter." lightbox="media/outbound.png":::

1. On the **Partner Profiles: Outbound Parameters** screen, in **Message Type**, enter **INTERNAL_ORDER**. On the **Outbound Options** tab, in the **Receiver port** box, enter **LOGICAPP**. Select **Pass IDoc Immediately**. In the **Basic type** box, enter **INTERNAL_ORDER01**. Select the **Save** button.

    :::image type="content" source="media/outbound-parameters.png" alt-text="Screenshot that shows outbound parameters." lightbox="media/outbound-parameters.png":::

### Test your SAP to Logic Apps workflow

To test your SAP to Logic Apps workflow, follow these steps:

1. In the search box, enter **WE19**. The **Test Tool for IDoc Processing** screen appears.

1. Select **Using message type** and then enter **INTERNAL_ORDER**.

1. Select **Create**.

1. Select the **EDICC** field to open the **Edit Control Record Fields** screen.

1. In the **Receiver** section, enter **LOGICAPP** in **Port**, enter **S4HCLNT100** in **Partner No.**, and enter **LS** in **Part. Type**.

1. In the **Sender** section, enter **SAPS4H** in **Port**, enter **S4HCLNT100** in **Partner No.**, and enter **LS** in **Part. Type**.

1. To save your changes, select the green check mark:

    :::image type="content" source="media/test-tool-idoc-processing.png" alt-text="Screenshot that shows the Test Tool for IDoc Processing screen." lightbox="media/test-tool-idoc-processing.png":::

1. Select **Standard Outbound Processing** at the top of the screen.

1. In the **Outbound Processing of IDoc** dialog, select the green check mark to start the IDoc message processing.

1. Open the storage browser in your Azure Storage account, select **File shares**, and validate that there's a new *IDoc.xml* file in the *sap* folder.

    > [!NOTE]
    > To check for IDoc message processing errors, enter **WE09** in the SAP application search box, select a time range, and then select the **execute** button. The **IDoc Search for Business Content** screen opens, and you can select each IDoc for processing errors in the table.

### Microsoft on-premises data gateway

To send data to on-premises SAP systems from Logic Apps, you can use a Microsoft on-premises data gateway.

> [!NOTE]
> The SAP connector and on-premises data gateway aren't required to receive data from on-premises SAP systems into Logic Apps in the cloud.

To install the on-premises data gateway:

1. Follow the steps in [Install an on-premises data gateway](/azure/logic-apps/logic-apps-gateway-install).

1. Follow the steps in [SAP Connector for Microsoft .NET](https://support.sap.com/en/product/connectors/msnet.html) to install the SAP Connector for Microsoft .NET 3.0 for Windows x64. SAP download access for the SAP portal is required. Contact SAP support if you don't have access.

1. Copy the *libicudecnumber.dll*, *rscp4n.dll*, *sapnco.dll*, and *sapnco_utils.dll* libraries from the SAP Connector installation location (typically *C:\Program Files\SAP\SAP_DotNetConnector3_Net40_x64*) to the installation location of the data gateway (typically *C:\Program Files\On-premises data gateway*).

1. Restart the data gateway by using the **On-premises data gateway** configuration tool that's included in the on-premises data gateway installer package you installed earlier.

1. Create the on-premises data gateway Azure resource in the same Azure region that you selected during the data gateway installation. Select the name of your data gateway in **Installation Name**.

    For more information, see [Connect to SAP from workflows in Azure Logic Apps](/azure/logic-apps/logic-apps-using-sap-connector).

    > [!NOTE]
    > If you encounter errors with the data gateway or the SAP connector, [enable debug tracing](/archive/blogs/david_burgs_blog/enable-sap-nco-library-loggingtracing-for-azure-on-premises-data-gateway-and-the-sap-connector).

## Related resources

- [OPC UA reference solution](iot-industrial-solution-architecture.md)
- [Connect Azure Data Explorer to the OPC UA reference solution](how-to-connect-azure-data-explorer-to-solution.md)

---
title: connecting to on-premises SAP systems
titleSuffix: Azure Reference Architectures
description: Step by step guide about how to connect on-premises SAP systems to Azure.
author: erichb
manager: kamv
ms.service: architecture-center
ms.subservice: reference-architecture
ms.topic: reference-architecture
ms.date: 3/25/2024
ms.author: erichb
ms.custom:
  - internal-intro
categories:
  - iot
products:
  - azure-iot-operations
  - azure-event-hubs
  - azure-data-explorer
---
 
## IEC 62541 Open Platform Communications Unified Architecture (OPC UA)

This solution leverages IEC 62541 Open Platform Communications Unified Architecture (OPC UA) for all Operational Technology (OT) data. This standard is described [here](https://opcfoundation.org). 


## Reference Solution Architecture

:::image type="content" source="../media/architecture-iiot-sap.png" alt-text="Simple IIoT architecture." lightbox="../media/architecture-iiot-sap.png" border="false" :::


## Connecting the Reference Solution to On-Premises SAP Systems

Note: If you want to simply try out SAP connectivity before connecting your real SAP system, you can deploy an `SAP S/4 HANA Fully-Activated Appliance` to Azure from [here](https://cal.sap.com/catalog#/applianceTemplates) and use that instead.

The Azure services handling connectivity to your on-premises SAP systems is called Azure Logic Apps. Azure Logic Apps is a no-code Azure service to orchestrate workflows that can trigger actions.

### Configuring Azure Logic Apps to Receive Data From On-Premises SAP Systems

To create a new Azure Logic Apps workflow from your on-premises SAP system to Azure Logic Apps and also store the data sent from SAP in your Azure Storage Account deployed in this reference solution, follow these steps:

1. Deploy an instance of Azure Logic Apps in the same region you picked during deployment of this reference solution via the Azure Portal. Select the consumption-based version.
1. From the Azure Logic App Designer, select the trigger template `When a HTTP request is received`.
1. Select `+ New step`, select `Azure File Storage` and select `Create file`. Give the connection a name and select the storage account name of the Azure Storage Account deployed for this reference solution. For `Folder path`, enter `sap`, for `File name` enter `IDoc.xml` and for `File content` select `Body` from the dynamic content. In the Azure Portal, navigate to your storage account deployed in this reference solution, select `Storage browser`, select `File shares` and select `Add file share`. Enter `sap` for the name and select `Create`.
1. Hover over the arrow between your trigger and your create file action, select the `+` button and select `Add a parallel branch`. Select `Azure Data Explorer` and add the action `Run KQL query` from the list of Azure Data Explorer actions available. Specify the ADX instance (Cluster URL) name and database name of your Azure Data Explorer service instance deployed in this reference solution. In the query field, enter `.create table SAP (name:string, label:string)`.
1. Save your workflow.
1. Select `Run Trigger` and wait for the run to complete. Verify that there are green check marks on all three components of your workflow. If you see any red exclamation marks, select the component for more info regardig the error.

Copy the `HTTP GET URL` from your HTTP trigger in your workflow. You will need it when configuring SAP in the next step.

### Configuring Your On-Premises SAP System to Send Data to Azure Logic Apps

1.	Log into the SAP windows VM
2.	Once at the VM desktop, Click on `SAP Logon` 
3.	Click `Log On` in the top left conner of the app

:::image type="content" source="../media/LogOn.png" alt-text="LogOn." lightbox="../media/LogOn.png" border="false" :::

4.	Log on with the `BPINST` user name, and `Welcome1` password
5.	In the top right conner search for `SM59`. This should bring up the `Configuration of RFC Connections` screen. 

:::image type="content" source="../media/SM95Search.png" alt-text="SM95 Search." lightbox="../media/SM95Search.png" border="false" :::

6.	Click on `Edit` and `Create` at the top of the app. 
7.	Enter `LOGICAPP` in the `Destination` field
8.	From the `Connection Type` dropdown select `HTTP Connection to external server`
9.	Click The green check at the bottom of the window. 

:::image type="content" source="../media/ConnectionLOGICAPP.png" alt-text="Connection LOGIC APP." lightbox="../media/ConnectionLOGICAPP.png" border="false" :::

10.	In the `Description 1` box put `LOGICAPP`
11.	Click the `Technical Settings` tab and fill in the `Host` field with the `HTTP GET URL` from the logic app you copied from above (e.g. prod-51.northeurope.logic.azure.com) . In `Port` put `443`. And in `Path Prefix` enter the rest of the `HTTP GET URL` starting with `/workflows/...`

:::image type="content" source="../media/AddgetURL.png" alt-text="Add get URL." lightbox="../media/AddgetURL.png" border="false" :::

12.	Click the `Login & Security` tab. 
13.	Scroll down to `Security Options`  and set `SSL` to `Active`
14.	Click `Save`
15.	In the main app from step 5, search for `WE21`. This will bring up the `Ports in IDoc processing`.
16.	Select the `XML HTTP` folder and click `Create`. 
17.	In the `Port` field input `LOGICAPP`
18.	In the `RFC destination` select `LOGICAPP`. 
19.	Click `Green Check` to `Save`

:::image type="content" source="../media/PortSelectLOGICAPP.png" alt-text="Port Select LOGIC APP." lightbox="../media/PortSelectLOGICAPP.png" border="false" :::

20. Create a partner profile for your Azure Logic App in your SAP system by entering `WE20` from the SAP system's search box, which will bring up the `Partner profiles` screen. 
21. Expand the `Partner Profiles` folder and select the `Partner Type LS` (Logical System) folder. 
21. Click on the `S4HCLNT100` partner profile. 
23. Click on the `Create Outbound Parameter` button below the `Outbound` table. 

:::image type="content" source="../media/Outbound.png" alt-text="Outbound." lightbox="../media/Outbound.png" border="false" :::

24. In the `Partner Profiles: Outbound Parameters` dialog, enter `INTERNAL_ORDER` for `Message Type`. In the `Outbound Options` tab, enter `LOGICAPP` for `Receiver port`. Select the `Pass IDoc Immediately` radio button. For `Basic type` enter `INTERNAL_ORDER01`. Click the `Save` button.

:::image type="content" source="../media/OutboundParams.png" alt-text="Outbound Params." lightbox="../media/OutboundParams.png" border="false" :::

### Testing your SAP to Azure Logic App Workflow

To try out your SAP to Azure Logic App workflow, follow these steps:

1.	In the main app, search for `WE19`. This should bring up the `Test Tool for IDoc Processing` screen.  
2.	Select `Using message type` and enter `INTERNAL_ORDER` 
3.	Click `Create` at the top left corner of the screen. 
4.	Click the `EDICC` field. 
5.	A `Edit Control Record Fields`  screen should open up. 
6.	In the `Receiver` section: `PORT` enter `LOGICAPP`, `Partner No.` enter `S4HCLNT100`, `Part. Type` enter `LS`
7.	In the `Sender` section: `PORT` enter `SAPS4H`, `Partner No.` enter `S4HCLNT100`, `Part. Type` enter `LS`
8.	Click the green check at the bottom of the window. 

:::image type="content" source="../media/Testing2.png" alt-text="Testing 2." lightbox="../media/Testing2.png" border="false" :::

9.	Click `Standard Outbound Processing` tab at the top of the screen. 
10.	In the `Outbound Processing of IDoc` dialog, click the green check button to start the IDoc message processing


Open the Storage browser of your Azure Storage Account, select Files shares and check that a new `IDoc.xml` file was created in the `sap` folder.

Note: To check for IDoc message processing errors, entering `WE09` from the SAP system's search box, select a time range and click the `execute` button. This will bring up the `IDoc Search for Business Content` screen and you can select each IDoc for processing errors in the table displayed.

### Microsoft On-Premises Data Gateway

Microsoft provides an on-premises data gateway for sending data **to** on-premises SAP systems from Azure Logic Apps.

Note: To receive data **from** on-premises SAP systems to Azure Logic Apps in the cloud, the SAP connector and on-premises data gateway is **not** required.

To install the on-premises data gateway, follow these steps:

1. Download and install the on-premises data gateway from [here](https://aka.ms/on-premises-data-gateway-installer). Pay special attention to the [prerequisits](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-install#prerequisites)! For example, if your Azure account has access to more than one Azure subscription, you need to use a different Azure account to install the gateway and to create the accompanying on-premises data gateway Azure resource. Simply create a new user in your Azure Active Directory if this is the case.
1. If not already installed, download and install the Visual Studio 2010 (VC++ 10.0) redistributables from [here](https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe).
1. Download and install the SAP Connector for Microsoft .NET 3.0 for Windows x64 from [here](https://support.sap.com/en/product/connectors/msnet.html?anchorId=section_512604546). SAP download access for the SAP portal is required. Contact SAP support if you don't have this.
1. Copy the 4 libraries libicudecnumber.dll, rscp4n.dll, sapnco.dll and sapnco_utils.dll from the SAP Connector's installation location (by default this is `C:\Program Files\SAP\SAP_DotNetConnector3_Net40_x64`) to the installation location of the data gateway (by default this is `C:\Program Files\On-premises data gateway`).
1. Restart the data gateway through the `On-premises data gateway` configuration tool that came with the on-premsis data gateway installer package installed earlier.
1. Create the on-premises data gateway Azure resource in the same Azure region as selected during the data gateway installation in the previous step and select the name of your data gateway under `Installation Name`.

:::image type="content" source="../media/gateway.png" alt-text="Data Gateway." lightbox="../media/gateway.png" border="false" :::

Note: Further background info regarding the configuration steps can be accessed [here](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-using-sap-connector?tabs=consumption).

Note: If you run into errors with the Data Gateway or the SAP Connector, you can enable debug tracing by following [these steps](https://learn.microsoft.com/en-us/archive/blogs/david_burgs_blog/enable-sap-nco-library-loggingtracing-for-azure-on-premises-data-gateway-and-the-sap-connector).

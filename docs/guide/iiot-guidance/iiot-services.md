---
title: Services in an Azure industrial IoT (IIoT) analytics solution
titleSuffix: Azure Application Architecture Guide
description: Explore services like time series, microservices, asset hierarchies, and calculations engines in an IIoT analytics solution.
author: khilscher
ms.author: kehilsch
ms.date: 05/03/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
  - fcp
categories:
  - internet-of-things
  - integration
products:
  - azure-data-explorer
  - azure-functions
  - azure-iot-hub
  - azure-logic-apps
  - azure-stream-analytics
ms.custom:
  - guide
---

# Services in an Azure industrial IoT (IIoT) analytics solution

This article builds on the basic [Azure industrial IoT (IIoT) analytics architecture](./iiot-architecture.yml) by discussing other subsystems and Azure services that IIoT analytics solutions use. Your solution might not use all these services, and might use other services.

## Time series service

IIoT systems collect time series data from IIoT devices at set intervals over a continuous time period. A time series data store has data measurements with corresponding time stamps. An IIoT analytics solution needs a time series service to provide warm and cold storage for time series data. You can run interactive analytics over warm data, and operational intelligence over cold storage and historical data.

[Azure Data Explorer](https://azure.microsoft.com/services/data-explorer) includes native support for creation, manipulation, and analysis of multiple time series with near real-time monitoring solutions and workflows. You can use Azure Data Explorer to develop a time series service. For more information, see [Time series analysis in Azure Data Explorer](/azure/data-explorer/time-series-analysis).

Azure Data Explorer provides a [Web UI](/azure/data-explorer/web-query-data), where you can run queries and [build data visualization dashboards](/azure/data-explorer/azure-data-explorer-dashboards).

> [!NOTE]
> IIoT systems that were using Azure Time Series Insights (TSI) for a time series service can migrate to Azure Data Explorer. The TSI service won't be supported after March 2025. For more information, see [Migrate to Azure Data Explorer](/azure/time-series-insights/migration-to-adx).

## Microservices

IIoT analytics solutions use several different types of microservices to satisfy their specific requirements.

You can use [Azure Functions](https://azure.microsoft.com/services/functions), an event-driven serverless compute platform, to develop stateless or stateful custom microservices. You can use Azure Cosmos DB, table storage, Azure SQL, or other databases to store state information.

Azure Functions helps you:

- Solve complex orchestration problems.
- Build and debug functions locally in several software languages without added setup.
- Deploy and operate at scale in the cloud.
- Integrate Azure services by using triggers and bindings.

For container-based microservices, consider using [Azure Service Fabric](https://azure.microsoft.com/services/service-fabric) or [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service). For more information, see [Microservices in Azure](https://azure.microsoft.com/solutions/microservice-applications).

Regardless of platform choice, you can use [Azure API Management](https://azure.microsoft.com/services/api-management) to create consistent and modern API gateways for microservices. API Management helps you abstract, publish, secure, and version your APIs.

The following sections describe common microservices in Azure IIoT analytics solutions.

### HTTP REST APIs for web applications

- You can create HTTP-triggered Azure Functions to implement your APIs.
- You can develop and host your REST APIs with Azure Service Fabric or AKS.

### REST API interfaces to factory floor OPC UA servers

- Use Azure IIoT components like [OPC Publisher](/azure/industrial-iot/overview-what-is-opc-publisher), [OPC Twin](https://github.com/Azure/Industrial-IoT/tree/main/docs/api/twin), and [OPC Vault](https://github.com/Azure/azure-iiot-opc-vault-service/blob/main/docs/opcvault-services-overview.md) for device discovery, registration, and remote control.
- Use AKS to host Azure IIoT microservices. To understand the deployment options, see [Deploy the Azure Industrial IoT Platform](https://github.com/Azure/Industrial-IoT/blob/master/docs/deploy/readme.md).

### Data transformation services

Different industrial equipment vendors send telemetry in different formats and schemas. When possible, convert different equipment schemas to common, canonical schemas, based on industry standards.

- Connect Azure Functions to IoT Hub to transform payloads, like converting binary to JSON or differing payloads to a common format.
- If the message body is binary, use functions to convert the incoming messages to JSON and send the converted messages back to IoT Hub.
- When the message body is binary, you can't use [IoT Hub message routing](/azure/iot-hub/iot-hub-devguide-messages-d2c) against the message body, but you can route against the [message properties](/azure/iot-hub/iot-hub-devguide-routing-query-syntax).
- Azure IIoT components can decode OPC UA binary messages to JSON.

### Data ingestion administrative services

Develop a data ingestion administrative service to add and update the list of SCADA *tags* your IIoT analytics solution monitors.

Tags are variables that map to I/O addresses on a PLC or RTU. Tag names vary among organizations, but often follow a pattern. For example, tag names for a pump with tag number `14P103` located in Station 001 (`STN001`) might have the following statuses:

- `STN001_14P103_RUN`
- `STN001_14P103_STOP`
- `STN001_14P103_TRIP`

The IIoT analytics solution must become aware of new tag names in the SCADA system, and subscribe to the tags to begin collecting their data. The solution might not subscribe to tags if their data is irrelevant to the solution.

In a SCADA system that supports OPC UA, new tags should appear as new `NodeID`s in the OPC UA hierarchy. For example, the preceding tag names might appear as:

- `ns=2;s= STN001_14P103_RUN`
- `ns=2;s= STN001_14P103_STOP`
- `ns=2;s= STN001_14P103_TRIP`

Use the following workflow to let solution administrators know about new or updated SCADA tags, and to update OPC Publisher with the tags. The workflow uses [Power Apps](https://powerapps.microsoft.com), [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps), and Azure Functions. For a code sample, see [OPC Publisher node configuration](https://github.com/Azure-Samples/iot-edge-opc-publisher-nodeconfiguration).

1. Whenever tags are created or edited in the SCADA system, the system operator triggers the Logic Apps workflow by using a Power Apps form.

   - Alternatively, Logic Apps [connectors](/azure/connectors/apis-list) can monitor a table in the SCADA system database for tag changes.
   - The Azure IIoT [Discovery Service](https://azure.github.io/Industrial-IoT/web-api/#discovery) can find OPC UA servers and the tags and methods they use.

1. In the approval step, the IIoT analytics solution owners can approve the new or updated tags.

1. Once the solution owners approve the new or updated tags and assign them a frequency, Logic Apps calls a function in Azure Functions.

1. The function calls the [OPC Twin](https://github.com/Azure/Industrial-IoT/tree/main/docs/api/twin) microservice, which directs the [OPC Publisher](/azure/industrial-iot/overview-what-is-opc-publisher) module to subscribe to the new tags.

   If your solution involves third-party software, configure the function to call a third-party API instead of OPC Publisher. Either call the API directly or by using an IoT Hub [direct method](/azure/iot-hub/iot-hub-devguide-direct-methods).

Alternatively, you can use [Microsoft Forms](https://forms.office.com) and [Power Automate](https://powerautomate.microsoft.com) for this workflow, instead of Power Apps and Logic Apps.

### Historical data ingestion

A  historical data ingestion service imports historical data from a SCADA, MES, or historian into an IIoT analytics solution. Loading historical data into an IIoT analytics solution consists of three steps:

1. Export the historical data.

   - Most SCADA, MES, or historian systems have a mechanism for exporting historical data, often as CSV files. Consult your system's documentation on how to export historical data.

   - If there's no export option, see if there's an API. Some systems support HTTP REST APIs or [OPC Historical Data Access (HDA)](https://en.wikipedia.org/wiki/OPC_Historical_Data_Access). You can build an application or use a Microsoft partner solution to connect to the API and query for historical data. Save the data to a file in CSV, Parquet, or TSV format.

1. Upload the data to Azure.

   - If the aggregated exported data size is small, you can upload the files to [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs) over the internet by using [Azcopy](/azure/storage/common/storage-use-azcopy-v10).

   - If the aggregated exported data size is large, consider using [Azure Import-Export Service](/azure/storage/common/storage-import-export-service) or [Azure Data Box](/azure/databox) to ship the files to the Azure region that deploys your IIoT analytics solution. The service imports the received files into your Azure Storage account.

1. Import the data by reading the files in Azure Storage and sending the data to Azure Data Explorer. You can use Azure Functions for this step.

> [!NOTE]
> Exporting large volumes of data from your industrial SCADA or historian system can place a significant performance load on that system. This load can negatively affect operations. Consider exporting smaller batches of historical data to minimize performance impacts.

## Rules and calculation engine

An IIoT analytics solution can do near real-time complex event processing (CEP) over streaming data, before the data enters a database. This CEP activity is called a *calculations engine*. The solution might also need to trigger actions, such as displaying an alert, based on streaming data. This capability is called a *rules engine*.

Azure Data Explorer is optimized to respond quickly and to simplify analytics for fast-flowing, rapidly changing streaming data. You can ask questions and iteratively explore data on the fly. Azure Data Explorer can quickly identify patterns, anomalies, and trends to monitor devices and optimize operations.

For example, a production manager wants to calculate the average number of widgets produced on a manufacturing line, over a time interval, to monitor productivity goals. [Data Explorer dashboards](/azure/data-explorer/azure-data-explorer-dashboards) can create and visualize the calculation. The [Data Explorer Web UI](/azure/data-explorer/web-query-data) provides a web experience for connecting to Azure Data Explorer.

### Azure Stream Analytics

For more advanced calculations or to implement a rules engine, you can use [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics). Stream Analytics is a real-time analytics and CEP engine that can analyze and process high volumes of streaming data from multiple sources simultaneously.

Stream Analytics can identify patterns and relationships in information from devices, sensors, click streams, social media feeds, and applications. You can use these patterns to trigger actions and workflows such as creating alerts, supplying report information, or storing transformed data.

You can develop a custom web application that uses the [Stream Analytics REST APIs](/rest/api/streamanalytics/) to let users create calculations, alerts, and actions. The web application creates associated jobs in Azure Stream Analytics.

For a rules engine, the Stream Analytics job output can call a function, which calls a logic app or a Power Automate task. The app or task can send an email alert or invoke [Azure SignalR](/aspnet/core/signalr/introduction) to display a message in the web application.

For example, a process engineer wants to calculate the [standard deviation](/stream-analytics-query/stdev-azure-stream-analytics) of widgets across production lines, to see when any line is more than two times beyond the mean. The engineer authors the calculations in the custom web application, which calls the Steam Analytics REST API to run the calculations. The application sends the job output to Azure Data Explorer to visualize in dashboards or in the web UI.

Stream Analytics supports processing events in CSV, JSON, and Avro data formats. You can use Azure Functions to do data transformation before sending the data to Stream Analytics.

Stream Analytics also supports using [reference data](/azure/stream-analytics/stream-analytics-use-reference-data), finite data sets that are static or change slowly. You can use reference data to do lookups or to augment data streams. A common scenario is joining asset metadata from an Enterprise Asset Management (EAM) system with real-time data from industrial devices.

Stream Analytics is available as an IoT Edge [module](https://azuremarketplace.microsoft.com/marketplace/apps/microsoft.stream-analytics-on-iot-?tab=Overview), for situations that need CEP at the edge. As an alternative to Stream Analytics, you can implement near real-time calculation and rules engines by using [Apache Spark streaming on Azure Databricks](/azure/databricks/getting-started/spark/streaming).

## Notifications

The IIoT analytics solution isn't a control system, so it doesn't require a complete [alarm management](https://en.wikipedia.org/wiki/Alarm_management) system. However, sometimes you might want to detect conditions in the streaming data and generate notifications or trigger workflows.

Examples include:

- The temperature of a heat exchanger exceeds a configured limit, which changes the color of an icon in your web application.
- A pump sends an error code that triggers a work order in your Enterprise Resource Planning (ERP) system.
- The vibration of a motor exceeds limits, triggering an email notification to an Operations Manager.

Azure Logic Apps offers automated, scalable workflows, business processes, and enterprise orchestrations. Logic Apps can integrate equipment and data across cloud services and on-premises systems.

1. Use Stream Analytics to define and detect conditions in streaming data.
1. Connect Stream Analytics to Logic Apps by using [Azure Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview). Use Logic Apps to define an email or SMS alert, or trigger a workflow.

For example, a plant manager creates and runs a job that monitors for specific error codes. The job implements an automated workflow whenever it receives the error codes from any equipment.

1. When Stream Analytics detects an error code, the job sends the error code to an Azure Service Bus queue output.
1. When the queue receives a message, it triggers a Logic App.
1. The Logic App runs the workflow the plant manager defined. The workflow might be creating a work order in Dynamics 365 or SAP, or sending an email to maintenance technicians.

The [Logic Apps REST API](/rest/api/logic/) can provide a user interface for authoring workflows, or you can build workflows in the Azure portal. A web application can use the [Stream Analytics REST API](/rest/api/streamanalytics) to provide a user interface for monitoring conditions.

To display visual alerts in your web application, create a Stream Analytics job to detect specific events and send the events to an Azure Functions output. Then [develop a function](/azure/azure-signalr/signalr-concept-azure-functions) that sends the events to your web application using [SignalR](/aspnet/core/signalr/introduction).

You can also ingest on-premises operational alarms and events into Azure for reporting and to trigger work orders, SMS messages, and emails.

### Microsoft 365

The IIoT analytics solution can also include [Microsoft 365](/office365) services to automate tasks and send notifications. For example:

- Receive email alerts in Microsoft Outlook or post a message to a Microsoft Teams channel when Stream Analytics recognizes a condition.
- Receive notifications as part of an approval workflow that's triggered by a Power App or Microsoft Forms submission.
- Create an item in a SharePoint list when an alert is triggered by a Logic App.
- Notify a user or execute a workflow when a new tag is created in a SCADA system.

## Machine learning

Training ML models by using historical industrial data adds predictive capabilities to your IIoT application. Data scientists can use the IIoT analytics solution to build and train models that predict factory floor events or recommend asset maintenance.

[Azure Machine Learning (Azure ML)](https://azure.microsoft.com/services/machine-learning) can [connect to data](/azure/machine-learning/how-to-create-register-datasets) stored in your Azure Storage account to create and train [forecasting models](/azure/machine-learning/how-to-auto-train-forecast). You can [deploy trained models](/azure/machine-learning/how-to-deploy-managed-online-endpoints) to an IoT Edge field gateway, or as a web service with Azure Functions or hosted on AKS.

If your organization is new to ML or doesn't have data scientists, you can use [Azure Cognitive Services](https://azure.microsoft.com/services/cognitive-services) to add cognitive features to your IIoT analytics solution. Azure Cognitive Services covers five main pillars: Vision, Speech, Language, Decision, and OpenAI. Cognitive Services APIs, SDKs, and services can help you create applications that see, hear, speak, understand, and begin to reason.

## Asset hierarchy

Asset hierarchies define asset classifications and relationships between assets. Many organizations maintain asset hierarchies within their industrial systems or within an EAM system. An example of an asset hierarchy is *Country/Region > Location > Facility > Room*. Periodically refresh your hierarchy as you update your EAM system.

Asset model [digital twins](/azure/digital-twins/concepts-twins-graph) combine dynamic asset data via real-time telemetry with static data, such as 3D models, and EAM metadata. Graph-based relationships let the digital twin change in real-time along with physical assets.

[Azure Digital Twins](https://azure.microsoft.com/services/digital-twins) is an Azure IoT service that can:

- Create comprehensive models of physical environments.
- Create spatial intelligence graphs to model relationships and interactions between people, places, and devices.
- Query data from a physical space rather than from disparate sensors.
- Build reusable, highly scalable, spatially aware experiences that link streaming data across the physical and digital world.

You can export your existing asset hierarchy and import it into Azure Digital Twins. For more information, see [Connected factory hierarchy service](../../solution-ideas/articles/connected-factory-hierarchy-service.yml).

## Business process integration

You might want your IIoT analytics solution to take actions based on insights from your industrial data. These actions can include triggering a workflow in your ERP or customer relationship management (CRM) systems. You can use Azure Logic Apps to integrate your IIoT analytics solution with your line-of-business systems. Azure Logic Apps has connectors to business systems and Microsoft services such as:

- Dynamics 365
- SharePoint Online
- Office 365 Outlook
- Salesforce
- SAP

The following example describes a workflow that integrates with line-of-business systems.

1. A Stream Analytics job detects an error code from a pump.
1. The job sends a message to Azure Service Bus that triggers a logic app to run.
1. The logic app sends an email notification to the plant manager by using the [Office 365 Outlook connector](/azure/connectors/connectors-create-api-office365-outlook).
1. The logic app also sends a message to the SAP S/4 HANA system, by using the [SAP connector](/azure/logic-apps/logic-apps-using-sap-connector).
1. The message creates an SAP service order.

## User management

User management in an IIoT analytics solution includes managing user profiles and defining the actions users can take.

User profile management involves:

- Creating new users.
- Updating users' profiles, such as their locations and phone numbers.
- Changing user passwords.
- Disabling user accounts.

You can use [Microsoft Graph](https://developer.microsoft.com/graph) for these operations.

To control which actions users can take and what data they can view in the system, use role-based access control (RBAC). Implement RBAC by using the [Microsoft identity platform](/azure/active-directory/develop) with [Azure Active Directory (Azure AD)](/azure/active-directory). Azure platform as a service (PaaS) services in an IIoT analytics solution can integrate directly with Azure AD, ensuring security across your solution.

Your web application and custom microservices can interact with the Microsoft identity platform. Use libraries such as the [Microsoft Authentication Library (MSAL)](/azure/active-directory/develop/msal-overview) and protocols such as OAuth 2.0 and OpenID Connect.

## Next steps

> [!div class="nextstepaction"]
> [Data analysis and visualization in Azure industrial IoT analytics](iiot-data.yml)

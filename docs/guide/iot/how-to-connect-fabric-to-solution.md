---
title: "Connect Microsoft Fabric to the OPC UA Reference Solution"
description: "Learn how to ingest and analyze OPC UA industrial IoT data by using Microsoft Fabric and KQL databases."
author: erichb
ms.author: erichb
ms.subservice: architecture-guide
ms.topic: concept-article
ms.date: 07/22/2026
ai-usage: ai-assisted
---

# Connect Fabric to the OPC UA reference solution

This article describes how to connect Microsoft Fabric to the [OPC UA reference solution](iot-industrial-solution-architecture.md).

[Fabric](/fabric/fundamentals/microsoft-fabric-overview) is an end-to-end analytics platform for data ingestion, transformation, real-time processing, analytics, and reporting. To use Fabric with this reference solution, you need an Azure subscription, the main industrial IoT solution deployed, and Fabric enabled for your tenant. For more information, see the prerequisites in the [Automated deployment section](#automated-deployment).

## Architecture

The following diagram illustrates the OPC UA solution. It shows Fabric as an analytics back end.

:::image type="complex" source="media/fabric-solution-architecture.svg" alt-text="Architecture diagram of the reference solution. It shows Fabric as an analytics option." lightbox="media/fabric-solution-architecture.svg" border="false":::
The diagram shows an industrial IoT reference architecture with Fabric as the analytics layer. The layout is divided into eight vertical zones arranged from left to right: Control (ISA-95 Level 2), Operations Management (ISA-95 Level 3), Edge (with Internet access), Edge management, Data acquisition and brokering, Data analytics and storage, API, and Apps. A firewall boundary separates the edge from the cloud. A box labeled Fabric contains an eventstream, an eventhouse, machine learning models, Microsoft OneLake, Power BI, and a dashboard. In the control and operations management zones, MES components appear at the top, representing communication between the shop-floor control level and the operations management level. Below the MES components, a group of OPC UA-enabled assets connects to the edge gateway by using the OPC UA Client/Server protocol. Separately, Non-OPC UA assets connect through a Web of Things connectivity solution by using any available interface and then connect to the edge gateway. In the Edge zone, an edge gateway contains nested infrastructure layers. The outermost layer is Linux. Kubernetes runs inside that layer. In the Kubernetes layer, several components are shown: the OPC UA connector ingests data, UA Cloud Action handles cloud-to-edge commands, MQ represents the MQTT broker, dataflows connect MQ to Event Hubs, and a schema registry manages schemas. These components operate under Azure IoT Operations. On the cloud side of the firewall, the Edge management zone contains two cloud management services: Azure Arc and Azure IoT Operations. Arrows labeled Management lead from these services, cross the firewall, and connect to the edge gateway. In the Data acquisition and brokering zone, an Event Hubs Kafka message broker receives data from the edge gateway. A label that reads Optional alternative leads from Azure Event Hubs to an eventstream icon. Below that icon is a machine learning models icon. The Data analytics and storage zone contains the eventhouse and OneLake icons. The eventhouse receives queries from UA Cloud Action. Arrows lead from the eventstream icon and the machine learning models to the eventhouse. Bidirectional arrows connect OneLake to the machine learning models and the eventhouse. In the API zone, an i3X component, labeled I3X4Kusto, sends queries to the eventhouse. The Apps zone contains three icons: a custom app, Power BI, and the dashboard. Arrows lead from Power BI and the dashboard to the eventhouse. The custom app sends queries to i3X.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/how-to-connect-fabric.pptx) of this architecture.*


## Automated deployment

The reference solution's deployment script can automatically deploy and configure Fabric as a third analytics option alongside Azure Data Explorer and Azure Databricks.

**Prerequisites**

1. **Verify Fabric capacity quota:** The deployment provisions an F2 capacity. Confirm that the subscription has sufficient Fabric quota in the target region. If this is the subscription's first Fabric capacity or its quota is zero, register the `Microsoft.Fabric` resource provider. For more information, see [Microsoft Fabric capacity quotas](/fabric/enterprise/fabric-quotas).  
1. **Deploy the main solution first:** Fabric uses the managed identity (`<resourcesName>-Identity`), the Azure Event Hubs namespace, the Azure Container Apps environment, and the `fabric` capacity created by the Azure Data Explorer deployment. Deploy this main solution first. (See [Connect Azure Data Explorer to the reference solution](how-to-connect-azure-data-explorer-to-solution.md).) Be sure to set the `deployFabricCapacity` parameter to `true` during that deployment.
1. **Enable Fabric for the tenant:** Deploying the F2 capacity in Azure doesn't turn on Fabric for your tenant. If `fabric.microsoft.com` switches to Power BI, a Fabric admin needs to enable Fabric. An admin can enable Fabric in the Fabric portal:
     1. Select **Settings (the gear icon)** > **Admin portal** > **Tenant settings** > **Microsoft Fabric** > **Users can create Fabric items**.
     1. Enable **Users can create Fabric items**.
1. **Enable the Fabric API setting:** The Fabric setup script calls the Fabric REST APIs as the solution's user-assigned managed identity (`<resourcesName>-Identity`). Therefore, a Fabric tenant admin needs to enable **Service principals can use Fabric APIs** (or **Service principals can call Fabric public APIs**) in **Fabric admin portal** > **Tenant settings** > **Developer settings**.
1. **Enable the service-principal workspace creation setting:** The setup script creates a Fabric workspace, which is gated by a developer setting that's disabled by default. In **Fabric admin portal** > **Tenant settings** > **Developer settings**, enable **Service principals can create workspaces, connections, and deployment pipelines**.

Select the **Deploy to Azure** button. On the **Custom deployment** page, select the same resource group that you used for the main deployment.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdigitaltwinconsortium%2FManufacturingOntologies%2Fmain%2FDeployment%2Ffabric.json)

> [!IMPORTANT]
> A Fabric administrator can grant users access to the workspace. In the Fabric portal, go to **Admin portal** > **Workspaces**. Find `<resourcesName>-Fabric`, and use **Access** > **Add admins, members or contributors** to add users as **Admin**.

## i3X API

The reference solution deploys an [**i3X API**](https://i3x.dev) container app named `<resourcesName>-i3x4kusto-fabric`. The app exposes an eventhouse through the i3X REST API. You can get its URL from the Azure portal. You can access the Swagger endpoint by adding `/swagger` to the URL.

The i3X API is protected with HTTP Basic authentication. All requests, including those from the Swagger **Authorize** dialog or an i3X client, must include the credentials you provided during deployment:
- **Username**: the `adminUsername` you specified
- **Password**: the `adminPassword` you specified

The health and capabilities endpoint (`GET /v1/info`) and the Swagger UI itself can be accessed without credentials. All data endpoints require the Basic authorization header. For example, use `curl -u <adminUsername>:<adminPassword> https://<i3x-url>/v1/namespaces`.

## Use the sample dashboard

The reference solution includes a sample Fabric RTI dashboard that mirrors the use cases of the Azure Data Explorer dashboard: condition monitoring, OEE calculation, energy consumption, production, and diagnostics for the Munich and Seattle production lines. The dashboard is already imported and published against the deployed eventhouse. Just open it from **Dashboards** in your workspace.

The dashboard also includes a **Unified NameSpace (UNS) / ISA-95 Graph** tile that renders the Unified Namespace / ISA-95 asset hierarchy as an interactive node-link graph.

> [!IMPORTANT]
> This tile renders only after you enable the Python plugin on the eventhouse. Go to **Eventhouse** > **Plugins** and enable **Python language extension**. Enabling the plugin consumes additional compute and can increase costs. The required cached-data refresh can take up to one hour.

## Run a query

Open your KQL database and select its `opcua_queryset`. Because the telemetry `Subject` is the numeric `DataSetWriterId`, the station and production line match on the metadata `DataSetName` (built from the OPC UA server's ApplicationUri and NodeId) and then join to the telemetry on `Subject`. Delete the sample queries, enter the following query in the text box, and then select `Run`.

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
| extend status = toint(Value)
| project Timestamp1, status
| sort by Timestamp1 desc
| render linechart
```

## Next steps

- [What is Fabric?](/fabric/fundamentals/microsoft-fabric-overview)

## Related resources

- [OPC UA reference solution](iot-industrial-solution-architecture.md)
- [Connect Azure Data Explorer to the OPC UA reference solution](how-to-connect-azure-data-explorer-to-solution.md)
- [Connect Azure Databricks to the OPC UA reference solution](how-to-connect-databricks-to-solution.md)
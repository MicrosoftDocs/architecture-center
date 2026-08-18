---
title: "Connect Microsoft Fabric to the reference solution"
description: "Learn how to ingest and analyze OPC UA PubSub industrial IoT data using Microsoft Fabric and KQL databases."
author: erichb
ms.author: erichb
ms.service: azure-iot
ms.topic: how-to
ms.date: 07/22/2026
---

# Connect Microsoft Fabric to the reference solution

[Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) is an end-to-end analytics platform for data ingestion, transformation, real-time processing, analytics, and reporting. To use Fabric with this reference solution, you need an Azure subscription, the main industrial IoT solution deployed, and Fabric enabled for your tenant.

:::image type="complex" source="media/fabric-solution-architecture.png" alt-text="Architecture diagram of the reference solution that adds Microsoft Fabric as an analytics option alongside Azure Data Explorer and Azure Databricks." lightbox="media/fabric-solution-architecture.png" border="false":::
The diagram shows a reference IoT analytics architecture arranged left to right, with Azure Event Hubs in the middle as the shared ingestion point and multiple downstream analytics paths grouped around it. On the left, source streams for industrial telemetry and metadata flow into Event Hubs. From the center, parallel arrows branch to three consumers: an Azure Data Explorer path, an Azure Databricks path, and a Microsoft Fabric path, indicating that all three analytics options read the same event streams side by side through separate consumer groups.

In the Fabric branch on the right, data flows into Fabric real-time components, with an Eventhouse and its KQL database as the primary store for telemetry and metadata. The branch then connects to query and API access and to a dashboard layer for operational views such as condition monitoring, OEE, energy, production, and diagnostics. Connector arrows emphasize progression from ingestion to storage and query, and then to visualization, while preserving the same upstream event backbone used by the other analytics branches.
:::image-end:::

## Automated deployment

The reference solution's deployment script can automatically deploy and configure Microsoft Fabric for you, as a **third analytics option** next to Azure Data Explorer and Azure Databricks.

**Prerequisites (required)**

  - **Verify Fabric capacity quota:** The deployment provisions an F2 capacity. Confirm that the subscription has sufficient Microsoft Fabric quota in the target region. If this is the subscription's first Fabric capacity or its quota is zero, register the `Microsoft.Fabric` resource provider. For instructions, see [Microsoft Fabric capacity quotas](/fabric/enterprise/fabric-quotas).  

  - **Deploy the main solution first:** Fabric reuses the managed identity (`<resourcesName>-Identity`), Event Hubs namespace, Container Apps environment, and the `fabric` capacity created by the ADX/Databricks deployment. Deploy that first (see [Connect Azure Data Explorer to the reference solution](how-to-connect-azure-data-explorer-to-solution.md)). Be sure to set the 'deployFabricCapacity' parameter to 'true' during that deployment.
 - **Enable Fabric for the tenant:** Deploying the F2 capacity in Azure does **not** turn Fabric on for your tenant. If `fabric.microsoft.com` keeps switching back to Power BI, a Fabric admin still needs to enable Fabric: Fabric portal -> Settings (gear) -> Admin portal -> Tenant settings -> Microsoft Fabric -> **Users can create Fabric items** -> Enabled (requires the *Fabric administrator* role).
 - **Enable the Fabric API setting:** The Fabric setup script calls the Fabric REST APIs as the solution's user-assigned managed identity (`<resourcesName>-Identity`), so a Fabric tenant admin must enable **Service principals can use Fabric APIs** (also shown as *Service principals can call Fabric public APIs*) under Fabric admin portal -> Tenant settings -> Developer settings.
 - **Enable service-principal workspace creation setting:** The setup script creates a Fabric workspace, which is gated by a *different* developer setting that is **disabled by default**: **Service principals can create workspaces, connections, and deployment pipelines** (Fabric admin portal -> Tenant settings -> Developer settings).

Select the **Deploy to Azure** button and choose the **same resource group you used for the main deployment**:

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdigitaltwinconsortium%2FManufacturingOntologies%2Fmain%2FDeployment%2Ffabric.json)

> [!IMPORTANT]
> **Getting access to the workspace**: A Fabric administrator can open the Fabric portal -> **Admin portal -> Workspaces**, find `<resourcesName>-Fabric`, and use **Access -> Add admins, members or contributors** to add users as **Admin**.

## I3X API

The reference solution deploys an [**I3X API**](https://i3x.dev) container app named `<resourcesName>-i3x4kusto-fabric`. The app exposes Eventhouse over the I3X REST API. You can get its URL from the Azure portal. You can access the Swagger endpoint by adding `/swagger` to its URL.


The I3X API uses HTTP Basic authentication for protection. Every request (including the Swagger **Authorize** dialog and any I3X client) must supply the credentials you provide during the Fabric deployment:
- **Username**: the `adminUsername` you specify.

- **Password**: the `adminPassword` you specify.
The health and capabilities endpoint (`GET /v1/info`) and the Swagger UI itself remain accessible without credentials. All data endpoints require the Basic auth header. For example, use `curl -u <adminUsername>:<adminPassword> https://<i3x-url>/v1/namespaces`.


## Use the sample dashboard

The reference solution includes a sample **Fabric RTI dashboard** that mirrors the use cases of the Azure Data Explorer dashboard: condition monitoring, OEE calculation, energy consumption, production, and diagnostics for the Munich and Seattle production lines. The dashboard is already imported and published against the deployed Eventhouse - just open it from **Dashboards** in your workspace.


The dashboard also includes a **Unified NameSpace (UNS) / ISA-95 Graph** tile that renders the Unified Namespace / ISA-95 asset hierarchy as an interactive node-link graph. 

> [!IMPORTANT]
> This tile renders only after you enable the Python plugin on Eventhouse via **Eventhouse > Plugins > Python language extension = On**. Enabling the plugin consumes additional compute and can increase costs. The required cached-data refresh can take up to one hour.

## Run a query

Open your KQL database and select its `opcua_queryset`. Because the telemetry `Subject` is the numeric `DataSetWriterId`, the station and production line match on the metadata `DataSetName` (built from the OPC UA server's ApplicationUri and NodeId) and then join to the telemetry on `Subject`. Delete the sample queries, enter the following query in the text box, and select `Run`:

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
---
title: Import OPC UA Information Models from the UA Cloud Library
description: Learn how to import OPC UA information models from the UA Cloud Library into Azure Data Explorer, Microsoft Fabric, and Azure Databricks.
author: barnstee
ms.author: erichb
ms.subservice: architecture-guide
ms.topic: concept-article 
ms.date: 07/22/2026
ai-usage: ai-assisted
---

# Import OPC UA information models from the UA Cloud Library

The UA Cloud Library is a standardized, internet-hosted repository for OPC UA information models. It's hosted by the OPC Foundation. It was developed by a joint working group of the OPC Foundation and CESMII to make OPC UA models globally discoverable, reusable, and reachable via web APIs.

The UA Cloud Library is essentially an online database of OPC UA AddressSpaces / namespaces / information models. The library is hosted in the cloud and can be accessed via the internet. A mandatory RESTful interface allows clients to upload models, download models, and query or search models. The RESTful interface eliminates the traditional dependency on a live OPC UA server to discover its data model.

## The problem it solves

In classic OPC UA usage, a client must connect to a running server and browse its AddressSpace to understand the structure. You can only finalize client configuration when the machine is online.

The UA Cloud Library resolves that problem by:

- Providing the model ahead of time, independently of device availability.
- Enabling offline engineering and pre-configuration at global scale.

The library stores the following:
- Standardized information models (for example, Companion Specifications)
- Vendor-specific or machine-specific models
- Partial AddressSpaces (useful subsets rather than full server instances)

Each entry is uniquely identified by the combination of NamespaceURI, Version, and PublicationDate.

## Architecture and access

The UA Cloud Library architecture and access methods are defined in the OPC UA specification series OPC 30400:  
- Part 1: Architecture and use cases  
- Part 2: API definition

It uses REST and a query language for search and retrieval, and a separate identity provider for access control.

There's also a public instance operated by the OPC Foundation and an open-source reference implementation.

## Key use cases

- Preconfiguring OPC UA clients (SCADA, analytics, digital twins) before connecting them to machines
- Interoperability validation / conformance checking of devices
- Retrofitting legacy machines by assigning or reusing models
- Deploying AddressSpaces into servers (for example, loading models into an empty server wrapper)
- Global sharing of industry models across vendors and ecosystems
- Serving as a neutral distribution mechanism for information models
- Decoupling protocol/runtime discovery from information model lifecycle and governance
- Enabling cross-organization reuse, which is critical for Companion Specifications and Digital Product Passport scenarios

The UA Cloud Library shifts OPC UA toward being a model-driven ecosystem with cloud-native discovery, reducing the dependency on live server connections.

## Import OPC UA information models from the UA Cloud Library into Azure Data Explorer

To enable reads of OPC UA information models directly from Azure Data Explorer, import the OPC UA nodes defined in an OPC UA information model into a table. You can use the imported information to enable enriched lookup of metadata within queries.

First, configure an Azure Data Explorer callout policy for the UA Cloud Library by running the following query on your Azure Data Explorer cluster. Before you start, make sure you're a member of the **AllDatabasesAdmin** role in the cluster. You can configure this role in the Azure portal on the **Permissions** page for your Azure Data Explorer cluster.

```kql
 .alter-merge cluster policy callout @'[{"CalloutType": "webapi","CalloutUriRegex": "uacloudlibrary\\.opcfoundation\\.org/?$","CanCall": true}]'
```

Next, run the following Azure Data Explorer query from the Azure portal. In the query:

- Replace `<INFORMATION_MODEL_IDENTIFIER_FROM_THE_UA_CLOUD_LIBRARY>` with the unique ID of the information model you want to import from the UA Cloud Library. You can find this ID in the URL of the information model's page in the UA Cloud Library. For example, the ID of the station nodeset that this guide uses is `1627266626`.
- Replace `<HASHED_CLOUD_LIBRARY_CREDENTIALS>` with a basic authorization header hash of your UA Cloud Library credentials. Use the following command block to generate the hash:
   ```powershell
   $username = "myUser"
   $password = "myPassword"
   $pair = "$username`:$password"
   $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
   $base64 = [System.Convert]::ToBase64String($bytes)
   $base64
   ```

   You can also use the following bash command: `echo -n 'username:password' | base64`.

```kql
let uri='https://uacloudlibrary.opcfoundation.org/infomodel/download/<INFORMATION_MODEL_IDENTIFIER_FROM_THE_UA_CLOUD_LIBRARY>';
let headers=dynamic({'accept':'text/plain', 'Authorization':h'Basic <HASHED_CLOUD_LIBRARY_CREDENTIALS>'});
evaluate http_request(uri, headers)
| project title = tostring(ResponseBody.['title']), contributor = tostring(ResponseBody.contributor.name), nodeset = parse_xml(tostring(ResponseBody.nodeset.nodesetXml))
| mv-expand UAVariable=nodeset.UANodeSet.UAVariable
| project-away nodeset
| extend NodeId = UAVariable.['@NodeId'], DisplayName = tostring(coalesce(UAVariable.DisplayName.['#text'], UAVariable.DisplayName)), BrowseName = tostring(UAVariable.['@BrowseName']), DataType = tostring(UAVariable.['@DataType'])
| project-away UAVariable
| take 10000
```

### Make the model's variables visible in the OPC UA tables

Instead of keeping the imported model in a separate table, you can add its variables directly to the standard `opcua_metadata` and `opcua_telemetry` tables. Each variable is written with a placeholder telemetry value of `[Future]`, so users can see all the variables that can be retrieved from that OPC UA server's information model, alongside the ones that are actually being published live. Both tables are created automatically on the first run.

First, add every variable of the information model to `opcua_metadata`, so they show up as known nodes:

```kql
.set-or-append opcua_metadata <|
let uri='https://uacloudlibrary.opcfoundation.org/infomodel/download/<INFORMATION_MODEL_IDENTIFIER_FROM_THE_UA_CLOUD_LIBRARY>';
let headers=dynamic({'accept':'text/plain', 'Authorization':'Basic <HASHED_CLOUD_LIBRARY_CREDENTIALS>'});
evaluate http_request(uri, headers)
| project title = tostring(ResponseBody.['title']), nodeset = parse_xml(tostring(ResponseBody.nodeset.nodesetXml))
| extend ModelNamespaceUri = tostring(nodeset.UANodeSet.NamespaceUris.Uri)
| mv-expand UAVariable = nodeset.UANodeSet.UAVariable
| extend NodeId = tostring(UAVariable.['@NodeId']), DisplayName = tostring(coalesce(UAVariable.DisplayName.['#text'], UAVariable.DisplayName)), DataType = tostring(UAVariable.['@DataType'])
| where isnotempty(DisplayName)
| project
    Subject = NodeId,
    Timestamp = now(),
    DataSetName = ['title'],
    MajorVersion = tolong(0),
    MinorVersion = tolong(0),
    Name = DisplayName,
    BuiltInType = toint(0),
    DataType = DataType,
    ValueRank = toint(-1),
    Type = '',
    DisplayName = DisplayName,
    Workcell = ['title'],
    Line = '[Future]',
    Area = '[Future]',
    Site = '[Future]',
    Enterprise = 'UA Cloud Library',
    NamespaceUri = ModelNamespaceUri,
    NodeId = NodeId
```

Next, add one placeholder row per variable to `opcua_telemetry`, with `[Future]` as the value:

```kql
.set-or-append opcua_telemetry <|
let uri='https://uacloudlibrary.opcfoundation.org/infomodel/download/<INFORMATION_MODEL_IDENTIFIER_FROM_THE_UA_CLOUD_LIBRARY>';
let headers=dynamic({'accept':'text/plain', 'Authorization':'Basic <HASHED_CLOUD_LIBRARY_CREDENTIALS>'});
evaluate http_request(uri, headers)
| project nodeset = parse_xml(tostring(ResponseBody.nodeset.nodesetXml))
| mv-expand UAVariable = nodeset.UANodeSet.UAVariable
| extend NodeId = tostring(UAVariable.['@NodeId']), DisplayName = tostring(coalesce(UAVariable.DisplayName.['#text'], UAVariable.DisplayName))
| where isnotempty(DisplayName)
| project
    Subject = NodeId,
    Timestamp = now(),
    Name = DisplayName,
    Value = dynamic("[Future]")
```

To view a graphical representation of an OPC UA information model, use the [Kusto Explorer tool](/azure/data-explorer/kusto/tools/kusto-explorer). To render the station model, run the following query in Kusto Explorer. For best results, change the `Layout` option to `Grouped` and the `Labels` to `name`:

```kql
let uri='https://uacloudlibrary.opcfoundation.org/infomodel/download/1627266626';
let headers=dynamic({'accept':'text/plain', 'Authorization':'Basic <HASHED_CLOUD_LIBRARY_CREDENTIALS>'});
let variables = evaluate http_request(uri, headers)
    | project title = tostring(ResponseBody.['title']), contributor = tostring(ResponseBody.contributor.name), nodeset = parse_xml(tostring(ResponseBody.nodeset.nodesetXml))
    | mv-expand UAVariable = nodeset.UANodeSet.UAVariable
    | extend NodeId = UAVariable.['@NodeId'], ParentNodeId = UAVariable.['@ParentNodeId'], DisplayName = tostring(UAVariable['DisplayName']), DataType = tostring(UAVariable.['@DataType']), References = tostring(UAVariable.['References'])
    | where References !contains "HasModellingRule"
    | where DisplayName != "InputArguments"
    | project-away nodeset, UAVariable, References;
let objects = evaluate http_request(uri, headers)
    | project title = tostring(ResponseBody.['title']), contributor = tostring(ResponseBody.contributor.name), nodeset = parse_xml(tostring(ResponseBody.nodeset.nodesetXml))
    | mv-expand UAObject = nodeset.UANodeSet.UAObject
    | extend NodeId = UAObject.['@NodeId'], ParentNodeId = UAObject.['@ParentNodeId'], DisplayName = tostring(UAObject['DisplayName']), References = tostring(UAObject.['References'])
    | where References !contains "HasModellingRule"
    | project-away nodeset, UAObject, References;
let nodes = variables
    | project source = tostring(NodeId), target = tostring(ParentNodeId), name = tostring(DisplayName)
    | join kind=fullouter (objects
        | project source = tostring(NodeId), target = tostring(ParentNodeId), name = tostring(DisplayName)) on source
        | project source = coalesce(source, source1), target = coalesce(target, target1), name = coalesce(name, name1);
let edges = nodes;
edges
    | make-graph source --> target with nodes on source
```

Here's a graph of the station model:

:::image type="content" source="media/station-graph.png" alt-text="Screenshot that shows a graph of the station information model." lightbox="media/station-graph.png":::

## Import OPC UA variable definitions from the UA Cloud Library into Fabric

You can import OPC UA variable definitions into your Microsoft Fabric eventhouse from the UA Cloud Library. Importing the variable nodes and selected attributes into a table lets you use identifiers, display names, browse names, and data types in your queries.

Because the Fabric eventhouse KQL engine supports the [`http_request` plugin](/kusto/query/http-request-plugin), the following queries work in Fabric exactly as they do in Azure Data Explorer.

### Find an information model

1. Go to [UA Cloud Library](https://uacloudlibrary.opcfoundation.org/Identity/Account/Register) and create a free account.
1. Review the available [information models](https://uacloudlibrary.opcfoundation.org/Explorer). Note the unique ID of the model that you want to import. You can find this ID in the URL of the model's page. For example, the `Station` nodeset used by this reference solution has the ID `1627266626`.
1. Create a basic authorization header from your UA Cloud Library credentials. Generate the Base64 hash by using the bash command `echo -n 'username:password' | base64`, or use the following command block:
   ```powershell
   $username = "myUser"
   $password = "myPassword"
   $pair = "$username`:$password"
   $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
   $base64 = [System.Convert]::ToBase64String($bytes)
   $base64
   ```

### Enable the http_request plugin and allow the UA Cloud Library endpoint

Unlike Azure Data Explorer, a Fabric eventhouse has the `http_request` plugin disabled by default, so you need to enable it. In your KQL database, select **Explore your data** and run the following commands. (You need database admin permissions.)

```kusto
// Enable the http_request plugin used to call the UA Cloud Library REST API
.enable plugin http_request

// Allow Kusto to call the UA Cloud Library endpoint
.alter cluster policy callout @'[{"CalloutType": "webapi","CalloutUriRegex": "uacloudlibrary.opcfoundation.org","CanCall": true}]'
```

### Import an information model

Run the following query to download an information model from the UA Cloud Library and expand its variable nodes. Replace `<INFORMATION_MODEL_IDENTIFIER_FROM_THE_UA_CLOUD_LIBRARY>` with the model's unique ID (for example `1627266626`) and `<HASHED_CLOUD_LIBRARY_CREDENTIALS>` with your Base64-encoded credentials.

```kusto
let uri='https://uacloudlibrary.opcfoundation.org/infomodel/download/<INFORMATION_MODEL_IDENTIFIER_FROM_THE_UA_CLOUD_LIBRARY>';
let headers=dynamic({'accept':'text/plain', 'Authorization':'Basic <HASHED_CLOUD_LIBRARY_CREDENTIALS>'});
evaluate http_request(uri, headers)
| project title = tostring(ResponseBody.['title']), contributor = tostring(ResponseBody.contributor.name), nodeset = parse_xml(tostring(ResponseBody.nodeset.nodesetXml))
| mv-expand UAVariable=nodeset.UANodeSet.UAVariable
| project-away nodeset
| extend NodeId = UAVariable.['@NodeId'], DisplayName = tostring(coalesce(UAVariable.DisplayName.['#text'], UAVariable.DisplayName)), BrowseName = tostring(UAVariable.['@BrowseName']), DataType = tostring(UAVariable.['@DataType'])
| project-away UAVariable
| take 10000
```

To save the imported model into a table (for example `opcua_information_model`) so you can join it with your `opcua_telemetry` and `opcua_metadata` tables, wrap the same query with `.set-or-append`. The table is created automatically on the first run.

```kusto
.set-or-append opcua_information_model <|
let uri='https://uacloudlibrary.opcfoundation.org/infomodel/download/<INFORMATION_MODEL_IDENTIFIER_FROM_THE_UA_CLOUD_LIBRARY>';
let headers=dynamic({'accept':'text/plain', 'Authorization':'Basic <HASHED_CLOUD_LIBRARY_CREDENTIALS>'});
evaluate http_request(uri, headers)
| project title = tostring(ResponseBody.['title']), contributor = tostring(ResponseBody.contributor.name), nodeset = parse_xml(tostring(ResponseBody.nodeset.nodesetXml))
| mv-expand UAVariable=nodeset.UANodeSet.UAVariable
| extend NodeId = tostring(UAVariable.['@NodeId']), DisplayName = tostring(coalesce(UAVariable.DisplayName.['#text'], UAVariable.DisplayName)), BrowseName = tostring(UAVariable.['@BrowseName']), DataType = tostring(UAVariable.['@DataType'])
| project title, contributor, NodeId, DisplayName, BrowseName, DataType
| take 10000
```

### Make the model's variables visible in the OPC UA tables

As in Azure Data Explorer, you can add the imported model's variables directly to the standard `opcua_metadata` and `opcua_telemetry` tables of your eventhouse instead of keeping them in a separate table. Each variable is written with a placeholder telemetry value of `[Future]`, so users can see all the variables that can be retrieved from that OPC UA server's information model, alongside the ones that are actually being published live.

First, add every variable of the information model to `opcua_metadata`:

```kusto
.set-or-append opcua_metadata <|
let uri='https://uacloudlibrary.opcfoundation.org/infomodel/download/<INFORMATION_MODEL_IDENTIFIER_FROM_THE_UA_CLOUD_LIBRARY>';
let headers=dynamic({'accept':'text/plain', 'Authorization':'Basic <HASHED_CLOUD_LIBRARY_CREDENTIALS>'});
evaluate http_request(uri, headers)
| project title = tostring(ResponseBody.['title']), nodeset = parse_xml(tostring(ResponseBody.nodeset.nodesetXml))
| extend ModelNamespaceUri = tostring(nodeset.UANodeSet.NamespaceUris.Uri)
| mv-expand UAVariable = nodeset.UANodeSet.UAVariable
| extend NodeId = tostring(UAVariable.['@NodeId']), DisplayName = tostring(coalesce(UAVariable.DisplayName.['#text'], UAVariable.DisplayName)), DataType = tostring(UAVariable.['@DataType'])
| where isnotempty(DisplayName)
| project
    Subject = NodeId,
    Timestamp = now(),
    DataSetName = ['title'],
    MajorVersion = tolong(0),
    MinorVersion = tolong(0),
    Name = DisplayName,
    BuiltInType = toint(0),
    DataType = DataType,
    ValueRank = toint(-1),
    Type = '',
    DisplayName = DisplayName,
    Workcell = ['title'],
    Line = '[Future]',
    Area = '[Future]',
    Site = '[Future]',
    Enterprise = 'UA Cloud Library',
    NamespaceUri = ModelNamespaceUri,
    NodeId = NodeId
```

Then add one placeholder row per variable to `opcua_telemetry`. Each row should have a value of `[Future]`.

```kusto
.set-or-append opcua_telemetry <|
let uri='https://uacloudlibrary.opcfoundation.org/infomodel/download/<INFORMATION_MODEL_IDENTIFIER_FROM_THE_UA_CLOUD_LIBRARY>';
let headers=dynamic({'accept':'text/plain', 'Authorization':'Basic <HASHED_CLOUD_LIBRARY_CREDENTIALS>'});
evaluate http_request(uri, headers)
| project nodeset = parse_xml(tostring(ResponseBody.nodeset.nodesetXml))
| mv-expand UAVariable = nodeset.UANodeSet.UAVariable
| extend NodeId = tostring(UAVariable.['@NodeId']), DisplayName = tostring(coalesce(UAVariable.DisplayName.['#text'], UAVariable.DisplayName))
| where isnotempty(DisplayName)
| project
    Subject = NodeId,
    Timestamp = now(),
    Name = DisplayName,
    Value = dynamic("[Future]")
```

### Visualize an information model as a graph

To view a graphical representation of an OPC UA information model, run the following query, and then switch the result view to `Graph`. For best results, set the `Layout` option to `Grouped` and the `Labels` to `name`.

```kusto
let uri='https://uacloudlibrary.opcfoundation.org/infomodel/download/1627266626';
let headers=dynamic({'accept':'text/plain', 'Authorization':'Basic <HASHED_CLOUD_LIBRARY_CREDENTIALS>'});
let variables = evaluate http_request(uri, headers)
    | project title = tostring(ResponseBody.['title']), contributor = tostring(ResponseBody.contributor.name), nodeset = parse_xml(tostring(ResponseBody.nodeset.nodesetXml))
    | mv-expand UAVariable = nodeset.UANodeSet.UAVariable
    | extend NodeId = UAVariable.['@NodeId'], ParentNodeId = UAVariable.['@ParentNodeId'], DisplayName = tostring(UAVariable['DisplayName']), DataType = tostring(UAVariable.['@DataType']), References = tostring(UAVariable.['References'])
    | where References !contains "HasModellingRule"
    | where DisplayName != "InputArguments"
    | project-away nodeset, UAVariable, References;
let objects = evaluate http_request(uri, headers)
    | project title = tostring(ResponseBody.['title']), contributor = tostring(ResponseBody.contributor.name), nodeset = parse_xml(tostring(ResponseBody.nodeset.nodesetXml))
    | mv-expand UAObject = nodeset.UANodeSet.UAObject
    | extend NodeId = UAObject.['@NodeId'], ParentNodeId = UAObject.['@ParentNodeId'], DisplayName = tostring(UAObject['DisplayName']), References = tostring(UAObject.['References'])
    | where References !contains "HasModellingRule"
    | project-away nodeset, UAObject, References;
let nodes = variables
    | project source = tostring(NodeId), target = tostring(ParentNodeId), name = tostring(DisplayName)
    | join kind=fullouter (objects
        | project source = tostring(NodeId), target = tostring(ParentNodeId), name = tostring(DisplayName)) on source
        | project source = coalesce(source, source1), target = coalesce(target, target1), name = coalesce(name, name1);
let edges = nodes;
edges
| make-graph source --> target with nodes on source
```

## Import OPC UA variable definitions from the UA Cloud Library into Azure Databricks

You might want to import OPC UA variable definitions into your analytics platform from the [UA Cloud Library](https://uacloudlibrary.opcfoundation.org). Doing so provides richer semantics beyond what OPC UA PubSub metadata alone can offer, including:

- **Full information model context.** The entire model hierarchy rather than just the published data points.
- **Complex type definitions** and references to other data that's needed for deeper analysis.
- **Visibility into all available telemetry** from your sites, so you can make informed decisions about what to publish to the cloud.

### Find an information model

1. Go to [UA Cloud Library](https://uacloudlibrary.opcfoundation.org) and create a free account.
1. Review the [available information models](https://uacloudlibrary.opcfoundation.org/Explorer).
1. Find the unique ID of the information model that you want to use via the [REST API](https://uacloudlibrary.opcfoundation.org/infomodel/namespaces).

   For example, the Robotics information model has the unique ID `4172981173`.

### Import an information model into Azure Databricks

In Azure Data Explorer, you complete this step by using the `evaluate http_request()` operator. In Azure Databricks, you can use a PySpark notebook with the `requests` library:

```python
import requests
import base64
import xml.etree.ElementTree as ET
from pyspark.sql import Row

# --- Configuration ---
CLOUD_LIBRARY_USERNAME = "<your-cloud-library-username>"
CLOUD_LIBRARY_PASSWORD = "<your-cloud-library-password>"
INFORMATION_MODEL_ID = "4172981173"  # For example, Robotics

# --- Download the information model ---
url = f"https://uacloudlibrary.opcfoundation.org/infomodel/download/{INFORMATION_MODEL_ID}"
credentials = base64.b64encode(
    f"{CLOUD_LIBRARY_USERNAME}:{CLOUD_LIBRARY_PASSWORD}".encode()
).decode()

headers = {
    "Accept": "text/plain",
    "Authorization": f"Basic {credentials}"
}

response = requests.get(url, headers=headers)
response.raise_for_status()
model_data = response.json()

# --- Extract metadata ---
title = model_data.get("title", "")
contributor = model_data.get("contributor", {}).get("name", "")
nodeset_xml = model_data.get("nodeset", {}).get("nodesetXml", "")

# --- Parse the OPC UA Nodeset XML ---
root = ET.fromstring(nodeset_xml)
ns = {"ua": "http://opcfoundation.org/UA/2011/03/UANodeSet.xsd"}

# The model's own namespace URI is the first entry of <NamespaceUris>
namespace_uri_elem = root.find("ua:NamespaceUris/ua:Uri", ns)
model_namespace_uri = namespace_uri_elem.text if namespace_uri_elem is not None and namespace_uri_elem.text else ""

rows = []
for var in root.findall(".//ua:UAVariable", ns):
    node_id = var.get("NodeId", "")
    browse_name = var.get("BrowseName", "")
    data_type = var.get("DataType", "")

    display_name_elem = var.find("ua:DisplayName", ns)
    display_name = display_name_elem.text if display_name_elem is not None and display_name_elem.text else ""

    rows.append(Row(
        Title=title,
        Contributor=contributor,
        NodeId=node_id,
        DisplayName=display_name,
        BrowseName=browse_name,
        DataType=data_type
    ))

# --- Create a DataFrame and save as a Delta table ---
if rows:
    info_model_df = spark.createDataFrame(rows)
    info_model_df.write.format("delta").mode("overwrite").saveAsTable("opcua_information_model")
    print(f"Successfully imported {len(rows)} nodes from '{title}' into opcua_information_model table.")
    display(info_model_df.limit(20))
else:
    print("No UAVariable nodes found in the Information Model.")
```

### Make the model's variables visible in the OPC UA tables

Instead of (or in addition to) adding the imported model's variables to the separate `opcua_information_model` table, you can add the variables directly to the standard `opcua_metadata` and `opcua_telemetry` Delta tables. Each variable is written with a placeholder telemetry value of `[Future]`, so users can see all the variables that can be retrieved from that OPC UA server's information model, alongside the ones that are actually being published live.

Append the following code to the notebook. (It reuses the `rows`, `title`, and `nodeset` parsing from the previous example.)

```python
from pyspark.sql import functions as F
from datetime import datetime, timezone

if rows:
    now = datetime.now(timezone.utc)

    # --- opcua_metadata: one row per variable so they show up as known nodes ---
    metadata_rows = [
        Row(
            Subject=r["NodeId"],
            Timestamp=now,
            DataSetName=title,
            MajorVersion=0,
            MinorVersion=0,
            Name=r["DisplayName"],
            BuiltInType=0,
            DataType=r["DataType"],
            ValueRank=-1,
            Type="",
            DisplayName=r["DisplayName"],
            Workcell=title,
            Line="[Future]",
            Area="[Future]",
            Site="[Future]",
            Enterprise="UA Cloud Library",
            NamespaceUri=model_namespace_uri,
            NodeId=r["NodeId"],
        )
        for r in (row.asDict() for row in rows)
        if r["DisplayName"]
    ]

    # --- opcua_telemetry: one placeholder row per variable, value set to [Future] ---
    telemetry_rows = [
        Row(
            Subject=r["NodeId"],
            Timestamp=now,
            Name=r["DisplayName"],
            Value="[Future]",
        )
        for r in (row.asDict() for row in rows)
        if r["DisplayName"]
    ]

    if metadata_rows:
        metadata_df = spark.createDataFrame(metadata_rows).select(
            F.col("Subject").cast("string"),
            F.col("Timestamp").cast("timestamp"),
            F.col("DataSetName").cast("string"),
            F.col("MajorVersion").cast("bigint"),
            F.col("MinorVersion").cast("bigint"),
            F.col("Name").cast("string"),
            F.col("BuiltInType").cast("int"),
            F.col("DataType").cast("string"),
            F.col("ValueRank").cast("int"),
            F.col("Type").cast("string"),
            F.col("DisplayName").cast("string"),
            F.col("Workcell").cast("string"),
            F.col("Line").cast("string"),
            F.col("Area").cast("string"),
            F.col("Site").cast("string"),
            F.col("Enterprise").cast("string"),
            F.col("NamespaceUri").cast("string"),
            F.col("NodeId").cast("string"),
        )
        metadata_df.write.format("delta").mode("append").saveAsTable("opcua_metadata")
    if telemetry_rows:
        telemetry_df = spark.createDataFrame(telemetry_rows).select(
            F.col("Subject").cast("string"),
            F.col("Timestamp").cast("timestamp"),
            F.col("Name").cast("string"),
            F.col("Value").cast("string"),
        )
        telemetry_df.write.format("delta").mode("append").saveAsTable("opcua_telemetry")

    print(f"Added {len(metadata_rows)} variables to opcua_metadata and opcua_telemetry (Value = [Future]).")
```

You have now imported OPC UA variable definitions into a Delta Lake table in Azure Databricks. You can now join this table with your telemetry and metadata to get richer analytics.

## Next steps

- [OPC UA information models](https://uacloudlibrary.opcfoundation.org/)

## Related resources

- [OPC UA reference solution](iot-industrial-solution-architecture.md)
- [Connect Azure Data Explorer to the OPC UA reference solution](how-to-connect-azure-data-explorer-to-solution.md)
---
title: "Connect Microsoft Fabric to the Reference Solution"
description: "Learn how to ingest and analyze OPC UA PubSub industrial IoT data using Microsoft Fabric and KQL databases."
author: erichb
ms.author: erichb
ms.service: azure-iot
ms.topic: how-to
ms.date: 06/18/2026
---

# Connect Microsoft Fabric to the reference solution

[Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview) is an all-in-one analytics solution that covers everything from data movement to data science, analytics, and business intelligence. It offers a comprehensive suite of services, including data lake, data engineering, and data integration, all in one place. You don't even need an Azure subscription for it, let alone deploy or manage any apps or services. You can get started with Microsoft Fabric [here](/fabric/get-started/fabric-trial).

## Create a Fabric Eventhouse to Store your Production Line Data

1. Log into Microsoft Fabric [here](https://fabric.microsoft.com).
1. Create an `Eventhouse` by opening your workspace, selecting `New item`, then searching for and selecting `Eventhouse`. Give it a name, e.g. `opcua`, and click `Create`. Both the eventhouse and a default KQL database with the same name are created.
1. Select your KQL database. In the `Database details` pane, under the `OneLake` section, set `Availability` to `Enabled`. This will enable sharing your OPC UA time-series data from your production line within your organization via [OneLake](/fabric/onelake/onelake-overview) in [Parquet file format](https://parquet.apache.org/docs/file-format/).

## Configure OPC UA PubSub Data Ingestion

These tables, mappings, functions and the materialized view mirror the ones the reference solution creates in Azure Data Explorer, so Fabric processes the OPC UA PubSub data exactly the same way ADX does.

Create the tables you need for ingesting the OPC UA PubSub data by clicking `opcua_queryset`, deleting the sample data in the text box, entering the following Kusto commands one-by-one, and then clicking `Run` for each command:

```kusto
// Create a landing table for raw OPC UA telemetry
.create table opcua_raw(payload: dynamic)

// Create an intermediate table to unbatch our OPC UA PubSub messages into
.create table opcua_intermediate(DataSetWriterID: string, Timestamp: datetime, Payload: dynamic)

// Create our final OPC UA telemetry table
.create table opcua_telemetry (DataSetWriterID: string, Timestamp: datetime, Name: string, Value: dynamic)

// Create a landing table for raw OPC UA metadata
.create table opcua_metadata_raw(payload: dynamic)

// Create an OPC UA metadata landing table
.create table opcua_metadata(DataSetWriterID: string, Timestamp: datetime, Name: string, Type: string, DisplayName:string, Workcell: string, Line: string, Area: string, Site: string, Enterprise: string, NamespaceUri: string, NodeId: string)
```

Then run the following Kusto commands one-by-one:

```kusto
// Create a function to do the raw OPC UA expansion
.create-or-alter function OPCUARawExpand() { opcua_raw | mv-expand records = payload.Messages | where records != '' | project DataSetWriterID = tostring(records["DataSetWriterId"]), Timestamp = todatetime(records["Timestamp"]), Payload = todynamic(records["Payload"]) }

// Create a function to do the OPC UA dataset expansion
.create-or-alter function OPCUADatasetExpand() { opcua_intermediate | mv-apply Payload on (extend key = tostring(bag_keys(Payload)[0]) | extend p = Payload[key] | project Name = key, Value = todynamic(p.Value)) }

// Create a function to do the raw OPC UA metadata expansion
.create-or-alter function OPCUAMetaDataExpand() { opcua_metadata_raw | parse tostring(payload.MetaData.Name) with * ":" Workcell "." Line "." Area "." Site "." Enterprise ";nsu=" NamespaceUri ";" NodeId | project DataSetWriterId = tostring(payload.DataSetWriterId), Timestamp = todatetime(payload.Timestamp), Name = tostring(payload.MetaData.Name), Type = tostring(payload.MetaData.Fields[0].Description), DisplayName = tostring(payload.MetaData.Fields[0].Name), Workcell, Line, Area, Site, Enterprise, NamespaceUri, NodeId }

// Create a materialized view for the last known value (LKV) of our metadata
.create materialized-view opcua_metadata_lkv on table opcua_metadata { opcua_metadata | summarize arg_max(Timestamp, *) by Name, DataSetWriterID }
```

Then run the following Kusto commands one-by-one:

```kusto
// Create mapping from JSON ingestion to the landing table  
.create-or-alter table opcua_raw ingestion json mapping 'opcua_mapping' '[{"column":"payload","path":"$","datatype":"dynamic"}]'
  
// Apply the raw expansion function to the OPC UA raw table
.alter table opcua_intermediate policy update @'[{"Source": "opcua_raw", "Query": "OPCUARawExpand()", "IsEnabled": "True"}]'

// Apply the dataset expansion function to the intermediate table  
.alter table opcua_telemetry policy update @'[{"Source": "opcua_intermediate", "Query": "OPCUADatasetExpand()", "IsEnabled": "True"}]'

// Create mapping from JSON ingestion to the metadata landing table
.create-or-alter table opcua_metadata_raw ingestion json mapping 'opcua_metadata_mapping' '[{"column":"payload","path":"$","datatype":"dynamic"}]'

// Apply the raw metadata expansion function to the metadata landing table
.alter table opcua_metadata policy update @'[{"Source": "opcua_metadata_raw", "Query": "OPCUAMetaDataExpand()", "IsEnabled": "True"}]'
```

## Connect Fabric to your existing Azure Event Hubs

The reference solution deploys an Azure Event Hubs namespace named `<resourcesName>-EventHubs` (where `<resourcesName>` is the name you chose during deployment) that already receives your OPC UA PubSub data on two event hubs:

| Event hub  | Contents                | KQL landing table    | Ingestion mapping        |
| ---------- | ----------------------- | -------------------- | ------------------------ |
| `data`     | OPC UA PubSub telemetry | `opcua_raw`          | `opcua_mapping`          |
| `metadata` | OPC UA PubSub metadata  | `opcua_metadata_raw` | `opcua_metadata_mapping` |

The Azure Data Explorer (ADX) cluster deployed by the solution consumes these Event Hubs through a dedicated `adx` consumer group. To let Fabric read the same data without interfering with ADX, create a separate consumer group for Fabric on each event hub. You can do this in the Azure portal under the event hub's `Consumer groups` blade. Call the new consumer group 'fabric'.
You will also need a connection string with at least `Listen` rights. The simplest option is the namespace-level `RootManageSharedAccessKey` policy: in the Azure portal, open your `<resourcesName>-EventHubs` namespace, select `Shared access policies` -> `RootManageSharedAccessKey` and copy the `Connection string-primary key`.

### Ingest the telemetry event hub (`data` -> `opcua_raw`)

1. In your Fabric workspace, select `New item`, then search for and select `Eventstream`. Name it e.g. `eventstream_opcua_data` and click `Create`.
1. Select `Add source` -> `Azure Event Hubs`. Under `Connection`, select `New connection` and enter your `<resourcesName>-EventHubs` namespace, the `data` event hub, and the `RootManageSharedAccessKey` shared access key name and key. Back on the source page, select the `fabric` consumer group (or `$Default`) and set `Data format` to `Json`. Select `Next`, then on the `Review + connect` page select `Add`. Finally, select `Publish` to publish the eventstream.
1. Select `Add destination` -> `Eventhouse`. Choose `Direct ingestion`, enter a `Destination name`, then select your `Workspace`, `Eventhouse`, and the KQL database you created earlier. Select `Save`, connect the destination card to your stream output if it isn't already, and select `Publish`.
1. In `Live view`, select `Configure` on the Eventhouse destination node to open the `Get data` screen. Select the existing `opcua_raw` table, keep or edit the `Data connection name`, and select `Next`. On the `Inspect the data` screen, confirm the `Format` is `JSON` (the existing `opcua_mapping` routes the raw payload into the `payload` column; you can review it via the `Table_mapping` dropdown or `Advanced` options). Select `Finish`, then select `Close` on the `Summary` screen.

### Ingest the metadata event hub (`metadata` -> `opcua_metadata_raw`)

1. Create a second eventstream by selecting `New item` -> `Eventstream`, name it e.g. `eventstream_opcua_metadata` and click `Create`.
1. Select `Add source` -> `Azure Event Hubs`. Create or select a connection exactly as above, but set the event hub to `metadata` (consumer group `fabric` or `$Default`). Set `Data format` to `Json`, select `Next`, then `Add` on the `Review + connect` page, and `Publish` the eventstream.
1. Select `Add destination` -> `Eventhouse`. Choose `Direct ingestion`, enter a `Destination name`, then select your `Workspace`, `Eventhouse`, and the same KQL database. Select `Save`, connect the destination card to your stream output if it isn't already, and select `Publish`.
1. In `Live view`, select `Configure` on the Eventhouse destination node to open the `Get data` screen. Select the existing `opcua_metadata_raw` table, keep or edit the `Data connection name`, and select `Next`. On the `Inspect the data` screen, confirm the `Format` is `JSON` (the existing `opcua_metadata_mapping` routes the raw payload into the `payload` column; you can review it via the `Table_mapping` dropdown or `Advanced` options). Select `Finish`, then select `Close` on the `Summary` screen.

Once both eventstreams are running, the update policies and the `opcua_metadata_lkv` materialized view you created above automatically expand the raw OPC UA PubSub messages into the `opcua_telemetry` and `opcua_metadata` tables, exactly like the ADX deployment.

## Create a Fabric Lakehouse to Share Your OPC UA Data within Your Organization

To share your OPC UA data via OneLake, create a `Lakehouse` by selecting `New item` in your workspace, then searching for and selecting `Lakehouse`. Give it a name, e.g. `opcua_lake`, and click `Create`.
1. Under `Tables`, select `New shortcut`, select `Microsoft OneLake`, select your KQL database, expand the `Tables` node and select `opcua_telemetry`.
1. Under `Tables`, select `New shortcut`, select `Microsoft OneLake`, select your KQL database, expand the `Tables` node and select `opcua_metadata`.

## View Your OPC UA Data Flow in Fabric

Click on your workspace, select `Lineage view` to see the entire flow of OPC UA data you have just setup in Microsoft Fabric.

## Run a Sample Data Query

Open your KQL database and select its `opcua_queryset`. Delete the sample queries, enter the following query in the text box, and select `Run`:

```kusto
let _startTime = ago(1h);
let _endTime = now();
opcua_metadata
| where Name contains "assembly"
| where Name contains "munich"
| join kind=inner (opcua_telemetry
    | where Name == "Status"
    | where Timestamp > _startTime and Timestamp < _endTime
) on DataSetWriterID
| extend energy = todouble(Value)
| project Timestamp1, energy
| sort by Timestamp1 desc 
| render linechart
```


## Import OPC UA Information Models from the UA Cloud Library (hosted by the OPC Foundation)

Beyond the metadata published via OPC UA PubSub, you can import entire OPC UA Information Models into your Eventhouse from the [UA Cloud Library](https://uacloudlibrary.opcfoundation.org), an online store of OPC UA Information Models hosted by the OPC Foundation. Importing the OPC UA nodes defined in an Information Model into a table lets you look up richer semantics within your queries, including the full model hierarchy, complex type definitions and all available telemetry from your sites.

Because the Fabric Eventhouse KQL engine supports the [`http_request` plugin](/kusto/query/http-request-plugin), the queries below work in Fabric exactly like they do in ADX.

### Register and find an Information Model

1. Register for free at the UA Cloud Library: [https://uacloudlibrary.opcfoundation.org/Identity/Account/Register](https://uacloudlibrary.opcfoundation.org/Identity/Account/Register).
1. Browse the available Information Models at [https://uacloudlibrary.opcfoundation.org/Explorer](https://uacloudlibrary.opcfoundation.org/Explorer) and note the unique ID of the model you want to import. You can find this ID in the URL of the model's page. For example, the `Station` nodeset used by this reference solution has the ID `1627266626`.
1. Create a basic authorization header from your UA Cloud Library credentials. Generate the Base64 hash with the bash command `echo -n 'username:password' | base64`, or use a tool such as [https://www.debugbear.com/basic-auth-header-generator](https://www.debugbear.com/basic-auth-header-generator).

### Enable the http_request plugin and allow the UA Cloud Library endpoint

Unlike Azure Data Explorer, a Fabric Eventhouse has the `http_request` plugin disabled by default, so it must be enabled first. In your KQL database, click `Explore your data` and run the following commands (you need database admin permissions):

```kusto
// Enable the http_request plugin used to call the UA Cloud Library REST API
.enable plugin http_request

// Allow Kusto to call the UA Cloud Library endpoint
.alter cluster policy callout @'[{"CalloutType": "webapi","CalloutUriRegex": "uacloudlibrary.opcfoundation.org","CanCall": true}]'
```

### Import an Information Model

Run the following query to download an Information Model from the UA Cloud Library and expand its variable nodes. Replace `<INFORMATION_MODEL_IDENTIFIER_FROM_THE_UA_CLOUD_LIBRARY>` with the model's unique ID (for example `1627266626`) and `<HASHED_CLOUD_LIBRARY_CREDENTIALS>` with your Base64-encoded credentials:

```kusto
let uri='https://uacloudlibrary.opcfoundation.org/infomodel/download/<INFORMATION_MODEL_IDENTIFIER_FROM_THE_UA_CLOUD_LIBRARY>';
let headers=dynamic({'accept':'text/plain', 'Authorization':'Basic <HASHED_CLOUD_LIBRARY_CREDENTIALS>'});
evaluate http_request(uri, headers)
| project title = tostring(ResponseBody.['title']), contributor = tostring(ResponseBody.contributor.name), nodeset = parse_xml(tostring(ResponseBody.nodeset.nodesetXml))
| mv-expand UAVariable=nodeset.UANodeSet.UAVariable
| project-away nodeset
| extend NodeId = UAVariable.['@NodeId'], DisplayName = tostring(UAVariable.DisplayName.['#text']), BrowseName = tostring(UAVariable.['@BrowseName']), DataType = tostring(UAVariable.['@DataType'])
| project-away UAVariable
| take 10000
```

To persist the imported model into a table (for example `opcua_information_model`) so you can join it with your `opcua_telemetry` and `opcua_metadata` tables, wrap the same query with `.set-or-append`. The table is created automatically on the first run:

```kusto
.set-or-append opcua_information_model <|
let uri='https://uacloudlibrary.opcfoundation.org/infomodel/download/<INFORMATION_MODEL_IDENTIFIER_FROM_THE_UA_CLOUD_LIBRARY>';
let headers=dynamic({'accept':'text/plain', 'Authorization':'Basic <HASHED_CLOUD_LIBRARY_CREDENTIALS>'});
evaluate http_request(uri, headers)
| project title = tostring(ResponseBody.['title']), contributor = tostring(ResponseBody.contributor.name), nodeset = parse_xml(tostring(ResponseBody.nodeset.nodesetXml))
| mv-expand UAVariable=nodeset.UANodeSet.UAVariable
| extend NodeId = tostring(UAVariable.['@NodeId']), DisplayName = tostring(UAVariable.DisplayName.['#text']), BrowseName = tostring(UAVariable.['@BrowseName']), DataType = tostring(UAVariable.['@DataType'])
| project title, contributor, NodeId, DisplayName, BrowseName, DataType
| take 10000
```

### Visualize an Information Model as a graph

To view a graphical representation of an OPC UA Information Model, run the following query and switch the result view to `Graph`. For best results, set the `Layout` option to `Grouped` and the `Labels` to `name`:

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


## Useful KQL Database Helper-Functions for Advanced Queries

```kusto
.create-or-alter function QuerySpecificValue(stationName: string, productionLineName: string, valueToQuery: string, desiredValue: real) {
opcua_metadata_lkv
| where Name contains stationName
| where Name contains productionLineName
| join kind = inner(opcua_telemetry
    | where Name == valueToQuery
    | where Value == desiredValue
    | where Timestamp > ago(5m)
) on DataSetWriterID
| project Timestamp1
| sort by Timestamp1 desc
| take 1
}

.create-or-alter function QuerySpecificTime(stationName: string, productionLineName: string, valueToQuery: string, timeToQuery: datetime, idealCycleTime: timespan) {
opcua_metadata_lkv
| where Name contains stationName
| where Name contains productionLineName
| join kind = inner(opcua_telemetry
    | where Name == valueToQuery
    | where Timestamp > ago(5m)
) on DataSetWriterID
| where around(Timestamp1, timeToQuery, idealCycleTime)
| sort by Timestamp1 desc
| project Value
| take 1
}

.create-or-alter function EnergyPerPart(productionLineName: string, idealCycleTime: timespan) {
// check if a new part was produced (last machine in the production line, i.e. packaging, is in state 2 ("done") with a passed QA)
// and get the part's serial number and energy consumption at that time
let timeLatestProductWasProduced = toscalar(QuerySpecificValue("packaging", productionLineName, "Status", "2"));
let serialNumber = toscalar(QuerySpecificTime("packaging", productionLineName, "ProductSerialNumber", timeLatestProductWasProduced, idealCycleTime));
//
let timePartWasProducedPackaging = toscalar(timeLatestProductWasProduced);
let energyPackaging = toscalar(QuerySpecificTime("packaging", productionLineName, "EnergyConsumption", timePartWasProducedPackaging, idealCycleTime));
//
// check each other machine for the time when the product with this serial number was in the machine and get its energy comsumption at that time
let timePartWasProducedTest = toscalar(QuerySpecificValue("test", productionLineName, "ProductSerialNumber", serialNumber));
let energyTest = toscalar(QuerySpecificTime("test", productionLineName, "EnergyConsumption", timePartWasProducedTest, idealCycleTime));
//
let timePartWasProducedAssembly = toscalar(QuerySpecificValue("assembly", productionLineName, "ProductSerialNumber", serialNumber));
let energyAssembly = toscalar(QuerySpecificTime("assembly", productionLineName, "EnergyConsumption", timePartWasProducedAssembly, idealCycleTime));
//
// calculate the total energy consumption for the product by summing up all the machines' energy consumptions (in kW), multiply by 1000 to get Watts and then multiply by the ideal cycle time (which is in seconds) divided by 3600 to get Wh
let totalenergy = (todouble(energyAssembly) + todouble(energyTest) + todouble(energyPackaging)) * 1000 * todouble(format_timespan(idealCycleTime, "s")) / 3600;
print serialNumber, timeLatestProductWasProduced, totalenergy
}
```

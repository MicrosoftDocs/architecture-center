---
title: "Connect Azure Databricks to the Reference Solution"
description: "Learn how to ingest and analyze OPC UA PubSub industrial IoT data in Azure Databricks using Delta Lake and Structured Streaming."
author: erichb
ms.author: erichb
ms.service: azure-iot
ms.topic: how-to
ms.date: 06/18/2026
---

# Connect Azure Databricks to the reference solution

## Introduction

Most Azure users looking to store and analyze OPC UA PubSub telemetry data sent from industrial sites via a cloud broker have a powerful cloud store and analytics platform in **Azure Databricks**. Databricks provides a unified analytics platform built on Apache Spark, with native support for Delta Lake, structured streaming, and scalable data engineering — making it an excellent fit for industrial IoT workloads.

This article walks you through:

1. Setting up Delta Lake tables for OPC UA PubSub telemetry and metadata
2. Ingesting data from Azure Event Hubs using Structured Streaming
3. Processing and expanding OPC UA PubSub messages with PySpark
4. Creating a last-known-value (LKV) view for OPC UA metadata
5. Importing OPC UA Information Models from the [UA Cloud Library](https://uacloudlibrary.opcfoundation.org)

## Prerequisites

- An **Azure Databricks workspace** in your Azure subscription
- The **Azure Event Hubs namespace** deployed by the reference solution, named `<resourcesName>-EventHubs` (where `<resourcesName>` is the name you chose during deployment). It already receives your OPC UA PubSub data on two event hubs: `data` (telemetry) and `metadata` (metadata).
- A login to the **UA Cloud Library**, hosted by the OPC Foundation — register for free at: [https://uacloudlibrary.opcfoundation.org/Identity/Account/Register](https://uacloudlibrary.opcfoundation.org/Identity/Account/Register)

## Step 1: Create Delta Lake Tables

First, create the Delta Lake tables that will hold your OPC UA data. Run the following SQL commands in a Databricks notebook:

```sql
-- Create a landing table for raw OPC UA telemetry
CREATE TABLE IF NOT EXISTS opcua_raw (
  payload STRING
)
USING DELTA;

-- Create an intermediate table to unbatch OPC UA PubSub messages
CREATE TABLE IF NOT EXISTS opcua_intermediate (
  DataSetWriterID STRING,
  Timestamp TIMESTAMP,
  Payload STRING
)
USING DELTA;

-- Create the final OPC UA telemetry table
CREATE TABLE IF NOT EXISTS opcua_telemetry (
  DataSetWriterID STRING,
  Timestamp TIMESTAMP,
  Name STRING,
  Value STRING
)
USING DELTA;

-- Create a landing table for raw OPC UA metadata
CREATE TABLE IF NOT EXISTS opcua_metadata_raw (
  payload STRING
)
USING DELTA;

-- Create the OPC UA metadata table
CREATE TABLE IF NOT EXISTS opcua_metadata (
  DataSetWriterID STRING,
  Timestamp TIMESTAMP,
  Name STRING,
  Type STRING,
  DisplayName STRING,
  Workcell STRING,
  Line STRING,
  Area STRING,
  Site STRING,
  Enterprise STRING,
  NamespaceUri STRING,
  NodeId STRING
)
USING DELTA;
```

## Step 2: Ingest Data from Azure Event Hubs

Use Databricks **Structured Streaming** to continuously ingest OPC UA PubSub messages from Azure Event Hubs into the raw landing tables.

The reference solution deploys an Azure Event Hubs namespace named `<resourcesName>-EventHubs` (where `<resourcesName>` is the name you chose during deployment) with two event hubs:

| Event hub  | Contents                | Delta landing table  |
| ---------- | ----------------------- | -------------------- |
| `data`     | OPC UA PubSub telemetry | `opcua_raw`          |
| `metadata` | OPC UA PubSub metadata  | `opcua_metadata_raw` |

The Azure Data Explorer cluster deployed by the template already consumes these event hubs through a dedicated `adx` consumer group. To let Databricks read the same data without interfering with ADX, create a separate `databricks` consumer group on each event hub.
Each Event Hubs connection string below is the namespace-level `RootManageSharedAccessKey` connection string (Azure portal -> your `<resourcesName>-EventHubs` namespace -> `Shared access policies` -> `RootManageSharedAccessKey` -> `Connection string-primary key`) with the target event hub appended via `;EntityPath=...`.

> [!NOTE]
> The snippets below use the [`azure-event-hubs-spark`](https://github.com/Azure/azure-event-hubs-spark) connector. Install the `com.microsoft.azure:azure-event-hubs-spark_2.12:<version>` Maven library on your cluster. On Unity Catalog clusters or Databricks Runtime 13.3 LTS and later, use the built-in Kafka connector instead (see [Alternative: read via the Event Hubs Kafka endpoint](#alternative-read-via-the-event-hubs-kafka-endpoint)).

### Telemetry Ingestion

```python
# OPC UA telemetry is published to the "data" event hub of the
# "<resourcesName>-EventHubs" namespace deployed by the reference solution.
telemetry_connection_string = (
    "Endpoint=sb://<resourcesName>-EventHubs.servicebus.windows.net/;"
    "SharedAccessKeyName=RootManageSharedAccessKey;"
    "SharedAccessKey=<YOUR_PRIMARY_KEY>;"
    "EntityPath=data"
)

# Event Hub connection configuration for telemetry
eh_telemetry_conf = {
    "eventhubs.connectionString": sc._jvm.org.apache.spark.eventhubs
        .EventHubsUtils.encrypt(telemetry_connection_string),
    "eventhubs.consumerGroup": "databricks"
}

# Read the telemetry stream from Event Hub
telemetry_stream = (
    spark.readStream
    .format("eventhubs")
    .options(**eh_telemetry_conf)
    .load()
    .selectExpr("CAST(body AS STRING) AS payload")
)

# Write to the raw telemetry Delta table
(
    telemetry_stream.writeStream
    .format("delta")
    .outputMode("append")
    .option("checkpointLocation", "/mnt/checkpoints/opcua_raw")
    .table("opcua_raw")
)
```

### Metadata Ingestion

```python
# OPC UA metadata is published to the "metadata" event hub of the
# "<resourcesName>-EventHubs" namespace deployed by the reference solution.
metadata_connection_string = (
    "Endpoint=sb://<resourcesName>-EventHubs.servicebus.windows.net/;"
    "SharedAccessKeyName=RootManageSharedAccessKey;"
    "SharedAccessKey=<YOUR_PRIMARY_KEY>;"
    "EntityPath=metadata"
)

# Event Hub connection configuration for metadata
eh_metadata_conf = {
    "eventhubs.connectionString": sc._jvm.org.apache.spark.eventhubs
        .EventHubsUtils.encrypt(metadata_connection_string),
    "eventhubs.consumerGroup": "databricks"
}

# Read the metadata stream from Event Hub
metadata_stream = (
    spark.readStream
    .format("eventhubs")
    .options(**eh_metadata_conf)
    .load()
    .selectExpr("CAST(body AS STRING) AS payload")
)

# Write to the raw metadata Delta table
(
    metadata_stream.writeStream
    .format("delta")
    .outputMode("append")
    .option("checkpointLocation", "/mnt/checkpoints/opcua_metadata_raw")
    .table("opcua_metadata_raw")
)
```

### Alternative: read via the Event Hubs Kafka endpoint

On Unity Catalog clusters or Databricks Runtime 13.3 LTS and later, the `azure-event-hubs-spark` connector is not supported. Instead, read the same `data` and `metadata` event hubs through the built-in Kafka connector — no extra library required:

```python
EH_NAMESPACE = "<resourcesName>-EventHubs"
# Namespace-level RootManageSharedAccessKey connection string (no EntityPath here):
EH_CONNECTION_STRING = (
    "Endpoint=sb://<resourcesName>-EventHubs.servicebus.windows.net/;"
    "SharedAccessKeyName=RootManageSharedAccessKey;"
    "SharedAccessKey=<YOUR_PRIMARY_KEY>"
)
eh_sasl = (
    "kafkashaded.org.apache.kafka.common.security.plain.PlainLoginModule required "
    f'username="$ConnectionString" password="{EH_CONNECTION_STRING}";'
)

def read_eventhub(topic: str):
    return (
        spark.readStream
        .format("kafka")
        .option("kafka.bootstrap.servers", f"{EH_NAMESPACE}.servicebus.windows.net:9093")
        .option("kafka.security.protocol", "SASL_SSL")
        .option("kafka.sasl.mechanism", "PLAIN")
        .option("kafka.sasl.jaas.config", eh_sasl)
        .option("subscribe", topic)            # "data" or "metadata"
        .option("startingOffsets", "earliest")
        .load()
        .selectExpr("CAST(value AS STRING) AS payload")
    )

# Telemetry -> opcua_raw, metadata -> opcua_metadata_raw
(
    read_eventhub("data").writeStream
    .format("delta")
    .outputMode("append")
    .option("checkpointLocation", "/mnt/checkpoints/opcua_raw")
    .table("opcua_raw")
)

(
    read_eventhub("metadata").writeStream
    .format("delta")
    .outputMode("append")
    .option("checkpointLocation", "/mnt/checkpoints/opcua_metadata_raw")
    .table("opcua_metadata_raw")
)
```

Both connectors land the raw event payloads in the same `opcua_raw` and `opcua_metadata_raw` tables, so the rest of this guide works unchanged.

## Step 3: Process and Expand OPC UA PubSub Messages

Once raw data is landing in your Delta tables, use PySpark to expand the nested OPC UA PubSub JSON structure into the intermediate and final tables.

### 3a. Raw Telemetry Expansion

This step unbatches the `Messages` array inside each OPC UA PubSub network message:

```python
from pyspark.sql.functions import from_json, explode, col, to_timestamp
from pyspark.sql.types import (
    StructType, StructField, StringType, ArrayType, MapType
)

# Read new rows from the raw table
raw_df = spark.readStream.format("delta").table("opcua_raw")

# Parse the JSON payload
parsed_df = raw_df.withColumn(
    "payload_json", from_json(col("payload"), "struct<Messages:array<struct<DataSetWriterId:string,Timestamp:string,Payload:string>>>")
)

# Explode the Messages array
intermediate_df = (
    parsed_df
    .select(explode(col("payload_json.Messages")).alias("msg"))
    .select(
        col("msg.DataSetWriterId").alias("DataSetWriterID"),
        to_timestamp(col("msg.Timestamp")).alias("Timestamp"),
        col("msg.Payload").alias("Payload")
    )
)

# Write to the intermediate Delta table
(
    intermediate_df.writeStream
    .format("delta")
    .outputMode("append")
    .option("checkpointLocation", "/mnt/checkpoints/opcua_intermediate")
    .table("opcua_intermediate")
)
```

### 3b. Dataset Expansion (Intermediate → Telemetry)

This step pivots the key-value payload into individual telemetry rows:

```python
from pyspark.sql.functions import from_json, explode, col, map_keys, map_values

# Read from intermediate table
intermediate_stream = spark.readStream.format("delta").table("opcua_intermediate")

# Parse the Payload as a map and explode the keys
telemetry_df = (
    intermediate_stream
    .withColumn("payload_map", from_json(
        col("Payload"),
        MapType(StringType(), "struct<Value:string>")
    ))
    .select(
        col("DataSetWriterID"),
        col("Timestamp"),
        explode(col("payload_map")).alias("Name", "val_struct")
    )
    .select(
        col("DataSetWriterID"),
        col("Timestamp"),
        col("Name"),
        col("val_struct.Value").alias("Value")
    )
)

# Write to the final telemetry Delta table
(
    telemetry_df.writeStream
    .format("delta")
    .outputMode("append")
    .option("checkpointLocation", "/mnt/checkpoints/opcua_telemetry")
    .table("opcua_telemetry")
)
```

### 3c. Metadata Expansion

OPC UA PubSub metadata messages contain semantic information encoded in the `Name` field using the pattern:
`<prefix>:<Workcell>.<Line>.<Area>.<Site>.<Enterprise>;nsu=<NamespaceUri>;<NodeId>`

```python
from pyspark.sql.functions import from_json, col, regexp_extract, to_timestamp

# Read from metadata raw table
metadata_raw_stream = spark.readStream.format("delta").table("opcua_metadata_raw")

# Parse the JSON payload
metadata_parsed = metadata_raw_stream.withColumn(
    "p", from_json(col("payload"),
        "struct<DataSetWriterId:string,Timestamp:string,"
        "MetaData:struct<Name:string,"
        "Fields:array<struct<Name:string,Description:string>>>>"
    )
)

# Extract fields using regex on the Name pattern
metadata_df = (
    metadata_parsed
    .select(
        col("p.DataSetWriterId").alias("DataSetWriterID"),
        to_timestamp(col("p.Timestamp")).alias("Timestamp"),
        col("p.MetaData.Name").alias("Name"),
        col("p.MetaData.Fields")[0]["Description"].alias("Type"),
        col("p.MetaData.Fields")[0]["Name"].alias("DisplayName"),
        regexp_extract(col("p.MetaData.Name"), r":([^.]+)\.", 1).alias("Workcell"),
        regexp_extract(col("p.MetaData.Name"), r":(?:[^.]+)\.([^.]+)\.", 1).alias("Line"),
        regexp_extract(col("p.MetaData.Name"), r":(?:[^.]+)\.(?:[^.]+)\.([^.]+)\.", 1).alias("Area"),
        regexp_extract(col("p.MetaData.Name"), r":(?:[^.]+)\.(?:[^.]+)\.(?:[^.]+)\.([^.]+)\.", 1).alias("Site"),
        regexp_extract(col("p.MetaData.Name"), r":(?:[^.]+)\.(?:[^.]+)\.(?:[^.]+)\.(?:[^.]+)\.([^;]+);", 1).alias("Enterprise"),
        regexp_extract(col("p.MetaData.Name"), r";nsu=([^;]+);", 1).alias("NamespaceUri"),
        regexp_extract(col("p.MetaData.Name"), r";nsu=[^;]+;(.+)$", 1).alias("NodeId"),
    )
)

# Write to the metadata Delta table
(
    metadata_df.writeStream
    .format("delta")
    .outputMode("append")
    .option("checkpointLocation", "/mnt/checkpoints/opcua_metadata")
    .table("opcua_metadata")
)
```

## Step 4: Create a Last-Known-Value (LKV) View for Metadata

In Azure Data Explorer, this was accomplished with a **materialized view** using `arg_max`. In Databricks, you can achieve the same result with a SQL view or a scheduled merge.

### Option A: SQL View (Simple)

```sql
CREATE OR REPLACE VIEW opcua_metadata_lkv AS
SELECT m.*
FROM opcua_metadata m
INNER JOIN (
    SELECT Name, DataSetWriterID, MAX(Timestamp) AS MaxTimestamp
    FROM opcua_metadata
    GROUP BY Name, DataSetWriterID
) latest
ON m.Name = latest.Name
AND m.DataSetWriterID = latest.DataSetWriterID
AND m.Timestamp = latest.MaxTimestamp;
```

### Option B: Delta Live Tables (Production)

If you are using [Delta Live Tables](https://docs.databricks.com/en/delta-live-tables/index.html), you can define a streaming live table that maintains the LKV automatically:

```python
import dlt
from pyspark.sql.functions import col, row_number
from pyspark.sql.window import Window

@dlt.table(comment="Last known value for OPC UA metadata")
def opcua_metadata_lkv():
    w = Window.partitionBy("Name", "DataSetWriterID").orderBy(col("Timestamp").desc())
    return (
        dlt.read("opcua_metadata")
        .withColumn("rn", row_number().over(w))
        .filter(col("rn") == 1)
        .drop("rn")
    )
```

## Step 5: Query Your OPC UA Data

With your data flowing into Delta Lake, you can query it using SQL or PySpark. Here is an example query that joins metadata and telemetry — equivalent to the ADX KQL queries:

```sql
-- Find the status of all assembly stations in Munich in the last hour
SELECT
    m.Name,
    m.DisplayName,
    m.Workcell,
    m.Line,
    t.Timestamp,
    t.Value
FROM opcua_metadata_lkv m
INNER JOIN opcua_telemetry t
    ON m.DataSetWriterID = t.DataSetWriterID
WHERE m.Name LIKE '%assembly%'
  AND m.Name LIKE '%munich%'
  AND t.Name = 'Status'
  AND t.Timestamp > current_timestamp() - INTERVAL 1 HOUR;
```

## Step 6: Import OPC UA Information Models from the UA Cloud Library (hosted by the OPC Foundation)

Many customers want to import entire **OPC UA Information Models** into their analytics platform from the [UA Cloud Library](https://uacloudlibrary.opcfoundation.org). This provides richer semantics beyond what OPC UA PubSub metadata alone can offer, including:

- **Full Information Model context** — not just the published data points, but the entire model hierarchy
- **Complex type definitions** and references to other data needed for deeper analysis
- **Visibility into all available telemetry** from your sites, enabling informed decisions about what to publish to the cloud

### Register and Browse

1. Register for free: [https://uacloudlibrary.opcfoundation.org/Identity/Account/Register](https://uacloudlibrary.opcfoundation.org/Identity/Account/Register)
2. Browse available Information Models: [https://uacloudlibrary.opcfoundation.org/Explorer](https://uacloudlibrary.opcfoundation.org/Explorer)
3. Find the unique ID via the REST API: [https://uacloudlibrary.opcfoundation.org/infomodel/namespaces](https://uacloudlibrary.opcfoundation.org/infomodel/namespaces)
   - For example, the "Robotics" Information Model has the unique ID `4172981173`.

### Import an Information Model into Databricks

In Azure Data Explorer, this was done using the `evaluate http_request()` operator. In Databricks, you can use a PySpark notebook with the `requests` library:

```python
import requests
import base64
import xml.etree.ElementTree as ET
from pyspark.sql import Row

# --- Configuration ---
CLOUD_LIBRARY_USERNAME = "<your-cloud-library-username>"
CLOUD_LIBRARY_PASSWORD = "<your-cloud-library-password>"
INFORMATION_MODEL_ID = "4172981173"  # e.g., Robotics

# --- Download the Information Model ---
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

You have just imported an entire OPC UA Information Model into a Delta Lake table in Azure Databricks, ready to be joined with your telemetry and metadata for richer analytics.

## Summary

Azure Databricks offers a flexible, scalable, and unified analytics platform for OPC UA data. With Delta Lake, Structured Streaming, and the rich PySpark/SQL ecosystem, you get all the capabilities needed to ingest, process, contextualize, and analyze your industrial data — from the shop floor to the cloud.

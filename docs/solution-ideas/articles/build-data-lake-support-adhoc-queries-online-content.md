The visibility of raw data in leisure and travel booking scenarios is important
to multiple actors. Technical support teams oversee real-time diagnostics to
continuously monitor transaction processing and rapidly react to undesired
issues. Data engineers oversee exporting data for stakeholder review and to feed
analytics in real time. Customer support teams require historical and recent
data to handle customer inquiries and complaints. Finally, legal teams ensure
compliance duties are respected and legal actions performed. These types of
requirements are typical in marketplaces that aggregate external providers and
manage user purchases. For example, leisure and travel booking systems
disintermediate users and services providers for searching services, aggregating
meaningful offers from providers, and managing user reservations.

## Potential use cases

You should use this pattern when:

-   You need to quickly answer ad hoc queries from a live data repository.
-   Your data is insourced as raw documents (for instance as json, xml, or csv
    files).
-   A fraction of data is sufficient to describe queries.
-   Users want to retrieve full raw documents.
-   The size of all data would require scaling the system above your target
    price.

This pattern might not be suitable when:

-   Data is insourced as recordsets.
-   Users are required to run analytics.
-   Users are willing to use their own packaged BI tool.
-   The size of data is not a challenge from a cost perspective.
-   Raw documents are not necessarily required.

## Architecture

:::image type="content" source="../media/build-data-lake-support-adhoc-queries-online-01.png" alt-text="Diagram of a marketplace with service providers and B2B and B2C users.":::

Typical technical needs in these scenarios include the ability to:

-   Quickly retrieve either real-time (for example, for diagnostics) or
    historical (for compliance) raw documents in their original format.
-   Manage petabytes of data.
-   Guarantee seconds-range performance for real-time diagnostics.
-   Achieve a unified approach to real-time diagnostics, historical queries, and
    feeding analytics.
-   Feed downstream real-time analytics.
-   Control costs.

### Context and problem

Leisure and travel booking scenarios can generate large amounts of raw documents
at a high frequency. However, you may not need to index the entire contents of
these documents. For example, users may need to search by a known transaction
ID, or by a customer name on a certain date, to retrieve a set of documents that
is interesting to them.

The concept behind this architecture consists in decoupling the metadata useful
for searching from bare data. Specifically, only metadata gets indexed within a
queryable service (such as Spark), while the actual data is stored in a data
lake. Raw documents in a data lake are linked to indexed metadata by their path.
When querying for documents, the service searches the documents' metadata, and
in turn the actual documents will be retrieved from the data lake by their path.
This solution dramatically lowers costs and increases performance, as metadata
comprises a fraction of the entire data estate (for instance, petabytes of raw
documents can be described by tens of gigabytes of concise metadata).

In addition, managing the blending of historical depth and real-time
requirements into a uniform, easy-to-maintain, high-performance system is a
typical challenge of this type of scenario. The [Delta Lake](https://delta.io)
architecture answers this challenge.

:::image type="content" source="../media/build-data-lake-support-adhoc-queries-online-02.png" alt-text="Diagram of Delta Lake architecture." lightbox="../media/build-data-lake-support-adhoc-queries-online-02.png":::

### Alternatives

When considering this pattern, also consider the tradeoffs that alternative
approaches offer:

-   As an alternative to only indexing metadata, you could index all raw data in
    a service that offers query capabilities, such as Azure Databricks, Azure
    Synapse Analytics, Azure Cognitive Search, or Azure Data Explorer. This
    approach is more immediate, but attention should be paid to the combined
    effect of data size, performance requirements, and update frequency,
    especially from a cost perspective.
-   Contrary to using a delta lake, using a [lambda architecture](/azure/architecture/data-guide/big-data/#lambda-architecture)
    keeps real-time data in a different repository than the historical data, and
    your client runs the logic to make heterogeneous queries transparent to the
    user. The advantage of this solution is the larger set of services that you
    can use (such as Azure Stream Analytics and Azure SQL Database), but the
    architecture would be more complex and the code base more expensive to
    maintain.

## Considerations

Consider the following points when deciding whether to implement this pattern:

-   Azure Event Hubs is highly versatile when it comes to decoupling a
    transactional system that generates raw documents from a diagnostics and
    compliance system; is easy to implement in already-established
    architectures; and, ultimately, is easy to use. However, the transactional
    system might already use the streaming pattern to process incoming
    documents. In that case, you would likely need to integrate logic for
    managing diagnostics and compliance into the streaming application as a
    substream.
-   Users will perform a double hop to access data. They’ll query metadata
    first, and then retrieve the desired set of documents. It might be difficult
    to reuse existing or packaged client assets.
-   The data lake will potentially manage petabytes of data, so data retention
    policies generally apply. Data governance solutions should be employed to
    manage data lifecycle, such as when to move old data between hot and cool
    storage tiers, when to delete or archive old data, and when to aggregate
    information into a downstream analytics solution.
-   Azure Data Lake Storage Gen2 provides three [performance tiers](/azure/cloud-adoption-framework/scenarios/data-management/best-practices/data-lake-key-considerations):
    hot, cool, and archive. In scenarios where documents are occasionally
    retrieved, the cool performance tier should guarantee similar performance to
    the hot performance tier but with the advantage of lower costs. In scenarios
    where the probability of retrieval is higher with newer data, consider
    blending the cool and hot tiers. Using archive tier storage could also
    provide an alternative to hard deletion, as well as reduce the size of data
    by keeping only meaningful information or more aggregated data.
-   Consider how this approach might work with downstream analytics scenarios.
    Although this pattern is not meant for analytics, it is appropriate for
    feeding downstream real-time analytics, while batch scenarios could be fed
    from the data lake instead.
-   Spark is distributed with Azure Databricks, Azure Synapse Analytics, and
    Azure HDInsight. Hence, the above architecture could be implemented with any
    of these Azure data services, preferably with a recent Spark version
    supporting Delta Lake 0.8 or 1.0.

## Deploy this scenario

In the following example architecture, we assume that one or more Azure Event
Hubs namespaces will contain structured raw documents (such as json or xml
files). However, the actual type and format of documents and source services,
and their type of integration, is highly dependent on the specific scenario and
architecture.

### Streaming

With Spark Structured Streaming, raw data is pulled, decompressed, parsed, and
translated to tabular data in a streaming DataFrame.

The following PySpark code snippet is used to load a streaming DataFrame from
Event Hubs:

```PySpark
# Code tested in Databricks with Delta Lake 1.0
eh_connstr = <your_conn_str>
eh_consumergroup = <your_consumer_group>
ehConf = {}
ehConf['eventhubs.connectionString'] = 
sc._jvm.org.apache.spark.eventhubs.EventHubsUtils.encrypt(eh_conn
str)
ehConf['eventhubs.consumerGroup'] = eh_consumergroup

streaming_df = spark \
  .readStream \
  .format("eventhubs") \
  .options(**ehConf) \
  .load()
```

The following code snippet is used to process the streaming DataFrame. It first
decompresses the Event Hubs message if necessary, and then parses its json
structure to a tabular format. This code is an example and should be adapted to
your specific scenario:

```
# Code tested in Databricks with Delta Lake 1.0

# defines an UDF to unzip the Event Hubs Body field, assuming it 
is gzipped

import zlib
def DecompressFunction(data):
  decoded_data = zlib.decompress(bytes(data), 15+32)
  return decoded_data.decode()

Decompress = udf(lambda body: DecompressFunction(body), 
StringType())
decoded_body_df = streaming_df.withColumn("DecodedBody", 
Decompress(col("body"))).select("DecodedBody")

# Parse json message from Event Hubs body, assuming the raw 
document is stored in the data field, and the others fields hold 
some metadata about it

schema = StructType([ \
    StructField("transactionId", LongType(),True), \
    StructField("timestamp",TimestampType(),True), \
    StructField("providerName", StringType(),True), \
    StructField("document", StringType(),True), \
    StructField("documentType", StringType(),True)
  ])

parsed_body_df = decoded_body_df.withColumn("jsonBody", 
from_json(col("DecodedBody"), schema)).select("jsonBody")
```

Actual data processing consists of two steps. The first is to extract metadata
to assist searching the raw documents after processing. Actual metadata depends
on the use case, but generalizable examples would be relevant dates and
identifiers, document types, source service, and any type of category:

```
# Code tested in Databricks with Delta Lake 1.0

df = parsed_body_df \
    .withColumn("transactionId", 
parsed_body_df.jsonBody.transactionId) \
    .withColumn("timestamp", parsed_body_df.jsonBody.timestamp) \
    .withColumn("providerName", 
parsed_body_df.jsonBody.providerName) \
    .withColumn("data", parsed_body_df.jsonBody.data)
    .withColumn("documentType", 
parsed_body_df.jsonBody.documentType)
```

The second processing step is to generate a path to Azure Data Lake Storage
Gen2, where you’ll store raw documents:

```
# Code tested in Databricks with Delta Lake 1.0

# A function to generate a path
def GetPathFunction(timeStamp, transactionId, providerName, 
Suffix='', Extension=".gz"):
  yy = timeStamp.year
  mm = timeStamp.month
  dd = timeStamp.day
  hh = timeStamp.hour
  mn = timeStamp.minute
  Suffix = f"{Suffix}_" if Suffix != '' else ''
  Name = f"{Suffix}{providerName}{Extension}"
  path = f"/{yy}/{mm}/{dd}/{hh}/{mn}/{transactionId}/{Name}"
  return path

GetPath = udf(lambda timestamp, transactionId, providerName, 
suffix, extension: GetPathFunction(timestamp, transactionId, 
providerName, suffix, extension), StringType())

df = df.withColumn("path", GetPath(col("timestamp"), 
col("transactionId"), col("providerName"), col('documentType')))
```

### Metadata ingestion in a delta lake

Metadata is written to a delta table that enables real-time query capabilities.
Writes are streamed in a buffer, and queries to the table can merge results from
the buffer with those from the historical portion of the table.

The following code snippet shows how to define a delta table in the metastore
and partition it by date:

```
# Code tested in Databricks with Delta Lake 1.0

DeltaTable.create(spark) \
   .tableName("metadata") \
   .addColumn("transactionId", LongType()) \
   .addColumn("date", TimestampType()) \
   .addColumn("providerName", StringType()) \
   .addColumn("documentType", StringType()) \
   .addColumn("path", StringType()) \
   .partitionedBy("date") \
   .execute()
```

Note that the transactionId field is numeric. Typical messages passing
distributed systems might use GUIDs to uniquely identify transactions instead.
However, numeric data types enable greater query performance in most data
platforms.

Assigning a unique transaction identifier might be challenging given the
distributed nature of cloud data platforms (such as Spark). A useful approach is
to base such a transaction identifier on a partition identifier (like the Event
Hubs partition number) and a within-partition incremental number. An example of
this approach is [monotonically_increasing_id()](/azure/databricks/kb/sql/gen-unique-increasing-values#use-monotonically_increasing_id-for-unique-but-not-consecutive-numbers)
in Azure Databricks.

The following code snippet shows how to append the stream with metadata of raw
documents to the delta table:

```
# Code tested in Databricks with Delta Lake 1.0

df.withColumn("date", col("timeStamp").cast(DateType())) \
    .select("transactionId", "date", "providerName", 
"documentType", "path") \
    .writeStream.format("delta") \
    .outputMode("append") \
    .option("checkpointLocation", 
"/delta/metadata/_checkpoints/metadata_checkpoint") \
    .table("metadata")
```

*Note that partitioning is managed while writing the stream according to the
table schema.*

### Data ingestion in a data lake

Actual raw documents are written to an appropriate storage performance tier in
Azure Data Lake Gen2.

The following code snippet shows a simple function to upload a file to Azure
Data Lake Store Gen2; using a *foreach* method in the DataStreamWriter class
allows you to upload the file hosted in each record of the streaming DataFrame:

```
# Code tested in Databricks with Delta Lake 1.0

from azure.storage.filedatalake import DataLakeServiceClient

def upload_data(storage_account_name, storage_account_key, 
file_system_name, file_path, data):

  service_client = 
DataLakeServiceClient(account_url="{}://{}.dfs.core.windows.net".
format("https", storage_account_name), 
credential=storage_account_key)

  file_system_client = 
service_client.get_file_system_client(file_system_name)
  file_client = 
service_client.get_file_client(file_system_client.file_system_nam
e, file_path)
    
  if not file_client.exists:
    file_client.create_file()      

  file_client.upload_data(data, overwrite=True)
  
# Process a row to upload data to ADLS
def Row2ADLS(row):
  upload_data(adls_name, adls_key, adls_container, row['path'], 
row['data'])

df.writeStream.foreach(Row2ADLS).start()
```

### Client

The client can be a custom web application that uses metadata to retrieve
document paths from the delta table with standard SQL statements and, in turn,
the actual document from the data lake with standard Azure Data Lake Storage
Gen2 APIs.

The following code snippet, for example, shows how to retrieve the paths of all
the documents in a certain transaction:

```
select * from metadata where transactionId = '123456'
```

## Next steps

-   [Delta Lake](https://delta.io/)
-   [Delta Lake in Azure Synapse Analytics](/azure/synapse-analytics/spark/apache-spark-what-is-delta-lake)
-   [Delta Lake in Azure Databricks](/azure/databricks/delta/delta-streaming)
-   [Spark Structured Streaming](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html)

## Related resources

-   [Azure Synapse Analytics](/azure/synapse-analytics/)
-   [What is Delta Lake in Azure Synapse Analytics](/azure/synapse-analytics/spark/apache-spark-what-is-delta-lake)
-   [Azure Databricks Delta Lake and Delta Engine guide](/azure/databricks/delta/)

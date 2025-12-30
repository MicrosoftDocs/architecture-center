<!-- cSpell:ignore eventhubs shapefile malformedrides malformedfares Dropwizard dropoff timechart DBUs DBCU -->

This reference architecture shows an end-to-end stream processing pipeline. The four stages of this pipeline include ingest, process, store, and analyze and report. For this reference architecture, the pipeline ingests data from two sources, performs a join on related records from each stream, enriches the result, and calculates an average in real time. The results are then stored for further analysis.

## Architecture

:::image type="complex" border="false" source="./images/stream-processing-databricks.svg" alt-text="Diagram that shows a reference architecture for stream processing with Azure Databricks." lightbox="./images/stream-processing-databricks.svg":::
  Diagram that shows a reference architecture for stream processing with Azure Databricks. In the diagram, two data sources produce real-time streams of ride and fare information. Data gets ingested by way of Azure Event Hubs, processed by Azure Databricks, stored in Azure Cosmos DB, and then analyzed by using Microsoft Fabric (querying mirrored operational data in a lakehouse or warehouse) and Azure Log Analytics.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/stream-processing-databricks.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram.

1. **Ingest**

   Two real‑time operational data streams feed the system: *fare* data and *trip* data. The data sources are devices installed in the taxi cabs. The devices publish events into Azure Event Hubs. Each stream is sent to its own event hub instance, providing independent ingestion paths.

1. **Process**

   Azure Databricks consumes both Event Hubs streams and runs the following operations:

   - Correlation between fare and trip records
   - Enrichment using a third dataset, neighborhood lookup data stored in the Azure Databricks file system

   The result is a unified, enriched dataset suitable for downstream analytics and storage.

1. **Store**

   The output of the Azure Databricks jobs is a series of records. The processed records are written into Azure Cosmos DB for NoSQL.

1. **Analyze / report**

   Operational data in Cosmos DB is queried without impacting transactional performance using [Mirroring Azure Cosmos DB for NoSQL in Microsoft Fabric](/fabric/database/mirrored-database/azure-cosmos-db), which provides a no‑ETL path for analytics. In this architecture, you can use it for the following purposes:

    - Mirror Cosmos DB data (or Delta‑formatted data) into Fabric
    - Keep datasets synchronized with the operational system
    - Enable analysis through:
      - Fabric SQL analytics endpoints (Lakehouse/Warehouse)
      - Spark notebooks
      - Real‑Time Analytics (KQL) for time‑series and log‑style exploration

1. **Monitor**

   Azure Monitor collects telemetry from the Azure Databricks processing pipeline. Application logs and metrics are stored in a Log Analytics workspace, where you can:

   - Query operational logs
   - Visualize metrics
   - Inspect failures, anomalies, and performance issues
   - Build dashboards

## Components

- [Azure Databricks](/azure/well-architected/service-guides/azure-databricks-security) is an Apache Spark-based analytics platform that's optimized for the Microsoft Azure cloud services platform. In this architecture, Azure Databricks jobs enrich taxi ride and fare data and store the results in Azure Cosmos DB.

- [Azure Event Hubs](/azure/well-architected/service-guides/event-hubs) is a managed, distributed ingestion service that can scale to ingest large amounts of events. This architecture uses two event hub instances to receive data from taxis.

- [Azure Cosmos DB for NoSQL](/azure/well-architected/service-guides/cosmos-db) is a fully managed, multiple-model database service. In this architecture, it stores the output of the Azure Databricks enrichment jobs. Data from within the database is mirrored for analytical queries using [Mirroring Azure Cosmos DB for NoSQL in Microsoft Fabric](/fabric/database/mirrored-database/azure-cosmos-db).

- [Azure Log Analytics](/azure/well-architected/service-guides/azure-log-analytics) is a tool within Azure Monitor that helps you query and analyze log data from various sources. In this architecture, all resources have Azure Diagnostics configured to store platform logs in this data store. It's also the data sink for all of the Spark job metrics emitted from the Azure Databricks processing pipelines.

## Scenario details

A taxi company collects data about each taxi trip. For this scenario, we assume that two separate devices send data. The taxi has a meter that sends information about each ride, including the duration, distance, and pickup and drop-off locations. A separate device accepts payments from customers and sends data about fares. To spot ridership trends, the taxi company wants to calculate the average tip per mile driven for each neighborhood, in real time.

## Data ingestion

To simulate a data source, this reference architecture uses the [New York City taxi data dataset](https://uofi.app.box.com/v/NYCtaxidata/folder/2332218797)<sup id="note1">[1](#note1)</sup>. This dataset contains data about taxi trips in New York City from 2010 to 2013. It contains both ride and fare data records. Ride data includes trip duration, trip distance, and the pickup and drop-off locations. Fare data includes fare, tax, and tip amounts. Fields in both record types include medallion number, hack license, and vendor ID. The combination of these three fields uniquely identifies a taxi and a driver. The data is stored in CSV format.

<span id="note1">[1]</span> Donovan, Brian; Work, Dan (2016): New York City Taxi Trip Data (2010-2013). University of Illinois at Urbana-Champaign. [https://doi.org/10.13012/J8PN93H8](https://doi.org/10.13012/J8PN93H8)

The data generator is a .NET Core application that reads the records and sends them to Event Hubs. The generator sends ride data in JSON format and fare data in CSV format.

Event Hubs uses [partitions](/azure/event-hubs/event-hubs-features#partitions) to segment the data. Partitions enable a consumer to read each partition in parallel. When you send data to Event Hubs, you can specify the partition key directly. Otherwise, records are assigned to partitions in round-robin fashion.

In this scenario, ride data and fare data should be assigned the same partition ID for a specific taxi cab. This assignment enables Databricks to apply a degree of parallelism when it correlates the two streams. For example, a record in partition *n* of the ride data matches a record in partition *n* of the fare data.

:::image type="content" source="./images/stream-processing-databricks-event-hubs.svg" alt-text="Diagram of stream processing with Azure Databricks and Event Hubs." border="false" lightbox="./images/stream-processing-databricks-event-hubs.svg" :::

*Download a [Visio file](https://arch-center.azureedge.net/stream-processing-databricks-event-hubs.vsdx)* of this architecture.

In the data generator, the common data model for both record types has a `PartitionKey` property that is the concatenation of `Medallion`, `HackLicense`, and `VendorId`.

```csharp
public abstract class TaxiData
{
    public TaxiData()
    {
    }

    [JsonProperty]
    public long Medallion { get; set; }

    [JsonProperty]
    public long HackLicense { get; set; }

    [JsonProperty]
    public string VendorId { get; set; }

    [JsonProperty]
    public DateTimeOffset PickupTime { get; set; }

    [JsonIgnore]
    public string PartitionKey
    {
        get => $"{Medallion}_{HackLicense}_{VendorId}";
    }
```

Use this property to provide an explicit partition key when it sends data to Event Hubs.

```csharp
using (var client = pool.GetObject())
{
    return client.Value.SendAsync(new EventData(Encoding.UTF8.GetBytes(
        t.GetData(dataFormat))), t.PartitionKey);
}
```

### Event Hubs

The throughput capacity of Event Hubs is measured in [throughput units](/azure/event-hubs/event-hubs-scalability#throughput-units). You can autoscale an event hub by enabling [auto-inflate](/azure/event-hubs/event-hubs-auto-inflate). This feature automatically scales the throughput units based on traffic, up to a configured maximum.

### Stream processing

In Azure Databricks, a job performs data processing. The job is assigned to a cluster and then runs on it. The job can be custom code written in Java or a Spark [notebook](/azure/databricks/notebooks/).

In this reference architecture, the job is a Java archive that has classes written in Java and Scala. When you specify the Java archive for a Azure Databricks job, the Azure Databricks cluster specifies the class for operation. Here, the `main` method of the `com.microsoft.pnp.TaxiCabReader` class contains the data processing logic.

#### Read the stream from the two event hub instances

The data processing logic uses [Spark structured streaming](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html) to read from the two Azure event hub instances:

```scala
// Create a token credential using Managed Identity
val credential = new DefaultAzureCredentialBuilder().build()

val rideEventHubOptions = EventHubsConf(rideEventHubEntraIdAuthConnectionString)
  .setTokenProvider(EventHubsUtils.buildTokenProvider(..., credential))
  .setConsumerGroup(conf.taxiRideConsumerGroup())
  .setStartingPosition(EventPosition.fromStartOfStream)
val rideEvents = spark.readStream
  .format("eventhubs")
  .options(rideEventHubOptions.toMap)
  .load

val fareEventHubOptions = EventHubsConf(fareEventHubEntraIdAuthConnectionString)
  .setTokenProvider(EventHubsUtils.buildTokenProvider(..., credential))
  .setConsumerGroup(conf.taxiFareConsumerGroup())
  .setStartingPosition(EventPosition.fromStartOfStream)
val fareEvents = spark.readStream
  .format("eventhubs")
  .options(fareEventHubOptions.toMap)
  .load
```

#### Enrich the data with the neighborhood information

The ride data includes the latitude and longitude coordinates of the pickup and drop-off locations. These coordinates are useful but not easily consumed for analysis. So, this data is enriched with neighborhood data that gets read from a [shapefile](https://en.wikipedia.org/wiki/Shapefile).

The shapefile format is binary and not easily parsed. But the [GeoTools](https://geotools.org) library provides tools for geospatial data that use the shapefile format. This library is used in the `com.microsoft.pnp.GeoFinder` class to determine the neighborhood name based on the coordinates for pickup and drop-off locations.

```scala
val neighborhoodFinder = (lon: Double, lat: Double) => {
      NeighborhoodFinder.getNeighborhood(lon, lat).get()
    }
```

#### Join the ride and fare data

First the ride and fare data is transformed:

```scala
val rides = transformedRides
  .filter(r => {
    if (r.isNullAt(r.fieldIndex("errorMessage"))) {
      true
    }
    else {
      malformedRides.add(1)
      false
    }
  })
  .select(
    $"ride.*",
    to_neighborhood($"ride.pickupLon", $"ride.pickupLat")
      .as("pickupNeighborhood"),
    to_neighborhood($"ride.dropoffLon", $"ride.dropoffLat")
      .as("dropoffNeighborhood")
  )
  .withWatermark("pickupTime", conf.taxiRideWatermarkInterval())

val fares = transformedFares
  .filter(r => {
    if (r.isNullAt(r.fieldIndex("errorMessage"))) {
      true
    }
    else {
      malformedFares.add(1)
      false
    }
  })
  .select(
    $"fare.*",
    $"pickupTime"
  )
  .withWatermark("pickupTime", conf.taxiFareWatermarkInterval())
```

Then, the ride data is joined with the fare data:

```scala
val mergedTaxiTrip = rides.join(fares, Seq("medallion", "hackLicense", "vendorId", "pickupTime"))
```

#### Process the data and insert it into Azure Cosmos DB

The average fare amount for each neighborhood is calculated for a specific time interval:

```scala
val maxAvgFarePerNeighborhood = mergedTaxiTrip.selectExpr("medallion", "hackLicense", "vendorId", "pickupTime", "rateCode", "storeAndForwardFlag", "dropoffTime", "passengerCount", "tripTimeInSeconds", "tripDistanceInMiles", "pickupLon", "pickupLat", "dropoffLon", "dropoffLat", "paymentType", "fareAmount", "surcharge", "mtaTax", "tipAmount", "tollsAmount", "totalAmount", "pickupNeighborhood", "dropoffNeighborhood")
      .groupBy(window($"pickupTime", conf.windowInterval()), $"pickupNeighborhood")
      .agg(
        count("*").as("rideCount"),
        sum($"fareAmount").as("totalFareAmount"),
        sum($"tipAmount").as("totalTipAmount"),
        (sum($"fareAmount")/count("*")).as("averageFareAmount"),
        (sum($"tipAmount")/count("*")).as("averageTipAmount")
      )
      .select($"window.start", $"window.end", $"pickupNeighborhood", $"rideCount", $"totalFareAmount", $"totalTipAmount", $"averageFareAmount", $"averageTipAmount")
```

The average fare amount is then inserted into Azure Cosmos DB:

```scala
maxAvgFarePerNeighborhood
  .writeStream
  .format("cosmos.oltp")
  .option("spark.cosmos.accountEndpoint", "<your-cosmos-endpoint>")
  .option("spark.cosmos.accountKey", "<your-cosmos-key>")
  .option("spark.cosmos.database", "<your-database-name>")
  .option("spark.cosmos.container", "<your-container-name>")
  .option("checkpointLocation", "/mnt/checkpoints/maxAvgFarePerNeighborhood")
  .outputMode("append")
  .start()
  .awaitTermination()
```

## Considerations

These considerations implement the pillars of the Microsoft Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Azure Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Access to the Azure Databricks workspace is controlled by using the [administrator console](/azure/databricks/admin/workspace/). The administrator console includes functionality to add users, manage user permissions, and set up single sign-on. Access control for workspaces, clusters, jobs, and tables can also be set through the administrator console.

#### Manage secrets

Azure Databricks includes a [secret store](/azure/databricks/security/secrets/) that's used to store credentials and reference them in notebooks and jobs. Scopes partition secrets within the Azure Databricks secret store:

```bash
databricks secrets create-scope --scope "azure-databricks-job"
```

Secrets are added at the scope level:

```bash
databricks secrets put --scope "azure-databricks-job" --key "taxi-ride"
```

> [!NOTE]
> Use an [Azure Key Vault-backed scope](/azure/databricks/security/secrets/#akv-ss) instead of the native Azure Databricks scope.

In code, secrets are accessed by way of the Azure Databricks [secrets utilities](/azure/databricks/dev-tools/databricks-utils).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs. Consider the following services used in this reference architecture.

#### Event Hubs cost considerations

This reference architecture deploys Event Hubs in the Standard tier. The pricing model is based on throughput units, ingress events, and capture events. An ingress event is a unit of data that's 64 KB or less. Larger messages are billed in multiples of 64 KB. You specify throughput units either through the Azure portal or Event Hubs management APIs.

If you need more retention days, consider the Dedicated tier. This tier provides single-tenant deployments that have stringent requirements. This offering builds a cluster based on capacity units and isn't dependent on throughput units. The Standard tier is also billed based on ingress events and throughput units.

For more information, see [Event Hubs pricing][event-hubs-pricing].

#### Azure Databricks cost considerations

Azure Databricks provides the Standard tier and the Premium tier, both of which support three workloads. This reference architecture deploys an Azure Databricks workspace in the Premium tier.

Data engineering workloads should run on a job cluster. Data engineers use clusters to build and perform jobs. Data analytics workloads should run on an all-purpose cluster and are intended for data scientists to explore, visualize, manipulate, and share data and insights interactively.

Azure Databricks provides multiple pricing models.

- **Pay-as-you-go plan**

  You're billed for virtual machines (VMs) provisioned in clusters and Azure Databricks units (DBUs) based on the chosen VM instance. A DBU is a unit of processing capability that bills by usage per second. The DBU consumption depends on the size and type of instance that runs in Azure Databricks. Pricing depends on the chosen workload and tier.

- **Pre-purchase plan**

  You commit to DBUs as Azure Databricks commit units for either one or three years to reduce the total cost of ownership over that time period when compared to the pay-as-you-go model.

For more information, see [Azure Databricks pricing][azure-databricks-pricing].

#### Azure Cosmos DB cost considerations

In this architecture, the Azure Databricks job writes a series of records to Azure Cosmos DB. You're charged for the capacity that you reserve, which is measured in Request Units per second (RU/s). This capacity is used to perform insert operations. The unit for billing is 100 RU/s per hour. For example, the cost of writing 100-KB items is 50 RU/s.

For write operations, set up enough capacity to support the number of writes needed per second. You can increase the provisioned throughput by using the portal or Azure CLI before you perform write operations and then reducing the throughput after those operations are complete. Your throughput for the write period is the sum of the minimum throughput needed for the specific data and the throughput required for the insert operation. This calculation assumes that there's no other workload running.

##### Example cost analysis

Suppose you configure a throughput value of 1,000 RU/s on a container. It deploys for 24 hours for 30 days, for a total of 720 hours.

The container is billed at 10 units of 100 RU/s per hour for each hour. Ten units at $0.008 (per 100 RU/s per hour) are charged at $0.08 per hour.

For 720 hours or 7,200 units (of 100 RUs), you're billed $57.60 for the month.

Storage is also billed for each GB that's used for your stored data and index. For more information, see [Azure Cosmos DB pricing model][cosmosdb-pricing].

Use the [Azure Cosmos DB capacity calculator][cosmos-calculator] for a quick estimate of the workload cost.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

#### Monitoring

Azure Databricks is based on Apache Spark. Both Azure Databricks and Apache Spark use [Apache Log4j](https://logging.apache.org/log4j/2.x) as the standard library for logging. In addition to the default logging that Apache Spark provides, you can implement logging in Log Analytics. For more information, see [Monitoring Azure Databricks](/azure/architecture/databricks-monitoring/).

As the `com.microsoft.pnp.TaxiCabReader` class processes ride and fare messages, a message might be malformed and therefore not valid. In a production environment, it's important to analyze these malformed messages to identify a problem with the data sources so that it can be fixed quickly to prevent data loss. The `com.microsoft.pnp.TaxiCabReader` class registers an Apache Spark Accumulator that tracks the number of malformed fare records and ride records:

```scala
@transient val appMetrics = new AppMetrics(spark.sparkContext)
appMetrics.registerGauge("metrics.malformedrides", AppAccumulators.getRideInstance(spark.sparkContext))
appMetrics.registerGauge("metrics.malformedfares", AppAccumulators.getFareInstance(spark.sparkContext))
SparkEnv.get.metricsSystem.registerSource(appMetrics)
```

Apache Spark uses the Dropwizard library to send metrics. Some of the native Dropwizard metrics fields are incompatible with Log Analytics, which is why this reference architecture includes a custom Dropwizard sink and reporter. It formats the metrics in the format that Log Analytics expects. When Apache Spark reports metrics, the custom metrics for the malformed ride and fare data are also sent.

You can use the following example queries in your Log Analytics workspace to monitor the operation of the streaming job. The argument `ago(1d)` in each query returns all records that were generated in the last day. You can adjust this parameter to view a different time period.

#### Exceptions logged during stream query operation

```kusto
SparkLoggingEvent_CL
| where TimeGenerated > ago(1d)
| where Level == "ERROR"
```

#### Accumulation of malformed fare and ride data

```kusto
SparkMetric_CL
| where TimeGenerated > ago(1d)
| where name_s contains "metrics.malformedrides"
| project value_d, TimeGenerated, applicationId_s
| render timechart

SparkMetric_CL
| where TimeGenerated > ago(1d)
| where name_s contains "metrics.malformedfares"
| project value_d, TimeGenerated, applicationId_s
| render timechart
```

#### Job operation over time

```kusto
SparkMetric_CL
| where TimeGenerated > ago(1d)
| where name_s contains "driver.DAGScheduler.job.allJobs"
| project value_d, TimeGenerated, applicationId_s
| render timechart
```

#### Resource organization and deployments

- Create separate resource groups for production, development, and test environments. Separate resource groups make it easier to manage deployments, delete test deployments, and assign access rights.

- Use the [Azure Resource Manager template][arm-template] to deploy the Azure resources according to the infrastructure-as-code process. By using templates, you can automate deployments with [Azure DevOps services][az-devops] or other continuous integration and continuous delivery (CI/CD) solutions.

- Put each workload in a separate deployment template and store the resources in source control systems. You can deploy the templates together or individually as part of a CI/CD process. This approach simplifies the automation process.

  In this architecture, Event Hubs, Log Analytics, and Azure Cosmos DB are identified as a single workload. These resources are included in a single Azure Resource Manager template.

- Consider staging your workloads. Deploy to various stages and run validation checks at each stage before you move to the next stage. That way you can control how you push updates to your production environments and minimize unanticipated deployment problems.

  In this architecture, there are multiple deployment stages. Consider creating an Azure DevOps pipeline and adding those stages. You can automate the following stages:

  - Start an Azure Databricks cluster.
  - Configure Azure Databricks CLI.
  - Install Scala tools.
  - Add the Azure Databricks secrets.

  Consider writing automated integration tests to improve the quality and reliability of the Azure Databricks code and its lifecycle.

## Next step

- [Stream processing with Azure Stream Analytics](./stream-processing-stream-analytics.yml)

<!-- links -->

[arm-template]: /azure/azure-resource-manager/management/overview#resource-groups
[az-devops]: /azure/virtual-machines/infrastructure-automation#azure-devops-services
[cosmos-calculator]: https://cosmos.azure.com/capacitycalculator
[cosmosdb-pricing]: https://azure.microsoft.com/pricing/details/cosmos-db/autoscale-provisioned/
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[event-hubs-pricing]: https://azure.microsoft.com/pricing/details/event-hubs/
[azure-databricks-pricing]: https://azure.microsoft.com/pricing/details/databricks/

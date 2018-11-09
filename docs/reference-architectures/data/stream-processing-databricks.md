---
title: Stream processing with Azure Databricks
description: Create an end-to-end stream processing pipeline in Azure using Azure Databricks
author: petertaylor9999
ms.date: 11/01/2018
---

# Stream processing with Azure Databricks

This reference architecture shows an end-to-end stream processing pipeline. The pipeline ingests data from two sources, correlates records in the two streams, and enriches the correlated record with data from external sources. The results are stored for further analysis. [**Deploy this solution**.](#deploy-the-solution)

![](./images/stream-processing-databricks.png)

**Scenario**: A taxi company collects data about each taxi trip. For this scenario, we assume there are two separate devices sending data. The taxi has a meter that sends information about each ride &mdash; the duration, distance, and pickup and dropoff locations. A separate device accepts payments from customers and sends data about fares. The taxi company wants to calculate the average tip per mile driven, in real time, in order to spot trends.

## Architecture

The architecture consists of the following components.

**Data sources**. In this architecture, there are two data sources that generate data streams in real time. The first stream contains ride information, and the second contains fare information. The reference architecture includes a simulated data generator that reads from a set of static files and pushes the data to Event Hubs. In a real application, the data sources would be devices installed in the taxi cabs.

**Azure Event Hubs**. [Event Hubs](/azure/event-hubs/) is an event ingestion service. This architecture uses two event hub instances, one for each data source. Each data source sends a stream of data to the associated event hub.

**Azure Databricks**. [Databricks](/azure/azure-databricks/) is an Apache Spark-based analytics platform optimized for the Microsoft Azure cloud services platform. Databricks is used to correlate of the taxi ride and fare data, and also to enrich the correlated data with neighborhood data stored in the Databricks file system.

**Cosmos DB**. The output from Azure Databricks job is a series of records, which are written to Cosmos DB using the Cassandra API. The Cassandra API is used because it support time series data modeling.

**Microsoft Power BI**. Power BI is a suite of business analytics tools to analyze data for business insights. In this architecture, it loads the data from Cosmos DB. This allows users to analyze the complete set of historical data that's been collected.  You could also stream the results directly from Stream Analytics to Power BI for a real-time view of the data. For more information, see [Real-time streaming in Power BI](/power-bi/service-real-time-streaming).

**Azure Monitor**. [Azure Monitor](/azure/monitoring-and-diagnostics/) collects performance metrics about the Azure services deployed in the solution. By visualizing these in a dashboard, you can get insights into the health of the solution. 

## Data ingestion

To simulate a data source, this reference architecture uses the [New York City Taxi Data](https://uofi.app.box.com/v/NYCtaxidata/folder/2332218797) dataset<sup>[[1]](#note1)</sup>. This dataset contains data about taxi trips in New York City over a 4-year period (2010 &ndash; 2013). It contains two types of record: Ride data and fare data. Ride data includes trip duration, trip distance, and pickup and dropoff location. Fare data includes fare, tax, and tip amounts. Common fields in both record types include medallion number, hack license, and vendor ID. Together these three fields uniquely identify a taxi plus a driver. The data is stored in CSV format. 

The data generator is a .NET Core application that reads the records and sends them to Azure Event Hubs. The generator sends ride data in JSON format and fare data in CSV format. 

Event Hubs uses [partitions](/azure/event-hubs/event-hubs-features#partitions) to segment the data. Partitions allow a consumer to read each partition in parallel. When you send data to Event Hubs, you can specify the partition key explicitly. Otherwise, records are assigned to partitions in round-robin fashion. 

In this particular scenario, ride data and fare data should end up with the same partition ID for a given taxi cab. This enables Databricks to apply a degree of parallelism when it correlates the two streams. A record in partition *n* of the ride data will match a record in partition *n* of the fare data.

![](./images/stream-processing-databricks-eh.png)

In the data generator, the common data model for both record types has a `PartitionKey` property which is the concatenation of `Medallion`, `HackLicense`, and `VendorId`.

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

This property is used to provide an explicit partition key when sending to Event Hubs:

```csharp
using (var client = pool.GetObject())
{
    return client.Value.SendAsync(new EventData(Encoding.UTF8.GetBytes(
        t.GetData(dataFormat))), t.PartitionKey);
}
```

### Event Hubs

The throughput capacity of Event Hubs is measured in [throughput units](/azure/event-hubs/event-hubs-features#throughput-units). You can autoscale an event hub by enabling [auto-inflate](/azure/event-hubs/event-hubs-auto-inflate), which automatically scales the throughput units based on traffic, up to a configured maximum. 

## Stream processing

In Azure Databricks, data processing is performed by a job. The job is assigned to and runs on a cluster. The job can either be custom code written in Java, or a Spark [notebook](https://docs.databricks.com/user-guide/notebooks/index.html).

In this reference architecture, the job is a Java archive with classes written in both Java and Scala. When specifying the Java archive for a Databricks job, a Java class with a **main** method is specificed for execution by the Databricks cluster. Here, the **main** method of the **com.microsoft.pnp.TaxiCabReader** class contains the data processing logic. 

### Reading the stream from the two event hub instances

The data processing logic uses [Spark structured streaming](https://spark.apache.org/docs/2.1.2/structured-streaming-programming-guide.html) to read from the two Azure event hub instances:

```java
val rideEventHubOptions = EventHubsConf(rideEventHubConnectionString)
      .setConsumerGroup(conf.taxiRideConsumerGroup())
      .setStartingPosition(EventPosition.fromStartOfStream)
    val rideEvents = spark.readStream
      .format("eventhubs")
      .options(rideEventHubOptions.toMap)
      .load

    val fareEventHubOptions = EventHubsConf(fareEventHubConnectionString)
      .setConsumerGroup(conf.taxiFareConsumerGroup())
      .setStartingPosition(EventPosition.fromStartOfStream)
    val fareEvents = spark.readStream
      .format("eventhubs")
      .options(fareEventHubOptions.toMap)
      .load
```

### Enriching the data with the neighborhood information

The ride data includes the latitude and longitude coordinates of the pick up and drop off locations. While this data is useful, it's not easily consumed for analysis. Therefore, this data is enriched with neighborhood data that is read from a [shapefile](https://en.wikipedia.org/wiki/Shapefile). 

The shapefile format is a binary format and not easily parsed, but the [GeoTools](http://geotools.org/) is an open source Java libary that provides tools for geospatial data that utilize the shapefile format. This library is used in the **com.microsoft.pnp.GeoFinder** class to determine the neighborhood name based on the pick up and drop off coordinates. 

```java
val neighborhoodFinder = (lon: Double, lat: Double) => {
      NeighborhoodFinder.getNeighborhood(lon, lat).get()
    }
```

### Joining the ride and fare data

First the ride and fare data is transformed:

```java
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

And then the ride data is joined with the fare data:

```java
val mergedTaxiTrip = rides.join(fares, Seq("medallion", "hackLicense", "vendorId", "pickupTime"))
```

### Processing the data and inserting into Cosmos DB

The average fare amount for each neighborhood is calculated for a given :

```java
val maxAvgFarePerNeighborhood = mergedTaxiTrip.selectExpr("medallion", "hackLicense", "vendorId", "pickupTime", "rateCode", "storeAndForwardFlag", "dropoffTime", "passengerCount", "tripTimeInSeconds", "tripDistanceInMiles", "pickupLon", "pickupLat", "dropoffLon", "dropoffLat", "paymentType", "fareAmount", "surcharge", "mtaTax", "tipAmount", "tollsAmount", "totalAmount", "pickupNeighborhood", "dropoffNeighborhood")
      .groupBy(window($"pickupTime", conf.windowInterval()), $"pickupNeighborhood")
      .agg(
        count("*").as("rideCount"),
        sum($"fareAmount").as("totalFareAmount"),
        sum($"tipAmount").as("totalTipAmount")
      )
      .select($"window.start", $"window.end", $"pickupNeighborhood", $"rideCount", $"totalFareAmount", $"totalTipAmount")
```

Which is then inserted into Cosmos DB:

```java
maxAvgFarePerNeighborhood
      .writeStream
      .queryName("maxAvgFarePerNeighborhood_cassandra_insert")
      .outputMode(OutputMode.Append())
      .foreach(new CassandraSinkForeach(connector))
      .start()
      .awaitTermination()
```

## Security considerations

Access to the Azure Database workspace is controlled using the [administrator console](https://docs.databricks.com/administration-guide/admin-settings/index.html). The administrator console includes functionality to add users, manage user permissions, and set up single sign-on. Access control for workspaces, clusters, jobs, and tables is also set through the adminstrator console.

### Managing secrets

Azure Databricks includes a [secret store](https://docs.azuredatabricks.net/user-guide/secrets/index.html) that is used to store all of the secrets in the reference architecture including connection strings, access keys, user names, and passwords. Secrets within the Azure Databricks secret store are partitioned by **scopes**:

```bash
databricks secrets create-scope --scope "azure-databricks-job"
```

Secrets are added at the scope level:

```
databricks secrets put --scope "azure-databricks-job" --key "taxi-ride"
```

In code, secrets are accessed via the Azure Databricks [secrets utilities](https://docs.databricks.com/user-guide/dev-tools/dbutils.html#secrets-utilities).

Access to the Azure Databricks workspace is controlled 


## Monitoring considerations

Azure Databricks is based on Apache Spark, and both use [log4j](https://logging.apache.org/log4j/2.x/) as the standard library for logging. In addition to the default logging provided by Apache Spark, this reference architecture sends logs and metrics to [Azure Log Analytics](/azure/log-analytics/).

The **com.microsoft.pnp.TaxiCabReader** class configures the Apache Spark logging system to send its logs to Azure Log Analytics using the values in the **log4j.properties** file. While the Apache Spark logger message are strings, Azure Log Analytics requires log messages to be formatted as JSON. The **com.microsoft.pnp.log4j.LogAnalyticsAppender** class transforms these messages to JSON:

```java

    @Override
    protected void append(LoggingEvent loggingEvent) {
        if (this.layout == null) {
            this.setLayout(new JSONLayout());
        }

        String json = this.getLayout().format(loggingEvent);
        try {
            this.client.send(json, this.logType);
        } catch(IOException ioe) {
            LogLog.warn("Error sending LoggingEvent to Log Analytics", ioe);
        }
    }

```

As the **com.microsoft.pnp.TaxiCabReader** class processes ride and fare messages, it's possible that either one may be malformed and therefore not valid. If this were a production environment, it's important to track these malformed messages to identify a problem with the data sources so it can be fixed as quickly as possible to prevent data loss. The **com.microsoft.pnp.TaxiCabReader** class registers an Apache Spark Accumulator that keeps track of the number of malformed fare and ride records:

```java
    @transient val appMetrics = new AppMetrics(spark.sparkContext)
    appMetrics.registerGauge("metrics.malformedrides", AppAccumulators.getRideInstance(spark.sparkContext))
    appMetrics.registerGauge("metrics.malformedfares", AppAccumulators.getFareInstance(spark.sparkContext))
    SparkEnv.get.metricsSystem.registerSource(appMetrics)
```

However, Apache Spark uses the Dropwizard library to send metrics, and some of the native Dropwizard metrics fields are incompatible with Azure Log Analytics. Therefore, this reference architecture includes a custom Dropwizard sink and reporter. This custom sink and report formats the metrics in the format expected by Azure Log Analytics, so when Apache Spark reports metrics, the custom metrics for the malformed ride and fare data are also sent.

The last metric to be logged to the Azure Log Analytics workspace is the cumulative progress of the Spark Structured Streaming job progress. This is done using a custom StreamingQuery listener implemented in the **com.microsoft.pnp.StreamingMetricsListener** class, which is registered to the Apache Spark Session when the job runs:

```java
spark.streams.addListener(new StreamingMetricsListener())
```

The methods in the StreamingMetricsListener are called by the Apache Spark runtime whenever a structured steaming event occurs.

## Deploy the solution

A deployment for this reference architecture is available on [GitHub](https://github.com/mspnp/reference-architectures/tree/master/data). 

### Prerequisites

1. Clone, fork, or download the zip file for the [reference architectures](https://github.com/mspnp/reference-architectures) GitHub repository.

2. Install [Docker](https://www.docker.com/) to run the data generator.

3. Install [Azure CLI 2.0](/cli/azure/install-azure-cli?view=azure-cli-latest).

4. Install [Databricks CLI](https://docs.databricks.com/user-guide/dev-tools/databricks-cli.html).

4. From a command prompt, bash prompt, or PowerShell prompt, sign into your Azure account as follows:
    ```
    az login
    ```
5. Install a Jave IDE, with the following resources:
    - JDK 1.8
    - Scala SDK 2.11
    - Maven 3.5.4

### Download the New York City taxi and neighborhood data files

1. Create a directory named `DataFile` under the `data/streaming_azuredatabricks` directory in your local file system.

2. Open a web browser and navigate to https://uofi.app.box.com/v/NYCtaxidata/folder/2332219935.

3. Click the **Download** button on this page to download a zip file of all the taxi data for that year.

4. Extract the zip file to the `DataFile` directory.

    > [!NOTE]
    > This zip file contains other zip files. Don't extract the child zip files.

The directory structure should look like the following:

```
/data
    /streaming_azuredatabricks
        /DataFile
            /FOIL2013
                trip_data_1.zip
                trip_data_2.zip
                trip_data_3.zip
                ...
```

5. Open a web browser and navigate to https://www.zillow.com/howto/api/neighborhood-boundaries.htm. 

6. Click on **New York Neighborhood Boundaries** to download the file.

7. Copy the file from your browser's **downloads** directory to the `DataFile` directory.

### Deploy the Azure resources

1. From a shell or Windows Command Prompt, run the following command and follow the sign-in prompt:

    ```bash
    az login
    ```

2. Navigate to the folder `data/streaming_azuredatabricks` in the GitHub repository

    ```bash
    cd data/streaming_azuredatabricks
    ```

3. Run the following commands to deploy the Azure resources:

    ```bash
    export resourceGroup='[Resource group name]'
    export resourceLocation='[Region]'
    export eventHubNamespace='[Event Hubs namespace name]'
    export databricksWorkspaceName='[Azure Databricks workspace name]'
    export cosmosDatabaseAccount='[Cosmos DB database name]'
    export logAnalyticsWorkspaceName='[Log Analytics workspace name]'
    export logAnalyticsWorkspaceRegion='[Log Analytics region]'

    # Create a resource group
    az group create --name $resourceGroup --location $resourceLocation

    # Deploy resources
    az group deployment create --resource-group $resourceGroup \
	    --template-file ./azure/deployresources.json --parameters \
	    eventHubNamespace=$eventHubNamespace \
        databricksWorkspaceName=$databricksWorkspaceName \
	    cosmosDatabaseAccount=$cosmosDatabaseAccount \
	    logAnalyticsWorkspaceName=$logAnalyticsWorkspaceName \
	    logAnalyticsWorkspaceRegion=$logAnalyticsWorkspaceRegion
    ```

4. The output of the deployment is written to the console once complete. Search the output for the following JSON:
```JSON
"outputs": {
        "cosmosDb": {
          "type": "Object",
          "value": {
            "hostName": <value>,
            "secret": <value>,
            "username": <value>
          }
        },
        "eventHubs": {
          "type": "Object",
          "value": {
            "taxi-fare-eh": <value>,
            "taxi-ride-eh": <value>
          }
        },
        "logAnalytics": {
          "type": "Object",
          "value": {
            "secret": <value>,
            "workspaceId": <value>
          }
        }
},
```
These values are the secrets that will be added to Databricks secrets in upcoming sections. Keep them secure until you add them in those sections.

### Add a Cassandra table to the Cosmos DB Account

1. In the Azure Portal, navigate to the resource group created in the **deploy the Azure resources** section above. Click on **Azure Cosmos DB Account**. Create a table with the Cassandra API.

2. In the **overview** blade, click **add table**.

3. When the **add table** blade opens, enter `newyorktaxi` in the **Keyspace name** text box. 

4. In the **enter CQL command to create the table** section, enter `neighborhoodstats` in the text box beside `newyorktaxi`.

5. In the text box below, enter the following::
```
(neighborhood text, window_end timestamp, number_of_rides bigint,total_fare_amount double, primary key(neighborhood, window_end))
```
6. In the **Throughput (1,000 - 1,000,000 RU/s)** text box enter the value `4000`.

7. Click **OK**.

### Add the Databricks secrets using the Databricks CLI

First, enter the secrets for EventHub:

1. Using the **Azure Databricks CLI** installed in step 2 of the prerequisites, create the Azure Databricks secret scope:
    ```
    databricks secrets create-scope --scope "azure-databricks-job"
    ```
2. Add the secret for the taxi ride EventHub:
    ```
    databricks secrets put --scope "azure-databricks-job" --key "taxi-ride"
    ```
    Once executed, this command opens the vi editor. Enter the **taxi-ride-eh** value from the **eventHubs** output section in step 4 of the *deploy the Azure resources* section. Save and exit vi.

3. Add the secret for the taxi fare EventHub:
    ```
    databricks secrets put --scope "azure-databricks-job" --key "taxi-fare"
    ```
    Once executed, this command opens the vi editor. Enter the **taxi-fare-eh** value from the **eventHubs** output section in step 4 of the *deploy the Azure resources* section. Save and exit vi.

Next, enter the secrets for CosmosDb:

1. Open the Azure Portal, and navigate to the resource group specified in step 3 of the **deploy the Azure resources** section. Click on the Azure Cosmos DB Account.

2. Using the **Azure Databricks CLI**, add the secret for the Cosmos DB user name:
    ```
    databricks secrets put --scope azure-databricks-job --key "cassandra-username"
    ```
Once executed, this command opens the vi editor. Enter the **username** value from the **CosmosDb** output section in step 4 of the *deploy the Azure resources* section. Save and exit vi.

4. Next, add the secret for the Cosmos DB password:
    ```
    databricks secrets put --scope azure-databricks-job --key "cassandra-password"
    ```
Once executed, this command opens the vi editor. Enter the **secret** value from the **CosmosDb** output section in step 4 of the *deploy the Azure resources* section. Save and exit vi.

### Add the Zillow Neighborhoods data file to the Databricks file system

1. Create a directory in the Databricks file system:
    ```bash
    dbfs mkdirs dbfs:/azure-databricks-jobs
    ```

2. Navigate to data/streaming_azuredatabricks/DataFile and enter the following:
    ```bash
    dbfs cp ZillowNeighborhoods-NY.zip dbfs:/azure-databricks-jobs
    ```
### Add the Azure Log Analytics workspace ID and primary key to configuration files

For this section, you require the Log Analytics workspace ID and primary key. The workspace ID is the **workspaceId** value from the **logAnalytics** output section in step 4 of the *deploy the Azure resources* section. The primary key is the **secret** from the output section. 

1. To configure log4j logging, open data\streaming_azuredatabricks\azure\AzureDataBricksJob\src\main\resources\com\microsoft\pnp\azuredatabricksjob\log4j.properties. Edit the following two values:
    ```
    log4j.appender.A1.workspaceId=<Log Analytics workspace ID>
    log4j.appender.A1.secret=<Log Analytics primary key>
    ```

2. To configure custom logging, open data\streaming_azuredatabricks\azure\azure-databricks-monitoring\scripts\metrics.properties. Edit the following two values:
    ``` 
    *.sink.loganalytics.workspaceId=<Log Analytics workspace ID>
    *.sink.loganalytics.secret=<Log Analytics primary key>
    ```

### Build the .jar files for the Databricks job and Databricks monitoring

1. Use your Java IDE to import the Maven project file named **pom.xml** located in the root of the **data/streaming_azuredatabricks** directory. 
2. Perform a clean build. The output of this build are files named **azure-databricks-job-1.0-SNAPSHOT.jar** and **azure-databricks-monitoring-0.9.jar**. 

### Configure custom logging for the Databricks job

1. Copy the **azure-databricks-monitoring-0.9.jar** file to the Databricks file system by entering the following command in the **Databricks CLI**:
    ```
    databricks fs cp --overwrite azure-databricks-monitoring-0.9.jar dbfs:/azure-databricks-job/azure-databricks-monitoring-0.9.jar
    ```

2. Copy the custom logging properties from data\streaming_azuredatabricks\azure\azure-databricks-monitoring\scripts\metrics.properties to the Databricks file system by entering the following command:
    ```
    databricks fs cp --overwrite metrics.properties dbfs:/azure-databricks-job/metrics.properties
    ```

3. While you haven't yet decided on a name for your Databricks cluster, select one now. You'll enter the name below in the Databricks file system path for your cluster. Copy the initialization script from data\streaming_azuredatabricks\azure\azure-databricks-monitoring\scripts\spark.metrics to the Databricks file system by entering the following command:
    ```
    databricks fs cp --overwrite spark-metrics.sh dbfs:/databricks/init/<cluster-name>/spark-metrics.sh
    ```

### Create a Databricks cluster

1. In the Databricks workspace, click "Clusters", then click "create cluster". Enter the cluster name you created in step 3 of the **configure custom logging for the Databricks job** section above. 
2. Select a **standard** cluster mode.
3. Set **Databricks runtime version** to **4.3 (includes Apache Spark 2.3.1, Scala 2.11)**
4. Set **Python version** to **2**.
5. Set **Driver Type** to **Same as worker**
6. Set **Worker Type** to **Standard_DS3_v2**.
7. Set **Min Workers** to **2**.
8. Deselect **Enable autoscaling**. 
9. Below the **Auto Termination** dialog box, click on **Init Scripts**. 
10. Enter **dbfs:/databricks/init/<cluster-name>/spark-metrics.sh**, substituting the cluster name created in step 1 for <cluster-name>.
11. Click the **Add** button.
12. Click the **Create Cluster** button.

### Create a Databricks job

1. In the Databricks workspace, click "Jobs", "create job".
2. Enter a job name.
3. Click "set jar", this opens the "Upload JAR to Run" dialog box.
4. Drag the `azure-databricks-job-1.0-SNAPSHOT.jar` file you created in the `Build the .jar for the Databricks job` section to the "Drop JAR here to upload" box.
5. Enter `com.microsoft.pnp.TaxiCabReader` in the `Main Class` field.
6. In the arguments field, enter the following:
    ```
    -n jar:file:/dbfs/azure-databricks-jobs/ZillowNeighborhoods-NY.zip!/ZillowNeighborhoods-NY.shp --taxi-ride-consumer-group taxi-ride-eh-cg --taxi-fare-consumer-group taxi-fare-eh-cg --window-interval "1 minute" --cassandra-host <Cosmos DB Cassandra host name from above> 
    ``` 
7. Install the dependent libraries by following these steps:
    1. In the Databricks workspace, click on "Home", in the `Users` blade, click on your user account name to open your account workspace settings, click on the drop-down arrow beside your account name, click on `create`, and click on `Library` to open the `New Library` dialog. In the `Source` drop-down control, select `Maven Coordinate`. Under the `Install Maven Artifacts` heading, enter `com.microsoft.azure:azure-eventhubs-spark_2.11:2.3.5` in the `Coordinate ` text box. Click on `Create Library`. This will open the `Artifacts` window. Under `Status on running clusters` check the `Attach automatically to all clusters` checkbox.
    2. Repeat step 1 for the `com.datastax.spark:spark-cassandra-connector_2.11:2.3.1` Maven coordinate.
    3. The process is slightly different for the final dependency. On the `New Library` dialog, once again select `Maven Coordinate` from the `Source` drop-down control. In the `Coordinate` text box, enter `org.geotools:gt-shapefile:19.2`. Click on `Advanced Options`, and enter `http://download.osgeo.org/webdav/geotools/` in the `Repository` text box. Click `Create Library`. This will open the `Artifacts` window. Under `Status on running clusters` check the `Attach automatically to all clusters` checkbox.
8. Add the dependent libraries added in step 7 to the job created at the end of step 6. In the Azure Databricks workspace, click on `Jobs`, then click on the job name created in step 2. Click on `Add` beside `Dependent Libraries`. This opens the `Add Dependent Library` dialog. Under `Library From` select `Workspace`. Click on `users`, then your username, then click on `com.microsoft.azure:azure-eventhubs-spark_2.11:2.3.5`. Click `OK`. Repeat this process for `com.datastax.spark:spark-cassandra-connector_2.11:2.3.1` and `org.geotools:gt-shapefile:19.2`.
9. Beside **Cluster:**, click on **Edit**. This opens the **Configure Cluster** dialog. In the **Cluster Type** drop-down, select `Existing Cluster`. In the the **Select Cluster** drop-down, select the cluster created the **create a Databricks cluster** section. Click **confirm**.
10. Click **run now**.

### Run the data generator

1. Navigate to the directory `data/streaming_azuredatabricks/onprem` in the GitHub repository

2. Update the values in the file `main.env` as follows:

    ```
    RIDE_EVENT_HUB=[Connection string for the taxi-ride event hub]
    FARE_EVENT_HUB=[Connection string for the taxi-fare event hub]
    RIDE_DATA_FILE_PATH=/DataFile/FOIL2013
    MINUTES_TO_LEAD=0
    PUSH_RIDE_DATA_FIRST=false
    ```
    The connection string for the taxi-ride event hub is the **taxi-ride-eh** value from the **eventHubs** output section in step 4 of the *deploy the Azure resources* section. The connection string for the taxi-fare event hubthe **taxi-fare-eh** value from the **eventHubs** output section in step 4 of the *deploy the Azure resources* section.

4. Run the following command to build the Docker image.

    ```bash
    docker build --no-cache -t dataloader .
    ```

5. Navigate back to the parent directory, `data/stream_azuredatabricks`.

    ```bash
    cd ..
    ```

6. Run the following command to run the Docker image.

    ```bash
    docker run -v `pwd`/DataFile:/DataFile --env-file=onprem/main.env dataloader:latest
    ```

The output should look like the following:

```
Created 10000 records for TaxiFare
Created 10000 records for TaxiRide
Created 20000 records for TaxiFare
Created 20000 records for TaxiRide
Created 30000 records for TaxiFare
...
```

To verify the Databricks job is running correctly, open the Azure portal and navigate to the Cosmos DB database. Open the **Data Explorer** blade and the examine the data in the **taxirecords** table. 

[1] <span id="note1">Donovan, Brian; Work, Dan (2016): New York City Taxi Trip Data (2010-2013). University of Illinois at Urbana-Champaign. https://doi.org/10.13012/J8PN93H8

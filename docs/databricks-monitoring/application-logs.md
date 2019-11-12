---
title: Send Azure Databricks application logs to Azure Monitor
description: How to send custom logs and metrics from Azure Databricks to Azure Monitor
author: petertaylor9999
ms.date: 03/26/2019
ms.service: architecture-center
ms.subservice: reference-architecture
---

# Send Azure Databricks application logs to Azure Monitor

This article shows how to send application logs and metrics from Azure Databricks to a [Log Analytics workspace](/azure/azure-monitor/platform/manage-access). It uses the [Azure Databricks Monitoring Library](https://github.com/mspnp/spark-monitoring), which is available on GitHub.

## Prerequisites

Configure your Azure Databricks cluster to use the monitoring library, as described in the [GitHub readme][config-cluster].

> [!NOTE]
> The monitoring library streams Apache Spark level events and Spark Structured Streaming metrics from your jobs to Azure Monitor. You don't need to make any changes to your application code for these events and metrics.

## Send application metrics using Dropwizard

Spark uses a configurable metrics system based on the Dropwizard Metrics Library. For more information, see [Metrics](https://spark.apache.org/docs/latest/monitoring.html#metrics) in the Spark documentation.

To send application metrics from Azure Databricks application code to Azure Monitor, follow these steps:

1. Build the **spark-listeners-loganalytics-1.0-SNAPSHOT.jar** JAR file as described in the [GitHub readme][config-cluster].

1. Create Dropwizard [gauges or counters](https://metrics.dropwizard.io/4.0.0/manual/core.html) in your application code. You can use the `UserMetricsSystem` class defined in the monitoring library. The following example creates a counter named `counter1`.

    ```Scala
    import org.apache.spark.metrics.UserMetricsSystems
    import org.apache.spark.sql.SparkSession

    object StreamingQueryListenerSampleJob  {

      private final val METRICS_NAMESPACE = "samplejob"
      private final val COUNTER_NAME = "counter1"

      def main(args: Array[String]): Unit = {

        val spark = SparkSession
          .builder
          .getOrCreate

        val driverMetricsSystem = UserMetricsSystems
            .getMetricSystem(METRICS_NAMESPACE, builder => {
              builder.registerCounter(COUNTER_NAME)
            })

        driverMetricsSystem.counter(COUNTER_NAME).inc(5)
      }
    }
    ```

    The monitoring library includes a [sample application][sample-app] that demonstrates how to use the `UserMetricsSystem` class.

## Send application logs using Log4j

To send your Azure Databricks application logs to Azure Log Analytics using the [Log4j appender](https://logging.apache.org/log4j/2.x/manual/appenders.html) in the library, follow these steps:

1. Build the **spark-listeners-loganalytics-1.0-SNAPSHOT.jar** JAR file as described in the [GitHub readme][config-cluster].

1. Create a **log4j.properties** [configuration file](https://logging.apache.org/log4j/2.x/manual/configuration.html) for your application. Include the following configuration properties. Substitute your application package name and log level where indicated:

    ```YAML
    log4j.appender.A1=com.microsoft.pnp.logging.loganalytics.LogAnalyticsAppender
    log4j.appender.A1.layout=com.microsoft.pnp.logging.JSONLayout
    log4j.appender.A1.layout.LocationInfo=false
    log4j.additivity.<your application package name>=false
    log4j.logger.<your application package name>=<log level>, A1
    ```

    You can find a sample configuration file [here][log4j.properties].

1. In your application code, include the **spark-listeners-loganalytics** project, and import `com.microsoft.pnp.logging.Log4jconfiguration` to your application code.

    ```Scala
    import com.microsoft.pnp.logging.Log4jConfiguration
    ```

1. Configure Log4j using the **log4j.properties** file you created in step 3:

    ```Scala
    getClass.getResourceAsStream("<path to file in your JAR file>/log4j.properties")) {
          stream => {
            Log4jConfiguration.configure(stream)
          }
    }
    ```

1. Add Apache Spark log messages at the appropriate level in your code as required. For example, use the `logDebug` method to send a debug log message. For more information, see [Logging][spark-logging] in the Spark documentation.

    ```Scala
    logTrace("Trace message")
    logDebug("Debug message")
    logInfo("Info message")
    logWarning("Warning message")
    logError("Error message")
    ```

## Run the sample application

The monitoring library includes a [sample application][sample-app] that demonstrates how to send both application metrics and application logs to Azure Monitor. To run the sample:

1. Build the **spark-jobs** project in the monitoring library, as described in the [GitHub readme][config-cluster].

1. Navigate to your Databricks workspace and create a new job, as described [here](https://docs.azuredatabricks.net/jobs.html#create-a-job).

1. In the job detail page, select **Set JAR**.

1. Upload the JAR file from `/src/spark-jobs/target/spark-jobs-1.0-SNAPSHOT.jar`.

1. For **Main class**, enter `com.microsoft.pnp.samplejob.StreamingQueryListenerSampleJob`.

1. Select a cluster that is already configured to use the monitoring library. See [Configure Azure Databricks to send metrics to Azure Monitor][config-cluster].

When the job runs, you can view the application logs and metrics in your Log Analytics workspace.

Application logs appear under SparkLoggingEvent_CL:

```Kusto
SparkLoggingEvent_CL | where logger_name_s contains "com.microsoft.pnp"
```

Application metrics appear under SparkMetric_CL:

```Kusto
SparkMetric_CL | where name_s contains "rowcounter" | limit 50
```

> [!IMPORTANT]
> After you verify the metrics appear, stop the sample application job.

## Next steps

Deploy the performance monitoring dashboard that accompanies this code library to troubleshoot performance issues in your production Azure Databricks workloads.

> [!div class="nextstepaction"]
> [Use dashboards to visualize Azure Databricks metrics](./dashboards.md)

<!-- links -->

[config-cluster]: https://github.com/mspnp/spark-monitoring/blob/master/README.md
[log4j.properties]: https://github.com/mspnp/spark-monitoring/blob/master/src/spark-jobs/src/main/resources/com/microsoft/pnp/samplejob/log4j.properties
[sample-app]: https://github.com/mspnp/spark-monitoring/tree/master/src/spark-jobs
[spark-logging]: https://spark.apache.org/docs/2.3.0/api/java/org/apache/spark/internal/Logging.html
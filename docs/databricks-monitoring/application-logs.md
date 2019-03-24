# Send Azure Databricks application logs to Azure Monitor

This article shows how to send application logs and metrics from Azure Databricks to a [Log Analytics workspace](/azure/azure-monitor/platform/manage-access). It uses the [Azure Databricks Monitoring Library](https://github.com/mspnp/spark-monitoring), which is available on GitHub.

## Prerequisites

Configure your Azure Databricks cluster to use the monitoring library, as described in [Configure Azure Databricks to send metrics to Azure Monitor](./configure-cluster.md)

## Azure Databricks application metrics using Dropwizard

To send application [metrics](https://spark.apache.org/docs/latest/monitoring.html#metrics) from your Azure Databricks application code to your Azure Log Analytics workspace using Dropwizard, follow these steps:

1. Follow the instructions above to deploy the **spark-listeners-loganalytics-1.0-SNAPSHOT.jar** file that is built from the **spark-listeners-loganalytics** project.
2. Create any [Dropwizard gauges or counters](https://metrics.dropwizard.io/4.0.0/manual/core.html) in your application code.

The code library includes a sample application that demonstrates how to implement custom DropWizard metrics. The **StreamingQueryListenerSampleJob** class creates an instance of the **UserMetricsSystem** class. A discussion of these classes is beyond the scope of this document, however, these can be used as the basis for your own custom metrics system.  

## Azure Databrick log4j Appender

To send your Azure Databricks application logs to Azure Log Analytics using the [log4j appender](https://logging.apache.org/log4j/2.x/manual/appenders.html) in the library, follow these steps:

1. Follow the instructions above to deploy the **spark-listeners-loganalytics-1.0-SNAPSHOT.jar** file that is built from the **spark-listeners-loganalytics** project.
2. In your application code, include the **spark-listeners-loganalytics** project, and `import com.microsoft.pnp.logging.Log4jconfiguration` to your application code.
3. Create a **log4j.properties** file for your application. In addition to any properties that you specify, you must include the following and substitute your application package name and log level where indicated:

    ```YAML
    log4j.appender.A1=com.microsoft.pnp.logging.loganalytics.LogAnalyticsAppender
    log4j.appender.A1.layout=com.microsoft.pnp.logging.JSONLayout
    log4j.appender.A1.layout.LocationInfo=false
    log4j.additivity.<your application package name>=false
    log4j.logger.<your application package name>=<log level>, A1
    ```

4. Configure log4j using with the **log4j.properties** file you created in step 3:

```Scala
getClass.getResourceAsStream("<path to file in your JAR file>/log4j.properties")) {
      stream => {
        Log4jConfiguration.configure(stream)
      }
}
```

5. Add [Apache Spark log messages at the appropriate level](https://spark.apache.org/docs/2.3.0/api/java/org/apache/spark/internal/Logging.html) in your code as required. For example, if the **log4j.logger** log level is set to **DEBUG**, use the `logDebug("message")` method to send `message` to your Azure Log Analytics workspace.

## Next steps

Deploy the performance monitoring dashboard that accompanies this code library to troubleshoot performance issues in your production Azure Databricks workloads.

> [!div class="nextstepaction"]
> [Use dashboards to visualize Azure Databricks metrics](./dashboards.md)

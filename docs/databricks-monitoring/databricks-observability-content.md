Your development team can use observability patterns and metrics to find bottlenecks and improve the performance of a big data system. Your team has to do load testing of a high-volume stream of metrics on a high-scale application.

This scenario offers guidance for performance tuning. Since the scenario presents a performance challenge for logging per customer, it uses Azure Databricks, which can monitor these items robustly:

- Custom application metrics
- Streaming query events
- Application log messages

Azure Databricks can send this monitoring data to different logging services, such as Azure Log Analytics.

This scenario outlines the ingestion of a large set of data that has been grouped by customer and stored in a GZIP archive file. Detailed logs are unavailable from Azure Databricks outside of the real-time Apache Spark™ user interface, so your team needs a way to store all the data for each customer, and then benchmark and compare. With a large data scenario, it’s important to find an optimal combination executor pool and virtual machine (VM) size for the fastest processing time. For this business scenario, the overall application relies on the speed of ingestion and querying requirements, so that system throughput doesn't degrade unexpectedly with increasing work volume. The scenario must guarantee that the system meets service-level agreements (SLAs) that are established with your customers.

## Potential use cases

Scenarios that can benefit from this solution include:

- System health monitoring.
- Performance maintenance.
- Monitoring day-to-day system usage.
- Spotting trends that might cause future problems if unaddressed.

## Architecture

:::image type="content" source="_images/databricks-observability-architecture.png" alt-text="Diagram of performance tuning using observability patterns with Azure Databricks, Azure Monitor, Azure Log Analytics, and Azure Data Lake Storage." border="false":::

The solution involves the following steps:

1. The server sends a large GZIP file that's grouped by customer to the **Source** folder in Azure Data Lake Storage (ADLS).

2. ADLS then sends a successfully extracted customer file to Azure Event Grid, which turns the customer file data into several messages.

3. Azure Event Grid sends the messages to the Azure Queue Storage service, which stores them in a queue.

4. Azure Queue Storage sends the queue to the Azure Databricks data analytics platform for processing.

5. Azure Databricks unpacks and processes queue data into a processed file that it sends back to ADLS:

    1. If the processed file is valid, it goes in the **Landing** folder.

    1. Otherwise, the file goes in the **Bad** folder tree. Initially, the file goes in the **Retry** subfolder, and ADLS attempts customer file processing again (step 2). If a pair of retry attempts still leads to Azure Databricks returning processed files that aren't valid, the processed file goes in the **Failure** subfolder.

6. As Azure Databricks unpacks and processes data in the previous step, it also sends application logs and metrics to Azure Monitor for storage.

7. An Azure Log Analytics workspace applies Kusto queries on the application logs and metrics from Azure Monitor for troubleshooting and deep diagnostics.

8. An Azure portal dashboard displays visualizations of the logs and metrics using the query results.

### Components

- [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a set of capabilities dedicated to big data analytics.
- [Azure Event Grid](/azure/event-grid/overview) allows a developer to easily build applications with event-based architectures.
- [Azure Queue Storage](/azure/storage/queues/storage-queues-introduction) is a service for storing large numbers of messages. It allows access to messages from anywhere in the world through authenticated calls using HTTP or HTTPS. You can use queues to create a backlog of work to process asynchronously.
- [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks) is a data analytics platform optimized for Azure cloud services. One of the two environments Azure Databricks offers for developing data-intensive applications is [Azure Databricks Workspace](/azure/databricks/scenarios/what-is-azure-databricks-ws), an Apache Spark-based unified analytics engine for large-scale data processing.
- [Azure Monitor](/azure/azure-monitor/overview) collects and analyzes app telemetry, such as performance metrics and activity logs.
- [Azure Log Analytics](/azure/azure-monitor/log-query/log-analytics-overview) is a tool used to edit and run log queries with data.
- [Azure portal dashboards](/azure/azure-portal/azure-portal-dashboards) are a focused and organized view of cloud resources in the Azure portal.

## Considerations

Keep these points in mind when considering this architecture:

- Azure Databricks can automatically allocate the computing resources necessary for a large job, which avoids problems that other solutions introduce. For example, with [Databricks-optimized autoscaling on Apache Spark](https://databricks.com/blog/2018/05/02/introducing-databricks-optimized-auto-scaling.html), excessive provisioning may cause the suboptimal use of resources. Or you might not know the number of executors required for a job.

- A queue message in Azure Queue Storage can be up to 64 KB in size. A queue may contain millions of queue messages, up to the total capacity limit of a storage account.

## Deploy this scenario

To get all the logs and information of the process, set up Azure Log Analytics and the Azure Databricks monitoring library. The monitoring library streams Apache Spark level events and Spark Structured Streaming metrics from your jobs to Azure Monitor. You don't need to make any changes to your application code for these events and metrics.

The procedures to set up performance tuning for a big data system are as follows:

1. Create an Azure Databricks workspace.
1. Create an Azure Log Analytics workspace with prebuilt queries for collecting Spark metrics.
1. Build libraries for monitoring Azure Databricks.
1. Configure the Azure Databricks workspace.
1. Create and configure an Azure Databricks cluster.
1. Build and run a sample application that shows how to send app metrics and app logs from Azure Databricks to Azure Monitor.
1. View and query the application logs and metrics in Azure Log Analytics.
1. Use visualizations to assess performance tuning options.

> [!NOTE]
> The deployment steps described here apply only to Azure Databricks, Azure Monitor, Azure Log Analytics, and Azure portal dashboards. Deployment of the other components isn't covered in this article.

### Prerequisites

- An Azure account with an active subscription. [Create one for free](https://azure.microsoft.com/free/).
- An integrated development environment (IDE) with:
  - [Java Development Kit (JDK)](https://www.oracle.com/java/technologies/javase-downloads.html) version 1.8 or higher.
  - [Scala programming language](https://www.scala-lang.org/) SDK version 2.11 or higher.
  - [Apache Maven](https://maven.apache.org/) version 3.5.4 or higher.

  For this article, install the Community Edition of [IntelliJ IDEA](https://www.jetbrains.com/idea/download/). JDK and Maven support are built into IntelliJ IDEA, but you'll have to add the [Scala plug-in](https://plugins.jetbrains.com/plugin/1347-scala).
- [Python](https://www.python.org/downloads/windows/) 2 (version 2.7.9 or higher) or 3 (version 3.6 or higher).
- [Azure CLI](/cli/azure) version 2.0 or higher.
- The [Azure CLI extensions](/cli/azure/azure-cli-extensions-overview) for `databricks` and `log-analytics`.
- [Azure Databricks CLI](/azure/databricks/dev-tools/cli/).
- A local copy of the [mspnp/spark-monitoring](https://github.com/mspnp/spark-monitoring) GitHub repository.

### Create an Azure Databricks workspace

The first procedure involves creating your own Azure Databricks workspace:

1. Connect to Azure CLI by entering `az login` and following the sign-in instructions.

1. Use the [az databricks workspace create](/cli/azure/ext/databricks/databricks/workspace#ext_databricks_az_databricks_workspace_create) command below to create the new workspace for Azure Databricks. If you don't already have an Azure resource group to create the workspace in, create a new Azure resource group first with the [az group create](/cli/azure/group#az_group_create) command.

    ```azurecli
    # Make a new resource group to hold the databricks workspace. (Skip if you already have an RG.)
    az group create --location <location-ID, such as westus> --name <name-of-new-resource-group>

    az databricks workspace create --resource-group <resource-group-name> \
        --name <databricks-workspace-name> \
        --location <location-id, such as westus> \
        --sku <premium-standard-or-trial>
    ```

1. In the console output, copy and save the string from the `workspaceUrl` output line. Use this URL string to access your workspace's web portal. Also, in the `id` output line's string, copy and save the GUID immediately following the `/subscriptions/` prefix. This value is your Azure subscription ID.

### Create an Azure Log Analytics workspace

Now create an Azure Log Analytics workspace to store the logs and the prebuilt Spark metrics queries. Instead of using the [**Log Analytics workspaces** menu in the Azure portal](/azure/azure-monitor/learn/quick-create-workspace) to create a Log Analytics workspace, use an Azure Resource Manager (ARM) template that also creates the prebuilt queries.

To set up an Azure Log Analytics workspace:

1. In a scripting console, go to the root directory of the *spark-monitoring* repository on your local computer.

1. Using the [az deployment group create](/cli/azure/deployment/group#az_deployment_group_create) command below, deploy the ARM template provided by the repository (the *logAnalyticsDeploy.json* file in the *perftools/deployment/loganalytics* path). The ARM template creates a Log Analytics workspace that includes prebuilt queries for gathering Spark metrics.

    ```azurecli
    # Create a new resource group for template deployment. (Skip if you already have an RG.)
    az group create --location <location-ID, such as westus> --name <name-of-new-resource-group>

    # Deploy the ARM template. Note that the --parameters ___='___' ... option isn't required.
    # The location, serviceTier, and dataRetention parameters are all optional.
    az deployment group create --resource-group <existing-resource-group-name> \
        --template-file perftools/deployment/loganalytics/logAnalyticsDeploy.json \
        --parameters location='<location-name, such as East US>' \
             serviceTier='<Free-Standalone-PerNode-or-PerGB2018>' dataRetention='<number-of-days>'
    ```

    > [!NOTE]
    > Alternatively, you can deploy the ARM template [directly through the Azure portal](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmspnp%2fspark-monitoring%2fmaster%2fperftools%2fdeployment%2floganalytics%2flogAnalyticsDeploy.json).

    The ARM template gives the new Log Analytics workspace a name in the format *spark-monitoring-\<randomized-string>*. Find this name in the console output, and copy and save this workspace name for later use.

1. With the resource group name and the new Log Analytics workspace name, view information about the workspace using the [az monitor log-analytics workspace show](/cli/azure/monitor/log-analytics/workspace#az_monitor_log_analytics_workspace_show) command shown below. Then copy and save the GUID from the `customerId` output line for later use. This value represents the workspace ID.

    ```azurecli
    az monitor log-analytics workspace show --resource-group <resource-group-name> \
        --workspace-name <azurela-workspace-name>
    ```

1. View the key values for the Log Analytics workspace using the [az monitor log-analytics workspace get-shared-keys](/cli/azure/monitor/log-analytics/workspace#az_monitor_log_analytics_workspace_get_shared_keys) command shown below. Then copy and save the workspace's key string from the `primarySharedKey` or `secondarySharedKey` output line for later use.

    ```azurecli
    az monitor log-analytics workspace get-shared-keys --resource-group <resource-group-name> \
        --workspace-name <azurela-workspace-name>
    ```

    > [!NOTE]
    > You can also find the workspace ID, primary key, and secondary key on the [Azure portal](https://portal.azure.com). Search for and select the **Log Analytics workspaces**, and select the name of your workspace. Then in the menu pane, under **Settings**, select **Agents management** to view and copy those values.

### Build the Azure Databricks monitoring library

Next, build the Azure Databricks monitoring library, which consists of Java Archive (JAR) files for a couple of Spark listener projects.

1. In IntelliJ IDEA, open as a project the Maven project object model (POM) file *src/pom.xml* (from the root directory of your local repository). This action imports the *spark-listeners* and *spark-listeners-loganalytics* projects.

1. Activate a single Maven profile that corresponds to the versions of the Scala/Spark combination that is being used. By default, the Scala 2.12 and Spark 3.0.1 profile is active. In IntelliJ IDEA, select **View** > **Tool Windows** > **Maven**, expand **Profiles**, and then explicitly select **scala-2.12_spark-3.0.1**.

1. Execute the Maven package phase on the project you just opened. In IntelliJ IDEA, in the Maven tool window, select the **Execute Maven Goal** icon, and then select or enter **mvn package**. This action builds JAR files for the two imported projects, under the following names in the *src/target* directory:
    - *spark-listeners_\<spark-version>_\<scala-version>-\<project-version>.jar*
    - *spark-listeners-loganalytics_\<spark-version>_\<scala-version>-\<project-version>.jar*

### Configure an Azure Databricks workspace

Configure the Azure Databricks workspace by copying the monitoring library's JAR files and the init script into Databricks.

1. Open your local version of the *src/spark-listeners/scripts/spark-monitoring.sh* repository file for editing. This file is the init script to be used in your Databricks workspace.

1. In the script, find the following lines, which are stubs for seven environment variable definitions:

    ```bash
    export LOG_ANALYTICS_WORKSPACE_ID=
    export LOG_ANALYTICS_WORKSPACE_KEY=
    export AZ_SUBSCRIPTION_ID=
    export AZ_RSRC_GRP_NAME=
    export AZ_RSRC_PROV_NAMESPACE=
    export AZ_RSRC_TYPE=
    export AZ_RSRC_NAME=
    ```

1. Provide values for the environment variables as described below, and then save the script.

    | Variable | Value |
    |----------|-------|
    | `LOG_ANALYTICS_WORKSPACE_ID` | The Azure Log Analytics workspace ID that you copied earlier |
    | `LOG_ANALYTICS_WORKSPACE_KEY` | The primary or secondary shared key that you copied earlier |
    | `AZ_SUBSCRIPTION_ID` | The Azure subscription ID that you copied earlier |
    | `AZ_RSRC_GRP_NAME` | The name you gave to the Azure resource group that contains the Azure Databricks workspace |
    | `AZ_RSRC_PROV_NAMESPACE` | `Microsoft.Databricks` |
    | `AZ_RSRC_TYPE` | `workspaces` |
    | `AZ_RSRC_NAME` | The name you gave to the Azure Databricks workspace |

1. In the address bar of a web browser, type `https://`, paste the URL string you copied earlier for your Azure Databricks workspace, and then press Enter. An authentication page for your Azure Databricks workspace appears. After you sign in, the web portal for your workspace appears.

1. In the far corner of the portal, select the workspace name, and then select **User settings**.

1. Select **Generate new token**, optionally fill in the **Comment** box, and select **Generate**.

1. Copy the token string that appears (which begins with `dapi` and a 32-character hexadecimal value), and  select **Done**. Then save the token string all by itself in a new file.

1. In the Azure Databricks CLI, enter the [DBFS](/azure/databricks/dev-tools/cli/dbfs-cli) command `dbfs configure` shown below to set up the CLI for use:

    ```Azure Databricks CLI
    dbfs configure --host https://<https-url-of-databricks-workspace> \
        --token-file <path-and-name-of-file-with-databricks-token>
    ```

1. Enter the following CLI commands to create a Databricks directory named `dbfs:/databricks/spark-monitoring`. Then copy the Spark monitoring script and the JAR files for the Azure Databricks monitoring library into that Databricks directory.

    ```Azure Databricks CLI
    dbfs mkdirs dbfs:/databricks/spark-monitoring
    dbfs cp src/spark-listeners/scripts/spark-monitoring.sh dbfs:/databricks/spark-monitoring/spark-monitoring.sh
    dbfs cp --overwrite --recursive src/target/ dbfs:/databricks/spark-monitoring/
    ```

### Create and configure an Azure Databricks cluster

Return to the web portal for your Azure Databricks workspace to create and configure a new Databricks cluster.

1. In your Azure Databricks workspace portal, select **Clusters** > **Create Cluster**.
1. In **Cluster Name**, type a name for the new cluster.
1. In **Databricks Runtime Version**, choose a version between 7.3 and 7.6, or any Databricks runtime version that corresponds to the Maven profile combination of Scala 2.12 and Spark 3.0.1.
1. Select **Advanced Options** > **Init Scripts**.
1. In **Destination**, select **DBFS**. In **Init Script Path**, enter *dbfs:/databricks/spark-monitoring/spark-monitoring.sh*. Then select **Add**.
1. Select **Create Cluster** to create the new cluster.

### Build and run the sample application

Next, build a sample app for sending application logs and application metrics from Azure Databricks to Azure Monitor. Then set up a Databricks job for running the sample app.

1. In IntelliJ IDEA, open the Maven project *sample/spark-sample-job/pom.xml* in your local repository.
1. Select **Execute Maven Goal** > **mvn package** to build the Maven project.
1. In the web portal for your Azure Databricks workspace, go to the side panel and select **Jobs** > **Create Job**.
1. Enter a name for the sample job, and then select **Set JAR** to display the **Upload JAR to Run** dialog box.
1. Select **Drop JAR here to upload**, browse to the *sample/spark-sample-job/target* directory, and then open the JAR file (*spark-monitoring-sample-1.0.0.jar*).
1. In the **Main class** box, enter *com.microsoft.pnp.samplejob.StreamingQueryListenerSampleJob*, and then select **OK**.

To run the Databricks job, select **Jobs**, and then in the row for your sample job, go to the **Action** column and select the **Run Now** icon. Let the sample job run for a few minutes. When the job runs, you can view the application logs and metrics in your Log Analytics workspace. After you verify that the metrics appear, stop the sample application job.

### View and query the logs and metrics in Azure Log Analytics

While the sample job is running in Azure Databricks, you can use Azure Log Analytics to view the event types (logs and metrics) produced by that job. You can also view and run the prebuilt Spark metrics queries or your own custom queries.

#### View the event types

To see the list of event types:

1. In a separate browser tab, go to the [Azure portal](https://portal.azure.com) to access your Azure Log Analytics workspace. Search for and select **Log Analytics workspaces**.

1. Select the name of your Log Analytics workspace.

1. In the Log Analytics workspace menu, from the **General** section, select **Logs**.

1. If the **Queries** screen appears, close it.

1. In the **Tables** tab, expand **Custom Logs**. Azure Log Analytics stores these logs, which the Azure Databricks sample job produces, in the following event type tables:

    | Event type | Table name |
    |------------|------------|
    | Spark listener events | `SparkListenerEvent_CL` |
    | Spark logging events | `SparkLoggingEvent_CL` |
    | Spark metrics | `SparkMetric_CL` |

    You can expand a table name to view the available column names in the table.

#### Access prebuilt and custom queries

To see the list of prebuilt [Kusto Query Language (KQL)](/azure/data-explorer/kql-quick-reference) queries:

1. Select **Query explorer**.

1. In the **Query explorer** pane, expand **Saved Queries** > **Spark Metrics**. The list of prebuilt KQL queries appears.

1. Select a query name to view its KQL query definition.

The prebuilt query names for retrieving Spark metrics are listed below.

:::row:::
    :::column:::
        - % CPU Time Per Executor
        - % Deserialize Time Per Executor
        - % JVM Time Per Executor
        - % Serialize Time Per Executor
        - Disk Bytes Spilled
        - Error Traces (Bad Record Or Bad Files)
        - File System Bytes Read Per Executor
        - File System Bytes Write Per Executor
        - Job Errors Per Job
        - Job Latency Per Job (Batch Duration)
        - Job Throughput
        - Running Executors
        - Shuffle Bytes Read
        - Shuffle Bytes Read Per Executor
        - Shuffle Bytes Read To Disk Per Executor
        - Shuffle Client Direct Memory
        - Shuffle Client Memory Per Executor
        - Shuffle Disk Bytes Spilled Per Executor
        - Shuffle Heap Memory Per Executor
        - Shuffle Memory Bytes Spilled Per Executor
    :::column-end:::
    :::column:::
        - Stage Latency Per Stage (Stage Duration)
        - Stage Throughput Per Stage
        - Streaming Errors Per Stream
        - Streaming Latency Per Stream
        - Streaming Throughput Input Rows/Sec
        - Streaming Throughput Processed Rows/Sec
        - Sum Task Execution Per Host
        - Task Deserialization Time
        - Task Errors Per Stage
        - Task Executor Compute Time (Data Skew Time)
        - Task Input Bytes Read
        - Task Latency Per Stage (Tasks Duration)
        - Task Result Serialization Time
        - Task Scheduler Delay Latency
        - Task Shuffle Bytes Read
        - Task Shuffle Bytes Written
        - Task Shuffle Read Time
        - Task Shuffle Write Time
        - Task Throughput (Sum Of Tasks Per Stage)
        - Tasks Per Executor (Sum Of Tasks Per Executor)
        - Tasks Per Stage
    :::column-end:::
:::row-end:::

When you select a query, the definition appears in the top middle pane. Select **Run** to execute the query. The query results appear in the bottom middle pane, in the **Results** tab. You can see a visualization of the query results if you select the **Chart** tab.

#### Add the query results or visualizations to the dashboard

To add a list of query results or a chart visualization to an Azure portal dashboard:

1. Select **Pin to dashboard**.
1. Choose to use a **Private** or **Shared** dashboard.
1. If you chose a **Shared** dashboard, choose which Azure subscription(s) you want to pin to in **Subscriptions**.
1. If you want to pin to a predefined dashboard, select the **Existing** tab. Otherwise, select the **Create new** tab.
1. If you selected **Existing**, also choose the **Dashboard** name. Otherwise, enter the **Dashboard name** in **Create new**.
1. Select **Pin** (for **Existing**) or **Create and pin** (for **Create new**) to complete the pinning process.

Repeat these steps for each set of results or visualizations that you want to add to your dashboard. To view the dashboard that you pinned the results or visualizations to, go to the Azure portal menu and select **Dashboard**.

> [!NOTE]
> You can alternatively use the open-source Grafana project to display the visualizations. The GitHub repository provides an ARM template that you can use or customize in the [perftools/dashboards/grafana](https://github.com/mspnp/spark-monitoring/blob/master/perftools/dashboards/grafana/SparkMetricsDashboardTemplate.json) directory. For more information, see [Deploy Grafana in a virtual machine](dashboards.md#deploy-grafana-in-a-virtual-machine), but deploy this template instead of the one used in that article.

#### Write query examples

You can also write your own queries in Kusto. Just select the top middle pane, which is editable, and customize the query to meet your needs.

The following two queries pull data from the Spark logging events:

```kusto
SparkLoggingEvent_CL | where logger_name_s contains "com.microsoft.pnp"
```

```kusto
SparkLoggingEvent_CL
| where TimeGenerated > ago(7d) 
| project TimeGenerated, clusterName_s, logger_name_s
| summarize Count=count() by clusterName_s, logger_name_s, bin(TimeGenerated, 1h)
```

And these two examples are queries on the Spark metrics log:

```kusto
SparkMetric_CL
| where name_s contains "executor.cpuTime"
| extend sname = split(name_s, ".")
| extend executor=strcat(sname[0], ".", sname[1])
| project TimeGenerated, cpuTime=count_d / 100000
```

```kusto
SparkMetric_CL
| where name_s contains "driver.jvm.total."
| where executorId_s == "driver"
| extend memUsed_GB = value_d / 1000000000
| project TimeGenerated, name_s, memUsed_GB
| summarize max(memUsed_GB) by tostring(name_s), bin(TimeGenerated, 1m)
```

#### Query terminology

The following table explains some of the terms that are used when you construct a query of application logs and metrics.

| Term | ID | Remarks |
|-----|----|---------|
| Cluster_init | Application&nbsp;ID |  |
| Queue | Run ID | One run ID equals multiple batches. |
| Batch | Batch ID | One batch equals two jobs. |
| Job | Job ID | One job equals two stages. |
| Stage | Stage ID | One stage has 100-200 task IDs depending on the task (read, shuffle, or write). |
| Tasks | Task ID | One task is assigned to one executor. One task is assigned to do a `partitionBy` for one partition. For about 200 customers, there should be 200 tasks. |

The following sections contain the typical metrics used in this scenario for monitoring system throughput, Spark job running status, and system resources usage.

##### System throughput

| Name | Measurement | Units |
|------|-------------|-------|
| Stream throughput | Average input rate over average processed rate per minute | Rows per minute |
| Job duration | Average ended Spark job duration per minute | Duration(s) per minute |
| Job count | Average number of ended Spark jobs per minute | Number of jobs per minute |
| Stage duration | Average completed stages duration per minute | Duration(s) per minute |
| Stage count | Average number of completed stages per minute | Number of stages per minute |
| Task duration | Average finished tasks duration per minute | Duration(s) per minute |
| Task count | Average number of finished tasks per minute | Number of tasks per minute |

##### Spark job running status

| Name | Measurement | Units |
|------|-------------|-------|
| Scheduler pool count | Number of distinct count of scheduler pools per minute (number of queues operating) | Number of scheduler pools |
| Number of running executors | Number of running executors per minute | Number of running executors |
| Error trace | All error logs with `Error` level and the corresponding tasks/stage ID (shown in `thread_name_s`) |  |

##### System resources usage

| Name | Measurement | Units |
|------|-------------|-------|
| Average CPU usage per executor/overall | Percent of CPU used per executor per minute | % per minute |
| Average used direct memory (MB) per host | Average used direct memory per executors per minute | MB per minute |
| Spilled memory per host | Average spilled memory per executor | MB per minute |
| Monitor data skew impact on duration | Measure range and difference of 70th-90th percentile and 90th-100th percentile in tasks duration | Net difference among 100%, 90%, and 70%; percentage difference among 100%, 90%, and 70% |

Decide how to relate the customer input, which was combined into a GZIP archive file, to a particular Azure Databricks output file, since Azure Databricks handles the whole batch operation as a unit. Here, you apply granularity to the tracing. You also use custom metrics to trace one output file to the original input file.

For more detailed definitions of each metric, see [Visualizations in the dashboards](dashboards.md#visualizations-in-the-dashboards) on this website, or see the [Metrics](http://spark.apache.org/docs/latest/monitoring.html#metrics) section in the Apache Spark documentation.

## Assess performance tuning options

### Baseline definition

You and your development team should establish a baseline, so that you can compare future states of the application.

Measure the performance of your application quantitatively. In this scenario, the key metric is job latency, which is typical of most data preprocessing and ingestion. Attempt to accelerate the data processing time and focus on measuring latency, as in the chart below:

:::image type="content" source="_images/databricks-observability-job-latency.png" alt-text="Job latency chart for performance tuning. The chart measures job latency per minute (0-50 seconds) while the application is running.":::

Measure the execution latency for a job: a coarse view on the overall job performance, and the job execution duration from start to completion (microbatch time). In the chart above, at the 19:30 mark, it takes about 40 seconds in duration to process the job.

If you look further into those 40 seconds, you see the data below for stages:

:::image type="content" source="_images/databricks-observability-stage-latency.png" alt-text="Stage latency chart for performance tuning. The chart measures stage latency per minute (0-30 seconds) while the application is running.":::

At the 19:30 mark, there are two stages: an orange stage of 10 seconds, and a green stage at 30 seconds. Monitor whether a stage spikes, because a spike indicates a delay in a stage.

Investigate when a certain stage is running slowly. In the partitioning scenario, there are typically at least two stages: one stage to read a file, and the other stage to shuffle, partition, and write the file.  If you have high stage latency mostly in the writing stage, you might have a bottleneck problem during partitioning.

:::image type="content" source="_images/databricks-observability-task-latency-per-stage.png" alt-text="Task latency per stage chart for performance tuning, at the 90th percentile. The chart measures latency (0.032-16 seconds) while the app is running.":::

Observe the tasks as the stages in a job execute sequentially, with earlier stages blocking later stages. Within a stage, if one task executes a shuffle partition slower than other tasks, all tasks in the cluster must wait for the slower task to finish for the stage to complete. Tasks are then a way to monitor data skew and possible bottlenecks. In the chart above, you can see that all of the tasks are evenly distributed.

Now monitor the processing time. Because you have a streaming scenario, look at the streaming throughput.

:::image type="content" source="_images/databricks-observability-streaming-throughput-latency.png" alt-text="Streaming throughput/latency chart for performance tuning. The chart measures throughput (105-135 K) and latency per batch while the app is running.":::

In the streaming throughput/batch latency chart above, the orange line represents input rate (input rows per second). The blue line represents the processing rate (processed rows per second). At some points, the processing rate doesn't catch the input rate. The potential issue is that input files are piling up in the queue.

Because the processing rate doesn't match the input rate in the graph, look to improve the process rate to cover the input rate fully. One possible reason might be the imbalance of customer data in each partition key that leads to a bottleneck. For a next step and potential solution, take advantage of the scalability of Azure Databricks.

### Partitioning investigation

First, further identify the correct number of scaling executors that you need with Azure Databricks. Apply the rule of thumb of assigning each partition with a dedicated CPU in running executors. For instance, if you have 200 partition keys, the number of CPUs multiplied by the number of executors should equal 200. (For example, eight CPUs combined with 25 executors would be a good match.) With 200 partition keys, each executor can work only on one task, which reduces the chance of a bottleneck.

Because some slow partitions are in this scenario, investigate the high variance in tasks duration. Check for any spikes in task duration. One task handles one partition. If a task requires more time, the partition may be too large and cause a bottleneck.

:::image type="content" source="_images/databricks-observability-check-skew.png" alt-text="List of results of a check skew query for performance tuning. The query is used for a partitioning investigation.":::

### Error tracing

Add a dashboard for error tracing so that you can spot customer-specific data failures. In data preprocessing, there are times when files are corrupted, and records within a file don't match the data schema. The following dashboard catches many bad files and bad records.

:::image type="content" source="_images/databricks-observability-error-trace-dashboard.png" alt-text="Dashboard of error tracing information for performance tuning. Components include streaming errors, cluster (job/task) errors, and exception traces.":::

This dashboard displays the error count, error message, and task ID for debugging. In the message, you can easily trace the error back to the error file. There are several files in error while reading. You review the top timeline and investigate at the specific points in our graph (16:20 and 16:40).

### Other bottlenecks

For more examples and guidance, see [Troubleshoot performance bottlenecks in Azure Databricks](performance-troubleshooting.md).

### Performance tuning assessment summary

For this scenario, these metrics identified the following observations:

- In the stage latency chart, writing stages take most of the processing time.
- In the task latency chart, task latency is stable.
- In the streaming throughput chart, the output rate is lower than the input rate at some points.
- In the task’s duration table, there's task variance because of imbalance of customer data.
- To get optimized performance in the partitioning stage, the number of scaling executors should match the number of partitions.
- There are tracing errors, such as bad files and bad records.

To diagnose these issues, you used the following metrics:

- Job latency
- Stage latency
- Task latency
- Streaming throughput
- Task duration (max, mean, min) per stage
- Error trace (count, message, task ID)

## Pricing

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing this solution.

## Next steps

Read about [performance antipatterns](../antipatterns/index.md).

## Related resources

- [Send Azure Databricks application logs to Azure Monitor](application-logs.md)
- [Use dashboards to visualize Azure Databricks metrics](dashboards.md)
- [Best practices for monitoring cloud applications](../best-practices/monitoring.md)
- [Monitoring Azure Databricks in an Azure Log Analytics workspace](https://github.com/mspnp/spark-monitoring/blob/master/README.md)
- [Deployment of Azure Log Analytics with Spark metrics](https://github.com/mspnp/spark-monitoring/tree/master/perftools/deployment#deployment-of-log-analytics-with-spark-metrics)
- [Observability patterns](/dotnet/architecture/cloud-native/observability-patterns)
- [Retry pattern](../patterns/retry.md)

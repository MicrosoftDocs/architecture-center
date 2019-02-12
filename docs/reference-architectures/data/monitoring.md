---
title: Monitoring Azure Databricks in Azure Log Analytics
titleSuffix: A solution for monitoring Azure Databricks in Azure Log Analytics
description: A scala library to deploy to a Databricks cluster to enable monitoring of metrics and logging data in Azure Log Analytics
author: petertaylor9999
ms.date: 01/28/2019
ms.topic:
ms.service:
ms.subservice:
---

# Monitoring Azure Databricks in Azure Log Analytics

Azure Databricks is a fast, powerful, and collaborative Apache Spark–based analytics service that makes it easy to rapidly develop and deploy big data analytics and artificial intelligence (AI) solutions. Most users take advantage of the simplicity of notebooks in their Azure Databricks solutions. For users that require more robust computing options, Azure Databricks supports the distributed execution of custom application code written in Scala.

Monitoring in custom application code is a critical part of any production-level solution, and Azure Databricks offers robust functionality for monitoring metrics, streaming query event information, and application logging data. Azure Databricks supports delivery of metrics and logging data to many different logging services, and the code library that accompanies this document extends the core monitoring functionality of Azure Databricks to send streaming query event information to Azure Log Analytics.

## Monitoring Apache Spark Structured Streaming queries in Azure Databricks

Azure Databricks is a service based on Apache Spark, which includes a set of structured APIs for batch processing data using Datasets, DataFrames, and SQL. With Apache Spark 2.0, support was added for [Structured Streaming](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html), a data stream processing API built upon Spark's batch processing APIs.

The Structured Streaming API includes functionality to monitor active streams as data is processed by sending event information to an external metrics system. An external metrics system is registered with Spark Structured Streaming by attaching an implementation of a **StreamingQueryListener** object to the current Spark streaming session.

This code library that accompanites this document includes a **StreamingQueryListener** implementation named **LogAnalyticsStreamingQueryListener**. Attaching an instance of **LogAnalyticsStreamingQueryListener** to the Spark session in your application sends Structured Streaming event information to an Azure Log Analytics workspace.

## Use the Azure Databricks monitoring library

Integration of the code library accompanying this document into your application has the following prerequisites:

* Clone, fork, or download the [GitHub repository](https://github.com/mspnp/spark-monitoring).

* An active Azure Databricks workspace. For instructions on how to deploy an Azure Databricks workspace, see [get started with Azure Databricks.](https://docs.microsoft.com/azure/azure-databricks/quickstart-create-databricks-workspace-portal).
* Install the [Azure Databricks CLI](https://docs.databricks.com/user-guide/dev-tools/databricks-cli.html#install-the-cli).
  * An Azure Databricks personal access token is required to use the CLI. For instructions, see [token management](https://docs.azuredatabricks.net/api/latest/authentication.html#token-management).
  * You can also use the Azure Databricks CLI from the Azure Cloud Shell. 

* A Java IDE, with the following resources:
  * Java Devlopment Kit (JDK) version 1.8
  * Scala language SDK 2.11
  * Maven build system 3.5.4

To use the solution accelerator, first import the Maven project configuration file, _pom.xml_, located in the **spark-monitoring** folder into your project. This will import four projects:

* spark-listeners
* spark-metrics
* spark-monitoring
* spark-jobs

For this solution accelerator, you'll work with the **spark-listeners** project.

### Develop your Apache Spark job application for Azure Databricks

There are three requirements for using the **LogAnalyticsStreamingQueryListener** object in your Apache Spark job application code:

1. Include all the required dependencies in your project using the following Maven coordinates:  

  |Group ID|Artifact ID|Version|Scope|
  |--------|-----------|-------|
  |org.scala-lang|scala-library| | |
  |org.apache.spark|spark-core_2.11|2.3.1| provided |
  |org.apache.spark|spark-sql_2.11| | provided |
  |org.apache.spark|spark-streaming_2.11| | provided |
  |com.microsoft.pnp|spark-listeners|1.0-SNAPSHOT| provided |

2. In your code, import **org.apache.spark.listeners.LogAnalyticsStreamingQueryListener**.
3. In your code, create a new instance of **LogAnalyticsStreamingQueryListener**, passing in the current Spark context as a parameter, and attach it to the current Spark Session **streams** property using the **addListener** method.

### Streaming query listener sample job application

To help you better understand how to use the solution accelerator, a sample job application is included in the **spark-jobs** project. You can build it as a job application and then follow the instructions below to run it in your Apache Spark cluster. The sample job application uses Spark Structured Streaming to read a data file that is present by default in each Azure Databricks cluster and then performs a simple query.

> [!NOTE]
> The **spark-jobs** sample application includes a Maven project configuration file, _pom.xml_, in the root folder for the project. Note that this file includes a **dependencies** section with all the dependencies necessary to include the **LogAnalyticsStreamingQueryListener**. You can use this file as a template for your own job application.

Let's first take a look at how the sample application references the library for the **LogAnalyticsStreamingQueryListener**:

```scala
import org.apache.spark.listeners.LogAnalyticsStreamingQueryListener
```

Note that this library is copied to each node in your Azure Databricks cluster during initialization. Apache Spark manages the Java class context for both the library and your job application code, so it does not need to be included in the JAR file for your job application.

Now let's take a look at how the sample application attaches an instance of a **LogAnalyticsStreamingQueryListener** to the current [Spark session](https://spark.apache.org/docs/2.3.0/api/java/org/apache/spark/sql/SparkSession.html)

```scala
val spark = SparkSession
    .builder
    .getOrCreate

[...]

spark.streams.addListener(new LogAnalyticsStreamingQueryListener(spark.sparkContext.getConf))
```

First, the current Spark session is assigned to the variable **spark**. Next, the **LogAnalyticsStreamingQueryListener** is attached to the **streams** property of the current Spark session. Note that the **LogAnalyticsStreamingQueryListener** constructor takes a single parameter, which is the configuration information for the Spark cluster.

Attaching the **LogAnalyticsStreamingQueryListener** enables asynchronous monitoring of all structured streaming queries associated with the current Apache Spark session. For more information, see [reporting metrics programmatically using asynchronous APIs](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html#reporting-metrics-programmatically-using-asynchronous-apis) in the [Apache Spark structured streaming programming guide](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html).

The remaining code in the sample configures and executes the structured streaming query using the sample data file from Azure Databricks. This is not the focus of this solution accelerator, so we won't dive in to this code. This code does follow standard practices for structured streaming queries so you can review it for your own information.

Let's move on to creating and configuring an Azure Databricks cluster to run your job application.

### Create and configure your Azure Databricks cluster

To create and configure your Azure Databricks cluster, follow these steps:

1. Build the JAR file defined in the Maven build file in the **spark-listeners** directory of the Github repository. Building this project creates a JAR filed named **spark-listeners-1.0-SNAPSHOT.jar**.
2. Use the Azure Databricks CLI to create a directory named **dbfs:/databricks/init/jar**:  

  ```bash
  dbfs mkdirs dbfs:/databricks/init/startupscript
  ```
3. Use the Azure Databricks CLI to copy the **spark-listeners-1.0-SNAPSHOT.jar** file to a staging folder in the Azure Databricks file system. For example:
  ```bash
  dbfs cp spark-listeners-1.0-SNAPSHOT.jar dbfs:/databricks/init/jar
  ```
4. Copy the **listeners.sh** bash script located in the **/scripts** directory of the Github repository to the **dbfs:/databricks/init/startupscript** directory in the Azure Databricks file system:
  ```bash
  dbfs cp listeners.sh dbfs:/databricks/init/startupscript
  ```
5. Navigate to your Azure Databricks workspace in the Azure Portal. On the home page, click "new cluster". Choose a name for your cluster and enter it in "cluster name" text box. In the "Databricks Runtime Version" dropdown, select **4.3 (includes Apache Spark 2.3.1, Scala 2.11)**. 
6. Under "Advanced Options", click on the "Spark" tab. Enter the following name-value pairs in the "Spark Config" text box:

  | Name | Value |
  |------|-------|
  |spark.databricks.delta.preview.enabled| true|
  |spark.extraListeners |com.databricks.backend.daemon.driver.DBCEventLoggingListener,org.apache.spark.listeners.LogAnalyticsListener|
  |spark.logAnalytics.workspaceId |[your Azure Log Analytics workspace ID](/azure/azure-monitor/platform/agent-windows#obtain-workspace-id-and-key)|
  |spark.logAnalytics.secret| [your Azure Log Analytics shared access signature](/azure/azure-monitor/platform/agent-windows#obtain-workspace-id-and-key)|

7. While still under the "Advanced Options" section, click on the "Init Scripts" tab. Go to the last line under the "Init Scripts section" Under the "destination" dropdown, select "DBFS". Enter "dbfs:/databricks/init/startupscript/listeners.sh" in the text box. Click the "add" button.
8. Click the "create cluster" button to create the cluster. Next, click on the "start" button to start the cluster.
9. Click on the "Jobs" button in the left hand navigation pane. Click the "create job" button. Choose a name for your job and enter it in the "name" text box. Click "set JAR" beside the "task" line, then drag and drop your job application's JAR file to the box. Enter the name of your application's **main** class in the "Main class" text box, and any starup arguments in the "arguments" text box. Click "OK".
10. On the "Cluster" line, select "edit" to go to the "configure cluster" dialog. Under the "cluster type" select "existing cluster" and select the cluster you created in step 6. Click "confirm".
11. On the job dialog, click on the job created in step 8 and select "run now".

Ensure that your job application is code is running by checking the job's status in the Azure Databricks job dialog. If it is running successfully you will see "running" beside your job's name.

### Monitor Azure Databricks structured streaming in Azure Log Analytics

Once you have completed all the steps above, the Spark Structured Streaming event data from Azure Databricks is sent to your Azure Log Analytics workspace as your query is processed. The log data is available under the "Active" "Custom Logs" "SparkListenerEvent_CL" schema.

Azure Log Analytics provides functionality to create dashboards that you can use to monitor the progress of your Apache Structured Streaming queries. The structure of the Apache Spark Strucutred streaming log data is documented in the [managing streaming queries](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html#managing-streaming-queries) section of the Apache Spark [structured streaming programming guide](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html). You can use this information to learn more about the types of events and what they mean as you build your Azure Log Analytics dashboards.

## Next steps

Learn more about [Structured Streaming](https://docs.databricks.com/spark/latest/structured-streaming/index.html) in Azure Databricks.
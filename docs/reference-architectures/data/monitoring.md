---
title: Solution Accelerator for Monitoring Azure Databricks
titleSuffix: Azure Solution Accelerators
description: A scala library to deploy to a Databricks cluster to enable monitoring of metrics and logging data in Azure Log Analytics
author: petertaylor9999
ms.date: 01/28/2019
ms.topic:
ms.service:
ms.subservice:
---

# Solution Accelerator: Monitoring Azure Databricks using Azure Log Analytics

Azure Databricks is a fast, easy and collaborative Apache Spark–based analytics service that makes it easy to rapidly develop and deploy big data analytics and artificial intelligence (AI) solutions. Monitoring is a critical part of any production-level solution, and Azure Databricks offers robust functionality for monitoring metrics and event information from Azure Databricks service itself and .

Databricks is a very flexible and extensible system that supports the delivery of metrics and logging data to many different services. This solution accelerator extends the core monitoring functionality of Azure Databricks to support Azure Log Analytics. The solution accelerator is a set of code libraries and Maven build scripts to create the JAR files that are deployed to your Azure Databricks cluster.

# Monitoring Apache Spark Structured Streaming queries in Azure Databricks

Azure Databricks is based on Apache Spark. Apache Spark includes a set of structured APIs for batch processing data using Datasets, DataFrames, and SQL. With Apache Spark 2.0, support was added for [Structured Streaming](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html), a data stream processing API built upon Spark's batch processing APIs.

The Structured Streaming API includes functionality to monitor active streams as data is processed by sending event information to an external metrics system. The external metrics system is registered with Spark Structured Streaming by attaching an implementation of a **StreamingQueryListener** object to the current Spark streaming session.

This solution accelerator includes a **StreamingQueryListener** implementation, **LogAnalyticsStreamingQueryListener**, to send Structured Streaming event information to an Azure Log Analytics workspace. You first attach the **LogAnalyticsStreamingQueryListener** to the Spark session in your job application code. Next, the solution accelerator includes a Spark initialization script that copies the **LogAnalyticsStreamingQueryListener** implementation to each node in your Spark cluster. Finally, specify the connection string, workspace ID, and shared access signature (SAS) token for your Log Analytics workspace in the Spark configuration settings.

# Use the solution accelerator

This solution accelerator has the following prerequisites:

* Clone, fork, or download the [GitHub repository](https://github.com/mspnp/spark-monitoring).

* An Azure Databricks workspace and cluster. For instructions, see [get started with Azure Databricks.](https://docs.microsoft.com/azure/azure-databricks/quickstart-create-databricks-workspace-portal).
* Install the [Azure Databricks CLI](https://docs.databricks.com/user-guide/dev-tools/databricks-cli.html#install-the-cli).
  * An Azure Databricks personal access token is required to use the CLI. For instructions, see [token management](https://docs.azuredatabricks.net/api/latest/authentication.html#token-management).
  * You can also use the Azure Databricks CLI from the Azure Cloud Shell. 

* A Java IDE, with the following resources:
  * JDK 1.8
  * Scala SDK 2.11
  * Maven 3.5.4

To use the solution accelerator, import the Maven project configuration file, _pom.xml_, located in the **spark-monitoring** folder into your project. This will import four projects:

* spark-listeners
* spark-metrics
* spark-monitoring
* spark-jobs

For this solution accelerator, you'll work with the **spark-listeners** project.

## Develop your Apache Spark job application for Azure Databricks

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

To help you better understand how to use the solution accelerator, a sample job application is included in the **spark-jobs** project. You can build it as a job application and then follow the instructions below to run it in your Apache Spark cluster. The sample job application uses Spark Structured Streaming to read a data file that is present by default in each Azure Databricks cluster and then performs a simple query.

> [!NOTE]
> The **spark-jobs** sample application includes a Maven project configuration file, _pom.xml_, in the root folder for the project. Note that this file includes a **dependencies** section with all the dependencies necessary to include the **LogAnalyticsStreamingQueryListener**.

Let's first take a look at how the sample application references the library for the **LogAnalyticsStreamingQueryListener**:

******scala
import org.apache.spark.listeners.LogAnalyticsStreamingQueryListener
******

Note that this library is copied to each node in your Azure Databricks cluster during initialization. Apache Spark manages the Java class context for both the library and your job application code.

Now let's take a look at how the sample application attaches an instance of a **LogAnalyticsStreamingQueryListener** to the current [Spark session](https://spark.apache.org/docs/2.3.0/api/java/org/apache/spark/sql/SparkSession.html)

******scala

val spark = SparkSession
    .builder
    .getOrCreate

[...]

spark.streams.addListener(new LogAnalyticsStreamingQueryListener(spark.sparkContext.getConf))
******

First, the current Spark session is assigned to the variable **spark**. Next, the **LogAnalyticsStreamingQueryListener** is attached to the **streams** property of the current Spark session. Not that the **LogAnalyticsStreamingQueryListener** constructor takes a single parameter, which is the configuration information for the Spark cluster.

Attaching the **LogAnalyticsStreamingQueryListener** enables asynchronous monitoring of all structured streaming queries associated with the current Apache Spark session. For more information, see [reporting metrics programmatically using asynchronous APIs](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html#reporting-metrics-programmatically-using-asynchronous-apis) in the [Apache Spark structured streaming programming guide](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html).

Let's move on to creating and configuring an Azure Databricks cluster to run your job application.

## Create and configure your Azure Databricks cluster

To create and configure your Azure Databricks cluster, follow these steps:

1. Build the JAR file defined in the Maven build file in the **spark-listeners** directory of the Github repository. Building this project creates a JAR filed named **spark-listeners-1.0-SNAPSHOT.jar**.
2. Use the Azure Databricks CLI to create a directory named **dbfs:/databricks/init/jar**:
******
dbfs mkdirs dbfs:/databricks/init/startupscript
******
3. Use the Azure Databricks CLI to copy the **spark-listeners-1.0-SNAPSHOT.jar** file to a staging folder in the Azure Databricks file system. For example:
******
dbfs cp spark-listeners-1.0-SNAPSHOT.jar dbfs:/databricks/init/jar
******
4. Copy the **listeners.sh** bash script located in the **/scripts** directory of the Github repository to the **dbfs:/databricks/init/startupscript** directory in the Azure Databricks file system:
******
dbfs cp listeners.sh dbfs:/databricks/init/startupscript
******
5. Navigate to your Azure Databricks workspace in the Azure Portal. On the home page, click "new cluster". Choose a name for your cluster and enter it in "cluster name" text box. In the "Databricks Runtime Version" dropdown, select **4.3 (includes Apache Spark 2.3.1, Scala 2.11)**. Under "Advanced Options", click on the "Spark" tab. Enter the following name-value pairs:
****** 
spark.databricks.delta.preview.enabled true
spark.extraListeners com.databricks.backend.daemon.driver.DBCEventLoggingListener,org.apache.spark.listeners.LogAnalyticsListener
spark.logAnalytics.workspaceId <your Azure Log Analytics workspace ID> 
spark.logAnalytics.secret <your Azure Log Analytics shared access signature>
******
6. Click "confirm" to create the cluster. Next, click on the "start" button to start the cluster. 
7. Add your application job code to a new job by clicking on the "create job" button in the "jobs" tab. Choose a name for your job and enter it in the "name" text box. Click "set JAR" beside the "task" line, then drag and drop your job application's JAR file to the box. Enter the name of your application's **main** class in the "Main class" text box, and any starup arguments in the "arguments" text box. Click "OK".
8. On the "Cluster" line, select "edit" to go to the "configure cluster" dialog. Under the "cluster type" select "existing cluster" and select the cluster you created in step 6. Click "confirm".
9. On the job dialog, click on the job created in step 8 and select "run now".

Ensure that your job application is code is running in the Azure Databricks job dialog. If it is running successfully you will see "running" beside your job's name.

## Monitor Azure Databricks structured streaming streaming in Azure Log Analytics

Once you have completed all the steps above, the Spark Structured Streaming event data from Azure Databricks as your query is processed is sent to your Azure Log Analytics workspace. The log data is available under the "Active" "Custom Logs" "SparkListenerEvent_CL" schema.

Azure Log Analytics allows you to create dashboards that you can use to monitor the progress of all Apache Structured Streaming queries currently running in your Azure Databricks job application code. 

The structure of the Apache Spark Strucutred streaming log data is documented in the [managing streaming queries](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html#managing-streaming-queries) section of the Apache Spark [structured streaming programming guide](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html). You can use this information to learn more about the types of events and what they mean as you build your Azure Log Analytics dashboards.

# Next steps

Learn more about [Structured Streaming](https://docs.databricks.com/spark/latest/structured-streaming/index.html) in Azure Databricks.
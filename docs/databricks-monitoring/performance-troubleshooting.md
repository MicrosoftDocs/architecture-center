---
title: Performance troubleshooting for Azure Databricks using Azure Monitor
titleSuffix: 
description: How to troubleshoot performance issues in Azure Databricks using Azure Monitor and Grafana Dashboards 
author: petertaylor9999
ms.date: 02/28/2019
ms.topic:
ms.service:
ms.subservice:
---

# Troubleshoot performance bottlenecks in Azure Databricks

This article describes how to use monitoring dashboards to find performance bottleneck in Spark jobs on Azure Databricks.

[Azure Databricks](/azure/azure-databricks/) is a fast, powerful, and collaborative [Apache Spark](https://spark.apache.org/)–based analytics service that makes it easy to rapidly develop and deploy big data analytics and artificial intelligence (AI) solutions. Monitoring and troubleshooting performance issues is a critical component of operating your production Azure Databricks workloads, and the the final step in the process is to identify common performance issues using the monitoring visualizations based on telemetry data you've sent to your Log Analytics workspace and correct them in your application.

## Azure Databricks performance overview

Azure Databricks is based on Apache Spark, a general-purpose distributed computing system. Your application code, known as a **job**, executes on an Apache Spark cluster, coordinated by the cluster manager. In general, a job is the highest-level unit of computation.

A job represents the complete operation performed by your Apache Spark application from end-to-end. A typical operation includes reading data from a source, applying data transformations, and writing the results to storage or another destination. An important aspect of job performance is that the job advances through stages **sequentially**, which means that later stages are blocked by earlier ones.

Jobs are broken down into **stages** which represent , and stages further represent groups of identical **tasks** that can be executed in parallel on multiple nodes of the Spark cluster. Tasks are the most granular unit of execution taking place on a subset of the data.

## Prequisites

To set up the Grafana dashboards shown in this article, 

- Configure your Databricks cluster to send telemetry to an Azure Log Analytics workspace, using the Azure Databricks Monitoring Library. For details, see [Configure Azure Databricks to send metrics to Azure Monitor](./configure-cluster.md).

- Deploy Grafana in a virtual machine. See [Use dashboards to visualize Azure Databricks metrics](./dashboards.md).

The Grafana dashboard that is deployed includes a set of time-series visualizations. Each graph is time-series plot of metrics related to an Apache Spark [job](https://spark.apache.org/docs/latest/job-scheduling.html), stages of the job, and tasks that make up each stage.

## Job and stage latency

Job latency is the duration of a job execution from when it starts (not when it was submitted) until it completes. It is shown as percentiles (10%, 30%, 50%, 90%) of a job execution per cluster and application ID, to allow the visualization of outliers. The following graph shows a job history where the 90% reached 50 seconds, whereas the median was much less.

![Graph showing job latency](./_images/grafana-job-latency.png)

Investigate job execution by cluster and application, looking for spikes in latency. Once clusters and applications with high latency are identified, move on to investigate stage latency.

Stage latency is the next step to assess task straggler scenario. It is also shown in percentiles breakdown to allow the visualization of outliers. The visualization of stage latency is per cluster, application and stage name to allow the detection of a particular stage running slow. A job that is broken down in 4 stages if each stage runs slow it will affect the overall completion of a job. Identify spikes in task latency in the graph to determine which tasks are holding back completion of the stage.

![Graph showing stage latency](./_images/grafana-stage-latency.png)

In Cluster Throughput we provide a visualization for the number of jobs, stages, and tasks completed per minute. This helps you to understood the workload in terms of the relative number of stages and tasks per job. Here you can see that the number of jobs per minute ranges between 2 and 6, while the number of stages is about 12 &ndash; 24 per minute.

![Graph showing cluster throughput](./_images/grafana-cluster-throughput.png)

## Sum of task execution latency

This visualization shows the sum of task execution latency per host running on a cluster. It allows to detect task straggler due to host slowing down on a cluster or a misallocation of tasks per executor for the auto scale scenario. In the following example, most of the hosts have a sum of about 30 seconds. However, two of the hosts have sums that hover around 10 minutes. Either the hosts are running slow or the numer of tasks per executor is misallocated.

![Graph showing sum of task execution per host](./_images/grafana-sum-task-exec.png)

By looking at the number of tasks per executor, we can see that two executors are assigned a disproportionate number of tasks, causing a bottleneck.

![Graph showing tasks per executor](./_images/grafana-tasks-per-exec.png)

## Task metrics per stage

Task Metrics panel will give the breakdown of cost for a task execution. It also will produce the shuffle data size for a task. This will present opportunities for optimization around serialization, deserialization with implementation of broadcasts. Also it will produce a visualization of scheduler latency important for the Degree of Parallelization scenario discussed in the next use  case. Hover over the mouse on task metrics panel. Note the ExecutorComputeTime is the amount of time to run the task or if you wish task latency metrics discussed on previous topic. Ideally you do not want to see other times with a high ratio compared with ExecutorComputeTime. Those metrics can be understood as the cost for running a task( serialization, deserialization, scheduler delay time, shuffle read time, shuffle write time, jvm gc time) and the bytes that were shuffled to run the task. With this view of task metrics one can reliably understand where the cost is going for task running a particular stage.

The following graph shows the scheduler delay time exceeding the executor compute time. That means most tasks are waiting to run.

![Graph showing task metrics per stage](./_images/grafana-metrics-per-stage.png)

In this case, the problem was caused by having too many partitions, which caused a lot of overhead. Reducing the number of partitions lowered the scheduler delay time. Now most of the time is spent executing the task.

![Graph showing task metrics per stage](./_images/grafana-metrics-per-stage2.png)

## Streaming throughput and latency

Streaming throughput is directly related with structured streaming. There two important metrics associated with streaming throughput: Input rows per second and processed rows per second. If input rows per second outpaces processed rows per second, it means that stream processing system is falling behind. Also, if the input data is coming from Event Hubs or Kafka, you want to make sure that input rows per second keeps up with the data ingestion rate at the front end. Streaming latency is the amount of time to execute a micro batch in milliseconds.

Note that two jobs can have similar cluster throughput but very different streaming metrics. The following screenshot shows two different workloads. They are similar in terms of cluster throughput (jobs, stages, and tasks per minute). But the second run processes 12,000 rows/sec versus 4,000 rows/sec.

![Graph showing streaming throughput](./_images/grafana-streaming-throughput.png)

Streaming throughput is often a better business metric than cluster throughput, because it measures the number of data records that are processed.

## Resource consumption per executor 

**Percentage metrics** measure how much time an executor spends on various things, expressed as a ratio of time spent versus the overall executor compute time. The metrics are:

- % Serialize time
- % Deserialize time
- % CPU executor time
- % JVM time

These visualizations show how much each of these metrics contributes to overall executor processing.

**Shuffle metrics** are metrics related to data shuffling across the executors.

- Suffle I/O
- Shuffle memory
- File system usage
- Disk usage

## Task straggler

Stages in an application are executed sequentially with earlier stages blocking later stages. An Apache Spark task that executes a shuffle partition more slowly than other tasks will cause the whole cluster to run slowly because all tasks in the cluster must wait for the slow task to catch up before the stage can end. This can happen for the following reasons:

1. A host or group of hosts are running slow. In that case a task, stage, job  streaming latency and cluster throughput will suffer. The summation of tasks latencies per host will not be evenly distributed. Resource consumption will be evenly distributed across executors.

1. Data skewing: Tasks have an expensive aggregation to execute. In that case a task, stage, job  streaming latency and cluster throughput will suffer but summation of latencies per host will be evenly distributed. Resource consumption will be evenly distributed across executors.

1. Parition skewing: If partitions are of unequal size, a larger partition may cause unbalanced task execution. In this case, executor resources will be elevated in comparison to other executors running on the cluster. The problem is that all tasks running on that executor will run slow and hold the stage execution in the pipeline. Those stages are said to be *stage barriers* and the whole application will run slow.

## Degree of parallelism

During a structured streaming query, the assignment of a task to an executor is a resource intensive operation for the cluster. If the data under shuffle is not the optimal size, the amount of delay for a task will negatively impact throughput and latency. Another aspect is if there are too few partitions, the cores in the cluster will be underutilized and can also result in processing inefficiency. Conversely, if there are too many paritions, there is a great deal of management overhead for a small number of tasks.

To diagnose these problems, review the panels related to [cluster throughput](./dashboards.md#cluster-throughput), [job latency](./dashboards.md#job-latency), [streaming latency](./dashboards.md#streaming-throughputlatency), and scheduler delay time.


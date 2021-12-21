---
title: Big data cost estimates
description: Know how to make cost estimates for big data analytics services, including Azure Synapse analytics, Azure Databricks, Azure Stream Analytics, and more.
author: PageWriter-MSFT
ms.date: 08/24/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-synapse-analytics
  - azure-databricks
ms.custom:
  - article
---

# Big data analytics cost estimates

Most big data workloads are designed to do:

- Batch processing of big data sources at rest.
- Stream processing of data in motion.

Those workloads have different needs. Batch processing is done with long-running batch jobs. For stream processing, the data ingestion component should be able to capture and in some cases buffer, store real-time messages. Both workloads also have the requirement to store large volume of data. Then, filter, aggregate, and prepare that data for analysis.

For information about choosing technologies for each workload, see these articles:

- Batch processing
    - [Technology choices for batch processing](../../data-guide/technology-choices/batch-processing.md#technology-choices-for-batch-processing)
    - [Capability matrix](../../data-guide/technology-choices/batch-processing.md#capability-matrix)

- Stream processing
    - [What are your options when choosing a technology for real-time processing?](../../data-guide/technology-choices/stream-processing.md#what-are-your-options-when-choosing-a-technology-for-real-time-processing)
    - [Capability matrix](../../data-guide/technology-choices/stream-processing.md#capability-matrix)

This article provides cost considerations for some of those choices. This is not meant to be an exhaustive list, but a subset of options.

## Azure Synapse Analytics
The analytics resources are measured in *Data Warehouse Units (DWUs)*, which tracks CPU, memory, and IO. DWU also indicates the required level of performance. If you need higher performance, add more DWU blocks.

You can provision the resources in one of two service levels.

- **Compute Optimized Gen1** tracks usage in DWUs and is offered in a pay-as-you-go model.
- **Compute Optimized Gen2** tracks the compute DWUs (cDWUs) which allows you to scale the compute nodes. This level is intended for intensive workloads with higher query performance and compute scalability. You can choose the pay-as-you-go model or save 37% to 65% by using reserved instances if you can commit to one or three years. For more information, see [Reserved instances](./optimize-vm.md#reserved-vms).

> ![Task](../../_images/i-best-practices.svg) Start with smaller DWUs and measure performance for resource intensive operations, such as heavy data loading or transformation. This will help you determine the number of units you need to increase or decrease. Measure usage during the peak business hours so you can assess the number of concurrent queries and accordingly add units to increase the parallelism. Conversely, measure off-peak usage so that you can pause compute when needed.

In Azure Synapse Analytics, you can import or export data from an external data store, such as Azure Blob Storage and Azure Data Lake Store. Storage and analytics resources aren't included in the price. There is additional bandwidth cost for moving data in and out of the data warehouse.

For more information, see these articles:
- [Azure Synapse Pricing](https://azure.microsoft.com/pricing/details/synapse-analytics/)
- [Manage compute in Azure Synapse Analytics data warehouse](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-manage-compute-overview)

### Reference architecture

- [Automated enterprise BI with Azure Synapse Analytics and Azure Data Factory](../../reference-architectures/data/enterprise-bi-adf.yml)
- [Enterprise BI in Azure with Azure Synapse Analytics](../../reference-architectures/data/enterprise-bi-synapse.yml)

## Azure Databricks
Azure Databricks offers two SKUs **Standard** and **Premium**, each with these options, listed in the order of least to most expensive.
- **Data Engineering Light** is for data engineers to build and execute jobs in automated Spark clusters.
- **Data Engineering** includes autoscaling and has features for machine learning flows.
- **Data Analytics** includes the preceding set of features and is intended for data scientists to explore, visualize, manipulate, and share data and insights interactively.

Choose a SKU depending on your workload. If you need features like log audit, which is available in **Premium**, the overall cost can increase. If you need autoscaling of clusters to handle larger workloads or interactive Databricks dashboards, choose an option higher than **Data Engineering Light**.

Here are factors that impact Databricks billing:
- Azure location where the resource is provisioned.
- The virtual machine instance tier and number of hours the instances were running.
- *Databricks units (DBU)*, which is a unit of processing capability per hour, billed on per-second usage.

> The example is based on the current price and is subject to change. The calculation shown is for information purposes only.

Suppose you run a **Premium** cluster for 100 hours in East US 2 with 10 DS13v2 instances.

|Item|Example estimate|
|---|---|
|Cost for 10 DS13v2 instances|100 hours x 10 instances x $0.741/hour = $741.00|
|DBU cost for **Data Analytics** workload|100 hours x 10 instances x 2 DBU per node x $0.55/DBU = $1,100|
|**Total**|$1,841|

For more information, see [Azure Databricks Pricing](https://azure.microsoft.com/pricing/details/databricks).

If you can commit to one or three years, opt for reserved instances, which can save 38% - 59%. For more information, see [Reserved instances](./optimize-vm.md#reserved-vms).

> ![Task](../../_images/i-best-practices.svg) Turning off the Spark cluster when not in use to prevent unnecessary charges.

#### Reference architecture
- [Stream processing with Azure Databricks](../../reference-architectures/data/stream-processing-databricks.yml)
- [Build a Real-time Recommendation API on Azure](../../reference-architectures/ai/real-time-recommendation.yml)
- [Batch scoring of Spark models on Azure Databricks](../../reference-architectures/ai/real-time-recommendation.yml)

## Azure Stream Analytics
Stream analytics uses *streaming units (SUs)* to measure the amount of compute, memory, and throughput required to process data. When provisioning a stream processing job, you're expected to specify an initial number of SUs. Higher streaming units mean higher cost because more resources are used.

Stream processing with low latency requires a significant amount of memory. This resource is tracked by the SU% utilization metric. Lower utilization indicates that the workload requires more compute resources. You can set an alert on 80% SU Utilization metric to prevent resource exhaustion.

> ![Task](../../_images/i-best-practices.svg) To evaluate the number of units you need, process an amount of data that is realistic for your production level workload, observe the SU% Utilization metric, and accordingly adjust the SU value.

You can create stream processing jobs in Azure Stream Analytics and deploy them to devices running Azure IoT Edge through Azure IoT Hub. The number of devices impacts over all cost. Billing starts when a job is deployed to devices, regardless of the job status (running, failed, stopped).

SUs are based on the partition configuration for the inputs and the query that's defined within the job. For more information, see [Calculate the max streaming units for a job](/azure/stream-analytics/stream-analytics-parallelization#calculate-the-max-streaming-units-for-a-job) and [Understand and adjust Streaming Units](/azure/stream-analytics/stream-analytics-streaming-unit-consumption).

For pricing details, see [Azure Stream Analytics pricing](https://azure.microsoft.com/pricing/details/stream-analytics/).

#### Reference architecture
- [Batch scoring of Python machine learning models on Azure](../../reference-architectures/ai/batch-scoring-python.yml)
- [Azure IoT reference architecture](../../reference-architectures/iot.yml#cost-considerations)

## Azure Analysis Services

Big data solutions need to store data that can be used for reporting. Azure Analysis Services supports the creation of tabular models to meet this need.

Here are the tiers:
- **Developer** is recommended for evaluation, development, and test scenarios.
- **Basic** is recommended for small production environment.
- **Standard** is recommended for mission critical workloads.

Analysis Services uses Query Processing Units (QPUs) to determine the processing power. A QPU is an abstracted measure of compute and data processing resources that impact performance. Higher the QPU results in higher performance.

Each tier offers one or more instances. The main cost drivers are the QPUs and memory allocated for the tier instance. Start with a smaller instance, monitor the QPU usage, and scale up or down by selecting a higher or lower instance within the tier. Also, monitor usage during off-peak hours. You can pause the server when not in use. No charges apply when you pause your instance. For more information, see these articles:

- [The right tier when you need it](/azure/analysis-services/analysis-services-overview)
- [Monitor server metrics](/azure/analysis-services/analysis-services-monitor)
- [Azure Analysis Services pricing](https://azure.microsoft.com/pricing/details/analysis-services)

#### Reference architecture
- [Enterprise business intelligence - Azure Reference Architectures](../../reference-architectures/data/enterprise-bi-synapse.yml)
- [Automated enterprise BI - Azure Architecture Center](../../reference-architectures/data/enterprise-bi-adf.yml)

## Azure Data Factory V2
Azure Data Factory is a big data orchestrator. The service transfers data to and from diverse types of data stores. It transforms the data by using other compute services. It creates workflows that automate data movement and transformation.  You are only charged for consumption. Consumption is measured by these factors:

- Pipeline activities that take the actions on the data. Those actions include copying the data from various sources, transforming it, and controlling the flow. For more information, see [data movement activities](/azure/data-factory/copy-activity-overview), [data transformation activities](/azure/data-factory/transform-data), and [control activities](/azure/data-factory/control-flow-web-activity).

    You are charged for the total activities in thousands.
- Executions measured in data integration units. Each unit tracks CPU, memory, and network resource allocation. This measurement applies to Azure Integration Runtime.

You are also charged for execution activities, such as copying data, lookups, and external activities. Each activity is individually priced. You are also charged for pipelines with no associated triggers or runs within the month. All activities are prorated by the minute and rounded up.

#### Reference architecture
- [Automated enterprise BI - Azure Architecture Center](../../reference-architectures/data/enterprise-bi-adf.yml)
- [Enterprise business intelligence - Azure Reference Architectures](../../reference-architectures/data/enterprise-bi-synapse.yml)
- [Build an enterprise-grade conversational bot - Azure Architecture Center](../../reference-architectures/ai/conversational-bot.yml)

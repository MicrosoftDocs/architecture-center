This article describes how to create a data store to search and filter medical data. This solution demonstrates how to ingest DICOM and clinical data by using Azure Data Factory pipelines with pre-ingestion and post-ingestion validation pipelines at scale. After the data is ingested, it's indexed into a format that you can search and filter.

## Architecture

:::image type="content" source="./media/data-factory-ingestion-pipeline.png" alt-text="{alt-text}" border="false" lightbox="./media/data-factory-ingestion-pipeline.png":::

_Download a [Visio file](https://arch-center.azureedge.net/data-factory-ingestion-pipeline.vsdx) of this architecture._

### Dataflow

1. Data to be ingested is copied from an AzCopy-supported source location and sent to Azure Blob Storage via a pipeline. In this solution, we had a requirement for processing large volumes of data. To address this an automation hybrid runbook worker was used to run AzCopy on a VM optimized for the copy task. Alternatively, AzCopy Activity can be used instead for relatively smaller datasets. An [Azure Event Grid system topic](https://docs.microsoft.com/azure/event-grid/system-topics) is configured to send a message to Azure Queue when a new DICOM file is uploaded to Blob Storage.
1. Before the processing begins, the data validation pipeline performs sanity checks and other business logic on the files. For successful data validation checks, the pipelines continue. For unsuccessful data validation checks, [failures](/azure/data-factory/tutorial-pipeline-failure-error-handling) are logged, and the pipeline is paused.
1. On the Azure Storage account, a storage queue is configured and the Azure function that ingests the files is set up to be triggered using [Azure Queue Storage triggers](/azure/azure-functions/functions-bindings-storage-queue?tabs=in-process%2Cextensionv5%2Cextensionv3&pivots=programming-language-csharp). This function reads the DICOM files from Blob Storage and then parses and ingests the metadata into a single flat Azure Data Explorer table.
   > [!NOTE]
   > In this use case, the metadata of the DICOM files is stored in Azure Data Explorer clusters, and the raw images are stored by using [DICOM healthcare services](/azure/healthcare-apis/dicom/dicom-services-overview). This file storage isn't represented in the diagram.
1. The clinical data pipeline processes other clinical data and ingests the data into the same Azure Data Explorer clusters.
1. The DICOM data and clinical data are stored in the Azure Data Explorer cluster database as different tables. These two data streams must have a common identifier, such as the patient ID, to make them linkable.
1. Errors that occur during the DICOM and clinical file ingestion are recorded in a separate table. The ingestion validation pipeline ensures that there's no data loss during ingestion by validating the DICOM and clinical data row counts.
1. After the data is ingested into Azure Data Explorer, it's post-processed by the data aggregation pipeline. The DICOM data that's stored in the flat table, described in step 3, is aggregated and projected into a hierarchical model that's based on the DICOM study, series, and instance entities. The query performance on the DICOM and clinical data joins are far better using this schema design.
1. The cleanup pipeline deletes temporary files and tables that were created during the ingestion process.

### Components

- [Data Factory](/azure/data-factory/introduction) is a cloud-based platform for workloads that use the extract, transform, and load (ETL) process and store large data amounts in data stores.
- [Azure Data Explorer](/products/data-explorer/#overview) is largely a managed-data analytics service that performs real-time analysis of large data volumes. In this use case, Azure Data Explorer stores and queries large datasets. Though it does not fit the traditional use case (analytical time series type of data) of Azure Data Explorer, it is a great tool when dealing with any large dataset that requires high speed of data retrieval and a large index set.
- [Azure Files](/azure/storage/files/storage-files-introduction) provides fully managed file shares in the cloud. The team that transfers medical images places files for ingestion into the file share. Use AzCopy with [Azure Automation runbook](/azure/automation/overview) to handle large volumes of files (~30 TB) for better performance.
- [Blob Storage](https://azure.microsoft.com/services/storage/blobs) is used for copying files from an Azure Files share, which triggers the Azure function to ingest data. During the ingestion process, Blob Storage also holds transient DICOM metadata files that are ingested into Azure Data Explorer clusters.
- [Azure Functions](/azure/azure-functions/functions-overview) is a serverless solution that's used to read, parse, and store DICOM metadata into an Azure Data Explorer cluster.

### Alternatives

To store data, you can use [Azure SQL](https://azure.microsoft.com/products/azure-sql) instead of Azure Data Explorer. In this scenario, you use Azure Data Explorer to store data. was selected based on the data size, larger index set, and the performance needs of this scenario. For a smaller dataset, you can store DICOM metadata and clinical data in Azure SQL tables.

## Scenario details

Medical researchers face challenges with the collection and management of large, disparate datasets. Data is not stored uniformly across various systems, adding additional work for researchers to understand and re-format.
The solution demonstrates a way to ingest medical imaging data in the DICOM standard format and also clinical data.
Automated ingestion reduces the complexity of managing data and makes data available quickly by accelerating the process time.

### Potential use cases

This solution applies to medical data ingestion. You can apply the high-level design of the ingestion workflow to any industry with large datasets of different types of data. The design and orchestration of pipelines is relevant and useful in many scenarios.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can recover from failures and continue to function as designed. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/reliability/overview).

In Data Factory, data is [stored and replicated](/azure/data-factory/concepts-data-redundancy) in paired regions to protect against metadata loss. This method is called zone redundancy. You can’t use zone redundancy in some regions due to data residency requirements. Zone redundancy with availability zones incurs extra costs. If a deployment doesn’t have zone redundancy, data isn’t protected, so an Azure datacenter outage results in a cluster outage. High availability refers to the fault-tolerance of Azure Data Explorer, its components, and underlying dependencies within a region.  [High availability](/azure/data-explorer/business-continuity-overview#high-availability-of-azure-data-explorer) includes the persistence layer, compute layer, and a leader-follower configuration.  

Azure Functions supports [zone redundancy and zonal instances](/azure/reliability/reliability-functions?tabs=azure-portal). In the primary region, data in Blob Storage is always replicated three times. Azure Storage offers two options to replicate data in the primary region: locally redundant storage (LRS) and zone-redundant storage (ZRS). Use the [reliability checklist](/azure/well-architected/services/storage/storage-accounts/reliability#checklist) when you design your application.

Distinction is made between failures when the pipeline run must be paused and when the pipelines can continue. For instance, the data validation pipeline pauses if a failure occurs. There are other scenarios when the failures during the ingestion of DICOM files in the Data Factory pipelines can be handled gracefully. Such failures are logged in a separate table on Azure Data Explorer with the batch details of the ingestion to help with troubleshooting. The ingestion validation pipeline ensures that there's no data loss during ingestion by validating the DICOM and clinical data row counts. [Telemetry](/azure/data-factory/monitor-using-azure-monitor) gathers log metrics and pipeline run data.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

For Azure component pricing, see the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). The cost of this solution is based on factors, such as:

- The Azure services that are used.
- The volume of data or the number of ingested DICOM files and clinical data.

When you implement this solution, here are a few things to consider:

- Data Factory uses pay-as-you-go pricing, which is directly related to the pipeline activity, Data Factory artifacts usage, and SSIS integration runtimes. Understanding the activities and pipelines used will help in estimating costs. For example, when you use a data flow, save costs by committing to a reserved capacity. For more information, see [pricing for Data Factory](https://azure.microsoft.com/pricing/calculator/?service=data-factory). Azure Data Explorer has costs attached to the volume of data stored in hot and cold caches. For more information, see the [pricing information](https://azure.microsoft.com/pricing/details/data-explorer).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

For efficient operation of this solution, consider the telemetry, performance considerations, automated infrastructure deployments, and end-to-end pipeline validation strategies. Your end-to-end pipeline validation strategy should:

- Store test DICOM files in a separate storage account and copy them into your Azure Storage account. Trigger the Data Factory pipeline to start the ingestion process.
- The successful verification of the data validation pipeline indicates that sanity checks and other business logic on the files are complete.
- Verify that the `Ingest DICOM files Pipeline` run is successfully complete by querying on the run status. Verify that the number of rows in the temporary table match the number of files in the test data. You can query the number of rows added to the Azure Data Explorer table by extent tags.
- Verify that the `Data Aggregation Pipeline` is successful and the data is added to the appropriate Azure Data Explorer tables.
- Verify that the `Clinical Data Pipeline` is successful and that the number of clinical records in the ADX tables match.

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal authors:

- [Narmatha Balasundaram](https://www.linkedin.com/in/narmathabala) | Principal Engineer
- [Niel Sutton](https://www.linkedin.com/in/nielsutton) | Principal Technical Program Manager

Other contributors:

- [Marisa Ashour](https://www.linkedin.com/in/marisa-ashour) | Software Engineer
- [Phong Cao](https://www.linkedin.com/in/phongcaothai) | Senior Software Engineer
- [Ari Goldberg](https://www.linkedin.com/in/axgoldberg) | Principal Engineer

## Next steps

- Learn how [Data Factory](/azure/data-factory/data-migration-guidance-hdfs-azure-storage) can help ingest data from on-premises Hadoop cluster to Azure Storage.
- Use [Azure Monitor](/azure/data-factory/monitor-metrics-alerts) with Data Factory to gain visibility into the performance and health of pipelines.
- Learn about [pipeline failures and error handling](/azure/data-factory/tutorial-pipeline-failure-error-handling).
- Open-source [analytic pipelines](/azure/healthcare-apis/github-projects#analytic-pipelines) for other medical formats.

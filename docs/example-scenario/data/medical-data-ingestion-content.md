Medical researchers face challenges with the collection and management of large, disparate data sets. Data is not stored uniformly across various systems, adding additional work for researchers to understand and re-format.

This solution shows how you can create a data store that enables your researchers to search and filter medical data. The solution demonstrates a way to ingest medical imaging data in the DICOM standard format, clinical data, and potentially other related data. Once ingested, the data is indexed to enable searching and filtering for research purposes. Automated ingestion reduces the complexity of data management and accelerates the overall time to make the data available.

This scenario showcases a solution to ingest DICOM and Clinical data using Azure Data Factory pipelines with pre and post ingestion validation pipelines at scale.

## Architecture

![](RackMultipart20230718-1-xokfbb_html_5d061cf6da479faa.png)

_Download a [Visio file](https://arch-center.azureedge.net/__ADF-IngestionPipeline.vsdx) of this architecture._

### Dataflow

1. Data to be ingested is copied from an AzCopy supported source location into Azure Blob Storage using a pipeline. In this solution, we had a requirement for processing large volumes of data. To address this an automation hybrid runbook worker was used to execute AzCopy on a VM optimized for the copy task. Alternatively, AzCopy Activity can be used instead for relatively smaller datasets. An [Azure Event Grid system topic](https://docs.microsoft.com/azure/event-grid/system-topics) is configured to send a message to Azure Queue when a new DICOM file is uploaded to Blob Storage.
1. Data Validation pipeline performs sanity checks and other business logic on the files before the processing begins. On successful data validation checks, the pipelines continue, [failures](/azure/data-factory/tutorial-pipeline-failure-error-handling)are logged, and the pipeline is paused.
1. A storage queue is configured on the Azure Storage account and the Azure function that ingests the files is set up to be triggered using [Azure Queue Storage triggers](/azure/azure-functions/functions-bindings-storage-queue?tabs=in-process%2Cextensionv5%2Cextensionv3&pivots=programming-language-csharp). This function reads the DICOM files from the Blob Storage, parses and ingests the metadata into Azure Data Explorer tables in a single, flat table. Note: In this use case, the metadata of the DICOM files are stored in the Azure Data Explorer clusters and the raw images were stored separately using [DICOM healthcare services](/azure/healthcare-apis/dicom/dicom-services-overview) (Not represented in this diagram)
1. The clinical data pipeline processes other clinical data and ingests into the same Azure Data Explorer clusters.
1. DICOM data and clinical data are both stored in Azure Data Explorer cluster database as different tables. These two data streams must be linkable using a common identifier, such as the patient ID.
1. Errors during the ingestion of DICOM and clinical files are recorded in a separate table. Ingestion Validation pipeline ensures there is no data loss during ingestion by validating DICOM / Clinical data row counts.
1. The data Aggregation pipeline performs post processing of the data after initial ingestion into Azure Data Explorer. DICOM data stored in the flat table (Step 3) is aggregated and projected into a hierarchical model based on DICOM Study, Series, and Instance entities. The query performance on the DICOM and Clinical Data joins are far better using this schema design.
1. The Cleanup pipeline deletes any temporary files and tables created during the ingestion process.

### Components

- [Data Factory](/azure/data-factory/introduction) is cloud-based platform for Extract-Transform-Load (ETL) workloads that stores big data in various data stores.
- [Azure Data Explorer](/products/data-explorer/#overview) is largely a managed-data analytics service for real-time analysis of large volumes of data. In this use case, Azure Data Explorer stores and queries large datasets. Though it does not fit the traditional use case (analytical time series type of data) of Azure Data Explorer, it is a great tool when dealing with any large dataset that requires high speed of data retrieval and a large index set.
- [Azure Files](/azure/storage/files/storage-files-introduction) offers fully managed file shares in the cloud. The team that transfers medical images places files for ingestion into the file share. Use AzCopy with [Azure Automation runbook](/azure/automation/overview) to handle large volumes of files (~30 TB) for better performance.
- [Blob Storage](https://azure.microsoft.com/services/storage/blobs) is used for copying files from Azure File Share, triggering the Azure Function to ingest data. During the ingestion process, this also holds transient DICOM metadata files that are ingested into Azure Data Explorer clusters.
- [Azure Functions](/azure/azure-functions/functions-overview) is a serverless solution used to read, parse, and store DICOM metadata into the Azure Data Explorer cluster.

### Alternatives

[Azure SQL](https://azure.microsoft.com/products/azure-sql) is an alternative to Azure Data Explorer for the purposes of storing data. In this scenario, Azure Data Explorer was selected based on the data size, larger index set, and the performance needs of this scenario. For a smaller dataset, DICOM metadata and clinical data could be stored in SQL tables.

## Scenario details

### Potential use cases

The solution described above applies to the ingestion of medical data. The high-level design of the ingestion workflow can be applied to any industry dealing with large datasets with multiple disparate types of data. The design and orchestration of pipelines is relevant and useful in many scenarios.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can recover from failures and continue to function as designed. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/reliability/overview).

This scenario uses Data Factory to ingest data into an Azure Data Explorer cluster. Except in certain regions (due to data residency requirements), data stored in Data Factory is [stored and replicated](/azure/data-factory/concepts-data-redundancy) in paired regions to protect against metadata loss. In Azure Data Explorer, [high availability](/azure/data-explorer/business-continuity-overview#high-availability-of-azure-data-explorer) includes the persistence layer, compute layer, and a leader-follower configuration. Zonal redundancy with availability zones involve additional costs. When deployed without zonal redundancy, Azure datacenter outage results in cluster outage.

Azure Functions support both [zone redundancy and zonal instances](/azure/reliability/reliability-functions?tabs=azure-portal). Data in Blob Storage is always replicated three times in the Primary Region. Azure Storage offers two options for how your data is replicated in the primary region - Locally redundant storage (LRS) and Zone-redundant storage (ZRS). Leverage the [reliability checklist](/azure/well-architected/services/storage/storage-accounts/reliability#checklist) while designing your application.

Distinction is made between failures when the pipeline run must be paused and when the pipelines can continue. For instance, any failure during the "Data Validation Pipeline" results in the run being paused. There are other scenarios when the failures during the ingestion of DICOM files in the Data Factory pipelines can be handled gracefully. Such failures are logged in a separate table on Azure Data Explorer with the batch details of the ingestion to help with troubleshooting. Ingestion Validation pipeline ensures there is no data loss during ingestion by validating DICOM / Clinical data row counts. Additionally, [telemetry](/azure/data-factory/monitor-using-azure-monitor) is enabled to gather log metrics and pipeline run data.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The pricing for many of the Azure components can be found in the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). Ultimately, pricing for this solution is based on factors such as:

- Azure services used
- Volume of data, in terms of the number of DICOM files and clinical data ingested.

When implementing this solution, here are a few things to consider while implementing this solution

- Data Factory uses pay-as-you-go pricing, which is directly related to the pipeline activity execution, Data Factory artifacts usage and SSIS integration runtimes. Understanding the activities and pipelines used will help in estimating costs. For example, when using Data flow, costs can be saved by committing to a reserved capacity. For more details in [pricing for ADF](https://azure.microsoft.com/pricing/calculator/?service=data-factory). Azure Data Explorer has costs attached to the volume of data stored in hot and cold caches. Understanding data helps in designing a data architecture with Azure Data Explorer. For more information, see the [pricing information](https://azure.microsoft.com/pricing/details/data-explorer).

### Operational excellence

The application design and implementation for workload orchestration was done with operational excellence pillar in mind. These include telemetry, performance considerations, automated infrastructure deployments and end-to-end pipeline validation strategies. Your end-to-end pipeline validation strategy should:

- Test DICOM files are stored in a separate storage account and copied into Azure Storage Account. The Data Factory pipeline is then triggered to start the ingestion process.
- The successful verification of the `Data Validation Pipeline` indicates that sanity checks and other business logic on the files are complete.
- Verify that the `Ingest DICOM files Pipeline` run has completed successfully by querying on the run status. Additional tests include verifying the count of rows in the temporary table matches with number of files in the test data. The number of rows added to the Azure Data Explorer table can be queried by extent tags.
- Verify that the `Data Aggregation Pipeline` is successful and data is added to expected Azure Data Explorer tables.
- Verify that the `Clinical Data Pipeline` is successful and the number of clinical records in the ADX tables match.
- Ingestion Validation pipeline ensures there is no data loss during ingestion by validating DICOM / Clinical data row counts.

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

To continue to understand more Azure capabilities related to implementing a data management pipeline, reference these resources –

- Learn how [Data Factory](/azure/data-factory/data-migration-guidance-hdfs-azure-storage) can help ingest data from on-premises Hadoop cluster to Azure Storage.
- Learn how to use [Azure Monitor](/azure/data-factory/monitor-metrics-alerts) with Data Factory to gain visibility into performance and health of the pipelines.
- Learn more about [pipeline failures and error handling](/azure/data-factory/tutorial-pipeline-failure-error-handling).
- Open-source [analytic pipelines](/azure/healthcare-apis/github-projects#analytic-pipelines) for other Medical formats.

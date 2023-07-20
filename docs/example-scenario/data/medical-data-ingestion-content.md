This article describes how to create a data store to search and filter medical data. It presents an architecture for ingesting DICOM-format medical imaging data and clinical data by using Azure Data Factory pipelines with preingestion and postingestion validation pipelines at scale. After the data is ingested, it's indexed into a format that you can search and filter.

## Architecture

:::image type="content" source="./media/data-factory-ingestion-pipeline.png" alt-text="Diagram that shows the process of ingesting and indexing medical files." border="false" lightbox="./media/data-factory-ingestion-pipeline.png":::

_Download a [Visio file](https://arch-center.azureedge.net/data-factory-ingestion-pipeline.vsdx) of this architecture._

### Dataflow

1. Data is copied from a source location that supports the `AzCopy` command-line utility, and it's sent to Azure Blob Storage via a pipeline. An [Azure Event Grid system topic](https://docs.microsoft.com/azure/event-grid/system-topics) is configured to send a message to Azure Queue Storage when a new DICOM file is uploaded to Blob Storage.
1. Before the processing begins, the data validation pipeline performs sanity checks and other business logic on the files. For successful data validation checks, the pipeline continues. For unsuccessful data validation checks, [failures](/azure/data-factory/tutorial-pipeline-failure-error-handling) are logged, and the pipeline is paused.
1. On the Azure Storage account, a storage queue is configured, and [Queue Storage](/azure/azure-functions/functions-bindings-storage-queue) is set up to trigger the Azure function that ingests the files. This function reads the DICOM files from Blob Storage and then parses and ingests the metadata into a single flat Azure Data Explorer table.
   > [!NOTE]
   > In this solution, the DICOM file metadata is stored in Azure Data Explorer clusters, and the raw images are stored by using [DICOM healthcare data services](/azure/healthcare-apis/dicom/dicom-services-overview). This storage organization isn't represented in the diagram.
1. The clinical data pipeline processes the clinical files and ingests the data into the same Azure Data Explorer clusters that the DICOM file metadata is stored in.
1. The DICOM metadata and clinical data are stored in the Azure Data Explorer cluster database as different tables. These two data streams must have a common identifier, such as the patient ID, to make them linkable.
1. Errors that occur during the DICOM and clinical file ingestion are recorded in a separate table. The ingestion validation pipeline ensures that there's no data loss during ingestion by validating the DICOM and clinical data row counts.
1. After the data is ingested into Azure Data Explorer, the data aggregation pipeline post-processes it. The DICOM metadata that's stored in the flat table is aggregated and projected into a hierarchical model that's based on the DICOM study, series, and instance entities. This design improves the query performance of the DICOM and clinical data joins.
1. The cleanup pipeline deletes temporary files and tables that were created during the ingestion process.

### Components

- [Data Factory](/azure/data-factory/introduction) is a cloud-based platform for workloads that use the extract, transform, and load (ETL) process and store large amounts of data in data stores.
- [Azure Data Explorer](https://azure.microsoft.com/products/data-explorer) is a managed-data analytics service that performs real-time analysis of large volumes of data. In this scenario, Azure Data Explorer stores and queries large datasets that require a high data retrieval speed and a large index set.
- [Azure Files](/azure/storage/files/storage-files-introduction) provides fully managed file shares in the cloud. In this scenario, medical image files that are to be ingested go in the file share.
- An [Azure Automation runbook](/azure/automation/overview) handles large volumes of files, up to 30 terabytes (TB). In this scenario, use `AzCopy` with an Azure Automation runbook for better performance.
- [Blob Storage](https://azure.microsoft.com/services/storage/blobs) is used for copying files from an Azure Files share, which triggers the Azure function to ingest data. During the ingestion process, Blob Storage also holds transient DICOM metadata files that are ingested into Azure Data Explorer clusters.
- [Azure Functions](/azure/azure-functions/functions-overview) is a serverless solution that's used to read, parse, and store DICOM metadata into an Azure Data Explorer cluster.

### Alternatives

To store data, you can use [Azure SQL](https://azure.microsoft.com/products/azure-sql) instead of Azure Data Explorer. In this scenario, you use Azure Data Explorer to store data, which is selected based on the data size, large index set, and the performance needs of this scenario. For a smaller dataset, you can store DICOM metadata and clinical data in Azure SQL tables.

In this scenario, an automation hybrid runbook worker runs `AzCopy` on a virtual machine that's optimized for the copy task. For smaller datasets, you can use an `AzCopy` activity.

## Scenario details

Large disparate datasets can be a challenge for medical researchers to collect and manage. Data isn't stored uniformly across systems, which can be difficult to understand and reformat. This solution demonstrates a method to ingest DICOM-format medical imaging data and clinical data. Automated ingestion reduces the complexity of managing data and makes data available quickly by accelerating the process time.

### Potential use cases

This solution applies to medical data ingestion. You can apply the high-level design of the ingestion workflow to any industry that uses large datasets that contain different types of data.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can recover from failures and continue to function as designed. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

In Data Factory, avoid data loss by [storing and replicating your data](/azure/data-factory/concepts-data-redundancy) in paired regions. This method is called zone redundancy. You can’t use zone redundancy in some regions due to data residency requirements. Zone redundancy with availability zones incurs extra costs. If a deployment doesn’t have zone redundancy, data isn’t protected. For example, an Azure datacenter outage also results in a cluster outage.

Azure Functions supports [zone redundancy and zonal instances](/azure/reliability/reliability-functions?tabs=azure-portal). In the primary region, data in Blob Storage is replicated three times. Azure Storage offers two options to replicate data in the primary region: locally redundant storage and zone-redundant storage.

Zone redundancy provides your solution with [high availability](/azure/data-explorer/business-continuity-overview#high-availability-of-azure-data-explorer). High availability refers to the fault-tolerance of Azure Data Explorer, its components, and underlying dependencies within a region. High availability includes the persistence layer, compute layer, and a leader-follower configuration.  

Sometimes when failures occur, the pipeline run must be paused and sometimes the pipelines can continue. For example, the data validation pipeline pauses if a failure occurs. In other scenarios, failures are logged in a separate Azure Data Explorer table. The batch details of the ingestion are recorded for troubleshooting. The ingestion validation pipeline ensures that there's no data loss during ingestion by validating the DICOM and clinical data row counts. Enable [telemetry](/azure/data-factory/monitor-using-azure-monitor) to gather log metrics and pipeline run data.

To incorporate reliability into your application, use the [reliability checklist](/azure/well-architected/services/storage/storage-accounts/reliability#checklist).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

For Azure component pricing, see the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). The cost of this solution is based on factors, such as:

- The Azure services that you use.
- The data volume or the number of ingested DICOM files and clinical data files.

Data Factory uses pay-as-you-go pricing. The pricing is based on the pipeline activity, Data Factory artifacts usage, and SQL Server Integration Services (SSIS) integration runtimes. When you use a data flow in Data Factory, you can reduce costs by committing to a reserved capacity. Azure Data Explorer costs are based on the volume of data that's stored in hot and cold caches. For more information, see the [Azure Data Explorer pricing](https://azure.microsoft.com/pricing/details/data-explorer).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

For efficient operation of this solution, consider the telemetry, performance considerations, automated infrastructure deployments, and end-to-end pipeline validation strategies. To implement an optimal end-to-end pipeline validation strategy:

- Store test DICOM files in a separate storage account and copy the files into your Azure Storage account. The Data Factory pipeline triggers to start the ingestion process.
- Ensure the successful verification of the data validation pipeline, which indicates that sanity checks and other business logic on the files are complete.
- Verify that the ingest DICOM files pipeline run is successfully complete by querying the run status. Verify that the number of rows in the temporary table match the number of files in the test data. You can query the number of rows added to the Azure Data Explorer table by using extent tags.
- Verify that the data aggregation pipeline is successful, and the data is added to the appropriate Azure Data Explorer tables.
- Verify that the clinical data pipeline is successful and that the number of clinical records in the Azure Data Explorer tables match.

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

- [Use Data Factory to migrate data from an on-premises Hadoop cluster to Azure Storage](/azure/data-factory/data-migration-guidance-hdfs-azure-storage)
- [Data Factory metrics and alerts](/azure/data-factory/monitor-metrics-alerts)
- [Pipeline failures and error handling](/azure/data-factory/tutorial-pipeline-failure-error-handling)
- [Open-source analytic pipelines](/azure/healthcare-apis/github-projects#analytic-pipelines)
- [Overview of Dataverse healthcare APIs](/dynamics365/industry/healthcare/dataverse-healthcare-apis-overview)

## Related resources

- [Solutions for the healthcare industry](../../industries/healthcare.md)
- [Health data consortium on Azure](azure-health-data-consortium.yml)
- [HIPAA and HITRUST compliant health data AI](../../solution-ideas/articles/security-compliance-blueprint-hipaa-hitrust-health-data-ai.yml)

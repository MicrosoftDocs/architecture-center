This architecture provides guidance and recommendations for developing offline data operations and data management (DataOps) for an automated driving solution. This DataOps architecture is built on the framework that's outlined in [Autonomous vehicle operations (AVOps) design guide](../../guide/machine-learning/avops-design-guide.md). DataOps is one of the building blocks of AVOps. Other building blocks include machine learning operations (MLOps), validation operations (ValOps), DevOps, and centralized AVOps functions.

## Architecture

:::image type="content" source="./images/dataops.png" alt-text="Diagram Dataops Architecture" border="false" lightbox="./images/dataops.png":::

*Download a [Visio file](https://arch-center.azureedge.net/dataops-architecture.vsdx) that contains the architecture diagrams in this article.*

### Dataflow

1. Measurement data originates in a vehicle's data streams. Sources include cameras, vehicle telemetry, and radar, ultrasonic, and lidar sensors. Data loggers in the vehicle store the measurement data on logger storage devices. The logger storage data is uploaded to a landing data lake. A service like [Azure Data Box](/azure/databox/) or [Azure Stack Edge](/azure/databox-online/), or a dedicated connection like [Azure ExpressRoute](/azure/expressroute/) ingests the data into Azure. Measurement data in the following formats lands in [Azure Data Lake](/azure/storage/blobs/data-lake-storage-introduction): Measurement Data Format version 4 (MDF4), technical data management systems (TDMS), and ROS bag. The uploaded data enters a storage account called Landing that's dedicated for receiving and validating the data.

1. An [Azure Data Factory](/azure/data-factory/introduction) pipeline is triggered at a scheduled interval to process the data in the Landing storage account. The pipeline handles the following steps:
   - Performs a data quality check such as a checksum. This step removes low-quality data so that only high-quality data passes through to the next stage. Azure App Service is used to run the quality check code. Data that's deemed incomplete is archived for future processing.
   - For lineage tracking, calls a metadata API by using App Service. This step updates the metadata in [Azure Cosmos DB](/azure/cosmos-db) to create a new data stream. For each measurement, there's a raw data stream.
   - Copies the data to a storage account called Raw in [Azure Data Lake](/azure/storage/blobs/data-lake-storage-introduction).
   - Calls the metadata API to mark the data stream as complete so that other components and services can consume the data stream.  
   - Archives the measurements and removes them from the Landing storage account.

1. Azure Data Factory and Azure Batch process the data in the raw zone to extract information that downstream systems can consume:
   - Azure Batch reads the data from topics in the raw file and outputs the data into selected topics in respective folders.  
   - Because the files in the raw zone can each be more than 2 GB in size, parallel processing extraction functions are run on each file. These functions extract image processing, lidar, radar, and GPS data. They also perform metadata processing. Data Factory and Azure Batch provide a way to perform parallelism in a scalable manner.
   - The data is downsampled to reduce the amount of data that needs to be labeled and annotated.

1. If data from the vehicle logger isn't synchronized across the various sensors, a Data Factory pipeline is triggered that syncs the data to create a valid dataset. The synchronization algorithm runs on Azure Batch.

1. A Data Factory pipeline is triggered that enriches the data with telemetry, vehicle logger data, or other data, such as weather, map, or object data. Enriched data helps to provide data scientists with insights that they can use in algorithm development, for example. The generated data is kept in Parquet files that are compatible with the synchronized data. Metadata about the enriched data is stored in the metadata storage.

1. A Data Factory pipeline performs scene detection. Scene metadata is kept in the metadata store. Scene data is stored as objects in Parquet or Delta files.

1. Third-party partners perform manual or auto labeling. The data is shared securely with the third-party partners via Azure Data Share and integrated in Microsoft Purview. Azure Data Share uses a dedicated storage account named Labeled in Azure Data Lake to return the labeled data to the organization. Recommended formats for label data exchange include [common objects in context (COCO) datasets](https://cocodataset.org/#home) and [Association for Standardization of Automation and Measuring Systems (ASAM) OpenLABEL datasets](https://www.asam.net/standards/detail/openlabel/).

   The labeled data sets are used in MLOps processes to create specialized algorithms such as perception and sensor fusion models. The algorithms can detect scenes and objects in an environment such as lane changes, blocked roads, pedestrian traffic, traffic lights, and traffic signs.

1. A metadata store in Azure Cosmos DB stores metadata for the measurements, such as drive data, and for the enrichment data and detected scenes. This store also contains metadata for the lineage of the data as it goes through the processes of extraction, downsampling, synchronization, enrichment, and scene detection. The metadata API is used to access the measurements, the lineage, and the scene data and to look up where data is stored. As a result, the metadata API serves as a storage layer manager. It spreads data across storage accounts. It also provides developers with a way to use a metadata-based search to get data locations. For that reason, the metadata store is a centralized component that offers traceability and lineage across the entire AD data flow.

1. Azure Databricks and Azure Synapse are used to connect with the metadata API and access Azure Data Lake Storage and conduct research on the data.

### Components

- [Data Box](https://azure.microsoft.com/products/databox) provides a way to send terabytes of data into and out of Azure in a quick, inexpensive, and reliable way. In this solution, Data Box is used to transfer collected vehicle data to Azure via a regional carrier.
- [ExpressRoute](https://azure.microsoft.com/products/expressroute) extends an on-premises network into the Microsoft cloud over a private connection.
- [Azure Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage) holds a large amount of data in its native, raw format. In this case, Data Lake Storage stores data based on stages, for example, raw or extracted.
- [Azure Data Factory](https://azure.microsoft.com/products/data-factory) is a fully managed, serverless solution for creating and scheduling extract, transform, and load (ETL) and extract, load, and transform (ELT) workflows. Here, Data Factory performs ETL via [batch compute](/azure/batch/) and creates data-driven workflows for orchestrating data movement and transforming data.
- [Azure Batch](https://azure.microsoft.com/products/batch) runs large-scale parallel and high-performance computing (HPC) batch jobs efficiently in Azure. This solution uses Azure Batch to run large-scale applications for tasks like data wrangling, filtering and preparing data, and extracting metadata.
- [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db) is a globally distributed, multimodel database. Here, it stores metadata results, like stored measurements.
- [Data Share](https://azure.microsoft.com/products/data-share/) shares data with partner organizations with enhanced security. By using in-place sharing, data providers can share data where it resides without copying the data or taking snapshots. In this solution, Data Share shares data with labeling companies.
- [Azure Databricks](https://azure.microsoft.com/products/databricks/) provides a set of tools for maintaining enterprise-grade data solutions at scale. It's required for long-running operations on large amounts of vehicle data. Data engineers use Azure Databricks as an analytics workbench.
- [Azure Synapse Analytics](https://azure.microsoft.com/products/synapse-analytics/) reduces time to insight across data warehouses and big data systems.
- [Azure Cognitive Search](https://azure.microsoft.com/products/search) provides data catalog search services.
- [Azure App Service](https://learn.microsoft.com/azure/app-service/overview) provides a serverless based web app service. In this case, App Service hosts the metadata API.
- [Azure Purview](https://learn.microsoft.com/purview/purview) provides data governance across organizations.
- [Azure Container Registry](https://learn.microsoft.com/azure/container-registry/) is a service that creates a managed registry of container images. This solution uses Container Registry to store containers for processing topics.
- [Azure Application Insights](https://learn.microsoft.com/azure/azure-monitor/app/app-insights-overview?tabs=net) is an extension of [Azure Monitor](https://learn.microsoft.com/azure/azure-monitor/overview) that provides application performance monitoring. Application Insights can be integrated to log custom events, custom metrics, and log information while processing a particular measurement for extraction. Application Insights helps in building the observability around measurement extraction. You can build queries on log analytics to get the all the details about a measurement.

## Scenario details

Designing a robust DataOps framework for autonomous vehicles is crucial for using your data, tracing its lineage, and making it available throughout your organization. Without a well-designed DataOps process, the massive amount of data that autonomous vehicles generate can quickly become overwhelming and difficult to manage.

When you implement an effective DataOps strategy, you help ensure that your data is properly stored, easily accessible, and has a clear lineage. You also make it easy to manage and analyze the data, leading to more informed decision-making and improved vehicle performance.

An efficient DataOps process provides a way to easily distribute data throughout your organization. Various teams can then access the information that they need to optimize their operations. DataOps makes it easy to collaborate and share insights, which helps to improve the overall effectiveness of your organization.

Typical challenges for data operations in the context of autonomous vehicles include:

- Management of the daily terabyte or petabyte data volume of measurement data from research and development vehicles.
- Data sharing and collaboration across multiple teams and partners, for instance, for labeling, annotations, and quality checks.
- Traceability and lineage for a safety-critical perception stack that captures versioning and the lineage of measurement data.
- Metadata and data discovery to improve semantic segmentation, image classification, and object detection models.

The AVOps DataOps reference architecture provides guidance how to address and solve these challenges. This one? Or the one that's mentioned in the intro? I think this one.

### Federated data operations

In an organization that implements AVOps, multiple teams contribute to DataOps due to the complexity that's required for autonomous vehicle operations. For example, one team might be in charge of data collection and data ingestion. Another team might be responsible for data quality management of lidar data. For that reason, the following principles of a [data mesh architecture](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/what-is-data-mesh) are important to consider for DataOps:

- Domain-oriented decentralization of data ownership and architecture: One dedicated team is responsible for one data domain that provides data products for that domain, for example, labeled datasets.
- Data as a product: Each data domain has various zones on data-lake implemented storage containers. There are zones for internal usage. There's also a zone that contains published data products for other data domains or external usage to avoid data duplication.
- Self-serve data as a platform to enable autonomous, domain-oriented data teams.
- Federated governance to enable interoperability and access between AVOps data domains that requires a centralized metadata store and data catalog. For example, a labeling data domain might needs access to a data collection domain.

For further details and guidance about data mesh implementations, see [Cloud-scale analytics](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics).

#### AVOps data domains example structure

The following table provides some ideas for structuring data domains for AVOps:

| Data domain | Published data products | Solution step |
|--|--|--|
|Data collection | Uploaded and validated measurement files| Landing and raw |
|Extracted images| Selected and extracted images or frames, lidar, and radar  | Extracted |
|Extracted radar or lidar| Selected and extracted lidar and radar data | Extracted |
|Extracted telemetry | Selected and extracted car telemetry data | Extracted |
|Labeled | Labeled data sets | Labeled |
|Recompute | Generated KPIs based on resimulation runs | Recompute |

Each AVOps data domain is set up based on a blueprint structure that includes [Azure Data Factory](/azure/data-factory/introduction), [Azure Data Lake Gen2](/azure/storage/blobs/data-lake-storage-introduction), databases, [Azure Batch](/azure/batch/), and Spark runtimes via [Azure Databricks](https://azure.microsoft.com/products/databricks/)  or [Azure Synapse Analytics](https://azure.microsoft.com/products/synapse-analytics/).

#### Metadata and data discovery

Each data domain is decentralized and individually manages its corresponding AVOps data products. For central data discovery and to know where data products are located, two components are required:

- A metadata store that persists metadata about processed measurement files and data streams, such as video sequences. This component makes the data discoverable and traceable with annotations that need to be indexed, such as for searching the metadata of unlabeled files. For example, you might want the metadata store to return all frames that are collected by specific VINs or frames with pedestrians or other enrichment-based objects.
- A data catalog that shows lineage, the dependencies between AVOps data domains, and which data stores are involved in the AVOps data loop. An example of a data catalog is [Microsoft Purview](https://learn.microsoft.com/purview/purview).

You can use Azure Data Explorer or Azure Cognitive Search to extend a metadata store that's based on Azure Cosmos DB. Your selection depends on the final scenario that you need for data discovery. Use Cognitive Search for semantic search capabilities.

The following metadata model diagram shows a typical unified metadata model that's used across several AVOps data loop pillars:

:::image type="content" source="images/metadata-model.png" alt-text="Diagram that shows how the solution converts raw measurement data into derived data streams." border="false":::

#### Data sharing

Data sharing is a common scenario in an AVOps data loop. Uses include data sharing between data domains and external sharing, for example, to integrate labeling partners. [Microsoft Purview](/purview/purview) provides the following capabilities for efficient data sharing in a data loop:

- [Self-service data discovery and access](/azure/purview/concept-self-service-data-access-policy)
- [In-place data sharing](/azure/purview/concept-data-share)

### Data pipeline

In this DataOps solution, the movement of data between different stages in the data pipeline is automated. By using this approach, the process provides efficiency, scalability, consistency, reproducibility, adaptability, and error handling benefits. It enhances the overall development process, accelerates progress, and supports the safe and effective deployment of autonomous driving technologies.  

The following sections describe how you can implement data movement between stages and how you should structure your storage accounts.

#### Hierarchical folder structure

A well-organized folder structure is a vital component of a data pipeline in autonomous driving development. Such a structure provides a systematic and easily navigable arrangement of data files, facilitating efficient data management and retrieval.

In this solution, the data in the *raw* folder has the following hierarchical structure:

   *region/raw/<measurement-ID>/<data-stream-ID>/YYYY/MM/DD*

The data in the extracted zone storage account uses a similar hierarchical structure:

   *region/extracted/<measurement-ID>/<data-stream-ID>/YYYY/MM/DD*

By using similar hierarchical structures, you can take advantage of the hierarchical namespace capability of [Azure Data Lake](/azure/storage/blobs/data-lake-storage-introduction). Hierarchical structures help create scalable and cost-effective object storage. These structures also improve the efficiency of object search and retrieval. Partitioning by year and vehicle ID makes it easy to search for relevant images from a specific vehicles. In the data lake, a storage container is created for each sensor, such as a camera, a GPS device, or a lidar or radar sensor.

#### Landing storage account to Raw storage account

A Data Factory pipeline is triggered based on a schedule. After the pipeline is triggered, the data is copied from the Landing storage account to the Raw storage account.

:::image type="content" source="./images/data-factory-copy-landing-raw.png" alt-text="Architecture diagram that shows how a Data Factory pipeline validates data, creates data streams, copies data to a raw account, and archives the data." border="false" lightbox="./images/data-factory-copy-landing-raw.png":::

The pipeline retrieves all the measurement folders and iterates through them. With each measurement, the solution performs the following activities:

1. Validate the measurement: A function retrieves the file manifest file from the measurement manifest. The function checks whether all the MDF4, TDMS, and ROS bag measurement files for the current measurement exist in the measurement folder. If the validation succeeds, the function proceeds to the next activity. If the validation fails, the function skips the current measurement and instead moves on to the next measurement folder.

1. Call an API to create a measurement: A web API call is made to the API that creates a measurement, and the JSON payload from the measurement manifest JSON file is passed to the API. If the call succeeds, the response is parsed to retrieve the measurement ID. If the call fails, the measurement is moved to the on-error activity for error handling.

   > [!NOTE]
   > This DataOps solution is built on the assumption that you limit the number of requests to the app service. If your solution might make an indeterminate number of requests, consider a [rate limiting pattern](/azure/architecture/patterns/rate-limiting-pattern).

1. Call an API to create a datastream: A web API call is made to the API that creates a datastream by creating the required JSON payload. If the call succeeds, the response is parsed to retrieve the datastream ID and the datastream location. If the call fails, the measurement is moved to the on-error activity.

1. Call an API to update the datastream state: A web API call is made to update the state of the stream to `Start Copy`. If the call succeeds, the copy activity copies measurement files to the datastream location. If the call fails, the measurement is moved to the on-error activity.

1. Copy the measurement files: [Azure Batch](/azure/batch/) is used to copy the measurement files from the Landing storage account to the Raw storage account. An [Azure Data Factory](/azure/data-factory/introduction) pipeline invokes [Azure Batch](/azure/batch/) for copying a measurement. A copy module of an orchestrator app creates a job with the following tasks for each measurement:

   - Copy the measurement files to the Raw storage account.
   - Copy the measurement files to an archive storage account.
   - Remove the measurement files from the Landing storage account.

   > [!NOTE]
   > [Azure Batch](/azure/batch/) makes use of an orchestrator pool for copying data. The AzCopy tool is used for copying and removing data based on the previously mentioned tasks. AzCopy uses SAS tokens to perform copy or removal tasks. SAS tokens are stored in a key vault and are referenced by using `landingsaskey`, `archivesaskey`, and `rawsaskey`.

1. Call an API to update the datastream state: A web API call is made to update the state of the stream to `Copy Complete`. If the call succeeds, the sequence proceeds to the next activity. If the call fails, measurement is moved to the on-error activity.

1. Move the measurement to a landing archive: The measurement files are moved from the Landing storage account to a landing archive. This activity can rerun a particular measurement by moving it back to the Landing storage account via a hydrate copy pipeline. Lifecycle management is turned on for this zone so that measurements in this zone are automatically deleted or archived.

1. Handle errors: If an error occurred with a measurement, the measurement is moved to an error zone. From there, it can be moved to the Landing storage account to be rerun. Alternatively, it can be automatically deleted or archived by lifecycle management.

Note the following points:

- These pipelines are triggered based on a schedule. This approach helps to improve the traceability of pipeline runs and to avoid unnecessary runs.
- Each pipeline is configured with the concurrency set to one to make sure any previous runs finish before the next scheduled run starts.
- Each pipeline is configured to copy measurements in parallel. For instance, if a scheduled run picks up 10 measurements to copy, the previous sequence of steps can be run concurrently for all the measurements.
- Each pipeline is configured to generate an alert in Azure Monitor if the pipeline takes longer than the expected time to finish.
- The on-error activity is implemented in later observability stories.
- Lifecycle management automatically deletes partial measurements, for example, measurements with missing ROS bag files.

#### Batch design

All extraction logic is packaged in different container images, with one container for each extraction process. [Azure Batch](/azure/batch/) runs the container workloads in parallel when it extracts information from measurement files.

:::image type="content" source="images/azure-batch-design.png" alt-text="Diagram that shows how Azure Batch uses an orchestrator pool and an execution pool to access images from a container registry and run extraction jobs." border="false" lightbox="images/azure-batch-design.png":::

[Azure Batch](/azure/batch/) uses an orchestrator pool and an execution pool for processing workloads:

- An orchestrator pool has Linux nodes without container runtime support. The pool runs Python code that uses the [Azure Batch](/azure/batch/) API to create jobs and tasks for the execution pool. This pool also monitors those tasks. [Azure Data Factory](/azure/data-factory/introduction) invokes the orchestrator pool, which orchestrates the container workloads that extract data.
- An execution pool has Linux nodes with container run times to support running container workloads. For this pool, jobs and tasks are scheduled via the orchestrator pool. All the container images that are required for processing in the execution pool are pushed to a container registry by using JFrog. The execution pool is configured to connect to this registry and pull the required images.

Storage accounts that data is read from and written to are mounted via NFS 3.0 on to the batch nodes and the containers that run on the nodes. This approach helps batch nodes and containers process data quickly without having to download the data files locally to the batch nodes.

> [!NOTE]
> The batch and storage accounts need to be in the same virtual network for mounting.

#### Invoke Azure Batch from Data Factory

In the extraction pipeline, the trigger passes the path of the metadata file and the raw data stream path to the pipeline parameters. [Azure Data Factory](/azure/data-factory/introduction) uses a Lookup activity to parse the JSON from the manifest file. The raw datastream ID can be parsed from the raw data stream path by parsing the pipeline variable.

[Azure Data Factory](/azure/data-factory/introduction) calls an API to create a datastream. The API returns the path for the extracted datastream. The extracted path is added to the current object, and [Azure Data Factory](/azure/data-factory/introduction) invokes Azure Batch via a custom activity by passing the current object, after appending the extracted datastream path:

```json
{
"measurementId":"210b1ba7-9184-4840-a1c8-eb£397b7c686",
"rawDataStreamPath":"raw/2022/09/30/KA123456/210b1ba7-9184-4840-
alc8-ebf39767c68b/57472a44-0886-475-865a-ca32{c851207",
"extractedDatastreamPath":"extracted/2022/09/30/KA123456
/210bIba7-9184-4840-a1c8-ebf39767c68b/87404c9-0549-4a18-93ff-d1cc55£d8b78",
"extractedDataStreamId":"87404bc9-0549-4a18-93ff-d1cc55fd8b78"
}
```

#### Stepwise extraction process

:::image type="content" source="images/stepwise-extraction-process.png" alt-text="Architecture diagram that shows the steps of a job that extracts information from measurement data." border="false" lightbox="images/stepwise-extraction-process.png":::

1. [Azure Data Factory](https://azure.microsoft.com/products/data-factory) schedules a job with one task for the orchestrator pool to process a measurement for extraction. Data Factory passes the following information to the orchestrator pool:

   - The measurement ID
   - The location of the measurement files of type MDF4, TDMS, or ROS bag that need to be extracted
   - The destination path of the storage location of the extracted contents
   - The extracted datastream ID

1. The orchestrator pool invokes an API to update the datastream and set its status to `PROCESSING`.

1. The orchestrator pool creates a job for each measurement file that's part of the measurement. Each job contains the following tasks:

   | Task | Purpose | Note |
   | --- | --- | --- |
   | Validation | Validates that data can be extracted from the measurement file. | All other tasks depend on this task. |
   | Process metadata | Derives metadata from the measurement file and enriches the file's metadata by using an API to update the file's metadata. | |
   | Process `StructuredTopics` | Extracts structured data from a given measurement file. | The list of topics to extract structured data from is passed as a configuration object. |
   | Process `CameraTopics` | Extracts images data from a given measurement file. | The list of topics to extract images from is passed as a configuration object. |
   | Process `LidarTopics` | Extracts lidar data from a given measurement file. | The list of topics to extract lidar data from is passed as a configuration object. |
   | Process `CANTopics` | Extracts controller area network (CAN) data from a given measurement file. | The list of topics to extract data from is passed as a configuration object. |

1. The orchestrator pool monitors the progress of each task. After all the jobs finish for all measurement files, the pool invokes an API to update the datastream and set its status to `COMPLETED`.

1. The orchestrator exits gracefully.

   > [!NOTE]
   > Each task is a separate container image that has logic that's appropriately defined for its purpose. Tasks accept configuration objects as input. For example, this input specifies where to write the output and which measurement file to process. An array of topic types, such as `sensor_msgs/Image`, is another example of input. Because all other tasks depend on the validation task, a dependent task is created for it. All other tasks can be processed independently and can run in parallel.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- In your solution, consider using [Azure availability zones](https://azure.microsoft.com/global-infrastructure/availability-zones), which are unique physical locations within the same Azure region.
- Also, plan for disaster recovery and account [failover](https://learn.microsoft.com/azure/storage/common/storage-disaster-recovery-guidance?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&bc=%2Fazure%2Fstorage%2Fblobs%2Fbreadcrumb%2Ftoc.json).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

It's important to understand the division of responsibility between the automotive original equipment manufacturer (OEM) and Microsoft. In the vehicle, the OEM owns the whole stack, but as the data moves to the cloud, some responsibilities transfer to Microsoft. Azure platform as a service (PaaS) offerings provide built-in security on the physical stack, including the operating system. You can add the following capabilities to the existing infrastructure security components:

- Identity and access management that uses Azure Active Directory (Azure AD) identities and [Azure AD Conditional Access](https://learn.microsoft.com/azure/active-directory/conditional-access) policies
- Infrastructure governance that uses [Azure Policy](https://azure.microsoft.com/services/azure-policy)
- Data governance that uses [Microsoft Purview](https://azure.microsoft.com/services/purview)
- Encryption of data at rest that uses native Azure storage and database services. For more information, see [Data protection considerations](https://learn.microsoft.com/azure/well-architected/security/design-storage)
- The safeguarding of cryptographic keys and secrets that uses [Key Vault](https://azure.microsoft.com/services/key-vault)

### Cost optimization

Cost optimization looks at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](https://learn.microsoft.com/azure/architecture/framework/cost/overview).

A key concern for OEMs and tier 1 suppliers that operating DataOps for automated vehicles is the cost of operating. This solution uses the following practices to help optimize costs:

- Take advantage of various options that Azure offers for hosting your application code. This solution uses Azure App Service and Azure Batch. For guidance about how to choose the right service for your deployment, see [Choose an Azure compute service](https://learn.microsoft.com/azure/architecture/guide/technology-choices/compute-decision-tree).  
- Consider using [Azure Storage in-place data sharing](https://learn.microsoft.com/azure/purview/concept-data-share).
- Optimize costs by using [lifecycle management](https://learn.microsoft.com/azure/storage/blobs/lifecycle-management-overview).
- Save costs on Azure App Service by using [reserved instances](https://learn.microsoft.com/azure/cost-management-billing/reservations/prepay-app-service).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

- [Ryan Matsumura](https://www.linkedin.com/in/ryan-matsumura-4167257b/) | Senior Program Manager
- [Jochen Schroeer](https://www.linkedin.com/in/jochen-schroeer/) | Lead Architect (Service Line Mobility)
- [Ginette Vellera](https://www.linkedin.com/in/ginette-vellera-35523314/) | Senior Software Engineering Lead
- [Brij Singh](https://www.linkedin.com/in/brijraajsingh/) | Principal Software Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [What is Azure Batch?](/azure/batch/batch-technical-overview)
- [Azure Data Factory documentation](/azure/data-factory/)
- [What is Azure Data Share?](/azure/data-share/overview)
- [Large-scale Data Operations Platform for Autonomous Vehicles](https://devblogs.microsoft.com/cse/2023/03/02/large-scale-data-operations-platform-for-autonomous-vehicles/)

## Related resources

- [AVOps design guide](../../guide/machine-learning/avops-design-guide.md)
- [Data analytics for automotive test fleets](../../industries/automotive/automotive-telemetry-analytics.yml)
- [Building blocks for autonomous-driving simulation environments](../../industries/automotive/building-blocks-autonomous-driving-simulation-environments.yml)
- [Building blocks for autonomous-driving simulation environments](../../industries/automotive/building-blocks-autonomous-driving-simulation-environments.yml)
- [Process real-time vehicle data using IoT](../data/realtime-analytics-vehicle-iot.yml)

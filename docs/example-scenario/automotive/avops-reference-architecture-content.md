
This architecture provides guidance on the building blocks and recommendations for developing an automated driving solution.
## Architecture

![AVOps Reference architecture.](.\images\high-level-architecture-avops.png)

### Dataflow
Here's the high-level process flow of data through the reference architecture:
1. Measurement data include different data streams for different sensors such as camera, radar, ultrasound, lidar and vehicle telemetry.  Data loggers in the vehicle, stores the measurement data on the logger storage device.   The logger storage data is then uploaded to the landing data lake. Ingestion to Azure could be via [Azure Data Box](https://learn.microsoft.com/azure/databox/), [Azure Stack Edge](https://learn.microsoft.com/azure/databox-online/) or through a dedicated connection such as [Azure ExpressRoute](https://learn.microsoft.com/azure/expressroute/).  

    Measurements could also be synthetic data from simulations or from any other source (the common data formats for measurements are MDF4, TDMS and Rosbag). The DataOps stage processes ingested measurements to validate and perform data quality checks (e. g. checksum) to remove low quality data. The DataOps stage extracts raw information meta-data recorded by a test driver along a test drive and stores the information in a centralized meta-data catalog.  This information helps downstream processes to identify specific scenes and sequences
1. Data then goes through an extract, transform, load (ETL) pipeline with [Azure Data Factory](https://learn.microsoft.com/azure/data-factory/introduction) where the output stores Raw and binary data on [Azure Data Lake Gen2](https://learn.microsoft.com/azure/storage/blobs/data-lake-storage-introduction). The DataOps stage stores meta-data in [Azure Cosmos DB](https://docs.microsoft.com/azure/cosmos-db) (depending on final scenario extended by [Azure Data Explorer](https://docs.microsoft.com/azure/data-explorer/data-explorer-overview) and [Azure Cognitive Search](https://learn.microsoft.com/azure/cognitive-services/))
1. Data enrichment helps improve the accuracy and reliability of the data by adding additional information, insights and context to the data collected.
1. The DataOps stage takes extracted measurement data and provides them to labeling partners (Human in the Loop) via [Azure Data Share](https://learn.microsoft.com/azure/data-share/). Auto Labeling (covered by third party partners) stores accesses data via a separate Data Lake account (“Label Lake”)
1. The DataOps stage takes labeled datasets and provides them to downstream [MLOps](#mlops) processes, mainly to create a perception and sensor fusion models.   These models perform functions used by autonomous vehicles to detect scenes (that is, lane change, blocked roads, pedestrian, traffic lights, and traffic signs)
1. [ValOps](#valops) takes trained models and validates them via Open Loop and Closed Loop testing
1. Tools such as [Foxglove](https://foxglove.dev/) running on [Azure Kubernetes Service](https://learn.microsoft.com/azure/aks/intro-kubernetes) or [Azure Container Instances](https://learn.microsoft.com/azure/container-instances/) visualizes  ingested and processed data 
### Data Collection
The Collection image shows an example scenario of an offline/online collection of vehicle data to a data lake.  

![Data Collection](.\images\data-collection.png)
### Data Operations (DataOps)
DataOps are a set of practices, processes, and tools aimed at improving the quality, speed, and reliability of data operations.  The goal of the DataOps flow for autonomous driving is to ensure that the data used to control the vehicle is of high quality, accurate, and reliable. By following a consistent DataOps flow, organizations can improve the speed and accuracy of their data operations and make better decisions to control their autonomous vehicles.  
#### DataOps Components
* [Azure Data Box](https://learn.microsoft.com/azure/databox/) used to transfer collected vehicle data to Azure through a regional carrier
* [Azure ExpressRoute](https://learn.microsoft.com/azure/expressroute/) extends on-premises network into the Microsoft cloud over a private connection
* [Azure Data Lake Gen2](https://learn.microsoft.com/azure/storage/blobs/data-lake-storage-introduction) used to data per stages (for example, raw, extracted)
* [Azure Data Factory](https://learn.microsoft.com/azure/data-factory/introduction) orchestrated data flow, performs ETL through [batch compute](https://learn.microsoft.com/azure/batch/), and data integration service that creates data-driven workflows for orchestrating data movement and transforming data 
* [Azure Batch](https://learn.microsoft.com/azure/batch/) runs large-scale applications such as for data wrangling, filtering and preparation of data, and metadata extraction
* [Azure Cosmos DB](https://docs.microsoft.com/azure/cosmos-db) used to store metadata results such as stored measurement
* [Azure Data Share](https://learn.microsoft.com/azure/data-share/) shares data with third party organizations such as labeling companies in a safe and secure manner
* [Azure Databricks](https://learn.microsoft.com/azure/databricks/) provides a set of tool to maintain enterprise-grade data solutions at scale. Required for long-running operations on large amounts of vehicle data.  Used as an analytics workbench for a Data Engineer
* [Azure Synapse](https://learn.microsoft.com/azure/synapse-analytics/overview-what-is) accelerates time to insight across data warehouses and big data systems.
* [Azure Cognitive Search](https://learn.microsoft.com/azure/cognitive-services/) - Provides the data catalog search services
### Machine Learning Operations (MLOps)
AVOps reference architecture utilizes MLOps in several places of the reference architecture.  AVOps utilizes MLOps when machine learning comes into the picture:
- Feature Extraction Models (like CLIP, YOLO) to classify scenes (for example, if pedestrian is part of the scene) during [DataOps](#dataops) pipeline 
- Auto Labeling Models to label ingested images / pictures, lidar and radar data 
- Perception and Computer Vision Models to detect objects and scenes
- Sensor Fusions Model that combines different sensor streams 
One of the main parts of the AVOps reference architecture is the development of the Azure Machine Learning based perception model that generates object detection model based on detected and extracted scenes. 

Transfer of containerized machine learning model to a format understood by SoC (system on a chip) hardware and validation / simulation software requires an extra step in the MLOps pipeline that needs support from SoC manufacturers.
#### MLOps Components
* [Azure Machine Learning](https://learn.microsoft.com/azure/machine-learning/overview-what-is-azure-machine-learning) used to develop machine learning algorithms such as feature extraction, auto labeling, object detection and classification, and sensor fusion.  
* [Azure DevOps](https://learn.microsoft.com/azure/devops/user-guide/what-is-azure-devops?view=azure-devops) used as the main tool for DevOps practice that includes CI/CD, testing and automation.
* [GitHub for Enterprises](https://github.com/enterprise) as an alternative as the main tool for DevOps practice that includes CI/CD, testing and automation.
* [Azure Container Registry](https://learn.microsoft.com/azure/container-registry/) allows you to build, store, and manage container images and artifacts in a private registry for all types of container deployments
### Validation Operations (ValOps)

ValOps involve testing the developed models in simulated environments via [managed scenarios](#scenario-management) to ensure they meet desired performance standards, accuracy, and safety requirements before expensive real-world environmental testing. The goal of the validation process in the cloud is to identify and address any potential issues before deploying the autonomous vehicle in a live environment. ValOps include:

1. Simulation validation: Cloud-based simulation ([Open Loop](#open-loop-testing)/[Closed Loop Testing](#closed-loop-testing-and-simulation)) environments allow for virtual testing of autonomous vehicle models, which runs at scale and at a lower cost than real-world testing.
1. Performance validation: Cloud-based infrastructure can run large-scale tests to evaluate the performance of autonomous vehicle models. Performance validation can include stress tests, load tests, and benchmarks.

In general, using the AVOps - ValOps reference for validation allows organizations to take advantage of the scalability, flexibility, and cost-effectiveness of cloud-based infrastructure, while also speeding up the time-to-market for autonomous vehicle models.
#### Open Loop testing
Re-Simulation can be considered an open loop test for automatic driving and is a complex process that may have regulatory requirements for safety, data privacy, data versioning and auditing. Resimulation is an open loop test and validation system for AD functions. It processes recorded raw data from various car sensors through a graph in the cloud. The produced result from resimulation validates data processing algorithms or detect regressions. The OEMs combine the sensors together into a Directed acyclic graph that represents the real-world vehicle.
Resimulation or “sensor reprocessing” is a large-scale  parallel compute job. Resiumulation processes 10 s~100-s PBs of data using tens of thousands of cores and requiring high I/O throughput of >30GB/sec. Datasets fused from multiple sensor types to represent a singular view of what the on-vehicle computer vision systems “saw” when navigating the real world. An open loop test validates the performance of the algorithms against ground truth using replay and scoring. The output is used later in the workflow for algorithm training:
- Datasets sourced from test fleet vehicles that collect raw sensor data (for example, camera, lidar, radar, ultrasonic)
- Data volume is highly dependent on camera resolution and number of sensors on vehicle
- Re-Processing of Raw Data against different software releases of the devices
- Raw sensor data is directly sent to the sensor input interface of the sensor-software
- Output is compared with the output of previous SW-versions and is checked against bug fixing or new features like detecting new object types
- A second “reinjection” or “rerun” of the job increasingly performed after model & software are updated
- Ground truth data is used to validate the results
- Results are written to Storage and offloaded to Azure Data Explorer (for visualization)
#### Closed Loop testing and simulation
Closed loop testing of autonomous vehicles refers to testing their capabilities with real-time feedback from the environment. In other words, the vehicle's actions are based on both its pre-programmed behavior and the dynamic conditions it's encountering, and it adjusts its actions accordingly. Closed loop testing executes in a more complex and realistic environment and used to assess the vehicle's ability to handle real-world scenarios, including dealing with unexpected situations. The goal of closed loop testing is to verify that the vehicle can operate safely and effectively in various conditions, and to refine its control algorithms and decision-making processes as needed.

ValOps pipeline integrates Closed-Loop testing and simulations third party and ISV applications.
#### Scenario Management 
The ValOps stage uses a catalog of specific real scenarios to validate the AD capabilities to simulate the behavior of AVs. The objective is to accelerate the creation of scenario catalogs, by automatically reading the route network, which is a part of a scenario, from publicly accessible and freely available digital maps. Use third party tools for Scenario Management or as an alternative use an OSS lightweight project like CARLA that also supports [OPENDrive (xodr) format](https://www.asam.net/standards/detail/opendrive/), see [carla-simulator/scenario_runner: Traffic scenario definition and execution engine](https://github.com/carla-simulator/scenario_runner).
#### ValOps Components
* [Azure Kubernetes Service](https://learn.microsoft.com/azure/aks/intro-kubernetes) runs large-scale applications batch inference for open-loop validation within a resin framework. For access measurement files, recommended using [BlobFuse2](https://learn.microsoft.com/azure/storage/blobs/blobfuse2-what-is).  Alternative is to use NFS but performance needs to evaluated for the use case.
* [BlobFuse2](https://learn.microsoft.com/azure/storage/blobs/blobfuse2-what-is)
* [Azure Batch](https://learn.microsoft.com/azure/batch/) runs large-scale applications batch inference for open-loop validation within a resin framework
* [Azure Data Explorer](https://docs.microsoft.com/azure/data-explorer/data-explorer-overview) provides exploration of measurements and KPI (that is, resimulation and job runs).
### Centralized AVOps Functions
Building autonomous vehicle operations is a complex architecture that includes many organizations, third parties, various roles, and various stages in the development.  Thus, implementing a good governance model is imperative. 

It's also recommended that a centralized team in an organization handles functions such as Infrastructure Provisioning, Cost Management, Metadata and Data Catalog, Lineage, Overall Orchestration and Event Handling.  Centralizing these services creates efficiency and easing of operations.  This architecture assumes these responsibilities from the centralized teams.  

For that reason, AVOps recommends a centralized team in an organization handling a set of these responsibilities:
- Providing Azure Resource Manager / Bicep templates incl. standard services like storage and compute used by each area and subarea of the AVOps reference architecture 
- Central Service Bus / Event Hubs instances allows an event driven orchestration of the AVOps data loop 
- Meta-Data Catalog 
- Capabilities for E2E lineage and traceability across all AVOps components 

![Centralized AVOps Functions](.\images\centralized-avops-functions.png)
### Potential use cases

- Automotive OEMs, Tier1s, and/or ISVs that are developing solutions for automated driving 

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

It's important to understand the division of responsibility between the automotive OEM and Microsoft. In the vehicle, the OEM owns the whole stack, but as the data moves to the cloud, some responsibilities transfer to Microsoft. Azure platform-as-a-service (PaaS) provides built-in security on the physical stack, including the operating system. You can apply the following capabilities on top of the infrastructure security components.  These points drive a Zero Trust Strategy

* Private endpoints for network security. For more information, see [Private endpoints for Azure Data Explorer](https://learn.microsoft.com/azure/data-explorer/security-network-private-endpoint) and [Allow access to Azure Event Hubs namespaces via private endpoints](https://learn.microsoft.com/azure/event-hubs/private-link-service).
* Encryption at rest and in transit, see [Azure Encryption Overview](https://learn.microsoft.com/azure/security/fundamentals/encryption-overview)
* Identity and access management that uses Azure Active Directory (Azure AD) identities and [Azure AD Conditional Access](https://learn.microsoft.com/azure/active-directory/conditional-access) policies.
* [Row Level Security (RLS)](https://learn.microsoft.com/azure/active-directory/conditional-access) for Azure Data Explorer.
* Infrastructure governance that uses [Azure Policy](https://azure.microsoft.com/services/azure-policy).
* Data governance that uses [Microsoft Purview](https://azure.microsoft.com/services/purview).
* Securing the connection of the vehicles - [certificate management](https://learn.microsoft.com/azure/iot-hub/iot-hub-x509-certificate-concepts)
* Use least privilege access: Limit user access with Just-In-Time and Just-Enough-Access ([JIT](https://learn.microsoft.com/azure/defender-for-cloud/just-in-time-access-usage)/[JEA](https://learn.microsoft.com/powershell/scripting/learn/remoting/jea/overview?view=powershell-7.3), risk-based adaptive policies, and data protection

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

There are several strategies that organizations can use to reduce costs associated with autonomous driving development:

1. Optimize cloud infrastructure: Careful planning and management of cloud infrastructure can help reduce costs, such as choosing cost-effective instance types and scaling infrastructure to meet changing workloads. Utilize the guidance from the [Azure Cloud Adoption Framework](https://learn.microsoft.com/azure/cloud-adoption-framework/).
1. Use spot instances: Spot instances allow organizations to bid on spare capacity, which can result in significant cost savings compared to on-demand instances.
1. Utilize auto-scaling: Auto-scaling enables organizations to automatically adjust their cloud infrastructure based on demand, reducing the need for manual intervention and helping to keep costs in check. For more information about scaling, see [Design Scaling](https://learn.microsoft.com/azure/architecture/framework/scalability/design-scale).
1. Utilize cost-effective storage: Organizations must consider how  using hot/cool/archive tiers for storage.  Storage can be a significant cost for autonomous driving development, so it's important to choose cost-effective storage options, such as cold storage or infrequent access storage. For more information of data lifecycle management, see [data lifecycle management](https://learn.microsoft.com/azure/storage/blobs/lifecycle-management-overview)
1. Utilize cost management and optimization tools: [Azure Cost Management](https://azure.microsoft.com/products/cost-management/#overview) provides cost management and optimization tools that can help organizations identify and address areas for cost reduction, such as identifying unused or underutilized resources.
1. Consider Azure Services: Organizations can use Azure services, such as [Azure Machine Learning](https://learn.microsoft.com/azure/machine-learning/overview-what-is-azure-machine-learning) to build and train autonomous driving models, which can be more cost-effective than building and maintaining in-house infrastructure.
1. Use shared resources: When possible, organizations can use shared resources, such as shared databases or shared compute resources, to reduce costs associated with autonomous driving development.  [AVOps Centralized Functions](#centralized-avops-functions) aims to solve this challenge by implementing a central bus, event hub and a Meta-Data Catalog.  In addition, services such as [Azure Data Share](https://learn.microsoft.com/azure/data-share/) help organizations achieve this goal.

By following these strategies, organizations can reduce the costs associated with autonomous driving development in the cloud, freeing up resources that organizations can use to further enhance the development process.

### Contributors 
*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

 - [Ryan Matsumura](https://www.linkedin.com/in/ryan-matsumura-4167257b/) | Senior Program Manager
 - [Jochen Schroeer](https://www.linkedin.com/in/jochen-schroeer/) | Lead Architect (Service Line Mobility)

Other contributors: 

 - [David Peterson](https://www.linkedin.com/in/david-peterson-64456021/) | Chief Architect
 - [Gabriel Sallah](https://www.linkedin.com/in/gabrielsallah/) | HPC/AI Global Black Belt Specialist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related resources

Related architecture guides:

* [Data analytics for automotive test fleets](https://learn.microsoft.com/azure/architecture/industries/automotive/automotive-telemetry-analytics)

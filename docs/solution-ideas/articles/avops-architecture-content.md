[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture provides guidance and recommendations for developing an automated driving solution.

## Architecture

:::image type="content" source="../media/high-level-architecture.png" alt-text="Diagram that shows an AVOps architecture." lightbox="../media/high-level-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/avops-design-and-architecture.vsdx) that contains the architecture diagrams in this article.*

### Dataflow

1. Measurement data comes from data streams for sensors like cameras, radar, ultrasound, lidar, and vehicle telemetry. Data loggers in the vehicle store measurement data on logger storage devices. The logger storage data is then uploaded to the landing data lake. A service like [Azure Data Box](/azure/databox/) or [Azure Stack Edge](/azure/databox-online/), or a dedicated connection like [Azure ExpressRoute](/azure/expressroute/), ingests data into Azure.

    Measurement data can also be synthetic data from simulations or from other sources. (MDF4, TDMS, and rosbag are common data formats for measurements.) In the DataOps stage, ingested measurements are processed. Validation and data quality checks, like checksum, are performed to remove low quality data. In this stage, raw information metadata that's recorded by a test driver during a test drive is extracted. This data is stored in a centralized metadata catalog. This information helps downstream processes identify specific scenes and sequences.
1. Data is processed by an [Azure Data Factory](/azure/data-factory/introduction) extract, transform, and load (ETL) pipeline. The output is stored as raw and binary data in [Azure Data Lake](/azure/storage/blobs/data-lake-storage-introduction). Metadata is stored in [Azure Cosmos DB](/azure/cosmos-db). Depending on the scenario, it might then be sent to [Azure Data Explorer](/azure/data-explorer/data-explorer-overview) or [Azure Cognitive Search](/azure/cognitive-services/).
1. Additional information, insights, and context are added to the data to improve its accuracy and reliability.
1. Extracted measurement data is provided to labeling partners (human-in-the-loop) via [Azure Data Share](/azure/data-share/). Third-party partners perform auto labeling, storing and accessing data via a separate Data Lake account.
1. Labeled datasets flow to downstream [MLOps](#mlops) processes, mainly to create perception and sensor fusion models. These models perform functions that are used by autonomous vehicles to detect scenes (that is, lane changes, blocked roads, pedestrians, traffic lights, and traffic signs).
1. In the [ValOps](#valops) stage, trained models are validated via open-loop and closed-loop testing.
1. Tools like [Foxglove](https://foxglove.dev/), running on [Azure Kubernetes Service](/azure/aks/intro-kubernetes) or [Azure Container Instances](/azure/container-instances/), visualize ingested and processed data. 

### Data collection

Data collection is one of the main [challenges](../../guide/machine-learning/avops-design-guide.md#challenges) of Autonomous Vehicles Operations (AVOps). The following diagram shows an example of how offline and online vehicle data can be collected and stored in a data lake.

:::image type="content" source="..\media\data-collection.png" alt-text="Diagram that shows offline and online data collection." lightbox="..\media\data-collection.png" border="false":::

### DataOps

Data operations (DataOps) is a set of practices, processes, and tools for improving the quality, speed, and reliability of data operations. The goal of the DataOps flow for autonomous driving (AD) is to ensure that the data used to control the vehicle is of high quality, accurate, and reliable. By using a consistent DataOps flow, you can improve the speed and accuracy of your data operations and make better decisions to control your autonomous vehicles.  

#### DataOps components

* [Data Box](https://azure.microsoft.com/products/databox) is used to transfer collected vehicle data to Azure via a regional carrier.
* [ExpressRoute](https://azure.microsoft.com/products/expressroute) extends the on-premises network into the Microsoft cloud over a private connection.
* [Azure Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage) stores data based on stages, for example, raw or extracted.
* [Azure Data Factory](https://azure.microsoft.com/products/data-factory) performs ETL via [batch compute](/azure/batch/) and creates data-driven workflows for orchestrating data movement and transforming data.
* [Azure Batch](https://azure.microsoft.com/products/batch) runs large-scale applications for tasks like data wrangling, filtering and preparing data, and extracting metadata.
* [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db) stores metadata results, like stored measurements.
* [Data Share](https://azure.microsoft.com/products/data-share/) is used to share data with partner organizations, like labeling companies, with enhanced security.
* [Azure Databricks](https://azure.microsoft.com/products/databricks/) provides a set of tools for maintaining enterprise-grade data solutions at scale. It's required for long-running operations on large amounts of vehicle data. Data engineers use Azure Databricks as an analytics workbench.
* [Azure Synapse Analytics](https://azure.microsoft.com/products/synapse-analytics/) reduces time to insight across data warehouses and big data systems.
* [Azure Cognitive Search](https://azure.microsoft.com/products/search) provides data catalog search services.

### MLOps

Machine learning operations (MLOps) include:

- Feature extraction models (like CLIP and YOLO) for classifying scenes (for example, whether a pedestrian is in the scene) during the [DataOps](#dataops) pipeline.
- Auto labeling models for labeling ingested images and lidar and radar data. 
- Perception and computer vision models for detecting objects and scenes.
- A sensor fusion model that combines sensor streams.

The perception model is an important component of this architecture. This Azure Machine Learning model generates an object detection model by using detected and extracted scenes.

The transfer of the containerized machine learning model to a format that can be read by system on a chip (SoC) hardware and validation/simulation software occurs in the MLOps pipeline. This step requires the support of the SoC manufacturer.

#### MLOps components

* [Azure Machine Learning](https://azure.microsoft.com/products/machine-learning) is used to develop machine learning algorithms, like feature extraction, auto labeling, object detection and classification, and sensor fusion.  
* [Azure DevOps](https://azure.microsoft.com/products/devops) provides support for DevOps tasks like CI/CD, testing, and automation.
* [GitHub for enterprises](https://github.com/enterprise) is an alternative choice for DevOps tasks like CI/CD, testing, and automation.
* [Azure Container Registry](https://azure.microsoft.com/products/container-registry) enables you to build, store, and manage container images and artifacts in a private registry.

### ValOps

Validation operations (ValOps) is the process of testing developed models in simulated environments via [managed scenarios](#scenario-management) before you perform expensive real-world environmental testing. ValOps tests help to ensure that the models meet your desired performance standards, accuracy standards, and safety requirements. The goal of the validation process in the cloud is to identify and address any potential issues before you deploy the autonomous vehicle in a live environment. ValOps includes:

- Simulation validation. Cloud-based simulation ([open-loop](#open-loop-testing) and [closed-loop testing](#closed-loop-testing-and-simulation)) environments enable virtual testing of autonomous vehicle models. This testing runs at scale and is less expensive than real-world testing.
- Performance validation. Cloud-based infrastructure can run large-scale tests to evaluate the performance of autonomous vehicle models. Performance validation can include stress tests, load tests, and benchmarks.

Using ValOps for validation can help you take advantage of the scalability, flexibility, and cost-effectiveness of a cloud-based infrastructure and reduce time-to-market for autonomous vehicle models.

#### Open-loop testing

Re-simulation, or *sensor processing*, is an open-loop test and validation system for automatic driving functions. It's a complex process, and there might be regulatory requirements for safety, data privacy, data versioning, and auditing. Re-simulation processes recorded raw data from various car sensors via a graph in the cloud. Re-simulation validates data processing algorithms or detects regressions. OEMs combine sensors in a directed acyclic graph that represents a real-world vehicle.

Re-simulation is a large-scale  parallel compute job. It processes tens or hundreds of PBs of data by using tens of thousands of cores. It requires I/O throughput of more than 30 GB/s. Data from multiple sensors is combined into datasets that represent a view of what the on-vehicle computer vision systems record when the vehicle navigates the real world. An open-loop test validates the performance of the algorithms against ground truth by using replay and scoring. The output is used later in the workflow for algorithm training.

- Datasets are sourced from test fleet vehicles that collect raw sensor data (for example, camera, lidar, radar, and ultrasonic data).
- Data volume depends on camera resolution and the number of sensors on the vehicle.
- Raw data is re-processed against different software releases of the devices.
- Raw sensor data is sent to the sensor input interface of the sensor software.
- Output is compared with the output of previous software versions and is checked against bug fixes or new features, like detecting new object types.
- A second re-injection of the job is performed after the model and software are updated.
- Ground truth data is used to validate the results.
- Results are written to storage and offloaded to Azure Data Explorer for visualization.

#### Closed-loop testing and simulation

Closed-loop testing of autonomous vehicles is the process of testing vehicle capabilities while including real-time feedback from the environment. The vehicle's actions are based both on its pre-programmed behavior and on the dynamic conditions that it encounters, and it adjusts its actions accordingly. Closed-loop testing runs in a more complex and realistic environment. It's used to assess the vehicle's ability to handle real-world scenarios, including how it reacts to unexpected situations. The goal of closed-loop testing is to verify that the vehicle can operate safely and effectively in various conditions, and to refine its control algorithms and decision-making processes as needed.

The ValOps pipeline integrates closed-loop testing, third-party simulations, and ISV applications.

#### Scenario management 

During the ValOps stage, a catalog of real scenarios is used to validate the autonomous driving solution's ability to simulate the behavior of autonomous vehicles. The objective is to speed up the creation of scenario catalogs by automatically reading the route network, which is a part of a scenario, from publicly accessible and freely available digital maps. Use third-party tools for scenario management or a lightweight open source simulator like CARLA, which supports [OpenDRIVE (xodr) format](https://www.asam.net/standards/detail/opendrive/). For more information, see [ScenarioRunner for CARLA](https://github.com/carla-simulator/scenario_runner).

#### ValOps components

* [Azure Kubernetes Service](https://azure.microsoft.com/products/kubernetes-service) runs large-scale batch inference for open-loop validation within a Resin framework. We recommend that you use [BlobFuse2](/azure/storage/blobs/blobfuse2-what-is) to access the measurement files. You can also use NFS, but you need to evaluate performance for the use case.
* [Azure Batch](https://azure.microsoft.com/products/batch) runs large-scale batch inference for open-loop validation within a Resin framework.
* [Azure Data Explorer](https://azure.microsoft.com/products/data-explorer) provides an analytics service for measurements and KPIs (that is, re-simulation and job runs).

### Centralized AVOps functions

An AVOps architecture is complex and involves various third parties, roles, and development stages, so it's important to implement a good governance model. 

We recommend that you create a centralized team to handle functions like infrastructure provisioning, cost management, the metadata and data catalog, lineage, and overall orchestration and event handling. Centralizing these services is efficient and simplifies operations.  

We recommend that you use a centralized team to handle these responsibilities:

- Providing ARM/Bicep templates, including templates for standard services like storage and compute used by each area and subarea of the AVOps architecture 
- Implementation of central Azure Service Bus / Azure Event Hubs instances for an event-driven orchestration of the AVOps data loop
- Ownership of the metadata catalog
- Capabilities for end-to-end lineage and traceability across all AVOps components 

![Diagram that shows centralized AVOps functions.](..\media\centralized-avops-functions.png)

## Scenario details

You can use this architecture to build an automated driving solution on Azure.

### Potential use cases

Automotive OEMs, Tier 1 vendors, and ISVs that develop solutions for automated driving. 

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

It's important to understand the division of responsibility between the automotive OEM and the cloud provider. In the vehicle, the OEM owns the whole stack, but as the data moves to the cloud, some responsibilities transfer to the cloud provider. Azure platform as a service (PaaS) provides built-in improved security on the physical stack, including the operating system. You can apply the following improvements in addition to the infrastructure security components. These improvements enable a Zero-Trust approach.

* Private endpoints for network security. For more information, see [Private endpoints for Azure Data Explorer](/azure/data-explorer/security-network-private-endpoint) and [Allow access to Azure Event Hubs namespaces via private endpoints](/azure/event-hubs/private-link-service).
* Encryption at rest and in transit. For more information, see [Azure encryption overview](/azure/security/fundamentals/encryption-overview).
* Identity and access management that uses Azure Active Directory (Azure AD) identities and [Azure AD conditional access](/azure/active-directory/conditional-access) policies.
* [Row Level Security (RLS)](/azure/active-directory/conditional-access) for Azure Data Explorer.
* Infrastructure governance that uses [Azure Policy](https://azure.microsoft.com/services/azure-policy).
* Data governance that uses [Microsoft Purview](https://azure.microsoft.com/services/purview).
* [Certificate management](/azure/iot-hub/iot-hub-x509-certificate-concepts) to help secure the connection of vehicles.
* Least privilege access. Limit user access with Just-In-Time ([JIT](/azure/defender-for-cloud/just-in-time-access-usage)) and Just-Enough-Administration ([JEA](/powershell/scripting/learn/remoting/jea/overview?view=powershell-7.3)), risk-based adaptive policies, and data protection.

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

You can use these strategies to reduce the costs that are associated with developing autonomous driving solutions:

- Optimize cloud infrastructure. Careful planning and management of cloud infrastructure can help you reduce costs. For example, use cost-effective instance types and scale infrastructure to meet changing workloads. Follow the guidance in the [Azure Cloud Adoption Framework](/azure/cloud-adoption-framework/).
- Use [Spot Virtual Machines](/azure/virtual-machines/spot-vms). You can determine which workloads in your AVOps deployment don't require processing within a specific time frame and use Spot Virtual Machines for these workloads. Spot Virtual Machines allows you to take advantage of unused Azure capacity for significant cost savings. If Azure needs the capacity back, the Azure infrastructure evicts spot virtual machines.
- Use autoscaling. Autoscaling enables you to automatically adjust your cloud infrastructure based on demand, reducing the need for manual intervention and helping you reduce costs. For more information, see [Design for scaling](/azure/architecture/framework/scalability/design-scale).
- Consider using hot, cool, and archive tiers for storage. Storage can be a significant cost in an autonomous driving solution, so you need to choose cost-effective storage options, like cold storage or infrequent-access storage. For more information, see [data lifecycle management](/azure/storage/blobs/lifecycle-management-overview).
- Use cost management and optimization tools. [Microsoft Cost Management](https://azure.microsoft.com/products/cost-management/) provides tools that can help you identify and address areas for cost reduction, like unused or underutilized resources.
- Consider using Azure services. For example, you can use [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) to build and train autonomous driving models. Using these services can be more cost-effective than building and maintaining in-house infrastructure.
- Use shared resources. When possible, you can use shared resources, like shared databases or shared compute resources, to reduce the costs that are associated with autonomous driving development. The [centralized functions](#centralized-avops-functions) in this architecture, for example, implement a central bus, event hub, and metadata catalog. Services like [Azure Data Share](/azure/data-share/) can also help you achieve this goal.

## Contributors 

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

 - [Ryan Matsumura](https://www.linkedin.com/in/ryan-matsumura-4167257b/) | Senior Program Manager
 - [Jochen Schroeer](https://www.linkedin.com/in/jochen-schroeer/) | Lead Architect (Service Line Mobility)

Other contributors: 

 - [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer 
 - [David Peterson](https://www.linkedin.com/in/david-peterson-64456021/) | Chief Architect
 - [Gabriel Sallah](https://www.linkedin.com/in/gabrielsallah/) | HPC/AI Global Black Belt Specialist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [What is Azure Batch?](/azure/batch/batch-technical-overview)
- [Azure Data Factory documentation](/azure/data-factory/)
- [What is Azure Data Share?](/azure/data-share/overview)

## Related resources

For more information about developing DataOps for an automated driving system, see:
> [!div class="nextstepaction"]
> [Data operations for autonomous vehicle operations](../../example-scenario/automotive/autonomous-vehicle-operations-dataops.yml)

You might also be interested in these related articles:
* [AVOps design guide](../../guide/machine-learning/avops-design-guide.md)
* [Data analytics for automotive test fleets](../../industries/automotive/automotive-telemetry-analytics.yml)
* [Building blocks for autonomous-driving simulation environments](../../industries/automotive/building-blocks-autonomous-driving-simulation-environments.yml)

This article presents a solution and guidance for developing a Validation Operations (ValOps) for Advanced Driving Assistance Systems (ADAS) and Autonomous Driving (AD). The ValOps solution is built on the framework outlined in [Autonomous vehicle operations (AVOps) design guide](../../guide/machine-learning/avops-design-guide.md). ValOps is one of the building blocks of AVOps.  Other building blocks include [DataOps](./autonomous-vehicle-operations-dataops-content.md), machine learning operations (MLOps), DevOps and centralized AVOps functions (see related articles).  In addition, the approach in this article utilizes the [Software defined vehicle DevOps toolchain Reference Architecture](../../industries/automotive/software-defined-vehicle-reference-architecture-content.md) to provide an end-to-end automated driving stack that can orchestrate testing required for automated driving.  

## Architecture

:::image type="content" source="./images/autonomous-vehicle-operations-valops-architecture.png" alt-text="Architecture diagram that shows a solution for validating autonomous vehicle software." border="false" lightbox="./images/autonomous-vehicle-operations-valops-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/autonomous-vehicle-operations-valops.vsdx) that contains the architecture diagrams in this article.*

Validation of AD/ADAS functionalities are structured into three main workflows:
- [Open Loop Testing (Resimulation or Recompute)](../../solution-ideas/articles/avops-architecture-content.md#open-loop-testing) 
- [Closed Loop Testing Simulation](../../solution-ideas/articles/avops-architecture-content.md#closed-loop-testing-and-simulation)
- [Scenario Management](../../solution-ideas/articles/avops-architecture-content.md#scenario-management)

Open Loop and Closed Loop validation typically has a SiL (Software-in-the-loop) and HiL (Hardware-in-the-loop) flavor. The latter validates the stack (e. g. perception stack) with real vehicle hardware.

To validate the AD capabilities (Open Loop, Close Loop), a catalog of specific real scenarios is required that is used to simulate the behavior of vehicles. The objective is to accelerate the creation of scenario catalogs, by automatically reading the route network, which is a part of a scenario, from publicly accessible and freely available digital maps. As part of the reference architecture open formats like OPENDrive (xodr) should be supported. Based on customer’s partner selection tools from Cognata, Ansys, dSPACE, or others that are used for Scenario Management. CARLA can be considered as OSS lightweight alternative that also supports OPENDrive format, see carla-simulator/scenario_runner: Traffic scenario definition and execution engine (github.com).

- Trained Perception Stack for AD / ADAS functions are converted and integrated to vehicle software artifacts 
- Scenarios are imported and created in Scenario Mgmt. Tool
- Open Loop and Closed Loop simulations are executed on Azure HPC infrastructure (Azure Batch or Azure Kubernetes Service)
- Results are generated and output to Azure Data Explorer for interactive analysis 

### Open Loop Testing Dataflow

Re-Simulation (or Recompute) is massively complex and requires years of development. Seeking government approval of Autonomous Driving (AD) raises strict requirements in areas such as safety, data privacy, data versioning and auditing. It can be considered an open loop test and validation system for AD functions. It processes recorded raw data from various car sensors through a graph in the cloud. The produced result can then be used to validate data processing algorithms or detect regressions. The OEMs combine the sensors together into a Directed acyclic graph that represents the real-world vehicle.
Resimulation or “sensor reprocessing” is typically a large-scale parallel compute job.  Resimulation processes 10~100s PBs of data using tens of thousands of cores and requiring high I/O throughput of >30GB/sec. Data sets are fused from multiple sensor types representing a singular view of what the on-vehicle computer vision systems “saw” when navigating the real world. An open loop test is where the performance of the algorithms is tested & validated against ground truth using replay and scoring. The output is used later in the workflow for algorithm training:
- Data sets sourced from test fleet vehicles that collect raw sensor data (for example, camera, lidar, radar, etc.) or synthetically from simulators
- Data volume is highly dependent on camera resolution and number of sensors on vehicle
- Re-Processing of Raw Data against different software releases of the devices (e. g. perception) 
- Raw sensor data is directly sent to the sensor input interface of the sensor-software
- Output is compared with the output of previous SW-versions and is checked against bug fixing or new features like detecting new object types
- A second “reinjection” or “rerun” of the job increasingly performed after model & software are updated
- Ground truth data is used to validate the results
- Results are written to Storage and offloaded to Azure Data Explorer (for visualization) and can be visualized in reporting tools like Microsoft Fabric / Power BI

### Closed Loop Workflow

Closed Loop simulation validates the behavior of the vehicle end to end, including perception and control planning for a set of defined scenarios. It includes typically these steps:

- Import of HD-Maps (OpenDRIVE) or road model from real recordings to derive a simulation digital twin
- Extract road information
- Defining static (traffic signs etc.) and dynamic assets (other cars, pedestrians, vulnerable road user also known as VRU)
- Configuration (ego vehicles, sensors etc.)
- 3D Scene and Digital Twin map modeling (using asset catalogs)
- Connecting perception and control planning stack with simulator environment (e. g. via SDKs)
- Scenario scripts definition and generation (compliant with OpenSCENARIO)
- Executing Simulation based on defined scenarios (incl. variations) and test plans (e. g. headless / automated and integrated in CI /CD DevOps workflows)
- Generating report of executing (KPIs and measurements)

These simulations can also be used to generate synthetic sequences / frame for training of the perception stack and Open Loop validation.

#### Visualization of Measurement and KPIs 
The output of Open Loop and Closed Loop simulations generate measurements and KPIs.  The outputs from the simulations that are generated are used to validate the performance of the ADAS / AD software stack.  In addition, AD engineers can determine what are improvements are required. Microsoft Fabric and Power BI support the visualization. The diagram shows a validated architecture to collect measurement and KPIs results stored in Microsoft Fabric. 
:::image type="content" source="./images/example-resim-results-ingestion.png" alt-text="Architecture diagram that shows resim results ingested into Microsoft Fabric." border="false" lightbox="./images/example-resim-results-ingestion.png":::

A [Power BI Azure Data Explorer Direct Query Connector](https://learn.microsoft.com/power-query/connectors/azure-data-explorer) can be used so that results can be directly visualized and analyzed (like DTO – Distance to Objects metrics) as Power BI report / dashboard as shown for an example resimulation / recompute run*:
:::image type="content" source="./images/example-resim-results-visualized.png" alt-text="Architecture diagram that shows resim results visualized in Power BI." border="false" lightbox="./images/example-resim-results-visualized.png":::


### Components
- [Azure Arc](https://learn.microsoft.com/azure/azure-arc/overview) provides a way for operators to manage non-Azure and/or on-premises resources such as HIL rigs from Azure Resource Manager
- [Azure Front Doors](https://learn.microsoft.com/azure/frontdoor/front-door-overview) protects for traffic surges and protect network  from attacks
- [Azure HPC Cache](https://learn.microsoft.com/azure/hpc-cache/hpc-cache-overview) speeds access to your data for high-performanc computing (HPC) tasks such as resimulation, simulation, or model training
- [ExpressRoute](https://azure.microsoft.com/products/expressroute) extends an on-premises network into the Microsoft cloud over a private connection.
- [Azure Batch](https://azure.microsoft.com/products/batch) runs large-scale parallel and high-performance computing (HPC) batch jobs efficiently in Azure. This solution uses Batch to run large-scale applications for tasks like resimulation jobs or closed-loop testing.
- [Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage) holds a large amount of data in its native, raw format. In this case, Data Lake Storage stores data based on stages, for example, raw or extracted.
- [Azure Deployment Environments](https://learn.microsoft.com/azure/deployment-environments/overview-what-is-azure-deployment-environments) empowers teams to quickly and easily spin up infrastructure based on templates.  SDV toolchain utilizes Azure Deployment Environments to spin up testing infrastructure consistently and securely
- [Azure Container Registry](https://azure.microsoft.com/products/container-registry) is a service that creates a managed registry of container images. This solution uses Container Registry to store containers for models and other SW modules for the automated driving stack.
- [Eclipse Orchestrator](https://projects.eclipse.org/projects/iot.symphony) enables end-to-end orchestration and create a consistent workflow across different systems and toolchains.  The SDV toolchain utilizes Eclipse Symphony as the main orchestrator workflow
- [Microsoft Fabric](https://learn.microsoft.com/fabric/get-started/microsoft-fabric-overview) is an all-in-one analytics solution that incorporates real-time analytics and business intelligence.  
- [Azure Private Link](https://learn.microsoft.com/azure/private-link/private-endpoint-overview) used as a network interfaces that uses a private IP address within the private virtual network.  Allows for private connection between resources and secures a service within the private virtual network
- [Azure Private Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview) provides a private network for deployment

## Scenario details

Designing a robust ValOps framework for autonomous vehicles is a critical stage to ensuring the safety of the automated driving stack.  Ensuring the organizations ValOps is operating efficiently and cost effectively is also an import consideration to ensure sustainability of operations. 

When you implement an effective DataOps strategy, you help ensure that your data is properly stored, easily accessible, and has a clear lineage. You also make it easy to manage and analyze the data, leading to more informed decision-making and improved vehicle performance.

An efficient DataOps process provides a way to easily distribute data throughout your organization. Various teams can then access the information that they need to optimize their operations. DataOps makes it easy to collaborate and share insights, which helps to improve the overall effectiveness of your organization.

Typical challenges for data operations in the context of autonomous vehicles include:

- Management of the daily terabyte-scale or petabyte-scale volume of measurement data from research and development vehicles.
- Data sharing and collaboration across multiple teams and partners, for instance, for labeling, annotations, and quality checks.
- Traceability and lineage for a safety-critical perception stack that captures versioning and the lineage of measurement data.
- Metadata and data discovery to improve semantic segmentation, image classification, and object detection models.

This AVOps DataOps solution provides guidance on how to address these challenges.

### Potential use cases

Simulation in ADAS/AD refers to the use of computer models to replicate the behavior of a vehicle in a virtual environment. It's an important tool in the development and testing of ADAS/AD systems.  Simulation allows engineers to evaluate the performance and safety of these systems in a controlled and repeatable way.  In addition, simulation allows testing without the risk and expense of testing on real vehicles.

Simulation can be used to test various aspects of ADAS/AD systems, such as their ability to detect and respond to different types of obstacles, their performance in different weather conditions, or their behavior in complex traffic scenarios. Simulation can also be used to test different versions of the software, and to identify and fix potential issues before they're deployed on real vehicles.

Using synthetic data and test fleet data to run and validate these simulations at scale for  

In summary, simulation is an essential tool in the development of ADAS/AD systems, allowing engineers to test and optimize these systems in a safe, cost-effective, and efficient manner.


### Alternatives
#### 	Simulation and Validation management 
First, it's important to understand that simulation test environments for ADAS/AD require a high degree of computational power, as they need to accurately replicate the behavior of complex vehicles and their surrounding environments. Therefore, a key aspect of the architecture is the selection of appropriate compute resources, such as virtual machines, GPUs, and high-performance computing clusters.

:::image type="content" source="./images/services-for-valops-workload-management.png" alt-text="Diagram that shows options for workload management for simulation." border="false" lightbox="./images/services-for-valops-workload-management.png":::

One possible architecture for building a simulation test environment on Azure is to use virtual machines (VMs) to host the simulation software.  With VMs, one can use an Azure Virtual Network to connect the VMs and create a private network for the simulation. The simulation software can be run on the VMs, and the simulation data can be stored in Azure Storage, such as Azure Blob Storage. The simulation can be orchestrated and managed using Azure Batch or CycleCloud.  Both of which provides a scalable and efficient way to run large-scale parallel simulations.

Another possible architecture for building a simulation test environment on Azure is to use Azure Kubernetes Service (AKS) to orchestrate the simulation workloads. AKS can be used to deploy and manage containerized simulation software, which can be run on a cluster of Azure virtual machines. The simulation data can be stored in Azure Data Lake Storage, which provides a scalable and secure way to store and analyze large amounts of data. Azure Machine Learning can be used to train machine learning models on the simulation data, which can then be used to improve the performance of the ADAS/AD systems.
In addition, it's important to ensure that the simulation test environment is secure and compliant with relevant regulations and standards. Azure provides a range of security features and compliance certifications.  An example of such features is Azure Security Center.  An example of certifications is ISO/IEC 27001 certification.  Both of which can help to ensure the security and compliance of the simulation test environment.

Overall, building a simulation test environment for ADAS/AD on the Azure cloud requires careful consideration of compute resources, storage, orchestration, and security. By selecting appropriate Azure services and designing a scalable and secure architecture, it's possible to build a powerful and efficient simulation test environment that can help to accelerate the development and testing of ADAS/AD systems.

#### AKS based architecture
:::image type="content" source="./images/autonomous-vehicle-operations-valops-aks-architecture.png" alt-text="Architecture diagram that shows a solution for validating autonomous vehicle software." border="false" lightbox="./images/autonomous-vehicle-operations-valops-aks-architecture.png":::


*Download a [Visio file](https://arch-center.azureedge.net/autonomous-vehicle-operations-valops.vsdx) that contains the architecture diagrams in this article.*

#### Architecture Overview
Although [Azure Batch](https://azure.microsoft.com/products/batch) is the recommended choice for HPC and (Re-)simulation workloads, there is a broad demand for a Kubernetes based solution for ValOps. Due to the broad adoption of Kubernetes organizations that want to utilize the similiar compute infrastructure that is already used for APIs and other applications, organizations can utilize [Azure Kubernetes Service](https://learn.microsoft.com/azure/aks/). 
 Azure Kubernetes Service or AKS is a managed Azure service that allows for API comp. 

An architectural difference for ValOps when utilizing AKS vs Azure Batch is the role of job scheduling.  Job scheduling is supported by Azure Batch out of the box. There are also 3rd party schedulers such as [Slurm](https://slurm.schedmd.com/overview.html)) that could be utilized to parallelize sequence processing.  For example, during resimulation validating images with ground truth data. 

For the ValOps reference architecture in AKS, it is recommended to utilize [Azure Durable Functions](https://learn.microsoft.com/azure/azure-functions/durable/durable-functions-overview?tabs=in-process%2Cnodejs-v3%2Cv1-model&pivots=csharp) as an external orchestrator and scheduler. Azure Durable Functions reads from the metadata database to determine which sequences need validation and chunks them into batches for parallel processing. These batches are sent as events to a work queue, such as [Kafka](https://kafka.apache.org/), where each event represents an activity in the Azure Durable Function. The batches contain references to images and frames stored on Azure Storage that require re-processing. Azure Durable Functions provides state management and can be easily integrated into an Azure Data Factory/Fabric pipeline or called by an orchestrator like Symphony. This approach aligns with the work queue job scheduling pattern, as described in the [Kubernetes documentation](https://kubernetes.io/docs/tasks/job/fine-parallel-processing-work-queue/). 

To achieve horizontal scalability, multiple pods are configured to listen to the work queue or Kafka topic. When an event is sent by an Azure Durable Function, one of the pods consumes the event and performs the re-processing or re-simulation of the chunk or batch.

:::image type="content" source="./images/adf-durable-functions.png" alt-text="Example Azure Fata Factory flow that shows integration with Azure Durable Functions" border="false" lightbox="./images/adf-durable-functions.png":::

#### Components
- [Azure Kubernetes Service](https://learn.microsoft.com/azure/aks/) managed Azure service to deploy a Kubernetes cluster for Validation use cases such as Open Loop testing or Closed loop testing
- [Azure Durable Functions](https://learn.microsoft.com/azure/azure-functions/durable/durable-functions-overview?tabs=in-process%2Cnodejs-v3%2Cv1-model&pivots=csharp) lets you write stateful functions in a serverless compute environment
- [Kafka](https://kafka.apache.org/) is an open-source distributed event streaming platform used for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications.
- [Azure Storage Account](https://learn.microsoft.com/azure/storage/common/storage-account-overview) storage account contains all of your Azure Storage data objects: blobs, files, queues, and tables. 

#### Alternatives
Alternative options for Job scheduling and orchestration on AKS are 3rd party tools like:

- [Apache Airflow](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/executor/kubernetes.html) is an open source platform that allows organizations to schedule and monitor worklows (available as managed service in Azure Data Factory as preview)
- [kubeflow](https://www.kubeflow.org/) is an open source project that makes deployments of workflows running on kubernetes simple

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- In your solution, consider using [Azure availability zones](https://azure.microsoft.com/global-infrastructure/availability-zones), which are unique physical locations within the same Azure region.
- Plan for disaster recovery and account [failover](/azure/storage/common/storage-disaster-recovery-guidance?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&bc=%2Fazure%2Fstorage%2Fblobs%2Fbreadcrumb%2Ftoc.json).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

It's important to understand the division of responsibility between an automotive OEM and Microsoft. In a vehicle, the OEM owns the whole stack, but as the data moves to the cloud, some responsibilities transfer to Microsoft. Azure platform as a service (PaaS) layers provide built-in security on the physical stack, including the operating system. You can add the following capabilities to the existing infrastructure security components:

- Identity and access management that uses Microsoft Entra identities and [Microsoft Entra Conditional Access](/azure/active-directory/conditional-access) policies.
- Infrastructure governance that uses [Azure Policy](https://azure.microsoft.com/services/azure-policy).
- Data governance that uses [Microsoft Purview](https://azure.microsoft.com/services/purview).
- Encryption of data at rest that uses native Azure storage and database services. For more information, see [Data protection considerations](/azure/well-architected/security/design-storage).
- The safeguarding of cryptographic keys and secrets. Use [Azure Key Vault](https://azure.microsoft.com/services/key-vault) for this purpose.
- Use of Private or Service Endpoints to avoid public network
- NFS doesn't support Microsoft Entra ID authentication (if that is required for enterprise security model).  Blobfuse (for example with CSI Driver) or Storage SDKs should be considered for Azure Kubernetes and Azure Batch workloads. See network file system security [article](https://learn.microsoft.com/azure/storage/blobs/network-file-system-protocol-support#network-security) for more details

### Cost optimization

Cost optimization looks at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

A key concern for OEMs and tier 1 suppliers that operate DataOps for automated vehicles is the cost of operating. This solution uses the following practices to help optimize costs:

- Taking advantage of various options that Azure offers for hosting application code. This solution uses App Service and Batch. For guidance about how to choose the right service for your deployment, see [Choose an Azure compute service](/azure/architecture/guide/technology-choices/compute-decision-tree).  
#### Compute Options
Based on the simulation requirements, [Azure Batch](https://learn.microsoft.com/azure/batch/) can provision permanently required containers or virtual machines based on the SLA. Here are some recommendations to save cost with various types of compute cost models and profiles. 

Several choices VMs could be utilized, depending on the use case:
- Pay-as-you-go – Only pay for what you consumed—applicable to interactive, unplanned jobs
- Reserved instances – Keep for 3 to 5 years reservation mainly for batch type and long running jobs
- Spot instances – Use sporadically for dev/tests jobs

#### Storage Options
- Refer to scalability and performance targets for [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/scalability-targets-standard-account)

### Performance Efficiency
- It's important the organizations storage location is in the same region as compute
- Recommended when data is larger, it isn't recommended to use Azure Files as blobs of data.  For example, images, video transaction rates or that use smaller objects IO performance slows  ML training or require consistently low storage latency workloads. 
- For most scenarios, this guidance doesn't recommend using Standard Azure Blob, except in cases where there are many small files (KB magnitude) that can't be processed into ‘fewer and larger’ blobs. 

### Deploy this scenario
There are several options to deploy this scenario:
- [dSPACE](https://www.dspace.com/inc/home.cfm) is a partner that worked with Microsoft on this architecture to create a product called SIMPHERA.  SIMPHERA is a software solution for simulating and validating functions for autonomous driving.  To deploy SIMPHERA, follow the instructions in this [repo](https://github.com/dspace-group/simphera-reference-architecture-azure/tree/main)
- [ANSYS](https://www.ansys.com/) is another partner that has a deployable solution that is aligned to this reference architecture.  The solution can be deployed in [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/ansys.av_platform_azure?tab=Overview)
- [Cognata](https://azuremarketplace.microsoft.com/marketplace/apps/cognata.simcloud10?tab=Overview) SimCloud is a deployable simulated test-drive environment  that enhances validation process by generating fast, highly accurate results, and eliminates the safety concerns, high costs, and limited scalability of road-testing in the physical world as well.
## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Ryan Matsumura](https://www.linkedin.com/in/ryan-matsumura-4167257b) | Senior Program Manager, MCI SDV & Mobility
- [Jochen Schroeer](https://www.linkedin.com/in/jochen-schroeer) | Lead Architect (Service Line Mobility)
- [Gabriel Sallah](https://www.linkedin.com/in/gabrielsallah/) | Senior Specialist GBB
- [Wolfgang De Salvador](https://www.linkedin.com/in/wolfgang-de-salvador/) | Senior Specialist GBB
- [Lukasz Miroslaw](https://www.linkedin.com/in/lukaszmiroslaw/?originalSubdomain=ch) | Senior Specialist GBB
- [Benedict Berger](https://www.linkedin.com/in/benedict-berger-msft/) | Senior Product Manager

Other Contributors:
- [Filipe Prezado](https://www.linkedin.com/in/filipe-prezado-9606bb14) | Principal Program Manager, MCI SDV & Mobililty

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Batch?](/azure/batch/batch-technical-overview)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
- [Large-scale Data Operations Platform for Autonomous Vehicles](https://devblogs.microsoft.com/ise/large-scale-data-operations-platform-for-autonomous-vehicles/)

## Related resources

- [AVOps design guide](../../guide/machine-learning/avops-design-guide.md)
- [Data operations for autonomous vehicle operations](./autonomous-vehicle-operations-dataops-content.md)
- [Software Defined Vehicle Reference Architecture](../../industries/automotive/software-defined-vehicle-reference-architecture-content.md)
- [Automotive messaging, data & analytics reference architecture](/azure/event-grid/mqtt-automotive-connectivity-and-data-solution)
- [Enhancing efficiency in AVOps with Generative AI](https://download.microsoft.com/download/c/e/c/ceccb875-9cc9-49d2-b658-88d9abc4dc3f/enhancing-efficiency-in-AVOps-with-generative-AI.pdf)
- [Validation as a Service](https://learn.microsoft.com/events/ignite-nov-2021/industry/breakouts/od203/)

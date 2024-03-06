This article presents a solution and guidance for developing a Validation Operations (ValOps) for Advanced Driving Assistance Systems (ADAS) and Autonomous Driving (AD). The ValOps solution is built on the framework outlined in [Autonomous vehicle operations (AVOps) design guide](../../guide/machine-learning/avops-design-guide.md). ValOps is one of the building blocks of AVOps. Other building blocks include [DataOps](./autonomous-vehicle-operations-dataops-content.md), machine learning operations (MLOps), DevOps, and centralized AVOps functions (see related articles). In addition, the approach in this article utilizes the [Software defined vehicle DevOps toolchain Reference Architecture](../../industries/automotive/software-defined-vehicle-reference-architecture-content.md) to provide an end-to-end automated driving stack that can orchestrate testing required for automated driving.  

## Architecture

:::image type="content" source="./images/autonomous-vehicle-operations-valops-architecture.png" alt-text="Architecture diagram that shows a solution for validating autonomous vehicle software." border="false" lightbox="./images/autonomous-vehicle-operations-valops-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/autonomous-vehicle-operations-valops.vsdx) that contains the architecture diagrams in this article.*

### Components
- [Azure Arc](https://learn.microsoft.com/azure/azure-arc/overview) provides a way for operators to manage non-Azure and/or on-premises resources such as Hardware-in-Loop (HIL) rigs from Azure Resource Manager
- [Azure Front Doors](https://learn.microsoft.com/azure/frontdoor/front-door-overview) protects for traffic surges and protect network  from attacks
- [Azure HPC Cache](https://learn.microsoft.com/azure/hpc-cache/hpc-cache-overview) speeds access to your data for high-performanc computing (HPC) tasks such as resimulation, simulation, or model training
- [ExpressRoute](https://azure.microsoft.com/products/expressroute) extends an on-premises network into the Microsoft cloud over a private connection
- [Azure Batch](https://azure.microsoft.com/products/batch) runs large-scale parallel and high-performance computing (HPC) batch jobs efficiently in Azure. This solution uses Batch to run large-scale applications for tasks like resimulation jobs or closed-loop testing
- [Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage) holds a large amount of data in its native, raw format. In this case, Data Lake Storage stores data based on stages, for example, raw or extracted
- [Azure Deployment Environments](https://learn.microsoft.com/azure/deployment-environments/overview-what-is-azure-deployment-environments) empowers teams to quickly and easily spin up infrastructure based on templates. Software Defined Vehicle (SDV) toolchain utilizes Azure Deployment Environments to spin up testing infrastructure consistently and securely
- [Azure Container Registry](https://azure.microsoft.com/products/container-registry) is a service that creates a managed registry of container images. This solution uses Container Registry to store containers for models and other software (SW) modules for the automated driving stack
- [Eclipse Orchestrator](https://projects.eclipse.org/projects/iot.symphony) enables end-to-end orchestration and create a consistent workflow across different systems and toolchains. The SDV toolchain utilizes Eclipse Symphony as the main orchestrator workflow
- [Microsoft Fabric](https://learn.microsoft.com/fabric/get-started/microsoft-fabric-overview) is an all-in-one analytics solution that incorporates real-time analytics and business intelligence
- [Azure Private Link](https://learn.microsoft.com/azure/private-link/private-endpoint-overview) used as a network interfaces that uses a private IP address within the private virtual network. Allows for private connection between resources and secures a service within the private virtual network
- [Azure Private Virtual Network](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview) provides a private network for deployment

## Scenario details

Designing a robust ValOps framework for autonomous vehicles is crucial to ensure the safety of the automated driving stack. It's also important to consider the efficiency and cost-effectiveness of the ValOps process to ensure sustainable operations.

Validation of AD/ADAS functionalities is structured into three main workflows:
- [Open Loop Testing (Resimulation or Recompute)](../../solution-ideas/articles/avops-architecture-content.md#open-loop-testing) 
- [Closed Loop Testing Simulation](../../solution-ideas/articles/avops-architecture-content.md#closed-loop-testing-and-simulation)
- [Scenario Management](../../solution-ideas/articles/avops-architecture-content.md#scenario-management)

Open Loop and Closed Loop validation typically has a SiL (Software-in-the-loop) and HiL (Hardware-in-the-loop) flavor. The latter validates the stack (e. g. perception stack) with real vehicle hardware.

To validate the AD capabilities (Open Loop, Close Loop), a catalog of specific real scenarios is required that is used to simulate the behavior of vehicles. The objective is to accelerate the creation of scenario catalogs, by automatically reading the route network, which is a part of a scenario, from publicly accessible and freely available digital maps. As part of the reference architecture open formats like OPENDrive (xodr) should be supported. Based on customer’s partner selection tools from Cognata, Ansys, dSPACE, or others that are used for Scenario Management. CARLA can be considered as open source software (OSS) lightweight alternative that also supports OPENDrive format, see carla-simulator/scenario_runner: Traffic scenario definition and execution engine (github.com).

- Trained Perception Stack for AD / ADAS functions are converted and integrated to vehicle software artifacts 
- Scenarios are imported and created in Scenario Mgmt. Tool
- Open Loop and Closed Loop simulations are executed on Azure HPC infrastructure (Azure Batch or Azure Kubernetes Service)
- Results are generated and output to Azure Data Explorer for interactive analysis 

### Open Loop Testing Dataflow

Re-Simulation (or Recompute) is a complex process that requires extensive development and strict adherence to government regulations for Autonomous Driving (AD). It serves as an open loop test and validation system for AD functions, focusing on safety, data privacy, data versioning, and auditing. In this process, recorded raw data from car sensors is processed through a cloud-based graph. The output is then used to validate data processing algorithms and identify any regressions. Original Equipment Manufacturers (OEMs) combine the sensors into a Directed Acyclic Graph (DAG) that represents the real-world vehicle.

Resimulation, also known as "sensor reprocessing," is a large-scale parallel compute job. It involves processing massive amounts of data (hundreds of Petabytes (PBs)) using tens of thousands of cores and requiring high I/O throughput (>30GB/sec). The data sets are fused from multiple sensor types to create a comprehensive view of the vehicle's surroundings. In an open loop test, the performance of algorithms is tested and validated against ground truth using replay and scoring. The output of this process is later used for algorithm training.

The resimulation workflow includes the following steps:
- Data sets are sourced from test fleet vehicles, collecting raw sensor data (for example, camera, lidar, radar) or synthetically generated from simulators.
- The volume of data depends on camera resolution and the number of sensors on the vehicle.
- Raw sensor data is processed against different software releases of the devices (for example, perception).
- The processed data is compared with the output of previous software versions to identify bug fixes or new features.
- A second run of the job is performed after model and software updates.
- Ground truth data is used to validate the results.
- The results are stored in a storage system and offloaded to Azure Data Explorer for visualization. They can be further analyzed and visualized using reporting tools like Microsoft Fabric and Power BI.

### Closed Loop Workflow

The Closed Loop simulation is responsible for validating the end-to-end behavior of the vehicle, including perception and control planning, for a defined set of scenarios. The simulation process typically involves the following steps:

- Importing HD-Maps (OpenDRIVE) or road models from real recordings to create a simulation digital twin.
- Extracting road information.
- Defining static assets such as traffic signs and dynamic assets such as other vehicles, pedestrians, and vulnerable road users (VRUs).
- Configuring ego vehicles and sensors.
- Modeling the 3D scene and digital twin map using asset catalogs.
- Connecting the perception and control planning stack with the simulator environment through SDKs.
- Defining and generating scenario scripts compliant with OpenSCENARIO.
- Executing simulations based on the defined scenarios and test plans, which can be automated and integrated into CI/CD DevOps workflows.
- Generating reports containing KPIs and measurements from the simulation execution.

These simulations can also be utilized to generate synthetic sequences or frames for training the perception stack and for Open Loop validation.

#### Visualization of Measurement and KPIs 
The output of Open Loop and Closed Loop simulations generate measurements and KPIs. These outputs are used to validate the performance of the ADAS/AD software stack and identify areas for improvement. Microsoft Fabric and Power BI provide support for visualizing these measurements and KPIs. The diagram illustrates an architecture that collects and stores measurement and KPI results in Microsoft Fabric.

:::image type="content" source="./images/example-resim-results-ingestion.png" alt-text="Architecture diagram that shows resim results ingested into Microsoft Fabric." border="false" lightbox="./images/example-resim-results-ingestion.png":::


A [Power BI Azure Data Explorer Direct Query Connector](https://learn.microsoft.com/power-query/connectors/azure-data-explorer) can be used to directly visualize and analyze results, such as DTO (Distance to Objects) metrics, in a Power BI report or dashboard. Here's an example of how the results from a resimulation/recompute run can be visualized:


:::image type="content" source="./images/example-resim-results-visualized.png" alt-text="Architecture diagram that shows resim results visualized in Power BI." border="false" lightbox="./images/example-resim-results-visualized.png":::

### Potential use cases

Simulation in ADAS/AD refers to the use of computer models to replicate the behavior of a vehicle in a virtual environment. It's an important tool in the development and testing of ADAS/AD systems. Simulation allows engineers to evaluate the performance and safety of these systems in a controlled and repeatable way. In addition, simulation allows testing without the risk and expense of testing on real vehicles.

Simulation can be used to test various aspects of ADAS/AD systems, such as their ability to detect and respond to different types of obstacles, their performance in different weather conditions, or their behavior in complex traffic scenarios. Simulation can also be used to test different versions of the software, and to identify and fix potential issues before they're deployed on real vehicles.

Using synthetic data and test fleet data to run and validate these simulations at scale for  

In summary, simulation is an essential tool in the development of ADAS/AD systems, allowing engineers to test and optimize these systems in a safe, cost-effective, and efficient manner.


### Alternatives
#### Azure Kubernetes Service (AKS) 
Another option is to use [Azure Kubernetes Service](https://learn.microsoft.com/azure/aks/) (AKS) to orchestrate simulation workloads. AKS can deploy and manage containerized simulation software on a cluster of Azure virtual machines. Simulation data can be stored in [Azure Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage), providing scalability and security for large data sets. [Azure Machine Learning](https://learn.microsoft.com/azure/machine-learning/overview-what-is-azure-machine-learning?view=azureml-api-2) can be utilized to train machine learning models on the simulation data, enhancing the performance of ADAS/AD systems.

#### AKS based architecture
:::image type="content" source="./images/autonomous-vehicle-operations-valops-aks-architecture.png" alt-text="Architecture diagram that shows a solution for validating autonomous vehicle software." border="false" lightbox="./images/autonomous-vehicle-operations-valops-aks-architecture.png":::


*Download a [Visio file](https://arch-center.azureedge.net/autonomous-vehicle-operations-valops.vsdx) that contains the architecture diagrams in this article.*
#### Architecture Overview

When utilizing AKS for ValOps, utilize Azure Durable Functions as an external orchestrator and scheduler. [Azure Durable Functions](https://learn.microsoft.com/azure/azure-functions/durable/durable-functions-overview?tabs=in-process%2Cnodejs-v3%2Cv1-model&pivots=csharp) can read from a metadata database to determine which sequences need validation and chunk them into batches for parallel processing. These batches can be sent as events to a work queue, such as Kafka, where each event represents an activity in the Azure Durable Function. Azure Durable Functions provide state management and can be easily integrated into an [Azure Data Factory](https://learn.microsoft.com/en-us/azure/data-factory/introduction)/[Microsoft Fabric](https://learn.microsoft.com/fabric/get-started/microsoft-fabric-overview) pipeline or called by an orchestrator like [Eclipse Symphony](https://projects.eclipse.org/projects/iot.symphony) . This approach aligns with the work queue job scheduling pattern, as described in the Kubernetes [documentation](https://kubernetes.io/docs/tasks/job/fine-parallel-processing-work-queue/).

To achieve horizontal scalability, multiple pods can be configured to listen to the work queue or Kafka topic. When an event is sent by an Azure Durable Function, one of the pods consumes the event and performs the reprocessing or resimulation of the chunk or batch.

:::image type="content" source="./images/adf-durable-functions.png" alt-text="Example Azure Fata Factory flow that shows integration with Azure Durable Functions" border="false" lightbox="./images/adf-durable-functions.png":::

#### Components
- [Azure Kubernetes Service](https://learn.microsoft.com/azure/aks/) managed Azure service to deploy a Kubernetes cluster for Validation use cases such as Open Loop testing or Closed loop testing
- [Azure Durable Functions](https://learn.microsoft.com/azure/azure-functions/durable/durable-functions-overview?tabs=in-process%2Cnodejs-v3%2Cv1-model&pivots=csharp) lets you write stateful functions in a serverless compute environment
- [Kafka](https://kafka.apache.org/) is an open-source distributed event streaming platform used for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications
- [Azure Storage Account](https://learn.microsoft.com/azure/storage/common/storage-account-overview) storage account contains all of your Azure Storage data objects: blobs, files, queues, and tables

Alternative options for Job scheduling and orchestration on AKS are third party tools like:

- [Apache Airflow](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/executor/kubernetes.html) is an open source platform that allows organizations to schedule and monitor workflow (available as managed service in Azure Data Factory as preview)
- [kubeflow](https://www.kubeflow.org/) is an open source project that makes deployments of workflows running on kubernetes simple

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- In your solution, consider using [Azure availability zones](https://azure.microsoft.com/global-infrastructure/availability-zones), which are unique physical locations within the same Azure region.
- To plan for a disaster, utilize the disaster recovery and account [failover guidance](/azure/storage/common/storage-disaster-recovery-guidance?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&bc=%2Fazure%2Fstorage%2Fblobs%2Fbreadcrumb%2Ftoc.json).

### Security and Compliance

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

It's important to understand the division of responsibility between an automotive OEM and Microsoft. In a vehicle, the OEM owns the whole stack, but as the data moves to the cloud, some responsibilities transfer to Microsoft. Azure platform as a service (PaaS) layers provide built-in security on the physical stack, including the operating system. You can add the following capabilities to the existing infrastructure security components:

- Identity and access management that uses Microsoft Entra identities and [Microsoft Entra Conditional Access](/azure/active-directory/conditional-access) policies
- Infrastructure governance that uses [Azure Policy](https://azure.microsoft.com/services/azure-policy)
- Data governance that uses [Microsoft Purview](https://azure.microsoft.com/services/purview)
- Encryption of data at rest that uses native Azure storage and database services. For more information, see [Data protection considerations](/azure/well-architected/security/design-storage)
- The safeguarding of cryptographic keys and secrets. Use [Azure Key Vault](https://azure.microsoft.com/services/key-vault) for this purpose
- Use of Private or Service Endpoints to avoid public network
- NFS doesn't support Microsoft Entra ID authentication (if that is required for enterprise security model). Blobfuse (for example with CSI Driver) or Storage SDKs should be considered for Azure Kubernetes and Azure Batch workloads. For more information, see network file system security [article](https://learn.microsoft.com/azure/storage/blobs/network-file-system-protocol-support#network-security) 


To ensure the security of complex systems, you need to understand the business, social, and technical conditions. Ensuring the security and compliance of the simulation test environment is crucial. Consider implementing GitHub’s code-scanning capabilities, so you can find and fix security issues and critical defects early in the development process. GitHub supports the coding standards [AUTOSAR C++ and CERT C++](https://github.blog/2022-06-20-adding-support-for-coding-standards-autosar-c-and-cert-c), which enables the development of functional safety applications. 

Consider adopting Azure Key Vault to maintain end-to-end security when you handle sensitive and business-critical elements, such as encryption keys, certificates, connection strings, and passwords. Key Vault-managed hardware security modules (HSMs) offer a robust solution that fortifies the entire software development and supply chain process. With Key Vault-managed HSMs, you can use automotive applications to help securely store and manage sensitive assets and ensure that they remain protected from potential cyber security threats. You can further enhance security by regulating access and permissions to critical resources with RBAC.

### Cost optimization

Cost optimization looks at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

A key concern for OEMs and tier 1 suppliers that operate DataOps for automated vehicles is the cost of operating. This solution uses the following practices to help optimize costs:

- Taking advantage of various options that Azure offers for hosting application code. This solution uses App Service and Batch. For guidance about how to choose the right service for your deployment, see [Choose an Azure compute service](/azure/architecture/guide/technology-choices/compute-decision-tree).  
### Compute Options
Based on the simulation requirements, [Azure Batch](https://learn.microsoft.com/azure/batch/) can provision permanently required containers or virtual machines based on the SLA. Here are some recommendations to save cost with various types of compute cost models and profiles. 

Several choices VMs could be utilized, depending on the use case:
- Pay-as-you-go – Only pay for what you consumed—applicable to interactive, unplanned jobs
- Reserved instances – Keep for 3 to 5 years reservation mainly for batch type and long running jobs
- Spot instances – Use sporadically for dev/tests jobs

### Storage Options
- Refer to scalability and performance targets for [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/scalability-targets-standard-account)

### Performance Efficiency
- It's important the organizations storage location is in the same region as compute.
- When data is larger, it isn't recommended to use Azure Files as blobs of data. For example, images, video transaction rates or that use smaller objects IO performance slows  ML training or require consistently low storage latency workloads. 
- This guidance doesn't recommend using Standard Azure Blob for most scenarios. Except in cases where there are many small files (KB magnitude) that can't be processed into "fewer and larger" blobs. 

### Deploy this scenario
There are several options to deploy this scenario:

- [dSPACE](https://www.dspace.com/inc/home.cfm) is a partner that collaborated with Microsoft on this architecture. dSPACE developed a software solution called SIMPHERA for simulating and validating functions for autonomous driving. To deploy SIMPHERA, refer to the instructions in this [repository](https://github.com/dspace-group/simphera-reference-architecture-azure/tree/main).

- [ANSYS](https://www.ansys.com/) is another partner that has a deployable solution that is aligned to this reference architecture. The solution can be deployed in [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/ansys.av_platform_azure?tab=Overview).
- [Cognata](https://azuremarketplace.microsoft.com/marketplace/apps/cognata.simcloud10?tab=Overview) SimCloud is a deployable simulated test-drive environment  that enhances validation process. SimCloud generates fast, highly accurate results, and eliminates the safety concerns. In addition, SimCloud address the high costs and limited scalability of road-testing in the physical world.
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

## Related resources

- [Mobility Hub](aka.ms/mobilitydocs)
- [AVOps design guide](../../guide/machine-learning/avops-design-guide.md)
- [Data operations for autonomous vehicle operations](./autonomous-vehicle-operations-dataops-content.md)
- [Software Defined Vehicle Reference Architecture](../../industries/automotive/software-defined-vehicle-reference-architecture-content.md)
- [Automotive messaging, data & analytics reference architecture](/azure/event-grid/mqtt-automotive-connectivity-and-data-solution)
- [Enhancing efficiency in AVOps with Generative AI](https://download.microsoft.com/download/c/e/c/ceccb875-9cc9-49d2-b658-88d9abc4dc3f/enhancing-efficiency-in-AVOps-with-generative-AI.pdf)
- [Validation as a Service](https://learn.microsoft.com/events/ignite-nov-2021/industry/breakouts/od203/)

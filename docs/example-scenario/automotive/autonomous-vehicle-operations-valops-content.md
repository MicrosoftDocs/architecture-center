Ensuring the reliability and safety of automated driving systems necessitates rigorous testing and validation of their sensors, algorithms, and various components. By defining comprehensive test scenarios, you can utilize simulators or manage on-premises hardware devices to execute these tests. The resulting data from these validation operations is crucial for refining and iterating your design, ultimately enhancing the performance and safety of autonomous vehicles. This article presents guidance for developing a Validation Operations (ValOps) solution for Advanced Driving Assistance Systems (ADAS) and Autonomous Driving (AD). The ValOps solution is built as part of the framework outlined in [Autonomous vehicle operations (AVOps) design guide](../../guide/machine-learning/avops-design-guide.md). The approach in this article utilizes the [Software defined vehicle DevOps toolchain reference architecture](../../industries/automotive/software-defined-vehicle-reference-architecture.md) to provide an end-to-end automated software stack that can orchestrate the required tests for automated driving.  

## Architecture

:::image type="content" source="./images/autonomous-vehicle-operations-valops-architecture.png" alt-text="Architecture diagram that shows a solution for validating autonomous vehicle software." border="false" lightbox="./images/autonomous-vehicle-operations-valops-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/autonomous-vehicle-operations-valops.vsdx) that contains the architecture diagrams in this article.*

### Workflow
- A GitHub action triggers the metadata and orchestration services that run the [deployment campaign](https://github.com/eclipse-symphony/symphony/blob/main/docs/symphony-book/concepts/unified-object-model/campaign.md) within Azure Deployment Environments.
- The metadata and orchestration services use the Azure deployment environment to establish the required compute for Open Loop or Closed Loop testing.
- The metadata and orchestration services use the Container Registry artifacts store to mount and configure the required high-performance compute (HPC) images.
- ValOps receives a trained perception stack for AD / ADAS functions that were converted and integrated to vehicle software and stored as software artifacts 
- A validation engineer could manually trigger or a GitOps engineer trigger a test trigger. The toolchain pulls the software stack container and a definition of the build.
- The toolchain and orchestration services trigger the test process. The services deploy the required infrastructure to build, validate, and release software containers.
- The metadata and orchestration invoke the job submission on the HPC cluster.
- [Azure Batch](https://learn.microsoft.com/azure/well-architected/service-guides/azure-batch/reliability) runs the job submission and stores key performance indicators (KPI) metrics into the dedicated storage account. [Microsoft Fabric](https://learn.microsoft.com/fabric/get-started/microsoft-fabric-overview) mounts the storage account where the validation engineer can monitor test plans, perform interactive analysis, and visualize results.

### Components
- [Azure Arc](https://learn.microsoft.com/azure/azure-arc/overview)  is a service that extends Azure management and services to any infrastructure, enabling you to manage and secure your resources across on-premises, multi-cloud, and edge environments.  In ValOps, Azure Arc provides a way for operators to manage non-Azure and/or on-premises resources such as Hardware-in-Loop (HiL) rigs from Azure Resource Manager
- [Azure Firewall](https://learn.microsoft.com/azure/well-architected/service-guides/azure-firewall) is a cloud-native network security service that protects your Azure Virtual Network resources with built-in high availability and unrestricted cloud scalability.  Azure Firewall is used to protect the network from traffic surges and attacks.
- [ExpressRoute](https://learn.microsoft.com/azure/well-architected/service-guides/azure-expressroute) is a service that extends your on-premises networks into the Microsoft cloud over a private connection, offering more reliability, faster speeds, and higher security than typical internet connections.  Azure ExpressRoute is used in ValOps to extend to your on-premises network where the organizations HiL rigs reside.  
- [Azure Batch](https://learn.microsoft.com/azure/well-architected/service-guides/azure-batch/reliability) runs efficient large-scale parallel and high-performance computing (HPC) batch jobs in Azure. This solution uses Batch to run large-scale applications for tasks, such as resimulation jobs or closed-loop testing.
- [Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage) holds a large amount of data in its native, raw format. In this solution, Data Lake Storage stores data based on stages, for example, raw or extracted.
- [Azure Deployment Environments](https://learn.microsoft.com/azure/deployment-environments/overview-what-is-azure-deployment-environments)  is a service that allows development teams to quickly create and manage consistent, secure infrastructure using project-based templates. Azure Deployment Environments lets organizations implementing a ValOps to quickly and easily spin up an infrastructure based on templates. Software Defined Vehicle (SDV) toolchain utilizes Azure Deployment Environments to spin up testing infrastructure consistently and securely.
- [Azure Container Registry](https://azure.microsoft.com/products/container-registry) is a service that creates a managed registry of container images. This solution uses Container Registry to store containers for models and other software (SW) modules for the automated driving stack.
- [Eclipse Orchestrator](https://projects.eclipse.org/projects/iot.symphony) is a service orchestration engine that simplifies managing and integrating multiple intelligent edge services into a seamless, end-to-end experience.  Eclipse Orchestrator enables an end-to-end orchestration and creates a consistent workflow across different systems and toolchains. The SDV toolchain utilizes Eclipse Symphony as the main orchestrator workflow.
- [Microsoft Fabric](https://learn.microsoft.com/fabric/get-started/microsoft-fabric-overview) is an all-in-one analytics solution that incorporates real-time analytics and business intelligence. In this solution, Microsoft Fabric allows validation engineers to quickly generate reports, analysis and business reports on validation operations for multiple projects, variants, and products.
- [Azure Private Link](https://learn.microsoft.com/azure/private-link/private-endpoint-overview) is used as a network interface that uses a private IP address within the private virtual network. Private Link allows for a private connection between resources and secures a service within the private virtual network.
- [Azure virtual networks](https://learn.microsoft.com/azure/well-architected/service-guides/azure-virtual-network/reliability) are the fundamental building blocks for creating isolated, secure, and scalable private networks within the Azure cloud environment.  Azure virtual network provides a private network for your Azure components to communicate with each other.

## Scenario details

Designing a robust ValOps framework for autonomous vehicles is crucial to ensure the safety of the automated driving stack. It's also important to consider the efficiency and cost-effectiveness of the ValOps process to ensure sustainable operations.

Validation of AD/ADAS functionalities is structured into three main workflows:
- [Open Loop Testing (Resimulation or Recompute)](../../solution-ideas/articles/avops-architecture-content.md#open-loop-testing) 
- [Closed Loop Testing Simulation](../../solution-ideas/articles/avops-architecture-content.md#closed-loop-testing-and-simulation)
- [Scenario Management](../../solution-ideas/articles/avops-architecture-content.md#scenario-management)

Open Loop and Closed Loop validation typically has a SiL (Software-in-the-loop) and HiL (Hardware-in-the-loop) flavor. Open Loop and Closed Loop simulations are executed on Azure HPC infrastructure ([Azure Batch](https://azure.microsoft.com/products/batch) or [Azure Kubernetes Service](https://learn.microsoft.com/azure/aks/)). HiL validates the stack (for example, perception stack) with real vehicle hardware. Automated driving embedded hardware systems require specialized hardware that considers cost, low-power, safety, and reliability. Although shifting as much validation to the cloud is seen as the most economical and efficient method for the industry, these hardware systems aren't widely available. As such, part of the ValOps architecture is to include a hybrid approach using [Azure Arc](https://learn.microsoft.com/azure/azure-arc/overview). Azure Arc provides a way for operators to manage non-Azure and/or on-premises resources such as Hardware-in-Loop (HiL) rigs from Azure Resource Manager. Organizations can work with third Party cloud providers or their own on-premises data center to host HiL rigs and manage both cloud and HiL systems through their ValOps deployment. 

A key component to validation of Automated driving systems is validating the system across a diverse and expansive set of scenarios. To validate the AD capabilities (Open Loop, Closed Loop), a catalog of real scenarios is used to validate the autonomous driving solution's ability to simulate the behavior of autonomous vehicles. Within ValOps, scenario management is used to speed up the creation of scenario catalogs by automatically reading the route network, which is a part of a scenario, from publicly accessible and freely available digital maps. 

To achieve scenario management:
 
 - Support open formats such as xodr from [OPENDrive](https://www.asam.net/standards/detail/opendrive/)
 - Consider, third-party tools from [Cognata, Ansys, dSPACE](#deploy-this-scenario) or other tools
 - Alternatively, CARLA can be considered as open-source software (OSS) lightweight alternative that also supports OPENDrive format, see [ScenarioRunner for CARLA](https://github.com/carla-simulator/scenario_runner)

### Open Loop Testing Dataflow

Open loop testing involves validating the performance of algorithms by replaying recorded data and comparing the output against known ground truth without any feedback influencing the system’s behavior.  Re-Simulation (or Recompute) is a complex process that requires extensive development and strict adherence to government regulations for Autonomous Driving (AD). It serves as an open loop test and validation system for AD functions, focusing on safety, data privacy, data versioning, and auditing. In this process, recorded raw data from car sensors is processed through a cloud-based graph. The output is then used to validate data processing algorithms and identify any regressions. Original Equipment Manufacturers (OEMs) combine the sensors into a Directed Acyclic Graph (DAG) that represents the real-world vehicle.

Resimulation, also known as "sensor reprocessing," is a large-scale parallel compute job. It involves processing massive amounts of data (hundreds of Petabytes (PBs)) using tens of thousands of cores and requiring high I/O throughput (>30GB/sec). The data sets are fused from multiple sensor types to create a comprehensive view of the vehicle's surroundings. In an open loop test, the performance of algorithms is tested and validated against ground truth using replay and scoring. The output of this process is later used for algorithm training.

The resimulation workflow includes the following steps:
- Data sets are sourced from test fleet vehicles, collecting raw sensor data (for example, camera, lidar, radar) or synthetically generated from simulators. The volume of data depends on camera resolution and the number of sensors on the vehicle.
- Raw sensor data is processed against different software releases of the devices (for example, perception)
- The processed data is compared with the output of previous software versions to identify bug fixes or new features
- A second run of the job is performed after model and software updates
- Ground truth data is used to validate the results
- The results are stored in a storage system and offloaded to Azure Data Explorer for visualization. They can be further analyzed and visualized using reporting tools like [Microsoft Fabric](https://learn.microsoft.com/fabric/get-started/microsoft-fabric-overview). In addition, validation engineers can utilize [Microsoft Fabric copilot](https://learn.microsoft.com/en-us/fabric/get-started/copilot-fabric-overview) to transform and analyze data, generate insights, and create visualizations and reports in Microsoft Fabric and Power BI

### Closed Loop Workflow

Closed loop testing involves evaluating the vehicle’s capabilities by incorporating real-time feedback from the environment. The vehicle’s actions are influenced by both its pre-programmed behavior and the dynamic conditions it encounters, allowing it to adjust its actions accordingly. This method ensures that the system can respond to changing scenarios in a realistic manner. The Closed Loop simulation is responsible for validating the end-to-end behavior of the vehicle, including perception and control planning, for a defined set of scenarios. The simulation process typically involves the following steps:

- Importing HD-Maps (OpenDRIVE) or road models from real recordings to create a simulation digital twin
- Extracting road information
- Defining static assets such as traffic signs and dynamic assets such as other vehicles, pedestrians, and vulnerable road users (VRUs)
- Configuring ego vehicles and sensors
- Modeling the 3D scene and digital twin map using asset catalogs
- Connecting the perception and control planning stack with the simulator environment through Software Development Kits (SDKs)
- Defining and generating scenario scripts compliant with OpenSCENARIO
- Engineers executing simulations based on the defined scenarios and test plans, which can be automated and integrated into CI/CD DevOps workflows
- Generating reports containing KPIs and measurements from the simulation execution

*Simulation* in ADAS/AD refers to the use of computer models to replicate the behavior of a vehicle in a virtual environment. It's an important tool in the development and testing of ADAS/AD systems. Simulation allows engineers to evaluate the performance and safety of these systems in a controlled and repeatable way. In addition, simulation allows testing without the risk and expense of testing on real vehicles.

Simulation can be used to test various aspects of ADAS/AD systems, such as their ability to detect and respond to different types of obstacles, their performance in different weather conditions, or their behavior in complex traffic scenarios. Simulation can also be used to test different versions of the software, and to identify and fix potential issues before they're deployed on real vehicles. Using synthetic data and test fleet data to run and validate these simulations at scale. In addition, these simulations can also be utilized to generate synthetic sequences or frames for training the perception stack and for Open Loop validation.

#### Visualization of Measurement and KPIs 
The output of Open Loop and Closed Loop simulations generate measurements and KPIs. These outputs are used to validate the performance of the ADAS/AD software stack and identify areas for improvement. [Microsoft Fabric](https://learn.microsoft.com/fabric/get-started/microsoft-fabric-overview) and Power BI provide support for visualizing these measurements and KPIs. [Microsoft Fabric copilot](https://learn.microsoft.com/en-us/fabric/get-started/copilot-fabric-overview) can assist validation engineers to transform and analyze data, generate insights, and create visualizations. The diagram illustrates an architecture that collects and stores measurement and KPI results in Microsoft Fabric.

:::image type="content" source="./images/example-resim-results-ingestion.png" alt-text="Architecture diagram that shows resim results ingested into Microsoft Fabric." border="false" lightbox="./images/example-resim-results-ingestion.png":::


A [Power BI Azure Data Explorer Direct Query Connector](https://learn.microsoft.com/power-query/connectors/azure-data-explorer) can be used to directly visualize and analyze results, such as DTO (Distance to Objects) metrics, in a Power BI report or dashboard. Here's an example of how the results from a resimulation/recompute run can be visualized:

:::image type="content" source="./images/example-resim-results-visualized.png" alt-text="Architecture diagram that shows resim results ingested into Microsoft Fabric." border="false" lightbox="./images/example-resim-results-visualized.png":::

### Potential use cases

ValOps is designed strictly for the validation of automated driving software. Automotive strong requirements for certification require strict adherence to industry standards, safety and yet require an abundance of HPC clusters to execute validation at scale. Other industries that follow these requirements can utilize this guidance such as manufacturing, health care, and financial segments.

### Alternatives
#### Azure Kubernetes Service (AKS) 
Azure Batch provides partners an Azure native option that provides scheduling and dynamic orchestration as a managed service. Another option to Azure Batch for ones HPC cluster is to use [Azure Kubernetes Service](https://learn.microsoft.com/azure/aks/) (AKS) to orchestrate simulation workloads. With AKS, partners can use a familiar and popular open source service such as Kubernetes while benefiting from the reliability and scalability of a managed service.  For partners that are already using AKS or Kubernetes, the recommendation is to either continue to use AKS or to use AKS for their HPC cluster.

#### AKS based architecture
:::image type="content" source="./images/autonomous-vehicle-operations-valops-aks-architecture.png" alt-text="Architecture diagram that shows a solution for validating autonomous vehicle software." border="false" lightbox="./images/autonomous-vehicle-operations-valops-aks-architecture.png":::


*Download a [Visio file](https://arch-center.azureedge.net/autonomous-vehicle-operations-valops.vsdx) that contains the architecture diagrams in this article.*
#### Architecture Overview

When utilizing AKS for ValOps, one can deploy and manage containerized simulation software on a cluster of Azure virtual machines. Similar to a ValOps implementation with Azure Batch, simulation data can be stored in [Azure Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage), providing scalability and security for large data sets. [Azure Machine Learning](https://learn.microsoft.com/azure/machine-learning/overview-what-is-azure-machine-learning?view=azureml-api-2) can be utilized to train machine learning models on the simulation data, enhancing the performance of ADAS/AD systems.

Since Azure Batch provides scheduling and orchestration for HPC workloads, one needs an ability to schedule workloads. One option, would be to utilize Azure Durable Functions as an external orchestrator and scheduler. [Azure Durable Functions](https://learn.microsoft.com/azure/azure-functions/durable/durable-functions-overview?tabs=in-process%2Cnodejs-v3%2Cv1-model&pivots=csharp) can read from a metadata database to determine which sequences need validation and chunk them into batches for parallel processing. These batches can be sent as events to a work queue, such as Kafka, where each event represents an activity in the Azure Durable Function. Azure Durable Functions provide state management and can be easily integrated into an [Azure Data Factory](https://learn.microsoft.com/en-us/azure/data-factory/introduction)/[Microsoft Fabric](https://learn.microsoft.com/fabric/get-started/microsoft-fabric-overview) pipeline or called by an orchestrator like [Eclipse Symphony](https://projects.eclipse.org/projects/iot.symphony) . This approach aligns with the work queue job scheduling pattern, as described in the Kubernetes [documentation](https://kubernetes.io/docs/tasks/job/fine-parallel-processing-work-queue/).
Since Azure Batch provides native scheduling and orchestration for HPC workloads, if you use AKS you need an ability to schedule workloads. One option, would be to utilize Azure Durable Functions as an external orchestrator and scheduler. [Azure Durable Functions](https://learn.microsoft.com/azure/azure-functions/durable/durable-functions-overview?tabs=in-process%2Cnodejs-v3%2Cv1-model&pivots=csharp) can read from a metadata database to determine which sequences need validation and chunk them into batches for parallel processing. These batches can be sent as events to a work queue, such as Kafka, where each event represents an activity in the Azure Durable Function. Azure Durable Functions provide state management and can be easily integrated into an [Azure Data Factory](https://learn.microsoft.com/en-us/azure/data-factory/introduction)/[Microsoft Fabric](https://learn.microsoft.com/fabric/get-started/microsoft-fabric-overview) pipeline or called by an orchestrator like [Eclipse Symphony](https://projects.eclipse.org/projects/iot.symphony) . This approach aligns with the work queue job scheduling pattern, as described in the Kubernetes [documentation](https://kubernetes.io/docs/tasks/job/fine-parallel-processing-work-queue/).
To achieve horizontal scalability, multiple pods can be configured to listen to the work queue or Kafka topic. The system receives an event through an Azure Durable Function. One of the pods consumes the event and performs the reprocessing or resimulation of the chunk or batch.

:::image type="content" source="./images/adf-durable-functions.png" alt-text="Example Azure Fata Factory flow that shows integration with Azure Durable Functions" border="false" lightbox="./images/adf-durable-functions.png":::

#### Components
- [Azure Kubernetes Service](https://learn.microsoft.com/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service that simplifies deploying, managing, and scaling containerized applications with built-in security and monitoring.  AKS is used to deploy a Kubernetes cluster for Validation use cases such as Open Loop testing or Closed loop testing
- [Azure Durable Functions](https://learn.microsoft.com/azure/azure-functions/durable/durable-functions-overview?tabs=in-process%2Cnodejs-v3%2Cv1-model&pivots=csharp) is an extension of [Azure Functions](https://learn.microsoft.com/azure/well-architected/service-guides/azure-functions-security) that enables you to write stateful workflows and orchestrate complex, long-running processes in a serverless environment.  Azure Durable Functions is used as an external orchestrator and scheduler to the AKS cluster
- [Kafka](https://kafka.apache.org/) is an open-source distributed event streaming platform used for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications.  Kafka is used to handle event sourcing that is trigged in the workflow pipeline.
- [Azure Storage Account](https://learn.microsoft.com/azure/well-architected/service-guides/storage-accounts/reliability) provides a unique namespace to store and manage your Azure Storage data objects like blobs, files, queues, and tables, ensuring durability, high availability, and scalability.  Azure Storage account is used to store simulation data and results.

Alternative options for Job scheduling and orchestration on AKS are third party tools like:

- [Apache Airflow](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/executor/kubernetes.html) is an open source platform that allows organizations to schedule and monitor workflow (available as managed service in Azure Data Factory as preview)
- [kubeflow](https://www.kubeflow.org/) is an open source project that makes deployments of workflows running on kubernetes simple

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Cost optimization
Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Most costs in ValOps for organizations are typically compute and storage. Due to safety compliance such as [ISO 26262](https://www.iso.org/obp/ui/#iso:std:iso:26262:-1:ed-1:v1:en), organizations spend towards compute can increase dramatically if care isn't taken while designing their ValOps strategy. Right sizing resources is of the utmost importance to optimize costs for an organization ValOps implementation. Use of Autoscaling, [Microsoft Cost Management and Billing](https://learn.microsoft.com/azure/cost-management-billing/costs/overview-cost-management), optimize resource allocation, and scaling strategies. More information can be found on this article to help with optimizing [scaling costs](https://learn.microsoft.com/azure/well-architected/cost-optimization/optimize-scaling-costs) 

Here are some further recommendations to help organizations save cost with various types of compute cost models and profiles. 
- Select the right virtual machine (VM) for your job by using the [VM selector guide](https://azure.microsoft.com/pricing/vm-selector/?msockid=3338580647b1602718c8499943b1663a) to help with the selection process
- Define your Azure resources according to your implementation requirements. These resources can include Kubernetes clusters, messaging services, and data and analytics services
Refer to scalability and performance targets for [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/scalability-targets-standard-account).
- Ensure that the organization is following best practices for [Batch and performance efficiency guide](https://learn.microsoft.com/azure/well-architected/service-guides/azure-batch/performance-efficiency)
- Ensure that the organization is following best practices for AKS scaling by following the scalability considerations for [AKS guide](https://learn.microsoft.com/azure/cloud-adoption-framework/scenarios/app-platform/aks/scalability)
- Taking advantage of various options that Azure offers for hosting application code. For guidance about how to choose the right service for your deployment, see [Choose an Azure compute service](/azure/architecture/guide/technology-choices/compute-decision-tree).  

Several choices for VMs could be utilized, depending on the use case:
- Pay-as-you-go – Only pay for what you consumed—applicable to interactive, unplanned jobs
- Pay-as-you-go, a consumption-based pricing model where pay for what you consume. Pay-as-you-go models are applicable to interactive, unplanned jobs.
- [Reserved instances](https://azure.microsoft.com/pricing/reserved-vm-instances/?msockid=3338580647b1602718c8499943b1663a) can be cost effective for long-term workloads, such as for batch and long-running jobs like simulation and open/closed loop testing.
- [Spot instances](https://learn.microsoft.com/azure/virtual-machines/spot-vms) can be useful for jobs that don't have a strict timeline in which they need to be completed, such as for dev/test jobs. For example, researchers might need to validate an experimental model against set of scenarios, and there's no time sensitivity for the workload.
### Operational excellence
Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see Overview of the [operational excellence pillar](https://learn.microsoft.com/azure/architecture/framework/devops/overview).
ValOps embraces key software engineering strategies, such as:

- Implement Resource Manager templates for infrastructure as code (IaC) so you can automate your deployment and maintain consistency
- Implement for infrastructure as code (IaC) so you can automate your deployment and maintain consistency. You might use Bicep, Resource Manager templates (ARM templates), Terraform, or another approach.
- Mandate automated testing 
- Regularly monitor the performance and usage of your Azure resources so you can optimize costs and enhance performance. Use tools like Azure Monitor and Microsoft Cost Management

### Performance Efficiency
Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).
- Ensure that the organizations storage location used for ValOps is in the same region as compute.
- When data is larger, it isn't recommended to use Azure Files as blobs of data. For example, images, video transaction rates or that use smaller objects IO performance slows  ML training or require consistently low storage latency workloads. 
- Performance for storage is essential in HPC applications such as ValOps. This guidance doesn't recommend using [Standard Azure Blob](https://learn.microsoft.com/azure/storage/common/storage-account-overview) for most scenarios and recommends utilizing [Premium Azure Blob](https://learn.microsoft.com/azure/storage/blobs/storage-blob-block-blob-premium) for HPC applications. Except in cases where there are many small files (KB magnitude) that can't be processed into "fewer and larger" blobs. Refer to [Blob storage performance and scalability checklist](https://learn.microsoft.com/azure/storage/blobs/storage-performance-checklist)
- Refer to scalability and performance targets for [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/scalability-targets-standard-account)
- Based on the simulation requirements, [Azure Batch](https://learn.microsoft.com/azure/batch/) can set up and maintain the necessary containers or virtual machines (VMs) to meet the Service Level Objective (SLO) requirements.  This involves:
    - Provisioning: Setting up the required containers or VMs.
    - Permanently Required: Ensuring these resources are continuously available.
    - Based on the SLO: Aligning the availability and performance of these resources with the agreed-upon service levels


### Security 
Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).
It's important to understand the division of responsibility between an automotive OEM and Microsoft. In a vehicle, the OEM owns the whole stack, but as the data moves to the cloud, some responsibilities transfer to Microsoft. Azure platform as a service (PaaS) layers provide built-in security on the physical stack, including the operating system. You can add the following capabilities to the existing infrastructure security components:

- Use [Azure Key Vault](https://azure.microsoft.com/services/key-vault) to maintain end-to-end security when you handle sensitive and business-critical elements, such as encryption keys, certificates, connection strings, and passwords. Key Vault-managed hardware security modules (HSMs) offer a robust solution that fortifies the entire software development and supply chain process. With Key Vault-managed HSMs, you can use automotive applications to help securely store and manage sensitive assets and ensure that they remain protected from potential cyber security threats. You can further enhance security by regulating access and permissions to critical resources with RBAC.
- Use [Azure Key Vault](https://azure.microsoft.com/services/key-vault) to maintain end-to-end security when you handle sensitive and business-critical elements, such as encryption keys, certificates, connection strings, and passwords. Key Vault offer a robust solution that fortifies the entire software development and supply chain process. With Key Vault, you can use automotive applications to help securely store and manage sensitive assets and ensure that they remain protected from potential cyber security threats. You can further enhance security by regulating access and permissions to critical resources with RBAC. If regulatory requirements require an enhanced security solution with dedicated hardware, Key Vault w/HSM (Hardware Security Module) should be used.
- Automated driving data requires a strict data governance to help with data classification, lineage, tracking, and compliance.  [Microsoft Purview](https://azure.microsoft.com/services/purview) allow organizations involved in autonomous driving to ensure their data is well-governed, secure, and compliant, ultimately supporting the development and deployment of safe and reliable autonomous vehicles.
- In addition to enforcing compliance on data, an organization needs to enforce compliance and governance rules across organizations Azure resources. Compliance can be achieved with [Azure Policy](https://azure.microsoft.com/services/azure-policy).
- Implement role-based access control (RBAC) to grant permissions to users and services on a least-privilege basis
- In addition, use Azure Security Center to proactively monitor and mitigate security threats
- Encryption of data at rest that uses native Azure storage and database services. For more information, see [Data protection considerations](/azure/well-architected/security/design-storage).
- Use Microsoft Defender for Cloud to proactively monitor and mitigate security threats
- NFS doesn't support Microsoft Entra ID authentication (if that is required for enterprise security model). [Blobfuse](https://learn.microsoft.com/azure/storage/blobs/blobfuse2-what-is) (for example with CSI Driver) or Storage SDKs should be considered for Azure Kubernetes and Azure Batch workloads. For more information, see [network file system security](https://learn.microsoft.com/azure/storage/blobs/network-file-system-protocol-support#network-security).

### Deploy this scenario
There are several options to deploy this scenario:

- [dSPACE](https://www.dspace.com/inc/home.cfm) is a partner that collaborated with Microsoft on this architecture. dSPACE developed a software solution called SIMPHERA for simulating and validating functions for autonomous driving. To deploy SIMPHERA, refer to the instructions in this [repository](https://github.com/dspace-group/simphera-reference-architecture-azure/tree/main).
- [ANSYS](https://www.ansys.com/) is another partner that has a deployable solution that is aligned to this reference architecture. The solution can be deployed in [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/ansys.av_platform_azure?tab=Overview).
- [Cognata](https://azuremarketplace.microsoft.com/marketplace/apps/cognata.simcloud10?tab=Overview) SimCloud is a deployable simulated test-drive environment  that enhances validation process. SimCloud generates fast, highly accurate results, and eliminates the safety concerns. In addition, SimCloud address the high costs and limited scalability of road-testing in the physical world.
## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Ryan Matsumura](https://www.linkedin.com/in/ryan-matsumura-4167257b) | Senior Program Manager, MCI SDV & Mobility
- [Jochen Schroeer](https://www.linkedin.com/in/jochen-schroeer) | Principal Architect (Service Line Mobility)
- [Gabriel Sallah](https://www.linkedin.com/in/gabrielsallah/) | Senior Specialist GBB
- [Wolfgang De Salvador](https://www.linkedin.com/in/wolfgang-de-salvador/) | Senior Specialist GBB
- [Lukasz Miroslaw](https://www.linkedin.com/in/lukaszmiroslaw/?originalSubdomain=ch) | Senior Specialist GBB
- [Benedict Berger](https://www.linkedin.com/in/benedict-berger-msft/) | Senior Product Manager

Other Contributors:
- [Filipe Prezado](https://www.linkedin.com/in/filipe-prezado-9606bb14) | Principal Program Manager, MCI SDV & Mobility

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

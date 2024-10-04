Validation operations (ValOps) testing for advanced driver-assistance systems (ADAS) and autonomous driving (AD) is a critical element of [Autonomous vehicle operations (AVOps) design](../../guide/machine-learning/avops-design-guide.md). This article provides guidance for developing a ValOps testing solution that ensures the reliability and safety of AD systems. 

By following this guidance, you can use Azure to facilitate extensive, scalable testing and validation processes. You can identify and address potential problems early in the development cycle by systematically evaluating software performance across diverse scenarios and conditions. You can run these scenarios by replaying recorded sensor data or by testing software in a dynamic environment, either through simulators or specialized on-premises hardware devices that inject real-time signals.

## Architecture

:::image type="content" source="./images/autonomous-vehicle-operations-valops-architecture.png" alt-text="An architecture diagram that shows a solution for validating autonomous vehicle software." border="false" lightbox="./images/autonomous-vehicle-operations-valops-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/autonomous-vehicle-operations-valops.vsdx) that contains the architecture diagrams in this article.*

### Workflow

- A GitHub action triggers the metadata and orchestration services that run the [deployment campaign](https://github.com/eclipse-symphony/symphony/blob/main/docs/symphony-book/concepts/unified-object-model/campaign.md) within Azure Deployment Environments.
- The metadata and orchestration services use the Azure deployment environment to establish the compute that you need for open-loop or closed-loop testing.
- The metadata and orchestration services use the Azure Container Registry artifacts store to mount and configure the required high-performance computing (HPC) images.
- ValOps receives a trained perception stack for AD and ADAS functions that were converted and integrated into vehicle software and stored as software artifacts.
- A validation engineer or a GitOps engineer can manually trigger a test trigger. The toolchain pulls the software stack container and a definition of the build.
- The toolchain and orchestration services then trigger the test process by deploying the required infrastructure to build, validate, and release software containers.
- Orchestration services, with the metadata, invoke the job submission on the HPC cluster.
- [Azure Batch](/azure/well-architected/service-guides/azure-batch/reliability) runs the job submission and stores key performance indicator (KPI) metrics in the dedicated storage account. The results are stored in a storage system and offloaded to Azure Data Explorer for visualization. Validation engineers can also use [Microsoft Fabric copilot](/fabric/get-started/copilot-fabric-overview) to transform and analyze data, generate insights, and create visualizations and reports in [Fabric](/fabric/get-started/microsoft-fabric-overview) and Power BI.

### Components

- [Batch](/azure/well-architected/service-guides/azure-batch/reliability) runs efficient, large-scale parallel and HPC batch jobs in Azure. This solution uses Batch to run large-scale applications for tasks like resimulation jobs or closed-loop testing.
- [Eclipse Symphony](https://projects.eclipse.org/projects/iot.symphony) is a service orchestration engine that simplifies the management and integration of multiple intelligent edge services into a seamless, end-to-end experience. Eclipse Symphony enables an end-to-end orchestration and creates a consistent workflow across different systems and toolchains. The software-defined vehicle (SDV) toolchain uses Eclipse Symphony as the main orchestrator workflow.
- [Deployment Environments](/azure/deployment-environments/overview-what-is-azure-deployment-environments) is a service for development teams to quickly create and manage consistent and secure infrastructure by using project-based templates. By using Deployment Environments, organizations can implement ValOps to quickly and easily create a template-based infrastructure. The SDV toolchain uses Deployment Environments to create testing infrastructure consistently and securely.
- [Azure Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage) holds a large amount of data in its native, raw format. In this solution, Data Lake Storage stores data based on stages, for example, raw or extracted.
- [Fabric](/fabric/get-started/microsoft-fabric-overview) is an all-in-one analytics solution that incorporates real-time analytics and business intelligence. In this solution, validation engineers use Fabric to quickly generate reports, such as analysis and business reports on ValOps for multiple projects, variants, and products.
- [Container Registry](https://azure.microsoft.com/products/container-registry) is a service that creates a managed registry of container images. This solution uses Container Registry to store containers for models and other software modules for the automated driving stack.
- [Azure Virtual Network](/azure/well-architected/service-guides/azure-virtual-network/reliability) is the fundamental building block for creating an isolated, secure, and scalable private network for your Azure components to communicate with each other.  
- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a cloud-native network security service that protects Virtual Network resources with built-in high availability and unrestricted cloud scalability. Use Azure Firewall to protect the network from traffic surges and attacks.
- [Azure Private Link](/azure/private-link/private-endpoint-overview) is a network interface that uses a private IP address within the private virtual network. Private Link creates a private connection between resources and secures a service within the private virtual network.
- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a service that extends your on-premises networks into the Microsoft cloud over a private connection, which offers more reliability, faster speeds, and higher security than typical internet connections. Use ExpressRoute in ValOps to extend your on-premises network to where your organization's hardware-in-the-loop (HIL) rigs reside.
- [Azure Arc](/azure/azure-arc/overview) is a service that extends Azure management and services to any infrastructure so that you can manage and secure your resources across on-premises, multicloud, and edge environments. In ValOps, Azure Arc provides a way for operators to manage non-Azure and on-premises resources, such as HIL rigs from Azure Resource Manager.

## Scenario details

The ValOps framework encompasses various scenarios that rigorously test and validate the performance of ADAS and AD software. These scenarios include synthetic and real-world conditions that range from simple maneuvers like lane keeping and adaptive cruise control to complex urban driving situations that involve pedestrians, cyclists, and unpredictable traffic patterns. By replaying recorded sensor data, you can assess how the software responds to specific events and conditions. 

Additionally, dynamic testing environments, facilitated by simulators or specialized on-premises hardware, allow for real-time interaction and feedback by simulating the behavior of a vehicle in response to its surroundings. This comprehensive approach helps you ensure that the software is robust, reliable, and capable of handling the diverse challenges that you might encounter in real-world driving.

### Testing methodologies

Within the ValOps framework, you use two primary testing methodologies to ensure the robustness and reliability of ADAS and AD software: open-loop testing and closed-loop testing. 

[Open-loop testing](../../solution-ideas/articles/avops-architecture.yml#open-loop-testing) evaluates the system's responses to predefined inputs without any feedback that influences the ongoing simulation. This method lets you replay recorded sensor data and assess how the software processes this data under controlled conditions. Open-loop testing is useful for initial validation and debugging because it isolates the software's decision-making process from external variables. 

The following list describes some examples of open-loop testing.

- **Resimulation, or recompute,** is a process that involves replaying recorded sensor data through a cloud-based graph to validate AD functions. This complex process requires extensive development and strict adherence to government regulations that focus on safety, data privacy, data versioning, and auditing. 

   Resimulation is a large-scale parallel compute job that processes massive amounts of data, for example, hundreds of petabytes, by using tens of thousands of cores and by requiring high input/output (I/O) throughput, greater than 30 GBps. Use the output to validate data processing algorithms against ground truth by using replay and scoring to identify any regressions.  
- **Sensor processing** analyzes and processes raw sensor data like camera images, LiDAR, and radar data to test the perception algorithms of the autonomous system.
- **Algorithm validation** tests individual algorithms for features like object detection and lane keeping by using prerecorded data to ensure that they perform correctly under various conditions.
- **Scenario-based testing** runs the system through various predefined scenarios to evaluate its performance in different situations, such as pedestrian crossings, merging traffic, or adverse weather conditions.

[Closed-loop testing](../../solution-ideas/articles/avops-architecture.yml#closed-loop-testing-and-simulation) creates a dynamic environment where the system's actions influence the ongoing simulation. This feedback loop enables real-time interaction between the vehicle and its surroundings, which provides a more realistic assessment of the software's performance. Closed-loop testing is essential for evaluating the system's ability to adapt to changing conditions and make decisions in real-world scenarios. 

The following list describes some examples of closed-loop testing.

- **Software-in-the-loop (SIL) testing** is a testing methodology in which you test the software components of an AD system in a simulated environment. For this test, you run the software on a virtual platform that mimics the actual hardware. SIL testing allows you to validate functionality and performance without physical hardware, which makes it cost-effective and efficient for identifying problems early. It's useful for testing algorithms, control logic, and sensor data processing in a controlled and repeatable environment. 
- **Simulation** in ADAS and AD uses computer models to replicate vehicle behavior in a virtual environment. This replication allows engineers to evaluate performance and safety without real-world risks and costs. It tests various aspects such as obstacle detection, weather conditions, and complex traffic scenarios. You can run simulations at scale by using synthetic and test fleet data, which generates sequences for training and open-loop validation.
- **Hardware-in-the-loop (HIL) testing** integrates real hardware components into the testing loop. You test software on actual hardware devices, such as sensors, control units, and actuators, that are part of the AD system. HIL testing provides a more realistic assessment of the system's performance by considering the interactions between the software and the physical hardware. It's essential for validating the system's behavior under real-world conditions and ensuring that the hardware and software components work seamlessly together. 

   HIL testing is crucial for identifying hardware-related problems and verifying the overall system's reliability and safety. HIL testing necessitates the use of custom hardware devices, which must be housed in an on-premises environment. Azure provides various approaches to interact with hardware devices and other appliances in an on-premises environment. So, part of the ValOps architecture includes a hybrid approach that uses [Azure Arc](/azure/azure-arc/overview). Azure Arc provides a way for operators to manage non-Azure and on-premises resources, such as HIL rigs from Resource Manager. Organizations can work with non-Microsoft cloud providers or their own on-premises datacenter to host HIL rigs and manage cloud and HIL systems through their ValOps deployment.
- **Driver-in-the-loop (DIL) testing** includes a human driver who interacts with the simulation to evaluate the system's performance and the driver's response to the system's actions.
- **Vehicle-in-the-loop (VIL) testing** includes the entire vehicle in a controlled environment where the vehicle and its surroundings are simulated to assess the system's performance in real-world scenarios.
- **Scenario-based testing** is similar to open-loop testing but is in a closed-loop setting. You test the system in various predefined scenarios to evaluate its real-time decision-making and control capabilities.

>[!NOTE]
>In this article, DIL and VIL testing aren't covered as part of the ValOps scope.

Together, open-loop and closed-loop testing offer a comprehensive approach to validate the safety and effectiveness of AD systems.

### Scenario management

A key component in AD systems testing is validating the system across a diverse and expansive set of scenarios. To validate the AD capabilities via open-loop and closed-loop testing, use a catalog of real scenarios to test the AD solution's ability to simulate the behavior of autonomous vehicles. 

Within ValOps, use [scenario management](../../solution-ideas/articles/avops-architecture.yml#scenario-management) to speed up the creation of scenario catalogs by automatically reading the route network, which is a part of a scenario, from publicly accessible and freely available digital maps. Scenarios can be based on real-world data that you collect from sensors, or they can be synthetically generated to test specific aspects of the software.

For example, scenarios might include:

- **Straight road driving**: Tests how the system handles lane keeping and speed control on a straight highway.
- **Intersection handling**: Evaluates the system's response to traffic signals, stop signs, and pedestrians who are crossing at intersections.
- **Obstacle detection**: Assesses the software's ability to detect and respond to static and dynamic obstacles, such as parked cars or moving vehicles.
- **Adverse weather conditions**: Simulates scenarios with rain, fog, or snow to test the robustness of sensor data processing and decision making.

By systematically running these scenarios, you can identify and address potential problems in the software's logic and performance before you move on to more complex closed-loop testing.

To achieve scenario management, you should:
 
 - Support open formats, such as .xodr from [OpenDRIVE](https://www.asam.net/standards/detail/opendrive/).
 - Consider non-Microsoft tools from [Cognata, Ansys, dSPACE](#deploy-this-scenario), or other providers.
 - Consider CARLA as an open-source software (OSS), lightweight alternative that also supports OpenDRIVE format. For more information, see [ScenarioRunner for CARLA](https://github.com/carla-simulator/scenario_runner).

#### Visualization of measurements and KPIs

The outputs of open-loop and closed-loop simulations generate measurements and KPIs. Use these outputs to validate the performance of the ADAS and AD software stack and identify areas for improvement. [Fabric](/fabric/get-started/microsoft-fabric-overview) and Power BI provide support for visualizing these measurements and KPIs. [Fabric copilot](/fabric/get-started/copilot-fabric-overview) can help validation engineers transform and analyze data, generate insights, and create visualizations. The following diagram illustrates an architecture that collects and stores measurement and KPI results in Fabric.  

:::image type="content" source="./images/example-resimulation-results-ingestion.png" alt-text="An architecture diagram that shows resimulation results that Fabric ingests." border="false" lightbox="./images/example-resimulation-results-ingestion.png":::

Use a [DirectQuery connector in Azure Data Explorer](/power-query/connectors/azure-data-explorer) to directly visualize and analyze results, such as distance-to-objects metrics, in a Power BI report or dashboard. Here's an example of how a report might display the results from a resimulation or recompute run:

:::image type="content" source="./images/example-resimulation-results-visualized.png" alt-text="A screenshot that shows a display of the results from a resimulation or recompute run." border="false" lightbox="./images/example-resimulation-results-visualized.png":::

### Potential use cases

ValOps is designed strictly for the validation of AD software. Automotive strong requirements for certification require strict adherence to industry standards and safety. They also require an abundance of HPC clusters to execute validation at scale. Other industries, like manufacturing, healthcare, and financial segments, that follow these requirements can also use this guidance.

### Alternatives

You might also consider the following Azure service for this solution.

#### Azure Kubernetes Service (AKS)

Batch provides an Azure-native option that provides scheduling and dynamic orchestration as a managed service to partners. An alternative to Batch for orchestrating simulation workloads for your HPC cluster is [AKS](/azure/aks/). With AKS, partners can use a familiar and popular open-source service like Kubernetes and benefit from the reliability and scalability of a managed service. For partners who are already using AKS or Kubernetes, we recommend that they continue to use AKS or use AKS for their HPC cluster.

#### AKS-based architecture

:::image type="content" source="./images/autonomous-vehicle-operations-valops-aks-architecture.png" alt-text="An architecture diagram that shows a solution for validating autonomous vehicle software with AKS." border="false" lightbox="./images/autonomous-vehicle-operations-valops-aks-architecture.png":::

#### Architecture overview

When you use AKS for ValOps, you can deploy and manage containerized simulation software on a cluster of Azure virtual machines (VMs). Similar to a ValOps implementation with Batch, you can store simulation data in [Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage), which provides scalability and security for large data sets. You can use [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning?view=azureml-api-2) to train machine learning models on the simulation data, which enhances the performance of ADAS and AD systems.

Because Batch provides scheduling and orchestration for HPC workloads, you need to be able to schedule workloads. One option for scheduling workloads is to use durable functions as an external orchestrator and scheduler. [Durable functions](/azure/azure-functions/durable/durable-functions-overview) can read from a metadata database to determine which sequences need validation and chunk them into batches for parallel processing. It sends these batches as events to a work queue, such as Kafka, where each event represents an activity in the durable function. Durable functions provide state management and easily integrate into an [Azure Data Factory](/azure/data-factory/introduction) or [Fabric](/fabric/get-started/microsoft-fabric-overview) pipeline or be called by an orchestrator like [Eclipse Symphony](https://projects.eclipse.org/projects/iot.symphony).

This approach aligns with the work queue job scheduling pattern, as described in the Kubernetes [documentation](https://kubernetes.io/docs/tasks/job/fine-parallel-processing-work-queue/). To achieve horizontal scalability, you can configure multiple pods to listen to the work queue or Kafka topic. The system receives an event through a durable function. One of the pods consumes the event and performs the reprocessing or resimulation of the chunk or batch.

The following diagram shows an example of a [Data Factory](/azure/data-factory/introduction) flow that invokes durable functions as part of a chain of tasks.

:::image type="content" source="./images/durable-functions.png" alt-text="A diagram of a Data Factory flow that shows integration with durable functions." border="false" lightbox="./images/durable-functions.png":::

#### Components

- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service that simplifies deploying, managing, and scaling containerized applications with built-in security and monitoring. Use AKS to deploy a Kubernetes cluster for validation use cases such as open-loop or closed-loop testing.
- [Durable functions](/azure/azure-functions/durable/durable-functions-overview) is a feature of [Azure Functions](/azure/well-architected/service-guides/azure-functions-security) that you can use to write stateful workflows and orchestrate complex, long-running processes in a serverless environment. You can use durable functions as an external orchestrator and scheduler for the AKS cluster.
- [Kafka](https://kafka.apache.org/) is an open-source distributed event streaming platform that you can use for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications. Use Kafka to handle event sourcing that is triggered in the workflow pipeline.
- An [Azure storage account](/azure/well-architected/service-guides/storage-accounts/reliability) provides a unique namespace to store and manage your Azure Storage data objects like blobs, files, queues, and tables, ensuring durability, high availability, and scalability. Use a storage account to store simulation data and results.

The following non-Microsoft tools are alternative options for job scheduling and orchestration on AKS.

- [Apache Airflow](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/executor/kubernetes.html) is an open-source platform that allows organizations to schedule and monitor workflow and is available in preview as a managed service in Data Factory.
- [Kubeflow](https://www.kubeflow.org/) is an open-source project that simplifies the deployment of workflows that run on Kubernetes.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Compliance with standards such as [ISO 26262](https://www.iso.org/obp/ui/#iso:std:iso:26262:-1:ed-1:v1:en) often requires more test hours, higher fidelity simulations, and extensive data processing to ensure the safety and reliability of automotive systems. These requirements increase compute costs because more resources are required to run these comprehensive tests. Right-sizing resources is crucial to optimize costs for your organization's ValOps implementation. You can use autoscaling, [Microsoft Cost Management](/azure/cost-management-billing/costs/overview-cost-management), resource allocation optimization, and scaling strategies. For more information on how to optimize scaling costs, see [Optimize scaling costs](/azure/well-architected/cost-optimization/optimize-scaling-costs). 

Here are more recommendations to help your organization lower costs with various types of compute cost models and profiles.

- Select the right VM for your job by using the [VM selector guide](https://azure.microsoft.com/pricing/vm-selector/?msockid=3338580647b1602718c8499943b1663a).  
- Deploy Azure resources based on your needs. Avoid deploying components that aren't adding value or meeting your requirements.  
- Ensure that the organization follows the best practices described in the [Batch and performance efficiency guide](/azure/well-architected/service-guides/azure-batch/performance-efficiency).
- Ensure that your organization follows [best practices for AKS scaling](/azure/cloud-adoption-framework/scenarios/app-platform/aks/scalability).
- Take advantage of Azure offerings for hosting application code. For guidance about how to choose the right service for your deployment, see [Choose an Azure compute service](/azure/architecture/guide/technology-choices/compute-decision-tree).  
- Use storage tiers to store cold data more cost efficiently. For more information, see [Access tiers overview](/azure/storage/blobs/access-tiers-overview) and other cost guidance for storage in the [Azure Blob Storage cost optimization guide](/azure/well-architected/service-guides/azure-blob-storage#cost-optimization).

Choose the best VM cost option for your organization's use case:

- **Pay-as-you-go** is a consumption-based pricing model where you pay for what you consume. Pay-as-you-go models are applicable to interactive, unplanned jobs.  
- [**Reserved instances**](https://azure.microsoft.com/pricing/reserved-vm-instances/?msockid=3338580647b1602718c8499943b1663a) can be cost effective for long-term workloads, such as for batch and long-running jobs like simulation and open-loop and closed-loop testing.
- [**Spot instances**](/azure/virtual-machines/spot-vms) can be useful for jobs that don't have a strict timeline to be completed, such as for dev/test jobs. For example, researchers might need to validate an experimental model against set of scenarios, and there's no time sensitivity for the workload.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

ValOps embraces the following key software engineering strategies.

- **Automate your deployment and maintain consistency** with infrastructure as code (IaC). You can use Bicep, Azure Resource Manager templates (ARM templates), Terraform, or another approach.
- **Mandate automated testing** to achieve operational excellence in validating autonomous vehicle software. Automated testing ensures consistent execution with minimal human intervention, which leads to reliable and repeatable results by reducing human error and increasing efficiency. Automated testing simulates a wide range of driving scenarios, including edge cases and rare events, which is critical for safety and reliability. Continuous integration and continuous delivery (CI/CD) provide immediate feedback on code changes, which accelerates problem resolution and maintains high quality standards. Automated testing can handle large volumes of test cases and complex scenarios that are impractical for manual testing. It ensures comprehensive coverage and robust validation of sensor data processing, decision-making algorithms, and control logic under various conditions. 

   By mandating automated testing, your organization can streamline validation processes, reduce costs, and improve the overall reliability and safety of its autonomous vehicle operations. Your organization can ensure that its software meets stringent safety standards and performs reliably in real-world conditions.

- **Regularly monitor the performance and usage of your Azure resources** to optimize costs and enhance performance. Use tools like Azure Monitor and Microsoft Cost Management.
- **For HPC clusters, use [Azure HPC health checks](https://github.com/Azure/azurehpc-health-checks?tab=readme-ov-file) on each compute node** to verify that the node is working properly. To prevent scheduling or running jobs on unhealthy nodes, mark them as down or offline. Health checking helps increase the reliability and throughput of a cluster by reducing preventable job failures due to misconfiguration, hardware failure, and other factors. 

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- To avoid cross-region latency, ensure that the storage location that you use for ValOps data is in the same region as the compute location. 
- When you handle large datasets, such as images or video files, or work with smaller objects that require high I/O performance, we don't recommended using Azure Files. Azure Files can slow down machine learning training or other workloads that require consistently low storage latency. We recommend using object storage with Blob Storage or Data Lake Storage for the highest level of performance while maintaining cost efficiency.
- Performance for storage is essential in an HPC application like ValOps. Blob Storage accounts with [Standard Azure Blob](/azure/storage/common/storage-account-overview) can deliver multi-terabits per second performance. You should use [premium block blob storage accounts](/azure/storage/blobs/storage-blob-block-blob-premium) if you need rapid responses and consistent low-latency scenarios, such as repeated reads of small objects. For more information, see [Blob storage performance and scalability checklist](/azure/storage/blobs/storage-performance-checklist).
- When you mount your storage account, use BlobFuse2 instead of older protocols like network file system (NFS). BlobFuse2 is built for Storage and provides validated end-to-end caching and streaming performance, which improves data access efficiency and reduces latency for repeat-access scenarios. It supports advanced caching mechanisms like block cache with prefetch that significantly improve read and write speeds. These improvements make it ideal for high-performance computing tasks in Batch.

  Unlike traditional virtual system mounts or NFS, which can suffer from higher latency and lower throughput, BlobFuse2 uses Azure infrastructure to deliver faster data transfer rates and better scalability. These results lead to more efficient processing of large datasets and improved overall performance for autonomous vehicle ValOps. For more information, see [What is BlobFuse?](/azure/storage/blobs/blobfuse2-what-is)  
  
  You can mount Blobfuse2 via scripts, which enable seamless integration for your existing workflows. 

- See scalability and performance targets for [Storage](/azure/storage/common/scalability-targets-standard-account).
- Based on the simulation requirements, you can use [Batch](/azure/batch/) to set up and maintain the necessary containers or VMs to meet the service-level objective (SLO) requirements. This task involves:
    - Provisioning the required containers or VMs.
    - Ensuring these resources are continuously available.
    - Aligning the availability and performance of these resources with the agreed-upon service levels.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

It's important to understand the division of responsibility between an automotive manufacturer and Microsoft. In a vehicle, the manufacturer owns the whole stack, but as the data moves to the cloud, some responsibilities transfer to Microsoft. Azure platform as a service (PaaS) layers provide built-in security on the physical stack, including the operating system. You can add the following capabilities to the existing infrastructure security components.

- Use [Azure Key Vault](https://azure.microsoft.com/services/key-vault) to maintain end-to-end security when you handle sensitive and business-critical elements, such as encryption keys, certificates, connection strings, and passwords. Key Vault offers a robust solution that fortifies the entire software development and supply chain process. With Key Vault, you can use automotive applications to help securely store and manage sensitive assets and ensure that they remain protected from potential cyber security threats. You can further enhance security by regulating access and permissions to critical resources with role-based access control (RBAC).  

  If regulatory requirements require an enhanced security solution with dedicated hardware, consider using [Azure Key Vault Managed HSM](/azure/key-vault/managed-hsm/overview). For even more stringent requirements, consider [Azure Cloud HSM](/azure/dedicated-hsm/overview), formerly Azure Dedicated HSM.  

- AD data requires strict data governance to help with data classification, lineage, tracking, and compliance. By using [Microsoft Purview](https://azure.microsoft.com/services/purview), your organization can ensure that its data is well-governed, secure, and compliant to support the development and deployment of safe and reliable autonomous vehicles.
- In addition to enforcing data compliance, your organization can use [Azure Policy](https://azure.microsoft.com/services/azure-policy) to enforce compliance and governance rules across its Azure resources.
- Implement RBAC to grant permissions to users and services on a least-privilege basis.
- Use Azure Security Center to proactively monitor and mitigate security threats.
- Ensure encryption of data at rest by using native Azure storage and database services. For more information, see [Data protection considerations](/azure/well-architected/security/design-storage).
- Use Microsoft Defender for Cloud to proactively monitor and mitigate security threats.

## Deploy this scenario

There are several options to deploy this scenario:

- [dSPACE](https://www.dspace.com/en/pub/start.cfm), in collaboration with Microsoft, developed SIMPHERA, a software solution designed to simulate and validate functions for AD. To deploy SIMPHERA, see the instructions in this [repository](https://github.com/dspace-group/simphera-reference-architecture-azure/tree/main).
- [Ansys](https://www.ansys.com/) worked with Microsoft to develop a deployable solution that aligns with this reference architecture. You can deploy the solution in [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/ansys.av_platform_azure?tab=Overview).
- [Cognata](https://azuremarketplace.microsoft.com/marketplace/apps/cognata.simcloud10?tab=Overview) SimCloud is a deployable, simulated test-drive environment that enhances the validation process. SimCloud generates fast, highly accurate results and reduces safety concerns. In addition, SimCloud addresses the high costs and limited scalability of road testing in the physical world.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Ryan Matsumura](https://www.linkedin.com/in/ryan-matsumura-4167257b) | Senior Program Manager, MCI SDV & Mobility
- [Jochen Schroeer](https://www.linkedin.com/in/jochen-schroeer) | Principal Architect (Service Line Mobility)
- [Gabriel Sallah](https://www.linkedin.com/in/gabrielsallah/) | Senior Specialist GBB
- [Wolfgang De Salvador](https://www.linkedin.com/in/wolfgang-de-salvador/) | Senior Specialist GBB
- [Lukasz Miroslaw](https://www.linkedin.com/in/lukaszmiroslaw/?originalSubdomain=ch) | Senior Specialist GBB
- [Benedict Berger](https://www.linkedin.com/in/benedict-berger-msft/) | Senior Product Manager

Other contributors:

- [Filipe Prezado](https://www.linkedin.com/in/filipe-prezado-9606bb14) | Principal Program Manager, MCI SDV & Mobility

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Batch?](/azure/batch/batch-technical-overview)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [What is ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)

## Related resources

For more information about developing DataOps for an AD system, see:
> [!div class="nextstepaction"]
> [Data operations for autonomous vehicle operations](./autonomous-vehicle-operations-dataops)

You might also be interested in these related articles:

- [Microsoft mobility documentation](/industry/mobility/)
- [AVOps design guide](../../guide/machine-learning/avops-design-guide.md)
- [SDV reference architecture](../../industries/automotive/software-defined-vehicle-reference-architecture)
- [Automotive messaging, data & analytics reference architecture](/azure/event-grid/mqtt-automotive-connectivity-and-data-solution)
- [Enhancing efficiency in AVOps with Generative AI](https://download.microsoft.com/download/c/e/c/ceccb875-9cc9-49d2-b658-88d9abc4dc3f/enhancing-efficiency-in-AVOps-with-generative-AI.pdf)
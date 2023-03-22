The example workload discussed below describes building out a simulation that runs automatically and assesses simulated vehicle function via an Azure DevOps pipeline. This pipeline runs each time an engineer checks a new version of the example function's source code or its simulation environment.

## Architecture

:::image type="content" border="false" source="images/building-blocks-autonomous-driving-simulation-environments.png" alt-text="Diagram showing building blocks for autonomous-driving simulation environments." lightbox="images/building-blocks-autonomous-driving-simulation-environments.png":::

*Download a [Visio file](https://arch-center.azureedge.net/building-blocks-autonomous-driving-simulation.vsdx) of this architecture.*

### User input layer

The developer will only interact with this layer. It contains the developer workstation (an Azure VM in our scope) and the specification file describing the simulation environment.

### Orchestration layer

"Orchestration" has a broad meaning: some of the problems described by the word are trivially solved; others are much more complex. For example, the
"orchestration" problem of creating, monitoring, and destroying containers and VMs is solved by many tools—the Azure API itself is a sufficient "orchestrator" for that! 

#### Workflow

However, it's important to break down the black box of "orchestration" into smaller components.

- Simulation API: This API receives a specification file and is the entry point for controlling simulation environments and simulation runs with the Orchestration Layer.

- Interpreter: This component interprets the specification file into a logical structure for the Simulation Manager.

- Simulation Manager: This is the state machine that converts the logical simulation environment object into desired states and actions to be used by other components. This is the component that triggers build, execute, and teardown of the simulation. It also manages internal dependencies and failure modes.

- Scheduler: This component assigns building blocks to infrastructure resources and starts them there. It accounts for hardware and access requirements, available resources, and resource limits.

- Environment Manager: This component watches the underlying infrastructure and responds to problems, such as when a container host goes down.

- Network Manager: This component manages the networks and routing for simulation environments. Each environment must live in an isolated network environment, with isolated building blocks receiving incoming connections for interactivity. This component will also be used to resolve building blocks within a simulation (for example, through an internal DNS).

- Access Manager: This component reflects authorization/authentication from Azure Active Directory (Azure AD) into the rest of the system.

- Configuration Manager: This component acts as a persistent storage mechanism for the state of the infrastructure and simulation environments.

- Infrastructure Abstraction: This is an abstraction layer that translates generic commands into specific Azure API commands for containers versus VMs.

- Storage Manager: This component manages provisioning and attaching storage for simulation environments (for example, VM root devices or container attached volumes).

- Resource Monitor: This component monitors infrastructure-level resource usage into a time series database, for export into the ADP's core monitoring.

- Log Manager: This component aggregates logs from building blocks for user inspection. It also exports logs into ADP core logging.

The Orchestration Layer is the primary focus of this example workload.

### Simulation Infrastructure Layer

This layer represents all running simulation environments.

- Simulation environment: The combination of building blocks defined by the Definition File and Parameters are created here, in network isolation from any other simulation environments.

- Building Block Contract: The written standard that defines how all building blocks send output, errors, and status to the Orchestration Layer.

- Building Block Pipeline: This area manages the creation and storage of building blocks.

- Building Block Repository: This is the storage and retrieval system for building-block images, such as a container registry and/or an Azure image gallery.

- Building Block Factory: The continuous integration and continuous deployment (CI/CD) pipeline which creates building block images using immutable, verifiable component packages (for example, dpkg or apt) in a declarative configuration language (for example, Chef or Ansible).

### Storage Layer

This layer durably and accessibly stores the results of the simulation. It's primarily the responsibility of the mobile application development platform (MADP) Data Lake workstream, though your output has to be manageable by that team.

- Storage interface: The interface that allows users to work with simulation result storage. This works in close concert with, or could be supplanted by, the Storage Manager orchestration component above.

- Storage: The storage mechanism used for saving simulation results (for example, Azure Blob Storage or Azure Disk Storage resources).

### Components

[Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) provides on-demand, scalable computing resources that give you the flexibility of virtualization, without having to buy and maintain the physical hardware.

[Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/#overview) is the fundamental building block for your private network in Azure. Azure Virtual Network enables many types of Azure resources, such as Azure Virtual Machines, to securely communicate with each other, the internet, and on-premises networks.

[Azure Container Instances](https://azure.microsoft.com/services/container-instances/#overview) offers the fastest and simplest way to run a container in Azure, without having to manage any VMs and without having to adopt a higher-level service.

[Azure Container Registry](https://azure.microsoft.com/services/container-registry/#overview) is a managed, private Docker registry service based on the open-source Docker Registry 2.0. You can use Azure container registries with your existing container development and deployment pipelines, or use Azure Container Registry Tasks to build container images in Azure. Build on demand, or fully automate builds with triggers, such as source code commits and base image updates.

[Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines) are part of the Azure DevOps Services and run automated builds, tests, and deployments. You can also use third-party CI/CD solutions such as Jenkins.

[Azure Active Directory](https://azure.microsoft.com/services/active-directory/#overview) is the cloud-based identity and access management service that authenticates users, services, and applications.

[Azure Storage](https://azure.microsoft.com/services/storage) offers a durable, highly available, and massively scalable cloud storage solution. It includes object, file, disk, queue, and table storage capabilities.

[Azure Monitor](https://azure.microsoft.com/services/monitor/#overview) collects monitoring telemetry from a variety of on-premises and Azure sources. This service aggregates and stores telemetry in a log data store that's optimized for cost and performance.

### Alternatives

This architecture uses VMs and containers for deploying the different tools and services. As an alternative, you can also use [Azure Kubernetes Services (AKS)](/azure/aks/intro-kubernetes). AKS offers serverless Kubernetes, an integrated CI/CD experience, and enterprise-grade security and governance.

The storage mechanism used for saving simulation results in this architecture is based on Azure Blob Storage or Azure Disk Storage. As an alternative for bigger workloads, you can also look at Azure's large-scale [data and analytics](https://azure.microsoft.com/solutions/big-data/#overview)  solutions for storing and analyzing data.

Also consider using [Azure Monitor](https://azure.microsoft.com/services/monitor/) to analyze and optimize the performance of your infrastructure, and to monitor and diagnose networking issues without logging into your VMs.

## Scenario details

To assess autonomous driving (AD), function engineers need to simulate the
behavior of vehicles with AD capabilities. Consider the following example driving scenario:

>   A test vehicle is autonomously driving at 80 mph in the right lane on a
>   3-lane highway. There is a truck 600 ft ahead driving in the same lane and
>   in the same direction at 55 mph. There is no vehicle nearby in the middle
>   lane. The road markers are visible, the sun is shining perpendicular to the
>   vehicle, and the road is dry.

A finite simulation of a vehicle's behavior using a scenario like this is called a *simulation run*. In the scenario above, your simulated vehicle's expected behavior is to comfortably pass the truck without causing an accident and without violating any traffic rules. By running a simulation for each new version of a function, AD function engineers test whether the new version still exhibits the expected behavior.

To run a simulation, AD function engineers commonly use a set of software applications. These can include [Virtual Test Drive](https://vires.mscsoftware.com/) (VTD), [Time Partition Testing](https://piketec.com/tpt/) (TPT), [Avionics Development System 2G](https://www.techsat.com/testsystems/ads2-productfamily) (ADS2), and [Automotive Data and Time-Triggered Framework](https://www.digitalwerk.net/adtf/) (ADTF), all of which communicate with each other according to their specific configurations for testing a given autonomous driving function such as the Highway Pilot. A deployment of this set of software tools and their configurations to physical and/or virtual machines (VMs) on-premises and/or in the cloud is called a *simulation environment*.

To ensure the validity of the test results generated by every simulation you run, you should ensure the simulation starts in a fresh simulation environment set to its initial state.

Every autonomous-driving team needs a separate set of applications in their simulation environment, with a unique configuration. Many teams will also need multiple different simulation environments. For example, to evaluate a LIDAR sensor you'll need very high resolution object simulation, but no other drivers, road markings, or other features. Though each environment is unique, there is significant overlap in the applications used. For example, many teams use VTD across multiple simulation environments.

It's possible to run a simulation in a simulation environment that is composed of reusable, encapsulated, and independently evaluated units. These units serve as the "building blocks" you'll use for automatic and on-demand creation of simulation environments in the Azure cloud. These simulation environments are also called automated driving platforms (ADP).

### Potential use cases

This solution is ideal for the automotive and transportation industries. Typical uses for this workload include:

- Automating driving tests.

- Prototyping, development, integration, testing, validation, and verification of control systems in the automotive industry.

- Recording vehicle data for visualization.

- Simulating complex driving scenarios in the automotive industry.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Availability and resiliency

Consider deploying VMs [across availability sets or availability zones](/azure/virtual-machines/availability), which help protect applications against planned maintenance events and unplanned outages.

An availability set is a logical grouping of VMs that allows Azure to understand how your application is built to provide for redundancy and availability.

Availability zones are unique physical locations within Azure regions that help protect VMs, applications, and data from datacenter failures. Each zone is made up of one or more datacenters. VMs and applications in zones can remain available even if there's a physical failure in a single datacenter.

### Scalability

You can scale Azure VMs either manually or by using [autoscaling features](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview).

For container deployments, [Azure Containers Instances](/azure/container-instances/container-instances-overview) and [Azure Kubernetes Services](/azure/aks/scale-cluster) are also designed to scale up or out manually or automatically.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

As with any other type of application, the simulation environment can be designed to handle sensitive data. Therefore, you should restrict who can sign in and use it, and you should also limit what data can be accessed based on the user's identity or role. Use [Azure AD](/azure/active-directory/fundamentals/active-directory-whatis) for identity and access control, and use [Azure Key Vault](/azure/key-vault/general/overview) to manage keys and secrets.

For general guidance on designing secure solutions, see the [Azure security documentation](/azure/security).

### DevOps

For deploying fresh simulation environments, it's best to use CI/CD processes using a solution such as Azure DevOps or GitHub Actions.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

In general, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs. You can also optimize your costs by following the process to right-size the capacity of your VMs from the beginning, along with simplified resizing as needed. Other considerations are described in the Cost section in [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/cost/overview).

## Next steps

Product documentation:

- [Azure Container Registry](/azure/container-registry/container-registry-intro)

- [Azure Container Instances](/azure/container-instances/container-instances-overview)

- [Azure Kubernetes Service](/azure/aks/intro-kubernetes)

- [Azure Active Directory](/azure/active-directory/fundamentals/active-directory-whatis)

- [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview)

- [Azure Virtual Machines](/azure/virtual-machines/linux/overview)

- [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops)
    / [GitHub](https://docs.github.com/en/get-started)

- [Azure Monitor](/azure/azure-monitor/overview)

Microsoft learning paths:

- [Implement and manage storage for Azure administrators](/training/paths/azure-administrator-manage-storage)

- [Deploy and manage compute resources for Azure administrators](/training/paths/azure-administrator-manage-compute-resources)

- [Configure and manage virtual networks for Azure administrators](/training/paths/azure-administrator-manage-virtual-networks)

- [Manage identities and governance for Azure administrators](/training/paths/azure-administrator-manage-identities-governance)

- [Monitor and back up resources for Azure administrators](/training/paths/azure-administrator-monitor-backup-resources)

## Related resources

Azure Architecture Center overview articles:

- [Choose an Azure compute service for your application](/azure/architecture/guide/technology-choices/compute-decision-tree)

- [Select an Azure data store for your application](/azure/architecture/guide/technology-choices/data-store-decision-tree)

- [Big compute architecture style](/azure/architecture/guide/architecture-styles/big-compute)

Relevant architectures:

- [Process real-time vehicle data using IoT](/azure/architecture/example-scenario/data/realtime-analytics-vehicle-iot)

- [Real-time asset tracking and management](/azure/architecture/solution-ideas/articles/real-time-asset-tracking-mgmt-iot-central)

- [Machine teaching with the Microsoft Autonomous Systems platform](/azure/architecture/solution-ideas/articles/autonomous-systems)

- [IoT and data analytics](/azure/architecture/example-scenario/data/big-data-with-iot)

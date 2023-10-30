The transition to **Software Defined Vehicles (SDV)** requires a different approach on the development, deployment, monitoring and management of automotive software stacks across the entire automotive industry. Automotive Original Equipment Manufacturers (OEMs) are embracing a *Shift-Left* strategy, which involves conducting testing earlier in the product development cycle. In this approach, the in-vehicle software stack undergoes comprehensive simulation and testing within cloud-based environments. This example architecture outlines how to leverage the software stack and distributions provided by the [Eclipse Software-defined Vehicle Working Group](https://sdv.eclipse.org/) in conjunction with GitHub and Azure services to develop an end-to-end automotive software stack, implement Software-in-the-Loop (SiL) testing and orchestrate Hardware-in-the-Loop (HiL) and engineering vehicle fleets validation.

This guide demonstrates how to:

* Integrate state of the art **developer tools** into the overall development process.
* Work with and manage **automotive source code**.
* Build **virtual vehicle environments** automatically as part of CI/CD pipelines and manage their execution for virtual testing.
* Orchestrate deployments for **software-in-the-loop (SiL)** tests (virtual testing) and **hardware-in-the-loop (HiL)** testing.
* Use highly scalable services to collect and analyze data produced during **validation tests** and **field usage**

## Architecture

:::image type="content" source="images/sdv-e2e-ref-architecture-high-level-overview.svg" alt-text="Software Defined Vehicle (SDV) Toolchain overvie#w" lightbox="images/sdv-e2e-ref-architecture-high-level-overview.svg":::

The Architecture consists of six key building blocks:

1. The **Automotive Software Defined Vehicle (SDV) Toolchain** is a plug-and-play approach that is open and configurable using our developer and DevOps assets. It reduces reliance on in-vehicle silicon by establishing highly configurable and flexible **virtual Electronic Control Units (vECU)** as well as **virtual High Performance Computers (vHPC)** environments on Azure to accelerate development, testing and validation of automotive software. The approach also ensures compatibility with edge / in-vehicle silicon to ensure bit, timing, and code parity. 

2. An **Automotive Software Stack** which encompasses a diverse range of technologies and frameworks, often governed by industry standards and collaborative efforts such as the *Eclipse Foundation Software Defined Vehicle Working Group*. Eclipse projects include non-differentiating components for vehicle connectivity, messaging and communications protocol, in-vehicle digital twin abstraction layer, advanced driver-assistance systems (ADAS), and autonomous driving solutions. Automotive Software Stacks are designed to provide a robust foundation for automakers and software developers, ensuring seamless integration and compatibility across the automotive ecosystem with a community-driven approach to technological advancements.

3. The **GitHub and Azure Marketplace** enable partners such as Tier I and automotive software tool vendors to offer solutions such as managed automotive software stacks, virtual ECUs and developer tooling and integrate them with the SDV Toolchain.

4. **Hardware-in-the-loop Testing** allows for test and validation execution on target hardware, and is managed using the same orchestration concept as the Software-in-the-loop for validation with edge / in-vehicle silicon. The Specialized hardware is connected with fast network access and secure networks.

5. **[Vehicle Messaging, data and analytics](https://learn.microsoft.com/azure/event-grid/mqtt-automotive-connectivity-and-data-solution)** provides required infrastructure for managing vehicles and devices, deploy and operate connected vehicle applications with dependencies to in-vehicle software components and provide data analytics services for engineering, operations and mobility-based services. The **[Data Analytics for automotive test fleets](/azure/architecture/industries/automotive/automotive-telemetry-analytics)** provides more detail on data collection and analytics for component and system validation.

6. **[Autonomous Vehicle Operations](https://learn.microsoft.com/azure/architecture/solution-ideas/articles/avops-architecture)** enables automotive OEMs to develop automated driving solutions on Azure. It describes how to manage Data Operations from autonomous vehicles (DataOps), automated feature extraction, labeling, model training for perception and sensor fusion (MLOps), and testing developed models in simulated environments (ValOps). It integrates with the SDV Toolchain by providing trained models and executing software validation.

This reference focuses on a general *SDV Toolchain* and *Automotive Software Stack*, and provides examples of for implementations using open-source projects under the purview of the Eclipse SDV Working Group such as [Eclipse uProtocol](https://github.com/eclipse-uprotocol), [Eclipse Chariott](https://github.com/eclipse-chariott), [Eclipse Ibeji](https://github.com/eclipse-ibeji), Eclipse Freya and Eclipse Agemo.

*Microsoft is a member of the [Eclipse Software Defined Vehicle](https://www.eclipse.org/org/workinggroups/sdv-charter.php) working group, a forum for open collaboration using open source for vehicle software platforms.*

### Workflow

This chapter explains which components compose the Automotive SDV Toolchain. It also describes the typical workflow for a developer to define, orchestrate and execute virtual tests for automotive software.

The Automotive SDV Toolchain is composed by the following three key blocks:

* **Development Tools** includes development and collaboration services such as GitHub, Microsoft Dev Box, Visual Code and Azure Container Registry. It also includes GitHub’s code scanning capabilities that use the CodeQL analysis engine to find security bugs in source code and surface alerts in pull requests, before the vulnerable code gets merged and released.

* **Development, Validation and Integration** – a combination of metadata and orchestration services that allow developers to configure, build, deploy and orchestrate on-demand virtual execution environments to streamline the development and testing process, integrating with existing toolchains and supporting multiple application formats, binaries, operating systems and runtime environments.

* **Execution Environment** – the set of Azure services: Azure Deployment Environments, Azure Compute Gallery, Azure Container Registry, Azure Arc, Azure Compute like Arm64-based Azure Virtual Machines and High Performance Computing and Azure Networking Services and Connectivity Services like ExpressRoute that enable reliable, repeatable and observable cloud and edge environments to build, test and validate automotive software stacks.

### Deploying Virtual ECUs

:::image type="content" source="images/sdv-e2e-ref-architecture-automotive-sdv-toolchain.svg" alt-text="Components and Workflow of the Automotive SDV Toolchain" lightbox="images/sdv-e2e-ref-architecture-automotive-sdv-toolchain.svg":::

The following flow describes how an automotive software developer belonging to the fictitious company *Contoso Automotive* uses the Automotive SDV Toolchain to:

* set up a development environment in minutes
* trigger an update change in the software-in-the-loop cloud infrastructure to deploy a virtual ECU running on an Arm64-based Virtual Machine.

*Contoso Automotive* is adding a new automotive High Performance Compute Unit (HPC) to the upcoming vehicle model and must onboard a new development team to develop containerized applications. The hardware for the vehicle isn't yet available, but compressed timelines mean that the software functionality must be developed and validated in parallel.

1. The automotive developer requests a **Microsoft Dev Box**. The dev box is preconfigured with all required development tools (such as Visual Studio Code and Android Studio) and all required extensions (such as GitHub Copilot) to work with the *Contoso Automotive* applications.
1. The automotive developer performs a check-out of the automotive **application code and metadata** that describes the upcoming vehicle configuration, the included HPCs and electronic control units (ECU), and the required deployment to perform software-in-the-loop (SiL) validation.
1. The automotive developer uses the **metadata extensions** to make configuration adjustments, such as changing the characteristics of the HPC based on new information from the engineering team.
1. Changing the configuration triggers the **metadata processing extension** that performs metadata validation, generates all required artifacts and configures an execution environment deployment campaign.
1. Once all configuration changes have been completed, the developer submits a Pull Request that triggers a **GitHub Action** for deployment.
1. The deployment GitHub action triggers the **Metadata and Orchestration Services**, which executes the deployment campaign.
1. The **Metadata and Orchestration Service** uses the **Azure Development Environment** to deploy the required compute to simulate the new version of the automotive electric / electronic architecture.
1. The **Metadata and Orchestration Service** sets the desired state of the compute based on the campaign. It uses the artifacts store to mount and configure the required ***Virtual HPC and ECU images***.

#### Software-Over-The-Air Updates for Automotive Applications

*Contoso Automotive* is ready to deploy containerized automotive applications to their engineering test fleet to perform integration testing. The *automotive developer* builds, test and validate the new version of their application and deploy it to the vehicle.

:::image type="content" source="images/sdv-e2e-ref-architecture-software-update.svg" alt-text="Software Update" lightbox="images/sdv-e2e-ref-architecture-software-update.svg":::

1. The *automotive developer* creates a release. The release contains a definition of the *software stack container* desired state, and definition of the build.
2. The **Toolchain and orchestration** services trigger the release process. They deploy the required infrastructure to build, validate and release software containers.
3. During execution, the software is build, validated and release with container-based tooling. Depending on the requirements of the tools, they can be deployed on AKS or dedicated Virtual Machines. Once the build is complete, the results are pushed to the **Azure Container Registry** for released containers and the changes are registered in the **OTA Server**.
4. The **OTA Client** has a dedicated **OTA Agent** for container-based applications. The *Desired State Seeking Agent* connects to the **toolchain & orchestration services* to retrieve the desired state definition.
5. The **container orchestration** engine will download and activate the desired containers from the **Azure Container Registry**

### Automotive Software Stack Workflow

This scenario presents a generic Automotive Software stack synchronizing its state with the Azure Cloud.

The represented stack has the following components:

* A **Service Registry** provides facilities to register and discover services within the vehicle.
* The **Dynamic Topic Management** enables services to subscribe and publish messages to named topics, abstracting the communication protocol.
* The **In-Vehicle Digital Twin** service maintains the state of the vehicle, including signals from Electronic Control Units and compute units such as AD/ADAS and Infotainment.
* The **Digital Twin Cloud Synchronization** synchronizes the local state of the vehicle with the state in the cloud to enable digital products and services that don't require a direct connection to the car.

:::image type="content" source="images/sdv-e2e-ref-architecture-automotive-software-stack.svg" alt-text="Software Stack" lightbox="images/sdv-e2e-ref-architecture-automotive-software-stack.svg":::

1. All components register their capabilities using the **Service Registry**.
1. **Vehicle Compute** register the state descriptions to the *Digital Twin Provider* of the *In-Vehicle Digital Twin* service. After registration, the compute units can publish updates on their state.
    1. Vehicle Compute can register more complex state objects and interactions.
    1. Vehicle Electronic Control Units register which signals are available to automotive applications, and which commands can be accepted.
1. The **In-vehicle digital twin** publishes state changes and updates to the **Dynamic Topic Management**. These updates are organized in topics.
1. **Automotive applications** can subscribe to messages from any source managed by the Dynamic Topic Managed. These applications are subscribed to relevant topics and react on state changes. They can also publish their own messages.
1. The **In-Vehicle Digital Twin Service** also publishes selected topics to the **Digital Twin Cloud Synchronization** service.
1. The **Digital Twin Cloud Synchronization** can use a *cartographer* to map the topic names (using a *Digital Twin Mapping Service*) to the equivalent names on the cloud. This harmonization reduces the dependency between vehicle and cloud software and among vehicle models.
1. The **cloud connector** publishes updates to the cloud and subscribes to receive state changes published by other services and applications
1. The **Event Grid** service routes the messages to the relevant services and applications. The state of the vehicle is stored using services such as **Azure Cache for Redis** to store the last known value for fast access and retrieval and **Azure Data Explorer** to provide short term vehicle state history and analytics.

## Components

This reference architecture references the following GitHub and Azure Components:

### Development Tools

* [GitHub](https://github.com/) is a development platform that enables you to host and review code, manage projects, collaborate and build software alongside developers inside your organization and outside.
* [Microsoft Dev Box](https://learn.microsoft.com/azure/dev-box/overview-what-is-microsoft-dev-box) provides developers with self-service access to ready-to-code, cloud-based workstations—known as dev boxes that can be customized with project-specific tools, source code, and prebuilt binaries for immediate workflow integration.
* [Azure Container Registry](https://learn.microsoft.com/azure/container-registry/) allows the build, store, and management of container images and artifacts in a private registry for all types of container deployments. Automotive software has adopted container based automotive applications and workloads. The SDV Toolchain user Azure container registries as part of container development and deployment processes and pipelines.
* [Visual Studio Code](https://code.visualstudio.com/) is a lightweight source code editor available for Windows, macOS and Linux. It has a rich ecosystem of extensions for several languages and runtimes.

### Execution Environment

* [Azure Deployment Environments](https://learn.microsoft.com/azure/deployment-environments/) - provides a preconfigured collection of Azure Resources. It empowers development teams to quickly and easily spin up infrastructure with project-based templates that establish consistency and best practices while maximizing security.
* [Azure Compute](https://azure.microsoft.com/products/category/compute/) is a comprehensive suite of cloud services from Microsoft's Azure platform that empowers developers to run their automotive software stacks, applications and workloads on virtual machines (VMs) and containers. It offers a wide array of compute varieties, including memory-optimized, CPU-optimized, high-performance, and general-purpose.
* [Azure Compute Gallery](https://learn.microsoft.com/azure/virtual-machines/azure-compute-gallery) provides support for versioning and grouping of resources for easier management, capability to share images (an image is a copy of either a full VM including any attached data disks or just the OS disk) with the community, across subscriptions and between Active Directory (AD) tenants and scale deployments with resource replicas in each Azure region and many other features, the Azure Compute Gallery provides structure and organization around automotive software stacks artifacts.
* [Azure Arc](https://learn.microsoft.com/azure/azure-arc/) is a bridge that simplifies governance and management and delivers a consistent Cloud to Hardware in the Loop management platform. Automotive OEM can use Azure Arc to control and govern increasingly complex Hardware in the Loop (HiL) environments that extend across data centers. Each HiL environment possesses its own set of management tools where the new developer inner loop and DevOps Outer Loop operational models.
* [Azure Blob Storage](https://learn.microsoft.com/azure/storage/blobs/) - a massively scalable object storage for any type of unstructured data, images, videos, audio and documents produced and consumed by automotive software stacks.
* [Azure Networking Services](https://learn.microsoft.com/azure/networking/fundamentals/networking-overview) provides global, secure and reliable networking services. Automotive software stacks require data processing pipelines for developing and testing autonomous and assisted driving solutions. Development tools also need to Hardware in the Loop farms. The networking services in Azure provide various networking capabilities like connectivity services, application protection services, application delivery services and networking monitoring that can be used together or separately.

## Alternatives

The selection of the right type of Azure services chosen for a specific implementation of the architecture depends on a multitude of factors.

The Deploy this scenario section of the architecture uses Azure Kubernetes Service (AKS). This offers serverless Kubernetes for running microservices, an integrated continuous integration and continuous deployment (CI/CD) experience, and enterprise-grade security and governance. As an alternative, you can run microservices in Azure Container Instances, which offers a fastest and simplest way to run a container in Azure, without having to adopt a higher-level service, such as Azure Kubernetes Service (AKS)

The Deploy this scenario section of the architecture suggestes the use of Event Hub and/or Service Bus for the implementation of uBus service. The [Choose between Azure messaging services](https://learn.microsoft.com/en-us/azure/service-bus-messaging/compare-messaging-services) article describes the differences between these services, and helps you understand which one to choose for your specific implementation. In many cases, the messaging services are complementary and can be used together.

The applications and services referenced in this Architecure are deployed using Azure-native Azure Resource Manager templates (ARM templates) or Bicep. As an alternative consider using Terraform scripts for provisioning and managing cloud infrastructure.

If you are considering alternatives for the Vehicle Messaging, Data & Analytics layer of the Architecture, please review the [Alternatives](https://learn.microsoft.com/en-us/azure/event-grid/mqtt-automotive-connectivity-and-data-solution#alternatives) section in the Automotive messaging, data & analytics reference architecture.

## Scenario details

Autonomous and connected SDVs open a whole new world of functionality, serviceability, and reliability. With hardware and software decoupled, OEMs can now develop independent applications to address specific functions and services, making it much easier to update or add software to the overall vehicle platform. As a result, automobile makers and their suppliers are forced to adjust their automotive operations to enable agile software development cycles, which are more flexible and adaptable to shorter development cycles, frequent releases, and focus on collaboration and continuous improvement.

Without a standardized, open and configurable toolchain strategy, OEMs can end up with a landscape of scattered tools. For a truly agile software development strategy, companies need to have a unified toolchain based on modern cloud-based native platform that increases developers’ abilities to collaborate and reuse software and opens innovation opportunities for application development by third parties that could have strong software expertise but no previous automotive hardware experience.

This automotive reference architecture is designed to meet the demands of the rapidly evolving automotive industry. Embracing the principles of "shift left," this architecture emphasizes early integration of software and hardware components, enabling continuous testing and validation from the early stages of development. Virtualization plays a pivotal role, allowing the creation of virtual prototypes and test environments that accelerate innovation and reduce physical prototype requirements. The heart of this architecture lies in its robust CI/CD pipeline automation, ensuring seamless integration, testing, and deployment of software updates throughout the vehicle's lifecycle. This agility enables fast software updates, addressing security vulnerabilities, enhancing performance, and delivering new features promptly, ultimately offering consumers a safer and more feature-rich driving experience.

:::image type="content" source="images/sdv-e2e-ref-architecture-scenario.svg" alt-text="Software Defined Vehicle Scenarios" lightbox="images/sdv-e2e-ref-architecture-scenario.svg":::

## Potential Use Cases

* **Developer Onboarding**: Accelerate the onboarding of automotive software developers by providing an open and fully configured automotive development environment.
* **Efficient Development**: Simulate the behavior's of a variety of hardware and software combinations and reduce the dependency to edge/in-vehicle silicon early in the development process.
* **Software-in-the Loop Validation**: Validate the behavior of your software application by running automated pipelines for build, test and validation using compute resources on the cloud for a faster development cycle.
* **Hardware-in-the-Loop Validation**: Simplify deployment and monitoring of the Hardware-in-the-Loop farms
* **Validate with a test fleet**: Collect software metrics, logs and traces of the software applications as well as vehicle telemetry and signal data to build a comprehensive view of the vehicle behavior for validation, root cause analysis and homologation.
* **Deploy and Manage**: create traceable software releases that can be updated and managed using DevOps concepts the vehicle fleet.
* **Understand and Improve**: use information collected from the field to drive improvements in your software applications.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

When deploying and configuring Azure services, it's essential to follow best practices to ensure a secure, efficient, and cost-effective environment. Begin by defining your Azure resources, such as virtual machines,  kubernetes clusters, messaging services and data and analytics services according to your implementation specific requirements. Leverage Azure Resource Manager templates for Infrastructure as Code (IaC) to automate deployment and maintain consistency. Implement role-based access control (RBAC) to grant permissions to users and services on a least-privilege basis. Utilize Azure Security Center to monitor and mitigate security threats proactively. For scalability and redundancy, consider using Azure Load Balancers and Azure Availability Sets or Zones. Additionally, regularly monitor your Azure resources' performance and usage to optimize costs and enhance performance, using tools like Azure Monitor and Microsoft Cost Management. Following these deployment and configuration recommendations will help you effectively manage your Azure environment.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](https://learn.microsoft.com/azure/architecture/framework/resiliency/overview).

* Running an end-to-end service-oriented application infrastructure to support the implementation of a distributed communication protocol platform on Azure with modern continuous integration and continuous deployment (CI/CD) requires a reliable and high available architecture. The [Azure Well-Architected Framework review - Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/well-architected/services/compute/azure-kubernetes-service/azure-kubernetes-service) provides architectural guidance and best practices for managing and running services on Azure Kubernetes Service (AKS).
* Hardware in the Loop (HiL) testing is an indispensable and critical part of the automotive software development process and test strategy. When designing and implementing the network architecture to the HiL farms consider [Designing for high availability with ExpressRoute](https://learn.microsoft.com/en-us/azure/expressroute/designing-for-high-availability-with-expressroute) to reduce single point of failure and maximize availability of remote environments to your development and test teams.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](https://learn.microsoft.com/azure/architecture/framework/security/overview).

* Security is one of the most important aspects of any architecture and ensuring security in complex systems depends on understanding different contexts like business, social and technical. Consider adopting GitHub’s code scanning capabilities to find and fix security issues and critical defects earlier [GitHub enables the development of functional safety applications by adding support for coding standards AUTOSAR C++ and CERT C++](https://github.blog/2022-06-20-adding-support-for-coding-standards-autosar-c-and-cert-c/ ) in the development process. 
* Consider adopting the following best practices to [Secure your end-to-end supply chain on GitHub](https://docs.github.com/en/code-security/supply-chain-security/end-to-end-supply-chain/end-to-end-supply-chain-overview).git

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](https://learn.microsoft.com/azure/architecture/framework/cost/overview).

* When creating Virtual ECUs, make sure that the [virtual machine size](https://learn.microsoft.com/azure/virtual-machines/sizes) matches the requirements. Modifying the configuration to use larger sizes than necessary can increase the cost drastically, specially in scenarios where multiple machines operate in parallel to complete long running tasks.
* For build, validation and testing tasks that aren't time critical, consider the usage of [Azure Spot Virtual Machines](https://learn.microsoft.com/azure/virtual-machines/spot-vms). These machines allow you to take advantage of unused capacity with significant cost savings.
* If you have a [Microsoft Azure Consumption Commitment](https://learn.microsoft.com/azure/cost-management-billing/manage/track-consumption-commitment), consider using [eligible partner offerings](https://learn.microsoft.com/marketplace/azure-consumption-commitment-benefit#determine-which-offers-are-eligible-for-azure-consumption-commitments-maccctc) in the Azure Marketplace when deploying development tools and virtual ECUs in the execution environment.
* Refer to the [Autonomous Vehicle Operations](https://learn.microsoft.com/azure/architecture/solution-ideas/articles/avops-architecture#cost-optimization) cost optimization section for more tips when running autonomous vehicle development workloads.
* GitHub Copilot can significantly speed up the software development process by providing real-time code suggestions and auto-completions. Automotive software engineers can write code faster and more efficiently, reducing time-to-market for new vehicle features and updates.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

* The Automotive Software Defined Vehicle (SDV) Toolchain embraces key software engineering disciplines like infrastructure as code environment provisioning, continuous integration and continuous delivery (CI/CD) pipelines for automotive software stacks build and release, automated testing to transition to a shift-left approach and configuration as code to avoid environments configuration drift. Consider adopting the above key principles across all your workloads for consistency, repetition and early detection of issues. 
* Consider Azure Arc enabled infrastructure to simplify governance and management across Azure cloud, on-premises environments and Hardware-in-the-Loop testing and validation farms.
* GitHub Copilot's AI-powered assistance can enhance the overall code quality by reducing the likelihood of human errors and standardizing coding practices. This is crucial in the automotive industry where software safety and reliability are paramount.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

* Consider what tasks can be parallelized as part of your build / test pipelines.
* Consider implementing [Performance efficiency patterns](https://learn.microsoft.com/en-us/azure/well-architected/scalability/performance-efficiency-patterns ) for performant applications and workloads based on the Distributed Communication Protocol example.

## Deploy this scenario

The Eclipse Software Defined Vehicle has a code-source first approach as their main tenant. That provides a large amount of flexibility for implementation. The following examples use existing Eclipse projects and describe their interaction with Azure Services.

### Distributed Communication Protocol on Azure Example

[Eclipse uProtocol](https://github.com/eclipse-uprotocol) is one of many  distributed communication protocols used in automotive. It's a transport agnostic, layered communication protocol that builds on top of existing automotive and Internet standards. It provides a ubiquitous language for discovery, subscription, messaging, and more, enabling apps and services running on any heterogeneous system to communicate with each other.

The following overview describes the services required to implement a distributed communication protocol using uProtocol as an example with Azure Services.

#### High Level Overview

The following components are part of the *uProtocol*:

:::image type="content" source="images/sdv-e2e-ref-architecture-uProtocol-on-Azure.svg" alt-text="Distributed Communication Protocol uProtocol on Azure" lightbox="images/sdv-e2e-ref-architecture-uProtocol-on-Azure.svg":::

* The vehicle sends messages with the **cloud connector** using the *uProtocol* definition over MQTT to the **Event Grid** service.
* **uEs** are applications and services that provide functionality to end users. These apps use the Core UEs for discovery, subscription and access to the digital twin.
* The **Cloud Gateway** is the cloud service that devices connect with to communicate with the Back-office domain/device.
* The **uStreamer** is an event dispatcher that enables seamless communication between *uEs* on different devices whom might talk different transport layer protocols. It performs functionality such as file transfer, event buffering and more. For example, when events need to move from one transport to the next it flows through the streamer. It can be equated to an IP router.
* **uBus** is a message bus that dispatches *CEs* between *uEs* over a common transport. It provides multicast and forwarding functionality (works like a network switch).
* The **uCDS** central discovery service provides a means for uEs to discover each other, their location (address), properties, and more.
* **uSubscription** is a subscription management service that is responsible for managing the publisher/subscriber design pattern for the *uEs*.
* **uTwin** Local cache of published events. the uTwin stores the published message using a primary key to enable local software components to retrieve it. This primary key is the full name of the Topic, hence also including the device name. The fact that the primary key represents a topic ensures that only the last event of a given topic is stored in the uTwin. The collection of events stored in a uTwin instance of a device, whose keys include a specific device name (for example, deviceA), represent the digital twin of that device (deviceA in our example). Examples of events for a vehicle include updates on tire pressure, window position, gear position, vehicle mode (driving, parked), and in general any information that is published within the vehicle for operating it and activating its features.

The following suggested services are relevant to a *uProtocol* implementation on Azure:

| uProtocol Component | Functionality | Azure Service |
|---------------------|---------------|---------------|
| Cloud Gateway       | MQTT Broker   | Event Grid |
| uStreamer           | File Transfer, Event Buffering, D2D Routing, Protocol Translation | Event Hubs, Storage, Functions, AKS |
| uDiscovery          | Service Discovery              | Microservices on AKS
| uBus                | Multicast Forwarding | Event Hubs, Service Bus, Event Grid |
| uSubscription       | Pub/Sub Topic Management |  Microservices on AKS |
| uTwin               | Last Known State | Azure Digital Twin, Azure Redis Cache |

*For additional information about uProtocol components, software development kits (SDK) and documentation refer to the [uProtocol github repository](https://github.com/eclipse-uprotocol)*

#### Provisioning of Devices

<!-- diagram needs to be reviewed to ensure we have the latest understanding -->

:::image type="content" source="images/sdv-e2e-ref-architecture-uProtocol-Provisioning.svg" alt-text="uProtocol Provisioning Flow" lightbox="images/sdv-e2e-ref-architecture-uProtocol-Provisioning.svg":::

1. The **Factory System** commissions the vehicle device to the desired construction state. Commissioning includes firmware & software initial installation and configuration. As part of this process, the factory system obtains and writes the device *certificate*, created from the **Public Key Infrastructure** provider.
1. The **Factory System** registers the vehicle & device using the *Vehicle & Device Provisioning API*.
1. The *device registration* application registers the device identity in **Device Provisioning / Device Registry**.
1. The information about authentication and authorization is stored in **Azure Active Directory**.
1. The Factory system triggers the **device provisioning client** to connect to the **Device Provisioning Service**. The device retrieves connection information to the assigned *MQTT Broker* feature in **Event Grid**.
1. The factory system triggers the device to establish a connection to the  *MQTT broker* feature in **Event Grid** for the first time.
    1. **Event Grid** authenticates the device using the *CA Root Certificate* and extracts the client information.
1. **Event Grid** manages authorization for allowed topics using the device information stored in **Active Directory**.
1. The OEM **Dealer System** triggers the registration of a new device if a part replacement is required.

### Eclipse Automotive Software Stack Example

The following architecture describes an Automotive Software Stack based on Eclipse project components. It can also use Eclipse uProtocol as a communication protocol.

:::image type="content" source="images/sdv-e2e-ref-architecture-sample-automotive-stack.svg" alt-text="Eclipse Software Defined Vehicle based automotive software stack" lightbox="images/sdv-e2e-ref-architecture-sample-automotive-stack.svg":::

* [Eclipse Chariott](https://projects.eclipse.org/projects/automotive.chariott) is a gRPC service that provides a common interface for interacting with applications. It facilitates Service Discovery for applications to advertise their capabilities by registering themselves with Chariott's service registry.
* [Eclipse Ibeji](https://projects.eclipse.org/projects/automotive.ibeji) provides the capability to express a digital representation of the vehicle state and its capabilities through an extensible, open and dynamic architecture that provides access to the vehicle hardware, sensors and capabilities.
* [Eclipse Freyja](https://github.com/eclipse-ibeji/freyja) is an application that enables synchronization between the digital twin state on the vehicle (the "instance digital twin") and the digital twin state in the cloud (the "canonical digital twin")
* [Eclipse Agemo](https://github.com/eclipse-chariott/Agemo) is a gRPC service that provides publish/subscribe functionality for applications within the vehicle, including Eclipse Ibeji and Eclipse Chariott.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

* [Mario Ortegon Cabrera](http://www.linkedin.com/in/marioortegon) | Principal Program Manager, MCI SDV & Mobility
* [Daniel Lueddecke](https://www.linkedin.com/in/daniellueddecke/) | Cloud Solution Architect, Automotive
* [Filipe Prezado](https://www.linkedin.com/in/filipe-prezado-9606bb14) | Principal Program Manager, MCI SDV & Mobility
* [Sandeep Pujar](https://www.linkedin.com/in/spujar/) | Principal PM Manager, Azure Messaging
* [Ashita Rastogi](https://www.linkedin.com/in/ashitarastogi/) | Principal Program Manager, Azure Messaging
* [Boris Scholl](https://www.linkedin.com/in/bscholl/) | General Manager, Partner Architect - Azure Cloud & AI

Other contributors:

* [Frank Kaleck](https://www.linkedin.com/in/frank-kaleck) | Industry Advisor - Manufacturing, Mobility & Automotive
* [Frederick Chong](https://www.linkedin.com/in/frederick-chong-5a00224) | Principal PM Manager, MCIGET SDV & Mobility
* [Mehmet Kucukgoz](https://www.linkedin.com/in/mehmetkucukgoz/) | Principal PM Manager, Azure IoT Hub

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

* [GitHub enables the development of functional safety applications by adding support for coding standards AUTOSAR C++ and CERT C++](https://github.blog/2022-06-20-adding-support-for-coding-standards-autosar-c-and-cert-c/)
* [Getting started with GitHub Copilot](https://docs.github.com/copilot/getting-started-with-github-copilot)

## Related resources

The following articles describe related architectures:

* [Automotive messaging, data & analytics reference architecture](https://learn.microsoft.com/en-us/azure/event-grid/mqtt-automotive-connectivity-and-data-solution) describes how to connect vehicles to the cloud and process messages for applications and analytics.
* [Create an Autonomous Vehicle Operations (AVOps) solution](https://learn.microsoft.com/azure/architecture/solution-ideas/articles/avops-architecture) for a broader look into automotive digital engineering for autonomous and assisted driving.
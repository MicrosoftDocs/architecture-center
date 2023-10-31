The transition to **software-defined vehicles (SDVs)** requires a different approach on the development, deployment, monitoring and management of automotive software stacks across the entire automotive industry. Automotive original equipment manufacturers (OEMs) are embracing a *shift-left* strategy, which involves conducting testing early in the product development cycle. In this approach, the in-vehicle software stack undergoes comprehensive simulation and testing within cloud-based environments. The example architecture in this article outlines how to leverage the software stack and distributions provided by the [Eclipse software-defined vehicle working group](https://sdv.eclipse.org) in conjunction with GitHub and Azure services to develop an end-to-end automotive software stack, implement software in the loop (SiL) testing and orchestrate hardware in the loop (HiL) and engineering vehicle fleets validation.

This guide demonstrates how to:

* Integrate state of the art **developer tools** into the overall development process.
* Work with and manage **automotive source code**.
* Build **virtual vehicle environments** automatically as part of continuous integration and continuous delivery (CI/CD) pipelines and manage their execution for virtual testing.
* Orchestrate deployments for **SiL** tests (virtual testing) and **HiL** testing.
* Use highly scalable services to collect and analyze data produced during **validation tests** and **field usage**

## Architecture

:::image type="content" source="images/sdv-e2e-ref-architecture-high-level-overview.svg" alt-text="Diagram that shows the SDV toolchain overview." border="false" lightbox="images/sdv-e2e-ref-architecture-high-level-overview.svg":::

The architecture consists of six key building blocks:

1. The **SDV toolchain** is a plug-and-play approach that's open and configurable. It takes advantage of Microsoft developer and DevOps assets and services. It reduces reliance on in-vehicle silicon by establishing highly configurable and flexible **virtual electronic control units (vECUs)** as well as **virtual high-performance computers (vHPCs)** environments on Azure to accelerate development, testing, and validation of automotive software. The approach also ensures compatibility with edge and in-vehicle silicon to ensure bit, timing, and code parity.

1. An **automotive software stack** encompasses a diverse range of technologies and frameworks, often governed by industry standards and collaborative efforts such as the *Eclipse Foundation Software Defined Vehicle Working Group*. Eclipse projects include non-differentiating components for vehicle connectivity, messaging and communication protocols, an in-vehicle digital twin abstraction layer, advanced driver-assistance systems (ADAS), and autonomous driving solutions. Automotive software stacks provide a robust foundation for automakers and software developers. They ensure seamless integration and compatibility across the automotive ecosystem and provide a community-driven approach to technological advancements.

1. The **GitHub and Azure Marketplace** enables partners such as Tier I and automotive software tool vendors to offer solutions, such as managed automotive software stacks, vECUs, and developer tooling, and integrate them with the SDV toolchain.

1. With **HiL testing**, you can run testing and validation on target hardware. HiL testing uses the same orchestration concept as SiL testing for validation with edge and in-vehicle silicon. The specialized hardware is connected with fast network access and secure networks.

1. **[Vehicle messaging, data, and analytics](/azure/event-grid/mqtt-automotive-connectivity-and-data-solution)** provides required infrastructure for managing vehicles and devices, deploy and operate connected vehicle applications with dependencies to in-vehicle software components and provide data analytics services for engineering, operations, and mobility-based services. The **[data analytics for automotive test fleets](/azure/architecture/industries/automotive/automotive-telemetry-analytics)** provides more detail on data collection and analytics for component and system validation.

1. **[Autonomous vehicle operations](/azure/architecture/solution-ideas/articles/avops-architecture)** enables automotive OEMs to develop automated driving solutions on Azure. It describes how to manage data operations from autonomous vehicles (DataOps), automated feature extraction, labeling, model training for perception and sensor fusion (MLOps), and testing developed models in simulated environments (ValOps). It integrates with the SDV toolchain by providing trained models and executing software validation.

This guide focuses on a general *SDV toolchain* and *automotive software stack*, and provides examples of for implementations using open-source projects under the purview of the Eclipse SDV working group, such as [Eclipse uProtocol](https://github.com/eclipse-uprotocol), [Eclipse Chariott](https://github.com/eclipse-chariott), [Eclipse Ibeji](https://github.com/eclipse-ibeji), Eclipse Freya, and Eclipse Agemo.

*Microsoft is a member of the [Eclipse Software Defined Vehicle](https://www.eclipse.org/org/workinggroups/sdv-charter.php) working group, a forum for open collaboration using open source for vehicle software platforms.*

### Workflow

This section describes the components that comprise the automotive SDV toolchain. It also describes the typical workflow for a developer to define, orchestrate, and run virtual tests for automotive software.

The following three key blocks comprise the automotive SDV toolchain:

* **Development tools** includes development and collaboration services such as GitHub, Microsoft Dev Box, Visual Studio Code and Azure Container Registry. It also includes GitHub’s code scanning capabilities that use the CodeQL analysis engine to find security bugs in source code and surface alerts in pull requests, before the vulnerable code gets merged and released.

* **Development, validation, and integration** – a combination of metadata and orchestration services that allow developers to configure, build, deploy, and orchestrate on-demand virtual execution environments to streamline the development and testing process, integrating with existing toolchains and supporting multiple application formats, binaries, operating systems, and runtime environments.

* **Execution environment** – the set of Azure services that enable reliable, repeatable, and observable cloud and edge environments to build, test, and validate automotive software stacks. These services might include:

  * Azure deployment environment
  * Azure Compute Gallery
  * Azure Container Registry
  * Azure Arc
  * Azure compute like ARM64-based Azure virtual machines and high-performance computing
  * Azure networking services and connectivity services, like Azure ExpressRoute

### Deploy vECUs

:::image type="content" source="images/sdv-e2e-ref-architecture-automotive-sdv-toolchain.svg" alt-text="Diagram that shows the components and workflow of the automotive SDV toolchain." border="false" lightbox="images/sdv-e2e-ref-architecture-automotive-sdv-toolchain.svg":::

The following flow describes how an automotive software developer belonging to the fictitious company *Contoso Automotive* uses the automotive SDV toolchain to:

* Set up a development environment in minutes.
* Trigger an update change in the SiL cloud infrastructure to deploy a vECU that runs on an ARM64-based virtual machine.

*Contoso Automotive* is adding a new automotive high-performance compute (HPC) unit to an upcoming vehicle model and must onboard a new development team to develop containerized applications. The hardware for the vehicle isn't available yet, but compressed timelines mean that the software functionality must be developed and validated in parallel.

1. The automotive developer creates and connects to a **Microsoft dev box**. The dev box is preconfigured with all required development tools (such as Visual Studio Code and Android Studio) and all required extensions (such as GitHub Copilot) to work with the *Contoso Automotive* applications.

1. The automotive developer performs a check-out of the automotive **application code and metadata** that describes the upcoming vehicle configuration, the included HPCs and ECUs, and the required deployment to perform SiL validation.
1. The automotive developer uses the **metadata extensions** to make configuration adjustments, such as changing the characteristics of the HPC based on new information from the engineering team.
1. Changing the configuration triggers the **metadata processing extension** that performs metadata validation, generates all required artifacts, and configures an execution environment deployment campaign.
1. After all configuration changes are complete, the developer submits a pull request that triggers a **GitHub action** for deployment.
1. The deployment GitHub action triggers the **metadata and orchestration services**, which runs the deployment campaign.
1. The **metadata and orchestration service** uses the **Azure development environment** to deploy the required compute to simulate the new version of the automotive electric or electronic architecture.
1. The **metadata and orchestration service** sets the desired state of the compute based on the campaign. It uses the artifacts store to mount and configure the required ***Virtual HPC and ECU images***.

#### Software over the air (SOTA) updates for automotive applications

*Contoso Automotive* is ready to deploy containerized automotive applications to their engineering test fleet to perform integration testing. The *automotive developer* builds, tests, and validates the new version of their application and deploys it to the vehicle.

:::image type="content" source="images/sdv-e2e-ref-architecture-software-update.svg" alt-text="Diagram that shows a software update." border="false" lightbox="images/sdv-e2e-ref-architecture-software-update.svg":::

1. The *automotive developer* creates a release. The release contains a definition of the *software stack container* desired state and definition of the build.

1. The **toolchain and orchestration** services trigger the release process. The services deploy the required infrastructure to build, validate, and release software containers.
1. During execution, the applications are built, validated, and released with container-based tooling. Depending on the requirements of the tools, they can be deployed on Azure Kubernetes Service (AKS) (for containerized applications) or dedicated virtual machines. After the build is complete, the results are pushed to the **Azure Container Registry** for released containers and the changes are registered in the **OTA server**.
1. The **OTA client** has a dedicated **OTA agent** for container-based applications. The *desired state seeking agent* connects to the **toolchain and orchestration services* to retrieve the desired state definition.
1. The **container orchestration** engine downloads and activates the desired containers from the **Azure Container Registry**

### Automotive software stack workflow

This scenario presents a generic automotive software stack synchronizing its state with the Azure Cloud.

The represented stack has the following components:

* A **Service Registry** provides facilities to register and discover services within the vehicle.

* The **Dynamic Topic Management** enables services to subscribe and publish messages to named topics, abstracting the communication protocol.
* The **in-vehicle digital twin** service maintains the state of the vehicle, including signals from ECUs and compute units such as AD/ADAS and infotainment.
* The **digital twin cloud synchronization** synchronizes the local state of the vehicle with the state in the cloud to enable digital products and services that don't require a direct connection to the car.

:::image type="content" source="images/sdv-e2e-ref-architecture-automotive-software-stack.svg" alt-text="Diagram that shows the software stack." border="false" lightbox="images/sdv-e2e-ref-architecture-automotive-software-stack.svg":::

1. All components register their capabilities using the **Service Registry**.

1. **Vehicle compute** registers the state descriptions to the *digital twin provider* of the *in-vehicle digital twin* service. After registration, the compute units can publish updates on their state.
    1. Vehicle compute can register more complex state objects and interactions.
    1. Vehicle ECUs register which signals are available to automotive applications and which commands can be accepted.
1. The **in-vehicle digital twin** publishes state changes and updates to the **dynamic topic management**. These updates are organized in topics.
1. **Automotive applications** can subscribe to messages from any source managed by the dynamic topic management. These applications are subscribed to relevant topics and react on state changes. They can also publish their own messages.
1. The **in-vehicle digital twin service** also publishes selected topics to the **digital twin cloud synchronization** service.
1. The **digital twin cloud synchronization** can use a *cartographer* to map the topic names (using a *digital twin mapping service*) to the equivalent names on the cloud. This harmonization reduces the dependency between vehicle and cloud software and among vehicle models.
1. The **cloud connector** publishes updates to the cloud and subscribes to receive state changes published by other services and applications
1. **Azure Event Grid** routes the messages to the relevant services and applications. The state of the vehicle is stored using services such as **Azure Cache for Redis** to store the last known value for fast access and retrieval and **Azure Data Explorer** to provide short term vehicle state history and analytics.

## Components

This guide references the following GitHub and Azure components:

### Development tools

* [GitHub](https://github.com) is a development platform that you can use to host and review code, manage projects, collaborate, and build software alongside developers inside your organization and outside.

* [Microsoft Dev Box](/azure/dev-box/overview-what-is-microsoft-dev-box) provides developers with self-service access to ready-to-code, cloud-based workstations known as dev boxes that can be customized with project-specific tools, source code, and prebuilt binaries for immediate workflow integration.
* [Azure Container Registry](/azure/container-registry) is a service that you can use to build, store, and manage container images and artifacts in a private registry for all types of container deployments. Automotive software has adopted container based automotive applications and workloads. The SDV toolchain uses Azure container registries as part of container development, deployment processes, and pipelines.
* [Visual Studio Code](https://code.visualstudio.com) is a lightweight source code editor that's available for Windows, macOS, and Linux. It has a rich ecosystem of extensions for several languages and runtimes.

### Execution environment

* [Azure deployment environments](/azure/deployment-environments) provide a preconfigured collection of Azure resources. It empowers development teams to quickly and easily spin up infrastructure with project-based templates that establish consistency and best practices while maximizing security.

* [Azure compute](https://azure.microsoft.com/products/category/compute) is a comprehensive suite of cloud services that empowers developers to run their automotive software stacks, applications, and workloads on virtual machines (VMs) and containers. It offers a wide array of compute varieties, including memory-optimized, CPU-optimized, high-performance, and general purpose compute.
* [Azure Compute Gallery](/azure/virtual-machines/azure-compute-gallery) is a service that supports versioning and grouping of resources for easier management. You can share images with the community, across subscriptions, and between Microsoft Entra ID tenants. You can also scale deployments with resource replicas in each Azure region. Azure Compute Gallery provides structure and organization for automotive software stack artifacts.
* [Azure Arc](/azure/azure-arc) simplifies governance and management and delivers a consistent Cloud to Hardware in the Loop management platform. Automotive OEM can use Azure Arc to control and govern increasingly complex HiL environments across on-premises and cloud-based data centers.
* [Azure Blob Storage](/azure/storage/blobs) is a service that provides massively scalable object storage for any type of unstructured data, like images, videos, audio, and documents that automotive software stacks produce and consume.
* [Azure networking services](/azure/networking/fundamentals/networking-overview) are global, secure, and reliable. Automotive software stacks and development tools require data-processing pipelines to access HiL farms for developing and testing autonomous and assisted driving solutions. The networking services in Azure provide various networking capabilities like connectivity services, application protection services, application delivery services, and networking monitoring.

## Alternatives

The Azure services that you choose for your implementation of the architecture depends on many factors.

The [example scenario](#deploy-this-scenario) of the architecture uses AKS. Serverless Kubernetes is used to run microservices, provide enterprise-grade security and governance, and provide an integrated CI/CD experience. As an alternative, you can run microservices in Azure Container Instances, which provides a fast simple way to run containers in Azure without adopting a higher-level service, like AKS.

The [example scenario](#deploy-this-scenario) suggests the use of Azure Event Hubs or Azure Service Bus to implement Ubus service. For more information, see [Choose between Azure messaging services](/azure/service-bus-messaging/compare-messaging-services). Messaging services are often complementary, and you can use more than one.

The applications and services in this guide are deployed by using Azure Resource Manager templates or Bicep. As an alternative, you can use Terraform scripts to provision and manage cloud infrastructure.

For alternatives to the vehicle messaging, data, and analytics layer of the architecture, see [Alternatives](/azure/event-grid/mqtt-automotive-connectivity-and-data-solution#alternatives).

## Scenario details

Autonomous and connected SDVs open a whole new world of functionality, serviceability, and reliability. When hardware and software are decoupled, OEMs can develop independent applications to address specific functions and services. This method makes it easy to update and add software to the overall vehicle platform. Automobile makers and their suppliers are encouraged to adjust their automotive operations to enable agile software development cycles, which are flexible and adaptable for short development cycles and frequent releases. They help ensure collaboration and continuous improvement.

Without a standardized, open, and configurable toolchain strategy, OEMs might have a landscape of scattered tools. For a truly agile software development strategy, companies need to have a unified toolchain that's based on a modern cloud-based platform that's native to Azure. The platform needs to enable developers to collaborate and reuse software and provide third parties the opportunity to develop applications. The platform is especially helpful for developers that have strong software expertise but no previous automotive hardware experience.

This automotive example architecture meets the demands of the rapidly evolving automotive industry. It applies the *shift left* principle, which emphasizes early integration of software and hardware components. It enables continuous testing and validation starting from the early stages of development. Virtualization plays a pivotal role, allowing the creation of virtual prototypes and test environments that accelerate innovation and reduce physical prototype requirements. The heart of this architecture is its robust CI/CD pipeline automation, which ensures seamless integration, testing, and deployment of software updates throughout the vehicle's lifecycle. This agility enables fast software updates, which addresses security vulnerabilities, enhances performance, and delivers new features promptly. It provides consumers with a safe, feature-rich driving experience.

:::image type="content" source="images/sdv-e2e-ref-architecture-scenario.svg" alt-text="Diagram that shows software-defined vehicle scenarios." border="false" lightbox="images/sdv-e2e-ref-architecture-scenario.svg":::

## Potential use cases

* **Developer onboarding**: Implement a fully configured automotive development environment to accelerate the onboarding of automotive software developers.

* **Efficient development**: Simulate the behaviors of various hardware and software combinations. Reduce the dependency to edge or in-vehicle silicon early in the development process.
* **SiL validation**: Run automated build, test, and validation pipelines to validate the behavior of your software application. Use compute resources on the cloud for a faster development cycle.
* **HiL validation**: Simplify deployment and monitoring of the HiL farms.
* **Validate with a test fleet**: Collect software metrics, logs, and traces of the software applications as well as vehicle telemetry and signal data. Use that data to create a comprehensive view of the vehicle behavior for validation, root cause analysis, and homologation.
* **Deploy and manage**: Create traceable software releases that can be updated and managed for the vehicle fleet using DevOps practices.
* **Understand and improve**: use information collected from the field to drive improvements in your software applications.

## Recommendations

The following recommendations help to ensure that you effectively manage your Azure environment. Follow these recommendations unless you have a requirement that overrides them.

* When you deploy and configure Azure services, follow best practices to help ensure a secure, efficient, and cost-effective environment.

* According to your implementation requirements, define your Azure resources, such as virtual machines, Kubernetes clusters, messaging services, and data and analytics services.
* To automate your deployment and maintain consistency, implement Azure Resource Manager templates for infrastructure as code (IaC).
* Implement role-based access control (RBAC) to grant permissions to users and services on a least-privilege basis.
* Utilize Azure Security Center to proactively monitor and mitigate security threats.
* For scalability and redundancy, consider using Azure load balancers and availability sets or availability zones.
* Regularly monitor the performance and usage of your Azure resources so you can optimize costs and enhance performance. Use tools like Azure Monitor and Microsoft Cost Management.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

* Running an end-to-end service-oriented application infrastructure to support the implementation of a distributed communication protocol platform on Azure with modern CI/CD requires a reliable and highly available architecture. For architectural guidance and best practices for managing and running services on AKS, see [AKS overview](/azure/well-architected/services/compute/azure-kubernetes-service/azure-kubernetes-service).

* HiL testing is an indispensable and critical part of the automotive software development process and test strategy. When you design and implement the network architecture to the HiL farms, consider [designing for high availability with ExpressRoute](/azure/expressroute/designing-for-high-availability-with-expressroute) to reduce single points of failure and maximize the availability of remote environments to your development and test teams.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

* Security is one of the most important aspects of an architecture. To ensure the security of complex systems, you need to understand the business, social, and technical conditions. Consider implementing GitHub’s code-scanning capabilities so you can find and fix security issues and critical defects early in the development process. [GitHub supports the coding standards AUTOSAR C++ and CERT C++, which enables the development of functional safety applications](https://github.blog/2022-06-20-adding-support-for-coding-standards-autosar-c-and-cert-c).
* Consider adopting the following best practices to [Secure your end-to-end supply chain on GitHub](https://docs.github.com/en/code-security/supply-chain-security/end-to-end-supply-chain/end-to-end-supply-chain-overview).

* Consider adopting Azure Key Vault to maintain end-to-end security when you handle sensitive and business-critical elements, such as encryption keys, certificates, connection strings, and passwords. Key Vault-managed hardware security modules (HSMs) offer a robust solution that fortifies the entire software development and supply chain process. With Key Vault-managed HSMs, automotive applications can securely store and manage sensitive assets to ensure that they remain protected from potential cyber security threats. Key Vault further enhances security by regulating access and permissions to critical resources with RBAC.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

* When you create vECUs, ensure that the [virtual machine size](/azure/virtual-machines/sizes) matches the requirements. If you modify the configuration to use larger sizes than necessary, cost can drastically increase, especially if multiple machines operate in parallel to perform long-running tasks.

* For build, validation, and testing tasks that aren't time-critical, consider using [Azure Spot Virtual Machines](/azure/virtual-machines/spot-vms). You can take advantage of unused capacity and incur significant cost savings.
* If you have a [Microsoft Azure Consumption Commitment](/azure/cost-management-billing/manage/track-consumption-commitment), consider using [eligible partner offerings](/marketplace/azure-consumption-commitment-benefit#determine-which-offers-are-eligible-for-azure-consumption-commitments-maccctc) from the Azure Marketplace when you deploy development tools and vECUs in the execution environment.
* Refer to the [autonomous vehicle operations](/azure/architecture/solution-ideas/articles/avops-architecture#cost-optimization) cost optimization section for more tips about running autonomous vehicle development workloads.
* GitHub Copilot can significantly speed up the software development process by providing real-time code suggestions and autocompletions. Automotive software engineers can write code faster and more efficiently, which reduces the time to market for new vehicle features and updates.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

* The automotive SDV toolchain embraces key software engineering disciplines, like IaC environment provisioning, CI/CD pipelines for automotive software stacks build and release, automated testing to transition to a shift left approach, and configuration as code to avoid configuration drift between environments. Consider adopting the previous key principles across all your workloads for consistency, repetition, and early detection of issues.

* Consider an Azure Arc-enabled infrastructure to simplify governance and management across Azure cloud and on-premises environments and HiL testing and validation farms.
* GitHub Copilot's AI-powered assistance can enhance the overall code quality by reducing the likelihood of human errors and standardizing coding practices. This is crucial in the automotive industry where software safety and reliability are paramount.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

* Consider which tasks you can parallelize as part of your build and test pipelines.

* Consider implementing [performance efficiency patterns](/azure/well-architected/scalability/performance-efficiency-patterns) for performant applications and workloads based on the following distributed communication protocol example.

## Deploy this scenario

The Eclipse SDV has a code-source first approach as their main tenant, which provides a large amount of flexibility for implementation. The following examples use existing Eclipse projects and describe their interaction with Azure services.

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

#### Provision devices

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
* [Daniel Lueddecke](https://www.linkedin.com/in/daniellueddecke) | Cloud Solution Architect, Automotive
* [Filipe Prezado](https://www.linkedin.com/in/filipe-prezado-9606bb14) | Principal Program Manager, MCI SDV & Mobility
* [Sandeep Pujar](https://www.linkedin.com/in/spujar) | Principal PM Manager, Azure Messaging
* [Ashita Rastogi](https://www.linkedin.com/in/ashitarastogi) | Principal Program Manager, Azure Messaging
* [Boris Scholl](https://www.linkedin.com/in/bscholl) | General Manager, Partner Architect-Azure Cloud & AI

Other contributors:

* [Frank Kaleck](https://www.linkedin.com/in/frank-kaleck) | Industry Advisor - Manufacturing, Mobility & Automotive
* [Frederick Chong](https://www.linkedin.com/in/frederick-chong-5a00224) | Principal PM Manager, MCIGET SDV & Mobility
* [Mehmet Kucukgoz](https://www.linkedin.com/in/mehmetkucukgoz) | Principal PM Manager, Azure IoT Hub

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

* [GitHub enables the development of functional safety applications by adding support for coding standards AUTOSAR C++ and CERT C++](https://github.blog/2022-06-20-adding-support-for-coding-standards-autosar-c-and-cert-c)
* [Get started with GitHub Copilot](https://docs.github.com/copilot/getting-started-with-github-copilot)
* [Create and connect to a dev box by using the Microsoft Dev Box developer portal](/azure/dev-box/quickstart-create-dev-box)

## Related resources

The following articles describe related architectures:

* [Automotive messaging, data, and analytics reference architecture](/azure/event-grid/mqtt-automotive-connectivity-and-data-solution) describes how to connect vehicles to the cloud and process messages for applications and analytics.
* [Create an autonomous vehicle operations (AVOps) solution](/azure/architecture/solution-ideas/articles/avops-architecture) for a broader look into automotive digital engineering for autonomous and assisted driving.

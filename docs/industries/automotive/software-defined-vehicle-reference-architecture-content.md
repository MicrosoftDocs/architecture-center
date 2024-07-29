Across the entire automotive industry, the transition to *software-defined vehicles (SDVs)* requires a unique approach for developing, deploying, monitoring, and managing automotive software stacks. Automotive original equipment manufacturers (OEMs) embrace a *shift-left strategy*, which involves conducting testing early in the product development cycle.

In the approach in this article, the in-vehicle software stack undergoes comprehensive simulation and testing in a cloud-based environment. The following example architecture outlines how to take advantage of the software stacks and distributions that the [Eclipse SDV working group](https://sdv.eclipse.org) offers. You can use these components with GitHub and Azure services to develop an end-to-end automotive software stack, implement *software in the loop (SIL) testing*, orchestrate *hardware in the loop (HIL) testing*, and engineer vehicle fleet validation.

This article describes how to:

* Integrate state-of-the-art developer tools into the development process.
* Work with and manage automotive source code.
* Build virtual vehicle environments automatically as part of continuous integration and continuous delivery (CI/CD) pipelines and manage their execution for virtual testing.
* Orchestrate deployments for SIL testing (virtual testing) and HIL testing.
* Use highly scalable services to collect and analyze data that's produced during validation tests and field usage.

## Architecture

This diagram shows the automotive SDV toolchain architecture.

:::image type="content" source="images/software-defined-vehicle-ref-architecture-overview.svg" alt-text="Diagram that shows the automotive SDV toolchain overview." border="false" lightbox="images/software-defined-vehicle-ref-architecture-overview.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/software-defined-vehicle.pptx) of this architecture.*

### Workflow

The architecture consists of six key building blocks:

1. The **SDV toolchain** is a plug-and-play approach that's open and configurable. This approach takes advantage of Microsoft developer and DevOps assets and services. It reduces the reliance on in-vehicle silicon by establishing configurable and flexible *virtual electronic control unit (vECU)* and *virtual high-performance computer (vHPC)* environments on Azure. These environments help to accelerate development, testing, and validation of automotive software. This approach ensures compatibility with edge and in-vehicle silicon to ensure bit, timing, and code parity.

1. An **automotive software stack** encompasses a diverse range of technologies and frameworks. Industry standards and collaborative efforts, such as the *Eclipse Foundation software-defined vehicle working group*, often govern these technologies and frameworks. Eclipse projects include non-differentiating components for vehicle connectivity, messaging, and communication protocols, such as an in-vehicle digital twin abstraction layer, advanced driver-assistance systems (ADAS), and autonomous driving solutions.

   Automotive software stacks provide a robust foundation for automakers and software developers. They ensure seamless integration and compatibility across the automotive ecosystem and provide a community-driven approach to technological advancements.

1. **GitHub Marketplace** and **Azure Marketplace** enable partners such as tier 1 vendors and automotive software tool vendors to offer solutions, like managed automotive software stacks, vECUs, and developer tooling. You can integrate these solutions with the SDV toolchain.

1. With **HIL testing**, you can run testing and validation on target hardware. For validation with edge and in-vehicle silicon, HIL testing uses the same orchestration concept as SIL testing. The specialized hardware is connected with fast network access and secure networks.

1. [Vehicle messaging, data, and analytics](/azure/event-grid/mqtt-automotive-connectivity-and-data-solution) provide the required infrastructure for:
   * Managing vehicles and devices.
   * Deploying and operating connected vehicle applications with dependencies to in-vehicle software components.
   * Providing data analytics for engineering, operations, and mobility-based services.

   For information about data collection and analytics for component and system validation, see [Data analytics for automotive test fleets](/azure/architecture/industries/automotive/automotive-telemetry-analytics).

1. [Autonomous vehicle operations (AVOps)](/azure/architecture/solution-ideas/articles/avops-architecture) enable automotive OEMs to develop automated driving solutions on Azure. The AVOps solution describes:
   * How to manage data operations (DataOps) for autonomous vehicles.
   * Automated feature extraction, labeling, and model training for perception and sensor fusion (MLOps).
   * Testing developed models in simulated environments (ValOps).

   This solution integrates with the SDV toolchain by providing trained models and executing software validation.

This architecture focuses on a general SDV toolchain and automotive software stack. It provides examples of implementations that use open-source projects under the purview of the Eclipse SDV working group, such as [Eclipse uProtocol](https://github.com/eclipse-uprotocol), [Eclipse Chariott](https://github.com/eclipse-chariott), [Eclipse Ibeji](https://github.com/eclipse-ibeji), [Eclipse Freyja](https://github.com/eclipse-ibeji/freyja), and [Eclipse Agemo](https://github.com/eclipse-chariott/Agemo).

Microsoft is a member of the [Eclipse software-defined vehicle working group](https://www.eclipse.org/org/workinggroups/sdv-charter.php), a forum for open-source collaboration for vehicle software platforms.

The automotive SDV toolchain consists of the following components.

* **Development tools** include development and collaboration services, such as GitHub, Microsoft Dev Box, Visual Studio Code, and Azure Container Registry. This architecture also uses GitHub’s code-scanning capabilities. The CodeQL analysis engine finds security bugs in source code and surface alerts in pull requests before the vulnerable code gets merged and released.

* **Development, validation, and integration** is a method that combines metadata and orchestration services. It enables developers to configure, build, deploy, and orchestrate on-demand virtual execution environments. Developers can streamline the development and testing process, integrate with existing toolchains, and support multiple application formats, binaries, operating systems, and runtime environments.

* The **execution environment** consists of Azure services and components that enable reliable, repeatable, and observable cloud and edge environments to build, test, and validate automotive software stacks. These components might include:

  * Azure Deployment Environments.
  * Azure Compute Gallery.
  * Container Registry.
  * Azure Arc.
  * Azure compute, like ARM64-based Azure virtual machines (VMs) and high-performance computing.
  * Azure networking services and connectivity services, like Azure ExpressRoute.

The following workflows show how a developer defines, orchestrates, and runs virtual tests for automotive software.

#### Workflow: Deploy vECUs

This solution describes how an automotive software developer for the fictitious company *Contoso Automotive* uses the automotive SDV toolchain to:

* Set up a development environment in minutes.
* Trigger an update change in the SIL cloud infrastructure to deploy a vECU that runs on an ARM64-based VM.

*Contoso Automotive* is adding a new automotive high-performance compute (HPC) unit to an upcoming vehicle model and must onboard a new development team to develop containerized applications. The hardware for the vehicle isn't available yet, but compressed timelines mean that the software functionality must be developed and validated in parallel.

:::image type="content" source="images/automotive-software-defined-vehicle-toolchain.svg" alt-text="Diagram that shows the components and workflow of the automotive SDV toolchain." border="false" lightbox="images/automotive-software-defined-vehicle-toolchain.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/software-defined-vehicle.pptx) of this architecture.*

1. The **automotive developer** creates and connects to a **Microsoft dev box**. The dev box is preconfigured with all required development tools (such as Visual Studio Code and Android Studio) and all required extensions (such as GitHub Copilot) to be compatible with the Contoso Automotive applications.

1. The automotive developer performs a check-out of the automotive **application code and metadata** that describes the upcoming vehicle configuration, the included HPCs and ECUs, and the required deployment to perform SIL validation.
1. The automotive developer uses **metadata extensions** to adjust configurations, such as changing the characteristics of the HPC based on new information from the engineering team.
1. Changing the configuration triggers the **metadata processing extension**. It performs metadata validation, generates all required artifacts, and configures an execution environment deployment campaign.
1. After all configuration changes are complete, the developer submits a pull request that triggers a **GitHub action** for deployment.
1. The deployment GitHub action triggers the **metadata and orchestration services**, which run the deployment campaign.
1. The **metadata and orchestration services** use the **Azure development environment** to deploy the required compute to simulate the new version of the automotive electronic architecture.
1. The **metadata and orchestration services** set the desired state of the compute based on the campaign. The services use the artifacts store to mount and configure the required **vHPC and ECU images**.

#### Workflow: Software over the air (SOTA) updates for automotive applications

Contoso Automotive wants to deploy containerized automotive applications to its engineering test fleet to perform integration testing. The automotive developer builds, tests, and validates the new version of the application and deploys it to the vehicle.

:::image type="content" source="images/software-defined-vehicle-software-update.svg" alt-text="Diagram that shows a software update architecture." border="false" lightbox="images/software-defined-vehicle-software-update.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/software-defined-vehicle.pptx) of this architecture.*

1. The **automotive developer** creates a release. The release contains a definition of the desired state for the **software stack container** and a definition of the build.

1. The **toolchain and orchestration services** trigger the release process. The services deploy the required infrastructure to build, validate, and release software containers.
1. During execution, the applications are built, validated, and released with container-based tooling. Depending on the requirements of the tools, they can be deployed on Azure Kubernetes Service (AKS) for containerized applications, or they can be deployed on dedicated VMs.

   After the build is complete, the results are pushed to **Container Registry** for released containers and the changes are registered in the **OTA server**.
1. The **OTA client** has a dedicated **OTA agent** for container-based applications. The **desired state-seeking agent** connects to the **toolchain and orchestration services** to retrieve the desired state definition.
1. The **container orchestration** engine downloads and activates the desired containers from **Container Registry**.

#### Workflow: Automotive software stack

In this solution, a generic automotive software stack synchronizes its state with the Azure cloud.

The stack has the following components:

* A *service registry* enables services within the vehicle to be registered and discovered.

* The *dynamic topic management* enables services to subscribe and publish messages to named topics, abstracting the communication protocol.
* The *in-vehicle digital twin service* maintains the state of the vehicle, including signals from ECUs and compute units, such as AD/ADAS and infotainment.
* The *digital twin cloud synchronization* synchronizes the local state of the vehicle with the state in the cloud to provide digital products and services that don't require a direct connection to the car.

:::image type="content" source="images/software-defined-vehicle-automotive-software-stack.svg" alt-text="Diagram that shows the software stack architecture." border="false" lightbox="images/software-defined-vehicle-automotive-software-stack.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/software-defined-vehicle.pptx) of this architecture.*

1. All components register their capabilities via the **service registry**.

1. **Vehicle compute** registers the state descriptions to the **digital twin provider** of the **in-vehicle digital twin service**. After registration, the compute units can publish updates on their state.
    1. **Vehicle compute** registers complex state objects and interactions.
    1. **Vehicle ECUs** register which signals are available to automotive applications and which commands can be accepted.
1. The **in-vehicle digital twin** publishes state changes and updates to the **dynamic topic management**. These updates are organized in topics.
1. **Automotive applications** can subscribe to messages from any source that's managed by the dynamic topic management. These applications are subscribed to relevant topics and react to state changes. They can also publish their own messages.
1. The **in-vehicle digital twin service** also publishes selected topics to the **digital twin cloud synchronization** service.
1. The **digital twin cloud synchronization** can use a **cartographer** to map the topic names (via a **digital twin mapping service**) to the equivalent names on the cloud. This harmonization reduces the dependency between vehicle and cloud software and among vehicle models.
1. The **cloud connector** publishes updates to the cloud and subscribes to receive state changes that are published by other services and applications.
1. **Azure Event Grid** routes the messages to the relevant services and applications. The state of the vehicle is stored via services. For example, **Azure Cache for Redis** might store the last-known value for fast access and retrieval, and **Azure Data Explorer** might provide short-term vehicle state history and analytics.

### Components

The following GitHub and Azure components are used in this architecture.

#### Development tools

* [Container Registry](https://azure.microsoft.com/products/container-registry) is a service that you can use to build, store, and manage container images and artifacts in a private registry for all types of container deployments. Automotive software has adopted container-based automotive applications and workloads. The SDV toolchain uses Azure container registries for container development, deployment processes, and pipelines.

* [Dev Box](https://azure.microsoft.com/products/dev-box) provides developers with self-service access to ready-to-code, cloud-based workstations known as dev boxes that can be customized with project-specific tools, source code, and prebuilt binaries for immediate workflow integration.
* [GitHub](https://github.com) is a development platform that you can use to host and review code, manage projects, collaborate, and build software alongside developers that are inside or outside your organization.
* [Visual Studio Code](https://code.visualstudio.com) is a lightweight source-code editor that's available for Windows, macOS, and Linux. It has a rich ecosystem of extensions for several languages and runtimes.

#### Execution environment

* [Azure Deployment Environments](https://azure.microsoft.com/products/deployment-environments) provides a preconfigured collection of Azure resources. It empowers development teams to quickly and easily create infrastructure by using project-based templates. Templates establish consistency and best practices while maximizing security.

* [Azure compute](https://azure.microsoft.com/products/category/compute) is a comprehensive suite of cloud services that empower developers to run their automotive software stacks, applications, and workloads on VMs and containers. There are many compute varieties, including memory-optimized, CPU-optimized, high-performance, and general-purpose compute.
* [Compute Gallery](/azure/virtual-machines/azure-compute-gallery) is a service that supports versioning and grouping resources for easy management. You can share images with the community, across subscriptions, and between Microsoft Entra ID tenants. You can also scale deployments with resource replicas in each Azure region. Compute Gallery provides structure and organization for automotive software stack artifacts.
* [Azure Arc](/azure/azure-arc) simplifies governance and management and delivers a consistent cloud to HIL management platform. Automotive OEMs can use Azure Arc to control and govern increasingly complex HIL environments across on-premises and cloud-based datacenters.
* [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs) is a service that provides massively scalable object storage for any type of unstructured data, like images, videos, audio, and documents, that automotive software stacks produce and consume.
* [Azure networking services](https://azure.microsoft.com/solutions/networking) are global, secure, and reliable services. Automotive software stacks and development tools require data-processing pipelines so they can access HIL farms to develop and test autonomous and assisted-driving solutions. The networking services in Azure provide various networking capabilities, like connectivity services, application protection services, application delivery services, and network monitoring.

### Alternatives

The Azure services that you choose for your implementation of the architecture depend on many factors.

The example in the [Deploy this scenario section](#deploy-this-scenario) uses AKS. Serverless Kubernetes is used to run microservices, provide enterprise-grade security and governance, and provide an integrated CI/CD experience. As an alternate fast and simple method, you can run microservices in Azure Container Instances. In this alternative, you don't have to adopt a higher-level service, like AKS.

The example in the [Deploy this scenario section](#deploy-this-scenario) suggests the use of Azure Event Hubs or Azure Service Bus to implement a uBus service. For more information, see [Choose between Azure messaging services](/azure/service-bus-messaging/compare-messaging-services). Messaging services are often complementary, and you can use more than one.

The applications and services in this architecture are deployed via Azure Resource Manager templates or Bicep. As an alternative, you can use Terraform scripts to provision and manage cloud infrastructure.

For alternatives to the vehicle messaging, data, and analytics layer of the architecture, see [Alternatives](/azure/event-grid/mqtt-automotive-connectivity-and-data-solution#alternatives).

## Scenario details

Autonomous and connected SDVs open a whole new world of functionality, serviceability, and reliability. When hardware and software are decoupled, OEMs can develop independent applications to address specific functions and services. This method makes it easy to update and add software to the overall vehicle platform.

Automobile makers and their suppliers are encouraged to adjust their automotive operations to enable agile software development cycles, which are flexible and adaptable for short development cycles and frequent releases. These cycles help ensure collaboration and continuous improvement.

Without a standardized, open, and configurable toolchain strategy, OEMs might have a landscape of scattered tools. For a truly agile software development strategy, companies need to have a unified toolchain that's based on a modern cloud-based platform that's native to Azure. The platform needs to enable developers to collaborate and reuse software. It must provide third-party developers with the opportunity to create applications. The platform is especially helpful for developers that have strong software expertise but no previous automotive hardware experience.

This automotive example architecture meets the demands of the rapidly evolving automotive industry. It applies the shift-left principle, which emphasizes early integration of software and hardware components. It enables continuous testing and validation starting from the early stages of development. Virtualization plays a pivotal role, allowing the creation of virtual prototypes and test environments to accelerate innovation and reduce physical prototype requirements.

The heart of this architecture is its robust CI/CD pipeline automation, which ensures seamless integration, testing, and deployment of software updates throughout the vehicle's lifecycle. This agility enables fast software updates, which promptly address security vulnerabilities, enhance performance, and deliver new features. It helps provide consumers with a safe, feature-rich driving experience.

The following diagram shows a general overview of the automotive SDV toolchain architecture.

:::image type="content" source="images/software-defined-vehicle-scenario.svg" alt-text="Diagram that shows SDV scenarios." border="false" lightbox="images/software-defined-vehicle-scenario.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/software-defined-vehicle.pptx) of this architecture.*

### Potential use cases

* **Developer onboarding**: Implement a fully configured automotive development environment to accelerate the onboarding of automotive software developers.

* **Efficient development**: Simulate the behavior of various hardware and software combinations. Reduce the dependency to edge or in-vehicle silicon early in the development process.
* **SIL validation**: Run automated build, test, and validation pipelines to validate the behavior of your software application. Use compute resources on the cloud for a faster development cycle.
* **HIL validation**: Simplify deployment and monitoring of HIL farms.
* **Test fleet validation**: Collect software metrics, logs, and traces of the software applications as well as vehicle telemetry and signal data. Use that data to create a comprehensive view of the vehicle behavior for validation, root cause analysis, and approval.
* **Software releases**: Create traceable software releases that can be updated and managed for the vehicle fleet via DevOps practices.
* **Continuous improvement**: Use information collected from the field to drive improvements in your software applications.

## Recommendations

The following recommendations help ensure that you effectively manage your Azure environment. Follow these recommendations unless you have a requirement that overrides them.

* Follow best practices when you deploy and configure Azure services to help ensure a secure, efficient, and cost-effective environment.

* Define your Azure resources according to your implementation requirements. These resources can include VMs, Kubernetes clusters, messaging services, and data and analytics services.
* Implement Resource Manager templates for infrastructure as code (IaC) so you can automate your deployment and maintain consistency.
* Implement role-based access control (RBAC) to grant permissions to users and services on a least-privilege basis.
* Use Azure Security Center to proactively monitor and mitigate security threats.
* Consider using Azure load balancers and availability sets or availability zones to improve scalability and redundancy.
* Regularly monitor the performance and usage of your Azure resources so you can optimize costs and enhance performance. Use tools like Azure Monitor and Microsoft Cost Management.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/reSILiency/overview).

You can run an end-to-end application infrastructure that's service-oriented and supports the implementation of a distributed communication protocol platform on Azure with modern CI/CD. If you use this solution, you need a reliable and highly available architecture. For architectural guidance and best practices for managing and running services on AKS, see [AKS overview](/azure/well-architected/services/compute/azure-kubernetes-service/azure-kubernetes-service).

HIL testing is an indispensable and critical part of the automotive software development process and test strategy. When you design and implement the network architecture for HIL farms, consider [designing for high availability with ExpressRoute](/azure/expressroute/designing-for-high-availability-with-expressroute). Use this strategy to reduce single points of failure and maximize the availability of remote environments for your development and test teams.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Security is one of the most important aspects of an architecture. To ensure the security of complex systems, you need to understand the business, social, and technical conditions. Consider implementing GitHub’s code-scanning capabilities, so you can find and fix security issues and critical defects early in the development process. GitHub supports the coding standards [AUTOSAR C++ and CERT C++](https://github.blog/2022-06-20-adding-support-for-coding-standards-autosar-c-and-cert-c), which enables the development of functional safety applications.

Consider [securing your end-to-end supply chain on GitHub](https://docs.github.com/en/code-security/supply-chain-security/end-to-end-supply-chain/end-to-end-supply-chain-overview).

Consider adopting Azure Key Vault to maintain end-to-end security when you handle sensitive and business-critical elements, such as encryption keys, certificates, connection strings, and passwords. Key Vault-managed hardware security modules (HSMs) offer a robust solution that fortifies the entire software development and supply chain process. With Key Vault-managed HSMs, you can use automotive applications to help securely store and manage sensitive assets and ensure that they remain protected from potential cyber security threats. You can further enhance security by regulating access and permissions to critical resources with RBAC.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

* When you create vECUs, ensure that the [VM size](/azure/virtual-machines/sizes) matches the requirements. If you modify the configuration to use a larger size than necessary, it increases cost, especially if multiple machines operate in parallel to perform long-running tasks.

* For build, validation, and testing tasks that aren't time-critical, consider using [Azure Spot Virtual Machines](/azure/virtual-machines/spot-vms). You can take advantage of unused capacity and incur significant cost savings.
* If you have an [Azure Consumption Commitment](/azure/cost-management-billing/manage/track-consumption-commitment), consider using [eligible partner offerings](/marketplace/azure-consumption-commitment-benefit#determine-which-offers-are-eligible-for-azure-consumption-commitments-maccctc) from Azure Marketplace when you deploy development tools and vECUs in the run environment.
* For tips about running autonomous vehicle development workloads, see [Create an AVOps solution](/azure/architecture/solution-ideas/articles/avops-architecture#cost-optimization).
* Copilot provides real-time code suggestions and autocompletions, which accelerates the software-development process. Automotive software engineers can use Copilot to quickly and efficiently write code, which reduces the time to market for new vehicle features and updates.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

The automotive SDV toolchain embraces key software engineering strategies, such as:

* IaC environment provisioning.
* CI/CD pipelines for building and releasing automotive software stacks.
* Automated testing to transition to a shift-left approach.
* Configuration as code to avoid configuration drift among environments.

Consider adopting these key strategies across all workloads for consistency, repetition, and early detection of issues.

Consider an infrastructure that's enabled by Azure Arc to simplify governance and management across Azure cloud and on-premises environments, HIL testing, and validation farms.

Copilot's AI-powered assistance can enhance overall code quality by reducing the likelihood of human errors and standardizing coding practices. High-quality code is crucial in the automotive industry where software safety and reliability are paramount.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Overview of the performance efficiency pillar](/azure/architecture/framework/scalability/overview).

Determine tasks in your build and test pipelines that you might parallelize to improve performance efficiency.

Consider implementing [performance efficiency patterns](/azure/well-architected/scalability/performance-efficiency-patterns) for performant applications and workloads that are based on the distributed communication protocol example in the next section.

## Deploy this scenario

The main tenant for the Eclipse SDV is a code-source first approach, which provides flexibility for implementation. The following examples use existing Eclipse projects and describe their integration with Azure services.

### Example: Distributed communication protocol on Azure

[Eclipse uProtocol](https://github.com/eclipse-uprotocol) is one of many  distributed communication protocols that are used in automotive industries. It's a transport-agnostic, layered communication protocol that builds on top of existing automotive and internet standards. It provides a ubiquitous language for discovery, subscription, and messaging, which enables apps and services that run on a heterogeneous system to communicate with each other.

The following overview describes the services that are required to implement a distributed communication protocol. This example uses uProtocol and Azure services.

#### Overview

:::image type="content" source="images/software-defined-vehicle-uprotocol-on-azure.svg" alt-text="Diagram that shows the distributed communication protocol, uProtocol, on Azure." border="false" lightbox="images/software-defined-vehicle-uprotocol-on-azure.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/software-defined-vehicle.pptx) of this architecture.*

* Messages are sent from the vehicle's **cloud connector** to **Event Grid**. Messages are transferred via the *uProtocol* definition over MQTT.

* The **cloud gateway** is the cloud service that devices connect with to communicate with the back-office domain or device.
* The **uStreamer** is an event dispatcher that enables *uEs* on devices to seamlessly communicate with various transport layer protocols. It performs functionalities, such as file transfer and event buffering. For example, when events move from one transport to the next, they flow through the uStreamer. The uStreamer is similar to an IP router.
* The **uBus** is a message bus that dispatches *CEs* between *uEs* over a common transport. It provides multicast and forwarding functionality. It functions like a network switch.
* The **uCDS** provides a means for uEs to discover each other, including their location (address) and properties.
* The **uSubscription** is a subscription-management service that manages the publisher and subscriber design patterns for the *uEs*.
* The **uTwin** is a local cache of published events. The uTwin stores the published message via a primary key. Local software components can retrieve the key. This primary key is the full name of the topic, including the device name. The primary key represents a topic, so only the last event of a given topic is stored in the uTwin. The collection of events stored in a uTwin instance of a device, whose keys include a specific device name, represent the digital twin of that device. Examples of vehicle events include updates for tire pressure, window position, gear position, and vehicle mode (driving or parked). Events can be any information that's published in the vehicle and used for operating the vehicle or activating its features.
* The **uEs** are applications and services that provide functionality to end users. These apps use the core uEs for discovery, subscription, and access to the digital twin.

The following table shows suggested services that are relevant to a uProtocol implementation on Azure.

| uProtocol component | Functionality | Azure service |
|---------------------|---------------|---------------|
| Cloud gateway       | MQTT broker   | Event Grid |
| uStreamer           | File transfer, event buffering, D2D routing, protocol translation | Event Hubs, Storage, Functions, AKS |
| uDiscovery          | Service discovery              | Microservices on AKS
| uBus                | Multicast forwarding | Event Hubs, Service Bus, Event Grid |
| uSubscription       | Pub/sub topic management |  Microservices on AKS |
| uTwin               | Last-known state | Azure Digital Twins, Azure Cache for Redis |

For more information about uProtocol components, SDKs, and documentation, see the [uProtocol GitHub repository](https://github.com/eclipse-uprotocol).

#### Provision devices for uProtocol

:::image type="content" source="images/software-defined-vehicle-uprotocol-provisioning.svg" alt-text="Diagram that shows the uProtocol provisioning flow." border="false" lightbox="images/software-defined-vehicle-uprotocol-provisioning.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/software-defined-vehicle.pptx) of this architecture.*

1. The **factory system** commissions the vehicle device to the desired construction state. Commissioning includes firmware and software initial installation and configuration. As part of this process, the factory system obtains and writes the device certificate. The public key infrastructure provider creates the certificate.

1. The **factory system** registers the vehicle and device via the vehicle and device provisioning API.
1. The device registration application registers the device identity in the **device provisioning and device registry**.
1. The information about authentication and authorization is stored in **Microsoft Entra ID**.
1. The factory system triggers the **device provisioning client** to connect to the **device provisioning service**. The device retrieves the connection information to the assigned MQTT broker feature in **Event Grid**.
1. The factory system triggers the device to establish a connection to the MQTT broker feature in **Event Grid** for the first time. **Event Grid** authenticates the device with the client authentication root certificate and extracts the client information.
1. **Event Grid** manages authorization for allowed topics via the device information that's stored in **Microsoft Entra ID**.
1. The OEM **dealer system** triggers the registration of a new device if a part replacement is required.

### Example: Eclipse automotive software stack

The following architecture describes an automotive software stack that's based on Eclipse project components. In this architecture, Eclipse uProtocol can be used as a communication protocol.

:::image type="content" source="images/software-defined-vehicle-sample-automotive-stack.svg" alt-text="Diagram that shows the architecture for the Eclipse SDV-based automotive software stack." border="false" lightbox="images/software-defined-vehicle-sample-automotive-stack.svg":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/software-defined-vehicle.pptx) of this architecture.*

* [Eclipse Chariott](https://projects.eclipse.org/projects/automotive.chariott) is a gRPC service that provides a common interface for interacting with applications. Applications can register with Eclipse Chariott's service registry to advertise their capabilities and enable service discovery.

* [Eclipse Ibeji](https://projects.eclipse.org/projects/automotive.ibeji) provides the capability to express a digital representation of the vehicle state and its capabilities through an extensible, open, and dynamic architecture that provides access to the vehicle hardware, sensors, and capabilities.
* [Eclipse Freyja](https://github.com/eclipse-ibeji/freyja) is an application that enables synchronization between the digital twin state on the vehicle (the instance digital twin) and the digital twin state in the cloud (the canonical digital twin).
* [Eclipse Agemo](https://github.com/eclipse-chariott/Agemo) is a gRPC service that provides publish and subscribe functionalities for applications in the vehicle, including Eclipse Ibeji and Eclipse Chariott.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

* [Daniel Lueddecke](https://www.linkedin.com/in/daniellueddecke) | Cloud Solution Architect, Automotive
* [Mario Ortegon Cabrera](http://www.linkedin.com/in/marioortegon) | Principal Program Manager, MCI SDV & Mobility
* [Filipe Prezado](https://www.linkedin.com/in/filipe-prezado-9606bb14) | Principal Program Manager, MCI SDV & Mobility
* [Sandeep Pujar](https://www.linkedin.com/in/spujar) | Principal PM Manager, Azure Messaging
* [Ashita Rastogi](https://www.linkedin.com/in/ashitarastogi) | Principal Program Manager, Azure Messaging
* [Boris Scholl](https://www.linkedin.com/in/bscholl) | General Manager, Partner Architect-Azure Cloud & AI

Other contributors:

* [Frederick Chong](https://www.linkedin.com/in/frederick-chong-5a00224) | Principal PM Manager, MCIGET SDV & Mobility
* [Frank Kaleck](https://www.linkedin.com/in/frank-kaleck) | Industry Advisor - Manufacturing, Mobility & Automotive
* [Mehmet Kucukgoz](https://www.linkedin.com/in/mehmetkucukgoz) | Principal PM Manager, Azure IoT Hub

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

* [GitHub adds support for coding standards AUTOSAR C++ and CERT C++](https://github.blog/2022-06-20-adding-support-for-coding-standards-autosar-c-and-cert-c)
* [Get started with Copilot](https://docs.github.com/copilot/getting-started-with-github-copilot)
* [Create and connect to a dev box by using the Dev Box developer portal](/azure/dev-box/quickstart-create-dev-box)
* [Automotive messaging, data, and analytics reference architecture](/azure/event-grid/mqtt-automotive-connectivity-and-data-solution)

## Related resources

* [Create an AVOps solution](../../solution-ideas/articles/avops-architecture.yml)

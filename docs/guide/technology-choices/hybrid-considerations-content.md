This article guides you in choosing a hybrid solution to fit your business needs.

A hybrid environment combines public cloud services with on-premises infrastructure. A hybrid strategy is common for organizations that have strict data sovereignty regulations, low latency requirements, or crucial resiliency and business continuity needs.

Azure provides several platform-as-a-service (PaaS), hardware, and software solutions that host applications and workloads, extend services, and provide security and operational tooling for on-premises, edge, and multicloud hybrid scenarios.

- *Edge* hybrid environments, such as internet of things (IoT), host devices that provide on-premises computing and data storage. This approach is common for organizations and applications that need to remain close to the data, reduce latency, or compute data in near real time.

- *Multicloud* hybrid environment use multiple cloud computing services and providers. This strategy provides flexibility, can reduce risk, and lets organizations investigate and use different providers for specific applications. This approach usually requires cloud-specific knowledge, and adds complexity in management, operations, and security.

Hybrid solutions encompass a system's [control plane and data plane](/azure/azure-resource-manager/management/control-plane-and-data-plane).

- The *control plane* refers to resource management operations, such as creating Azure virtual machines (VMs). Azure uses [Azure Resource Manager](/azure/azure-resource-manager/management/overview) to handle the control plane. Hybrid solutions can extend Azure control plane operations outside of Azure datacenters, or run dedicated control plane instances.

- The *data plane* uses the capabilities of the resource instances the control plane creates. For example, you use the data plane when you access Azure VMs over remote desktop protocol (RDP).

## Choose a hybrid solution

A hybrid solution must consider requirements and constraints for hardware, hosting location, application or workload type, and developer operations (DevOps). Solutions must also meet organizational and industry standards and regulations.

Hybrid solution considerations include:

- Hardware requirements: Consider whether to refresh, repurpose, or replace existing hardware. Brownfield scenarios use existing hardware in modern hybrid workload approaches. Greenfield scenarios buy new hardware or use hardware as a service with a monthly fee.

- Hosting location: Consider whether to use on-premises datacenter, edge, Azure cloud, or multicloud hosting with a consistent cloud-native technology approach. Business, compliance, cost, or security requirements might determine hosting location.

- Workload type: Consider whether the workloads are distributed, containerized, or traditional IT hosted on VMs or databases. [Azure IoT Hub](/azure/iot-hub), [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) clusters, or PaaS solutions outside of Azure datacenters can host hybrid workloads.

All factors are important for the final decision, but depending on requirements, background, and expertise, organizations might approach solution evaluation from different starting points. Developers and DevOps teams might emphasize criteria like mass deployments and restricted vs. purpose-built hardware. System administrators might focus on hosting location or hardware and hypervisor usage.

Some organizations and teams might start with their hardware and hosting requirements and constraints. Other organizations might start by investigating various PaaS and cloud service capabilities from an application and workload perspective. The following sections present hybrid solution decision trees from both the hardware and services perspectives.

## Start with hardware

The following hybrid solution decision tree starts with a hardware deployment and hosting model, and proceeds through decision points to select an appropriate Azure hybrid solution. The three deployment choices are existing or custom hardware, another public cloud, or Microsoft-specified deployments.

[ ![Diagram that shows a decision tree for selecting Azure hybrid services.](./images/hybrid-decision-tree.png) ](./images/hybrid-decision-tree.png#lightbox)


For **existing or custom** deployments:

1. Decide whether the hardware is **restricted** or deployed in a **datacenter**.

1. For **restricted** hardware, decide whether the deployment is **mass** or **low scale**. Large-scale deployments have different requirements than smaller-scale implementations. Deployments based on containers or distributed devices must be able to massively scale on demand.

1. For **datacenters** and **other public cloud** deployments, determine whether the workload type uses **containers** or traditional IT deployment in **VMs** or **SQL** databases.

1. **IoT workloads** can use [Azure IoT Edge](/azure/iot-edge). Traditional, database, and cloud-native deployments can use [Azure Arc](/azure/azure-arc/overview)-enabled services. **Container-based** deployments can use Azure Arc-enabled Kubernetes, and **VM-based** deployments can use Azure Arc-enabled servers. **Restricted devices** can use rack, portable, or ruggedized servers for traditional or cloud deployments.

For **Microsoft-specified** deployments:

1. Decide whether you want **hardware as a service** or **Azure datacenter-like** deployments. Azure **datacenter-like** deployments can use [Azure Stack Hub](/azure-stack/operator/azure-stack-overview).

1. For **hardware as a service**, decide whether your workload type uses **data transfer and compute**, or a [hyperconverged](/windows-server/hyperconverged) datacenter. For a **hyperconverged** solution, you can use [Azure Stack HCI](/azure-stack/hci).

1. **Data transfer and compute** workloads can use [Azure Stack Edge](/azure/databox-online). **Datacenter** deployments can use [Azure Stack Edge Pro 2](/azure/databox-online/azure-stack-edge-pro-2-overview), **portable** deployments can use [Azure Stack Edge Mini R](/azure/databox-online/azure-stack-edge-mini-r-overview), and **ruggedized** deployments can use [Azure Stack Edge Pro R](/azure/databox-online/azure-stack-edge-pro-r-overview).

- Containerized and distributed services might address concerns like business continuity differently from traditional IT.
- Traditional apps can run on VMs with hyperconverged infrastructure and Azure operational, security, and management tooling for day-two operations.
- Cloud-native apps can run on a container orchestrator like AKS and use other Azure PaaS services.
- Cloud-trained models deployed on-premises or on IoT Edge can monitor IoT devices at scale and provide Azure data transfer.

## Start with services

The following hybrid solution decision tree starts with Azure services, and describes their supported hardware capabilities and deployment models. All Azure services include the Azure portal and other Azure operations and management tools.

![ ![Diagram that shows Azure hybrid services capabilities and characteristics.](./images/hybrid-choices.png) ](./images/hybrid-choices.png#lightbox)

- The **Azure cloud** can provide cloud-based software as a service (SaaS), infrastructure as a service (IaaS), and PaaS compute, storage, and network services. The services run on Microsoft hardware in Azure datacenters.

- [Azure Stack](/azure-stack/) is a family of products and solutions that extend Azure to the edge or to on-premises datacenters. Azure Stack provides several solutions for different use cases.

  - [Azure Stack Hub](https://azure.microsoft.com/products/azure-stack/hub) extends Azure to run apps in on-premises environments. Azure Stack Hub provides SaaS, IaaS, and PaaS hyperconverged compute, storage, and network services, and runs on industry-standard hardware on-premises or in multicloud datacenters. Azure Stack Hub delivers Azure services to datacenters with integrated systems, and can run on connected or disconnected environments.
  - [Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci) is a hyperconverged solution that uses validated hardware to run virtualized and containerized workloads on-premises. Azure Stack HCI provides VM-based and AKS-based hyperconverged compute, storage, and network services, and runs on industry-standard hardware on-premises or in multicloud datacenters. Azure Stack HCI connects workloads to Azure for cloud services and management.
  - [Azure Stack Edge](/azure/databox-online/) delivers Azure capabilities such as compute, storage, networking, and hardware-accelerated machine learning to edge locations. Azure Stack Edge provides VM-based, AKS-based, machine learning, and data transfer services on industry-standard hardware as a service, and runs on-premises or in multicloud datacenters.

- [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge) and [IoT Hub](https://azure.microsoft.com/services/iot-hub) deploy custom functionality to mass devices. IoT Edge natively integrates with IoT Hub to provide DevOps, PaaS, and containerized services on custom and industry-standard hardware, and runs on-premises or in multicloud datacenters.

- [Azure Arc](https://azure.microsoft.com/services/azure-arc) provides application delivery and management by using Azure Arc-enabled services on VMs, SQL databases, and Kubernetes. Azure Arc projects existing bare metal, VM, and Kubernetes infrastructure resources into Azure to handle operations with Azure management and security tools. Azure Arc simplifies governance and management by delivering a consistent multicloud and on-premises management platform for Azure services.

  Azure Arc runs on existing industry-standard hardware, hypervisors, Azure Stack HCI, or Azure Stack Edge, on-premises or in multicloud datacenters. Azure Arc provides the following capabilities:
  
  - [Azure Arc-enabled servers](/azure/azure-arc/servers/overview)
  - [SQL Server on Azure Arc-enabled servers](/sql/sql-server/azure-arc/overview)
  - [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview)
  - [Azure Arc-enabled vSphere](/azure/azure-arc/vmware-vsphere/overview)
  - [Arc-enabled System Center Virtual Machine Manager](/azure/azure-arc/system-center-virtual-machine-manager/overview)
  - [Azure Arc-enabled VMs on Azure Stack HCI](/azure-stack/hci/manage/azure-arc-enabled-virtual-machines)

  Azure Arc-enabled services let you create on-premises and multicloud applications with Azure PaaS and data services such as [Azure App Service, Azure Functions, Azure Logic Apps](/azure/app-service/overview-arc-integration), [Azure SQL Managed Instance](/azure/azure-arc/data/managed-instance-overview), [PostgreSQL Hyperscale](/azure/azure-arc/data/what-is-azure-arc-enabled-postgres-hyperscale), and [Azure Machine Learning](/azure/machine-learning/how-to-attach-kubernetes-anywhere). You can run these services anywhere and use existing infrastructure.

## Next steps

- [Azure hybrid and multicloud documentation](/hybrid)
- [Azure hybrid and multicloud patterns and solutions documentation](/hybrid/app-solutions)
- [Introduction to hybrid and multicloud](/azure/cloud-adoption-framework/scenarios/hybrid)
- [Introduction to Azure hybrid cloud services (Training module)](/training/modules/intro-to-azure-hybrid-services)

## Related resources

- [Hybrid architecture design](../../hybrid/hybrid-start-here.md)
- [Overview of a hybrid workload](../../framework/hybrid/hybrid-overview.md)
- [DevOps in a hybrid environment](../../solution-ideas/articles/devops-in-a-hybrid-environment.yml)
- [Run containers in a hybrid environment](../../hybrid/hybrid-containers.yml)
- [Implement a secure hybrid network](../../reference-architectures/dmz/secure-vnet-dmz.yml)

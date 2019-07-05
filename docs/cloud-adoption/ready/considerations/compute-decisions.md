---
title: "Azure readiness compute design decisions"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Azure readiness compute design decisions
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/15/2019
ms.topic: guide
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Compute design decisions

A key consideration when preparing for your cloud adoption effort is determining the compute requirements for hosting your workloads. Azure compute products and services support a wide variety of workload computing scenarios and capabilities. How you configure your landing zone environment to support these requirements will depend on your workload's governance, technical, and business requirements.

## Identify compute services requirements

As part of your landing zone evaluation and preparation, you will want to identify all compute resources that your landing zone will need to support. This process involves assessing each of the applications and services that make up your workloads for compute and hosting requirements. Once you've identified and documented these requirements, you can create policies for your landing zone controlling what resource types are allowed based on your workload needs.

For each of the applications or services you will be deploying to your landing zone environment, use the following decision tree as a starting point when determining your compute services requirements.

![Azure compute services decision tree](../../_images/ready/compute-decision-tree.png)

### Key questions

Answering the following questions about your workloads will help you make decisions based on the above tree.

> [!NOTE]
> You can find additional guidance on assessing compute options for each of your application or services in the Azure application architecture guide's [choosing a compute service](/azure/architecture/guide/technology-choices/compute-overview) section.

- **Are you building net new applications and services, or migrating from existing on-premises workloads?** Developing new applications as part of your cloud adoption efforts allows you to take full advantage of modern cloud-based hosting technologies from the design phase on.
- **If you're migrating existing workloads, can they take advantage of modern cloud technologies?** Migrating on-premises workloads will require analysis to determine if you can easily optimize existing applications and services to take advantage of modern cloud technologies, or if a *lift-and-shift* approach is better suited to your workloads.
- **Can your applications or services take advantage of containers?** If your applications are good candidates for containerized hosting, you can take advantage of the resource efficiency, scalability, and orchestration capabilities provided by [Azure container services](https://azure.microsoft.com/product-categories/containers). Note that both [Azure Disk Storage](/azure/virtual-machines/windows/managed-disks-overview) and [Azure Files](/azure/storage/files/storage-files-introduction) services can be used for persistent storage for containerized applications.
- **Are you applications Web- or API-based, and using PHP, ASP.NET, Node.js, or similar technologies?** Web aps can be deployed to managed [App Service](/azure/app-service/overview) instances, removing the need to maintain virtual machines for hosting purposes.
- **Will you require full control over the OS and hosting environment of your workload?** If you need to control the hosting environment, including OS, disks, locally running software, and other configuration, you can use [virtual machines](https://azure.microsoft.com/services/virtual-machines) to host your applications and services. Note that in addition to choosing your virtual machine sizes and performance tiers, your decisions regarding virtual disk storage will also impact performance and SLAs related to your IaaS-based workloads. Consult the [Azure Disk Storage](/azure/virtual-machines/windows/managed-disks-overview) documentation for more information.
- **Will your workload involve HPC capabilities?** [Azure Batch](/azure/batch/batch-technical-overview) provides job scheduling and autoscaling of compute resources as a platform service, making it easy to run large-scale parallel and HPC applications in the cloud.
- **Will your applications make use of a microservices architecture?** Applications using a microservices-based architecture can take advantage of several optimized compute technologies. Self-contained, event-driven workloads can use [Azure Functions](/azure/azure-functions/functions-overview) to build scalable serverless applications without the need to worry about infrastructure. For applications that require more control over the environment where microservices run, container services such as [Azure Container Instances](/azure/container-instances/container-instances-overview), [Azure Kubernetes Service](/azure/aks/intro-kubernetes), and [Service Fabric](/azure/service-fabric/service-fabric-overview) can be used. 

> [!NOTE]
> Most Azure Compute services are used in combination with Azure Storage. Consult the [storage decisions guidance article](./storage-guidance.md) related storage decisions.  

## Common compute scenarios

The following table illustrates a few common usage scenarios and the recommended compute services best suited to handle them.

| **Scenario** | **Compute service** |
| --- | --- |
| Provision Linux and Windows virtual machines in seconds with the configurations of your choice. | [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) |
| Achieve high availability by autoscaling to create thousands of VMs in minutes. | [Virtual Machine Scale Sets](https://azure.microsoft.com/services/virtual-machine-scale-sets) |
| Simplify the deployment, management, and operations of Kubernetes. | [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) |
| Accelerate app development using an event-driven serverless architecture. | [Azure Functions](https://azure.microsoft.com/services/functions) |
| Develop microservices and orchestrate containers on Windows and Linux. | [Service Fabric](https://azure.microsoft.com/services/service-fabric) |
| Quickly create cloud apps for web and mobile with fully managed platform. | [App Service](https://azure.microsoft.com/services/app-service) |
| Containerize apps and easily run containers with a single command. | [Azure Container Instances](https://azure.microsoft.com/services/container-instances) |
| Cloud-scale job scheduling and compute management with the ability to scale to tens, hundreds, or thousands of virtual machines. | [Batch](https://azure.microsoft.com/services/batch) |
| Create highly available, scalable cloud applications and APIs that help you focus on apps instead of hardware. | [Cloud Services](https://azure.microsoft.com/services/cloud-services) |

## Regional availability

Azure lets you deliver services at the scale you need to reach your customers and partners, _wherever they are_. A key factor in planning your cloud deployment is to determine what Azure region will host your workload resources.

Some compute options, such as Azure App Services, are generally available in most Azure regions. However, some compute services are only supported in selected regions, and certain virtual machine types and their associated storage types have limited regional availability. Before deciding on what regions you will deploy your compute resources to, we recommend referring to the [regions page](https://azure.microsoft.com/global-infrastructure/services/?regions=all&products=azure-vmware-cloudsimple,cloud-services,batch,container-instances,app-service,service-fabric,functions,kubernetes-service,virtual-machine-scale-sets,virtual-machines) to check the latest status.

To learn more about Azure global infrastructure, you can visit [Azure regions page](https://azure.microsoft.com/global-infrastructure/regions). You can also consult the [products available by region](https://azure.microsoft.com/global-infrastructure/services/?regions=all&products=all) page for specific details on what overall services are available in each Azure region.

## Data residency and compliance requirements

Legal and contractual requirements related to data storage will often apply to your workloads. These requirements may vary based on the location of your organization, the jurisdiction where files and data are stored and processed, and your applicable business sector. Components of understanding data obligations include data classification, data location, and the respective responsibilities for data protection under the shared responsibility model. Many compute solutions depend on linked storage resources, so these requirements may also influence you compute decisions. For help with understanding these requirements, see the white paper [Achieving Compliant Data Residency and Security with Azure](https://azure.microsoft.com/resources/achieving-compliant-data-residency-and-security-with-azure).

As part of these compliance efforts you may need to control where your compute resources are physically located. Azure regions are organized into groups called geographies. An [Azure geography](https://azure.microsoft.com/global-infrastructure/geographies) ensures that data residency, sovereignty, compliance, and resiliency requirements are honored within geographical and political boundaries. If your workloads are subject to data sovereignty or other compliance requirements, storage resources must be deployed to regions in a compliant Azure geography.

## Establish controls for compute services

As part of preparing your landing zone environment, you can establish controls limiting what users are allowed to deploy. These controls can help manage costs and limit security risks, while still allowing developers and IT teams to deploy and configure resources needed to support your workloads.  

After you've identified and documented your landing zone's requirements, you can use [Azure Policy](/azure/governance/policy/overview) to control the compute resources you allow users to create. These controls can take the form of [allowing or denying the creation of compute resource types](/azure/governance/policy/samples/allowed-resource-types), for instance restricting users to creating only Azure App Service or Azure Function resources. Policy can also be used to control the allowable options when creating a resource, like [restricting what virtual machine SKUs can be provisioned](https://docs.microsoft.com/azure/governance/policy/samples/allowed-skus-storage), or only [allowing specific VM images](https://docs.microsoft.com/azure/governance/policy/samples/allowed-custom-images).

Policies can be scoped to resources, resource groups, subscriptions, or management groups. These policies can also be included in [Azure Blueprint](/azure/governance/blueprints/overview) definitions and applied repeatedly throughout your cloud estate.

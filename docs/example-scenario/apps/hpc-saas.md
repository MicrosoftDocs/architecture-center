---
title: A computer-aided engineering service
titleSuffix: Azure Example Scenarios
description: Provide a software-as-a-service (SaaS) platform for computer-aided engineering (CAE) on Azure.
author: alexbuckgit
ms.date: 08/22/2018
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
  - HPC
social_image_url: /azure/architecture/example-scenario/apps/media/architecture-hpc-saas.png
---

# A computer-aided engineering service on Azure

This example scenario demonstrates delivery of a software-as-a-service (SaaS) platform built on the high-performance computing (HPC) capabilities of Azure. This scenario is based on an engineering software solution. However, the architecture is relevant to other industries requiring HPC resources such as image rendering, complex modeling, and financial risk calculation.

This example demonstrates an engineering software provider that delivers computer-aided engineering (CAE) applications to engineering firms and manufacturing enterprises. CAE solutions enable innovation, reduce development times, and lower costs throughout the lifetime of a product's design. These solutions require substantial compute resources and often process high data volumes. The high costs of an on-premises HPC appliance or high-end workstations often put these technologies out of reach for small engineering firms, entrepreneurs, and students.

The company wants to expand the market for its applications by building a SaaS platform backed by cloud-based HPC technologies. Their customers should be able to pay for compute resources as needed and access massive computing power that would be unaffordable otherwise.

The company's goals include:

- Taking advantage of HPC capabilities in Azure to accelerate the product design and testing process.
- Using the latest hardware innovations to run complex simulations, while minimizing the costs for simpler simulations.
- Enabling true-to-life visualization and rendering in a web browser, without requiring a high-end engineering workstation.

## Relevant use cases

Other relevant use cases include:

- Genomics research
- Weather simulation
- Computational chemistry applications

## Architecture

![Architecture for a SaaS solution enabling HPC capabilities][architecture]

- Users can access NV-series virtual machines (VMs) via a browser with an HTML5-based RDP connection using the [Apache Guacamole service](https://guacamole.apache.org/). These VM instances provide powerful GPUs for rendering and collaborative tasks. Users can edit their designs and view their results without needing access to high-end mobile computing devices or laptops. The scheduler spins up additional VMs based on user-defined heuristics.
- From a desktop CAD session, users can submit workloads for execution on available HPC cluster nodes. These workloads perform tasks such as stress analysis or computational fluid dynamics calculations, eliminating the need for dedicated on-premises compute clusters. These cluster nodes can be configured to autoscale based on load or queue depth based on active user demand for compute resources.
- Azure Kubernetes Service (AKS) is used to host the web resources available to end users.

### Components

- [H-series virtual machines](/azure/virtual-machines/linux/sizes-hpc) are used to run compute-intensive simulations such as molecular modeling and computational fluid dynamics. The solution also takes advantage of technologies like remote direct memory access (RDMA) connectivity and InfiniBand networking.
- [NV-series virtual machines](/azure/virtual-machines/windows/sizes-gpu) give engineers high-end workstation functionality from a standard web browser. These virtual machines have NVIDIA Tesla M60 GPUs that support advanced rendering and can run single precision workloads.
- [General purpose virtual machines](/azure/virtual-machines/linux/sizes-general) running CentOS handle more traditional workloads such as web applications.
- [Application Gateway](/azure/application-gateway/overview) load balances the requests coming into the web servers.
- [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes) is used to run scalable workloads at a lower cost for simulations that don't require the high end capabilities of HPC or GPU virtual machines.
- [Altair PBS Works Suite](https://www.pbsworks.com/PBSProduct.aspx?n=PBS-Works-Suite&c=Overview-and-Capabilities) orchestrates the HPC workflow, ensuring that enough virtual machine instances are available to handle the current load. It also deallocates virtual machines when demand is lower to reduce costs.
- [Blob storage](/azure/storage/blobs/storage-blobs-introduction) stores files that support the scheduled jobs.

### Alternatives

- [Azure CycleCloud](/azure/cyclecloud/overview) simplifies creating, managing, operating, and optimizing HPC clusters. It offers advanced policy and governance features. CycleCloud supports any job scheduler or software stack.
- [HPC Pack](/azure/virtual-machines/windows/hpcpack-cluster-options) can create and manage an Azure HPC cluster for Windows Server-based workloads. HPC Pack isn't an option for Linux-based workloads.
- [Azure Automation State Configuration](/azure/automation/automation-dsc-overview) provides an infrastructure-as-code approach to defining the virtual machines and software to be deployed. Virtual machines can be deployed as part of a virtual machine scale set, with autoscaling rules for compute nodes based on the number of jobs submitted to the job queue. When a new virtual machine is needed, it is provisioned using the latest patched image from the Azure image gallery, and then the required software is installed and configured via a PowerShell DSC configuration script.
- [Azure Functions](/azure/azure-functions/functions-overview)

## Considerations

- While using an infrastructure-as-code approach is a great way to manage virtual machine build definitions, it can take a long time to provision a new virtual machine using a script. This solution found a good middle ground by using the DSC script to periodically create a golden image, which can then be used to provision a new virtual machine faster than completely building a VM on demand using DSC. Azure DevOps Services or other CI/CD tooling can periodically refresh golden images using DSC scripts.
- Balancing overall solution costs with fast availability of compute resources is a key consideration. Provisioning a pool of N-series virtual machine instances and putting them in a deallocated state lowers the operating costs. When an additional virtual machine is needed, reallocating an existing instance will involve powering up the virtual machine on a different host, but the PCI bus detection time required by the OS to identify and install drivers for the GPU is eliminated because a virtual machine that is deprovisioned and then reprovisioned will retain the same PCI bus for the GPU when restarted.
- The original architecture relied entirely on Azure virtual machines for running simulations. In order to reduce costs for workloads that didn't require all the capabilities of a virtual machine, these workloads were containerized and deployed to Azure Kubernetes Service (AKS).
- The company's workforce had existing skills in open-source technologies. They can take advantage of these skills by building on technologies like Linux and Kubernetes.

## Pricing

To help you explore the cost of running this scenario, many of the required services are pre-configured in a [cost calculator example][calculator]. The costs of your solution depend on the number and scale of services needed to meet your requirements.

The following considerations will drive a substantial portion of the costs for this solution:

- Azure virtual machine costs increase linearly as additional instances are provisioned. Virtual machines that are deallocated will only incur storage costs, and not compute costs. These deallocated machines can then be reallocated when demand is high.
- Azure Kubernetes Services costs are based on the VM type chosen to support the workload. The costs will increase linearly based on the number of VMs in the cluster.

## Next Steps

- Read the [Altair customer story][source-document]. This example scenario is based on a version of their architecture.
- Review other [Big Compute solutions](https://azure.microsoft.com/solutions/big-compute) available in Azure.

<!-- links -->
[architecture]: ./media/architecture-hpc-saas.png
[source-document]: https://customers.microsoft.com/story/altair-manufacturing-azure
[calculator]: https://azure.com/e/3cb9ccdc893f41ffbcdb00c328178ccf

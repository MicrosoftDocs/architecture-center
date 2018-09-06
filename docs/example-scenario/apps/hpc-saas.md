---
title: Computer-aided engineering through high performance computing on Azure
description: <Article Description>
author: alexbuckgit
ms.date: 08/22/2018
---

# Computer-aided engineering through high performance computing on Azure

This example scenario demonstrates delivery of a software-as-a-service (SaaS) platform built on the high-performance computing (HPC) capabilities of Azure. This scenario is based on an engineering software solution. However, the architecture is relevant to other industries requiring HPC resources such as image rendering, complex modeling, and financial risk calculation.

This example demonstrates an engineering software provider that delivers computer-aided engineering (CAE) applications to engineering firms and manufacturing enterprises. CAE solutions enable innovation, reduce development times, and lower costs throughout the lifetime of a product's design. These solutions require a substantial compute resources and often process high data volumes. The high costs of an on-premises HPC appliance or high-end workstations often put these technologies out of reach for small engineering firms, entrepreneurs, and students. 

The company wants to expand the market for its applications by building a SaaS platform backed by cloud-based HPC technologies. Their customers should be able to pay for compute resources as needed and access massive computing power that would be unaffordable otherwise. The company's goals include:
* Taking advantage of HPC capabilities in Azure to accelerate the product design and testing process
* Using the latest hardware innovations to run complex simulations, while minimizing the costs for simpler simulations  
* Enabling true-to-life visualization and rendering in a web browser, without requiring a high-end engineering workstation

## Potential use cases

Other scenarios using this architecture might include:

* Genomics research
* Weather simulation
* Computational chemistry applications

## Architecture

![Architecture for a SaaS solution enabling HPC capabilities][architecture]

* Users can access NV-series virtual machines with powerful GPUs for rendering and collaborative tasks via a browser with a custom Remote Desktop browser control. Users can edit their designs and view their results. The HPC scheduler spins up additional nodes based on the number of waiting users.
* Users access a web application hosted in CentOS virtual machines to submit workloads to a queue for execution on available HPC cluster nodes.
* Complex workloads are executed using nodes in an HPC compute cluster. The HPC scheduler invokes Resource Manager templates to spin up additional nodes based on the depth of the queue.
* Simpler workloads are executed using an Azure Kubernetes Service cluster.


### Components

* [H-series virtual machines](/azure/virtual-machines/linux/sizes-hpc) are used to run compute-intensive simulations such as molecular modeling and computational fluid dynamics. The solution also takes advantage of technologies like remote direct memory access (RDMA) connectivity and InfiniBand networking.
* [NV-series virtual machines](/azure/virtual-machines/windows/sizes-gpu) give engineers high-end workstation functionality from a standard web browser. These virtual machines have NVIDIA Tesla M60 GPUs that support advanced rendering and can run single precision workloads.
* [General purpose virtual machines](/azure/virtual-machines/linux/sizes-general) running CentOS handle more traditional workloads such as web applications.
* [Application Gateway](/azure/application-gateway/) load balances the requests coming into the web servers.
* [Azure Kubernetes Service (AKS)](/azure/aks/) is used to run scalable workloads at a lower cost for simulations that don't require the high end capabilities of HPC or GPU virtual machines.
* [Altair PBS Works Suite](https://www.pbsworks.com/PBSProduct.aspx?n=PBS-Works-Suite&c=Overview-and-Capabilities) orchestrates the HPC workflow, ensuring that enough virtual machine instances are available to handle the current load. It also deallocates virtual machines when demand is lower to reduce costs.

### Alternatives

* [Azure CycleCloud](/azure/cyclecloud/overview) simplifies creating, managing, operating, and optimizing HPC clusters. It offers advanced policy and governance features. CycleCloud supports any job scheduler or software stack.
* [HPC Pack](/azure/virtual-machines/windows/hpcpack-cluster-options) can create and manage an Azure HPC cluster for Windows Server-based workloads. HPC Pack isn't an option for Linux-based workloads.
* [Azure Automation State Configuration](/azure/automation/automation-dsc-overview) provides an infrastructure-as-code approach to defining the virtual machines in a cluster. When a new set of virtual machines is needed, they are provisioned using the latest definition specified in a PowerShell DSC configuration script.

## Considerations

* While using an infrastructure-as-code approach is a great way to manage virtual machine build definitions, it can take a long time to provision a new virtual machine using a script. This solution found a good middle ground by using the DSC script to periodically create a golden image, which can then be used to provision a new virtual machine much more quickly.
* Balancing overall solution costs with fast availability of compute resources is a key consideration. Provisioning a pool of virtual machine instances and putting them in a deallocated state lowers the operating costs. When an additional virtual machine is needed, reallocating an existing instance is much faster than provisioning a new instance.
* The original architecture relied entirely on Azure virtual machines for running simulations. In order to reduce costs for workloads that didn't require all the capabilities of a virtual machine, these workloads were containerized and deployed to Azure Kubernetes Service (AKS).
* The company's workforce had existing skills in open source technologies. They can take advantage of these skills by building on technologies like Linux and Kubernetes. 

## Pricing

The following considerations will drive a substantial portion of the costs for this solution.

* Azure virtual machine costs will increase linearly as additional instances are provisioned. Virtual machines that are deallocated will only incur storage costs, and not compute costs. These deallocated machines can then be reallocated when demand is high.
* Azure Kubernetes Services costs are based on the VM type chosen to support the workload. The costs will increase linearly based on the number of VMs in the cluster.

## Next Steps

* Read the [Altair customer story][source-document]. This example scenario is based on a version of their architecture.
* Review other [Big Compute solutions](https://azure.microsoft.com/en-us/solutions/big-compute/) available in Azure.
* Learn proven practices for building Azure-based solutions in the [Azure Architecture Center](/azure/architecture/).

<!-- links -->
[source-document]: https://customers.microsoft.com/story/altair-manufacturing-azure
[architecture]: ./media/architecture-diagram-hpc-saas.png
[calculator]: https://azure.com/e/

---
title: Running Computational Fluid Dynamics on Azure
description: Sample solution describing how to run CFD on Azure
author: mikewarr
ms.date: <publish or update date - mm/dd/yyyy>
---
# Running Computational Fluid Dynamics on Azure

CFD simulations not only take time to process, while requiring a significant amount of compute time, but also have a need for specialised hardware. As business needs increase, leading to stretched simulation times and overall grid use, spare capacity becomes an issue. Supplementing with additional hardware is expensive and a considerable long term investment for the future, which is a difficult challenge to achieve given the peaks and troughs a business goes through. By taking advantage of Azure, a lot of these challenges can be overcome, all without any capital expenditure.

Azure provides the specialised hardware you need to accomplish your CFD goals with compute available with both GPU and CPU virtual machines. RDMA (Remote Direct Memory Access) enabled VM sizes facilitate the interconnect needed for MPI (Message Passing Interface), using FDR InfiniBand for low latency networking. Run this either in a hybrid approach with an on-premises grid where a decrease in local capacity can be scaled out to Azure or a completely self contained approach where everything you need is running on Azure, further reducing operational costs. 

To simplify the creation, management, operations and optimization of HPC clusters, Azure CycleCloud can be used to provision clusters to orcestrate data in both hybrid and cloud scenarios. Monitoring the pending jobs it will auto scale for on-demand compute, where you only pay for what you use, with the workload scheduler of your choice. 

## Potential use cases

Consider this scenario for these similar use cases:
> Additional examples to be put here for each vertical
* Aeronautics
* Automotive
* Building HVAC
* Oil & Gas
* Life Sciences

These other uses cases have similar design patterns:

* List of example use cases

## Architecture

![alt text][cyclearch]

The diagram provides a high level overview of a typical hybrid design providing job monitoring of the on-demand nodes in Azure:

1. Connect to the Azure CycleCloud server to configure the cluster
2a. Configure and create the cluster head node, using RDMA enabled machines for MPI 
2b. Add and configure the on-premise head node
3a. If there is insufficient resources, Azure CycleCloud will scale up (or down) compute resources in Azure. A predetermined limit can be defined to prevent over allocation.
3b. Tasks allocated to the execute nodes
4. Job and task information relayed to the Azure CycleCloud server


### Components

* [Azure CycleCloud][cyclecloud] a tool for creating, managing, operating, and optimizing HPC & Big Compute clusters in Azure
* [Virtual Machine Scale Sets (VMSS)][vmss] a group of identical load balanced VMs, capable of being scaled up or down, utilised by Azure CycleCloud
* [Virtual Machines][vms] use Virtual Machines to create a static set of compute instances
* [Storage][storage] accounts are used for synchronization and data retention


### Alternatives

If you are looking to create a grid entirely in Azure, this can also be acheived with Azure CycleCloud, where the Azure CycleCloud server is resident within your Azure subscription.

For a modern application approach where management of a workload scheduler is not desirable, and running CFD applications across specilaised hardware is needed, [Azure Batch][batch] can help. Azure Batch can run large-scale parallel and high-performance computing (HPC) applications efficiently in the cloud. Where you define the Azure compute resources to execute your applications in parallel or at scale without manually configuring or managing infrastructure. Schedule compute-intensive tasks and dynamically add or remove compute resources based on your requirements

## Considerations

> Are there any lessons learned from running this that would be helpful for new customers?  What went wrong when building it out?  What went right?

### Availability, Scalability, and Security

> How do I need to think about managing, maintaining, and monitoring this long term?

> Are there any size considerations around this specific solution?  
> What scale does this work at?  
> At what point do things break or not make sense for this architecture?

> Are there any security considerations (past the typical) that I should know about this?

## Deploy this scenario


Before deploying in Azure, some pre-requisites are required:
1. 

## Pricing

The cost of running an HPC implementation using CycleCloud server will differ depending on a number of factors. For example, CycleCloud is charged by the amount of compute time is used, with the Master and CycleCloud server typically being constantly allocated and running. For the Execute nodes, this will entirely depend on how long these are up and running for, but also which size is used. In addition to this, the normal Azure charges also apply for Storage being used for the VMs and data, 

This scenario is intended to show how CFD applications can be run in Azure, and as such the 

> How much will this cost to run?  
> Are there ways I could save cost?  
> If it scales linearly, than we should break it down by cost/unit.  If it does not, why?  
> What are the components that make up the cost?  
> How does scale effect the cost?
> 
> Link to the pricing calculator with all of the components in the architecture included, even if they're a $0 or $1 usage.  
> If it makes sense, include a small/medium/large configurations.  Describe what needs to be changed as you move to larger sizes

## Next Steps

> Where should I go next if I want to start building this?  
> Are there any reference architectures that help me build this?

## Related Resources

> Are there any relevant case studies or customers doing something similar?
> Is there any other documentation that might be useful?  
> Are there product documents that go into more detail on specific technologies not already linked


<!-- links -->
[calculator]: https://azure.com/e/
[availability]: /azure/architecture/checklist/availability
[resource-groups]: /azure/azure-resource-manager/resource-group-overview
[resiliency]: /azure/architecture/resiliency/
[security]: /azure/security/
[scalability]: /azure/architecture/checklist/scalability
[cyclearch]: /HybridHPCReferenceArchitecture.png
[vmss]: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview
[cyclecloud]: https://docs.microsoft.com/en-us/azure/cyclecloud/
[rdma]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-hpc#rdma-capable-instances
[gpu]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-gpu
[hpcsizes]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-hpc
[vms]: https://docs.microsoft.com/en-us/azure/virtual-machines/
[storage]: https://azure.microsoft.com/services/storage/
[low-pri]: https://docs.microsoft.com/en-ca/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-use-low-priority
[batch]: https://docs.microsoft.com/en-us/azure/batch/


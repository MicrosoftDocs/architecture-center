---
title: Hybrid HPC in Azure
description: Running hybrid HPC workloads in Azure and on-premises
author: Mike Warrington and Ben Hummerstone
ms.date: <publish or update date>
---
# Hybrid HPC in Azure

High Performance Computing on Azure is somtimes also referred to as Big Compute, as it moves away from the traditional need for on-premises specialist hardware as a major investment. On-demand compute resources can be utilised when a buiness needs it the most, either with hardware for specific HPC scenarios (GPU or RDMA for instance) or general purpose VMs that provide a balance on cost and performance. 

This sample solution demonstrates how CycleCloud* can be used to orchestrate an IaaS HPC grid running on Azure, while also providing an optional scenario to extend a grid running on-premises to Azure for on demand compute resources.

By using CycleCloud, the manual work to create an IaaS grid in the cloud becomes an efficient process, and can also be used to faciliate a new grid for Disaster Recovery or failover purposes. Additionally, organisations can build multiple grids and be confident there is no infrastructure drift taking place between deployments.

\* CycleCloud has been a recent aquisition for Microsoft, we are currently in the process of intregrating this solution with Azure. During this period the functionality of CycleCloud will not be modified.

## Potential use cases

You should consider this solution for the following use cases:

* If you have been manually building HPC IaaS infrastructures or using an ARM template, but want to further automate the deployment process.
* Where there is a need to use on-demand compute in Azure while maintaining an on-premises grid.
* Where a new grid is to be implemented entirely within Azure, while also utilising on-demand compute resources in Azure.

## Architecture diagram

The solution diagram below is an example of this solution:

![Architecture overview of the components involved in a Hybrid HPC solution using CycleCloud][architecture]

## Architecture

This solution covers the workflow when using a head node running on Azure while an optional head node is also deployed on premises, the data flows through the solution as follows:

1. User submits job to the CycleCloud server
2. CycleCloud server decides where to place the job depending on submission criteria
  - 2a. CycleCloud submits the job to an Azure-based head node
  - 2b. CycleCloud submits the job to an on-premises head node
3. The job is queued for execution
  - 3a. CycleCloud detects a job in the queue and scales the number of execute nodes accordingly
  - 3b. The on-premises head node submits the job when space is available on the cluster
4. CycleCloud monitors the head nodes and job queues to gather usage metrics and determine when the job is completed

## CycleCloud: Deploying a sample solution manually
* Please use the following link to deploy CycleCloud which can then be used to orchestrate your grid, you will be manually altering an ARM template to deploy CycleCloud:
  - CycleCloud Install: [Install][cycle-recipes]

* The installation consists of the following:
  - Installing the Azure CLI
  - Creating a service principal in your Azure Active Directory
  - Optiona cloning of the CycleCloud GitHub repo
  - Creating an Azure resource group and VNET
  - Deploying CycleCloud using a modified ARM template, this will deploy a jumpbox and the CycleCloud server

## CycleCloud: Deploying a sample solution using an ARM template

First a VNET called CycleVNET is required before the VMs can be deployed:

Deploy a VNET called CycleVnet
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmikewarr%2Farchitecture-center%2Fsolutions-release%2Fdocs%2Fsample-solutions%2Ffasttrack%2Fhpc%2Fdeploycyclevnet.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

The following will then deploy a Jump Box and a Cycle Cloud server to Azure, by default using Standard D2 VM's. Before clicking on the link, some pre-requisites will need to be completed:

  [CycleCloud Prerequisites][cycle-prereqs]

  [Create an SSH keypair][cycle-prereqs-keypair]

Deploy CycleVMs
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmikewarr%2Farchitecture-center%2Fsolutions-release%2Fdocs%2Fsample-solutions%2Ffasttrack%2Fhpc%2Fdeploycyclevms.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


Configuration of CycleCloud is required once the jump box and CycleCloud server have been deployed. To configure CycleCloud please follow the steps detailed [here][cycle-configure]. 

### Components

* [Resource Groups][resource-groups] is a logical container for Azure resources.
* [Virtual Networks][vnet] are used to for both the Head Node and Compute resources
* [Storage][storage] accounts are used for the synchronisation and data retention
* [Virtual Machine Scale Sets][vmss] are utilised by CycleCloud for compute resources

## HPC Machine Sizes
Compute resources in the VM Scale Sets will depend on a number of factors:
  - Is the Application being run memory bound?
  - Does the Application need to use GPU's? 
  - Are the job types embarassingly parallel or require Infiniband connectivity for tightly coupled jobs?
  - Require fast I/O to Storage on the Compute Nodes

Azure has a wide range of VM sizes that can address each and every one of the above application requirements, some are specific to HPC, but even the smallest sizes can be utilised to provide an effective grid implementation:

  - [HPC VM sizes][compute-hpc]* VM's specifically available for high end computational needs, with 8 and 16 core vCPU sizes available, the Azure H-Series feature DDR4 memory, SSD temporary storage and Haswell E5 Intel technology.
  - [GPU VM sizes][compute-gpu]* GPU optimized VM sizes are specialized virtual machines available with single or multiple NVIDIA GPUs. These sizes are designed for compute-intensive, graphics-intensive, and visualization workloads.
    - NC, NCv2, NCv3, and ND sizes are optimized for compute-intensive and network-intensive applications and algorithms, including CUDA- and OpenCL-based applications and simulations, AI, and Deep Learning. 
NV sizes are optimized and designed for remote visualization, streaming, gaming, encoding, and VDI scenarios utilizing frameworks such as OpenGL and DirectX.
  - [Memory optmised VM sizes][compute-memory] Memory optimized VM sizes offer a high memory-to-CPU ratio that are great for relational database servers, medium to large caches, and in-memory analytics.
  - [Storage optimised VM sizes][compute-storage] Storage optimized VM sizes offer high disk throughput and IO, and are ideal for Big Data, SQL, and NoSQL databases. This article provides information about the number of vCPUs, data disks and NICs as well as storage throughput and network bandwidth for each size in this grouping
  - [General purposes VM sizes][compute-general] General purpose VM sizes provide balanced CPU-to-memory ratio. Ideal for testing and development, small to medium databases, and low to medium traffic web servers.

\* For MPI applications, dedicated RDMA backend network is enabled by FDR InfiniBand network, which delivers ultra-low-latency and high bandwidth

### Alternatives

If you are looking to transform current applications or develop anew as a Cloud Native app, then [Azure Batch][batch] might be more appropriate. This is especially true if a SaaS (Software as a Service) offering to your own customers is the end goal. 

The design principles for Azure Batch can be found [here][batch-arch]

For a complete overview of all the HPC solutions that are available to you in Azure, please see the article [HPC, Batch, and Big Compute solutions using Azure VMs][hpc-alt-solutions].

### Availability

### Scalability

* CycleCloud can scale up or down on demand depending on the criteria you supply.

### Security

For a deeper discussion on [security][] please see the relevant article in the architecure center.

### Resiliency

For a deeper discussion on [resiliency][] please see the relevant article in the architecure center.

## Pricing

Explore the cost of running this solution, all of the services are pre-configured in the cost calculator.  To see how the pricing would change for your particular use case change the appropriate variables to match your expected needs.

The cost of deploying CycleCloud will depend on the VM sizes that are used for the compute and how long these are allocated and running. Storage and data egress should also be taken into account as these will apply additional costs. The following are examples of costs that could be incurred over a one month period if the resources are utilised on a 24x7 basis:


- High Performance CPU VMs: [Cost Estimate][hpc-est-high]

  100 x H16mr (16 cores, 225GB RAM, Premium Storage 512GB, RDMA networking), 2 TB Blob Storage, 1 TB egress

- Mid Performance CPU VMs: [Cost Estimate][hpc-est-med]

  100 x F8 (8 Cores, 16GB RAM, Premium Storage 128GB), 2 TB Blob Storage, 1 TB egress

- Low Performance CPU VMs: [Cost Estimate][hpc-est-low]
  
  100 x A4v2 (4 cores, 8GB RAM, Premium Storage 32GB), 2 TB Blob Storage, 1 TB egress


## Related Resources

Other resources that are relevant that aren't linked from else where in the doc.

<!-- links -->
[small-pricing]: https://azure.com/e/
[medium-pricing]: https://azure.com/e/
[large-pricing]: https://azure.com/e/
[architecture]: ./media/hybrid-hpc-ref-arch.png
[resource-groups]: https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview
[resiliency]: https://docs.microsoft.com/en-us/azure/architecture/resiliency/
[scalability]: https://docs.microsoft.com/en-us/azure/architecture/checklist/scalability
[vmss]: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview
[vnet]: https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview
[storage]: https://azure.microsoft.com/en-us/services/storage/
[batch]: https://azure.microsoft.com/en-us/services/batch/
[batch-arch]: https://azure.microsoft.com/en-gb/solutions/architecture/big-compute-with-azure-batch/
[compute-hpc]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-hpc
[compute-gpu]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-gpu
[compute-compute]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-compute
[compute-memory]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-memory
[compute-general]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-general
[compute-storage]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-storage
[compute-acu]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/acu
[compute=benchmark]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/compute-benchmark-scores
[cycle-recipes]: https://github.com/azurebigcompute/BigComputeLabs/tree/master/CycleCloud
[cycle-configure]: https://github.com/azurebigcompute/BigComputeLabs/tree/master/CycleCloud#4-configure-cyclecloud-server
[cycle-prereqs]: https://github.com/azurebigcompute/BigComputeLabs/tree/master/CycleCloud#2-prerequisites
[cycle-prereqs-keypair]: https://git-scm.com/book/en/v2/Git-on-the-Server-Generating-Your-SSH-Public-Key
[hpc-est-high]: https://azure.com/e/9ac25baf44ef49c3a6b156935ee9544c
[hpc-est-med]: https://azure.com/e/0286f1d6f6784310af4dcda5aec8c893
[hpc-est-low]: https://azure.com/e/e39afab4e71949f9bbabed99b428ba4a
[hpc-alt-solutions]: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/high-performance-computing?toc=%2fazure%2fbatch%2ftoc.json




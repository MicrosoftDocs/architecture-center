---
title: Native HPC using Azure Batch
description: Running native HPC workloads in Azure using the Azure Batch service
author: Mike Warrington and Ben Hummerstone
ms.date: <publish or update date>
---
# Native HPC in Azure using Azure Batch

Batch processing began with mainframe computers and punch cards. Today, it still plays a central role in business, engineering, science, and other areas that require running lots of automated tasks—processing bills and payroll, calculating portfolio risk, designing new products, rendering animated films, testing software, searching for energy, predicting the weather, and finding new cures for disease. Previously, few people had access to the computing power for these scenarios. With Azure Batch, that power is available to you when you need it, without any capital investment.

Batch gives you a consistent management experience and job scheduling, whether you select Windows Server or Linux compute nodes, but it lets you take advantage of the unique features of each environment. With Windows, use your existing Windows code, including Microsoft .NET, to run large-scale compute jobs in Azure. With Linux, choose from popular distributions including CentOS, Ubuntu, and SUSE Linux Enterprise Server to run your compute jobs, or use Docker containers to lift and shift your applications. Batch gives you SDKs and supports a range of development tools including Python and Java.

## Potential use cases

You should consider this solution for the following use cases:

* You need on-demand HPC compute without the overhead of managing the scheduling of jobs or scaling of resources
* If you're intending to develop a SaaS (Software as a Service) solution for your own customers
* You want to use containers as part of your HPC solution in a managed environment

## Architecture diagram

The solution diagram below is an example of this solution:

![Architecture overview of the components involved in a Cloud Native HPC solution using Azure Batch][architecture]

## Architecture

This solution covers the workflow when using Azure Batch, the data flows through the solution as follows:

1. Upload input files and the applications to process those files to your Azure Storage account
2. Create a Batch pool of compute nodes in your Batch account, a job to run the workload on the pool, and tasks in the job.
3. Download input files and the applications to Batch
4. Monitor task execution
5. Upload task output
6. Download output files

## Azure Batch: Creating an Azure Batch account and pools manually
This sample solution is will provide help in learning how Azure Batch works while showcasing Azure Batch Labs as an example SaaS solution that can be developed for your own customers:

[Azure Batch Masterclass][batch-labs-masterclass]

## Azure Batch: Deploying a sample solution using an ARM template

The following deployment will deploy:
  - a new Azure Batch account
  - a storage account
  - a node pool associated with the batch account
  - the node pool will be configured to use A2 v2 VMs with Canonical Ubuntu images
  - the node pool will contain 0 VMs initially and will require scaling manually to add VMs

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmikewarr%2Farchitecture-center%2Fdocs%2Fsample-solutions%2Fhpc%2Fbatchcreatewithpools.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

### Components

Azure Batch builds upon the following Azure technologies:

* [Resource Groups][resource-groups] is a logical container for Azure resources.
* [Virtual Networks][vnet] are used to for both the Head Node and Compute resources
* [Storage][storage] accounts are used for the synchronisation and data retention
* [Virtual Machine Scale Sets][vmss] are utilised by CycleCloud for compute resources

## Machine Sizes available for Azure Batch
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

If you require more control over an HPC environment in Azure or need a Hybrid implementation, then CycleCloud computing can help orchestrate an IaaS grid in the cloud. Using the same underlying Azure technologies as Azure Batch, it makes building and maintaining an IaaS grid an efficient process. To find out more and learn about the design principles, please use the following link:

<Link for IaaS on Azure>

For a complete overview of all the HPC solutions that are available to you in Azure, please see the article [HPC, Batch, and Big Compute solutions using Azure VMs][hpc-alt-solutions]

### Availability
Monitoring of the Azure Batch components is available through a range of services, tools and APIs. This is discussed further in the [Monitor Batch solutions][batch-monitor] article.


### Scalability

Pools within an Azure Batch account can either scale through manual intervention or, by using an formula based on Azure Batch metrics, be scaled automatically. For more information on this, please see the article
[Create an automatic scaling formula for scaling nodes in a Batch pool][batch-scaling].

### Security

For a deeper discussion on [security][] please see the relevant article in the architecure center.

### Resiliency

While there is currently no failover capability in Azure Batch, we recommend using the following steps to ensure availbility in case of an unplanned outage:

* Create a Azure Batch account in an alternate Azure location with an alternate Storage Account
* Create the same node pools with the same name, with 0 nodes allocated
* Ensure Applications are created and updated to the alternate Storage Account
* Upload input files and submit jobs to the alternate Azure Batch account

## Pricing

Explore the cost of running this solution, all of the services are pre-configured in the cost calculator.  To see how the pricing would change for your particular use case change the appropriate variables to match your expected needs.

The cost of using Azure Batch will depend on the VM sizes that are used for the pools and how long these are allocated and running, there is no cost associated with an Azure Batch account creation. Storage and data egress should also be taken into account as these will apply additional costs. The following are examples of costs that could be incurred over a one month period if the resources are utilised on a 24x7 basis:


- High Performance CPU VMs: [Cost Estimate][hpc-est-high]

  100 x H16mr (16 cores, 225GB RAM, Premium Storage 512GB, RDMA networking), 2 TB Blob Storage, 1 TB egress

- Mid Performance CPU VMs: [Cost Estimate][hpc-est-med]

  100 x F8 (8 Cores, 16GB RAM, Premium Storage 128GB), 2 TB Blob Storage, 1 TB egress

- Low Performance CPU VMs: [Cost Estimate][hpc-est-low]
  
  100 x A4v2 (4 cores, 8GB RAM, Premium Storage 32GB), 2 TB Blob Storage, 1 TB egress

### Low Priority VM Pricing

Azure Batch also supports the use of Low Priority VMs* in the node pools, which can potentially provide a substantial cost saving. For a price comparison between standard VMs and Low Priority VMs, and to find out more about Low Priority VMs, please see [Batch Pricing][batch-pricing].

\* Please note that only certain applications and workloads will be suitable to run on Low Priority VMs.

## Related Resources

[Azure Batch Overview][batch-overview]

[Azure Batch Documentation][batch-doc]

[Using containers on Azure Batch][batch-containers]

Other resources that are relevant that aren't linked from else where in the doc.

<!-- links -->
[small-pricing]: https://azure.com/e/
[medium-pricing]: https://azure.com/e/
[large-pricing]: https://azure.com/e/
[architecture]: ./media/native-hpc-ref-arch.png
[resource-groups]: https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview
[security]: https://docs.microsoft.com/en-gb/azure/architecture/patterns/category/security
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
[hpc-est-high]: https://azure.com/e/9ac25baf44ef49c3a6b156935ee9544c
[hpc-est-med]: https://azure.com/e/0286f1d6f6784310af4dcda5aec8c893
[hpc-est-low]: https://azure.com/e/e39afab4e71949f9bbabed99b428ba4a
[batch-labs-masterclass]: https://github.com/azurebigcompute/BigComputeLabs/tree/master/Azure%20Batch%20Masterclass%20Labs
[batch-scaling]: https://docs.microsoft.com/en-us/azure/batch/batch-automatic-scaling
[hpc-alt-solutions]: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/high-performance-computing?toc=%2fazure%2fbatch%2ftoc.json
[batch-monitor]: https://docs.microsoft.com/en-us/azure/batch/monitoring-overview
[batch-pricing]: https://azure.microsoft.com/en-gb/pricing/details/batch/
[batch-doc]: https://docs.microsoft.com/en-us/azure/batch/
[batch-overview]: https://azure.microsoft.com/en-us/services/batch/
[batch-containers]: https://github.com/Azure/batch-shipyard



---
title: 3D video rendering on Azure
description: Running native HPC workloads in Azure using the Azure Batch service
author: adamboeglin
ms.date: 07/13/2018
---
# 3D video rendering on Azure

3D rendering is a time consuming process that requires a significant amount of CPU time co complete.  On a single machine, the process of generating a video file from static assets can take hours or even days depending on the length and complexity of the video you are producing.  Many companies will purchase either expensive high end desktop computers to perform these tasks, or invest in large render farms that they can submit jobs to.  However, by taking advantage of Azure Batch, that power is available to you when you need it and shuts itself down when you don't, all without any capital investment.

Batch gives you a consistent management experience and job scheduling, whether you select Windows Server or Linux compute nodes. With Batch, you can use your existing Windows or Linux applications, including AutoDesk Maya and Blender, to run large-scale render jobs in Azure.

## Related use cases

Consider this scenario for these similar use cases:

* 3D Modeling
* Visual FX (VFX) Rendering
* Video transcoding
* Image processing, color correction, & resizing

## Architecture

![Architecture overview of the components involved in a Cloud Native HPC solution using Azure Batch][architecture]

This sample scenario covers the workflow when using Azure Batch, the data flows as follows:

1. Upload input files and the applications to process those files to your Azure Storage account
2. Create a Batch pool of compute nodes in your Batch account, a job to run the workload on the pool, and tasks in the job.
3. Download input files and the applications to Batch
4. Monitor task execution
5. Upload task output
6. Download output files

To simplify this process, you could also use the [Batch Plugins for Maya & 3ds Max][batch-plugins]

### Components

Azure Batch builds upon the following Azure technologies:

* [Resource Groups][resource-groups] is a logical container for Azure resources.
* [Virtual Networks][vnet] are used to for both the Head Node and Compute resources
* [Storage][storage] accounts are used for the synchronisation and data retention
* [Virtual Machine Scale Sets][vmss] are utilised by CycleCloud for compute resources

## Considerations

### Machine Sizes available for Azure Batch
While most rendering customers whill choose resources with high CPU power, other workloads using VM Scale Sets may choose VM's differently and will depend on a number of factors:
  - Is the Application being run memory bound?
  - Does the Application need to use GPU's? 
  - Are the job types embarassingly parallel or require Infiniband connectivity for tightly coupled jobs?
  - Require fast I/O to Storage on the Compute Nodes

Azure has a wide range of VM sizes that can address each and every one of the above application requirements, some are specific to HPC, but even the smallest sizes can be utilised to provide an effective grid implementation:

  - [HPC VM sizes][compute-hpc] Due to the CPU bound nature of rendering, Microsoft typically suggests the Azure H-Series VM's.  These are built specifically available for high end computational needs, have 8 and 16 core vCPU sizes available, and feature DDR4 memory, SSD temporary storage and Haswell E5 Intel technology.
  - [GPU VM sizes][compute-gpu] GPU optimized VM sizes are specialized virtual machines available with single or multiple NVIDIA GPUs. These sizes are designed for compute-intensive, graphics-intensive, and visualization workloads.
    - NC, NCv2, NCv3, and ND sizes are optimized for compute-intensive and network-intensive applications and algorithms, including CUDA and OpenCL-based applications and simulations, AI, and Deep Learning. NV sizes are optimized and designed for remote visualization, streaming, gaming, encoding, and VDI scenarios utilizing frameworks such as OpenGL and DirectX.
  - [Memory optmised VM sizes][compute-memory] When more memory is required, the memory optimized VM sizes offer a higher memory-to-CPU ratio.
  - [General purposes VM sizes][compute-general] General purpose VM sizes are also available and provide balanced CPU-to-memory ratio.

### Alternatives

If you require more control over your rendering environment in Azure or need a hybrid implementation, then CycleCloud computing can help orchestrate an IaaS grid in the cloud. Using the same underlying Azure technologies as Azure Batch, it makes building and maintaining an IaaS grid an efficient process. To find out more and learn about the design principles, please use the following link:

For a complete overview of all the HPC solutions that are available to you in Azure, please see the article [HPC, Batch, and Big Compute solutions using Azure VMs][hpc-alt-solutions]

### Availability

Monitoring of the Azure Batch components is available through a range of services, tools and APIs. This is discussed further in the [Monitor Batch solutions][batch-monitor] article.

### Scalability

Pools within an Azure Batch account can either scale through manual intervention or, by using an formula based on Azure Batch metrics, be scaled automatically. For more information on this, please see the article
[Create an automatic scaling formula for scaling nodes in a Batch pool][batch-scaling].

### Security

For general guidance on designing secure solutions, see the [Azure Security Documentation][security].

### Resiliency

While there is currently no failover capability in Azure Batch, we recommend using the following steps to ensure availbility in case of an unplanned outage:

* Create a Azure Batch account in an alternate Azure location with an alternate Storage Account
* Create the same node pools with the same name, with 0 nodes allocated
* Ensure Applications are created and updated to the alternate Storage Account
* Upload input files and submit jobs to the alternate Azure Batch account

## Deploy this scenario

### Creating an Azure Batch account and pools manually

This sample scenario will provide help in learning how Azure Batch works while showcasing Azure Batch Labs as an example SaaS solution that can be developed for your own customers:

[Azure Batch Masterclass][batch-labs-masterclass]

### Deploying the sample scenario using an Azure Resource Manager (ARM) template

The template will deploy:
  - A new Azure Batch account
  - A storage account
  - A node pool associated with the batch account
  - The node pool will be configured to use A2 v2 VMs with Canonical Ubuntu images
  - The node pool will contain 0 VMs initially and will require scaling manually to add VMs

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Fsolution-architectures%2Fmaster%2Fhpc%2Fbatchcreatewithpools.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

[Learn more about ARM templates][azure-arm-templates]

## Pricing

The cost of using Azure Batch will depend on the VM sizes that are used for the pools and how long these are allocated and running, there is no cost associated with an Azure Batch account creation. Storage and data egress should also be taken into account as these will apply additional costs.

The following are examples of costs that could be incurred for a job that completes in 8 hours using a different number of servers:


- 100 High Performance CPU VMs: [Cost Estimate][hpc-est-high]

  100 x H16m (16 cores, 225GB RAM, Premium Storage 512GB), 2 TB Blob Storage, 1 TB egress

- 50 High Performance CPU VMs: [Cost Estimate][hpc-est-med]

  50 x H16m (16 cores, 225GB RAM, Premium Storage 512GB), 2 TB Blob Storage, 1 TB egress

- 10 High Performance CPU VMs: [Cost Estimate][hpc-est-low]
  
  10 x H16m (16 cores, 225GB RAM, Premium Storage 512GB), 2 TB Blob Storage, 1 TB egress

### Low Priority VM Pricing

Azure Batch also supports the use of Low Priority VMs* in the node pools, which can potentially provide a substantial cost saving. For a price comparison between standard VMs and Low Priority VMs, and to find out more about Low Priority VMs, please see [Batch Pricing][batch-pricing].

\* Please note that only certain applications and workloads will be suitable to run on Low Priority VMs.

## Related Resources

[Azure Batch Overview][batch-overview]

[Azure Batch Documentation][batch-doc]

[Using containers on Azure Batch][batch-containers]

<!-- links -->
[architecture]: ./media/native-hpc-ref-arch.png
[resource-groups]: /azure/azure-resource-manager/resource-group-overview
[security]: /azure/security/
[resiliency]: /azure/architecture/resiliency/
[scalability]: /azure/architecture/checklist/scalability
[vmss]: /azure/virtual-machine-scale-sets/overview
[vnet]: /azure/virtual-network/virtual-networks-overview
[storage]: https://azure.microsoft.com/services/storage/
[batch]: https://azure.microsoft.com/services/batch/
[batch-arch]: https://azure.microsoft.com/solutions/architecture/big-compute-with-azure-batch/
[compute-hpc]: /azure/virtual-machines/windows/sizes-hpc
[compute-gpu]: /azure/virtual-machines/windows/sizes-gpu
[compute-compute]: /azure/virtual-machines/windows/sizes-compute
[compute-memory]: /azure/virtual-machines/windows/sizes-memory
[compute-general]: /azure/virtual-machines/windows/sizes-general
[compute-storage]: /azure/virtual-machines/windows/sizes-storage
[compute-acu]: /azure/virtual-machines/windows/acu
[compute=benchmark]: /azure/virtual-machines/windows/compute-benchmark-scores
[hpc-est-high]: https://azure.com/e/9ac25baf44ef49c3a6b156935ee9544c
[hpc-est-med]: https://azure.com/e/0286f1d6f6784310af4dcda5aec8c893
[hpc-est-low]: https://azure.com/e/e39afab4e71949f9bbabed99b428ba4a
[batch-labs-masterclass]: https://github.com/azurebigcompute/BigComputeLabs/tree/master/Azure%20Batch%20Masterclass%20Labs
[batch-scaling]: /azure/batch/batch-automatic-scaling
[hpc-alt-solutions]: /azure/virtual-machines/linux/high-performance-computing?toc=%2fazure%2fbatch%2ftoc.json
[batch-monitor]: /azure/batch/monitoring-overview
[batch-pricing]: https://azure.microsoft.com/en-gb/pricing/details/batch/
[batch-doc]: /azure/batch/
[batch-overview]: https://azure.microsoft.com/services/batch/
[batch-containers]: https://github.com/Azure/batch-shipyard
[azure-arm-templates]: /azure/azure-resource-manager/resource-group-overview#template-deployment
[batch-plugins]: /azure/batch/batch-rendering-service#options-for-submitting-a-render-job
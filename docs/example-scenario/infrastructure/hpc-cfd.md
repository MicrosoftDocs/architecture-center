---
title: Running Computational Fluid Dynamics on Azure
description: Sample solution describing how to run CFD on Azure
author: mikewarr
ms.date: <publish or update date - mm/dd/yyyy>
---
# Running Computational Fluid Dynamics on Azure

CFD simulations not only take time to process, while requiring a significant amount of compute time, but also have a need for specialised hardware. As business needs increase, leading to stretched simulation times and overall grid use, spare capacity becomes an issue. Supplementing with additional physical hardware is expensive and a considerable long term investment, which is a difficult challenge to achieve given the peaks and troughs a business goes through. By taking advantage of Azure, a lot of these challenges can be overcome, all without any capital expenditure.

Azure provides the specialised hardware you need to accomplish your CFD goals with compute available with both GPU and CPU virtual machines. RDMA (Remote Direct Memory Access) enabled VM sizes facilitate the interconnect needed for MPI (Message Passing Interface), using FDR InfiniBand for low latency networking. Couple this with Avere vFXT, which provides an enterprise-scale clustered file system, to ensure maximum througput for read operations in Azure. Run this either in a hybrid approach with an on-premises grid where a decrease in local capacity can be scaled out to Azure or a completely self contained approach where everything you need is running on Azure, further reducing operational costs. 

To simplify the creation, management, operations and optimization of HPC clusters, Azure CycleCloud can be used to provision clusters to orcestrate data in both hybrid and cloud scenarios. Monitoring the pending jobs it will auto scale for on-demand compute, where you only pay for what you use, with the workload scheduler of your choice. 

## Potential use cases

Consider this scenario for these industries where CFD applications could be used:

* Aeronautics
* Automotive
* Building HVAC
* Oil & Gas
* Life Sciences

## Architecture

![alt text][cyclearch]

The diagram provides a high level overview of a typical hybrid design providing job monitoring of the on-demand nodes in Azure:

1. Connect to the Azure CycleCloud server to configure the cluster
2. Configure and create the cluster head node, using RDMA enabled machines for MPI 
3. Add and configure the on-premise head node
4. If there is insufficient resources, Azure CycleCloud will scale up (or down) compute resources in Azure. A predetermined limit can be defined to prevent over allocation.
5. Tasks allocated to the execute nodes
6. Data cached in Azure from on-premises NFS server
7. Data read in from the Avere vFXT for Azure cache
8. Job and task information relayed to the Azure CycleCloud server


### Components

* [Azure CycleCloud][cyclecloud] a tool for creating, managing, operating, and optimizing HPC & Big Compute clusters in Azure
* [Avere vFXT on Azure][avere] used to provide an enterprise-scale clustered file system built for the cloud
* [Virtual Machine Scale Sets (VMSS)][vmss] a group of identical load balanced VMs, capable of being scaled up or down, utilised by Azure CycleCloud
* [Virtual Machines][vms] use Virtual Machines to create a static set of compute instances
* [Storage][storage] accounts are used for synchronization and data retention
* [Virtual Network][vnet] Azure Virtual Network enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks 


### Alternatives

If you are looking to create a grid entirely in Azure, this can also be acheived with Azure CycleCloud, where the Azure CycleCloud server is resident within your Azure subscription.

For a modern application approach where management of a workload scheduler is not desirable, and running CFD applications across specilaised hardware is needed, [Azure Batch][batch] can help. Azure Batch can run large-scale parallel and high-performance computing (HPC) applications efficiently in the cloud. Where you define the Azure compute resources to execute your applications in parallel or at scale without manually configuring or managing infrastructure. Schedule compute-intensive tasks and dynamically add or remove compute resources based on your requirements

### Scalability, and Security


Scaling the execute nodes on Azure CycleCloud can be accomplished either manually or by using autoscaling, see [CycleCloud Autoscaling][cycle-scale]

For general guidance on designing secure solutions, see the [Azure Security Documentation][security].

## Deploy this scenario

Before deploying in Azure, some pre-requisites are required, please run through these steps before deploying the ARM template:
1. [Service Princiapl][cycle-svcprin] to retrieve the appId, displayname, password and tenant
2. [SSH Keypair][cycle-ssh] to logon securely to the CycleCloud server

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FCycleCloudCommunity%2Fcyclecloud_arm%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

3. [Log into the CycleCloud server][cycle-login] to configure and create a new cluster
4. [Create a simple cluster][cycle-create] 

The Avere Cache is an optional solution which can drastically speed up read throughput for the application job data. Avere vFXT for Azure solves the problem of running these enterprise HPC applications in the cloud while leveraging data stored on-premises or in Azure Blob storage. The Avere vFXT facilitates Edge computing as a virtual high-performance file caching appliance that runs in Azure Compute. With Avere, these critical workloads can access thousands of cores on-demand, increasing business agility by processing smarter and faster without adding extra cost. For organizations that are planning on a hybrid infrastructure situation with on-premises storage and cloud computing, HPC applications can “burst” into Azure using data stored in NAS devices and spin up as many virtual CPUs on an as needed basis. The data set itself never completely moves into the cloud. The requested bytes are temporarily cached using an Avere cluster while processing.

To setup and configure an Avere vFXT installation, please use the following instructions:

[Avere Setup and Configuration][avere]


## Pricing

The cost of running an HPC implementation using CycleCloud server will differ depending on a number of factors. For example, CycleCloud is charged by the amount of compute time that is used, with the Master and CycleCloud server typically being constantly allocated and running. For the Execute nodes, this will entirely depend on how long these are up and running for, but also which size is used. In addition to this, the normal Azure charges also apply for Storage and Networking.  

This scenario is intended to show how CFD applications can be run in Azure, and as such the machine of choice will require RDMA functionality which is only available on specific VM sizes. The following are examples of costs that could be incurred for a scale set that is allocated continuously for 8 hours a day for a month, with an egress of 1TB of data, it also includes the pricing for the Azure CycleCloud server and the Avere vFXT for Azure install:

* Region: North Europe
* Azure CycleCloud Server: 1 x Standard D3 (4 x CPUs, 14GB Memory, Standard HDD 32GB)
* Azure CycleCloud Master Server: 1 x Standard D12 v (4 x CPUs, 28GB Memory, Standard HDD 32GB)
* Azure CycleCloud Node Array: 10 x Standard H16r (16 x CPUs, 112GB Memory)
* Avere vFXT on Azure Cluster: 3 x D16s v3 ( 200GB OS, Premium SSD 1TB data disk)
* Data Egress: 1TB

Please use the following link to check the [Price Estimate][pricing] for the above hardware


## Next Steps

Once you've deployed the sample, please find more information about Azure CycleCloud here: [Azure CycleCloud Docs][cyclecloud]

## Related Resources

* [RDMA Capable Machine Instances][rdma]
* [Customising an RDMA Instance VM][rdma-custom]



<!-- links -->
[calculator]: https://azure.com/e/
[availability]: /azure/architecture/checklist/availability
[resource-groups]: /azure/azure-resource-manager/resource-group-overview
[resiliency]: /azure/architecture/resiliency/
[security]: /azure/security/
[scalability]: /azure/architecture/checklist/scalability
[cyclearch]: media/Hybrid-HPC-Ref-Arch.png
[vmss]: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview
[cyclecloud]: https://docs.microsoft.com/en-us/azure/cyclecloud/
[rdma]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-hpc#rdma-capable-instances
[gpu]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-gpu
[hpcsizes]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-hpc
[vms]: https://docs.microsoft.com/en-us/azure/virtual-machines/
[storage]: https://azure.microsoft.com/services/storage/
[low-pri]: https://docs.microsoft.com/en-ca/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-use-low-priority
[batch]: https://docs.microsoft.com/en-us/azure/batch/
[avere]: https://github.com/Azure/Avere/blob/master/README.md
[vnet]: https://docs.microsoft.com/en-us/azure/virtual-network/
[cycle-prereq]: https://docs.microsoft.com/en-us/azure/cyclecloud/quickstart-install-cyclecloud#prerequisites
[cycle-svcprin]: https://docs.microsoft.com/en-us/azure/cyclecloud/quickstart-install-cyclecloud#service-principal
[cycle-ssh]: https://docs.microsoft.com/en-us/azure/cyclecloud/quickstart-install-cyclecloud#ssh-keypair
[cycle-login]: https://docs.microsoft.com/en-us/azure/cyclecloud/quickstart-install-cyclecloud#log-into-the-cyclecloud-application-server
[cycle-create]: https://docs.microsoft.com/en-us/azure/cyclecloud/quickstart-create-and-run-cluster
[rdma]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-hpc#rdma-capable-instances
[rdma-custom]: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/classic/rdma-cluster#customize-the-vm
[pricing]: https://azure.com/e/53030a04a2ab47a289156e2377a4247a
[cycle-scale]: https://docs.microsoft.com/en-us/azure/cyclecloud/autoscale

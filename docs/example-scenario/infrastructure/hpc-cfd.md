---
title: Running CFD simulations
titleSuffix: Azure Example Scenarios
description: Execute computational fluid dynamics (CFD) simulations on Azure.
author: mikewarr
ms.date: 09/20/2018
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
  - fasttrack
  - hpc
social_image_url: /azure/architecture/example-scenario/infrastructure/media/architecture-hpc-cfd.png
---

# Running computational fluid dynamics (CFD) simulations on Azure

Computational Fluid Dynamics (CFD) simulations require significant compute time along with specialized hardware. As cluster usage increases, simulation times and overall grid use grow, leading to issues with spare capacity and long queue times. Adding physical hardware can be expensive, and may not align to the usage peaks and valleys that a business goes through. By taking advantage of Azure, many of these challenges can be overcome with no capital expenditure.

Azure provides the hardware you need to run your CFD jobs on both GPU and CPU virtual machines. RDMA (Remote Direct Memory Access) enabled VM sizes have FDR InfiniBand-based networking which allows for low latency MPI (Message Passing Interface) communication. Combined with the Avere vFXT, which provides an enterprise-scale clustered file system, customers can ensure maximum throughput for read operations in Azure.

To simplify the creation, management, and optimization of HPC clusters, Azure CycleCloud can be used to provision clusters and orchestrate data in both hybrid and cloud scenarios. By monitoring the pending jobs, CycleCloud will automatically launch on-demand compute, where you only pay for what you use, connected to the workload scheduler of your choice.

## Relevant use cases

Other relevant industries for CFD applications include:

- Aeronautics
- Automotive
- Building HVAC
- Oil and gas
- Life sciences

## Architecture

![Architecture diagram][architecture]

This diagram shows a high-level overview of a typical hybrid design providing job monitoring of the on-demand nodes in Azure:

1. Connect to the Azure CycleCloud server to configure the cluster.
2. Configure and create the cluster head node, using RDMA enabled machines for MPI.
3. Add and configure the on-premises head node.
4. If there are insufficient resources, Azure CycleCloud will scale up (or down) compute resources in Azure. A predetermined limit can be defined to prevent over allocation.
5. Tasks allocated to the execute nodes.
6. Data cached in Azure from on-premises NFS server.
7. Data read in from the Avere vFXT for Azure cache.
8. Job and task information relayed to the Azure CycleCloud server.

### Components

- [Azure CycleCloud][cyclecloud] a tool for creating, managing, operating, and optimizing HPC and Big Compute clusters in Azure.
- [Avere vFXT on Azure][avere] is used to provide an enterprise-scale clustered file system built for the cloud.
- [Azure Virtual Machines (VMs)][vms] are used to create a static set of compute instances.
- [Virtual machine scale sets][vmss] provide a group of identical VMs capable of being scaled up or down by Azure CycleCloud.
- [Azure Storage accounts](/azure/storage/common/storage-introduction) are used for synchronization and data retention.
- [Virtual Networks](/azure/virtual-network/virtual-networks-overview) enable many types of Azure resources, such as Azure Virtual Machines (VMs), to securely communicate with each other, the internet, and on-premises networks.

### Alternatives

Customers can also use Azure CycleCloud to create a grid entirely in Azure. In this setup, the Azure CycleCloud server is run within your Azure subscription.

For a modern application approach where management of a workload scheduler is not needed, [Azure Batch][batch] can help. Azure Batch can run large-scale parallel and high-performance computing (HPC) applications efficiently in the cloud. Azure Batch allows you to define the Azure compute resources to execute your applications in parallel or at scale without manually configuring or managing infrastructure. Azure Batch schedules compute-intensive tasks and dynamically adds and removes compute resources based on your requirements.

### Scalability, and Security

Scaling the execute nodes on Azure CycleCloud can be accomplished either manually or using autoscaling. For more information, see [CycleCloud Autoscaling][cycle-scale].

For general guidance on designing secure solutions, see the [Azure security documentation][security].

## Deploy the scenario

### Prerequisites

Follow these steps before deploying the Resource Manager template:

1. Create a [service principal][cycle-svcprin] for retrieving the appId, displayName, name, password, and tenant.

1. Generate an [SSH key pair][cycle-ssh] to sign in securely to the CycleCloud server.

1. Click the link below to deploy the solution.

    [![Deploy to Azure](https://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FCycleCloudCommunity%2Fcyclecloud_arm%2Fmaster%2Fazuredeploy.json)

1. [Log into the CycleCloud server][cycle-login] to configure and create a new cluster.

1. [Create a cluster][cycle-create].

The Avere Cache is an optional solution that can drastically increase read throughput for the application job data. Avere vFXT for Azure solves the problem of running these enterprise HPC applications in the cloud while leveraging data stored on-premises or in Azure Blob storage.

For organizations that are planning for a hybrid infrastructure with both on-premises storage and cloud computing, HPC applications can "burst" into Azure using data stored in NAS devices and spin up virtual CPUs as needed. The data set is never moved completely into the cloud. The requested bytes are temporarily cached using an Avere cluster during processing.

To set up and configure an Avere vFXT installation, follow the [Avere Setup and Configuration guide][avere].

## Pricing

The cost of running an HPC implementation using CycleCloud server will vary depending on a number of factors. For example, CycleCloud is charged by the amount of compute time that is used, with the Master and CycleCloud server typically being constantly allocated and running. The cost of running the Execute nodes will depend on how long these are up and running as well as what size is used. The normal Azure charges for storage and networking also apply.

This scenario shows how CFD applications can be run in Azure, so the machines will require RDMA functionality, which is only available on specific VM sizes. The following are examples of costs that could be incurred for a scale set that is allocated continuously for eight hours per day for one month, with data egress of 1 TB. It also includes pricing for the Azure CycleCloud server and the Avere vFXT for Azure install:

- Region: North Europe
- Azure CycleCloud Server: 1 x Standard D3 (4 x CPUs, 14 GB Memory, Standard HDD 32 GB)
- Azure CycleCloud Master Server: 1 x Standard D12 v (4 x CPUs, 28 GB Memory, Standard HDD 32 GB)
- Azure CycleCloud Node Array: 10 x Standard H16r (16 x CPUs, 112 GB Memory)
- Avere vFXT on Azure Cluster: 3 x D16s v3 (200 GB OS, Premium SSD 1-TB data disk)
- Data Egress: 1 TB

Review this [price estimate][pricing] for the hardware listed above.

## Next Steps

Once you've deployed the sample, learn more about [Azure CycleCloud][cyclecloud].

## Related resources

- [RDMA Capable Machine Instances][rdma]
- [Customizing an RDMA Instance VM][rdma-custom]

<!-- links -->
[architecture]: ./media/architecture-hpc-cfd.png
[calculator]: https://azure.com/e/
[availability]: /azure/architecture/checklist/availability
[resource-groups]: /azure/azure-resource-manager/resource-group-overview
[resiliency]: /azure/architecture/resiliency/
[security]: /azure/security/
[scalability]: /azure/architecture/checklist/scalability
[vmss]: /azure/virtual-machine-scale-sets/overview
[cyclecloud]: /azure/cyclecloud/
[rdma]: /azure/virtual-machines/windows/sizes-hpc#rdma-capable-instances
[gpu]: /azure/virtual-machines/windows/sizes-gpu
[hpcsizes]: /azure/virtual-machines/windows/sizes-hpc
[vms]: /azure/virtual-machines/
[low-pri]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-use-low-priority
[batch]: /azure/batch/
[avere]: https://github.com/Azure/Avere/blob/master/README.md
[cycle-prereq]: /azure/cyclecloud/quickstart-install-cyclecloud#prerequisites
[cycle-svcprin]: /azure/cyclecloud/quickstart-install-cyclecloud#service-principal
[cycle-ssh]: /azure/cyclecloud/quickstart-install-cyclecloud#ssh-keypair
[cycle-login]: /azure/cyclecloud/quickstart-install-cyclecloud#log-into-the-cyclecloud-application-server
[cycle-create]: /azure/cyclecloud/quickstart-create-and-run-cluster
[rdma]: /azure/virtual-machines/windows/sizes-hpc#rdma-capable-instances
[rdma-custom]: /azure/virtual-machines/linux/sizes-hpc#rdma-capable-instances
[pricing]: https://azure.com/e/53030a04a2ab47a289156e2377a4247a
[cycle-scale]: /azure/cyclecloud/autoscale

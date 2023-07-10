This architecture demonstrates running computational fluid dynamics simulations using Azure. Learn to create, manage, and optimize clusters using Azure CycleCloud.

## Architecture

:::image type="content" alt-text="Diagram showing the architecture of a computational-fluid-dynamics scenario." source="./media/architecture-hpc-cfd.svg" lightbox="./media/architecture-hpc-cfd.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/architecture-hpc-cfd.vsdx) of this architecture.*

### Workflow

This diagram shows a high-level overview of a typical hybrid design providing job monitoring of the on-demand nodes in Azure:

1. Connect to the [Azure CycleCloud][cyclecloud] server to configure the cluster.
2. Configure and create the cluster head node, using RDMA enabled machines for MPI.
3. Add and configure the on-premises head node.
4. If there are insufficient resources, Azure CycleCloud scales the Azure compute resources up (or down). A predetermined limit can be defined to prevent over allocation.
5. Tasks are allocated to the execute nodes.
6. Data is cached in Azure from the on-premises NFS server.
7. Data is read in from the [Avere vFXT for Azure][avere] cache.
8. Job and task information is relayed to the Azure CycleCloud server.

### Components

- [Azure CycleCloud](https://azure.microsoft.com/features/azure-cyclecloud) a tool for creating, managing, operating, and optimizing HPC and Big Compute clusters in Azure.
- [Avere vFXT on Azure][avere] is used to provide an enterprise-scale clustered file system built for the cloud.
- [Azure Virtual Machines (VMs)](https://azure.microsoft.com/free/virtual-machines) is used to create a static set of compute instances.
- [Virtual machine scale sets][vmss] provide a group of identical VMs capable of being scaled up or down by Azure CycleCloud.
- [Azure Storage accounts](https://azure.microsoft.com/free/storage) are used for synchronization and data retention.
- [Azure Virtual Networks](https://azure.microsoft.com/free/virtual-network) enable many types of Azure resources, such as VMs, to securely communicate with each other, the internet, and on-premises networks.

### Alternatives

Customers can also use Azure CycleCloud to create a grid entirely in Azure. In this setup, the Azure CycleCloud server is run within your Azure subscription.

For a modern application approach where management of a workload scheduler isn't needed, [Azure Batch][batch] can help. Azure Batch can run large-scale parallel and high-performance computing (HPC) applications efficiently in the cloud. Azure Batch allows you to define the Azure compute resources to execute your applications in parallel or at scale without manually configuring or managing infrastructure. Azure Batch schedules compute-intensive tasks and dynamically adds and removes compute resources based on your requirements.

## Scenario details

Computational fluid dynamics (CFD) simulations require significant compute time along with specialized hardware. As cluster usage increases, simulation times and overall grid use grow, leading to issues with spare capacity and long queue times. Adding physical hardware can be expensive, and might not align to the usage peaks and valleys that a business goes through. By taking advantage of Azure, many of these challenges can be overcome with no capital expenditure.

Azure provides the hardware you need to run your CFD jobs on both GPU and CPU virtual machines. RDMA (Remote Direct Memory Access) enabled VM sizes have FDR InfiniBand-based networking, which allows for low latency MPI (Message Passing Interface) communication. When you combine these solutions with the Avere vFXT, which provides an enterprise-scale clustered file system, customers can ensure maximum throughput for read operations in Azure.

To simplify the creation, management, and optimization of HPC clusters, Azure CycleCloud can be used to provision clusters and orchestrate data in both hybrid and cloud scenarios. When you monitor the pending jobs, CycleCloud will automatically launch on-demand compute, where you only pay for what you use, connected to the workload scheduler of your choice.

### Potential use cases

Other relevant industries for CFD applications include:

- Aeronautics and aerospace/aircraft
- Automotive
- Building HVAC (facilities)
- Oil and gas (energy)
- Life sciences and healthcare

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Scalability and security

Scaling the execute nodes on Azure CycleCloud can be accomplished either manually or using autoscaling. For more information, see [CycleCloud Autoscaling][cycle-scale].

For general guidance on designing secure solutions, see the [Azure security documentation][security].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The cost of running an HPC implementation using CycleCloud server will vary depending on a number of factors. For example, CycleCloud is charged by the amount of compute time that is used, with the Primary and CycleCloud server typically being constantly allocated and running. The cost of running the Execute nodes will depend on how long these are up and running as well as what size is used. The normal Azure charges for storage and networking also apply.

This scenario shows how CFD applications can be run in Azure, so the machines will require RDMA functionality, which is only available on specific VM sizes. The following are examples of costs that could be incurred for a scale set that is allocated continuously for eight hours per day for one month, with data egress of 1 TB. It also includes pricing for the Azure CycleCloud server and the Avere vFXT for Azure install:

- Region: North Europe
- Azure CycleCloud Server: 1 x Standard D3 (4 x CPUs, 14 GB Memory, Standard HDD 32 GB)
- Azure CycleCloud Primary Server: 1 x Standard D12 v (4 x CPUs, 28 GB Memory, Standard HDD 32 GB)
- Azure CycleCloud Node Array: 10 x Standard H16r (16 x CPUs, 112 GB Memory)
- Avere vFXT on Azure Cluster: 3 x D16s v3 (200 GB OS, Premium SSD 1-TB data disk)
- Data Egress: 1 TB

Review this [price estimate][pricing] for the hardware listed above.

## Deploy this scenario

### Prerequisites

Follow these steps before deploying the Resource Manager template:

1. Create a [service principal][cycle-svcprin] for retrieving the appId, displayName, name, password, and tenant.

1. Generate an [SSH key pair][cycle-ssh] to sign in securely to the CycleCloud server.

1. Click the link below to deploy the solution.

    [![Deploy to Azure](../../_images/deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FCycleCloudCommunity%2Fcyclecloud_arm%2Fmaster%2Fazuredeploy.json)

1. [Log into the CycleCloud server][cycle-login] to configure and create a new cluster.

1. [Create a cluster][cycle-create].

The Avere Cache is an optional solution that can drastically increase read throughput for the application job data. Avere vFXT for Azure solves the problem of running these enterprise HPC applications in the cloud while leveraging data stored on-premises or in Azure Blob storage.

For organizations that are planning for a hybrid infrastructure with both on-premises storage and cloud computing, HPC applications can "burst" into Azure using data stored in NAS devices and spin up virtual CPUs as needed. The data set is never moved completely into the cloud. The requested bytes are temporarily cached using an Avere cluster during processing.

To set up and configure an Avere vFXT installation, follow the [Avere Setup and Configuration guide][avere].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Mike Warrington](https://www.linkedin.com/in/mikewarrington) | FastTrack for Azure Engineer

## Next steps

Product documentation:

- [What is Azure CycleCloud?](/azure/cyclecloud/overview)
- [Azure Virtual Machines (VMs)](/azure/virtual-machines/windows/overview)
- [Introduction to Azure Storage](/azure/storage/common/storage-introduction)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)

See the following virtual machine articles:

- [RDMA Capable Machine Instances][rdma]
- [Customizing an RDMA Instance VM][rdma-custom]

## Related resources

- [Run reservoir simulation software on Azure](./reservoir-simulation.yml)
- [Oil and gas tank level forecasting](../../solution-ideas/articles/oil-and-gas-tank-level-forecasting.yml)

<!-- links -->
[security]: /azure/security
[vmss]: /azure/virtual-machine-scale-sets/overview
[cyclecloud]: /azure/cyclecloud
[rdma]: /azure/virtual-machines/windows/sizes-hpc#rdma-capable-instances
[vms]: /azure/virtual-machines
[batch]: /azure/batch
[avere]: https://github.com/Azure/Avere/blob/master/README.md
[cycle-svcprin]: /azure/cyclecloud/quickstart-install-cyclecloud#service-principal
[cycle-ssh]: /azure/cyclecloud/quickstart-install-cyclecloud#ssh-keypair
[cycle-login]: /azure/cyclecloud/quickstart-install-cyclecloud#log-into-the-cyclecloud-application-server
[cycle-create]: /azure/cyclecloud/quickstart-create-and-run-cluster
[rdma]: /azure/virtual-machines/windows/sizes-hpc#rdma-capable-instances
[rdma-custom]: /azure/virtual-machines/linux/sizes-hpc#rdma-capable-instances
[pricing]: https://azure.com/e/53030a04a2ab47a289156e2377a4247a
[cycle-scale]: /azure/cyclecloud/autoscale

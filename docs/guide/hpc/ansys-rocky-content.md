This article briefly describes the steps for running [Ansys Rocky](https://www.ansys.com/products/fluids/ansys-rocky) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running Ansys Rocky on Azure.

Ansys Rocky is a 3D DEM (discrete element modeling) particle simulation application that simulates the flow behavior of bulk materials with complex particle shapes and size distributions. Typical applications include conveyor chutes, mills, mixers, and other material-handling equipment. 

The solver in Rocky distributes and manages the combined memory of two or more GPU cards in a single motherboard to overcome memory limitations.

Ansys Rocky enables you to simulate a system with real particle shapes and sizes, specifying both spherical and non-spherical particle shapes, including shells and fibers. 

Rocky is used in industries like food processing, manufacturing, pharmaceutical and biotech, medical and healthcare, agriculture equipment, energy, and mining/metals.

## Why deploy Ansys Rocky on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Impressive performance results for simulations with varying levels of complexity

## Architecture

:::image type="content" source="media/ansys-rocky/ansys-rocky-architecture.svg" alt-text="Diagram that shows an architecture for deploying Ansys Rocky." lightbox="media/ansys-rocky/ansys-rocky-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/ansys-rocky.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Windows VM. For information about deploying the VM and installing the drivers, see [Windows VMs on Azure](../../reference-architectures/n-tier/windows-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  - A public IP address connects the internet to the VM.
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

The performance tests of Ansys Rocky on Azure used [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) and [NC_A100_v4](/azure/virtual-machines/nc-a100-v4-series) VMs running Windows. The following table provides details about the VMs.

|VM size|vCPU|Memory, in GiB|Number of GPUs|	GPU memory, in GiB|Maximum data disks|Maximum uncached disk throughput, in IOPS / MBps|
|-|-|-|-|-|-|-|
|Standard_ND96asr_v4|96|900|8 |40|32|80,000 / 800|
|Standard_NC24ads_A100_v4|24|220|1|80|12|30,000 / 1,000|
|Standard_NC48ads_A100_v4|48|440|2|160|24|60,000 / 2,000|
|Standard_NC96ads_A100_v4|96|880|4|320|32|120,000 / 4,000|

### Required drivers

To take advantage of the GPU capabilities of [NC_A100_v4](/azure/virtual-machines/nc-a100-v4-series) and [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VMs, you need to install NVIDIA GPU drivers.

To use AMD processors on [NC_A100_v4](/azure/virtual-machines/nc-a100-v4-series) and [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VMs, you need to install AMD drivers.

## Ansys Rocky installation

Before you install Ansys Rocky, you need to deploy and connect a VM, install an eligible Windows 10 or Windows 11 image, and install the required NVIDIA and AMD drivers.

For information about eligible Windows images, see [How to deploy Windows 10 on Azure](/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment) and [Use Windows client in Azure for dev/test scenarios](/azure/virtual-machines/windows/client-images).

> [!IMPORTANT]
> NVIDIA Fabric Manager installation is required for VMs that use NVLink or NVSwitch. NC_A100_v4 and ND_A100_v4 VMs use NVLink. 

For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

For information about installing Ansys Rocky, see the [Ansys website](https://www.ansys.com/products/fluids/ansys-rocky).

## Ansys Rocky performance results

A combine harvester simulation was used for the performance tests: 

:::image type="content" source="media/ansys-rocky/combine.png" alt-text="Screenshot that shows the combine harvester model."  :::


- **Total number of particles:** 110,827
- **Simulation duration:** 1 second

DEM particle simulation was used to test the application's performance.  Two versions of Ansys Rocky were tested: 2021 R2.2 and 2022 R1.1. 

The following table presents the wall-clock times for running the simulation, for both CPU and GPU configurations.

|Rocky version	|VM series|	96 CPUs	|1 GPU	|2 GPUs|	3 GPUs|	4 GPUs|
|-|-|-|-|-|-|-|
|2021 R2.2|	ND_A100_v4|	10:57:58|	00:53:24<sup>1|	00:44:30<sup>1|	00:40:42<sup>1	|00:46:01<sup>1|
|2022 R1.1|	ND_A100_v4|	-	|00:44:41<sup>1|	00:37:47<sup>1|	00:39:40<sup>1|	00:42:29<sup>1|
|2022 R1.1|	NC_A100_v4|	-	|00:40:19|	00:32:11|	00:30:55<sup>2|	00:32:42|

<sup>1</sup> *In these cases, the number of GPUs was artificially limited. This VM has eight GPUs.*

<sup>2</sup> *In this case, the number of GPUs was artificially limited. This VM is available with one, two, or four GPUs.*

The following table shows the relative speed increases as the CPUs are replaced by GPUs in increasing numbers. The 96-CPU configuration in the preceding table is used as the baseline for the comparisons.

|Rocky version	|VM series|	96 CPUs	|1 GPU	|2 GPUs|	3 GPUs|	4 GPUs|
|-|-|-|-|-|-|-|
|2021 R2.2|	ND_A100_v4|	1.00|12.32<sup>1|14.79<sup>1|16.17<sup>1|14.30<sup>1|
|2022 R1.1|	ND_A100_v4|	1.00	|14.73<sup>1	|17.41<sup>1	|16.59<sup>1	|15.49<sup>1|
|2022 R1.1|	NC_A100_v4|	1.00	|16.32	|20.45|21.29<sup>2	|20.12|

<sup>1</sup> *In these cases, the number of GPUs was artificially limited. This VM has eight GPUs.*

<sup>2</sup> *In this case, the number of GPUs was artificially limited. This VM is available with one, two, or four GPUs.*

Here's the same data, presented graphically:

:::image type="content" source="media/ansys-rocky/rocky-graph.png" alt-text="Graph that shows the relative speed increases." border="false" :::

*In the preceding graph, 0 GPUs indicates that the simulation was run with only CPUs.*

## Azure cost

The following table presents wall-clock times that you can use to calculate Azure costs. You can multiply the times presented here by the Azure hourly rates for NCA100v4-series VMs to calculate costs. For the current hourly costs, see [Windows Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing). 

Only the wall-clock times for running the model are presented in this table. Application installation time isn't included. These times are indicative. The actual times depend on the size of the model.

The wall-clock times for a full production-level simulation of the combine harvester model are longer than the times presented here, so the associated costs are higher.

The times here represent tests performed on Ansys Rocky 2022 R1.1.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

|VM size|	Number of GPUs|	Elapsed time, in hours|
|-|-|-|
|Standard_NC24ads_A100_v4	|	1|	0.67|
|Standard_NC48ads_A100_v4	|	2|	0.53|
|Standard_NC96ads_A100_v4	|	4	|0.54|

## Summary

- Ansys Rocky was successfully tested on ND_A100_v4 and NC_A100_v4 VMs on Azure.
- The speed increases significantly when you upgrade from 96 CPUs to one GPU.
- For all models, there's an optimal configuration that achieves the best combination of price and performance. After that point, adding hardware doesn't scale the performance substantially. For this particular harvester model, optimal performance occurs with three GPUs. For more complex models, we expect the optimal number of GPUs to be higher. For models that are less complex, we expect it to be lower.

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

-   [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) |
    Senior Manager
-   [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) |
    Principal Program Manager
-   [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) |
    HPC Performance Engineer

Other contributors:

-   [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) |
    Technical Writer
-   [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director
    Business Strategy
-   [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) |
    Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [GPU-optimized virtual machine sizes](/azure/virtual-machines/sizes-gpu)
- [Virtual machines on Azure](/azure/virtual-machines/overview)
- [Virtual networks and virtual machines on Azure](/azure/virtual-network/network-overview)
- [Learning path: Run high-performance computing (HPC) applications on Azure](/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)

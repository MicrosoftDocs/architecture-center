<Intro should cover a basic overview of the workload.>

## Why deploy Ansys Rocky on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Impressive performance results for simulations with varying levels of complexity

## Architecture

:::image type="content" source="media/ansys-rocky/architecture.png" alt-text="Diagram that shows an architecture for deploying Ansys Rocky." lightbox="media/ansys-rocky/architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/ansys-rocky.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a VM. For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml) or [].
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  - A public IP address connects the internet to the VM.
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

The performance tests of Ansys Rocky on Azure used [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) and [NC_A100_v4](/azure/virtual-machines/nc-a100-v4-series) VMs running . The following table provides details about the VMs.

|VM size|vCPU|Memory, GiB|Number of GPUs|	GPU memory, in GiB|Maximum data disks|Maximum uncached disk throughput, in IOPS / MBps|
|-|-|-|-|-|-|-|
|Standard_ND96asr_v4|96|900|8 |40|32|80,000 / 800|
|Standard_NC24ads_A100_v4|24|220|1|80|12|30,000 / 1,000|
|Standard_NC48ads_A100_v4|48|440|2|160|24|60,000 / 2,000|
|Standard_NC96ads_A100_v4|96|880|4|320|32|120,000 / 4,000|

### Required drivers

To take advantage of the GPU capabilities of [NC_A100_v4](/azure/virtual-machines/nc-a100-v4-series) and [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VMs, you need to install NVIDIA GPU drivers.

To use AMD processors on [NC_A100_v4](/azure/virtual-machines/nc-a100-v4-series) and [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VMs, you need to install AMD drivers.

## Ansys Rocky installation

Before you install Ansys Rocky, you need to deploy and connect a VM and install the required NVIDIA and AMD drivers.

> [!IMPORTANT]
> NVIDIA Fabric Manager installation is required for VMs that use NVLink or NVSwitch. NC_A100_v4 and ND_A100_v4 VMs use NVLink. 

For information about deploying the VM and installing the drivers, see one of these articles:
- [Run a Windows VM on Azure]
- [Run a Linux VM on Azure]

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
|2021 R2.2|	ND_A100_v4|	10:57:58|	00:53:24|	00:44:30|	00:40:42	|00:46:01|
|2022 R1.1|	ND_A100_v4|	-	|00:44:41|	00:37:47|	00:39:40|	00:42:29|
|2022 R1.1|	NC_A100_v4|	-	|00:40:19|	00:32:11|	00:30:55|	00:32:42|

The following table shows the relative speed increases as the CPUs are replaced by GPUs in increasing numbers. The 96-CPU configuration in the preceding table is used as the baseline for the comparisons.

|Rocky version	|VM series|	96 CPUs	|1 GPU	|2 GPUs|	3 GPUs|	4 GPUs|
|-|-|-|-|-|-|-|
|2021 R2.2|	ND_A100_v4|	1.00|12.32|14.79|16.17|14.30|
|2022 R1.1|	ND_A100_v4|	1.00	|14.73	|17.41	|16.59	|15.49|
|2022 R1.1|	NC_A100_v4|	1.00	|16.32	|20.45	|21.29	|20.12|

Here's the same data, presented graphically:

:::image type="content" source="media/ansys-rocky/rocky-graph.png" alt-text="Graph that shows the relative speed increases." border="false" :::

*In the preceding graph, 0 GPUs indicates that the simulation was run with only CPUs.*

## Azure cost

The following tables present wall-clock times that you can use to calculate Azure costs.

<Description of the costs that might be associated with running this workload in Azure. Make sure to have a link to the Azure pricing calculator.>

You can use the [Azure pricing calculator]() to estimate the costs for your configuration.
<Show the pricing calculation or a direct link to this specific workload with the configuration(s) used.>

## Summary

- Ansys-Rocky Application is successfully deployed and tested on ND A100v4 and NC A100v4 series Azure Virtual Machine
- The expected speed up is achieved when compared between CPU and one GPU.
- For all models, there is an optimal amount of computational hardware that achieves best price/performance, after which adding additional hardware does not scale the performance substantially. For this particular harvester model, we see the peak optimal performance achieved when we utilized 3 GPUs. For larger or more complex models, we expect this optimal GPU number to be higher, and for smaller ones we expect it to be lower.

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

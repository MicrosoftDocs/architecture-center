
This article briefly describes the steps for running [Turbostream](https://www.turbostream-cfd.com) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running TurboStream on Azure.

Turbostream is advanced simulation software that's based on a computational fluid dynamics (CFD) solver. It can run on high-speed GPUs and on conventional CPUs. 

The software enables high-fidelity methods, like unsteady full-annulus simulations, to be used as part of the routine design process.

Turbostream is used by NASA and in the design of aircraft engines, turbomachinery, and gas turbines.

## Why deploy Turbostream on Azure?

- Modern and diverse compute options to meet the needs of your workloads 
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- With an eight-GPU configuration, a performance increase of 4.51 times that of a single GPU

## Architecture

:::image type="content" source="media/turbostream/turbostream-architecture.svg" alt-text="Diagram that shows an architecture for deploying Turbostream." lightbox="media/turbostream/turbostream-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/turbostream.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Linux VM. For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  - A public IP address connects the internet to the VM.
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

The performance tests of Turbostream used an [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VM running Linux. The following table provides details about the VM.

|VM size|vCPU|Memory (GiB)|SSD (GiB)|GPUs|GPU memory (GiB)|Maximum data disks|
|-|-|-|-|-|-|-|
|Standard_ND96asr_v4|96|900|6,000|8 A100|40|32|

### Required drivers

To take advantage of the GPU capabilities of [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VMs, you need to install NVIDIA GPU drivers.

To use AMD processors on [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VMs, you need to install AMD drivers.

## Turbostream installation

Before you install Turbostream, you need to deploy and connect a Linux VM and install the required NVIDIA and AMD drivers.

> [!IMPORTANT]
> NVIDIA Fabric Manager installation is required for VMs that use NVLink or NVSwitch. ND_A100_v4 VMs use NVLink.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

You can install Turbostream by signing in to [ExaVault](https://app.exavault.com/login) as a customer. The downloadable files include documentation, a release package, a license file, and a test simulation package (*scaling_test.zip*). For more information, contact [Turbostream](https://www.turbostream-cfd.com/#contact).

## Turbostream performance results

Four simulations were tested, as described in the following table.  

|Model number|	Number of grid nodes (millions)|
|-|-|
|1|	6|
| 2|12|
|3|24|
| 4|48|

The following table describes the performance results. *Performance* is the number of grid nodes processed per second. *Relative performance* is relative to the performance described in the first line of the table. 

Model number|Number of GPUs|Time (seconds, average of 200 iterations)|Performance| Relative performance|
|-|-|-|-|-|
|1|1*|0.0743|80,753,701.21|1|
|2|2*|0.0944|127,118,644.1|1.57|
|3|4*|0.1145|209,606,986.9|2.60|
|4|8|0.1319|363,912,054.6|4.51|

\* *In these cases, the number of GPUs was artificially limited. The Standard_ND96asr_v4 VM has eight GPUs.*

The relative performance increases are presented graphically here: 

:::image type="content" source="media/turbostream/performance-graph.png" alt-text="Graph that shows the relative performance increases."  border="false":::


### Additional notes about tests

The following table provides details about the operating system and the NVIDIA drivers that were used for testing.

|OS version |OS architecture |GPU driver version|CUDA version|
|-|-|-|-|
|CentOS Linux release 8.1.1911 (Core)|x86-64|470.57.02|11.4|

## Azure cost

The following table presents the elapsed time. You can use this time and the Azure VM hourly cost for the NDA100v4 VM to calculate costs. For the current hourly cost, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

Only simulation runtime is included in the reported time. Application installation time isn't included.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

|VM size|	GPUs	|Elapsed time (seconds)|
|-|-|-|
|Standard_ND96asr_v4	|	8 A100|	196.10|

## Summary

- Turbostream was successfully tested on the ND_A100_v4 VM.
- Performance with eight GPUs is 4.51 times faster than the performance with one GPU.

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

- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)

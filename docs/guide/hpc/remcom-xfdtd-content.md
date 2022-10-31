This article briefly describes the steps for running [Remcom XFdtd](https://www.remcom.com/xfdtd-3d-em-simulation-software) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running Remcom XFdtd on Azure.

XFdtd is electromagnetic simulation software that includes full-wave, static, biothermal, optimization, and circuit solvers. 

XFdtd includes a schematic editor that's designed for antenna engineers who need to analyze matching networks and corporate feed networks. 

The software enables in-depth analysis of a device's stand-alone performance, with 5G-device design features that support high-frequency array antennas and complex devices that operate at millimeter wave frequencies.

XFdtd is used for antenna design and analysis, antenna modeling, 5G array analysis, biomedical effects, microwave devices and waveguides, radar/scattering, military defense, and automotive radar. It's ideal for the telecommunications, healthcare, manufacturing, and automotive industries.

## Why deploy Remcom XFdtd on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Fast compute capabilities for GPU-intensive workloads

## Architecture

:::image type="content" source="media/remcom-xfdtd/architecture.png" alt-text="Diagram that shows an architecture for deploying Remcom XFdtd." lightbox="media/remcom-xfdtd/architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/remcom-xfdtd.vsdx) of this
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

The performance tests of Remcom XFdtd used an [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VM running Windows 10. The following table provides details about the VM.

|VM size|vCPU|Memory, in GiB|Temporary storage (SSD), in GiB|	GPUs	|GPU memory, in GiB|Maximum data disks|
|-|-|-|-|-|-|-|
|Standard_ND96asr_v4	|96	|900	|6,000	|8 A100	|40	|32|

### Required drivers

To take advantage of the GPU capabilities of [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VMs, you need to install NVIDIA GPU drivers.

To use AMD processors on [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VMs, you need to install AMD drivers.

## Remcom XFdtd installation

Before you install Remcom XFdtd, you need to deploy and connect a VM, install an eligible Windows 10 image, and install the required NVIDIA and AMD drivers. 

For information about eligible Windows images, see [How to deploy Windows 10 on Azure](/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment) and [Use Windows client in Azure for dev/test scenarios](/azure/virtual-machines/windows/client-images).

> [!IMPORTANT]
>  NVIDIA Fabric Manager installation is required for VMs that use NVLink or NVSwitch. ND_A100_v4 VMs use NVLink. 

For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

Before you install XFdtd, you need to install a floating license server. For detailed instructions on [installing XFdtd](https://support.remcom.com/xfdtd/installation/xfdtd-installation.php), [installing the license server](https://support.remcom.com/xfdtd/installation/floating-license.php), [setting up an MPI cluster](https://support.remcom.com/xfdtd/installation/mpi-cluster-setup.php), and more, see the [installation manual](https://support.remcom.com/xfdtd/installation.html).

## Remcom XFdtd performance results

Remcom XFdtd version 7.10.0.1 was tested. A patch in body model was used for the tests: 

:::image type="content" source="media/remcom-xfdtd/patch-body-model.png" alt-text="Screenshot that shows the patch in body model." border="false":::

The following table provides details about the model.

|Model name|Frequency range of interest|Minimum cells per wavelength|Frequency of interest|Minimum cell size|
|-|-|-|-|-|
|Patch in body|0 GHz to 10 GHz|15|2.45 GHz|0.735 mm|

Throughput is used as a metric to test the performance of the simulation. The following table provides the test results. 

|Number of GPUs|	Simulation timesteps |Total cells|Elapsed time (seconds)|Timesteps per second|Throughput (cells per second)|Throughput (Gcells<sup>1</sup> per second)|
|-|-|-|-|-|-|-|
|1<sup>2	|39,141	|1,077,552,576	|3,003	|13.03	|14,044,783,675	|14.04|
|4<sup>2|	39,141|	1,077,552,576|	954|	41.03|	44,210,152,387|	44.21|
|8|	39,141	|1,077,552,576|	834	|46.93|	50,571,325,392	|50.57|

<sup>1</sup> *Gcells is the cell count divided by 1,000,000,000.*

<sup>2</sup> *In these cases, the number of GPUs was artificially limited. The Standard_ND96asr_v4 VM has eight GPUs.*

This graph shows the throughput for the different numbers of GPUs: 

:::image type="content" source="media/remcom-xfdtd/xfdtd-graph.png" alt-text="Graph that shows the performance of the model." border="false":::

## Azure cost

The following table shows the wall-clock time for running the simulation, in hours. To compute the total cost, multiply this time by the Azure VM hourly cost for the NDA100v4 VM. For the current hourly cost, see [Windows Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing).

Only simulation runtime is included in the reported time. Application installation time isn't included.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

|VM size|	Number of GPUs|	Elapsed time (hours)|
|-|-|-|
|Standard_ND96asr_v4	|	8|	0.23| 

## Summary

- Remcom XFdtd was successfully tested on the Standard_ND96asr_v4 VM.
- A complex simulation ran in 0.23 hours. 

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

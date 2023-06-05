This article briefly describes the steps for running [Siemens NX](https://www.plm.automation.siemens.com/global/en/products/nx/) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running NX on Azure.

Organizations use NX for design, simulation, and manufacturing solutions that enable digital twin technology. Siemens NX:

- Provides layout piping and instrumentation diagrams in two dimensions while maintaining the design tied to the 3D model.
- Eliminates re-creation of annotated 2D CAD drawings by using legacy data with model-based definition.

NX is used in the automotive sector and for projects ranging from supersonic cars to drones for the medical industry. These scenarios also relate to the aerospace and healthcare industries.

## Why deploy Siemens NX on Azure?

- Modern and diverse compute options to align to your workload's needs 
- The flexibility of virtualization without the need to buy and maintain physical hardware 
- Rapid provisioning 
- Successful runs of all ATS and NXCP test cases

## Architecture

:::image type="content" source="media/siemens-nx/siemens-nx.png" alt-text="Diagram that shows an architecture for deploying Siemens NX." lightbox="media/siemens-nx/siemens-nx.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/siemens-nx.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Windows VM. 
  - For information about deploying the VM and installing the drivers, see [Windows VMs on Azure](../../reference-architectures/n-tier/windows-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud. 
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  -  A public IP address connects the internet to the VM.
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

Performance tests of NX on Azure used [NVv3](/azure/virtual-machines/nvv3-series) and [NCasT4_v3](/azure/virtual-machines/nct4-v3-series) series VMs running Windows. The following table provides the configuration details.

|VM size|vCPU|Memory, in GiB|SSD, in GiB|Number of GPUs|GPU memory, in GiB|Maximum data disks|
|-|-|-|-|-|-|-|
|Standard_NV12s_v3 |12|112|320|1|8|12|
|Standard_NV24s_v3 |24|224|640|2|16|24|
|Standard_NC16as_T4_v3|16|110|360|1|16|32|

### Required drivers

To take advantage of the GPU capabilities of [NVv3](/azure/virtual-machines/nvv3-series) and [NCasT4_v3](/azure/virtual-machines/nct4-v3-series) series VMs, you need to install the NVIDIA GPU drivers.

To use CPUs on [NCasT4_v3](/azure/virtual-machines/nct4-v3-series), you need to install the AMD drivers.

## NX installation

Before you install NX, you need to deploy and connect a VM, install an eligible Windows 10 or Windows 11 image, and install the required NVIDIA and AMD drivers.

For information about eligible Windows images, see [How to deploy Windows 10 on Azure](/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment) and [Use Windows client in Azure for dev/test scenarios](/azure/virtual-machines/windows/client-images).

For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

After you install the drivers, install Siemens PLM License Server and the NX application. You can download these applications and get download instructions from the [Siemens website](https://support.sw.siemens.com/en-US/product).

> [!NOTE]
> You need to install the [Java Runtime Environment (64-bit) for NX](https://www.java.com/en) before you install NX.

## NX performance results

Siemens Automated Testing Studio (ATS) and NXCP were used to test NX.
For information about installing and using these tools, see the [Siemens website](https://support.sw.siemens.com/en-US/product).

### NXCP test results  

The Siemens NXCP tool was used to run these tests. Test cases are grouped to demonstrate various capabilities. Each test group consists of multiple test cases.

The following table shows the test results.

|Test group name|Number of test cases|1 GPU (NV12s_v3)|2 GPUs (NV24s_v3)|1 GPU (NCasT4, 16 CPU)|
|-|-|-|-|-|
|GDAT_LEGACY|15|Pass|Pass|Pass|
|TCVIS 2007|10|Pass|Pass|Pass|
|TECNOMATIX_OpenGL Display|2|Pass|Pass|Pass|
|TECNOMATIX_OpenGL Buffer|2|Pass|Pass|Pass|
|NX1847_Manual|7|Pass|Pass|Pass|
|NX1899_Manual|7|Pass|Pass|Pass|
|NX 1899 Mark|6|Pass|Pass|Pass|

### ATS test results

The following table shows ATS test results.

|Case number|Description|Case ID|	1 GPU (NV12s_v3) |	2 GPUs (NV24s_v3)|1 GPU (NCasT4, 16 CPU)|
|-|-|-|-|-|-|
|AT-01|	Verifies that Listing Window shows data correctly|	Listing Window	|1 minute, 11 seconds|	31 seconds	|18 seconds|
|AT-02|Verifies correct mirror display in various views	|Mirror Display|	1 minute, 40 seconds|	1 minute, 8 seconds|	1 minute, 10 seconds|
|AT-03|	Verifies de-emphasis displays|	Deemphasis	|1 minute, 13 seconds|	1 minute	|57 seconds|
|AT-04|	Verifies grid displays|	Grid Display	|1 minute, 47 seconds	|1 minute, 16 seconds	|51 seconds|
|AT-05|	Verifies correct display of raster images in various view ports|	Raster Image	|20 seconds|	19 seconds|	23 seconds|
|AT-06|	Shows multiple views in one window|	Multiple Views	|23 seconds|	26 seconds|	25 seconds|
|AT-07|	Verifies the background setting in the wireframe view|	Background Setting Wireframe	|45 seconds	|29 seconds	|34 seconds|
|AT-08|	Verifies correct display of light and shadow in Advanced Studio	|Light Direction	|21 seconds	|20 seconds|	23 seconds|
|AT-09	|Verifies the display section|Display Section|	4 minutes, 35 seconds	|2 minutes, 8 seconds	|1 minute, 52 seconds|
|AT-10	|Verifies display modes|	Display Modes|	17 minutes	|45 seconds	|43 seconds|
|AT-11	|Activates HD3D and representation status with tags	|HD3D|	1 minute, 37 seconds	|47 seconds|	47 seconds|
|AT-12	|Activates face analysis and verifies displays with reflection	|Face Analysis|	52 minutes|	41 minutes	|40 minutes, 33 seconds|
|AT-13	|Rotates views in sync	|Synchronize View	|18 seconds|	16 seconds	|15 seconds|

## Azure cost

The following table presents wall-clock times that you can use to calculate Azure costs. You can use the times presented here together with the Azure hourly rates for NVv3 and NCas_T4_v3 series VMs to calculate costs. For the current hourly costs, see [Windows Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing).

Only elapsed running time of the tests is considered for these cost calculations. Application installation time isn't considered.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

|VM size| Number of GPUs|Wall-clock time|
|-|-|-|
|NV12s_v3|1|1 hour, 23 minutes, 10 seconds|
|NV24s_v3|2|50 minutes, 25 seconds|
|NC16as_T4_v3|1|49 minutes, 18 seconds|

## Summary

- NX was successfully tested on NVv3 and NCas_T4 series VMs on Azure.
- All test cases, for both ATS and NXCP, ran successfully on 1-GPU Standard_NV12s_v3, 2-GPU Standard_NV24s_v3, and 1-GPU Standard_NC16as_T4_v3 configurations.

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

-   [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) |
    Senior Manager
-   [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) |
    Principal Program Manager
-   [Vinod
    Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) |
    HPC Performance Engineer

Other contributors:

-   [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) |
    Technical Writer
-   [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director
    Business Strategy
-   [Sachin
    Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) |
    Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

-   [GPU-optimized virtual machine
    sizes](/azure/virtual-machines/sizes-gpu)
-   [Windows virtual machines on Azure](/azure/virtual-machines/overview)
-   [Virtual networks and virtual machines on
    Azure](/azure/virtual-network/network-overview)
-   [Learning path: Run high-performance computing (HPC) applications on
    Azure](/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

-   [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
-   [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
-   [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)

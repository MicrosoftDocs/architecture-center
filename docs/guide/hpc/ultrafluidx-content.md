This article briefly describes the steps for running [Altair ultraFluidX](https://www.altair.com/altair-cfd-capabilities) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running ultraFluidX on Azure.

Altair ultraFluidX is a simulation tool for predicting the aerodynamic properties of passenger and heavy-duty vehicles, and for the evaluation of building and environmental aerodynamics. Altair ultraFluidX:

- Is based on Lattice Boltzmann methods (LBM).
- Is optimized for GPUs and supports CUDA-aware MPI for multi-GPU usage.
- Provides an LBM-consistent Smagorinsky LES turbulence model, TBLE-based wall modeling, and porous media model (pressure drop) for simulation of multiple heat exchangers.
- Handles rotating geometries via wall-velocity boundary conditions, a Moving Reference Frame (MRF) model, and truly rotating overset grids (OSM).
- Provides automated volume mesh generation with low surface mesh requirements, local grid refinement, and support for intersecting/baffle parts.
 
Altair ultraFluidX is used in the automotive, building, facilities, energy, and environmental industries.

## Why deploy ultraFluidX on Azure?

- Modern and diverse compute options to align with your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Complex problems solved within a few hours

## Architecture

:::image type="content" source="media/ultrafluidx/hpc-ultrafluidx.png" alt-text="Diagram that shows an architecture for deploying Altair ultraFluidX." lightbox="media/ultrafluidx/hpc-ultrafluidx.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/hpc-ultrafluidx.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Linux VM. 
  - For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud. 
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  -  A public IP address connects the internet to the VM.
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

Performance tests of ultraFluidX on Azure used [ND A100 v4 series VMs](/azure/virtual-machines/nda100-v4-series) running Linux. The following table provides the configuration details.

|VM size|vCPU|Memory, in GiB|SSD, in GiB|GPUs|GPU memory, in GiB|Maximum data disks|
|-|-|-|-|-|-|-|
|Standard_ND96asr_v4|96|900|6,000|8 A100|40|32|

The Standard_ND96asr_v4 VM runs NVIDIA Ampere A100 Tensor Core GPUs and is supported by 96 AMD processor cores.

### Required drivers

To use ultraFluidX on Standard_ND96asr_v4 VMs as described in this article, you need to install NVIDIA and AMD drivers.

## ultraFluidX installation

Before you install ultraFluidX, you need to deploy and connect a Linux VM and install the required NVIDIA and AMD drivers.

> [!IMPORTANT]
> NVIDIA Fabric Manager installation is required for VMs that use NVLink or NVSwitch. Standard_ND96asr_v4 uses NVLink.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

Altair ultraFluidX only runs on Linux. You can download ultraFluidX from [Altair One Marketplace](https://altairone.com/Marketplace?__hstc=142694250.005b507352b9e4107a39c334591c181a.1662053255169.1663267860104.1663279870680.17&__hssc=142694250.2.1663279870680&__hsfp=4046309035&queryText=ultrafluidx&app=ultraFluidX&tab=Info). You also need to install Altair License Manager and activate your license via Altair Units Licensing. For more information, see the Altair Units Licensing document on [Altair One Marketplace](https://altairone.com/Marketplace?__hstc=142694250.005b507352b9e4107a39c334591c181a.1662053255169.1663267860104.1663279870680.17&__hssc=142694250.2.1663279870680&__hsfp=4046309035&queryText=ultrafluidx&app=ultraFluidX&tab=Info).

## ultraFluidX performance results

The Roadster and CX1 models were used as test cases. This image shows the roadster model:

:::image type="content" source="media/ultrafluidx/roadster.png" alt-text="Figure that shows the roadster model." border="false":::

This image shows the CX1 model:

:::image type="content" source="media/ultrafluidx/cx1.png" alt-text="Figure that shows the CX1 model." border="false":::

The amount of time it takes to complete the simulation by using GPUs was measured. The Linux platform was used, with an Azure Marketplace CentOS 8.1 HPC Gen2 image. The following table provides details about the operating system and NVIDIA drivers.

| Operating system version | OS architecture |GPU driver version  | Cuda version |
|---------|---------|---------|---------|
| CentOS Linux release 8.1.1911 (Core) | x86-64    |  470.57.02       |   11.4      |

GPU-based fluid dynamics simulations were run to test ultraFluidX. The simulations were run for shortened test cases, not for full production-level test cases. The projected wall-clock times and computation times for a full production run of the CX1 are provided here. Because the workload per time step is constant, these times can be computed from the computation time of the short run via linear extrapolation.

The total simulation consists of two phases: a mostly CPU-based pre-processing phase (independent of the physical simulation time) and the GPU-based computation phase. The purpose of the simulation is to test the performance of the GPU phase on the chosen VM: Standard_ND96asr_v4.

The following table shows the wall-clock times, in seconds.  

|Model|1 GPU|2 GPUs|4 GPUs|8 GPUs|
|-|-|-|-|-|
|Roadster|1,571|1,097|731|539|
|CX1 (short run)|NA*|NA*|6,679|4,743|
|CX1 (production run)|NA*|NA*|39,115|23,518|

This graph provides the same information for the Roadster model and the short run of the CX1 model:

:::image type="content" source="media/ultrafluidx/wall-clock-time.png" alt-text="Graph that shows the wall-clock times for simulations using various numbers of GPUs." border="false":::

The following table shows the pre-processing times, in seconds.

|Model|1 GPU|2 GPUs|4 GPUs|8 GPUs|
|-|-|-|-|-|
|Roadster|679|607|446|350|
|CX1 |NA*|NA*|4,926|3,728|


The following table shows the computation times, in seconds.

|Model|1 GPU|2 GPUs|4 GPUs|8 GPUs|
|-|-|-|-|-|
|Roadster|782|433|257|174|
|CX1 (short run)|NA*|NA*|1,560|903|
|CX1 (production run)|NA*|NA*|33,996|19,678|

Finally, the following table shows the relative speed increases when the number of GPUs is increased. The speed increases are calculated for the computation time (the phase when GPUs are used) to provide the GPU performance.

|Model|1 GPU|2 GPUs|4 GPUs|8 GPUs|
|-|-|-|-|-|
|Roadster|1.00|1.81|3.04|4.49|
|CX1 |NA*|NA*|1.00|1.73|

*\* NA indicates that the model requires more than 100 GB of GPU memory, so the simulation can't run with only one or two GPUs.*

Here's that information in graphical form:

:::image type="content" source="media/ultrafluidx/relative-increase.png" alt-text="Graph that shows the relative speed increases as the number of GPUs increases." border="false":::

## Azure cost

The following table presents wall-clock times that you can use to calculate Azure costs. You can use the times presented here together with the Azure hourly rates for ND A100 v4-series VMs to calculate costs. For the current hourly costs, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

Only wall-clock time is considered for these cost calculations. Application installation time isn't considered.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

|Model| Number of GPUs*|Wall-clock time, in seconds|
|-|-|-|
|Roadster|1|1,571|
|Roadster|2|1,097|
|Roadster|4|731|
|Roadster|8|539|
|CX1 (short run)|4|6,679|
|CX1 (short run)|8|4,743|
|CX1 (production run)|4|39,115|
|CX1 (production run)|8|23,518 |

*\* The CX1 model requires more than 100 GB of GPU memory, so the simulation can't run with only one or two GPUs.*

## Summary

- Altair ultraFluidX was successfully tested on ND A100 v4-series VMs on Azure.
- Complex problems can be solved within a few hours on ND A100 v4 VMs.
- Increasing the number of GPUs improves performance.

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
-   [Linux virtual machines on
    Azure](/azure/virtual-machines/linux/overview)
-   [Virtual networks and virtual machines on
    Azure](/azure/virtual-network/network-overview)
-   [Learning path: Run high-performance computing (HPC) applications on
    Azure](/training/paths/run-high-performance-computing-applications-azure)

## Related resources

-   [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
-   [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
-   [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)

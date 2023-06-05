This article briefly describes the steps for running [OpenFOAM](https://www.openfoam.com) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running OpenFOAM on Azure.

OpenFOAM is a free, open-source computational fluid dynamics (CFD) application. Users have permission to modify and compile the package based on the needs and the physics of the problem they're solving.

The software is a C++ toolbox for the development of customized numerical solvers. It uses explicit methods for configuring a simulation by selecting numerical schemes, solvers and their parameters, and algorithm controls.

OpenFOAM is used in academia/education and in industries like transportation, automotive, manufacturing, and healthcare.

## Why deploy OpenFOAM on Azure?

- Modern and diverse compute options to align to your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Appreciable speed increase as cores increase

## Architecture

:::image type="content" source="media/openfoam/architecture.png" alt-text="Diagram that shows an architecture for deploying OpenFOAM." lightbox="media/openfoam/architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/openfoam.vsdx) of this
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

Performance tests of OpenFOAM on Azure used [HBv3-series](/azure/virtual-machines/hbv3-series) VMs running Linux. The following table provides details about the VMs.

|VM size|vCPU|Memory (GiB)|Memory bandwidth GBps|Base CPU frequency (GHz)|All-cores frequency (GHz, peak)|Single-core frequency (GHz, peak)|RDMA performance (Gbps)|Temp storage (GiB)|Maximum data disks|
|-|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3|	120|	448|	350|	1.9|	3.0|	3.5|	200|	2 * 960|	32|
|Standard_HB120-96rs_v3|	96|	448	|350|	1.9	|3.0|	3.5	|200|	2 * 960	|32|
|Standard_HB120-64rs_v3	|64	|448	|350|	1.9	|3.0|	3.5	|200|	2 * 960|	32|
|Standard_HB120-32rs_v3	|32|	448	|350|	1.9	|3.0|	3.5	|200|	2 * 960|	32|
|Standard_HB120-16rs_v3	|16|	448	|350|	1.9	|3.0|	3.5	|200|	2 * 960|	32|

The HBv3 (Milan-X) VMs are optimized for HPC applications like fluid dynamics, explicit and implicit finite element analysis, weather modeling, seismic processing, reservoir simulation, and RTL simulation.

### Required drivers

To use AMD CPUs on [HBv3](/azure/virtual-machines/hbv3-series) VMs, you need to install AMD drivers.

To use InfiniBand, you need to enable InfiniBand drivers.

## OpenFOAM installation

Before you install OpenFOAM, you need to deploy and connect a Linux VM and install the required AMD and InfiniBand drivers.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

For information about installation and about the various versions of OpenFOAM, see this [OpenFOAM Development page](https://develop.openfoam.com/Development/openfoam/-/wikis/precompiled).

## OpenFOAM performance results

The following table provides the details of the operating system that was used for testing.

|Operating system	|OS architecture|	Processor|
|-|-|-|
|CentOS 7.9.2009|x86-64|AMD EPYC 7V73X (Milan-X)|

The motorbike model with 21M cells was used for testing.

:::image type="content" source="media/openfoam/motorbike.png" alt-text="Screenshot that shows the motorbike model."  border="false":::

The following table shows the elapsed times, in seconds, for running the simulation with varying numbers of CPUs.

|Number of CPUs|Elapsed times (seconds)|	Relative speed increase|
|-|-|-|
|16 |	412.08|	1.00|
|32 |	253.04|	1.63|
|64 |	176.43|	2.34|
|96 |	159.62|	2.58|
|120 |	157.88|	2.61|

This graph shows the relative speed increases as the number of CPUs increases:

:::image type="content" source="media/openfoam/graph.png" alt-text="Graph that shows the relative speed increases."  border="false":::

## Azure cost

The following table presents wall-clock times that you can use to calculate Azure costs. You can multiply the times presented here by the Azure hourly rates for HBv3-series VMs to calculate costs. For the current hourly costs, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

Only model running time (wall-clock time) is considered in these cost calculations. Application installation time isn't considered. The calculations are indicative. The actual costs depend on the size of the model.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

|Number of CPU cores	|Wall-clock time (hours)|
|-|-|
|16	|0.114|
|32	|0.070|
|64	|0.049|
|96	|0.044|
|120|	0.044|

## Summary

- OpenFOAM was successfully tested on HBv3-series VMs on Azure.
- An appreciable speed increase is achieved as CPU cores are increased up to 64 cores. After that point, the speed increase starts to saturate.

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

-   [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) |
    Senior Manager
-   [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) |
    Principal Program Manager
-   [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) |
    HPC Performance Engineer

Other contributors:

-   [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) |
    Technical Writer
-   [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director
    Business Strategy
-   [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) |
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

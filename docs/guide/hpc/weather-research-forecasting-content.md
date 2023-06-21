This article briefly describes the steps for running [WRF](https://www.mmm.ucar.edu/models/wrf) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running WRF on Azure.

Weather Research & Forecasting (WRF) is a mesoscale numerical weather-prediction system that's designed for atmospheric research and operational forecasting applications. 

WRF serves a wide range of meteorological applications across scales from tens of meters to thousands of kilometers. It provides a flexible and computationally efficient platform while reflecting recent advances in physics, numerics, and data assimilation. The software can produce simulations based on actual atmospheric conditions or from idealized conditions.

WRF is used by academic atmospheric scientists (dynamics, physics, weather, and climate research), forecast teams at operational centers, and applications scientists (air quality, hydrology, and utilities).

## Why deploy WRF on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Performance that scales as CPUs are added, based on tests of a sample model

## Architecture

:::image type="content" source="media/wrf/weather-research-forecasting.svg" alt-text="Diagram that shows an architecture for deploying WRF." lightbox="media/wrf/weather-research-forecasting.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/hpc-weather-research-forecasting.vsdx) of this
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

The performance tests of WRF used [HBv3-series](/azure/virtual-machines/hbv3-series) VMs running Linux. The following table provides details about the VMs.

|Size|vCPU|	RAM memory (GiB)|Memory bandwidth (GBps)|Base CPU frequency (GHz)|	All-cores frequency (GHz, peak)	|Single-core frequency (GHz, peak)|	RDMA performance (Gbps)|Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3	|120|	448|	350|	1.9|	3.0|	3.5|	200|	32|
|Standard_HB120-96rs_v3	|96	|448	|350	|1.9	|3.0|	3.5	|200	|32|
|Standard_HB120-64rs_v3|	64	|448|	350	|1.9|	3.0|	3.5|	200|	32|
|Standard_HB120-32rs_v3	|32	|448	|350	|1.9	|3.0	|3.5	|200	|32|
|Standard_HB120-16rs_v3|	16	|448|	350|	1.9|	3.0	|3.5|	200	|32|

HBv3-series VMs are optimized for HPC applications like fluid dynamics, explicit and implicit finite element analysis, weather modeling, seismic processing, reservoir simulation, and RTL simulation. 

### Required drivers

To use the AMD CPUs on [HBv3-series](/azure/virtual-machines/hbv3-series) VMs, you need to install AMD drivers.

To use InfiniBand, you need to enable InfiniBand drivers.

## WRF installation

Before you install WRF, you need to deploy and connect a Linux VM and install the required AMD and InfiniBand drivers.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

You can download WRF from the [WRF users page](https://www2.mmm.ucar.edu/wrf/users/download/get_source.html).

Installation steps include setting up your environment and configuring and compiling WRF and WRF Preprocessing System (WPS). (You need WPS if you want to run simulations that use real data rather than idealized simulations.) For detailed compilation instructions, see [How to Compile WRF](https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php).

## WRF performance results

 The New CONUS 2.5 km model was tested:

:::image type="content" source="media/wrf/new-conus-25-km-model.png" alt-text="Screenshot that shows the New CONUS 2.5 km model." border="false":::

The following table provides details about the model. 

|Model|	Resolution (km)|	e_we|	e_sn|	e_vert|	Total grid points|	Time step (seconds)|	Simulation hours|
|-|-|-|-|-|-|-|-|
|New CONUS 2.5 km	|2.5	|1901|	1301|	35	|2,473,201|	15|	6|

Because thread configuration improves performance, we need to consider it in these performance tests. The thread settings shown in the following table provide improved hardware performance.

The results were obtained by averaging the WRF computation time of each time step in the *rsl.out.0000* output file.

|CPU|	Threads|	Tile|	MPI rank|	Simulation time (hours)|	Mean time per step (seconds)|
|-|-|-|-|-|-|
|16	|1|	162|	16|	3.25|	7.85|
|32	|2|	162	|16	|2.08	|4.97|
|64	|4	|325|	16	|1.59|	3.75|
|96|	6|	325|	16|	1.46|	3.44|
|120|	6|	260	|20|	1.43|	3.34|

The following graph shows the mean times per step, in seconds. 

:::image type="content" source="media/wrf/graph.png" alt-text="Graph that shows the mean times per step." border="false":::


### Additional notes about tests

WRF version 4.3.1 was tested. The following table provides information about the VM that was used for testing.

| Operating system version | OS architecture | MPI |Compiler  |
|---------|---------|---------|---------|
|CentOS Linux release 8.1.1911 (Core)     |  x86-64       |  Open MPI 4.1.0       |  ICC 2021.4.0   |

## Azure cost

The following table presents the wall-clock times for running the New CONUS 2.5 km simulation. You can multiply these times by the Azure VM hourly costs for HBv3-series VMs to calculate costs. For the current hourly costs, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

Only the simulation time is represented in these times. Application installation time isn't considered.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

|VM size|	 	Number of CPUs|	Simulation time (hours)|
|-|-|-|
|Standard_HB120-16rs_v3|		16	|3.25|		
|Standard_HB120-32rs_v3|	32	|2.08		|
|Standard_HB120-64rs_v3|	64	|1.59|		
|Standard_HB120-96rs_v3|	96	|1.46|		
|Standard_HB120rs_v3|	120|	1.43|

## Summary

- WRF was successfully tested on HBv3-series series VMs on Azure.
- Expected mean time per step was achieved with all CPU configurations. However, scalability might vary depending on the dataset used and the node count. Be sure to test the affect of the tile size, process, and threads per process.
 
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
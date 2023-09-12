This article briefly describes the steps for running [WRF](https://www.mmm.ucar.edu/models/wrf) on a HPC Cluster that's deployed on Azure. It also presents the performance results of running WRF on Azure.

Weather Research & Forecasting (WRF) is a mesoscale numerical weather-prediction system that's designed for atmospheric research and operational forecasting applications. 

WRF serves a wide range of meteorological applications across scales from tens of meters to thousands of kilometers. It provides a flexible and computationally efficient platform while reflecting recent advances in physics, numerics, and data assimilation. The software can produce simulations based on actual atmospheric conditions or from idealized conditions.

WRF is used by academic atmospheric scientists (dynamics, physics, weather, and climate research), forecast teams at operational centers, and applications scientists (air quality, hydrology, and utilities).

## Why deploy WRF on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Performance that scales as CPUs are added, based on tests of a sample model

## Architecture

:::image type="content" source="guide/hpc/media/wrf/WRF_Multi_Node.svg" alt-text="Diagram that shows an architecture for deploying WRF." lightbox="guide/hpc/media/wrf/WRF_Multi_Node.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/hpc-weather-research-forecasting.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Linux VM. For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  - A public IP address connects the internet to the VM.
  - [Azure CycleCloud](https://azuremarketplace.microsoft.com/en-US/marketplace/apps/azurecyclecloud.azure-cyclecloud) is used to create the cluster in the multi-node configuration.
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


## WRF installation

Before you install WRF, you need to deploy and connect a Linux VM and install the required AMD and InfiniBand drivers.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

For deploying Azure CycleCloud and HPC cluster, see the below articles:

- [Install and configure Azure CycleCloud](https://learn.microsoft.com/en-us/training/modules/azure-cyclecloud-high-performance-computing/4-exercise-install-configure)
- [Create a HPC Cluster](https://learn.microsoft.com/en-us/training/modules/azure-cyclecloud-high-performance-computing/5-exercise-create-cluster)

#### Download and Compile WRF
1. Open the [WRF Portal](https://www2.mmm.ucar.edu/wrf/users/download/get_source.html) in a web browser and sign up to download WRF source code.
2. Configure and compile WRF. For detailed compiling folllow the steps provided in [here](https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php).
3. Configuring option for WRF: For the current performance tests, we have selected option 16 as shown below in the image

    :::code language="console" source="ddocs/guide/hpc/media/wrf/WRF-snip-1.console" highlight="7,25":::

4. Download static geographic data (for geogrid.exe) from [here](http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html).
5. For Real time cases, WRF model requires up-to-date meteorological information for both an initial condition and also for lateral boundary conditions. The real time data can be downloaded from [here](https://nomads.ncep.noaa.gov/).
Data used for current performance test: Date : 12-Feb-2023
Files:
- gfs.0p25.2023021200.f000.grib2
- gfs.0p25.2023021200.f003.grib2
- gfs.0p25.2023021200.f006.grib2
- gfs.0p25.2023021200.f009.grib2
- gfs.0p25.2023021200.f384.grib2
7. One must successfully run WPS, and create met_em. * file for more than one-time period and link or copy WPS output files to the WRF run directory. To run WPS refer the respective steps from [here](https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php).
8. Configuring option for WPS: For current performance test option 19 was selected as shown below

    :::code language="console" source="docs/guide/hpc/media/wrf/WRF-snip-2.console" highlight="22,45":::

9. WRF model (In current case CONUS 2.5 km) is defined by the namelist.input file which will have the model geometric details.
10. Edit namelist.input file for runtime options (at minimum, one must edit &time control for start, end and integration times, and &domains for grid dimensions).

## WRF performance results on Azure HPC Cluster

 The New CONUS 2.5 km model is used for performance evaluation:

 WRF model (In current case CONUS 2.5 km) is defined by the namelist.input file which will have the model geometric details.
 Edit the namelist.input file for runtime options (at minimum, one must edit *&time* control for start, end and integration times, and *&domains* for grid dimensions)

:::image type="content" source="media/wrf/new-conus-25-km-model.png" alt-text="Screenshot that shows the New CONUS 2.5 km model." border="false":::

The following table provides details about the model. 

|Model|	Resolution (km)|	e_we|	e_sn|	e_vert|	Total grid points|	Time step (seconds)|	Simulation hours|
|-|-|-|-|-|-|-|-|
|New CONUS 2.5 km	|2.5	|1901|	1301|	35	|2,473,201|	15|	6|

The following table shows the System and Operating System details:

|OS/Softwares| Details |
|-|-|
|Operating system version | CentOS Linux release 8.1.1911 (Core)|
|OS Architecture | X86-64|
|MPI|Open MPI 4.1.0|
|Compiler|icc (ICC) 2021.4.0|

Standard_HB120-64rs_v3 VM with 64 vCPUs is considerd for the cluster runs. The simulation was run on 1, 2, 4, 8 and 16 nodes and the results are shown in the table below.

|VM Size|Nodes|vCPU|Tiles|Threads|Simulation time (Hrs)|Mean time per step (s)|
|-|-|-|-|-|-|-|
|Standard_HB120-64rs_v3|1|64|325|1|02:11:30|4.94|
|Standard_HB120-64rs_v3|2|128|325|1|01:27:00|3.07|
|Standard_HB120-64rs_v3|4|256|325|1|00:59:01|1.86|
|Standard_HB120-64rs_v3|8|512|325|1|00:44:36|1.17|
|Standard_HB120-64rs_v3|16|1024|325|1|00:34:51|0.83|


The following graph shows the mean times per step, in seconds. 

:::image type="content" source="docs/guide/hpc/media/wrf/Multi-node-results.svg" alt-text="Graph that shows the mean times per step." border="false":::



### Additional notes about tests

1. WRF is successfully deployed and tested on HBv3 AMD EPYC™ 7V73X series VM on Azure Platform.
2. Expected meantime per step is achieved in all CPU cores in multi-node setup
3. However, the scalability might vary depending on the dataset being used and the node count being tested. Ensure that to test the impact of the tile size, process, and threads per process before use.



## Azure cost

The following table presents the wall-clock times for running the New CONUS 2.5 km simulation. You can multiply these times by the Azure VM hourly costs for HBv3-series VMs to calculate costs. For the current hourly costs, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

Only the simulation time is represented in these times. Application installation time isn't considered.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

|Number of Nodes|	Simulation time (hours)|
|-|-|
|1|02:11:30|		
|2|01:27:00|
|4|00:59:01|		
|8|00:44:36|		
|16|00:34:51|

## Summary

- WRF was successfully tested on HBv3-series series VMs on Azure.
- Expected mean time per step was achieved with all CPU configurations. However, scalability might vary depending on the dataset used and the node count. Be sure to test the effect of the tile size, process, and threads per process.
 
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
-   [Vivi Richard](https://www.linkedin.com/in/vivi-richard) | HPC Performance Engineer

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

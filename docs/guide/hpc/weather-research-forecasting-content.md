This article briefly describes the steps for running [Weather Research & Forecasting (WRF)](https://www.mmm.ucar.edu/models/wrf) on a virtual machine (VM) deployed on Azure. It also presents the performance results of running WRF on Azure.

WRF is a mesoscale numerical weather-prediction system designed for atmospheric research and operational forecasting applications.

WRF serves a wide range of meteorological applications across scales from tens of meters to thousands of kilometers. It provides a flexible and computationally efficient platform while reflecting recent advances in physics, numerics, and data assimilation. The software can produce simulations based on actual atmospheric conditions or from idealized conditions.

WRF is used by academic atmospheric scientists (dynamics, physics, weather, and climate research), forecast teams at operational centers, and applications scientists (air quality, hydrology, and utilities).

## Why deploy WRF on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Performance that scales as CPUs are added, based on tests of a sample model

## Architecture

:::image type="content" source="media/wrf/wrf-multi-node-architecture.svg" alt-text="Diagram that shows an architecture for deploying WRF." lightbox="media/wrf/wrf-multi-node-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/wrf-multi-node-architecture.vsdx) of this architecture.*

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

| Size | vCPU | RAM memory (GiB) | Memory bandwidth (GBps) | Base CPU frequency (GHz) | All-cores frequency (GHz, peak) | Single-core frequency (GHz, peak) | RDMA performance (Gbps) | Maximum data disks |
|-|-|-|-|-|-|-|-|-|
| Standard_HB120rs_v3 | 120 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-96rs_v3 | 96 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-64rs_v3 | 64 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-32rs_v3 | 32 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-16rs_v3 | 16 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |

HBv3-series VMs are optimized for HPC applications, such as:

- Fluid dynamics
- Explicit and implicit finite element analysis
- Weather modeling
- Seismic processing
- Reservoir simulation
- RTL simulation

### WRF installation

Before you install WRF, you must deploy and connect to a VM or HPC Cluster.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml). For deploying Azure CycleCloud and HPC cluster, see these articles:

- [Install and configure Azure CycleCloud](/training/modules/azure-cyclecloud-high-performance-computing/4-exercise-install-configure)
- [Create a HPC Cluster](/training/modules/azure-cyclecloud-high-performance-computing/5-exercise-create-cluster)

#### Download and compile WRF

1. Open the [WRF Portal](https://www2.mmm.ucar.edu/wrf/users/download/get_source.html) in a web browser and download the WRF source code.
1. Configure and compile WRF. For detailed compiling information, follow the steps at [How to Compile WRF: The Complete Process](https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php).
1. Configure options for WRF. For the current performance tests, we selected option 16 as shown here:

    :::image type="content" source="media/wrf/wrf-compilation-1.png" alt-text="Screenshot that shows first configuration option for WRF." border="false":::

1. Download static geographic data (for *geogrid.exe*) from the [WPS V4 Geographical Static Data Downloads Page](http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html).
1. Download real-time data from the [NOMADS Data at NCEP](https://nomads.ncep.noaa.gov/). For real-time cases, the WRF model requires up-to-date meteorological information for both an initial condition and also for lateral boundary conditions. The following data is used for the current performance test:

   - **Date**: 12-February-2023

   - **Files**:
     - gfs.0p25.2023021200.f000.grib2
     - gfs.0p25.2023021200.f003.grib2
     - gfs.0p25.2023021200.f006.grib2
     - gfs.0p25.2023021200.f009.grib2
     - gfs.0p25.2023021200.f384.grib2

1. Run WPS, create an `met_em.*` file for more than one time period, and link or copy WPS output files to the WRF run directory. To run WPS, follow the steps at [How to Compile WRF: The Complete Process](https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php).
1. Configure options for WRF. For the current performance test, option 19 was selected as shown here:

    :::image type="content" source="media/wrf/wrf-compilation-2.png" alt-text="Screenshot that shows second configuration option for WRF." border="false":::

1. Edit the *namelist.input* file for runtime options. At minimum, you must edit `&time` control for start, end, and integration times, and `&domains` for grid dimensions.

   The WRF model for this example is **CONUS 2.5 km** and is defined by the *namelist.input* file, which includes the model geometric details.

## WRF performance results on Azure HPC Cluster

 The New CONUS 2.5 km model is used for performance evaluation:

:::image type="content" source="media/wrf/new-conus-25-km-model.png" alt-text="Screenshot that shows the New CONUS 2.5 km model." border="false":::

The following table provides details about the model:

|Model| Resolution (km)| e_we| e_sn| e_vert| Total grid points| Time step (seconds)| Simulation hours|
|-|-|-|-|-|-|-|-|
|New CONUS 2.5 km |2.5 |1901| 1301| 35 |2,473,201| 15| 6|

The following table shows the system and operating system details:

| OS/Software | Details |
|-|-|
| Operating system version | CentOS Linux release 8.1.1911 (Core) |
| OS Architecture | X86-64 |
| MPI | Open MPI 4.1.0 |
| Compiler | ICC 2021.4.0 |

Standard_HB120-64rs_v3 VM with 64 vCPUs is considered for the cluster runs. The simulation was run on 1, 2, 4, 8 and 16 nodes and the results are shown in this table:

| VM Size | Nodes | vCPU | Tiles | Threads | Simulation time (Hrs) | Mean time per step (s) |
|-|-|-|-|-|-|-|
| Standard_HB120-64rs_v3 | 1 | 64 | 325 | 1 | 02:11:30 | 4.94 |
| Standard_HB120-64rs_v3 | 2 | 128 | 325 | 1 | 01:27:00 | 3.07 |
| Standard_HB120-64rs_v3 | 4 | 256 | 325 | 1 | 00:59:01 | 1.86 |
| Standard_HB120-64rs_v3 |8 | 512 | 325 | 1 | 00:44:36 | 1.17 |
| Standard_HB120-64rs_v3 |16 | 1024 | 325 | 1 | 00:34:51 | 0.83 |

The following graph shows the mean times per step, in seconds:

:::image type="content" source="media/wrf/cluster-meantime.png" alt-text="Graph that shows the mean times per step in seconds." border="false":::

### More notes about tests

1. WRF is successfully deployed and tested on HBv3 AMD EPYC™ 7V73X series VM on Azure Platform.
1. Expected meantime per step is achieved in all CPU cores in multi-node setup.
1. The scalability might vary depending on the dataset being used and the node count being tested. Consider these factors when you test the impact of the tile size, process, and threads per process.

## Azure cost

The following table presents the wall-clock times for running the New CONUS 2.5 km simulation. You can multiply these times by the Azure VM hourly costs for HBv3-series VMs to calculate costs. For the current hourly costs, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

Only elapsed solver running time (simulation run time) was considered for these cost calculations. Application installation time isn't considered.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

| Number of Nodes | Simulation time (hours) |
|-|-|
| 1 | 02:11:30 |
| 2 | 01:27:00 |
| 4 | 00:59:01 |
| 8 | 00:44:36 |
| 16 | 00:34:51 |

## Summary

- WRF was successfully tested on HBv3-series VMs on Azure.
- Expected mean time per step was achieved with all the nodes tested. However, scalability might vary depending on the dataset used and the node count. Be sure to test the effect of the tile size, process, and threads per process.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) | HPC Performance Engineer
- [Vivi Richard](https://www.linkedin.com/in/vivi-richard) | HPC Performance Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [GPU-optimized virtual machine sizes](/azure/virtual-machines/sizes-gpu)
- [Virtual machines on Azure](/azure/virtual-machines/overview)
- [Virtual networks and virtual machines on Azure](/azure/virtual-network/network-overview)
- [Learning path: Run high-performance computing (HPC) applications on Azure](/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
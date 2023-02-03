This article describes the steps for running the Computational Fluid Dynamics (CFD) software [ELEMENTS](https://engys.com/products/elements) on a Virtual Machine (VM) and a HPC cluster on Azure. It also presents the performance results of ELEMENTS  while running on single-node and multi-node VM configurations. 

Elements is a CFD and optimization software solution for vehicle design applications produced by Streamline Solutions LLC, a joint venture between [ENGYS](https://engys.com) and [Auto Research Center](http://www.arcindy.com). The simulation engine delivered with this tool is powered by [HELYX](https://engys.com/products/helyx) to offer a cost-effective solution that combines the best of automotive engineering design practices with the latest and most advanced open-source CFD and optimization methods developed by Engys, all within a unified, easy-to-use platform.

ELEMENTS was widely used and validated in the production environment to solve most flow related problems encountered in automotive design, including external vehicle aerodynamics, UHTM, HVAC and cabin comfort, aeroacoustics, powertrain, ICE, water management and soiling, among others. CFD methods available in ELEMENTS have also been successfully applied beyond automotive to analyze the aerodynamics performance of other vehicles and means of transportation, such as high-speed trains, motorbikes, and competition bicycles.

- **Evaluate vehicle designs more efficiently** using a completely new ribbon-based GUI layout focused on functional design.
- **Automate external vehicle aerodynamics calculations** using a virtual wind tunnel wizard with fully configurable best simulation practices, automatic report creation, added support for rotating tires/wheels, and new ride height and frontal area calculators.
- **Solve more complex engineering problems** with improved CFD methods and tools for UHMT, HVAC, in-cabin flows and aeroacoustics, including better volume meshing, faster and more stable solvers, added support for multi-region CHT, etc.
- **Leverage on-demand computing and cloud services** with a dedicated client-server framework for working remotely via secure network connections.
- **Improved usability and productivity** through powerful open-source CFD solvers and utilities developed and maintained by Engys.

## Why deploy ELEMENTS on Azure?

- Modern and diverse compute options to meet your workload's needs.
- The flexibility of virtualization without the need to buy and maintain physical hardware.
- Rapid provisioning.
- Complex problems solved within a few hours.

## Architecture

Multi-node configuration:

image 

link 

Single-node configuration:

image

link 

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Linux and Windows VMs. 
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud. 
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VMs.  
  - A public IP address connects the internet to the VM.   
- [Azure CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud) is used to create the cluster in the multi-node configuration.
- A physical SSD is used for storage.  

## Compute sizing and drivers

Performance tests of ELEMENTS on Azure used [HBv3 AMD EPYC 7V73X](/azure/virtual-machines/hbv3-series) (Milan-X) VMs running Linux CentOS Operating system.  The following table provides details about HBv3-series VMs.

|VM size|	vCPU|	Memory (GiB)|	Memory bandwidth GBps|	Base CPU frequency (GHz)|	All-cores frequency (GHz, peak)|	Single-core frequency (GHz, peak)|	RDMA performance (Gbps)|Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3	|120	|448|	350|	1.9|	3.0|	3.5|	200|	32|
|Standard_HB120-96rs_v3|	96|	448|	350|	1.9|	3.0|	3.5|	200|	32|
|Standard_HB120-64rs_v3|	64|	448|	350|	1.9	|3.0|	3.5|	200|	32|
|Standard_HB120-32rs_v3|	32|	448|	350|	1.9|	3.0|	3.5|	200|	32|
|Standard_HB120-16rs_v3|	16	|448|	350|1.9|3.0|3.5|200|32|

### Required drivers

To use AMD CPUs on [HBv3 VMs](/azure/virtual-machines/hbv3-series), you need to install AMD drivers.

To use InfiniBand, you need to enable [InfiniBand drivers](/azure/virtual-machines/workloads/hpc/enable-infiniband).

## Install ELEMENTS 3.5.0 on a VM and HPC Cluster

The software ELEMENTS must be purchased from Engys or one of their local authorized distributors/agents to get the installation files and technical support with the application. ContactEngys if you interested in buying [ELEMENTS](https://engys.com/products/elements).

Before you install ELEMENTS, you need to deploy and connect a VM or HPC Cluster.

For information about deploying the VM and installing the drivers, see one of these articles:

- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)

For information about deploying the Azure CycleCloud and HPC cluster, see below articles:

- [Install and configure Azure CycleCloud](/learn/modules/azure-cyclecloud-high-performance-computing/4-exercise-install-configure)
- [Create a HPC Cluster](/learn/modules/azure-cyclecloud-high-performance-computing/5-exercise-create-cluster)

## ELEMENTS 3.5.0 Performance Results

### Test Models

Two vehicle models were considered for testing the parallel scalability performance of ELEMENTS version 3.5.0 on Azure, namely:

- [DrivAer](https://www.epc.ed.tum.de/en/aer/research-groups/automotive/drivaer) sedan model (mid-size computational grid) external vehicle aerodynamics.
- Generic Truck Utility ([GTU](https://www.ecara.org/driveaer/gtu)) model (large computational grid) external vehicle aerodynamics.

All the computational grids were created in parallel as part of the execution process using the hex-dominant meshing utility provided with ELEMENTS.  

The details of each test model are shown below: 

#### Model 1 – Automotive_DESdrivAer

image 

Model Details

|Mesh Size	|Solver|Transient|
|-|-|-|
|17,000,000 cells|	DES (helyxAero)|400 time steps|

#### Model 2 – Automotive_GTU-0001

image 

Model Details

|Mesh Size	|Solver|Transient|
|-|-|-|
|116,000,000 cells|	DES (helyxAero)|3,583 time steps|

### ELEMENTS 3.5.0 Performance Results on Single-Node VM

The performance results achieved running ELEMENTS in parallel on single-node Azure [HBv3 AMD EPYC™ 7V73X](/azure/virtual-machines/hbv3-series) (Milan-X) VMs are presented below as baseline for comparing with multi-node runs. Only Model 1 was considered for single-node tests.

#### Model 1 - Automotive_DESdrivAer

|Number of cores|Total Solver time in seconds|Relative Solver Speedup|
|-|-|-|
|16|	3,102.28|	1.00|
|32|	1,938.16|	1.60|
|64|	1,395.36|	2.22|
|96|	1,337.25|	2.32|
|120|	1,318.55|	2.35|

The below chart shows the relative speedup of Automotive DESdrivAer model on HBv3 single nodes

graph

#### Additional notes about Single-Node Tests 

For all single-node tests we have taken the solver time on HB120-16rs_v3 (16 cores) as the reference to calculate the relative speed up with respect to other similar VMs with more cores. The results for Model 1 presented above show that parallel performance in ELEMENTS improves as we increase from 16 to 64 cores, then above 64 cores no further scalability is attained. This is a common occurrence with CFD solvers and other memory intensive applications due to the saturation of the onboard memory available on each processor.

The AMD EPYC™ 7V73-series (Milan-X) featured in the Azure HBv3 VMs tested here is a very capable processor with 768MB of total L3 cache. Our single-node tests confirm that this memory is sufficient to guarantee parallel scalability of the ELEMENTS solvers when using half the cores available on each 7V73-series chip.

### ELEMENTS 3.5.0 Performance Results on Multi-Node (Cluster)

The single-node tests carried out with ELEMENTS confirmed that the solver exhibits proper parallel performance when using up to 64 cores with HBv3 VMs. Therefore, we employed only 64 cores to evaluate the performance of ELEMENTS with [Standard_HB120-64rs_v3](/azure/virtual-machines/hbv3-series) when testing multi-node (cluster) configurations. The results are shared below for each test case considered in this study: 

#### Model 1 - Automotive_DESdrivAer

|Number of Nodes|Number of cores|Cells per Core|Total Solver time in seconds|Relative Solver Speedup|
|-|-|-|-|-|
|1|	64|	265,625|	1,370.81|	1.00|
|2|	128|	132,813|	630.86|	2.17|
|4|	256	|66,406|	351.83	|3.90|
|8|	512	|33,203|	206.36|	6.64|
|16|	1,024	|16,602	|168.07|	8.16|

The below chart shows the relative speedup of Automotive DESdrivAer model on HBv3 cluster

graph 

#### Model 2 - Automotive_GTU-0001

|Number of Nodes|Number of cores|Cells per Core|Total Solver time in seconds|Relative Solver Speedup|
|-|-|-|-|-|
|1|	64|	 1,812,500	|102,740.23|	1.00|
|2|	128|	 906,250|	47,761.85|	2.15|
|4|	256	| 453,125	|21,484.47	|4.78|
|8|	512	| 226,563	|9,595.72|	10.71|
|16|	1,024	| 113,281	|5,125.38|	20.05|

The below chart shows the relative speedup of Automotive DESdrivAer model on HBv3 cluster

graph 

#### Additional notes about Multi-Node Tests 

The multi-node performance tests for Model 1 (mid-size mesh) show that the parallel scalability of ELEMENTS in this particular case is appropriate, albeit below optimal. This suboptimal performance can be explained by the relatively low number of cells per core employed when running with 8 and 16 nodes. Solver performance is known to be reduced due to excessive data communication between processor boundaries when the number of cells count per core is low.

By contrast, the results for Model 2 (large mesh) confirm that solver scalability is outstanding and above optimal. The number of cells per core in this case never drops below 100,000, even when using 16 nodes. This is encouraging because most real-life CFD external vehicle aerodynamic models feature 100 million cells or more. 

## Azure cost

Only solver time has been considered for the cost calculations. Meshing times, installation time and software costs have been ignored.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the VM costs for your configurations.

The following tables provide the solver times in hours. The Azure VM hourly rates are subject to change. To compute the cost, multiply the solver time by the number of nodes and the Azure VM hourly cost which you can find [here for Windows]()  and  [here for Linux](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

### Cost for Model 1 - Automotive_DESdrivAer

|Number of Nodes|	Solver time (Hr)|
|-|-|
|1|	0.458|
|2|	0.256|
|4|	0.168|
|8|	0.148|
|16	|0.162|

### Cost for Model 2 - Automotive_GTU-0001

|Number of Nodes|	Solver time (Hr)|
|-|-|
|1| 28.888|
|2|	 13.622|
|4|	 6.249|
|8|	 2.990|
|16	| 1.761|

## Summary

- ELEMENTS 3.5.0 was successfully tested on Azure using HBv3 standalone Virtual Machines and Azure Cycle Cloud multi-node (cluster) configurations.
- All external vehicle aerodynamics models tested demonstrated good CPU acceleration when running in multi-node configurations.
- The meshing, setup and solver applications in ELEMENTS can all be run in parallel, thus making this CFD tool ideal for execution in multi-node configurations (no need for mesh decomposition/reconstruction).
- The simulation engine delivered with ELEMENTS is open source, which means users can run as many simulations in as many processors as needed without incurring additional license costs. This is particularly useful when performing DES-type external aerodynamic calculations.
- For better parallel performance when running DES-type calculations with ELEMENTS we recommend using 64 cores per HBv3 node and a minimum of 50,000 cells per core.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:
- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
 
Other contributors:
- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [GPU Optimized Virtual Machine Sizes](/azure/virtual-machines/sizes-gpu)
- [Windows Virtual Machines in Azure](/azure/virtual-machines/windows/overview)
- [Virtual networks and virtual machines on Azure](/azure/virtual-network/network-overview)
- [Learning path: Run high-performance computing (HPC) applications on Azure](/training/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [Run a Windows VM on Azure]()
- [HPC system and big-compute solutions]()
- [HPC cluster deployed in the cloud]()

This article describes the steps for running [Engys ELEMENTS](https://engys.com/products/elements) on a virtual machine (VM) and on an HPC cluster on Azure. It also presents the performance results of running ELEMENTS on single-node and multi-node VM configurations. 

ELEMENTS is a computational fluid dynamics (CFD) and optimization solution for vehicle design applications. The simulation engine that's provided with ELEMENTS is powered by [HELYX](https://engys.com/products/helyx). The resulting solution combines automotive engineering design practices with open-source CFD and optimization methods developed by Engys.

ELEMENTS is used to solve flow-related problems that are encountered in automotive design, including external vehicle aerodynamics, UHTM, HVAC and cabin comfort, aeroacoustics, powertrain, ICE, water management, and soiling. ELEMENTS is also used to analyze the aerodynamics of other vehicles, like high-speed trains, motorcycles, and competition bicycles.

## Why deploy ELEMENTS on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Complex problems solved within a few hours

## Architecture

Multi-node configuration:

:::image type="content" source="media/elements-cluster-architecture.png" alt-text="Diagram that shows an architecture for running ELEMENTS in a multi-node configuration." lightbox="media/elements-cluster-architecture.png" border="false":::

Download a [Visio file](https://arch-center.azureedge.net/elements-cluster-architecture.vsdx) of this architecture.

Single-node configuration:

:::image type="content" source="media/elements-architecture.png" alt-text="Diagram that shows an architecture for running ELEMENTS in a single-node configuration." lightbox="media/elements-architecture.png" border="false":::

Download a [Visio file](https://arch-center.azureedge.net/elements-architecture.vsdx) of this architecture.

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Linux VMs. 
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud. 
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to control access to the VMs.  
  - A public IP address connects the internet to the VM.   
- [Azure CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud) is used to create the cluster in the multi-node configuration.
- A physical SSD provides storage.  

## Compute sizing and drivers

Performance tests of ELEMENTS on Azure used [HBv3 AMD EPYC 7V73X (Milan-X)](/azure/virtual-machines/hbv3-series) VMs running Linux CentOS. The following table provides details about HBv3-series VMs.

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

## Install ELEMENTS 3.5.0 on a VM or HPC cluster

You need to buy ELEMENTS from Engys or one of its local authorized distributors or agents to get the installation files and technical support. For information about buying [ELEMENTS](https://engys.com/products/elements), contact Engys.

Before you install ELEMENTS, you need to deploy and connect a VM or HPC cluster.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

For information about deploying the Azure CycleCloud and HPC cluster, see these articles:

- [Install and configure Azure CycleCloud](/learn/modules/azure-cyclecloud-high-performance-computing/4-exercise-install-configure)
- [Create an HPC cluster](/learn/modules/azure-cyclecloud-high-performance-computing/5-exercise-create-cluster)

## ELEMENTS 3.5.0 performance results

Two vehicle models were used to test the parallel scalability performance of ELEMENTS 3.5.0 on Azure:

- The [DrivAer](https://www.epc.ed.tum.de/en/aer/research-groups/automotive/drivaer) sedan model (mid-size computational grid) for external vehicle aerodynamics
- The [Generic Truck Utility (GTU)](https://www.ecara.org/driveaer/gtu) model (large computational grid) for external vehicle aerodynamics

The hex-dominant meshing utility that's provided with ELEMENTS was used to create all computational grids. They were created in parallel as part of the execution process.

The details of each test model are provided in the following sections. 

### Model 1: Automotive_DESdrivAer

:::image type="content" source="media/drivaer-model.png" alt-text="Screenshot that shows the DrivAer model." :::

The following table provides details about the model.

|Mesh size	|Solver|Transient|
|-|-|-|
|17,000,000 cells|	DES (helyxAero)|400 time steps|

### Model 2: Automotive_GTU-0001

:::image type="content" source="media/generic-truck-utility-model.png" alt-text="Screenshot that shows the GTU model." :::
 
The following table provides details about the model.

|Mesh size	|Solver|Transient|
|-|-|-|
|116,000,000 cells|	DES (helyxAero)|3,583 time steps|

### ELEMENTS 3.5.0 performance results on single-node VMs

The following section provides the performance results of running ELEMENTS in parallel on single-node Azure [HBv3 AMD EPYC 7V73X (Milan-X)](/azure/virtual-machines/hbv3-series) VMs. You can use these results as a baseline for comparison with multi-node runs. Only the DrivAer model was tested in single-node configurations.

#### Model 1: Automotive_DESdrivAer

|Number of cores|Solver running time (seconds)|Relative speed increase|
|-|-|-|
|16|	3,102.28|	1.00|
|32|	1,938.16|	1.60|
|64|	1,395.36|	2.22|
|96|	1,337.25|	2.32|
|120|	1,318.55|	2.35|

The following graph shows the relative speed increases as the number of CPUs increases:

:::image type="content" source="media/drivaer-graph.png" alt-text="Graph that shows the relative speed increases on a single-node configuration." lightbox="media/drivaer-graph.png" border="false":::

#### Notes about single-node tests 

For all single-node tests, the solver running time on a Standard_HB120-16rs_v3 VM (16 cores) is used as a reference to calculate the relative speed increase with respect to similar VMs that have more cores. The previously presented results for the DrivAer model show that parallel performance in ELEMENTS improves as cores increase from 16 to 64. Above 64 cores, no further improvement occurs. This pattern is common with CFD solvers and other memory-intensive applications because of saturation of the onboard memory that's available on each processor.

The AMD EPYC 7V73-series processor (Milan-X) in the HBv3 VMs tested here is a powerful processor, with 768 MB of total L3 cache. The single-node tests confirm that this memory is sufficient to guarantee parallel scalability of the ELEMENTS solvers when you use half the cores available on each 7V73-series chip.

### ELEMENTS 3.5.0 performance results on multi-node clusters

The single-node tests confirm that the solver achieves good parallel performance until you reach 64 cores with HBv3 VMs. Based on those results, only 64-core configurations on [Standard_HB120-64rs_v3](/azure/virtual-machines/hbv3-series) were used to evaluate the performance of ELEMENTS on multi-node clusters. The following sections provide the test results.

#### Model 1: Automotive_DESdrivAer

|Number of nodes|Number of cores|Cells per core|Solver running time (seconds)|Relative speed increase|
|-|-|-|-|-|
|1|	64|	265,625|	1,370.81|	1.00|
|2|	128|	132,813|	630.86|	2.17|
|4|	256	|66,406|	351.83	|3.90|
|8|	512	|33,203|	206.36|	6.64|
|16|	1,024	|16,602	|168.07|	8.16|

The following graph shows the relative speed increases as the number of nodes increases:

:::image type="content" source="media/drivaer-graph-cluster.png" alt-text="Graph that shows the relative speed increases on a multi-node configuration." lightbox="media/drivaer-graph-cluster.png" border="false":::

#### Model 2: Automotive_GTU-0001

|Number of nodes|Number of cores|Cells per core|Solver running time (seconds)|Relative speed increase|
|-|-|-|-|-|
|1|	64|	 1,812,500	|102,740.23|	1.00|
|2|	128|	 906,250|	47,761.85|	2.15|
|4|	256	| 453,125	|21,484.47	|4.78|
|8|	512	| 226,563	|9,595.72|	10.71|
|16|	1,024	| 113,281	|5,125.38|	20.05|

The following graph shows the relative speed increases as the number of nodes increases:

:::image type="content" source="media/truck-graph-cluster.png" alt-text="Graph that shows the relative speed increases for the GTU model on a multi-node configuration." lightbox="media/truck-graph-cluster.png" border="false":::
 
#### Notes about multi-node tests

The multi-node performance tests for the DrivAer model (mid-size mesh) show that the parallel performance improves as the number of nodes increases but is less than optimal. This suboptimal performance can be explained by the relatively low number of cells per core in 8-node and 16-node configurations. Solver performance is known to be reduced by excessive data communication between processor boundaries when the number of cells per core is low.

In contrast, the results for the GTU model (large mesh) show that solver scalability is above optimal. The number of cells per core in this case never drops below 100,000, even in 16-node configurations. These results are encouraging because most real-life CFD external vehicle aerodynamic models have 100 million cells or more. 

## Azure cost

Only solver running time is considered for these cost calculations. Meshing times, installation time, and software costs aren't considered.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the VM costs for your configurations.

The following tables provide the solver running times in hours. Azure VM hourly rates are subject to change. To compute the cost, multiply the solver time by the number of nodes and the [Linux VM hourly cost](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

### Cost for model 1: Automotive_DESdrivAer

|Number of nodes|	Solver running time (hours)|
|-|-|
|1|	0.458|
|2|	0.256|
|4|	0.168|
|8|	0.148|
|16	|0.162|

### Cost for model 2: Automotive_GTU-0001

|Number of nodes|	Solver running time (hours)|
|-|-|
|1| 28.888|
|2|	 13.622|
|4|	 6.249|
|8|	 2.990|
|16	| 1.761|

## Summary

- ELEMENTS 3.5.0 was successfully tested on HBv3 standalone VMs and on an Azure CycleCloud multi-node configuration.
- All  external vehicle aerodynamics models that were tested demonstrate good CPU acceleration when running in multi-node configurations.
- The meshing, setup, and solver applications in ELEMENTS can be run in parallel, which makes it ideal for running in multi-node configurations. (There's no need for mesh decomposition and reconstruction.)
- The simulation engine that's provided with ELEMENTS is open source, so you can run as many simulations in as many processors as you need, without incurring additional license costs. This capability is particularly useful when you're performing DES-type external aerodynamic calculations.
- For better parallel performance when you run DES-type calculations by using ELEMENTS, we recommend that you use 64 cores per HBv3 node and a minimum of 50,000 cells per core.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:
- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
 
Other contributors:
- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director, Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [GPU-optimized virtual machine sizes](/azure/virtual-machines/sizes-gpu)
- [Virtual machines on Azure](/azure/virtual-machines/windows/overview)
- [Virtual networks and virtual machines on Azure](/azure/virtual-network/network-overview)
- [Learning path: Run HPC applications on Azure](/training/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)

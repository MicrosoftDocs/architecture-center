This article briefly describes the steps for running [Ansys CFX](https://www.ansys.com/products/fluids/ansys-cfx) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running Ansys CFX on Azure.

Ansys CFX is computational fluid dynamics (CFD) software for turbomachinery applications. It uses an equilibrium phase change model and relies on material properties to reliably predict cavitation without the need for empirical model parameters. CFX:

- Uses transient blade row methods to reduce geometry from a full wheel to a single passage.
- Integrates with Geolus Shape Search to rapidly find parts that are identical to a specified part, based on geometry.

CFX is used in the aerospace, defense, steam turbine, energy, automotive, construction, facilities, manufacturing, and materials/chemical processing industries.

## Why deploy Ansys CFX on Azure?

- Modern and diverse compute options to align to your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Multi-node deployment as much as 17 times faster than single-node deployment

## Architecture

Single-node configuration:

:::image type="content" source="media/cfx/ansys-cfx.svg" alt-text="Diagram that shows an architecture for deploying Ansys CFX on Single Node." lightbox="media/cfx/ansys-cfx.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/ansys-cfx.vsdx) of this
architecture.*

Multi-node configuration:

:::image type="content" source="media/cfx/hpc-ansys-cfx-multi-node.svg" alt-text="Diagram that shows an architecture for deploying Ansys CFX on Multi Node." lightbox="media/cfx/ansys-cfx.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/ansys-cfx.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Linux VM. 
  - For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud. 
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  -  A public IP address connects the internet to the VM.
- [Azure CycleCloud](https://azuremarketplace.microsoft.com/en-US/marketplace/apps/azurecyclecloud.azure-cyclecloud) is used to create the cluster in the multi-node configuration.
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

Performance tests of Ansys CFX on Azure used [HBv3-series](/azure/virtual-machines/hbv3-series) VMs running Linux. The following table provides the configuration details.

|VM size| vCPU| Memory (GiB) |Memory bandwidth (GBps) |Base CPU frequency (Ghz)| All-cores frequency (Ghz, peak)| Single-core frequency (Ghz, peak)| RDMA performance (Gbps) |Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3| 120| 448| 350| 2.45| 3.1| 3.675| 200| 32|
|Standard_HB120-96rs_v3| 96| 448| 350| 2.45| 3.1| 3.675 |200| 32|
|Standard_HB120-64rs_v3 |64 |448 |350| 2.45| 3.1| 3.675| 200| 32|
|Standard_HB120-32rs_v3 |32 |448 |350| 2.45| 3.1| 3.675| 200 |32|
|Standard_HB120-16rs_v3 |16| 448 |350| 2.45| 3.1| 3.675| 200 |32|

 

## Install Ansys CFX on a VM or HPC Cluster

The software can be downloaded from [Ansys CFX](https://www.ansys.com/products/fluids/ansys-cfx#tab1-2) Official website. For more details use this [link](https://www.ansys.com/products/fluids/ansys-cfx).

Before you install Ansys CFX, you need to deploy and connect to a VM or HPC Cluster.
For information about deploying the VM and installing the drivers, see one of these articles:
- [Run a Windows VM on Azure](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/windows-vm)
- [Run a Linux VM on Azure](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm)

For information about deploying the Azure CycleCloud and HPC cluster, see below articles:
- [Install and configure Azure CycleCloud](https://learn.microsoft.com/en-us/training/modules/azure-cyclecloud-high-performance-computing/4-exercise-install-configure)
- [Create a HPC Cluster](https://learn.microsoft.com/en-us/training/modules/azure-cyclecloud-high-performance-computing/5-exercise-create-cluster).

## CFX performance results

 CFD analysis was performed in these tests. Ansys CFX 2021 R2 and 2022 R2 were tested. The following table provides the details of the VM that was used for testing.

|System/Software Details |HBv3(Milan)|HBv3(Milan-X)|
|-|-|-|
|Operating system version|Centos based 8.1 HPC Gen_2|Centos based 8.1 HPC Gen_2|
|OS Architecture|X86-64|X86-64|
|Processor|AMD EPYC 7V13|AMD EPYC 7V73X|

Many factors can influence HPC scalability, including the mesh size, element type, mesh topology, and physical models. To get meaningful and case-specific benchmark results, it's best to use the standard HPC benchmark cases that are available on the [Ansys Customer Portal](https://support.ansys.com/Home/HomePage).

The following models were tested. For more information about the current Ansys models, see [Ansys Engineering Simulation Solutions](https://fluidcodes.com/softwares/ansys/). 

### 1. Pump

:::image type="content" source="media/cfx/pump.png" alt-text="Figure that shows the pump model." border="false":::

- Case Details:
 
  a)	Automotive pump with rotating and stationary components
 
  - Turbulent k-e, incompressible, isothermal, multiple frames of reference.
  - Advection- scheme: specified blend factor 0.75.

  b)	Global mesh size: 1,305,718 Nodes, 5362055 Elements Tetrahedra-4, 509, 881, Prisms-850, 617, Pyramids-1557
  
- Benchmark Information:

  a)	Suitable up to ~16 cores
  
  b)	Currently set to 10 iterations
  
  c)	Solver memory requirement (total) ~3 GB


### 2. Airfoil 10M

:::image type="content" source="media/cfx/airfoil.png" alt-text="Figure that shows the airfoil model." border="false":::

- Case Details:
 
  a)	Transonic flow around an Airfoil. Flow is 2D ¬ the mesh is extruded to give   a 3D meshes of various sizes
 
  - Turbulent SST, ideal gas, heat transfer. 
  - Default advection scheme (high resolution)

  b)	Global mesh size: 9,933,000 nodes, 9,434,520 elements.
  
- Benchmark Information:

  a)	Suitable for up to ~50 partitions.
  
  b)	Currently set to 5 iterations
  
  c)	Partitioning memory requirement 1.7 GB

  d)    Solver memory requirement (total) 13 GB

### 3. Airfoil 50M


- Case Details:
 
  a)	Transonic flow around an Airfoil. Flow is 2D ¬ the mesh is extruded to give   a 3D meshes of various sizes
 
  - Turbulent SST, ideal gas, heat transfer. 
  - Default advection scheme (high resolution)

  b)	Global mesh size: 47,773,000 nodes, 47,172,600 elements
  
- Benchmark Information:

  a)	Suitable for up to >100 partitions.
  
  b)	Currently set to 5 iterations
  
  c)	Partitioning memory requirement ~13 GB

  d)    Solver memory requirement (total) ~65 GB


### 4. Airfoil 100M


- Case Details:
 
  a)	Transonic flow around an Airfoil. Flow is 2D ¬ the mesh is extruded to give   a 3D meshes of various sizes
 
  - Turbulent SST, ideal gas, heat transfer. 
  - Default advection scheme (high resolution)

  b)	Global mesh size: 104,533,000 nodes, 103,779,720 elements (all hexahedra)
  
- Benchmark Information:

  a)	Suitable for 100s ¬or 1000s of partitions 
  
  b)	Currently set to 5 iterations
  
  c)	Partitioning memory requirement ~28 GB

  d)    Solver memory requirement (total) ~140 GB


### Ansys CFX 2021 R2 Performance results on single-node configuration

The following table and graph show elapsed wall-clock times and relative speed increases for the pump model.

|Model| Iterations |Cores| CFD solver wall-clock time (seconds)| Relative speed increase|
|-|-|-|-|-|
|perf_Pump_R16| 10| 16| 32.59| 1.00|
|perf_Pump_R16| 10|32 |20.48| 1.59|
|perf_Pump_R16| 10|64| 16.19 |2.01|
|perf_Pump_R16| 10|96 |16.85| 1.93|
|perf_Pump_R16| 10|120| 18.00 |1.81|

:::image type="content" source="media/cfx/pump-graph.png" alt-text="Graph that shows the relative speed increases as the number of CPUs increases." border="false":::

The following table and graph show elapsed wall-clock times and relative speed increases for the airfoil model, with a mesh size of 10 million.

|Model| Iterations |Cores| CFD solver wall-clock time (seconds)| Relative speed increase|
|-|-|-|-|-|
|perf_Airfoil_10M_R16|5|16| 149.40| 1.00|
|perf_Airfoil_10M_R16|5|32| 113.05 |1.32|
|perf_Airfoil_10M_R16|5|64| 113.87 |1.31|
|perf_Airfoil_10M_R16|5|96| 121.71 |1.23|
|perf_Airfoil_10M_R16|5|120| 125.10| 1.19|

:::image type="content" source="media/cfx/graph-airfoil-10m.png" alt-text="Graph that shows the relative speed increases for the 10M airfoil." border="false":::

The following table and graph show elapsed wall-clock times and relative speed increases for the airfoil model, with a mesh size of 50 million.

|Model| Iterations |Cores| CFD solver wall-clock time (seconds)| Relative speed increase|
|-|-|-|-|-|
|perf_Airfoil_50M_R16|5|16| 861.34| 1.00|
|perf_Airfoil_50M_R16|5|32| 627.99 |1.37|
|perf_Airfoil_50M_R16|5|64| 573.76 |1.50|
|perf_Airfoil_50M_R16|5|96| 616.32 |1.40|
|perf_Airfoil_50M_R16|5|120|646.07| 1.33|

:::image type="content" source="media/cfx/graph-airfoil-50m.png" alt-text="Graph that shows the relative speed increases for the 50M airfoil." border="false":::

The following table and graph show elapsed wall-clock times and relative speed increases for the airfoil model, with a mesh size of 100 million.

|Model| Iterations |Cores| CFD solver wall-clock time (seconds)| Relative speed increase|
|-|-|-|-|-|
|perf_Airfoil_100M_R16|5|16|2029.20 | 1.00|
|perf_Airfoil_100M_R16|5|32|1541.70 |1.32|
|perf_Airfoil_100M_R16|5|64|1445.70 |1.40|
|perf_Airfoil_100M_R16|5|96|1451.70|1.40|
|perf_Airfoil_100M_R16|5|120|1473.70 |1.05|

:::image type="content" source="media/cfx/graph-airfoil-100m.png" alt-text="Graph that shows the relative speed increases for the 100M airfoil." border="false":::

### Ansys CFX 2021 R2 and 2022 R2 Performance on Multi-Nodes

Based on the single node results, we decided the configuration for cluster. The single node tests were carried out using AMD Milan Processors. For cluster runs, we used Milan-X AMD processors which are the latest updated version of AMD EPYC Series Processors. 

As the single-node results show, scalability improves as the number of cores increases. Because memory bandwidth is fixed on a single node, performance saturates after a certain number of cores is reached. A multi-node configuration surpasses this limitation to fully take advantage of the CFX solver capabilities.

Based on the single-node tests, the 64-CPU configuration is optimal. It's also less expensive than 96-CPU and 120-CPU configurations. The Standard_HB120-64rs_v3 VM with 64 CPUs was used for the multi-node tests.

To utilize the benefits of these latest processors for CFX simulations, we carried out multi-node runs on the Milan-X processors and compared the results between 2021R2 and 2022R2 versions.

1.	Pump: Assembly of stator and rotor

|Number of nodes|Number of vCPUs| CFD solver wall clock Time (s) 2021R2| CFD solver wall clock Time (s) 2022R2|Speed Up  2021R2|Speed Up 2022R2|% Improvement in solver time|
|-|-|-|-|-|-|-|
|1|	64|	11.36|	12.37|	1.00|	0.92|	-8.85%|
|2|	128|	6.56|	7.256|	1.73|	1.57|	-10.61%|
|4|	256|	3.88|	4.271|	2.93|	2.66|	-10.08%|
|8|512|	2.97|	2.585|	3.82|	4.39|	12.96%|
|16|	1024|	2.22|	2.206|	5.12|	5.15|	0.63%|


:::image type="content" source="media/cfx/graph-pump-cmpr-multi-node.png" alt-text="Graph that shows the relative speed increases for pump model, using the multi-node configuration." border="false":::

2.	Airfoil with 10M mesh size

|Number of nodes|Number of vCPUs| CFD solver wall clock Time (s) 2021R2| CFD solver wall clock Time (s) 2022R2|Speed Up  2021R2|Speed Up 2022R2|% Improvement in solver time|
|-|-|-|-|-|-|-|
|1|	64|	70.03|	72.19|	1.00|	0.97|	-3.09%|
|2|	128|	35.54|	37.87|	1.97|	1.85|	-6.56%|
|4|256|	20.71|	17.80|	3.38|	3.94|	14.07%|
|8|	512|	15.12|	10.28|	4.63|	6.81|	31.99%|
|16|	1024|	9.4|	9.79|	7.45|	7.16|	-4.11%|


:::image type="content" source="media/cfx/graph-airfoil-10m-multi-node.png" alt-text="Graph that shows the relative speed increases for 10M airfoil, using the multi-node configuration." border="false":::

3.	Airfoil with 50M mesh size

|Number of nodes|Number of vCPUs| CFD solver wall clock Time (s) 2021R2| CFD solver wall clock Time (s) 2022R2|Speed Up  2021R2|Speed Up 2022R2|% Improvement in solver time|
|-|-|-|-|-|-|-|
|1|	64|	371.33|	373.15|	1.00|	1.00|	-0.49%|
|2|	128|	184.35|	201.23|	2.01|	1.85|	-9.16%|
|4|	256|	91|	94.24|	4.08|	3.94|	-3.56%|
|8|	512|	71.84|	47.90|	5.17|	7.75|	33.33%|
|16|	1024|	37.69|	39.30|	9.85|	9.45|	-4.26%|


:::image type="content" source="media/cfx/graph-airfoil-50m-multi-node.png" alt-text="Graph that shows the relative speed increases for 50M airfoil, using the multi-node configuration." border="false":::

4.	Airfoil with 100M mesh size  

|Number of nodes|Number of vCPUs| CFD solver wall clock Time (s) 2021R2| CFD solver wall clock Time (s) 2022R2|Speed Up  2021R2|Speed Up 2022R2|% Improvement in solver time|
|-|-|-|-|-|-|-|
|1|	64|	1139|	1146.40|	1.00|	0.99|	-0.65%|
|2|	128|	439.92|	473.65|	2.59|	2.40|	-7.67%|
|4|	256|	208.92|	211.07|	5.45|	5.40|	-1.03%|
|8|	512|	104|	106.35|	10.95|	10.71|	-2.26%|
|16|	1024|	83.38|	84.34|	13.66|	13.50|	-1.16%|

:::image type="content" source="media/cfx/graph-100m-airfoil-multi-node.png" alt-text="Graph that shows the relative speed increases for 100M airfoil, using the multi-node configuration." border="false":::

## Azure cost

The following tables provide wall clock times that you can use to calculate Azure costs. To compute the cost, multiply the wall clock time by the number of nodes and the Azure VM hourly rate. For the hourly rates for Linux, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/#pricing). Azure VM hourly rates are subject to change.
Only simulation running time is considered for the cost calculations. Installation time, simulation setup time, and software costs aren't included. The time shown below in hours is the combined wall clock time for all the models.


You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate VM costs for your configuration.

### Cost for Ansys CFX 2021R2

|Number of Nodes| Number of vCPUs|  Hours|
|-|-|-|
|1 |64| 0.44|
|2 |128 | 0.18|
|4 |256 | 0.09|
|8| 512| 0.053|
|16| 1024 |0.036|

### Cost for Ansys CFX 2022R2

| Number of nodes| Number of vCPUs | Hours|
|-|-|-|
 |1|64| 0.45|
 |2|128| 0.20|
 |4|256| 0.09|
 |8|512| 0.05|
 |16|1,024|0.04|

## Summary

Ansys CFX Application 2021 R2 and 2022 R2 both are successfully deployed and tested on HBv3 120 AMD EPYC™ 7V73X-series (Milan-X) Azure Virtual Machines.

1.	In case of single node configuration, it is observed that there is a relative speed increase up to 64 cores and there after it is saturated with further increase of cores.
2.	In case of multi-node runs, with sufficiently large models, Ansys CFX is scaling up linearly with increase in number of nodes.
3.	A Relative speed increase of ~13.5 times is achieved with multi-node setup (16 nodes) for a considerably bigger model (100 million cells) which is a very good performance indicator for Ansys CFX on Azure HBv3 Virtual Machines
4.	The Performance comparison between the CFX versions 2021 R2 and 2022 R2 is shown in this report.



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
-   [Virtual machines on Azure](/azure/virtual-machines/overview)
-   [Virtual networks and virtual machines on
    Azure](/azure/virtual-network/network-overview)
-   [Learning path: Run high-performance computing (HPC) applications on
    Azure](/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

-   [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
-   [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)

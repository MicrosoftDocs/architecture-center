This article briefly describes the steps for running [Ansys CFX](https://www.ansys.com/products/fluids/ansys-cfx) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running Ansys CFX on Azure.

Ansys CFX is computational fluid dynamics (CFD) software for turbomachinery applications. It uses an equilibrium phase change model and relies on material properties to reliably predict cavitation without the need for empirical model parameters. CFX:

- Uses transient blade row methods to reduce geometry from a full wheel to a single passage.
- Integrates with Geolus Shape Search to rapidly find parts that are identical to a specified part, based on geometry.

CFX is used in the aerospace, defense, steam turbine, energy, automotive, construction, facilities, manufacturing, and materials/chemical processing industries.

## Why deploy Ansys CFX on Azure?

-	Modern and diverse compute options to align to your workload's needs
-	The flexibility of virtualization without the need to buy and maintain physical hardware
-	Rapid provisioning
-	Multi-node deployment as much as 17 times faster than single-node deployment

## Architecture

:::image type="content" source="media/cfx/ansys-cfx.png" alt-text="Diagram that shows an architecture for deploying Ansys CFX." lightbox="media/cfx/ansys-cfx.png" border="false":::

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
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

Performance tests of Ansys CFX on Azure used [HBv3-series](/azure/virtual-machines/hbv3-series) VMs running Linux. The following table provides the configuration details.

|VM size|	vCPU|	Memory (GiB)	|Memory bandwidth (GBps)	|Base CPU frequency (Ghz)|	All-cores frequency (Ghz, peak)|	Single-core frequency (Ghz, peak)|	RDMA performance (Gbps)	|Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3|	120|	448|	350|	2.45|	3.1|	3.675|	200|	32|
|Standard_HB120-96rs_v3|	96|	448|	350|	2.45|	3.1|	3.675	|200|	32|
|Standard_HB120-64rs_v3	|64	|448	|350|	2.45|	3.1|	3.675|	200|	32|
|Standard_HB120-32rs_v3	|32	|448	|350|	2.45|	3.1|	3.675|	200	|32|
|Standard_HB120-16rs_v3	|16|	448	|350|	2.45|	3.1|	3.675|	200	|32|

### Required drivers

To use AMD CPUs on [HBv3 VMs](/azure/virtual-machines/hbv3-series), you need to install AMD drivers.

To use InfiniBand, you need to enable InfiniBand drivers.

## CFX installation

Before you install CFX, you need to deploy and connect a Linux VM and install the required AMD and InfiniBand drivers.

For information about deploying the VM, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

For information about installing CFX, see the [Ansys website](https://www.ansys.com/products/fluids/ansys-cfx).  

## CFX performance results

 CFD analysis was performed in these tests. Ansys CFX 2021 R2 was tested. The following table provides the details of the VM that was used for testing.

|Operating system |OS architecture|MPI|
|-|-|-|
|CentOS Linux release 8.1.1911 (Core)|Linux x86-64|Intel MPI|

Many factors can influence HPC scalability, including the mesh size, element type, mesh topology, and physical models. To get meaningful and case-specific benchmark results, it's best to use the standard HPC benchmark cases that are available on the [Ansys Customer Portal](https://support.ansys.com/Home/HomePage).

The following models were tested. For more information about the current Ansys models, see [CFX benchmarks](https://fluidcodes.com/customer-support/platform-support/benchmarks-overview/ansys-cfx-benchmarks). 

### Pump

:::image type="content" source="media/cfx/pump.png" alt-text="Figure that shows the pump model." border="false":::

This model represents an automotive pump with rotating and stationary components.

### Airfoils

:::image type="content" source="media/cfx/airfoil.png" alt-text="Figure that shows the airfoil model." border="false":::

These models represent transonic flow around an airfoil. Airfoils with mesh sizes of 10 million, 50 million, and 100 million were tested. 

### Results, single-node configuration

The following table and graph show elapsed wall-clock times and relative speed increases for the pump model.

|Model|	Iterations	|Cores|	CFD solver wall-clock time (seconds)|	Relative speed increase|
|-|-|-|-|-|
|perf_Pump_R16|	10|	16|	32.59|	1.00|
|perf_Pump_R16|	10|32	|20.48|	1.59|
|perf_Pump_R16|	10|64|	16.19	|2.01|
|perf_Pump_R16|	10|96	|16.85|	1.93|
|perf_Pump_R16|	10|120|	18.00	|1.81|

:::image type="content" source="media/cfx/pump-graph.png" alt-text="Graph that shows the relative speed increases as the number of CPUs increases." border="false":::

The following table and graph show elapsed wall-clock times and relative speed increases for the airfoil model, with a mesh size of 10 million.

|Model|	Iterations	|Cores|	CFD solver wall-clock time (seconds)|	Relative speed increase|
|-|-|-|-|-|
|perf_Airfoil_10M_R16|5|16|	149.40|	1.00|
|perf_Airfoil_10M_R16|5|32|	113.05	|1.32|
|perf_Airfoil_10M_R16|5|64|	113.87	|1.31|
|perf_Airfoil_10M_R16|5|96|	121.71	|1.23|
|perf_Airfoil_10M_R16|5|120|	125.10|	1.19|

:::image type="content" source="media/cfx/graph-airfoil-10m.png" alt-text="Graph that shows the relative speed increases for the 10M airfoil." border="false":::

The following table and graph show elapsed wall-clock times and relative speed increases for the airfoil model, with a mesh size of 50 million.

|Model|	Iterations	|Cores|	CFD solver wall-clock time (seconds)|	Relative speed increase|
|-|-|-|-|-|
|perf_Airfoil_50M_R16|5|16|	861.34|	1.00|
|perf_Airfoil_50M_R16|5|32|	627.99	|1.37|
|perf_Airfoil_50M_R16|5|64|	573.76	|1.50|
|perf_Airfoil_50M_R16|5|96|	616.32	|1.40|
|perf_Airfoil_50M_R16|5|120|646.07|	1.33|

:::image type="content" source="media/cfx/graph-airfoil-50m.png" alt-text="Graph that shows the relative speed increases for the 50M airfoil." border="false":::

The following table and graph show elapsed wall-clock times and relative speed increases for the airfoil model, with a mesh size of 100 million.

|Model|	Iterations	|Cores|	CFD solver wall-clock time (seconds)|	Relative speed increase|
|-|-|-|-|-|
|perf_Airfoil_100M_R16|5|16|2029.20	|	1.00|
|perf_Airfoil_100M_R16|5|32|1541.70	|1.32|
|perf_Airfoil_100M_R16|5|64|1445.70	|1.40|
|perf_Airfoil_100M_R16|5|96|1451.70|1.40|
|perf_Airfoil_100M_R16|5|120|1473.70	|1.05|

:::image type="content" source="media/cfx/graph-airfoil-100m.png" alt-text="Graph that shows the relative speed increases for the 100M airfoil." border="false":::

### Results, multi-node configuration

As the single-node results show, scalability improves as the number of cores increases. Because memory bandwidth is fixed on a single node, performance saturates after a certain number of cores is reached. A multi-node configuration surpasses this limitation to fully take advantage of the CFX solver capabilities.

Based on the single-node tests, the 64-CPU configuration is optimal. It's also less expensive than 96-CPU and 120-CPU configurations. The Standard_HB120-64rs_v3 VM with 64 CPUs was used for the multi-node tests.

The following table and graph show elapsed wall-clock times and relative speed increases for the pump model.

|Model|	Iterations	|Number of nodes|Number of cores|	CFD solver wall-clock time (seconds)|	Relative speed increase|
|-|-|-|-|-|-|
|perf_Pump_R16|	10|1|64|16.19|1.00|
|perf_Pump_R16|	10|2|128|9.09|1.78|
|perf_Pump_R16|	10|4|256|4.93|3.28|
|perf_Pump_R16|	10|8|512|3.07|5.27|
|perf_Pump_R16|	10|16|1,024|2.30|7.02|

:::image type="content" source="media/cfx/graph-pump-multi-node.png" alt-text="Graph that shows the relative speed increases for pump model, using the multi-node configuration." border="false":::

The following table and graph show elapsed wall-clock times and relative speed increases for the airfoil model, with a mesh size of 10 million.

|Model|	Iterations	|Number of nodes|Number of cores|	CFD solver wall-clock time (seconds)|	Relative speed increase|
|-|-|-|-|-|-|
|perf_Airfoil_10M_R16|	10|1|64|113.87|1.00|
|perf_Airfoil_10M_R16|	10|2|128|55.43	|2.05|
|perf_Airfoil_10M_R16|	10|4|256|28.21|	4.04|
|perf_Airfoil_10M_R16|	10|8|512|15.39	|7.40|
|perf_Airfoil_10M_R16|	10|16|1,024|9.42|	12.09|

:::image type="content" source="media/cfx/graph-10m-airfoil-multi-node.png" alt-text="Graph that shows the relative speed increases for 10M airfoil, using the multi-node configuration." border="false":::

The following table and graph show elapsed wall-clock times and relative speed increases for the airfoil model, with a mesh size of 50 million.

|Model|	Iterations	|Number of nodes|Number of cores|	CFD solver wall-clock time (seconds)|	Relative speed increase|
|-|-|-|-|-|-|
|perf_Airfoil_50M_R16|	10|1|64|573.76|1.00|
|perf_Airfoil_50M_R16|	10|2|128|284.75|2.01|
|perf_Airfoil_50M_R16|	10|4|256|143.73|3.99|
|perf_Airfoil_50M_R16|	10|8|512|73.09|7.85|
|perf_Airfoil_50M_R16|	10|16|1,024|38.35|14.96|

:::image type="content" source="media/cfx/graph-50m-airfoil-multi-node.png" alt-text="Graph that shows the relative speed increases for 50M airfoil, using the multi-node configuration." border="false":::

The following table and graph show elapsed wall-clock times and relative speed increases for the airfoil model, with a mesh size of 100 million.

|Model|	Iterations	|Number of nodes|Number of cores|	CFD solver wall-clock time (seconds)|	Relative speed increase|
|-|-|-|-|-|-|
|perf_Airfoil_100M_R16|	10|1|64|1445.70|1.00|
|perf_Airfoil_100M_R16|	10|2|128|642.95|2.25|
|perf_Airfoil_100M_R16|	10|4|256|320.27|4.51|
|perf_Airfoil_100M_R16|	10|8|512|161.64|8.94|
|perf_Airfoil_100M_R16|	10|16|1,024|83.73|17.27|

:::image type="content" source="media/cfx/graph-airfoil-100m-multi-node.png" alt-text="Graph that shows the relative speed increases for 100M airfoil, using the multi-node configuration." border="false":::

## Azure cost
The following tables present wall-clock times that you can use to calculate Azure costs. You can multiply the times presented here by the Azure hourly rates for HBv3-series VMs to calculate costs. For the current hourly costs, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing). 

Only the wall-clock time per 100 iterations for running each model is considered for these cost calculations. Application installation time and license costs aren't considered.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

### Costs, single-node configuration

|VM size|	Number of CPUs|		CFD solver wall-clock time (hours)|
|-|-|-|
|Standard_HB120-16rs_v3	|16|		0.85|
|Standard_HB120-32rs_v3	|32	|	0.64|
|Standard_HB120-64rs_v3	|64	|	0.60|
|Standard_HB120-96rs_v3|	96|		0.61|
|Standard_HB120rs_v3|	120		|0.63|

### Costs, multi-node configuration

|VM size|	Number of nodes|	Number of cores|	CFD solver wall-clock time (seconds)|	Hours|
|-|-|-|-|-|
|HB120-64rs_v3|	1|	64	|2,175|	0.60|
|HB120-64rs_v3|	2	|128|	1,005|	0.28|
|HB120-64rs_v3|4|	256	|504|	0.14|
|HB120-64rs_v3|8|	512	|257|	0.07|
|HB120-64rs_v3|16|	1,024|	134	|0.04|

## Summary

- Ansys CFX was successfully tested on HBv3-series VMs on Azure.
- In single-node configurations, performance scales well up to 64 cores. After that point, the speed increase drops off.
- In multi-node configurations, performance scales linearly when nodes are added.

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
-   [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)

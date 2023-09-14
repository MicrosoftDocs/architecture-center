This article briefly describes the steps for running [Ansys Fluent](https://www.ansys.com/products/fluids/ansys-fluent) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running Ansys Fluent on Azure.

Fluent is a computational fluid dynamics (CFD) application that's used to model fluid flow, heat and mass transfer, chemical reactions, and more. Fluent provides:

- Task-based workflows, including multiphase modeling, batteries, shape optimization, and aerodynamics, for pre-processing the generation of a CFD-ready mesh for both clean and dirty CAD. 
- Accurate simulation of multiphase flows, including gas-liquid, liquid-liquid, gas-solid, particle flows, and DEM. 
- A range of turbulence models, including the GEKO model.

Fluent is used in the aerospace, automotive, medical, healthcare, manufacturing, industrial equipment, communication, embedded systems, energy, retail, and consumer goods industries. 

## Why deploy Ansys Fluent on Azure?

- Modern and diverse compute options to align to your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Performance that scales well up to 64 or 96 CPUs on a single node and linearly on multiple nodes

## Architecture

:::image type="content" source="media/ansys-fluent/ansys-fluent.svg" alt-text="Diagram that shows an architecture for deploying Fluent." lightbox="media/ansys-fluent/ansys-fluent.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/ansys-fluent.vsdx) of this
architecture.*

## Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Linux VM.
  - For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  -  A public IP address connects the internet to the VM.
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

Performance tests of Fluent on Azure used [HBv3-series](/azure/virtual-machines/hbv3-series) VMs running the Linux CentOS operating system. The following table provides details about HBv3-series VMs.

VM size|	vCPU|	Memory (GiB)|	Memory bandwidth GBps|	Base CPU frequency (Ghz)|	All-cores frequency (Ghz, peak)|	Single-core frequency (Ghz, peak)	|RDMA performance (Gbps)|	Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3|120|448|	350|	1.9|	3.0|	3.5|	200	|32|
|Standard_HB120-96rs_v3	|96	|448|	350	|1.9	|3.0	|3.5|	200	|32|
|Standard_HB120-64rs_v3	|64	|448|	350	|1.9	|3.0	|3.5|	200	|32|
|Standard_HB120-32rs_v3	|32	|448|	350	|1.9	|3.0	|3.5|	200	|32|
|Standard_HB120-16rs_v3	|16	|448|	350	|1.9	|3.0	|3.5|	200	|32|



### Required drivers

To use AMD CPUs on [HBv3 VMs](/azure/virtual-machines/hbv3-series), you need to install AMD drivers.

To use InfiniBand, you need to enable InfiniBand drivers.

## Fluent installation

Before you install Fluent, you need to deploy and connect a VM, install Linux, and install the required AMD and InfiniBand drivers.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

For information about installing Fluent, see the [Ansys website](https://www.ansys.com/products/fluids/ansys-fluent).

## Fluent performance results

HBv3 VMs with different numbers of vCPUs were deployed to determine the optimal configuration for Fluent on a single node. That optimal configuration was then tested in a multi-node cluster deployment. Ansys Fluent 2021 R2 was tested.

### Results, single-node configuration

The single-node configuration was evaluated for the following test cases.

#### Aircraft wing test case

:::image type="content" source="media/ansys-fluent/aircraft-wing.png" alt-text="Screenshot that shows the aircraft wing test case." border="false":::


|Test case name|Number of cells  |Cell type  |Solver  |Models  |
|---------|--|-------|---------|---------|
|aircraft_wing_14m|14,000,000     | Hexahedral        |  Pressure-based coupled solver, Least Squares cell based, steady       |  Realizable K-e Turbulence       |

The following table and graph present the test results.

|Cores|Wall-time per <br> 100 iterations <br> (seconds)|Relative speed increase|
|-|-|-|
|16	|860.67|	1.00|
|32 |569.03	|1.51	|
|64 |442.69	|1.94|
|96 |433.45	|1.99|
|120| 429.54|	2.00|

:::image type="content" source="media/ansys-fluent/aircraft-wing-graph.png" alt-text="Graph that shows the relative speed increase for the aircraft wing test case." border="false":::

#### Pump test case

:::image type="content" source="media/ansys-fluent/pump.png" alt-text="Screenshot that shows the pump test case." border="false":::

|Test case name|Number of cells  |Cell type  |Solver  |Models  |
|---------|--|-------|---------|---------|
|pump_2m|2,000,000|Hexahedral|Pressure-based coupled solver, Least Squares cell based, steady|Realizable K-e Turbulence, Mixture Multiphase|

The following table and graph present the test results.

|Cores|Wall-time per <br> 100 iterations <br> (seconds)|Relative speed increase|
|-|-|-|
|16|	213.83|	1.00|
|32	|146.38	|1.46|
|64	|118.26	|1.81|
|96	|112.53	|1.90|
|120	|115.47|	1.85|

:::image type="content" source="media/ansys-fluent/pump-graph.png" alt-text="Graph that shows the relative speed increase for the pump test case." border="false":::

#### Landing gear test case

:::image type="content" source="media/ansys-fluent/landing-gear.png" alt-text="Screenshot that shows the landing gear test case." border="false":::

|Test case name|Number of cells  |Cell type  |Solver  |Models  |
|---------|--|-------|---------|---------|
|landing_gear_15m|15,000,000|Mixed|	Pressure-based coupled solver, Least Squares cell based, Unsteady|LES, Acoustics|

The following table and graph present the test results.

|Cores|Wall-time per <br> 100 iterations <br> (seconds)|Relative speed increase|
|-|-|-|
|16|	871.37|	1.00|
|32|	580.31|	1.50|
|64|	501.02|	1.74|
|96|	484.46|	1.80|
|120|	489.96|	1.78|

:::image type="content" source="media/ansys-fluent/landing-gear-graph.png" alt-text="Graph that shows the relative speed increase for the landing gear test case.":::

#### Oil rig test case

:::image type="content" source="media/ansys-fluent/oil-rig.png" alt-text="Screenshot that shows the oil rig test case." border="false":::

|Test case name|Number of cells  |Cell type  |Solver  |Models  |
|---------|--|-------|---------|---------|
|oil_rig_7m|7,000,000|Mixed|Pressure-based segregated solver, Green-Gauss cell based, unsteady|VOF, SST K-omega Turbulence|

The following table and graph present the test results.

|Cores|Wall-time per <br> 100 iterations <br> (seconds)|Relative speed increase|
|-|-|-|
|16|	377.11|	1.00|
|32|	224.16|	1.68|
|64|	152.42|	2.47|
|96|	140.81|	2.68|
|120|	132.34	|2.85|

:::image type="content" source="media/ansys-fluent/oil-rig-graph.png" alt-text="Graph that shows the relative speed increase for the oil rig test case.":::

#### Sedan test case

:::image type="content" source="media/ansys-fluent/sedan.png" alt-text="Screenshot that shows the sedan test case." border="false":::

|Test case name|Number of cells  |Cell type  |Solver  |Models  |
|---------|--|-------|---------|---------|
|sedan_4m|4,000,000|Mixed|Pressure-based coupled solver, Green-Gauss cell based, steady|Standard K-e Turbulence|

The following table and graph present the test results.

|Cores|Wall-time per <br> 100 iterations <br> (seconds)|Relative speed increase|
|-|-|-|
|16	|154.02|	1.00|
|32	|99.88|	1.54|
|64	|79.40|	1.94|
|96	|74.88|	2.06|
|120|	75.62|	2.04|

:::image type="content" source="media/ansys-fluent/sedan-graph.png" alt-text="Graph that shows the relative speed increase for the sedan test case.":::

#### Combustor test case

:::image type="content" source="media/ansys-fluent/combustor.png" alt-text="Figure that shows the combustor test case." border="false":::

|Test case name|Number of cells  |Cell type  |Solver  |Models  |
|---------|--|-------|---------|---------|
|combustor_12m|12,000,000|Polyhedra|Pressure-based coupled solver, Least Squares cell based, pseudo transient|Realizable K-e Turbulence, Species Transport|

The following table and graph present the test results.

|Cores|Wall-time per <br> 100 iterations <br> (seconds)|Relative speed increase|
|-|-|-|
|16	|3,238|	1.00|
|32	|2,085|	1.55|
|64|	1,513|	2.14|
|96|	1,360|	2.38|
|120|	1,236|	2.62|

:::image type="content" source="media/ansys-fluent/combustor-graph.png" alt-text="Graph that shows the relative speed increase for the combustor test case.":::

#### Exhaust system test case  

:::image type="content" source="media/ansys-fluent/exhaust-system.png" alt-text="Screenshot that shows the exhaust system test case." border="false":::

|Test case name|Number of cells  |Cell type  |Solver  |Models  |
|---------|--|-------|---------|---------|
|exhaust_system_33m|33,000,000|Mixed|Pressure-based coupled solver, Least Squares cell based, steady|SST K-omega Turbulence|

The following table and graph present the test results.

|Cores|Wall-time per <br> 100 iterations <br> (seconds)|Relative speed increase|
|-|-|-|
|16	|2,685|	1.00|
|32	|1,628|	1.65|
|64|	1,334	|2.01|
|96	|1,205|	2.23|
|120|	1,112|	2.42|

:::image type="content" source="media/ansys-fluent/exhaust-system-graph.png" alt-text="Graph that shows the relative speed increase for the exhaust system test case.":::

### Results, multi-node configuration

As the preceding performance results show, HBv3-series VMs with 64 cores and 96 cores are optimal configurations. The performance improvement when you increase from 64 CPUs to 96 CPUs is between 5 and 10 percent. Taking license costs into consideration, the 64-CPU configuration is the best choice. Standard_HB120-64rs_v3 VMs, which have 64 cores, were used for the multi-node tests.

The multi-node configuration was evaluated for the same test cases.

#### Aircraft wing test case

Number of nodes|Number of cores|Wall-clock time per 100 iterations (seconds)|	Relative speed increase|
|-|-|-|-|
|1|	64|	442.69	|1.00|
|2|	128|	226.06	|1.96|
|3|	192	|149.31	|2.96|
|4|	256	|109.23|	4.05|

This graph shows the relative speed increases:

:::image type="content" source="media/ansys-fluent/aircraft-wing-multi-node.png" alt-text="Graph that shows the relative speed increase for the aircraft wing test case on a multi-node configuration.":::

#### Pump test case

Number of nodes|Number of cores|Wall-clock time per 100 iterations (seconds)|	Relative speed increase|
|-|-|-|-|
|1|	64|	118.26	|1.00|
|2|	128|	55.42|	2.13|
|3|	192|	35.53|	3.33|
|4|	256	|24.26|	4.88|

This graph shows the relative speed increases:

:::image type="content" source="media/ansys-fluent/pump-multi-node.png" alt-text="Graph that shows the relative speed increase for the pump test case on a multi-node configuration.":::

#### Landing gear test case

Number of nodes|Number of cores|Wall-clock time per 100 iterations (seconds)|	Relative speed increase|
|-|-|-|-|
|1|	64|	501.02	|1.00|
|2|	128|	247.17|	2.03|
|3|	192	|160.02	|3.13|
|4|	256	|117.78|	4.25|

This graph shows the relative speed increases:

:::image type="content" source="media/ansys-fluent/landing-gear-multi-node.png" alt-text="Graph that shows the relative speed increase for the landing gear test case on a multi-node configuration.":::

#### Oil rig test case

Number of nodes|Number of cores|Wall-clock time per 100 iterations (seconds)|	Relative speed increase|
|-|-|-|-|
|1|	64|	152.42	|1.00|
|2|	128|	75.48|	2.02|
|3|	192	|52.76|	2.89|
|4|	256	|41.38|	3.68|

This graph shows the relative speed increases:

:::image type="content" source="media/ansys-fluent/oil-rig-multi-node.png" alt-text="Graph that shows the relative speed increase for the oil rig test case on a multi-node configuration.":::

#### Sedan test case

Number of nodes|Number of cores|Wall-clock time per 100 iterations (seconds)|	Relative speed increase|
|-|-|-|-|
|1|	64|	79.40	|1.00|
|2|	128|	39.66|	2.00|
|3|	192	|23.90|	3.32|
|4|	256	|20.15|	3.94|


This graph shows the relative speed increases:

:::image type="content" source="media/ansys-fluent/sedan-multi-node.png" alt-text="Graph that shows the relative speed increase for the sedan test case on a multi-node configuration.":::

#### Combustor test case

Number of nodes|Number of cores|Wall-clock time per 100 iterations (seconds)|	Relative speed increase|
|-|-|-|-|
|1|	64|	1,512.56	|1.00|
|2|	128|	828.63|	1.83|
|3|	192	|531.82	|2.84|
|4|	256	|359.86|	4.20|


This graph shows the relative speed increases:

:::image type="content" source="media/ansys-fluent/combustor-multi-node.png" alt-text="Graph that shows the relative speed increase for the combustor test case on a multi-node configuration.":::

#### Exhaust system test case 

Number of nodes|Number of cores|Wall-clock time per 100 iterations (seconds)|	Relative speed increase|
|-|-|-|-|
|1|	64	|1,333.72	|1.00|
|2|	128	|629.02	|2.12|
|3|	192	|399.66	|3.34|
|4|256|304.05|4.39|


This graph shows the relative speed increases:

:::image type="content" source="media/ansys-fluent/exhaust-system-multi-node.png" alt-text="Graph that shows the relative speed increase for the exhaust system test case on a multi-node configuration.":::

## Azure cost

Only wall-clock time per 100 iterations of each model is considered for these cost calculations. Application installation time and license costs aren't considered.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

For a single-node configuration, you can multiply the wall-clock times by the Azure hourly costs for HBv3-series VMs to compute total costs. For the current hourly costs, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing). Here are the times for a single-node configuration:

|VM size|	 Number of CPUs|	Wall-clock time (hours)|
|-|-|-|
|Standard_HB120-16rs_v3|	16|	2.33|
|Standard_HB120-32rs_v3|	32|	1.48|
|Standard_HB120-64rs_v3|	64|	1.15|
|Standard_HB120-96rs_v3|	96|	1.06|
|Standard_HB120rs_v3	|120	|1.00|

For a multi-node configuration, you can multiply the wall-clock times by the number of nodes and the Azure hourly costs for HBv3-series VMs to compute total costs. For the current hourly costs, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing). Here are the times for a multi-node configuration:

VM size|	Number of nodes|	Number of cores|	Wall-clock time (hours)|
|-|-|-|-|
|Standard_HB120-64rs_v3|	1	|64	|1.15|
|Standard_HB120-64rs_v3|	2	|128|	0.58|
|Standard_HB120-64rs_v3|	3|	192	|0.38|
|Standard_HB120-64rs_v3|	4|	256|	0.27|

## Summary

- Ansys Fluent 2021 R2 was successfully tested on HBv3-series Azure VMs.
- In single-node configurations, performance scaled well up to 64 or 96 CPUs. After that point, the speed increase dropped off.
- In multi-node configurations, performance scaled linearly as nodes were added.

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

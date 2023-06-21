This article describes the steps for running [Engys HELYX](https://engys.com/products/helyx) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running HELYX on single-node and multi-node VM configurations.

HELYX is a general purpose computational fluid dynamics (CFD) application for engineering analysis and design optimization. It's based on OpenFOAM libraries and uses  an advanced automatic meshing utility to simulate complex flows. 

HELYX provides:

- A Generalized Internal Boundaries (GIB) method to support complex boundary motions inside the finite-volume mesh.
- An advanced hex-dominant automatic mesh algorithm with polyhedra support that can run in parallel to generate large computational grids.
- A solver stack that's based on the finite-volume approach. It covers single-phase and multi-phase turbulent flows (RANS, URANS, DES, LES), thermal flows with natural/forced convection, thermal/solar radiation, and incompressible and compressible flow solutions.

HELYX supports industry-specific add-ons, including hydrodynamics analysis for marine applications, block-coupled incompressible flow solvers, and advanced two-phase volume-of-fluid (VOF) flows.

HELYX is used in the automotive, aerospace, construction, marine, turbo, and energy industries.

## Why deploy HELYX on Azure?

- Modern and diverse compute options to meet your workload's needs.
- The flexibility of virtualization without the need to buy and maintain physical hardware.
- Rapid provisioning.
- Complex problems solved within a few hours.

## Architecture

Multi-node configuration:

:::image type="content" source="media/helyx-cluster-architecture.svg" alt-text="Diagram that shows a multi-node configuration." lightbox="media/helyx-cluster-architecture.svg" border="false":::

Single-node configuration: 

:::image type="content" source="media/helyx-architecture.svg" alt-text="Diagram that shows a single-node configuration." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/helyx-architecture.vsdx) of all diagram in this article.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Linux VMs. For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud. 
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VMs.  
  - A public IP address connects the internet to the VM.   
- [Azure CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud) is used to create the cluster in the multi-node configuration.
- A physical SSD is used for storage.  

## Compute sizing and drivers

Performance tests of HELYX on Azure used [HBv3 AMD EPYC 7V73X (Milan-X)](/azure/virtual-machines/hbv3-series) VMs running Linux CentOS. The following table provides details about HBv3-series VMs.

|VM size|vCPU|Memory (GiB)|Memory bandwidth (GBps)|Base CPU frequency (GHz)|	All-cores frequency (GHz, peak)|Single-core frequency (GHz, peak)|RDMA performance (Gbps)|Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3|	120	|448|	350|	1.9|	3.0|	3.5|	200|	32|
|Standard_HB120-96rs_v3|	96|	448|	350|	1.9|	3.0|	3.5|	200	|32|
|Standard_HB120-64rs_v3	|64	|448|	350	|1.9	|3.0	|3.5|	200|	32|
|Standard_HB120-32rs_v3	|32	|448|	350	|1.9	|3.0	|3.5|	200|	32|
|Standard_HB120-16rs_v3	|16|	448|	350	|1.9|	3.0	|3.5|	200	|32|

### Required drivers

To use InfiniBand, you need to enable InfiniBand drivers.

## Install HELYX 3.5.0 on a VM or HPC cluster

You need to buy HELYX from ENGYS or one of its local authorized distributors or agents to get access to the installation files and technical support. For information about buying HELYX, contact [ENGYS](https://engys.com/products/helyx).

Before you install HELYX, you need to deploy and connect a VM or HPC cluster.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

For information about deploying Azure CycleCloud and an HPC cluster, see these articles:

- [Install and configure Azure CycleCloud](/learn/modules/azure-cyclecloud-high-performance-computing/4-exercise-install-configure)
- [Create an HPC cluster](/learn/modules/azure-cyclecloud-high-performance-computing/5-exercise-create-cluster)

## HELYX 3.5.0 performance results

Three models are used to test the parallel scalability performance of HELYX version 3.5.0 on Azure:

- A steady-state model of a city landscape, typical of wind comfort analysis.
- A steady-state model of a ventilator fan with moving blades, approximated via an MRF approach and an arbitrary mesh interface (AMI). Two mesh densities are compared.
- A transient model of a ship moving in calm water. A two-phase VOF solver is used. Two mesh densities are compared.

All computational grids tested were created in parallel as part of the execution process. The hex-dominant meshing utility that's provided with HELYX was used for the tests. 

The details of each test model are provided in the following sections. 

### Model 1: City_landscape_Niigata-NNE

:::image type="content" source="media/model-1.png" alt-text="Screenshot that shows model 1." border="false":::  

The following table provides details about the model.

|Model number|	Mesh size|	Solver|	Steady state|
|-|-|-|-|
|1|	26,500,000 cells|	Single phase, turbulent flow|	1,000 iterations|

### Model 2: Turbomachine_Ventilator-AFnq182

:::image type="content" source="media/model-2.png" alt-text="Screenshot that shows model 2." border="false":::   

The following table provides details about the model.

|Model number|	Mesh size|	Solver|	Steady state|
|-|-|-|-|
|2a|3,100,000 cells	|Single phase, turbulent flow with MRF (AMI)	|1,000 iterations	|
|2b|11,800,000 cells	|Single phase, turbulent flow with MRF (AMI)	|1,000 iterations	|

### Model 3: Marine_G2010-C2.2b-KCS-Fn026

:::image type="content" source="media/model-3.png" alt-text="Screenshot that shows model 3." border="false":::  

The following table provides details about the model.

|Model number|	Mesh size|	Solver|	Steady state|
|-|-|-|-|
|3a|1,350,000 cells|Two-phase VOF with automatic mesh refinement|CFL regulated for 20 seconds|
|3b|11,100,000 cells|Two-phase VOF with automatic mesh refinement|CFL regulated for 20 seconds|

## HELYX 3.5.0 performance results on single-node VMs

The following sections provide the performance results of running HELYX in parallel on single-node Azure [HBv3 AMD EPYC 7V73X (Milan-X)](/azure/virtual-machines/hbv3-series) VMs. You can use these results as a baseline for comparison with multi-node runs.

### Model 1: City_landscape_Niigata-NNE

This table shows total elapsed solver running times recorded for varying numbers of CPUs on the Standard HBv3-series VM:

|Number of cores|Solver running time (seconds)|	Relative speed increase|
|-|-|-|
|16|	6,176.48|	1.00|
|32	|4,301.36	|1.44|
|64	|3,783.12	|1.63|
|120|	3,774.44	|1.64|

The following graph shows the relative speed increases as the number of CPUs increases:

:::image type="content" source="media/model-1-increase-single.png" alt-text="Graph that shows the relative speed increases for model 1 in a single-node configuration." lightbox="media/model-1-increase-single.png" border="false":::   

### Model 2a: Turbomachine_Ventilator-AFnq182

This table shows total elapsed solver running times recorded for varying numbers of CPUs on the Standard HBv3-series VM:

|Number of cores|Solver running time (seconds)|	Relative speed increase|
|-|-|-|
|16|1,609.85|	1.00|
|32	|1,081.2	|1.49|
|64	|850.98	|1.89|
|120|715.07	|2.25|

The following graph shows the relative speed increases as the number of CPUs increases:

:::image type="content" source="media/ventilator-increase-single.png" alt-text="Graph that shows the relative speed increases for model 2a in a single-node configuration." lightbox="media/ventilator-increase-single.png" border="false":::   

### Model 3a: Marine_G2010-C2.2b-KCS-Fn026

This table shows total elapsed solver running times recorded for varying numbers of CPUs on the Standard HBv3-series VM:

|Number of cores|Solver running time (seconds)|	Relative speed increase|
|-|-|-|
|16|16,608.29|	1.00|
|32	|13,622.88	|1.22|
|64	|7,979.05	|2.08|
|120|8,007.08|2.07|

The following graph shows the relative speed increases as the number of CPUs increases:

:::image type="content" source="media/marine-increase-single.png" alt-text="Graph that shows the relative speed increases for model 3a in a single-node configuration." lightbox="media/marine-increase-single.png" border="false":::   

### Notes about the single-node tests 

For all the single-node tests, the solver time on a Standard_HB120-16rs_v3 VM (16 cores) is used as a reference to calculate the relative speed increase with respect to similar VMs that have more cores. The previously presented results show that parallel performance improves as cores increase from 16 to 64. At 120 cores, some simulations show limited improvement and others show a drop in performance. This pattern is common with CFD solvers and other memory-intensive applications because of saturation of the onboard memory that's available on each processor.

The AMD EPYC 7V73-series processor (Milan-X) in the HBv3 VMs tested here is a powerful processor, with 768 MB of total L3 cache. The single-node tests confirm that this memory is sufficient to guarantee parallel scalability of the HELYX solvers when you use half the cores available on each 7V73-series chip.

## HELYX 3.5.0 performance results on multi-node clusters

The single-node tests confirm that the solver achieves parallel performance until you reach 64 cores on HBv3 VMs. Based on those results, only 64-core configurations on [Standard_HB120-64rs_v3](/azure/virtual-machines/hbv3-series) VMs were used to evaluate the performance of HELYX on  multi-node clusters. The following sections provide the test results.

### Model 1: City_landscape_Niigata-NNE

This table shows the total elapsed solver running times recorded for varying numbers of CPUs on Standard HBv3-series VMs:

|Number of nodes|	Number of cores|	Cells per core|	Solver running time (seconds)|	Relative speed increase|
|-|-|-|-|-|
|1	|64	|414,063	|3,741.59	|1.00|
|2	|128	|207,031	|1,528.34	|2.45|
|4	|256	|103,516	|640.64	|5.84|
|8	|512	|51,758	|398.73	|9.38|
|16	|1,024	|25,879	|193.72	|19.31|

The following graph shows the relative speed increase as the number of cores increases:

:::image type="content" source="media/city-increase-cluster.png" alt-text="Graph that shows the relative speed increases for model 1 in a multi-node configuration." lightbox="media/city-increase-cluster.png" border="false":::    

### Model 2a: Turbomachine_Ventilator-AFnq182

This table shows the total elapsed solver running times recorded for varying numbers of CPUs on Standard HBv3-series VMs:

|Number of nodes|	Number of cores|	Cells per core|	Solver running time (seconds)|	Relative speed increase|
|-|-|-|-|-|
|1	|64	|48,438	|838.4|1.00|
|2	|128	|24,219	|567.48|	1.48|
|4	|256	|12,109	|455.9	|1.84|
|8	|512	|6,055	|372.82	|2.25|

The following graph shows the relative speed increase as the number of cores increases:

:::image type="content" source="media/ventilator-increase-cluster.png" alt-text="Graph that shows the relative speed increases for model 2a in a multi-node configuration." lightbox="media/ventilator-increase-cluster.png" border="false":::     

### Model 2b: Turbomachine_Ventilator-AFnq182_large

This table shows the total elapsed solver running times recorded for varying numbers of CPUs on Standard HBv3-series VMs:

|Number of nodes|	Number of cores|	Cells per core|	Solver running time (seconds)|	Relative speed increase|
|-|-|-|-|-|
|1	|64	|184,375|	2,710.14	|1.00|
|2	|128		|92,188	|1,602.64|	1.69|
|4	|256	|46,094	|1,076.27	|2.52|
|8	|512	|23,047	|756.73	|3.58|

The following graph shows the relative speed increase as the number of cores increases:

:::image type="content" source="media/ventilator-large-increase-cluster.png" alt-text="Graph that shows the relative speed increases for model 2b in a multi-node configuration." lightbox="media/ventilator-large-increase-cluster.png" border="false":::    

### Model 3a: Marine_G2010-C2.2b-KCS-Fn026

This table shows the total elapsed solver running times recorded for varying numbers of CPUs on Standard HBv3-series VMs:

|Number of nodes|	Number of cores|	Cells per cores|	Solver running time (seconds)|	Relative speed increase|
|-|-|-|-|-|
|1	|64	|21,094|	8,028.75	|1.00|
|2	|128		|10,547|	6,354.25|	1.26|
|4	|256	|5,273	|4,320.72|	1.86|
|8	|512	|2,637	|4,518.09|	1.78|

The following graph shows the relative speed increase as the number of cores increases:

:::image type="content" source="media/marine-increase-cluster.png" alt-text="Graph that shows the relative speed increases for model 3a in a multi-node configuration." lightbox="media/marine-increase-cluster.png" border="false"::: 

### Model 3b: Marine_G2010-C2.2b-KCS-Fn026_large

This table shows the total elapsed solver running times recorded for varying numbers of CPUs on Standard HBv3-series VMs:

|Number of nodes|	Number of cores|	Cells per core|	Solver running time (seconds)|	Relative speed increase|
|-|-|-|-|-|
|1	|64	|173,438|	66,860.55|	1.00|
|2	|128		|86,719|	41,243.12|	1.62|
|4	|256	|43,359	|25,901.95	|2.58|
|8	|512	|21,680	|16,781.86	|3.98|

The following graph shows the relative speed increase as the number of cores increases:

:::image type="content" source="media/marine-large-increase-cluster.png" alt-text="Graph that shows the relative speed increases for model 3b in a multi-node configuration." lightbox="media/marine-large-increase-cluster.png" border="false":::  

### Notes about the multi-node tests

Based on the multi-node tests, parallel scalability for model 1 (steady state, incompressible, turbulent flow) is above optimal. The results of the model 2 and 3 tests show that parallel solver performance can be influenced by ancillary methods like MRF/AMI or automatic mesh refinement.

The results also show that a minimum number of cells per core is required to reach optimal scalability across multiple nodes. You can see this by comparing the model 2a results to those of 2b and the model 3a results to those of 3b. Solver performance is reduced when the number of cells per core falls below 20,000 because of excessive data communication between processor boundaries.

## Azure cost

Only elapsed solver running time is considered for these cost calculations. Meshing times, installation time, and software costs aren't considered.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the VM costs for your configurations.

The following tables provide the elapsed solver running times in hours. Azure VM hourly rates are subject to change. To compute the cost, multiply the solver running time by the number of nodes and the [Linux VM hourly cost](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

### Cost for model 1: City_landscape_Niigata-NNE

|Number of nodes	|Solver running time (hours)|
|-|-|
|1	|1.052|
|2	|0.436|
|4	|0.186|
|8	|0.118|
|16|	0.062|

### Cost for model 2a: Turbomachine_Ventilator-AFnq182

|Number of nodes	|Solver time (hours)|
|-|-|
|1	|0.244|
|2	|0.168|
|4	|0.138|
|8	|0.118|

### Cost for model 2b: Turbomachine_Ventilator-AFnq182_large

|Number of nodes	|Solver time (hours)|
|-|-|
|1	|0.801|
|2	|0.483|
|4	|0.337|
|8	|0.247|

### Cost for model 3a: Marine_G2010-C2.2b-KCS-Fn026

|Number of nodes	|Solver time (hours)|
|-|-|
|1	|2.291|
|2	|1.823|
|4	|1.264|
|8	|1.336|


### Cost for model 3b: Marine_G2010-C2.2b-KCS-Fn026_large

|Number of nodes	|Solver time (hours)|
|-|-|
|1	|18.800|
|2	|11.670|
|4	|7.406|
|8	|4.890|

## Summary

- HELYX 3.5.0 was successfully tested on HBv3 standalone VMs and on an Azure CycleCloud multi-node configuration.
- All tested models demonstrated good CPU acceleration in a multi-node configuration.
- The meshing, setup, and solver applications in HELYX can all be run in parallel, which makes it ideal for running in multi-node configurations. (There's no need for mesh decomposition and reconstruction.)
- The simulation engine delivered with HELYX is open source, so you can run as many simulations as you need, on as many processors as you need, without incurring additional license costs.
- For better parallel performance, we recommend that you use 64 cores per HBv3 node and a minimum of 20,000 cells per core.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:
- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Preetham Y M](https://www.linkedin.com/in/preetham-y-m-6343a6212) | HPC Performance Engineer

Other contributors:
- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy
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
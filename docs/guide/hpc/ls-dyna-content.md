This article briefly describes the steps for running [Ansys LS-DYNA](https://www.ansys.com/products/structures/ansys-ls-dyna) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running LS-DYNA on Azure.

Ansys LS-DYNA is explicit simulation software for applications like drop tests, impact and penetration, smashes and crashes, and occupant safety. It simulates the response of materials to short periods of severe loading. It provides elements, contact formulations, material models, and other controls that can be used to simulate complex models with control over all the details of the problem.

LS-DYNA is used in the automotive, aerospace, construction, facilities, military, manufacturing, and bio-engineering industries.

## Why deploy LS-DYNA on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- In a multi-node configuration, impressive scale-up as the number of nodes increases

## Architecture

:::image type="content" source="media/ls-dyna/architecture.png" alt-text="Diagram that shows an architecture for deploying LS-DYNA." lightbox="media/ls-dyna/architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/ls-dyna.vsdx) of this
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

The performance tests of LS-DYNA on Azure used an [HBv3-series](/azure/virtual-machines/hbv3-series) VM running Linux. The following table provides details about the VM.

|Size|vCPU|Memory (GiB)|Memory bandwidth GBps|Base CPU frequency (GHz)|	All-cores frequency (GHz, peak)|Single-core frequency (GHz, peak)|Maximum data disks|
|-|-|-|-|-|-|-|-|
|Standard_HB120-64rs_v3|	64|		448|	350|	1.9|	3.0|	3.5|	32	|

### Required drivers

To use AMD CPUs on [HBv3-series](/azure/virtual-machines/hbv3-series) VMs, you need to install AMD drivers.

To use InfiniBand, you need to enable InfiniBand drivers.

## LS-DYNA installation

Before you install LS-DYNA, you need to deploy and connect a Linux VM and install the required AMD and InfiniBand drivers.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

For information about installing LS-DYNA, see the [Ansys website](https://www.ansys.com/products/structures/ansys-ls-dyna).

## LS-DYNA performance results

The following table provides the details of the operating system that was used for testing.

|Operating system	|OS architecture|Processor|
|-|-|-|
|Ubuntu 20.04.3 LTS|x86-64|	AMD EPYC 7V73X (Milan-X)|

A crash simulation model was used for testing:

:::image type="content" source="media/ls-dyna/crash-simulation.png" alt-text="Screenshot that shows the crash simulation that was used for testing." border="false":::

Here are the details of the model: 

- **Size:** 18,299,158
- **Cell type:** Shell and solid
- **Solver:** LS-DYNA (Ansys 2022 R2)
- **Termination time:** 4 ms
- **Compiler:** Intel Fortran Compiler 19.0 SSE2

Based on the results of testing on a single node, the 64-core VM Standard_HB120-64rs_v3 is the best configuration, taking into account performance and license costs. This configuration was used in multi-node tests, with two, three, and four nodes.

The following table shows the wall-clock times for running the simulation and the relative speed increases as the number of CPUs increases. LS-DYNA 2022 R1 on an HBv3 VM with an AMD Milan processor is used as a reference baseline to determine the speed increases. LS-DYNA 2022 R1 and LS-DYNA 2022 R2 were tested.

|Number of compute nodes|	Number of CPUs|2022 R1 (seconds)| 	2022 R2 (seconds)| 2022 R1, increase| 	2022 R2, increase |
|-|-|-|-|-|-|
|1	|64|		6,966	|5,888|		1.05|	1.24|
|2	|128|		4,019	|3,209|		1.82|	2.27|
|3	|192|		2,902	|2,417|		2.51|	3.02|
|4	|256|		2,292	|2,043|		3.18|	3.57|

The performance scales impressively as the number of nodes increases.

This graph shows the relative speed increases:

:::image type="content" source="media/ls-dyna/ls-dyna-graph.png" alt-text="Graph that shows the relative speed increases." border="false":::

## Azure cost

The following table presents wall-clock times that you can use to calculate Azure costs. You can multiply the times presented here by the number of nodes and the Azure hourly rates for HBv3-series VMs to calculate costs. For the current hourly costs, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

Only the wall-clock times for running the model are presented in this table. Application installation time and license costs aren't included. These times are indicative. The actual times depend on the size of the model.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

|VM |	Number of nodes	| Number of cores|2022 R1 (hours)|	2022 R2 (hours)|
|-|-|-|-|-|
|Standard_HB120-64rs_v3|	1|	64|		1.94|	1.64|
|Standard_HB120-64rs_v3|2	|128		|1.12|	0.89|
|Standard_HB120-64rs_v3|3	|192	|	0.81|	0.67|
|Standard_HB120-64rs_v3|4	|256	|	0.64	|0.57|
 
## Summary

- Ansys LS-DYNA was successfully tested on HBv3-series Azure VMs.
- Based on earlier testing of LS-DYNA 2021 R2, simulations on a single-node configuration scale well up to 64 cores. After that point, the relative speed increase saturates.
- At each increment from one to four nodes, performance increases as the number of nodes increases.
- If we take costs into consideration, single-node and 2-node configurations are optimal.
- To optimize only for computation time, the 4-node configuration is best. Further testing is needed on 8-node and 16-node configurations.

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

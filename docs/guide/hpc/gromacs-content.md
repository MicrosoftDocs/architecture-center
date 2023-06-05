This article briefly describes the steps for running [GROMACS](https://www.gromacs.org) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running GROMACS on Azure.

GROMACS (GROningen MAChine for Simulations) is a molecular dynamics package designed for simulations of proteins, lipids, and nucleic acids. It's used primarily for dynamic simulations of biomolecules and provides a rich set of calculation types and preparation and analysis tools. GROMACS:

- Supports compressed trajectory storage format and advanced techniques for free-energy calculations.
- Runs multiple simulations as part of a single program, which enables generalized ensemble methods like replica-exchange.
- Works within an elaborate multi-level parallelism that distributes computational work across ensembles of simulations and multiple program paths.
- Describes all systems with triclinic unit cells, so complex geometries like rhombic dodecahedron, truncated octahedron, and hexagonal boxes are supported.

GROMACS is used across the healthcare industry by biotechnology organizations, universities and research centers, education, pharmaceutical organizations, and hospitals and clinics.

## Why deploy GROMACS on Azure?

- Modern and diverse compute options to align to your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- With a 120 vCPU, a performance increase of three to four times that of 16 CPUs  

## Architecture

:::image type="content" source="media/gromacs/gromacs.png" alt-text="Diagram that shows an architecture for deploying GROMACS." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/gromacs.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Linux VM. For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  -  A public IP address connects the internet to the VM.
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

Performance tests of GROMACS on Azure used [HBv3-series](/azure/virtual-machines/hbv3-series) VMs running the Linux Ubuntu operating system. The following table provides details about HBv3-series VMs.

|VM size|	vCPU |	Ram memory (GiB)|	Memory bandwidth (GBps)|	Base CPU frequency (GHz)|	All-cores frequency (GHz, peak)|	Single-core frequency (GHz, peak)|	RDMA performance (GBps)|	Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3|120|448|	350	|1.9|	3.0|	3.5|	200|	32|
|Standard_HB120-96rs_v3	|96	|448|	350	|1.9|	3.0	|3.5|	200	|32|
|Standard_HB120-64rs_v3|64	|448|	350	|1.9|	3.0	|3.5|	200	|32|
|Standard_HB120-32rs_v3	|32	|448|	350	|1.9|	3.0|	3.5|	200	|32|
|Standard_HB120-16rs_v3	|16	|448|	350	|1.9|	3.0|	3.5|	200|	32|

HBv3-series VMs are optimized for HPC applications like fluid dynamics, explicit and implicit finite element analysis, weather modeling, seismic processing, reservoir simulation, and RTL simulation.

### Required drivers

To use the AMD CPUs on [HBv3-series](/azure/virtual-machines/hbv3-series) VMs, you need to install AMD drivers.

 To use InfiniBand, you need to enable InfiniBand drivers.

## GROMACS installation

Before you install GROMACS, you need to deploy and connect a Linux VM and install the required AMD and InfiniBand drivers.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

You can download GROMACS from the [GROMACS download](https://manual.gromacs.org/documentation/current/download.html) page. For information about installing the application, see the [Installation guide](https://manual.gromacs.org/current/install-guide/index.html). 

For information about using GROMACS, see the [User guide](https://manual.gromacs.org/documentation/current/user-guide/index.html).

## GROMACS performance results

The cell and water models described later in this section were used to test GROMACS. Elapsed times of runs on VMs with varying numbers of CPUs were recorded. The following table provides the details of the operating system that was used for testing.

|Operating system version|OS architecture|
|-|-|
|Ubuntu Linux 20.04|x86-64|

**Results for water-cut1.0_GMX50_bare**

:::image type="content" source="media/gromacs/water-cut.png" alt-text="Figure that shows the water-cut1.0_GMX50_bare model." border="false":::

|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|water-cut1.0_GMX50_bare|3,072,000|  16   |  291.3       | 1.00        |   
|water-cut1.0_GMX50_bare|3,072,000|    32 |  158.6       | 1.84        |         
|water-cut1.0_GMX50_bare|3,072,000|  64   |       89.7  |      3.25   |         
|water-cut1.0_GMX50_bare|3,072,000|    96 | 71.5       |         4.07|         
|water-cut1.0_GMX50_bare|3,072,000|120|66.9|4.35|

:::image type="content" source="media/gromacs/water-cut-graph.png" alt-text="Graph that shows relative speed increases for the water-cut1.0_GMX50_bare model." border="false":::

**Results for water-cut1.0_bare_hbonds**

:::image type="content" source="media/gromacs/water-cut-2.png" alt-text="Figure that shows the water-cut1.0_bare_hbonds model." border="false":::

|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|water-cut1.0_bare_hbonds|3,072,000|16|290.7|1.00|
|water-cut1.0_bare_hbonds|3,072,000|32|157.1|1.85|
|water-cut1.0_bare_hbonds|3,072,000|64|90.4|3.22|
|water-cut1.0_bare_hbonds|3,072,000|96|71.6|4.06|
|water-cut1.0_bare_hbonds|3,072,000|120|67.8|4.29|

:::image type="content" source="media/gromacs/water-cut-hbonds-graph.png" alt-text="Graph that shows relative speed increases for the water-cut1.0_bare_hbonds model." border="false":::


**Results for rnase_bench_systems_old-allbond**

:::image type="content" source="media/gromacs/rnase-bench-systems-old.png" alt-text="Figure that shows the rnase_bench_systems_old-allbond model." border="false":::


|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|rnase_cubic|24,040|16|2.6|1.00|
|rnase_cubic|24,040|32|1.5|1.71|
|rnase_cubic|24,040|64|0.9|2.84|
|rnase_cubic|24,040|96|0.8|3.17|
|rnase_cubic|24,040|120|0.8|3.22|
|rnase_dodec|16,816|16|2.4|1.00|
|rnase_dodec|16,816|32|N/A*|N/A*|
|rnase_dodec|16,816|64|N/A*|N/A*|
|rnase_dodec|16,816|96|0.8|3.10|
|rnase_dodec|16,816|120|N/A*|N/A*|

*\* The rnase_dodec model can't run on 32-core, 64-core, or 120-core configurations because of the size of the model and an MPI error.*

:::image type="content" source="media/gromacs/rnase-bench-systems-old-graphs.png" alt-text="Graphs that show relative speed increases for the rnase_bench_systems_old-allbond models." lightbox="media/gromacs/rnase-bench-systems-old-graphs.png" border="false":::

**Results for rnase_bench_systems**

:::image type="content" source="media/gromacs/rnase-bench-systems.png" alt-text="Figure that shows the rnase_bench_systems model." border="false":::

|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|rnase_cubic|24,040|16|2.5|1.00|
|rnase_cubic|24,040|32|1.4|1.76|
|rnase_cubic|24,040|64|0.9|2.95|
|rnase_cubic|24,040|96|0.7|3.41|
|rnase_cubic|24,040|120|0.7|3.50|
|rnase_dodec|16,816|16|2.2|1.00|
|rnase_dodec|16,816|32|1.3|1.73|
|rnase_dodec|16,816|64|0.8|2.77|
|rnase_dodec|16,816|96|0.7|3.29|
|rnase_dodec|16,816|120|0.7|3.26|

:::image type="content" source="media/gromacs/rnase-bench-systems-graphs.png" alt-text="Graphs that show relative speed increases for the rnase_bench_systems models." lightbox="media/gromacs/rnase-bench-systems-graphs.png" border="false":::

**Results for gmxbench-3.0**

:::image type="content" source="media/gromacs/gmxbench-3.png" alt-text="Figure that shows the gmxbench-3.0 model." border="false":::

|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|d.poly-ch2|6,000 atoms and 6,000 vsites|16|0.6|1.00|
|d.poly-ch2|6,000 atoms and 6,000 vsites|32|0.4|1.70|
|d.poly-ch2|6,000 atoms and 6,000 vsites|64|0.2|2.85|
|d.poly-ch2|6,000 atoms and 6,000 vsites|96|0.2|3.22|
|d.poly-ch2|6,000 atoms and 6,000 vsites|120|0.2|3.20|

:::image type="content" source="media/gromacs/gmxbench-3-graph.png" alt-text="Graph that shows relative speed increases for the gmxbench-3.0 model." border="false":::

**Results for ADH_bench_systems_old-allbonds**

:::image type="content" source="media/gromacs/adh-bench-systems-old.png" alt-text="Figure that shows the ADH_bench_systems_old-allbonds model." border="false":::

|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|adh_cubic|134,177|16|13.5|1.00|
|adh_cubic|134,177|32|8.2|1.65|
|adh_cubic|134,177|64|4.6|2.94|
|adh_cubic|134,177|96|3.6|3.70|
|adh_cubic|134,177|120|3.2|4.28|
|adh_dodec|95,561|16|11.3|1.00|
|adh_dodec|95,561|32|6.5|1.72|
|adh_dodec|95,561|64|3.8|3.01|
|adh_dodec|95,561|96|3.0|3.78|
|adh_dodec|95,561|120|3.0|3.81|

:::image type="content" source="media/gromacs/adh-bench-systems-old-graphs.png" alt-text="Graphs that show the relative speed increases for the ADH_bench_systems_old-allbonds models." lightbox="media/gromacs/adh-bench-systems-old-graphs.png" border="false":::

**Results for ADH_bench_systems**

:::image type="content" source="media/gromacs/adh-bench-systems.png" alt-text="Figure that shows the ADH_bench_systems model." border="false":::

|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|adh_cubic|134,177|16|13.0|1.00|
|adh_cubic|134,177|32|7.6|1.71|
|adh_cubic|134,177|64|4.3|3.03|
|adh_cubic|134,177|96|3.2|4.02|
|adh_cubic|134,177|120|3.0|4.28|
|adh_dodec|95,561|16|10.9|1.00|
|adh_dodec|95,561|32|6.1|1.78|
|adh_dodec|95,561|64|3.5|3.10|
|adh_dodec|95,561|96|2.8|3.85|
|adh_dodec|95,561|120|2.7|4.05|

:::image type="content" source="media/gromacs/adh-bench-systems-graph.png" alt-text="Graphs that show the relative speed increases for the ADH_bench_systems models." lightbox="media/gromacs/adh-bench-systems-graph.png" border="false":::

## Azure cost

The following tables present wall-clock times that you can use to calculate Azure costs. You can multiply the times presented here by the Azure hourly rates for  HBv3-series VMs to calculate costs. For the current hourly costs, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

Only the wall-clock time for running the test cases is considered for these cost calculations. Application installation time isn't considered.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

|VM size|	Number of CPUs|	Elapsed time (hours)|
|-|-|-|
|Standard_HB120-16rs_v3	|16	|0.178|
|Standard_HB120-32rs_v3|	32|	0.097|
|Standard_HB120-64rs_v3|	64	|0.055|
|Standard_HB120-96rs_v3|	96	|0.044|
|Standard_HB120rs_v3|	120	|0.041|

## Summary

- Gromacs was tested successfully on Azure HBv3-series VMs.
- With a 120 vCPU, the performance is three to four times the performance with 16 CPUs.

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

-   [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) |
    Senior Manager
-   [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) |
    Principal Program Manager
-   [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) |
    HPC Performance Engineer

Other contributors:

-   [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) |
    Technical Writer
-   [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director
    Business Strategy
-   [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) |
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

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

This diagram shows GROMACS running on a single Azure VM:

:::image type="content" source="media/gromacs/gromacs.svg" alt-text="Diagram that shows an architecture for deploying GROMACS." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/gromacs.vsdx) of this
architecture.*

This diagram shows a multi-node configuration, orchestrated with Azure CycleCloud:


:::image type="content" source="media/gromacs/gromacs-cluster-architecture.svg" alt-text="Diagram that shows an architecture for deploying GROMACS in a multi-node configuration." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/gromacs-multi-node-architecture.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Linux VM. For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  -  A public IP address connects the internet to the VM.
- [Azure CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud) is used to create the cluster in the multi-node configuration. 
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

Performance tests of GROMACS on Azure used [HBv3-series](/azure/virtual-machines/hbv3-series) VMs running the Linux Ubuntu operating system. The following table provides details about HBv3-series VMs.

|VM size| vCPU | Ram memory (GiB)| Memory bandwidth (GBps)| Base CPU frequency (GHz)| All-cores frequency (GHz, peak)| Single-core frequency (GHz, peak)| RDMA performance (GBps)| Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3|120|448| 350 |1.9| 3.0| 3.5| 200| 32|
|Standard_HB120-96rs_v3 |96 |448| 350 |1.9| 3.0 |3.5| 200 |32|
|Standard_HB120-64rs_v3|64 |448| 350 |1.9| 3.0 |3.5| 200 |32|
|Standard_HB120-32rs_v3 |32 |448| 350 |1.9| 3.0| 3.5| 200 |32|
|Standard_HB120-16rs_v3 |16 |448| 350 |1.9| 3.0| 3.5| 200| 32|

HBv3-series VMs are optimized for HPC applications like fluid dynamics, explicit and implicit finite element analysis, weather modeling, seismic processing, reservoir simulation, and RTL simulation.

### Required drivers

To use the AMD CPUs on [HBv3-series](/azure/virtual-machines/hbv3-series) VMs, you need to install AMD drivers.

 To use InfiniBand, you need to enable InfiniBand drivers.

## GROMACS installation

### Install GROMACS on a virtual machine

Before you install GROMACS, you need to deploy and connect a Linux VM and install the required AMD and InfiniBand drivers.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

You can download GROMACS from the [GROMACS download](https://manual.gromacs.org/documentation/current/download.html) page. For information about installing the application, see the [Installation guide](https://manual.gromacs.org/current/install-guide/index.html). 

For information about using GROMACS, see the [User guide](https://manual.gromacs.org/documentation/current/user-guide/index.html).

### Install GROMACS on an HPC cluster

You can easily deploy an HPC cluster on Azure by using [Azure CycleCloud](/azure/cyclecloud/overview).

Azure CycleCloud is a tool for orchestrating and managing HPC environments on Azure. You can use it to provision infrastructure for HPC systems, deploy HPC schedulers, and automatically scale the infrastructure to run jobs efficiently.

Azure CycleCloud is a Linux-based web application. We recommend that you begin the implementation by deploying an Azure VM that's based on a preconfigured Azure Marketplace image.

To set up an HPC cluster on Azure, complete these steps:

- [Install and configure Azure CycleCloud](/training/modules/azure-cyclecloud-high-performance-computing/4-exercise-install-configure).
- [Create an HPC cluster from built-in templates](/training/modules/azure-cyclecloud-high-performance-computing/5-exercise-create-cluster).
- [Connect to the head node (the scheduler)](/azure/cyclecloud/how-to/connect-to-node?view=cyclecloud-8).

For multi-node configurations, the GROMACS installation process is the same as the process described previously for a single node, except for the path to the installation directory:

- You need to select **/shared** for the installation directory path so that the directory is accessible for all nodes.
- The shared folder path depends on your network attached storage service. For example, an NFS server, BeeGFS cluster, [Azure NetApp Files](https://azure.microsoft.com/products/netapp/), or [Azure HPC Cache](https://azure.microsoft.com/products/hpc-cache/).

## GROMACS performance results

The cell and water models described later in this section were used to test GROMACS. Elapsed times of runs on VMs with varying numbers of CPUs were recorded. The following table provides the details of the operating system that was used for testing.

|Operating system version|OS architecture|
|-|-|
|Ubuntu Linux 20.04|x86-64|

### Performance results on a single node

**Results for water-cut1.0_GMX50_bare**

:::image type="content" source="media/gromacs/water-cut.png" alt-text="Figure that shows the water-cut1.0_GMX50_bare model." border="false":::

|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|water-cut1.0_GMX50_bare|3,072,000|  16   |  277.03       | NA        |   
|water-cut1.0_GMX50_bare|3,072,000|    32 |  153.93      | 1.80        |         
|water-cut1.0_GMX50_bare|3,072,000|  64   |       85.69  |      3.23   |         
|water-cut1.0_GMX50_bare|3,072,000|    96 | 68.26       |         4.06|         
|water-cut1.0_GMX50_bare|3,072,000|120|60.77|4.56|

:::image type="content" source="media/gromacs/water-cut1-0-gmx50_bare-result-single node.png" alt-text="Graph that shows relative speed increases for the water-cut1.0_GMX50_bare model." border="false":::

**Results for water-cut1.0_bare_hbonds**

:::image type="content" source="media/gromacs/water-cut-2.png" alt-text="Figure that shows the water-cut1.0_bare_hbonds model." border="false":::

|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|water-cut1.0_bare_hbonds|3,072,000|16|274.25|NA|
|water-cut1.0_bare_hbonds|3,072,000|32|153.92|1.78|
|water-cut1.0_bare_hbonds|3,072,000|64|87.32|3.14|
|water-cut1.0_bare_hbonds|3,072,000|96|69.22|3.96|
|water-cut1.0_bare_hbonds|3,072,000|120|60.91|4.50|

:::image type="content" source="media/gromacs/water-cut1-0-bare-hbonds-results-single-node.png" alt-text="Graph that shows relative speed increases for the water-cut1.0_bare_hbonds model." border="false":::


**Results for rnase_bench_systems_old-allbond**

:::image type="content" source="media/gromacs/rnase-bench-systems-old.png" alt-text="Figure that shows the rnase_bench_systems_old-allbond model." border="false":::


|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|rnase_cubic|24,040|16|2.47|NA|
|rnase_cubic|24,040|32|1.53|1.61|
|rnase_cubic|24,040|64|0.92|2.68|
|rnase_cubic|24,040|96|0.82|3.02|
|rnase_cubic|24,040|120|0.81|3.07|
 


:::image type="content" source="media/gromacs/rnase-bench-systems-old-allbond-results-single-node.png" alt-text="Graphs that show relative speed increases for the rnase_bench_systems_old-allbond models." lightbox="media/gromacs/rnase-bench-systems-old-allbond-results-single-node.png" border="false":::

**Results for rnase_bench_systems**

:::image type="content" source="media/gromacs/rnase-bench-systems.png" alt-text="Figure that shows the rnase_bench_systems model." border="false":::

|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|rnase_cubic|24,040|16|2.41|NA|
|rnase_cubic|24,040|32|1.47|1.64|
|rnase_cubic|24,040|64|0.85|2.84|
|rnase_cubic|24,040|96|0.75|3.21|
|rnase_cubic|24,040|120|0.73|3.30|
|rnase_dodec|16,816|16|2.17|1.00|
|rnase_dodec|16,816|32|1.27|1.71|
|rnase_dodec|16,816|64|0.78|2.79|
|rnase_dodec|16,816|96|0.68|3.21|
|rnase_dodec|16,816|120|0.67|3.22|

:::image type="content" source="media/gromacs/rnase-bench-systems-results-single-node.png" alt-text="Graphs that show relative speed increases for the rnase_bench_systems models." lightbox="media/gromacs/rnase-bench-systems-results-single-node.png" border="false":::

**Results for gmxbench-3.0**

:::image type="content" source="media/gromacs/gmxbench-3.png" alt-text="Figure that shows the gmxbench-3.0 model." border="false":::

|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|d.poly-ch2|6,000 atoms and 6,000 vsites|16|0.58|NA|
|d.poly-ch2|6,000 atoms and 6,000 vsites|32|0.36|1.61|
|d.poly-ch2|6,000 atoms and 6,000 vsites|64|0.21|2.76|
|d.poly-ch2|6,000 atoms and 6,000 vsites|96|0.19|3.01|
|d.poly-ch2|6,000 atoms and 6,000 vsites|120|0.18|3.17|

:::image type="content" source="media/gromacs/gmxbench-3-0-results-single-node.png" alt-text="Graph that shows relative speed increases for the gmxbench-3.0 model." border="false":::

**Results for ADH_bench_systems_old-allbonds**

:::image type="content" source="media/gromacs/adh-bench-systems-old.png" alt-text="Figure that shows the ADH_bench_systems_old-allbonds model." border="false":::

|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|adh_cubic|134,177|16|12.91|NA|
|adh_cubic|134,177|32|8.18|1.58|
|adh_cubic|134,177|64|4.52|2.86|
|adh_cubic|134,177|96|3.40|3.80|
|adh_cubic|134,177|120|3.10|4.17|
|adh_dodec|95,561|16|10.87|1.00|
|adh_dodec|95,561|32|6.55|1.66|
|adh_dodec|95,561|64|3.89|2.79|
|adh_dodec|95,561|96|2.96|3.68|
|adh_dodec|95,561|120|2.88|3.78|

:::image type="content" source="media/gromacs/Adh-bench-systems-old-allbonds-results-single-node.png" alt-text="Graphs that show the relative speed increases for the ADH_bench_systems_old-allbonds models." lightbox="media/gromacs/adh-bench-systems-old-allbonds-results-single-node.png" border="false":::

**Results for ADH_bench_systems**

:::image type="content" source="media/gromacs/adh-bench-systems.png" alt-text="Figure that shows the ADH_bench_systems model." border="false":::

|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|adh_cubic|134,177|16|12.94|NA|
|adh_cubic|134,177|32|7.67|1.69|
|adh_cubic|134,177|64|4.23|3.06|
|adh_cubic|134,177|96|3.27|3.96|
|adh_cubic|134,177|120|2.94|4.41|
|adh_dodec|95,561|16|10.42|1.00|
|adh_dodec|95,561|32|6.1|1.71|
|adh_dodec|95,561|64|3.46|3.02|
|adh_dodec|95,561|96|2.78|3.74|
|adh_dodec|95,561|120|2.65|3.93|

:::image type="content" source="media/gromacs/adh-bench-systems-updated-results.png" alt-text="Graphs that show the relative speed increases for the ADH_bench_systems models." lightbox="media/gromacs/adh-bench-systems-updated-results.png" border="false":::

### Performance results on a multi-node configuration

This VM configuration was used for the multi-node tests:

|Operating system version| OS architecture | Processor |
|-|-|-|
|CentOS 8|x86-64|AMD EPYC 7V73X|

**Results for water-cut1.0_GMX50_bare**

12,000 calculation steps were used in these tests. 

|Model| Initial element atom count|Number of nodes| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|-|------|---------|---------|
|water-cut1.0_GMX50_bare|3,072,000|1|64|297.30|NA|   
|water-cut1.0_GMX50_bare|3,072,000|2|128|125.37|2.37|         
|water-cut1.0_GMX50_bare|3,072,000|4|256|66.12|4.50|         
|water-cut1.0_GMX50_bare|3,072,000|8|512|35.22|8.44|         
|water-cut1.0_GMX50_bare|3,072,000|16|1,024|19.17|15.51|

:::image type="content" source="media/gromacs/water-cut1-0-gmx50-bare-multi-node-result.png" alt-text="Graph that shows relative speed increases for the water-cut1.0_GMX50_bare model in a multi-node configuration." border="false":::

**Results for water-cut1.0_bare_hbonds**

12,000 calculation steps were used in these tests. 

|Model| Initial element atom count|Number of nodes| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|-|------|---------|---------|
|water-cut1.0_bare_hbonds|3,072,000|1|64|298.15|NA|   
|water-cut1.0_bare_hbonds|3,072,000|2|128|128.19|2.33|         
|water-cut1.0_bare_hbonds|3,072,000|4|256|65.85|4.53|         
|water-cut1.0_bare_hbonds|3,072,000|8|512|34.71|8.59|         
|water-cut1.0_bare_hbonds|3,072,000|16|1,024|19.43|15.34|

:::image type="content" source="media/gromacs/water-cut1-0-bare-hbonds-multi-node-results.png" alt-text="Graph that shows relative speed increases for the water-cut1.0_bare_hbonds model in a multi-node configuration." border="false":::

**Results for benchPEP**

4,000 calculation steps were used in these tests. 

|Model| Initial element atom count|Number of nodes| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|-|------|---------|---------|
|benchPEP|12,000,000 |1|64|499.414|NA|   
|benchPEP|12,000,000 |2|128|257.945|1.94|         
|benchPEP|12,000,000 |4|256|124.556|4.01|         
|benchPEP|12,000,000 |8|512|62.708|7.96|         
|benchPEP|12,000,000 |16|1,024|31.818|15.70|

:::image type="content" source="media/gromacs/benchpep-multi-node.png" alt-text="Graph that shows relative speed increases for the benchPEP model in a multi-node configuration." border="false":::

## Azure cost

The following tables present wall-clock times that you can use to calculate Azure costs. You can multiply the times presented here by the Azure hourly rates for  HBv3-series VMs to calculate costs. For the current hourly costs, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

Only the wall-clock time for running the test cases is considered for these cost calculations. Application installation time isn't considered.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

### Single-node configurations

|VM size| Number of CPUs| Elapsed time (hours)|
|-|-|-|
|Standard_HB120-16rs_v3 |16|0.169|
|Standard_HB120-32rs_v3|32| 0.095|
|Standard_HB120-64rs_v3|64|0.053|
|Standard_HB120-96rs_v3|96|0.043|
|Standard_HB120rs_v3|120|0.038|

### Multi-node configurations

|VM size| Number of CPUs| Elapsed time (hours)|
|-|-|-|
|Standard_HB120-16rs_v3 |64|0.304|
|Standard_HB120-32rs_v3|128|0.142|
|Standard_HB120-64rs_v3|256|0.071|
|Standard_HB120-96rs_v3|512|0.037|
|Standard_HB120rs_v3|1024|0.020|

## Summary

- GROMACS was tested successfully on Azure HBv3-series virtual machines in single-node and multi-mode configurations.
- With a 120 vCPU, the performance is three to four times the performance with 16 CPUs.

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

-   [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) |
    Senior Manager
-   [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) |
    Principal Program Manager
-   Shivakumar Tallolli |
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

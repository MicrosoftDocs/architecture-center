This article briefly describes the steps for running [Altair Radioss](https://www.altair.com/radioss) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running Radioss on Azure.

Radioss is a multidisciplinary finite-element solver for linear and nonlinear problems.  It’s used to predict crash response and dynamic, transient-loading effects on vehicles, structures, and other products. Radioss:
- Uses battery and module macro models for crash events, road debris impacts, and shocks to simulate mechanical failures that cause electrical short circuits, thermal runaway, and risk of fire.
- Provides a composite shell element with delamination tracking and a fast parabolic tetra element.
- Implements extensive material laws and rupture criteria for crack propagation in brittle materials like windshields.
- Provides a fast solution for airbag deployment that uses finite-volume method technology.

Radioss is used across industry sectors to provide multiphysics solutions to dynamic problems that combine structures, mechanisms, fluids, and thermal and electromagnetic effects. It's ideal for the automotive, aerospace, and energy industries.

## Why deploy Radioss on Azure?

- Modern and diverse compute options to align with your workload's needs  
- The flexibility of virtualization without the need to buy and maintain physical hardware  
- Rapid provisioning  
- On a single node, performance improvements of as much as 2.76 times over that of 16 CPUs

## Architecture

This architecture shows a multi-node configuration, orchestrated with Azure CycleCloud:

:::image type="content" source="media/altair-radioss/radioss-cluster-architecture.svg" alt-text="Diagram that shows a multi-node configuration for deploying Altair Radioss." lightbox="media/altair-radioss/radioss-cluster-architecture.svg" border="false":::

This architecture shows a single-node configuration:

:::image type="content" source="media/altair-radioss/hpc-radioss.svg" alt-text="Diagram that shows a single-node configuration for deploying Altair Radioss." lightbox="media/altair-radioss/hpc-radioss.svg" border="false"::: 

*Download a [Visio file](https://arch-center.azureedge.net/hpc-radioss-architecture.vsdx) of all diagrams in this article.*

### Components

-   [Azure Virtual
    Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Linux VM. 
    -   For information about deploying the VM and installing the
        drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
-   [Azure Virtual
    Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud. 
    -   [Network security
        groups](/azure/virtual-network/network-security-groups-overview)
        are used to restrict access to the VM.  
    -   A public IP address connects the internet to the VM.   
-   [Azure
    CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud)
    is used to create the cluster in the multi-node configuration.
-   A physical SSD is used for storage.

## Compute sizing and drivers

Performance tests of Radioss on Azure used [HBv3-series](/azure/virtual-machines/hbv3-series) VMs running Linux. The following table provides the configuration details.

|VM size|vCPU|RAM memory (GiB)|Memory bandwidth (GBps)| Base CPU frequency (GHz)|All-cores frequency (GHz, peak)|Single-core frequency (GHz, peak)|RDMA performance (GBps)|Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3|120|448|350|1.9|3.0|3.5|200|32|
|Standard_HB120-96rs_v3|96|448|350|1.9|3.0|3.5|200|32|
|Standard_HB120-64rs_v3|64|448|350|1.9|3.0|3.5|200|32|
|Standard_HB120-32rs_v3|32|448|350|1.9|3.0|3.5|200|32|
|Standard_HB120-16rs_v3|16|448|350|1.9|3.0|3.5|200|32| 

HBv3-series VMs are optimized for HPC applications like fluid dynamics, explicit and implicit finite-element analysis, weather modeling, seismic processing, reservoir simulation, and RTL simulation.

HBv3 VMs with different numbers of vCPUs were deployed to determine the optimal configuration for Radioss test simulations on a single node. That optimal configuration was then tested in a multi-node cluster deployment.

### Required drivers

To use the AMD CPUs on [HBv3-series](/azure/virtual-machines/hbv3-series) VMs, you need to install AMD drivers.

## Radioss installation

Before you install Radioss, you need to deploy and connect a Linux VM and install the required AMD drivers.

For information about deploying the VM, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

You can install Radioss from [Altair One Marketplace](https://altairone.com/Marketplace?queryText=radioss&app=Radioss&tab=Info). You also need to install Altair License Manager and activate your license via Altair Units Licensing. See the Altair Units Licensing document on [Altair One Marketplace](https://altairone.com/Marketplace?queryText=radioss&app=Radioss&tab=Info). You can find more information about installing Radioss and License Manager and activating your license on Altair One Marketplace. For multi-node installation, see the next section.

## Multi-node configuration

You can easily deploy an HPC cluster on Azure by using [Azure
CycleCloud](/azure/cyclecloud/overview).

Azure CycleCloud is a tool for orchestrating and managing HPC
environments on Azure. You can use CycleCloud to provision
infrastructure for HPC systems, deploy HPC schedulers, and automatically
scale the infrastructure to run jobs efficiently at any scale.

Azure CycleCloud is a Linux-based web application. We recommend that you
set it up by deploying an Azure VM that\'s based on a preconfigured
Azure Marketplace image.

To set up an HPC cluster on Azure, complete these steps:

1.  [Install and configure Azure
    CycleCloud.](/training/modules/azure-cyclecloud-high-performance-computing/4-exercise-install-configure)
2.  [Create an HPC cluster from built-in
    templates.](/training/modules/azure-cyclecloud-high-performance-computing/5-exercise-create-cluster)
3.  [Connect to the head node (the
    scheduler).](/azure/cyclecloud/how-to/connect-to-node)

For multi-node configurations, the Radioss installation process is the
same as the process described previously for a single node, except for
the path to the installation directory:

-   You need to select **/shared** for the installation directory path
    so that the directory is accessible for all nodes.
-   The shared folder path depends on your network attached storage
    service, like an NFS server, BeeGFS cluster, [Azure NetApp
    Files](https://azure.microsoft.com/services/netapp), [Azure
    HPC Cache](https://azure.microsoft.com/services/hpc-cache),
    or [Azure Active Directory Domain
    Services](https://azure.microsoft.com/services/active-directory-ds).
-   To authorize multi-node VMs to access License Manager, 
    include your authorization code in the job script. For more
    information about installing Radioss, see [Altair One
    Marketplace](https://altairone.com/Marketplace?queryText=radioss&app=Radioss&tab=Info).

## Radioss performance results

Radioss was tested in single-node and multi-node configurations. Computation time (wall-clock time) was measured. The Linux platform was used, with an Azure Marketplace CentOS 8.1 HPC Gen2 image. The following table provides details. 

|  Operating system version  | OS architecture     |  MPI|
|---------|---------|---------|
|    CentOS Linux release 8.1.1911 (Core) |  x86-64       |         Intel MPI    |

### Results for a single-node configuration

Nonlinear finite-element analysis was performed to test Radioss on a single node with various numbers of CPUs. See the table in the [Compute sizing and drivers](#compute-sizing-and-drivers) section of this article for details about the VMs.

The Neon model was used as a test case:

:::image type="content" source="media/altair-radioss/neon.png" alt-text="Figure that shows the Neon model.":::

The following table provides the numbers of various elements in the model.

|Nodal points |Parts |Materials  |Property sets  |3D solid elements |3D shell elements (4 nodes)|3D beam elements|3D spring elements|3D shell elements (3 nodes)|Accelerometers|Interfaces|Rigid walls|Rigid bodies|Added nodal masses|
|---------|---------|---------|---------|-|-|-|-|-|-|-|-|-|-|
|1,096,865 |340|21|148|2,860|1,054,611|63|4,180|176|7|18|1|694|273|

The following table presents the results, in wall-clock time, in seconds.

|Model| Simulation time (ms) || 16 CPUs | 32 CPUs |64 CPUs|96 CPUs|120 CPUs|
|-----|-|-|--|---------|-------|--|---------|
| Neon    |    8     |   Starter      |20.27 | 22.91|    25.78   |29.18|31.46|
| Neon    |     8    |   Engine      |   421.99      |246.65|147.31|131.74|128.74|
|  Neon   |      8   |  Total runtime       |  442.26       |269.56|173.09|160.92|160.2|

The following table shows the relative speed increase for each increase in number of CPUs.

| Model | 16 CPUs | 32 CPUs |64 CPUs|96 CPUs|120 CPUs|
|-------|--|--|-------|---------|---------|
|Neon| 1.00    |1.64 |2.56    |2.75     | 2.76        |

:::image type="content" source="media/altair-radioss/relative-increase-neon.png" alt-text="Graph that shows the relative speed increases for the Neon model.":::

### Results for a multi-node configuration

As the preceding performance results show, a [Standard_HB120-64rs_v3](/azure/virtual-machines/hbv3-series) VM with 64 cores is the optimal configuration. This configuration was used in the multi-node tests. 64 cores were used on each node.

The Taurus model was used as a test case:

:::image type="content" source="media/altair-radioss/taurus.png" alt-text="Figure that shows the Taurus model.":::

The following table provides the numbers of various elements in the model.

|Nodal points |Parts |Materials  |Property sets |Boundary conditions |3D solid elements |3D shell elements (4 nodes)|3D beam elements|3D spring elements|3D shell elements (3 nodes)|Gravity loads|Initial velocities|Accelerometers|Sensors|Interfaces|Rigid bodies|Added nodal masses|Rayleigh damping groups|Monitored volumes|
|---------|---------|---------|---|-|-|-|-|--|-|-|-|-|-|-|-|-|-|-|
| 9,754,355 |1,585|66|762|1|330,418|9,196,272|3,766|417|345,409|1|5|4|4|1,712|901|5|4|8|

The following table shows the elapsed wall-clock time, in hours, for the test runs.

|Model|Simulation time (ms)   |  |1 node  | 4 nodes |8 nodes|16 nodes|
|----|-----|---|------|----|-----|---------|
| Taurus (T10M)  | 120   | Starter | 00:07:47  |00:11:12| 00:07:04 |00:08:13  |
| Taurus (T10M)  | 120   | Engine |37:21:22  |10:23:02|08:18:28| 04:34:59  |
| Taurus (T10M)  | 120  | Total runtime|    37:29:10     |10:34:14|08:25:32|04:43:13|

## Azure cost

Only rendering time is considered for these cost calculations. Application installation time isn't considered.

You can use the wall-clock time and the Azure hourly cost to compute total costs. For the current hourly costs, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

The following table provides the wall-clock times for single-node configurations.

|VM size  | Model  |Number of CPUs  |Wall clock time (seconds)  |
|---------|---------|---------|---------|
| HB120rs_v3    |  Neon       |  16       |   442.26      |
| HB120rs_v3      |   Neon      |  32       |    269.56     |
| HB120rs_v3      |   Neon      |    64     |    173.09     |
| HB120rs_v3      |   Neon      |      96   |   160.92      |
| HB120rs_v3      |   Neon     |  120       | 160.2        |

The following table provides the wall-clock times for multi-node configurations.

|VM size  | Model  |Number of CPUs  |Number of nodes|Wall clock time (hours)  |
|-|-|-|-|-|
|HB120-64rs_v3|Taurus (T10M)|64|1|37:29:10|
|HB120-64rs_v3|Taurus (T10M)|256|4|10:34:14|
|HB120-64rs_v3|Taurus (T10M)|512|8|08:25:32|
|HB120-64rs_v3|Taurus (T10M)|1024|16|04:43:13|

## Summary

- Radioss was successfully tested on HBv3-series VMs on Azure.
- Radioss on an Azure VM can solve complex workloads.
- In a single-node configuration, increasing the number of CPUs increases the relative speed. The optimal configuration is 64 CPUs.
- Radioss scales impressively up to 16 nodes (1024 CPUs).

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
-   [Linux virtual machines on
    Azure](/azure/virtual-machines/linux/overview)
-   [Virtual networks and virtual machines on
    Azure](/azure/virtual-network/network-overview)
-   [Learning path: Run high-performance computing (HPC) applications on
    Azure](/training/paths/run-high-performance-computing-applications-azure)
-   [What is Azure
    CycleCloud?](/azure/cyclecloud/overview)

## Related resources

-   [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
-   [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
-   [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)

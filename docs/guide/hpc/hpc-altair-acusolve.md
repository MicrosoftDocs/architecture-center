This article briefly describes the steps for running [Altair
AcuSolve](https://www.altair.com/altair-cfd-capabilities) on a virtual
machine (VM) that\'s deployed on Azure. It also presents the performance
results of running AcuSolve on Azure.

AcuSolve is a computational fluid dynamics (CFD) analyzer. It provides
comprehensive software and tools to solve fluid mechanics problems like
thermal analysis, aerodynamics, and noise reduction. AcuSolve:

-   Is finite-element based and uses distinct methods to solve all fluid
    > problems: Navier-Stokes, smoothed-particle hydrodynamic, and
    > Lattice Boltzmann.

-   Enables simulations that involve flow, heat transfer, turbulence,
    > and non-Newtonian materials.

-   Validates physical models on fully sewed unstructured meshes.

## Why deploy AcuSolve on Azure?

-   Modern and diverse compute options to align to your workload\'s
    needs 

-   The flexibility of virtualization without the need to buy and
    maintain physical hardware 

-   Rapid provisioning 

-   On a single node, performance improvements of as much as 2.47 times
    over that of 16 CPUs

## Architecture

This architecture shows a multi-node configuration:

![Diagram Description automatically
generated](media/image1.png){width="10.303521434820647in"
height="5.688293963254593in"}

*Download a [Visio
file](https://arch-center.azureedge.net/hpc-acusolve.vsdx) of this
architecture.*

This architecture shows a single-node configuration:

![](media/image2.png){width="7.751081583552056in"
height="6.021673228346457in"}

## *Download a* *[Visio file](https://arch-center.azureedge.net/acusolve-cluster-architecture.vsdx) of this architecture.*

## Components

-   [Azure Virtual
    Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create Linux and Windows VMs. 

    -   For information about deploying the VM and installing the
        drivers, see [Linux VMs on
        Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm).

-   [Azure Virtual
    Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud. 

    -   [Network security
        groups](https://docs.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)
        are used to restrict access to the VMs.  

    -   A public IP address connects the internet to the VM.   

-   [Azure
    CycleCloud](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/azurecyclecloud.azure-cyclecloud)
    is used to create the cluster in the multi-node configuration.

-   A physical SSD is used for storage.   

## Compute sizing 

### [HBv3-series](https://docs.microsoft.com/en-us/azure/virtual-machines/hbv3-series) series VMs were used to test the performance of AcuSolve on Azure. The following table provides configuration details. 

+-------------+---+-----+------+------+------+------+--------+-----+
| Size        | v | RAM | Me   | Base | A    | Sin  | RDMA   | M   |
|             | C |     | mory | CPU  | ll-c | gle- | perfo  | axi |
|             | P | mem | b    | f    | ores | core | rmance | mum |
|             | U | ory | andw | requ | f    | f    | (GBps) | d   |
|             |   | (G  | idth | ency | requ | requ |        | ata |
|             |   | iB) | (G   | (    | ency | ency |        | di  |
|             |   |     | Bps) | GHz) | (    | (    |        | sks |
|             |   |     |      |      | GHz, | GHz, |        |     |
|             |   |     |      |      | p    | p    |        |     |
|             |   |     |      |      | eak) | eak) |        |     |
+=============+===+=====+======+======+======+======+========+=====+
| Standard    | 1 | 448 | 350  | 2.45 | 3.1  | 3    | 200    | 32  |
| _HB120rs_v3 | 2 |     |      |      |      | .675 |        |     |
|             | 0 |     |      |      |      |      |        |     |
+-------------+---+-----+------+------+------+------+--------+-----+
| Standard_HB | 6 | 448 | 350  | 2.45 | 3.1  | 3    | 200    | 32  |
| 120-64rs_v3 | 4 |     |      |      |      | .675 |        |     |
+-------------+---+-----+------+------+------+------+--------+-----+

## [HBv3-series VMs](https://docs.microsoft.com/en-us/azure/virtual-machines/hbv3-series) are optimized for high-performance computing (HPC) applications like fluid dynamics, explicit and implicit finite-element analysis, weather modelling, seismic processing, reservoir simulation, and RTL simulation. 

## AcuSolve installation

Before you install AcuSolve, you need to deploy and connect a VM.

For information about deploying the VM, see [Run a Linux VM on
Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm).

You can install AcuSolve from [Altair One
Marketplace](https://altairone.com/Marketplace?queryText=acusolve). You
also need to install Altair License Manager and activate your license
via Altair Units Licensing. You can find more information about
installing AcuSolve and License Manager and activating your license on
Altair One Marketplace. For multi-mode installation, see the next
section.

## Multi-mode configuration

You can easily deploy an HPC cluster on Azure by using [Azure
CycleCloud](https://docs.microsoft.com/en-us/azure/cyclecloud/overview).

Azure CycleCloud is a tool for orchestrating and managing HPC
environments on Azure. You can use CycleCloud to provision
infrastructure for HPC systems, deploy HPC schedulers, and automatically
scale the infrastructure to run jobs efficiently at any scale.

Azure CycleCloud is a Linux-based web application. We recommend that you
set it up by deploying an Azure VM that\'s based on a preconfigured
Azure Marketplace image.

To set up an HPC cluster on Azure, complete these steps:

1.  [Install and configure Azure
    CycleCloud](https://docs.microsoft.com/en-us/learn/modules/azure-cyclecloud-high-performance-computing/4-exercise-install-configure)

2.  [Create an HPC cluster from built-in
    templates](https://docs.microsoft.com/en-us/learn/modules/azure-cyclecloud-high-performance-computing/5-exercise-create-cluster)

3.  [Connect to the head node (the
    scheduler)](https://docs.microsoft.com/en-us/azure/cyclecloud/how-to/connect-to-node?view=cyclecloud-8)

For multi-mode configurations, the AcuSolve installation process is the
same as the process described previously for a single node, except for
the path to the installation directory:

-   You need to select **/shared** for the Installation directory path
    so that the directory is accessible for all nodes.

-   The shared folder path depends on your network attached storage
    service, like an NFS server, BeeGFS cluster, [Azure NetApp
    Files](https://azure.microsoft.com/en-us/services/netapp/), [Azure
    HPC Cache](https://azure.microsoft.com/en-us/services/hpc-cache/),
    or [Azure Active Directory Domain
    Services](https://azure.microsoft.com/en-us/services/active-directory-ds/).

-   To authorize multi-node VMs to access License Manager, you need to
    include your authorization code in the job script. For more
    information about installing AcuSolve, see [Altair One
    Marketplace](https://altairone.com/Marketplace?queryText=acusolve).

# AcuSolve performance results

### AcuSolve was tested in single-node and multi-mode configurations. Computation time (wall-clock time) was measured. The Linux platform was used, with an Azure Marketplace CentOS 8.1 HPC --Gen2 image. The following table provides details: 

  -----------------------------------------------------------------------
  Operating system details       
  ------------------------------ ----------------------------------------
  Operating system version       CentOS Linux 8.1.1911 (Core)

  OS architecture                x86-64

  Processor                      AMD EPYC 7003-series (Milan)

  MPI                            Intel MPI
  -----------------------------------------------------------------------

### Results for a single-node configuration

Two models were used to test the single-node configuration:

-   Backward-facing step (0.27 million elements)

> ![Background pattern Description automatically
> generated](media/image3.png){width="6.527673884514436in"
> height="2.833530183727034in"}

-   Impinging nozzle (7.6 million elements)

> ![](media/image4.png){width="6.603354111986001in"
> height="3.626965223097113in"}

The following table provides details about the backward-facing step
model:

  -----------------------------------------------------------------------
  **Backward-facing step model**   
  -------------------------------- --------------------------------------
  Analysis type                    Steady state

  Turbulence model                 Spalart-Allmaras

  Number of elements               276,936

  Number of nodes                  279,270

  Maximum time steps               300
  -----------------------------------------------------------------------

The following table provides details about the impinging nozzle model:

  -----------------------------------------------------------------------
  **Impinging nozzle model**           
  ------------------------------------ ----------------------------------
  Analysis type                        Steady

  Turbulence model                     Spalart-Allmaras

  Number of elements                   7,690,844

  Number of nodes                      7,855,017

  Maximum time steps                   200
  -----------------------------------------------------------------------

#### Results for backward-facing step, single node

In this benchmarking exercise, AcuSolve simulates turbulent flow over a
backward-facing step. The following table shows total consumption times
for varying numbers of CPUs on Standard_HB120rs_v3 VMs:

  -----------------------------------------------------------------------
  VM size                    Number of processors   Wall-clock time
                                                    (seconds)
  -------------------------- ---------------------- ---------------------
  Standard_HB120rs_v3        120                    130.8

  Standard_HB120rs_v3        64                     188.7

  Standard_HB120rs_v3        32                     196.4

  Standard_HB120rs_v3        16                     322.9
  -----------------------------------------------------------------------

The following graph shows the relative speed increases on the
Standard_HB120rs_v3 VM:

![Chart, bar chart Description automatically
generated](media/image5.png){width="7.009962817147857in"
height="3.9487018810148733in"}

The following table shows total consumption times for varying numbers of
CPUs on Standard_HB120-64rs_v3 VMs:

  -----------------------------------------------------------------------
  VM size                   Number of processors   Wall-clock time
                                                   (seconds)
  ------------------------- ---------------------- ----------------------
  Standard_HB120-64rs_v3    64                     127.7

  Standard_HB120-64rs_v3    32                     199.88

  Standard_HB120-64rs_v3    16                     266.2
  -----------------------------------------------------------------------

The following graph shows the relative speed increases on the
Standard_HB120-64rs_v3 VM:

![Chart, waterfall chart Description automatically
generated](media/image6.png){width="6.970320428696413in"
height="3.3199682852143484in"}

#### Results for impinging nozzle, single node

As the preceding performance results show, the Standard_HB120-64rs_v3 VM
with 64 cores provides the best performance. For the impinging nozzle
model, which has more elements, we used that VM for the performance
evaluation.

The following table shows total consumption times for varying numbers of
CPUs on Standard_HB120-64rs_v3 VMs:

  -----------------------------------------------------------------------
  VM size                   Number of processors    Wall-clock time
                                                   (hours)
  ------------------------- ---------------------- ----------------------
  Standard_HB120-64rs_v3    16                     13.48

  Standard_HB120-64rs_v3    32                     8.95

  Standard_HB120-64rs_v3    64                     7.7
  -----------------------------------------------------------------------

The following graph shows the relative speed increases on the
Standard_HB120-64rs_v3 VM:

![Chart, bar chart Description automatically
generated](media/image7.png){width="8.061491688538933in"
height="5.238928258967629in"}

### Results for a multi-node configuration

As the preceding performance results show, the Standard_HB120-64rs_v3 VM
with 64 cores provides the best performance. For the multi-node
configuration, we tested the impinging nozzle model, which has 7.6
million elements, on 1, 2, 4, 8, and 16 nodes of
the Standard_HB120-64rs_v3 VM in an Azure HPC cluster. 

  -------------------------------------------------------------------------------
  VM size                   Number of  Number of   Wall-clock     Relative
                           nodes      cores       time (seconds)  increase
  ------------------------ ---------- ----------- --------------- ---------------
  Standard_HB120-64rs_v3   1          64          24,054          1.15

  Standard_HB120-64rs_v3   2          128         9,794           2.83

  Standard_HB120-64rs_v3   4          256         4,241           6.53

  Standard_HB120-64rs_v3   8          512         2,160           12.83

  Standard_HB120-64rs_v3   16         1,024       2,250           12.31
  -------------------------------------------------------------------------------

## Azure cost

Only rendering time is considered for these cost calculations.
Application installation time isn\'t considered.

To calculate costs, multiply the wall-clock time by the Azure hourly
cost. For the current hourly costs, see [Linux Virtual Machines
Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

You can use the [Azure pricing
calculator](https://azure.microsoft.com/pricing/calculator) to estimate
the costs for your configuration.

### Single node on Standard_HB120rs_v3

  -----------------------------------------------------------------------
  Number of CPUs                      Wall-clock time (hours)
  ----------------------------------- -----------------------------------
  16                                  0.09

  32                                  0.05

  64                                  0.05

  120                                 0.04
  -----------------------------------------------------------------------

### Single node Standard_HB120-64rs_v3

  -----------------------------------------------------------------------
  Number of CPUs                      Wall-clock time (hours)
  ----------------------------------- -----------------------------------
  16                                  13.55

  32                                  9.01

  64                                  7.74
  -----------------------------------------------------------------------

### Multi-node on Standard_HB120-64rs_v3

  ------------------------------------------------------------------------
  Number of nodes   Number of CPUS        Wall-clock time (hours)
  ----------------- --------------------- --------------------------------
  1                 64                    6.68

  2                 128                   2.72

  4                 256                   1.18

  8                 512                   0.60

  16                1,024                 0.63
  ------------------------------------------------------------------------

## Summary

-   AcuSolve was successfully tested on Standard_HB120rs_v3 and
    Standard_HB120-64rs_v3 VMs.

-   On a single node, on Standard_HB120rs_v3 VMs with 120 vCPUs,
    performance increases as much as 2.47 times over that of 16 CPUs,
    based on wall-clock time.

-   On a single node on Standard_HB120-64rs_v3 VMs with 64 vCPUs,
    performance increases as much as 2.08 times over that of 16 CPUs,
    based on wall-clock time.

-   AcuSolve scales up linearly with impressive numbers up to 8 nodes on
    an Azure HPC cluster with Standard_HB120-64rs_v3 VM instances that
    have 64 cores on each node. Performance increases 12.83 times with
    an 8-node (512-core) configuration on AMD Milan-X processors, an
    excellent scale-up value for AcuSolve. Scalability increases beyond
    8 nodes when a higher number of finite-element nodes are simulated.

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

-   [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) \|
    Senior Manager

-   [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) \|
    Principal Program Manager

-   [Vinod
    Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) \|
    HPC Performance Engineer

Other contributors:

-   [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) \|
    Technical Writer

-   [Guy Bursell](https://www.linkedin.com/in/guybursell) \| Director
    Business Strategy

-   [Sachin
    Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) \|
    Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

-   [GPU optimized virtual machine
    sizes](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-gpu)

-   [Linux virtual machines in
    Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/overview)

-   [Virtual networks and virtual machines in
    Azure](https://docs.microsoft.com/en-us/azure/virtual-network/network-overview)

-   [Learning path: Run high-performance computing (HPC) applications on
    Azure](https://docs.microsoft.com/en-us/learn/paths/run-high-performance-computing-applications-azure)

-   [What is Azure
    CycleCloud?](https://docs.microsoft.com/en-us/azure/cyclecloud/overview)

## Related resources

-   [Run a Linux VM on
    Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm)

-   [HPC system and big-compute
    solutions](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/big-compute-with-azure-batch)

-   [HPC cluster deployed in the
    cloud](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/hpc-cluster)

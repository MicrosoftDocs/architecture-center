This article briefly describes the steps for installing and running [LAMMPS](http://lammps.sandia.gov) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running LAMMPS on single-node and multi-node VM configurations.

LAMMPS is a classical molecular dynamics simulator that's used for materials modeling. It can model solid-state materials, soft matter, and coarse-grained or mesoscopic systems. It can be used to model atoms or, more generically, as a parallel particle simulator at the atomic, meso, or continuum scale. 

LAAMPS is designed to run well on parallel machines, but it also runs on single-processor desktop machines. It's composed of modular code, and most functionality is in optional packages.

Typical LAMMPS simulations include all-atom models of liquids, solids, and explicit solvents.

## Why deploy LAMMPS on Azure?

- Modern and diverse compute options to meet your workload's needs. 
- The flexibility of virtualization without the need to buy and maintain physical hardware. 
- Rapid provisioning. 
- Support for Message Passing Interface (MPI).
- Ability to run large and time-consuming jobs.

## Architecture

This diagram shows a multi-node configuration:

:::image type="content" source="media/multi-node-lammps.png" alt-text="Diagram that shows a multi-node architecture for deploying LAMMPS." lightbox="media/multi-node-lammps.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/MULTI-NODE-LAMMPS.vsdx) of this architecture.*
 
This diagram shows a single-node configuration:

:::image type="content" source="media/single-node-lammps.png" alt-text="Diagram that shows a single-node architecture for deploying LAMMPS." lightbox="media/single-node-lammps.png" border="false":::


*Download a [Visio file](https://arch-center.azureedge.net/single-node-LAMMPS.vsdx) of this architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Linux VMs.  
  - For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml). 
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud.  
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) restrict access to the VMs.
  - A public IP address connects the internet to the VM.
- [Azure CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud) is used to create the cluster in the multi-node configuration. 
- A physical SSD is used for storage.

## Compute sizing

Performance tests of LAMMPS on Azure used [HBv3 AMD EPYC 7V73X](/azure/virtual-machines/hbv3-series) (Milan-X) VMs running Linux CentOS. The following table provides details about HBv3-series VMs.

|VM size|vCPU|Memory (GiB)|Memory bandwidth (GBps)|Base CPU frequency (GHz)|All-cores frequency (GHz, peak)|Single-core frequency (GHz, peak)|RDMA performance (Gbps) |Maximum data disks|
|-|-|-|-|-|-|-|-|-| 
|Standard_HB120rs_v3|120 |448|350|1.9|3.0|3.5|200|32|
|Standard_HB120-96rs_v3|96|448|350|1.9|3.0|3.5|200|32|
|Standard_HB120-64rs_v3|64|448|350|1.9|3.0|3.5|200|32|
|Standard_HB120-32rs_v3|32|448|350|1.9|3.0|3.5|200|32|
|Standard_HB120-16rs_v3|16 |448|350|1.9|3.0|3.5|200|32| 

## Install LAMMPS on a VM or HPC cluster 

You can download the software from the [LAMMPS](https://docs.lammps.org/Install.html) website. You just need to untar or unzip the LAMMPS binary distribution file and you can run directly in the resulting directory. For a guide to building from source code, see [Build LAMMPS](https://docs.lammps.org/Build.html). 

Before you install LAMMPS, you need to deploy and connect to a VM or HPC cluster.

For information about deploying the VM, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

For information about deploying the Azure CycleCloud and HPC cluster, see these resources: 
- [Install and configure Azure CycleCloud](/training/modules/azure-cyclecloud-high-performance-computing/4-exercise-install-configure/)
- [Create an HPC cluster](/training/modules/azure-cyclecloud-high-performance-computing/5-exercise-create-cluster/)

### Install LAMMPS

Complete the following steps below to install LAMMPS on single-node and cluster VMs. 

1. Run the following commands: 

   ```
   export PATH=$PATH:/opt/openmpi-4.1.0/bin/ 

   export LD_LIBRARY_PATH=/opt/openmpi-4.1.0/lib 

   export CC=gcc 

   export CXX=g++ 

   export FC=gfortran 

   export FCFLAGS=-m64 

   export F77=gfortran 

   export F90=ifort 

   export CPPFLAGS=-DpggFortran
   ```

1. Download the source code from [LAMMPS](https://www.lammps.org/download.html). 

1. Unzip the file: 
   ```
   tar xvf *
   ```

1. Locate the LAMMPS folder: 
   
   ```
   cd lammps-<version> 

   cd src 
   ```

1. To build LAMMPS, run these commands in the *src* folder: 

   ```
   make yes-rigid 

   make serial 

   make mpi 
   ```

### Run LAMMPS

1. To run LAMMPS on a standalone VM, use these commands: 

   ```
   export PATH=$PATH:/opt/openmpi-4.1.0/bin/ 

   export LD_LIBRARY_PATH=/opt/openmpi-4.1.0/lib 

   export LMP_MPI=/path/LAMMPS/lammps-<version>/src/lmp_mpi 

   mpirun -np 16 /path/LAMMPS/lammps-<version>/src/lmp_mpi -in in.lj 
   ```

1. To run LAMMPS on a multi-node cluster, use this script: 

   ```
   1   #!/bin/bash 

   2   #SBATCH --job-name=LAMMPS 

   3   #SBATCH --partition=hpc 

   4   #SBATCH --nodes=2 

   5   #SBATCH --ntasks-per-node=64 

   6   #SBATCH --ntasks=128 

   7   export PATH=$PATH:/opt/openmpi-4.1.0/bin/ 

   8   export LD_LIBRARY_PATH=/opt/openmpi-4.1.0/lib 

   9   export LMP_MPI=/path/LAMMPS/lammps-<version>/src/lmp_mpi 

   10   mpirun -np 64 /path/LAMMPS/lammps-<version>/src/lmp_mpi -in benchmark.in 
   ```

   > [!Note]
   >
   > In the preceding script, `ntasks` on line 6 is the number of nodes multiplied by the number of cores per VM configuration. The number of nodes is 2, as specified on line 4. The number of cores per VM configuration is 64, as noted on line 5. So `ntasks` is 128. 

## LAMMPS performance results on Azure VMs

Two models were used to test the performance of LAMMPS versions 23  and 17 on Azure.

### Lennard-Jones model

Lennard-Jones (in.lj) is a simple molecular dynamics simulation of a binary fluid in the NVT ensemble. It's made of neutral dots with a Langevin thermostating. 

The following table provides details about the Lennard-Jones model.

 |Number of atoms |Timestep|Thermo step|Run steps|
 |-|-|-|-|
 |1.0e+9  |0.1 |10|200| 

### HECBioSim model 

HECBioSim is a benchmark suite that consists of a set of simple benchmarks for a number of popular molecular dynamics engines, each of which is set at a different atom count.

The following table provides details about the HECBioSim model.

 |Number of atoms |Timestep|Thermo step|Run steps|
 |-|-|-|-|
 |1,403,180  |2.0|5,000|10,000| 

### LAMMPS performance results on single-node VMs

The following sections provide the performance results of running LAMMPS version 23 on single-node Azure [HBv3 AMD EPYC 7V73X](/azure/virtual-machines/hbv3-series) (Milan-X) VMs. The Lennard-Jones model is used in these tests. 

This table shows the total wall clock times recorded for various number of CPUs on the Standard HBv3-series VM: 


|Number of cores|Wall clock time (seconds)|Relative speed increase| 
|-|-|-|
|16|7,634|1|
|32|4,412|1.73|
|64|2,102|3.63|
|96|1,648|4.63| 
|120|1,445|5.28| 

The following graph shows the relative speed increases as the number of CPUs increases: 

:::image type="content" source="media/single-node-graph.png" alt-text="Graph that shows the relative speed increases in a single-node configuration. " lightbox="media/single-node-graph.png" border="false":::

#### Notes about the single-node tests

For the single-node tests, the Standard_HB120-16rs_v3 VM (16 cores) is used as a baseline to calculate relative speed increases as the number of cores increases. The results show that parallel performance improves as the number of cores increases from 16 to 120. A speed increase of 5.3x is achieved with 120 cores.

### LAMMPS performance results on multi-node clusters

The single-node tests show that optimal parallel performance is reached with 64 cores on HBv3 VMs. Based on those results, 64-core configurations on [Standard_HB120-64rs_v3](/azure/virtual-machines/hbv3-series) VMs are used to evaluate the performance of LAMMPS on multi-node clusters. The Lennard-Jones and HECBioSim models are used for the multi-node tests. 

#### Lennard-Jones model

This table shows the total wall clock times recorded for various numbers of nodes:


|Number of nodes |Number of cores|Wall clock time (seconds)|Relative speed increase |
|-|-|-|-|
|1 |64|2,612|N/A|
|2|128|1,573|1.66|
|4|256|1,035|2.52| 
|8|512|793|3.29| 

The following graph shows the relative speed increases as the number of nodes increases: 

:::image type="content" source="media/multi-node-lennard-jones.png" alt-text="Graph that shows the relative speed increases for the Lennard-Jones model in a multi-node configuration. " lightbox="media/multi-node-lennard-jones.png" border="false":::

#### HECBioSim model 

This table shows the total wall clock times recorded for various numbers of nodes: 

|Number of nodes |Number of cores|Wall clock time (seconds)|Relative speed increase |
|-|-|-|-|
|1|64|3,103|N/A| 
|2|128|1,601|1.94| 
|4|256|840|3.69| 
|8|512|442|7.02| 
|16|1,024|241|12.88| 

The following graph shows the relative speed increases as the number of nodes increases: 

:::image type="content" source="media/multi-node-hecbiosim.png" alt-text="Graph that shows the relative speed increases for the HECBioSim model in a multi-node configuration. " lightbox="media/multi-node-hecbiosim.png" border="false":::

#### Notes about the multi-node tests  

- The multi-node results show that both models scale well when you  increase the number of nodes.  
- The Lennard-Jones model was tested with LAMMPS version 23. The HECBioSim model was tested with LAMMPS version 17.

## Azure cost

The following tables provide wall clock times that you can use to calculate Azure costs. To compute the cost, multiply the wall clock time by the number of nodes and the Azure VM hourly rate. For the hourly rates for Linux, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing). Azure VM hourly rates are subject to change.

Only simulation running time is considered for the cost calculations. Installation time, simulation setup time, and software costs aren't included. 

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate VM costs for your configurations. 

### Running times for the Lennard-Jones model

|Number of nodes|Wall clock time (hours)| 
|-|-|
|1|0.73| 
|2|0.44 |
|4|0.29|
|8|0.22| 

### Running times for the HECBioSim model 

|Number of nodes|Wall clock time (hours)| 
|-|-|
|1|0.86 | 
|2|0.44  |
|4|0.23 |
|8|0.12 | 
|16|0.07 |

## Summary

- LAMMPS was successfully tested on HBv3 standalone VMs and Azure CycleCloud multi-node configurations with as many as 16 nodes. 
- In multi-node configurations, tests indicate speed increases of about 3.29x for the Lennard-Jones model about 12.88x for the HECBioSim model. 
- For small simulations, we recommend that you use fewer CPUs to improve performance.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:
- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Amol Rane](https://www.linkedin.com/in/amol-rane-b47571ab/) | HPC Performance Engineer

Other contributors:
- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director, Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

*To see non-public LinkedIn profiles, sign into LinkedIn.*

## Next steps

- [GPU-optimized virtual machine sizes](/azure/virtual-machines/sizes-gpu)
- [Linux virtual machines on Azure](/azure/virtual-machines/linux/overview)
- [Virtual networks and virtual machines on Azure](/azure/virtual-network/network-overview)
- [Learning path: Run HPC applications on Azure](/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)
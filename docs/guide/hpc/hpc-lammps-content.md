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

image

link 

This diagram shows a single-node configuration:

image 

link? 

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Linux VMs.  
  - For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml). 
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud.  
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VMs.
  - A public IP address connects the internet to the VM.
- [Azure CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud) is used to create the cluster in the multi-node configuration. 
- A physical SSD is used for storage.

## Compute sizing

Performance tests of LAMMPS on Azure used [HBv3 AMD EPYC 7V73X]() (Milan-X) VMs running Linux CentOS Operating system. The following table provides details about HBv3-series VMs.


|VM size|vCPU|Memory (GiB)|Memory bandwidth GBps|Base CPU frequency (Ghz)|All-cores frequency (Ghz, peak)|Single-core frequency (Ghz, peak)|RDMA performance (Gbps) |Maximum data disks|
|-|-|-|-|-|-|-|-|-| 
|Standard_HB120rs_v3|120 |448|350|1.9|3.0|3.5|200|32|
|Standard_HB120-96rs_v3|96|448|350|1.9|3.0|3.5|200|32|
|Standard_HB120-64rs_v3|64|448|350|1.9|3.0|3.5|200|32|
|Standard_HB120-32rs_v3|32|448|350|1.9|3.0|3.5|200|32|
|Standard_HB120-16rs_v3|16 |448|350|1.9|3.0|3.5|200|32| 

## Install LAMMPS on a VM or HPC Cluster 

The software can be downloaded from [LAMMPS](https://docs.lammps.org/Install.html) Official website. A LAMMPS binary distribution need only be untarred or unzipped and can be run directly in the resulting directory and guide for building from source code can be found [here](https://docs.lammps.org/Build.html). 

Before you install LAMMPS, you need to deploy and connect to a VM or HPC Cluster. 

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

For information about deploying the Azure CycleCloud and HPC cluster, see below articles: 
- [Install and configure Azure CycleCloud](/training/modules/azure-cyclecloud-high-performance-computing/4-exercise-install-configure/)
- [Create an HPC cluster](/training/modules/azure-cyclecloud-high-performance-computing/5-exercise-create-cluster/)

### Install LAMMPS 

Follow the steps below to install LAMMPS in single node and cluster VMs. 

1. Export the below commands: 

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

1. Download the source code from [here](https://www.lammps.org/download.html) 

1. Unzip the file using the below command 
   ```
   tar xvf *
   ```

1. Locate the LAMMPS folder with following command: 
   
   ```
   cd lammps-<version> 

   cd src 
   ```

1. Execute below commands in src folder to build LAMMPS: 

   ```
   make yes-rigid 

   make serial 

   make mpi 
   ```

### Run LAMMPS

1. To execute LAMMPS simulation on Standalone VM use below commands: 

   ```
   export PATH=$PATH:/opt/openmpi-4.1.0/bin/ 

   export LD_LIBRARY_PATH=/opt/openmpi-4.1.0/lib 

   export LMP_MPI=/path/LAMMPS/lammps-<version>/src/lmp_mpi 

   mpirun -np 16 /path/LAMMPS/lammps-<version>/src/lmp_mpi -in in.lj 
   ```

1. To execute LAMMPS simulation on Multi node (Cluster) use below script: 

   ```
   #!/bin/bash 

   #SBATCH --job-name=LAMMPS 

   #SBATCH --partition=hpc 

   #SBATCH --nodes=2 

   #SBATCH --ntasks-per-node=64 

   #SBATCH --ntasks=128 

   export PATH=$PATH:/opt/openmpi-4.1.0/bin/ 

   export LD_LIBRARY_PATH=/opt/openmpi-4.1.0/lib 

   export LMP_MPI=/path/LAMMPS/lammps-<version>/src/lmp_mpi 

   mpirun -np 64 /path/LAMMPS/lammps-<version>/src/lmp_mpi -in benchmark.in 

> [!Note]
>
>#SBATCH --nodes=a (No. of nodes) 
>
>#SBATCH --ntasks-per-node=b (No. of cores per VM configuration) 
>
>#SBATCH --ntasks=a*b 

## LAMMPS performance results on Azure Virtual Machines

Two models were considered for testing the scalability performance of LAMMPS v23  and v17 Nov2016 on Azure. 

- In.lj (Lennard-Jones) - It is a simple molecular dynamics simulation of a binary fluid in the NVT ensemble. It is made of neutral dots with a Langevin thermostating. 
- HECBioSim – It is benchmark suite consists of a set of simple benchmarks for a number of popular Molecular Dynamics (MD) engines, each of which is set at a different atom count.

The details of each test model are provided in the following sections.

Model 1: In.lj (Lennard-Jones) 

To validate LAMMPS scaling on Azure HPC systems, Lennard-Jones (lj) liquid model is used (1.0e+9 atoms). The following table provides details about the model.


|Model Details|No. of atoms |Timestep|Thermo Step|Run steps|
|-|-|-|-|-|
|In.lj|1.0e+9 atoms|0.1 |10|200| 

Model 2: HECBioSim 

The following table provides details about the model.

|Model Details|No. of atoms |Timestep|Thermo Step|Run steps|
|-|-|-|-|-|
|HECBioSim|1403180 atoms|2.0|5000|10000| 

### LAMMPS 23June2022 performance results on single-node VMs

The following sections provide the performance results of running LAMMPS on single-node Azure [HBv3 AMD EPYC 7V73X](/azure/virtual-machines/hbv3-series) (Milan-X) VMs.  

Model 1: in.lj (Lennard-Jones) 

This table shows total wall clock time recorded for varying number of CPUs on the Standard HBv3-series VM: 


|Number of cores|Wall clock time (seconds)|Relative speed increase| 
|-|-|-|
|16|7634|1|
|32|4412|1.73|
|64|2102|3.63|
|96|1648|4.63| 
|120|1445|5.28| 

The following graph shows the relative speed increase as the number of CPUs increases: 

image 

#### Notes about the single-node tests

For all single-node tests we have taken the solver time on HB120-16rs_v3 (16 cores) as the reference to calculate the relative speed up with respect to other similar VMs with more cores. The results presented above show that parallel performance improves as we increase from 16 to 120 cores. We can observe a speedup of about 5.3x is achieved with 120 cores.

### LAMMPS performance results on multi-node cluster

The single-node tests confirm that the solver gives optimal parallel performance with 64 cores on HBv3 VMs. Based on those results, 64-core configurations on [Standard_HB120-64rs_v3](/azure/virtual-machines/hbv3-series) VMs were used to evaluate the performance of LAMMPS on multi-node clusters. In.lj (Lennard-Jones) and HECBioSim Models are used for multi-node runs. The following sections provide the test results.  

Model 1: In.lj (Lennard-Jones Liquid) 

This table shows total wall clock time recorded for varying numbers of Nodes with Standard HBv3-series VMs:


|Number of nodes |Number of cores|Wall clock time (seconds)|Relative speed increase |
|-|-|-|-|
|1 |64|2612|1.00|
|2|128|1573|1.66|
|4|256|1035|2.52| 
|8|512|793|3.29| 

The following graph shows the relative speed increase as the number of nodes increases: 

image 

Model 2: HECBioSim 

This table shows total wall clock time recorded for varying numbers of Nodes with Standard HBv3-series VMs: 

|Number of nodes |Number of cores|Wall clock time (seconds)|Relative speed increase |
|-|-|-|-|
|1|64|3103|1| 
|2|128|1601|1.94| 
|4|256|840|3.69| 
|8|512|442|7.02| 
|16|1024|241|12.88| 

The following graph shows the relative speed increase as the number of nodes increases: 

image 

#### Notes about the multi-node tests  

- From the multi-node results we can observe that, both models are scaling very well with increase in number of nodes.  
- The model **in.lj (Lennard-Jones Liquid)** is tested using LAMMPS version June2022 and the model **HECBioSim** is tested using LAMMPS version Nov2016.

## Azure cost 

Only simulation running time has been considered for the cost calculations. Installation time, simulation setup time and software costs have been ignored. 

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate VM costs for your configurations. 

The following tables provide the solver times in hours. The Azure VM hourly rates are subject to change. To compute the cost, multiply the wall clock time by the number of nodes and the Azure VM hourly cost which you can find [here for Linux](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

### Cost for model 1: in.lj (Lennard-Jones)

|Number of nodes|Wall clock time (Hr)| 
|-|-|
|1|0.73| 
|2|0.44 |
|4|0.29|
|8|0.22| 

### Cost for model 2: HECBioSim 

|Number of nodes|Wall clock time (Hr)| 
|-|-|
|1|0.86 | 
|2|0.44  |
|4|0.23 |
|8|0.12 | 
|16|0.07 |

## Summary

- LAMMPS was successfully tested on Azure using HBv3 standalone Virtual Machines and Azure Cycle Cloud multi-node (cluster) setup upto 16 nodes. 
- We can see a very good scaleup of about 3.28x for Lennard-Jones liquid and a very good scaleup of about 12.38x for HECBioSim model with the multi-node setup. 
- For small problems, we recommend that you use fewer CPUs to improve performance.

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
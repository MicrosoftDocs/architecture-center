This article describes the steps for running [NAMD](http://www.ks.uiuc.edu/Research/namd/) application on a virtual machine (VM) that’s deployed on Azure. It also presents the performance results of running NAMD on single-node and multi-node VM configurations. 

NAMD is a computer software for molecular dynamics  simulation, written using the [Charm++](https://en.wikipedia.org/wiki/Charm%2B%2B) parallel programming model. It has been developed by the collaboration of the Theoretical and Computational Biophysics Group (TCB) and the Parallel Programming Laboratory (PPL) at the University of Illinois at Urbana–Champaign. It is noted for its parallel efficiency and is often used to simulate large systems (millions of [atoms](https://en.wikipedia.org/wiki/Atom)). It is a parallel molecular dynamics code designed for high-performance simulation of large biomolecular systems. NAMD supports hundreds of cores for typical simulations and exceeds 500,000 cores for the largest simulations based on Charm++ parallel objects.  The NAMD simulation tool performed the first all-atom simulation of a virus in 2006, and a molecular dynamics flexible fitting interaction of an HIV virus capsid in 2012. Simulations and trajectory analysis are performed with the popular molecular graphics program VMD, but NAMD is also compatible with AMBER, CHARMM, and X-PLOR files. A source code version of NAMD is available for free.

NAMD is used mainly in areas were high-performance simulation of large biomolecular systems. Typical NAMD simulations include all-atom models of proteins, lipids, and/or nucleic acids as well as explicit solvent (water and ions).

**Why deploy** **NAMD on Azure?**

With Azure’s HB-series VMs, NAMD customers can reduce the time and cost of their simulations.

Running molecular simulation and analysis tasks in the Azure can significantly lower the barriers to use of advanced simulation methods and practical solution for many molecular modelling tasks.

By adapting NAMD and associated tools to operate within the Azure HB-series platform, enabling popular research workflows such as MDFF structure refinement and QwikMD simulation protocols to be run remotely by scientists all over the globe, with no need for investment in local computing resources and a reduced requirement for expertise in high performance computing technologies.

**Architecture**

Multi-node configuration:

:::image type="content" source="media/image1.png" alt-text="Image showing a architecture diagram of a multi node cluster in azure." border="true":::

Single-node configuration:

:::image type="content" source="media/image2.png" alt-text="Image showing a architecture diagram of a single node vm in azure." border="true":::

**Components**

[Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Linux and Windows VMs. 

For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](https://learn.microsoft.com/azure/architecture/reference-architectures/n-tier/linux-vm).

[Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud. 

[Network security groups](https://learn.microsoft.com/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VMs.  

A public IP address connects the internet to the VM.   

[Azure CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud) is used to create the cluster in the multi-node configuration.

A physical SSD is used for storage.  

**Compute sizing and drivers**

Performance tests of NAMD on Azure used HBv3 AMD EPYC™ 7V73X (Milan-X) VMs running Linux CentOS Operating system. The following table provides details about HBv3-series VMs.

| **VM size** | **vCPU** | **Memory (GiB)** | **Memory bandwidth** **GBps** | **Base CPU frequency (Ghz)** | **All-cores frequency (Ghz, peak)** | **Single-core frequency (Ghz, peak)** | **RDMA performance (Gbps)** | **Maximum data disks** |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **Standard_HB120rs_v3** | 120 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| **Standard_HB120-96rs_v3** | 96 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| **Standard_HB120-64rs_v3** | 64 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| **Standard_HB120-32rs_v3** | 32 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| **Standard_HB120-16rs_v3** | 16 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |

**Required** **drivers**

To use InfiniBand, you need to enable InfiniBand drivers.

**Install** **NAMD 2.14 on a VM** **or HPC Cluster**

The software can be downloaded from [NAMD](https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=NAMD) Official website. A NAMD binary distribution need only be untarred or unzipped and can be run directly in the resulting directory and guide for building from source code can be found [here.](https://www.ks.uiuc.edu/Research/namd/2.14/notes.html)

Before you install NAMD, you need to deploy and connect to a VM or HPC Cluster.

For information about deploying the VM and installing the drivers, see one of these articles:

[Run a Windows VM on Azure](https://docs.microsoft.com/azure/architecture/reference-architectures/n-tier/windows-vm)

[Run a Linux VM on Azure](https://docs.microsoft.com/azure/architecture/reference-architectures/n-tier/linux-vm)

For information about deploying the Azure CycleCloud and HPC cluster, see below articles:

[Install and configure Azure CycleCloud](https://docs.microsoft.com/learn/modules/azure-cyclecloud-high-performance-computing/4-exercise-install-configure/)

[Create a HPC Cluster](https://docs.microsoft.com/learn/modules/azure-cyclecloud-high-performance-computing/5-exercise-create-cluster/)

**NAMD 2.14** **performance** **results**

Two models were considered for testing the scalability performance of NAMD version 2.14 on Azure

STMV - It is a small, icosahedral plant virus which worsens the symptoms of infection by Tobacco Mosaic Virus (TMV). 

ApoA1 - It is a component of high-density lipoprotein (HDL). The APOA1 gene provides instructions for making a protein called apolipoprotein A-I. 

The details of each test model are provided in the following sections.

**Model** **1:** **STMV**

![Image of a STMV model](media/image3.png)

To validate NAMD 2.14 scaling on Azure HPC systems, STMV has been tiling in arrays of 5x2x2 (21M atoms). The following table provides details about the model.

| **Model Details** | **No.** **of atoms** | **Timestep** | **No. of steps** | **Method** |
|:---:|:---:|:---:|:---:|:---:|
| **1a** | 1,066,628 atoms | 1 | 2000 | PME(Particle Mesh Ewald) |
| **1b** | 21,000,000 atoms | 2 | 1200 | PME(Particle Mesh Ewald) |

**Model** **2:** **ApoA1**

![Image of a ApoA1 model](media/image4.png)

The following table provides details about the model.

| **Model Details** | **No.** **of atoms** | **Timestep** | **No. of steps** | **Method** |
|:---:|:---:|:---:|:---:|:---:|
| **2** | 92,224 atoms | 1 | 2000 | PME(Particle Mesh Ewald) |

**NAMD 2.14** **performance** **results on** **single-node VMs**

The following sections provide the performance results of running NAMD on single-node Azure [HBv3 AMD EPYC™ 7V73X](https://docs.microsoft.com/azure/virtual-machines/hbv3-series) (Milan-X) VMs. 

**Model 1a:** **STMV**

This table shows nanoseconds per day and total wall clock time recorded for varying number of CPUs on the Standard HBv3-series VM:

| **Number ofcores** | **ns per day** | **Wall clocktime(seconds)** | **Relativespeedincrease** |
|:---:|:---:|:---:|:---:|
| **16** | 0.168 | 1046.34 | 1.00 |
| **32** | 0.306 | 633.58 | 1.65 |
| **64** | 0.535 | 380.58 | 2.75 |
| **96** | 0.692 | 308.60 | 3.39 |
| **120** | 0.692 | 312.93 | 3.34 |

The following graph shows the relative speed increase as the number of CPUs increases:

The following graph shows the nanoseconds per day increase as the number of CPUs increases:

**Model 1b:** **STMV**

This table shows nanoseconds per day and total wall clock time recorded for varying number of CPUs on the Standard HBv3-series VM:

| **Number ofcores** | **ns per day** | **Wall clocktime(seconds)** | **Relativespeedincrease** |
|:---:|:---:|:---:|:---:|
| **16** | 0.014 | 14712.03 | 1.00 |
| **32** | 0.028 | 7715.94 | 1.91 |
| **64** | 0.054 | 4092.31 | 3.60 |
| **96** | 0.070 | 3239.06 | 4.54 |
| **120** | 0.078 | 2955.45 | 4.98 |

The following graph shows the relative speed increase as the number of CPUs increases:

The following graph shows the nanoseconds per day increase as the number of CPUs increases:

**Model 2:** **ApoA1**

This table shows nanoseconds per day and total wall clock times recorded for varying number of CPUs on the Standard HBv3-series VM:

| **Number ofcores** | **ns per day** | **Wall clocktime(seconds)** | **Relativespeedincrease** |
|:---:|:---:|:---:|:---:|
| **16** | 1.794 | 130.61 | 1.00 |
| **32** | 3.004 | 82.67 | 1.58 |
| **64** | 4.285 | 66.36 | 1.97 |
| **96** | 4.966 | 61.51 | 2.12 |
| **120** | 5.288 | 58.89 | 2.22 |

The following graph shows the relative speed increase as the number of CPUs increases:

The following graph shows the nanoseconds per day increase as the number of CPUs increases:

**Notes about the** **single-node** **tests** 

For all single-node tests we have taken the solver time on HB120-16rs_v3 (16 cores) as the reference to calculate the relative speed up with respect to other similar VMs with more cores. The results presented above show that parallel performance improves as we increase from 16 to 64 cores, then at 120 cores some simulations show very limited improvement. This is a common occurrence with these simulations and other memory intensive applications due to the saturation of the onboard memory available on each processor. Taking VM costs into consideration, the 64-CPU configuration is the best choice. Standard_HB120-64rs_v3 VMs, which have 64 cores, were used for the multi-node tests.

**NAMD 2.14** **performance** **results on** **multi-node** **cluster**

The single-node tests confirm that the solver gives optimal parallel performance with 64 cores on HBv3 VMs. Based on those results, 64-core configurations on [Standard_HB120-64rs_v3](https://learn.microsoft.com/azure/virtual-machines/hbv3-series) VMs were used to evaluate the performance of NAMD on multi-node clusters. Based on the single-node results, STMV Model 1b is used for multi-node runs. The following sections provide the test results. 

**Model 1b:** **STMV**

This table shows nanoseconds per day and total wall clock time recorded for varying numbers of Nodes with Standard HBv3-series VMs:

| **Number of** **nodes** | **Number ofcores** | **ns per day** | **Wall clocktime(seconds)** | **Relativespeedincrease** |
|:---:|:---:|---|:---:|:---:|
| **1** | 64 | 0.054 | 3835.48 | 1.00 |
| **2** | 128 | 0.157 | 1340.54 | 2.86 |
| **4** | 256 | 0.313 | 675.18 | 5.68 |
| **8** | 512 | 0.619 | 346.97 | 11.05 |
| **16** | 1024 | 1.221 | 183.09 | 20.95 |

The following graph shows the relative speed increase as the number of nodes increases:

The following graph shows the nanoseconds per day increase as the number of nodes increases:

**Notes about** **the multi-node** **tests** 

We can observe from the multi-node results, the model 1b is scaling very well with the increase of number of nodes. For better performance of the application use memory-optimized version which can be done by compiling source code. This simulation we performed is limited to only a few iterations, since real-world iterations can be more numerous, you can minimize the total amount of time required for decomposition, improving performance further.

**Azure cost**

Only simulation running time has been considered for the cost calculations. Installation time, simulation setup time and software costs have been ignored.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate VM costs for your configurations.

The following tables provide the solver times in hours. The Azure VM hourly rates are subject to change. To compute the cost, multiply the solver time by the number of nodes and the Azure VM hourly cost which you can find [here for Windows](https://azure.microsoft.com/pricing/details/virtual-machines/windows/)  and  [here for Linux](https://azure.microsoft.com/pricing/details/virtual-machines/linux/).

**Cost for** **model 1b:** **STMV**

| **Number**<br>**of** **nodes** | **Wall clock** **time** **(Hr)** |
|:---:|:---:|
| 1 | 1.07 |
| 2 | 0.37 |
| 4 | 0.19 |
| 8 | 0.10 |
| 16 | 0.05 |

**Summary**

NAMD 2.14 was successfully tested on Azure using HBv3 standalone Virtual Machines and Azure Cycle Cloud multi-node (cluster) setup.

We can see a very good scaleup for the model 1b with the multi-node setup. A speedup of about 21 is achieved with 16 nodes which is a very impressive value.

For better performance we recommend using one thread per processor with the +p option and look for pre-built ibverbs NAMD binaries or specify ibverbs when building Charm++.

For small problems, we recommend that you use fewer CPUs to improve performance.

**Contributors**

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

[Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager

[Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager

[Preetham Y M](https://www.linkedin.com/in/preetham-y-m-6343a6212/) | HPC Performance Engineer

Other contributors:

[Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer

[Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy

[Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

*To see non-public LinkedIn profiles, sign into LinkedIn.*

**Next steps**

[GPU Optimized Virtual Machine Sizes](https://docs.microsoft.com/azure/virtual-machines/sizes-gpu)

[Windows Virtual Machines in Azure](https://docs.microsoft.com/azure/virtual-machines/windows/overview)

[Virtual networks and virtual machines on Azure](https://learn.microsoft.com/azure/virtual-network/network-overview)

[Learning path: Run high-performance computing (HPC) applications on Azure](https://learn.microsoft.com/training/paths/run-high-performance-computing-applications-azure)

**Related resources**

[Run a Linux VM on Azure](https://learn.microsoft.com/azure/architecture/reference-architectures/n-tier/linux-vm)

[HPC system and big-compute solutions](https://learn.microsoft.com/azure/architecture/solution-ideas/articles/big-compute-with-azure-batch)

[HPC cluster deployed in the cloud](https://learn.microsoft.com/azure/architecture/solution-ideas/articles/hpc-cluster)


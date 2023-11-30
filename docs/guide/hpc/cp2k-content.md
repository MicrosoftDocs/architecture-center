This article describes the steps for running a CP2K application on a virtual machine (VM) deployed on Azure. It also presents the performance results of running CP2K on single-node and multi-node VM configurations. 

CP2K is a quantum chemistry and solid-state physics software package that can perform atomistic simulations of solid state, liquid, molecular, periodic, material, crystal, and biological systems. CP2K provides a general framework for different modeling methods, such as DFT, using the mixed Gaussian and plane waves approaches GPW and GAPW. Supported theory levels include DFTB, LDA, GGA, MP2, RPA, semi-empirical methods, and classical force fields. CP2K can do simulations of molecular dynamics, meta dynamics, Monte Carlo, Ehrenfest dynamics, vibrational analysis, core level spectroscopy, energy minimization, and transition state optimization using NEB or dimer method. CP2K is written in Fortran 2008 and can be run efficiently in parallel using a combination of multi-threading, MPI, and CUDA. It includes Ab-initio electronic structure theory methods using the QUICKSTEP module, Ab-initio Molecular Dynamics, and Mixed quantum-classical simulations.

## Why deploy CP2K on Azure?

- Single-point energies, geometry optimizations, and frequency calculations
- Several nudged-elastic band (NEB) algorithms (B-NEB, IT-NEB, CI-NEB, D-NEB) for minimum energy path (MEP) calculations
- Global optimization of geometries
- Solvation via the Self-Consistent Continuum Solvation (SCCS) model
- Metadynamics including well-tempered Metadynamics for Free Energy calculations
- Classical Force-Field (MM) and Monte-Carlo (MC) KS-DFT simulations
- Static (such as spectra) and dynamical (such as diffusion) properties
- ATOM code for pseudopotential generation

## Architecture

This section shows the differences between the architecture for a multi-node configuration and the architecture for a single-node configuration.

**Multi-node configuration**:

This architecture shows a multi-node configuration:

:::image type="content" source="media/cp2k/cp2k-multi-node-architecture.svg" alt-text="Diagram that shows an architecture for deploying CP2K in a multi-node configuration." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/cp2k-multi-node-architecture.vsdx) of this architecture.*

**Single-node configuration**:

This architecture shows a single-node configuration:

:::image type="content" source="media/cp2k/cp2k-single-node-architecture.svg" alt-text="Diagram that shows an architecture for deploying CP2K in a single-node configuration." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/cp2k-single-node-architecture.vsdx) of this architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create a Linux VM. For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  - A public IP address connects the internet to the VM.
- [Azure CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud) is used to create the cluster in the multi-node configuration.
- A physical SSD is used for storage.

## Compute sizing and drivers

Performance tests of CP2K on Azure [HBv3 AMD EPYC™ 7V73X](/azure/virtual-machines/hbv3-series) VMs running Linux CentOS Operating system are presented in the following sections. This table provides details about HBv3-series VMs:

| VM size | vCPU | Memory (GiB) | Memory bandwidth (GBps) | Base CPU frequency (GHz) | All-cores frequency (GHz, peak) | Single-core frequency (GHz, peak) | RDMA performance (GBps) | Maximum data disks |
|-|-|-|-|-|-|-|-|-|
| Standard_HB120-96rs_v3 | 96 | 448 | 350| 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-64rs_v3 | 64 | 448 | 350| 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-32rs_v3 | 32 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-16rs_v3 | 16 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |

### Required drivers

To use InfiniBand, you must enable [InfiniBand](/azure/virtual-machines/extensions/enable-infiniband) drivers.

## CP2K installation

For current performance testing, CP2K 2023.1 was used. The software can be downloaded from the [CP2K Official website](https://www.cp2k.org/download). A CP2K binary distribution need only be unzipped and can be run directly in the resulting directory. To view instructions for building from source code, see [How to compile the CP2K code](https://github.com/mkrack/cp2k/blob/master/INSTALL.md).

Before you install CP2K, you need to deploy and connect to a VM or HPC Cluster.

For information about deploying the VM and installing the drivers, see one of these articles:

- [Run a Windows VM on Azure](/azure/architecture/reference-architectures/n-tier/windows-vm)
- [Run a Linux VM on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm)

For information about deploying the Azure CycleCloud and HPC cluster, see below articles:

- [Install and configure Azure CycleCloud](/learn/modules/azure-cyclecloud-high-performance-computing/4-exercise-install-configure/)
- [Create a HPC Cluster](/learn/modules/azure-cyclecloud-high-performance-computing/5-exercise-create-cluster/)

## CP2K performance results

Three models were considered for testing the performance scalability of CP2K on Azure. The details of each test model are provided in the following sections.

| Model Details | H2O-256 (Single Node) | H2O-1024 (Multi Node) | QMMM-CLC-19 (Single Node) |
|-|-|-|-|
| **Model Description** | Ab-initio molecular dynamics of liquid water using the Born-Oppenheimer approach, using Quickstep DFT. Production quality settings for the basis sets (TZV2P) and the planewave cutoff (280 Ry) are chosen, and the Local Density Approximation (LDA) is used for the calculation of the Exchange-Correlation energy. | Ab-initio molecular dynamics of liquid water using the Born-Oppenheimer approach, using Quickstep DFT. Production quality settings for the basis sets (TZV2P) and the planewave cutoff (280 Ry) are chosen, and the Local Density Approximation (LDA) is used for the calculation of the Exchange-Correlation energy. | A short QM/MM MD simulation of five steps. ClC consists of a (ClC-ec1) chloride ion channel embedded in a lipid bilayer that is solvated in water. |
| **No. of atoms** | 768 | 3072 | 150925 |
| **Timestep** | 10 | 10 | 5 |
| **Run step** | 0.5 | 0.5 | 1.0 |
| **Temperature (K)** | 300 | 300 | 300 |

### CP2K performance results on single-node

The following sections provide the performance results of running CP2K on single-node Azure [HBv3 AMD EPYC™ 7V73X](/azure/virtual-machines/hbv3-series) VMs.

#### Model 1: H2O-256

This table shows total wall clock time recorded for varying number of CPUs on the standard HBv3-series VM:

| Number of cores | Wall clock time (seconds) | Relative speed up |
|-|-|-|
| 16 | 1139.52 | 1.00 |
| 32 | 606.62 | 1.88 |
| 64 | 394.31 | 2.89 |
| 96 | 343.12 | 3.32 |

This graph shows the relative speedup as the number of CPUs increases:

:::image type="content" source="media/cp2k/model-1-h2o-256.png" alt-text="Diagram that shows the relative speedup for an H2O-256 model in a single-node configuration." border="false":::

#### Model 2: QMMM-CLC-19

This table shows total wall clock time recorded for varying number of CPUs on the standard HBv3-series VM:

| Number of cores | Wall clock time (seconds) | Relative speed up |
|-|-|-|
| 16 | 569.82 | 1.00 |
| 32 | 343.29 | 1.66 |
| 64 | 229.00 | 2.49 |
| 96 | 190.47 | 2.99 |

This graph shows the relative speedup as the number of CPUs increases:

:::image type="content" source="media/cp2k/model-2-qmmm-clc-19.png" alt-text="Diagram that shows the relative speedup for a QMMM-CLC-19 model in a single-node configuration." border="false":::

#### Notes about the single-node tests

For all single-node tests, we take the solver time on HB120-16rs_v3 (16 cores) as the reference to calculate the relative speedup with respect to other similar VMs with more cores. The results presented earlier show that parallel performance improves as we increase from 16 to 64 cores. Then at 96 cores, some simulations show limited improvement.

This occurrence is common with these simulations and other memory intensive applications due to the saturation of the onboard memory available on each processor. When you consider VM costs and model complexity, the 32-CPU configuration is the best choice. Standard_HB120-32rs_v3 VMs, which have 32 cores, were used for the multi-node tests.

### CP2K performance results on multi-node

This section provides the performance results of running CP2K on multi-node VMs.

#### Model 3: H2O-1024

This table shows total wall clock time recorded for varying numbers of nodes with standard HBv3-series VMs:

| Number of nodes | Number of cores | Wall clock time (seconds) | Relative speed up |
|-|-|-|-|
| 1 | 32 | 4651.98 | 1.00 |
| 2 | 64 | 2413.77 | 1.93 |
| 3 | 128 | 1424.87 | 3.26 |
| 4 | 256 | 812.34 | 5.73 |

This graph shows the relative speedup as the number of nodes increases:

:::image type="content" source="media/cp2k/model-3-h2o-1024.png" alt-text="Diagram that shows the relative speedup for an H2O-1024 model in a multi-node configuration." border="false":::

## Azure cost

Only simulation running time is considered for the cost calculations. Installation time, simulation setup time, and software costs were ignored.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate VM costs for your configuration.

The following tables provide the solver times in hours. The Azure VM hourly rates are subject to change. To compute the cost, multiply the wall clock time by the number of nodes and the Azure VM hourly cost, which you can find [here for Windows](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing) and [here for Linux](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

**Cost for model 1: H2O-256**:

| Number of cores | Wall clock time (hours) |
|-|-|
| 16 | 0.32 |
| 32 | 0.17 |
| 64 | 0.11 |
| 96 | 0.10 |

**Cost for model 2: QMMM-CLC-19**:

| Number of cores | Wall clock time (hours) |
|-|-|
| 16 | 0.16 |
| 32 | 0.10 |
| 64 | 0.06 |
| 96 | 0.05 |

**Cost for model 3 : H2O-1024**:

| Number of nodes | Wall clock time (hours) |
|-|-|
| 1 | 1.29 |
| 2 | 0.67 |
| 4 | 0.40 |
| 8 | 0.23 |

## Summary

- CP2K was successfully tested on Azure using HBv3 standalone VMs and Azure Cycle Cloud multi-node (cluster) setup.
- We can see a good scaleup for all models on both single-node and multi-node setup. For single-node, we could observe a speedup of ~3.5X for H2O-256 model and a speedup of ~3X for QMMM-CLC-19 with 96 vCPUs.
- For multi-node runs, we could observe a scaleup of ~5.75X for H2O-1024 model with eight nodes.
- If necessary, we recommend that you use fewer CPUs to improve performance.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Saurabh Parave](https://www.linkedin.com/in/saurabh-parave-957303162/) | HPC Performance Engineer
- [Vivi Richard](https://www.linkedin.com/in/vivi-richard) | HPC Performance Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [GPU-optimized virtual machine sizes](/azure/virtual-machines/sizes-gpu)
- [Windows virtual machines on Azure](/azure/virtual-machines/windows/overview)
- [Virtual networks and virtual machines on Azure](/azure/virtual-network/network-overview)
- [Learning path: Run high-performance computing (HPC) applications on Azure](/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)

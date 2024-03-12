This article describes the steps for running the [Quantum ESPRESSO](https://www.quantum-espresso.org/) application on a virtual machine (VM) deployed on Azure. It also presents the performance results of running Quantum ESPRESSO on single-node and multi-node VM configurations.

Quantum ESPRESSO is based on density-functional theory, plane waves, and pseudopotentials. Quantum ESPRESSO is an integrated suite of open-source computer codes for electronic-structure calculations and materials modeling at the nanoscale. The Quantum ESPRESSO distribution consists of a historical core set of components, and a set of plug-ins that perform more advanced tasks, plus many third-party packages designed to be inter-operable with the core components.

Quantum ESPRESSO runs on many different architectures and conditions:

- Ground state calculations utilizing local density approximation (LDA), Generalized Gradient Approximation (GGA), GGA+U, van der Waals (vdW-DF) and Hybrid Exchange-Correlation Functionals
- Support of Ultrasoft (US), Norm-Conserving (NC) pseudopotentials and Projector Augmented Wave (PAW) method
- Structural optimization and polymorphism studies
- Transition states and minimum energy paths using Nudged Elastic Bands (NEB) method
- Linear response properties within Density Functional Perturbation theory (DFPT)
- Spectroscopic properties
- Effective Screening Medium (ESM) for charged surfaces and interfaces

Quantum ESPRESSO is used mainly by researchers active in the field of electronic-structure calculations.

## Why deploy Quantum ESPRESSO on Azure?

- Modern and diverse compute options to meet your workload's needs.
- The flexibility of virtualization without the need to buy and maintain physical hardware.
- Rapid provisioning.
- Complex problems solved within a few hours.

## Architecture

This section shows the differences between the architecture for a multi-node configuration and the architecture for a single-node configuration.

**Multi-node configuration**:

:::image type="content" source="media/quantum-espresso/quantum-espresso-multi-node-architecture.svg" alt-text="Diagram that shows an architecture for deploying Quantum ESPRESSO in a multi-node configuration." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/quantum-espresso-multi-node-architecture.vsdx) of this
architecture.*

**Single-node configuration**:

:::image type="content" source="media/quantum-espresso/quantum-espresso-single-node-architecture.svg" alt-text="Diagram that shows an architecture for deploying Quantum ESPRESSO in a single-node configuration." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/quantum-espresso-single-node-architecture.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Linux and Windows VMs. For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VMs.  
  - A public IP address connects the internet to the VMs.
- [Azure CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud) is used to create the cluster in the multi-node configuration.
- A physical SSD is used for storage.

## Compute sizing and drivers

Performance tests of Quantum ESPRESSO on Azure used [HBv3 AMD EPYC™ 7V73X](/azure/virtual-machines/hbv3-series) VMs running Linux CentOS Operating system. The following table provides details about HBv3-series VMs.

| VM size | vCPU | Memory (GiB) | Memory bandwidth (GBps) | Base CPU frequency (GHz) | All-cores frequency (GHz, peak) | Single-core frequency (GHz, peak) | RDMA performance (GBps) | Maximum data disks |
|-|-|-|-|-|-|-|-|-|
| Standard_HB120rs_v3 | 120 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-96rs_v3 | 96 | 448 | 350| 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-64rs_v3 | 64 | 448 | 350| 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-32rs_v3 | 32 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-16rs_v3 | 16 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |

### Required drivers

To use InfiniBand, you must enable [InfiniBand](/azure/virtual-machines/extensions/enable-infiniband) drivers.

## Install Quantum ESPRESSO on a VM or HPC Cluster

Download the software from the [Quantum ESPRESSO](https://www.quantum-espresso.org/login/) official website.

Before you install Quantum ESPRESSO, deploy and connect to a VM or HPC Cluster. For information about deploying the VM and installing the drivers, see one of these articles:

- [Run a Windows VM on Azure](/azure/architecture/reference-architectures/n-tier/windows-vm)
- [Run a Linux VM on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm)

For information about deploying the Azure CycleCloud and HPC cluster, see one of these articles:

- [Install and configure Azure CycleCloud](/learn/modules/azure-cyclecloud-high-performance-computing/4-exercise-install-configure/)
- [Create a HPC Cluster](/learn/modules/azure-cyclecloud-high-performance-computing/5-exercise-create-cluster/)

### Install Quantum ESPRESSO

To install Quantum ESPRESSO on Azure Virtual Machines and run the simulations, see the following links:

- [Quantum ESPRESSO documentation](https://www.quantum-espresso.org/documentation/)
- [User’s Guide for Quantum ESPRESSO](https://www.quantum-espresso.org/Doc/user_guide_PDF/user_guide.pdf)

## Quantum ESPRESSO performance results

Quantum ESPRESSO was tested in single-node and multi-node configurations. Model *ta2o5* was used to test the scalability performance of Quantum ESPRESSO version 7.1 on Azure. The details of the model used for validation are as follows:

| Model Details | Number of atoms per cell | Number of atomic types | Number of electrons | Mixing beta |
|-|-|-|-|-|
| **ta2o5** | 25  | 2 | 125 | 0.5000 |

### Quantum ESPRESSO performance results on single-node VMs

This section provides the performance results of running Quantum ESPRESSO on single-node Azure [HBv3 AMD EPYC™ 7V73X](/azure/virtual-machines/hbv3-series) VMs.

#### Model 1: ta2o5

This table shows total wall clock time recorded for a varying number of CPUs on the standard HBv3-series VM:

| Number of cores | Wall clock time (seconds) | Relative speed up |
|-|-|-|
| 16 | 7213 | 1.00 |
| 32 | 3620 | 1.99 |
| 64 | 2344 | 3.08 |
| 96 | 1998 | 3.61 |
| 120 | 1527 | 4.72 |

This graph shows the relative speedup improvement as the number of CPUs increases:

:::image type="content" source="media/quantum-espresso/model-ta2o5-single-node.png" alt-text="Diagram that shows the relative speedup for a ta2o5 model in a single-node configuration." border="false":::

#### Notes about the single-node tests

For all single-node tests, a solver time of HB120-16rs_v3 (16 cores) is considered as the reference to compute the relative speed of other VMs with more cores. The speedup improves as we increase the number of cores from 16 to 120 cores. We can observe that a speedup of about 4.7x is achieved with 120 cores with the ta2o5 model.

### Quantum ESPRESSO performance results on a multi-node cluster

The single-node tests confirm that the solver gives optimal parallel performance with 64 cores on HBv3 VMs. Based on those results, 64-core configurations on Standard_HB120-64rs_v3 VMs were used to evaluate the performance of Quantum ESPRESSO on multi-node clusters. The ta2o5 model is used for multi-node runs.

This section provides the performance results of running Quantum ESPRESSO on multi-node VMs.

#### Model 1: ta2o5 for multi-node

This table shows total wall clock time recorded for varying numbers of nodes with standard HBv3-series VMs:

| Number of nodes | Number of cores | Wall clock time (seconds) | Relative speed up |
|-|-|-|-|
| 1 | 64 | 2270 | 1.00 |
| 2 | 128 | 1487 | 1.53 |
| 4 | 256 | 703 | 3.23 |
| 8 | 512 | 358 | 6.34 |

This graph shows the relative speed increase as the number of nodes increases:

:::image type="content" source="media/quantum-espresso/model-ta2o5-multi-node.png" alt-text="Diagram that shows the relative speedup for a ta2o5 model in a multi-node configuration." border="false":::

## Azure cost

Only model running time (wall clock time) is considered for these cost calculations. Application installation time isn't considered. The numbers presented here are indicative of your potential results. The actual numbers depend on the size of the model.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

The following table provides the elapsed times in hours. To compute the total cost, multiply these times by the hourly costs for [Linux VMs](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

**Cost for model 1: ta2o5**:

| Number of nodes | Wall clock time (hours) |
|-|-|
| 1 | 0.63 |
| 2 | 0.41 |
| 4 | 0.20 |
| 8 | 0.10 |

## Summary

- Quantum ESPRESSO was successfully tested on Azure using HBv3 standalone Virtual Machines and an Azure Cycle Cloud multi-node (cluster) setup.
- For a standalone VM, we can observe that the application is scaling up with an increase of vCPUs and achieved a speedup of 4.7x with 120 vCPUs.
- For multi-node runs, the application scales linearly with the increase of nodes. A scale up of about 6.5x is achieved for Quantum Espresso with eight nodes.
- For small problems, we recommend you use fewer CPUs to improve performance.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) | HPC Performance Engineer
- Shivakumar Tallolli | HPC Performance Engineer

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
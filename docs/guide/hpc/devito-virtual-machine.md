---
author: Ed Price
ms.date: 12/19/2023
---
# Deploy Devito on an Azure virtual machine

### This article describes the steps for running [Devito](https://www.devitoproject.org/) on an Azure virtual machine (VM), and presents the performance results of running Devito on Azure.

Devito is a functional language, implemented as a Python package, which enables optimized stencil computation (e.g., finite differences, image processing, machine learning) from high-level symbolic problem definitions. Devito builds on [SymPy](https://www.sympy.org/) and employs automated code generation and just-in-time compilation to execute optimized computational kernels on several compute platforms, including CPUs, GPUs, and clusters. 

**Devito provides key features like mechanisms to adjust finite difference discretization, constructs to express various operators, A** **flexible API, Generation of highly optimized parallel code, Distributed NumPy** **arrays, Smooth integration with popular Python packages etc.**

## Architectures

Single-node Architecture:

# <br><br>Multi-node Architecture:

![Azure HPC Architecture for running Devito on Azure platform](media/image1.png)

![](media/image2.png)

### Components

[Azure CycleCloud](https://learn.microsoft.com/azure/cyclecloud/) is an enterprise-friendly tool for orchestrating and managing HPC environments on Azure.

[Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create a Linux VM. For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm).

[Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud.

[Network security groups](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  

A public IP address connects the internet to the VM.

An [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs) physical solid-state drive (SSD) is used for storage.

CycleCloud REST API is used for adding automated and programmatic cluster management like determine cluster status, create nodes etc.

**Scenario details**<br><br>Deploying Devito on Azure can provide the following benefits:

- Modern and diverse compute options to meet your workload's needs.
- Flexibility of virtualization without the need to buy and maintain physical hardware.
- Rapid provisioning

Devito provides a functional language to implement sophisticated operators that can be made up of multiple stencil computations, boundary conditions, sparse operations (e.g., interpolation), and much more. A typical use case is explicit finite difference methods for approximating partial differential equations. For example, a 2D diffusion operator may be implemented with Devito as follows:

>>> grid = Grid(shape=(10, 10))<br>>>> f = TimeFunction(name='f', grid=grid, space_order=2)<br>>>> eqn = Eq(f.dt, 0.5 * f.laplace)<br>>>> op = Operator(Eq(f.forward, solve(eqn, f.forward)))>>> grid = Grid(shape=(10, 10))<br>>>> f = TimeFunction(name='f', grid=grid, space_order=2)<br>>>> eqn = Eq(f.dt, 0.5 * f.laplace)<br>>>> op = Operator(Eq(f.forward, solve(eqn, f.forward)))

- 

An Operator generates low-level code from an ordered collection of Eq (the example above being for a single equation). 

There is virtually no limit to the complexity of an Operator -- the Devito compiler will automatically analyze the input, detect and apply optimizations (including single- and multi-node parallelism), and eventually generate code with suitable loops and expressions.

### Devito installation

Before installing Devito, you need to deploy and connect a Linux VM and install the required AMD and InfiniBand drivers. For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](https://learn.microsoft.com/azure/architecture/reference-architectures/n-tier/linux-vm).

Once you have the Linux VM deployed, refer to the [Devito installation instructions](https://www.devitoproject.org/download.html) to learn about the 3 methods for installing the Devito on your VM: 

- Docker Installation
- Pip installation
- Installation using conda environment.

### Compute sizing and drivers

The Devito performance tests used [HBv3-series](https://learn.microsoft.com/en-us/azure/virtual-machines/hbv3-series) VMs running Linux, which is covered in detail in the next section. The following table provides details about the VMs used:

| **Size** | **vCPU** | **RAM memory (GiB)** | **Memory bandwidth (GBps)** | **Base CPU frequency (GHz)** | **All-cores frequency (GHz, peak)** | **Single-core frequency (GHz, peak)** | **RDMA performance (Gbps)** | **Maximum data disks** |
|---|---|---|---|---|---|---|---|---|
| **Standard_HB120rs_v3** | 120 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| **Standard_HB120-96rs_v3** | 96 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| **Standard_HB120-64rs_v3** | 64 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| **Standard_HB120-32rs_v3** | 32 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| **Standard_HB120-16rs_v3** | 16 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |

 

 

## Devito performance results

### Benchmarking Devito on Azure Virtual Machines

To test the performance of Devito on Azure Virtual machines, benchmarking was done using the HB120rs_v3 series SKU. There are lot of seismic models like acoustic, tti, elastic, visco-elastic etc., available in the tutorials section of Devito. We have used forward operator under acoustic model for benchmarking the performance of Devito.

The following table provides information about the VM that was used for testing.

:::row:::
    :::column:::
    **Operating system and Hardware Details (Azure Infrastructure)**
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
    **Operating system version**
    :::column-end:::
    :::column:::
    CentOS-based 8.1 HPC
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
    **OS Architecture**
    :::column-end:::
    :::column:::
    X86-64
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
    **Processor **
    :::column-end:::
    :::column:::
    AMD EPYC 7V73X
    :::column-end:::
:::row-end:::

**Benchmarking a Devito operator**

Users can use the ***benchmark.py*** python file to test the performance of Devito operator. The file is located at under the /benchmarks/user folder in the Devito folder. ***benchmark.py*** implements a minimalist framework to evaluate the performance of a Devito Operator while varying:

the problem size (e.g., shape of the computational grid).

the discretization (e.g., space- and time-order of the input/output fields).

the simulation time (in milliseconds).

the performance optimization level.

the autotuning level.

### Devito Performance on HB120rs_v3 (Single-Node)

The Devito forward operator performance for the acoustic model is tested on Standard HBv3 series virtual machines with 16, 32, 64, 96 and 120 vCPU configurations. The tests were performed with the CentOS 8.1 HPC image. The results are shown below.

 **Results for CentOS-based 8.1 HPC image**

| **# vCPUs(cores)** | **Forward Operator run time (sec)** | **G Flops/sec** | **Relative** <br>**Speed Up** |
|:---:|:---:|:---:|:---:|
| **16** | 184.39 | 211.24 | 1.00 |
| **32** | 126.20 | 308.55 | 1.46 |
| **64** | 117.61 | 331.22 | 1.57 |
| **96** | 132.86 | 293.25 | 1.39 |
| **120** | 149.99 | 259.78 | 1.23 |

**Speed up chart for** **CentOS-based** **8.1 HPC Results￼**

**Additional notes** **about** **single-node tests:**

The Devito operator is run on all the HBv3-series VM configurations. The runtime with Standard_HB120-16rs_v3 is taken as baseline to calculate the relative speedup.

### Devito performance on a cluster (multi-node):

Based on the Devito forward operator performance on HB120rs_v3 single nodes, you can observe scale up behavior for the 64 and 96 vCPU configurations. The following is a summary of running Devito operator on 2 cluster configurations with 64 vCPUs and 96 vCPUs respectively. CentOS-based 8.1 HPC image is used for these 2 clusters. The results for the two clusters are presented below.

**Results for cluster with 64 vCPUs per node:**

| **# Nodes** | **# vCPUs(cores)** | **Forward Operator run time (sec)** | **GFlops** | **Relative Speed Up** |
|:---:|:---:|:---:|:---:|:---:|
| **1** | 64 | 121.73 | 320.04 | 1.00 |
| **2** | 128 | 75.68 | 514.86 | 1.61 |
| **4** | 256 | 60.77 | 641.30 | 2.00 |
| **8** | 512 | 51.94 | 750.40 | 2.34 |

**Results for cluster with 96 vCPUs per node:**

| **VM Configuration** | **# Nodes** | **# vCPUs(cores)** | **Forward Operator run time (sec)** | **GFlops** | **Relative Speed Up** |
|:---:|:---:|:---:|:---:|:---:|:---:|
| **Standard_HB120-96rs_v3** | 1 | 96 | 137.19 | 284 | 1.00 |
| **Standard_HB120-96rs_v3** | 2 | 192 | 88.72 | 439.27 | 1.55 |
| **Standard_HB120-96rs_v3** | 4 | 384 | 75.11 | 518.93 | 1.83 |
| **Standard_HB120-96rs_v3** | 8 | 768 | 69.38 | 561 | 1.98 |

<br>

## Azure cost

The following table presents the wall-clock times for running the simulation. You can multiply these times by the Azure VM hourly costs for HB120rs_v3-series VMs to calculate costs. For the current hourly costs, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/).

Only the simulation time is represented in these times. Application installation time isn't considered.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

**HB120rsv3-series**

| **No. of CPUs per node** | **Forward Operator run time (Hr)** |
|---|---|
| **Single node** | 0.197 |
| **64 CPUs per node** | 0.086 |
| **96 CPUs per node** | 0.102 |

## Summary

Devito is successfully deployed and tested on HB120rs_v3 series VM on Azure Platform.

On the single-node configuration, we observed that the Devito is scaling very well up to 64 and 96 cores. A maximum scaleup of 1.57x is observed with 64 cores.  

_On the multi-node_ _configuration,_ _we_ _could_ _observe a gradual scaleup_ _from 1 node to 8 nodes_ *in both the clusters with Standard_HB120-64rs_v3 and Standard_HB120-96rs_v3 Virtual* _Machines respectively._

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal authors:

[Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager

[Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager

[Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) | HPC Performance Engineer

Other contributors:

[Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer

[Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy

[Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

_To see non-public LinkedIn profiles, sign_ _into LinkedIn._

## Next steps

[GPU-optimized virtual machine sizes](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes-gpu)

[Virtual machines on Azure](https://learn.microsoft.com/en-us/azure/virtual-machines/overview)

[Virtual networks and virtual machines on Azure](https://learn.microsoft.com/en-us/azure/virtual-network/network-overview)

[Learning path: Run high-performance computing (HPC) applications on Azure](https://learn.microsoft.com/en-us/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

[Run a Windows VM on Azure](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/windows-vm)

[Run a Linux VM on Azure](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm)

[HPC system and big-compute solutions](https://learn.microsoft.com/en-us/azure/architecture/solution-ideas/articles/big-compute-with-azure-batch)

[HPC cluster deployed in the cloud](https://learn.microsoft.com/en-us/azure/architecture/solution-ideas/articles/hpc-cluster)


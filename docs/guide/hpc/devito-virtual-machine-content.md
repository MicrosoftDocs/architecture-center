This article describes the steps to run [Devito](https://www.devitoproject.org) on an Azure virtual machine (VM). It also presents the performance results of running Devito on Azure.

Devito is a functional language that you implement as a Python package. With Devito, you can use high-level symbolic problem definitions to create optimized stencil computation, such as finite differences, image processing, and machine learning. Devito is built on [SymPy](https://www.sympy.org) and uses automated code generation and just-in-time compilation to run optimized computational kernels on several compute platforms, including CPUs, GPUs, and clusters.

Devito provides key offerings like:

- Mechanisms to adjust finite difference discretization.
- Constructs to express various operators.
- A flexible API.
- The ability to generate highly optimized parallel code.
- Distributed NumPy arrays.
- Smooth integration with popular Python packages.

## Architecture

Single-node architecture:

:::image type="content" source="./media/hpc-devito-single-node.svg" alt-text="Diagram that shows the single-node architecture." lightbox="./media/hpc-devito-single-node.svg" border="false":::
*Download a [Visio file](https://arch-center.azureedge.net/hpc-devito-single-node.vsdx) of this architecture.*

Multi-node architecture:

:::image type="content" source="./media/hpc-devito-multi-node.svg" alt-text="Diagram that shows the multi-node architecture." lightbox="./media/hpc-devito-multi-node.svg" border="false":::
*Download a [Visio file](https://arch-center.azureedge.net/hpc-devito-multi-node.vsdx) of this architecture.*

### Components

- [Azure CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud) is an enterprise-friendly tool for orchestrating and managing HPC environments on Azure.

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create a Linux VM. For information about how to deploy a VM and install drivers, see [Linux VMs on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm).

- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud.

- [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  

- A public IP address connects the internet to the VM.

- An [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs) physical solid-state drive (SSD) is used for storage.

- An [Azure CycleCloud REST API](/azure/cyclecloud/how-to/use-rest-api) is used to add automated and programmatic cluster management capabilities, like determining a cluster's status or creating nodes.

## Scenario details

Deploy Devito on Azure to provide the following benefits:

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning

Devito provides a functional language to implement sophisticated operators that can be made up of multiple stencil computations, boundary conditions, sparse operations (for example, interpolation), and more. With Devito, you might use explicit finite difference methods to approximate partial differential equations. For example, you might use Devito to implement a 2D diffusion operator by using the following equation:

:::image type="content" source="./media/operator-equation.png" alt-text="Screenshot that shows the operator equation." lightbox="./media/operator-equation.png":::

An Operator generates low-level code from an ordered collection of Eq (this example is for a single equation).

There's virtually no limit to the complexity of an Operator. The Devito compiler automatically analyzes the input, detects and applies optimizations (including single-node and multi-node parallelism), and generates code with suitable loops and expressions.

### Install Devito

Before you install Devito, you need to deploy and connect a Linux VM and install the required AMD and InfiniBand drivers.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](https://learn.microsoft.com/azure/architecture/reference-architectures/n-tier/linux-vm).

After you deploy the Linux VM, see the [Devito installation instructions](https://www.devitoproject.org/download.html) to learn about three methods for installing Devito on your VM:

- Docker installation
- Pip installation
- Conda environment installation

### Compute sizing and drivers

The Devito performance tests used [HBv3-series](/azure/virtual-machines/hbv3-series) VMs running Linux, which is covered in detail in the next section. The following table provides details about the VMs used:

| Size | vCPU | RAM memory (GiB) | Memory bandwidth (GBps) | Base CPU frequency (GHz) | All-cores frequency (GHz, peak) | Single-core frequency (GHz, peak) | RDMA performance (Gbps) | Maximum data disks |
|---|---|---|---|---|---|---|---|---|
| Standard_HB120rs_v3 | 120 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-96rs_v3 | 96 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-64rs_v3 | 64 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-32rs_v3 | 32 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-16rs_v3 | 16 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |

## Devito performance results

### Benchmarking Devito on Virtual Machines

To test the performance of Devito on Virtual Machines, benchmarking was performed by using the HB120rs_v3 series SKU. There are many seismic models, like acoustic, tti, elastic, and visco-elastic, available on [the tutorials page of the Devito website](https://www.devitoproject.org/tutorials.html). We used a forward operator under the acoustic model for benchmarking the performance of Devito.

The following table provides information about the VM that was used for testing.

|Operating system and hardware details (Azure infrastructure)||
|---|---|
|Operating system version|CentOS-based 8.1 HPC|
|OS architecture|X86-64|
|Processor|AMD EPYC 7V73X|

### Benchmarking a Devito operator

You can use the *benchmark.py* python file to test the performance of a Devito operator. The file is located under the */benchmarks/user* folder that's in the Devito folder. The *benchmark.py* file implements a minimalist framework to evaluate the performance of a Devito operator, but it varies:

- The problem size, for example the shape of the computational grid.

- The discretization, for example the space-order and time-order of the input/output fields.

- The simulation time (in milliseconds).

- The performance optimization level.

- The autotuning level.

#### Devito performance on the HB120rs_v3 (single node) series

The Devito forward operator performance for the acoustic model is tested on Standard HBv3 series virtual machines with 16, 32, 64, 96, and 120 vCPU configurations. The tests were performed with the CentOS 8.1 HPC image.

The following table shows the results for the CentOS-based 8.1 HPC image:

| Number of vCPUs (cores) | Forward operator runtime (in seconds) | GFLOPS/sec | Relative speed up |
|:---:|:---:|:---:|:---:|
| 16 | 184.39 | 211.24 | 1.00 |
| 32 | 126.20 | 308.55 | 1.46 |
| 64 | 117.61 | 331.22 | 1.57 |
| 96 | 132.86 | 293.25 | 1.39 |
| 120 | 149.99 | 259.78 | 1.23 |

Speed up chart for CentOS-based 8.1 HPC Results

Additional notes about single-node tests:

The Devito operator is run on all HBv3-series VM configurations. The Standard_HB120-16rs_v3 VM runtime is used as the baseline to calculate the relative speed up.

#### Devito performance on a cluster (multi node)

Based on the Devito forward operator performance on HB120rs_v3 single nodes, you can observe the scale-up behavior for the 64 and 96 vCPU configurations. The following performance tests run the Devito operator on two cluster configurations with 64 vCPUs and 96 vCPUs respectively. CentOS-based 8.1 HPC image is used for these two clusters.

The following table shows the results for a cluster with 64 vCPUs per node:

| Number of nodes | Number of vCPUs (cores) | Forward operator runtime (in seconds) | GFLOPS/sec | Relative speed up |
|:---:|:---:|:---:|:---:|:---:|
| 1 | 64 | 121.73 | 320.04 | 1.00 |
| 2 | 128 | 75.68 | 514.86 | 1.61 |
| 4 | 256 | 60.77 | 641.30 | 2.00 |
| 8 | 512 | 51.94 | 750.40 | 2.34 |

The following table shows the results for a cluster with 96 vCPUs per node:

| VM configuration | Number of nodes | Number of vCPUs (cores) | Forward operator runtime (in seconds) | GFLOPS | Relative speed up |
|:---:|:---:|:---:|:---:|:---:|:---:|
| Standard_HB120-96rs_v3 | 1 | 96 | 137.19 | 284 | 1.00 |
| Standard_HB120-96rs_v3 | 2 | 192 | 88.72 | 439.27 | 1.55 |
| Standard_HB120-96rs_v3 | 4 | 384 | 75.11 | 518.93 | 1.83 |
| Standard_HB120-96rs_v3 | 8 | 768 | 69.38 | 561 | 1.98 |

## Azure cost

The following table presents the wall-clock times for running the simulation. You can multiply these times by the Azure VM hourly costs for HB120rs_v3-series VMs to calculate costs. For the current hourly costs, see [Linux Virtual Machines pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux).

Only the simulation time is represented in these times. Application installation time isn't considered.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

The following table shows runtimes for the HB120rs_v3 series.

| Number of CPUs per node | Forward operator runtime (in hours) |
|---|---|
| Single node | 0.197 |
| 64 CPUs per node | 0.086 |
| 96 CPUs per node | 0.102 |

## Summary

- Devito is successfully deployed and tested on the HB120rs_v3 series VM on Azure.

- For the single-node configuration, the Devito scales well up to 64 and 96 cores. It has a maximum scale up of 1.57 times with 64 cores.  

- For the multi-node configuration, there's a gradual scale up from one node to eight nodes in both the clusters with the Standard_HB120-64rs_v3 and the Standard_HB120-96rs_v3 virtual machines respectively.

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal authors:

- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) | HPC Performance Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

_To see non-public LinkedIn profiles, sign into LinkedIn._

## Next steps

- [GPU-optimized VM sizes](/azure/virtual-machines/sizes-gpu)
- [VMs on Azure](/azure/virtual-machines/overview)
- [Virtual networks and VMs on Azure](/azure/virtual-network/network-overview)
- [Learning path: Run high-performance computing (HPC) applications on Azure](/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)


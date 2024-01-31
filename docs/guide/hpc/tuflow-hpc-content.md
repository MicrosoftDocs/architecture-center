This article describes the steps for running [TUFLOW HPC](https://wiki.tuflow.com/Hardware_Benchmarking_(2018-03-AA)) (Heavily Parallelized Compute) models on a Azure virtual machine (VM). It also presents the performance results of running TUFLOW HPC on Azure.

TUFLOW HPC is an explicit solver for the full 2D Shallow Water Equations (SWE), including a sub-grid scale eddy viscosity model. It builds upon the TUFLOW Classic's strengths and accuracy. HPC incorporates finite volume TVD shock capturing, adaptive timestepping stability, and GPU acceleration that achieves 10 to 400 times shorter simulation times than TUFLOW Classic. 

## Architecture

:::image type="content" source="././media/tuflow-hpc/tuflow-hpc-architecture.svg" alt-text="{alt-text}":::

*Download a [Visio file](https://arch-center.azureedge.net/hpc-tuflow-hpc-architecture.vsdx) of this architecture.*

## Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Windows VMs.
  - For information about deploying the VM and installing the drivers, see [Windows VMs on Azure](/azure/architecture/reference-architectures/n-tier/windows-vm).
- The TUFLOW HPC benchmarking application is installed on the OS Disk attached with the VM. A Premium SSD is used as OS disk which is used for storage also.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VMs.
  - A public IP address connects the internet to the VM. 

## Scenario details

TUFLOW HPC is the latest Explicit Finite Volume engine which allows the distribution of hydrodynamic calculations across multiple cores, specifically GPU The accuracy, stability, speed, quadtree mesh structure and sub-grid sampling (SGS) make TUFLOW HPC the most powerful 1D/2D hydrodynamic computational engine.

Environment and natural resources, flood, urban stormwater & coastal simulation labs are some of the industries that use Tuflow HPC. For example, it’s used by UVA Hydroinformatics and Chartered Institution of Water and Environmental Management.

Deploying TUFLOW HPC on Azure offers the following benefits:

- Modern and diverse compute options to align to your workload's needs.
- The flexibility of virtualisation without the need to buy and maintain physical hardware.
- Rapid provisioning
- The ability to run the models on multiple GPU cards for increased modelling speeds.

  

### VM and driver requirements

| Size | vCPU | Memory (GiB) | Temp disk (GiB) | GPU | GPU memory (GiB) | Max data disks |
|---|---|---|---|---|---|---|
| Standard_NC24ads_A100_v4 | 24 | 220 | 64 | 1 | 80 | 12 |
| Standard_NC48ads_A100_v4 | 48 | 440 | 128 | 2 | 160 | 24 |
| Standard_NC96ads_A100_v4 | 96 | 880 | 256 | 4 | 320 | 32 |

To run the TUFLOW HPC benchmarks, you need to:

- Deploy and connect to a Virtual Machine.
- Install NVIDIA GPU drivers. This is required in order to take advantage of the GPU capabilities of [NC A100 v4](/azure/virtual-machines/nc-a100-v4-series) VMs.

For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](/azure/architecture/reference-architectures/n-tier/windows-vm) or [Run a Linux VM on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm).

### Install TUFLOW HPC and run benchmarks

The dataset used for the benchmarking exercise is the standard TUFLOW HPC benchmarking dataset. More information on the benchmark tests is provided here see <https://wiki.tuflow.com/Hardware_Benchmarking_(2018-03-AA)>.

> [!NOTE]
> The benchmarking dataset runs licence free allowing it to be used to assess performance on any other machine.

Complete the following steps to install and run the TUFLOW HPC models:

1. Download the TUFLOW HPC  Benchmarking Models zip file from the [TUFLOW downloads page](https://www.tuflow.com/Download/TUFLOW/Benchmark_Models/FMA2_GPU_CPU_Benchmark.zip).

1. Extract the zip file on a local drive of the computer you would like to test.

1. Navigate to the **TUFLOW\runs\** folder and run the **Run_Benchmark.bat** file.

### TUFLOW HPC performance results

For this performance analysis, we used the TUFLOW version 2018-03-AA on Windows [NC A100 v4](/azure/virtual-machines/nc-a100-v4-series) series VMs. Note that the benchmarking only covers the TUFLOW HPC engine which has functionality to distribute simulations across multiple CPU and GPU cards.  The benchmarking did not cover TUFLOW Classic models, which are limited to a single CPU, or 1D components.

_The Windows 10 x64 ISO image win10-22h2-pro-g2 was used for testing._

The following table provides the details of the operating system that was used for testing.

| Operating system | Operating system architecture |
|:---:|:---:|
| win10-22h2-pro-g2 | x64 |

The following cell sizes (models) are used for benchmarking tests:

| Model | Cell size (m) | Number of cells |
|:---:|:---:|:---:|
| Model 1 | 20 | 1,81,981 |
| Model 2 | 10 | 7,27,865 |
| Model 3 | 5 | 29,11,472 |
| Model 4 | 2.5 | 1,16,45,341 |

### **Model 1**: 20.00m (cell size).

TUFLOW HPC (runs on both CPU and GPU hardware) with 20m cell size and 1,81,981 2D cells

| VM Configuration | CPU/GPU | Runtime (secs) | Relative speedup |
|:---:|:---:|:---:|:---:|
| EPYC 9V33X | 8 CPUs | 5973 | 1.00 |
| EPYC 9V33X | 16 CPUs | 3209 | 1.86 |
| Standard NC24ads A100 v4 | 1 GPU | 152 | 39.30 |

For performance analysis, simulation runtime is the key parameter. To calculate the relative speedup, we considered 8 vCPU (cores) runtime as the baseline.

This graph shows the relative speed increase in the model runtime as we increase the number of CPUs/GPUs.

### **Model 2:** 10.00m (cell size).

TUFLOW HPC (runs on both CPU and GPU hardware) with 10m cell size and 7,27,865 2D cells.

| VM Configuration | CPU/GPU | Runtime (secs) | Relative speedup |
|:---:|:---:|:---:|:---:|
| EPYC 9V33X | 8 CPUs | 43082 | 1.00 |
| EPYC 9V33X | 16 CPUs | 25071 | 1.72 |
| Standard NC24ads A100 v4 | 1 GPU | 808 | 53.32 |

### **Model 3**: 05.00m (cell size).

TUFLOW HPC - GPU Hardware, an option to run bigger models on GPU hardware as part of the high-end GPU benchmarking.

| VM Configuration | GPUs | Runtime (secs) | Relative speed increase |
|:---:|:---:|:---:|:---:|
| Standard NC24ads A100 v4 | 1 GPU | 6638 | 1.00 |
| Standard NC48ads A100 v4 | 2 GPU | 4860 | 1.37 |
| Standard NC96ads A100 v4 | 4 GPU | 4155 | 1.60 |

### **Model 4**: 02.50m (cell size).

TUFLOW HPC - GPU Hardware, a high end GPU benchmarking model with 1,16,45,341 cells.

| VM configuration | GPUs | Runtime (secs) | Relative speed increase |
|:---:|:---:|:---:|:---:|
| Standard NC24ads A100 v4 | 1 GPU | 51797 | 1.00 |
| Standard NC48ads A100 v4 | 2 GPU | 47496 | 1.09 |
| Standard NC96ads A100 v4 | 4 GPU | 27469 | 1.89 |

## Azure cost optimization

Based on the TUFLOW HPC test results, there is a considerable price advantage in using GPU SKUs like [NC A100 v4](/azure/virtual-machines/nc-a100-v4-series) when compared with CPU based SKUs. Users can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your configuration.

To compute the total VM cost for your analysis, multiply the total runtime of the VM by the Azure VM hourly cost, which you can find [here for Windows](https://azure.microsoft.com/pricing/details/virtual-machines/windows/) and [here for Linux](https://azure.microsoft.com/pricing/details/virtual-machines/linux/).

## Summary

The TUFLOW HPC models were tested on Single Precision version, as  calculations take slightly less time and require less memory for the field data. The memory requirement of SP is almost half of that of SDP.

The SP version of TUFLOW is recommended as it will be slightly comparatively faster and will enables larger models to be run within the available CPU/GPU memory.

The TUFLOW HPC models(Model 1, Model 2, Model 3, and Model 4) were successfully tested on the Azure Cloud Platform using NCA100v4 virtual machine.

The application is scaling very well with GPU utilization when compared with CPU runtimes. A relative speedup of ~54x was observed with 1 GPU when compared with 8 CPUs for the 10.0m model, which indicates very impressive scaling.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Pavankumar Navalli](https://www.linkedin.com/in/pavankumar-navalli-1193851a1/) | HPC Performance Engineer
- [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) | HPC Performance Engineer

Other contributors:

- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy
- [Duncan Kitts](https://www.linkedin.com/in/duncan-kitts-25401531) | TUFLOW UK/Europe Software Lead
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager
- [Jaap van der Velde](https://www.linkedin.com/in/jaapvandervelde) | TUFLOW Associate Principal Software Architect & ICT Consultant

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [GPU Optimized Virtual Machine Sizes](/azure/virtual-machines/sizes-gpu)
- [Windows Virtual Machines in Azure](/azure/virtual-machines/windows/overview)
- [Linux Virtual Machines in Azure](/azure/virtual-machines/linux/overview)
- [Virtual networks and virtual machines in Azure](/azure/virtual-network/network-overview)
- [Learning path: Run high-performance computing (HPC) applications on Azure](/training/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)


This article describes the steps for running [TUFLOW HPC](https://wiki.tuflow.com/Hardware_Benchmarking_(2018-03-AA)) (Heavily Parallelized Compute) models on a Azure virtual machine (VM). It also presents the performance results of running TUFLOW HPC on Azure.

TUFLOW HPC is an explicit solver for the full 2D Shallow Water Equations (SWE), including a sub-grid scale eddy viscosity model. It builds upon the TUFLOW Classic's strengths and accuracy. HPC incorporates finite volume TVD shock capturing, adaptive timestepping stability, and GPU acceleration that achieves 10 to 400 times shorter simulation times than TUFLOW Classic. 

## Architecture

:::image type="content" source="././media/tuflow-hpc/tuflow-hpc-architecture.svg" alt-text="{alt-text}":::

*Download a [Visio file](https://arch-center.azureedge.net/hpc-tuflow-hpc-architecture.vsdx) of this architecture.*

## Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Windows VMs. For information about deploying the VM and installing the drivers, see [Windows VMs on Azure](/azure/architecture/reference-architectures/n-tier/windows-vm).

- The TUFLOW HPC benchmarking application is installed on the OS Disk attached with the VM. A Premium SSD is used as OS disk which is used for storage also.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud.
- [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VMs.
- A public IP address connects the internet to the VM. 

## Scenario details

TUFLOW HPC is the latest explicit finite volume engine. It can be used to distribute hydrodynamic calculations across multiple cores, specifically GPUs. The accuracy, stability, speed, quadtree mesh structure and sub-grid sampling (SGS) make TUFLOW HPC the most powerful 1D/2D hydrodynamic computational engine.

TUFLOW HPC is used in the environment and natural resource industries, specifically in flood, urban stormwater, and coastal simulation labs. UVA Hydroinformatics and Chartered Institution of Water and Environmental Management are groups that use TUFLOW HPC.

Deploy TUFLOW HPC on Azure to get benefits like:

- Modern and diverse compute options to align to your workload's needs.
- The flexibility of virtualization without the need to buy and maintain physical hardware.
- Rapid provisioning.
- The ability to run the models on multiple GPU cards to increase modeling speeds.

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

The standard TUFLOW HPC benchmarking dataset is used in the following benchmarking tests. For more information, see [Hardware benchmarking](https://wiki.tuflow.com/Hardware_Benchmarking_(2018-03-AA)).

> [!NOTE]
> The TUFLOW HPC benchmarking dataset is license-free, so you can use it to assess performance on any machine.

Complete the following steps to install and run the TUFLOW HPC models:

1. Download the [TUFLOW HPC Benchmarking Models zip file](https://www.tuflow.com/Download/TUFLOW/Benchmark_Models/FMA2_GPU_CPU_Benchmark.zip).

1. Extract the zip file on a local drive of the computer that you want to test.

1. Go to the TUFLOW\runs\ folder, and run the **Run_Benchmark.bat** file.

## TUFLOW HPC performance results

The TUFLOW version 2018-03-AA on Windows [NC_A100_v4-series VMs](/azure/virtual-machines/nc-a100-v4-series) was used for the following performance analysis. Note that the benchmarking tests only cover the TUFLOW HPC engine, which can distribute simulations across multiple CPU and GPU cards. The benchmarking tests don't cover TUFLOW classic models, which are limited to a single CPU or 1D components.

The following table provides the details of the operating system that was used for testing.

| Operating system | Operating system architecture |
|:---:|:---:|
| win10-22h2-pro-g2 | x64 |

The following table shows the details for each model that was used for testing:

| Model | Cell size (m) | Number of cells |
|:---:|:---:|:---:|
| Model 1 | 20 | 181,981 |
| Model 2 | 10 | 727,865 |
| Model 3 | 5 | 2,911,472 |
| Model 4 | 2.5 | 11,645,341 |

### Model 1

20.00m (cell size).

TUFLOW HPC (runs on both CPU and GPU hardware) with 20m cell size and 181,981 2D cells

| VM configuration | CPU/GPU | Runtime (secs) | Relative speed increase |
|:---:|:---:|:---:|:---:|
| EPYC 9V33X | 8 CPUs | 5,973 | 1.00 |
| EPYC 9V33X | 16 CPUs | 3,209 | 1.86 |
| Standard NC24ads_A100_v4 | 1 GPU | 152 | 39.30 |

For the performance analysis, simulation runtime is the key parameter. To calculate the relative speed increase, the 8 vCPU (cores) runtime is used as the baseline.

This graph shows the relative speed increase in the model runtime as we increase the number of CPUs/GPUs.

### Model 2

10.00m (cell size).

TUFLOW HPC (runs on both CPU and GPU hardware) with 10m cell size and 727,865 2D cells.

| VM configuration | CPU/GPU | Runtime (secs) | Relative speed increase |
|:---:|:---:|:---:|:---:|
| EPYC 9V33X | 8 CPUs | 43,082 | 1.00 |
| EPYC 9V33X | 16 CPUs | 25,071 | 1.72 |
| Standard NC24ads_A100_v4 | 1 GPU | 808 | 53.32 |

### Model 3

05.00m (cell size).

TUFLOW HPC - GPU Hardware, an option to run bigger models on GPU hardware as part of the high-end GPU benchmarking. 2,911,472 cells.

| VM configuration | GPUs | Runtime (secs) | Relative speed increase |
|:---:|:---:|:---:|:---:|
| Standard NC24ads_A100_v4 | 1 | 6,638 | 1.00 |
| Standard NC48ads_A100_v4 | 2 | 4,860 | 1.37 |
| Standard NC96ads_A100_v4 | 4 | 4,155 | 1.60 |

### Model 4

02.50m (cell size).

TUFLOW HPC - GPU Hardware, a high-end GPU benchmarking model with 11,645,341 cells.

| VM configuration | GPUs | Runtime (secs) | Relative speed increase |
|:---:|:---:|:---:|:---:|
| Standard NC24ads_A100_v4 | 1 | 51,797 | 1.00 |
| Standard NC48ads_A100_v4 | 2 | 47,496 | 1.09 |
| Standard NC96ads_A100_v4 | 4 | 27,469 | 1.89 |

## Azure cost

Based on the TUFLOW HPC test results, there is a considerable price advantage in using GPU SKUs like [NC_A100_v4](/azure/virtual-machines/nc-a100-v4-series) when compared with CPU-based SKUs. You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your configuration.

To compute the total VM cost for your analysis, multiply the total runtime of the VM by the Azure VM hourly cost. For more information, see [Windows VM pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows) or [Linux VM pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux).

## Summary

- The TUFLOW HPC models were tested on Single Precision version, as  calculations take slightly less time and require less memory for the field data. The memory requirement of SP is almost half of that of SDP.

- The SP version of TUFLOW is recommended as it will be slightly comparatively faster and will enables larger models to be run within the available CPU/GPU memory.

- The four TUFLOW HPC models were successfully tested on Azure using NC_A100_v4 VM.

- The application scales well with GPU utilization when compared with CPU runtimes. A relative speedup of ~54x was observed with 1 GPU when compared with 8 CPUs for the 10.0m model, which indicates very impressive scaling.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Pavankumar Navalli](https://www.linkedin.com/in/pavankumar-navalli-1193851a1) | HPC Performance Engineer
- [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) | HPC Performance Engineer

Other contributors:

- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy
- [Duncan Kitts](https://www.linkedin.com/in/duncan-kitts-25401531) | TUFLOW UK/Europe Software Lead
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager
- [Jaap van der Velde](https://www.linkedin.com/in/jaapvandervelde) | TUFLOW Associate Principal Software Architect & ICT Consultant

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [GPU-optimized VM sizes](/azure/virtual-machines/sizes-gpu)
- [Windows Virtual Machines in Azure](/azure/virtual-machines/windows/overview)
- [Linux VMs on Azure](/azure/virtual-machines/linux/overview)
- [Virtual networks and VMs on Azure](/azure/virtual-network/network-overview)
- [Learning path: Run high-performance computing (HPC) applications on Azure](/training/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)


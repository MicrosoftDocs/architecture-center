This article presents the performance results of running [TUFLOW (heavily parallelized compute) HPC](https://www.tuflow.com/) models on an Azure virtual machine (VM).

TUFLOW HPC is an explicit solver for the 2D shallow-water equations (SWEs), including the sub-grid scale eddy viscosity model. It builds on the strength and accuracy of the TUFLOW Classic model. The TUFLOW HPC model provides finite volume TVD shock capturing, adaptive timestepping stability, and GPU acceleration that achieves simulation times that are 10 to 400 times faster than the TUFLOW Classic model. 

## Architecture

:::image type="content" source="././media/tuflow-hpc/tuflow-hpc-architecture.svg" alt-text="Diagram that shows the architecture to run TUFLOW HPC on an Azure VM.":::

*Download a [Visio file](https://arch-center.azureedge.net/hpc-tuflow-hpc-architecture.vsdx) of this architecture.*

## Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Windows VMs. For information about deploying a VM and installing drivers, see [Windows VMs on Azure](/azure/architecture/reference-architectures/n-tier/windows-vm).

- The TUFLOW HPC application is installed on the operating system disk that's attached to the VM.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud.
- [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.
- A public IP address connects the internet to the VM. 
- A [premium solid-state drive (SSD)](/azure/virtual-machines/disks-types#premium-ssds) is used as an operating system disk for storage.

## Scenario details

TUFLOW HPC is the latest explicit finite volume engine. It can be used to distribute hydrodynamic calculations across multiple cores, specifically GPUs. The accuracy, stability, and speed of TUFLOW HPC combined with features like a quadtree mesh structure and sub-grid sampling make it a powerful 1D/2D hydrodynamic computational engine.

Deploy TUFLOW HPC on Azure to get benefits like:

- Modern and diverse compute options to meet your workload's needs.
- The flexibility of virtualization without the need to buy and maintain physical hardware.
- Rapid provisioning.
- The ability to run the models on multiple GPU cards to increase modeling speeds.

### VM and driver requirements

| VM size | vCPU | Memory (GiB) | Temp disk (GiB) | GPU | GPU memory (GiB) | Max data disks |
|---|---|---|---|---|---|---|
| Standard_NC24ads_A100_v4 | 24 | 220 | 64 | 1 | 80 | 12 |
| Standard_NC48ads_A100_v4 | 48 | 440 | 128 | 2 | 160 | 24 |
| Standard_NC96ads_A100_v4 | 96 | 880 | 256 | 4 | 320 | 32 |

To run TUFLOW HPC benchmarks, you need to:

- Deploy a VM and connect to it.
- Install NVIDIA GPU drivers to take advantage of the GPU capabilities of [NC_A100_v4-series VMs](/azure/virtual-machines/nc-a100-v4-series).

For information about deploying a VM and installing drivers, see [Run a Windows VM on Azure](/azure/architecture/reference-architectures/n-tier/windows-vm) or [Run a Linux VM on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm).

### Install TUFLOW HPC and run benchmarks

The standard TUFLOW HPC benchmarking dataset is used in the following benchmarking tests. For more information, see [Hardware benchmarking](https://wiki.tuflow.com/Hardware_Benchmarking_(2018-03-AA)).

> [!NOTE]
> The TUFLOW HPC benchmarking dataset is license-free, so you can use it to assess performance on any machine.

To install and run the TUFLOW HPC models:

1. Download the [TUFLOW HPC benchmarking models zip file](https://www.tuflow.com/Download/TUFLOW/Benchmark_Models/FMA2_GPU_CPU_Benchmark.zip).

1. Extract the zip file on a local drive of the computer that you want to test.

1. Go to the **TUFLOW\runs\\** folder, and run the **Run_Benchmark.bat** file.

## TUFLOW HPC performance results

For the following performance analysis, the 2018-03-AA version of TUFLOW HPC was run on Windows [NC_A100_v4-series VMs](/azure/virtual-machines/nc-a100-v4-series). Note that the benchmarking tests only cover the TUFLOW HPC engine, which can distribute simulations across multiple CPU and GPU cards. The tests don't cover TUFLOW Classic models, which are limited to a single CPU or 1D components.

The operating system that was used for testing is Windows 10 Pro x64 version 22H2 G2.

The following table shows the details for each model that was used for testing:

| Model | Cell size (m) | Number of cells |
|:---:|:---:|:---:|
| Model 1 | 20 | 181,981 |
| Model 2 | 10 | 727,865 |
| Model 3 | 5 | 2,911,472 |
| Model 4 | 2.5 | 11,645,341 |

### Model 1

Model 1 has a cell size of 20m, or 181,981 2D cells. TUFLOW HPC runs on both CPU and GPU hardware. The following table shows the performance results of running TUFLOW HPC on a NC_A100_v4-series VM compared to running the application on an EPYC 9V33X processor.

| Processor/VM series | CPU/GPU | Runtime (secs) | Relative speed increase |
|:---:|:---:|:---:|:---:|
| EPYC 9V33X  | 8 CPUs | 5,973 | 1.00 |
| EPYC 9V33X  | 16 CPUs | 3,209 | 1.86 |
| Standard NC24ads_A100_v4 | 1 GPU | 152 | 39.30 |

For a performance analysis, the simulation runtime is a key parameter. To calculate the relative speed increase, the 8-vCPU (core) runtime is used as the baseline.

The following graph shows how the relative speed increase improves.

:::image type="content" source="./media/tuflow-hpc/tuflow-hpc-20m-speed.png" alt-text="Graph that shows the relative speed increase for TUFLOW HPC with a 20m cell.":::

### Model 2

Model 2 has a cell size of 10m, or 727,865 2D cells. The following table shows the performance results of running TUFLOW HPC on a NC_A100_v4-series VM compared to running the application on an EPYC 9V33X processor.

| Processor/VM series | CPU/GPU | Runtime (secs) | Relative speed increase |
|:---:|:---:|:---:|:---:|
| EPYC 9V33X  | 8 CPUs | 43,082 | 1.00 |
| EPYC 9V33X  | 16 CPUs | 25,071 | 1.72 |
| Standard NC24ads_A100_v4 | 1 GPU | 808 | 53.32 |

:::image type="content" source="./media/tuflow-hpc/tuflow-hpc-10m-speed.png" alt-text="Graph that shows the relative speed increase for TUFLOW HPC with a 10m cell.":::

### Model 3

Model 3 has a cell size of 5m, or 2,911,472 2D cells. This option runs large models on GPU hardware for high-end GPU benchmarking.

| VM configuration | GPUs | Runtime (secs) | Relative speed increase |
|:---:|:---:|:---:|:---:|
| Standard NC24ads_A100_v4 | 1 | 6,638 | 1.00 |
| Standard NC48ads_A100_v4 | 2 | 4,860 | 1.37 |
| Standard NC96ads_A100_v4 | 4 | 4,155 | 1.60 |

:::image type="content" source="./media/tuflow-hpc/tuflow-hpc-5m-speed.png" alt-text="Graph that shows the relative speed increase for TUFLOW HPC with a 5m cell.":::

### Model 4

Model 4 has a cell size of 2.5m, or 11,645,341 2D cells. This model is also for high-end GPU benchmarking.

| VM configuration | GPUs | Runtime (secs) | Relative speed increase |
|:---:|:---:|:---:|:---:|
| Standard NC24ads_A100_v4 | 1 | 51,797 | 1.00 |
| Standard NC48ads_A100_v4 | 2 | 47,496 | 1.09 |
| Standard NC96ads_A100_v4 | 4 | 27,469 | 1.89 |

:::image type="content" source="./media/tuflow-hpc/tuflow-hpc-2-5m-speed.png" alt-text="Graph that shows the relative speed increase for TUFLOW HPC with a 2.5m cell.":::

## Azure cost

Based on the TUFLOW HPC test results, GPU-based SKUs, like [NC_A100_v4-series VMs](/azure/virtual-machines/nc-a100-v4-series) are more cost effective compared to CPU-based SKUs. You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your configuration.

To compute the total VM cost for your analysis, multiply the total runtime of the VM by the Azure VM hourly cost. For more information, see [Windows VM pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows) or [Linux VM pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux).

## Summary

- The four models of TUFLOW HPC were successfully tested on a NC_A100_v4 VM on Azure.

- The TUFLOW HPC models were tested with a single-precision version. This version requires less time and memory to calculate field data compared to a double-precision version. The memory requirement for a single-precision version is almost 50% less than that of a double-precision version.

- We recommend the single-precision version of TUFLOW HPC. Compared to a double-precision version, it's faster and it enables you to run larger models with the available CPU/GPU memory.

- TUFLOW HPC scales better with GPUs compared to CPUs. For the 10m model, when 1 GPU was used, the relative speed increase improved by about 53 times compared to the same test with 8 CPUs. These results indicate impressive scaling.

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


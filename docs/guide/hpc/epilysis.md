---
author: Anjankar, Aashay Vinod
ms.date: 01/19/2024
---
# Deploy Beta-CAE EPILYSIS on Azure Virtual Machines

This article presents the performance results of running the [Beta-CAE EPILYSIS](https://www.beta-cae.com/epilysis.htm) application on Azure Virtual Machines (VM). Epilysis is a software program that can perform various types of finite element analysis on different structures and materials. It can help engineers design and optimize products. It can also work with other tools such as ANSA and META for simulation and optimization. The solver can handle various solution types from structural, NVH (noise, vibration, and harshness), optimization and more.

EPILYSIS is used in Aerospace, Automotive, Defense, High Tech, and Industrial Equipment industries.

.

## Why deploy EPILYSIS on Azure?

Modern and diverse compute options to align to your workload's needs.

The flexibility of virtualization without the need to buy and maintain physical hardware.

- Rapid provisioning.
- Performance that scales as CPUs are added, based on tests of a sample model

## Architecture

![Diagram that shows architecture for running Beta-CAE Epilysis on Azure.](media/image1.png)

## Components

[Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create a Linux VM. For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm).

[Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud. 

[Network security groups](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  

A public IP address connects the internet to the VM.

A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

The performance tests of EPILYSIS on Azure used [HBv3-series](https://learn.microsoft.com/en-us/azure/virtual-machines/hbv3-series) VM and   Eadsv5-series VM running on Linux OS. 

- HBv3-series VMs are optimized for HPC applications like fluid dynamics, explicit and implicit finite element analysis, weather modeling, seismic processing, reservoir simulation, and RTL simulation.
- Eadsv5-series VMs are optimized for memory-intensive enterprise applications, such as relational database servers and in-memory analytics workloads.

The following table provides the configuration details of [HBv3-series](https://learn.microsoft.com/en-us/azure/virtual-machines/hbv3-series) and [Eadsv5-series](https://learn.microsoft.com/en-us/azure/virtual-machines/easv5-eadsv5-series) VMs:

| **VM series** | **VM Size** | **vCPU** | **Memory: GiB** | **Temp storage (GiB)** | **Max data disk** | **Max NICs** |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **HBv3** | Standard_HB120-16rs_v3 | 16 | 448 | 2\*960 | 32 | 8 |
| **HBv3** | Standard_HB120-32rs_v3 | 32 | 448 | 2\*960 | 32 | 8 |
| **Eadsv5** | Standard_E64ads_v5<sup>2</sup> | 64 | 512 | 2400 | 32 | 8 |

Performance test details for EPILYSIS are mentioned in the **EPILYSIS performance results on HBv3-series VMs** and **EPILYSIS performance results on performance on Eadsv5-series VMs** sections respectively.

## EPILYSIS installation

Before you install EPILYSIS, you need to [deploy and connect a Linux VM](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm). You can download and install EPILYSIS from the [Beta-CAE website](https://www.beta-cae.com/epilysis.htm).

## EPILYSIS Performance results

EPILYSIS version 23.1.1 was used for testing the 101_large_7million model.

The following table provides details of the computing environment used for testing, including the operating system, processor, and MPI implementation.

| **VM-series** | **Operating system version** | **OS Architecture** | **Processor** | **MPI** |
|:---:|:---:|:---:|:---:|:---:|
| **Eadsv5** | Linux CentOS-HPC-7.9 Gen2 | X86-64-Bit | AMD EPYC<sup>TM</sup> 7763v | Open MPI 4.1.1 |
| **HBv3** | Linux CentOS-HPC-7.9 Gen2 | X86-64-Bit | AMD EPYC™ 7V73X | Open MPI 4.1.1 |

** Important**

This document refers to a release version of Linux that is nearing or at the end of Life (EOL). Results are expected to be similar on newer Linux images that include the same drivers.

### Model details:

For EPILYSIS solver validation, we used the 101_large_7million model. The model is set up for a linear static analysis (solution 101). A linear static analysis is an analysis where a linear relation holds between applied forces and displacements. The following image shows 101_large_7million model: 

 

![The image shows 101_large_7million.nas model](media/image2.png)

**The following table provides details about the model:**

|          **Model Name** | **Nodes** | **Shell Elements** | **Solid Elements** |
|:---:|:---:|:---:|:---:|
| **101_large_7million.nas** | 7678688 | 6341470 | 1295109 |

### EPILYSIS performance results on HBv3-series VMs

The following table shows vCPUs used, the total elapsed time, and relative speed increase of each test. As the number of vCPUs increases, the total elapsed time decreases and the relative speed increase improves.

| **VM** **size** | **No. of vCPUs available** | **No. of** **vCPUs used** | **Total Elapsed time  (Seconds)** | **Relative speed increase** |
|:---:|:---:|:---:|:---:|:---:|
| **Standard_HB120-16rs_v3** | 16 | 1 | 5542 | 1.00 |
| | 16 | 2 | 3469 | 1.60 |
| | 16 | 4 | 2213 | 2.50 |
| | 16 | 8 | 1630 | 3.40 |
| | 16 | 16 | 1420 | 3.90 |
| **Standard_HB120-32rs_v3** | 32 | 20 | 1393 | 3.98 |

The following chart shows the relative speed increase goes up as you increase the vCPUs. However, it begins to plateau at 16 vCPUs:

**Higher is BetterHigher is Better**

### EPILYSIS performance results on Eadsv5-series VMs

The table illustrates that as the number of vCPUs used increases, the total elapsed time in seconds decreases, and the relative speed increase improves significantly. This suggests a strong correlation between the vCPUs used and the efficiency of the process.

| **VM size** | **No. of vCPUs available** | **No. of** **vCPUs used** | **Total Elapsed time in Seconds** | **Relative speed increase** |
|:---:|:---:|:---:|:---:|:---:|
| **Standard_E64ads_v5** | 64 | 1 | 6049 | 1.00 |
| | 64 | 2 | 3480 | 1.74 |
| | 64 | 4 | 2195 | 2.76 |
| | 64 | 8 | 1520 | 3.98 |
| | 64 | 16 | 1177 | 5.14 |
| | 64 | 20 | 1122 | 5.39 |

The following chart shows the relative speed increase goes up as you increase the vCPUs count:

**Higher is BetterHigher is Better** ￼

## Azure Cost

The following table provides estimated running time that you can use to calculate Azure costs. To compute the cost, multiply the estimated time by the Azure VM hourly rate. For the hourly rates for Linux, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/). Azure VM hourly rates are subject to change.

Only simulation running time is considered for the cost calculations. Installation time, simulation setup time, and software costs aren't included. You can use the  [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator)  to estimate VM costs for your configurations.

| **VM size** | **vCPUs** **used** | **Elapsed time (hours)** |
|:---:|:---:|:---:|
| **Standard_HB120-16rs_v3** | 1 | 1.54 |
| | 2 | 0.96 |
| | 4 | 0.61 |
| | 8 | 0.45 |
| | 16 | 0.39 |
| **Standard_HB120-32rs_v3** | 20 | 0.39 |
| **Standard_E64ads_v52** | 1 | 1.68 |
| | 2 | 0.97 |
| | 4 | 0.61 |
| | 8 | 0.42 |
| | 16 | 0.33 |
| | 20 | 0.31 |

## Summary

- Considering the wide uses of Beta-CAE EPILYSIS, benchmarking suite is created using HBv3 and Eadsv5 series virtual machines on Azure platform.

Beta-CAE EPILYSIS's performance was evaluated on two HBv3-series virtual machines (Standard_HB120-16rs_v3 and Standard_HB120-32rs_v3) and one Eadsv5-series virtual machine (Standard_E64ads_v5<sup>2</sup>).

When using HBv3-series virtual machines, a performance improvement of approximately 4X is observed when the vCPU count is increased upto 20 vCPUs, using the performance of a single vCPU as a baseline.

In a similar vein, Eadsv5-series virtual machines show an approximate 5X increase in performance when the vCPU count is increased upto 20 vCPUs, again considering the performance of a single vCPU as a baseline.

A validation study reveals that Eadsv5-series virtual machines with 20 vCPUs are 19% more performance efficient compared to HBv3-series virtual machines with the same number of vCPUs.

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal authors:

- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- Shivakumar Tallolli | HPC Performance Engineer
- [Rupali Konade](https://www.linkedin.com/in/rupali-konade-3ba2851b2) | HPC Performance Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

## Next steps

- [GPU optimized virtual machine sizes](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-gpu)
- [Windows virtual machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/overview)
- [Linux virtual machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/overview)
- [Virtual networks and virtual machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-network/network-overview)
- [Learning path: Run high-performance computing (HPC) applications on Azure](https://docs.microsoft.com/en-us/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Windows VM on Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/windows-vm)
- [Run a Linux VM on Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm)
- [HPC system and big-compute solutions](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/big-compute-with-azure-batch)
- [HPC cluster deployed in the cloud](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/hpc-cluster)


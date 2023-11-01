---
author: Bhagat, Sujata
ms.date: 08/30/2023
---
# Deploy M-STAR on an Azure Virtual machine

This article briefly describes the steps for running [M-Star CFD](https://mstarcfd.com/) on an Azure virtual machine (VM). It also presents the performance results of running M-STAR on Azure.

M-Star CFD is a Multiphysics modeling package used to simulate fluid flow, heat transfer, species transport, chemical reactions, particle transport, and rigid-body dynamics. 

M-Star CFD is software that simulates real-world systems with unprecedented accuracy. The high-fidelity results are driven by Large Eddy Simulation and advanced lattice-Boltzmann algorithms that run entirely on GPUs. As a fully time-resolved approach, it is easy to include multi-fluid, multi-phase, and multi-physics effects into any model. Simulations are a snap to set up, run, and post-processes on Windows workstations, Linux or HPC Clusters. 

M-Star CFD is used in the chemical, biopharmaceutical, and energy sectors, including the US Department of Energy. Predictions from the software are validated against experimental data and applied to critical manufacturing processes.

## Why deploy M-STAR on Azure

* Modern and diverse compute options to align with your workload's needs 
* The flexibility of virtualization without the need to buy and maintain physical hardware 
* Rapid provisioning 
* The technology enables the creation of exceedingly complex flow fields in a short amount of time. Simulate large and complex particle systems.
* Integrated post-processing capability such as creating photorealistic renderings, backed by high fidelity numerical solutions and calculate power number, residence time, and blend time

## Architecture

![Azure Architecture of M-STAR application](media/image1.png)

## Components

[Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Windows VMs.

For information about deploying the VM and installing the drivers, see [Windows VMs on Azure](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/windows-vm).

[Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud.

[Network security groups](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VMs.

A public IP address connects the internet to the VM.

A physical SSD is used for storage.

## Compute sizing and drivers

For Performance tests of M-STAR on Azure NDm A100 v4-series and [NC A100 v4-series](https://learn.microsoft.com/en-us/azure/virtual-machines/nc-a100-v4-series) series VMs running on Linux are used. The following table provides the configuration details of these VMs.

| **Size** | **vCPU** | **Memory: GiB** | **Temp Storage (SSD): GiB** | **GPU** | **GPU Memory: GiB** | **Max data disks** | **Max uncached disk throughput: IOPS / MBps** | **Max network bandwidth** | **Max NICs** |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **Standard_NC48ads_A100_v4** | 48 | 440 | 2246 | 2 | 160 | 24 | 60000/2000 | 40,000 Mbps | 4 |
| **Standard_ND96amsr_A100_v4** | 96 | 1900 | 6400 | 8 A100 80 GB GPUs (NVLink 3.0) | 80 | 32 | 80,000 / 800 | 24,000 Mbps | 8 |

### Required drivers

To take advantage of the GPU capabilities of  [NC A100 v4](https://learn.microsoft.com/en-us/azure/virtual-machines/nc-a100-v4-series) and NDm A100 v4 series VMs, you need to install NVIDIA GPU drivers.

## M-STAR installation

Before you install M-STAR, you need to deploy and connect to a VM and install the required NVIDIA  drivers.

For information about deploying the VM and installing the drivers, see one of these articles:

* [Run a Windows VM on Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/windows-vm)
* [Run a Linux VM on Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm)

**Important**

NVIDIA Fabric Manager installation is required for VMs that use NVLink or NVSwitch. 

The following table provides details about the operating system and NVIDIA drivers that were used.

| **Operating system** **version** | **OS architecture** | **GPU driver version** | **Cuda version** | **MPI** |
|:---:|:---:|:---:|:---:|:---:|
| **Linux (ubuntu HPC 18.04 Gen 2)** | x86-64 | 510.85.02 | 11.6 | openmpi-4.1.1 |

You can install M-STAR from the [M-Star CFD documentation](https://docs.mstarcfd.com/2_Installation/txt-files/Installation-index.html). For information about the installation process, see [M-Star CFD on Linux](https://docs.mstarcfd.com/2_Installation/txt-files/Linux-single-node.html)

# M-STAR performance results

For this performance analysis, we used the M-STAR 3.8.27 version on Windows, [NC A100 v4](https://learn.microsoft.com/en-us/azure/virtual-machines/nc-a100-v4-series) and [NDm A100 v4](https://learn.microsoft.com/en-us/azure/virtual-machines/ndm-a100-v4-series) series VMs.

Pipe_500 and Tank_1000 test case models are considered for testing the performance of the M-STAR on Azure VMs. The model details are shown below.

:::row:::
    :::column:::
    ![Image shows Pipe_500 Model](media/image2.png)
    :::column-end:::
    :::column:::
    ![Image shows Tank_1000 Model](media/image3.png)
    :::column-end:::
:::row-end:::

### Results for NC A100 v4

#### **Pipe_500 Model**

The following table shows the total runtime and relative speed increase.

| **VM Size** | **No. of GPUs** | **Total Run Time(sec)** | **Speed** **increase** |
|---|---|---|---|
| Standard_NC96ads_A100_v4 | 1 | 15921.18 | 1.00 |
| Standard_NC96ads_A100_v4 | 2 | 8347.98 | 1.91 |

#### **Tank_1000 Model**

The following table shows the total runtime.

| **VM Size** | **No. of GPUs** | **Total Run Time(sec)** |
|---|---|---|
| Standard_NC96ads_A100_v4 | 1 | NA |
| Standard_NC96ads_A100_v4 | 2 | 1420.25 |

### Additional notes about tests on NC A100 v4

1. Since The Tank-1000 Model is large, it cannot be run on 1 GPU of the NCv4 Virtual Machine.
2. For M-STAR CFD, an NVLink connection is required.
3. Since the architecture of NCv4 Virtual Machines only supports dual GPU connectivity, we only evaluate models on 1 and 2 GPUs.

### Results for NDm A100 v4

#### **Pipe_500 Model**

The following table shows the total runtime and relative speed increase.

| **VM Size** | **No. of GPUs** | **Total Run Time(sec)** | **Speed** **increase** |
|:---:|:---:|:---:|:---:|
| Standard_NC96ads_A100_v4 | 1 | 15921.18 | 1.00 |
| Standard_ND96amsr_A100_v4 | 2 | 8967.48 | 1.78 |
| Standard_ND96amsr_A100_v4 | 4 | 4463.21 | 3.57 |
| Standard_ND96amsr_A100_v4 | 8 | 2276.67 | 6.99 |

#### **Tank_1000 Model**

The following table shows the total runtime and relative speed increase.

| **VM Size** | **No. of GPUs** | **Total Run Time(sec)** | **Speed** **increase** |
|:---:|:---:|:---:|:---:|
| Standard_ND96amsr_A100_v4 | 2 | 1481.36 | 1.00 |
| Standard_ND96amsr_A100_v4 | 4 | 735.31 | 2.01 |
| Standard_ND96amsr_A100_v4 | 8 | 429.69 | 3.45 |

### Notes about tests on NDm A100 v4

The NC A100 v4-series VMs only had individual pairs of GPUs connected peer-to-peer, while the NDmA100 v4-series VMs had full peer-to-peer between all the 8 GPUs.  Effectively, this means that users should use the NC A100 v4-series systems for simulations running on 1 or 2 GPUs.  But for anything that needs more than 2 GPUs, it is much better to use the NDmA100 v4-series VMs.

For the Pipe 500 model, we plotted a scaleup using the 1 GPU NCv4 result as a baseline.

## Azure cost

Only model running time (wall clock time) is considered for these cost calculations. Application installation time is not considered. The calculations are indicative. The actual numbers depend on the size of the model.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your configuration.

The following tables provide elapsed times in hours. To compute the total cost, multiply by the Azure VM hourly cost, which you can find [here for Windows](https://azure.microsoft.com/pricing/details/virtual-machines/windows/) and [here for Linux](https://azure.microsoft.com/pricing/details/virtual-machines/linux/).

### Cost for Pipe_500

#### **NDm A100 v4**

| **No. of GPUs** | **Time in** **Hour** |
|---|---|
| **2** | 2.49 |
| **4** | 1.23 |
| **8** | 0.63 |

#### **NC A100 v4**

| **No. of GPUs** | **Time in Hour** |
|---|---|
| **1** | 4.42 |
| **2** | 2.31 |

### Cost for Tank_1000

#### **NDm A100 v4**

| **No. of GPUs** | **Time in Hour** |
|---|---|
| **2** | 0.41 |
| **4** | 0.20 |
| **8** | 0.11 |

#### **NC A100 v4**

| **No. of GPUs** | **Time in Hour** |
|---|---|
| **1** | NA |
| **2** | 0.39 |

## Summary

M-STAR 3.8.27 is successfully tested on NCA100v4 and NDmA100V4 Virtual Machines on the Azure Cloud Platform.

From the models tested, we could observe that M-STAR is scaling almost linearly with the increase of GPU’s.

We could observe a scaleup of up to 7x for the model Pipe_500 with 8 GPU’s.

## Contributors

*This article is being updated and maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

[Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager

[Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager

[Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) | HPC Performance Engineer

Other contributors:

* [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
* [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy
* [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5/) | Manager

## Next steps

* [GPU Optimized Virtual Machine Sizes](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-gpu)
* [Windows Virtual Machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/overview)
* [Virtual networks and virtual machines on Azure](https://learn.microsoft.com/en-us/azure/virtual-network/network-overview)
* [Learning path: Run high-performance computing (HPC) applications on Azure](https://learn.microsoft.com/en-us/training/paths/run-high-performance-computing-applications-azure)

## Related resources

* [Run a Linux VM on Azure](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm)
* [HPC system and big-compute solutions](https://learn.microsoft.com/en-us/azure/architecture/solution-ideas/articles/big-compute-with-azure-batch)
* [HPC cluster deployed in the cloud](https://learn.microsoft.com/en-us/azure/architecture/solution-ideas/articles/hpc-cluster)


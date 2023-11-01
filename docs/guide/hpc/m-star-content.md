This article briefly describes the steps for running [M-Star](https://mstarcfd.com/) computational fluid dynamics software on an Azure virtual machine (VM). It also presents the performance results of running M-Star on Azure.

M-Star is a multiphysics modeling package that simulates fluid flow, heat transfer, species transport, chemical reactions, particle transport, and rigid-body dynamics. It uses large eddy simulation and advanced lattice-Boltzmann algorithms that run entirely on GPUs. 
M-Star is used in the chemical, biopharmaceutical, and energy industries.

## Why deploy M-Star on Azure?

* Modern and diverse compute options to align with your workload's needs 
* The flexibility of virtualization without the need to buy and maintain physical hardware 
* Rapid provisioning 
* Technology that enables the creation of exceedingly complex flow fields in a short amount of time 
* Integrated post-processing capability, such as creating photorealistic renderings

## Architecture

:::image type="content" source="media/m-star-architecture.svg" alt-text="Diagram that shows an architecture for deploying M-Star." lightbox="media/m-star-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/m-star-architecture.vsdx) of this architecture.*

## Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Windows and Linux VMs. For information about deploying VMs and installing the drivers, see [Windows VMs on Azure](../../reference-architectures/n-tier/windows-vm.yml) and [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud.
   - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VMs.
   - A public IP address connects the internet to the VMs.
- A physical SSD is used for storage.

## Compute sizing and drivers

For performance tests of M-Star on [NDm A100 v4](/azure/virtual-machines/ndm-a100-v4-series) and [NC A100 v4](/azure/virtual-machines/nc-a100-v4-series) series Azure VMs, the Linux operating system was used. The following table provides the configuration details of these VMs.

|Size | vCPU | Memory: GiB | Temporary storage (SSD): GiB | GPU | GPU memory: GiB | Maximum data disks | Maximum uncached disk throughput: IOPS / MBps | Maximum network bandwidth | Maximum NICs |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Standard_NC48ads_A100_v4 | 48 | 440 | 2,246 | 2 | 160 | 24 | 60,000 / 2,000 | 40,000 Mbps | 4 |
| Standard_ND96amsr_A100_v4 | 96 | 1,900 | 6,400 | 8 A100 80-GB GPUs (NVLink 3.0) | 80 | 32 | 80,000 / 800 | 24,000 Mbps | 8 |

### Required drivers

To take advantage of the GPU capabilities of [NC A100 v4](/azure/virtual-machines/nc-a100-v4-series) and [NDm A100 v4](/azure/virtual-machines/ndm-a100-v4-series) series VMs, you need to install NVIDIA GPU drivers.

## M-Star installation

Before you install M-Star, you need to deploy and connect to a VM and install the required NVIDIA  drivers.

For information about deploying the VM and installing the drivers, see one of these articles:

* [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
* [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)

> [!Important] 
> NVIDIA Fabric Manager is required for VMs that use NVLink or NVSwitch.

The following table provides details about the operating system and NVIDIA drivers that were used for these tests.

|Operating system version | OS architecture | GPU driver version | CUDA version| MPI |
|:---|:---|:---|:---|:---|
|Linux (Ubuntu HPC 18.04 Gen 2) | x86-64 | 510.85.02 | 11.6 | openmpi-4.1.1 |

You can install M-Star from the [M-Star installation page](https://docs.mstarcfd.com/2_Installation/txt-files/Installation-index.html). For information about the installation process, see [M-Star on Linux](https://docs.mstarcfd.com/2_Installation/txt-files/Linux-single-node.html).

## M-Star performance results

This performance analysis uses M-Star 3.8.27 on the Windows operating system. [NC A100 v4](/azure/virtual-machines/nc-a100-v4-series) and [NDm A100 v4](/azure/virtual-machines/ndm-a100-v4-series) series VMs are used.

Pipe_500 and Tank_1000 test case models are considered for testing the performance of the M-Star on Azure VMs. The model details are shown below.
 
    ![Image shows Pipe_500 Model](media/image2.png)
 
    ![Image shows Tank_1000 Model](media/image3.png)
 

### Results for NC A100 v4

#### **Pipe_500 Model**

The following table shows the total runtime and relative speed increase.

| **VM Size** | **No. of GPUs** | **Total Run Time(sec)** | **Speed** **increase** |
|---|---|---|---|
| Standard_NC96ads_A100_v4 | 1 | 15921.18 | 1.00 |
| Standard_NC96ads_A100_v4 | 2 | 8347.98 | 1.91 |

graph

#### **Tank_1000 Model**

The following table shows the total runtime.

| **VM Size** | **No. of GPUs** | **Total Run Time(sec)** |
|---|---|---|
| Standard_NC96ads_A100_v4 | 1 | NA |
| Standard_NC96ads_A100_v4 | 2 | 1420.25 |

### Additional notes about tests on NC A100 v4

1. Since The Tank-1000 Model is large, it cannot be run on 1 GPU of the NCv4 Virtual Machine.
2. For M-STAR, an NVLink connection is required.
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

graph

#### **Tank_1000 Model**

The following table shows the total runtime and relative speed increase.

| **VM Size** | **No. of GPUs** | **Total Run Time(sec)** | **Speed** **increase** |
|:---:|:---:|:---:|:---:|
| Standard_ND96amsr_A100_v4 | 2 | 1481.36 | 1.00 |
| Standard_ND96amsr_A100_v4 | 4 | 735.31 | 2.01 |
| Standard_ND96amsr_A100_v4 | 8 | 429.69 | 3.45 |

graph

### Notes about tests on NDm A100 v4

1. The NC A100 v4-series VMs only had individual pairs of GPUs connected peer-to-peer, while the NDmA100 v4-series VMs had full peer-to-peer between all the 8 GPUs.  Effectively, this means that users should use the NC A100 v4-series systems for simulations running on 1 or 2 GPUs.  But for anything that needs more than 2 GPUs, it is much better to use the NDmA100 v4-series VMs.

1. For the Pipe 500 model, we plotted a scaleup using the 1 GPU NCv4 result as a baseline.

## Azure cost

Only model running time (wall clock time) is considered for these cost calculations. Application installation time is not considered. The calculations are indicative. The actual numbers depend on the size of the model.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your configuration.

The following tables provide elapsed times in hours. To compute the total cost, multiply by the Azure VM hourly cost, which you can find [here for Windows](https://azure.microsoft.com/pricing/details/virtual-machines/windows/) and [here for Linux](https://azure.microsoft.com/pricing/details/virtual-machines/linux/).

### Cost for Pipe_500

#### NDm A100 v4

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

- M-STAR 3.8.27 is successfully tested on NCA100v4 and NDmA100V4 Virtual Machines on the Azure Cloud Platform.

- From the models tested, we could observe that M-STAR is scaling almost linearly with the increase of GPU’s.

- We could observe a scaleup of up to 7x for the model Pipe_500 with 8 GPU’s.

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


---
author: Anjankar, Aashay Vinod
ms.date: 01/03/2024
---
# Deploy tNavigator on an Azure virtual machine

This article briefly describes the steps for running Rock Flow Dynamic’s [tNavigator](https://rfdyn.com/) application on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running tNavigator. 

tNavigator is a reservoir modelling and simulation platform. It provides tools for geoscience, reservoir, and production engineering. It builds static and dynamic reservoir models and runs dynamic simulations. tNavigator runs on workstations and clusters. A cloud-based solution with full GUI capabilities via a remote desktop is also available. 

You can perform extended uncertainty analysis and surface networks builds as part of one integrated workflow. All the parts of the workflow share an internal data storage system, scalable parallel numerical engine, data input/output mechanism, and graphical user interface. tNavigator supports the metric, lab, field unit systems.

## Why deploy tNavigator on Azure?

Modern and diverse compute options to align to your workload's needs.

Flexible virtualization without purchasing physical hardware.

- Rapid provisioning.
- Complex simulations can be solved in few hours by using greater number of CPU cores.

## Architectures

:::image type="content" source="media/image1.jpg" alt-text="Diagram that shows architecture for running tNavigator on Azure VM" border="true":::

*Figure 1: Single-node configuration*

**Components:**

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Linux and Windows VMs. For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm).

[Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud. 

Network security groups are used to restrict access to the VMs.  

A public IP address connects the internet to the VM.   

A physical SSD is used for storage.  

- 

:::image type="content" source="media/image2.png" alt-text="Image showing a architecture diagram of a multi node cluster in azure." border="true":::

**Components:** 

- Azure Virtual Machines is used to create Linux and Windows VMs. For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm).

[Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud. 

- Azure CycleCloud is used to create the cluster in the multi-node configuration.

[Network security groups](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VMs.  

A public IP address connects the internet to the VM.   

A physical SSD is used for storage.   

- 

## Compute sizing and drivers

Performance tests of tNavigator on Azure used [HBv3-series](https://learn.microsoft.com/en-us/azure/virtual-machines/hbv3-series) VM running on Linux OS. The following table provides the configuration details of HBv3-series VM:

| **VM** **Size** | **vCPU** | **Memory: GiB** | **Memory bandwidth GB/s** | **Base CPU frequency (GHz)** | **All-cores frequency (GHz, peak)** | **Single-core frequency (GHz, peak)** | **RDMA performance (Gb/s)** |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **Standard_HB120-16rs_v3** | 16 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| **Standard_HB120-32rs_v3** | 32 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| **Standard_HB120-64rs_v3** | 64 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| **Standard_HB120-96rs_v3** | 96 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| **Standard_HB120-120rs_v3** | 120 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |

## tNavigator installation

Before you install tNavigator, you need to deploy and connect a VM. For information about deploying the VM and installing the drivers, see Run a Linux VM on Azure. You can download and install tNavigator from the Rock Flow Dynamics Portal. For information about the installation process, see Rock Flow Dynamics resource hub.

## tNavigator performance results

Performance tests of tNavigator on Azure used [HBv3-series](https://learn.microsoft.com/en-us/azure/virtual-machines/hbv3-series) VM running on Linux OS. The following table provides the Operating system details.

| **Operating system version** | **OS Architecture** |
|:---:|:---:|
| **Linux** **CentOS-HPC-8.1** | x64-Bit |

The performance of tNavigator was tested on two different models using the Azure HBv3 series VM. These are two standard and stable models to test the performance of tNavigator. The model details are shown below.

**Model 1:**

| **Model Name** | **Speed test model** |
|---|---|
| **Model dimensions** | NX = 88, NY = 215, NZ = 177 (SIZE = 3,348,840) |
| **Total active grid blocks** | 2,418,989 |
| **Total pore volume** | 13,563,305,518.45987 rm3 |
| **Mesh connections statistics** | total = 7,052,853<br>geometrical = 7,052,853 |

:::image type="content" source="media/image3.png" alt-text="The image shows 3D view of Speed test model" border="true":::

**Model 2:**

| **Model Name** | **Speed test 9** **model** |
|---|---|
| **Model dimensions** | NX = 264, NY = 645, NZ = 177 (SIZE = 30,139,560) |
| **Total active grid blocks** | 21770901 |
| **Total pore volume** | 13,563,305,518.45987 rm3 |
| **Mesh connections statistics** | total = 64,533,441<br>geometrical = 64,533,441 |

:::image type="content" source="media/image3.png" alt-text="The image shows 3D view of Speed test 9 model" border="true":::

### tNavigator performance results on single node

The following sections provide the performance results of running tNavigator on single-node Azure [HBv3 AMD EPYC™ 7V73X](https://docs.microsoft.com/en-us/azure/virtual-machines/hbv3-series) VMs. 

#### Model 1 – Speed test

The following table shows elapsed time of the speed test model in seconds:

| **VM** **Size** | **No. of vCPU used** | **Total Elapsed time in Seconds** | **Relative speed** **increase** |
|:---:|:---:|:---:|:---:|
| **Standard_HB120-16rs_v3** | 8 | 643 | 1 |
| **Standard_HB120-16rs_v3** | 16 | 352 | 1.82 |
| **Standard_HB120-32rs_v3** | 32 | 208 | 3.09 |
| **Standard_HB120-64rs_v3** | 64 | 139 | 4.62 |
| **Standard_HB120-96rs_v3** | 96 | 128 | 5.05 |
| **Standard_HB120-120rs_v3** | 120 | 132 | 4.87 |

The following chart shows relative speed increases in terms of total elapsed time of the speed test model:

#### Model 2 – Speed test 9

The following table shows total elapsed time of speed test 9 in seconds:

| **VM** **Size** | **No. of vCPU used** | **Total Elapsed time in Seconds** | **Relative speed** **increase** |
|:---:|:---:|:---:|:---:|
| **Standard_HB120-16rs_v3** | 8 | 20045 | 1 |
| **Standard_HB120-16rs_v3** | 16 | 11541 | 1.73 |
| **Standard_HB120-32rs_v3** | 32 | 6588 | 3.04 |
| **Standard_HB120-64rs_v3** | 64 | 4572 | 4.38 |
| **Standard_HB120-96rs_v3** | 96 | 4113 | 4.87 |
| **Standard_HB120-120rs_v3** | 120 | 4061 | 4.93 |

The following chart shows relative speed increases of speed test 9 model:

#### Additional notes about tests on tNavigator

Near linear relative speed up was observed as the number of CPU cores were increased up to the optimal configuration for a given model. 

- For all single-node tests, we have taken the slower time on HB120-16rs_v3 (8 cores) as the reference to calculate the relative speed up with respect to other similar VMs with more cores. The results presented above show that computation performance improves as we increase from 8 to 120 cores, up to the optimal configuration for a given model.

  

**tNavigator performance results on multi-node**

The following sections provide the performance results of running tNavigator on multi-node Azure HBv3-series VMs. Model1 is not a suitable for testing in multi node environment, so test were restricted to Model 2.

#### Model 2 – Speed test 9

This table shows the total elapsed time recorded for varying numbers of Nodes with Standard_HB120-64rs_v3 VMs on Azure CycleCloud.

| **VM size** | **Number of nodes** | **Number ofvCPU** | **Total Elapsed time(seconds)** | **Relative speed** **increase** |
|:---:|:---:|:---:|:---:|:---:|
| **Standard_HB120-64rs_v3** | 1 | 64 | 5025 | 1.00 |
| | 2 | 128 | 3323 | 1.51 |
| | 4 | 256 | 2264 | 2.22 |
| | 8 | 512 | 1697 | 2.96 |
| | 16 | 1024 | 1383 | 3.63 |

The following graph shows the relative speed up as the number of nodes increases:

 

**Notes about the multi-node tests** 

From the multi-node results, we can observe that models scale linearly up to 16 nodes, giving maximum speed up of 3.63 times the single node. We have limited our validation study to a few iterations.

## Azure Cost

Only the model running time (elapsed time) is considered for these cost calculations. Application installation time isn't considered. The calculations are indicative. The actual cost depends on the size of the model. You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your configuration.

The following tables provide elapsed times in hours. To compute the total cost, multiply by the Azure VM hourly cost, which you can find[ here for Linux.](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/)

### Total elapsed time for model 1 (Single node):  Speed Test model

| **Number**<br>**of** **VCPUs** | **Total Elapsed time** **(Hr)** |
|:---:|:---:|
| 8 | 0.17 |
| 16 | 0.09 |
| 32 | 0.05 |
| 64 | 0.03 |
| 96 | 0.03 |
| 120 | 0.03 |

### Total elapsed time for model 2 (Single node): Speed Test 9 Model

| **Number**<br>**of** **VCPUs** | **Total Elapsed time** **(Hr)** |
|:---:|:---:|
| 8 | 5.56 |
| 16 | 3.20 |
| 32 | 1.83 |
| 64 | 1.27 |
| 96 | 1.14 |
| 120 | 1.12 |

### Total elapsed time for model 2 (Multi-Node): Speed Test 9 Model

| **Number**<br>**of** **nodes** | **Total Elapsed time** **(Hr)** |
|:---:|:---:|
| 1 | 1.40 |
| 2 | 0.92 |
| 4 | 0.63 |
| 8 | 0.47 |
| 16 | 0.38 |

## Summary

- RFD tNavigator, powered by Microsoft Azure platform exhibits high scalability when deployed on HBv3-series (AMD EPYC™ 7V73X [Milan-X] CPU cores).  To calculate scalability, we calculate the ratio of the inverse of time elapsed to solve a given model.
- For evaluating the performance, the lowest VM configuration of the series is considered as the baseline i.e. 8 vCPUs for HBv3. The results are assessed based on the relative performance, where higher values indicate better performance. 
- For the single node setup on HBv3, it is observed that the solution is completed approximately 1.5x times faster whenever the cores are doubled. Moderation of scaleup is observed as we reach optimal configuration. Further increase of cores beyond optimal configuration doesn’t result in improving the performance.
- For the multimode setup on HBv3 using Azure Cycle Cloud, , it is observed that the solution is completed approximately 1.3x to 1.5x times faster whenever the nodes are doubled. Moderation of scaleup is observed as we reach optimal configuration. 

Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Saurabh Parave](https://www.linkedin.com/in/saurabh-parave-957303162/) | HPC Performance Engineer
- [Aashay Anjankar](https://www.linkedin.com/in/aashay-anjankar-6a44291ba) | HPC Performance Engineer

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


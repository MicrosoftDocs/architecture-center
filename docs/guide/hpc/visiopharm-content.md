This article briefly describes the steps for running [Visiopharm](https://visiopharm.com) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running Visiopharm on Azure.

Visiopharm is an AI-based image analysis and tissue mining tool that supports drug development research and other research.  

Visionpharm:

- Enables researchers to align and subsequently analyze digitized serial sections. 
- Enables tissue researchers to analyze both simple and complex datasets to generate reliable quantitative results.
- Uses pre-trained nuclei segmentation APPs, suitable for bright-field and fluorescence applications.

Visiopharm is used in academic institutions, the biopharmaceutical industry, and diagnostic centers. It's ideal for the education, healthcare, and manufacturing industries.

## Why deploy Visiopharm on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning

## Architecture

:::image type="content" source="media/visiopharm/visiopharm-architecture.svg" alt-text="Diagram that shows an architecture for deploying Visiopharm." lightbox="media/visiopharm/visiopharm-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/visiopharm.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Windows VM. For information about deploying the VM and installing the drivers, see [Windows VMs on Azure](../../reference-architectures/n-tier/windows-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  - A public IP address connects the internet to the VM.
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

The performance tests of Visiopharm used [Standard_NC24s_v3](/azure/virtual-machines/ncv3-series) and [Standard_NC16as_T4_v3](/azure/virtual-machines/nct4-v3-series) VMs running Windows. The following table provides details about the VMs.

|VM |	vCPU|	Memory (GiB)|	SSD (GiB)|	GPU	|GPU memory (GiB)|	Maximum data disks|
|-|-|-|-|-|-|-|
|Standard_NC24s_v3	|24|	448|	2,948|	4 V100|	64|	32|
|Standard_NC16as_T4_v3|	16|	110|	360|	1 T4|	16	|32|

### Required drivers

To take advantage of the GPU capabilities of [Standard_NC24s_v3](/azure/virtual-machines/ncv3-series) and [Standard_NC16as_T4_v3](/azure/virtual-machines/nct4-v3-series) VMs, you need to install NVIDIA GPU drivers.

To use AMD processors on [Standard_NC16as_T4_v3](/azure/virtual-machines/nct4-v3-series) VMs, you need to install AMD drivers.

## Visiopharm installation

Before you install Visiopharm, you need to deploy and connect a VM, install an eligible Windows 10 or Windows 11 image, and install NVIDIA and AMD drivers, as needed.

For information about eligible Windows images, see [How to deploy Windows 10 on Azure](/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment) and [Use Windows client in Azure for dev/test scenarios](/azure/virtual-machines/windows/client-images).

For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

For information about installing the software, contact [Visiopharm](https://visiopharm.com). 

## Visiopharm performance results

To test the performance of Visiopharm, image analysis was performed on Standard_NC24s_v3 and Standard_NC16as_T4_v3 VMs, and the performance was compared. Visiopharm version 2022.03 was used for testing. 

Three Visiopharm solutions (APPs) were run: 

- APP1: Tissue detection
- APP2: Segmentation
- APP3: Cell detection AI 

The image is called LuCa 6Plex. It's a set of pathology data that's provided by Visiopharm. The three APPs predominantly use the GPU capabilities of the VMs to run analyses.

The following table shows the results.

|VM | GPU| APP1 elapsed time|APP2 elapsed time| APP3 elapsed time|
|-|-|-|-|-|
|Standard_NC24s_v3*|V100|00:00:20|03:55:02|00:45:21|
|Standard_NC16as_T4_v3|Tesla T4|00:00:21|03:33:01|00:42:43|

\* *This test was performed with an artificially limited one-GPU configuration. This VM has four GPUs.*

The following graph shows the relative performance of the two VMs. Note that this comparison uses a one-GPU configuration for both VMs. The Standard_NC24s_v3 has four GPUs, although the NCv3 series provides options with one, two, and four GPUs.

:::image type="content" source="media/visiopharm/graph.png" alt-text="Graph that shows the relative performance of the two VMs." border="false":::

## Azure cost

The following table presents the wall-clock times for running the analyses. You can use these times and the Azure VM hourly costs for NCas_T4_v3 series VMs to compute costs. For the current hourly costs, see [Windows Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing).

Only analysis time is considered for these calculations. Application installation time isn't included.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

|VM |		APP1: Tissue detection	|APP2: Segmentation|	APP3: Cell detection AI|
|-|-|-|-|
|Standard_NC16as_T4_v3|		21 seconds	|3 hours, 33 minutes|	42 minutes, 43 seconds|

## Summary

- Visiopharm was successfully tested on Standard_NC24s_v3 and Standard_NC16as_T4_v3 VMs.
- Based on a one-GPU configuration for both VMs, Standard_NC16as_T4_v3 performs better. 

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

-   [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) |
    Senior Manager
-   [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) |
    Principal Program Manager
-   [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) |
    HPC Performance Engineer

Other contributors:

-   [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) |
    Technical Writer
-   [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director
    Business Strategy
-   [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) |
    Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [GPU-optimized virtual machine sizes](/azure/virtual-machines/sizes-gpu)
- [Virtual machines on Azure](/azure/virtual-machines/overview)
- [Virtual networks and virtual machines on Azure](/azure/virtual-network/network-overview)
- [Learning path: Run high-performance computing (HPC) applications on Azure](/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)

This article briefly describes the steps for running [Indica Labs HALO AI](https://indicalab.com/halo-ai) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running HALO AI on Azure.

HALO AI is a collection of train-by-example classification and segmentation tools underpinned by advanced deep learning neural network algorithms. It was originally developed as a tool that could decipher and assess the complex patterns of histologically stained tissues in a way that's similar to how a pathologist thinks. 

:::image type="content" source="media/halo-ai/image-classification.png" alt-text="Figure that shows image classification in HALO AI." border="false":::

HALO AI has the following capabilities.

- Includes three powerful neural networks: VGG, DenseNet, and MiniNet. 
- Provides pretrained networks for H&E, single IHC, or DAPI stained-images. You can also train your own nuclei segmentation network for a specific application.
- Uses a type of deep learning algorithm called a convolutional neural network (CNN), which is ideally suited for tissue classification in digital pathology.

HALO AI is used across the healthcare industry, in clinical, pharmaceutical, biotech, and central research (education) organizations.

## Why deploy HALO AI on Azure?

- Modern and diverse compute options to align to your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Fast compute capabilities for GPU-intensive workloads

## Architecture

:::image type="content" source="media/halo-ai/architecture.png" alt-text="Diagram that shows an architecture for deploying HALO AI." lightbox="media/halo-ai/architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/halo-ai.vsdx) of this
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

Performance tests of HALO AI on Azure used [Standard_NC6s_v3](/azure/virtual-machines/ncv3-series) and [Standard_NC4as_T4_v3](/azure/virtual-machines/nct4-v3-series) VMs running Windows. The following table provides details about the VMs.

|VM size|vCPU|Memory (GiB)|SSD (GiB)|GPU|GPU memory (GiB)|Maximum data disks|
|-|-|-|-|-|-|-|
|Standard_NC6s_v3|6|112|736|V100|16|12|
|Standard_NC4as_T4_v3|4|28|180|T4|16|8|

### Required drivers

To take advantage of the GPU capabilities of [Standard_NC6s_v3](/azure/virtual-machines/ncv3-series) and [Standard_NC4as_T4_v3](/azure/virtual-machines/nct4-v3-series) VMs, you need to install NVIDIA GPU drivers.

To use AMD processors on Standard_NC4as_T4_v3 VMs, you need to install AMD drivers.

## HALO AI installation

Before you install HALO AI, you need to deploy and connect a VM,  install an eligible Windows 10 image, and install the required NVIDIA and AMD drivers.

For information about eligible Windows images, see [How to deploy Windows 10 on Azure](/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment) and [Use Windows client in Azure for dev/test scenarios](/azure/virtual-machines/windows/client-images).

For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

For information about installing HALO AI on an Azure VM, contact [Indica Labs](mailto:support@indicalab.com).

## HALO AI performance results

HALO AI performs best on machines that have single-GPU configurations.
Testing was performed on Standard_NC6s_v3, which has one NVIDIA V100 GPU, and Standard_NC4as_T4_v3, which has one T4 GPU. Image classification was performed on 20 pathology datasets.

The following table shows the test results.

|Image ID|Analysis<br> time on<br> NC4as_T4_v3<br> (minutes)|Analysis<br> time on<br> NC6s_v3<br> (minutes) |
|-|-|-|
|1|15|7|
|2|10|5|
|3|11|6|
|4|7|3|
|5|11|5|
|6|11|5|
|7|11|6|
|8|6|3|
|9|11|6|
|10|9|5|
|11|5|3|
|12|9|4|
|13|13|7|
|14|8|4|
|15|12|6|
|16	|9|	5|
|17|7|4|
|18|18|11|
|19|6|3|
|20|14|8|

This graph shows the elapsed running times on both VMs:

:::image type="content" source="media/halo-ai/elapsed-times.png" alt-text="Graph that shows the elapsed times."  border="false":::

NC6s_v3 is consistently faster. This graph shows the relative speed increases:

:::image type="content" source="media/halo-ai/speed-increase.png" alt-text="Graph that shows the relative speed increases on NCv3."  border="false":::

## Azure cost

The following table presents elapsed times that you can use to calculate Azure costs. You can multiply the times presented here by the Azure hourly rates for NCasT4_v3 and NCsv3 series VMs to calculate costs. For the current hourly costs, see [Windows Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing). 

Only analysis times are considered for the cost calculations. Application installation time isn't considered. These times are indicative. Actual times depend on the size of the model.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

|VM size|GPU|Elapsed time<br> for all 20 images<br> (hours)|
|-|-|-|
|Standard_NC4as_T4_v3|T4 |3.38|
|Standard_NC6s_v3|V100|1.77|
 
## Summary

- HALO AI was successfully tested on NC6s_v3 and NC4as_T4 series VMs. HALO AI performs best with single-GPU configurations, so we recommend that you use a VM with that configuration.
- NC6s_v3 is almost twice as fast as NC4as_T4.

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) |
    Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) |
    Principal Program Manager
- [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) |
    HPC Performance Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) |
    Technical Writer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director
    Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) |
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

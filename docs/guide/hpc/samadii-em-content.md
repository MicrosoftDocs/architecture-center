This article briefly describes the steps for running [Samadii EM](https://www.metariver.kr/smdem.html) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running Samadii EM on Azure.

Samadii EM (electromagnetic) analyzes the electromagnetic field in three-dimensional space by using the Maxwell equation. It calculates the Maxwell equation by using the vector finite element method (FEM) and GPU computing.

The application provides a multi-physics solution to complex electromagnetic problems. It can analyze problems in electrostatic fields, AC electromagnetic fields, and electromagnetic wave fields.

Samadii EM is used in wireless communications and by manufacturers of radar devices, motors, semiconductors, and display devices. It's ideal for the telecommunications, manufacturing, and automotive industries.

## Why deploy Samadii EM on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- VM options that enable you to optimize for varying levels of simulation complexity  

## Architecture

:::image type="content" source="media/samadii-em/samadii-em-architecture.svg" alt-text="Diagram that shows an architecture for deploying Samadii EM." lightbox="media/samadii-em/samadii-em-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/samadii-em.vsdx) of this
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

The performance tests of Samadii EM on Azure used [NVadsA10_v5](/azure/virtual-machines/nva10v5-series), [NCas_T4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), and [NC_A100_v4](/azure/virtual-machines/nc-a100-v4-series) VMs running Windows 10.

The following table shows information about the operating systems that were used for testing:

||	NCv3| NCasT4_v3|	NVadsA10_v5 |	NC_A100_v4|
|-|-|-|-|-|
|Operating system version	|Windows 10 Professional, version 20H2|Windows 10 Professional, version 20H2|	Windows 10, version 20H2|	Windows 10, version 21H2|
|OS architecture|	x86-64|	x86-64|	x86-64|	x86-64|
|Processor|	Intel Xeon CPU E5-2690 v4	|AMD EPYC 7V12, 64-core processor, 2.44 GHz|	AMD EPYC 74F3V (Milan)|	AMD EPYC 7V13, 64-core processor, 2.44 GHz|

### Required drivers

To take advantage of the GPU capabilities of [NVadsA10_v5](/azure/virtual-machines/nva10v5-series), [NCasT4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), and [NC_A100_v4](/azure/virtual-machines/nc-a100-v4-series) VMs, you need to install NVIDIA GPU drivers.

To use AMD processors on [NVadsA10](/azure/virtual-machines/nva10v5-series), [NCasT4_v3](/azure/virtual-machines/nct4-v3-series), and [NC_A100_v4](/azure/virtual-machines/nc-a100-v4-series) VMs, you need to install AMD drivers.

## Samadii EM installation

Before you install Samadii EM, you need to deploy and connect a VM, install an eligible Windows 10 image, and install the required NVIDIA and AMD drivers.

For information about eligible Windows images, see [How to deploy Windows 10 on Azure](/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment) and [Use Windows client in Azure for dev/test scenarios](/azure/virtual-machines/windows/client-images).

For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

The product installation process involves installing a license server, installing Samadii EM, and configuring the license server. For more information about installing Samadii EM, contact [Metariver Technology](https://www.metariver.kr/index.html). 

## Samadii EM performance results

The nonlinear current model was used for testing:

:::image type="content" source="media/samadii-em/current-nonlinear.png" alt-text="Screenshot that shows the nonlinear current model." border="false":::

- **Model size:** 219,398
- **Solver:** Samadii EM V21 V22 R1

To get a baseline, this model was tested on an on-premises VM with the following configuration:

|Processor| 	GPU| 	Elapsed time (seconds)|
|-|-|-|
|Intel i7-3770 CPU|	NVIDIA Titan X (Pascal)	|		4,471|


The following table shows the relative speed increases over this baseline:

|VM|	GPU |	Number of GPUs used|	Elapsed time (seconds)	|Relative speed increase|
|-|-|-|-|-|
|NVadsA10_v5	|NVIDIA A10	|1/6	|17,181	|0.26|
|NVadsA10_v5	|NVIDIA A10|			1/3|	9,350|	0.48|
|NVadsA10_v5	|NVIDIA A10	|		1/2|	6,743|	0.66|
|NVadsA10_v5	|NVIDIA A10	|1	|1,933	|2.31|
|NCasT4_v3	|Tesla T4	|1	|1,875|	2.38|
|NCv3	|V100|	1	|1,689	|2.65|
|NC_A100_v4	|A100 80-GB PCle	|1	|1,290|	3.47|

This graph shows the relative speed increases for the previous GPU configurations: 

:::image type="content" source="media/samadii-em/em-graph.png" alt-text="Graph that shows the relative speed increases." border="false":::

## Azure cost

The following table shows wall-clock times in hours. To compute the total cost, multiply these times by the Azure VM hourly costs for NVadsA10v5, NCas_T4_v3, NCsv3, or NCA100v4 VMs. For the current hourly costs, see [Windows Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing).

Only simulation runtime is included in the reported times. Application installation time and license costs aren't included. 

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

|VM series	|Number of GPUs|	Wall-clock time (hours)|
|-|-|-|
|NVadsA10_v5|	1/6	|4.77|
|NVadsA10_v5|	1/3|	2.60|
|	NVadsA10_v5|1/2|	1.87|
|	NVadsA10_v5|1|	0.54|
|NCasT4_v3|	1|	0.52|
|NCv3	|1	|0.47|
|NC_A100_v4|	1	|0.36|

## Summary

- Samadii EM was successfully tested on NCv3, NCasT4_v3, NC_A100_v4, and NVadsA10_v5 VMs.
- For complex models, NC_A100_v4, NCv3, and NCasT4_v3 VMs, and the one-GPU configuration of the NVadsA10_v5 VM, all perform better than the NVadsA10_v5 VM with partial GPUs.
- For models that are less complex, configurations of NC_A100_v4 and NVadsA10_v5 VMs, including configurations that use partial GPUs, perform better than NCasT4_v3 and NCv3 VMs.
- If we take cost into consideration, NCasT4_v3 is the best choice.

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

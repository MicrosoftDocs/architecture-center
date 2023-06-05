This article briefly describes the steps for running [Samadii Plasma](https://www.metariver.kr/smdplasma.html) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running Samadii Plasma on Azure.

Samadii Plasma is a particle-based solution for the analysis of plasma behavior.

Samadii Plasma:

- Enables high-speed plasma analysis by means of high-speed electromagnetic field analysis and particle-based gas analysis.
- Uses the finite element method to analyze the Maxwell equation.
- Calculates various reactions based on collision theory by freely inputting collision cross section and chemical reaction equations.

Organizations that use Samadii Plasma include manufacturers of flat panel and OLED displays and manufacturers of semiconductors. This solution is ideal for the manufacturing and electronics industries.

## Why deploy Samadii Plasma on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Impressive performance results for simulations with varying levels of complexity  

## Architecture

:::image type="content" source="media/samadii-plasma/architecture.png" alt-text="Diagram that shows an architecture for deploying Samadii Plasma." lightbox="media/samadii-plasma/architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/samadii-plasma.vsdx) of this
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

The performance tests of Samadii Plasma on Azure used [NVv3](/azure/virtual-machines/nvv3-series), [NCas_T4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), and [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VMs running Windows 10. The following table provides details about the VMs.

|VM size|GPU|vCPU|Memory, in GiB|Maximum data disks|Number of GPUs|GPU memory, in GiB|Maximum uncached disk throughput, in IOPS / MBps|Temporary storage (SSD), in GiB|Maximum NICs|
|-|-|-|-|-|-|-|-|-|-|
|Standard_NV12s_v3|	Tesla M60|	12|	112|	12|	1|	8	|20,000 / 200|	320|	4|
|Standard_NC4as_T4_v3|	Tesla T4|	4|	28|	8	|1	|16|	-|	180|	2|
|Standard_NC6s_v3	|V100|	6	|112	|12|	1|	16|	20,000 / 200|	736|	4|
|Standard_ND96asr_v4|	A100|	96|	900	|32|	8	|40	|80,000 / 800	|6,000	|8|

### Required drivers

To take advantage of the GPU capabilities of [NVv3](/azure/virtual-machines/nvv3-series), [NCas_T4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), and [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VMs, you need to install NVIDIA GPU drivers.

To use AMD processors on [NCas_T4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), and [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VMs, you need to install AMD drivers.

## Samadii Plasma installation

Before you install Plasma, you need to deploy and connect a VM, install an eligible Windows 10 image, and install the required NVIDIA and AMD drivers.

For information about eligible Windows images, see [How to deploy Windows 10 on Azure](/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment) and [Use Windows client in Azure for dev/test scenarios](/azure/virtual-machines/windows/client-images).

> [!IMPORTANT]
> NVIDIA Fabric Manager installation is required for VMs that use NVLink. ND_A100_v4 VMs use this technology. 

For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

The product installation process involves installing a license server, installing Plasma, and configuring the license server. For more information about installing Plasma, contact [Metariver Technology](https://www.metariver.kr/index.html).

## Samadii Plasma performance results

Windows 10 Professional, version 20H2, with an x86-64 architecture, was used for all tests. The following table shows the processors that were used.

||ND_A100_v4|	NCv3|	NCas_T4_v3|	NVv3|
|-|-|-|-|-|
|Processor|	AMD EPYC 7V12, 64-core processor, 2.44 GHz (2 processors)|	Intel Xeon CPU E5-2690 v4|	AMD EPYC 7V12, 64-core processor, 2.44 GHz|	Intel Xeon CPU E5-2690 v4|

Three models were used for testing, as shown in the following sections. 

### Results for the magnetron sputter model

:::image type="content" source="media/samadii-plasma/magnetron-sputter.png" alt-text="Screenshot that shows the magnetron sputter model." :::

The following table shows the elapsed runtimes and relative speed increases on the four VMs.

|VM |	Elapsed time, in seconds	|Relative speed increase|
|-|-|-|
|NVv3|	12,825.36|	1.00|
|NCas_T4_v3	|7,606.59|	1.69|
|NCv3	|2,798.55|	4.58|
|ND_A100_v4	|1,977|	6.49|

This graph shows the relative speed increases: 

:::image type="content" source="media/samadii-plasma/graph-magnetron-sputter.png" alt-text="Graph that shows the relative speed increases for the magnetron sputter model." border="false":::

### Results for the import inlet model

:::image type="content" source="media/samadii-plasma/import-inlet.png" alt-text="Screenshot that shows the import inlet model." :::

The following table shows the elapsed runtimes and relative speed increases on the four VMs.

|VM |	Elapsed time, in seconds	|Relative speed increase|
|-|-|-|
|NVv3|248.99| 1.00|
|NCas_T4_v3	|159.61|1.56|
|NCv3	|141.59|1.76|
|ND_A100_v4	|112|2.22|

This graph shows the relative speed increases: 

:::image type="content" source="media/samadii-plasma/graph-import-inlet.png" alt-text="Graph that shows the relative speed increases for the import inlet model." border="false":::

### Results for the sputtering target model

:::image type="content" source="media/samadii-plasma/sputtering-target.png" alt-text="Screenshot that shows the sputtering target model.":::

The following table shows the elapsed runtimes and relative speed increases on the four VMs.

|VM |	Elapsed time, in seconds	|Relative speed increase|
|-|-|-|
|NVv3|13.82| 1.00|
|NCas_T4_v3	|8.46|1.63|
|NCv3	|6.86|2.01|
|ND_A100_v4	|5.9|2.34|

This graph shows the relative speed increases: 

:::image type="content" source="media/samadii-plasma/graph-sputtering-target.png" alt-text="Graph that shows the relative speed increases for the sputtering target model." border="false":::

## Azure cost

The following tables present wall-clock times in hours. To compute the total cost, multiply these times by the Azure VM hourly costs for NVv3, NCasT4_v3, NCsv3, and NDA100v4 VMs. For the current hourly costs, see [Windows Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing).

Only simulation runtime is considered in these cost calculations. Application installation time and license costs aren't included.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

### Cost, magnetron sputter model

|VM size|	Number of GPUs|		Wall-clock time, in hours|
|-|-|-|
|Standard_NV12s_v3|	1		|3.56|
|Standard_NC4as_T4_v3|	1|		2.11|
|Standard_NC6s_v3	|1		|0.78|
|Standard_ND96asr_v4|	8	|	0.55|

### Cost, import inlet model

|VM size|	Number of GPUs|		Wall-clock time, in hours|
|-|-|-|
|Standard_NV12s_v3|1|0.07|
|Standard_NC4as_T4_v3|1|0.04|
|Standard_NC6s_v3	|1|0.04|
|Standard_ND96asr_v4|8|0.03|

### Cost, sputtering target model

|VM size|	Number of GPUs|		Wall-clock time, in hours|
|-|-|-|
|Standard_NV12s_v3|1|0.0038|
|Standard_NC4as_T4_v3|1|0.0024|
|Standard_NC6s_v3	|1|0.0019|
|Standard_ND96asr_v4|8|0.0016|

## Summary

- Samadii Plasma was successfully tested on NDv4, NCv3, NCasT4_v3, and NVv3 VMs.
- For complex models, the NCv3 and NDv4 VMs provide good results.
- For models with less complexity, the NCasT4_v3 VM provides good scale-up and is cost efficient.

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

-   [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) |
    Senior Manager
-   [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) |
    Principal Program Manager
-   [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) |
    HPC Performance Engineer

Other contributors:

-   [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) |
    Technical Writer
-   [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director
    Business Strategy
-   [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) |
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

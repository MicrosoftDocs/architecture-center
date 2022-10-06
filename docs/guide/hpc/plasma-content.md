<Intro should cover a basic overview of the workload.>

## Why deploy Samadii Plasma on Azure?
- Modern and diverse compute options to align to your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Impressive performance results for both small and large simulations  

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

Performance tests of Samadii Plasma on Azure used [NVv3](/azure/virtual-machines/nvv3-series), [NC4as_T4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) series VMs running Windows 10. The following table provides details about the VMs.

|VM size|GPU|vCPU|Memory, in GiB|Maximum data disks|Number of GPUs|GPU memory, in GiB|Maximum uncached disk throughput, in IOPS / MBps|Temporary storage (SSD), in GiB|Maximum NICs|
|-|-|-|-|-|-|-|-|-|-|
|Standard_NV12s_v3|	Tesla M60|	12|	112|	12|	1|	8	|20,000 / 200|	320|	4|
|Standard_NC4as_T4_v3|	Tesla T4|	4|	28|	8	|1	|16|	-|	180|	2|
|Standard_NC6s_v3	|V100|	6	|112	|12|	1|	16|	20,000 / 200|	736|	4|
|Standard_ND96asr v4|	A100|	96|	900	|32|	8	|40	|80,000 / 800	|6,000	|8|

### Required drivers

To take advantage of the GPU capabilities of [NVv3](/azure/virtual-machines/nvv3-series), [NC4as_T4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) series VMs, you need to install NVIDIA GPU drivers.

To use AMD processors on [NC4as_T4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), and [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) series VMs, you need to install AMD drivers.

## Samadii Plasma installation

Before you install Plasma, you need to deploy and connect a VM, install an eligible Windows 10 image, and install the required NVIDIA and AMD drivers.

For information about eligible Windows images, see [How to deploy Windows 10 on Azure](/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment) and [Use Windows client in Azure for dev/test scenarios](/azure/virtual-machines/windows/client-images).

> [!IMPORTANT]
> NVIDIA Fabric Manager installation is required for VMs that use NVLink. ND_A100_v4 VMs use this technology. 

For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](/azure/architecture/reference-architectures/n-tier/windows-vm).

The product installation process involves installing a license server, installing Plasma, and configuring the license server. For more information about installing Plasma, contact [Metariver Technology](https://www.metariver.kr/index.html).

## Samadii Plasma performance results

Windows 10 Professional, version 20H2, with an x86-64 architecture, was used for all tests. The following table shows the processors that were used.

||ND_A100_v4|	NCv3|	NC4as_T4_v3|	NVv3|
|-|-|-|-|-|
|Processor|	AMD EPYC 7V12, 64-core processor, 2.44 GHz (2 processors)|	Intel Xeon CPU E5-2690 v4|	AMD EPYC 7V12, 64-core processor, 2.44 GHz|	Intel Xeon CPU E5-2690 v4|

Three models were used for testing, as shown in the following sections. 

### Results for the magnetron sputter model

:::image type="content" source="media/samadii-plasma/magnetron-sputter.png" alt-text="Screenshot that shows the magnetron sputter model." :::

The following table shows the elapsed runtimes and relative speed increases for the four VMs.

|VM |	Elapsed time, in seconds	|Relative speed increase|
|-|-|-|
|NVv3|	12,825.36|	1.00|
|NC4as_T4_v3	|7,606.59|	1.69|
|NCv3	|2,798.55|	4.58|
|ND_A100_v4	|1,977|	6.49|

This graph shows the relative speed increases: 

:::image type="content" source="media/samadii-plasma/graph-magnetron-sputter.png" alt-text="Graph that shows the relative speed increases for the magnetron sputter model." border="false":::

### Results for the import inlet model

:::image type="content" source="media/samadii-plasma/import-inlet.png" alt-text="Screenshot that shows the import inlet model." :::

The following table shows the elapsed runtimes and relative speed increases for the four VMs.

|VM |	Elapsed time, in seconds	|Relative speed increase|
|-|-|-|
|NVv3|248.99| 1.00|
|NC4as_T4_v3	|159.61|1.56|
|NCv3	|141.59|1.76|
|ND_A100_v4	|112|2.22|

This graph shows the relative speed increases: 

:::image type="content" source="media/samadii-plasma/graph-import-inlet.png" alt-text="Graph that shows the relative speed increases for the import inlet model." border="false":::

### Results for the sputtering target model

:::image type="content" source="media/samadii-plasma/sputtering-target.png" alt-text="Screenshot that shows the sputtering target model.":::

The following table shows the elapsed runtimes and relative speed increases for the four VMs.

|VM |	Elapsed time, in seconds	|Relative speed increase|
|-|-|-|
|NVv3|13.82| 1.00|
|NC4as_T4_v3	|8.46|1.63|
|NCv3	|6.86|2.01|
|ND_A100_v4	|5.9|2.34|

This graph shows the relative speed increases: 

:::image type="content" source="media/samadii-plasma/graph-sputtering-target.png" alt-text="Graph that shows the relative speed increases for the sputtering target model." border="false":::

## Azure cost
<Description of the costs that might be associated with running this workload in Azure. Make sure to have a link to the Azure pricing calculator.>
You can use the Azure pricing calculator, to estimate the costs for your configuration.
<Show the pricing calculation or a direct link to this specific workload with the configuration(s) used.>
Summary
<One or two sentences or bullet points reinforcing why Azure is the right platform for this workload>

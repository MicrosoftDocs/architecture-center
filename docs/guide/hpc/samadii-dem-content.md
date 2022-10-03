<Intro should cover a basic overview of the workload.>

## Why deploy Samadii DEM on Azure?

- Modern and diverse compute options to align to your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Good scale and cost efficiency on NCasT4_v3-series VMs  

## Architecture

:::image type="content" source="media/samadii-dem/architecture.png" alt-text="Diagram that shows an architecture for deploying Samadii DEM." lightbox="media/samadii-dem/architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/samadii-dem.vsdx) of this
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

Performance tests of Samadii DEM on Azure used [NVv3](/azure/virtual-machines/nvv3-series), [NC4as_T4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) series VMs running Windows 10. The following table provides details about the VMs.

|VM size|vCPU|Memory, in GiB|Maximum data disks|	GPU|GPU memory, in GiB|Maximum uncached disk throughput, in IOPS / MBps|Temporary storage (SSD), in GiB|Maximum NICs|
|-|-|-|-|-|-|-|-|-|
|Standard_ND96asr_v4|	96	|900|	32|	8|	40|	80,000 / 800|	6,000|	8|
|Standard_NC6s_v3	|6	|112	|12|	1	|16	|20,000 / 200	|736	|4|
|Standard_NC12s_v3	|12	|224	|24|	2|	32|	40,000 / 400|	1,474|	8|
|Standard_NC4as_T4_v3|	4|	28	|8	|1	|16	|-|	180|	2|
|Standard_NC64as_T4_v3|	64|	440|	32|	4|	64	|-|	2880|	8|
|Standard_NV12s_v3	|12	|112|	12|	1|	112	|20,000/200	|320|	4|
|Standard_NV24s_v3	|24	|224|	24|	2|	224	|40,000/400|	640	|8|

### Required drivers

To take advantage of the GPU capabilities of [NVv3](/azure/virtual-machines/nvv3-series), [NC4as_T4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) series VMs, you need to install NVIDIA GPU drivers.

To use AMD processors on [NC4as_T4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series) and [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) series VMs, you need to install AMD drivers.

## Samadii DEM installation

Before you install Samadii DEM, you need to deploy and connect a VM, install an eligible Windows 10 image, and install the required NVIDIA and AMD drivers.

For information about eligible Windows images, see [How to deploy Windows 10 on Azure](/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment) and [Use Windows client in Azure for dev/test scenarios](/azure/virtual-machines/windows/client-images).

For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

Install a license server, install Samadii DEM, configure the license server. 

<Must include a sentence or two to outline the installation context along with link/s (no internal links, it must be official/accessible) to install information of the product docs for the workload solution.  >

## Samadii DEM performance results
<Give a short intro to how performance was tested>
<Results for X>
<Results for Y etc>

### Additional notes about tests
<Include any additional notes about the testing process used.>

## Azure cost
<Description of the costs that might be associated with running this workload in Azure. Make sure to have a link to the Azure pricing calculator.>
You can use the Azure pricing calculator, to estimate the costs for your configuration.
<Show the pricing calculation or a direct link to this specific workload with the configuration(s) used.  >

## Summary

## Contributors
## Next steps
## Related resources 

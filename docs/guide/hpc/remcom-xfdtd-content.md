<Intro should cover a basic overview of the workload.>

## Why deploy Remcom XFdtd on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Fast compute capabilities for GPU-intensive workloads

## Architecture

:::image type="content" source="media/remcom-xfdtd/architecture.png" alt-text="Diagram that shows an architecture for deploying Remcom XFdtd." lightbox="media/remcom-xtdtd/architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/remcom-xfdtd.vsdx) of this
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

The performance tests of Remcom XFdtd used an [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VM running Windows 10. The following table provides details about the VM.

|VM size|vCPU|Memory, in GiB|Temporary storage (SSD), in GiB|	GPUs	|GPU memory, in GiB|Maximum data disks|
|-|-|-|-|-|-|-|
|Standard_ND96asr_v4	|96	|900	|6,000	|8 A100	|40	|32|

## Required drivers

<Information about any specialized drivers required for the recommended sizes. List the specific size and link it to the appropriate page in the VM sizes documentation – for example: https://docs.microsoft.com/azure/virtual-machines/nda100-v4-series>

## Remcom XFdtd installation

Before you install Remcom XFdtd, you need to deploy and connect a VM and install the required NVIDIA and AMD drivers. 

> [!IMPORTANT]
>  NVIDIA Fabric Manager installation is required for VMs that use NVLink or NVSwitch. ND_A100_v4 VMs use NVLink. 

For information about deploying the VM and installing the drivers, see one of these articles:
•	Run a Windows VM on Azure
•	Run a Linux VM on Azure

<Must include a sentence or two to outline the installation context along with link/s (no internal links, it must be official/accessible) to install information of the product docs for the workload solution.>
<Should not list any ordered steps of installation.> 
<Workload> performance results
<Give a short intro to how performance was tested>
<Results for X>
<Results for Y etc>

Additional notes about tests
<Include any additional notes about the testing process used.>
Azure cost
<Description of the costs that might be associated with running this workload in Azure. Make sure to have a link to the Azure pricing calculator.>
You can use the Azure pricing calculator, to estimate the costs for your configuration.
<Show the pricing calculation or a direct link to this specific workload with the configuration(s) used.>
Summary
<One or two sentences or bullet points reinforcing why Azure is the right platform for this workload>

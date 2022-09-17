<Intro>

## Why deploy Siemens NX on Azure?

- Modern and diverse compute options to align to your workload's needs 
- The flexibility of virtualization without the need to buy and maintain physical hardware 
- Rapid provisioning 
- All ATS and Cert test cases run successfully

## Architecture

:::image type="content" source="media/siemens-nx/siemens-nx.png" alt-text="Diagram that shows an architecture for deploying Siemens NX." lightbox="media/siemens-nx/siemens-nx.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/siemens-nx.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Windows VM. 
  - For information about deploying the VM and installing the drivers, see [Windows VMs on Azure](../../reference-architectures/n-tier/windows-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud. 
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  -  A public IP address connects the internet to the VM.
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

Performance tests of NX on Azure used [NVv3](/azure/virtual-machines/nvv3-series) and [NCasT4_v3](/azure/virtual-machines/nct4-v3-series) series VMs running Windows. The following table provides the configuration details.

|VM size|vCPU|Memory, in GiB|SSD, in GiB|Number of GPUs|GPU memory, in GiB|Maximum data disks|
|-|-|-|-|-|-|-|
|Standard_NV12s_v3 |12|112|320|1|8|12|
|Standard_NV24s_v3 |24|224|640|2|16|24|
|Standard_NC16as_T4_v3|16|110|360|1|16|32|

### Required drivers

To take advantage of the GPU capabilities of [NVv3](/azure/virtual-machines/nvv3-series) and [NCasT4_v3](/azure/virtual-machines/nct4-v3-series) series VMs, you need to install the NVIDIA GPU drivers.

To use CPUs on [NCasT4_v3](/azure/virtual-machines/nct4-v3-series), you need to install the AMD drivers.

## NX installation

Before you install NX, you need to deploy and connect a VM, install an eligible Windows 10 or Windows 11 image, and install the required NVIDIA and AMD drivers.

For information about eligible Windows images, see [How to deploy Windows 10 on Azure](/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment) and [Use Windows client in Azure for dev/test scenarios](/azure/virtual-machines/windows/client-images).

For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

After you install the drivers, install license server and the NX application.

<Must include a sentence or two to outline the installation context along with link/s (no internal links, it must be official/accessible) to install information of the product docs for the workload solution.>
<Should not list any ordered steps of installation.> 

<Workload> performance results
<Give a short intro to how performance was tested>

<Results for X>

<Results for Y etc>

Additional notes about tests
<Include any additional notes about the testing process used.>

## Azure cost
<Description of the costs that might be associated with running this workload in Azure. Make sure to have a link to the Azure pricing calculator.>
You can use the Azure pricing calculator, to estimate the costs for your configuration.
<Show the pricing calculation or a direct link to this specific workload with the configuration(s) used.>

## Summary

- NX Application is successfully deployed and tested on NV_v3 & NCas_T4 series Azure Virtual Machines.
- All test cases (both ATS and Cert) are successfully run on 1GPU VM (Standard_NV12s_v3), 2GPU VM (Standard_NV24s_v3) and 1GPU VM (Standard_NC16as_T4_v3) configurations.
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

To take advantage of the GPU capabilities of [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VMs, you need to install NVIDIA GPU drivers.

To use AMD processors on [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VMs, you need to install AMD drivers.

## Remcom XFdtd installation

Before you install Remcom XFdtd, you need to deploy and connect a VM, install an eligible Windows 10 image, and install the required NVIDIA and AMD drivers. 

For information about eligible Windows images, see [How to deploy Windows 10 on Azure](/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment) and [Use Windows client in Azure for dev/test scenarios](/azure/virtual-machines/windows/client-images).

> [!IMPORTANT]
>  NVIDIA Fabric Manager installation is required for VMs that use NVLink or NVSwitch. ND_A100_v4 VMs use NVLink. 

For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

Before you install XFdtd, you need to install a floating license server. For detailed instructions on [installing XFdtd](https://support.remcom.com/xfdtd/installation/xfdtd-installation.php), [installing the license server](https://support.remcom.com/xfdtd/installation/floating-license.php), [setting up an MPI cluster](https://support.remcom.com/xfdtd/installation/mpi-cluster-setup.php), and more, see the [installation manual](https://support.remcom.com/xfdtd/installation.html).

## Remcom XFdtd performance results

Remcom XFdtd 7.10.0.1 was tested. A patch in body model was used for the tests: 

:::image type="content" source="media/remcom-xfdtd/patch-body-model.png" alt-text="Screenshot that shows the patch in body model." border="false":::

The following table provides details about the model.

|Model name|Frequency range of interest|Minimum cells per wavelength|Frequency of interest|Minimum cell size|
|-|-|-|-|-|
|Patch in body|0 GHz to 10 GHz|15|2.45 GHz|0.735 mm|

Throughput is used as a metric to test the performance of the simulation. The following table.. 

|Number of GPUs|	Simulation timesteps (ts)|Total cells|Ts time (s)|Ts/s|(throughput) (cells/sec)|C (throughput) (gcells/sec)|
|-|-|-|-|-|-|-|
|1	|39141	|1077552576	|3003	|13.03	|14044783675	|14.04|
|4|	39141|	1077552576|	954|	41.03|	44210152387|	44.21|
|8|	39141	|1077552576|	834	|46.93|	50571325392	|50.57|

<Results for X>
<Results for Y etc>

### Additional notes about tests

## Azure cost

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

## Summary


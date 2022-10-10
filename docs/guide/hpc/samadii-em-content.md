<Intro should cover a basic overview of the workload.>

## Why deploy Samadii EM on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- VM options that enable you to optimize for varying levels of simulation complexity  

## Architecture

:::image type="content" source="media/samadii-em/architecture.png" alt-text="Diagram that shows an architecture for deploying Samadii EM." lightbox="media/samadii-em/architecture.png" border="false":::

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

### Required drivers

To take advantage of the GPU capabilities of [NVadsA10](/azure/virtual-machines/nva10v5-series), [NCasT4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), and [NC_A100_v4](/azure/virtual-machines/nc-a100-v4-series) VMs, you need to install NVIDIA GPU drivers.

To use AMD processors on [NVadsA10](/azure/virtual-machines/nva10v5-series), [NCasT4_v3](/azure/virtual-machines/nct4-v3-series), and [NC_A100_v4](/azure/virtual-machines/nc-a100-v4-series) VMs, you need to install AMD drivers.

## Samadii EM installation

Before you install Samadii EM, you need to deploy and connect a VM, install an eligible Windows 10 image, and install the required NVIDIA and AMD drivers.

For information about eligible Windows images, see [How to deploy Windows 10 on Azure](/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment) and [Use Windows client in Azure for dev/test scenarios](/azure/virtual-machines/windows/client-images).

For information about deploying the VM and installing the drivers, see one [Run a Windows VM on Azure]().

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

## Summary

- Samadii EM was successfully tested on NCv3, NCas_T4_v3, and NVadsA10_v5 VMs.
- From the Performance Benchmarking results, considering the elapsed time as benchmarking parameter it can be observed that for smaller models (lesser complexity) all the configurations of NCv4 and NVv5 VM (including partial usage of GPU’s) are performing better in comparison with NCasT4 NCv3 for Samadii-EM application
- For models with increased complexity considering the elapsed time as benchmarking parameter, NCv4, NCv3, NCasT4, NVv5 (full GPU) VM’s are performing better than the NVv5 (partial usage of GPU’s)
- Considering the Azure cost as the criteria for performance evaluation NCasT4 VM’s shows better performance in comparison with other VM’s

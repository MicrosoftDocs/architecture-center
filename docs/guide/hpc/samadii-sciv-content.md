<Intro should cover a basic overview of the workload.>

## Why deploy Samadii SCIV on Azure?

- Modern and diverse compute options to align to your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Good performance scale-up, with configurations that provide optimized scaling or optimized cost efficiency

## Architecture

:::image type="content" source="media/samadii-sciv/architecture.png" alt-text="Diagram that shows an architecture for deploying Samadii SCIV." lightbox="media/samadii-sciv/architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/samadii-sciv.vsdx) of this
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

Performance tests of Samadii SCIV on Azure used [NVv3](/azure/virtual-machines/nvv3-series), [NCas_T4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), and [ND_A100_v4](/azure/virtual-machines/nda100-v4-series) VMs running Windows 10. The following table provides details about the VMs.

### Required drivers

<Information about any specialized drivers required for the recommended sizes. List the specific size and link it to the appropriate page in the VM sizes documentation – for example: https://docs.microsoft.com/azure/virtual-machines/nda100-v4-series>
<Workload> installation
Before you install <Workload>, you need to deploy and connect a VM and install the required NVIDIA and AMD drivers.
 Important – if needed
<if needed – for example: NVIDIA Fabric Manager installation is required for VMs that use NVLink or NVSwitch.>
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

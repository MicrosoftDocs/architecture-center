This article briefly describes the steps for running [Altair ultraFluidX](https://www.altair.com/altair-cfd-capabilities) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running ultraFluidX on Azure.

Altair ultraFluidX is a simulation tool for predicting the aerodynamic properties of passenger and heavy-duty vehicles, and for the evaluation of building and environmental aerodynamics. Altair ultraFluidX:

- Is based on Lattice Boltzmann methods (LBM).
- Is optimized for GPUs and supports CUDA-aware MPI for multi-GPU usage.
- Provides an LBM-consistent Smagorinsky LES turbulence model, TBLE-based wall modeling, and porous media model (pressure drop) for simulation of multiple heat exchangers.
- Handles rotating geometries via wall-velocity boundary conditions, a Moving Reference Frame (MRF) model, and truly rotating overset grids (OSM).
- Provides automated volume mesh generation with low surface mesh requirements, local grid refinement, and support for intersecting/baffle parts.
 
Altair ultraFluidX is used in the automotive, building, and environmental industry sectors.

## Why deploy ultraFluidX on Azure?

- Modern and diverse compute options to align with your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Complex problems solved within a few hours

## Architecture

:::image type="content" source="media/ultrafluidx/hpc-ultrafluidx.png" alt-text="Diagram that shows an architecture for deploying Altair ultraFluidX." lightbox="media/ultrafluidx/hpc-ultrafluidx.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/hpc-ultrafluidx.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Linux VM. 
  - For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud. 
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  -  A public IP address connects the internet to the VM.
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

Performance tests of ultraFluidX on Azure used [ND A100 v4 series VMs](/azure/virtual-machines/nda100-v4-series) running Linux. The following table provides the configuration details.

|VM size|vCPU|Memory, in GiB|SSD, in GiB|GPUs|GPU memory, in GiB|Maximum data disks|
|-|-|-|-|-|-|-|
|Standard_ND96asr_v4|96|900|6,000|8 A100|40|32|

### Required drivers

To use ultraFluidX on Standard_ND96asr_v4 VMs as described in this article, you need to install NVIDIA and AMD drivers.

## ultraFluidX installation

Before you install ultraFluidX, you need to deploy and connect a Linux VM and install the required NVIDIA and AMD drivers.

> [!IMPORTANT]
> NVIDIA Fabric Manager installation is required for VMs that use NVLink or NVSwitch. Standard_ND96asr_v4 uses NVLink.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

Altair ultraFluidX only runs on Linux. You can download ultraFluidX from [Altair One Marketplace](https://altairone.com/Marketplace?__hstc=142694250.005b507352b9e4107a39c334591c181a.1662053255169.1663267860104.1663279870680.17&__hssc=142694250.2.1663279870680&__hsfp=4046309035&queryText=ultrafluidx&app=ultraFluidX&tab=Info). You also need to install Altair License Manager and activate your license via Altair Units Licensing. For more information, see the Altair Units Licensing document on [Altair One Marketplace](https://altairone.com/Marketplace?__hstc=142694250.005b507352b9e4107a39c334591c181a.1662053255169.1663267860104.1663279870680.17&__hssc=142694250.2.1663279870680&__hsfp=4046309035&queryText=ultrafluidx&app=ultraFluidX&tab=Info).

## ultraFluidX performance results

GPU-based fluid dynamics simulations were run to test ultraFluidX. 

Roadster and CX1

The simulations were run for shortened test cases, not for full production-level test cases. The projected wall-clock times and computation times for a full production run of the CX1 with 3 s of physical time are provided here. Due to the constant workload per time step, these can be easily computed from the computation time of the short run via linear extrapolation.

<Results for X>
<Results for Y etc>

### Additional notes about tests

## Azure cost
<Description of the costs that might be associated with running this workload in Azure. Make sure to have a link to the Azure pricing calculator.>

You can use the [Azure pricing calculator] to estimate the costs for your configuration.

<Show the pricing calculation or a direct link to this specific workload with the configuration(s) used.>

## Summary

## Contributors

## Next steps

## Related resources
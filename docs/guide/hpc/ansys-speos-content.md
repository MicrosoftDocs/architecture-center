This article briefly describes the steps for running [Ansys Speos](https://www.ansys.com/products/optics/ansys-speos) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running Ansys Speos on Azure.

Ansys Speos is a high-precision simulation tool for optical systems based on human visual perception. Integrated into virtual product development, Ansys Speos can realistically simulate the real-life individual user experience for improved and even more precise optimization of the product design.

Ansys Speos delivers an intuitive and comprehensive user interface, enhanced productivity with use of GPUs for simulation previews and easy access to the Ansys ecosystem. Ansys Speos offers a wide range of advanced innovative tools for Aerospace, Automotive, Healthcare, Energy and Defense engineering disciplines.

## Why deploy Ansys Speos on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Complex simulations with varying level of complexity can be solved by adding a greater number of GPUs

















## Architecture

:::image type="content" source="media/ansys-speos/ansys-speos-architecture.svg" alt-text="Diagram that shows an architecture for deploying Ansys Speos." lightbox="media/ansys-speos/ansys-speos-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/ansys-speos.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Windows VM. For information about deploying the VM and installing the drivers, see [Run a Windows VMs on Azure](../../reference-architectures/n-tier/windows-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network/) is
    used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  - A public IP address connects the internet to the VM.
- [Azure Disk Storage](https://azure.microsoft.com/products/storage/disks) provides a physical solid-state drive (SSD) for storage.

## Compute sizing and drivers

The following table provides the configuration details of [NVadsA10 v5-series](/azure/virtual-machines/nva10v5-series) VM:

|VM size|vCPU|Memory, in GiB| Temp storage (SSD) GiB | GPU partition | GPU memory, in GiB|Maximum data disks | Maximum uncached disk throughput, in IOPS / MBps | Maximum NICs / Expected network bandwidth (Mbps) |
|-|-|-|-|-|-|-|-|-|
|Standard_NV6ads_A10_v5|6|55|180 |1/6|4|4|6,400 / 100|2 / 5,000|
|Standard_NV12ads_A10_v5|12|110|360|1/3|8|4|12,800 / 200|2 / 10,000|
|Standard_NV18ads_A10_v5|18|220|720|1/2|12|8|25,600 / 384|4 / 20,000|
|Standard_NV36ads_A10_v5|36|440|1440|1|24|16|51,200 / 768|4 / 40,000|
|Standard_NV72ads_A10_v5|72|880|2880|2|48|32|80,000 / 1,200|8 / 80,000|

The following table provides the configuration details of [NCasT4_v3-series](/azure/virtual-machines/nct4-v3-series) VM:

|VM size|vCPU|Memory, in GiB| Temp storage (SSD) GiB | GPU partition | GPU memory, in GiB|Maximum data disks | Maximum NICs / Expected network bandwidth (Mbps) |
|-|-|-|-|-|-|-|-|
|Standard_NC4as_T4_v3|4|28|180 |1|16|8|2 / 8,000|
|Standard_NC64as_T4_v3|64|440|2880|4|64|32|8 / 32,000|

The following table provides the configuration details of [NC A100 v4-series](/azure/virtual-machines/nc-a100-v4-series) VM:

|VM size|vCPU|Memory, in GiB| Temp storage (SSD) GiB | NVMe Disks | GPU partition | GPU memory, in GiB|Maximum data disks | Maximum uncached disk throughput, in IOPS / MBps | Maximum NICs / Expected network bandwidth (Mbps) |
|-|-|-|-|-|-|-|-|-|-|
|Standard_NC24ads_A100_v4|24|220|64|960 GB|1|80|12|30,000 / 1,000|2 / 20,000|
|Standard_NC48ads_A100_v4|48|440|128|2x960 GB|2|160|24|60,000 / 2,000|4 / 40,000|
|Standard_NC96ads_A100_v4|96|880|256|4x960 GB|4|320|32|120,000 / 4,000|8 / 80,000|

The following table provides the configuration details of [NDm A100 v4-series](/azure/virtual-machines/ndm-a100-v4-series) VM:

|VM size|vCPU|Memory, in GiB| Temp storage (SSD) GiB | GPU | GPU memory, in GiB|Maximum data disks | Maximum uncached disk throughput, in IOPS / MBps | Maximum network bandwidth | Maximum NICs |
|-|-|-|-|-|-|-|-|-|-|
|Standard_ND96amsr_A100_v4|96|1900|6400|8 A100 80 GB GPUs (NVLink 3.0)|80|32|80,000 / 800|24,000 Mbps|8|

## Ansys Speos installation

- **Deploy Azure VMs**. Use NVadsA10v5-series, NCasT4_v3 series, NC A100 v4 series and NDm A100 v4-series VMs to run Ansys Speos.
- **Create and configure the supporting infrastructure**. Configure a public IP address for inbound connectivity. Use network security groups to provide security for the subnet.
- **Install NVIDIA drivers**. To take advantage of the GPU capabilities of NVadsA10v5-series, NCasT4_v3 series, NC A100 v4 series and NDm A100 v4-series VMs, install NVIDIA GPU drivers. You need to deploy and connect a VM via Remote Desktop Protocol (RDP) to install the required NVIDIA drivers. For information about deploying VMs and installing the drivers, see [Run a Windows VM on Azure](/azure/virtual-machines/windows/n-series-driver-setup).
- **Install Ansys Speos**. You can install Ansys Speos from the [Ansys portal](https://www.ansys.com/). For information about the installation process, see the [Ansys Speos website](https://www.ansys.com/products/optics/ansys-speos).

## Ansys Speos performance results

A set of test case models are considered for testing the performance of Ansys Speos on Azure NVadsA10v5-series, NCasT4_v3 series, NC A100 v4 series and NDm A100 v4-series VMs. The model details are shown below.

| Model | Model description | Analysis Type | Wavelength range | Wavelength number | Resolution |
|-|-|-|-|-|-|
| ![Image of Bottle Direct model.](./media/ansys-speos/bottle-direct.png) **Bottle Direct**| The model image shows a perfume bottle, Tangent transparent bodies, and caustics | Speos Core Direct Monte-Carlo Hybrid Simulation | 400nm – 700nm | 13 | 2048 x 2048 |
| ![Image of Bottle Inverse model.](./media/ansys-speos/bottle-inverse.png) **Bottle Inverse** | The model image shows a perfume bottle, Tangent transparent bodies | Speos Core Inverse Monte Carlo Hybrid Simulation | 400nm – 700nm | 13 | 2048 x 2048 |
| ![Image of FOG-Nightlight Direct model.](./media/ansys-speos/fog-nightlight-direct.png) **FOG-Nightlight Direct** | The model image shows road lighting, Volume scattering fog gathered towards sensor | Speos Core Direct Monte-Carlo Hybrid simulation | 400nm – 700nm | 13 | 1280 x 960 |
| ![Image of FOG-Nightlight Radiance model.](./media/ansys-speos/fog-nightlight-radiance.png) **FOG-Nightlight Radiance** | The model image shows road lighting, Volume scattering fog gathered towards source | Speos Core Inverse Monte-Carlo Hybrid simulation | 400nm – 700nm | 13 | 1280 x 960 |
| ![Image of RearLamp Demo Direct model.](./media/ansys-speos/rearlamp-demo-direct.png) **RearLamp Demo Direct** | The model image shows automotive lightings, facetted mirrors, stripped lightguide, volume scattering diffusors | Speos Core Direct Monte-Carlo Hybrid simulation | 400nm – 700nm | 13 | 1920 x 1080 |
| ![Image of RearLamp Demo Inverse model.](./media/ansys-speos/rearlamp-demo-inverse.png) **RearLamp Demo Inverse** | The model image shows automotive lightings, facetted mirrors, stripped lightguide, volume scattering diffusors | Speos Core Inverse Monte-Carlo Hybrid simulation | 400nm – 700nm | 13 | 1920 x 1080 |
| ![Image of Tunnel 4K Camera Timeline_single model.](./media/ansys-speos/tunnel-4k-camera.png) **Tunnel 4K Camera Timeline_single** | The model image shows tunnel exit, indirect lighting with strong dynamics, spectral physical camera sensor | Speos Core Inverse Monte-Carlo Hybrid simulation | 400nm – 700nm | 13 | 3856 x 2176 |

### Results for NVadsA10v5-series VM

The performance tests on Ansys Speos 2023 R2 used NVadsA10v5-series VMs. The following table provides the operating system and GPU details of NVadsA10v5-series VM. Each cell in the table shows the **Number of Rays (Computation time)** / **Relative Speed Increase** for each of the models.

| Size | Number of vCPUs/ GPUs  used | Bottle Direct | Bottle Inverse | FOG-NightLight Direct | FOG-NightLight_Radiance | Rearlamp Demo Direct | Rearlamp Demo Inverse | Tunnel 4K Camera Timeline_single |
|-|-|-|-|-|-|-|-|-|
| Standard_NV6ads_A10_v5 | 6 vCPUs | 5.35789E+05 / 1.00 | 4.75517E+05 / 1.00 | 2.15933E+04 / 1.00 | 1.06543E+04 / 1.00 | 4.45442E+04 / 1.00 | 2.16231E+05 / 1.00 | 2.03505E+05 / 1.00 |
| XXXXX | XXXXX | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx |
| XXXXX | XXXXX | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx |
| XXXXX | XXXXX | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx |
| XXXXX | XXXXX | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx |
| XXXXX | XXXXX | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx |
| XXXXX | XXXXX | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx |
| XXXXX | XXXXX | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx | xxx / xxx |







The following table shows relative speed increase on NVadsA10v5-series VM:

| XXXXX | XXXXX | XXXXX | XXXXX | XXXXX | XXXXX |
|-|-|-|-|-|-|
| XXXXX | XXXXX | XXXXX | XXXXX | XXXXX | XXXXX |
| XXXXX | XXXXX | XXXXX | XXXXX | XXXXX | XXXXX |
| XXXXX | XXXXX | XXXXX | XXXXX | XXXXX | XXXXX |
| XXXXX | XXXXX | XXXXX | XXXXX | XXXXX | XXXXX |
| XXXXX | XXXXX | XXXXX | XXXXX | XXXXX | XXXXX |
| XXXXX | XXXXX | XXXXX | XXXXX | XXXXX | XXXXX |
| XXXXX | XXXXX | XXXXX | XXXXX | XXXXX | XXXXX |

| Size                   | No. of vCPUs/GPUs | Used          | Bottle Direct | Bottle Inverse | FOG-NightLight Direct | FOG-NightLight_Radiance | Rearlamp Demo Direct | Rearlamp Demo Inverse | Tunnel 4K Camera Timeline_single |
|------------------------|-------------------|---------------|---------------|----------------|-----------------------|-------------------------|----------------------|-----------------------|---------------------------------|
|                        | No of Rays/Computation time | Relative Speed Increase | No of Rays/Computation time | Relative Speed Increase | No of Rays/Computation time | Relative Speed Increase | No of Rays/Computation time | Relative Speed Increase | No of Rays/Computation time | Relative Speed Increase |
|------------------------|-------------------|---------------|---------------|----------------|-----------------------|-------------------------|----------------------|-----------------------|---------------------------------|
| Standard_NV6ads_A10_v5 | 6 vCPUs           | 5.35789E+05   | 1.00          | 4.75517E+05   | 1.00                  | 2.15933E+04             | 1.00                 | 1.06543E+04          | 1.00                  | 4.45442E+04                     | 1.00                 | 2.16231E+05                     | 1.00                 | 2.03505E+05                     | 1.00                 |
| Standard_NV12ads_A10_v5 | 1/3 GPU           | 7.05502E+06   | 13.17         | 6.33147E+06   | 13.31                | 1.38082E+05             | 6.39                 | 4.32866E+04          | 4.06                  | 2.15824E+05                     | 4.85                 | 3.93593E+05                     | 1.82                 | 9.72960E+05                     | 4.78                 |
| Standard_NV18ads_A10_v5 | 1/2 GPU           | 1.11367E+07   | 20.79         | 9.72984E+06   | 20.46                | 2.13309E+05             | 9.88                 | 6.95355E+04          | 6.53                  | 3.44093E+05                     | 7.72                 | 6.02317E+05                     | 2.79                 | 1.52759E+06                     | 7.51                 |
| Standard_NV36ads_A10_v5 | 1 GPU             | 2.38216E+07   | 44.46         | 2.10233E+07   | 44.21                | 4.42797E+05             | 20.51                | 1.32615E+05          | 12.45                 | 7.38095E+05                     | 16.57                | 1.40697E+06                     | 6.51                 | 3.26173E+06                     | 16.03                |
| Standard_NV72ads_A10_v5 | 2 GPUs            | 4.90611E+07   | 91.57         | 4.15515E+07   | 87.38                | 9.00568E+05             | 41.71                | 2.32190E+05          | 21.79                 | 1.48949E+06                     | 33.44                | 2.81894E+06                     | 13.04                | 6.37847E+06                     | 31.34                |


























A combine harvester simulation was used for the performance tests: 

:::image type="content" source="media/ansys-rocky/combine.png" alt-text="Screenshot that shows the combine harvester model."  :::


- **Total number of particles:** 110,827
- **Simulation duration:** 1 second

DEM particle simulation was used to test the application's performance.  Two versions of Ansys Speos were tested: 2021 R2.2 and 2022 R1.1. 

The following table presents the wall-clock times for running the simulation, for both CPU and GPU configurations.

|Rocky version |VM series| 96 CPUs |1 GPU |2 GPUs| 3 GPUs| 4 GPUs|
|-|-|-|-|-|-|-|
|2021 R2.2| ND_A100_v4| 10:57:58| 00:53:24<sup>1| 00:44:30<sup>1| 00:40:42<sup>1 |00:46:01<sup>1|
|2022 R1.1| ND_A100_v4| - |00:44:41<sup>1| 00:37:47<sup>1| 00:39:40<sup>1| 00:42:29<sup>1|
|2022 R1.1| NC_A100_v4| - |00:40:19| 00:32:11| 00:30:55<sup>2| 00:32:42|

<sup>1</sup> *In these cases, the number of GPUs was artificially limited. This VM has eight GPUs.*

<sup>2</sup> *In this case, the number of GPUs was artificially limited. This VM is available with one, two, or four GPUs.*

The following table shows the relative speed increases as the CPUs are replaced by GPUs in increasing numbers. The 96-CPU configuration in the preceding table is used as the baseline for the comparisons.

|Rocky version |VM series| 96 CPUs |1 GPU |2 GPUs| 3 GPUs| 4 GPUs|
|-|-|-|-|-|-|-|
|2021 R2.2| ND_A100_v4| 1.00|12.32<sup>1|14.79<sup>1|16.17<sup>1|14.30<sup>1|
|2022 R1.1| ND_A100_v4| 1.00 |14.73<sup>1 |17.41<sup>1 |16.59<sup>1 |15.49<sup>1|
|2022 R1.1| NC_A100_v4| 1.00 |16.32 |20.45|21.29<sup>2 |20.12|

<sup>1</sup> *In these cases, the number of GPUs was artificially limited. This VM has eight GPUs.*

<sup>2</sup> *In this case, the number of GPUs was artificially limited. This VM is available with one, two, or four GPUs.*

Here's the same data, presented graphically:

:::image type="content" source="media/ansys-rocky/rocky-graph.png" alt-text="Graph that shows the relative speed increases." border="false" :::

*In the preceding graph, 0 GPUs indicates that the simulation was run with only CPUs.*

## Azure cost

The following table presents wall-clock times that you can use to calculate Azure costs. You can multiply the times presented here by the Azure hourly rates for NCA100v4-series VMs to calculate costs. For the current hourly costs, see [Windows Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing). 

Only the wall-clock times for running the model are presented in this table. Application installation time isn't included. These times are indicative. The actual times depend on the size of the model.

The wall-clock times for a full production-level simulation of the combine harvester model are longer than the times presented here, so the associated costs are higher.

The times here represent tests performed on Ansys Speos 2022 R1.1.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

|VM size| Number of GPUs| Elapsed time, in hours|
|-|-|-|
|Standard_NC24ads_A100_v4 | 1| 0.67|
|Standard_NC48ads_A100_v4 | 2| 0.53|
|Standard_NC96ads_A100_v4 | 4 |0.54|

## Summary

- Ansys Speos was successfully tested on ND_A100_v4 and NC_A100_v4 VMs on Azure.
- The speed increases significantly when you upgrade from 96 CPUs to one GPU.
- For all models, there's an optimal configuration that achieves the best combination of price and performance. After that point, adding hardware doesn't scale the performance substantially. For this particular harvester model, optimal performance occurs with three GPUs. For more complex models, we expect the optimal number of GPUs to be higher. For models that are less complex, we expect it to be lower.

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

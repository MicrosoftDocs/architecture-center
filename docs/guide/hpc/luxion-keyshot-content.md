This article briefly describes the steps for running [Luxion KeyShot](https://www.keyshot.com) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running KeyShot on Azure.

KeyShot is a standalone, real-time ray tracing and global illumination program that's used to create 3D renderings, animations, and interactive visuals. It uses photon mapping, an extension of ray tracing, which makes simulation of global illumination in complex scenes more efficient. KeyShot has the following capabilities:

- 3D-paint enabled, so users can directly paint or stamp bump textures, colors, roughness, specularity, refractivity, and opacity.
- Provides physics simulation that allows users to record the physics of an object and apply it as a keyframe animation.
- Allows control over gravity, friction, and bounciness and the ability to adjust the time, quality, and keyframes per second.
 
KeyShot customers include product and industrial designers, vehicle design companies, jewelers, and architects. It's ideal for the automotive and manufacturing industries.

## Why deploy KeyShot on Azure?

- Modern and diverse compute options to align to your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Fast compute capabilities for GPU-intensive workloads

## Architecture

:::image type="content" source="media/keyshot/architecture.png" alt-text="Diagram that shows an architecture for deploying KeyShot." lightbox="media/keyshot/architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/keyshot.vsdx) of this
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

Performance tests of KeyShot on Azure used [NVadsA10_v5](/azure/virtual-machines/nva10v5-series) and [NC4as_T4_v3](/azure/virtual-machines/nct4-v3-series) series VMs running Windows. KeyShot 11 was used in these tests. The following table provides details about the VMs.

|VM size|vCPU|Memory (GiB)|Temporary storage SSD (GiB)|GPU partition|GPU memory (GiB)|Maximum data disks|
|-|-|-|-|-|-|-|
|Standard_NV12ads_A10_v5|12|110|360|1/3|8|4|
|Standard_NV18ads_A10_v5|18|220|720|1/2|12|8|
|Standard_NV36ads_A10_v5|36|440|720|1|24|16|
|Standard_NV36adms_A10_v5|36|880|720|1|24|32|
|Standard_NV72ads_A10_v5|72|880|1,400|2|48|32|
|Standard_NC64as_T4_v3|64|440|2,880|4|64|32|

### Required drivers

To take advantage of the GPU capabilities of [NVadsA10_v5](/azure/virtual-machines/nva10v5-series) and [NC4as_T4_v3](/azure/virtual-machines/nct4-v3-series) series VMs, you need to install NVIDIA GPU drivers.

To use AMD processors on [NVadsA10_v5](/azure/virtual-machines/nva10v5-series) and [NC4as_T4_v3](/azure/virtual-machines/nct4-v3-series) series VMs, you need to install AMD drivers.

## KeyShot installation

Before you install KeyShot, you need to deploy and connect a VM, install an eligible Windows 10 or Windows 11 image, and install the required NVIDIA and AMD drivers.

For information about eligible Windows images, see [How to deploy Windows 10 on Azure](/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment) and [Use Windows client in Azure for dev/test scenarios](/azure/virtual-machines/windows/client-images).
 
For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

For information about installing KeyShot, see the [KeyShot website](https://manual.keyshot.com/keyshot11/manual/installation).

## KeyShot performance results

Three test case models were used to test the performance of KeyShot on Azure:

**Watch configurator**

:::image type="content" source="media/keyshot/watch.png" alt-text="Figure that shows the watch configurator." border="false":::

Resolution: 3,556 x 2,000 pixels

**Ring configurator**

:::image type="content" source="media/keyshot/ring.png" alt-text="Figure that shows the watch configurator." border="false":::

Resolution: 3,556 x 2,000 pixels

**Door configurator**
 
:::image type="content" source="media/keyshot/door.png" alt-text="Figure that shows the watch configurator." border="false":::

Resolution: 3,556 x 2,000 pixels

### Performance results for NVads_A10_v5 series

The following sections present the performance results for each model. Rendering times are shown in seconds, for three sample sizes. 

#### Watch configurator

|VM size|CPU/GPU| Rendering<br> time, 256|Rendering<br> time, 512|Rendering<br> time, 1024|
|-|-|-|-|-|
|Standard_NV12ads_A10_v5|	12 vCPU|	365|	728|	813|
|Standard_NV12ads_A10_v5|	1/3 GPU	|48.44|	95.89|	191|
|Standard_NV18ads_A10_v5|	1/2 GPU	|29.47|	58.93|	116|
|Standard_NV36ads_A10_v5|	1 GPU	|13.98|	27.97|	55.94|
|Standard_NV36adms_A10_v5|	1 GPU	|12.98|	25.98|	51.95|
|Standard_NV72ads_A10_v5|	2 GPU	|6.99|	13.98|	28.47|

This graph shows the relative speed increases as the CPU/GPU increases:

:::image type="content" source="media/keyshot/watch-nvads.png " alt-text="Graph that shows the relative speed increase for the watch configurator on the NVads_A10 VM." border="false":::


#### Ring configurator

|VM size|CPU/GPU| Rendering<br> time, 256|Rendering<br> time, 512|Rendering<br> time, 1024|
|-|-|-|-|-|
|Standard_NV12ads_A10_v5|	12 vCPU|	1,244|2,445|4,908|
|Standard_NV12ads_A10_v5|	1/3 GPU	|117|234|459|
|Standard_NV18ads_A10_v5|	1/2 GPU	|62.95|125|248|
|Standard_NV36ads_A10_v5|	1 GPU	|27.98|55.94|111|
|Standard_NV36adms_A10_v5|	1 GPU	|24.98|48.94|99.4|
|Standard_NV72ads_A10_v5|	2 GPU	|13.48|26.96|53.45|

This graph shows the relative speed increases as the CPU/GPU increases:

:::image type="content" source="media/keyshot/ring-nvads.png " alt-text="Graph that shows the relative speed increase for the ring configurator on the NVads_A10 VM." border="false":::

#### Door configurator

|VM size|CPU/GPU| Rendering<br> time, 256|Rendering<br> time, 512|Rendering<br> time, 1024|
|-|-|-|-|-|
|Standard_NV12ads_A10_v5|	12 vCPU|	786|1,573|3,223|
|Standard_NV12ads_A10_v5|	1/3 GPU	|188|375|747|
|Standard_NV18ads_A10_v5|	1/2 GPU	|123|247|492|
|Standard_NV36ads_A10_v5|	1 GPU	|54.97|110|220|
|Standard_NV36adms_A10_v5|	1 GPU	|42.45|81.42|162|
|Standard_NV72ads_A10_v5|	2 GPU	|26.97|43.97|87.43|

This graph shows the relative speed increases as the CPU/GPU increases:

:::image type="content" source="media/keyshot/door-nvads.png " alt-text="Graph that shows the relative speed increase for the door configurator on the NVads_A10 VM." border="false":::

### Performance results for NC64as_T4_v3

The following sections present the performance results for each model. Rendering times are in seconds, for three sample sizes. 

#### Watch configurator

|VM size|CPU/GPU| Rendering<br> time, 256|Rendering<br> time, 512|Rendering<br> time, 1024|
|-|-|-|-|-|
|Standard_NC64as_T4_v3|64 vCPU|	66.92	|133|	268|
|Standard_NC64as_T4_v3|1 GPU<sup>1	|32.98|	66.93|	133|
|Standard_NC64as_T4_v3|2 GPU<sup>1	|17.48|	34.48|	68.43|
|Standard_NC64as_T4_v3|3 GPU<sup>1	|12.49|	23.98|	47.95|
|Standard_NC64as_T4_v3|4 GPU	|9.98|	18.96|	37.46|

This graph shows the relative speed increases as the CPU/GPU increases:

:::image type="content" source="media/keyshot/watch-nc64as.png " alt-text="Graph that shows the relative speed increase for the watch configurator on the NC64as_T4 VM." border="false":::

#### Ring configurator

|VM size|CPU/GPU| Rendering<br> time, 256|Rendering<br> time, 512|Rendering<br> time, 1024|
|-|-|-|-|-|
|Standard_NC64as_T4_v3|64 vCPU|	260	|509|	1,008|
|Standard_NC64as_T4_v3|1 GPU<sup>1	|88.91	|169	|334|
|Standard_NC64as_T4_v3|2 GPU<sup>1	|49.95|93.4|180|
|Standard_NC64as_T4_v3|3 GPU<sup>1	|36.48	|66.43|	126|
|Standard_NC64as_T4_v3|4 GPU	|30.96	|54.45|	101|

This graph shows the relative speed increases as the CPU/GPU increases:

:::image type="content" source="media/keyshot/ring-nc64as.png " alt-text="Graph that shows the relative speed increase for the ring configurator on the NC64as_T4 VM." border="false":::

#### Door configurator

|VM size|CPU/GPU| Rendering<br> time, 256|Rendering<br> time, 512|Rendering<br> time, 1024|
|-|-|-|-|-|
|Standard_NC64as_T4_v3|64 vCPU|	139	|273	|547|
|Standard_NC64as_T4_v3|1 GPU<sup>1	|102|	203|	406|
|Standard_NC64as_T4_v3|2 GPU<sup>1	|52.44	|104	|208|
|Standard_NC64as_T4_v3|3 GPU<sup>1	|35.96	|70.93|	140|
|Standard_NC64as_T4_v3|4 GPU	|27.47	|53.96|	106|

<sup>1</sup> *In these cases, the number of GPUs was artificially limited. This VM has four GPUs.*

This graph shows the relative speed increases as the CPU/GPU increases:

:::image type="content" source="media/keyshot/door-nc64as.png " alt-text="Graph that shows the relative speed increase for the door configurator on the NC64as_T4 VM." border="false":::

## Azure cost

The following tables provide elapsed times in hours. To compute the total cost, multiply these times by the Azure VM hourly costs for NVads_A10_v5 and NCas_T4_v3 VMs. For the current hourly costs, see [Windows Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing).

Only model running time (wall-clock time) is considered for these cost calculations. Application installation time isn't considered. The calculations are indicative. The actual numbers depend on the size of the model.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

### NVads_A10_v5 series 

This table shows elapsed times, in hours, for running all three models. 

|Sample size|12-core CPU|1/3 GPU|1/2 GPU|1 GPU|1 GPU (36adms* VM)|2 GPU|
|-----------|-----------|-------|-------|-----|-----------------------------|-----|
|256        |0.665      |0.098  |0.060  |0.027|0.022                        |0.013|
|512        |1.318      |0.196  |0.120  |0.054|0.043                        |0.024|
|1024       |2.484      |0.388  |0.238  |0.107|0.087                        |0.047|

\* *This number refers to a Standard_NV36adms_A10_v5 VM configuration.*

### NCAST4_V3 series

This table shows elapsed times, in hours, for running all three models.

|Sample size|	64-core CPU|	1 GPU|	2 GPU|	3 GPU|	4 GPU|
|-|-|-|-|-|-|
|256	|0.129	|0.062	|0.033	|0.024	|0.019|
|512	|0.254	|0.122	|0.064	|0.045	|0.035|
|1024	|0.506	|0.243|	0.127	|0.087|	0.068|

## Summary

- Luxion KeyShot 11 was successfully tested on NVads_A10_v5 and NC64as_T4_v3 VMs.
- The GPU technology in KeyShot 11 provides excellent processing power on Azure.
- Depending on the complexity of the model, the performance improvement as you increase CPU/GPU varies.

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) |
    Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) |
    Principal Program Manager
- [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) |
    HPC Performance Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) |
    Technical Writer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director
    Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) |
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

This article briefly describes the steps for running [Samadii DEM](https://www.metariver.kr/smddem.html) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running Samadii DEM on Azure.

Samadii DEM analyzes and interprets large-scale particles at high speed. It uses discrete element method (DEM), which is a Lagrangian method that determines the movement of particles by using the six-degrees-of-freedom equations of motion, taking into consideration all forces of individual particles. It uses explicit methods for time integration to calculate the position and velocity of the particles in the next time step.

DEM requires significant memory and computing power because of its small time step and the large number of particles that it takes into account. Samadii DEM, which is designed to perform analysis by using GPU and parallel processing techniques, supplies reliable results by analyzing a variety of large-scale grain boundary issues at a high speed.

Samadii DEM is used in the mechanical, electronic, chemical, semiconductor, manufacturing, automotive, energy, and construction/facilities industries.

## Why deploy Samadii DEM on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Good scale and cost efficiency on NCasT4_v3-series VMs  

## Architecture

:::image type="content" source="media/samadii-dem/architecture.png" alt-text="Diagram that shows an architecture for deploying Samadii DEM." lightbox="media/samadii-dem/architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/samadii-dem.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Windows VM. For information about deploying VMs and installing the drivers, see [Windows VMs on Azure](../../reference-architectures/n-tier/windows-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) restrict access to the VM.  
  - A public IP address connects the internet to the VM.
- A physical solid-state drive (SSD) provides storage.

## Compute sizing and drivers

Performance tests of Samadii DEM on Azure used [NVv3](/azure/virtual-machines/nvv3-series), [NCasT4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), [ND_A100_v4](/azure/virtual-machines/nda100-v4-series), and [NC A100 v4](/azure/virtual-machines/nc-a100-v4-series) series VMs running Windows 10. The following table provides details about the VMs.

|VM size|GPU name|vCPUs|Memory, in GiB|Maximum data disks|	GPUs|GPU memory, in GiB|Maximum uncached disk throughput, in IOPS / MBps|Temporary storage (SSD), in GiB|Maximum NICs|
|-|-|-|-|-|-|-|-|-|-|
|Standard_NV12s_v3	|Tesla M60|12	|112|	12|	1|	8	|20,000 / 200	|320|	4|
|Standard_NC4as_T4_v3|Tesla T4|	4|	28	|8	|1	|16	|-|	180|	2|
|Standard_NC6s_v3	|V100|6	|112	|12|	1	|16	|20,000 / 200	|736	|4|
|Standard_ND96asr_v4|A100|	96	|900|	32|	8|	40|	80,000 / 800|	6,000|	8|
|Standard_NC24ads_A100_v4|	A100|	24|	220|	32|	1|	80|	30,000 / 1,000|	1,123	|2|

### Required drivers

To take advantage of the GPU capabilities of [NVv3](/azure/virtual-machines/nvv3-series), [NCas_T4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), [ND_A100_v4](/azure/virtual-machines/nda100-v4-series), and [NC A100 v4](/azure/virtual-machines/nc-a100-v4-series) series VMs, you need to install NVIDIA GPU drivers.

## Samadii DEM installation

Before you install Samadii DEM, you need to deploy and connect a VM and install the required NVIDIA drivers.

For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

> [!IMPORTANT]
> NVIDIA Fabric Manager installation is required for VMs that use NVLink. ND_A100_v4 VMs use this technology. 

Following are some prerequisites for running Samadii applications.
- Windows 10 (x64) OS
- One or more NVIDIA CUDA-enabled GPUs: Tesla, Quadro, or GeForce series
- Visual C++ 2010 SP1 Redistributable Package 
- Microsoft MPI v7.1
- .NET Framework 4.5

The product installation process involves installing a license server, installing Samadii DEM, and configuring the license server. For more information about installing Samadii DEM, contact [Metariver Technology](https://www.metariver.kr/index.html).

## Samadii DEM performance results

The following table shows operating system versions and processors that were used for the tests.

|VM series| ND_A100_v4	|NCv3| 	NCasT4_v3|	NVv3| 	NC A100 v4|
|-|-|-|-|-|-|
|Operating system version|Windows 10 Professional, version 20H2|Windows 10 Professional, version 20H2|Windows 10 Professional, version 20H2|Windows 10 Professional, version 20H2|Windows 10 Professional, version 21H2|
|OS architecture|x86-64 |x86-64 |x86-64 |x86-64 |x86-64 |
|Processor	|AMD EPYC 7V12, 64-core processor, 2.44 GHz (2 processors)	|Intel Xeon CPU E5-2690 v4|	AMD EPYC 7V12, 64-core processor, 2.44 GHz	|Intel Xeon CPU E5-2690 v4|	AMD EPYC 7V13, 64-core processor, 2.44 GHz|

The following two models were used for testing.

### Simple box

:::image type="content" source="media/samadii-dem/simple-box.png" alt-text="Screenshot that shows the simple box model." :::

- **Size:** 13,560
- **Cell type:** Shell
- **Solver:** Samadii-dem-x64-v21 R2 

### Auger mixer

:::image type="content" source="media/samadii-dem/auger-mixer.png" alt-text="Screenshot that shows the auger mixer model." :::

- **Size:** 42,446
- **Cell type:** Shell
- **Solver:** Samadii-dem-x64-v21 R2 

### Results for the simple box model 

The following table shows the elapsed runtimes and relative speed increases for various VM configurations.

|VM series|	GPU |	1-GPU runtime, in seconds|	Relative speed increase|	2-GPU runtime, in seconds|	Relative speed increase|
|-|-|-|-|-|-|
|ND_A100_v4	|A100	|173<sup>1|	1.61|	252<sup>1|	1.34|
|NCv3	|V100	|182|	1.53	|249	|1.35|
|NCasT4_v3|	Tesla T4|	176|	1.58|	236<sup>2|	1.43|
|NVv3|	Tesla M60	|278|	1.00	|337	|1.00|
|NC A100 v4|A100|	290|	0.96|	355|	0.95|

<sup>1</sup> *In these cases, the number of GPUs was artificially limited. This VM has eight GPUs.*<br>
<sup>2</sup> *In these cases, the number of GPUs was artificially limited. This VM is available with one or four GPUs.*

Here are the relative speed increases in graphical form:

:::image type="content" source="media/samadii-dem/simple-box-graph.png" alt-text="Graph that shows the relative speed increases for the simple box model." lightbox="media/samadii-dem/simple-box-graph.png" border="false":::

### Results for the auger mixer model

The following table shows the elapsed runtimes and relative speed increases for various VM configurations.

|VM series|	GPU |	1-GPU runtime, in seconds|	Relative speed increase|	2-GPU runtime, in seconds|	Relative speed increase|
|-|-|-|-|-|-|
|ND_A100_v4	|A100	|1,766<sup>1	|2.15	|2,054<sup>1	|1.78|
|NCv3	|V100	|1,885	|2.01|	2,140|	1.71|
|NCasT4_v3|	Tesla T4|	2,601	|1.46	|2,543<sup>2|	1.44|
|NVv3|	Tesla M60	|3,794	|1|	3,659|	1|
|NC A100 v4|A100|	1,701|	2.23|	1,939|	1.89|

<sup>1</sup> *In these cases, the number of GPUs was artificially limited. This VM has eight GPUs.*<br>
<sup>2</sup> *In these cases, the number of GPUs was artificially limited. This VM is available with one or four GPUs.*

Here are the relative speed increases in graphical form:

:::image type="content" source="media/samadii-dem/auger-mixer-graph.png" alt-text="Graph that shows the relative speed increases for the auger mixer model." lightbox="media/samadii-dem/auger-mixer-graph.png" border="false":::

## Azure cost

The following tables present wall-clock times in hours. To compute the total cost, multiply these times by the Azure VM hourly costs for NVv3, NCasT4_v3, NCv3, ND_A100_v4, and NC A100 v4 series VMs. For the current hourly costs, see [Windows Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing).

Only simulation runtime is considered for these cost calculations. Application installation time and license costs aren't included. In some cases, the number of GPUs was artificially limited for the sake of testing.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

### Costs, simple box

|VM size	|Number of GPUs|	GPUs utilized	|	Wall-clock time, in hours|
|-|-|-|-|
|Standard_ND96asr_v4|	8|	1|		0.048|
|Standard_ND96asr_v4	|8	|2	|	0.07|
|Standard_NC6s_v3	|1|	1|		0.05|
|Standard_NC12s_v3	|2	|2	|	0.07|
|Standard_NC4as_T4_v3|	1|	1|		0.049|
|Standard_NC64as_T4_v3	|4	|2	|	0.066|
|Standard_NV12s_v3	|1	|1	|	0.077|
|Standard_NV24s_v3	|2	|2	|	0.094|
|Standard_NC24ads_A100_v4|	2	|1|	0.081|
|Standard_NC24ads_A100_v4|	2|	2	|0.099|

### Costs, auger mixer

|VM size	|Number of GPUs|	GPUs utilized	|	Wall-clock time, in hours|
|-|-|-|-|
|Standard_ND96asr_v4|	8|1|0.49|
|Standard_ND96asr_v4	|8|2|0.57|
|Standard_NC6s_v3	|1|1|0.53|
|Standard_NC12s_v3	|2|2|0.59|
|Standard_NC4as_T4_v3|1|1|0.72|	
|Standard_NC64as_T4_v3	|4|2|0.71|
|Standard_NV12s_v3	|1|1|1.05|
|Standard_NV24s_v3	|2|2|1.02|
|Standard_NC24ads_A100_v4	|2|	1|	0.47|
|Standard_NC24ads_A100_v4	|2|	2	|0.54|

## Summary

- Samadii DEM was successfully tested on ND_A100_v4, NCv3, NCasT4_v3, NVv3, and NC A100 v4 series VMs.
- Performance tests demonstrate that Samadii DEM performs well on NCasT4_v3, NCv3, NC A100 v4, and ND_A100_v4 series VMs. The speed increases are as much as 1.5 times, 2 times, 2.25 times, and 2.15 times, respectively, higher than the times recorded with Tesla M60 GPU cards.
- We recommend NCasT4_v3 VMs with a one-GPU configuration because these VMs provide good scale-up and are also cost efficient. For the simple box model, they provide relative speed increases that are comparable to those recorded on the NC A100 v4 VM.

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

-   [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) |
    Senior Manager
-   [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) |
    Principal Program Manager
-   [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) |
    HPC Performance Engineer

Other contributors:

-   [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) |
    Technical Writer
-   [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director of
    Business Strategy
-   [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) |
    Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [GPU-optimized virtual machine sizes](/azure/virtual-machines/sizes-gpu)
- [Virtual machines on Azure](/azure/virtual-machines/overview)
- [Virtual networks and virtual machines on Azure](/azure/virtual-network/network-overview)
- [Learning path: Run HPC applications on Azure](/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)

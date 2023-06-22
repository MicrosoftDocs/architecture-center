This article briefly describes the steps for running [Samadii Plasma](https://www.metariver.kr/smdplasma.html) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running Samadii Plasma on Azure.

Samadii Plasma provides high-performance plasma physics simulation. It simulates plasma physics by using a method that's based on ion and electron particles. Samadii Plasma's high-speed electromagnetic field analysis capabilities and particle-based gas analysis, based on GPU technology, enable highly advanced plasma simulation.

Organizations that use Samadii Plasma include manufacturers of flat panel and OLED displays and manufacturers of semiconductors. This solution is ideal for the manufacturing and electronics industries.

## Why deploy Samadii Plasma on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Strong performance scale-up, and configurations that provide either optimized scaling or optimized cost efficiency

## Architecture

:::image type="content" source="media/samadii-plasma/architecture.png" alt-text="Diagram that shows an architecture for deploying Samadii Plasma." lightbox="media/samadii-plasma/architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/samadii-plasma.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Windows VM. For information about deploying the VM and installing the drivers, see [Windows VMs on Azure](../../reference-architectures/n-tier/windows-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) restrict access to the VM.  
  - A public IP address connects the internet to the VM.
- A physical solid-state drive (SSD) provides storage.

## Compute sizing and drivers

The performance tests of Samadii Plasma on Azure used [NVv3](/azure/virtual-machines/nvv3-series), [NCasT4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), [ND_A100_v4](/azure/virtual-machines/nda100-v4-series), and [NC_A100_v4](/azure/virtual-machines/nc-a100-v4-series) series VMs running Windows 10. The following table provides details about the VMs.

|VM size|GPU|Number of vCPUs|Memory, in GiB|Maximum data disks|Number of GPUs|GPU memory, in GiB|Maximum uncached disk throughput, in IOPS / MBps|Temporary storage (SSD), in GiB|Maximum NICs|
|-|-|-|-|-|-|-|-|-|-|
|Standard_NV12s_v3|	Tesla M60|	12|	112|	12|	1|	8	|20,000 / 200|	320|	4|
|Standard_NC4as_T4_v3|	Tesla T4|	4|	28|	8	|1	|16|	-|	180|	2|
|Standard_NC6s_v3	|V100|	6	|112	|12|	1|	16|	20,000 / 200|	736|	4|
|Standard_ND96asr_v4|	A100|	96|	900	|32|	8	|40	|80,000 / 800	|6,000	|8|
|Standard_NC24ads_A100_v4|A100|	24|	220|	32|	1|	80|	30,000 / 1,000	|1,123|	2|

### Required drivers

To take advantage of the GPU capabilities of [NVv3](/azure/virtual-machines/nvv3-series), [NCasT4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), [ND_A100_v4](/azure/virtual-machines/nda100-v4-series), and [NC_A100_v4](/azure/virtual-machines/nc-a100-v4-series) series VMs, you need to install NVIDIA GPU drivers.

To use AMD processors on [NVv3](/azure/virtual-machines/nvv3-series), [NCasT4_v3](/azure/virtual-machines/nct4-v3-series), [NCv3](/azure/virtual-machines/ncv3-series), [ND_A100_v4](/azure/virtual-machines/nda100-v4-series), and [NC_A100_v4](/azure/virtual-machines/nc-a100-v4-series) series VMs, you need to install AMD drivers.

## Samadii Plasma installation

Before you install Samadii Plasma, you need to deploy and connect a VM and install the required NVIDIA and AMD drivers.

For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml). 

> [!IMPORTANT]
> NVIDIA Fabric Manager installation is required for VMs that use NVLink. ND_A100_v4 and NC_A100_v4 VMs use this technology.

Following are some prerequisites for running Samadii applications.
- Windows 10 (x64) OS
- One or more NVIDIA CUDA-enabled GPUs: Tesla, Quadro, or GeForce series
- Visual C++ 2010 SP1 Redistributable Package 
- Microsoft MPI v7.1
- .NET Framework 4.5

The product installation process involves installing a license server, installing Samadii Plasma, and configuring the license server. For more information about installing Plasma, contact [Metariver Technology](https://www.metariver.kr/index.html).

## Samadii Plasma performance results

Windows 10 Professional, version 20H2, with an x86-64 architecture, was used for all tests. The following table shows the processors that were used.

|VM series|ND_A100_v4|	NCv3|	NCasT4_v3|	NVv3|NC_A100_v4|
|-|-|-|-|-|-|
|Processor|	AMD EPYC 7V12, 64-core processor, 2.44 GHz (2 processors)|	Intel Xeon CPU E5-2690 v4|	AMD EPYC 7V12, 64-core processor, 2.44 GHz|	Intel Xeon CPU E5-2690 v4|AMD EPYC 7V13, 64-core processor, 2.44 GHz|

The following three models were used for testing.

### Magnetron sputter

:::image type="content" source="media/samadii-plasma/magnetron-sputter.png" alt-text="Screenshot that shows the magnetron sputter model." :::

- Model size:  941,371
- Cell type: Shell and solid
- Solver: Samadii SCIV V21 R1
- Number of GPUs used for all simulations: One

### Import inlet 

:::image type="content" source="media/samadii-plasma/import-inlet.png" alt-text="Screenshot that shows the import inlet model." :::

- Model size:  141,967
- Cell type: Shell and solid
- Solver: Samadii SCIV V21 R1   
- Number of GPUs used for all simulations: One


### Sputtering target

:::image type="content" source="media/samadii-plasma/sputtering-target.png" alt-text="Screenshot that shows the sputtering target model.":::

- Model size: 15,991
- Cell type: Shell and solid
- Solver: Samadii SCIV V21 R1
- Number of GPUs used for all simulations: One

### Results for the magnetron sputter model

The following table shows the elapsed runtimes and relative speed increases on each VM series. The NVv3 series VM is used as a baseline for the relative speed increases. 

|VM series |GPU|	Elapsed time, in seconds	|Relative speed increase|
|-|-|-|-|
|NVv3|Tesla M60|	12,825.36|	N/A|
|NCasT4_v3|Tesla T4	|7,606.59|	1.69|
|NCv3	|V100|2,798.55|	4.58|
|ND_A100_v4|A100	|1,977|	6.49|
|NC_A100_v4|A100|1,590.83|	8.06|

This graph shows the relative speed increases.  

:::image type="content" source="media/samadii-plasma/magnetron-sputter-graph.png" alt-text="Graph that shows the relative speed increases for the magnetron sputter model." lightbox="media/samadii-plasma/magnetron-sputter-graph.png" border="false":::

### Results for the import inlet model

The following table shows the elapsed runtimes and relative speed increases on each VM series. The NVv3 series VM is used as a baseline for the relative speed increases. 

|VM series|GPU |	Elapsed time, in seconds	|Relative speed increase|
|-|-|-|-|
|NVv3|Tesla M60|248.99| N/A|
|NCasT4_v3|Tesla T4	|159.61|1.56|
|NCv3	|V100|141.59|1.76|
|ND_A100_v4|A100	|112|2.22|
|NC_A100_v4|A100|44.27|	5.62|

This graph shows the relative speed increases.  

:::image type="content" source="media/samadii-plasma/import-inlet-graph.png" alt-text="Graph that shows the relative speed increases for the import inlet model." lightbox="media/samadii-plasma/import-inlet-graph.png" border="false":::

### Results for the sputtering target model

The following table shows the elapsed runtimes and relative speed increases on each VM series. The NVv3 series VM is used as a baseline for the relative speed increases. 

|VM series|GPU|	Elapsed time, in seconds	|Relative speed increase|
|-|-|-|-|
|NVv3|Tesla M60|13.82| N/A|
|NCasT4_v3	|Tesla T4|8.46|1.63|
|NCv3|V100	|6.86|2.01|
|ND_A100_v4|A100	|5.9|2.34|
|NC_A100_v4|A100	|8.61	|1.61|

This graph shows the relative speed increases. 

:::image type="content" source="media/samadii-plasma/sputtering-target-graph.png" alt-text="Graph that shows the relative speed increases for the sputtering target model." lightbox="media/samadii-plasma/sputtering-target-graph.png" border="false":::

## Azure cost

The following tables present wall-clock times in hours. To compute the total cost, multiply these times by the Azure VM hourly costs for NVv3, NCasT4_v3, NCv3, ND_A100_v4, and NC_A100_v4 series VMs. For the current hourly costs, see [Windows Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing).

Only simulation runtime is considered in these cost calculations. Application installation time and license costs aren't included.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

### Cost, magnetron sputter model

|VM size|GPU|	Number of GPUs|		Wall-clock time, in hours|
|-|-|-|-|
|Standard_NV12s_v3|Tesla M60|	1		|3.56|
|Standard_NC4as_T4_v3|Tesla T4|	1|		2.11|
|Standard_NC6s_v3	|V100|1		|0.78|
|Standard_ND96asr_v4|A100|	1	|	0.55|
|Standard_NC24ads_A100_v4|A100|1	|0.44|

### Cost, import inlet model

|VM size|GPU	|Number of GPUs|		Wall-clock time, in hours|
|-|-|-|-|
|Standard_NV12s_v3|Tesla M60|1|0.07|
|Standard_NC4as_T4_v3|Tesla T4|1|0.04|
|Standard_NC6s_v3	|V100|1|0.04|
|Standard_ND96asr_v4|A100|1|0.03|
|Standard_NC24ads_A100_v4|A100|	1	|0.01|

### Cost, sputtering target model

|VM size|	GPU|Number of GPUs|		Wall-clock time, in hours|
|-|-|-|-|
|Standard_NV12s_v3|Tesla M60|1|0.0038|
|Standard_NC4as_T4_v3|Tesla T4|1|0.0024|
|Standard_NC6s_v3	|V100|1|0.0019|
|Standard_ND96asr_v4|A100|1|0.0016|
|Standard_NC24ads_A100_v4|A100|1	|0.0024|

## Summary

- Samadii Plasma was tested on Azure ND_A100_v4, NCv3, NCasT4_v3, NVv3, and NC_A100_v4 series VMs.
- For complex models, like magnetron sputter and import inlet, the Standard_NC24ads_A100_v4 VM provides the best performance.
- For models with less complexity, the NCasT4_v3 VM provides good scale-up, and the performance-to-cost ratio is better than that of the other VMs tested. 

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

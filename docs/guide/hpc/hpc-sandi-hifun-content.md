This article briefly describes the steps for running [Sandi HiFUN](https://sandi.co.in)   on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running HiFUN on Azure.

HiFUN is a  general-purpose computational fluid dynamics (CFD) application. You can use it to simulate airflow over aircraft, automobiles, and structures like buildings and ships. 

HiFUN has these capabilities:
- Provides a robust, fast, and accurate solver for aerodynamic design data
- Uses an unstructured cell-centered finite volume method that can handle complex geometries and flow physics
- Handles MPI directives for parallel computing on distributed-memory HPC
- Can scale over thousands of processor cores
- Can be ported to NVIDIA GPUs for parallel computing via [OpenACC](https://www.openacc.org) constructs  

Sandi HiFUN is used in the aerospace, automotive, industrial, and wind/turbine industries.

[HBv3](/azure/virtual-machines/hbv3-series) and [NCasT4_v3](/azure/virtual-machines/nct4-v3-series) series VMs were used to test the performance of HiFUN on Azure.

## Why deploy HiFUN on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning

## Architecture

:::image type="content" source="media/hpc-sandi-hifun.png" alt-text="Diagram that shows an architecture for running HiFUN on a virtual machine." lightbox="media/hpc-sandi-hifun.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/hpc-sandi-hifun.vsdx) of this architecture.* 

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Linux virtual machines.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud.

## Compute sizing and drivers

Performance tests of HiFUN on Azure used [HBv3](/azure/virtual-machines/hbv3-series) and [NCasT4_v3](/azure/virtual-machines/nct4-v3-series) VMs running the Linux CentOS operating system. The following table provides details about HBv3-series VMs.

|VM size|vCPU|Memory (GiB)|	Memory bandwidth (GBps)|	Base CPU frequency (GHz)|All-cores frequency (GHz, peak)|Single-core frequency (GHz, peak)|	RDMA performance (Gbps)	|Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3|	120	|448|	350|	1.9|	3.0	|3.5	|200|	32|
|Standard_HB120-96rs_v3|	96|	448|	350|	1.9|	3.0	|3.5	|200	|32|
|Standard_HB120-64rs_v3	|64	|448	|350	|1.9|	3.0	|3.5|	200|	32|
|Standard_HB120-32rs_v3	|32	|448|	350	|1.9|	3.0	|3.5	|200	|32
|Standard_HB120-16rs_v3	|16|	448|	350|	1.9|	3.0	|3.5	|200|	32|

The following table provides details about NCasT4_v3 VMs.

|VM size|vCPU|Memory, in GiB|	Temporary storage (SSD), in GiB|GPU|GPU memory, in GiB|Maximum data disks|Maximum NICs / Expected network bandwidth, in Mbps|
|-|-|-|-|-|-|-|-|
|Standard_NC4as_T4_v3	|4	|28|	180|	1|	16|	8	|2 / 8,000|
|Standard_NC8as_T4_v3	|8|	56|	360|	1|	16|	16|	4 / 8,000|
|Standard_NC16as_T4_v3|	16|	110|	360|	1|	16|	32|	8 / 8,000|
|Standard_NC64as_T4_v3|	64	|440|	2,880|	4	|64|	32|	8 / 32,000|

### Required drivers

To use InfiniBand, you need to enable [InfiniBand drivers](/azure/virtual-machines/workloads/hpc/enable-infiniband).

To enable the GPU capabilities of [NCasT4_v3](/azure/virtual-machines/nct4-v3-series) VMs, you need to install NVIDIA GPU drivers.

## HiFUN installation

Before you install HiFUN, you need to deploy and connect a VM. For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).
 
For more information about installing HiFUN on an Azure VM, you can contact Sandi at [sales@sandi.co.in](mailto:sales@sandi.co.in) or [info@sandi.co.in](mailto:info@sandi.co.in).

## HiFUN performance results

The Windsor model is used in this performance evaluation.

:::image type="content" source="media/windsor-model.png" alt-text="Screenshots that show the Windsor model." border="false":::


The following tables provide details about the model.

|Flow conditions||
|-|-|
|**Parameter**|	**Value**|
|Mach number|	0.1207|
|Velocity|	40 m/s|
|Reynolds number|	1.8 million|
|Flow direction	|Aligned to x axis|

|**Workload**|| 
|-|-|
|Model| 	Windsor car body |
|Number of volumes|	7.456 million|

### Performance results for HiFUN 4.1.1 on HBv3

|VM size|	Number of iterations|	Time per iteration (seconds)<sup>1</sup>|Relative speed increase|
|-|-|-|-|
|Standard_HB120-16rs_v3	|100	|10.13|	1.00|
|Standard_HB120-32rs_v3	|100|	5.29	|1.91|
|Standard_HB120-64rs_v3	|100|	2.76|	3.67|
|Standard_HB120-96rs_v3|	100	|2.00	|5.07|
|Standard_HB120rs_v3|	100	|1.70|	5.96|

<sup>1</sup> To negate the effect of input/output operations per second (IOPS), the average time of 51-60 recorded iterations is presented here.

This graph shows the relative speed increase<sup>2</sup> as the number of CPUs increases:

:::image type="content" source="media/hifun-hbv3.png" alt-text="Graph that shows the relative speed increase on an HBv3 VM." border="false":::

<sup>2</sup> The 16-CPU configuration is used as a baseline for the relative-speed calculations.

### Performance results for HiFUN 4.1.1 on NCasT4

|CPU configuration|Number of CPUs/GPUs|Number of iterations|Time per iteration (seconds)<sup>3</sup>|Relative speed increase|
|-|-|-|-|-|
|24 CPU|24 CPU|	100|	7.70|	1.00|
|	|1 GPU	|100	|5.55	|1.39|
|	|2 GPU|	100	|4.07	|1.89|
|	|4 GPU	|100|	2.91|	2.65|
|32 CPU|32 CPU|	100|	5.59|	1.00|
|	|1 GPU|	100|	4.99|	1.12|
|	|2 GPU	|100	|3.59|	1.56|
|	|4 GPU|	100|	2.45|	2.28|
|48 CPU|48 CPU	|100	|4.15	|1.00|
||	1 GPU|	100|	5.18|	0.80|
||	2 GPU|	100	|3.32	|1.25|
||	4 GPU|	100|	2.02|	2.05|

<sup>3</sup> To negate the effect of IOPS, the average time of 51-60 recorded iterations is presented here.

This graph shows the relative speed increase<sup>4</sup> as the number of GPUs increases:

:::image type="content" source="media/hifun-ncast4.png" alt-text="Graph that shows the relative speed increase on an NCasT4 VM." border="false":::

<sup>4</sup> The CPU configurations listed in the preceding table are used as the baselines for the relative-speed calculations.

### Additional notes about the tests

- HiFUN was successfully tested on HBv3 and NCasT4 VMs on Azure.
- Every CPU increase provides a good speed increase on all VM sizes. The peak speed increase of 5.96x is achieved with 120 CPUs.
- Every GPU increase provides a good speed increase on all CPU configurations. The peak speed increase of 2.65x is achieved with 4 GPUs.

## Azure cost

Only model running time (wall clock time) is considered for these cost calculations. Application installation time isn't considered. The numbers presented here are indicative of your potential results. The actual numbers depend on the size of the model.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your configuration.

The following tables provide elapsed times in hours. To compute the total cost, multiply these times by the hourly costs for [Linux VMs](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

### HBv3

| VM size|	Number of CPUs|	Elapsed time (hours)|
|-|-|-|
|Standard_HB120-16rs_v3	|16|	0.297|
|Standard_HB120-32rs_v3	|32|	0.156|
|Standard_HB120-64rs_v3	|64|	0.083|
|Standard_HB120-96rs_v3	|96	|0.061|
|Standard_HB120rs_v3	|120|	0.052|

### NC64as_T4_v3

|CPU/GPU|	Elapsed time (hours)|
|-|-|
|CPU	|0.116|
|4 GPU|	0.057|

## Summary

Azure provides robust compute services that support GPU-intensive workloads and offers unlimited scalability for HPC applications. You can use H-series virtual machines for memory-bound applications and N-series virtual machines for graphic-intensive applications.
 
## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:
- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- Kalai Selvan | HPC Performance Engineer

Other contributors:
- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director, Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [High performance computing VM sizes](/azure/virtual-machines/sizes-hpc)
- [Linux virtual machines on Azure](/azure/virtual-machines/linux/overview)
- [Virtual networks and virtual machines on Azure](/azure/virtual-network/network-overview)
- [Learning path: Run HPC applications on Azure](/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)


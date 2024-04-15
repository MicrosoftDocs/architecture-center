> [!CAUTION]
> This article references CentOS, a Linux distribution that is nearing End Of Life (EOL) status. Please consider your use and plan accordingly. For more information, see the [CentOS End Of Life guidance](/azure/virtual-machines/workloads/centos/centos-end-of-life).

This article briefly describes the steps for running Rock Flow Dynamics [tNavigator](https://rfdyn.com/) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running tNavigator.

tNavigator is a reservoir modeling and simulation platform. It provides tools for geoscience, reservoir, and production engineering. It builds static and dynamic reservoir models and runs dynamic simulations. tNavigator runs on workstations and clusters. A cloud-based solution with full GUI capabilities via remote desktop is also available.

With tNavigator, you can perform extended uncertainty analysis and surface networks builds as part of one integrated workflow. All the parts of the workflow share an internal data storage system, scalable parallel numerical engine, data input and output mechanism, and graphical user interface. tNavigator supports the metric, lab, and field unit systems.

## Why deploy tNavigator on Azure?

- Azure provides the latest and diverse compute options to align with the huge workloads for reservoir simulations.
- Flexible virtualization without the purchase of physical hardware
- Rapid provisioning
- Dynamic reservoir simulations can be solved in few hours by using greater number of vCPUs cores and GPUs.

## Architecture

This diagram shows a single-node configuration:

:::image type="content" source="media/tnavigator-single-node.svg" alt-text="Diagram that shows a single-node architecture for running tNavigator on an Azure VM." lightbox="media/tnavigator-single-node.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/tnavigator-single-node.vsdx) of this architecture.* 

This diagram shows a multi-node configuration:

:::image type="content" source="media/tnavigator-multi-node.svg" alt-text="Diagram that shows a multi-node architecture for running tNavigator on an Azure VM." border="false" lightbox="media/tnavigator-multi-node.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/tnavigator-multi-node.vsdx) of this architecture.* 

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Linux VMs. For information about deploying the VMs and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud. 
   - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VMs.
   - A public IP address connects the internet to the VMs. 
- [Azure CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud) is used to create the cluster in the multi-node configuration.
- A physical SSD is used for storage.

## Compute sizing for CPU scaling

 Performance tests of tNavigator on Azure used [HBv3-series](https://learn.microsoft.com/en-us/azure/virtual-machines/hbv3-series) , [HBv4-series](https://learn.microsoft.com/en-us/azure/virtual-machines/hbv4-series) VM running on Linux operating system for CPU scaling.

## HBv3-series

The following table provides configuration details for HBv3-series.

| VM size | vCPU | Memory (GiB) | Memory bandwidth (GBps) | Base CPU frequency (GHz) | All-cores frequency (GHz, peak) | Single-core frequency (GHz, peak) | RDMA performance (Gbps) |
|---|---|---|---|---|---|---|---|
| Standard_HB120-16rs_v3 | 16 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| Standard_HB120-32rs_v3 | 32 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| Standard_HB120-64rs_v3 | 64 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| Standard_HB120-96rs_v3 | 96 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| Standard_HB120-120rs_v3 | 120 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |

The following table provides operating system details used for the testing of tNavigator on HBv3-series.

| Operating system version | OS architecture |
|---|---|
| Linux CentOS 8.1 HPC | x86-64  |

## HBv4-series

The following table provides configuration details for HBv4-series.

| VM size | vCPU | Memory (GiB) | Memory bandwidth (GBps) | Base CPU frequency (GHz) |Single-core frequency (GHz, peak) | RDMA performance (Gbps) |
|---|---|---|---|---|---|---|
| Standard_HB176-24rs_v4|	24|	768|	780|	2.4|	3.7|	400|
| Standard_HB176-48rs_v4|	48|	768|	780|	2.4|	3.7|	400|
| Standard_HB176-96rs_v4|	96|	768|	780|	2.4|	3.7|	400|
| Standard_HB176-144rs_v4|	144|	768|	780|	2.4|	3.7|	400|
| Standard_HB176rs_v4|	176|	768|	780|	2.4|	3.7|	400|

The following table provides operating system details used for the testing of tNavigator on HBv4-series.

| Operating system version | OS architecture |
|---|---|
| Linux CentOS 8.1 HPC | x86-64  |

## Compute sizing and drivers for GPU scaling

Performance tests of tNavigator on Azure used [NC A100 v4-series](https://learn.microsoft.com/en-us/azure/virtual-machines/nc-a100-v4-series) VM running on Linux operating system for GPU scaling.

The following table provides configuration details for NC A100 v4-series.

| VM size | vCPU | Memory (GiB)| NVMe Disk (GiB) |GPU | GPU Memory(GiB) |Max data disk|
|---|---|---|---|---|---|---|
| Standard_NC24ads_A100_v4|	24|	220|	960|	1|	80|	12|
| Standard_NC48ads_A100_v4|	48|	440|	2x960|	2|	160|	24|
| Standard_NC96ads_A100_v4|	96|	880|	4x960|	4	|320|	32|

The following table provides operating system and driver details used for the testing of tNavigator on NC A100 v4-series.

| Operating system version | OS architecture |Cuda version|GPU driver version|
|---|---|---|---|
| AlmaLinux-hpc-8.6-gen2|	x86-64|	11.6|	510.85|

## Required drivers

To take advantage of the GPU capabilities [NC A100 v4-series](https://learn.microsoft.com/en-us/azure/virtual-machines/nc-a100-v4-series) VMs, you need to install required NVIDIA GPU drivers. For information about installing the drivers, see [Install NVIDIA GPU drivers](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/n-series-driver-setup) on N-series VMs running Linux.

## tNavigator installation

Before you install tNavigator, you need to deploy and connect a VM. For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml). You can download and install tNavigator from the [Rock Flow Dynamics Resources Hub](https://rfdyn.com/resources-hub/). You can also get information about the installation process from this hub.

## tNavigator performance results

 The performance tests of tNavigator v22.4 on Azure used [HBv3-series](https://learn.microsoft.com/en-us/azure/virtual-machines/hbv3-series) , [HBv4-series](https://learn.microsoft.com/en-us/azure/virtual-machines/hbv4-series)  for CPU scaling and [NC A100 v4-series](https://learn.microsoft.com/en-us/azure/virtual-machines/nc-a100-v4-series) and GPU scaling VM running on Linux operating system. The Speed test 9 model is used for performance testing of tNavigator.


## Model details:

The following image shows Speed test 9 model used for performance evaluation.

:::image type="content" source="media/speed-test-model.png" alt-text="Image that shows a 3D view of the speed test model." border="true":::
<br>

These are the details for the speed test 9 model:

|Dimensions| Total active grid blocks| Total pore volume | Mesh connection statistics|
|---|---|-|-|
| NX = 264<br>NY = 645<br>NZ = 177<br>SIZE = 30,139,560| 21770901 | 13,563,305,518.45987 rm3 | Total: 64,533,441<br>Geometrical: 64,533,441 |

## Results on HBv3-series VM

HBv3-series VM with different numbers of vCPUs were deployed to determine the optimal core configuration to run tNavigator on a standalone VM. That optimal configuration is then tested on a multi-node cluster deployment. 

### Results on single-node configuration

The following table shows total elapsed time of speed test 9 model in seconds:

| VM size | Number of vCPUs used | Total elapsed time (seconds) | Relative speed increase |
|---|---|---|---|
| Standard_HB120-16rs_v3 | 8 | 20,045 | N/A |
| Standard_HB120-16rs_v3 | 16 | 11,541 | 1.73 |
| Standard_HB120-32rs_v3 | 32 | 6,588 | 3.04 |
| Standard_HB120-64rs_v3 | 64 | 4,572 | 4.38 |
| Standard_HB120-96rs_v3 | 96 | 4,113 | 4.87 |
| Standard_HB120-120rs_v3 | 120 | 4,061 | 4.93 |

The following chart shows relative speed increases as the number of vCPUs increases:

:::image type="content" source="media/speed-test-9-single-node.png" alt-text="Graph that shows the relative speed increases for the speed test 9 model." lightbox="media/speed-test-9-single-node.png" border="false":::

#### Additional notes about tests on tNavigator

•	It was observed that relative speed increases linearly as the number of vCPU cores were increased. 
•	For all single-node tests, we have taken the solver time on HB120-16rs_v3 (8 cores) as the reference to calculate the relative speed increase with respect to other similar VMs with more vCPUs. The results presented above show that parallel performance improves as we increase from 8 to 120 vCPUs.

### Results in a multi-node configuration

HBv3-series standalone testing depicts Standard_HB120-64rs_v3 is the optimal core configuration to continue the testing on multinode cluster. The following table shows the total elapsed time recorded for speed test 9 model on 1,2,4,6,8 and 16 nodes.

This table shows the times recorded for varying numbers of nodes of the Standard_HB120-64rs_v3 VM on Azure CycleCloud:

| VM size | Number of nodes | Number of vCPUs | Total elapsed time (seconds) | Relative speed increase |
|---|---|---|---|---|
| Standard_HB120-64rs_v3 | 1 | 64 | 5,025 | N/A |
|Standard_HB120-64rs_v3  | 2 | 128 | 3,323 | 1.51 |
|Standard_HB120-64rs_v3  | 4 | 256 | 2,264 | 2.22 |
|Standard_HB120-64rs_v3 | 8 | 512 | 1,697 | 2.96 |
| Standard_HB120-64rs_v3 | 16 | 1024 | 1,383 | 3.63 |

The following graph shows the relative speed increases as the number of nodes increases:

:::image type="content" source="media/speed-test-9-multi-node.png" alt-text="Graph that shows the relative speed increases for the speed test 9 model in a multi-node configuration." lightbox="media/speed-test-9-multi-node.png" border="false":::

#### Additional notes about the multi-node tests 
From the multi-node results, we can observe that models scale linearly up to 16 nodes, giving maximum speed up of 3.63 times the single node. We have limited our validation study to few iterations. It was also observed that using more than 64 vCPUs per node resulted in decrease in performance for this specific model.

## Results on HBv4-series VM

HBv4 VMs with different numbers of vCPUs were deployed to determine the optimal core configuration to run tNavigator on a standalone VM. That optimal configuration was then tested in a multi-node cluster deployment.

### Results on single-node configuration
The following table shows total elapsed time of speed test 9 in seconds:

|VM Size|	No. of vCPUs used|	Total Elapsed time (Seconds)|	Relative speed increase|
|---|---|---|---|
|Standard_HB176-24rs_v4|	12|	11602|	1.00|
|Standard_HB176-24rs_v4|	24|	6407|	1.81|
|Standard_HB176-48rs_v4|	48|	3288|	3.53|
|Standard_HB176-96rs_v4|	96|	2290|	5.07|
|Standard_HB176-144rs_v4|	144|	2017|	5.75|
|Standard_HB176_v4|	176|	1980|	5.86|

The following chart shows relative speed increase of speed test 9 model:

:::image type="content" source="media/speed-test-9-single-node.png" alt-text="Graph that shows the relative speed increases for the speed test 9 model." lightbox="media/speed-test-9-single-node.png" border="false":::

### Additional notes about tests on tNavigator

•	It was observed that relative speed increases linearly as the number of vCPU cores were increased. 
•	For all single-node tests, we have taken the solver time on HB176-24rs_v4 (12 vCPUs) as the reference to calculate the relative speed up with respect to other similar VMs with more vCPUs. The results presented above show that parallel performance improves as we increase from 12 to 176 vCPUs.

### Results on multi-node configuration

HBv4-series standalone testing depicts Standard_HB176-144rs_v4 is the optimal core configuration to continue the testing on multinode cluster. The following table shows the total elapsed time recorded for speed test 9 model on 1, 2, 4 and 8 nodes.

|VM size|Number of nodes|Number of vCPUs|Total Elapsed time (seconds)| Relative speed increase|
|---|---|---|---|---|
|Standard_HB176-144rs_v4| 1|	144|	2017|	1.00|
|Standard_HB176-144rs_v4| 2|	288|	1627|	1.24|
|Standard_HB176-144rs_v4| 4|	576|	1208|	1.67|
|Standard_HB176-144rs_v4| 8|	1152|	958|	2.11|

The following graph shows the relative speed increase as the number of nodes increases:

:::image type="content" source="media/speed-test-9-multi-node.png" alt-text="Graph that shows the relative speed increases for the speed test 9 model in a multi-node configuration." lightbox="media/speed-test-9-multi-node.png" border="false":::

### Additional notes about the multi-node tests 

From the multi-node results, we can observe that models scale linearly up to 8 nodes, giving maximum speed increase of 2.11 times the single node. We have limited our validation study to few iterations and 8 nodes as more nodes results in drop in performance for this model.

## Results on NC A100 v4-series VM

The following sections provide the performance results of running tNavigator on single-node Azure [NC A100 v4-series](https://learn.microsoft.com/en-us/azure/virtual-machines/nc-a100-v4-series)  VMs. 

The following table shows Total Elapsed time of Speed test 9 model in Seconds:

|VM Size|	No. of vCPUs and GPUs used|	Total Elapsed time (Seconds)|	Relative speed increase|
|---|---|---|---|
|Standard_NC24ads_A100_v4|	24vCPU & 0GPU|	14973|	1|
|Standard_NC24ads_A100_v4|	24vCPU & 1GPU|	3596|	4.16|
|Standard_NC48ads_A100_v4|	48vCPU & 2GPU|	2014|	7.43|
|Standard_NC96ads_A100_v4|	96vCPU & 4GPU|	1265|	11.84|

The following chart shows Relative speed increase of Speed Test 9 model:

:::image type="content" source="media/speed-test-9-multi-node.png" alt-text="Graph that shows the relative speed increases for the speed test 9 model in a multi-node configuration." lightbox="media/speed-test-9-multi-node.png" border="false":::

### Additional notes about tests on tNavigator

•	It was observed that relative speed increases linearly as the number of vCPU cores and GPUs were increased. 
•	For all tests we have taken the solver time on Standard_NC24ads_A100_v4 (24vCPUs & 0GPUs) as the reference to calculate the relative speed increase with respect to other similar VMs. The results presented above shows that parallel performance improves as we change the VM configuration with increasing number of vCPUs and GPUs.

## Azure cost

Only model running time (elapsed time) is considered for these cost calculations. Application installation time isn't considered. The calculations are indicative of your potential results. The actual cost depends on the size of the model. You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your configuration.

The following tables provide elapsed times in hours. To compute the total cost, multiply by the [Azure VM hourly costs for Linux](https://azure.microsoft.com/pricing/details/virtual-machines/linux/).

### Single node configuration: HBv3-series and HBv4-series VM and NC A100 v4-series.

|VM Size| Number of vCPUs and GPUs | Total elapsed time (hours) |
|---|---|---|
|Standard_HB120-16rs_v3|8|	5.56|
|Standard_HB120-16rs_v3|16|	3.20|
|Standard_HB120-32rs_v3|32|	1.83|
|Standard_HB120-64rs_v3|64|	1.27|
|Standard_HB120-96rs_v3|96|	1.14|
|Standard_HB120-120rs_v3|120|	1.12|
|Standard_HB176-24rs_v4|12|	3.22|
|Standard_HB176-24rs_v4|24|	1.78|
|Standard_HB176-48rs_v4|48|	0.91|
|Standard_HB176-96rs_v4|96|	0.64|
|Standard_HB176-144rs_v4|144|	0.56|
|Standard_HB176_v4|176|	0.55|
|Standard_NC24ads_A100_v4| 24vCPUs & 0GPU|	4.16|
|Standard_NC24ads_A100_v4| 24vCPUs & 1GPU|	1.00|
|Standard_NC48ads_A100_v4| 48vCPUs & 2GPU|	0.56|
|Standard_NC96ads_A100_v4| 96vCPUs & 4GPU|	0.35|

 

### Multi node configuration: HBv3-series and HBv4 series VM

|VM size| Number of nodes | Total elapsed time (hours) |
|---|---|---|
|Standard_HB120-64rs_v3| 1|	1.40|
|Standard_HB120-64rs_v3| 2|	0.92|
|Standard_HB120-64rs_v3| 4|	0.63|
|Standard_HB120-64rs_v3| 8|	0.47|
|Standard_HB120-64rs_v3| 16|	0.38|
|Standard_HB176-144rs_v4| 1|	0.56|
|Standard_HB176-144rs_v4| 2|	0.45|
|Standard_HB176-144rs_v4| 4|	0.34|
|Standard_HB176-144rs_v4| 8|	0.27|


### Summary details of cost consumption on HBv3-series used for the validation: 

•	To evaluate the cost performance of the other available sizes of HBv3-series VM, Standard_HB120-16rs_v3 with 8vCPUs is considered as a baseline.
•	There is partially linear scalability is observed when VM configuration changes from Standard_HB120-16rs_v3 to Standard_HB120_v3 ,while cost at each VM configuration is same.
•	Users can achieve ~4.9x performance improvement there by reducing per hour cost of the VM as the simulation’s Elapsed time reduces.
•	In Multi-Node setup, As the nodes are doubled, then cost also increases by 2x while the performance improvement at each increment is ~1.38x.

### Summary details of cost consumption on HBv4-series used for the validation: 

•	To evaluate the cost performance of the other available sizes of HBv4-series VM, Standard_HB176-24rs_v4 with 12vCPUs is considered as a baseline.
•	Partial linear scalability is observed when VM configuration of HBv4-series changes from Standard_HB176-24rs_v4 to Standard_HB176_v4, while the cost of HBv4-series at each VM size remains constant.
•	It is observed that ~5.86x performance can be enhanced which interns reduces the per hour cost of running the simulation using HBv4-series VMs.
•	In Multi-Node setup, As the nodes are doubled, the cost also increases by 2x while the performance improvement at each increment is ~1.28x.

### Summary details of cost consumption on NC A100 v4-series used for the validation: 

•	To evaluate the cost performance of the other available sizes of NC A100 v4-series VM, Standard_NC24ads_A100_v4 configuration is considered as a baseline.
•	It is evident that linear scalability in terms of performance and Azure cost is observed with every increment in NC A100 v4 series, as we increase the size from 24 vCPUs &1GPU (80GB) to 48vCPUs &2GPUs (160 GB), and 96vCPUs & 4GPUs (320GB).
•	In comparison of Standard_NC48ads_A100_v4 performance and cost with respect to Standard_NC24ads_A100_v4, there is ~80% increase in performance while there is ~11% increase in overall cost.
•	Similarly, comparison of Standard_NC96ads_A100_v40 performance and cost with respect to Standard_NC24ads_A100_v4, there is ~185% increase in performance however there is ~40% increase in overall cost.

## Summary
•	RFD tNavigator powered by Microsoft Azure platform exhibits high scalability on AMD EPYC™ 7V73X [Milan-X] vCPU cores and AMD EPYC™ 9V33X ("Genoa-X") vCPU cores. Moreover, it can also enhance performance by using A100 Nvidia GPU cards.
•	For evaluating AMD CPU performance, the lowest VM configurations for HBv3 and HBv4 are used as a baseline to calculate the relative speed increase.
•	On HBv3-series single node, we can achieve maximum scale up of ~4x with 64 vCPUs. Beyond which the performance becomes stale with minimum improvement. Whereas in HBv3 multi-node setup, a maximum scale up of 3.63x is observed with 16 nodes. 
•	On HBv4-series single node, maximum performance of ~5x can be achieved with 96vCPUs and beyond which minimum improvement in performance is observed. Whereas in HBv4-series multi-node setup, a maximum scale up of ~2.11x is observed with 8 nodes. Providing more nodes beyond 8 can result in decrease in performance.
•	In context with one-to-one comparison between 96 vCPUs HBv3-series and 96 vCPUs HBv4-series, it is noticed that HBv4-series is ~1.8x times faster.
•	For evaluating Performance of tNavigator on NVIDIA GPUs, NC A100 v4 series VMs are used.
•	 To show the scalability of NVIDIA GPUs, 24 vCPUs result was considered as a baseline.  A scale up of ~4.16x was observed with 1 A100 GPU and a maximum scale up of 11.84x is observed with 4 A100 GPU cards.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Aashay Anjankar](https://www.linkedin.com/in/aashay-anjankar-6a44291ba) | HPC Performance Engineer
- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Saurabh Parave](https://www.linkedin.com/in/saurabh-parave-957303162/) | HPC Performance Engineer
- [Karbasappa Umadi](https://www.linkedin.com/in/karbas-umadi-458879248/) | HPC Performance Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director of Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [GPU-optimized virtual machine sizes](/azure/virtual-machines/sizes-gpu)
- [Virtual machines on Azure](/azure/virtual-machines/linux/overview)
- [Virtual networks and virtual machines on Azure](/azure/virtual-network/network-overview)
- [Learning path: Run high-performance computing (HPC) applications on Azure](/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)

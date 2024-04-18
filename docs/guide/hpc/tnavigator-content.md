> [!CAUTION]
> This article references CentOS, a Linux distribution that is nearing End Of Life (EOL) status. Consider your use and plan accordingly. For more information, see the [CentOS EOL guidance](/azure/virtual-machines/workloads/centos/centos-end-of-life).

This article describes how to run Rock Flow Dynamics [tNavigator](https://rfdyn.com/) on a virtual machine (VM) in Azure. It also provides the performance results of running tNavigator.

tNavigator is a reservoir modeling and simulation platform that provides tools for geoscience, reservoir, and production engineering. It builds static and dynamic reservoir models and runs dynamic simulations. tNavigator runs on workstations and clusters. A cloud-based solution with full GUI capabilities via remote desktop is also available.

You can use tNavigator to perform extended uncertainty analysis and surface networks builds as part of one integrated workflow. All the parts of the workflow share an internal data storage system, scalable parallel numerical engine, data input and output mechanism, and graphical user interface. tNavigator supports the metric, lab, and field unit systems.

## Why deploy tNavigator on Azure?

- Azure provides the latest and diverse compute options to align with the huge workloads for reservoir simulations.
- Flexible virtualization without the purchase of physical hardware.
- Rapid provisioning.
- Dynamic reservoir simulations can be solved in a few hours by using a greater number of vCPU cores and GPUs.

## Architecture

The following diagram shows a single-node configuration:

:::image type="content" source="media/tnavigator-single-node.svg" alt-text="Diagram that shows a single-node architecture for running tNavigator on an Azure VM." lightbox="media/tnavigator-single-node.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/tnavigator-single-node.vsdx) of this architecture.*

The following diagram shows a multi-node configuration:

:::image type="content" source="media/tnavigator-multi-node.svg" alt-text="Diagram that shows a multi-node architecture for running tNavigator on an Azure VM." border="false" lightbox="media/tnavigator-multi-node.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/tnavigator-multi-node.vsdx) of this architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Linux VMs. For information about how to deploy the VMs and install the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VMs.
  - A public IP address connects the internet to the VMs.
- [Azure CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud) is used to create the cluster in the multi-node configuration.
- A physical SSD is used for storage.

## Compute sizing for CPU scaling

 Performance tests of tNavigator on Azure used [HBv3-series](/azure/virtual-machines/hbv3-series) and [HBv4-series](/azure/virtual-machines/hbv4-series) VMs that run on Linux operating system for CPU scaling.

### HBv3-series

The following table provides configuration details for HBv3-series.

| VM size | vCPU | Memory (GiB) | Memory bandwidth (GBps) | Base CPU frequency (GHz) | All-cores frequency (GHz, peak) | Single-core frequency (GHz, peak) | RDMA performance (Gbps) |
|---|---|---|---|---|---|---|---|
| Standard_HB120-16rs_v3 | 16 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| Standard_HB120-32rs_v3 | 32 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| Standard_HB120-64rs_v3 | 64 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| Standard_HB120-96rs_v3 | 96 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| Standard_HB120-120rs_v3| 120| 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |

The following table provides operating system details used for the testing of tNavigator on HBv3-series.

| Operating system version | OS architecture |
|---|---|
| Linux CentOS 8.1 HPC | x86-64  |

### HBv4-series

The following table provides configuration details for the HBv4-series tests.

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

Performance tests of tNavigator on Azure used [NC A100 v4-series](/azure/virtual-machines/nc-a100-v4-series) VMs running on Linux operating system for GPU scaling.

The following table provides configuration details for the NC A100 v4-series tests.

| VM size | vCPU | Memory (GiB)| NVMe Disk (GiB) |GPU | GPU Memory(GiB) |Max data disk|
|---|---|---|---|---|---|---|
| Standard_NC24ads_A100_v4|	24|	220|	960|	1|	80|	12|
| Standard_NC48ads_A100_v4|	48|	440|	2x960|	2|	160|	24|
| Standard_NC96ads_A100_v4|	96|	880|	4x960|	4	|320|	32|

The following table provides operating system and driver details used for the testing of tNavigator on NC A100 v4-series.

| Operating system version | OS architecture |Cuda version|GPU driver version|
|---|---|---|---|
| AlmaLinux-hpc-8.6-gen2|x86-64|11.6|510.85|

### Required drivers

To take advantage of the GPU capabilities [NC A100 v4-series](/azure/virtual-machines/nc-a100-v4-series) VMs, you need to install required NVIDIA GPU drivers. For information about how to install the drivers, see [Install NVIDIA GPU drivers](/azure/virtual-machines/linux/n-series-driver-setup) on N-series VMs that run Linux.

## tNavigator installation

Before you install tNavigator, you need to deploy and connect a VM. For information about how to deploy the VM and install the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml). You can download and install tNavigator from the [Rock Flow Dynamics Resources Hub](https://rfdyn.com/resources-hub/). You can also get information about the installation process from this hub.

## tNavigator performance results

The performance tests of tNavigator v22.4 on Azure used [HBv3-series](/azure/virtual-machines/hbv3-series) and [HBv4-series](/azure/virtual-machines/hbv4-series) VMs for CPU scaling and [NC A100 v4-series](/azure/virtual-machines/nc-a100-v4-series) and GPU scaling VMs that run on Linux operating systems. The Speed Test 9 model is used for performance testing of tNavigator.

### Model details

The following image shows Speed Test 9 model used for performance evaluation.

:::image type="content" source="media/speed-test-model.png" alt-text="Image that shows a 3D view of the speed test model." border="true":::
<br>

The following table provides the details for the Speed Test 9 model:

|Dimensions| Total active grid blocks| Total pore volume | Mesh connection statistics|
|---|---|-|-|
| NX = 264<br>NY = 645<br>NZ = 177<br>SIZE = 30,139,560| 21770901 | 13,563,305,518.45987 rm3 | Total: 64,533,441<br>Geometrical: 64,533,441 |

### Results on the HBv3-series VM

We deployed the HBv3-series VM with different numbers of vCPUs to determine the optimal core configuration to run tNavigator on a standalone VM. We tested this optimal vCPU configuration on a multi-node cluster deployment.

#### HBv3-series VM on single-node configuration

The following table shows the total elapsed time of the Speed Test 9 model in seconds:

| VM size | Number of vCPUs used | Total elapsed time (seconds) | Relative speed increase |
|---|---|---|---|
| Standard_HB120-16rs_v3 | 8 | 20,045 | N/A |
| Standard_HB120-16rs_v3 | 16 | 11,541 | 1.73 |
| Standard_HB120-32rs_v3 | 32 | 6,588 | 3.04 |
| Standard_HB120-64rs_v3 | 64 | 4,572 | 4.38 |
| Standard_HB120-96rs_v3 | 96 | 4,113 | 4.87 |
| Standard_HB120-120rs_v3 | 120 | 4,061 | 4.93 |

The following chart shows relative speed increases as the number of vCPUs increased:

:::image type="content" source="media/speed-test-9-single-node.png" alt-text="Graph that shows the relative speed increases for the Speed Test 9 model." lightbox="media/speed-test-9-single-node.png" border="false":::

#### HBv3-series VM notes about tests on tNavigator

- The relative speed increases linearly with the addition of vCPU cores.
- The solver time on the HB120-16rs_v3 (eight cores) VM serves as the baseline for relative speed increase results.
- Parallel performance improves as we increase the vCPUs from 8 to 120 in all single-node tests.

### HBv3-series VM results in a multi-node configuration

The HBv3-series VMs standalone testing depicts Standard_HB120-64rs_v3 as the optimal core configuration to continue the testing on multinode cluster. The following table shows the total elapsed time recorded for Speed Test 9 model on 1, 2, 4, 6, 8, and 16 nodes.

This table shows the times recorded for varying numbers of nodes of the Standard_HB120-64rs_v3 VM on Azure CycleCloud:

| VM size | Number of nodes | Number of vCPUs | Total elapsed time (seconds) | Relative speed increase |
|---|---|---|---|---|
| Standard_HB120-64rs_v3 | 1 | 64 | 5,025 | N/A |
|Standard_HB120-64rs_v3  | 2 | 128 | 3,323 | 1.51 |
|Standard_HB120-64rs_v3  | 4 | 256 | 2,264 | 2.22 |
|Standard_HB120-64rs_v3 | 8 | 512 | 1,697 | 2.96 |
| Standard_HB120-64rs_v3 | 16 | 1024 | 1,383 | 3.63 |

The following graph shows the relative speed increases as the number of nodes increases:

:::image type="content" source="media/speed-test-9-multi-node.png" alt-text="Graph that shows the relative speed increases for the Speed Test 9 model in a multi-node configuration." lightbox="media/speed-test-9-multi-node.png" border="false":::

#### HBv3-series VM notes about the multi-node tests

From the multi-node results, we can observe that models scale linearly up to 16 nodes, which gives maximum speed-up of 3.63 times the single node. We limited the validation study to a few iterations. Using more than 64 vCPUs per node resulted in decreased performance for this specific model.

### Results on the HBv4-series VM

HBv4-series VMs with different numbers of vCPUs were deployed to determine the optimal core configuration to run tNavigator on a standalone VM. That optimal configuration was then tested in a multi-node cluster deployment.

#### Results on single-node configuration

The following table shows the total elapsed time of Speed Test 9 in seconds:

|VM size|Number of vCPUs used|Total Elapsed time (seconds)|Relative speed increase|
|---|---|---|---|
|Standard_HB176-24rs_v4|12|11,602|1.00|
|Standard_HB176-24rs_v4|24|6,407|1.81|
|Standard_HB176-48rs_v4|48|3,288|3.53|
|Standard_HB176-96rs_v4|96|2,290|5.07|
|Standard_HB176-144rs_v4|144|2,017|5.75|
|Standard_HB176_v4|176|1,980|5.86|

The following chart shows relative speed increase of Speed Test 9 model:

:::image type="content" source="media/tnavigator/speed-test9-hbv4-singlenode-chart.png" alt-text="Graph that shows the relative speed increases for the Speed Test 9 model on single node configuration." lightbox="media/speed-test-9-single-node.png" border="false":::

#### HBv4-series VM notes about tests on tNavigator

- The relative speed increases linearly as the number of vCPU cores increases.
- The solver time on HB176-24rs_v4 (12 vCPUs) is the baseline reference to calculate the relative speed increase.
- Parallel performance improves from 12 to 176 vCPUs in all single-node tests.

#### HBv4-series VM results on multi-node configuration

HBv4-series standalone testing depicts Standard_HB176-144rs_v4 is the optimal core configuration to continue the testing on multinode cluster. The following table shows the total elapsed time recorded for Speed Test 9 model on one, two, four, and eight nodes.

|VM size|Number of nodes|Number of vCPUs|Total Elapsed time (seconds)| Relative speed increase|
|---|---|---|---|---|
|Standard_HB176-144rs_v4| 1|	144|	2,017|	1.00|
|Standard_HB176-144rs_v4| 2|	288|	1,627|	1.24|
|Standard_HB176-144rs_v4| 4|	576|	1,208|	1.67|
|Standard_HB176-144rs_v4| 8|	1,152|	958|	2.11|

The following graph shows the relative speed increase as the number of nodes increases:

:::image type="content" source="media/tnavigator/speed-test9-hbv4-multinode-chart.png" alt-text="Graph that shows the relative speed increases for the Speed Test 9 model in a multi-node configuration." lightbox="media/speed-test-9-multi-node.png" border="false":::

### HBv4-series VM notes about the multi-node tests

From the multi-node results, models scale linearly up to eight nodes, which gives a maximum speed increase of 2.11 times the single node. We limited our validation study to a few iterations and eight nodes as more nodes results in drop in performance for this model.

### Results on the NC A100 v4-series VM

The following sections provide the performance results of running tNavigator on single-node Azure [NC A100 v4-series](/azure/virtual-machines/nc-a100-v4-series) VMs.

The following table shows the total elapsed time in seconds of Speed Test 9 model:

|VM size|	Number of vCPUs and GPUs used|	Total Elapsed time (seconds)|	Relative speed increase|
|---|---|---|---|
|Standard_NC24ads_A100_v4|	24vCPU & 0GPU|	14,973|	1|
|Standard_NC24ads_A100_v4|	24vCPU & 1GPU|	3,596|	4.16|
|Standard_NC48ads_A100_v4|	48vCPU & 2GPU|	2,014|	7.43|
|Standard_NC96ads_A100_v4|	96vCPU & 4GPU|	1,265|	11.84|

The following chart shows relative speed increase of Speed Test 9 model:

:::image type="content" source="media/tnavigator/speed-test9-ncv4-chart.png" alt-text="Graph that shows the relative speed increases for the Speed Test 9 model on NCv4 configuration." lightbox="media/speed-test-9-multi-node.png" border="false":::

#### NC A100 v4-series VM notes about tests on tNavigator

- The relative speed increases linearly as the number of vCPU cores and GPUs increase.
- The solver time on Standard_NC24ads_A100_v4 (24vCPUs & 0GPUs) is the baseline reference for relative speed increase.
- Parallel performance improves as the number of vCPUs and GPUs increase in all tests.

## Azure cost

Only model running time (elapsed time) is considered for these cost calculations. Application installation time isn't considered. The calculations are indicative of your potential results. The actual cost depends on the size of the model. You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your configuration.

The following tables provide elapsed time in hours. To compute the total cost, multiply by the [Azure VM hourly costs for Linux](https://azure.microsoft.com/pricing/details/virtual-machines/linux/).

### Single node configuration: HBv3-series and HBv4-series VM and NC A100 v4-series

|VM size| Number of vCPUs and GPUs | Total elapsed time (hours) |
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

### Multi node configuration: HBv3-series and HBv4-series VM

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

### Summary of cost consumption on HBv3-series VMs

- The Standard_HB120-16rs_v3 VM that features 8 vCPUs is the baseline to assess the cost-performance of different HBv3-series VM sizes.
- There's partially linear scalability when VM configuration changes from Standard_HB120-16rs_v3 to Standard_HB120_v3, while the cost remains constant across these configurations.
- Users can achieve approximately a 4.9 times performance improvement, which effectively reduces the per-hour cost as the elapsed time for simulations decreases.
- In multi-node setups, doubling the number of nodes results in a twofold cost increase, while performance improves by approximately 1.38 times with each node addition.

### Summary of cost consumption on HBv4-series VMs

- The Standard_HB176-24rs_v4 VM with 12 vCPUs serves as the baseline for evaluating the cost-performance across the HBv4-series VM sizes.
- A similar trend of partial linear scalability is observed when configurations are changed within the HBv4-series, from Standard_HB176-24rs_v4 to Standard_HB176_v4, with consistent costs across different VM sizes.
- A performance enhancement of approximately 5.86 times can be observed, which in turn reduces the hourly operational cost when using the HBv4-series VMs.
- In multi-node configurations, doubling the nodes doubles the cost but results in a performance increase of about 1.28 times with each increment.

### Summary of cost consumption on NC A100 v4-series VMs

- The Standard_NC24ads_A100_v4 configuration that features 24 vCPUs and 1 GPU (80 GB) is the baseline for evaluating other sizes in the NC A100 v4-series.
- A clear linear scalability is evident with every increase in VM size, scaling up to configurations with 96 vCPUs and 4 GPUs (320 GB).
- The comparison of the Standard_NC48ads_A100_v4 to the baseline reveals an 80% increase in performance for an 11% increase in cost.
- The comparison of the Standard_NC96ads_A100_v40 to the baseline shows a 185% increase in performance with a 40% increase in cost.

## Summary

- RFD tNavigator powered by Microsoft Azure platform exhibits high scalability on AMD EPYC™ 7V73X Milan-X vCPU cores and AMD EPYC™ 9V33X ("Genoa-X") vCPU cores. Moreover, it can also enhance performance by using A100 Nvidia GPU cards.
- For evaluating AMD CPU performance, the lowest VM configurations for HBv3-series and HBv4-series are used as a baseline to calculate the relative speed increase.
- For HBv3-series single nodes, a maximal scaling up to approximately four times is possible with 64 vCPUs, with minimal gains beyond this configuration. In a multi-node HBv3 setup, scaling up to about 3.63 times is possible with 16 nodes.
- For the HBv4-series, a single node can achieve a maximum performance increase of around five times with 96 vCPUs, with further nodes offering diminishing returns. In a multi-node setup, the maximum scalability observed is about 2.11 times with eight nodes, with performance declines when more nodes are added.
- A direct comparison between the 96 vCPUs configurations of HBv3-series and HBv4-series indicates that the HBv4-series is approximately 1.8 times faster.
- To illustrate the scalability of NVIDIA GPUs in our tests, we used a configuration with 24 vCPUs as our standard baseline. With this setup, integrating one A100 NVIDIA GPU resulted in a performance increase of approximately 4.16 times. When expanding to four A100 GPUs, the performance further increased, achieving a maximum scalability of about 11.84 times compared to the baseline.

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

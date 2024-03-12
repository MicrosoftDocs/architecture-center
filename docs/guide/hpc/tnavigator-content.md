This article briefly describes the steps for running Rock Flow Dynamics [tNavigator](https://rfdyn.com/) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running tNavigator.

tNavigator is a reservoir modeling and simulation platform. It provides tools for geoscience, reservoir, and production engineering. It builds static and dynamic reservoir models and runs dynamic simulations. tNavigator runs on workstations and clusters. A cloud-based solution with full GUI capabilities via remote desktop is also available.

With tNavigator, you can perform extended uncertainty analysis and surface networks builds as part of one integrated workflow. All the parts of the workflow share an internal data storage system, scalable parallel numerical engine, data input and output mechanism, and graphical user interface. tNavigator supports the metric, lab, and field unit systems.

## Why deploy tNavigator on Azure?

- Modern and diverse compute options to align to your workload's needs
- Flexible virtualization without the purchase of physical hardware
- Rapid provisioning
- Complex simulations solved in a few hours via an increase in the number of CPU cores

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

## Compute sizing

[HBv3-series](/azure/virtual-machines/hbv3-series) VMs running on the Linux OS were used to test the performance of tNavigator on Azure. The following table provides configuration details:

| VM size | vCPU | Memory (GiB) | Memory bandwidth (GBps) | Base CPU frequency (GHz) | All-cores frequency (GHz, peak) | Single-core frequency (GHz, peak) | RDMA performance (Gbps) |
|---|---|---|---|---|---|---|---|
| Standard_HB120-16rs_v3 | 16 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| Standard_HB120-32rs_v3 | 32 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| Standard_HB120-64rs_v3 | 64 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| Standard_HB120-96rs_v3 | 96 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| Standard_HB120-120rs_v3 | 120 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |

The following table provides details about the operating system used in these tests:

| Operating system version | OS architecture |
|---|---|
| Linux CentOS 8.1 HPC | x86-64  |

## tNavigator installation

Before you install tNavigator, you need to deploy and connect a VM. For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml). You can download and install tNavigator from the [Rock Flow Dynamics Resources Hub](https://rfdyn.com/resources-hub/). You can also get information about the installation process from this hub.

## tNavigator performance results

Two standard, stable models were used to test tNavigator: speed test and speed test 9. Details about the models are shown in the following tables.

:::image type="content" source="media/speed-test-model.png" alt-text="Image that shows a 3D view of the speed test model." border="true":::
<br>

These are the details for the speed test model:

|Dimensions| Total active grid blocks| Total pore volume | Mesh connection statistics|
|---|---|-|-|
| X: 88<br> Y: 215<br> Z: 177<br> Size: 3,348,840 | 2,418,989 | 13,563,305,518.45987 rm3 | Total: 7,052,853<br>Geometrical: 7,052,853 |

<br>

These are the details for the speed test 9 model:

|Dimensions| Total active grid blocks| Total pore volume | Mesh connection statistics|
|---|---|-|-|
| X: 264<br> Y: 645<br> Z: 177<br> Size: 30,139,560 | 21,770,901 |13,563,305,518.45987 rm3 |Total: 64,533,441<br>Geometrical: 64,533,441 |

### Results on a single node

The following sections provide the performance results of running tNavigator on single-node Azure [HBv3 AMD EPYC 7V73X](/azure/virtual-machines/hbv3-series) VMs.

#### Speed test model

| VM size | Number of vCPUs used | Total elapsed time (seconds) | Relative speed increase |
|---|---|---|---|
| Standard_HB120-16rs_v3 | 8 | 643 | N/A|
| Standard_HB120-16rs_v3 | 16 | 352 | 1.82 |
| Standard_HB120-32rs_v3 | 32 | 208 | 3.09 |
| Standard_HB120-64rs_v3 | 64 | 139 | 4.62 |
| Standard_HB120-96rs_v3 | 96 | 128 | 5.05 |
| Standard_HB120-120rs_v3 | 120 | 132 | 4.87 |

The following chart shows relative speed increases as the number of vCPUs increases:

:::image type="content" source="media/speed-test-graph.png" alt-text="Graph that shows the relative speed increases as the number of vCPUs increases." lightbox="media/speed-test-graph.png" border="false":::

#### Speed test 9 model

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

#### Notes about the single-node tests

For all single-node tests, the slower time on a Standard_HB120-16rs_v3 VM with 8 cores is used as a reference to calculate the relative speed increases with respect to similar VMs that have more cores. The results presented previously show near linear computation performance improvements as the number of cores increases from 8 to 120, until the optimal configuration for a given model is reached.

### Results in a multi-node configuration

The following sections provide the performance results of running tNavigator on multi-node Azure HBv3-series VMs. The speed test model isn't suitable for testing in a multi-node environment, so tests are restricted to the speed test 9 model.

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

#### Notes about the multi-node tests

The multi-node results show that models scale linearly until the 16-node configuration is reached. This configuration provides a maximum speed increase of 3.63 times that of the single node. Testing was limited to a few iterations.

## Azure cost

Only model running time (elapsed time) is considered for these cost calculations. Application installation time isn't considered. The calculations are indicative of your potential results. The actual cost depends on the size of the model. You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your configuration.

The following tables provide elapsed times in hours. To compute the total cost, multiply by the [Azure VM hourly costs for Linux](https://azure.microsoft.com/pricing/details/virtual-machines/linux/).

### Elapsed times for the speed test model, single-node 

| Number of vCPUs | Total elapsed time (hours) |
|---|---|
| 8 | 0.17 |
| 16 | 0.09 |
| 32 | 0.05 |
| 64 | 0.03 |
| 96 | 0.03 |
| 120 | 0.03 |

### Elapsed times for the speed test 9 model, single-node

| Number of vCPUs | Total elapsed time (hours) |
|---|---|
| 8 | 5.56 |
| 16 | 3.20 |
| 32 | 1.83 |
| 64 | 1.27 |
| 96 | 1.14 |
| 120 | 1.12 |

### Elapsed times for the speed test model, multi-node

| Number of nodes* | Total elapsed time (hours) |
|---|---|
| 1 | 1.40 |
| 2 | 0.92 |
| 4 | 0.63 |
| 8 | 0.47 |
| 16 | 0.38 |

*64 cores per node.

## Summary

- tNavigator exhibits high scalability when deployed on HBv3-series VMs (AMD EPYC 7V73X Milan-X CPU cores) on Azure. To determine the scalability, the ratio of the inverse of the time it takes to solve a given model is calculated.
- To evaluate the performance, the lowest VM configuration in the series, 8 vCPUs for HBv3, is used as a baseline. The results are assessed based on the performance relative to this baseline. Higher values indicate better performance.
- For the single-node configuration on HBv3, the solution finishes approximately 1.5 times faster whenever the number of cores is doubled. Scale-up decreases as the optimal configuration is reached. Increasing the number of cores beyond the optimal configuration doesn't result in improved performance.
- For the multi-mode configuration on HBv3, implemented via CycleCloud, the solution finishes approximately 1.3 to 1.5 times faster whenever the number of nodes is doubled. Scale-up decreases as the optimal configuration is reached. 

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Aashay Anjankar](https://www.linkedin.com/in/aashay-anjankar-6a44291ba) | HPC Performance Engineer
- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Saurabh Parave](https://www.linkedin.com/in/saurabh-parave-957303162/) | HPC Performance Engineer

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
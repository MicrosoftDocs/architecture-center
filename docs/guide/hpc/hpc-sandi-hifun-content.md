This article briefly describes the steps for running [Sandi’s](https://sandi.co.in)  HiFUN application on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running HiFUN on Azure.

HiFUN is a  general purpose Computational Fluid Dynamics (CFD) software.

HiFUNis capable of simulating airflow over flying configurations, automobiles as well as structures such as buildings, ships etc. HiFUN:

- Provides robust, fast, and accurate solver providing aerodynamic design data in an attractive turnaround time.
- Employs unstructured cell center finite volume method capable of handling complex geometries and complicated flow physics in a typical industry environment.
- Handles MPI directives for parallel computing on distributed memory HPC.
- Provides the ability to scale over several thousands of processor cores
- Uses [OpenACC](https://www.openacc.org) constructs  for porting HiFUN onto NVIDIA GPUs for parallel computing using hybrid HPC platform

Sandi HiFUN is  majorly used in Aerospace, Automotive, Industrial and Wind/Turbine industries.

To test the performance of Sandi HiFUN on Azure Platform [HBv3-Series](/azure/virtual-machines/hbv3-series) virtual machines and [NC64as_T4_v3](/azure/virtual-machines/nct4-v3-series) virtual machines are deployed.

## Why deploy HiFUN on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning

## Architecture

diagram 

link 

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines). Create Linux and Windows virtual machines in seconds.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network). Use Virtual Network to create your own private network infrastructure in the cloud.

## Compute sizing and drivers

Performance tests of HiFUN on Azure used [HBv3-series](/azure/virtual-machines/hbv3-series) VMs running the Linux CentOS operating system. The following table provides details about HBv3-series VMs.

|VM size|vCPU|Memory (GiB)|	Memory bandwidth GBps|	Base CPU frequency (GHz)|All-cores frequency (GHz, peak)|Single-core frequency (GHz, peak)|	RDMA performance (Gbps)	|Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3|	120	|448|	350|	1.9|	3.0	|3.5	|200|	32|
|Standard_HB120-96rs_v3|	96|	448|	350|	1.9|	3.0	|3.5	|200	|32|
|Standard_HB120-64rs_v3	|64	|448	|350	|1.9|	3.0	|3.5|	200|	32|
|Standard_HB120-32rs_v3	|32	|448|	350	|1.9|	3.0	|3.5	|200	|32
|Standard_HB120-16rs_v3	|16|	448|	350|	1.9|	3.0	|3.5	|200|	

The performance tests of HiFUN on Azure used [Standard_NCasT4_v3](/azure/virtual-machines/nct4-v3-series) VMs running Linux CentOS operating system. The following table provides details about the VMs.

|VM size|vCPU|Memory (GiB)|	Temp storage (SSD) GiB|GPU|GPU memory: GiB|Max data disks|Max NICs / Expected network bandwidth (Mbps)|
|-|-|-|-|-|-|-|-|
|Standard_NC4as_T4_v3	|4	|28|	180|	1|	16|	8	|2 / 8000|
|Standard_NC8as_T4_v3	|8|	56|	360|	1|	16|	16|	4 / 8000|
|Standard_NC16as_T4_v3|	16|	110|	360|	1|	16|	32|	8 / 8000|
|Standard_NC64as_T4_v3|	64	|440|	2880|	4	|64|	32|	8 / 32000|

### Required drivers

To use InfiniBand, you need to enable [InfiniBand drivers](/azure/virtual-machines/workloads/hpc/enable-infiniband).

To take advantage of the GPU capabilities of [NCasT4_v3](/azure/virtual-machines/nct4-v3-series) VMs, you need to install NVIDIA GPU drivers.

## HiFUN installation

Before you install HiFUN, you need to deploy and connect a VM For information about deploying the VM and installing the drivers, see one of these articles:

- [Run a Windows VM on Azure](/azure/architecture/reference-architectures/n-tier/windows-vm)
- [Run a Linux VM on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm)
 
For Installing Sandi HiFUN on Azure Virtual Machine, Users can connect with Sandi by contacting at [sales@sandi.co.in](mailto:sales@sandi.co.in) and [info@sandi.co.in](mailto:info@sandi.co.in)

## HiFUN performance results

The Windsor model is used for this performance evaluation. The model details are shown below.

|Flow conditions||
|-|-|
|**Parameter**|	**Value**|
|Mach No.|	0.1207|
|Velocity|	40 m/s|
|Reynolds Number|	1.8 million|
|Flow Direction	|Aligned to X axis|

|**Workload**|| 
|-|-|
|Model| 	Windsor Car Body |
|No. of volumes|	7.456 million|

image 

### Performance results for HiFUN 4.1.1 on HBv3

|VM Instances|	No of iterations|	Time taken per iteration (S)|Relative Speed-up|
|-|-|-|-|
|Standard_HB120-16rs_v3	|100	|10.13|	1.00|
|Standard_HB120-32rs_v3	|100|	5.29	|1.91|
|Standard_HB120-64rs_v3	|100|	2.76|	3.67|
|Standard_HB120-96rs_v3|	100	|2.00	|5.07|
|Standard_HB120rs_v3|	100	|1.70|	5.96|

Note: In order to neglect the impact of Input/output operations per second (IOPS), average time taken from 51-60 iterations.

The following graph shows the relative speed increase of HiFUN with increase of number of CPUs

graph

Note: 16CPU is taken as a baseline to calculate the relative Speed-up.

### Performance results for HiFUN 4.1.1 on NCasT4

|Configuration|No of iterations|Time taken per iteration (S)|Accelerated Speed-up|
|-|-|-|-|
|24 CPU|	100|	7.70|	1.00|
|	1GPU	|100	|5.55	|1.39|
|	2GPU|	100	|4.07	|1.89|
|	4GPU	|100|	2.91|	2.65|
|32 CPU|	100|	5.59|	1.00|
|	1GPU|	100|	4.99|	1.12|
|	2GPU	|100	|3.59|	1.56|
|	4GPU|	100|	2.45|	2.28|
|48 CPU	|100	|4.15	|1.00|
|	1GPU|	100|	5.18|	0.80|
|	2GPU|	100	|3.32	|1.25|
|	4GPU|	100|	2.02|	2.05|

Note: In order to neglect the impact of Input/Output operations per second (IOPS), average time taken from 51-60 iterations.

The following graph shows the relative speed increase of HiFUN with increase of number of GPUs

graph 

### Additional notes about the tests

- Sandi HiFUN is successfully tested on HBv3 Series and NC64as_T4_v3Virtual Machines on Azure Cloud Platform.
- Every incremental CPU demonstrated good speed up in all different sizes of the VM and the peak performance of 5.96x is achieved with 120CPUs.
- Every incremental GPU demonstrated accelerated speed up in all 4 GPUs and the peak performance of 2.65x is achieved with 4 GPUs.

## Azure cost

Only model running time (wall clock time) is considered for these cost calculations. Application installation time isn't considered. The calculations are indicative. The actual numbers depend on the size of the model.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your configuration.

The following tables provide elapsed times in hours. To compute the total cost, multiply by the Azure VM hourly cost, which you can find [here for Windows](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing) and here for [Linux](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

### HBv3

|Azure VM Size|	No of CPUs|	Elapsed time in hours|
|-|-|-|
|Standard_HB120-16rs_v3	|16|	0.297|
|Standard_HB120-32rs_v3	|32|	0.156|
|Standard_HB120-64rs_v3	|64|	0.083|
|Standard_HB120-96rs_v3	|96	|0.061|
|Standard_HB120rs_v3	|120|	0.052|

### NC64as_T4_v3

|No of GPUs|	Elapsed time in Hours|
|-|-|
|CPU	|0.116|
|1-GPU|	0.144
|2-GPU|	0.093
|4-GPU|	0.057

## Summary
- Azure HPC comes in with its fully managed platform services and a robust architecture to run HPC workloads and applications.
- Azure HPC supports fast compute capabilities for GPU-intensive workloads.
- Azure offers robust compute services that provide unlimited scalability options for HPC applications. User can use H-series virtual machines for memory-bound applications, N-series virtual machines for graphic-intensive applications.
 
## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:
- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Kalai Selvan](https://www.linkedin.com/in/kalai-selvan-5a153358) | HPC Performance Engineer

Other contributors:
- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director, Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [High performance computing VM sizes](/azure/virtual-machines/sizes-hpc)
- [Windows virtual machines in Azure](/azure/virtual-machines/windows/overview)
- [Linux virtual machines in Azure](/azure/virtual-machines/linux/overview)
- [Virtual networks and virtual machines in Azure](/azure/virtual-network/network-overview)
- [Learning path: Run high-performance computing (HPC) applications on Azure](/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)


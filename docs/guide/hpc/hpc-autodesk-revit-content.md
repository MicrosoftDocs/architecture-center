This article briefly explains the steps for installing and running Autodesk Revit on a virtual machine (VM) in Azure. It also presents the performance results of running Revit on Azure. 

Revit helps architecture, engineering, and construction (AEC) teams create high-quality buildings and infrastructure.

Engineers use Revit to model shapes, structures, and systems in 3D with parametric accuracy and precision and to streamline documentation work. 

Revit has built-in automation for documenting design and managing deliverables. It saves, syncs, and shares model-based BIM and CAD data to connect multidisciplinary teams and workflows.

## Why deploy Revit on Azure?

- Modern and diverse compute options to align to your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Strong GPU acceleration, with increased performance as GPUs are added

## Architecture

:::image type="content" source="media/hpc-revit.png" alt-text="Diagram that shows an architecture for deploying Revit." lightbox="media/hpc-revit.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/hpc-revit.vsdx) of this architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Windows VMs and run Windows. For information about deploying the VM and installing the drivers, see [Windows VMs on Azure](../../reference-architectures/n-tier/windows-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network in the cloud.
- [Network security groups](/azure/virtual-network/network-security-groups-overview) restrict access to VMs at the subnet level.
- A public IP address allows users to access Revit via the internet. 
- A physical solid-state drive (SSD) is used for storage.

## Deploy infrastructure and install Revit

**Deploy Azure VMs.** Before you install Revit, deploy your Azure VMs. You should use a [NVadsA10_v5 series](/azure/virtual-machines/nva10v5-series) or [NCasT4_v3 series](/azure/virtual-machines/nct4-v3-series) VM to run Revit. You should use a Premium SSD managed disk and attach it to the VM.

**Create and configure the supporting infrastructure.** You need to configure a public IP address for inbound connectivity use network security groups to provide security for the subnet.

**Install NVIDIA drivers.** You need to install [NVIDIA GPU drivers](https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html) to take the advantage of the GPU capabilities of NVadsA10_v5 and NCasT4_v3 series VMs. For information about deploying VMs and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

**Download and install Revit.** After you install the NVIDIA drivers, install Revit. To install the product, log in to your [Autodesk](https://www.autodesk.com/products/revit/overview) account. Select **Revit** under **Products**. For more information, see the Autodesk support website.

## Revit performance on Azure Virtual Machines

HPC workloads require significant compute, memory, and storage resources. Understanding the performance of different VM types with the Revit application can help you select the most appropriate VM for your workload and optimize performance and cost.

We ran six test scenarios, via scripts, for Revit. The tests were run on a trial version of Revit 2022 on [NVadsA10_v5 series](/azure/virtual-machines/nva10v5-series) and [NCasT4_v3 series](/azure/virtual-machines/nct4-v3-series) Azure VMs. The results of these performance tests are presented later in this document to help you determine the right hardware for your Azure deployment.

### Model details

The [RFO Benchmark](https://www.revitforum.org/node/442015) automatic test suite is used to measure the performance of Revit on Azure Virtual Machines. Some prebuilt test scenarios are availble in the Benchmark script. We used six of these scenarios to analyze performance: 

- Graphics_Acceleration 
- Full_Expanded 
- Full_Simplified 
- Full_Standard 
- Graphics_Comparison  
- Graphics_Expanded

### Results on NVadsA10_v5

The following table shows the elapsed times in seconds for different test sets on different VM configurations of NVadsA10_v5 series.

|RFO Benchmark test names|6 vCPU (1/6th GPU)|18 vCPU (1/2 GPU)|	36 vCPU (1 GPU)|72 vCPU (2 GPU)|
|-|-|-|-|-|
|Graphics Acceleration|3,847.19|	3,366.57|	3,472.25|	3,432.98|
|Full Expanded	|13,552.75|	12,539.80|	11,590.06|	11,567.43|
|Full Simplified|	197.70|	174.49	|140.31|	137.95|
|Full Standard	|784.41	|595.08	|574.08	|536.98|
|Graphics Comparison|	205.31|	100.58	|83.22|	78.82|
|Graphics Expanded|2,824.53|	1,259.49|	921.05|	1,000.70|

Below table shows the relative speedup increase for all the test sets. Here the elapsed time for 1/6th GPU is taken as baseline. The relative increase in speed for all the GPUs with respect to 1/6th GPU is shown below.

|RFO Benchmark test names|6 vCPU (1/6th GPU)|18 vCPU (1/2 GPU)|36 vCPU (1 GPU)|	72 vCPU (2 GPU)|
|-|-|-|-|-|
|Graphics Acceleration|	1|	1.14|	1.11|	1.12|
|Full Expanded|	1|	1.08	|1.17	|1.17|
|Full Simplified|	1|	1.13|	1.41|	1.43|
|Full Standard	|1|	1.32|	1.37|	1.46|
|Graphics Comparison|	1|	2.04|	2.47|	2.60|
|Graphics Expanded	|1|	2.24	|3.07	|2.83|

This graph shows the relative speed increase for all the six test cases. A higher relative speedup is better than a lower one.

image 

### Results on NCasT4_v3 

Below table shows the Elapsed time in Seconds for different test sets

|RFO Benchmark test names|4 vCPUs<br> 1 GPU|	64 vCPUs<br> 4 GPUs|
|-|-|-|
|Full Simplified	|184.47|	193.91|
|Full Expanded|	864.42	|741.36|
|Full Standard|	17,353.97	|16,794.71|
|Graphics Acceleration|	5,534.41|	4691.55|
|Graphics Comparison	|114.25	|134.06|
|Graphics Expanded	|1,783.71	|1,632.31|

The below table shows the relative speed increase for all the test sets

|RFO Benchmark test names|4 vCPUs<br>1 GPU|	64 vCPUs<br>4 GPUs|
|-|-|-|
|Full Simplified|	1	|0.95|
|Full Expanded	|1	|1.17|
|Full Standard	|1	|1.03|
|Graphics Acceleration|	1	|1.18|
|Graphics Comparison	|1|	0.85|
|Graphics Expanded	|1|	1.09|

This graph shows the relative speed increase of all the test cases. A higher speedup is better than a lower one.

image

## Azure cost

Use the following elapsed time data to calculate the cost of running your workload. To compute the cost, multiply the total elapsed time by the hourly cost for that VM. The total elapsed time doesn’t include application installation. It only gives the total time to complete the test scenarios for all models. Because the hourly rates of VMs change, you should use the [Windows Virtual Machines Pricing to calculate the cost](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing).

|VM series|	vCPU|	# GPUs|	Total elapsed time in Hrs|
|-|-|-|-|
|NVadsA10_v5-series|6| 	1/6	|5.95 hrs|
||	18| 	1/2|	5.01 hrs|
||	36	|1|	4.66 hrs|
||	72 |	2	|4.65 hrs|
|NCasT4_v3-series|4| 	1	|7.18 hrs|
||	64|	4|	6.72 hrs|

## Summary

- We deployed and tested AUTODESK Revit Application on Azure NVadsA10_v5 and NCasT4_v3 series VMs.
- For theNVadsA10_v5-series VMs, every incremental VM configuration shows a percentage increase in speedup.  We can observe that the relative speedup increases until 1 GPU. There’s a saturation in performance with further increase in GPU sizes.
- For the NCasT4_v3-series, there was only a performance difference between 4 GPUs and 1 GPU except in two out of the six test scenarios. As a result, we recommend using a NCasT4_v3 VM with one GPU.

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

- Hari Bagudu | Senior Manager
- Gauhar Junnarkar | Principal Program Manager
- Amol Rane | HPC Performance Engineer

Other contributors:

- Mick Alberts | Technical Writer
- Guy Bursell | Director Business Strategy
- Sachin Rastogi | Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- GPU Optimized Virtual Machine Sizes
- Windows Virtual Machines on Azure
- Virtual networks and virtual machines on Azure
- Learning path: Run high-performance computing (HPC) applications on Azure

## Related resources

- Run a Windows VM on Azure
- HPC system and big-compute solutions
- HPC cluster deployed in the cloud

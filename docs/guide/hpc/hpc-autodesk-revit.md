This document briefly explains the steps to install and run Autodesk Revit application on a virtual machine (VM) in Azure and presents the performance results. Revit software helps architecture, engineering, and construction (AEC) teams create high-quality buildings and infrastructure.

Engineers uses Revit to model shapes, structures, and systems in 3D with parametric accuracy, precision, and streamline documentation work with instant revisions to plans, elevations, schedules, and section as projects change. 

Revit has built-in automation for documenting design and managing deliverables. It saves, syncs, and shares model-based BIM and CAD data to connect multidisciplinary teams and workflows. Revit is use as the data backbone of your BIM process. Develop and deploy standards, workflows, and content.

## Why deploy Revit on Azure?

- Modern and diverse compute options to align to your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Strong GPU acceleration, with increased performance as GPUs are added

## Architecture

:::image type="content" source="media/ .png" alt-text="Diagram that shows an architecture for deploying ." lightbox="media/   .png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/   .vsdx) of this architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) run a Windows operating system. For information about deploying the VM and installing the drivers, see [Windows VMs on Azure](../../reference-architectures/n-tier/windows-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) creates a private network in the cloud.
- [Network security groups](/azure/virtual-network/network-security-groups-overview) restrict access to VMs at the subnet level.
- The public IP address allows users to use the Revit application via the internet. 
- A physical solid-state drive (SSD) is used for storage.

## Deploy infrastructure and install Revit

**Deploy Azure VMs.** Before you install Revit, you need to deploy your Azure VMs. You should use a [NVadsA10_v5 series](/azure/virtual-machines/nva10v5-series) or [NCasT4_v3 series](/azure/virtual-machines/nct4-v3-series) VM for your Revit application. You should use a Premium SSD managed disk and attach it to the VM.

**Create and configure supporting infrastructure.** You also need to configure a public IP address for inbound connectivity and secure the subnet with network security groups.

**Install NVIDIA drivers.** You need to install [NVIDIA GPU drivers](https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html) to take the advantage of GPU capabilities of NVadsA10_v5 and NCasT4_v3 series VMs. To install the NVIDIA drivers, you need to connect to a VM and install the required NVIDIA drivers. For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml) or [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

**Download and install the Autodesk Revit product.** After installing the NVIDIA drivers, you need to install the Revit product. To install, you need to log into your [Autodesk](https://www.autodesk.com/products/revit/overview) account. Search for “Revit” under “products”. Download and install Revit. For more information, see the Autodesk support website. 

## Autodesk Revit performance on Azure Virtual Machines

HPC workloads require significant compute, memory, and storage resources. By understanding the performance of different VM types with the Revit application, you can select the most appropriate VM for your workload and optimize performance and cost. 

We ran six test scenarios (scripts) for the Autodesk Revit application. We ran these performance tests with Autodesk Revit 2022 trial version installed on [NVadsA10_v5 series](/azure/virtual-machines/nva10v5-series) and [NCasT4_v3 series](/azure/virtual-machines/nct4-v3-series) Azure VMs. We provided the results of these performance test below so you can determine the right hardware for your Azure deployment.

### Model Details

[RFO Benchmark](https://www.revitforum.org/node/442015) tool (automatic test suite) is used to measure performance matrix of Revit installed on Azure Virtual Machines. Some project layout models are already available in benchmark script. We used six prebuilt test scenarios in the RFO Benchmark tool to analyse performance. The names of the RFO Benchmarks tests are (1) graphics acceleration test, (2) full expanded test, (3) full simplified test, (3) full standard test, (5) graphics comparison test, and (6) graphics expanded test.

### Results on NVadsA10_v5

Below table shows the Elapsed time in Seconds for different test sets on different VM configurations of NVadsA10_v5 series.

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

### Results on NCasT4_v3 Virtual Machine

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
- Run a Linux VM on Azure
- HPC system and big-compute solutions
- HPC cluster deployed in the cloud

Intro 

## Why deploy GROMACS on Azure?

- Modern and diverse compute options to align to your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- With a 120 vCPU, performance increase of 3 to 4 times that of 16 CPUs  

## Architecture

:::image type="content" source="media/gromacs/gromacs.png" alt-text="Diagram that shows an architecture for deploying GROMACS." lightbox="media/gromacs/gromacs.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/gromacs.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Linux VM.
  - For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  -  A public IP address connects the internet to the VM.
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

Performance tests of GROMACS on Azure used [HBv3-series](/azure/virtual-machines/hbv3-series) VMs running Linux. The following table provides details.

|VM size|	vCPU |	Ram memory (GiB)|	Memory bandwidth (GBps)|	Base CPU frequency (GHz)|	All-cores frequency (GHz, peak)|	Single-core frequency (GHz, peak)|	RDMA performance (GBps)|	Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3|120|448|	350	|1.9|	3.0|	3.5|	200|	32|
|Standard_HB120-96rs_v3	|96	|448|	350	|1.9|	3.0	|3.5|	200	|32|
|Standard_HB120-64rs_v3|64	|448|	350	|1.9|	3.0	|3.5|	200	|32|
|Standard_HB120-32rs_v3	|32	|448|	350	|1.9|	3.0|	3.5|	200	|32|
|Standard_HB120-16rs_v3	|16	|448|	350	|1.9|	3.0|	3.5|	200|	32|

### Required drivers

To use the AMD CPUs on [HBv3-series](https://learn.microsoft.com/en-us/azure/virtual-machines/hbv3-series) VMs, you need to install AMD drivers.

 To use InfiniBand, you need to enable InfiniBand drivers.

## GROMACS installation

Before you install GROMACS, you need to deploy and connect a Linux VM and install the required AMD and InfiniBand drivers.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

You can download GROMACS from the [GROMACS download](https://manual.gromacs.org/documentation/current/download.html) page. For information about installing the application, see the [Installation guide](https://manual.gromacs.org/current/install-guide/index.html). 

For information about using GROMACS, see the [User guide](https://manual.gromacs.org/documentation/current/user-guide/index.html).

## GROMACS performance results

The cell and water models described later in this section were used to test GROMACS. The following table provides the details of the operating system that was used for testing.

|Operating system version|OS architecture|
|-|-|
|Ubuntu Linux 20.04|x86-64|

**Results for water-cut1.0_GMX50_bare**

:::image type="content" source="media/gromacs/water-cut.png" alt-text="Figure that shows the water-cut1.0_GMX50_bare model." border="false":::

|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|water-cut1.0_GMX50_bare|3,072,000|  16   |  291.3       | 1.00        |   
|water-cut1.0_GMX50_bare|3,072,000|    32 |  158.6       | 1.84        |         
|water-cut1.0_GMX50_bare|3,072,000|  64   |       89.7  |      3.25   |         
|water-cut1.0_GMX50_bare|3,072,000|    96 | 71.5       |         4.07|         
|water-cut1.0_GMX50_bare|3,072,000|120|66.9|4.35|

graph

**Results for water-cut1.0_bare_hbonds**

:::image type="content" source="media/gromacs/water-cut-2.png" alt-text="Figure that shows the water-cut1.0_bare_hbonds model." border="false":::

|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|water-cut1.0_bare_hbonds|3,072,000|16|290.7|1.00|
|water-cut1.0_bare_hbonds|3,072,000|32|157.1|1.85|
|water-cut1.0_bare_hbonds|3,072,000|64|90.4|3.22|
|water-cut1.0_bare_hbonds|3,072,000|96|71.6|4.06|
|water-cut1.0_bare_hbonds|3,072,000|120|67.8|4.29|

graph

**Results for rnase_bench_systems_old-allbond**

image 

|Model| Initial element atom count| Number of cores |Elapsed time (seconds)  |Relative speed increase  |  
|--|-|------|---------|---------|
|rnase_cubic|24,040|16|2.6|1.00|
|rnase_cubic|24,040|32|1.5|1.71|
|rnase_cubic|24,040|64|0.9|2.84|
|rnase_cubic|24,040|96|0.8|3.17|
|rnase_cubic|24,040|120|0.8|3.22|
|rnase_dodec|16,816|16|2.4|1.00|
|rnase_dodec|16,816|32|N/A|N/A|
|rnase_dodec|16,816|64|N/A|N/A|
|rnase_dodec|16,816|96|0.8|3.10|
|rnase_dodec|16,816|120|N/A|N/A|

graphs

**Results for rnase_bench_systems**

image

table

graph

**Results for gmxbench-3.0**

image

table

graph

**Results for ADH_bench_systems_old-allbonds**

image

table

graph

**Results for ADH_bench_systems**

image 

table

graph

### Additional notes about tests

## Azure cost
<Description of the costs that might be associated with running this workload in Azure. Make sure to have a link to the Azure pricing calculator.>
You can use the [Azure pricing calculator] to estimate the costs for your configuration.
<Show the pricing calculation or a direct link to this specific workload with the configuration(s) used.  >

## Summary
<One or two sentences or bullet points reinforcing why Azure is the right platform for this workload>

Contributors

Next steps 

Related resources
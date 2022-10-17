<Intro should cover a basic overview of the workload.>

## Why deploy WRF on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Performance that scales as CPUs are added, based on tests of a sample model

## Architecture

:::image type="content" source="media/wrf/architecture.png" alt-text="Diagram that shows an architecture for deploying WRF." lightbox="media/wrf/architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/wrf.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Linux VM. For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  - A public IP address connects the internet to the VM.
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

The performance tests of WRF used [HBv3-series](/azure/virtual-machines/hbv3-series) VMs running Linux. The following table provides details about the VMs.

|Size|vCPU|	RAM memory (GiB)|Memory bandwidth (GBps)|Base CPU frequency (GHz)|	All-cores frequency (GHz, peak)	|Single-core frequency (GHz, peak)|	RDMA performance (Gbps)|Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3	|120|	448|	350|	1.9|	3.0|	3.5|	200|	32|
|Standard_HB120-96rs_v3	|96	|448	|350	|1.9	|3.0|	3.5	|200	|32|
|Standard_HB120-64rs_v3|	64	|448|	350	|1.9|	3.0|	3.5|	200|	32|
|Standard_HB120-32rs_v3	|32	|448	|350	|1.9	|3.0	|3.5	|200	|32|
|Standard_HB120-16rs_v3|	16	|448|	350|	1.9|	3.0	|3.5|	200	|32|

HBv3-series VMs are optimized for HPC applications like fluid dynamics, explicit and implicit finite element analysis, weather modeling, seismic processing, reservoir simulation, and RTL simulation. 

### Required drivers

To use the AMD CPUs on [HBv3-series](/azure/virtual-machines/hbv3-series) VMs, you need to install AMD drivers.

To use InfiniBand, you need to enable InfiniBand drivers.

## WRF installation

Before you install WRF, you need to deploy and connect a Linux VM and install the required AMD and InfiniBand drivers.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

You can download WRF from the [WRF users page](https://www2.mmm.ucar.edu/wrf/users/download/get_source.html).

Installation steps include setting up your environment for paths and libraries and configuring and compiling WRF. For detailed compilation instructions, see [How to Compile WRF](https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php).

<Must include a sentence or two to outline the installation context along with link/s (no internal links, it must be official/accessible) to install information of the product docs for the workload solution.>
<Should not list any ordered steps of installation.> 

## WRF performance results

<Give a short intro to how performance was tested>
<Results for X>
<Results for Y etc>

### Additional notes about tests
<Include any additional notes about the testing process used.>

## Azure cost

You can use the [Azure pricing calculator] to estimate the costs for your configuration.

## Summary

- WRF is successfully deployed and tested on HB120rs_v3 series VM on Azure Platform.
- Expected meantime per step is achieved in all CPU cores.
- However, the scalability might vary depending on the dataset being used and the node count being tested. Ensure that to test the impact of the tile size, process, and threads per process before use.
This article describes the steps for running the Computational Fluid Dynamics (CFD) software [ELEMENTS](https://engys.com/products/elements) on a Virtual Machine (VM) and a HPC cluster on Azure. It also presents the performance results of ELEMENTS  while running on single-node and multi-node VM configurations. 

Elements is a CFD and optimization software solution for vehicle design applications produced by Streamline Solutions LLC, a joint venture between [ENGYS](https://engys.com) and [Auto Research Center](http://www.arcindy.com). The simulation engine delivered with this tool is powered by [HELYX](https://engys.com/products/helyx) to offer a cost-effective solution that combines the best of automotive engineering design practices with the latest and most advanced open-source CFD and optimization methods developed by Engys, all within a unified, easy-to-use platform.

ELEMENTS was widely used and validated in the production environment to solve most flow related problems encountered in automotive design, including external vehicle aerodynamics, UHTM, HVAC and cabin comfort, aeroacoustics, powertrain, ICE, water management and soiling, among others. CFD methods available in ELEMENTS have also been successfully applied beyond automotive to analyze the aerodynamics performance of other vehicles and means of transportation, such as high-speed trains, motorbikes, and competition bicycles.

- **Evaluate vehicle designs more efficiently** using a completely new ribbon-based GUI layout focused on functional design.
- **Automate external vehicle aerodynamics calculations** using a virtual wind tunnel wizard with fully configurable best simulation practices, automatic report creation, added support for rotating tires/wheels, and new ride height and frontal area calculators.
- **Solve more complex engineering problems** with improved CFD methods and tools for UHMT, HVAC, in-cabin flows and aeroacoustics, including better volume meshing, faster and more stable solvers, added support for multi-region CHT, etc.
- **Leverage on-demand computing and cloud services** with a dedicated client-server framework for working remotely via secure network connections.
- **Improved usability and productivity** through powerful open-source CFD solvers and utilities developed and maintained by Engys.

## Why deploy ELEMENTS on Azure?

- Modern and diverse compute options to meet your workload's needs.
- The flexibility of virtualization without the need to buy and maintain physical hardware.
- Rapid provisioning.
- Complex problems solved within a few hours.

## Architecture

Multi-node configuration:

image 

link 

Single-node configuration:

image

link 

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Linux and Windows VMs. 
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud. 
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VMs.  
  - A public IP address connects the internet to the VM.   
- [Azure CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud) is used to create the cluster in the multi-node configuration.
- A physical SSD is used for storage.  

## Compute sizing and drivers

Performance tests of ELEMENTS on Azure used [HBv3 AMD EPYC 7V73X](/azure/virtual-machines/hbv3-series) (Milan-X) VMs running Linux CentOS Operating system.  The following table provides details about HBv3-series VMs.

|VM size|	vCPU|	Memory (GiB)|	Memory bandwidth GBps|	Base CPU frequency (GHz)|	All-cores frequency (GHz, peak)|	Single-core frequency (GHz, peak)|	RDMA performance (Gbps)|Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3	|120	|448|	350|	1.9|	3.0|	3.5|	200|	32|
|Standard_HB120-96rs_v3|	96|	448|	350|	1.9|	3.0|	3.5|	200|	32|
|Standard_HB120-64rs_v3|	64|	448|	350|	1.9	|3.0|	3.5|	200|	32|
|Standard_HB120-32rs_v3|	32|	448|	350|	1.9|	3.0|	3.5|	200|	32|
|Standard_HB120-16rs_v3|	16	|448|	350|1.9|3.0|3.5|200|32|

### Required drivers

To use AMD CPUs on [HBv3 VMs](/azure/virtual-machines/hbv3-series), you need to install AMD drivers.

To use InfiniBand, you need to enable [InfiniBand drivers](/azure/virtual-machines/workloads/hpc/enable-infiniband).

## Install ELEMENTS 3.5.0 on a VM and HPC Cluster

The software ELEMENTS must be purchased from Engys or one of their local authorized distributors/agents to get the installation files and technical support with the application. ContactEngys if you interested in buying [ELEMENTS](https://engys.com/products/elements).

Before you install ELEMENTS, you need to deploy and connect a VM or HPC Cluster.

For information about deploying the VM and installing the drivers, see one of these articles:

- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)


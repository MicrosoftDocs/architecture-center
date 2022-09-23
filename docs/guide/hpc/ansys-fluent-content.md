Intro

## Why deploy Ansys Fluent on Azure?

- Modern and diverse compute options to align to your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Performance scales well up to 64 or 96 CPUs on a single node and linearly on multiple nodes

## Architecture

:::image type="content" source="media/ansys-fluent/ansys-fluent.png" alt-text="Diagram that shows an architecture for deploying Fluent." lightbox="media/ansys-fluent/ansys-fluent.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/ansys-fluent.vsdx) of this
architecture.*

## Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a OPERATING SYSTEM VM.
  - For information about deploying the VM and installing the drivers, see [Windows VMs on Azure](../../reference-architectures/n-tier/windows-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  -  A public IP address connects the internet to the VM.
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

Performance tests of Fluent on Azure used [HBv3-series](/azure/virtual-machines/hbv3-series) VMs running OPERATING SYSTEM. The following table provides details about HBv3-series VMs.

VM size|	vCPU|	Memory (GiB)|	Memory bandwidth GBps|	Base CPU frequency (Ghz)|	All-cores frequency (Ghz, peak)|	Single-core frequency (Ghz, peak)	|RDMA performance (Gbps)|	Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3|120|448|	350|	1.9|	3.0|	3.5|	200	|32|
|Standard_HB120-96rs_v3	|96	|448|	350	|1.9	|3.0	|3.5|	200	|32|
|Standard_HB120-64rs_v3	|64	|448|	350	|1.9	|3.0	|3.5|	200	|32|
|Standard_HB120-32rs_v3	|32	|448|	350	|1.9	|3.0	|3.5|	200	|32|
|Standard_HB120-16rs_v3	|16	|448|	350	|1.9	|3.0	|3.5|	200	|32|



### Required drivers

To use AMD CPUs on [HBv3 VMs](/azure/virtual-machines/hbv3-series), you need to install AMD drivers.

To use InfiniBand, you need to enable InfiniBand drivers.

## Fluent installation

Before you install Fluent, you need to deploy and connect a VM and install the required AMD and InfiniBand drivers.

For information about deploying the VM and installing the drivers, see one of these articles:
•	Run a Windows VM on Azure
•	Run a Linux VM on Azure

For information about installing Fluid, see the [Ansys website](https://www.ansys.com/products/fluids/ansys-fluent). 

## Fluent performance results

HBv3 VMs with different numbers of vCPUs were deployed to determine the optimal configuration for Fluent on a single node. That optimal configuration was then tested in a multi-node cluster deployment. Ansys Fluent 2021 R2 was tested.

### Results, single-node configuration

The following test cases were tested.

#### Aircraft wing test case

:::image type="content" source="media/ansys-fluent/aircraft-wing.png" alt-text="Figure that shows the aircraft wing test case." border="false":::


|Number of cells  |Cell type  |Solver  |Models  |
|---------|---------|---------|---------|
|14,000,000     | Hexahedral        |  Pressure based coupled solver, Least Squares cell based, steady       |  Realizable K-e Turbulence       |

The following table presents the test results.

|Cores|Wall-time per <br> 100 iterations <br> (seconds)|Relative speed increase|
|-|-|-|
|16	|860.67|	1.00|
|32 |569.03	|1.51	|
|64 |442.69	|1.94|
|96 |433.45	|1.99|
|120| 429.54|	2.00|

:::image type="content" source="media/ansys-fluent/aircraft-wing-graph.png" alt-text="Graph that shows the relative speed increase for the aircraft wing test case." border="false":::

#### Pump model

landing gear model

oil rig model

sedan model

combustor model 

exhaust system model 

### Results, multi-node configuration

### Additional notes about tests
<Include any additional notes about the testing process used.>

## Azure cost
<Description of the costs that might be associated with running this workload in Azure. Make sure to have a link to the Azure pricing calculator.>
You can use the Azure pricing calculator, to estimate the costs for your configuration.
<Show the pricing calculation or a direct link to this specific workload with the configuration(s) used.>

## Summary
<One or two sentences or bullet points reinforcing why Azure is the right platform for this workload>

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

-   [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) |
    Senior Manager
-   [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) |
    Principal Program Manager
-   [Vinod
    Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) |
    HPC Performance Engineer

Other contributors:

-   [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) |
    Technical Writer
-   [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director
    Business Strategy
-   [Sachin
    Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) |
    Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

-   [GPU-optimized virtual machine
    sizes](/azure/virtual-machines/sizes-gpu)
-   [Virtual machines on Azure](/azure/virtual-machines/overview)
-   [Virtual networks and virtual machines on
    Azure](/azure/virtual-network/network-overview)
-   [Learning path: Run high-performance computing (HPC) applications on
    Azure](/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

-   [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
-   [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
-   [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)

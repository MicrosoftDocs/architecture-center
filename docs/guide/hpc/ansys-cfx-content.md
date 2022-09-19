<Intro >

## Why deploy Ansys CFX on Azure?
-	Modern and diverse compute options to align to your workload's needs
-	The flexibility of virtualization without the need to buy and maintain physical hardware
-	Rapid provisioning
-	Multi-node deployment as much as 17 times faster than single-node deployment

## Architecture

:::image type="content" source="media/cfx/ansys-cfx.png" alt-text="Diagram that shows an architecture for deploying Ansys CFX." lightbox="media/cfx/ansys-cfx.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/ansys-cfx.vsdx) of this
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

Performance tests of Ansys CFX on Azure used [HBv3-series](/azure/virtual-machines/hbv3-series) VMs running Linux. The following table provides the configuration details.

|VM size|	vCPU|	Memory (GiB)	|Memory bandwidth (GBps)	|Base CPU frequency (Ghz)|	All-cores frequency (Ghz, peak)|	Single-core frequency (Ghz, peak)|	RDMA performance (Gbps)	|Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3|	120|	448|	350|	2.45|	3.1|	3.675|	200|	32|
|Standard_HB120-96rs_v3|	96|	448|	350|	2.45|	3.1|	3.675	|200|	32|
|Standard_HB120-64rs_v3	|64	|448	|350|	2.45|	3.1|	3.675|	200|	32|
|Standard_HB120-32rs_v3	|32	|448	|350|	2.45|	3.1|	3.675|	200	|32|
|Standard_HB120-16rs_v3	|16|	448	|350|	2.45|	3.1|	3.675|	200	|32|

### Required drivers

To use AMD CPUs on [HBv3 VMs](/azure/virtual-machines/hbv3-series), you need to install AMD drivers.

To use InfiniBand, you need to enable InfiniBand drivers.

## CFX installation

Before you install CFX, you need to deploy and connect a Linux VM and install the required AMD and InfiniBand drivers.

For information about deploying the VM, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

To for information about installing CFX, see the [Ansys website](https://www.ansys.com/products/fluids/ansys-cfx).  

## CFX performance results

Ansys CFX 2021 R2 was tested. 

### Results, single-node 

### Results, multi-node

Additional notes about tests
<Include any additional notes about the testing process used.>

## Azure cost
<Description of the costs that might be associated with running this workload in Azure. Make sure to have a link to the Azure pricing calculator.>
You can use the Azure pricing calculator, to estimate the costs for your configuration.
<Show the pricing calculation or a direct link to this specific workload with the configuration(s) used.>

## Summary
<One or two sentences or bullet points reinforcing why Azure is the right platform for this workload>

This article briefly describes the steps for running Altair Radioss on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running Radioss on Azure.

Radioss is a multidisciplinary finite-element solver for linear and non-linear problems.  It’s used to predict crash response, dynamic, transient-loading effects on vehicles, structures, and other products. Radioss:
- Uses battery and module macro models for crash events, road debris impacts, and shocks to simulate mechanical failures that cause electrical short circuits, thermal runaway, and risk of fire.
- Provides a composite shell element with delamination tracking and a fast parabolic tetra element.
- Implements extensive material laws and rupture criteria for crack propagation in brittle materials like windshields.
- Provides a fast solution for airbag deployment that uses finite volume method technology.

Radioss is used across industry sectors to provide multiphysics solutions to dynamic problems combining structures, mechanisms, fluids, thermal, and electromagnetic effects.

## Why deploy Radioss on Azure?

- Modern and diverse compute options to align to your workload's needs  
- The flexibility of virtualization without the need to buy and maintain physical hardware  
- Rapid provisioning  
- On a single node, performance improvements of as much as 2.76 times over that of 16 CPUs

## Architecture

This architecture shows a multi-node configuration, orchestrated with Azure CycleCloud:

:::image type="content" source="media/altair-radioss/radioss-cluster-architecture.png" alt-text="Diagram that shows a multi-node configuration for deploying Altair Radioss." lightbox="media/altair-radioss/radioss-cluster-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/radioss-cluster-architecture.vsdx) of this
architecture.*

This architecture shows a single-node configuration:

:::image type="content" source="media/altair-radioss/hpc-radioss.png" alt-text="Diagram that shows a single-node configuration for deploying Altair Radioss." lightbox="media/altair-radioss/hpc-radioss.png" border="false"::: 

*Download a [Visio file](https://arch-center.azureedge.net/hpc-radioss.vsdx) of this
architecture.*

### Components

-   [Azure Virtual
    Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create Linux VMs. 
    -   For information about deploying the VM and installing the
        drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
-   [Azure Virtual
    Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud. 
    -   [Network security
        groups](/azure/virtual-network/network-security-groups-overview)
        are used to restrict access to the VMs.  
    -   A public IP address connects the internet to the VM.   
-   [Azure
    CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud)
    is used to create the cluster in the multi-node configuration.
-   A physical SSD is used for storage.

## Compute sizing and drivers

Performance tests of Radioss on Azure used [HBv3-series](/azure/virtual-machines/hbv3-series) VMs running Linux. The following table provides the configuration details.

|VM size|vCPU|RAM memory, in GiB|MEMORY BANDWIDTH GB/S| BASE CPU FREQUENCY (GHZ)|ALL-CORES FREQUENCY (GHZ, PEAK)|SINGLE-CORE FREQUENCY (GHZ, PEAK)|RDMA PERFORMANCE (GB/S)|MAX DATA DISKS|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3|120|448|350|2.45|3.1|3.675|200|32|
|Standard_HB120-96rs_v3|96|448|350|2.45|3.1|3.675|200|32|
|Standard_HB120-64rs_v3|64|448|350|2.45|3.1|3.675|200|32|

Standard_HB120-32rs_v3

32

448

350

2.45

3.1

3.675

200

32

Standard_HB120-16rs_v3

16

448

350

2.45

3.1

3.675

200

32 

### Required drivers
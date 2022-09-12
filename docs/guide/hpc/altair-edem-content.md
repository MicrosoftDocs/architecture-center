title: Deploy Altair EDEM on an Azure virtual machine

description: Learn how Altair EDEM discrete element method (DEM)
software performs on an Azure virtual machine (VM). 

# Deploy Altair EDEM on a virtual machine

This article briefly describes the steps for running [Altair
EDEM](https://www.altair.com/edem) on a virtual machine (VM) that\'s
deployed on Azure. It also presents the performance results of running
EDEM on Azure.

EDEM is a high-performance application that's used for bulk material
simulation. EDEM uses discrete element method (DEM) to simulate and
analyze the behavior of coal, mined ores, soils, fibers, grains,
tablets, and powders. EDEM:

-   Shows crucial insight to bulk material interaction with equipment
    during a range of operation and process conditions.

-   Creates simulations of real-world materials like large rocks, fine
    powders, grains, fibers, and tablets, representing material
    behaviors like dry, sticky, and compressible.

EDEM includes three core components: EDEM Creator, Simulator, and
Analyst.

EDEM is primarily used in industries like construction, off-highway,
mining, agriculture, space exploration, and process industries.

## Why deploy EDEM on Azure?

-   Modern and diverse compute options to align to your workload\'s
    needs 

-   The flexibility of virtualization without the need to buy and
    maintain physical hardware 

-   Rapid provisioning 

-   Ability to solve simulations in a few hours with A100 GPUs

## Architecture

![Diagram Description automatically
generated](media/image1.png){width="7.751081583552056in"
height="6.021673228346457in"}

## *Download a [Visio file](https://arch-center.azureedge.net/hpc-edem.vsdx) of this architecture.*

## Components

-   [Azure Virtual
    Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create Linux and Windows VMs. 

    -   For information about deploying the VM and installing the
        drivers, see [Windows VMs on
        Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/windows-vm)
        or [Linux VMs on
        Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm).

-   [Azure Virtual
    Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud. 

    -   [Network security
        groups](https://docs.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)
        are used to restrict access to the VMs.  

    -   A public IP address connects the internet to the VM.   

-   A physical SSD is used for storage.   

## Compute sizing and drivers

# [ND A100 v4](https://docs.microsoft.com/en-us/azure/virtual-machines/nda100-v4-series) and [NCv3](https://docs.microsoft.com/en-us/azure/virtual-machines/ncv3-series) series VMs, running the Windows operating system, were used to test the performance of EDEM on Azure. The following table provides the configuration details:

  ---------------------------------------------------------------------------------
  VM size               vCPU     Memory,   Temporary   GPUs     GPU       Maximum
                                 in GiB    storage              memory,   data
                                           (SSD), in            in GiB    disks
                                           GiB                            
  --------------------- -------- --------- ----------- -------- --------- ---------
  Standard_ND96asr_v4   96       900       6,000       8 A100   40        32

  Standard_NC6s_v3      6        112       736         1 V100   16        12
  ---------------------------------------------------------------------------------

### Required drivers

To use EDEM on Standard_ND96asr_v4 VMs, you need to install NVIDIA and
AMD drivers.

To use EDEM on Standard_NC6s_v3 VMs, you need to install NVIDIA drivers.

## EDEM installation

Before you install EDEM, you need to deploy and connect a VM and install
the NVIDIA drivers. On Standard_ND96asr_v4 VMs, you need to install the
AMD drivers.

**Important:** NVIDIA Fabric Manager installation is required for VMs
that use NVLink or NVSwitch.

For information about deploying the VM and installing the drivers, see
one of these articles:

-   [Run a Windows VM on
    Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/windows-vm)

-   [Run a Linux VM on
    Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm)

To install EDEM, you need to download EDEM from Altair One Marketplace,
install License Manager, and then install EDEM. For detailed
installation instructions, see [Altair One
Marketplace](https://altairone.com/Marketplace?__hstc=142694250.005b507352b9e4107a39c334591c181a.1662053255169.1662498072969.1662503447214.4&__hssc=142694250.2.1662503447214&__hsfp=886166656).

# EDEM performance results

Seven real-world scenarios were used to test the performance of EDEM on
Azure VMs. Particle simulations were tested. Here are the details:

![Table Description automatically generated with medium
confidence](media/image2.png){width="9.240624453193352in"
height="4.295063429571304in"}

This table shows the elapsed wall-clock time needed to complete each of
the simulations, in seconds:

+---------------------+-------------+------------------+--------------+
| Model               | 96 CPUs     | 8 A100 GPUs      | V100 GPU     |
|                     |             |                  |              |
|                     |             | (ND96asr_v4)     | (NC6s_v3)    |
+=====================+=============+==================+==============+
| Angle of repose     | 12819.80    | 1543.66          | 2319.39      |
+---------------------+-------------+------------------+--------------+
| Bed of material     | 2650.56     | 320.24           | 475.04       |
+---------------------+-------------+------------------+--------------+
| Hopper discharge    | 9318.89     | 566.59           | 1030.38      |
+---------------------+-------------+------------------+--------------+
| Powder mixer        | 14028.50    | 1013.98          | 1312.27      |
+---------------------+-------------+------------------+--------------+
| Screw auger         | 8871.59     | 1295.16          | 1158.98      |
+---------------------+-------------+------------------+--------------+
| Mill                | 1339.11     | 83.18            | 116.49       |
+---------------------+-------------+------------------+--------------+
| Transfer chute      | 3859.01     | 310.22           | 437.92       |
+---------------------+-------------+------------------+--------------+

This graph shows the elapsed seconds for A100 GPUs, compared to the
results for 96 CPUs:

![Chart, bar chart Description automatically
generated](media/image3.png){width="7.892930883639545in"
height="3.4614785651793527in"}

The following table shows the relative speed increases for A100 GPUs and
the V100 GPU, as compared to 96 CPUs:

+---------------------+-------------+------------------+--------------+
| Model               | 96 CPUs     | 8 A100 GPUs      | V100 GPU     |
|                     |             |                  |              |
|                     |             | (ND96asr_v4)     | (NC6s_v3)    |
+=====================+=============+==================+==============+
| Angle of repose     | 1           | 8.30             | 5.53         |
+---------------------+-------------+------------------+--------------+
| Bed of material     | 1           | 8.28             | 5.58         |
+---------------------+-------------+------------------+--------------+
| Hopper discharge    | 1           | 16.45            | 9.04         |
+---------------------+-------------+------------------+--------------+
| Powder mixer        | 1           | 13.84            | 10.69        |
+---------------------+-------------+------------------+--------------+
| Screw auger         | 1           | 6.85             | 7.65         |
+---------------------+-------------+------------------+--------------+
| Mill                | 1           | 16.10            | 11.50        |
+---------------------+-------------+------------------+--------------+
| Transfer chute      | 1           | 12.44            | 8.81         |
+---------------------+-------------+------------------+--------------+

This graphs shows the relative speeds:

![Chart, bar chart Description automatically
generated](media/image4.png){width="8.060733814523184in"
height="4.044811898512686in"}

## Azure cost

Only rendering time is considered for these cost calculations.
Application installation time isn\'t considered.

You can use the wall-clock time presented in the following table and the
Azure hourly rate to calculate costs. For the current hourly costs,
see [Windows Virtual Machines
Pricing](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/windows/#pricing)
and [Linux Virtual Machines
Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

You can use the [Azure pricing
calculator](https://azure.microsoft.com/pricing/calculator) to estimate
the costs for your configuration.

  -----------------------------------------------------------------------
  VM size                    Model                         Wall-clock
                                                           time, in
                                                           seconds
  -------------------------- ----------------------------- --------------
  Standard_ND96asr_v4        Angle of repose               1543.66

                             Bed of material               320.244

                             Hopper discharge              566.587

                             Powder mixer                  1013.98

                             Screw auger                   1295.16

                             Mill                          83.1794

                             Transfer chute                310.224

  Standard_NC6s_v3           Angle of repose               2319.39

                             Bed of material               475.04

                             Hopper discharge              1030.38

                             Powder mixer                  1312.27

                             Screw auger                   1158.98

                             Mill                          116.49

                             Transfer chute                437.92
  -----------------------------------------------------------------------

## Summary

-   Altair EDEM was successfully tested on ND A100 v4 and NCv3 series
    VMs on Azure.

-   The highest speeds are achieved on ND96asr_v4 VMs.

-   Simulations for complex workloads are solved in a few hours on
    ND96asr_v4 VMs.

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

-   [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) \|
    Senior Manager

-   [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) \|
    Principal Program Manager

-   [Vinod
    Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) \|
    HPC Performance Engineer

Other contributors:

-   [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) \|
    Technical Writer

-   [Guy Bursell](https://www.linkedin.com/in/guybursell) \| Director
    Business Strategy

-   [Sachin
    Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) \|
    Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

-   [GPU optimized virtual machine
    sizes](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-gpu)

-   [Windows virtual machines in
    Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/overview)

-   [Linux virtual machines in
    Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/overview)

-   [Virtual networks and virtual machines in
    Azure](https://docs.microsoft.com/en-us/azure/virtual-network/network-overview)

-   [Learning path: Run high-performance computing (HPC) applications on
    Azure](https://docs.microsoft.com/en-us/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

-   [Run a Windows VM on
    Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/windows-vm)

-   [Run a Linux VM on
    Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm)

-   [HPC system and big-compute
    solutions](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/big-compute-with-azure-batch)

-   [HPC cluster deployed in the
    cloud](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/hpc-cluster)

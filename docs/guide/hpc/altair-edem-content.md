This article briefly describes the steps for running [Altair
EDEM](https://www.altair.com/edem) on a virtual machine (VM) that's
deployed on Azure. It also presents the performance results of running
EDEM on Azure.

EDEM is an application that's used for bulk and granular material simulation. EDEM uses discrete element method (DEM) to simulate and analyze the behavior of coal, mined ores, soils, fibers, grains, tablets, and powders. 

EDEM simulation provides engineers with insight into how those materials interact with equipment during a range of operation and process conditions. It can be used by itself or combined with other CAE tools.

Companies in the heavy equipment, off-road, mining, steelmaking, and process manufacturing industries use EDEM to understand and predict granular material behaviors, evaluate equipment performance, and optimize processes.

## Why deploy EDEM on Azure?

- You can use EDEM to Model particle shape by using the highly validated and computationally efficient multi-sphere method.
- EDEM is a cutting edge DEM solver, highly parallelized for use on multi-core shared memory workstations, GPU hardware, and multi-GPU systems.
- The solver engine is fully double precision across all platforms.
- EDEM can simulate large and complex particle systems.
- EDEM provides advanced post-processing capabilities.

## Architecture

:::image type="content" source="media/altair-edem/hpc-edem.svg" alt-text="Diagram that shows an architecture for deploying Altair EDEM." lightbox="media/altair-edem/hpc-edem.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/hpc-edem.vsdx) of this architecture.*

### Components

-   [Azure Virtual
    Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create Windows VMs. 
    -   For information about deploying the VM and installing the
        drivers, see [Windows VMs on Azure](../../reference-architectures/n-tier/windows-vm.yml).
-   [Azure Virtual
    Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud. 
    -   [Network security
        groups](/azure/virtual-network/network-security-groups-overview)
     restrict access to the VMs.  
    -   A public IP address connects the internet to the VM.   
-   A physical SSD provides storage.

## Compute sizing and drivers

Performance tests of EDEM on Azure used [NCv3](/azure/virtual-machines/ncv3-series), [NC A100 v4](/azure/virtual-machines/nc-a100-v4-series) and [ND A100 v4](/azure/virtual-machines/nda100-v4-series) series VMs running on Windows. The following table provides the configuration details.

|  Size|               vCPU    | Memory, in GiB |  Temporary storage (SSD), in GiB|   GPUs |    GPU  memory, in GiB     | Maximum data disks|Maximum uncached disk throughput: IOPS / MBps |Maximum NICs|
|--|--|--|--|--|--|--|-|-|
|Standard_ND96asr_v4|   96   |    900|       6,000|      8 |   40|        32|80,000 / 800|8|
|Standard_NC24ads_A100_v4|24|220|1,123|1|80|12|30,000 / 1,000|2|
|Standard_NC48ads_A100_v4|48|440|2,246|2|160|24|60,000 / 2,000|4|
|Standard_NC96ads_A100_v4|96|880|4,492|4|320|32|120,000 / 4,000|8|
|  Standard_NC6s_v3   |   6 |       112     |  736         |1    |16    |12|20,000 / 200|4|

### Required drivers

To use EDEM  on the previously listed VMs as described in this article, you need to install NVIDIA and AMD drivers.

## EDEM installation

Before you install EDEM, you need to deploy and connect a VM and install the required NVIDIA and AMD drivers.

For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).
 
To download EDEM:
1.	Sign in to [Altair one Marketplace](https://altairone.com/Marketplace?queryText=edem&app=EDEM&tab=Download).
2.	Select **EDEM** in the product list.
3.	Select the appropriate operating system and download.
4.	Download the license manager.

See the documents in [Altair one Marketplace](https://altairone.com/Marketplace?queryText=edem&app=EDEM&tab=Download) for instructions for installing EDEM.

## EDEM performance results

Seven models are used to test the performance of EDEM on
Azure VMs. The following table provides details.

| Model | Angle of repose |Bed of material  |Hopper discharge  |Powder mixer|Screw augur|Mill|Transfer chute|
|---------|---------|---------|---------|--|--|--|--|
|   Description  |Cylinder angle of repose         |  Bed of material with tillage tool      |Hopper emptying into container         |Powder mixer operation|Screw augur operation|Mill operation| Transfer chute with dynamic factory|
|     |   ![Image that shows the angle of repose model.](media/altair-edem/angle-repose.png)      |     ![Image that shows the bed of material model.](media/altair-edem/bed-material.png)    |   ![Image that shows the hopper discharge model.](media/altair-edem/hopper-discharge.png)        |![Image that shows the powder mixer model.](media/altair-edem/powder-mixer.png) |![Image that shows the screw augur model.](media/altair-edem/screw-augur.png) |![Image that shows the mill model.](media/altair-edem/mill.png) |![Image that shows the transfer chute model.](media/altair-edem/transfer-chute.png) |
|  Particle radius (m)| 0.0005 - 0.001|0.002 - 0.004 |0.003|0.0005|0.001|0.005|0.0045 - 0.009|
| Number of spheres    | 3        |3         |3         |1|1|1|3|
|   Size distribution  |Random         |Random         |Fixed|Fixed |    Fixed|Fixed|Random
| Number of particles    |  1,000,000 |  1,000,000 | 1,000,000 | 1,000,000| 1,000,000| 1,000,000| 1,000,000|
|  Physics|Hertz-Mindlin  |Hertz-Mindlin with JKR |Hertz-Mindlin  |Hertz-Mindlin|Hertz-Mindlin|Hertz-Mindlin|Hertz-Mindlin with JKR|
|Time steps|5.73E-06 |5.00E-05 |4.00E-05 |9.20E-06|1.40E-05|0.00016|5.97E-05|
| Total time |   0.5 | 1 |1 |1|1 |1|1 |
|Save interval |0.1|0.1|0.1  |0.1 |0.1 |0.1 |0.1|
| Grid cell size (x Rmin)| 3|3|3|3| 3 |3 |5|
| Factory |No|No| No|No|No|No|Yes|
|  Periodic boundaries   |No|No| No|No|No|No|No|

### Results for EDEM 2021.1 on NDv4 and NCv3 VMs

The following table shows the elapsed wall-clock times, in seconds, required to complete each simulation.

| Model               |ND96asr_v4, 96 CPUs     | ND96asr_v4, 1 A100 GPU | NC6s_v3, 1 V100 GPU   |
|     --               |--         |--          |--    |
| Angle of repose     | 12,819.80    | 1,543.66          | 2,319.39      |
| Bed of material     | 2,650.56     | 320.24           | 475.04       |
| Hopper discharge    | 9,318.89     | 566.59           | 1,030.38      |
| Powder mixer        | 14,028.50    | 1,013.98          | 1,312.27      |
| Screw auger         | 8,871.59     | 1,295.16          | 1,158.98      |
| Mill                | 1,339.11     | 83.18            | 116.49       |
| Transfer chute      | 3,859.01     | 310.22           | 437.92       |

The following graph uses a Standard_ND96asr_v4, 96 vCPU VM as a baseline and shows how much the speed increases on A100 and V100 GPU VMs. 

:::image type="content" source="media/altair-edem/2021-ndv4-ncv3.png" alt-text="Graph that shows relative speed increases on NCv4 and NCv3 VMs." lightbox="media/altair-edem/2021-ndv4-ncv3.png" border="false":::


### Results for EDEM 2022.1 on NC A100 v4 VMs 

The following table shows the elapsed wall-clock times, in seconds, required to complete each simulation.

| Model| NC24ads_A100_v4, 24 vCPUs| NC24ads_A100_v4,	1 GPUs| NC48ads_A100_v4, 2 GPU|NC96ads_A100_v4, 4 GPUs |
|-|-|-|-|-|
|Angle of repose|22,950.80|649.59|404.05|	339.38|
|Bed of material|	4,835.23	|140.10	|87.67|	72.11|
|Hopper cischarge|	11,457.00|	301.33	|187.68	|144.45|
|Powder mixer|	13,906.20	|606.43	|394.99	|361.85|
|Screw auger|	11,089.00	|536.27|	343.75|	278.92|
|Mill	|1,141.65|	46.33	|34.26	|28.49|
|Transfer chute|	4,146.64|	117.67|	77.98|	63.80|

 The following graph uses a Standard_NC24ads_A100_v4, 24-vCPU VM as a baseline and shows how much the speed increases on VMs with varying numbers of A100 GPUs.

:::image type="content" source="media/altair-edem/2022-nc-a100.png" alt-text="Graph that shows relative speed increases on NC A100 v4 VMs." lightbox="media/altair-edem/2022-nc-a100.png" border="false":::

### Results for EDEM 2022.1 on ND A100 v4 VMs

The following table shows the elapsed wall-clock times, in seconds, required to complete each simulation.

| Model| NC24ads_A100_v4, 24 vCPUs|ND96asr_v4, 1 GPU	|ND96asr_v4, 2 GPUs | ND96asr_v4, 3 GPUs| ND96asr_v4, 4 GPUs|
|-|-|-|-|-|-|
|Angle of repose|22,950.80|682.66 |517.99|	491.00|494.08|
|Bed of material|	4,835.23	| 148.17	|106.42|93.42|98.30	|
|Hopper discharge|	11,457.00|316.62	 	|236.32	|204.62|189.02|
|Powder mixer|	13,906.20	|646.77 	|477.97|463.59|	477.86|
|Screw auger|	11,089.00	|566.37 |408.32	|	378.17	|341.56|
|Mill	|1,141.65|51.79	 | 41.29	|39.93	|35.96|
|Transfer chute|	4,146.64|126.46	 |90.54|85.01	|81.35|

The following graph uses a Standard_NC24ads_A100_v4, 24-vCPU VM as a baseline and shows how much the speed increases on ND96asr_v4 VMs with varying numbers of A100 GPUs.

:::image type="content" source="media/altair-edem/2022-nd-a100.png" alt-text="Graph that shows relative speed increases on ND A100 v4 VMs." lightbox="media/altair-edem/2022-nd-a100.png" border="false":::

## Azure cost

Only model running time (wall clock time) is considered for these cost calculations. Application installation time isn't considered. The calculations are indicative. The actual numbers depend on the size of the model.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your configuration.

The following tables provide elapsed times in hours. To compute the total costs, multiply by the Azure VM hourly cost. For the current hourly costs, see [Windows Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing).

### EDEM 2021.1 costs on ND96asr_v4 VMs

|Model |ND96asr_v4, 96 vCPUs|	ND96asr_v4, 1 GPU|
|-|-|-|
|Angle of repose|	3.56|	0.43|
|Bed of material|	0.74|	0.09|
|Hopper discharge|	2.59|	0.16|
|Powder mixer	|3.90	|0.28|
|Screw auger|	2.46|	0.36|
|Mill	|0.37|	0.02|
|Transfer chute	|1.07|	0.09|
 
### EDEM 2021.1 costs on NCv3 VMs

|Model |NC6s_v3, 1 GPU |	
|-|-|
|Angle of repose|0.64	|
|Bed of material|0.13	|
|Hopper cischarge|0.29	|
|Powder mixer	|0.36	|
|Screw auger|0.32	|	
|Mill	|0.03|	
|Transfer chute	|0.12|	

### EDEM 2022.1 costs on NC A100 v4 VMs

|Model |NC24ads_A100_v4, 24 vCPUs|NC24ads_A100_v4, 1 GPU|	NC24ads_A100_v4, 2 GPUs|NC24ads_A100_v4, 4 GPUs|
|-|-|-|-|-|
|Angle of pepose|	6.38|	0.18	|0.11|	0.09|
|Bed of material|	1.34|	0.04	|0.02	|0.02|
|Hopper discharge|	3.18|	0.08	|0.05|	0.04|
|Powder mixer|	3.86	|0.17|	0.11|	0.10|
|Screw auger|	3.08|	0.15|	0.10	|0.08|
|Mill	|0.32	|0.01|	0.01	|0.01|
|Transfer chute|	1.15|	0.03|	0.02	|0.02| 

### EDEM 2022.1 costs on ND96asr_v4 VMs

|Model| ND96asr_v4, 1 GPU|ND96asr_v4, 2 GPUs|ND96asr_v4, 3 GPUs|ND96asr_v4, 4 GPUs|
|-|-|-|-|-|
|Angle of repose|	0.19|	0.14|	0.14|	0.14|
|Bed of material	|0.04|	0.03|	0.03|	0.03|
|Hopper discharge|	0.09|	0.07|	0.06|	0.05|
|Powder mixer	|0.18	|0.13	|0.13|	0.13|
|Screw auger|	0.16	|0.11	|0.11|	0.09|
|Mill	|0.01	|0.01	|0.01	|0.01|
|Transfer chute|	0.04|	0.03|	0.02|	0.02|

## Summary

- EDEM 2021.1 was deployed and tested on ND A100 v4 and NCv3 VMs with one GPU. EDEM 2022.1 was deployed and tested on ND A100 v4 and NC A100 v4 VMs with multiple GPUs.
-	The GPU technology in EDEM provides faster processing than CPU configurations on Azure. Tests demonstrate speed increases of about 80x with NC A100 v4 A100 GPUs and about 60x with ND A100 v4 A100 GPUs.
-	The complexity of the model affects GPU scale-up. 
-	The NC A100 v4 VM demonstrates better GPU acceleration than other VM configurations on Azure.

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

-   [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) |
    Senior Manager
-   [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) |
    Principal Program Manager
- [Saurabh Parave](https://www.linkedin.com/in/saurabh-parave-957303162/) | HPC Performance Engineer
- Kalai Selvan | HPC Performance Engineer

Other contributors:

-   [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) |
    Technical Writer
-   [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director of
    Business Strategy
-   [Sachin
    Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) |
    Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

-   [GPU-optimized virtual machine
    sizes](/azure/virtual-machines/sizes-gpu)
-   [Windows virtual machines on
    Azure](/azure/virtual-machines/windows/overview)
-   [Virtual networks and virtual machines on
    Azure](/azure/virtual-network/network-overview)
-   [Learning path: Run HPC applications on
    Azure](/training/paths/run-high-performance-computing-applications-azure)

## Related resources

-   [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
-   [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
-   [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)

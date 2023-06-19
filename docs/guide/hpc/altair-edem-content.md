This article briefly describes the steps for running [Altair
EDEM](https://www.altair.com/edem) on a virtual machine (VM) that\'s
deployed on Azure. It also presents the performance results of running
EDEM on Azure.

EDEM is high-performance software for bulk and granular material simulation. Powered by DEM, EDEM quickly and accurately simulates and analyzes the behavior of coal, mined ores, soils, fibers, grains, tablets, powders, and more.

EDEM simulation provides engineers with crucial insight into how those materials will interact with their equipment during a range of operation and process conditions. It can be used stand-alone or combined with other CAE tools.

Leading companies in the heavy equipment, off-road, mining, steelmaking, and process manufacturing industries use EDEM to understand and predict granular material behaviors, evaluate equipment performance, and optimize processes.

## Why deploy EDEM on Azure?

- Model particle shape using the highly validated and computationally efficient multi-sphere method.
- Cutting edge DEM solver, highly parallelized for use on multi-core shared memory workstations, GPU hardware, and multi-GPU systems.
- Solver engine is fully double precision across all platforms.
- Simulate large and complex particle systems.
- Advanced and powerful post-processing capability

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
        are used to restrict access to the VMs.  
    -   A public IP address connects the internet to the VM.   
-   A physical SSD is used for storage.   

## Compute sizing and drivers

Performance tests of Altair EDEM on Azure used [NCv3-series], [NC A100 v4-series] and [ND A100 v4-series] VMs running on Windows. The following table provides the configuration details.

|  Size|               vCPU    | Memory, in GiB |  Temporary storage (SSD), in GiB|   GPUs |    GPU  memory, in GiB     | Maximum data disks|Max uncached disk throughput: IOPS / MBps |Max network bandwidth|Max NICs|
|--|--|--|--|--|--|--|-|-|-|
|Standard_ND96asr_v4|   96   |    900|       6,000|      8 A100 40 GB GPUs (NVLink 3.0)|   40|        32|80,000 / 800|24,000 Mbps|8|
|Standard_NC24ads_A100_v4|24|220|1123|1|80|12|30000/1000|20,000|2|
|Standard_NC48ads_A100_v4|48|440|2246|2|160|24|60000/2000|40,000|4|
|Standard_NC96ads_A100_v4|96|880|4492|4|320|32|120000/4000|80,000|8|
|  Standard_NC6s_v3   |   6 |       112     |  736         |1    |16        |12|20000/200||4|

### Required drivers

To use Altair EDEM  on the above mentioned VMs as described in this article, you need to install NVIDIA and AMD drivers.

## EDEM installation

Before you install EDEM, you need to deploy and connect a VM and install the required NVIDIA and AMD drivers.

For information about deploying the VM and installing the drivers, see one of these articles:

- [Run a Windows VM on Azure]
 
To download EDEM:
1.	Open Altair one Marketplace in web browser and sign in
2.	Select EDEM in the product list.
3.	Select appropriate operating system and download.
4.	Download the license manager.

See the documents in [Altair one Marketplace](https://altairone.com/Marketplace?queryText=edem&app=EDEM&tab=Download) for instructions for installing EDEM.

## Performance results of EDEM on an Azure VM
### EDEM performance results

Seven models were used to test the performance of EDEM on
Azure VMs. The following table provides the details.

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

### Performance results for EDEM v2021.1  on NDv4 & NCv3 Series VMs

The following table shows the elapsed wall-clock time required to complete each of
the simulations, in seconds.

| Model               | ND96asr_v4  VM <br>96 CPUs     | ND96asr_v4 VM <br>A100 GPU (1GPU) | NC6s_v3 VM<br> V100 GPU (1GPU)   |
|     --               |--         |--                  |--              |
| Angle of repose     | 12819.80    | 1543.66          | 2319.39      |
| Bed of material     | 2650.56     | 320.24           | 475.04       |
| Hopper discharge    | 9318.89     | 566.59           | 1030.38      |
| Powder mixer        | 14028.50    | 1013.98          | 1312.27      |
| Screw auger         | 8871.59     | 1295.16          | 1158.98      |
| Mill                | 1339.11     | 83.18            | 116.49       |
| Transfer chute      | 3859.01     | 310.22           | 437.92       |

Note: The Standard_ND96asr_v4, 96 vCPU VM size wall clock time is used as the baseline for calculating relative speed for A100 and V100 GPU wall clock time as shown in the table below. 

image

### Performance results for EDEM v2022.1  on NC A100 v4 Series VMs 

Wall clock time in seconds:

| Model| 24 vCPU<br> NC24ads_A100_v4|1 GPU <br> NC24ads_A100_v4	|2 GPU<br> NC48ads_A100_v4|4 GPU <br>NC96ads_A100_v4|
|-|-|-|-|-|
|Angle of Repose|22950.80|649.59|404.05|	339.38|
|Bed of Material|	4835.23	|140.10	|87.67|	72.11|
|Hopper Discharge|	11457.00|	301.33	|187.68	|144.45|
|Powder Mixer|	13906.20	|606.43	|394.99	|361.85|
|Screw Auger|	11089.00	|536.27|	343.75|	278.92|
|Mill	|1141.65|	46.33	|34.26	|28.49|
|Transfer Chute|	4146.64|	117.67|	77.98|	63.80|


Note: The Standard_ NC24ads_A100_v4, 24 vCPU wall clock time is used as the baseline for calculating the relative speed for A100 GPUs wall clock time as shown in the table below.

image 

### Performance results for EDEM v2022.1 in ND A100 v4 Series VM

Wall clock time in seconds:

| Model| 24 vCPU<br> NC24ads_A100_v4|1 GPU <br> ND96asr_v4 	|2 GPU<br> ND96asr_v4 |3 GPU <br>ND96asr_v4|4 GPU <br>ND96asr_v4|
|-|-|-|-|-|-|
|Angle of Repose|22950.80|682.66 |517.99|	491.00|494.08|
|Bed of Material|	4835.23	| 148.17	|106.42|93.42|98.30	|
|Hopper Discharge|	11457.00|316.62	 	|236.32	|204.62|189.02|
|Powder Mixer|	13906.20	|646.77 	|477.97|463.59|	477.86|
|Screw Auger|	11089.00	|566.37 |408.32	|	378.17	|341.56|
|Mill	|1141.65|51.79	 | 41.29	|39.93	|35.96|
|Transfer Chute|	4146.64|126.46	 |90.54|85.01	|81.35|

Note: Standard_ NC24ads_A100_v4, 24 vCPU wall clock time is used as baseline for calculating relative speed for ND96asr_v4 A100 GPUs wall clock time as shown in the table below..

graph 

## Azure cost

Only model running time (wall clock time) is considered for these cost calculations. Application installation time isn't considered. The calculations are indicative. The actual numbers depend on the size of the model.

You can use the [Azure pricing calculator] to estimate costs for your configuration.

The following tables provide elapsed times in hours. To compute the total cost, multiply by the Azure VM hourly cost, which you can find [here for Windows] and .

### EDEM cost on Standard_ND96asr_v4 VM Series

|Model |ND96asr_v4 <br>96 vCPU|	ND96asr_v4<br> 1 GPU|
|-|-|-|
|Angle of Repose|	3.56|	0.43|
|Bed of Material|	0.74|	0.09|
|Hopper Discharge|	2.59|	0.16|
|Powder Mixer	|3.90	|0.28|
|Screw Auger|	2.46|	0.36|
|Mill	|0.37|	0.02|
|Transfer Chute	|1.07|	0.09|
 

### EDEM v2021.1 cost on NCv3-series

|Model |NC6s_v3 <br>1 GPU |	
|-|-|
|Angle of Repose|0.64	|
|Bed of Material|0.13	|
|Hopper Discharge|0.29	|
|Powder Mixer	|0.36	|
|Screw Auger|0.32	|	
|Mill	|0.03|	
|Transfer Chute	|0.12|	

### EDEM v2022.1 cost on NC A100 v4-series

|Model |NC24ads_A100_v4 24 vCPU|NC24ads_A100_v4 1 GPU|	NC24ads_A100_v4 2 GPU|NC24ads_A100_v4 4 GPU|
|-|-|-|-|-|
|Angle of Repose|	6.38|	0.18	|0.11|	0.09|
|Bed of Material|	1.34|	0.04	|0.02	|0.02|
|Hopper Discharge|	3.18|	0.08	|0.05|	0.04|
|Powder Mixer|	3.86	|0.17|	0.11|	0.10|
|Screw Auger|	3.08|	0.15|	0.10	|0.08|
|Mill	|0.32	|0.01|	0.01	|0.01|
|Transfer Chute|	1.15|	0.03|	0.02	|0.02| 

### EDEM v2022.1 cost on Standard_ND96asr_v4

|Model| ND96asr_v4 1 GPU|ND96asr_v4 2 GPU|ND96asr_v4 3 GPU|ND96asr_v4 4 GPU|
|-|-|-|-|-|
|Angle of Repose|	0.19|	0.14|	0.14|	0.14|
|Bed of Material	|0.04|	0.03|	0.03|	0.03|
|Hopper Discharge|	0.09|	0.07|	0.06|	0.05|
|Powder Mixer	|0.18	|0.13	|0.13|	0.13|
|Screw Auger|	0.16	|0.11	|0.11|	0.09|
|Mill	|0.01	|0.01	|0.01	|0.01|
|Transfer Chute|	0.04|	0.03|	0.02|	0.02|


## Summary

-	We deployed and tested Altair EDEM v2021.1 on the ND A100 v4 VM and NCv3 VM with 1GPU. We also deployed and tested EDEM v2022.1 on ND A100 v4 and NC A100 v4 VMs with multi-GPUs
-	The GPU technology in EDEM provides increased processing power when compared to CPU runs on Azure. We can observe around 80x speedup with NC A100 v4 A100 GPUs and around 60x with ND A100 v4 A100 GPUs.
-	The model complexity affected the GPU scale-up. .
-	The NC A100 v4 demonstrated the best GPU acceleration compared to other configuration of VM in Azure.

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

-   [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) |
    Senior Manager
-   [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) |
    Principal Program Manager
- [Saurabh Parave](https://www.linkedin.com/in/saurabh-parave-957303162/) | HPC Performance Engineer
- [Kalai Selvan](https://www.linkedin.com/in/kalai-selvan-5a153358/) | HPC Performance Engineer


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

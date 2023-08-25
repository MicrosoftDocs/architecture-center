This article briefly describes the steps for running CPFD's [Barracuda Virtual Reactor](https://cpfd-software.com) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running Virtual Reactor on Azure.

Virtual Reactor simulates the 3D transient behavior in fluid-particle systems, including multiphase hydrodynamics, heat balance, and chemical reactions. 

Virtual Reactor has these capabilities:

- Uses the Lagrangian formula for the particulate phase, which allows inclusion of discrete particle properties, including the particle size distribution (PSD), composition, temperature, residence time, and history.
- Provides directional particle filtering through baffles and a GUI.

Barracuda is most widely used in the oil refining, petrochemical, energy, and minerals processing industries, including the clean energy sector in the production of electricity, gas, and liquid fuels from coal and biomass.

## Why deploy Barracuda Virtual Reactor on Azure?

- Modern and diverse compute options to align to your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- For simulations with high particle counts, impressive scaling as GPUs are added

## Architecture

:::image type="content" source="media/barracuda-virtual-reactor/barracuda-virtual-reactor.svg" alt-text="Diagram that shows an architecture for deploying Virtual Reactor." lightbox="media/barracuda-virtual-reactor/barracuda-virtual-reactor.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/barracuda-virtual-reactor.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is
    used to create a Linux VM. For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is
    used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  -  A public IP address connects the internet to the VM.
- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

Performance tests of Barracuda Virtual Reactor on Azure used [ND A100_v4](/azure/virtual-machines/nda100-v4-series), [NCv3](/azure/virtual-machines/ncv3-series), and [NCasT4_v3](/azure/virtual-machines/nct4-v3-series) series VMs running Linux. The following table provides details.

|VM size|vCPU|	Memory (GiB)|	SSD (GiB)|GPU|GPU memory (GiB)|Maximum data disks|
|-|-|-|-|-|-|-|
|Standard_ND96asr_v4|	96|	900	|6,000|	8 A100|	40|	32|
|Standard_NC24s_v3	|24	|448	|2,948|	4 V100	|64|32|
|Standard_NC64as_T4_v3|	64|	440	|2,880|	4 T4	|64|	32|

### Required drivers

To take advantage of the GPU capabilities of [ND A100_v4](/azure/virtual-machines/nda100-v4-series), [NCv3](/azure/virtual-machines/ncv3-series), and [NCasT4_v3](/azure/virtual-machines/nct4-v3-series) series VMs, you need to install NVIDIA GPU drivers.

To use AMD processors on [ND A100_v4](/azure/virtual-machines/nda100-v4-series) and [NCasT4_v3](/azure/virtual-machines/nct4-v3-series) series VMs, you need to install AMD drivers.

## Barracuda Virtual Reactor installation

Before you install Virtual Reactor, you need to deploy and connect a Linux VM and install the required NVIDIA and AMD drivers.

> [!IMPORTANT]
> NVIDIA Fabric Manager installation is required for VMs that use NVLink or NVSwitch. NDv4 series VMs use NVLink.

For information about deploying the VM and installing the drivers, see [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml).

You can install Virtual Reactor from the [CPFD Downloads page](https://cpfd-software.com/downloads). For information about the installation process, see [CPFD customer support](https://cpfd-software.com/login/?returnUrl=/user-manual/installation.html).

## Virtual Reactor performance results

Particle-based fluid dynamics simulations were run to test Virtual Reactor. The following table provides details about the operating system and NVIDIA drivers that were used.

|Operating system version|OS architecture|GPU driver version|Cuda version|
|-|-|-|-|
|CentOS Linux release 8.1.1911 (Core)|	x86-64|	470.57.02|11.4	|

A number of test cases were run. The following table provides details.

|Test case number|	Cell count|	Number of particles	|Chemistry|	Thermal|	P1 model|
|-|-|-|-|-|-|
|479|	243,267|	29,920,300|	Enabled|	Enabled|	Disabled|
|499|	243,267|	3,581,140	|Enabled	|Enabled|	Disabled|
|480|	105,157|	40,581,300|	Disabled|	Disabled|	Disabled|
|500|	105,157|	9,528,670	|Disabled	|Disabled|	Disabled|
|481|	389,320|	50,170,500|	Enabled	|Enabled|	Disabled|
|501|	389,320|	12,994,400|	Enabled|	Enabled|	Disabled|
|482|	821,781|	55,070,200|	Enabled	|Enabled|	Disabled|
|502|	821,781|	22,625,700|	Enabled	|Enabled|	Disabled|

### Results on NDv4 

Results are presented in seconds. 

|Test case number|	479|	480|	481|	482|	499|	500|	501|	502|
|-|-|-|-|-|-|-|-|--|
|CPU	|422.55	|755.8	|755.8|	1,258.1	|92.92|	222.81|	594.3	|601.59|
|1 GPU<sup>1|	2.92	|12.7	|12.7	|13.8	|1.453	|2.63	|9.57|	6.59|
|2 GPU<sup>1|	2.85	|7.4|	7.4	|7.4|	1.358|	1.8	|6.38|	4.57|
|3 GPU<sup>1|	2.68|	5.4	|5.4|	6.1|	1.629|	1.61|	5.65|	4.49|
|4 GPU<sup>1|	3.35|	4.6	|4.6|	7.8	|1.845|	1.71	|5.41|	4.44|
|5 GPU<sup>1|	3.35|	4.5	|4.5|	8|	2.189|	1.83|	5.86|	5.39|
|6 GPU<sup>1|	3.67|	4.8	|4.8|	8|	2.908	|2.36|	6.21|	6.46|
|7 GPU<sup>1|	4.17|	4.6	|4.6|	9.6	|3.433|	2.69|	8.56|	6.63|
|8 GPU|	4.62|	4.6	|4.6|	9	|3.971|	3.01|	8.12|	7.93|

The following table and graph show speed increases, in seconds of chemical reaction completed per day, for each configuration.

|Test case number|	479|	480|	481|	482|	499|	500|	501|	502|
|-|-|-|-|-|-|-|-|--|
|CPU|	1.84	|1.03|	0.49|	0.62|	7.44	|3.49|	1.31	|1.29|
|1 GPU<sup>1|	172.10|	61.10|	29.37|	56.11|	475.84|	295.82|	81.31	|118.05|
|2 GPU<sup>1|	266.81|	104.80|	52.80|	96.60|	509.10|	433.26|	81.31	|170.29|
|3 GPU<sup>1|	272.85|	145.75|	68.53|	105.11|	424.87	|482.75|	137.87|	173.19|
|4 GPU<sup>1|	290.68|	168.87|	75.92|	126.11|	375.23	|454.95	|144.20	|175.39|
|5 GPU<sup>1|	232.16|	162.10|	77.81|	99.79	|316.32|	426.85|	132.83|	144.44|
|6 GPU<sup>1|	211.66|	172.31|	79.69|	96.47|	238.60|	329.83|	125.22|	120.73|
|7 GPU<sup>1|	186.82|	163.73|	71.68|	81.18|	201.66|	289.21|	101.61|	117.47|
|8 GPU|	168.21|	171.39|	78.23|	85.89|	174.89|	258.41|	96.02|	98.20|

*1. In these cases, the number of GPUs was artificially limited. This VM has eight GPUs.*

:::image type="content" source="media/barracuda-virtual-reactor/increase-ndv4.png" alt-text="Graph that shows the speed increase on an NDv4 VM." border="false":::

These graphs provide comparisons of models that are similar but have different particle counts:

:::image type="content" source="media/barracuda-virtual-reactor/ndv4-comparisons.png" alt-text="Graphs that provide comparisons for similar models on NDv4." border="false":::

### Results on NCv3

Results are presented in seconds.

|Test case number|	479|	480|	481|	482|	499|	500|	501|	502|
|-|-|-|-|-|-|-|-|--|
CPU	|595.68	|1,146.1|	5,327.5|	1,768.7|	113.751|	335.73|	772.93|	678.59|
|1 GPU<sup>2	|8.8|	55|	216.3|	183.2|	2.17|	5.19|	17.2|	12.88|
|2 GPU<sup>2	|8.03|	12.5	|49.9|	22.7|	5.217|	5.2|	24.37	|13.8|
|3 GPU<sup>2	|8.06|	10.1	|46	|20.8|	5.708	|4.31|	29.68	|12.88|
|4 GPU|	8.07|	9.5|	67.1|	19.1|	6.61|	4.84	|35.98|	13.93|

The following table and graph show speed increases, in seconds of chemical reaction completed per day, for each configuration.

|Test case number|	479|	480|	481|	482|	499|	500|	501|	502|
|-|-|-|-|-|-|-|-|--|
|CPU|1.31|0.68|0.24|0.44|6.08|2.32|1.01|1.15|
|1 GPU<sup>2|91.28|14.14|3.60|4.25|317.20|149.69|45.20|60.38|
|2 GPU<sup>2|96.82|61.91|17.18|34.33|132.88|149.65|32.40|56.41|
|3 GPU<sup>2|96.62|76.89|18.84|37.51|122.35|180.74|27.03|60.45|
|4 GPU|96.45|82.22|12.13|40.68|105.15|160.74|24.38|55.87|

*2. In these cases, the number of GPUs was artificially limited. NCv3 VMs are available with one, two, or four GPUs.*

:::image type="content" source="media/barracuda-virtual-reactor/increase-ncv3.png" alt-text="Graph that shows the speed increase on an NCv3 VM." border="false":::

These graphs provide comparisons of models that are similar but have different particle counts:

:::image type="content" source="media/barracuda-virtual-reactor/comparison-ncv3.png" alt-text="Graphs that provide comparisons for similar models on NCv3." border="false":::

### Results on NCasT4_v3

Results are presented in seconds.

|Test case number|	479|	480|	481|	482|	499|	500|	501|	502|
|-|-|-|-|-|-|-|-|--|
|CPU	|439.31|	789.6|	1,673.1	|1,266.5|	96.427	|251.59|	609.31	|609.34|
|1 GPU<sup>3|	28.31|	87.1|	295.1|	238	|6.37	|9.9	|49.15|	39.5|
|2 GPU<sup>3|	16.82|	29.9|	163.6|	50.7|	7.271|	7.95	|87.51|	27.47|
|3 GPU<sup>3|	14.17|	21.7|	258.2|	45.2|	7.47|	7.72	|127.32|	24.21|
|4 GPU|	12.73|	18|	351.1	|35.4|	8.025|	7.72|	128.35|	22.34|

The following table and graph show speed increases, in seconds of chemical reaction completed per day, for each configuration.

|Test case number|	479|	480|	481|	482|	499|	500|	501|	502|
|-|-|-|-|-|-|-|-|--|
|CPU|	1.77|	0.98|	0.47|	0.61|	7.17|	3.09	|1.28|	1.28|
|1 GPU<sup>3|	27.50|	8.93|	2.64|	3.27|	108.69|	52.73	|15.82|	19.69|
|2 GPU<sup>3|	46.23|	26.00|	5.08|	15.32|	95.26	|78.55	|9.19	|28.30|
|3 GPU<sup>3|	54.90|	35.83|	17.21|	17.21|	92.92	|97.88	|6.12	|32.16|
|4 GPU|	61.07|	43.13|	21.95|	21.95|	86.39	|100.70|	6.07|	34.86|

*3. In these cases, the number of GPUs was artificially limited.  NCasT4_v3 VMs are available with one or four GPUs.*

:::image type="content" source="media/barracuda-virtual-reactor/increase-ncast4.png" alt-text="Graph that shows the speed increase on an NCasT4_v3 VM." border="false":::

These graphs provide comparisons of models that are similar but have different particle counts:

:::image type="content" source="media/barracuda-virtual-reactor/comparison-ncast4.png" alt-text="Graphs that provide comparisons for similar models on NCasT4_v3."  border="false":::

## Azure cost

The following tables present wall-clock times that you can use to calculate Azure costs. You can multiply the times presented here by the Azure hourly rates for NDA100v4, NCsv3, and NCas_T4_v3 series VMs to calculate costs. For the current hourly costs, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

The times presented in the following tables represent the total elapsed time for running all eight of the tests described earlier in this document. Only the wall-clock time for running the test cases is considered for these cost calculations. Application installation time isn't considered. The times presented are indicative. The actual times depend on the size of the simulation. The elapsed times for full production-level test cases are higher than the results presented here, so the associated costs are higher.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

### Cost for ND96asr_v4

|	CPU/GPU|	Elapsed time (hours)|
|-|-|
|	CPU|	1.31|
|	8 GPU|	0.01|

### Cost for NC24s_v3

|	CPU/GPU|	Elapsed time (hours)|
|-|-|
|CPU|2.98|
|1 GPU|0.14|
|2 GPU| 0.04|
|4 GPU|0.05|

### Cost for NC64as_T4_v3

|	CPU/GPU|	Elapsed time (hours)|
|-|-|
|CPU|1.59|
|1 GPU|0.21|
|4 GPU|0.16|

## Summary

- Barracuda Virtual Reactor was successfully tested on NDv4, NCv3, and NCasT4_v3 VMs on Azure.
- On NDv4 VMs, the application scales well up to four GPUs for models with higher particle counts. For models with lower particle counts, it scales only up to two GPUs.
- On NCv3 VMs, performance scales up to three GPUs for models with higher particle counts. For models with lower particle counts, we recommend a one-GPU configuration.
- On NCasT4_v3 VMs, the application scales well up to four GPUs for models with higher particle counts. For models with lower particle counts, it scales well only with a one-GPU configuration.
- For simulations with high numbers of particles and cells, a single 16-GB GPU might not run well because of the required memory. In these cases, you need to run the simulation with two GPUs. You can see this issue in the results for test cases 480, 481, and 482 on the NCv3 and NCasT4_v3 VMs.
- For smaller simulations, when there are performance penalties when all GPUs are used on an instance, you can run concurrent simulations using the other GPUs. In this scenario, multiple points in the simulation parameter space can be explored more quickly.

## Contributors

*This article is maintained by Microsoft. It was originally written by
the following contributors.*

Principal authors:

-   [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) |
    Senior Manager
-   [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) |
    Principal Program Manager
-   [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) |
    HPC Performance Engineer

Other contributors:

-   [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) |
    Technical Writer
-   [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director
    Business Strategy
-   [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) |
    Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [GPU-optimized virtual machine sizes](/azure/virtual-machines/sizes-gpu)
- [Virtual machines on Azure](/azure/virtual-machines/overview)
- [Virtual networks and virtual machines on Azure](/azure/virtual-network/network-overview)
- [Learning path: Run high-performance computing (HPC) applications on Azure](/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)

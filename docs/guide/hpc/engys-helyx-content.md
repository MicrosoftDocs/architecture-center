This article describes the steps for running [Engys](https://engys.com/products/helyx) HELYX application on a virtual machine(VM) that’s deployed on Azure. It also presents the performance results of  running HELYX on single-node and multi-node VM configurations.

Engys HELYX is a general purpose, computational fluid dynamics (CFD) software for engineering analysis and design optimization. It is based on OpenFOAM libraries and advanced automatic meshing utility for simulating complex flows. HELYX provides:
- A Generalised Internal Boundaries (GIB) method to support complex boundary motions inside the finite-volume mesh.
- Advanced hex-dominant automatic mesh algorithm with polyhedra support which can run in parallel to generate large computational grids.
- Highly capable solver stack based on the finite-volume approach covering single- and multi-phase turbulent flows (RANS, URANS, DES, LES), thermal flows with natural/forced convection, thermal/solar radiation, incompressible and compressible flow solutions.

HELYX supports industry specific add-ons such as elements, hydro, marine, coupled, etc., in conjunction with core to offer solutions.

HELYX is primarily used in industries like automotive, aerospace, building, marine, turbo, energy, engineering process industries including academic research.

## Why deploy HELYX on Azure?

- Modern and diverse compute options to meet your workload's needs.
- The flexibility of virtualization without the need to buy and maintain physical hardware.
- Rapid provisioning.
- Complex problems solved within a few hours.

## Architecture

Multi-node configuration:

image 

download 

Single-node configuration: 

image 

Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Linux and Windows VMs. 
   - For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](../../reference-architectures/n-tier/linux-vm.yml).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud. 
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VMs.  
  - A public IP address connects the internet to the VM.   
- [Azure CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud) is used to create the cluster in the multi-node configuration.
- A physical SSD is used for storage.  

Compute sizing and drivers

Performance tests of HELYX on Azure used [HBv3 AMD EPYC 7V73X](/azure/virtual-machines/hbv3-series) (Milan-X) VMs running Linux CentOS Operating system. The following table provides details about HBv3-series VMs.

|VM size|vCPU|Memory (GiB)|Memory bandwidth GBps|Base CPU frequency (Ghz)|	All-cores frequency (Ghz, peak)|Single-core frequency (Ghz, peak)|RDMA performance (Gbps)|Maximum data disks|
|-|-|-|-|-|-|-|-|-|
|Standard_HB120rs_v3|	120	|448|	350|	1.9|	3.0|	3.5|	200|	32|
|Standard_HB120-96rs_v3|	96|	448|	350|	1.9|	3.0|	3.5|	200	|32|
|Standard_HB120-64rs_v3	|64	|448|	350	|1.9	|3.0	|3.5|	200|	32|
|Standard_HB120-32rs_v3	|32	|448|	350	|1.9	|3.0	|3.5|	200|	32|
|Standard_HB120-16rs_v3	|16|	448|	350	|1.9|	3.0	|3.5|	200	|32|

Required drivers

To use InfiniBand, you need to enable InfiniBand drivers.

Install HELYX 3.5.0 on a VM and HPC Cluster

The software HELYX must be purchased from ENGYS or one of their local authorized distributors/agents to get access to the installation files and technical support. Contact [ENGYS](https://engys.com/products/helyx) if you are interested in buying HELYX.

Before you install HELYX, you need to deploy and connect a VM or HPC Cluster.

For information about deploying the VM and installing the drivers, see one of these articles:

- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)

For information about deploying the Azure CycleCloud and HPC cluster, see below articles:

- [Install and configure Azure CycleCloud](/learn/modules/azure-cyclecloud-high-performance-computing/4-exercise-install-configure)
- [Create a HPC Cluster](/learn/modules/azure-cyclecloud-high-performance-computing/5-exercise-create-cluster)

HELYX 3.5.0 Performance Results

Test Models

Three models were considered for testing the parallel scalability performance of HELYX version 3.5.0 on Azure, namely:
- A steady-state model of a city landscape, typical of wind comfort analysis.
- A steady-state model of a ventilator fan with moving blades approximated using a MRF approach with arbitrary mesh interface. Two mesh densities were compared.
- A transient model of a ship moving in calm water using a two-phase volume-of-fluid solver. Two mesh densities were compared.

All computational grids tested herein were created in parallel as part of the execution process using the hex-dominant meshing utility provided with HELYX. 

The details of each test model are shown below:

**Model 1 – City_landscape_Niigata-NNE**

image 

The following table provides details about the model.

|Model Details|	Mesh Size|	Solver|	Steady-state|
|-|-|-|-|
|1|	26,500,000 cells|	Single phase, turbulent flow|	1000 iterations|

**Model 2 – Turbomachine_Ventilator-AFnq182**

image 

The following table provides details about the model.

|Model Details|	Mesh Size|	Solver|	Steady-state|
|-|-|-|-|
|2a|3,100,000 cells	|Single phase, turbulent flow with MRF (AMI)	|1000 iterations	|
|2b|11,800,000 cells	|Single phase, turbulent flow with MRF (AMI)	|1000 iterations	|

**Model 3 – Marine_G2010-C2.2b-KCS-Fn026**

|Model Details|	Mesh Size|	Solver|	Steady-state|
|-|-|-|-|
|3a|1,350,000 cells|Two-phase (VOF) with automatic mesh refinement|CFL regulated for 20 s|
|3b|11,100,000 cells|Two-phase (VOF) with automatic mesh refinement|CFL regulated for 20 s|

HELYX 3.5.0 Performance Results on Single-Node VM

The performance results achieved running HELYX in parallel on single-node Azure [HBv3 AMD EPYC 7V73X](/azure/virtual-machines/hbv3-series) (Milan-X) VMs are presented below as baseline for comparing with multi-node runs.

**Model 1 - City_landscape_Niigata-NNE**

This table shows total solver times for varying numbers of CPUs on Standard_HBv3-series VM:

|Number of cores|Total Solver time in seconds|	Relative Solver Speedup|
|-|-|-|
|16|	6176.48|	1.00|
|32	|4301.36	|1.44|
|64	|3783.12	|1.63|
|120|	3774.44	|1.64|

The following graph shows the relative speedup of the City_landscape_Niigata-NNE model on Standard_HBv3-series VM:

image 

**Model 2a - Turbomachine_Ventilator-AFnq182**

This table shows total solver times for varying numbers of CPUs on Standard_HBv3-series VM:

|Number of cores|Total Solver time in seconds|	Relative Solver Speedup|
|-|-|-|
|16|1609.85|	1.00|
|32	|1081.2	|1.49|
|64	|850.98	|1.89|
|120|715.07	|2.25|

The following graph shows the relative speedup of the Turbomachine_Ventilator-AFnq182 model on Standard_HBv3-series VM:

image 

**Model 3a - Marine_G2010-C2.2b-KCS-Fn026**

This table shows total solver times for varying numbers of CPUs on Standard_HBv3-series VM:

|Number of cores|Total Solver time in seconds|	Relative Solver Speedup|
|-|-|-|
|16|16608.29|	1.00|
|32	|13622.88	|1.22|
|64	|7979.05	|2.08|
|120|8007.08|2.07|

The following graph shows the relative speedup of the Marine_G2010-C2.2b-KCS-Fn026 model on Standard_HBv3-series VM:

image 

Additional notes about Single-Node Tests 

For all single-node tests we have taken the solver time on HB120-16rs_v3 (16 cores) as the reference to calculate the relative speed up with respect to other similar VMs with more cores. The results presented above show that parallel performance improves as we increase from 16 to 64 cores, then at 120 cores some simulations show very limited improvement and others show a drop in performance. This is a common occurrence with CFD solvers and other memory intensive applications due to the saturation of the onboard memory available on each processor.

The AMD EPYC 7V73-series (Milan-X) featured in the Azure HBv3 VMs tested here is a very capable processor with 768MB of total L3 cache. Our single-node tests confirm that this memory is sufficient to guarantee parallel scalability of the HELYX solvers when using half the cores available on each 7V73-series chip.

HELYX 3.5.0 Performance Results on Multi-Node (Cluster)

The single-node tests carried out with HELYX confirmed that the solver exhibits proper parallel performance when using up to 64 cores with HBv3 VMs. Therefore, we employed only 64 cores to evaluate the performance of HELYX with [Standard_HB120-64rs_v3](/azure/virtual-machines/hbv3-series) when testing multi-node (cluster) configurations. The results are shared below for each test case considered in this study:

**Model 1 - City_landscape_Niigata-NNE**

This table shows total solver times for varying numbers of CPUs on Standard_HBv3-series VMs:

|Number of nodes|	Number of cores|	Cells per cores|	Total solver time, in seconds|	Relative solver speedup|
|-|-|-|-|-|
|1	|64	|414063	|3741.59	|1.00|
|2	|128	|207031	|1528.34	|2.45|
|4	|256	|103516	|640.64	|5.84|
|8	|512	|51758	|398.73	|9.38|
|16	|1024	|25879	|193.72	|19.31|

The following graph shows the relative speedup of the City_landscape_Niigata-NNE model on Standard_HBv3-series VMs:

image 

Model 2a - Turbomachine_Ventilator-AFnq182

This table shows total solver times for varying numbers of CPUs on Standard_HBv3-series VMs:

|Number of nodes|	Number of cores|	Cells per cores|	Total solver time, in seconds|	Relative solver speedup|
|-|-|-|-|-|
|1	|64	|48438	|838.4|1.00|
|2	|128	|24219	|567.48|	1.48|
|4	|256	|12109	|455.9	|1.84|
|8	|512	|6055	|372.82	|2.25|

The following graph shows the relative speedup of the Turbomachine_Ventilator-AFnq182 model on Standard_HBv3-series VMs:

image 

Model 2b - Turbomachine_Ventilator-AFnq182_large

This table shows total solver times for varying numbers of CPUs on Standard_HBv3-series VM:

|Number of nodes|	Number of cores|	Cells per cores|	Total solver time, in seconds|	Relative solver speedup|
|-|-|-|-|-|
|1	|64	|184375|	2710.14	|1.00|
|2	|128		|92188	|1602.64|	1.69|
|4	|256	|46094	|1076.27	|2.52|
|8	|512	|23047	|756.73	|3.58|

The following graph shows the relative speedup of the Turbomachine_Ventilator-AFnq182_large model on Standard_HBv3-series VMs:

image 

Model 3a - Marine_G2010-C2.2b-KCS-Fn026

This table shows total solver times for varying numbers of CPUs on Standard_HBv3-series VMs:

|Number of nodes|	Number of cores|	Cells per cores|	Total solver time, in seconds|	Relative solver speedup|
|-|-|-|-|-|
|1	|64	|21094|	8028.75	|1.00|
|2	|128		|10547|	6354.25|	1.26|
|4	|256	|5273	|4320.72|	1.86|
|8	|512	|2637	|4518.09|	1.78|

The following graph shows the relative speedup of the Marine_G2010-C2.2b-KCS-Fn026 model on Standard_HBv3-series VMs:

image 

Model 3b - Marine_G2010-C2.2b-KCS-Fn026_large

This table shows total solver times for varying numbers of CPUs on Standard_HBv3-series VM:

|Number of nodes|	Number of cores|	Cells per core|	Total solver time, in seconds|	Relative solver speedup|
|-|-|-|-|-|
|1	|64	|173438|	66860.55|	1.00|
|2	|128		|86719|	41243.12|	1.62|
|4	|256	|43359	|25901.95	|2.58|
|8	|512	|21680	|16781.86	|3.98|

The following graph shows the relative speedup of the Marine_G2010-C2.2b-KCS-Fn026_large model on Standard_HBv3-series VMs:

inage 

Additional notes about Multi-Node Tests 

We conclude from the multi-node tests that parallel scalability for Model 1 (steady-state, incompressible, turbulent flow) is above optimal. We also notice from the results obtained with Models 2 and 3 that parallel solver performance can be somewhat conditioned when using ancillary methods such as MRF/AMI or automatic mesh refinement.

The results also show that a minimum number of cells per core is required to reach optimal scalability across multiple nodes when using HELYX. This is evident when comparing the results from Model 2a to 2b and 3a to 3b. Solver performance is reduced when the number of cells per core falls below 20,000 due to excessive data communication between processor boundaries.

Azure cost

Only solver time has been considered for the cost calculations. Meshing times, installation time and software costs have been ignored.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate VM costs for your configurations.

The following tables provide the solver times in hours. The Azure VM hourly rates are subject to change. To compute the cost, multiply the solver time by the number of nodes and the Azure VM hourly cost which you can find [here for Windows](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing) and [here for Linux](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

Cost for Model 1 - City_landscape_Niigata-NNE

|Number of nodes	|Solver time, in hours|
|-|-|
|1	|1.052|
|2	|0.436|
|4	|0.186|
|8	|0.118|
|16|	0.062|

Cost for Model 2a - Turbomachine_Ventilator-AFnq182

|Number of nodes	|Solver time, in hours|
|-|-|
|1	|0.244|
|2	|0.168|
|4	|0.138|
|8	|0.118|

Cost for Model 2b - Turbomachine_Ventilator-AFnq182_large

|Number of nodes	|Solver time, in hours|
|-|-|
|1	|0.801|
|2	|0.483|
|4	|0.337|
|8	|0.247|

Cost for Model 3a - Marine_G2010-C2.2b-KCS-Fn026

|Number of nodes	|Solver time, in hours|
|-|-|
|1	|2.291|
|2	|1.823|
|4	|1.264|
|8	|1.336|


Cost for Model 3b - Marine_G2010-C2.2b-KCS-Fn026_large

|Number of nodes	|Solver time, in hours|
|-|-|
|1	|18.800|
|2	|11.670|
|4	|7.406|
|8	|4.890|

Summary

- HELYX 3.5.0 was successfully tested on Azure using HBv3 standalone Virtual Machines and Azure Cycle Cloud multi-node (cluster) setup.
- All models tested demonstrated good CPU acceleration when running in a multi-node configuration.
- The meshing, setup and solver applications in HELYX can all be run in parallel, thus making this CFD tool ideal for execution in multi-node configurations (no need for mesh decomposition/reconstruction).
- The simulation engine delivered with HELYX is open source, which means users can run as many simulations in as many processors as needed without incurring additional license costs.
- For better parallel performance we recommend using 64 cores per HBv3 node and a minimum of 20,000 cells per core.

## Contributors

This article is maintained by Microsoft. It was originally written by the following contributors.

Principal authors:
- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Preetham Y M](https://www.linkedin.com/in/preetham-y-m-6343a6212) | HPC Performance Engineer

Other contributors:
- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

To see non-public LinkedIn profiles, sign into LinkedIn.

## Next steps

- [GPU-optimized virtual machine sizes](/azure/virtual-machines/sizes-gpu)
- [Windows virtual machines on Azure](/azure/virtual-machines/windows/overview)
- [Virtual networks and virtual machines on Azure](/azure/virtual-network/network-overview)
- [Learning path: Run HPC applications on Azure](/training/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)
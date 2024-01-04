This article describes the steps for installing and running [Ansys HFSS](https://www.ansys.com/products/electronics/ansys-hfss) on a virutal machine (VM) that's deployed on Azure. It also presents the performance results of running HFSS.

Ansys HFSS is a 3D electromagnetic (EM) simulation application for designing and simulating high-frequency electronic products. HFSS enables engineers to address RF, microwave, IC, PCB, and EMI problems for most complex systems.

HFSS is used in simulations of high-frequency electronic products like antennas, antenna arrays, RF or microwave components, high-speed interconnects, IC packages, and printed circuit boards. Engineers use HFSS to design high-frequency, high-speed electronics found in communications systems, advanced driver assistance systems (ADAS), satellites, and IoT products.

## Benefits of deploying HFSS on Azure

Azure offers:

- Modern and diverse compute options, like VM SKUs, to align to your workload requirements.
- The flexibility to create customised VMs within seconds by defining an operating system, language, and workload.
- Rapid provisioning.
- Strong GPU acceleration, with increased performance as GPUs are added.

## Architecture

![Diagram that shows an architecture for running Ansys HFSS on Azure.](media/hpc-ansys-hfss.svg)

*Download a [Visio file](https://arch-center.azureedge.net/hpc-ansys-hfss.vsdx) of this architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create a Windows VM. 
   - For information about deploying the VM and installing the drivers, see [Windows VMs on Azure](../../reference-architectures/n-tier/windows-vm.yml).
   - A physical solid-state drive (SSD) is used to store data that's related to the VM.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud. [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.
- [Azure Bastion](https://azure.microsoft.com/products/azure-bastion) provides improved-security Remote Desktop Protocol (RDP) and Secure Shell Protocol (SSH) access to VMs without any exposure through public IP addresses.

## Compute sizing and drivers

[NC A100 v4](/azure/virtual-machines/nc-a100-v4-series) series VMs were used to test the performance of HFSS on Azure.

The following table provides the configuration details:

| Size | vCPU | Memory, in GiB | Temporary storage (with NVMe), in GiB | GPU | GPU memory, in GiB | Maximum data disks | Maximum uncached disk throughput, in IOPS / MBps | Maximum NICs / network bandwidth, in MBps |
|---|---|---|---|---|---|---|---|---|
| Standard_NC24ads_A100_v4 | 24 | 220 | 1,123 | 1 | 80 | 12 | 30,000 / 1,000 | 2 / 20,000 |
| Standard_NC48ads_A100_v4 | 48 | 440 | 2,246 | 2 | 160 | 24 | 60,000 / 2,000 | 4 / 40,000 |
| Standard_NC96ads_A100_v4 | 96 | 880 | 4,492 | 4 | 320 | 32 | 120,000 / 4,000 | 8 / 80,000 |

### Required drivers

To take the advantage of the  GPU capabilities of [NC A100 v4](/azure/virtual-machines/nc-a100-v4-series) series VMs, you need to install NVIDIA GPU drivers.

## Ansys HFSS installation

Before you install HFSS, you need to deploy a VM and use the NVIDIA GPU Driver Extension provided by Azure to install NVIDIA drivers.

For information about deploying the VM and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

For information about installing HFSS, see the [Ansys website](https://www.ansys.com/products/electronics/ansys-hfss).

## Ansys HFSS performance results

The following table describes the VM that was used for testing.

> [!Note] 
> These performance tests were conducted on Windows 10 Pro 22H2. HFSS can also be deployed on newer OS versions.

| Operating system | OS architecture | GPU driver version | CUDA version |
|---|---|---|---|
| Windows 10 Pro 22H2 | x64 | 527.41 | 12 |

Three models were considered for testing the scalability performance of HFSS version 2021 R2 on Azure.

The details of each test model are provided in the following sections.

**Model 1: Pedestrian**

***Description:*** The below scene shows Detection and classification of vulnerable road users (VRUs) such as pedestrians  by using a sensor. [Ansys HFFS SBR+](https://www.ansys.com/en-in/products/electronics/ansys-hfss) solver is an asymptotic, ray tracing electromagnetic solver that efficiently solves electrically large problems. HFSS SBR+ uses geometric optics (GO), physical optics (PO), uniform theory of diffraction (UTD), physical theory of diffraction (PTD) and creeping waves (CW) to accurately predict the propagation of electromagnetic waves.

![Image showing a Pedestrian model.](media/image3.png)

The following table provides details about the model.

| Model Name | Solver | Ray Density | Maximum Bounces | Distribution | Solution Frequency | Far Field Observation Points |
|---|---|---|---|---|---|---|
| Pedestrian | HFSS SBR+ | 2 | 3 | Single point | 77GHz | 519841 |

**Model** **2:** **Autonomous Vehicular** **Radar_ADP**

**Description:** **The below scene shows 2 vehicles moving towards each other in opposite direction and one of the vehicle will detect obstacles or pedestrians before they are visible to the driver by using Automotive Radar. Automotive radar has emerged as one of the backbone technologies in the automotive industry’s advanced driver assistance systems (ADAS) revolution. Because radar uses electromagnetic waves to sense the environment, it can operate over a long distance, and in poor visibility or inclement weather conditions. Designing automotive radar that accurately captures diverse traffic situations will be essential in making autonomous operations safe.

![Image showing Autonomous Vehicular Radar_ADP model.](media/image4.png)

The following table provides details about the model.

| Model Name | Solver | Ray Density | Maximum Bounces | Distribution | Solution Frequency | Far Field Observation Points |
|---|---|---|---|---|---|---|
| Autonomous Vehicular Radar_ADP | HFSS SBR+ | 4 | 5 | Single point | 77GHz | 260281 |

**Model** **3:** **Urban_city** 

**Description:** **The below scene shows a 3D view of urban city which has buildings adjacent to each other. HFSS software is used in simulating the design and testing of various city features.

![Image Showing Urban_city model.](media/image5.png)

The following table provides details about the model.

| Model Name | Solver | Ray Density | Maximum Bounces | Distribution | Solution Frequency | Far Field Observation Points |
|---|---|---|---|---|---|---|
| Urban_city | HFSS SBR+ | 1 | 5 | Single point | 35GHz | 519841 |

The following sections provide the performance results of running Ansys HFSS on single-node Azure [NCA100_v4](/azure/virtual-machines/nc-a100-v4-series) VMs. 

**Model 1:** **Pedestrian**

This table shows total elapsed time recorded for running the simulation for varying number of GPUs on the Standard NCv4-series VM:

| VM/Processor | Number ofcores | Number of GPU | Total Elapsedtime(seconds) | Relativespeedincrease |
|---|---|---|---|---|
| EPYC 7V73X | 32 | 0 | 154475 | 1.00 |
| NCv4 | 8 | 1 | 1201 | 128.62 |
| NCv4 | 8 | 2 | 599 | 257.89 |
| NCv4 | 8 | 3 | 409 | 377.69 |
| NCv4 | 8 | 4 | 309 | 499.92 |

**Note:** The Relative speed-up is calculated by taking the time taken (elapsed time) to complete the simulation with only CPUs as a baseline. With respect to this elapsed time the relative speed for 1,2,3 and 4 GPUs is calculated.

The following graph shows the relative speed increase as the number of GPUs increases:

**Model 2: Autonomous Vehicular Radar_ADP

This table shows total elapsed time recorded for running the simulation for varying number of GPUs on the Standard NCv4-series VM:

| VM | Number ofcores | Number of GPU | Total Elapsedtime(seconds) | Relativespeedincrease |
|---|---|---|---|---|
| NCv4 | 8 | 1 | 15164 | 1.00 |
| NCv4 | 8 | 2 | 7750 | 1.96 |
| NCv4 | 8 | 3 | 5175 | 2.93 |
| NCv4 | 8 | 4 | 3879 | 3.91 |

Note: The Relative speed-up is calculated by taking the time taken (elapsed time) to complete the simulation with only 1 GPU as a baseline. With respect to this elapsed time the relative speed for 2,3 and 4 GPUs is calculated. 

The following graph shows the relative speed increase as the number of GPUs increases:

**Model 3: Urban_city

This table shows total elapsed time recorded for running the simulation for varying number of GPUs on the Standard NCv4-series VM

| VM | Number ofcores | Number of GPU | Total Elapsedtime(seconds) | Relativespeedincrease |
|---|---|---|---|---|
| NCv4 | 8 | 1 | 4635 | 1.00 |
| NCv4 | 8 | 2 | 2753 | 1.68 |
| NCv4 | 8 | 3 | 2181 | 2.13 |
| NCv4 | 8 | 4 | 1886 | 2.46 |

Note: The Relative speed-up is calculated by taking the time taken (elapsed time) to complete the simulation with only 1 GPU as a baseline. With respect to this elapsed time the relative speed for 2,3 and 4 GPUs is calculated. 

The following graph shows the relative speed increase as the number of GPUs increases:

**Notes about the tests performed for the above 3 test cases:**

To show the advantage of HFSS with SBR+ solver which uses GPUs to boost the performance, we have used pedestrian model and shown the relative increase in the speedup when we run with GPUs as compared to running it on only CPUs. To validate the performance on CPU, we have chosen 32 vCPUs EPYC 7V73X processor. The other 2 models Autonomous Vehicular Radar and Urban_City, for which the step sizes are smaller, will require more computation time, so we have limited CPU validation to only Pedestrian model and shown only GPU scaleup for the other two models by taking the elapsed time with 1 GPU as a baseline. 

## Azure Cost

Only simulation running time has been considered for the cost calculations. Installation time, simulation setup time and software costs have been ignored.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate VM costs for your configurations.

The following tables provide the solver times in hours. The Azure VM hourly rates are subject to change. To compute the cost, multiply the solver time by the number of nodes and the Azure VM hourly cost which you can find [here for Windows](https://azure.microsoft.com/pricing/details/virtual-machines/windows/)  and  [here for Linux](https://azure.microsoft.com/pricing/details/virtual-machines/linux/).

**Cost for model 1: Pedestrian**

| Number<br>of GPUs | Elapsedtime (Hr) |
|---|---|
| 0 | 42.91 |
| 1 | 0.33 |
| 2 | 0.17 |
| 3 | 0.11 |
| 4 | 0.09 |

**Cost for model 2: Autonomous Vehicular Radar_ADP**

| Number<br>of GPUs | Elapsedtime (Hr) |
|---|---|
| 1 | 4.21 |
| 2 | 2.15 |
| 3 | 1.44 |
| 4 | 1.08 |

**Cost for model 3: Urban_city**

| Number<br>of GPUs | Elapsedtime (Hr) |
|---|---|
| 1 | 1.29 |
| 2 | 0.76 |
| 3 | 0.61 |
| 4 | 0.52 |

## Summary

- Ansys HFSS Application is successfully deployed and tested on NCA100_v4 series VMs on Azure Platform.

In the Pedestrian model with SBR+ Solver, simulation can be completed 128 times faster using 1 GPU when compared to solving the same without the use of GPUs. With 4GPUs, up to 500 times of relative speedup can be achieved. 

The AVR model shows up to 97% of increased efficiency with the use of 4GPUs when compared to 1GPU.

Ansys-HFSS with SBR+ Solver can use the GPU power to accelerate the simulations. Azure provides the suitable VMs equipped with latest GPUs for running HFSS Simulations.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

[Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager

[Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager

[Preetham Y M](https://www.linkedin.com/in/preetham-y-m-6343a6212/) | HPC Performance Engineer

Other contributors:

[Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer

[Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy

[Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

*To see non-public LinkedIn profiles, sign into LinkedIn.*

## Next steps

[GPU Optimized Virtual Machine Sizes](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-gpu)

[Windows Virtual Machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/overview)

[Virtual networks and virtual machines on Azure](/azure/virtual-network/network-overview)

[Learning path: Run high-performance computing (HPC) applications on Azure](/training/paths/run-high-performance-computing-applications-azure)

## Related resources

[Run a Linux VM on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm)

[HPC system and big-compute solutions](/azure/architecture/solution-ideas/articles/big-compute-with-azure-batch)

[HPC cluster deployed in the cloud](/azure/architecture/solution-ideas/articles/hpc-cluster)


 This article describes the steps to install and run [Ansys HFSS](https://www.ansys.com/products/electronics/ansys-hfss) application on a VM deployed in Azure  and presents the performance results.

Ansys HFSS is a 3D electromagnetic (EM) simulation software for designing and simulating high-frequency electronic products. HFSS’s unmatched capacity, coupled with indisputable accuracy, enables engineers to address RF, microwave, IC, PCB and EMI problems for most complex systems. HFSS is the premier EM tool for R&D and virtual design prototyping. It reduces design cycle time and boosts your product’s reliability and performance.

HFSS is used in simulations of high-frequency electronic products such as antennas, antenna arrays, RF or microwave components, high-speed interconnects, IC packages and printed circuit boards. Engineers use Ansys HFSS to design high-frequency, high-speed electronics found in communications systems, advanced driver assistance systems (ADAS), satellites, and IoT products.

## Benefits of deploying on Azure

Azure offers:

- Modern and diverse compute  such as Virtual Machine SKUs options to align to your workload requirements.
- Flexibility to create your own customised virtual machines within seconds by defining an operating system, language, and workload.
- Rapid provisioning
- Strong GPU acceleration, with increased performance as GPUs ar e added.

## Architecture

![Diagram that shows architecture for running Ansys HFSS on Azure](media/image1.png)

### Components

[Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create Windows or Linux VMs.

- For information about deploying the VM and installing the drivers, see [Windows VMs on Azure](/azure/architecture/reference-architectures/n-tier/windows-vm).
- For storing data related to VM, physical solid-state drive (SSD) is used.

[Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud.

- [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to VMs.
- Azure Bastion provides more secure and seamless Remote Desktop Protocol (RDP) and Secure Shell Protocol (SSH) access to virtual machines (VMs) without any exposure through public IP addresses.

## Compute sizing and drivers

[NCA100_v4](/azure/virtual-machines/nc-a100-v4-series) series VMs were used to test performance of Ansys HFSS on Azure.

The following table shows configuration details:

| Size | vCPU | Memory: GiB | Temp Storage (with NVMe) : GiB | GPU | GPU Memory: GiB | Max data disks | Max uncached disk throughput: IOPS / MBps | Max NICs/network bandwidth (MBps) |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|---|
| Standard_NC24ads_A100_v4 | 24 | 220 | 1123 | 1 | 80 | 12 | 30000/1000 | 2/20,000 |
| Standard_NC48ads_A100_v4 | 48 | 440 | 2246 | 2 | 160 | 24 | 60000/2000 | 4/40,000 |
| Standard_NC96ads_A100_v4 | 96 | 880 | 4492 | 4 | 320 | 32 | 120000/4000 | 8/80,000 |

### Required drivers

To take the advantage of the  GPU capabilities of the [NCA100_v4](/azure/virtual-machines/nc-a100-v4-series) series VMs, you need to install NVIDIA GPU drivers.

## Ansys HFSS installation

Before you install HFSS, you need to deploy a VM using NVIDIA GPU Driver Extensions provided by Azure.

For information about deploying the VM and installing the drivers, see these articles:

- [Run a Windows VM on Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/windows-vm)
- [Run a Linux VM on Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm)

For information about installing HFSS, see the [Ansys Website](https://www.ansys.com/en-in/products/electronics/ansys-hfss).

## Ansys HFSS_v2021R2 performance results

The following table provides the details of the VM that was used for testing.

Note: This performance study has been conducted on Windows 10 Pro 22H2 Operating system and this software can also be deployed on newer OS versions.

| Operating system | OS architecture | GPU driver version | CUDA version |
|:---:|:---:|:---:|:---:|
| Windows 10 Pro 22H2 | x64 | 527.41 | 12 |

Three models were considered for testing the scalability performance of HFSS version 2021 R2 on Azure.

The details of each test model are provided in the following sections.

**Model 1: Pedestrian**

***Description:*** The below scene shows Detection and classification of vulnerable road users (VRUs) such as pedestrians  by using a sensor. [Ansys HFFS SBR+](https://www.ansys.com/en-in/products/electronics/ansys-hfss) solver is an asymptotic, ray tracing electromagnetic solver that efficiently solves electrically large problems. HFSS SBR+ uses geometric optics (GO), physical optics (PO), uniform theory of diffraction (UTD), physical theory of diffraction (PTD) and creeping waves (CW) to accurately predict the propagation of electromagnetic waves.

![Image showing a Pedestrian model.](media/image3.png)

The following table provides details about the model.

| Model Name | Solver | Ray Density | Maximum Bounces | Distribution | Solution Frequency | Far Field Observation Points |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Pedestrian | HFSS SBR+ | 2 | 3 | Single point | 77GHz | 519841 |

**Model** **2:** **Autonomous Vehicular** **Radar_ADP**

**Description:** **The below scene shows 2 vehicles moving towards each other in opposite direction and one of the vehicle will detect obstacles or pedestrians before they are visible to the driver by using Automotive Radar. Automotive radar has emerged as one of the backbone technologies in the automotive industry’s advanced driver assistance systems (ADAS) revolution. Because radar uses electromagnetic waves to sense the environment, it can operate over a long distance, and in poor visibility or inclement weather conditions. Designing automotive radar that accurately captures diverse traffic situations will be essential in making autonomous operations safe.

![Image showing Autonomous Vehicular Radar_ADP model.](media/image4.png)

The following table provides details about the model.

| Model Name | Solver | Ray Density | Maximum Bounces | Distribution | Solution Frequency | Far Field Observation Points |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Autonomous Vehicular Radar_ADP | HFSS SBR+ | 4 | 5 | Single point | 77GHz | 260281 |

**Model** **3:** **Urban_city** 

**Description:** **The below scene shows a 3D view of urban city which has buildings adjacent to each other. HFSS software is used in simulating the design and testing of various city features.

![Image Showing Urban_city model.](media/image5.png)

The following table provides details about the model.

| Model Name | Solver | Ray Density | Maximum Bounces | Distribution | Solution Frequency | Far Field Observation Points |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Urban_city | HFSS SBR+ | 1 | 5 | Single point | 35GHz | 519841 |

The following sections provide the performance results of running Ansys HFSS on single-node Azure [NCA100_v4](/azure/virtual-machines/nc-a100-v4-series) VMs. 

**Model 1:** **Pedestrian**

This table shows total elapsed time recorded for running the simulation for varying number of GPUs on the Standard NCv4-series VM:

| VM/Processor | Number ofcores | Number of GPU | Total Elapsedtime(seconds) | Relativespeedincrease |
|:---:|:---:|:---:|:---:|:---:|
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
|:---:|:---:|:---:|:---:|:---:|
| NCv4 | 8 | 1 | 15164 | 1.00 |
| NCv4 | 8 | 2 | 7750 | 1.96 |
| NCv4 | 8 | 3 | 5175 | 2.93 |
| NCv4 | 8 | 4 | 3879 | 3.91 |

Note: The Relative speed-up is calculated by taking the time taken (elapsed time) to complete the simulation with only 1 GPU as a baseline. With respect to this elapsed time the relative speed for 2,3 and 4 GPUs is calculated. 

The following graph shows the relative speed increase as the number of GPUs increases:

**Model 3: Urban_city

This table shows total elapsed time recorded for running the simulation for varying number of GPUs on the Standard NCv4-series VM

| VM | Number ofcores | Number of GPU | Total Elapsedtime(seconds) | Relativespeedincrease |
|:---:|:---:|:---:|:---:|:---:|
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
|:---:|:---:|
| 0 | 42.91 |
| 1 | 0.33 |
| 2 | 0.17 |
| 3 | 0.11 |
| 4 | 0.09 |

**Cost for model 2: Autonomous Vehicular Radar_ADP**

| Number<br>of GPUs | Elapsedtime (Hr) |
|:---:|:---:|
| 1 | 4.21 |
| 2 | 2.15 |
| 3 | 1.44 |
| 4 | 1.08 |

**Cost for model 3: Urban_city**

| Number<br>of GPUs | Elapsedtime (Hr) |
|:---:|:---:|
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


This article presents the performance results of running the [BETA CAE EPILYSIS](https://www.beta-cae.com/epilysis.htm) application on an Azure virtual machine (VM). EPILYSIS is a software program that is used to perform several types of finite element analysis on various structures and materials.

Engineers use EPILYSIS to help design and optimize products. EPILYSIS can be combined with other tools, such as ANSA and META, to optimize simulations. The solver covers various solution types, like structural, NVH (noise, vibration, and harshness), optimization, and more.

EPILYSIS is used in the aerospace, automotive, defense, high-tech, and industrial equipment industries.

## Why deploy EPILYSIS on Azure?

Deploy EPILYSIS on Azure to get benefits like:

- Modern and diverse compute options to meet your workload's needs.
- The flexibility of virtualization without the need to buy and maintain physical hardware.
- Rapid provisioning.
- Performance that scales as CPUs are added, based on tests of a sample model.

## Architecture

:::image type="content" source="./media/epilysis/hpc-epilysis-single.svg" alt-text="Diagram that shows architecture for running BETA CAE EPILYSIS on Azure." border="false" lightbox="./media/epilysis/hpc-epilysis-single.svg":::
*Download a [Visio file](https://arch-center.azureedge.net/hpc-epilysis-single.vsdx) of this architecture.*

## Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create a Linux VM. For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm).

- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud.

- [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  

- A public IP address connects the internet to the VM.

- A physical solid-state drive (SSD) is used for storage.

## Compute sizing and drivers

The performance tests of EPILYSIS on Azure used an [HBv3-series](/azure/virtual-machines/hbv3-series) VM and [Eadsv5-series](/azure/virtual-machines/easv5-eadsv5-series) VM running on a Linux operating system.

- HBv3-series VMs are optimized for HPC applications like fluid dynamics, explicit and implicit finite element analysis, weather modeling, seismic processing, reservoir simulation, and RTL simulation.

- Eadsv5-series VMs are optimized for memory-intensive enterprise applications, such as relational database servers and in-memory analytics workloads.

The following table provides the configuration details for [HBv3-series](/azure/virtual-machines/hbv3-series) and [Eadsv5-series](/azure/virtual-machines/easv5-eadsv5-series) VMs:

| VM series | VM size | vCPU | Memory (GiB) | Temp storage (GiB) | Max data disk | Max NICs |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| HBv3 | Standard_HB120-16rs_v3 | 16 | 448 | 2\*960 | 32 | 8 |
| HBv3 | Standard_HB120-32rs_v3 | 32 | 448 | 2\*960 | 32 | 8 |
| Eadsv5 | Standard_E64ads_v5 | 64 | 512 | 2400 | 32 | 8 |

Performance test details for EPILYSIS are mentioned in the EPILYSIS performance results on HBv3-series VMs and EPILYSIS performance results on performance on Eadsv5-series VMs sections respectively.

## EPILYSIS installation

Before you install EPILYSIS, you need to [deploy and connect a Linux VM](/azure/architecture/reference-architectures/n-tier/linux-vm). You can download and install EPILYSIS from the [BETA CAE website](https://www.beta-cae.com/epilysis.htm).

## EPILYSIS performance results

EPILYSIS version 23.1.1 was used for testing the 101_large_7million model.

The following table provides details about the computing environment that was used for testing.

| VM series | Operating system version | Operating system architecture | Processor | MPI |
|:---:|:---:|:---:|:---:|:---:|
| Eadsv5 | Linux CentOS 7.9 HPC Gen2 | X86-64 | AMD EPYC 7763v | Open MPI 4.1.1 |
| HBv3 | Linux CentOS 7.9 HPC Gen2 | X86-64 | AMD EPYC 7V73X | Open MPI 4.1.1 |

>![Important]
>The version of Linux discussed in this article will be discontinued in 2024. Tests that are performed on newer versions of Linux that include the same drivers are expected to produce similar results.

#### Model details

The 101_large_7million model is used for EPILYSIS solver validation. This model is set up for a linear static analysis (solution 101). A *linear static analysis* is an analysis where a linear relation holds between applied forces and displacements. The following image shows the 101_large_7million model.

:::image type="content" source="./media/epilysis/model-example.png" alt-text="Image that shows the shows 101_large_7million.nas model.":::

The following table provides details about the model.

|  Model name | Nodes | Shell elements | Solid elements |
|:---:|:---:|:---:|:---:|
| 101_large_7million.nas | 7678688 | 6341470 | 1295109 |

### EPILYSIS performance results on a HBv3-series VM

The following table shows the details of each test on a HBv3-series VM. As the number of vCPUs increases, the total elapsed time decreases, and the relative speed increase improves.

| VM size | Number of vCPUs available | Number of vCPUs used | Total elapsed time (seconds) | Relative speed increase |
|:---:|:---:|:---:|:---:|:---:|
| Standard_HB120-16rs_v3 | 16 | 1 | 5542 | 1.00 |
| | 16 | 2 | 3469 | 1.60 |
| | 16 | 4 | 2213 | 2.50 |
| | 16 | 8 | 1630 | 3.40 |
| | 16 | 16 | 1420 | 3.90 |
| Standard_HB120-32rs_v3 | 32 | 20 | 1393 | 3.98 |

The following graph shows how the relative speed increases as you increase the vCPUs. It begins to plateau at 16 vCPUs.

:::image type="content" source="./media/epilysis/relative-speed-increase.png" alt-text="Graph that shows the relative speed increase for the HBv3-series VM.":::

### EPILYSIS performance results on Eadsv5-series VMs

The table illustrates that as the number of vCPUs used increases, the total elapsed time in seconds decreases, and the relative speed increase improves significantly. This suggests a strong correlation between the vCPUs used and the efficiency of the process.

| VM size | Number of vCPUs available | Number of vCPUs used | Total elapsed time (seconds) | Relative speed increase |
|:---:|:---:|:---:|:---:|:---:|
| Standard_E64ads_v5 | 64 | 1 | 6049 | 1.00 |
| | 64 | 2 | 3480 | 1.74 |
| | 64 | 4 | 2195 | 2.76 |
| | 64 | 8 | 1520 | 3.98 |
| | 64 | 16 | 1177 | 5.14 |
| | 64 | 20 | 1122 | 5.39 |

The following graph shows how the relative speed increases as you increase the vCPUs.

:::image type="content" source="./media/epilysis/relative-speed-increase-2.png" alt-text="Graph that shows the relative speed increase for the Eadsv5-series VM.":::

## Azure cost

The following table provides estimated runtimes that you can use to calculate Azure costs. To compute the cost, multiply the estimated time by the Azure VM hourly rate. For the hourly rates for Linux, see [Linux virtual machines pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux). Azure VM hourly rates are subject to change.

The cost calculations factor in only the simulation runtime. The installation time, simulation setup time, and software costs aren't included. You can use the  [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate VM costs for your configurations.

| VM size | vCPUs used | Elapsed time (hours) |
|:---:|:---:|:---:|
| Standard_HB120-16rs_v3 | 1 | 1.54 |
| | 2 | 0.96 |
| | 4 | 0.61 |
| | 8 | 0.45 |
| | 16 | 0.39 |
| Standard_HB120-32rs_v3 | 20 | 0.39 |
| Standard_E64ads_v5 | 1 | 1.68 |
| | 2 | 0.97 |
| | 4 | 0.61 |
| | 8 | 0.42 |
| | 16 | 0.33 |
| | 20 | 0.31 |

## Summary

- The HBv3 and Eadsv5-series VMs on Azure were used to create a benchmarking suite, which is one of the many uses of EPILYSIS.

- EPILYSIS's performance was evaluated on two HBv3-series VMs (Standard_HB120-16rs_v3 and Standard_HB120-32rs_v3) and one Eadsv5-series VM (Standard_E64ads_v5).

- On the HBv3-series VM, performance improves approximately 4X when the vCPU count is increased up to 20 vCPUs, using a single vCPU as a baseline.

- Similarly, on the Eadsv5-series VM, performance improves approximately 5X when the vCPU count is increased up to 20 vCPUs, using a single vCPU as a baseline.

- According to a validation study, the performance of a Eadsv5-series VM with 20 vCPUs is 19% more efficient compared to a HBv3-series VM with the same number of vCPUs.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Rupali Konade](https://www.linkedin.com/in/rupali-konade-3ba2851b2) | HPC Performance Engineer
- Shivakumar Tallolli | HPC Performance Engineer

Other contributors:

- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy
- [Jodi Martis](https://www.linkedin.com/in/jodimartis) | Technical Writer
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [GPU-optimized virtual machine sizes](/azure/virtual-machines/sizes-gpu)
- [Virtual machines on Azure](/azure/virtual-machines/linux/overview)
- [Virtual networks and virtual machines on Azure](/azure/virtual-network/network-overview)
- [Learning path: Run high-performance computing (HPC) applications on Azure](/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)

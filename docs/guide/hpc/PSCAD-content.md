
This article briefly describes the steps for running the Power Systems Computer Aided Design ([PSCAD](https://www.pscad.com/)) application on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running PSCAD..

PSCAD is a powerful and flexible graphical user interface to the Electromagnetic Transients including Direct Current (EMTDC) electromagnetic transient simulation engine. It enables the user to schematically construct a circuit, run a simulation, analyze the results, and manage the data in a completely integrated, graphical environment. PSCAD provides the following benefits:

- Bundled with a library of pre-programmed and tested simulation models, ranging from simple passive elements and control functions to more complex models, such as electric machines, full-on Flexible Alternating Current Transmission System (FACTS) devices, transmission lines and cables.
- Provides online plotting functions, controls, and meters, enabling the user to alter system parameters during a simulation run, and view the effects while the simulation is in progress.

PSCAD is used in many areas of the energy sector, like utilities & wind farms. It’s also used in industries like equipment manufacturing, consulting companies, research and academic organizations, and by regulators for functions including planning, operation, design, commissioning, teaching and research.

## Why deploy PSCAD on Azure?

The following list describes the benefits of deploying PSCAD on Azure:

Modern and diverse compute options to align to your workload's needs.

The flexibility of virtualization without the need to buy and maintain physical hardware.

- Rapid provisioning.
- Cost optimization by utilizing fewer cores for simpler simulations and adding a greater number of cores for complex simulation.

## Architecture

:::image type="content" source="media/image1.jpg" alt-text="Diagram that shows architecture for running PSCAD on Azure" border="true":::

## Components

[Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create a Windows VM. For information about deploying the VM and installing the drivers, see [Windows VMs on Azure](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/windows-vm).

A Premium solid-state drive (SSD) is used for OS disk as well as for storage.

[Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud. 

[Network security groups](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  

- A public IP address connects the internet to the VM. 

## Compute sizing and drivers

Performance tests of PSCAD on Azure used [HBv3-series](https://learn.microsoft.com/en-us/azure/virtual-machines/hbv3-series) and [HBv4-series](https://learn.microsoft.com/en-us/azure/virtual-machines/hbv4-series) VMs running on Windows OS. The following table provides the configuration details of HBv3-series and HBv4-series VM:

HBv3-series:

| **VM Size** | **vCPU** | **Memory: GiB** | **Memory bandwidth GB/s** | **Base CPU frequency (GHz)** | **All-cores frequency (GHz, peak)** | **Single-core frequency (GHz, peak)** | **RDMA performance (Gb/s)** |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **Standard_HB120-16rs_v3** | 16 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| **Standard_HB120-32rs_v3** | 32 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| **Standard_HB120-64rs_v3** | 64 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| **Standard_HB120-96rs_v3** | 96 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |
| **Standard_HB120-120rs_v3** | 120 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 |

HBv4-series:

| **VM Size** | **vCPU** | **Memory: GiB** | **Memory bandwidth GB/s** | **Base CPU frequency (GHz)** | **Max data disks)** | **Single-core frequency (GHz, peak)** | **RDMA performance (Gb/s)** |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **Standard_HB176-24rs_v4** | 24 | 704 | 780 | 2.4 | 32 | 3.7 | 400 |
| **Standard_HB176-48rs_v4** | 48 | 704 | 780 | 2.4 | 32 | 3.7 | 400 |
| **Standard_HB176-96rs_v4** | 96 | 704 | 780 | 2.4 | 32 | 3.7 | 400 |
| **Standard_HB176-1444rs_v4** | 144 | 704 | 780 | 2.4 | 32 | 3.7 | 400 |
| **Standard_HB176rs_v4** | 176 | 704 | 780 | 2.4 | 32 | 3.7 | 400 |

## PSCAD installation

Before you install PSCAD, you need to deploy and connect a VM.

For information about deploying the VM, see:

- [Run a Windows VM on Azure](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/windows-vm)

You can download & install PSCAD as follows:

 Register a MyCentre user account if you do not already have one.

 Send an email using your facility’s email domain to the PSCAD Sales Desk requesting the PSCAD software.

#  The software downloads and setup instructions will be provided to authorized users through their MyCentre user account. Log in to MyCentre, and download the software from your Downloads tab. For information see the Knowledge base website.

# PSCAD Performance results

Performance tests of PSCAD on Azure used [HBv3-series](https://learn.microsoft.com/en-us/azure/virtual-machines/hbv3-series) and [HBv4-series](https://learn.microsoft.com/en-us/azure/virtual-machines/hbv4-series) VM running on Windows OS. The following table provides the Operating system details.

| **Operating system version** | **OS Architecture** |
|:---:|:---:|
| **Windows** **10** **OS** | 64-bit |

A test case model is considered for testing the performance of PSCAD on Azure HBv3-series and HBv4-series VM. The model details are shown below.

### Model Details:

**Model: Province-80**

 The province-80 case comprises of a large network covering a geographical area in North America. The network is comprised of 7 individual zones serving each of its populous geographical areas. The case demonstrates task parallel processing using multiple EMTDC processes to distribute computational loading across multiple cores. Model is split into 80 cases of 1D simulations and complexity of model is dependent on splits. Below are components used:

| **Components** | **Number of components used** |
|---|---|
| **Buses (AC system)** | 2500 |
| **Synchronous and inverter-based generators** | 400 |
| **Transmission Line and cables** | 2500 |
| **Transformers** | 1500 |

## Results on HBv3-series

### Model – Province-80

The following table shows Elapsed time in seconds and Relative speed increase of Province-80 model:

| **VM** **Size** | **No. of vCPU used** | **Total Elapsed time in Seconds** | **Relative speed increase** |
|:---:|:---:|:---:|:---:|
| **Standard_HB120-16rs_v3** | 16 | 3031 | 1.00 |
| **Standard_HB120-32rs_v3** | 32 | 1743 | 1.74 |
| **Standard_HB120-64rs_v3** | 64 | 897 | 3.38 |
| **Standard_HB120-96rs_v3** | 96 | 767 | 3.95 |
| **Standard_HB120-120rs_v3** | 120 | 774 | 3.92 |

The following chart shows Relative speed increase of Province-80 model:

## Results on HBv4-series

### Model – Province-80

The following table shows Total Elapsed time in seconds and Relative speed increase of Province-80 model:

| **VM** **Size** | **No. of vCPU used** | **Total Elapsed time in Seconds** | **Relative speed increase** |
|:---:|:---:|:---:|:---:|
| **Standard_HB176-24rs_v4** | 24 | 2336 | 1 |
| **Standard_HB176-48rs_v4** | 48 | 1128 | 2.07 |
| **Standard_HB176-96rs_v4** | 96 | 617 | 3.79 |
| **Standard_HB176-144rs_v4** | 144 | 548 | 4.26 |

The following chart shows Relative speed increases of Province-80 model:

## Azure Cost

Only model running time is considered for the cost calculations. Application installation time isn't considered. The calculations are indicative. 

Below summary details of cost consumption on HBv3-series used for the validation.

**HBv3-series**

- To evaluate the cost performance of the configurations, Standard_HB120-16rs_v3 configuration is used as a baseline.
- It is apparent that linear decrease in azure cost is observed with every increment in HBv3 series, as we increase the size from 16vCPU to highest configuration of 120vCPU.                 
- It is apparent that the linear scalability in terms of performance is observed, as HBv3 series cost per hour same across all VM configuration it is advisable to use the Higher vCPU size to achieve good cost to performance advantage.

**HBv4-series**

- To evaluate the cost performance of the configurations, Standard_HB176-24rs_v4 configuration is used as a baseline.
- It is apparent that linear decrease in azure cost is observed with every increment in HBv4 series, as we increase the size from 24vCPU to highest configuration of 144vCPU.                 
- It is apparent that the linear scalability in terms of performance is observed, as HBv4 series cost per hour same across all VM configuration it is advisable to use the Higher vCPU size to achieve good cost to performance advantage.
- When compared between HBv3 with 96 cores and HBv4 96cores, it is evident that there is ~24% increase in performance is observed.

## Summary

PSCAD, powered by Microsoft Azure platform, exhibits high scalability when deployed on HBv3-series (AMD EPYC™ 7V73X (Milan-X) CPU cores) and HBv4-series (AMD EPYC™ 9V33X ("Genoa-X") CPU cores)

- For evaluating both series' performance, the lowest VM configuration is considered baseline: 16 cores for HBv3, and 24 cores for HBv4. The results are assessed based on the relative performance, where higher values indicate better performance.
- On HBv3 VMs, due to the model complexity as the number of cores doubles, we can observe an approximate 2X increase in relative speed up to 64 cores and moderate increases beyond 64 cores for this study.
- Similarly, on HBv4 VMs, a performance increase of between approximately 2X and 4.3X can be observed between the 48 and 144 core configurations.
- Higher scalability can be achieved based on the increased complexity of the model beyond 96 cores of HBv3 and 144 cores of HBv4.

  

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal authors:

- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Saurabh Parave](https://www.linkedin.com/in/saurabh-parave-957303162/) | HPC Performance Engineer
- [Karbasappa Umadi](https://www.linkedin.com/in/karbas-umadi-458879248/) | HPC Performance Engineer

  

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

## Next steps

- [GPU optimized virtual machine sizes](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-gpu)
- [Windows virtual machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/overview)
- [Linux virtual machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/overview)
- [Virtual networks and virtual machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-network/network-overview)
- [Learning path: Run high-performance computing (HPC) applications on Azure](https://docs.microsoft.com/en-us/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Windows VM on Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/windows-vm)
- [Run a Linux VM on Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm)
- [HPC system and big-compute solutions](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/big-compute-with-azure-batch)
- [HPC cluster deployed in the cloud](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/articles/hpc-cluster)


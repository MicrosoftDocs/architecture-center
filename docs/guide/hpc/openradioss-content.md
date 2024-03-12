This article briefly describes the steps for running [OpenRadioss](https://www.openradioss.org/) on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running OpenRadioss on Azure.

OpenRadioss is a free, open-source finite element analysis (FEA) code base that a worldwide community of researchers, software developers, and industry leaders are enhancing every day. OpenRadioss empowers users to make rapid contributions that tackle the latest challenges brought on by rapidly evolving technologies, such as:

- Battery development
- Lightweight materials and composites
- Human body models and biomaterials
- Autonomous driving and flight

OpenRadioss also provides virtual testing so that users can give passengers the safest environment possible.

- **Scalability, quality, and robustness**

  Industry-proven, class leading scalability from single core to HPC (High Performance Computing), with repeatability regardless of CPU count, optimized for all modern CPU processors

- **Innovative element formulations**

  Fast and accurate solutions from under integrated shell and solid elements with physical hourglass stabilization giving quality results at a fraction of fully integrated CPU cost

- **Extensive material and rupture libraries**

  Advanced nonlinear material laws and failure models, for isotropic, orthotropic, composite, hyper- and viscoelastic materials

- **Comprehensive capabilities**

  Wide array of contact interfaces, boundary conditions, imposed conditions, loading, joints, sensors, and output requests in animation and graph formats

- **Complex multiphysics**

  Battery failure model; Airbag deployment; Smooth Particle Hydrodynamics (SPH); Arbitrary Lagrangian Eulerian (ALE); Fluid Structure Interaction (FSI); Multiphase fluids

## Why deploy OpenRadioss on Azure?

- Provides modern and diverse compute options to align with your workload's needs
- Offers the flexibility of virtualization without the need to buy and maintain physical hardware
- Provides rapid provisioning
- On a single node, improves performance as much as 2.76 times over that of 16 CPUs

## Architecture

This section shows the differences between the architecture for a single-node configuration and the architecture for a multi-node configuration.

**Single-node configuration**:

This architecture shows a single-node configuration:

:::image type="content" source="media/openradioss/openradioss-single-node-architecture.png" alt-text="Diagram that shows an architecture for deploying OpenRadioss in a single-node configuration." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/openradioss-single-node-architecture.vsdx) of this
architecture.*

**Multi-node configuration**:

This architecture shows a multi-node configuration, orchestrated with Azure CycleCloud:

:::image type="content" source="media/openradioss/openradioss-multi-node-architecture.png" alt-text="Diagram that shows an architecture for deploying OpenRadioss in a multi-node configuration." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/openradioss-multi-node-architecture.vsdx) of this
architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is used to create a Linux VM. For information about deploying the VM and installing the drivers, see [Linux VMs on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is used to create a private network infrastructure in the cloud.
  - [Network security groups](/azure/virtual-network/network-security-groups-overview) are used to restrict access to the VM.  
  - A public IP address connects the internet to the VM.
- [Azure CycleCloud](https://azuremarketplace.microsoft.com/marketplace/apps/azurecyclecloud.azure-cyclecloud) is used to create the cluster in the multi-node configuration.
- A physical SSD is used for storage.

## Compute sizing and drivers

Performance tests of OpenRadioss on Azure used [HBv3-series](/azure/virtual-machines/hbv3-series) VMs running Linux. The following table provides the configuration details.

| VM size | vCPU | RAM memory (GiB) | Memory bandwidth (GBps) | Base CPU frequency (GHz) | All-cores frequency (GHz, peak) | Single-core frequency (GHz, peak) | RDMA performance (GBps) | Maximum data disks |
|-|-|-|-|-|-|-|-|-|
| Standard_HB120rs_v3 | 120 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-96rs_v3 | 96 | 448 | 350| 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-64rs_v3 | 64 | 448 | 350| 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-32rs_v3 | 32 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |
| Standard_HB120-16rs_v3 | 16 | 448 | 350 | 1.9 | 3.0 | 3.5 | 200 | 32 |

HBv3-series VMs are optimized for HPC applications, such as:

- Fluid dynamics
- Explicit and implicit finite-element analysis
- Weather modeling
- Seismic processing
- Reservoir simulation
- RTL simulation

HBv3 VMs with different numbers of vCPUs were deployed to determine the optimal configuration for OpenRadioss test simulations on a single node. That optimal configuration was then tested in a multi-node cluster deployment.

## OpenRadioss installation

Before you install OpenRadioss, deploy and connect a Linux VM and install the required AMD drivers. For information about deploying the VM, see [Run a Linux VM on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm).

You can install OpenRadioss from the OpenRadioss download page. For information about the installation process, see [OpenRadioss User Documentation](https://openradioss.atlassian.net/wiki/spaces/OPENRADIOSS/pages/4816906/OpenRadioss+User+Documentation).

## Multi-node configuration

You can deploy an HPC cluster on Azure by using [Azure CycleCloud](/azure/cyclecloud/overview).

Azure CycleCloud lets you orchestrate and manage HPC environments on Azure. You can use Azure CycleCloud to provision infrastructure for HPC systems, deploy HPC schedulers, and automatically scale the infrastructure to run jobs efficiently at any scale.

Azure CycleCloud is a Linux-based web application. We recommend that you set it up by deploying an Azure VM that's based on a preconfigured Azure Marketplace image.

To set up an HPC cluster on Azure, complete these steps:

1. [Install and configure Azure CycleCloud](/training/modules/azure-cyclecloud-high-performance-computing/4-exercise-install-configure).
1. [Create an HPC cluster from built-in templates](/training/modules/azure-cyclecloud-high-performance-computing/5-exercise-create-cluster).
1. [Connect to the head node (the scheduler)](/azure/cyclecloud/how-to/connect-to-node).

For multi-node configurations, the OpenRadioss installation process is the same as the process described for a single node, except the path to the installation directory is different.

- Select `/shared` for the installation directory path so that the directory is accessible for all nodes.
- The shared folder path depends on your network attached storage service, like an NFS server, [BeeGFS cluster](https://www.beegfs.io/c/), [Azure NetApp Files](https://azure.microsoft.com/services/netapp), and [Azure HPC Cache](https://azure.microsoft.com/services/hpc-cache).

## OpenRadioss performance results

OpenRadioss was tested in single-node and multi-node configurations. Computation time (engine run time) was measured. The Linux platform was used, with an Azure Marketplace CentOS 8.1 HPC Gen2 image. The following table provides details.

| Operating system version | OS architecture | MPI |
|-|-|-|
| CentOS Linux release 8.1.1911 (Core) | x86-64 | Open MPI |

### Model Details

**For Single-node runs**:

| Bird Strike | INIVOL and Fluid Structure Interaction model |
|-|-|
| :::image type="content" source="media/openradioss/bird-strike.png" alt-text="Diagram that shows a Bird Strike model in a single-node configuration." border="false"::: | :::image type="content" source="media/openradioss/inivol.png" alt-text="Diagram that shows an Inivol model in a single-node configuration." border="false"::: |

| Model details | Bird Strike | INIVOL and Fluid Structure Interaction model |
|-|-|-|
| FINAL TIME | 10.00000 | 0.00930 |
| TIME INTERVAL FOR TIME HISTORY PLOTS | 0.10000 | 0.00015 |
| TIME STEP SCALE FACTOR | 0.90000 | 0.90000 |
| MINIMUM TIME STEP | 0.00000 | 0.00000 |
| NUMBER OF 3D SOLID ELEMENTS | 0 | 89670 |
| NUMBER OF 3D SHELL ELEMENTS (4-NODES) | 37020 | 1510 |
| NUMBER OF 3D SHELL ELEMENTS (3-NODES) | 275 | 44 |
| NUMBER OF RIGID WALLS | 6 | 1 |
| NUMBER OF RIGID BODIES | 0 | 1 |
| NUMBER OF NODAL POINTS | 51704 | 97513 |
| NUMBER OF 3D BEAM ELEMENTS | 201 | 0 |
| NUMBER OF 3D SPRING ELEMENTS | 144 | 0 |

**For Multi-node runs:**

Yaris Impact Model

:::image type="content" source="media/openradioss/yaris-impact.png" alt-text="Diagram that shows a Yaris Impact model in a single-node configuration." border="false":::

| Model details | Yaris |
|-|-|
| FINAL TIME | 0.20000 |
| TIME INTERVAL FOR TIME HISTORY PLOTS | 0.00010 |
| TIME STEP SCALE FACTOR | 0.90000 |
| MINIMUM TIME STEP | 0.00000 |
| NUMBER OF 3D SOLID ELEMENTS | 259803 |
| NUMBER OF 3D SHELL ELEMENTS (4-NODES) | 1189905 |
| NUMBER OF 3D SHELL ELEMENTS (3-NODES) | 65134 |
| NUMBER OF RIGID WALLS | 6 |
| NUMBER OF RIGID BODIES | 887 |
| NUMBER OF NODAL POINTS | 1489653 |
| NUMBER OF 3D BEAM ELEMENTS | 313 |
| NUMBER OF 3D SPRING ELEMENTS | 7678 |

**OpenRadioss Performance Results on single node**

**Bird Strike Model**

The following table shows the elapsed wall-clock time, in seconds, for the test runs on a bird strike model of 16,600 cycles. Engine runtime was considered to calculate speedup.

| VM Size | CPU | Starter Runtime (sec) | Engine Runtime (sec) | Speedup |
|-|-|-|-|-|
| Standard_HB120-16rs_v3 | 4 | 0.94 | 551.99 | 1.00 |
| Standard_HB120-16rs_v3 | 8 | 0.99 | 319.66 | 1.73 |
| Standard_HB120-16rs_v3 | 16 | 2.17 | 222.45 | 2.48 |
| Standard_HB120-32rs_v3 | 32 | 2.54 | 177.43 | 3.11 |
| Standard_HB120-64rs_v3 | 64 | 2.05 | 139.36 | 3.96 |
| Standard_HB120-96rs_v3 | 96 | 3.07 | 136.91 | 4.03 |
| Standard_HB120rs_v3 | 120 | 4.76 | 148.98 | 3.71 |

:::image type="content" source="media/openradioss/bird-strike-speedup.png" alt-text="Diagram that shows the Bird Strike speedup for the Bird Strike model in a single-node configuration." border="false":::

**INIVOL and Fluid Structure Interaction model**

The following table shows the elapsed wall-clock time, in seconds, for the test runs on an INIVOL and Fluid Structure Interaction model of 11,000 cycles. Engine runtime was considered to calculate speedup.

| VM Size | CPU | Starter Runtime (sec) | Engine Runtime (sec) | Speedup |
|-|-|-|-|-|
| Standard_HB120-16rs_v3 | 4 | 5.01 | 1112.19 | 1.00 |
| Standard_HB120-16rs_v3 | 8 | 6.03 | 740.64 | 1.50 |
| Standard_HB120-16rs_v3 | 16 | 6.12 | 472.55 | 2.35 |
| Standard_HB120-32rs_v3 | 32 | 7.77 | 248.38 | 4.48 |
| Standard_HB120-64rs_v3 | 64 | 9.30 | 147.85 | 7.52 |
| Standard_HB120-96rs_v3 | 96 | 10.91 | 128.52 | 8.65 |
| Standard_HB120rs_v3 | 120 | 11.13 | 130.71 | 8.51 |

:::image type="content" source="media/openradioss/inivol-speedup.png" alt-text="Diagram that shows the INIVOL speedup for the INIVOL model in a single-node configuration." border="false":::

**OpenRadioss Performance Results on multi node**

**Yaris Impact Model**

For Yaris Impact model, as the preceding performance results show, a [Standard_HB120-64rs_v3](/azure/virtual-machines/hbv3-series) VM (AMD EPYC™ 7V73X Processors) with 64 cores is the optimal configuration. This configuration was used in the multi-node tests. Sixty-four cores were used on each node.

The following table shows the elapsed wall-clock time, in seconds, for the test runs on a Yaris Impact model of 200,800 cycles and a VM size of Standard_HB120-64rs_v3. Engine runtime was considered to calculate speedup.

| CPU | Thread | Starter Runtime (sec) | Engine Runtime (sec) | Speedup |
|-|-|-|-|-|
| 1 | 64 | 1 | 58.47 | 8373.51 | 1.00 |
| 2 | 128 | 1 | 123.57 | 4578.15 | 1.83 |
| 4 | 256 | 1 | 201.13 | 3064.46 | 2.73 |
| 8 | 512 | 2 | 127.67 | 3133.47 | 2.67 |
| 16 | 1024 | 4 | 117.06 | 3459.74 | 2.42 |

:::image type="content" source="media/openradioss/yaris-speedup.png" alt-text="Diagram that shows the Yaris Impact speedup for the Yaris Impact model in a multi-node configuration." border="false":::

## Azure cost

Only model running time (total run time) is considered for these cost calculations. Application installation time isn't considered. The calculations are indicative. The actual numbers depend on the size of the model.

You can use the wall-clock time and the Azure hourly cost to compute total costs. For the current hourly costs, see [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your configuration.

The following table provides the wall-clock times for single-node configurations.

**Cost for running Bird Strike Model**:

| VM size | Number of CPUs | Wall clock time (hours) |
|-|-|-|
| HB120-16rs_v3 | 4, 8, 16 | 00:18:18 |
| HB120-32rs_v3 | 32 | 00:03:00 |
| HB120-64rs_v3 | 64 | 00:02:21 |
| HB120-96rs_v3 | 96 | 00:02:20 |
| HB120-120rs_v3 | 120 | 00:02:34 |

**Cost for running Drop Container Model**:

| VM size | Number of CPUs | Wall clock time (hours) |
|-|-|-|
| HB120-16rs_v3 | 4, 8, 16 | 00:39:03 |
| HB120-32rs_v3 | 32 | 00:04:16 |
| HB120-64rs_v3 | 64 | 00:02:37 |
| HB120-96rs_v3 | 96 | 00:02:19 |
| HB120-120rs_v3 | 120 | 00:02:22 |

The following table provides the wall-clock times for multi-node configurations.

| VM size | Model | Number of CPUs | Number of nodes | Wall clock time (hours) |
|-|-|-|-|-|
| HB120-64rs_v3 | Yaris Impact Model | 64 | 1 | 02:20:32 |
| HB120-64rs_v3 | Yaris Impact Model | 128 | 2 | 01:18:22 |
| HB120-64rs_v3 | Yaris Impact Model | 256 | 4 | 00:54:26 |
| HB120-64rs_v3 | Yaris Impact Model | 512 | 8 | 00:54:21 |
| HB120-64rs_v3 | Yaris Impact Model | 1024 | 16 | 00:59:37 |

## Summary

- OpenRadioss was successfully tested on HBv3 AMD EPYC™ 7V73X series on Azure VM and Azure CycleCloud multi-node setup.
- OpenRadioss on an Azure VM can solve complex workloads.
- OpenRadioss scales up to four nodes (256 CPUs) for a Yaris Impact model. Models that are larger than a Yaris Impact model (1.4 million nodal points) scale up better when targeting the number of nodes.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Vivi Richard](https://www.linkedin.com/in/vivi-richard) | HPC Performance Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [GPU-optimized virtual machine sizes](/azure/virtual-machines/sizes-gpu)
- [Virtual machines on Azure](/azure/virtual-machines/overview)
- [Virtual networks and virtual machines on Azure](/azure/virtual-network/network-overview)
- [Learning path: Run high-performance computing (HPC) applications on Azure](/learn/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
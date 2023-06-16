This article briefly describes the steps for running the [Autodesk Maya](https://www.autodesk.com/products/maya/overview?term=1-YEAR&tab=subscription) application on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running Maya on Azure.

Maya is a professional toolset for 3D animation, modeling, simulation, and rendering. You can use Maya to create realistic characters, landscapes, and action sequences. Artists, modelers, and animators rely on this award-winning toolset to add lifelike 3D assets to animated and live-action films, TV shows, and video games.

Key features of Maya include:

- Bifrost for Maya, a plug-in that you can use to create physically accurate simulations in a single visual programming environment.
- USD in Maya, an extension for the Universal Scene Description (USD) framework. You can use this extension to load and edit large datasets quickly and to use native tools to work directly with data.
- Fast playback, which provides a fast way to review animations and leads to reduced *playblasts* with the Cached Playback system in Viewport 2.0. A playblast is a real-time preview of an animation in Maya.
- Unreal Live Link for Maya, a plug-in that you can use to stream real-time animation data from Maya to Unreal.
- A nondestructive, clip-based nonlinear time editor for making high-level animation edits.
- A graph editor. You can use this graphical representation of scene animation to create, view, and modify animation curves.
- Polygon modeling, a feature for creating 3D models that uses geometry that's based on vertices, edges, and faces.
- Nonuniform rational basis spline (NURBS) modeling. By using this feature, you can construct 3D models from geometric primitives and drawn curves.
- Character setup for creating sophisticated skeletons, inverse kinematics (IK) handles, and deformers for characters that deliver lifelike performances.

Maya was developed by Autodesk and offers a wide range of powerful tools for animation, simulation, and modeling. You can also use Maya for motion graphics, virtual reality, UV maps, low poly, and character creation. This 3D software is popular in the video game industry. You can use the Maya application to generate 3D assets for games and also for film, television, and commercials. Besides offering a vast library of animation tools, Maya is customizable. Scripting languages like Maya Embedded Language (MEL) and Python provide a way to extend Maya functionality.

To see how to use an Arnold plug-in to use an [Arnold renderer](https://docs.arnoldrenderer.com/display/A5AFMUG/Arnold) directly in Maya, see the [Arnold for Maya User Guide](https://docs.arnoldrenderer.com/display/a5AFMUG/Arnold+for+Maya+User+Guide?preview=/40111191/134645273/car.jpg).

## Why deploy Maya on Azure?

- Modern and diverse compute options to align with your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Strong GPU acceleration, with increased performance as you add GPUs

## Architecture

:::image type="content" source="media/autodesk-maya/autodesk-maya-architecture.png" alt-text="Architecture diagram that shows how to deploy Maya on an Azure VM in a private virtual network. A public IP address provides access to Maya." lightbox="media/autodesk-maya/autodesk-maya-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/autodesk-maya-architecture.vsdx) of this architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines) is used to create Windows VMs. For information about deploying a VM and installing drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) is used to create a private network infrastructure in the cloud.

- [Network security groups](/azure/virtual-network/network-security-groups-overview) restrict access to VMs at the subnet level.

- A public IP address provides users with access to Maya via the internet.

- A physical solid-state drive (SSD) provides storage.

## Deploy infrastructure and install Maya

**Deploy Azure VMs.** Before you install Maya, deploy your Azure VMs. Use a [NVadsA10_v5-series](/azure/virtual-machines/nva10v5-series) VM to run Maya. You should use a Premium SSD managed disk and attach it to the VM.

**Create and configure the supporting infrastructure.** Configure a public IP address for inbound connectivity. Use network security groups to provide security for the subnet.

**Install NVIDIA drivers.** To take advantage of the GPU capabilities of NVadsA10_v5-series VMs, install [NVIDIA GPU drivers](https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html). For information about deploying VMs and installing the drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

## Compute sizing

| Size | vCPUs | Memory (GiB) | SSD (GiB) | GPU partition | GPU memory (GiB) | Maximum data disks |
| --- | --- | --- | --- | --- | --- | --- |
| Standard_NV6ads_A10_v5 | 6 | 55 | 180 | 1/6 | 4 | 4 |
| Standard_NV12ads_A10_v5 | 12 | 110 | 360 | 1/3 | 8 | 4 |
| Standard_NV18ads_A10_v5 | 18 | 220 | 720 | 1/2 | 12 | 8 |
| Standard_NV36ads_A10_v5 | 36 | 440 | 720 | 1 | 24 | 16 |
| Standard_NV72ads_A10_v5 | 72 | 880 | 1400 | 2 | 48 | 32 |

## Maya installation

Before you install Maya, you need to deploy and connect to a VM via Remote Desktop Protocol (RDP) and install the required NVIDIA drivers.

> [!IMPORTANT]
> An NVIDIA Fabric Manager installation is required for VMs that use NV Link or NV Switch.

You can install Maya from the [Autodesk Maya portal](https://www.autodesk.com/products/maya/overview?term=1-YEAR&tab=subscription&plc=MAYA). For a detailed installation procedure, see the [Autodesk Maya help documentation](https://help.autodesk.com/view/MAYAUL/2022/ENU).

## Maya performance results

This performance analysis uses the Autodesk Maya 2023.1 trial version on Windows [NVadsA10_v5-series](/azure/virtual-machines/nva10v5-series) VMs.

The following table provides details about the operating system that's used in testing:

| Operating system | Architecture | Processor |
| --- | --- | --- |
| Windows 10 Pro-20H2 | x86-64 | AMD EPYC 74F3V (Milan) |

The tests use the following model:

:::image type="content" source="media/autodesk-maya/autodesk-maya-open-scene.png" alt-text="Animated image of a character straddling a motorbike. The character has a skull for a head.":::

| Model name | Image size | Image size in inches |
| --- | --- | --- |
| Open scene | HD 1080 | 26.7 x 15.0 |

The following sections provide information about four metrics that measure the performance of Maya on an Azure VM.

### Measurement 1: Open scene performance

The following table lists times for reading the model file with various GPU configurations. The time that it takes to load a test scene is the time that it takes to read a file.

| Number of GPUs | File read time (seconds) |
| --- | --- |
| 1/3 | 15 |
| 1/2 | 13.3 |
| 1 | 12.9 |

The following image shows the loading view:

:::image type="content" source="media/autodesk-maya/autodesk-maya-loading-view.png" alt-text="Animated image of a motorbike parked on an image of a skull.":::

Note these points:

- The loading view is the view that the independent software vendor (ISV) expects to see.
- On tests with 1/6 GPUs, Maya reports an error about not enough free memory remaining in the GPU.

### Measurement 2: Playback performance

The following table lists playback times and rates for various GPU configurations when a MEL script is used:

| Number of GPUs | Playback rate (frames/second) | Total playback time (seconds) |
| --- | --- | --- |
| 1/3 | 23.89 | 17.79 |
| 1/2 | 24.02 | 17.69 |
| 1 | 24.02 | 17.69 |

Note these points:

- The model contains 425 frames.
- The playback time and rate are almost identical for all tested GPU configurations.

### Measurement 3: Arnold renderer performance

The following table shows the rendering time for various GPU configurations. Results from tests with six vCPUs (cores) are used as the baseline for determining speedup.

| Number of GPUs | Rendering time (seconds) | Relative speedup |
| --- | --- | --- |
| 6 vCPUs (cores) | 1,275 | 1.00 |
| 1/3 | 138 | 9.24 |
| 1/2 | 96 | 13.28 |
| 1 | 27 | 47.22 |

The following chart shows the relative speed increase for the model as the number of GPUs increases:

:::image type="content" source="media/autodesk-maya/autodesk-maya-render-speedup.png" alt-text="Chart that compares the rendering speed of various CPU configurations with the rendering speed of six vCPUs.":::

The following image shows the rendered output:

:::image type="content" source="media/autodesk-maya/autodesk-maya-rendered-output.png" alt-text="Animated image of a character with a skull head straddling a motorbike on a red-and-white striped surface.":::

### Measurement 4: Caching performance

The following table lists performance data for caching via a Python script. When you use the Cached Playback feature, you can view changes that you made to the animation without having to create a new playblast.

| Number of vCPUs (cores) | Filling playback (frames/second) | Cached playback (frames/second) | Fill time (seconds) | Memory before playback (MB) | Memory after playback (MB) |
| --- | --- | --- | --- | --- | --- |
| 1/3 | 6.19 | 21.31 | 0.88 | [112,638.88, 18,825.78] | [112,638.88, 18,697.53] |
| 1/2 | 17.09 | 24.11 | 0.67 | [225,278.88, 19,137.05] | [225,278.88, 19,172.94] |
| 1 | 18.86 | 24.11 | 0.60 | [450,558.88, 19,718.22] | [450,558.88, 19,636.18] |

### Additional notes about tests

- Tests on the Maya application run successfully on NVadsA10_v5 VMs on the Azure cloud platform.
- In tests of the rendering process on an NVadsA10_v5 VM, Maya scales well from a partial to a full GPU configuration.
- Tests of the caching performance show that the fill time decreases as the configuration improves.

## Azure cost

The following table lists the elapsed times in hours for running the model with various GPU configurations. To compute the total cost, multiply these times by the Azure VM hourly cost for an NVadsA10_v5 VM. For the current hourly cost, see [Windows Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing) and [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing).

| Number of GPUs | Elapsed time (hours) |
| --- | --- |
| 1/3 | 0.0041 |
| 1/2 | 0.0036 |
| 1 | 0.0035 |

Only the model running time, or wall clock time, is considered for these cost calculations. The application installation time isn't considered. The calculations are indicative of your potential results, but actual values depend on the size of your model.

To estimate the cost of your configuration, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).

## Summary

- You can successfully deploy and run Maya on NVadsA10_v5-series VMs.
- In tests of the rendering process on an NVadsA10_v5 VM, Maya scales well from a partial to a full GPU configuration.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) | HPC Performance Engineer

Other contributors:

- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [GPU optimized virtual machine sizes](/azure/virtual-machines/sizes-gpu)
- [Virtual machines in Azure](/azure/virtual-machines/overview)
- [Virtual networks and virtual machines in Azure](/azure/virtual-network/network-overview)
- [Training path: Run high-performance computing (HPC) applications on Azure](/training/paths/run-high-performance-computing-applications-azure)

## Related resources

- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)

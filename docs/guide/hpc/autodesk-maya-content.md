This article briefly describes the steps for running the [Autodesk Maya](https://www.autodesk.com/products/maya/overview?term=1-YEAR&tab=subscription) application on a virtual machine (VM) that's deployed on Azure. It also presents the performance results of running Autodesk Maya on Azure.

Maya is a professional 3D animation, modeling, simulation, and rendering toolset that's designed to create realistic characters and blockbuster-worthy effects. From fantastic creatures to sweeping landscapes and explosive battle sequences, Maya provides tools for creating stunning visuals. Top artists, modelers, and animators rely on Maya's award-winning toolset to add lifelike 3D assets to today's most-loved animated and live-action films, TV shows, and video games.

Key features of Autodesk Maya include:

- Bifrost for Maya for creating physically accurate simulations in a single visual programming environment.
- USD in Maya for loading and editing large datasets quickly and for using native tools to work directly with data.
- Fast playback, which provides a fast way to review animations and leads to reduced playblasts with cached playback in Viewport 2.0.
- Unreal Live Link for Maya, a plug-in that you can use to stream real-time animation data from Maya to Unreal.
- A non-destructive, clip-based nonlinear time editor that you can use to make high-level animation edits.
- A graph editor. You can use this graphical representation of scene animation to create, view, and modify animation curves.
- Polygon modeling for creating 3D models by using geometry that's based on vertices, edges, and faces.
- NURBS modeling for constructing 3D models from geometric primitives and drawn curves.
- Character setup for creating sophisticated skeletons, IK handles, and deformers for characters that deliver lifelike performances.

Maya was developed by Autodesk and offers a wide range of animation, simulation, and modeling tools. You can also use it for motion graphics, virtual reality, UV maps, low poly, and character creation. This 3D software is very popular in the video game industry. You can use the Maya application to generate 3D assets for games and also for film, television, and commercials. Maya is known as a powerful application for animation that offers a vast library of animation tools. It's also very customizable if you're familiar with MEL or Python, which are the scripting languages in Maya.

To see how to use an Arnold plug-in to use an [Arnold renderer](https://docs.arnoldrenderer.com/display/A5AFMUG/Arnold) directly in Autodesk Maya, see the [Arnold for Autodesk Maya User Guide](https://docs.arnoldrenderer.com/display/a5AFMUG/Arnold+for+Maya+User+Guide?preview=/40111191/134645273/car.jpg).

## Why deploy Autodesk Maya on Azure?

- Modern and diverse compute options to align with your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- Strong GPU acceleration, with increased performance as you add GPUs

## Architecture

:::image type="content" source="media/autodesk-maya/autodesk-maya-architecture.png" alt-text="Architecture diagram that shows how to deploy Autodesk Maya." lightbox="media/autodesk-maya/autodesk-maya-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/autodesk-maya-architecture.vsdx) of this architecture.*

### Components

- [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines) is used to create Windows VMs. For information about deploying a VM and installing drivers, see [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml).

- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) is used to create a private network infrastructure in the cloud.

- [Network security groups](/azure/virtual-network/network-security-groups-overview) restrict access to VMs at the subnet level.

- A public IP address allows users to access Maya via the internet.

- A  physical solid-state drive (SSD) provides storage.

## Deploy infrastructure and install Autodesk Maya

**Deploy Azure VMs.** Before you install Maya, deploy your Azure VMs. Use a [NVadsA10_v5](https://learn.microsoft.com/azure/virtual-machines/nva10v5-series) series VM to run Maya. You should use a Premium SSD managed disk and attach it to the VM.

**Create and configure the supporting infrastructure.** Configure a public IP address for inbound connectivity and use network security groups to provide security for the subnet.

**Install NVIDIA drivers.** To take advantage of the GPU capabilities of NVadsA10_v5 series VMs, install [NVIDIA GPU drivers](https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html). For information about deploying VMs and installing the drivers, see [Run a Windows VM on Azure](https://learn.microsoft.com/azure/architecture/reference-architectures/n-tier/windows-vm).

## Compute sizing

| Size | vCPU | Memory (GiB) | SSD (GiB) | GPU partition | GPU memory (GiB) | Maximum data disks |
| --- | --- | --- | --- | --- | --- | --- |
| Standard_NV6ads_A10_v5 | 6 | 55 | 180 | 1/6 | 4 | 4 |
| Standard_NV12ads_A10_v5 | 12 | 110 | 360 | 1/3 | 8 | 4 |
| Standard_NV18ads_A10_v5 | 18 | 220 | 720 | 1/2 | 12 | 8 |
| Standard_NV36ads_A10_v5 | 36 | 440 | 720 | 1 | 24 | 16 |
| Standard_NV72ads_A10_v5 | 72 | 880 | 1400 | 2 | 48 | 32 |

### Required drivers

To use Inventor on NCasT4_v3 and NVadsA10_v5 VMs, you need to install NVIDIA and AMD drivers.

## Autodesk Maya installation

Before you install Autodesk Maya, you need to deploy and connect to a VM via Remote Desktop Protocol (RDP) and install the required NVIDIA drivers.

> [!IMPORTANT]
> An NVIDIA Fabric Manager installation is required for VMs that use NV Link or NV Switch.

You can install Maya from the [Autodesk Maya portal](https://www.autodesk.com/products/maya/overview?term=1-YEAR&tab=subscription&plc=MAYA). For a detailed installation procedure, see the  [Autodesk Maya Help](https://help.autodesk.com/view/MAYAUL/2022/ENU/) documentation.

## Autodesk Maya performance results

The performance analysis used the Autodesk Maya 2023.1 trial version on Windows [NVadsA10 v5-series](https://learn.microsoft.com/en-us/azure/virtual-machines/nva10v5-series) VMs.

The following table provides details about the operating system that was used for testing.

| Operating system | Architecture | Processor |
| --- | --- | --- |
| Windows 10 Pro-20H2 | x86-64 | AMD EPYC 74F3V (Milan) |

The following model was used for testing.

:::image type="content" source="media/autodesk-maya/autodesk-maya-open-scene.png" alt-text="Image of an animated character on a motorcycle.":::

The following table provides details about the model.

| Name | Image size | Image size in inches |
| --- | --- | --- |
| Open scene | HD 1080 | 26.7 x 15.0 inches |

## Azure cost



## Summary



## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) | HPC Performance Engineer

Other contributors:

- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director Business Strategy
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps



## Related resources



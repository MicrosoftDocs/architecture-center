---
title: Deploy Autodesk VRED for HPC on Azure
description: Learn how to deploy Autodesk VRED on Azure. Review performance results on two Azure virtual machines. 
author: gauharjunnarkar
ms.author: gajunnar
ms.date: 02/07/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-virtual-machines
categories:
  - compute
---

# Deploy Autodesk VRED for HPC on Azure

Autodesk VRED is a 3D visualization application that helps automotive designers and engineers create product presentations, design reviews, and virtual prototypes by using interactive CPU and GPU ray tracing. VRED, which was previously limited to CPU, now uses GPU technology to support the high demands of consumers and provide interactive ray tracing and AI-powered denoising.

By using VRED, users can create digital prototypes to gain insight into how vehicles will look and perform. To be effective in guiding design decisions, the digital prototypes need to look and behave as close as possible to the real vehicles. This solution is ideal for the automotive and manufacturing industries.

This article briefly describes the steps for running VRED on a virtual machine (VM) that's deployed on Azure. It also provides performance results. For more information about VRED, see the [Autodesk website](https://www.autodesk.com/products/vred/features/vred).

VRED 2022.1 was successfully deployed and tested on [NC64as_T4_v3](/azure/virtual-machines/nct4-v3-series) and [NV48s_v3](/azure/virtual-machines/nvv3-series) Azure VMs. VRED 2023.1 was deployed and tested on [NC64as_T4_v3](/azure/virtual-machines/nct4-v3-series) and [NVadsA10 v5](/azure/virtual-machines/nva10v5-series) VMs.

## Install VRED on a VM

Before you install VRED, you need to deploy and connect a VM and install the required NVIDIA and AMD drivers.

> [!IMPORTANT]
> NVIDIA Fabric Manager installation is required for VMs that use NVLink or NVSwitch.

For information about deploying the VM and installing the drivers, see one of these articles:

- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)

To download VRED:

1. Sign in to your Autodesk account.
1. Search for VRED in **Products and Services**.
1. Install VRED Professional.

### Install License Manager

Before you install VRED on an Azure VM, you need to install Autodesk Network License Manager on the VM. You can [install Network License Manager for Windows here]( https://knowledge.autodesk.com/search-result/caas/downloads/content/autodesk-network-license-manager-for-windows.html).

During installation, this folder is created: C:\Autodesk\Network License Manager\.

After installation, generate a license file from your Autodesk account and save it in the Network License Manager folder. Create a text file named *debug.log* and save it in the same folder.

To generate the license file:

1. While signed in to your Autodesk account, select **VRED Professional downloads**.
1. Select **Generate network license file**.
1. Provide the server or VM name and the physical or MAC address.
1. Select the product.
1. Select **Get License File**. The license file is generated.

To configure the license server on Windows:

1. Open Network License Manager by typing **lmtools** in the Windows search bar and selecting it in the results. A GUI opens.
1. Select **Config Services** and provide the service name, in this case, **Autodesk Network License Manager**.
1. Provide the path of the license file and the other requested paths.
1. Select **Start Server at Power Up** at the bottom of the window.
1. Select **Save Service** and follow the prompts that appear.
1. On the **Start/Stop/Reread** tab, select **Start Server**. You should see the service name **Autodesk Network License Manager** highlighted in blue.

The Network License Manager installation is complete.

:::image type="content" source="media/license-manager-installation.png" alt-text="Screenshot that shows the LMTOOLS interface." lightbox="media/license-manager-installation.png" border="false":::

> [!NOTE]
> For Linux configuration instructions, see [Configure and start your license server](https://www.autodesk.com/support/download-install/admins/network-licenses/configure-and-start-your-license-server).

## VRED performance on Azure VMs

Rendering time is an important parameter for visualization and design software. Designers often spend a lot of time on the rendering process. By incorporating advanced capabilities like CPU and GPU ray tracing, VRED drastically reduces rendering times. To perform these complex rendering simulations on VRED, you need to use the right hardware. Microsoft partners with Nvidia to provide suitable infrastructure and hardware on Azure. Azure provides the fastest compute capabilities for both CPU-intensive and GPU-intensive workloads.

### Rendering

The term *rendering* refers to the automatic process of generating digital images from three-dimensional models by using specialized software. The images simulate a 3D model's photorealistic environments, materials, lighting, and objects.

**Real-time rendering** is mainly used in gaming and interactive graphics, where images are calculated from 3D information at a fast pace. Dedicated graphics hardware has improved the performance of real-time rendering to ensure rapid image processing.

**Offline rendering** is used when less processing speed is required. Visual effects provide the highest standards of photorealism. In contrast to real-time rendering, there's no unpredictability with offline rendering.

**Ray tracing** is a rendering technique that can produce highly realistic lighting effects. Ray tracing generates lifelike shadows and reflections and much-improved translucence and scattering, taking into account light phenomena like reflection and refraction. In VRED, there are two primary ray tracing options: CPU ray tracing and GPU ray tracing.

### VRED application settings for rendering

You can activate CPU and GPU ray tracing in VRED according to your requirements. To activate CPU/GPU ray tracing, select **Visualization** > **Raytracing** > **CPU/GPU Raytracing**.

#### Anti-aliasing settings

For CPU and GPU ray tracing rendering in these tests, we set the anti-aliasing option to high: **Visualization** > **Realtime Antialiasing** > **High**

#### Rendering settings

Select the rendering settings as shown here:

:::image type="content" source="media/rendering-settings.png" alt-text="Screenshot that shows the rendering settings." lightbox="media/rendering-settings.png" border="false":::

**Saving images**

You can save a rendered image to the desired location by selecting the path on the **File Output** tab in the **Render Settings** window. You can also choose an image size, like **HD** or **4K**, under **Image Size Presets**. We used **HD**.

**General Settings**

For CPU and GPU ray tracing, you need to select image samples for anti-aliasing. Your anti-aliasing output improves as you increase the number of samples. Under **General Settings**, we selected the maximum number: **1024**. For OpenGL, you can use a lower number, between 16 and 32 images, for example.

:::image type="content" source="media/general-settings-tab.png" alt-text="Screenshot that shows the general settings tab in Render Settings." lightbox="media/general-settings-tab.png" border="false":::

**Raytracing Quality**

In the **Raytracing Quality** settings, for the **Illumination Mode** for both interactive and still frame, we used **Full Global Illumination**.

## Benchmarking methodology for VRED performance analysis on VMs

To analyze the performance of VRED on [NC64as_T4_v3](/azure/virtual-machines/nct4-v3-series) and [NV48s_v3](/azure/virtual-machines/nvv3-series) VMs, we tested offline image rendering and calculated the rendering times for both CPU ray tracing and GPU ray tracing. For this analysis, we rendered 4k and HD images. We tested GPU ray tracing on NC64as_T4_v3 and NV48s_v3 VMs by using 1, 2, 3, and 4 GPUs and on NVadsA10_v5 by using 1 and 2 GPUs. For CPU ray rendering, the application uses all CPU cores on the VM. We then calculated the relative speed increase of GPU rendering as compared to CPU rendering. The results are presented in the following sections.

### VRED 2022.1 performance results on the NC64as_T4_v3 VM

#### CPU and GPU rendering times

:::image type="content" source="media/ncas-t4-render-times.png" alt-text="Graphs that show CPU and GPU rendering times for NCas_T4." lightbox="media/ncas-t4-render-times.png" border="false":::

#### Relative speed increases between CPU and GPU ray tracing

:::image type="content" source="media/ncas-t4-speed-increase.png" alt-text="Graphs that show the relative speed increases for NCas_T4." lightbox="media/ncas-t4-speed-increase.png" border="false"::: 

### VRED 2022.1 performance results on the NV48s_v3 VM

#### CPU and GPU rendering times

:::image type="content" source="media/nv48s-v3-render-times.png" alt-text="Graphs that show CPU and GPU rendering times for NV48s_v3." lightbox="media/nv48s-v3-render-times.png" border="false":::
 
> [!NOTE]
> During GPU rendering on a NV48s_v3 VM with 1 GPU, the application produced an error when rendering with 4K and higher resolution. HD image rendering works fine. The results depend on the model's complexity and environment settings. For large-scale models, we don't recommend the 1-GPU setting.

#### Relative speed increases between CPU and GPU ray tracing

:::image type="content" source="media/nv48s-v3-speed-increase.png" alt-text="Graphs that show the relative speed increases for NV48s_v3." lightbox="media/nv48s-v3-speed-increase.png" border="false"::: 

### VRED 2023.1 performance results on the NC64as_T4_v3 VM

#### CPU and GPU rendering times

:::image type="content" source="media/vred-2023-image-render-time.png" alt-text="Graphs that show CPU and GPU rendering times for VRED 2023.1 on NC64as_T4_v3." lightbox="media/vred-2023-image-render-time.png" border="false":::

#### Relative speed increases between CPU and GPU ray tracing

:::image type="content" source="media/vred-2023-image-increase.png" alt-text="Graphs that show the relative speed increases for VRED 2023.1 on NC64as_T4_v3." lightbox="media/vred-2023-image-increase.png" border="false"::: 

### VRED 2023.1 performance results on the NVadsA10_v5 VM

#### CPU and GPU rendering times

:::image type="content" source="media/vred-2023-render-time-nvv5.png" alt-text="Graphs that show CPU and GPU rendering times for NVadsA10_v5." lightbox="media/vred-2023-render-time-nvv5.png" border="false":::

#### Relative speed increases between CPU and GPU ray tracing

:::image type="content" source="media/vred-2023-increase-nvv5.png" alt-text="Graphs that show the relative speed increases for VRED 2023.1 on NVadsA10_v5." lightbox="media/vred-2023-increase-nvv5.png" border="false":::

## Pricing

Only model running time (wall clock time) is considered for these cost calculations. Application installation time isn't considered. The calculations are indicative. The actual numbers depend on the size of the model.

You can use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your configuration.

You can use the rendering times provided in the following tables and the Azure hourly costs to compute rendering costs. For example, if the Azure VM hourly cost is $8.60 and the rendering time is 11 minutes and 47 seconds, the cost is $1.69. For current Azure hourly costs, see [Windows Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/#pricing) or [Linux Virtual Machines Pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/#pricing). 

### Azure cost for VRED 2022.1

#### GPU rendering costs 

|VM  |Number of GPUs on VM  |  4K image render time  |HD image render time|
|---------|---------|---------|---|
|NC64as_T4_v3     |    4     |         11 minutes and 47 seconds       |3 minutes and 48 seconds|
|NV48s_v3     |    4     |         49 minutes and 21 seconds      |15 minutes and 49 seconds|

#### CPU rendering costs

|VM   | Number of CPU cores  |4K image render time  |HD image render time|
|---------|---------|---------|---|
|NC64as_T4_v3     |    64            |  21 minutes and 13 seconds       |5 minutes and 48 seconds|
|NV48s_v3     |  48           | 55 minutes and 48 seconds  |14 minutes and 27 seconds|

### Azure cost for VRED 2023.1

#### GPU rendering costs 

|VM  |Number of GPUs on VM  |  4K image render time  |HD image render time|
|---------|---------|---------|---|
|NC64as_T4_v3     |    4     |         11 minutes and 20 seconds       |2 minutes and 57 seconds|
|NVadsA10_v5     |    2     |         9 minutes and 49 seconds      |2 minutes and 49 seconds|

#### CPU rendering costs

|VM   | Number of CPU cores  |4K image render time  |HD image render time|
|---------|---------|---------|---|
|NC64as_T4_v3     |    64            |  19 minutes and 3 seconds       |5 minutes and 6 seconds|
|NVadsA10_v5     |  72           | 19 minutes and 34 seconds  |5 minutes and 3 seconds|


## Results and recommendations

- VRED was successfully deployed and tested on NCas_T4_v3, NVv3, and NVadsA10_v5 series VMs on Azure.
- On NC64as_T4, GPU rendering is 1.8 times faster than CPU rendering.
- On NVadsA10_v5, GPU rendering is 1.94 times faster than CPU rendering.
- On NVv3, GPU rendering doesn't significantly improve rendering time as compared to CPU rendering.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager
- [Vinod Pamulapati](https://www.linkedin.com/in/vinod-reddy-20481a104) | HPC Performance Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Jason Bouska](https://www.linkedin.com/in/jasonbouska) | Senior Software Development Engineer
- [Guy Bursell](https://www.linkedin.com/in/guybursell) | Director, Business Strategy 
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [GPU optimized virtual machine sizes](/azure/virtual-machines/sizes-gpu)
- [Windows virtual machines on Azure](/azure/virtual-machines/windows/overview)
- [Linux virtual machines on Azure](/azure/virtual-machines/linux/overview)
- [Learning path: Run high-performance computing (HPC) applications on Azure](/training/paths/run-high-performance-computing-applications-azure)
- [Virtual networks and virtual machines in Azure](/azure/virtual-network/network-overview)
- [VRED Render Settings and Modes](https://knowledge.autodesk.com/support/vred-products/learn-explore/caas/CloudHelp/cloudhelp/2018/ENU/VRED/files/GUID-281BFE63-D833-431C-95E3-4EA418201954-htm.html)

## Related resources

- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
- [Deploy ADS CFD Code Leo for HPC on a virtual machine](hpc-ads-cfd.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)

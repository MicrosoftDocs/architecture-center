Autodesk VRED is a 3D visualization application that helps automotive designers and engineers create product presentations, design reviews, and virtual prototypes by using interactive CPU and GPU ray tracing. VRED, which was previously limited to CPU, now uses GPU technology to support the high demands of consumers and provide interactive ray tracing and AI-powered denoising. This technology enables users to gain immediate visual feedback to see how a vehicle's aesthetics will interact with various environments in real time.

By using VRED, users can create digital prototypes so they can gain insight into how vehicles will look and perform. To be effective in guiding design decisions, the digital prototypes need to look and behave as close as possible to the real vehicles.  

This article briefly describes the steps for running VRED on a virtual machine (VM) that's deployed on Azure. It also provides performance results. For more information about VRED, see the [Autodesk website](https://www.autodesk.com/products/vred/features/vred).

VRED was successfully deployed and tested on [NC64as_T4_v3](/azure/virtual-machines/nct4-v3-series) and [NV48s_v3](/azure/virtual-machines/nvv3-series) Azure VMs.  

## Install VRED on a VM

Before you install VRED, you need to deploy and connect a VM and install the required NVIDIA and AMD drivers.

For information about deploying the VM, see one of these articles:

- [Run a Windows VM on Azure](/azure/architecture/reference-architectures/n-tier/windows-vm)
- [Run a Linux VM on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm)

To download VRED:

1. Sign in to you Autodesk account.
1. Search for VRED in **Products and Services**.
1. Install VRED Professional.

### Install License Manager

Before you install VRED on an Azure VM, you need to install Autodesk Network License Manager on the VM. You can [install Autodesk Network License Manager for Windows here]( https://knowledge.autodesk.com/search-result/caas/downloads/content/autodesk-network-license-manager-for-windows.html).

During installation, this folder is created: C:\Autodesk\Network License Manager\.

Next, generate a license file from your Autodesk account and keep the license file in the Network License Manager folder. Create a text file named *debug.log* and save it in the same folder.

To generate the license file:

1. While signed in to your Autodesk account, select **VRED Professional downloads**.
1. Select **Generate network license file**.
1. Provide the server or VM name and the physical or MAC address.
1. Select the product.
1. Select **Get License File**. The license file is generated.

To configure the license server:

1. From the Windows search bar, open lmtools. A GUI opens.
1. Select **Config Services** and provide the service name, in this case, **Autodesk Network License Manager**.
1. Provide the path of the license file and the other paths.
1. Select **Start Server at Power Up** at bottom of the window.
1. Select **Save Service** and follow the prompts that appear.
1. On the **Start/Stop/Reread** tab, select **Start Server**. You should see the service name **Autodesk Network License Manager** highlighted in blue.

The Network License Manager installation is complete.

image 

## VRED performance on Azure VMs

Rendering time is an important parameter for visualization and design software. Designers often spend a lot of time on the rendering process. By incorporating advanced capabilities like CPU and GPU ray tracing, VRED has drastically reduced render times. To perform these complex rendering simulations on VRED, you need to use the right hardware. Microsoft partners with Nvidia to provide suitable infrastructure and hardware on Azure. Azure provides the fastest compute capabilities for both CPU-intensive and GPU-intensive workloads.

### Rendering

The term *rendering* refers to the automatic process of generating digital images from three-dimensional models by using specialized software. The images simulate a 3D model's photorealistic environments, materials, lighting, and objects.

**Real-time rendering** is mainly used in gaming and interactive graphics, where images are calculated from 3D information at a fast pace. Dedicated graphics hardware has improved the performance of real-time rendering to ensure rapid image processing.

**Offline rendering** is mainly used when less processing speed is required. Visual effects provide the highest standards of photorealism. In contrast to real-time rendering, there is no unpredictability with offline rendering.

**Ray tracing** is a rendering technique that can produce highly realistic lighting effects. Ray tracing generates lifelike shadows and reflections and much-improved translucence and scattering, taking into account light phenomena like reflection and refraction. In VRED, there are mainly two ray tracing options: CPU ray tracing and GPU ray tracing.

### VRED application settings for rendering 

You can activate CPU and GPU ray tracing in VRED according to your requirements. To activate CPU/GPU ray tracing, select **Visualization** > **Raytracing** > **CPU/GPU Raytracing**.

#### Anti-aliasing settings

For CPU and GPU ray tracing rendering, we set the anti-aliasing option to high:

- **Visualization** > **Realtime Antialiasing** > **High**

#### Render settings

Select the render settings as shown here:

image

**Saving images**

You can save a rendered image to the desired location by selecting the path on the **File Output** tab in the **Render Settings** window. You can also choose an image size, like **HD** or **4K**, under **Image Size Presets**. We used **HD**.

**General Settings** 

For CPU and GPU ray tracing, you need to select image samples for anti-aliasing. Your anti-aliasing output improves as you increase the number of samples. Under **General Settings**, we selected the maximum number: **1024**. For OpenGL, you can use a lower number, between 16 and 32 images, for example.

image 

**Raytracing Quality**

In the **Raytracing Quality** settings, for the **Illumination Mode** for both interactive and still frame, we used **Full Global Illumination**.

## Benchmarking methodology for VRED performance analysis on VMs

To analyze the performance of VRED on [NC64as_T4_v3](/azure/virtual-machines/nct4-v3-series) and [NV48s_v3](/azure/virtual-machines/nvv3-series) VMs, we tested offline image rendering and calculated the rendering times for both CPU ray tracing and GPU ray tracing. For this analysis, we rendered 4k and HD images. We tested GPU ray tracing on both VMs by using 1, 2, 3, and 4 GPUs. For CPU ray rendering, the application uses all CPU cores on the VM. We then calculated the relative speed increase of GPU rendering as compared to CPU rendering. The results are presented in the following sections.

### VRED performance results on NCas_T4 VM

CPU and GPU Rendering times

2 images 

Relative speedup between CPU and GPU raytracing:

2 images 

Autodesk VRED Performance Results on NVv3 VM
CPU and GPU rendering times

2 images 

Note: GPU Rendering with 1 GPU settings on NVv3 VMs, application produced an error while rendering with 4K and higher resolution setting. It works fine with HD image rendering. It depends on the model complexity and environment setting for the model. For larger scale models, 1 GPU setting is not recommended.

Relative speedup between CPU and GPU raytracing:

2 images 

Pricing

The application installation time not considered for Azure cost calculation, only model run time (wall clock time) considered for cost calculation. Please note following calculation is indicative, the actuals would depend on the model size.

For the cost estimate, [Azure calculator](https://azure.microsoft.com/pricing/calculator) can be used for the required configuration.

GPU Rendering cost


|VM Name  |# GPUs on VM  |Azure VM hourly cost ($)  |4K Image Render time  |Total Azure consumption of 4k Image|HD Image Render time|Total Azure consumption of HD Image|
|---------|---------|---------|---------|---|---|----|
|NC64as_T4_v3     |    4     |  $8.60       |  11 min 47 sec       |$1.69|3 min 48 sec|$0.54|
|NV48s_v3     |    4     |  $8.59       |   49 min 21 sec      |$7.06|15 min 49 sec|$2.26|

CPU Rendering cost

|VM Name  | No. of CPU cores |Azure VM hourly cost ($)  |4K Image Render time  |Total Azure consumption of 4k Image|HD Image Render time|Total Azure consumption of HD Image|
|---------|---------|---------|---------|---|---|----|
|NC64as_T4_v3     |    64     |  $8.60       |  21 min 13 sec       |$3.04|5 min 48 sec|$0.83|
|NV48s_v3     |  48    |  $8.59       | 55 min 48 sec  |$8.00|14 min 27 sec|$2.07|

Summary

- VRED Application is successfully deployed and tested on NCas_T4_v3 series VMs and NVv3 series Virtual Machines on Azure Platform
- NC64as_T4 VM, GPU rendering is 1.8 times faster than the CPU rendering. 
- NC64as_T4 Virtual Machine is recommended for VRED application as it demonstrated a better performance for both CPU and GPU rendering timelines.
- For NVv3 VM, it was observed that there isn’t much improvement in GPU rendering times compared to CPU rendering time.

## Contributors

## Next steps

- [GPU Optimized Virtual Machine Sizes](/azure/virtual-machines/sizes-gpu)
- [Windows Virtual Machines in Azure](/azure/virtual-machines/windows/overview)
- [Linux Virtual Machines in Azure](/azure/virtual-machines/linux/overview)

## Related resources

- [Run a Windows VM on Azure](/azure/architecture/reference-architectures/n-tier/windows-vm)
- [Run a Linux VM on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm) 

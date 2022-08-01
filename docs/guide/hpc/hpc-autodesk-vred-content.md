Autodesk VRED Overview

Autodesk VRED is a 3D visualization software which helps Automotive Designers and Engineers create product presentations, design reviews and virtual prototypes using interactive CPU and GPU ray tracing. Autodesk VRED, which was previously limited to CPU, now leverages GPU technology to support the high demands of consumers and provide interactive ray tracing and AI-powered Denoising. This allows users to gain immediate visual feedback to see how a vehicle’s aesthetics will interact with different environments in real time

Autodesk VRED enables users to create digital prototypes so they can gain insight into how vehicles will look and perform. To be effective in guiding design decisions, the digital prototypes need to look and behave as close as possible to the real thing  

This article briefly describes the steps to run Autodesk VRED application on a Virtual Machine deployed in Azure Cloud Platform and presents the performance results. Learn more about VRED application @ https://www.autodesk.com/products/vred/features/vred

Autodesk VRED Application has been successfully deployed and tested on the Azure VM configurations  [NC64as_T4_v3](/azure/virtual-machines/hbv3-series) & [NV48s_v3](/azure/virtual-machines/hbv3-series)  

Prior to installing the Autodesk VRED application, you’ll need to deploy and connect a virtual machine, and install the required NVIDIA and AMD drivers. 

Run a Windows VM on Azure (/azure/architecture/reference-architectures/n-tier/windows-vm)
Run a Linux VM on Azure (/azure/architecture/reference-architectures/n-tier/linux-vm)

Install Autodesk VRED application on a VM

DOWNLOAD THE PRODUCT

- Log in to **Autodesk** account
- Search under **Products and Services**
- Install VRED Professional

License Manager Installation

As a prerequisite to install VRED Application on Azure Virtual Machine, Autodesk Network License Manager needs to be installed on the VM. Autodesk Network License Manager for Windows can be found in the below link: https://knowledge.autodesk.com/search-result/caas/downloads/content/autodesk-network-license-manager-for-windows.html 

- Install **.msi** file

After installation, a folder with name Network License Manager will be created in the path as shown here:  C:\Autodesk\Network License Manager\ 

Now generate the license file from user’s Autodesk account and keep the license file in the Network License Manager folder. Create a text file with name “debug.log” and keep it in the same Network License Manager folder.

Generating license file:

From the Autodesk account,

- Select VRED Professional downloads > click on Generate network license file
- Fill the details of Server or VM Name and Physical address or MAC address > Select the Product > click on Get License File, the license file will be generated.

From the windows search bar, open lmtools, a GUI will open. Select Config Services and name the service name, in this case it is named Autodesk Network License Manager. Give the license file path where we placed it and fill the other paths as shown here. Now tick mark the ‘Start Server at Power Up’ at bottom and select ‘Save Service’ button and then follow the automatic messages which will pop up. Now select the Start/Stop/Reread button from the top ribbon and then select Start Server. The service name – ‘Autodesk Network License Manager’ should be seen under blue color. Once user clicks on start server, the below GUI should show up with service name “Autodesk Network License Manager”. Now the License Manager installation is complete.

image 

Performance results of Autodesk VRED on Azure VMs

When it comes to performance parameters, rendering time is one parameter which need to be carried out on visualization and design software. Often designers spend a lot of time in rendering process. With advanced capabilities like CPU & GPU ray tracing, VRED has drastically reduced the Render times over the period. To carry out these complex and heavy rendering simulations on VRED software, right hardware is must. Microsoft partners with Nvidia provides the required and suitable Infrastructure and hardware on Azure cloud platform. Microsoft Azure provides the latest and fastest compute capabilities for both CPU & GPU intensive workloads

Rendering

The term rendering defines the automatic process of generating digital images from three-dimensional models, by means of a special software. These images simulate project or 3D model’s photorealistic environments, materials, lights and objects.

Types of Rendering and Techniques 

**Rendering Real Time:** Real-time rendering is mainly used in gaming and interactive graphics, where images are calculated from 3D information at a very fast pace. As a result, dedicated graphics hardware has improved the performance of real-time rendering ensuring rapid image processing.

**Rendering offline:** Offline rendering is a technique mainly used in situations where the need for processing speed is lower. Visual effects work where photorealism needs to be at highest standard possible. There is no unpredictability, unlike real time

Ray tracing

Ray tracing is a rendering technique that can produce incredibly realistic lighting effects. Ray tracing generates lifelike shadows and reflections, along with much-improved translucence and scattering, considering light phenomena such as reflection and refraction. In VRED, there are mainly two types of Ray Tracing options, CPU ray tracing and GPU ray tracing.

VRED application Settings for the Rendering 

We can activate the CPU and GPU Raytracing options in VRED based on our Rendering requirements. To activate CPU/GPU Raytracing in VRED application,

- Visualization> Raytracing> CPU/GPU Raytracing

Antialiasing settings

For the CPU and GPU raytracing rendering, we have kept the antialiasing option to high 
•	Visualization > Realtime Antialiasing > High

Render settings

For render setting select the render option in VRED as shown below

image

Saving the Images

User can save the image rendered in the desired location or path in desktop from selecting the option under Image option from Render settings tab. The image size like HD or 4K is also selected from the dropdown box under Image Size Presents. Here we have selected HD Image

**General Settings:** For CPU and GPU Raytracing, Image samples must be selected for Antialiasing, more the number of samples, better the antialiasing output. Under general settings, we have selected the maximum number, 1024 Image samples for Antialiasing. For open GL less number can be selected like 16 to 32 samples.

image 

Raytracing Quality:

For Illumination mode for both interactive and still frame mode, Full Global Illumination option is selected under the Raytracing Quality settings

Benchmarking Methodology used for Autodesk VRED Performance Analysis on Azure Virtual Machines:

To Analyze the performance of VRED on Azure VMs  NC64as_T4_v3 & [NV48s_v3](/azure/virtual-machines/nvv3-series), [NV48s_v3](),  we carried out offline image rendering task and calculated the render times for CPU ray tracing and GPU Ray tracing. For this Benchmarking analysis, we have used 4k and HD images for rendering. The GPU ray tracing has been performed on both the Virtual Machines by varying the number of GPUs from 1 to 4 GPUs. For CPU ray rendering, the application will utilize all the CPU cores present in the Virtual Machine. We then calculated the relative speedup of GPU rendering compared with the CPU rendering. The performance results of VRED on both the Virtual Machines has been presented in the below sections

Autodesk VRED Performance Results on NCas_T4 VM

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

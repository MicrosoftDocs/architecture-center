This article briefly explains the steps to run ADS CFD Code Leo application on a Virtual Machine deployed in Azure Cloud Platform and presents the performance results. Learn more about ADS CFD at [ADS CFD Inc. (aerodynamic-solutions.com)](https://new.aerodynamic-solutions.com).

The ADS CFD flow solver, Code Leo, is a URANS-based flow solver that delivers both accurate and fast flow simulations for general flow configurations
- It is a density-based, compressible flow code, with explicit time-marching, and convergence acceleration.
- It is second order accurate in time and space with low numerical smoothing
- It is used to run both the steady-state and unsteady simulations
- It can handle both structured multi-block meshes and unstructured meshes with mixed tetrahedrons, pyramids, prisms and hex elements.
- It allows use of various turbomachinery rotor/stator interaction models including the sliding mesh, mixing plane and frozen rotor models.

Originally designed for CPUs, ADS CFD has extended it to take advantage of the advanced GPU architecture following the advent of cost-effective GPUs. The methods used have been validated over multiple decades by industry leaders including AFRL, and NASA. Code Leo allows users to switch easily between CPU and GPU solvers.
 
The ADS CFD software is used primarily in the aerospace and turbomachinery industries for performance and durability assessments of jet engines and aircraft. One of the main use cases is the analysis and optimization of the integrated engine/aircraft configurations so that next generation aircraft designs can be closed on time and with confidence

Prior to installing the ADS CFD Code Leo application, you’ll need to deploy and connect a virtual machine, and install the required NVIDIA and AMD drivers. 

**Run a Windows VM on Azure** (https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/windows-vm)
**Run a Linux VM on Azure** (https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm)

Install ADS CFD Code Leo application on a Virtual Machine
DOWNLOAD THE PRODUCT

**Instructions on how to download Code Leo products from the ADS CFD portal.**
Before beginning, open the ADS CFD portal in a web browser and log on:
1. Click on **Support tab** on home page.
1. Click on **Download** button.
1. Click the latest version **Download** icon for Linux.
1. The package contains one run file.

INSTALL CODE LEO APPLICATION

Installation instructions for Code Leo can be found at https://new.aerodynamic-solutions.com/support

Performance results of Code Leo on Azure virtual machine
ADS CFD CODE LEO OVERVIEW

The ADS CFD flow solver, Code Leo, was used to run both the steady state and unsteady simulations. Code Leo is a density-based, compressible flow code, with explicit time marching, and convergence acceleration. Code Leo handles both structured multi-block meshes and unstructured meshes with mixed tetrahedrons, pyramids, prisms and hex elements. Code Leo allows use of various turbomachinery rotor/stator interaction models including the sliding mesh, mixing plane and frozen rotor models. Code Leo is HPC-aware and uses MPI+MP for parallel computing.

Code Leo can be executed on both CPUs and GPUs. Originally designed for CPUs, ADS CFD has extended it to take advantage of the advanced GPU architecture following the advent of cost-effective GPUs. Code Leo allows users to switch easily between CPU and GPU solvers.

ADS CFD CODE LEO V8.21.08 PERFORMANCE RESULTS

**Model Details:**
For performance evaluation, the CC3 wheel model is considered. The CC3 wheel model has two parts: the Impeller and Diffuser.

2 images 
**CC3 wheel: Impeller and Diffuser**

|MODEL  |NUMBER OF ELEMENTS |NUMBER OF NODES  |
|---------|---------|---------|
|Impeller     |   670848      |     742968    |
|Diffuser     |     914688    |     1012095    |

Full wheel time accurate analysis results are carried out on Azure virtual machines ND96asr_v4 and NC24s_v3 respectively.

ADS CFD provided CPU results, which is used as baseline to compare GPU runs on both VM instances.

The elapsed time for CPU simulation is 3600 minutes, which was carried out on server with Xeon 23 CPUs, clock speed of 2.4 GHz.

Performance Results of NDv4 A100, Diffuser and Impeller

|NO OF GPUS. |ELAPSED TIME (MINUTES)|SIMULATION SPEED-UP  |
|---------|---------|---------|
|1-GPU     |    159     |22.64         |
|2-GPU     |       95  | 37.89        |
|4-GPU     |         61|  59.02       |
|8-GPU     |         45|   80.00      |

image 

Runs performed on Xeon 23 CPU with 2.4 GHz and A100 , which has 8 GPUs, each GPU has 40 GB memory.

Performance Results of NCv3 V100, Diffuser and Impeller


|NO OF GPUS. |ELAPSED TIME (MINUTES)|SIMULATION SPEED-UP  |
|---------|---------|---------|
|1-GPU     |    -     |-        |
|2-GPU     |   173      |  20.81       |
|4-GPU     |   123      |  29.27      |
|8-GPU     |   112      |  32.14     |

Note: The Model requires high GPU memory and hence the 1 GPU case could not perform the run.

image 

Runs performed on Xeon 23 CPU with 2.4 GHz and V100, which has 4 GPUs, each GPU has 16 GB memory.

Pricing 

The application installation time not considered for Azure cost calculation, only model run time (wall clock time) considered for cost calculation. Please note following calculation is indicative, the actuals would depend on the model size.

For the cost estimate, [Azure calculator](https://azure.microsoft.com/pricing/calculator) can be used for the required configuration. 

ND96asr_v4

|GPU  |Elapsed time in hours  |Azure VM hourly cost  |Total Azure cost  |
|---------|---------|---------|---------|
|1 GPU     |2.65         |  $35.36       |$93.70         |
|2 GPU    |1.58         |  $35.36       | $55.87        |
|4 GPU    | 1.02        |   $35.36      | $36.07        |
|8 GPU     | 0.75        |  $35.36       | $26.52        |

NC24s_v3


|GPU  |Elapsed time in hours  |Azure VM hourly cost  |Total Azure cost  |
|---------|---------|---------|---------|
|2 GPU    | 2.88      |  $16.94       | $48.79        |
|4 GPU    | 2.05        |   $16.94      | $34.73        |
|8 GPU     |  1.87      |  $16.94       | $31.68        |

Summary

- ADS CFD Code Leo is successfully tested on NDv4 and NCv3 Virtual Machines on Azure Cloud Platform.
- For NDv4 A100 Virtual Machine, demonstrated good GPU acceleration. Every incremental GPU shows good speed up in all 8 GPUs and the peak performance of 80x is achieved with 8 GPUs.
- For NCv3 V100 Virtual Machine, demonstrated good GPU acceleration. Every incremental GPU shows good speed up in all 4 GPUs and the peak performance of 32x is achieved with 4 GPUs. For complex problems, 1 GPU memory of 16GB may not be sufficient hence 2 GPUs are recommended for this instance type.
- GPU technology in ADS CFD Code Leo on Azure platform has brought unprecedented processing power.

## Contributors

## Next steps

Run a Windows VM on Azure (/azure/architecture/reference-architectures/n-tier/windows-vm)
Run a Linux VM on Azure (/azure/architecture/reference-architectures/n-tier/linux-vm)
[GPU Optimized Virtual Machine Sizes](/azure/virtual-machines/sizes-gpu)
[Windows Virtual Machines in Azure](/azure/virtual-machines/windows/overview)
[Linux Virtual Machines in Azure](/azure/virtual-machines/linux/overview)

## Related resources

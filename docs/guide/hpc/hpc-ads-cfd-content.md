This article briefly explains the steps for running [ADS CFD's](https://new.aerodynamic-solutions.com) Code Leo application on a virtual machine deployed on Azure. It also presents performance results.

Code Leo is a URANS-based flow solver that delivers accurate and fast flow simulations for general flow configurations. Code Leo:

- Is density based and compressible and has explicit time marching and convergence acceleration.
- Is second-order accurate in time and space with low numerical smoothing.
- Is used to run both steady-state and unsteady simulations.
- Can handle structured multi-block meshes and unstructured meshes with mixed tetrahedrons, pyramids, prisms, and hex elements.
- Allows the use of various turbomachinery rotor/stator interaction models, including sliding mesh, mixing plane, and frozen rotor models.
- Is HPC-aware and uses MPI+MP for parallel computing.

Code Leo was originally designed for CPUs, but ADS CFD has extended it to take advantage of the advanced GPU architecture when GPUs became more cost-effective. It's been validated for decades by industry leaders like Air Force Research Laboratory and NASA. Code Leo users can switch easily between CPU and GPU solvers.

ADS CFD software is used primarily in the aerospace and turbomachinery industries for performance and durability assessments of jet engines and aircraft. One of the main use cases is the analysis and optimization of integrated engine/aircraft configurations so that next-generation aircraft designs can be closed on time and with confidence.

## Install Code Leo on a virtual machine

Before you install Code Leo, you need to deploy and connect a virtual machine (VM) and install the required NVIDIA and AMD drivers.

For information about deploying the VM, see one of these articles:

- [Run a Windows VM on Azure](/azure/architecture/reference-architectures/n-tier/windows-vm)
- [Run a Linux VM on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm)


To download Code Leo products from the ADS CFD portal:

1. Open the ADS CFD portal in a web browser and sign in.
1. Select **Support tab** on the home page.
1. Select **Download**.
1. Select the download link for the latest version of Linux.

The package contains one run file.

 See the [ADS CFD website](https://new.aerodynamic-solutions.com/support) for instructions for installing Code Leo.

## Performance results of Code Leo on an Azure VM

Code Leo was used to run both the steady state and unsteady simulations. 

### Code Leo V8.21.08 performance results

The CC3 wheel model is used for this performance evaluation. This model has two parts, the impeller and the diffuser, as shown here:

![Image that shows the impeller and diffuser.](/media/impeller-diffuser.png)

|Model  |Number of elements |Number of nodes  |
|---------|---------|---------|
|Impeller     |   670848      |     742968    |
|Diffuser     |     914688    |     1012095    |

Full wheel time analyses were performed on ND96asr_v4 and NC24s_v3 Azure VMs.

ADS CFD provided CPU results, which are used as a baseline for comparing GPU runs on both VM instances.

The elapsed time for CPU simulation is 3,600 minutes. The simulation was performed on a server with Xeon 23 CPUs with a clock speed of 2.4 GHz.

#### Performance results of NDv4 A100, diffuser and impeller

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

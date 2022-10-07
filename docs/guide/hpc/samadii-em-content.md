<Intro should cover a basic overview of the workload.>

## Why deploy Samadii EM on Azure?

- Modern and diverse compute options to meet your workload's needs
- The flexibility of virtualization without the need to buy and maintain physical hardware
- Rapid provisioning
- for varying levels of simulation complexity  

## Architecture

### Components
 
## Compute sizing and drivers
<List of evaluated sizes for this workload and a table of the input sizes with corresponding evaluated output for the chosen input sizes.>
Required drivers
<Information about any specialized drivers required for the recommended sizes. List the specific size and link it to the appropriate page in the VM sizes documentation – for example: https://docs.microsoft.com/azure/virtual-machines/nda100-v4-series>
<Workload> installation
Before you install <Workload>, you need to deploy and connect a VM and install the required NVIDIA and AMD drivers.
 Important – if needed
<if needed – for example: NVIDIA Fabric Manager installation is required for VMs that use NVLink or NVSwitch.>
For information about deploying the VM and installing the drivers, see one of these articles:
•	Run a Windows VM on Azure
•	Run a Linux VM on Azure

<Must include a sentence or two to outline the installation context along with link/s (no internal links, it must be official/accessible) to install information of the product docs for the workload solution.>
<Should not list any ordered steps of installation.> 
<Workload> performance results
<Give a short intro to how performance was tested>
<Results for X>
<Results for Y etc>

Additional notes about tests
<Include any additional notes about the testing process used.>
Azure cost
<Description of the costs that might be associated with running this workload in Azure. Make sure to have a link to the Azure pricing calculator.>
You can use the Azure pricing calculator, to estimate the costs for your configuration.
<Show the pricing calculation or a direct link to this specific workload with the configuration(s) used.>

## Summary
- Samadii-EM Application is successfully deployed and tested on NCv3, NCasT4 & NVv5 series Azure Virtual Machines.
- From the Performance Benchmarking results, considering the elapsed time as benchmarking parameter it can be observed that for smaller models (lesser complexity) all the configurations of NCv4 and NVv5 VM (including partial usage of GPU’s) are performing better in comparison with NCasT4 NCv3 for Samadii-EM application
- For models with increased complexity considering the elapsed time as benchmarking parameter, NCv4, NCv3, NCasT4, NVv5 (full GPU) VM’s are performing better than the NVv5 (partial usage of GPU’s)
- Considering the Azure cost as the criteria for performance evaluation NCasT4 VM’s shows better performance in comparison with other VM’s

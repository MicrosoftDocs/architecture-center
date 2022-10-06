
<Intro should cover a basic overview of the workload.>
Why deploy <workload> on Azure
-	Simplifies migration to the cloud
-	Optimizes the workload in these ways….
-	Can be rapidly provisioned
-	Performance
Architecture
<Not generic. Product/Solution specific Architecture diagram>
<The architecture diagram must be product associated and the VM (Virtual Machines) topology should match the above stated test conditions.>
Components
<List of links to more information on the discrete pieces of the architecture. The list below is just an example of the most common items, you might need to add or remove items based on your architecture diagram.>
<link to the normal AAC standard links for these (Azure service pages)>
-	Virtual machine – description/context. Please also link Linux VMs on Azure or Windows VMs on Azure (whichever the architecture is based on) in the sentence that follows this.
-	Network – description/context
-	PIP – description/context
-	NSG – description/context
-	Storage – description/context
Compute sizing and drivers
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
Summary
<One or two sentences or bullet points reinforcing why Azure is the right platform for this workload>

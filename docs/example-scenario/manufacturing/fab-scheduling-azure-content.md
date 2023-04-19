This article demonstrates the automation of fab acheduling and dispatching of semiconductor manufacturing workloads on Azure. These simulations on Azure generate intelligent solutions for solving some of the most complex and dynamic real-world challenges across many industries. To implement these solutions, enterprises need to use high-performance computing (HPC) environments in which these kinds of simulations can be performed at scale. This scenario is based on minds.ai Maestro, a semiconductor manufacturing product suite.

## Architecture

image 

link 

### Workflow

1. End users interact with the Maestro management system via a REST API that runs on Azure Kubernetes Service (AKS). They can interact with the system in various ways: 

   - Python API  
   - Web-based user interface 
   - Command-line client 

1. Users submit the job in minds.ai Maestro, which schedules the training jobs on the cluster.
1. minds.ai Maestro invokes Kubernetes to assign pods to the relevant node pools and AKS scales the node pools up or down if required. The specific node pools, that minds.ai Maestro assigns the pods to, are based on the end-user job configuration. Where the user can select regular or spot nodes and CPU or GPU nodes. 
1. Kubernetes pulls the image from Azure Container Registry (ACR) based on the configuration as defined by minds.ai Maestro and initialize the pods. 
1. During training, the results are stored in the Azure File Storage and the metric tracking system that is part of minds.ai Maestro mgmt. pods (and backed by an additional storage device). Through the minds.ai Maestro™ dashboard the user monitors the job progress. 
1. When the training is complete the agent is pushed to the deployment system from where it can be queried for actions. The deployment server has the option to report back monitoring statistics to the minds.ai platform for further optimization of the agent via File Storage.

### Components

- [Azure Kubernetes Service (AKS)]() is a managed container orchestration service based on the open-source Kubernetes system. An organization can use AKS to handle critical functionality such as deploying, scaling and managing Docker containers and container-based applications. 
- The minds.ai Maestro™ engine (code name [DeepSim](https://azuremarketplace.microsoft.com/marketplace/apps/mindsaiinc1591719795879.mindsai_deepsim_subscription_full?tab=overview&exp=ubp8)) augments your existing workflow and improves semiconductor fab KPIs with AI-enhanced dispatching and scheduling recommendations. Additional fab automation use case applications are available which share a similar architecture. [minds.ai](https://minds.ai/semiconductor/) has developed software containers for Cloud HPC environments. These production ready containers bundle OS, libraries and tools as well as application codes. They also contain minds.ai’s proprietary DeepSim platform with custom A.I. based algorithms that ensure all the relevant KPIs are explored and optimized by the reinforcement learning agents. 
- [Azure Spot Virtual Machines]() provision unused Azure compute capacity at deep discounts. Spot VMs offer the same machine types, options, and performance as regular Compute instances. 
- [Azure Storage Accounts](https://azure.microsoft.com/free/storage) are used to store the results, input and configuration data. 
- [Azure Managed Disks]() are high-performance, durable block storage devices designed to be used with Azure Virtual Machines and Azure VMware Solution, Simple, Scalable and Highly available.
- [Azure Virtual Networks]() enable many types of Azure resources, such as VMs, to securely communicate with each other, the internet, and on-premises networks. 
- [Azure Files]() take advantage of fully managed file shares in the cloud that are accessible via the industry-standard SMB and NFS protocols. 
- [Azure Container Registry]() Build, store, secure, scan, replicate, and manage container images and artifacts with a fully managed, geo-replicated instance of OCI distribution.

## Scenario details

Superior, next-gen tool modeling plus effective and efficient scheduling and dispatching methods are a critical means for manufacturers to gain a competitive advantage. These HPC workloads at scale enable enterprises to dynamically and efficiently optimize for a fab’s complex and ever-changing demands. 

In order to utilize cutting edge AI+ machine learning solutions in-house, these enterprises must invest and maintain the latest, scalable and cost-effective HPC infrastructure. Additionally, execution may take many days to complete with old on-premises infrastructures. These on-prem systems are typically much less energy efficient than the Azure solutions that use the latest sustainable data center technologies. 

Microsoft partner minds.ai has commercially deployed this fab scheduling and dispatching solution for semiconductor manufacturing companies for the optimization of wafer fabrication KPIs. This solution architecture is applicable for the following distinct scenarios: 

### Reinforcement Learning (RL) for fab scheduling

The customer’s line control engineers needed a solution that would enable them to improve the cycle time, throughput and utilization since their existing industry-standard workflow system was not able to fully utilize the available fab capacity. Additionally, with the industry-wide shortages of experienced fab engineers, faced by this customer, freeing up resource bandwidth through augmentation & automation is critical. Additional requirements included an execution speed of under 2 minutes, non-disruptive implementation, and ability  to adjust and dynamically respond to a continuously changing Fab state. This resulting data-driven solution by minds.ai on Azure augments the customer’ current workflow using AI agents that are trained using reinforcement learning and work in cooperation with the fab engineers to give them more insights and options to directly improve the current relevant KPIs.

The core engine (code named DeepSim) for the product suite is a highly scalable, AI-based controller design platform that generates solutions for automating and improving manual processes in your existing workflows. This solution augments fab scheduling expertise using cloud-based reinforcement learning and patented technology to increase cost-effectiveness of the HPC workloads. The deployed solutions are trained in simulation to quickly respond to dynamic fab states; this parallel workflow automatically generates schedule recommendations to improve critical, organization-level, KPIs.  

The resulting schedules have demonstrated a value of **$24M+/fab/year** via increased throughput of 1-2%, decreased critical queue time violations of 1-2%, decreased new product cycle time by 2-7%, improved utilization for bottlenecked tool groups, and decreased cost per wafer.

### Supervised Learning for fab tool modeling

Another critical aspect of a fab’s manufacturing planning and operation is accurate information for the available tools/equipment. Specific customer requirements often include next-gen models for tools reliability and predictability as these are critical for the planning and scheduling steps. The existing solution of minds.ai's customer was not sufficiently capable of giving an accurate enough estimate of the Equipment Health Index (EHI) and the Remaining Useful Life (RUL). 

​​​The core engine (code named DeepSim) for minds.ai Maestro™ product is an AI-based controller design platform that automates many of the manual processes in  your existing workflows. minds.ai Maestro™ also includes applications to train EHI and RUL models. The models are trained using the historical data that is part of the existing fab’s logging system. Azure’s latest GPU hardware greatly speeds up this solution enabling faster ROI for the end user. The resulting models are then utilized for risk-aware scheduling and thereby optimize productivity, yield and preventative maintenance. 

Using the trained model, the EHI robustness improved significantly from the current baseline.

This solution is deployed in an Azure Environment using the Azure Kubernetes Service (AKS) which is a fully managed container orchestration service to deploy, manage and scale container-based applications in a cluster environment. A REST API is used to achieve a user-friendly interface to AKS. Azure Files Storage is used to store the data and is a highly available secure and scalable storage solution. Azure Container Registry allows you to build, store, and manage container images such as DeepSim. The containers have a high portability and increase agility to your on Demand workflows. Using Azure Spot Virtual Machines allows you to take advantage of unused capacity at significant cost savings. At any point in time when Azure needs the capacity back, the Azure infrastructure will evict Azure Spot Virtual Machines and the minds.ai software will automatically launch new instances and resume the training process ensuring reliability.

### Potential use cases 

This solution and architecture is also applicable to the following industries where advanced control and scheduling solutions are typically used: 

- Automated ​​manufacturing 4.0 
- Travel and Transportation (Application Development) 
- Pharma and Medicine 
- Renewable Energy control and multivariate site design

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability 

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

The minds.ai solutions are deployed in some of the world's most complex, critical processes that are responsible for chip and energy production. As such, reliability is essential. All solutions are trained using the Microsoft Azure platform which ensures a stable execution environment with High Availability and Disaster Recovery as it is using the Azure Availability zones, Availability Sets and geo-redundant storage, Azure site recovery. In the rare case that issues are detected the system will automatically restart (part of) the compute environment and seamlessly restart the training process. This ensures that the user will get a trained agent or neural network model within the expected timeframe. 

The deployment system augments the customer's existing solutions and as such the user is always able to fall back to the existing baseline solutions. This ensures that no-matter the cause, there won’t be a disruption in the production process.

### Security 

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview). 

This solution is deployed as a single tenant solution. Sole control of the software, data and simulation under progress remains with the user without risk of interference from others. 

Azure Kubernetes Service offers Role-based access control (RBAC) which ensures engineers access only information they need to do their jobs and prevents them from accessing information that doesn't pertain to them. 

For more information on Network Security options, see Secure traffic between pods using network policies in Azure Kubernetes Service (AKS). 

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview). 

minds.ai Maestro training runs can operate in an interruptible manner, which enables the user to use two options:
- Spot VMs: Reduce the cost, but increase the chances of jobs taking more time to finish due to interruptions. 
- Reserved Instance: Increase the cost, but in exchange you get dedicated compute resources resulting in predictable execution times.

There are no costs associated with AKS in deployment, management, and operations of the Kubernetes cluster. You only pay for the virtual machine’s instances, storage, and networking resources consumed by your Kubernetes cluster. Azure files are used for long term data storage. Since all the data stays in the cloud, the data transfer bandwidth charges are reduced. 

The below BOQ shows the two use case scenarios, 

- CPU use case: Reinforcement Learning of 10 RL Agents running for a month using 20 nodes, each with 120 CPU cores per node, are used with Compute Time of 360 Hrs. (2400 CPU cores)

  To achieve cost savings of up to 83%, make use of [Azure Spot VMs](https://azure.microsoft.com/pricing/spot-advisor). 

  |Service category|Service type|Description| 
  |-|-|-|
  |Compute|Virtual Machines|1 HB120rs v3 (120 Cores, 448 GB RAM)|  
  |Compute|Virtual Machines|1 B8ms (8 Cores, 32 GB RAM)|
  |Storage|Storage Accounts|File Storage, Premium Performance Tier| 
  |Storage|Storage Accounts|Managed Disks, Premium SSD, P4 Disk Type 1 Disk|
  |Containers |Azure Container Registry|1 registry |
  |Compute |Virtual Machines|20 HB120rs v3 (120 Cores, 448 GB RAM)| 

- GPU use case: Supervised Learning 10 neural network training jobs running for a month using 16 nodes with 1 GPU per node are used with a Compute Time of 360 Hrs. (#16 GPUs) 

  To achieve cost savings of up to 52%, make use of [Azure Spot VMs](https://azure.microsoft.com/pricing/spot-advisor/#overview).

  |Service category|Service type|Description| 
  |-|-|-|
  |Compute|Virtual Machines|1 HB120rs v3 (120 Cores, 448 GB RAM)|  
  |Compute|Virtual Machines|1 B8ms (8 Cores, 32 GB RAM)|
  |Storage|Storage Accounts|File Storage, Premium Performance Tier| 
  |Storage|Storage Accounts|Managed Disks, Premium SSD, P4 Disk Type 1 Disk|
  |Containers |Azure Container Registry|1 registry |
  |Compute |Virtual Machines|16 NC6s v3 (6 vCPUs, 112 GB RAM) | 

To estimate the costs for your organization please use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).

### Performance efficiency 

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

This architecture leverages the AMD CPU based HBv3-series VMs for Reinforcement Learning and Nvidia GPU based NC series VMs for Supervised Learning on Azure.  

[HBv3 series VMs](/azure/virtual-machines/hbv3-series): These VMs come with compute intensive processors and high bandwidth memory which are well suited for the reinforcement learning demands which can leverage multi-node cluster setups to achieve scale-up performance. 

[NCv3 series VMs](/azure/virtual-machines/ncv3-series): These VMs have compute-intensive GPU-accelerated Processors which are well suited for the demands of Supervised Learning and can leverage multi-GPU capabilities to achieve scalable performance. 

See scaling options when you run your applications on [AKS](/azure/aks/concepts-scale).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*
 

Principal authors:
  
Kalaiselvan Balaraman | Cloud Solution Architect 
[Mahaboob Basha R]() | Cloud Solution Architect 
Jeroen Bédorf | Chief Architect 
Thomas Soule | Business Development Manager 
 
Other contributors:  

Hari Bagudu | Senior Manager  
Gauhar Junnarkar | Principal Program Manager 
Sachin Rastogi | Program Lead 

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps 

Product documentation: 

What is Azure Kubernetes Service? 
Azure Virtual Machines (VMs) 
Use Azure Spot Virtual Machines 
Introduction to Azure Storage 
What is Azure Virtual Network?  
Using containers on Azure Batch 
What is Azure Virtual Network? 

See the following virtual machine articles: 

RDMA Capable Machine Instances 
Customizing an RDMA Instance VM 

## Related resources
DeepSim Product Description 
minds.ai semiconductor solutions 
DeepSim minds.ai's training platform 
Vestas supercharges its wind farm control models for sustainable energy with Azure HPC 
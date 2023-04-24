This article demonstrates the automation of fab scheduling and dispatching for semiconductor manufacturing workloads on Azure. The solution uses a high-performance computing (HPC) environment to perform reinforcement learning (RL) at scale. The architecture is based on minds.ai Maestro, a semiconductor manufacturing product suite.

## Architecture

:::image type="content" source="media/fab-scheduling.png" alt-text="Image alt text." lightbox="media/fab-scheduling.png" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/fab-scheduling.pptx) of this architecture.*

### Workflow

This workflow provides a high-level overview of the architecture that's used for RL training.

1. End users interact with the Maestro management system via a REST API that runs on Azure Kubernetes Service (AKS). They can interact with the system in various ways: 

   - Python API  
   - Web-based user interface 
   - Command-line client 

1. Maestro schedules the training jobs on a Kubernetes cluster.
1. Maestro invokes Kubernetes to assign pods to the relevant node pools. AKS scales the node pools up or down as needed. Maestro assigns the pods to specific node pools based on a configuration that's specified by the user. The user can select: 
   - Regular or spot nodes. 
   - CPU or GPU nodes. 
1. Kubernetes pulls the container image from Azure Container Registry, based on the configuration defined by Maestro, and initializes the pods. 
1. During training, the results are stored in Azure Files and the metric tracking system that's part of the Maestro management pods (and backed by an additional storage device). The user monitors job progress by using the Maestro dashboard. 
1. When training is complete, the RL agent is pushed to the deployment system, where it can be queried for actions. Optionally, the deployment server can report monitoring statistics to the Maestro platform for further optimization of the agent via Azure Files.

### Components

- [AKS](https://azure.microsoft.com/products/kubernetes-service/) is a managed container orchestration service that's based on the open-source Kubernetes system. You can use AKS to handle critical functionality like deploying, scaling, and managing Docker containers and container-based applications. 
- [The Maestro engine (code name DeepSim)](https://azuremarketplace.microsoft.com/marketplace/apps/mindsaiinc1591719795879.mindsai_deepsim_subscription_full?tab=overview&exp=ubp8) augments existing fab workflows and improves semiconductor fab KPIs with AI-enhanced dispatching and scheduling recommendations.
- [Azure Spot Virtual Machines](https://azure.microsoft.com/products/virtual-machines/spot/) provisions unused Azure compute capacity at a significant discount. Spot VMs offer the same machine types, options, and performance as regular compute instances. 
- [Azure storage accounts](https://azure.microsoft.com/free/storage) are used in this architecture to store training results, input, and configuration data.
- [Azure managed disks](/azure/virtual-machines/managed-disks-overview) are high-performance, durable block storage devices that are designed to be used with Azure Virtual Machines and Azure VMware Solution.
- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network/) enables Azure resources, like VMs, to communicate with each other, the internet, and on-premises networks over an enhanced security connection.
- [Azure Files](https://azure.microsoft.com/products/storage/files/) provides fully managed file shares in the cloud that are accessible via industry-standard SMB and NFS protocols. 
- [Azure Container Registry](https://azure.microsoft.com/products/container-registry/) can help you build, store, scan, replicate, and manage container images and artifacts with a fully managed geo-replicated instance of OCI distribution.

## Scenario details

Effective tool modeling and effective and efficient scheduling and dispatching methods are critical for manufacturers.

To take advantage of cutting edge AI and machine learning solutions, enterprises need a scalable and cost-effective HPC infrastructure. Execution of highly complex workloads can take days to complete with on on-premises infrastructures. On-premises systems are also typically less energy efficient than Azure solutions. 

Microsoft partner minds.ai created the Maestro scheduling and dispatching solution to help fab semiconductor manufacturing companies optimize wafer fabrication KPIs.

This solution uses AKS to deploy, manage, and scale container-based applications in a cluster environment. A REST API is used to provide a user-friendly interface to AKS. You can use Container Registry to build, store, and manage container images like DeepSim. The containers have high portability and increase agility for on-demand workflows. 

The solution architecture described in this article applies to the following scenarios.

### RL for fab scheduling

This solution can help line control engineers improve product cycle time, throughput, and utilization and free up resource bandwidth via automation and augmentation of current workflows. The solution can augment a workflow with AI agents that are trained via RL to give fab engineers more insights and options for improving KPIs.

The solution uses RL to train models. The deployed solutions are trained, in simulations, to quickly respond to dynamic fab states. The workflow automatically generates schedule recommendations.  

In real-world a scenario, the resulting schedules saved an enterprise tens of millions of dollars per year by: 
- Increasing throughput by 1-2%. 
- Decreasing critical queue time violations by 1-2%. 
- Decreasing new product cycle time by 2-7%.
- Improving utilization for bottlenecked tool groups.
- Decreasing cost per wafer.  

### Supervised learning for fab tool modeling

Getting accurate information about tools and equipment is another critical aspect of a fab's planning and operation. Business requirements often include models for measuring tool reliability and predictability, including Equipment Health Index (EHI) and the Remaining Useful Life (RUL).

Maestro includes applications for training EHI and RUL models. Historical data that's part of the fab's logging system is used to train the models. Azure GPU hardware speeds up this process. The resulting models are used for risk-aware scheduling to optimize productivity, yield, and preventative maintenance and significantly improve EHI.

### Potential use cases 

This architecture also applies to the following industries, in which advanced control and scheduling solutions are typically used:

- Industry 4.0 
- Travel and transportation (application development) 
- Pharma and healthcare 
- Renewable energy control and multivariate site design

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures that your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

minds.ai solutions are deployed in some of the world's most complex, critical processes for chip and energy production, so reliability is essential. On the Azure platform, you can keep your running environments stable by using availability zones, availability sets, geo-redundant storage, and Azure Site Recovery. If issues are detected, the system automatically restarts part of the compute environment and restarts the training process. This capability ensures that you get a trained agent or neural network model within the expected timeframe.

This system augments your existing solutions, so you can always fall back to those solutions.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview). 

This solution is deployed as a single-tenant solution. Sole control of the software, data, and in-prcess simulations remains with you. 

AKS provides role-based access control (RBAC), which helps you ensure that engineers can access only information that they need to do their jobs.

For more information about network security options, see [Secure traffic between pods using network policies in AKS](/azure/aks/use-network-policies). 

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Maestro training runs can operate in an interruptible manner, which enables two options:
- Spot VMs. Reduce costs, but increase the chances of jobs taking more time to finish because of interruptions.
- Reserved instances. Increase costs, but get dedicated compute resources that result in predictable runtimes.

You can use Spot Virtual Machines to take advantage of unused Azure capacity at significant cost savings. If Azure needs the capacity back, it evicts the spot virtual machines, and the minds.ai software automatically starts new instances and resumes the training process.

There are no costs associated with the AKS deployment, management, and operations of the Kubernetes cluster. You pay only for the virtual machine instances, storage, and networking resources consumed by your Kubernetes cluster. Azure Files is used for long-term data storage. Because all data stays in the cloud, data transfer bandwidth charges are reduced.

Following are some details about CPU and GPU use cases.

- CPU use case: 10 RL agents running for a month on 20 nodes, with 120 CPU cores per node, are used with a compute time of 360 hours (2,400 CPU cores).

  To save as much as 83% of cost, use [Azure Spot Virtual Machines](https://azure.microsoft.com/pricing/spot-advisor). 

  |Service category|Service type|Description|
  |-|-|-|
  |Compute|Virtual machines|One Standard_HB120rs_v3 VM (120 cores, 448 GiB of RAM)|  
  |Compute|Virtual machines|One Standard_B8ms VM (8 cores, 32 GiB of RAM)|
  |Storage|Storage accounts|File storage, premium performance tier| 
  |Storage|Storage accounts|Managed disks, Premium SSD, P4 disk type, one disk|
  |Containers |  Container Registry|One registry |
  |Compute |Virtual machines|20 Standard_HB120rs_v3 VMs (120 cores, 448 GiB of RAM)| 

- GPU use case: Supervised learning of 10 neural network training jobs running for a month on 16 nodes, with one GPU per node, are used with a compute time of 360 hours (16 GPUs). 

  To save as much as 52% of cost, use [Azure Spot Virtual Machines](https://azure.microsoft.com/pricing/spot-advisor/).

  |Service category|Service type|Description| 
  |-|-|-|
  |Compute|Virtual machines|One Standard_HB120_rs v3 VM (120 cores, 448 GiB of RAM)|  
  |Compute|Virtual machines|One Standard_B8ms VM (8 cores, 32 GiB of RAM)|
  |Storage|Storage accounts|File storage, premium performance tier| 
  |Storage|Storage accounts|Managed disks, Premium SSD, P4 disk type, one disk|
  |Containers |  Container Registry|One registry |
  |Compute |Virtual machines|16 Standard_NC6s_v3 VMs (6 vCPUs, 112 GiB of RAM) | 

To estimate costs for your organization, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

This architecture uses HBv3-series VMs with AMD CPUs for reinforcement learning and NCv3-series VMs with NVIDIA GPUs for supervised learning.  

[HBv3-series VMs](/azure/virtual-machines/hbv3-series) have compute-intensive processors and high bandwidth memory that are well suited for reinforcement learning. You can use them in multi-node cluster configurations to achieve scalable performance.

[NCv3-series VMs](/azure/virtual-machines/ncv3-series) have compute-intensive GPU-accelerated processors that are well suited for the demands of supervised learning. They can use multi-GPU capabilities to achieve scalable performance.

For more information, see [Scaling options for applications on AKS](/azure/aks/concepts-scale).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*
 
Principal authors:
  
- [Kalaiselvan Balaraman](http://www.linkedin.com/in/kalaiselvan-b-5a153358) | Cloud Solution Architect 
- [Mahaboob Basha R](https://www.linkedin.com/in/mahaboob-basha-r-396951262/) | Cloud Solution Architect 
- [Jeroen Bédorf](https://www.linkedin.com/in/jeroenbedorf/) | Chief Architect 
- [Thomas Soule](https://www.linkedin.com/in/thomas-s-a432a216a/) | Business Development Manager 
 
Other contributors:  

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer
- [Hari Bagudu](https://www.linkedin.com/in/hari-bagudu-88732a19) | Senior Manager  
- [Gauhar Junnarkar](https://www.linkedin.com/in/gauharjunnarkar) | Principal Program Manager 
- [Sachin Rastogi](https://www.linkedin.com/in/sachin-rastogi-907a3b5) | Program Lead 

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps 

- [What is AKS?](/azure/aks/intro-kubernetes)
- [Virtual machines in Azure](/azure/virtual-machines/windows/overview) 
- [Use Azure Spot Virtual Machines](/azure/virtual-machines/spot-vms) 
- [Introduction to Azure Storage](/azure/storage/common/storage-introduction) 
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)  
- [Using containers on Azure Batch](https://github.com/Azure/batch-shipyard) 
- [RDMA-capable VM Instances](/azure/virtual-machines/sizes-hpc#rdma-capable-instances) 
- [HPC cluster configuration options](/azure/virtual-machines/sizes-hpc?branch=main#cluster-configuration-options)
- [DeepSim product description](https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWRwHJ) 
- [minds.ai semiconductor solutions](https://minds.ai/semiconductor/) 
- [DeepSim training platform](https://minds.ai/platform/) 
- [Vestas supercharges its wind farm control models for sustainable energy with Azure HPC](https://customers.microsoft.com/story/1430379358742351454-vestas-energy-azure-hpc) 

## Related resources

- [HPC for manufacturing](../../industries/manufacturing/compute-manufacturing-overview.yml)
- [Introduction to predictive maintenance in manufacturing](../../industries/manufacturing/predictive-maintenance-overview.yml)
- [Use subject matter expertise in machine teaching and reinforcement learning](../../solution-ideas/articles/machine-teaching.yml)

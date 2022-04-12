For decades, Software AG Adabas has been the adaptable database system behind many large mission-critical business applications. Now you can bring the convenience of cloud computing to these applications without giving up your Adabas database, the Natural programming language, or even your green screen, unless you want to.  

Most organizations are pragmatic in their approach to digital transformation. They want to reuse what they can and make cost-effective choices about the rest. That's why the rehost approach to cloud migration is so popular. You simply move your workload as is, if possible, to Azure virtual machines (VMs), a type of infrastructure as a service (IaaS). VMs run in Azure datacenters that are managed by Microsoft, so you benefit from the efficiency, scalability, and performance of a distributed platform without the overhead of hardware management. 

However, to gain the full benefits of cloud computing, consider a refactor approach that uses modern techniques like container-based microservices. This type of migration is more complex than a rehost approach, but the payoff is increased flexibility and scalability. 

This architecture presents the rehost option and gives you a high-level look at what's possible, whether you keep the green screen or go modern. 

## Mainframe architecture 

This architecture shows a legacy IBM z/OS architecture, before a rehost to the cloud. It illustrates an example of a mainframe with Software AG's Adabas & Natural modules installed. 

:::image type="content" border="false" source="media/mainframe-software-ag-rehost-before.png" alt-text="Image alt text." lightbox="media/mainframe-software-ag-rehost-before.png ":::

link? 

### Workflow

A. Users input data over TCP/IP, including TN3270 and HTTP(S). Data is input into the mainframe via standard mainframe protocols. 

B. Applications receive the data. These applications can be either batch or online systems. 

C. Natural, COBOL, PL/I, Assembler, or compatible languages run in an enabled environment. 

D. Database services, commonly hierarchical/network database systems and relational databases, store data.

E. Services like program execution, I/O operations, error detection, and protection within the environment are enabled. 

F. Middleware and utility services manage services like tape storage, queueing, output, and web services within the environment. 

G. Operating systems provide interfaces between the engine and the and the software it runs. 

H. Partitions are used to run separate workloads or segregate work types within the environment. 

## Rehosted Azure architecture

This diagram shows the legacy architecture migrated to Azure. A rehost approach is used to migrate the system. 

:::image type="content" border="false" source="media/mainframe-software-ag-azure-rehost-after.png" alt-text="Image alt text." lightbox="media/mainframe-software-ag-azure-rehost-after.png "::: 

link 

### Workflow

1. Input, typically via either Azure ExpressRoute from remote clients or via other applications currently running in Azure. In either case, TCP/IP connections provide the primary means of connection to the system. User access for web-based applications is provided over TLS port 443. You can use the legacy web-application presentation layer virtually unchanged to minimize user retraining. Alternatively, you can update the web-application presentation layer with modern UX frameworks. To improve security by minimizing open ports, you can use Azure Bastion hosts for admin access to the VMs.
1. Azure Application Gateway is used to access to the application compute clusters. Application Gateway provides Layer 7 load balancing services and can make routing decisions based on additional attributes in an HTTP request, like a URI path or host headers. For example, you can route traffic based on the incoming URL. In this case, you can route traffic to the correct Software AG component (ApplinX or EntireX). 
1. For application compute clusters, you can use one VM for the Software AG Adabas &Natural software. We recommend that you use separate VMs for the application and database for more than 200 MIPS. This example uses two VMs. You can deploy a distributed architecture (Adabas & Natural running on multiple VMs) to provide scalable Natural applications with higher availability and higher consistency for Adabas storage. 
1. Software AG ApplinX, a server-based technology, provides web connectivity and integration into system applications without requiring changes to the applications. 
1. Software AG EntireX connects services that run on Integration Server to mission-critical programs that are written in languages like COBOL or Natural. 
1. Natural Online – Allows online users to connect to Natural application using ssh or via a web browser.  
1. Natural Services – Allows API access to business functions programmed in Natural. 
1. Adabas – Software AG’s high performance NonSQL Database Management System. 
1. Natural Batch - (Software AG)  Dedicated component to execute batch jobs 

Components  

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) - Azure Virtual Machines (VM) is one of several types of on-demand, scalable computing resources that Azure offers.  An Azure VM gives you the flexibility of virtualization without having to buy and maintain the physical hardware that runs it.  
- [Azure Virtual Network]() - Azure Virtual Network (VNet) is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks. VNet is similar to a traditional network that you'd operate in your own data center, but brings with it additional benefits of Azure's infrastructure such as scale, availability, and isolation.  
- [Azure Virtual Network Interface Cards](/azure/virtual-network/virtual-network-network-interface) - A network interface enables an Azure Virtual Machine to communicate with internet, Azure, and on-premises resources.  As shown in this architecture, you can add additional network interface cards to the same Azure VM, which allows the Solaris child-VMs to have their own dedicated network interface device and IP address.  
- [Azure SSD Managed Disk]() - Azure managed disks are block-level storage volumes that are managed by Azure and used with Azure Virtual Machines.  The available types of disks are ultra disks, premium solid-state drives (SSD), standard SSDs, and standard hard disk drives (HDD).  For this architecture, we recommend either Premium SSDs or Ultra Disk SSDs.  
- [Azure ExpressRoute]() - ExpressRoute lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. With ExpressRoute, you can establish connections to Microsoft cloud services, such as Microsoft Azure and Office 365.  

Considerations 

The following considerations, based on the Azure Well-Architected Framework, apply to this solution:  

Cost optimization  

Azure provides cost optimization by running on Linux VMs which allow the ability to turn off the VMs when not in use and scripting a schedule for known usage patterns. Azure focuses on avoiding unnecessary costs by identifying right number or resource types, analyzing spend over time and scaling to meet business needs without overspending. 

Operational excellence  

Rehosting the target architecture is completely Azure Cloud proven, customers have full flexibility in terms of their deployment options in development and production. This transformation not only supports immediate adoption of the cloud but also supports adoption of both DevOps and Agile working principles. 

Performance efficiency  

Performance efficiency is built into this solution because resiliency is built into the architecture.  Load Balancers and redundant VMs in a distributed environment make this possible. If one presentation or transaction server fails, the other server behind the Load Balancer shoulders the workload.  

Security  

This solution uses an Azure network security group (NSG) to manage traffic between Azure resources in different subnets. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).   

[Azure Bastion](/azure/bastion/bastion-overview) maximizes admin access security by minimizing open ports. Bastion provides secure and seamless RDP/SSH connectivity to virtual network VMs directly from the Azure portal over TLS. 

Pricing  

Azure avoids unnecessary costs by identifying the correct number of resource types, analyzing spending over time, and scaling to meet business needs without overspending. 

- Azure provides cost optimization by running on VMs. You can turn off the VMs when not in use, and script a schedule for known usage patterns. See the [Azure Well-Architected Framework]() for more information about cost optimization for [VM instances](/azure/architecture/framework/cost/optimize-vm). 

- The VMs in this architecture use either premium SSDs or ultra disk SSDs. For more information about disk options and pricing, see [Managed Disks pricing](https://azure.microsoft.com/pricing/details/managed-disks). 

## Next steps  

For more information, please contact legacy2azure@microsoft.com.  

## Related resources 
 
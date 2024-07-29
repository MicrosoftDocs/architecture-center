For decades, Software AG Adabas has been the adaptable database system behind many large mission-critical business applications. Now you can bring the convenience of cloud computing to these applications without giving up your Adabas database or the Natural programming language. This architecture presents the option to rehost your system on Azure. It provides a high-level look at what's possible, whether you keep the green screen or go modern. 

## Mainframe architecture 

This architecture shows a legacy Adabas & Natural architecture, before a rehost to the cloud:

:::image type="content" border="false" source="media/mainframe-software-ag-rehost-before.svg" alt-text="Diagram that shows the legacy mainframe architecture, before migration." lightbox="media/mainframe-software-ag-rehost-before.svg ":::

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-azure-rehost-before.vsdx) of this architecture.*

### Workflow

A. Users input data over TCP/IP, including TN3270 and HTTP(S). Data is input into the mainframe via standard mainframe protocols. 

B. Applications receive the data. These applications can be either batch or online systems. 

C. Natural, COBOL, PL/I, Assembler, or compatible languages run in an enabled environment. 

D. Database services, commonly hierarchical/network database systems and relational databases, store data.

E. Common services, like program execution, I/O operations, error detection, and protection within the environment, provide support. 

F. Middleware and utility services manage functions like tape storage, queueing, output, and web services within the environment. 

G. Operating systems run on partitions. 

H. Partitions are used to run separate workloads or segregate work types within the environment. 

## Azure architecture

This diagram shows the legacy architecture migrated to Azure. A rehost approach is used to migrate the system:

:::image type="content" border="false" source="media/mainframe-software-ag-azure-rehost-after.svg" alt-text="Diagram that shows the mainframe architecture rehosted on Azure." lightbox="media/mainframe-software-ag-azure-rehost-after.svg "::: 

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-azure-rehost-after.vsdx) of this architecture.*

### Workflow

1. Data is input, typically via either Azure ExpressRoute from remote clients or via other applications currently running in Azure. In either case, TCP/IP connections provide the primary means of connection to the system. User access for web-based applications is provided over TLS port 443. You can use the legacy web-application presentation layer virtually unchanged to minimize user retraining. Alternatively, you can update the web-application presentation layer with modern UX frameworks. To improve security by minimizing open ports, you can use Azure Bastion hosts for admin access to the VMs.
1. Azure Application Gateway is used to access the application compute clusters. It provides Layer 7 load balancing services. It can also make routing decisions based on additional attributes in an HTTP request, like a URI path or host headers. For example, you can route traffic based on the incoming URL. In this case, you route traffic to the correct Software AG component (ApplinX or EntireX). 
1. For application compute clusters, you can use one VM for the Adabas & Natural software. We recommend that you use separate VMs for the application and database for more than 200 MIPS. This example uses two VMs. You can deploy a distributed architecture (Adabas & Natural running on multiple VMs) to provide scalable Natural applications with higher availability and higher consistency for Adabas storage. 
1. ApplinX provides web connectivity and integration into system applications. No changes to the applications are required. 
1. EntireX connects services that run on Integration Server to mission-critical programs that are written in languages like COBOL or Natural. 
1. Online users connect to the Natural application by using Natural Online. Natural Online enables connection via SSH or a web browser.  
1. Natural Services provides API access to business functions that are programmed in Natural. 
1. An Adabas NoSQL database stores data. 
1. Software AG Natural Batch runs batch jobs. 

### Components  

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines). Virtual Machines is one of several types of on-demand, scalable computing resources that Azure offers. An Azure virtual machine (VM) provides the flexibility of virtualization without the need to buy and maintain physical hardware.  
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network).  Virtual Network is the fundamental building block for your private network on Azure. Virtual Network enables many types of Azure resources, like VMs, to communicate with each other, the internet, and on-premises networks via a highly secure connection. A virtual network is like a traditional network that you might operate in your own datacenter, but it provides the benefits of the Azure infrastructure, like scalability, availability, and isolation.  
- [Azure Application Gateway](https://azure.microsoft.com/services/application-gateway). Application Gateway provides a customizable Layer 7 load-balancing solution.
- [Virtual network interfaces](/azure/virtual-network/virtual-network-network-interface). A network interface enables a VM to communicate with internet, Azure, and on-premises resources. You can add network interface cards to a VM to provide child VMs with their own dedicated network interface device and IP address.  
- [Azure managed disks](/azure/virtual-machines/managed-disks-overview). Azure managed disks are block-level storage volumes that are managed by Azure and used with Azure Virtual Machines. Ultra disks, premium solid-state drives (SSD), standard SSDs, and standard hard disk drives (HDD) are available. For this architecture, we recommend either premium SSDs or ultra disk SSDs.  
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute). You can use ExpressRoute to extend your on-premises networks into the Azure cloud via a private connection that's facilitated by a connectivity provider. By using ExpressRoute, you can establish connections to Microsoft cloud services like Azure and Office 365.

## Scenario details

For decades, Software AG Adabas has been the adaptable database system behind many large mission-critical business applications. Now you can bring the convenience of cloud computing to these applications without giving up your Adabas database, the Natural programming language, or even your green screen, unless you want to.  

Most organizations are pragmatic in their approach to digital transformation. They want to reuse what they can and make cost-effective choices about the rest. That's why the rehost approach to cloud migration is so popular. You simply move your workload as is, if possible, to Azure virtual machines (VMs), a type of infrastructure as a service (IaaS). VMs run in Azure datacenters that are managed by Microsoft, so you benefit from the efficiency, scalability, and performance of a distributed platform without the overhead of hardware management. 

This architecture presents the rehost option. It provides a high-level look at what's possible, whether you keep the green screen or go modern. 

### Potential use cases

This architecture is appropriate for organizations that want to use a *rehost* approach for a cost-effective mainframe migration to Azure that optimizes reuse of legacy systems. 

To gain the full benefits of cloud computing, consider a *[refactor](refactor-adabas-aks.yml)* approach that uses modern techniques like container-based microservices. This type of migration is more complex than a rehost approach, but the payoff is increased flexibility and scalability. 

## Considerations 

The following considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of your workloads. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Cost optimization  

Azure helps you avoid unnecessary costs by identifying the correct number of resources, analyzing spending over time, and scaling to meet business needs without overspending. 

Azure also provides cost optimization by running on VMs. You can turn off the VMs when they're not being used and script a schedule for known usage patterns. For more information about cost optimization for [VM instances](/azure/architecture/framework/cost/optimize-vm), see the [Azure Well-Architected Framework](/azure/architecture/framework). 

The VMs in this architecture use either premium SSDs or ultra disk SSDs. For more information about disk options and pricing, see [Managed Disks pricing](https://azure.microsoft.com/pricing/details/managed-disks). 

### Operational excellence  

In addition to supporting faster cloud adoption, rehosting also promotes the adoption of DevOps and Agile working principles. It provides flexibility in development and production deployment options.

### Performance efficiency  

Load balancers and redundant VMs in a distributed environment provide performance efficiency and resiliency in this architecture. If one presentation or transaction server fails, the other server behind the load balancer handles the workload.  

### Security  

This solution uses an Azure network security group (NSG) to manage traffic between Azure resources in different subnets. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).   

[Azure Bastion](/azure/bastion/bastion-overview) improves security for admin access by minimizing open ports. Azure Bastion provides highly secure RDP or SSH connectivity to virtual network VMs directly from the Azure portal, over TLS. 

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- Marlon Johnson | Senior Program Manager

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Bhaskar Bandam](https://www.linkedin.com/in/bhaskar-bandam-75202a9) | Senior Program Manager

## Next steps  

For more information, contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).  

See these additional resources:

- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [Configure virtual networks](/training/modules/configure-virtual-networks)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is Azure Application Gateway?](/azure/application-gateway/overview)
- [Windows virtual machines in Azure](/azure/virtual-machines/windows/overview)
- [Mainframe rehosting on Azure virtual machines](/azure/virtual-machines/workloads/mainframe-rehosting/overview)

## Related resources

- [Refactor mainframe computer systems that run Adabas & Natural](refactor-adabas-aks.yml)
- [Azure mainframe and midrange architecture concepts and patterns](../../mainframe/mainframe-midrange-architecture.md)
- [Mainframe migration overview](/azure/cloud-adoption-framework/infrastructure/mainframe-migration/?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Move mainframe compute to Azure](/azure/virtual-machines/workloads/mainframe-rehosting/concepts/mainframe-compute-azure?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [General mainframe refactor to Azure](../../example-scenario/mainframe/general-mainframe-refactor.yml)
- [AIX UNIX on-premises to Azure Linux migration](../../example-scenario/unix-migration/migrate-aix-azure-linux.yml)

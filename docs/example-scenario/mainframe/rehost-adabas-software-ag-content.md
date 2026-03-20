For decades, Adabas and Natural from Software AG have powered some of the world’s most demanding, mission-critical business systems. From core banking and insurance platforms to government and retail workloads, these technologies have proven their stability, performance, and longevity in environments where reliability is non-negotiable.
Today, organizations can extend that proven foundation into the cloud—without abandoning the Adabas database or the Natural programming language. By rehosting on Microsoft Azure, you can retain your existing application logic and data structures while gaining the flexibility, scalability, and operational benefits of a modern cloud platform.
This architecture outlines how Adabas and Natural workloads can run in Azure, providing a high-level view of the available options. Whether you choose to preserve the familiar green-screen experience or modernize the user interface with web technologies and APIs, the cloud enables you to evolve at your own pace. The result is a practical path forward: protect your core systems of record, reduce infrastructure constraints, and unlock innovation opportunities—without rewriting what already works.
 

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

Distributed and Resilient Adabas & Natural Architecture on Azure
1. Data Ingress and Client Connectivity
Data is input either through Azure ExpressRoute from remote clients or from other applications running within Azure. TCP/IP provides the primary communication protocol for all system connectivity, and web-based user access is secured over TLS port 443. Existing web application presentation layers can be retained to minimize user retraining or modernized using contemporary UX frameworks. Administrative access to virtual machines is secured through Azure Bastion, eliminating the need to expose RDP or SSH endpoints publicly and reducing the overall attack surface.
2. Application Traffic Routing and Load Balancing
Azure Application Gateway provides Layer 7 load balancing for inbound application traffic. Routing decisions can be made based on HTTP attributes such as URI paths or host headers. Traffic is distributed across multiple Natural availability server instances deployed in the compute tier, ensuring balanced workload distribution and automatic redirection to healthy nodes in the event of instance-level failures.
3. Application and Database Compute Architecture
For smaller dev/test workloads, a single virtual machine can host both Adabas and Natural components, however the recommendation is to keep the application and data tier separate and use at least two separate machines for Natural and Adabas components. Both the components communicate over TCP/IP protocol.
For production environments, it is recommended to separate the application and database tiers onto dedicated virtual machines. SoftwareAG high availability products like Natural Availability Server (HA mode) and Adabas Cluster should be used. A distributed architecture using multiple VMs improves scalability, resilience, and operational flexibility. Virtual machines should be deployed across multiple Azure Availability Zones to eliminate single points of failure at the infrastructure level.
4. Natural Availability Server 
Natural Availability Server is a front-end component that provides a Natural emulator in a modernized Angular-based and REST-enabled web application environment. Natural Availability Server supports Natural sessions on Linux. High Availability functionality is provided at the session level for Linux deployments, enabling scalable and resilient Natural online processing in distributed environments. The Availability Server enables scalable, high-availability Natural applications by externalizing session state to a centralized store such as Redis. This allows multiple server instances or containers to run behind a load balancer, ensuring seamless failover and uninterrupted user sessions.
5. Natural API Server 
The Natural OpenAPI Server enables the exposure of Natural Subprograms as OpenAPI services. The calls being received in REST protocol are being translated to Natural calls via the Subprogram Server. The REST API definition is exposed as an OpenAPI document, that can be used by automatic tools to generate REST calls. 
The calls to REST API can be done by any program written in most of the commonly used Programming language like (Java, C# etc ...)
Deployed across virtual machines and Availability Zones on Microsoft Azure, and managed through Azure Application Gateway, the architecture provides horizontal scaling, fault tolerance, and automatic traffic redirection. It supports Natural Online users, API access via Natural Services, and resilient batch processing within the same highly available environment.
6. Failure Handling and Resilience
In the event of a virtual machine failure, Azure infrastructure services initiate automated recovery processes. If an Availability Zone experiences an outage, Natural application processing continues in the remaining zones and Adabas cluster operations continue using surviving secondary replicas which becomes primary. This distributed architecture minimizes downtime during both planned maintenance and unexpected failures.
7. Adabas 
Adabas is a high-performance database management system developed by Software AG. It was originally built in the 1970s and has been widely used in large-scale enterprise and mainframe environments ever since. Unlike traditional relational databases (like Oracle or PostgreSQL), Adabas uses an inverted list data model, which makes it exceptionally fast at handling large volumes of transactional data — particularly in industries where performance and reliability are non-negotiable.
Adabas serves as the core transactional database platform for both online and batch workloads. When combined with clustering and distributed deployment, the database layer delivers enhanced scalability, consistency, and fault tolerance. Storage configurations should support high durability and zone redundancy to align with the overall high-availability architecture.


8. Monitoring and Observability
Adabas Manager provides browser-based administration and monitoring of Adabas databases on Linux and Windows platforms. It can be used to administer Adabas databases on remote host machines, in addition to Adabas databases on the local machine. Common administration tasks include listing databases and files, starting/stopping and creating databases, viewing and modifying database parameters, managing database containers, and viewing information about high water marks and buffer pools. Adabas Manager can also be used to monitor database health. Database health is based on the twin concepts of pre-defined monitor criteria (e.g. database uptime, space usage, buffer pool hit rate) and so-called monitoring groups

### Components  

- [Azure Virtual Machines (VMs)](/azure/well-architected/service-guides/virtual-machines). Virtual Machines is one of several types of on-demand, scalable computing resources that Azure offers. An Azure virtual machine (VM) provides the flexibility of virtualization without the need to buy and maintain physical hardware.  
- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network).  Virtual Network is the fundamental building block for your private network on Azure. Virtual Network enables many types of Azure resources, like VMs, to communicate with each other, the internet, and on-premises networks via a highly secure connection. A virtual network is like a traditional network that you might operate in your own datacenter, but it provides the benefits of the Azure infrastructure, like scalability, availability, and isolation.  
- [Azure Application Gateway](/azure/well-architected/service-guides/azure-application-gateway). Application Gateway provides a customizable Layer 7 load-balancing solution.
- [Virtual network interfaces](/azure/virtual-network/virtual-network-network-interface). A network interface enables a VM to communicate with internet, Azure, and on-premises resources. You can add network interface cards to a VM to provide child VMs with their own dedicated network interface device and IP address.  
- [Azure Managed Disks](/azure/virtual-machines/managed-disks-overview). Azure Managed Disks are block-level storage volumes that Azure manages on its VMs. Ultra Disks, Premium SSDs, Standard SSDs, and Standard HDDs are available. For this architecture, we recommend either Premium SSDs or Ultra Disks.  
- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute). You can use ExpressRoute to extend your on-premises networks into the Azure cloud via a private connection that's facilitated by a connectivity provider. By using ExpressRoute, you can establish connections to Microsoft cloud services like Azure and Microsoft 365.

## Scenario details

For decades, Software AG Adabas has been the adaptable database system behind many large mission-critical business applications. Now you can bring the convenience of cloud computing to these applications without giving up your Adabas database, the Natural programming language, or even your green screen, unless you want to.  

Most organizations are pragmatic in their approach to digital transformation. They want to reuse what they can and make cost-effective choices about the rest. That's why the rehost approach to cloud migration is so popular. You move your workload as is, if possible, to Azure virtual machines (VMs). These machines are a type of infrastructure as a service (IaaS). VMs run in Azure datacenters that Microsoft manages, so you benefit from the efficiency, scalability, and performance of a distributed platform without the overhead of hardware management.

This architecture presents the rehost option. It provides a high-level overview of what's possible, whether you keep the green screen or go modern. 

### Potential use cases

This architecture is appropriate for organizations that want to use a *rehost* approach for a cost-effective mainframe migration to Azure that optimizes reuse of legacy systems. 

To gain the full benefits of cloud computing, consider a *[refactor](refactor-adabas-aks.yml)* approach that uses modern techniques like container-based microservices. This type of migration is more complex than a rehost approach, but the payoff is increased flexibility and scalability. 

## Considerations 

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This solution uses an Azure network security group (NSG) to manage traffic between Azure resources in different subnets. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).   

[Azure Bastion](/azure/bastion/bastion-overview) improves security for admin access by minimizing open ports. Azure Bastion provides highly secure RDP or SSH connectivity to virtual network VMs directly from the Azure portal, over TLS.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Azure helps you avoid unnecessary costs by identifying the correct number of resources, analyzing spending over time, and scaling to meet business needs without overspending. 

Azure also provides cost optimization by running on VMs. You can turn off the VMs when they're not being used and script a schedule for known usage patterns. For more information about cost optimization for [VM instances](/azure/architecture/framework/cost/optimize-vm), see [Azure Well-Architected Framework](/azure/well-architected/). 

The VMs in this architecture use either Premium SSDs or Ultra Disks. For more information about disk options and pricing, see [Managed Disks pricing](https://azure.microsoft.com/pricing/details/managed-disks). 

### Operational Excellence  

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

In addition to supporting faster cloud adoption, rehosting also promotes the adoption of DevOps and Agile working principles. It provides flexibility in development and production deployment options.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Load balancers and redundant VMs in a distributed environment provide performance efficiency and resiliency in this architecture. If one presentation or transaction server fails, the other server behind the load balancer handles the workload.  

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- Bhaskar Bandam | Principal Program Manager

Other contributors:

- [Bhaskar Bandam](https://www.linkedin.com/in/bhaskar-bandam-75202a9) | Principal Program Manager

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
- [Mainframe migration overview](/azure/cloud-adoption-framework/infrastructure/mainframe-migration/?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Move mainframe compute to Azure](/azure/virtual-machines/workloads/mainframe-rehosting/concepts/mainframe-compute-azure?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [General mainframe refactor to Azure](../../example-scenario/mainframe/general-mainframe-refactor.yml)
- [AIX UNIX on-premises to Azure Linux migration](../../example-scenario/unix-migration/migrate-aix-azure-linux.yml)

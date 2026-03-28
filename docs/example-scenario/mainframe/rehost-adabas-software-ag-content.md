Adabas and Natural from Software AG power mission-critical business systems in banking, insurance, government, and retail. These technologies provide stability, performance, and reliability in demanding production environments.

You can now run these same workloads in the cloud without abandoning the Adabas database or the Natural programming language. When you rehost on Azure, you can retain your existing application logic and data structures and gain the flexibility, scalability, and operational benefits of a modern cloud platform.

This architecture describes how to run Adabas and Natural workloads in Azure. You can preserve the familiar terminal interface experience or modernize the UI by using web technologies and APIs. You can evolve at your own pace. This approach protects your core systems, reduces infrastructure constraints, and creates innovation opportunities without rewriting your existing systems.

## Mainframe architecture 

This architecture shows a legacy Adabas and Natural architecture before you rehost it to the cloud.

:::image type="complex" border="false" source="media/mainframe-software-ag-rehost-before.svg" alt-text="Diagram that shows the legacy mainframe architecture before migration." lightbox="media/mainframe-software-ag-rehost-before.svg":::
Diagram that shows an on‑premises general mainframe environment. On the left, administrators use an emulator and web users access the system through a browser over Transport Layer Security (TLS). Inside the mainframe, communications services handle protocols such as LU 6.2, TN3270, File Transfer Protocol (FTP), sockets, and Unisys Terminal Services (UTS). Integration middleware provides web services, transaction management, queuing, and environment integration, along with supporting services such as tape storage and monitoring. Transaction processing includes batch jobs, a transaction monitoring facility, and applications written in languages such as COBOL, PL/I, Assembler, and 4GL. Common services provide execution, input/output (I/O), error detection, and protection. Data is stored in multiple formats, including hierarchical or network databases, flat or indexed data files, relational databases, and systems such as Adabas. The environment runs on operating system partitions.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-software-ag-rehost-before.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

A. Users input data over TCP/IP, including TN3270, HTTP, and HTTPS. Data enters the mainframe via standard mainframe protocols. 

B. Batch or online applications receive the data.

C. Natural, COBOL, PL/I, Assembler, or compatible languages run in the environment. 

D. Database services, commonly hierarchical systems, network database systems, and relational databases, store data.

E. Common services, like program execution, input/output (I/O) operations, error detection, and protection within the environment, provide support. 

F. Middleware and utility services manage functions, like tape storage, queueing, output, and web services, within the environment. 

G. Operating systems run on partitions. 

H. Partitions run separate workloads or segregate work types within the environment. 

## Azure architecture

The following diagram shows the legacy architecture after you migrate to Azure. This solution uses a rehost approach to migrate the system.

:::image type="complex" border="false" source="media/mainframe-software-ag-azure-rehost-after.svg" alt-text="Diagram that shows the mainframe architecture rehosted on Azure." lightbox="media/mainframe-software-ag-azure-rehost-after.svg":::
Diagram that shows an on‑premises to Azure architecture that uses Azure ExpressRoute. On‑premises users connect to Azure through web browsing or bastion access over Transport Layer Security (TLS). In Azure, traffic enters a virtual network through Azure Application Gateway and routes to virtual machines (VMs) that run Software AG components. One subnet hosts application services, including a Natural Availability Server, Natural Application Server, Natural services, and supporting components such as Cache Redis, Azure NetApp Files, and Accelerated Networking. A network security group (NSG) protects these components. A separate subnet hosts data services, including primary and secondary Adabas databases, Adabas Manager, and Natural batch processing, with encrypted disks and managed storage. The architecture also shows connectivity to external devices or APIs, with NSGs applied to protect Azure resources.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-software-ag-azure-rehost-after.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. **Data ingress and client connectivity:** Users input data either through Azure ExpressRoute from remote clients or from other applications that run in Azure. TCP/IP is the primary communication protocol for all system connectivity. Web-based user access is secured over TLS port 443.

   You can keep existing web application presentation layers to avoid retraining users, or you can modernize by using current web frameworks. Azure Bastion secures administrative access to VMs, which eliminates the need to expose Remote Desktop Protocol (RDP) or Secure Shell (SSH) endpoints publicly and reduces the overall attack surface.

1. **Application traffic routing and load balancing:** Azure Application Gateway provides layer-7 load balancing for incoming application traffic. It routes requests based on HTTP attributes like Uniform Resource Identifier (URI) paths or host headers. Traffic is distributed across multiple Natural availability server instances in the compute tier. This distribution balances the workload and automatically redirects traffic to healthy nodes when an instance fails.

1. **Application and database compute architecture:** For smaller dev/test workloads, a single VM can host both Adabas and Natural components. However, we recommend that you separate the application and data tiers by using at least two separate VMs for Natural and Adabas components. Both components communicate over the TCP/IP protocol. For production environments, separate the application and database tiers onto dedicated VMs.

   Use Software AG high availability (HA) products like Natural Availability Server in HA mode and Adabas Cluster. A distributed architecture that uses multiple VMs improves scalability, resilience, and operational flexibility. Deploy VMs across multiple Azure availability zones to eliminate single points of failure at the infrastructure level.

1. **Natural Availability Server:** This front-end component provides a Natural emulator in a modernized Angular-based and REST-enabled web application environment. It supports Natural sessions on Linux and provides HA functionality at the session level. This configuration provides scalable and resilient Natural online processing in distributed environments. The server externalizes session state to a centralized store like Redis so that multiple server instances or containers can run behind a load balancer. This approach ensures seamless failover and uninterrupted user sessions.

1. **Natural API Server:** This component exposes Natural subprograms as OpenAPI services. The Subprogram Server translates incoming REST protocol calls to Natural calls. The REST API definition is exposed as an OpenAPI document that automated tools can use to generate REST calls. Any program written in common programming languages like Java or C# can call the REST API.

   When deployed across VMs and Azure availability zones and managed through Application Gateway, the architecture provides horizontal scaling, fault tolerance, and automatic traffic redirection. It supports Natural Online users, API access via Natural services, and resilient batch processing within the same highly available environment.

1. **Failure handling and resilience:** When a VM fails, Azure infrastructure services automatically initiate recovery processes. If an availability zone experiences an outage, Natural application processing continues in the remaining zones. Adabas cluster operations continue by promoting a surviving secondary replica to primary. This distributed architecture minimizes downtime during planned maintenance and unexpected failures.

1. **Adabas:** Unlike traditional relational databases like Oracle or PostgreSQL, Adabas uses an inverted list data model. This model provides fast performance for large volumes of transactional data in industries that require high performance and reliability.

   Adabas serves as the core transactional database platform for both online and batch workloads. When combined with clustering and distributed deployment, the database layer delivers enhanced scalability, consistency, and fault tolerance. Storage configurations should support high durability and zone redundancy to align with the overall HA architecture.

1. **Monitoring and observability:** Adabas Manager provides browser-based administration and monitoring for Adabas databases on Linux and Windows. You can use it to manage databases on both local and remote host machines. Common administration tasks include listing databases and files, starting and stopping databases, creating databases, modifying database parameters, managing database containers, and viewing high water marks and buffer pool information. You can also use Adabas Manager to monitor database health based on monitoring groups and predefined criteria, like database uptime, space usage, and buffer pool hit rate.

### Components  

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is an on-demand, scalable computing resource. An Azure virtual machine (VM) provides the flexibility of virtualization without the need to buy and maintain physical hardware. In this architecture, VMs host the Adabas and Natural components, which provides the compute infrastructure for both application and database tiers.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the fundamental building block for your private network on Azure. Virtual Network enables many types of Azure resources, like VMs, to communicate with each other, the internet, and on-premises networks via a highly secure connection. In this architecture, Virtual Network provides network isolation and segmentation for the rehosted mainframe workloads.

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a web traffic load balancer that provides layer-7 load-balancing capabilities. In this architecture, Application Gateway distributes incoming application traffic across multiple Natural availability server instances and provides automatic redirection to healthy nodes.

- [Virtual network interfaces](/azure/virtual-network/virtual-network-network-interface) enable a VM to communicate with internet, Azure, and on-premises resources. You can add network interface cards (NICs) to a VM to provide child VMs with their own dedicated network interface device and IP address. In this architecture, network interfaces provide connectivity for VMs that run Adabas and Natural components.

- [Azure managed disks](/azure/virtual-machines/managed-disks-overview) are block-level storage volumes that Azure manages on Azure VMs. In this architecture, Premium SSDs or Ultra Disks provide high-performance storage for Adabas databases and Natural applications.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) extends your on-premises networks into the Azure cloud via a private connection that a connectivity provider facilitates. Use ExpressRoute to establish connections to Microsoft cloud services like Azure and Microsoft 365. In this architecture, ExpressRoute provides secure, private connectivity between on-premises users and the rehosted mainframe workloads in Azure.

## Scenario details

Most organizations take a pragmatic approach to digital transformation. They reuse existing systems where possible and make cost-effective decisions about modernization. The rehost approach to cloud migration addresses this need. You can move your workload to Azure VMs with minimal changes. VMs run in Azure datacenters that Microsoft manages, so you benefit from cloud efficiency, scalability, and performance without managing physical hardware.

This architecture presents the rehost option and shows what you can achieve with your existing systems. 

### Potential use cases

This architecture supports organizations that want to use a *rehost approach* for a cost-effective mainframe migration to Azure that optimizes reuse of legacy systems. 

To gain the full benefits of cloud computing, consider a *[refactor approach](refactor-adabas-aks.yml)* that uses modern techniques like container-based microservices. This type of migration is more complex than a rehost approach but provides increased flexibility and scalability. 

## Considerations 

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This solution uses an Azure network security group (NSG) to manage traffic between Azure resources in different subnets. For more information, see [NSGs](/azure/virtual-network/network-security-groups-overview).   

[Azure Bastion](/azure/bastion/bastion-overview) improves security for admin access by minimizing open ports. Azure Bastion provides highly secure RDP or SSH connectivity to virtual network VMs directly from the Azure portal over TLS.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Azure helps you avoid unnecessary costs by identifying the correct number of resources, analyzing spending over time, and scaling to meet business needs without overspending. 

Azure also provides cost optimization by running on VMs. You can turn off the VMs when you don't use them and script a schedule for known usage patterns. For more information about cost optimization for [VM instances](/azure/architecture/framework/cost/optimize-vm), see [Azure Well-Architected Framework](/azure/well-architected/). 

The VMs in this architecture use either Premium SSDs or Ultra Disks. For more information about disk options and pricing, see [Managed disks pricing](https://azure.microsoft.com/pricing/details/managed-disks). 

### Operational Excellence  

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

In addition to supporting faster cloud adoption, rehosting also promotes the adoption of DevOps and Agile working principles. It provides flexibility in development and production deployment options.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Load balancers and redundant VMs in a distributed environment provide performance efficiency and resiliency in this architecture. If one presentation or transaction server fails, the other server behind the load balancer handles the workload.  

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Bhaskar Bandam](https://www.linkedin.com/in/bhaskar-bandam-75202a9) | Principal Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps  

For more information, contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).  

- [What is Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [Configure virtual networks](/training/modules/configure-virtual-networks)
- [What is ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is Application Gateway?](/azure/application-gateway/overview)
- [VMs in Azure](/azure/virtual-machines/overview)
- [Plan your migration](/azure/cloud-adoption-framework/migrate/plan-migration)

## Related resources

- [Refactor mainframe computer systems that run Adabas and Natural](refactor-adabas-aks.yml)
- [General mainframe refactor to Azure](general-mainframe-refactor.yml)
- [AIX UNIX on-premises to Azure Linux migration](../../example-scenario/unix-migration/migrate-aix-azure-linux.yml)
